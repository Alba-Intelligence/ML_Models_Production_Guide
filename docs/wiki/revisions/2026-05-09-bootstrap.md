---
updated: 2026-05-09
summary: Initial wiki bootstrap revision artifact.
read_when:
  - You want to know how the wiki was initialized
  - You need provenance for the first synthesized pages
sources:
  - ../../flake.nix
  - ../../flake.lock
  - ../../.gitignore
---

# Revision: 2026-05-09 bootstrap

## Trigger

Initial creation of the repository's living Karpathy-style wiki and root `AGENTS.md`.

## Raw sources processed

- `flake.nix`
- `flake.lock`
- `.gitignore`

## Wiki pages created

- `docs/wiki/README.md`
- `docs/wiki/index.md`
- `docs/wiki/overview.md`
- `docs/wiki/current-state.md`
- `docs/wiki/architecture/dev-environment.md`
- `docs/wiki/runbooks/jupyter-and-shell.md`
- `docs/wiki/decisions/repository-shape.md`
- `docs/wiki/sources/flake.nix.md`
- `docs/wiki/sources/flake.lock.md`
- `docs/wiki/sources/gitignore.md`
- `docs/wiki/log.md`

## Non-wiki file created

- `AGENTS.md`

## Key extracted facts

- The repo is currently a sparse, environment-first scaffold.
- `flake.nix` is the main implementation artifact.
- Python 3.13, `uv`, Jupyter helper commands, Typst tooling, and several AI coding CLIs are bundled in the shell.
- Jupyter kernel name is fixed to `ml_ops`.
- `pyproject.toml`-driven `.venv` bootstrapping is configured but inactive because no `pyproject.toml` exists yet.
- `flake.lock` pins `nixpkgs`, `flake-utils`, and `llm-agents.nix` as the most important upstream inputs.
- `.gitignore` currently ignores `flake.lock` and `docs/reference/private`.

## Open questions captured

- What concrete ML deployment workload is this repo meant to implement?
- Will CUDA support be enabled later?
- Which future files will define the actual application or notebook workflow?
