"""Tests for execution adapters and backend mapping."""

from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from ml_deploy.execution_backends import (
    ExecutionOrchestrator,
    LocalExecutionAdapter,
    map_to_kubernetes_job_spec,
    map_to_slurm_job_spec,
)
from ml_deploy.webui_contracts import NotebookExecutionRequest, NotebookRevision


def _fake_runner(work_dir: Path, *, tracking_uri: str) -> dict:
    _ = tracking_uri
    output_dir = work_dir / "vertical_slice"
    output_dir.mkdir(parents=True, exist_ok=True)
    prediction_path = output_dir / "prediction_logs.jsonl"
    prediction_path.write_text("", encoding="utf-8")

    class _TrainingOutcome:
        mlflow_run_id = "run-abc123"

    return {
        "output_dir": output_dir,
        "prediction_log_path": prediction_path,
        "training_outcome": _TrainingOutcome(),
        "packaged": {"model_version_record": {"model_version_identifier": "model-v1"}},
    }


class TestExecutionBackends(unittest.TestCase):
    def _request(self) -> NotebookExecutionRequest:
        return NotebookExecutionRequest(
            notebook=NotebookRevision(
                repository="git@github.com:org/repo.git",
                notebook_path="nbs/train.ipynb",
                revision="a1b2c3d4e5",
                revision_kind="commit",
            ),
            target="local-replica",
            requested_by="engineer@example.com",
            config_profile="dev-local",
            parameters={"epochs": 5},
        )

    def test_local_execution_adapter_returns_run_visibility(self) -> None:
        adapter = LocalExecutionAdapter("http://localhost:5000", runner=_fake_runner)
        with tempfile.TemporaryDirectory() as tmp_dir:
            result = adapter.submit(
                self._request(),
                work_dir=Path(tmp_dir),
                tracking_uri="http://localhost:5000",
                request_id="req-test-01",
            )
            self.assertEqual(result.request_id, "req-test-01")
            self.assertEqual(result.run_visibility.run_id, "run-abc123")
            self.assertIn("/#/experiments/0/runs/run-abc123", result.run_visibility.mlflow_run_url)

    def test_slurm_and_k8s_mappings(self) -> None:
        spec = self._request().with_defaults(request_id="req-map-01").as_job_spec()
        slurm_payload = map_to_slurm_job_spec(spec)
        k8s_payload = map_to_kubernetes_job_spec(spec)
        self.assertEqual(slurm_payload["scheduler"], "slurm")
        self.assertIn("Job", k8s_payload["kind"])
        self.assertEqual(k8s_payload["metadata"]["name"], "nb-req-map-01")

    def test_orchestrator_routes_targets(self) -> None:
        orchestrator = ExecutionOrchestrator(
            "http://localhost:5000",
            local_adapter=LocalExecutionAdapter("http://localhost:5000", runner=_fake_runner),
        )
        with tempfile.TemporaryDirectory() as tmp_dir:
            work_dir = Path(tmp_dir)
            local = orchestrator.submit(
                self._request(),
                work_dir=work_dir,
                tracking_uri="http://localhost:5000",
                request_id="req-local-01",
            )
            self.assertEqual(local.backend, "local")
            self.assertEqual(local.status, "completed")
            self.assertIsNotNone(local.run_visibility)

            slurm = orchestrator.submit(
                NotebookExecutionRequest(
                    notebook=self._request().notebook,
                    target="lambda-slurm",
                    requested_by="engineer@example.com",
                ),
                work_dir=work_dir,
                request_id="req-slurm-01",
            )
            self.assertEqual(slurm.backend, "slurm")
            self.assertEqual(slurm.status, "submitted")
            self.assertEqual(slurm.submission_payload["scheduler"], "slurm")


if __name__ == "__main__":
    unittest.main()
