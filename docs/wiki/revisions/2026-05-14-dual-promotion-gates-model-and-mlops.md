---
title: "Dual promotion gates for model and MLOps"
date: 2026-05-14
summary: "Extended the distilled Allium architecture requirements to require parallel DEV→UAT→REGRESSION→PROD promotion gates for both model artifacts and MLOps Nix/Terranix/OpenTofu definitions."
---

# What changed

1. Added an explicit `MLOpsPromotionGateContract` to the distilled Allium specification.
2. Added `MLOpsDefinitionArtifact` with stage, approval, validation, and rollback-readiness fields.
3. Added rules for DEV→UAT, UAT→REGRESSION, and REGRESSION→PROD gating for MLOps definition promotion.
4. Added a production invariant requiring approved, validated, rollback-ready MLOps definitions in `prod`.
5. Marked dual promotion gating as an explicit architecture requirement in wiki target-system/current-state summaries.

# Touched sources

- `specs/ml-deploy-reference-repo.allium`
- `docs/wiki/sources/ml-deploy-reference-repo.allium.md`
- `docs/wiki/current-state.md`
- `docs/wiki/architecture/target-system.md`
- `docs/wiki/revisions/2026-05-14-dual-promotion-gates-model-and-mlops.md`
- `docs/wiki/index.md`
- `docs/wiki/log.md`
