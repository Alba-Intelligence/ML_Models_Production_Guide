---
updated: 2026-05-09
summary: Data domain responsibilities for datasets, schemas, provenance, and transformation lineage.
read_when:
  - You are defining data inputs, schemas, or transformation behavior
  - You are deciding where data concerns stop and training concerns begin
sources:
  - index.md
  - ../contracts/data-lineage-baseline.md
  - ../contracts/security-baseline.md
  - ../architecture/reference-architecture-skeleton.md
---

# Data domain

## Owns

- data intake
- dataset versioning
- schema evolution
- provenance capture
- retention expectations
- data quality gates
- transformation lineage boundaries

## Does not own

- model training logic
- serving runtime behavior
- infrastructure provisioning details
- cost policy beyond providing data needed for attribution

## Lifecycle coverage

Primary coverage:
- data intake and dataset versioning
- feature / transformation definition
- evaluation data inputs
- batch input/output provenance where derived data is produced

## Contracts consumed

- [../contracts/data-lineage-baseline.md](../contracts/data-lineage-baseline.md)
- [../contracts/security-baseline.md](../contracts/security-baseline.md)

## Topology relevance

- Topology A: local development and single-node training
- Topology B: distributed training on Lambda.ai
- Topology C: batch inference on AWS-integrated infrastructure
- Topology D: online inference where schema compatibility matters

## Key questions this domain must answer

- What is a dataset version?
- How are schemas versioned?
- How are transformations tied to upstream inputs?
- How do training and inference paths know they are using compatible data definitions?

## Assistant implications

Useful assistant capabilities here include:
- identifying missing dataset/version references
- surfacing schema mismatches
- tracing upstream/downstream lineage for a run or deployment

## Open decisions

- exact dataset version identifier format
- exact schema registry or schema-management approach
- exact data-quality gate posture across topologies
