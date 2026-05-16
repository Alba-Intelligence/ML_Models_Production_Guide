---
title: "Security authorization architecture"
date: 2026-05-16
summary: "Central authorization model for roles, capabilities, and request validation across the MLOps stack."
---

# Security authorization architecture

## Decision

Use **OIDC-backed identity + a centralized policy engine** as the reference authorization model.

That means:

- one central authority owns roles and capabilities
- every system and subsystem declares its capabilities
- user requests are validated against that central authority before access is granted

## Compatible solution families

| Option                                       | Fit                  | Notes                                                                          |
| -------------------------------------------- | -------------------- | ------------------------------------------------------------------------------ |
| OIDC IdP + central policy engine             | Best fit             | Recommended canonical posture for this architecture                            |
| Cloud IAM federation + central policy engine | Good for infra edges | Useful where cloud services need direct IAM integration                        |
| IdP-managed RBAC only                        | Limited fit          | Acceptable only for small/simple surfaces, not the preferred reference posture |

## Guidance

- Keep authentication and authorization separate.
- Keep capability catalogs explicit per system and subsystem.
- Require request validation and audit trails for privileged actions.
- Prefer policy-as-code so the same rules can guard model ops, platform ops, and MLOps infrastructure.
- For AWS-compatible subsystems, prefer services that Floci can emulate locally so security, secrets, and audit paths stay parity-friendly.

## Upstream contract

- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/sources/nbs.reference.03_Security_Authorization_and_Policy.qmd.md`
- `docs/wiki/decisions/aws-floci-aligned-implementation-path.md`
- `specs/ml-deploy-reference-repo.allium`
