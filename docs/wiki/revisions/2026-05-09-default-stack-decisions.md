---
updated: 2026-05-09
summary: Captures the accepted default stack and boundary decisions for monitoring, cost, Docker/Nix, MCP scope, and docs delivery.
read_when:
  - You need provenance for the accepted defaults
  - You want to know which major stack choices are no longer tentative
sources:
  - ../decisions/monitoring-stack-decision.md
  - ../decisions/cost-monitoring-stack-decision.md
  - ../decisions/docker-nix-boundary-decision.md
  - ../decisions/mcp-default-scope-decision.md
  - ../decisions/documentation-delivery-decision.md
---

# Revision: 2026-05-09 default stack decisions

## Trigger

After reviewing the available options, the user approved the proposed default choices for monitoring, cost, Docker/Nix posture, MCP scope, and docs delivery.

## Accepted decisions

- default monitoring stack: **Evidently + Prometheus + Grafana + MLflow**
- default cost stack: **AWS Cost Explorer / CUR / Athena / Budgets + Python attribution layer for Lambda.ai**
- Docker/Nix boundary: **Docker canonical, Nix helper/convenience layer**
- default MCP scope: **MLflow, observability, AWS cost visibility, Lambda.ai usage visibility, and documentation/decision retrieval**
- documentation delivery posture: **markdown-in-git canonical, dedicated docs delivery optional companion pattern**

## Architectural effect

These decisions reduce uncertainty for:

- observability design
- cost-governance design
- local/dev environment documentation
- assistant integration planning
- documentation delivery planning

## Remaining uncertainty after these decisions

- acceptance of the broader draft architecture layers
- precise topology details once examples arrive
- exact implementation details for Docker workflows, assistant tooling, and monitoring integrations
