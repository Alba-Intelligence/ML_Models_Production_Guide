---
updated: 2026-05-12
summary: Removed the Python Terraform-bootstrap implementation and aligned active docs with Nix/Terranix OpenTofu as the live path.
---

# Revision: remove Python Terraform bootstrap code

## What changed

- Deleted the Python Terraform-bootstrap module and its dedicated tests/notebook source.
- Removed the bootstrap page from active navigation and generated documentation references.
- Updated the wiki snapshot and log to reflect the removal as a current-state change.

## Why

The repository now treats Nix/Terranix-generated OpenTofu as the active infrastructure bootstrap path. Keeping a separate Python Terraform-bootstrap implementation would conflict with that direction and confuse future maintenance work.

## Touched files

- `ml_deploy/terraform_bootstrap.py`
- `tests/test_terraform_bootstrap.py`
- `nbs/10_terraform_bootstrap.qmd`
- `nbs/10_terraform_bootstrap.html.md`
- `README.md`
- `nbs/index.qmd`
- `nbs/index.html.md`
- `ml_deploy/_modidx.py`
- `tests/test_documentation_series_contracts.py`
- `docs/wiki/current-state.md`
- `docs/wiki/log.md`
- `docs/wiki/revisions/2026-05-12-remove-python-terraform-bootstrap-code.md`
