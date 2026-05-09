---
updated: 2026-05-09
summary: Honest snapshot of the repository's present state, notable constraints, and likely next steps.
read_when:
  - You need a current repo snapshot
  - You are deciding what to change next
sources:
  - sources/flake.nix.md
  - sources/flake.lock.md
  - sources/gitignore.md
  - sources/LICENSE.md
  - architecture/target-system.md
  - architecture/reference-architecture-skeleton.md
  - architecture/documentation-toc.md
  - architecture/assistant-integration-and-docs-delivery.md
  - contracts/index.md
  - decisions/project-scope-and-constraints.md
---

# Current state

## Snapshot

As of 2026-05-09, the repository contains:

- `LICENSE`
- `flake.nix`
- `flake.lock` (local, but currently gitignored)
- `.gitignore`
- `AGENTS.md`
- `docs/wiki/` (the living memory layer added in this task)
- git metadata for a repository now rebased onto `origin/main`

## What is working

- A Nix dev shell can provision a curated toolchain.
- The shell includes Python 3.13, `uv`, `pyright`, `sphinx`, Typst tools, and multiple AI coding-agent CLIs.
- Helper commands exist for Jupyter kernel installation and launching JupyterLab.
- The shell is prepared to activate a local `.venv` when a `pyproject.toml` is added.
- A git repository exists and is currently at `main`, with the local planning commits rebased onto the GitHub origin history.
- The project now has a much clearer target specification captured in the wiki.
- The first draft of the reference architecture skeleton and documentation TOC now exists in the wiki.
- The project now also has a draft proposal for MCP-enabled assistant integrations and FastAPI-based documentation delivery.
- The first pass of cross-cutting contract pages now exists in the wiki.

## Current limitations

- There is no Python project definition yet, so the `uv` auto-venv path is configured but currently dormant.
- Jupyter kernel installation depends on `ipykernel` being installed in the active Python environment.
- CUDA support is explicitly commented out in `flake.nix`.
- There is no actual ML code, data pipeline, or deployment implementation yet.
- Docker-based reproducible development is now a requirement, but the repository does not yet implement that workflow.
- The reference now has draft versions of the architecture skeleton, documentation TOC, assistant/MCP posture, docs-delivery posture, and cross-cutting contracts, but they are not yet formally approved as a complete set.
- The default monitoring and cost-monitoring choices are not yet agreed.
- `flake.lock` is not tracked by git under the current ignore rules, so lockfile drift may be local-only unless that policy changes.
- The origin currently contributes a `LICENSE` file, while the expected remote `README.md` was not present during synchronization.

## Repo posture

The repo is currently best understood as a **specification-first and documentation-first bootstrap**, not as a completed or started ML deployment system.

## Most likely next additions

- domain pages for data, training, serving, infrastructure, observability, governance, and cost
- topology pages for distributed training, batch inference, and online inference
- architecture pages for assistant integration surfaces and documentation delivery
- decision records for monitoring, cost, Docker/Nix, MCPs, and docs delivery
- Docker-based development definition
- `pyproject.toml`
- example code only after specification alignment

## If you are modifying the repo

- Do not implement project code until the user explicitly says the specification is understood well enough to proceed.
- Scope and stack decisions should update [architecture/target-system.md](architecture/target-system.md) and [decisions/project-scope-and-constraints.md](decisions/project-scope-and-constraints.md).
- Changes to shell packages or startup behavior should update [architecture/dev-environment.md](architecture/dev-environment.md).
- Changes to commands or Jupyter behavior should update [runbooks/jupyter-and-shell.md](runbooks/jupyter-and-shell.md).
- Any new important root file should get a source summary under `docs/wiki/sources/`.
