---
title: "OpenTofu Infrastructure Profiles"
---

This page summarizes the dual-profile infrastructure posture.

## Profiles

- **local_emulation**: LocalStack + K3s + Slurm-Docker paired with MLflow/PostgreSQL/MinIO.
- **cloud**: AWS-backed infrastructure with Kubernetes control plane and Lambda.ai integration surfaces.

## Generation model

- Terranix modules under `nix/modules/` provide shared plus profile-specific definitions.
- Profile entrypoints under `nix/profiles/` compose modules into OpenTofu-compatible JSON.
- Apply flow is profile-scoped and local-emulation validation should precede cloud rollout.

## Key outputs

- Deployment profile identification.
- MLflow tracking URI per profile.
- Storage and scheduler endpoint references required by orchestration layers.
