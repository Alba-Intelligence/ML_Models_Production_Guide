---
updated: 2026-05-11
summary: Fixed Quarto chunk metadata compatibility in converted `.qmd` files and confirmed full docs render from Quarto sources.
read_when:
  - You need context for why Quarto render validation uses `--no-execute`
  - You are debugging converted notebook chunk options in `.qmd` files
sources:
  - ../../nbs/00_core.qmd
  - ../../nbs/02_data.qmd
  - ../../nbs/03_model_training.qmd
  - ../../nbs/05_webui_contracts.qmd
  - ../../nbs/06_vertical_slice.qmd
  - ../../nbs/07_mlflow_parity.qmd
  - ../../nbs/08_execution_backends.qmd
  - ../../nbs/09_notebook_intake.qmd
  - ../../nbs/10_terraform_bootstrap.qmd
  - ../runbooks/jupyter-and-shell.md
  - ../current-state.md
---

# 2026-05-11 — Quarto render metadata fix

## What changed

- Normalized converted Quarto chunk metadata in notebook-derived `.qmd` files from `#| export: true` to `#| export:` (null-valued export flag).
- Updated wiki runbook and current-state pages to document the stable full-site validation command:
  - `nix develop -c quarto render nbs --no-execute`

## Why

- Quarto validation rejects boolean `export` metadata in these converted chunks and expects a null-valued export marker.
- Full execution-enabled render also depends on currently-resolved Jupyter kernel paths; docs-generation confirmation does not require execution.

## Verification outcome

- Full Quarto site render from `nbs/*.qmd` completes with `--no-execute`.
- `_docs/index.html` includes current Quarto homepage navigation links (for example, `vertical_slice.html` and `webui_contracts.html`).
