---
updated: 2026-05-09
summary: Captures the proposal to add MCP-enabled assistant integrations and a documentation delivery layer.
read_when:
  - You need provenance for assistant-integration and documentation-delivery planning
  - You want to know how these ideas were incorporated into the architecture
sources:
  - ../architecture/assistant-integration-and-docs-delivery.md
  - ../architecture/target-system.md
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/documentation-toc.md
---

# Revision: 2026-05-09 assistant and docs delivery

## Trigger

The user added two planning points:

1. consider MCP integrations for AI-assistant support in monitoring and ongoing improvement tasks
2. consider using a dedicated documentation delivery layer

## Decisions/proposals captured

- Assistant support should be treated as an **augmentation layer**, not a second source of truth.
- MCP integrations are most valuable first for MLflow, observability, cost visibility, Lambda.ai visibility, deployment/service metadata, and documentation retrieval.
- Assistant integrations should be read-first, least-privilege, and auditable by default.
- A dedicated docs delivery mechanism is a viable candidate for **documentation delivery**.
- Documentation should remain **markdown-in-git as canonical source**, with a documentation-serving/composition/search/navigation layer.
- Documentation delivery should remain logically separate from model-serving delivery even if both use the same serving technology.

## Wiki pages added

- `docs/wiki/architecture/assistant-integration-and-docs-delivery.md`

## Wiki pages updated

- `docs/wiki/architecture/target-system.md`
- `docs/wiki/architecture/reference-architecture-skeleton.md`
- `docs/wiki/architecture/documentation-toc.md`
- `docs/wiki/current-state.md`
- `docs/wiki/index.md`
- `docs/wiki/log.md`

## Remaining decisions

- which MCP integrations should be default vs optional
- whether a docs delivery layer is part of the default reference architecture or an optional companion pattern
- whether authenticated docs-authoring helpers should be part of the reference, or deferred
