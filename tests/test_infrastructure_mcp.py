"""Tests for infrastructure MCP interrogation helpers."""

from __future__ import annotations

import unittest

from ml_deploy.infrastructure_mcp import (
    InfrastructureMcpInventory,
    assess_infrastructure_mcp_availability,
    build_infrastructure_mcp_interrogation_profile,
    parse_infrastructure_mcp_inventory,
)


class TestInfrastructureMcpInterrogation(unittest.TestCase):
    def test_parse_inventory_normalizes_and_filters_blank_entries(self) -> None:
        self.assertEqual(
            parse_infrastructure_mcp_inventory(
                "iac_plans_and_state, kubernetes_runtime_state, , cloud_resource_inventory"
            ),
            (
                "iac_plans_and_state",
                "kubernetes_runtime_state",
                "cloud_resource_inventory",
            ),
        )

    def test_inventory_from_env_and_availability_assessment(self) -> None:
        inventory = InfrastructureMcpInventory(
            (
                "iac_plans_and_state",
                "cost_and_usage_signals",
            )
        )
        self.assertTrue(assess_infrastructure_mcp_availability(inventory))
        self.assertTrue(inventory.is_available())

    def test_build_profile_exposes_required_aspects_when_available(self) -> None:
        inventory = InfrastructureMcpInventory(
            (
                "iac_plans_and_state",
                "kubernetes_runtime_state",
                "lambda_ai_slurm_runtime_state",
            )
        )
        profile = build_infrastructure_mcp_interrogation_profile(inventory)
        self.assertTrue(profile.mcp_servers_available)
        self.assertEqual(
            profile.default_mcp_scope,
            frozenset(
                {
                    "mlflow",
                    "observability",
                    "aws_cost_visibility",
                    "lambda_ai_usage_visibility",
                    "infrastructure_visibility",
                    "docs_and_decisions",
                }
            ),
        )
        self.assertEqual(
            profile.infrastructure_interrogation_aspects,
            frozenset(
                {
                    "iac_plans_and_state",
                    "kubernetes_runtime_state",
                    "lambda_ai_slurm_runtime_state",
                    "cloud_resource_inventory",
                    "cost_and_usage_signals",
                }
            ),
        )

    def test_unknown_inventory_server_names_are_rejected(self) -> None:
        with self.assertRaises(ValueError):
            InfrastructureMcpInventory(("unknown_server",)).normalized()


if __name__ == "__main__":
    unittest.main()
