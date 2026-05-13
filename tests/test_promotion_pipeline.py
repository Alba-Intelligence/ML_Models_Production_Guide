"""Tests for model promotion pipeline gates."""

from __future__ import annotations

from pathlib import Path
import tempfile
import unittest

from ml_deploy.vertical_slice import execute_first_vertical_slice, promote_model_artifact


class TestPromotionPipeline(unittest.TestCase):
    def _fresh_artifact(self) -> dict:
        with tempfile.TemporaryDirectory() as tmp_dir:
            root = Path(tmp_dir)
            result = execute_first_vertical_slice(root, tracking_uri=f"file://{(root / 'mlruns').resolve()}")
            return result["packaged"]["model_version_record"]

    def test_promote_to_uat_requires_smoke_tests(self) -> None:
        artifact = self._fresh_artifact()
        with self.assertRaises(ValueError):
            promote_model_artifact(dict(artifact), "uat")

        artifact["passes_smoke_tests"] = True
        promoted = promote_model_artifact(dict(artifact), "uat")
        self.assertEqual(promoted["stage"], "uat")

    def test_promote_to_regression_requires_gate_checks(self) -> None:
        artifact = self._fresh_artifact()
        artifact.update(
            {
                "passes_uat_suite": True,
                "no_data_leakage_detected": True,
                "meets_minimum_metrics": True,
            }
        )
        promoted = promote_model_artifact(dict(artifact), "regression")
        self.assertEqual(promoted["stage"], "regression")

    def test_promote_to_prod_requires_approval_and_quality(self) -> None:
        artifact = self._fresh_artifact()
        artifact.update(
            {
                "promotion_approved": True,
                "passes_regression_suite": True,
                "no_performance_regression": True,
                "security_scan_passed": True,
                "pytorch_compile_applied": True,
                "pytorch_no_grad_applied": True,
                "pytorch_mixed_precision_applied": True,
                "pytorch_channels_last_applied": True,
                "pytorch_memory_fraction_limited": True,
            }
        )
        promoted = promote_model_artifact(dict(artifact), "prod")
        self.assertEqual(promoted["stage"], "prod")


if __name__ == "__main__":
    unittest.main()
