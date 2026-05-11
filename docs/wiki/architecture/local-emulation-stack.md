# Local Emulation Stack

**What this page is for**: Reference for running the full ML deployment stack locally before cloud deployment.

**When to read**: When setting up local development, when running integration tests, or before applying a cloud OpenTofu profile.

**Upstream source**: `docker-compose.aws-emulator.yml`, `docker-compose.local-infra.yml`, `docker-compose.dev.yml`, `nix/modules/local.nix`

---

## Overview

The local emulation stack mirrors every service boundary present in the cloud topology.
It allows complete end-to-end verification of the system before any cloud infrastructure is touched.

**Rule (from spec `RequireLocalEmulationParity`)**: The `local_emulation` deployment profile must be fully verified before the `cloud` profile is applied.

---

## Stack components

### AWS emulator (`docker-compose.aws-emulator.yml`)

| Service | Port | Emulates |
|---|---|---|
| Floci | 4566 | AWS APIs (S3, IAM, EC2, STS, Secrets Manager, CloudWatch) |
| floci_bootstrap | — | Bootstrap: creates S3 buckets + IAM role |

### Data plane (`docker-compose.dev.yml`)

| Service | Port | Emulates |
|---|---|---|
| PostgreSQL | 5432 | MLflow backend store (RDS in cloud) |
| MLflow | 5001 | Experiment tracking server |

### Compute plane (`docker-compose.local-infra.yml`)

| Service | Port | Emulates |
|---|---|---|
| K3s | 6443 | Kubernetes API (EKS in cloud) |
| slurmctld | 6817 | Slurm controller (Lambda.ai head node) |
| slurmd | — | Slurm worker (Lambda.ai compute nodes) |

---

## Starting the stack

```bash
# AWS emulator
docker compose -f docker-compose.aws-emulator.yml up -d

# Data plane (MLflow, PostgreSQL)
docker compose -f docker-compose.dev.yml up -d

# Compute plane (K3s, Slurm)
docker compose -f docker-compose.local-infra.yml up -d

# Both together
docker compose -f docker-compose.aws-emulator.yml -f docker-compose.dev.yml -f docker-compose.local-infra.yml up -d
```

---

## Verification checklist

After both stacks are up, verify:

```bash
# MLflow
curl http://localhost:5001/health

# Floci S3
aws --endpoint-url=http://localhost:4566 s3 ls

# K3s Kubernetes
kubectl --kubeconfig /output/kubeconfig.yaml get nodes

# Slurm
scontrol ping

# Run full test suite
uv run python -m unittest discover -s tests -q
```

---

## OpenTofu integration

The local emulation stack is the OpenTofu `local_emulation` profile target.
Generated via Terranix from `nix/profiles/local.nix` and paired with `docker-compose.aws-emulator.yml`:

```bash
nix build .#localInfraJson && cp result infra/local/main.tf.json
cd infra/local && tofu init && tofu apply
```

See `nbs/13_opentofu_infra.qmd` for the dual-mode architecture walkthrough.

---

## Floci limitations

- The local emulator still runs via Docker and a mounted Docker socket.
- The Floci bootstrap role/bucket setup is intentionally minimal; add more init steps only when the stack needs them.
- K3s is still the local Kubernetes target; AWS-specific control-plane APIs remain Floci-backed.

---

## Security notes

- All local AWS credentials are dummy values (`access_key = "test"`)
- Never use local emulation credentials in cloud contexts
- K3s runs privileged — keep compute-plane Compose off production hosts
- Floci state is local-only and should not be treated as durable cloud storage

---

## Related pages

- `docs/wiki/architecture/full-system-interaction-analysis.md`
- `docs/wiki/decisions/project-scope-and-constraints.md`
- `docs/wiki/runbooks/mlflow-tracking-postgres-s3-parity.md`
- Quarto page: `nbs/13_opentofu_infra.qmd`
