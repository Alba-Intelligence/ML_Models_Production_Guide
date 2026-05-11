---
updated: 2026-05-10
summary: Accepted MCP assistant integration surfaces and docs-delivery posture aligned to nbdev-first architecture.
read_when:
  - You are designing assistant/tool interfaces
  - You are defining docs-delivery boundaries
sources:
  - target-system.md
  - reference-architecture-skeleton.md
  - documentation-toc.md
  - ../decisions/project-scope-and-constraints.md
---

# Assistant integration and docs delivery

## Status

This page captures accepted defaults, replacing older framework-specific drafts.

## Assistant integration scope (accepted default)

The default assistant-support scope includes:

1. MLflow experiment/model surfaces
2. Observability surfaces (Prometheus/Grafana/CloudWatch as applicable)
3. AWS cost visibility
4. Lambda.ai usage/job visibility
5. Infrastructure-state interrogation when infrastructure MCP servers are available
6. Documentation and decision retrieval

## Design rules

1. Read-first and least-privilege by default.
2. Any write capability must be explicit and auditable.
3. Assistants consume canonical system facts through controlled interfaces.
4. Assistant tooling must not create a parallel control plane.

## Recommended MCP categories

- MLflow MCP (runs, parameters, metrics, artifacts, model versions)
- Observability MCP (metrics, alerts, traces/log summaries)
- Cost MCP (AWS billing + Lambda.ai attribution)
- Infrastructure MCP (Terraform state/plans, Kubernetes/Lambda.ai deployment state)
- Documentation MCP (architecture/decisions/runbooks/contracts retrieval)

Minimum required infrastructure interrogation coverage (when infrastructure MCP servers are available):

1. IaC plans/state
2. Kubernetes runtime state
3. Lambda.ai/Slurm runtime state
4. Cloud resource inventory
5. Cost and usage signals

## Documentation delivery posture

Accepted posture:

- notebooks + markdown in git are canonical sources
- nbdev/Quarto is the default docs generation and delivery path
- optional dynamic docs services may be added later, but remain companion-only
- docs delivery remains operationally separate from inference-serving surfaces

## Practical implication

When adding assistant features:

- prefer adding narrow MCP adapters over ad hoc scripts
- bind every assistant-facing concept to existing architecture contracts
- require provenance links back to runs/deployments/cost records/docs
