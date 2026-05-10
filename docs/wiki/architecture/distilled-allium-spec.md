---
updated: 2026-05-10
summary: How the repository-wide distilled Allium spec maps current behavior and constraints.
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

1. **Repository posture and constraints** (Python/Linux/PyTorch/GPU/MLflow/python-terraform/Lambda.ai/AWS direction plus accepted default monitoring/cost/MCP sets).
2. **Implemented shell behavior** from `flake.nix` (shell entry, `uv` bootstrap when `pyproject.toml` exists, Jupyter helper expectations).
3. **Wiki maintenance obligations** from `AGENTS.md` and the current wiki process.
4. **Implementation gating** (specification-first block unless explicit confirmation is present).

## Scope boundaries

Included:

- behavior actually represented in this repository's files
- durable constraints that already exist in accepted decision records

Excluded:

- runtime internals of external platforms (AWS, Lambda.ai, MLflow, Prometheus, Grafana)
- ML implementation behavior that has not been added to this repository yet

## How to use it

- Use this distilled spec as the baseline when refining behavior with `tend`.
- Use this distilled spec as the reference point for future spec-code drift checks with `weed`.
- When repository behavior or constraints change, update both the `.allium` file and its source summary page.
