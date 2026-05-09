---
updated: 2026-05-09
summary: Governance domain responsibilities for security policy, approvals, auditability, IAM, and compliance boundaries.
read_when:
  - You are defining controls, approvals, or audit expectations
  - You are deciding where governance stops and domain implementation begins
sources:
  - index.md
  - ../contracts/security-baseline.md
  - ../contracts/deployment-baseline.md
  - ../architecture/reference-architecture-skeleton.md
---

# Governance domain

## Owns

- security policy interpretation
- IAM and access policy guidance
- approval boundaries
- auditability requirements
- promotion/deployment governance checkpoints
- least-privilege expectations

## Does not own

- training algorithm design
- serving request semantics
- monitoring implementation details
- cost dashboards themselves

## Lifecycle coverage

Cross-cutting, but especially relevant to:
- model registration and promotion
- deployment
- assistant integration
- documentation delivery if write paths exist
- incident review and audit trails

## Contracts consumed

- [../contracts/security-baseline.md](../contracts/security-baseline.md)
- [../contracts/deployment-baseline.md](../contracts/deployment-baseline.md)
- [../contracts/model-artifact-baseline.md](../contracts/model-artifact-baseline.md)

## Topology relevance

- all topologies

## Key questions this domain must answer

- What requires explicit approval?
- Which identities and boundaries are permitted in each environment?
- What must be auditable for training, deployment, assistant activity, and docs delivery?
- What governance expectations are hedge-fund-specific vs reusable?

## Assistant implications

Useful assistant capabilities here include:
- checking whether a workflow appears to violate declared policy
- identifying missing audit hooks or approval records
- surfacing least-privilege gaps in proposed patterns

## Open decisions

- exact approval workflow for promotion/deployment
- exact audit evidence requirements
- exact hedge-fund-specific governance overlays to include in the reference
