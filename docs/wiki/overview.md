---
updated: 2026-05-09
summary: High-level summary of the repository as it exists today and the intended project direction.
read_when:
  - You need orientation
  - You need to explain the project quickly
sources:
  - sources/flake.nix.md
  - sources/flake.lock.md
  - current-state.md
  - architecture/target-system.md
  - architecture/reference-architecture-skeleton.md
  - architecture/documentation-toc.md
  - architecture/assistant-integration-and-docs-delivery.md
  - decisions/project-scope-and-constraints.md
---

# Overview

## One-sentence summary

This repository is becoming a **documentation-first, Python-heavy ML deployment reference** covering the path from PyTorch model development to distributed production, while the current implementation still consists mainly of an environment bootstrap and living wiki.

## What exists

- A `flake.nix` that defines the development shell.
- A local `flake.lock` that pins upstream inputs.
- A root `.gitignore` with a minimal ignore policy.
- A root `AGENTS.md` that requires future agents to maintain the wiki.
- A living wiki in `docs/wiki` that now serves as the repository memory layer.

## What does not exist yet

- No application code.
- No notebooks.
- No `pyproject.toml`.
- No test suite.
- No deployment scripts or infrastructure definitions.

## Important implications

- The repo is still more of a **tooling scaffold plus specification memory layer** than an implemented ML deployment project.
- The intended end state is now clearer: extensive reference documentation and code examples for the full lifecycle from development to distributed production.
- The primary audience is now defined as **ML engineers in hedge funds**.
- The technical direction is Python-first, Linux-only, PyTorch-only with GPU support, with FastAPI, MLflow, python-terraform, Lambda.ai, and AWS in scope.
- Security, data lineage, traceability, and reproducibility are permanent architectural requirements.
- Reproducible development is expected to use Docker, while Nix may remain as a helper layer.
- The project now has draft versions of the reference architecture skeleton, the documentation TOC, and the assistant/MCP plus docs-delivery posture.
- The shell is prepared for Python and Jupyter work, but Python environment auto-creation only activates once a `pyproject.toml` appears.
- Jupyter support is present and opinionated, including a fixed kernel name: `ml_ops`.
- Git tracking is intentionally minimal; notably, `flake.lock` is present locally but ignored by the current `.gitignore`.

## High-value pages

- [current-state.md](current-state.md) — what is true right now.
- [architecture/target-system.md](architecture/target-system.md) — intended end-state scope and stack.
- [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md) — proposed architectural spine.
- [architecture/documentation-toc.md](architecture/documentation-toc.md) — proposed documentation structure.
- [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md) — proposed MCP assistant surfaces and docs delivery model.
- [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md) — current hard constraints and no-code planning rule.
- [architecture/dev-environment.md](architecture/dev-environment.md) — the current technical substance of the repo.

## Open questions

- Should the proposed reference architecture skeleton be accepted as-is or revised?
- Should the proposed documentation TOC be accepted as-is or revised?
- Which model-monitoring and cost-monitoring stacks should be the default recommended path?
- Which MCP integrations should be default vs optional?
- Should FastAPI docs delivery be part of the default architecture or an optional companion pattern?
- What exact boundary should exist between Docker as the standard path and Nix as a helper layer?
- Will Python packaging be managed through `uv` + `pyproject.toml`, Docker, or both?
