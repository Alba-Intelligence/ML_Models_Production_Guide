---
updated: 2026-05-09
summary: Router for durable architectural and stack decisions.
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

## Rule

If a future choice materially changes architecture, operations, or implementation defaults, it should be captured as a new decision page or a revision to an existing one.
