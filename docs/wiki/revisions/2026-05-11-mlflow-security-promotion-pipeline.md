# Revision: MLflow security/storage, promotion pipeline, open questions

**Date**: 2026-05-11
**Scope**: MLflow storage/security spec additions, promotion pipeline, five open questions

---

## What changed

### Allium spec (`specs/ml-deploy-reference-repo.allium`)

**New enums**:
- `MlflowBackendStore { sqlite | postgresql }`
- `MlflowArtifactStore { filesystem | minio | s3 }`
- `PromotionStage { dev | uat | regression | prod }`

**New entities**:
- `MlflowTrackingServer` — backend_store, artifact_store, has_reverse_proxy, model_version_source_validation_enabled, profile_switchable, deployment_profile
- `ModelArtifact` — tracked_in_mlflow, stage (PromotionStage), promotion_approved

**Repository additions**: `cicd_pipeline_in_scope`, `promotion_pipeline_in_scope` (both default `true`)

**New rules**:
- `RequireMlflowProfileSwitchable` — server must work identically across profiles (mlflow-go pattern)
- `RequireMlflowProductionStorageBackends` — cloud: postgresql + s3 required
- `RequireMlflowReverseProxyInProduction` — cloud: reverse proxy required (TLS, auth, rate-limiting)
- `RequireMlflowSourceValidationInProduction` — cloud: MLFLOW_CREATE_MODEL_VERSION_SOURCE_VALIDATION_REGEX must be set
- `RequireModelPromotionApproval` — prod stage gate: requires promotion_approved

**New surface**: `MlflowOperationsSurface` (MlflowTrackingServerDeployed, ModelArtifactPromoted)

**Open questions (5)**:
1. Lambda.ai Slurm vs Kubernetes preference per workload type
2. bigmlflow community flavor requirement for cloud model logging/loading
3. CI/CD tooling choice for promotion pipeline
4. Promotion gate criteria at each stage boundary
5. PyTorch inference optimisation mandatory steps before prod promotion

**Fixed**: All `@guidance` annotations converted from inline-string to indented-comment-line format (grammar compliance).

### Wiki decision pages (new)

- `docs/wiki/decisions/mlflow-storage-backends.md` — storage backend choices, reverse proxy, security env var, mlflow-go
- `docs/wiki/decisions/promotion-pipeline.md` — promotion stages, gate criteria, MLflow registry mapping, CI/CD, PyTorch tuning gate

### Wiki index and routing updated

- `decisions/index.md`, `index.md` — new pages added to routing tables

---

## Source notes

- PyTorch tuning guide: https://docs.pytorch.org/tutorials/recipes/recipes/tuning_guide.html
- MLflow community flavors: https://mlflow.org/docs/latest/ml/community-model-flavors/
- mlflow-go: https://github.com/mlflow/mlflow-go

---

## Commits

- `1782f55` — spec: MLflow storage/security, promotion pipeline, open questions
