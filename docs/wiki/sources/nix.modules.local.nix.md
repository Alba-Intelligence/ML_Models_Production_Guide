---
updated: 2026-05-12
summary: Terranix local profile override module for Floci-backed emulation.
read_when:
  - You need to understand the local Terranix/OpenTofu profile
sources:
  - ../../../../nix/modules/local.nix
  - ../../../../nix/modules/shared.nix
---

# `nix/modules/local.nix`

- Configures the local profile to use `http://localhost:4566` for the local AWS emulator.
- Uses Floci-compatible AWS provider endpoints for S3, IAM, STS, EC2, Secrets Manager, CloudWatch, and Logs.
- Keeps Kubernetes pointed at the local K3s kubeconfig path.
