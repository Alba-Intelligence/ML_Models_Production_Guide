"""Tests for MLflow parity helpers."""

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

from ml_deploy.mlflow_parity import (
    LocalMlflowParityConfig,
    build_mlflow_runtime_env,
    build_mlflow_server_command,
    render_local_compose_config,
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


if __name__ == "__main__":
    unittest.main()
