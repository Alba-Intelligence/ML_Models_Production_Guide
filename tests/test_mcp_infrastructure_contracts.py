"""Spec-propagated tests for infrastructure MCP interrogation requirements."""

from __future__ import annotations

from pathlib import Path
import unittest


class TestInfrastructureMcpSpecContracts(unittest.TestCase):
    """Checks that infrastructure MCP requirements are encoded in the Allium spec."""

    @classmethod
    def setUpClass(cls) -> None:
        cls.repo_root = Path(__file__).resolve().parents[1]
        cls.spec_path = cls.repo_root / "specs" / "ml-deploy-reference-repo.allium"
        cls.spec_text = cls.spec_path.read_text(encoding="utf-8")

    def test_default_mcp_scope_includes_infrastructure_visibility(self) -> None:
        self.assertIn("infrastructure_visibility", self.spec_text)
        self.assertIn(
            "default_mcp_scope: Set<McpSurface> = {mlflow, observability, aws_cost_visibility, lambda_ai_usage_visibility, infrastructure_visibility, docs_and_decisions}",
            self.spec_text,
        )

    def test_enum_for_infrastructure_interrogation_aspects_is_declared(self) -> None:
        self.assertIn(
            "enum InfrastructureInterrogationAspect { iac_plans_and_state | kubernetes_runtime_state | lambda_ai_slurm_runtime_state | cloud_resource_inventory | cost_and_usage_signals }",
            self.spec_text,
        )

    def test_minimum_infrastructure_interrogation_aspects_are_configured(self) -> None:
        self.assertIn(
            "required_infrastructure_interrogation_aspects: Set<InfrastructureInterrogationAspect> = {iac_plans_and_state, kubernetes_runtime_state, lambda_ai_slurm_runtime_state, cloud_resource_inventory, cost_and_usage_signals}",
            self.spec_text,
        )

    def test_repository_tracks_required_and_realized_interrogation_aspects(self) -> None:
        self.assertIn(
            "required_infrastructure_interrogation_aspects: Set<InfrastructureInterrogationAspect>",
            self.spec_text,
        )
        self.assertIn(
            "infrastructure_interrogation_aspects: Set<InfrastructureInterrogationAspect>",
            self.spec_text,
        )

    def test_infrastructure_mcp_rule_has_success_and_failure_guards(self) -> None:
        self.assertIn("rule RequireInfrastructureMcpInterrogationWhenAvailable", self.spec_text)
        self.assertIn("requires: repository.requires_infrastructure_mcp_if_available", self.spec_text)
        self.assertIn("requires: mcp_servers_available", self.spec_text)
        self.assertIn(
            "ensures: repository.infrastructure_interrogation_aspects = repository.required_infrastructure_interrogation_aspects",
            self.spec_text,
        )


if __name__ == "__main__":
    unittest.main()
