"""Tests for MLflow parity helpers."""

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

from ml_deploy.mlflow_parity import (
    LocalMlflowParityConfig,
    build_mlflow_runtime_env_from_storage,
    build_mlflow_runtime_env,
    build_mlflow_server_command,
    render_local_compose_config,
    resolve_mlflow_storage_config,
    write_local_compose_file,
)


class TestMlflowParity(unittest.TestCase):
    def test_render_compose_contains_required_services(self) -> None:
        config = LocalMlflowParityConfig()
        compose = render_local_compose_config(config)
        self.assertIn("postgres", compose["services"])
        self.assertIn("minio", compose["services"])
        self.assertIn("mlflow", compose["services"])

    def test_command_and_env_match_postgres_s3_posture(self) -> None:
        config = LocalMlflowParityConfig()
        command = build_mlflow_server_command(config)
        env = build_mlflow_runtime_env(config)
        self.assertIn(config.backend_store_uri, command)
        self.assertIn(config.artifacts_destination, command)
        self.assertEqual(env["MLFLOW_S3_ENDPOINT_URL"], config.minio_endpoint)

    def test_write_local_compose_file(self) -> None:
        config = LocalMlflowParityConfig()
        with tempfile.TemporaryDirectory() as tmp_dir:
            path = Path(tmp_dir) / "compose.json"
            write_local_compose_file(path, config)
            payload = json.loads(path.read_text(encoding="utf-8"))
            self.assertEqual(payload["name"], config.compose_project_name)

    def test_resolve_storage_config_defaults_to_postgres_and_s3(self) -> None:
        config = resolve_mlflow_storage_config({})
        self.assertTrue(config.backend_store_uri.startswith("postgresql://"))
        self.assertTrue(config.artifacts_destination.startswith("s3://"))
        self.assertEqual(config.tracking_uri, "http://localhost:5000")

    def test_build_runtime_env_from_storage(self) -> None:
        config = resolve_mlflow_storage_config(
            {
                "MLFLOW_BACKEND_STORE_URI": "postgresql://u:p@db:5432/mlflow",
                "MLFLOW_ARTIFACTS_DESTINATION": "s3://mlflow-prod",
                "MLFLOW_TRACKING_URI": "https://mlflow.internal",
                "AWS_ACCESS_KEY_ID": "key",
                "AWS_SECRET_ACCESS_KEY": "secret",
                "MLFLOW_S3_ENDPOINT_URL": "https://s3.internal",
            }
        )
        env = build_mlflow_runtime_env_from_storage(config)
        self.assertEqual(env["MLFLOW_BACKEND_STORE_URI"], "postgresql://u:p@db:5432/mlflow")
        self.assertEqual(env["MLFLOW_ARTIFACTS_DESTINATION"], "s3://mlflow-prod")
        self.assertEqual(env["MLFLOW_S3_ENDPOINT_URL"], "https://s3.internal")


if __name__ == "__main__":
    unittest.main()
