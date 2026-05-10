---
updated: 2026-05-11
summary: Synthesized summary of nbdev notebook source-of-truth for Python-driven Terraform bootstrap helpers.
read_when:
  - You are editing Terraform bootstrap behavior
  - You need source ownership for generated `ml_deploy/terraform_bootstrap.py`
source_file: ../../nbs/10_terraform_bootstrap.ipynb
---

# Source summary: nbs/10_terraform_bootstrap.ipynb

## Role

Notebook-first source for Terraform bootstrap helpers:

- stack config and tfvars generation
- JSON Terraform file generation
- subprocess runner wrapper for `init`/`plan`/`apply`

## Export behavior

- `#| default_exp terraform_bootstrap` exports into `ml_deploy/terraform_bootstrap.py`.
- Re-export via `nbdev-export --path nbs/` keeps module synchronized.
