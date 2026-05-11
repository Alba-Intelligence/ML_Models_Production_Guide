---
updated: 2026-05-11
summary: Switched nbdev code ownership from `.ipynb` notebooks to Quarto `.qmd` sources and removed legacy code notebooks.
read_when:
  - You need the rationale for removing the remaining code `.ipynb` files
  - You are maintaining nbdev export flow with Quarto-first sources
sources:
  - ../../nbs/05_webui_contracts.qmd
  - ../../nbs/06_vertical_slice.qmd
  - ../../nbs/07_mlflow_parity.qmd
  - ../../nbs/08_execution_backends.qmd
  - ../../nbs/09_notebook_intake.qmd
  - ../../nbs/10_terraform_bootstrap.qmd
  - ../../tests/test_documentation_series_contracts.py
  - ../current-state.md
  - ../index.md
---

# 2026-05-11 — Quarto code ownership switch

## What changed

- Removed remaining code-oriented notebook sources:
  - `nbs/00_core.ipynb`
  - `nbs/02_data.ipynb`
  - `nbs/03_model_training.ipynb`
  - `nbs/04_web_ui.ipynb`
  - `nbs/05_webui_contracts.ipynb`
  - `nbs/06_vertical_slice.ipynb`
  - `nbs/07_mlflow_parity.ipynb`
  - `nbs/08_execution_backends.ipynb`
  - `nbs/09_notebook_intake.ipynb`
  - `nbs/10_terraform_bootstrap.ipynb`
- Kept and promoted `.qmd` files as the sole nbdev code source for these modules.
- Regenerated exported modules using `nbdev-export --path nbs/`.
- Updated docs and source summaries from `.ipynb` ownership references to `.qmd` ownership references.
- Updated docs-series contract test to validate `06_vertical_slice.qmd` and the `#| default_exp: vertical_slice` marker.

## Why

The repository had already completed Quarto conversion for documentation. This change removes split ownership and makes source-of-truth unambiguous: Quarto files now drive both docs and nbdev code export for the converted modules.

## Verification outcome

- `uv run nbdev-export --path nbs/` succeeded after notebook removal.
- `uv run python -m unittest discover -s tests -q` passed.
- `nix develop -c quarto render nbs --no-execute` succeeded.
