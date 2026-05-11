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

## Gate criteria (current open question)

The exact automated checks required at each gate are an **open question** in the spec:

> "What automated checks must pass at each stage boundary — DEV→UAT, UAT→REGRESSION, REGRESSION→PROD?"

**Proposed minimum gates** (not yet formally spec'd):

### DEV → UAT
- Model is logged in MLflow with all required metadata (params, metrics, artifact URI)
- Training run is reproducible (fixed seed, pinned deps)
- Basic smoke tests pass (model loads, produces output shape)

### UAT → REGRESSION
- UAT test suite passes (sample production-representative data)
- No data leakage detected (train/test split verified)
- Performance metrics meet minimum thresholds (to be defined per model type)

### REGRESSION → PROD
- Full regression suite passes on reference holdout datasets
- No performance regression vs. current production model
- Security scan passes (no unexpected dependencies)
- **Human approval gate** (ML lead sign-off)

---

## MLflow model registry alignment

MLflow stage names map as follows:

| Our stage | MLflow registry stage |
|---|---|
| `dev` | `None` (not yet registered) or `Staging` |
| `uat` | `Staging` |
| `regression` | `Staging` (with CI tags) |
| `prod` | `Production` |

The spec rule `RequireModelPromotionApproval` enforces that `stage = prod` requires `promotion_approved = true`. This maps to the MLflow registry `Production` transition requiring explicit approval.

---

## CI/CD pipeline integration

The promotion pipeline must be gated by CI/CD. The specific tooling is an **open question** in the spec:

> "Which CI/CD platform should gate the promotion pipeline?"

**Candidate approaches**:

1. **GitHub Actions** — Native to the repo; workflows trigger on model registry webhooks or on git tags
2. **ArgoCD** + Kubernetes — Better for Kubernetes-native deployment promotion
3. **Custom orchestration** — Python-driven promotion scripts triggered by MLflow webhooks

---

## Infrastructure alignment

| Stage | Infrastructure target |
|---|---|
| `dev` | Local (`local_emulation` profile) |
| `uat` | Local or staging cloud cluster |
| `regression` | Dedicated regression environment (cloud profile, isolated namespace) |
| `prod` | Production cloud cluster (cloud profile, `local_emulation_verified = true` prerequisite) |

---

## PyTorch inference optimisation

Before a model is eligible for `regression` or `prod` promotion, PyTorch-specific performance tuning should be applied. The mandatory steps are an **open question** in the spec. Reference:
[PyTorch Performance Tuning Guide](https://docs.pytorch.org/tutorials/recipes/recipes/tuning_guide.html)

**Candidates to formalise**:
- `torch.compile` (graph compilation)
- Mixed-precision inference (`torch.autocast`)
- Channels-last memory format for CNN models
- `torch.no_grad()` context for all inference paths
- GPU memory fraction limits

---

## Related pages

- `docs/wiki/decisions/project-scope-and-constraints.md`
- `docs/wiki/decisions/mlflow-storage-backends.md`
- `docs/wiki/architecture/local-emulation-stack.md`
- Notebook: `nbs/12_system_interaction_analysis.ipynb`
- Notebook: `nbs/13_opentofu_infra.ipynb`
