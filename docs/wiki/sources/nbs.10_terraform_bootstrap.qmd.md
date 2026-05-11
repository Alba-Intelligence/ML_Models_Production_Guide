---
updated: 2026-05-12
summary: Deprecated historical summary of the old Terraform bootstrap Quarto source.
read_when:
  - You are reviewing historical bootstrap behavior that has been superseded by Nix/Terranix OpenTofu docs
source_file: ../../nbs/10_terraform_bootstrap.qmd
---

# Source summary: nbs/10_terraform_bootstrap.qmd

## Role

Historical Quarto source for Terraform bootstrap helpers:

- stack config and tfvars generation
- JSON Terraform file generation
- subprocess runner wrapper for `init`/`plan`/`apply`

## Export behavior

- `#| default_exp: terraform_bootstrap` exports into `ml_deploy/terraform_bootstrap.py`.
- Re-export via `nbdev-export --path nbs/` keeps module synchronized.

## Practical implication

This page is retained only as historical context. The active infrastructure source of truth is the Terranix/Nix OpenTofu infrastructure documentation, not a Python Terraform bootstrap workflow.
