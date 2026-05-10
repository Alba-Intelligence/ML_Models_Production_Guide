---
updated: 2026-05-10
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
An auxiliary `devenv.nix`/`devenv.yaml` setup is also present and now mirrors the same `allium` and `start-jupyter` approach.

## Primary responsibilities of the flake

1. Provision the developer toolchain.
2. Set up a predictable Python/Jupyter workflow.
3. Expose a helper command for Jupyter kernel setup and launch.
4. Bundle a set of AI coding-agent CLIs alongside standard development tools.
5. Provide a working `allium` CLI as a reproducible Nix-built package.

## Python and environment model

- Base interpreter: `python313`
- Package manager / environment workflow: `uv`
- Static analysis: `pyright`
- Docs tooling: `sphinx`
- Jupyter helper runtime: `start-jupyter` uses a flake-provided Python interpreter with `ipykernel` bundled.
- uv2nix remains configured for lockfile-derived packaging, but the dev shell no longer requires a uv2nix-built virtualenv to start.
- The shell exports `UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"`.
- If `pyproject.toml` exists and `.venv` is missing, the shell hook will create the venv and run `uv sync` automatically.
- If no `pyproject.toml` exists, none of that bootstrap happens.

## Jupyter model

One command is packaged into the shell:

- `start-jupyter` (Python-backed wrapper)

Key facts:

- Kernel name is fixed to `ml_ops`.
- The project-level Jupyter path is set to `jupyter/` inside the repo.
- Kernel spec directory target is `jupyter/kernels/ml_ops` under the project root.
- `start-jupyter` ensures the kernel and can be run as `start-jupyter --ensure-only` for setup-only behavior.
- `start-jupyter` launches `jupyter-lab` with token/password disabled and XSRF checks disabled.

## Bundled tool categories

### General CLI tools

- `bash`
- `bun`
- `curl`
- `gawk`
- `gh`
- `git`

### Rust tooling used for packaged CLI builds

- `rustc`
- `cargo`

### Python / notebook tooling

- `python313`
- `uv`
- `pyright`
- `sphinx`
- `ipykernel`
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

### Specification tooling

- `allium` (`allium-cli` built in Nix via `naersk`)

## Operational constraints

- `config.allowUnfree = true` is enabled.
- CUDA support is present only as commented-out hints.
- `LD_LIBRARY_PATH` is set from the C compiler runtime library, not CUDA.
- The shell can source `.env` automatically if present.
- Building `allium` from source may require network access for crate dependency fetches during Nix builds.

## Practical reading of the repo

The flake is currently the repository's real center of gravity. Until more project files exist, understanding `flake.nix` is equivalent to understanding most of the implemented system.
