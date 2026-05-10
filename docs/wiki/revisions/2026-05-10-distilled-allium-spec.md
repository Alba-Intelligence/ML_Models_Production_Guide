---
updated: 2026-05-10
summary: Captures the first repository-wide Allium distillation from existing files and accepted decisions.
read_when:
  - You need provenance for the new distilled specification layer
  - You want to understand what was abstracted from code/docs into Allium
sources:
  - ../architecture/distilled-allium-spec.md
  - ../sources/ml-deploy-reference-repo.allium.md
  - ../../specs/ml-deploy-reference-repo.allium
---

# Revision: 2026-05-10 distilled Allium spec

## Trigger

A full-repository distillation was requested for all files with no exclusions, requiring a formal Allium baseline of current behavior and constraints.

## Artifacts added

- `specs/ml-deploy-reference-repo.allium`
- `docs/wiki/sources/ml-deploy-reference-repo.allium.md`
- `docs/wiki/architecture/distilled-allium-spec.md`

## What it establishes

- explicit scope notes for what is and is not specified
- modeled repository posture and accepted default stacks
- modeled shell + Jupyter behavior from `flake.nix`
- modeled wiki-maintenance obligations from `AGENTS.md`
- modeled specification-first implementation gate

## Architectural effect

The repo now has an executable-style specification baseline that can be:

- evolved with `tend` as requirements become sharper
- checked against implementation later with `weed`
- used as a stable reference when adding real project code
