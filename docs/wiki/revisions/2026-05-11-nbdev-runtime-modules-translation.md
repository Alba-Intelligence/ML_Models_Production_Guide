---
updated: 2026-05-11
summary: Records conversion of newly added runtime helper modules into nbdev notebook sources and synchronized exports.
read_when:
  - You need provenance for notebook-first ownership of runtime helper modules
  - You are tracing generated module changes after `nbdev-export`
sources:
  - ../../nbs/07_mlflow_parity.ipynb
  - ../../nbs/08_execution_backends.ipynb
  - ../../nbs/09_notebook_intake.ipynb
  - ../../nbs/10_terraform_bootstrap.ipynb
  - ../../ml_deploy/mlflow_parity.py
  - ../../ml_deploy/execution_backends.py
  - ../../ml_deploy/notebook_intake.py
  - ../../ml_deploy/terraform_bootstrap.py
---

# Revision: 2026-05-11 nbdev translation for runtime modules

## Trigger

Runtime modules had been introduced as direct Python files and needed to be corrected to notebook-first ownership.

## What changed

1. Added new nbdev notebooks:
   - `nbs/07_mlflow_parity.ipynb`
   - `nbs/08_execution_backends.ipynb`
   - `nbs/09_notebook_intake.ipynb`
   - `nbs/10_terraform_bootstrap.ipynb`
2. Re-exported notebooks with `nbdev-export --path nbs/`.
3. Confirmed tests still pass after export synchronization.

## Outcome

The runtime helper modules are now sourced and maintained through nbdev notebooks instead of manual Python edits.
