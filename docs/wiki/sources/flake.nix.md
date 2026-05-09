---
updated: 2026-05-09
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

## Important packaged helper scripts

### `ensure-jupyter-kernel`

Behavior:

- infers `PROJECT_ROOT` from env or current directory
- exports `JUPYTER_PATH` to include the project's `jupyter/` directory
- creates `jupyter/kernels/ml_ops`
- requires `ipykernel` to exist in the active Python environment
- runs `python -m ipykernel install --user --name ml_ops --display-name ml_ops`
- writes config disabling XSRF checks in both `~/.jupyter` and a Cursor Jupyter config path

### `start-jupyter`

Behavior:

- sets `PROJECT_ROOT`
- runs `ensure-jupyter-kernel`
- launches `jupyter-lab --no-browser --ip="*"`
- disables notebook token, password, and XSRF checks

## Dev shell package sets

### Standard tools

`bash`, `bun`, `curl`, `gawk`, `gh`, `git`

### Python and docs tools

`python313`, `pyright`, `sphinx`, `uv`, plus the two Jupyter helper scripts

### Publishing / document tools

`typst`, `typst-live`, `typstyle`, `poppler-utils`, and Typst packages `ori`, `ilm`, `tbl`

### AI coding tools

`claude-code`, `copilot-cli`, `kilocode-cli`, `opencode`, `openskills`, `openspec`, `pi`, `spec-kit`, `rtk`

## Shell hook behavior

On shell entry, the flake:

- exports `PROJECT_ROOT`, `JUPYTER_CONFIG_DIR`, `JUPYTER_PATH`, `kernel_name`, `UV_PYTHON_DOWNLOADS=never`, and `UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"`
- optionally sources `.env`
- sets `LD_LIBRARY_PATH` from the compiler runtime library
- if `pyproject.toml` exists:
  - creates `.venv` if missing using `uv venv`
  - runs `uv sync`
  - activates `.venv`
- prints Python and Git versions
- runs `ensure-jupyter-kernel` if `ipykernel` is importable

## Commented or dormant choices

- `config.cudaSupport = true` is commented out
- CUDA runtime path export is also commented out
- `jupyter-all` is commented out from packages
- `awscli` is commented out

## Practical implications

- The flake is ready for notebook-centric Python work but not yet backed by a Python project file.
- Jupyter defaults favor convenience in a trusted dev setup.
- The repo appears designed for an interactive, agent-assisted workflow.
