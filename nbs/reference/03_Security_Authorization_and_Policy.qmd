---
title: "Security, Roles, and Policy"
---

# Security, Roles, and Policy

This page defines the reference **traditional authorization posture** for the ML Deploy stack.

The design is deliberately conservative:

- OIDC-backed authentication for humans
- scoped service identities for automation
- centralized policy decisions
- human RBAC plus capability catalogs
- audit trails for every privileged action

The goal is not to invent a new auth model. The goal is to describe the enterprise shape that fits this repository.

## Why this page exists

The repository already has:

- immutable notebook source-of-truth behavior
- Web UI-triggered execution contracts
- local, distributed, and cloud topology separation
- MLflow tracking and lineage
- governance gates for specification-first transitions

What was still missing was the **who may do what, under which conditions, and how is that decision enforced** narrative.

## Canonical posture

The reference posture is:

1. authenticate identities with OIDC
2. authorize requests centrally
3. keep authentication separate from authorization
4. use policy-as-code for privileged actions
5. audit every allow/deny and every sensitive mutation

That is the stack's traditional auth/roles/policy model.

## Identity classes

### Human identities

People use the platform directly as:

- ML engineer
- researcher
- platform engineer
- data engineer
- security admin
- auditor
- operator
- reviewer/approver

### Machine identities

Automation uses service principals such as:

- Web UI backend
- execution orchestrator
- local execution adapter
- Slurm submitter
- Kubernetes submitter
- MLflow proxy
- docs server
- CI/CD automation
- assistant/MCP tooling

Machine identities should be narrower than human identities and should not inherit broad ambient access by default.

## Core roles

The reference RBAC model stays small on purpose.

| Role | Intent | Typical powers |
|---|---|---|
| `SystemAdmin` | Full control / break-glass | all capabilities |
| `SecurityAdmin` | Identity, audit, policy | roles, policies, audit access |
| `PlatformAdmin` | Platform operations | envs, runtime settings, infra controls |
| `DataAdmin` | Data stewardship | datasets, schemas, lineage, quality |
| `ProjectAdmin` | Project control | runs, promotions, approvals |
| `Developer` | Build and test workflows | create and inspect non-prod work |
| `Analyst` | Read and analyze | experiments, models, runs, predictions |
| `Viewer` | Read-only | permitted summaries |
| `Auditor` | Compliance review | logs, decisions, evidence |

## Service principals

Machine identities should be expressed as narrowly scoped service principals:

| Service principal | Purpose | Scope |
|---|---|---|
| `webui-backend` | Request normalization and submission | notebook execution workflow only |
| `mlflow-proxy` | Enforce auth in front of MLflow | configured MLflow surfaces only |
| `execution-local` | Local runs | local execution only |
| `execution-slurm-submit` | Slurm job submission | submit/monitor approved jobs |
| `execution-k8s-submit` | Kubernetes job submission | approved jobs only |
| `docs-server` | Serve docs | read-only docs delivery |
| `ci-runner` | Repository automation | build/test scoped access |
| `mcp-readonly` | Assistant tooling | read-first unless elevated |

## Capability catalogs

Roles are useful, but the policy layer should also speak in capabilities.

### Capability families

- **Data**: `data.read`, `data.create`, `data.update`, `data.delete`, `data.lineage.read`, `data.quality.manage`
- **Training**: `experiment.read`, `experiment.create`, `run.submit`, `run.cancel`, `checkpoint.manage`
- **Artifacts**: `model.read`, `model.create`, `model.update`, `model.promote`, `model.rollback`
- **Serving**: `serving.read`, `serving.invoke`, `serving.deploy`, `serving.rollback`, `serving.manage`
- **Infrastructure**: `infra.read`, `infra.plan`, `infra.apply`, `infra.destroy`, `infra.secrets.manage`
- **Observability**: `observability.read`, `logs.read`, `metrics.read`, `alerts.manage`
- **Governance**: `policy.read`, `policy.update`, `approval.grant`, `approval.reject`, `audit.read`
- **Cost**: `cost.read`, `cost.export`, `budget.manage`, `chargeback.manage`
- **Notebook execution**: `notebook.read`, `notebook.execute.local`, `notebook.execute.slurm`, `notebook.execute.k8s`, `notebook.approve`

## Policy dimensions

A real decision should evaluate several dimensions together:

1. **Identity** — who is requesting the action?
2. **Resource** — what is being requested?
3. **Action** — what operation is being attempted?
4. **Environment** — local, dev, uat, regression, prod, Slurm, Kubernetes, docs
5. **Sensitivity** — public, internal, confidential, restricted
6. **Approval state** — none, pending, approved, rejected, break-glass
7. **Provenance** — commit SHA, approved ref, CI job, operator session, assistant session

That combination is more durable than a simple admin/non-admin split.

## Enforcement points

The policy posture must be enforced at the places where privileged action happens.

### Web UI and backend

The Web UI is the human-facing enforcement point. It should:

- authenticate through OIDC
- resolve roles and capabilities
- refuse unauthorized notebook execution
- include notebook revision and environment in context
- log every decision

### MLflow reverse proxy

MLflow should sit behind an auth-enforcing proxy.
The proxy should:

- validate the user
- inject the identity context downstream
- restrict registry and experiment actions by role
- preserve audit context

### Execution orchestrator

The orchestrator should validate policy before submission.
It should check:

- notebook revision approval
- environment allowance
- resource limits
- role/capability fit
- request provenance

### Slurm and Kubernetes submitters

Backend submitters should use narrow service identities.
They should only submit jobs that already passed policy checks upstream.

### Infrastructure apply path

Apply operations need stronger controls than normal runs.
Expect:

- elevated role or approval
- change-window or review context
- audit trail
- environment-scoped credentials

### Assistant and MCP tooling

Assistant tools should be read-only by default.
Any mutation must be:

- explicit
- attributable
- auditable
- narrowly scoped

## AWS / Floci-aligned implementation posture

For the gaps that map cleanly to AWS, prefer the services that Floci can emulate locally.

That usually means:

- OIDC at the edge for human auth
- IAM / STS for service identity and scoped execution
- Secrets Manager for runtime secrets
- S3 for artifacts and model packages
- PostgreSQL for MLflow backend state
- CloudWatch for logs, metrics, and alarms

### Consequences on other subsystems

- **Web UI**: must preserve principal identity and role/capability context.
- **Execution**: backend adapters should expect AWS-scoped credentials and object-store URLs.
- **Model registry**: version identity should remain tied to S3/PostgreSQL-backed storage.
- **Observability**: log/metric names should match between local emulation and cloud.
- **Infrastructure**: Terranix/OpenTofu should generate AWS resources that can be mirrored locally.
- **Governance**: approvals and audit trails should remain explicit and environment-scoped.

## Request lifecycle

A typical request should look boring:

1. authenticate the user
2. resolve the principal
3. derive roles and capabilities
4. validate the resource, action, and environment
5. evaluate policy
6. allow or deny
7. submit only if allowed
8. record the decision
9. record the downstream run or mutation

## Deny conditions

The default answer is no unless the policy grants the action.

Common deny reasons:

- missing authentication
- invalid or expired token
- role not present
- capability not granted
- notebook revision not approved
- target environment not allowed
- approval missing
- resource too sensitive
- provenance insufficient
- policy engine unavailable and the action is not on an explicit fail-open path

## Practical mapping to the stack

### Developer

Can usually:

- read notebook catalogs
- execute approved notebooks in local/dev scopes
- inspect their own runs

Cannot usually:

- mutate policy
- bypass approval gates
- write to production infra
- access restricted datasets without grant

### ProjectAdmin

Can usually:

- approve workflow transitions
- promote approved artifacts
- inspect project runs and models

Cannot usually:

- grant themselves unrestricted infra access
- bypass lineage or approval checks

### Auditor

Can usually:

- read historical decisions and logs
- export evidence
- review approvals and mutations

Cannot usually:

- change system state

## Environment posture

The same role should not imply the same power everywhere.

- **local/dev**: broader convenience, still policy-checked
- **uat/regression**: tighter promotion controls
- **prod**: strongest restrictions and explicit approvals

## What this page is not

This page is a reference posture, not an implementation claim.
It does **not** mean the repo already has:

- a complete IdP integration
- a policy engine wired into every path
- service-account plumbing everywhere
- audit sinks connected to every surface

Those remain implementation tasks and gap-analysis items.

## Summary

The stack's security model should remain:

- OIDC for identity
- RBAC for human intent
- service principals for automation
- central policy for authorization
- capability catalogs per subsystem
- least privilege by default
- environment-aware enforcement
- auditability for every privileged action

## Related pages

- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/decisions/security-authorization-architecture.md`
- `docs/wiki/gaps/software-stack-gaps.md`
- `docs/wiki/sources/nbs.reference.03_Security_Authorization_and_Policy.qmd.md`
