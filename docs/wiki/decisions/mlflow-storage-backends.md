# MLflow Storage Backends

**What this page is for**: Decision record for MLflow Tracking Server storage backend choices across deployment profiles.

**When to read**: When configuring MLflow, when designing the local emulation stack, or when reviewing security posture.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `RequireMlflowProductionStorageBackends`, `RequireMlflowReverseProxyInProduction`, `RequireMlflowSourceValidationInProduction`

---

## Decision

| Context | Backend store | Artifact store |
|---|---|---|
| `local_emulation` | SQLite or PostgreSQL | filesystem or MinIO |
| `cloud` | **PostgreSQL (required)** | **S3 (required)** |

---

## Rationale

### Why PostgreSQL in production

- SQLite has no concurrent-writer support — unsuitable for multi-server or multi-user tracking
- SQLite has no replication, WAL archiving, or point-in-time recovery out of the box
- PostgreSQL on RDS/Aurora provides HA, automated backups, and connection pooling (PgBouncer)

### Why S3 in production

- MLflow artifacts (models, plots, datasets) can be very large — S3 provides unlimited scalable storage
- S3 has versioning, lifecycle rules, and cross-region replication
- MinIO is S3-API compatible and is used in `local_emulation` for exact API parity

### Why SQLite is acceptable locally

- Zero configuration for a single developer
- Fast for low-volume experiment tracking
- Trivially swapped to PostgreSQL for team-local setups via `docker-compose.dev.yml`

---

## Reverse proxy requirement (production)

MLflow upstream documentation recommends routing all tracking server traffic through a **reverse proxy** in production.

**Recommended**: nginx or Traefik

**Why**:
- TLS termination (MLflow server does not handle TLS natively)
- Authentication enforcement (Basic Auth / OAuth gateway before MLflow)
- Rate limiting and request throttling
- Path-based routing for multi-tenant deployments

---

## Security: model version source validation

**`MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX`** must be set in all cloud deployments.

This env var restricts which source URIs can be registered as model version sources. Without it, an attacker with MLflow API access could register an arbitrary URI as a model source, enabling model poisoning or SSRF.

Example (restrict to your S3 bucket):
```
MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX=^s3://mlflow-artifacts/.*
```

---

## Server implementation: mlflow-go

[mlflow-go](https://github.com/mlflow/mlflow-go) with the `mlflow-go-backend` Python package is the preferred MLflow server implementation because:

- It supports both SQLite/local-PostgreSQL and cloud PostgreSQL backends via environment configuration alone
- No code changes required to switch between `local_emulation` and `cloud` profiles
- API-compatible with the standard MLflow Python client

This satisfies the spec's `RequireMlflowProfileSwitchable` rule.

**Local usage** (`docker-compose.dev.yml`):
```bash
MLFLOW_BACKEND_STORE_URI=postgresql://mlflow:mlflow@postgres:5432/mlflow
MLFLOW_DEFAULT_ARTIFACT_ROOT=s3://mlflow-artifacts
MLFLOW_S3_ENDPOINT_URL=http://minio:9000  # MinIO in local_emulation
```

**Cloud usage** (same vars, different values):
```bash
MLFLOW_BACKEND_STORE_URI=postgresql://user:pass@rds-host:5432/mlflow
MLFLOW_DEFAULT_ARTIFACT_ROOT=s3://mlflow-artifacts
# No MLFLOW_S3_ENDPOINT_URL override — uses real AWS S3
```

---

## Open question

See spec: `open question "MLflow model flavors: must models be logged and loaded using the bigmlflow community flavor..."`

The standard `mlflow.sklearn` / `mlflow.pytorch` flavors may be sufficient. The `bigmlflow` community flavor adds cloud-specific helpers but requires model classes to inherit from a `bigmlflow` base. Decision deferred.

---

## Lambda.ai workload scheduling

**Decision**: Slurm for training, Kubernetes for inference serving.

- Training jobs (long-running, GPU batch) → submitted via Slurm on Lambda.ai
- Inference serving (latency-sensitive, scalable) → deployed via Kubernetes
- Both schedulers are present in the local emulation stack (`docker-compose.local-infra.yml`)
- `Repository.lambda_ai_training_scheduler = slurm`
- `Repository.lambda_ai_inference_scheduler = kubernetes`

---

## CI/CD platform

**Decision**: GitHub Actions.

- GitHub Actions workflows gate all stage promotions (DEV→UAT→REGRESSION→PROD)
- Triggers: model registry webhook events, git tags, manual approval steps
- `Repository.cicd_platform = github_actions`

---

## MLflow model flavors

**Decision**: Standard MLflow Python API only — no bigmlflow community flavor.

- Use `mlflow.pytorch`, `mlflow.sklearn` etc. throughout all profiles
- `Repository.uses_community_model_flavors = false`
- This avoids extra dependency risk and keeps local/cloud code identical

---



- `docs/wiki/architecture/local-emulation-stack.md`
- `docs/wiki/decisions/project-scope-and-constraints.md`
- Notebook: `nbs/07_mlflow_parity.qmd`
- Notebook: `nbs/13_opentofu_infra.qmd`
