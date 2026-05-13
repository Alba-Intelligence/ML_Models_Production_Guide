---
updated: 2026-05-09
summary: Minimum security requirements that every workload, topology, and operational path must satisfy.
read_when:
  - You are designing any workload or service
  - You are deciding what security fields and controls are mandatory
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
  - ../decisions/project-scope-and-constraints.md
---

# Security baseline

## Purpose

Define the minimum security posture for all workloads in the reference.

Security is a permanent requirement, not a later hardening task.

## Applies to

- local development environments
- distributed training jobs
- batch inference jobs
- online inference services
- documentation delivery services
- assistant/MCP integrations

## Every workload must define

1. **Identity boundary**
   - which identity executes the workload
   - what role/account/service principal it uses
   - what it is explicitly allowed to access

2. **Secret source**
   - where secrets come from
   - how they are injected
   - whether they are rotated and by whom

3. **Network boundary**
   - which network segment/subnet it runs in
   - what inbound traffic is allowed
   - what outbound destinations are allowed

4. **Access scope**
   - data stores accessible
   - artifact stores accessible
   - observability systems accessible
   - control-plane APIs accessible

5. **Audit trail location**
   - where authentication, deployment, and privileged actions are recorded
   - how investigators can link actions to actors

## Mandatory rules

- Use **least privilege** by default.
- No plaintext secrets in source control.
- Environment boundaries must be explicit: at minimum dev vs non-dev, and preferably dev/staging/prod.
- Production-serving and documentation-serving surfaces must be logically separated even if they share FastAPI.
- Assistant integrations should be **read-only by default**.
- Any assistant-triggered mutation must be attributable to a user/session and guarded by explicit confirmation.
- Remote training and batch jobs must not inherit broad ambient permissions without written justification.

## Required security metadata

Each design page or implementation pattern should declare:

- runtime identity
- secret dependencies
- network assumptions
- privileged operations
- audit log destination
- approval boundary if mutation/promotion is involved

## Authorization baseline

Every system and subsystem must declare:

- which capabilities it exposes
- which roles may request those capabilities
- which central authority validates the request

Accepted reference posture:

- OIDC-backed identity provider for authentication
- centralized policy engine for authorization decisions
- capability catalogs defined per system and subsystem
- auditable request validation for every privileged action

Compatible solution families:

1. OIDC IdP + centralized policy engine, with systems/subsystems publishing capabilities to the policy layer
2. Cloud IAM federation + centralized policy engine for cloud-facing infrastructure controls
3. IdP-managed RBAC only for smaller/internal surfaces, if the policy surface stays simple enough

The first option is the recommended fit for this MLOps architecture.

## Domain implications

### Training
- access to datasets, artifact stores, and experiment tracking must be explicit
- distributed jobs must declare remote secret handling and node trust assumptions

### Serving
- request surface, auth posture, and model/artifact access must be explicit
- prediction logging must not leak protected inputs by default

### Documentation delivery
- docs serving is lower-risk than model serving, but still requires explicit auth posture if any private/internal material exists
- editing helpers, if added later, require stronger write-path controls than read-only serving

### Assistant integration
- MCP connectors should use narrowly scoped credentials
- assistant tools should not be given unbounded cloud write access
- every write-capable tool requires auditability and confirmation boundaries

## Minimum review questions

- What identity runs this component?
- What secret sources does it depend on?
- What can it reach on the network?
- What can it mutate?
- Where would an auditor look to reconstruct privileged actions?

## Open decisions

- exact IAM bindings by environment
- exact secret-management stack
- exact network segmentation model on AWS and Lambda.ai-connected workflows
