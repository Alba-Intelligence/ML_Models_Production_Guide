# Promotion Pipeline: DEV → UAT → REGRESSION → PROD

**What this page is for**: Decision record for the model and code promotion pipeline across environments.

**When to read**: When designing CI/CD, when implementing model registry workflows, or when onboarding ML engineers to the deployment lifecycle.

**Upstream spec**: `specs/ml-deploy-reference-repo.allium` — `RequireModelPromotionApproval`, `PromotionStage` enum

---

## Decision

All model artifacts must pass through four promotion stages before production:

```
DEV → UAT → REGRESSION → PROD
```

No model may skip a stage. Progression to `prod` requires explicit `promotion_approved`.

---

## Stage definitions

| Stage | Purpose | Who promotes |
|---|---|---|
| `dev` | Active experimentation — tracked in MLflow, ephemeral | Developer (automatic on log) |
| `uat` | User acceptance testing — model is candidate for regression | ML engineer (manual trigger or CI gate) |
| `regression` | Regression suite against reference datasets | CI/CD (automated gate) |
| `prod` | Production serving — approved and deployed | Approval gate (human + automated) |

---

## Gate criteria — **RESOLVED**

All gate criteria are now formally encoded in the spec as rules.

### DEV → UAT (`RequirePromotionGateDevToUat`)
- `artifact.tracked_in_mlflow = true`
- `artifact.passes_smoke_tests = true` (model loads, output shape correct)

### UAT → REGRESSION (`RequirePromotionGateUatToRegression`)
- `artifact.passes_uat_suite = true`
- `artifact.no_data_leakage_detected = true`
- `artifact.meets_minimum_metrics = true`

### REGRESSION → PROD (`RequireModelPromotionApproval` + `RequirePromotionGateProdQualityChecks`)
- `artifact.passes_regression_suite = true`
- `artifact.no_performance_regression = true`
- `artifact.security_scan_passed = true`
- `artifact.promotion_approved = true` (human gate)
- All 5 PyTorch optimisation flags = true (see below)

---

## CI/CD platform — **RESOLVED**

**GitHub Actions** gates the promotion pipeline.

---

## PyTorch inference optimisations — **RESOLVED**

All 5 optimisations are mandatory before prod promotion (`RequirePromotionGateProdQualityChecks`):

| Field | Optimisation |
|---|---|
| `pytorch_compile_applied` | `torch.compile` — graph compilation |
| `pytorch_no_grad_applied` | `torch.no_grad()` — disable gradient tracking |
| `pytorch_mixed_precision_applied` | `torch.autocast` — mixed precision inference |
| `pytorch_channels_last_applied` | Channels-last memory format (CNN models) |
| `pytorch_memory_fraction_limited` | GPU memory fraction cap |

Reference: https://docs.pytorch.org/tutorials/recipes/recipes/tuning_guide.html

---



MLflow stage names map as follows:

| Our stage | MLflow registry stage |
|---|---|
| `dev` | `None` (not yet registered) or `Staging` |
| `uat` | `Staging` |
| `regression` | `Staging` (with CI tags) |
| `prod` | `Production` |

The spec rule `RequireModelPromotionApproval` enforces that `stage = prod` requires `promotion_approved = true`. This maps to the MLflow registry `Production` transition requiring explicit approval.

---

## CI/CD pipeline integration — **RESOLVED**

**GitHub Actions** gates the promotion pipeline. Workflows trigger on:
- Model registry webhook events (stage transitions)
- Git tags (release candidates)
- Manual approval steps (REGRESSION → PROD human gate)

---

## Infrastructure alignment

| Stage | Infrastructure target |
|---|---|
| `dev` | Local (`local_emulation` profile) |
| `uat` | Local or staging cloud cluster |
| `regression` | Dedicated regression environment (cloud profile, isolated namespace) |
| `prod` | Production cloud cluster (cloud profile, `local_emulation_verified = true` prerequisite) |

---

## PyTorch inference optimisation — **RESOLVED**

See gate criteria table above. All 5 optimisations are mandatory.

---

## Related pages

- `docs/wiki/decisions/project-scope-and-constraints.md`
- `docs/wiki/decisions/mlflow-storage-backends.md`
- `docs/wiki/architecture/local-emulation-stack.md`
- Notebook: `nbs/12_system_interaction_analysis.ipynb`
- Notebook: `nbs/13_opentofu_infra.ipynb`
