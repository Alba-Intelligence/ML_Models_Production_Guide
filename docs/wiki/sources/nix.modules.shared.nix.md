---
updated: 2026-05-12
summary: Shared Terranix module for deployment profile options and common outputs.
read_when:
  - You need the profile-neutral Terranix baseline
sources:
  - ../../../../nix/modules/shared.nix
---

# `nix/modules/shared.nix`

- Declares the shared `mlDeploy` options used by both local and cloud profiles.
- Creates the shared artifact and model-registry S3 buckets.
- Exposes the MLflow tracking URI and deployment profile as OpenTofu outputs.
