---
updated: 2026-05-11
summary: Synthesized summary of nbdev notebook source-of-truth for execution adapters and backend mapping helpers.
read_when:
  - You are editing local/slurm/k8s execution mappings
  - You need source ownership for generated `ml_deploy/execution_backends.py`
source_file: ../../nbs/08_execution_backends.ipynb
---

# Source summary: nbs/08_execution_backends.ipynb

## Role

Notebook-first source for execution adapters:

- local execution adapter returning `RunVisibility`
- normalized Slurm payload mapping
- normalized Kubernetes Job mapping

## Export behavior

- `#| default_exp execution_backends` exports into `ml_deploy/execution_backends.py`.
- Re-export via `nbdev-export --path nbs/` keeps module synchronized.
