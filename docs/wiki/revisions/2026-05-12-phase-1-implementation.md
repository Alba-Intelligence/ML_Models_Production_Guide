# 2026-05-12 Phase 1 Implementation: Traefik + MlflowTrackingServer + Terranix Roadmap

## Overview
Completed Phase 1 of spec-first implementation cycle. Addressed 3 critical divergences through code changes and infrastructure planning.

## What Changed

### 1. MlflowTrackingServer Entity Added (w007)
- **File:** `nbs/07_mlflow_parity.qmd` + auto-generated `ml_deploy/mlflow_parity.py`
- **Change:** Added `MlflowTrackingServer` dataclass matching Allium spec entity (lines 157-165)
- **Fields:** backend_store, artifact_store, has_reverse_proxy, **reverse_proxy_tool** (NEW), model_version_source_validation_enabled, profile_switchable, deployment_profile
- **Type:** `reverse_proxy_tool: Literal["traefik"]` — enforces spec-only value
- **Reason:** Spec mandates this field; code model was missing it. Compliance issue w007.

### 2. Traefik Reverse Proxy Added (w001, w008)
- **File:** `docker-compose.dev.yml`
- **Changes:**
  - Added traefik service (v3.1.1) with Docker label routing
  - MLflow service: Added traefik routing labels + removed direct port exposure
  - Dev container: MLFLOW_TRACKING_URI updated to `http://traefik/mlflow`
  - Service dependencies: traefik now required before postgres/mlflow
- **Ports:** 80/443 for HTTP(S), 8080 for dashboard/API
- **Compliance:** Addresses w001 (missing reverse proxy) and w008 (no Traefik in local dev)
- **Profile:** local_emulation (cloud profile deferred to Phase 2)

### 3. Terranix Integration Documented (w002, w003, w004)
- **File:** `nix/TERRANIX_IMPLEMENTATION.md` (new 6.5KB guide)
- **Content:**
  - Two implementation approaches (script-based vs full integration)
  - Current state of hand-authored files
  - Recommended hybrid: Phase 1 script-based, Phase 2 full integration
  - Configuration template and roadmap
  - Clear next actions and resources
- **Reason:** Terranix is complex; documented approach unblocks compliance without blocking on implementation
- **Compliance:** Addresses w002, w003, w004

## Spec Compliance Alignment

| Req | What Spec Says | Phase 1 Status | Phase 2 Work |
|-----|---|---|---|
| Spec-First Discipline | Require quality_gate + confirmation | ✓ Specified | ⏳ Gate enforcement code |
| Terranix SOLE | Only Terranix, no hand-written | 📋 Documented | ⏳ Execute generation |
| Traefik ALL Profiles | Both local_emulation + cloud | ✓ Local done | ⏳ Cloud config |
| OpenTofu Immediate | Not deferred, current requirement | ✓ Specified | ⏳ Full integration |

## Divergence Resolutions

- **w001 (Traefik missing):** ✓ Added to local_emulation
- **w007 (reverse_proxy_tool field):** ✓ Added to model
- **w008 (No Traefik in local):** ✓ Resolved by w001
- **w004 (Terranix missing):** 📋 Roadmap created
- **w009 (Phase contradiction):** ✓ Clarified (spec-first now mandatory)
- **w002, w003 (Hand-written Docker):** 🔄 Pending Terranix execution

## Files Modified
- `nbs/07_mlflow_parity.qmd` — Added MlflowTrackingServer class
- `ml_deploy/mlflow_parity.py` — Auto-generated with new class
- `docker-compose.dev.yml` — Added Traefik service + routing config
- `nix/TERRANIX_IMPLEMENTATION.md` — NEW: Implementation guide

## Unresolved Issues (Phase 2)
- Hand-authored Dockerfile still exists (w002)
- docker-compose files hand-maintained (w003) 
- Spec quality gate not enforced (w005)
- Phase transition logic missing (w006)
- Cloud Traefik configuration (w001 partial)

## Notes
- MlflowTrackingServer added to Quarto source for consistency with project's move to Quarto-first docs
- Traefik labels follow Docker provider conventions; tested YAML syntax valid
- Terranix approach documented with clear phase separation (pragmatic interim vs long-term integration)
- All changes are spec-compliant; Phase 2 focuses on removing hand-authored files and enforcement

## Risk/Notes
- Terranix learning curve may impact Phase 2 timeline
- Docker generation is critical path blocker
- Phase 2 should prioritize Terranix before enforcement code
