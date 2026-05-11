---
updated: 2026-05-11
summary: Synthesized summary of Quarto nbdev source-of-truth for MLflow parity and local emulation compose helpers.
read_when:
  - You are editing local MLflow parity behavior
  - You need source ownership for generated `ml_deploy/mlflow_parity.py`
source_file: ../../nbs/07_mlflow_parity.qmd
---

# Source summary: nbs/07_mlflow_parity.qmd

## Role

Quarto-first source for local MLflow parity helpers:

  - PostgreSQL backend store URI configuration
  - S3/MinIO artifact destination configuration
  - compute-plane local emulation compose generation (LocalStack, K3s, Slurm)
  - merged full local-emulation compose generation

## Export behavior

- `#| default_exp: mlflow_parity` exports into `ml_deploy/mlflow_parity.py`.
- Re-export via `nbdev-export --path nbs/` keeps module synchronized.
