---
title: "Security authorization architecture"
date: 2026-05-14
summary: "Established OIDC-backed identity plus a centralized policy engine as the reference authorization model, with explicit capability catalogs per system and subsystem."
---

# What changed

1. Chose OIDC-backed identity plus a centralized policy engine as the reference posture.
2. Required every system and subsystem to declare capabilities explicitly.
3. Required user requests to be validated centrally and recorded for audit.
4. Documented the compatible solution families and the recommended fit for this architecture.

# Touched sources

- `specs/ml-deploy-reference-repo.allium`
- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/domains/governance-domain.md`
- `docs/wiki/architecture/target-system.md`
- `docs/wiki/decisions/security-authorization-architecture.md`
- `docs/wiki/decisions/index.md`
- `docs/wiki/current-state.md`
- `docs/wiki/revisions/2026-05-14-security-authorization-architecture.md`
- `docs/wiki/log.md`
