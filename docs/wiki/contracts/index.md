---
updated: 2026-05-10
summary: Router for the cross-cutting contracts that every domain, topology, and example must satisfy.
read_when:
  - You are defining or reviewing invariants used across the whole system
  - You are about to design domain pages, topology pages, or examples
sources:
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/documentation-toc.md
---

# Cross-cutting contracts

## Purpose

These contracts define the reusable invariants that every domain and topology must obey.

They exist to prevent:

- inconsistent security posture
- ad hoc lineage definitions
- incomplete traceability
- incompatible model packaging
- deployment ambiguity
- unusable prediction logs
- weak cost attribution

## Contracts

- [security-baseline.md](security-baseline.md) — identity, secrets, network, access, and audit minimums.
- [data-lineage-baseline.md](data-lineage-baseline.md) — required provenance and lineage fields for datasets and transformations.
- [experiment-traceability-baseline.md](experiment-traceability-baseline.md) — required metadata for experiments and training runs.
- [model-artifact-baseline.md](model-artifact-baseline.md) — minimum metadata and compatibility requirements for model artifacts.
- [deployment-baseline.md](deployment-baseline.md) — what every deployment record must capture.
- [prediction-logging-baseline.md](prediction-logging-baseline.md) — minimum logging requirements for batch and online inference.
- [cost-attribution-baseline.md](cost-attribution-baseline.md) — minimum tagging and attribution requirements for spend visibility.

## How to use these pages

- Domain pages should **consume** these contracts rather than redefining them.
- Topology pages should state how they **implement** these contracts.
- Code examples should state which contracts they satisfy and where they intentionally simplify.

## Enforcement matrix

Each contract must be treated as an interface with explicit ownership and validation points.

| Contract | Primary owner domain | Validation point(s) |
| --- | --- | --- |
| security baseline | governance | design review, deployment approval, incident review |
| data lineage baseline | data | dataset publish, transformation publish, training-job submission |
| experiment traceability baseline | training | training start/end, MLflow run checks, promotion gate |
| model artifact baseline | artifact | artifact packaging, model registration, serving compatibility checks |
| deployment baseline | serving + governance | rollout approval, deployment record creation, rollback readiness check |
| prediction logging baseline | serving + observability | pre-release checklist, runtime log schema checks, incident triage |
| cost attribution baseline | cost + infrastructure | infra provisioning, scheduled cost reports, budget alerting reviews |

## Rule

If a future page invents a new cross-cutting rule, either:

1. add it to an existing contract, or
2. create a new explicit contract page,

instead of burying it inside one domain or topology.
