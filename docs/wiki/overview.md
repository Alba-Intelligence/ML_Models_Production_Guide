---
updated: 2026-05-11
summary: High-level summary of the repository as it exists today and the intended project direction.
read_when:
  - You need orientation
  - You need to explain the project quickly
sources:
  - sources/flake.nix.md
  - sources/flake.lock.md
  - sources/LICENSE.md
  - sources/ml_deploy.vertical_slice.py.md
  - current-state.md
  - architecture/target-system.md
  - architecture/reference-architecture-skeleton.md
  - architecture/documentation-toc.md
  - architecture/assistant-integration-and-docs-delivery.md
  - architecture/example-matrix.md
  - architecture/first-vertical-slice.md
  - architecture/distilled-allium-spec.md
  - contracts/index.md
  - domains/index.md
  - topologies/index.md
  - decisions/project-scope-and-constraints.md
  - sources/ml-deploy-reference-repo.allium.md
---

# Overview

## One-sentence summary

This repository is becoming a **documentation-first, Python-heavy ML deployment reference** covering the path from model development to distributed production, and it now includes a concrete local first-vertical-slice implementation.

## What exists

- A root `LICENSE` file from the GitHub origin, currently GPL-3.0.
- A `flake.nix` that defines the development shell.
- A local `flake.lock` that pins upstream inputs.
- A root `.gitignore` with a minimal ignore policy.
- A root `AGENTS.md` that requires future agents to maintain the wiki.
- A living wiki in `docs/wiki` that now serves as the repository memory layer.
- A repository-level distilled Allium specification at `specs/ml-deploy-reference-repo.allium`.
- An nbdev 3 scaffold with `pyproject.toml`, notebooks under `nbs/`, package exports under `ml_deploy/`, and baseline tests.
- Ratified architecture write-up pages for the reference skeleton, documentation TOC, and first vertical slice.
- A concrete local vertical-slice implementation module (`ml_deploy/vertical_slice.py`) plus end-to-end tests (`tests/test_vertical_slice.py`).
- The vertical-slice module is now generated from `nbs/06_vertical_slice.ipynb` through nbdev export.
- A thin Web UI backend contract module (`ml_deploy/webui_contracts.py`) with tests (`tests/test_webui_contracts.py`) for immutable notebook execution requests and MLflow-linked run summaries.
- The Web UI contract module is now generated from `nbs/05_webui_contracts.ipynb` through nbdev export.
- Runtime scaffolding now exists for MLflow parity config, execution adapters, notebook intake validation, and Python-managed Terraform bootstrap.
- These runtime helpers are now sourced from nbdev notebooks (`nbs/07` through `nbs/10`) and exported into package modules.
- A standard end-of-task workflow now exists via `./scripts/finalize-task.sh` to export notebooks, render docs, and run tests.

## What does not exist yet

- No production-ready multi-topology ML pipeline implementation.
- No Docker-based reproducible workflow artifacts yet.
- No deployment scripts or infrastructure definitions for the target topologies yet.
- No concrete Slurm/Kubernetes execution adapters yet for the Web UI execution contract.
- Slurm/Kubernetes payload mappings now exist, but direct submission clients and orchestration loops are still thin scaffolding.

## Important implications

- The repo now has an initial executable slice, but remains primarily a **tooling scaffold plus specification memory layer** for broader architecture rollout.
- The intended end state is now clearer: extensive reference documentation and code examples for the full lifecycle from development to distributed production, using nbdev 3 as the core framework.
- The primary audience is now defined as **ML engineers in hedge funds**.
- The technical direction is Python-first, Linux-only, PyTorch-only with GPU support, with nbdev 3 (Quarto-based), MLflow, python-terraform, Lambda.ai, and AWS in scope.
- MLflow storage direction is PostgreSQL backend + S3 artifact store, with local parity via PostgreSQL + S3-compatible storage.
- Lambda.ai paths are expected to model Slurm coordination/redundancy for distributed workloads.
- AWS platform direction is Kubernetes-first for non-Lambda.ai services.
- Notebook execution should be triggered from a Web UI without requiring notebook source modifications.
- Security, data lineage, traceability, and reproducibility are permanent architectural requirements.
- Reproducible development is expected to use Docker, while Nix may remain as a helper layer.
- The project now has ratified architecture write-up layers (skeleton + TOC), enforceability guidance for contracts, and flow-oriented topology pages.
- The first implementation-aligned vertical slice is explicitly defined to prevent scope drift.
- The repo now also has a formal distilled spec that captures current shell behavior and specification-first governance constraints.
- The shell is prepared for Python and Jupyter work, but Python environment auto-creation only activates once a `pyproject.toml` appears.
- Jupyter support is present and opinionated, including a fixed kernel name: `ml_ops`.
- The shell now provides `allium` as a reproducible `naersk`-built package for `.allium` parsing/checking workflows.
- Git tracking is intentionally minimal; notably, `flake.lock` is present locally but ignored by the current `.gitignore`.
- The local branch history has now been rebased onto the configured GitHub origin.

## High-value pages

- [current-state.md](current-state.md) — what is true right now.
- [architecture/target-system.md](architecture/target-system.md) — intended end-state scope and stack.
- [architecture/reference-architecture-skeleton.md](architecture/reference-architecture-skeleton.md) — ratified architectural spine.
- [architecture/documentation-toc.md](architecture/documentation-toc.md) — ratified documentation structure.
- [architecture/assistant-integration-and-docs-delivery.md](architecture/assistant-integration-and-docs-delivery.md) — accepted MCP defaults plus docs delivery guidance.
- [architecture/example-matrix.md](architecture/example-matrix.md) — proposed implementation/example sequence.
- [architecture/first-vertical-slice.md](architecture/first-vertical-slice.md) — first slice definition plus implementation status.
- [architecture/webui-backend-contract.md](architecture/webui-backend-contract.md) — executable Web UI request/response contract baseline.
- [architecture/distilled-allium-spec.md](architecture/distilled-allium-spec.md) — formal distilled behavior baseline for the current repository.
- [contracts/index.md](contracts/index.md) — router for the cross-cutting contracts.
- [domains/index.md](domains/index.md) — router for the bounded domains.
- [topologies/index.md](topologies/index.md) — router for the reference topologies.
- [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md) — current hard constraints and working-mode expectations.
- [decisions/notebook-intake-validation-and-approval.md](decisions/notebook-intake-validation-and-approval.md) — notebook intake validation/approval gate model.
- [architecture/dev-environment.md](architecture/dev-environment.md) — the current technical substance of the repo.
- [sources/ml-deploy-reference-repo.allium.md](sources/ml-deploy-reference-repo.allium.md) — synthesized summary of the repository-level `.allium` source file.
- [sources/ml_deploy.vertical_slice.py.md](sources/ml_deploy.vertical_slice.py.md) — synthesized summary of the implemented local vertical-slice module.

## Open questions

- Should the first-pass cross-cutting contracts be accepted as-is or revised?
- Should the first-pass bounded domain pages be accepted as-is or revised?
- Should the first-pass topology pages be accepted as-is or revised?
- How should contract validation become automated as implementation starts?
- Will Python packaging be managed through `uv` + `pyproject.toml`, Docker, or both?
- Does the origin repository also need a README added later, given that only `LICENSE` was present during synchronization?
