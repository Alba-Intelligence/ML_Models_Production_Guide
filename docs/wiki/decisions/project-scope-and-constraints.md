---
updated: 2026-05-09
summary: Current agreed purpose, constraints, and planning-phase rules for the project.
read_when:
  - You are deciding whether proposed work fits scope
  - You are about to implement anything substantial
sources:
  - ../architecture/target-system.md
  - ../current-state.md
---

# Project scope and constraints

## Current purpose

The project is intended to become an **extensive reference documentation set with code examples** covering the path from model development to distributed production.

## Hard constraints

1. Prefer Python to the maximum extent possible.
2. Linux only.
3. PyTorch only for model definition/training.
4. GPU support is required.
5. Reproducible development uses Docker.
6. Docker files must be written explicitly even if Nix helps generate/support them.
7. FastAPI is the local development / local serving framework.
8. MLflow is part of the core stack.
9. `python-terraform` is part of the infrastructure story.
10. Lambda.ai is the distributed compute platform in scope.
11. AWS is the tooling / production platform in scope.
12. Security is a permanent requirement.
13. Data lineage is a permanent requirement.
14. Experiment traceability, model traceability, and reproducibility are permanent requirements.

## Audience and scope decisions

- Primary audience: **ML engineers in hedge funds**.
- Expected material depth: **architecture plus runnable end-to-end reference patterns**.
- Deployment scope must cover **all three**: distributed training, batch inference, and online inference.
- AWS coverage should use **full production patterns**.
- Lineage scope should cover **datasets, features/transformations, experiments, model artifacts, model versions, deployments, and operational runs where relevant**.
- Nix may assist with Docker generation, but Docker remains the primary reproducible development artifact.
- The default MCP scope includes MLflow, observability, AWS cost visibility, Lambda.ai usage visibility, and documentation/decision retrieval.
- FastAPI documentation delivery is accepted as an optional companion pattern if markdown-in-git remains canonical.
- Default monitoring stack: Evidently + Prometheus + Grafana + MLflow.
- Default cost stack: AWS Cost Explorer / CUR / Athena / Budgets + Python attribution layer for Lambda.ai.

## Working mode decision

The project is currently in a **specification-first phase**.

Until the user explicitly says otherwise:

- do **not** write implementation code
- prefer specification, structure, tradeoff analysis, and documentation planning
- identify ambiguities before selecting concrete implementations

## Implications for future implementation

Any eventual implementation should be judged against these questions:

- Is it primarily Python-driven?
- Does it work on Linux?
- Does it support PyTorch with GPU?
- Does it preserve security expectations?
- Does it preserve data lineage?
- Does it improve reproducibility and traceability rather than weaken them?
- Does it fit the FastAPI + MLflow + python-terraform + Lambda.ai + AWS direction?

## Open items still requiring explicit agreement

- approval or revision of the proposed reference architecture skeleton
- approval or revision of the proposed documentation TOC
- approval or revision of the first-pass cross-cutting contracts
- approval or revision of the first-pass bounded domain pages
- approval or revision of the first-pass topology pages
- exact boundary between Nix-assisted generation and hand-authored Docker workflow in practice
- how to separate reusable platform guidance from hedge-fund-specific operating guidance
