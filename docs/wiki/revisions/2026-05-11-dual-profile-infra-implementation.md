# Revision: Dual-Profile Infrastructure Implementation

**Date**: 2026-05-11
**Scope**: Dual-mode OpenTofu/Terranix infrastructure with local emulation verification gate

---

## What changed

### Allium spec (`specs/ml-deploy-reference-repo.allium`)

- Added `DeploymentProfile` enum: `local_emulation | cloud`
- Added `LocalEmulationStack` entity with all required emulation fields
- Added `active_deployment_profile` and `local_emulation_verified` fields to `Repository`
- Added `supports_local_emulation` and `supports_cloud_deployment` to `OpenTofuConfiguration`
- Added `RequireLocalEmulationParity` rule with `@guidance` annotation
- Updated `RequireNixGeneratedOpenTofuConfiguration` to enforce both profile fields
- Wired `LocalEmulationStackDeclared` trigger into `GovernanceAndDocumentationSurface`
- `allium check` passes with `findings: []`

### Docker Compose (`docker-compose.local-infra.yml`) — new file

Compute-plane local emulation stack:
- LocalStack 3 (AWS APIs: S3, IAM, EC2, STS, Secrets Manager, CloudWatch)
- K3s v1.29 in Docker (Kubernetes API emulating EKS)
- Slurm cluster (slurmctld + slurmd containers)
- `localstack_init` bootstrap container (creates S3 buckets + IAM role)

Pairs with `docker-compose.dev.yml` (data plane).

### Nix/Terranix modules (`nix/`) — new directory

```
nix/
  modules/
    shared.nix   # mlDeploy options + S3 resources (both profiles)
    local.nix    # local_emulation overrides (LocalStack + K3s + Slurm)
    cloud.nix    # cloud overrides (real AWS/EKS + sensitive vars)
  profiles/
    local.nix    # Terranix entrypoint for local profile
    cloud.nix    # Terranix entrypoint for cloud profile
```

### Notebook 13 (`nbs/13_opentofu_infra.ipynb`) — new file

Documents: architecture overview (Mermaid), local emulation stack, Nix module structure,
profile switching workflow, trade-offs, security considerations, implementation steps.

### Wiki — new + updated pages

- `docs/wiki/architecture/local-emulation-stack.md` — new reference page
- `docs/wiki/current-state.md` — updated with dual-profile implementation status
- `docs/wiki/index.md` — added local-emulation-stack entry
- `docs/wiki/log.md` — append entry

---

## Why this matters

The dual-profile constraint ensures no cloud infrastructure is applied without first
verifying the full system locally. This reduces cloud cost risk, secrets exposure,
and debugging friction significantly for ML deployments.

---

## Commits

- `65b54e3` — spec: add DeploymentProfile enum, dual-profile fields, RequireLocalEmulationParity rule
- `a28ab60` — infra: add docker-compose.local-infra.yml (compute plane emulation)
- `fce25bc` — infra: add Terranix Nix modules (shared/local/cloud) and profiles
- `2f77cc4` — docs: add nbs/13_opentofu_infra.ipynb (OpenTofu dual-mode architecture)
