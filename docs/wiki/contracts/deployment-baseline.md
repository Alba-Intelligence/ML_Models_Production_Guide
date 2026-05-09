---
updated: 2026-05-09
summary: Minimum data every deployment record must capture for traceability, rollback, and incident analysis.
read_when:
  - You are defining batch or online deployment behavior
  - You are deciding what deployment metadata is mandatory
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
---

# Deployment baseline

## Purpose

Define what every deployment record must capture so that model releases are attributable, reviewable, and reversible.

## Applies to

- online inference deployments
- batch inference release configurations
- documentation delivery deployments where operational auditability matters

## Every deployment must define

- deployment identifier
- deployed model version
- target environment
- infrastructure revision
- deployment timestamp
- deployment actor/owner
- rollout strategy
- rollback target
- monitoring configuration
- approval state or release gate result

## Additional required context

Each deployment record should also make it possible to identify:

- service or batch surface affected
- environment-specific configuration bundle
- linked incident/change ticket if required by policy
- responsible team/contact

## Mandatory rules

- No production deployment without a clearly identified model version.
- No deployment without a rollback target or an explicit reason no rollback exists.
- Monitoring configuration must be attached to the deployment record, not implied.
- Deployment records must link infrastructure state/revision to model state/revision.
- Online and batch deployment records may differ in shape, but both must preserve traceability and rollback semantics.

## Relationship to other contracts

- consumes [model-artifact-baseline.md](model-artifact-baseline.md)
- feeds [prediction-logging-baseline.md](prediction-logging-baseline.md)
- informs [cost-attribution-baseline.md](cost-attribution-baseline.md)
- reinforces [security-baseline.md](security-baseline.md)

## Assistant implications

Assistant tooling should be able to answer:

- what is deployed right now?
- what model version changed in the last rollout?
- what rollback target exists?
- which monitoring configuration should be checked first after a deployment?

## Open decisions

- exact representation of deployment records
- exact promotion-to-deployment approval flow
- exact deployment metadata location and query surface
