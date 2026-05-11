---
updated: 2026-05-12
summary: Retired the Python Terraform-bootstrap page from active wiki routing in favor of Nix/Terranix OpenTofu infrastructure docs.
---

# Revision: retire Python Terraform bootstrap wiki page

## What changed

- Removed the Terraform-bootstrap helper page from active wiki routing and references.
- Reworded historical source summaries so they read as deprecated context, not current posture.
- Kept the old material only as archival background.

## Why

The repository direction is now explicitly Nix/Terranix-generated OpenTofu JSON. Keeping the Python Terraform-bootstrap page in active routing would mislead readers about the current architecture.

## Touched files

- `docs/wiki/current-state.md`
- `docs/wiki/overview.md`
- `docs/wiki/index.md`
- `docs/wiki/sources/ml_deploy.terraform_bootstrap.py.md`
- `docs/wiki/sources/nbs.10_terraform_bootstrap.qmd.md`
- `docs/wiki/revisions/2026-05-12-retire-python-terraform-bootstrap-wiki.md`
- `docs/wiki/log.md`
