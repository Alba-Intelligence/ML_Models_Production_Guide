---
updated: 2026-05-09
summary: Router for the bounded domains used by the reference architecture.
read_when:
  - You are designing domain-specific guidance
  - You are deciding where a responsibility belongs
sources:
  - ../architecture/reference-architecture-skeleton.md
  - ../contracts/index.md
---

# Domains

## Purpose

These pages turn the architecture skeleton's bounded domains into more explicit planning surfaces.

Each domain page should answer:

- what this domain owns
- what it explicitly does not own
- which lifecycle stages it covers
- which contracts it consumes
- which topologies it is most relevant to
- what open questions remain

## Domain pages

- [data-domain.md](data-domain.md) — datasets, schemas, provenance, and transformation lineage.
- [training-domain.md](training-domain.md) — PyTorch training, GPU execution, distributed training behavior, and experiment traceability.
- [artifact-domain.md](artifact-domain.md) — model packaging, registry, versioning, and promotion.
- [serving-domain.md](serving-domain.md) — local serving, batch/online inference contracts, and rollout behavior.
- [infrastructure-domain.md](infrastructure-domain.md) — AWS, Lambda.ai, networking, storage, and Terranix/OpenTofu generation workflows.
- [observability-domain.md](observability-domain.md) — metrics, logs, traces, drift, quality, and alerting.
- [governance-domain.md](governance-domain.md) — security, approvals, auditability, IAM, and policy boundaries.
- [cost-domain.md](cost-domain.md) — spend attribution, reporting, budgets, and unit economics.

## Rule

If a responsibility is ambiguous, resolve it here before turning it into examples or implementation structure.
