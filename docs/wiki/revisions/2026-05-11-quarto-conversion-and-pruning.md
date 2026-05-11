---
updated: 2026-05-11
summary: Converted all active notebook docs surfaces to Quarto pages and pruned deprecated/outdated notebook artifacts from navigation.
read_when:
  - You need the rationale for the new Quarto-first docs narrative layout
  - You are updating docs navigation or documentation-series tests
sources:
  - ../../nbs/index.qmd
  - ../../nbs/01_platform_narrative.qmd
  - ../../nbs/12_system_interaction_analysis.qmd
  - ../../nbs/13_opentofu_infra.qmd
  - ../../nbs/_quarto.yml
  - ../../tests/test_documentation_series_contracts.py
---

# Revision: 2026-05-11 Quarto conversion and pruning

## Trigger

User requested conversion of notebooks to Quarto and pruning of outdated content.

## What changed

1. Added Quarto source pages across active notebook surfaces:
   - `nbs/index.qmd`
   - `nbs/00_core.qmd`
   - `nbs/01_platform_narrative.qmd`
   - `nbs/02_data.qmd`
   - `nbs/03_model_training.qmd`
   - `nbs/04_web_ui.qmd`
   - `nbs/05_webui_contracts.qmd`
   - `nbs/06_vertical_slice.qmd`
   - `nbs/07_mlflow_parity.qmd`
   - `nbs/08_execution_backends.qmd`
   - `nbs/09_notebook_intake.qmd`
   - `nbs/10_terraform_bootstrap.qmd`
   - `nbs/12_system_interaction_analysis.qmd`
   - `nbs/13_opentofu_infra.qmd`
2. Updated Quarto sidebar/render config in `nbs/_quarto.yml` to render only `.qmd` docs pages and remove deprecated navigation entries.
3. Pruned outdated notebook artifacts:
   - removed deprecated/obsolete narrative notebooks (`index.ipynb`, `01_platform_narrative.ipynb`, `11_infrastructure_overview.ipynb`, `12_system_interaction_analysis.ipynb`, `13_opentofu_infra.ipynb`)
   - removed stale backup notebooks (`00_core.ipynb.backup`, `02_data.ipynb.backup`)
4. Updated documentation-series tests to validate required sections from `.qmd` sources for narrative pages.
5. Updated wiki source summaries/router/state pages to reference Quarto pages instead of removed notebooks.

## Result

Documentation rendering now uses Quarto markdown pages across all active notebook surfaces, while `.ipynb` sources remain available for nbdev module generation.
