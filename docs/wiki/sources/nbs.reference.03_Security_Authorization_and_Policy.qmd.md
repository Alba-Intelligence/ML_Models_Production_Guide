---
updated: 2026-05-16
summary: Exhaustive reference posture for traditional authentication, RBAC, capability catalogs, centralized policy enforcement, and auditability across the ML Deploy stack.
read_when:
  - You are implementing or reviewing authn/authz behavior
  - You need the canonical role/capability/policy model for the stack
source_file: ../../nbs/reference/03_Security_Authorization_and_Policy.qmd
sources:
  - ../contracts/security-baseline.md
  - ../decisions/security-authorization-architecture.md
  - ../architecture/notebook-repository-web-ui.md
  - ../architecture/webui-backend-contract.md
  - ../decisions/mlflow-postgres-s3-contract.md
---

# Source summary: nbs/reference/03_Security_Authorization_and_Policy.qmd

## Role

Defines the repository's reference security posture for a traditional enterprise auth model:

- OIDC-backed authentication
- centralized authorization decisions
- human RBAC plus machine service principals
- capability catalogs per subsystem
- environment-aware and approval-aware policy checks
- auditable allow/deny decisions for privileged actions

## Main narrative points

- Authentication and authorization are intentionally separated.
- The policy layer evaluates principal, resource, action, environment, sensitivity, approval state, and request provenance.
- Human roles are kept small and understandable.
- Automation uses narrowly scoped service identities rather than ambient broad access.
- Enforcement points include the notebook Web UI, MLflow reverse proxy, execution orchestrator, backend adapters, infrastructure apply paths, and assistant/MCP tooling.
- Default behavior is deny unless an explicit policy grants the action.

## Canonical role families

- `SystemAdmin`
- `SecurityAdmin`
- `PlatformAdmin`
- `DataAdmin`
- `ProjectAdmin`
- `Developer`
- `Analyst`
- `Viewer`
- `Auditor`
- service principals for Web UI, MLflow proxy, execution adapters, docs serving, CI, and MCP tooling

## Capability families

- data and dataset operations
- training/experiment/run operations
- artifact/model/registry operations
- serving operations
- infrastructure operations
- observability operations
- governance/policy/audit operations
- cost/chargeback operations
- notebook execution operations

## Contract-relevant behavior

- Every privileged action should have a reconstructable audit trail.
- Policies should be environment-aware and topology-aware.
- Promotion, deployment, infra apply, and notebook execution are approval-sensitive operations.
- Assistant/MCP tooling should remain read-only by default.
- The page is a reference posture, not an implementation claim.

## Ownership

- Generated/maintained in the nbdev + Quarto docs stack.
- Should stay aligned with the security baseline, auth architecture decision, and gap analysis.
