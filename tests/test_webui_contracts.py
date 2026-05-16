"""Tests for Web UI execution and run-visibility contracts."""

from __future__ import annotations

import unittest

from ml_deploy.webui_contracts import (
    NotebookExecutionRequest,
    NotebookRevision,
    build_mlflow_run_url,
    summarize_run_for_webui,
)


class TestWebUIContracts(unittest.TestCase):
    def test_build_mlflow_run_url_normalizes_slashes(self) -> None:
        url = build_mlflow_run_url("https://mlflow.example.com///", "abc123")
        self.assertEqual(url, "https://mlflow.example.com/#/experiments/0/runs/abc123")

    def test_request_job_spec_requires_immutable_notebook_ref(self) -> None:
        request = NotebookExecutionRequest(
            notebook=NotebookRevision(
                repository="git@github.com:org/repo.git",
                notebook_path="nbs/train.ipynb",
                revision="a1b2c3d4e5",
                revision_kind="commit",
            ),
            target="local-replica",
            requested_by="engineer@example.com",
            config_profile="dev-local",
            parameters={"learning_rate": 0.01, "access_token": "fake-token"},
        ).with_defaults(request_id="req-001")

        spec = request.as_job_spec()
        self.assertEqual(spec["request_id"], "req-001")
        self.assertEqual(spec["notebook"]["revision_kind"], "commit")
        self.assertEqual(spec["notebook"]["revision"], "a1b2c3d4e5")

    def test_authorize_execution_request(self) -> None:
        request = NotebookExecutionRequest(
            notebook=NotebookRevision(
                repository="git@github.com:org/repo.git",
                notebook_path="nbs/train.ipynb",
                revision="a1b2c3d4e5",
                revision_kind="commit",
            ),
            target="local-replica",
            requested_by="engineer@example.com",
            config_profile="dev-local",
            parameters={"access_token": "fake-token"},
        ).with_defaults(request_id="req-002")
        self.assertTrue(request.authorize())
        # Should fail for invalid token
        request_bad = NotebookExecutionRequest(
            notebook=request.notebook,
            target="local-replica",
            requested_by="engineer@example.com",
            config_profile="dev-local",
            parameters={"access_token": "bad-token"},
        ).with_defaults(request_id="req-003")
        with self.assertRaises(Exception):
            request_bad.authorize()

    def test_commit_revision_validation_rejects_non_sha(self) -> None:
        with self.assertRaises(ValueError):
            NotebookExecutionRequest(
                notebook=NotebookRevision(
                    repository="git@github.com:org/repo.git",
                    notebook_path="nbs/train.ipynb",
                    revision="working-copy",
                    revision_kind="commit",
                ),
                target="aws-kubernetes",
                requested_by="engineer@example.com",
            ).with_defaults(request_id="req-002").as_job_spec()

    def test_run_summary_includes_mlflow_link(self) -> None:
        summary = summarize_run_for_webui(
            {
                "run_id": "run-123",
                "status": "running",
                "started_at": "2026-05-10T12:00:00Z",
                "model_version": "model-v3",
            },
            mlflow_base_url="https://mlflow.example.com/",
        )
        self.assertEqual(summary.run_id, "run-123")
        self.assertEqual(summary.status, "running")
        self.assertEqual(
            summary.mlflow_run_url,
            "https://mlflow.example.com/#/experiments/0/runs/run-123",
        )


if __name__ == "__main__":
    unittest.main()
