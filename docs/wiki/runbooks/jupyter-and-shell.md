---
updated: 2026-05-12
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

## Docker-first local development path

Bring up the canonical Docker stack (Floci + MLflow/PostgreSQL):

```bash
docker compose -f docker-compose.aws-emulator.yml -f docker-compose.dev.yml up -d --build
docker compose -f docker-compose.aws-emulator.yml -f docker-compose.dev.yml exec dev bash
```

Shut it down:

```bash
docker compose -f docker-compose.dev.yml down
```

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

## Render Quarto docs from `.qmd`

Render the full docs site from Quarto sources without executing notebook kernels:

```bash
nix develop -c quarto render . --no-execute
```

This is the canonical way to recreate the HTML docs from source; it refreshes `_docs/index.html` and `_docs/nbs/*.html`.

Short helper script:

```bash
./scripts/regenerate-html.sh
```

The helper prefers `quarto` directly if available and otherwise uses:

```bash
nix-shell --packages quarto --run 'quarto render . --no-execute'
```

Render only the homepage:

```bash
nix develop -c quarto render nbs/index.qmd --no-execute
```

That homepage is what `_docs/index.html` forwards to in the published site; the rendered content lives at `_docs/nbs/index.html`.

## End-of-task publishable notebook workflow

Use the standardized finalize command:

```bash
./scripts/finalize-task.sh
```

This runs:

1. `nbdev-export --path nbs/`
2. `quarto render . --no-execute`
3. `python -m unittest discover -s tests -q`

Docs freshness is enforced by `tests/test_docs_freshness.py`, which fails if `_docs/nbs/*.html` is older than `nbs/*.qmd`.

The same export/render/test sequence is enforced in CI via `.github/workflows/ci.yml`.

## Known sharp edges

- If `uv sync` has not been run yet in the current workspace, project-local Python dependencies may be missing.
- If `ipykernel` is missing, Jupyter helper commands will not complete successfully.
- Root Quarto project render writes the canonical repo docs output under `_docs/` (notably `_docs/nbs/*.html` and `_docs/index.html`).
- Quarto render with execution enabled depends on a valid configured Jupyter kernel path; use `--no-execute` for docs-generation validation when kernel execution is not required.
- Jupyter is configured for convenience over security; the defaults are suitable for a trusted local/dev environment, not an exposed production service.
