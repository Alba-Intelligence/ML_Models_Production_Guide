---
updated: 2026-05-11
summary: Required infrastructure interrogation coverage for MCP integrations and inventory of default vs optional infrastructure MCP servers.
read_when:
  - You are implementing or reviewing infrastructure MCP integrations
  - You need the minimum infrastructure interrogation coverage expected by default
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - mcp-default-scope-decision.md
  - ../architecture/assistant-integration-and-docs-delivery.md
  - ../architecture/target-system.md
---

# Decision: infrastructure MCP server inventory

## Status

**Accepted** on 2026-05-11.

## Decision

If infrastructure MCP servers are available, assistant integrations must expose infrastructure interrogation by default.

Minimum required infrastructure interrogation aspects:

1. IaC plans and state
2. Kubernetes runtime state
3. Lambda.ai / Slurm runtime state
4. Cloud resource inventory
5. Cost and usage signals

## Default vs optional inventory

| Candidate infrastructure MCP surface | Default/optional | Notes |
| --- | --- | --- |
| OpenTofu/Terraform plans + state | **Default** | Must support read interrogation of planned vs applied shape and state drift posture. |
| Kubernetes runtime state (AWS services) | **Default** | Must support workload, pod, node, and namespace-level operational visibility for non-Lambda.ai services. |
| Lambda.ai / Slurm job state | **Default** | Must support queue/running/failed/completed visibility with job-level metadata. |
| AWS resource inventory (core infra services) | **Default** | Must support read visibility into deployed resource inventory and environment separation checks. |
| Cost + usage visibility for infra workloads | **Default** | Must support AWS + Lambda.ai usage/cost interrogation surfaces used for attribution and incident triage context. |
| Network policy / firewall posture MCP | Optional | Useful when available; not mandatory for baseline default scope. |
| Secret manager metadata MCP | Optional | Useful for audit posture; keep read-only and avoid secret material exposure. |

## Guardrails

- All infrastructure MCP integrations are read-first and least-privilege by default.
- Write paths, if ever introduced, require explicit approvals and audit trails.
- MCP surfaces augment canonical platforms; they do not replace them.

## Revisit if

- platform constraints make one default surface unavailable in a target topology
- a default surface proves disproportionate in operational overhead
- scope is narrowed away from full lifecycle infrastructure observability and interrogation
