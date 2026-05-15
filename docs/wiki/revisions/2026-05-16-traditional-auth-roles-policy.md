---
title: "Revision: 2026-05-16 traditional auth, roles, and policy narrative"
summary: "Added an exhaustive reference narrative for the stack's traditional OIDC + RBAC + policy-as-code posture and updated the structural gap analysis to treat that posture as the security implementation blueprint."
author: "Emmanuel"
---

# 2026-05-16 — Traditional auth, roles, and policy narrative

## What changed

- Added `nbs/reference/03_Security_Authorization_and_Policy.qmd` as the canonical narrative for the stack's traditional auth posture.
- Documented the role model, capability catalog concept, enforcement points, deny conditions, and audit expectations.
- Linked the new reference page from the wiki decision record and the wiki source index.
- Updated the structural gap analysis so the security gap now points to the documented OIDC + RBAC + centralized policy posture as the implementation blueprint.
- Recorded the new page in current-state and wiki log/revision artifacts.

## Why it matters

The repository now has a single, explicit, narrative reference for the security model that should guide implementation work across the Web UI, execution orchestrator, MLflow proxy, and infrastructure paths.

## Touched files

- `nbs/reference/03_Security_Authorization_and_Policy.qmd`
- `nbs/_quarto.yml`
- `docs/wiki/sources/nbs.reference.03_Security_Authorization_and_Policy.qmd.md`
- `docs/wiki/decisions/security-authorization-architecture.md`
- `docs/wiki/current-state.md`
- `docs/wiki/gaps/software-stack-gaps.md`
- `docs/wiki/index.md`
- `docs/wiki/revisions/2026-05-16-traditional-auth-roles-policy.md`
- `docs/wiki/log.md`
