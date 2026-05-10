---
updated: 2026-05-11
summary: Synthesized summary of the repository's main flake definition.
read_when:
  - You are editing the flake
  - You need exact behavior summarized before opening the raw file
source_file: ../../flake.nix
---

# Source summary: flake.nix

## Role

`flake.nix` defines the repository's development environment and is currently the single most important implementation file.

## Top-level intent

- Description: `ML Ops`
- Uses `flake-utils.lib.eachDefaultSystem`
- Pulls packages from `nixpkgs` and tool bundles from `llmpkgs`

## Notable constants

- `kernelName = "ml_ops"`
- `jupyterDir = "jupyter"`
- `kernelsDir = "jupyter/kernels"`
- `basePython = pkgs.python313`

## Packaged Allium CLI

- `allium` is provided as a Nix package built with `naersk`.
- The source is the crates.io release archive for `allium-cli` `3.2.3`.
- The crate source is unpacked into a normalized source directory before the `naersk` build.
- `singleStep = true` is enabled for the `naersk` build.

## Important packaged helper scripts

### `start-jupyter` (Python-backed)

Behavior:

- infers `PROJECT_ROOT` from env or current directory
- exports `JUPYTER_PATH` to include the project's `jupyter/` directory
- creates `jupyter/kernels/ml_ops`
- runs `ipykernel install` through a flake-provided Python interpreter with `ipykernel` bundled
- writes config disabling XSRF checks in `~/.jupyter`
- supports `--ensure-only` to run setup without launching JupyterLab
- launches `jupyter-lab --no-browser --ip="*"`
- disables notebook token, password, and XSRF checks

## Dev shell package sets

### Standard tools

`bash`, `bun`, `curl`, `gawk`, `gh`, `git`, `quarto`

### Rust build tools

`rustc`, `cargo`

### Python and docs tools

`python313`, `pyright`, `sphinx`, `uv`, `ipykernel`, plus the `start-jupyter` helper command

### uv2nix integration boundary

- uv2nix remains wired for lockfile/workspace translation and `packages.default`.
- `devShells.default` no longer injects a uv2nix-built `mkVirtualEnv` derivation.
- The shell now relies on the local `uv` workflow (`uv venv` + `uv sync`) for project environment activation.
- This avoids `nix develop` failures when workspace files are present locally but not in the flake's Git-tracked source snapshot.

### Publishing / document tools

`typst`, `typst-live`, `typstyle`, `poppler-utils`, and Typst packages `ori`, `ilm`, `tbl`

### AI coding tools

`claude-code`, `copilot-cli`, `kilocode-cli`, `opencode`, `openskills`, `openspec`, `pi`, `spec-kit`, `rtk`

### Specification tooling

`allium` (naersk-built `allium-cli` package)

## Shell hook behavior

On shell entry, the flake:

- exports `PROJECT_ROOT`, `JUPYTER_CONFIG_DIR`, `JUPYTER_PATH`, `UV_PYTHON_DOWNLOADS=never`, and `UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"`
- optionally sources `.env`
- sets `LD_LIBRARY_PATH` from the compiler runtime library
- if `pyproject.toml` exists:
  - creates `.venv` if missing using `uv venv`
  - runs `uv sync`
  - activates `.venv`
- prints Python and Git versions
- runs `start-jupyter --ensure-only`

## Commented or dormant choices

- `config.cudaSupport = true` is commented out
- CUDA runtime path export is also commented out
- `jupyter-all` is commented out from packages
- `awscli` is commented out

## Practical implications

- The flake is ready for notebook-centric Python work but not yet backed by a Python project file.
- Jupyter defaults favor convenience in a trusted dev setup.
- The repo appears designed for an interactive, agent-assisted workflow.
- The shell ships a reproducible `allium` binary from Nix builds rather than runtime self-install logic.
