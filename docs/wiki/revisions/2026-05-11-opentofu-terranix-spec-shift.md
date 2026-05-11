---
updated: 2026-05-11
summary: Shifted canonical infrastructure posture from Python-driven Terraform workflows to Nix (flake+devenv) Terranix-generated OpenTofu JSON.
read_when:
  - You need the rationale for the infrastructure direction change
  - You are migrating docs/specs from python-terraform wording to OpenTofu/Terranix wording
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../sources/ml-deploy-reference-repo.allium.md
  - ../architecture/target-system.md
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/top-down-planning.md
  - ../overview.md
  - ../domains/index.md
  - ../domains/infrastructure-domain.md
  - ../decisions/project-scope-and-constraints.md
---

# Revision: 2026-05-11 OpenTofu/Terranix spec shift

## Trigger

Infrastructure direction was explicitly changed to use Nix (both flake and devenv) for Terranix-generated OpenTofu configurations, replacing Python-managed Terraform-first posture.

## What changed

1. Updated distilled Allium spec defaults/rules to model OpenTofu + Terranix + flake/devenv + JSON-output requirements.
2. Updated core architecture and decision pages to align baseline infrastructure direction with the new canonical approach.
3. Updated spec source summary to include the new `OpenTofuConfiguration` behavior model.

## Result

The formal spec baseline and key architecture/decision references now reflect OpenTofu/Terranix as canonical infrastructure generation behavior.
