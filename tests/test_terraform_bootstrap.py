"""Tests for python-driven Terraform bootstrap helpers."""

from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest

from ml_deploy.terraform_bootstrap import (
    TerraformStackConfig,
    build_tfvars,
    write_stack_files,
)


class TestTerraformBootstrap(unittest.TestCase):
    def test_build_tfvars(self) -> None:
        config = TerraformStackConfig(stack_name="stack-a", aws_region="eu-west-1")
        tfvars = build_tfvars(config)
        self.assertEqual(tfvars["stack_name"], "stack-a")
        self.assertEqual(tfvars["aws_region"], "eu-west-1")

    def test_write_stack_files(self) -> None:
        with tempfile.TemporaryDirectory() as tmp_dir:
            config = TerraformStackConfig()
            paths = write_stack_files(Path(tmp_dir), config)
            self.assertTrue(paths["main_tf_json"].exists())
            self.assertTrue(paths["terraform_tfvars_json"].exists())
            main_payload = json.loads(paths["main_tf_json"].read_text(encoding="utf-8"))
            self.assertIn("resource", main_payload)
            self.assertIn("aws_s3_bucket", main_payload["resource"])


if __name__ == "__main__":
    unittest.main()
