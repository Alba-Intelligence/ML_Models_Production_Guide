---
updated: 2026-05-09
summary: Durable technical summary of the Nix-based development environment.
read_when:
  - You are editing the flake
  - You need to understand shell behavior, Python setup, or bundled tools
sources:
  - ../sources/flake.nix.md
---

# Development environment

## Core design

The repository uses a Nix flake to define a cross-system development shell via `flake-utils.lib.eachDefaultSystem`.

## Primary responsibilities of the flake

1. Provision the developer toolchain.
2. Set up a predictable Python/Jupyter workflow.
3. Expose helper commands for Jupyter kernel installation and launch.
4. Bundle a set of AI coding-agent CLIs alongside standard development tools.

## Python and environment model

- Base interpreter: `python313`
- Package manager / environment workflow: `uv`
- Static analysis: `pyright`
- Docs tooling: `sphinx`
- The shell exports `UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"`.
- If `pyproject.toml` exists and `.venv` is missing, the shell hook will create the venv and run `uv sync` automatically.
- If no `pyproject.toml` exists, none of that bootstrap happens.

## Jupyter model

Two shell scripts are packaged into the shell:

- `ensure-jupyter-kernel`
- `start-jupyter`

Key facts:

- Kernel name is fixed to `ml_ops`.
- The project-level Jupyter path is set to `jupyter/` inside the repo.
- Kernel spec directory target is `jupyter/kernels/ml_ops` under the project root.
- Kernel installation requires `ipykernel` to already be importable from the active Python environment.
- `start-jupyter` runs `ensure-jupyter-kernel` first, then launches `jupyter-lab` with token/password disabled and XSRF checks disabled.

## Bundled tool categories

### General CLI tools

- `bash`
- `bun`
- `curl`
- `gawk`
- `gh`
- `git`

### Python / notebook tooling

- `python313`
- `uv`
- `pyright`
- `sphinx`
- `ensure-jupyter-kernel`
- `start-jupyter`

### Document tooling

- `typst`
- `typst-live`
- `typstyle`
- `poppler-utils`
- Typst packages: `ori`, `ilm`, `tbl`

### AI coding-agent tooling

- `claude-code`
- `copilot-cli`
- `kilocode-cli`
- `opencode`
- `openskills`
- `openspec`
- `pi`
- `spec-kit`
- `rtk`

## Operational constraints

- `config.allowUnfree = true` is enabled.
- CUDA support is present only as commented-out hints.
- `LD_LIBRARY_PATH` is set from the C compiler runtime library, not CUDA.
- The shell can source `.env` automatically if present.

## Practical reading of the repo

The flake is currently the repository's real center of gravity. Until more project files exist, understanding `flake.nix` is equivalent to understanding most of the implemented system.
