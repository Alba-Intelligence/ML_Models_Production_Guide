---
updated: 2026-05-09
summary: Recommended top-down planning method to keep the project structured, avoid detail traps, and preserve separation of concerns.
read_when:
  - You are defining the documentation set
  - You want to sequence planning without getting lost in implementation detail
sources:
  - target-system.md
  - ../decisions/project-scope-and-constraints.md
---

# Top-down planning method

## Principle

To avoid getting lost, plan the project in **descending layers of commitment**.

Do not start with tools, folders, APIs, or scripts.
Start with:

1. mission
2. system boundaries
3. architectural domains
4. cross-cutting requirements
5. contracts between domains
6. only then examples and implementation artifacts

## Recommended planning stack

### Layer 1 — Mission and operating context

Define what the reference is for and for whom.

For this project, that means locking:

- audience: ML engineers in hedge funds
- scope: model development to distributed production
- outcome: documentation plus runnable reference patterns
- platform constraints: Python-first, Linux-only, PyTorch-only, GPU-capable

This layer prevents the rest of the project from drifting into generic MLOps material.

### Layer 2 — Lifecycle map

Define the major lifecycle stages before discussing implementation details.

Recommended canonical stages:

1. data intake and dataset versioning
2. feature / transformation pipeline
3. experiment execution
4. model training
5. evaluation and validation
6. packaging and registration
7. local serving
8. distributed training
9. batch inference
10. online inference
11. monitoring and alerting
12. cost governance
13. incident response and rollback

This becomes the backbone of the documentation set.

### Layer 3 — Architectural domains

Separate the system into domains with clear ownership boundaries.

Recommended domains:

- **Data domain** — datasets, schemas, lineage, retention, provenance
- **Training domain** — PyTorch training, GPU execution, distributed training, experiment config
- **Artifact domain** — model artifacts, metadata, registries, versioning, promotion
- **Serving domain** — FastAPI local serving, online inference contracts, batch jobs
- **Infrastructure domain** — python-terraform, Lambda.ai compute, AWS resources, networking
- **Observability domain** — metrics, logs, traces, drift, data quality, SLOs
- **Governance domain** — security, secrets, IAM, approvals, compliance posture, auditability
- **Cost domain** — provider billing, tagging, attribution, budgets, unit economics

Each domain should get its own page set. This is the main separation-of-concerns mechanism.

### Layer 4 — Cross-cutting requirements

Define these once and make every domain comply with them.

Permanent cross-cutting requirements for this project:

- security
- data lineage
- reproducibility
- experiment traceability
- model traceability

This avoids scattering security or lineage logic inconsistently across pages.

### Layer 5 — Canonical contracts

Before implementation, define the interfaces between domains.

Examples:

- what metadata every dataset version must expose
- what MLflow run metadata is mandatory
- what every model artifact must contain
- what deployment records must capture
- what prediction logs must retain for lineage and monitoring
- what cost tags must exist across Lambda.ai and AWS resources

These contracts are more important than early code structure.

### Layer 6 — Reference topologies

Define the major deployment shapes separately instead of mixing them.

Recommended topologies:

- **Topology A:** local development and single-node GPU training
- **Topology B:** distributed training on Lambda.ai
- **Topology C:** batch inference on AWS-integrated infrastructure
- **Topology D:** online inference with FastAPI-based serving behind production controls

Each topology should reuse the same domain contracts.

### Layer 7 — Documentation tree

Only after the above is stable, design the table of contents.

Recommended top-level document groups:

- 00-introduction and scope
- 01-reference architecture
- 02-data and lineage
- 03-training and experimentation
- 04-model packaging and registry
- 05-local serving
- 06-distributed training
- 07-batch inference
- 08-online inference
- 09-infrastructure and environment
- 10-security and governance
- 11-observability and monitoring
- 12-cost governance
- 13-operations, rollback, and incident response
- 14-code examples
- 15-decision records

### Layer 8 — Example matrix

Only here decide what code examples to build.

Examples should be organized by lifecycle stage and topology, not by random tool demos.

For each example, specify:

- purpose
- inputs/outputs
- dependencies
- security assumptions
- lineage implications
- reproducibility guarantees
- related docs pages

### Layer 9 — Decision records as checkpoint memory

Decision records are valuable, but they are **not** the primary architectural backbone.

Use them to record:

- why a major choice was made
- what alternatives were rejected
- what assumptions were in force
- what would trigger revisiting the decision

They are best understood as the project's **checkpoint memory layer**.
They improve restartability, but they do not replace:

- the architecture skeleton
- the documentation TOC
- the cross-cutting contracts
- the current-state and index pages

## Anti-patterns to avoid

- Starting with repository folders before defining domain boundaries
- Mixing training, serving, and infrastructure concerns in one page
- Mixing local dev guidance with production controls
- Letting tool choices substitute for architectural contracts
- Writing examples before metadata/lineage requirements are defined
- Treating monitoring as an afterthought instead of a first-class domain

## Best practical sequence from here

1. Freeze the **reference architecture skeleton**.
2. Freeze the **documentation table of contents**.
3. Freeze the **cross-cutting contracts** for security, lineage, traceability, and reproducibility.
4. Freeze the **reference topologies** for distributed training, batch inference, and online inference.
5. Record major accepted choices as **decision records**.
6. Only then define the **code-example inventory**.
7. Only after that begin implementation.

## Recommendation

The best way to stay top-down is to treat the project as three things at once, but in strict order:

1. a **lifecycle map**
2. a **set of bounded architectural domains**
3. a **catalog of reference topologies**

That ordering is what keeps details from leaking across concerns.

## Rule of thumb

If you want the project to be restartable at any time, the ideal stack is:

- architecture for structure
- contracts for invariants
- decision records for rationale
- current-state/log for recency

Decision records are therefore **essential**, but **not sufficient by themselves**.
