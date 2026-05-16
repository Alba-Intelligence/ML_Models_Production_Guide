---
updated: 2026-05-16
summary: Router for durable architectural and stack decisions, including infrastructure MCP availability expectations and AWS / Floci-aligned implementation guidance.
read_when:
  - You need the accepted defaults quickly
  - You are deciding whether a major choice is already settled
sources:
  - project-scope-and-constraints.md
  - monitoring-stack-decision.md
  - cost-monitoring-stack-decision.md
  - docker-nix-boundary-decision.md
  - mcp-default-scope-decision.md
  - documentation-delivery-decision.md
  - aws-floci-aligned-implementation-path.md
  - notebook-intake-validation-and-approval.md
  - infrastructure-mcp-server-inventory.md
---

# Decisions

## Purpose

These pages preserve durable choices that should not be rediscovered from scratch every session.

## Core decision pages

- [project-scope-and-constraints.md](project-scope-and-constraints.md) — current purpose, constraints, and no-code planning rule.
- [repository-shape.md](repository-shape.md) — why the repo is implementation-light and wiki-first right now.
- [monitoring-stack-decision.md](monitoring-stack-decision.md) — accepted default monitoring stack.
- [cost-monitoring-stack-decision.md](cost-monitoring-stack-decision.md) — accepted default cost stack.
- [docker-nix-boundary-decision.md](docker-nix-boundary-decision.md) — accepted Docker/Nix boundary.
- [mcp-default-scope-decision.md](mcp-default-scope-decision.md) — accepted default MCP scope.
- [documentation-delivery-decision.md](documentation-delivery-decision.md) — accepted docs-delivery posture.
- [aws-floci-aligned-implementation-path.md](aws-floci-aligned-implementation-path.md) — AWS-native / Floci-parity preference for the biggest remaining gaps.
- [nbdev-framework-decision.md](nbdev-framework-decision.md) — accepted nbdev 3 framework for notebook-first development
- [notebook-intake-validation-and-approval.md](notebook-intake-validation-and-approval.md) — accepted validation and approval gates for executable notebook intake
- [infrastructure-mcp-server-inventory.md](infrastructure-mcp-server-inventory.md) — required infrastructure MCP coverage and default vs optional server inventory.

- [mlflow-storage-backends.md](mlflow-storage-backends.md) — MLflow backend store and artifact store choices per profile; reverse proxy requirement; MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX; mlflow-go parity.
- [promotion-pipeline.md](promotion-pipeline.md) — DEV→UAT→REGRESSION→PROD model promotion stages, gate criteria, MLflow registry alignment, CI/CD integration, PyTorch optimisation gate.
- [security-authorization-architecture.md](security-authorization-architecture.md) — central authority for roles/capabilities, capability catalogs, and request validation across the MLOps stack.

## Rule

If a future choice materially changes architecture, operations, or implementation defaults, it should be captured as a new decision page or a revision to an existing one.
