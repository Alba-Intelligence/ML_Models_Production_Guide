---
updated: 2026-05-13
summary: How the repository-wide distilled Allium spec maps current behavior, implementation gates, spec-quality constraints, and explicit safety invariants/contracts.
read_when:
  - You want the quickest formal view of current repository behavior
  - You are about to update shell behavior, constraints, or wiki-maintenance rules
sources:
  - ../sources/ml-deploy-reference-repo.allium.md
  - ../decisions/project-scope-and-constraints.md
  - ../architecture/dev-environment.md
---

# Distilled Allium specification

## Purpose

This page explains the repository-level distilled spec at:

- `specs/ml-deploy-reference-repo.allium`

The spec is intended as a compact, formal baseline for current repository behavior during the specification-first phase.

## What the spec currently models

1. **Repository posture and constraints** (Python/Linux/PyTorch/GPU/MLflow/Terranix+OpenTofu-from-flake+devenv/Lambda.ai/AWS direction plus accepted default monitoring/cost/MCP sets, including infrastructure interrogation when MCP servers are available).
2. **Implemented shell behavior** from `flake.nix` (shell entry, `uv` bootstrap when `pyproject.toml` exists, Jupyter helper expectations).
3. **Wiki maintenance obligations** from `AGENTS.md` and the current wiki process.
4. **Implementation gating** (specification-first block unless explicit confirmation is present).
5. **Spec quality readiness gating** (implementation is also gated unless spec-quality readiness is passed or explicitly overridden).
6. **Infrastructure MCP interrogation gating** (when infra MCP servers are available, minimum interrogation coverage is required and explicit).
7. **Documentation self-sufficiency gating** (published QMD docs must be sufficient without requiring repository source browsing).
8. **Formal safety contracts and invariants** for promotion gates and MLflow cloud safety posture.

## Scope boundaries

Included:

- behavior actually represented in this repository's files
- durable constraints that already exist in accepted decision records

Excluded:

- runtime internals of external platforms (AWS, Lambda.ai, MLflow, Prometheus, Grafana)
- ML implementation behavior that has not been added to this repository yet

## Notable quality-tightening changes

- `fastapi_in_scope` now defaults to `false` in the distilled repository model to align with the nbdev-first direction.
- `spec_quality_gate_passed` is now modeled as a repository state required for default implementation allowance.
- `AllowImplementationAfterGate` now requires either:
  - explicit user confirmation, or
  - both implementation-enabled phase and passed spec-quality gate.

## How to use it

- Use this distilled spec as the baseline when refining behavior with `tend`.
- Use this distilled spec as the reference point for future spec-code drift checks with `weed`.
- When repository behavior or constraints change, update both the `.allium` file and its source summary page.
