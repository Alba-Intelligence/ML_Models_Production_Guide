---
updated: 2026-05-11
summary: Added explicit spec and wiki requirement that infrastructure MCP servers, when available, must be included for assistant interrogation, with minimum coverage and propagated tests.
read_when:
  - You need to understand why infrastructure MCP visibility became an explicit requirement
  - You are updating assistant/MCP scope in specs or architecture docs
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../decisions/mcp-default-scope-decision.md
  - ../architecture/assistant-integration-and-docs-delivery.md
  - ../architecture/target-system.md
  - ../decisions/project-scope-and-constraints.md
  - ../sources/ml-deploy-reference-repo.allium.md
  - ../sources/tests.test_mcp_infrastructure_contracts.py.md
  - ../decisions/infrastructure-mcp-server-inventory.md
---

# Revision: 2026-05-11 MCP infrastructure interrogation requirement

## Trigger

An original requirement needed to be made explicit: if MCP servers are available for infrastructure systems, they must be available to interrogate infrastructure state.

## What changed

1. Extended `McpSurface` in the distilled Allium spec with `infrastructure_visibility`.
2. Added conditional rule `RequireInfrastructureMcpInterrogationWhenAvailable` with an explicit trigger and availability guard.
3. Added explicit minimum interrogation-aspect coverage in spec config (IaC plans/state, Kubernetes runtime state, Lambda.ai/Slurm runtime state, cloud resource inventory, cost/usage signals).
4. Added spec-propagated tests in `tests/test_mcp_infrastructure_contracts.py`.
5. Added a dedicated decision page documenting default-vs-optional infrastructure MCP server inventory.
6. Updated MCP-related decision/architecture/domain/topology pages so infrastructure interrogation is part of default scope when such MCPs exist.
7. Updated current-state and source-summary wiki pages to reflect the new requirement.

## Result

The spec, test suite, and wiki now encode and enforce a clear requirement that assistant tooling should expose infrastructure interrogation through MCP surfaces whenever those MCP servers are available.
