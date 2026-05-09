---
updated: 2026-05-09
summary: Accepted default scope for MCP-enabled assistant integrations.
read_when:
  - You are deciding which assistant integrations are core vs optional
  - You are building assistant-support or monitoring docs
sources:
  - ../architecture/assistant-integration-and-docs-delivery.md
  - ../architecture/target-system.md
  - ../domains/observability-domain.md
  - ../domains/cost-domain.md
---

# Decision: default MCP scope

## Status

**Accepted** on 2026-05-09.

## Decision

The default MCP/assistant-support scope includes all five of these core surfaces:

1. **MLflow**
2. **Observability backends** (Prometheus/Grafana and/or CloudWatch as relevant)
3. **AWS cost visibility**
4. **Lambda.ai job/usage visibility**
5. **Documentation / decision retrieval**

These are the default reference integrations to plan around.

## Why

Together, these five surfaces give the assistant the most practical leverage for:

- experiment analysis
- deployment review
- monitoring review
- incident triage
- cost review
- ongoing improvement suggestions
- architecture/documentation navigation

This is the smallest set that still makes the assistant operationally useful across the lifecycle.

## Guardrails

- integrations are read-first by default
- write actions require explicit confirmation and auditability
- assistant tooling must not become a shadow control plane
- canonical truth remains in platform systems and the repository

## Consequences

- assistant-related docs should treat these five as core reference capabilities
- additional integrations can still exist, but should be labeled optional/extensions
- decision retrieval becomes a first-class assistant capability, not an afterthought

## Revisit if

- one of the five surfaces proves too costly or low-value to justify as default
- platform constraints limit one of the integrations in practice
- the project narrows its scope away from full lifecycle operational support
