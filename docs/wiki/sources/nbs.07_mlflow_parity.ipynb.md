---
updated: 2026-05-11
summary: Synthesized summary of nbdev notebook source-of-truth for MLflow parity stack helpers.
read_when:
  - You are editing local MLflow parity behavior
  - You need source ownership for generated `ml_deploy/mlflow_parity.py`
source_file: ../../nbs/07_mlflow_parity.ipynb
---

# Source summary: nbs/07_mlflow_parity.ipynb

## Role

Notebook-first source for local MLflow parity helpers:

- PostgreSQL backend store URI configuration
- S3/MinIO artifact destination configuration
- compose/runtime helper generation

## Export behavior

- `#| default_exp mlflow_parity` exports into `ml_deploy/mlflow_parity.py`.
- Re-export via `nbdev-export --path nbs/` keeps module synchronized.
