---
updated: 2026-05-09
summary: Operational commands and caveats for entering the shell and using Jupyter helpers.
read_when:
  - You want to run the repo
  - You need Jupyter or kernel setup details
sources:
  - ../sources/flake.nix.md
  - ../architecture/dev-environment.md
---

# Jupyter and shell runbook

## Enter the development shell

```bash
nix develop
```

What this gives you:

- the flake-defined toolchain
- shell environment variables such as `PROJECT_ROOT`, `JUPYTER_PATH`, and `UV_PROJECT_ENVIRONMENT`
- optional `.env` loading if a root `.env` file exists

## If you later add a `pyproject.toml`

On shell entry, the shell hook will:

1. create `.venv` with the flake's Python if needed
2. run `uv sync`
3. activate `.venv`

Today this does **not** happen because the repo does not yet contain a `pyproject.toml`.

## Install or refresh the Jupyter kernel

```bash
nix develop -c ensure-jupyter-kernel
```

Important caveat:

- this only succeeds if `python -c 'import ipykernel'` works in the active environment
- if it fails, the flake itself suggests running `uv sync` after adding notebook dependencies

## Start JupyterLab

```bash
nix develop -c start-jupyter
```

Behavior:

- ensures the `ml_ops` kernel first
- launches `jupyter-lab`
- disables token and password auth
- disables XSRF checks

## Where Jupyter data goes

- project Jupyter path: `jupyter/`
- kernel location under project: `jupyter/kernels/ml_ops`
- config also written to:
  - `~/.jupyter`
  - `~/.config/Cursor/User/globalStorage/ms-toolsai.jupyter/version-2025.9.1`

## Quick diagnostics

Inside `nix develop`, useful checks are:

```bash
python --version
git --version
which uv
which start-jupyter
which ensure-jupyter-kernel
```

## Known sharp edges

- No `pyproject.toml` means no project-local Python packages are installed yet.
- If `ipykernel` is missing, Jupyter helper commands will not complete successfully.
- Jupyter is configured for convenience over security; the defaults are suitable for a trusted local/dev environment, not an exposed production service.
