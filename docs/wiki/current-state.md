---
updated: 2026-05-11
summary: Honest snapshot of the repository's present state, notable constraints, and likely next steps.
read_when:
  - You need a current repo snapshot
  - You are deciding what to change next
sources:
  - sources/flake.nix.md
  - sources/flake.lock.md
  - sources/gitignore.md
  - sources/LICENSE.md
  - sources/ml_deploy.vertical_slice.py.md
  - sources/nbs.06_vertical_slice.ipynb.md
  - sources/tests.test_vertical_slice.py.md
  - architecture/target-system.md
  - architecture/reference-architecture-skeleton.md
  - architecture/documentation-toc.md
  - architecture/assistant-integration-and-docs-delivery.md
  - architecture/example-matrix.md
  - architecture/first-vertical-slice.md
  - architecture/webui-backend-contract.md
  - architecture/distilled-allium-spec.md
  - contracts/index.md
  - domains/index.md
  - topologies/index.md
  - decisions/project-scope-and-constraints.md
  - decisions/notebook-intake-validation-and-approval.md
  - sources/ml-deploy-reference-repo.allium.md
  - sources/ml_deploy.webui_contracts.py.md
  - sources/ml_deploy.execution_backends.py.md
  - sources/ml_deploy.mlflow_parity.py.md
  - sources/ml_deploy.notebook_intake.py.md
  - sources/ml_deploy.terraform_bootstrap.py.md
  - sources/nbs.05_webui_contracts.ipynb.md
  - sources/tests.test_webui_contracts.py.md
---

# Current state

## Snapshot

As of 2026-05-11, the repository contains:

- `LICENSE`
- `flake.nix`
- `flake.lock` (local, but currently gitignored)
- `.gitignore`
- `AGENTS.md`
- `devenv.nix`, `devenv.yaml`, and `devenv.lock`
- `docs/wiki/` (the living memory layer, now including architecture decision for notebook repository web UI)
- `specs/ml-deploy-reference-repo.allium` (distilled repository-level Allium specification)
- nbdev 3 project structure with `pyproject.toml`, `nbs/` directory for notebooks, and `ml_deploy/` package
- `nbs/05_webui_contracts.ipynb` as nbdev source for Web UI backend contracts
- `nbs/06_vertical_slice.ipynb` as nbdev source for first-vertical-slice implementation
- runtime helper modules for MLflow parity, execution adapters, intake validation, and Terraform bootstrap
- git metadata for a repository now rebased onto `origin/main`

## What is working

- A Nix dev shell can provision a curated toolchain.
- The shell includes Python 3.13, `uv`, `pyright`, `sphinx`, Typst tools, and multiple AI coding-agent CLIs.
- The shell now exposes `allium` as a `naersk`-built Nix package (`allium-cli` 3.2.3).
- A single helper command (`start-jupyter`) handles kernel setup and JupyterLab launch.
- The auxiliary devenv config now mirrors the same `allium` (naersk build) and Python-backed `start-jupyter` behavior.
- The shell can create/sync and activate a local `.venv` via `uv` using the current `pyproject.toml`.
- `nix develop` no longer depends on building the editable workspace package through uv2nix during shell entry.
- A git repository exists and is currently at `main`, with the local planning commits rebased onto the GitHub origin history.
- The project now has a much clearer target specification captured in the wiki.
- The reference architecture skeleton and documentation TOC are now ratified in the wiki.
- The project now also has accepted defaults for MCP scope, monitoring stack, cost stack, Docker/Nix posture, and docs-delivery posture captured in decision records.
- The first pass of cross-cutting contract pages now exists in the wiki.
- The first pass of bounded domain pages now exists in the wiki.
- The topology pages now include explicit control/data/artifact flow specifications and contract checkpoints.
- The first architecture-aligned example matrix now exists in the wiki.
- The first implementation-aligned architecture slice is now defined in `architecture/first-vertical-slice.md`.
- The first local vertical slice is now implemented in `ml_deploy/vertical_slice.py` with tests in `tests/test_vertical_slice.py`.
- The vertical-slice module is now notebook-owned and exported from `nbs/06_vertical_slice.ipynb`.
- A thin Web UI backend contract module now exists in `ml_deploy/webui_contracts.py` with tests in `tests/test_webui_contracts.py`.
- The Web UI contract module is now notebook-owned and exported from `nbs/05_webui_contracts.ipynb`.
- Execution adapter mappings now exist for local, Slurm, and Kubernetes payloads.
- Notebook intake validation gates now exist for immutable refs, notebook structure, and optional nbdev export checks.
- Python-driven Terraform bootstrap helpers now generate Terraform JSON stack files and expose init/plan/apply runners.
- A distilled repository-wide Allium specification now exists and is indexed in the wiki.
- An nbdev 3 project structure has been initialized with pyproject.toml, nbs/ directory, and ml_deploy/ package placeholder.
- Notebooks can be successfully exported to Python packages using `nbdev-export --path nbs/`.

## Current limitations

- Docker-based reproducible development is a hard requirement, but Docker workflows are still not implemented in-repo.
- `ipykernel` is included in the flake-provided toolchain for Jupyter kernel setup.
- Building `allium` may require network access for Rust crate dependency fetches during Nix builds.
- CUDA support is explicitly commented out in `flake.nix`.
- There is no production-ready ML data pipeline or deployment implementation yet.
- Contract validation is currently test-level for the local vertical slice, not yet generalized across all topologies.
- New architecture requirements now specify MLflow PostgreSQL/S3 storage, Lambda.ai Slurm coordination/redundancy, AWS Kubernetes for non-Lambda.ai services, and Python-managed Terraform-first infrastructure workflows.
- Slurm/Kubernetes mappings exist, but direct submission clients and runtime orchestration integration are still minimal scaffolding.
- The distilled Allium spec currently models repository posture, shell behavior, and governance constraints; it does not yet cover any real ML implementation logic because that code still does not exist.
- `flake.lock` is not tracked by git under the current ignore rules, so lockfile drift may be local-only unless that policy changes.
- The origin currently contributes a `LICENSE` file, while the expected remote `README.md` was not present during synchronization.

## Repo posture

The repo is currently best understood as a **specification-first and documentation-first bootstrap**, not as a completed or started ML deployment system.

## Most likely next additions

- Docker-based development definition
- local replica topology that mirrors production control planes (Kubernetes/Slurm/storage) where feasible
- promotion of the implemented local slice into Docker-first execution flow
- expansion into distributed, batch, and online production topologies
- notebook Web UI execution flow with immutable notebook source semantics
- concrete Slurm/Kubernetes submission clients and orchestration runners on top of current mapping helpers
- validation hooks for contract compliance checks
- implementation only after user-directed transition from spec-first write-up to build-out

## If you are modifying the repo

- Keep architecture/spec quality first; implement concrete slices only when user-directed and keep wiki in lockstep.
- Scope and stack decisions should update [architecture/target-system.md](architecture/target-system.md) and [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md).
- Changes to shell packages or startup behavior should update [architecture/dev-environment.md](architecture/dev-environment.md).
- Changes to commands or Jupyter behavior should update [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md).
- Any new important root file should get a source summary under `docs/wiki/sources/`.
