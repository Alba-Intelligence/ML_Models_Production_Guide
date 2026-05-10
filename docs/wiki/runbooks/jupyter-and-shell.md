---
updated: 2026-05-10
summary: Operational commands and caveats for entering the shell and using Jupyter helpers.
read_when:
  - You want to run the repo
  - You need Jupyter or kernel setup details
sources:
  - ../sources/flake.nix.md
  - ../architecture/dev-environment.md
  - ../sources/ml_deploy.vertical_slice.py.md
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

## With the current `pyproject.toml`

On shell entry, the shell hook will:

1. create `.venv` with the flake's Python if needed
2. run `uv sync`
3. activate `.venv`

This should happen automatically in normal `nix develop` entry for this repository.

## Install or refresh the Jupyter kernel

```bash
nix develop -c start-jupyter --ensure-only
```

Important caveat:

- `start-jupyter` uses a flake-provided Python runtime with `ipykernel` bundled, independent of project `.venv` contents

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
- config written to: `~/.jupyter`

## Quick diagnostics

Inside `nix develop`, useful checks are:

```bash
python --version
git --version
which uv
which start-jupyter
```

## Run the implemented first vertical slice tests

```bash
uv sync
uv run python -m unittest discover -s tests -q
```

This validates the local implementation of EX-01 -> EX-03 in `ml_deploy/vertical_slice.py`.

## Known sharp edges

- If `uv sync` has not been run yet in the current workspace, project-local Python dependencies may be missing.
- If `ipykernel` is missing, Jupyter helper commands will not complete successfully.
- Jupyter is configured for convenience over security; the defaults are suitable for a trusted local/dev environment, not an exposed production service.
