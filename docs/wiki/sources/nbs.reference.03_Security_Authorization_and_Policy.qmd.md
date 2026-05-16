---
updated: 2026-05-16
summary: Compact security reference for the stack's OIDC + RBAC + capability-catalog + policy-as-code posture, with an AWS / Floci-compatible implementation preference.
read_when:
  - You are implementing or reviewing authn/authz behavior
  - You need the canonical role/capability/policy model for the stack
source_file: ../../nbs/reference/03_Security_Authorization_and_Policy.qmd
sources:
  - ../contracts/security-baseline.md
  - ../decisions/security-authorization-architecture.md
  - ../architecture/notebook-repository-web-ui.md
  - ../architecture/webui-backend-contract.md
---

# Source summary: nbs/reference/03_Security_Authorization_and_Policy.qmd

## Role

Defines the stack's reference security posture:

- OIDC-backed authentication
- centralized authorization decisions
- human RBAC plus machine service principals
- capability catalogs per subsystem
- environment-aware and approval-aware policy checks
- auditable allow/deny decisions for privileged actions

## Main points

- Authentication and authorization are intentionally separate.
- The policy layer evaluates identity, resource, action, environment, sensitivity, approval state, and provenance.
- Human roles stay small and understandable.
- Automation uses narrow service identities.
- Enforcement points include the notebook Web UI, MLflow proxy, execution orchestrator, backend adapters, infra apply paths, and assistant tooling.
- The page is a reference posture, not an implementation claim.
- For AWS-compatible subsystems, prefer services that Floci can emulate locally so security, secrets, and audit paths stay parity-friendly.

## Use when

- you are implementing or reviewing authn/authz behavior
- you need the canonical role/capability/policy model
- you need the compact reference rather than a long treatment
