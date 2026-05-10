"""Tests for first vertical-slice implementation."""

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

from fastapi.testclient import TestClient

from ml_deploy.vertical_slice import (
    create_prediction_app,
    execute_first_vertical_slice,
)


class TestVerticalSlice(unittest.TestCase):
    def test_execute_vertical_slice_produces_traceability_records(self) -> None:
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = Path(tmp_dir)
            tracking_uri = f"file://{(root / 'mlruns').resolve()}"
            result = execute_first_vertical_slice(root, tracking_uri=tracking_uri)

            artifact_metadata = result["packaged"]["artifact_metadata"]
            model_version = result["packaged"]["model_version_record"]
            deployment = result["deployment"]["deployment_record"]

            self.assertTrue(result["packaged"]["model_path"].exists())
            self.assertTrue(result["packaged"]["scaler_path"].exists())
            self.assertTrue(result["packaged"]["artifact_metadata_path"].exists())
            self.assertTrue(result["packaged"]["model_version_path"].exists())
            self.assertTrue(result["deployment"]["deployment_record_path"].exists())

            self.assertIn("originating_training_run_identifier", artifact_metadata)
            self.assertIn("dataset_version", artifact_metadata)
            self.assertIn("transformation_version", artifact_metadata)
            self.assertIn("expected_input_schema_version", artifact_metadata)
            self.assertIn("evaluation_summary", artifact_metadata)
            self.assertIn("model_version_identifier", model_version)
            self.assertEqual(
                deployment["deployed_model_version"], model_version["model_version_identifier"]
            )

            self.assertGreater(result["training_outcome"].accuracy, 0.5)
            self.assertTrue(result["training_outcome"].mlflow_run_id)

    def test_prediction_endpoint_logs_model_and_deployment_linkage(self) -> None:
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = Path(tmp_dir)
            tracking_uri = f"file://{(root / 'mlruns').resolve()}"
            result = execute_first_vertical_slice(root, tracking_uri=tracking_uri)
            app = create_prediction_app(
                result["packaged"]["bundle_dir"],
                result["deployment"]["deployment_record_path"],
                result["prediction_log_path"],
            )

            client = TestClient(app)
            response = client.post(
                "/predict",
                json={"request_id": "req-test-001", "features": result["sample_features"]},
            )
            self.assertEqual(response.status_code, 200)
            payload = response.json()
            self.assertEqual(payload["request_id"], "req-test-001")

            logs = result["prediction_log_path"].read_text().strip().splitlines()
            self.assertEqual(len(logs), 1)
            entry = json.loads(logs[0])
            self.assertEqual(entry["request_identifier"], "req-test-001")
            self.assertEqual(
                entry["model_version_used"],
                result["packaged"]["model_version_record"]["model_version_identifier"],
            )
            self.assertEqual(
                entry["deployment_identifier"],
                result["deployment"]["deployment_record"]["deployment_identifier"],
            )
            self.assertIn("latency_ms", entry["runtime_metadata"])


if __name__ == "__main__":
    unittest.main()
