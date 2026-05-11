---
updated: 2026-05-11
summary: Synthesized summary of spec-propagated tests for infrastructure MCP interrogation obligations in the distilled Allium spec.
read_when:
  - You need to understand automated checks for infrastructure MCP requirements
  - You are changing MCP scope semantics in the Allium specification
source_file: ../../tests/test_mcp_infrastructure_contracts.py
---

# Source summary: tests/test_mcp_infrastructure_contracts.py

## Role

`tests/test_mcp_infrastructure_contracts.py` enforces the distilled Allium MCP obligations as repository tests.

## What it asserts

1. Default MCP scope includes `infrastructure_visibility`.
2. Minimum required infrastructure interrogation aspects are present in config (`iac_plans_and_state`, `kubernetes_runtime_state`, `lambda_ai_slurm_runtime_state`, `cloud_resource_inventory`, `cost_and_usage_signals`).
3. Conditional infrastructure rule is availability-guarded and enforces required interrogation-aspect coverage.

## Practical implication

Changes that weaken or accidentally remove infrastructure MCP interrogation requirements in the spec will fail fast at test time.
