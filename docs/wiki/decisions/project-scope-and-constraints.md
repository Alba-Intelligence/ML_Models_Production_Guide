---
updated: 2026-05-11
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
7. MLflow is mandatory, with PostgreSQL backend store and S3 artifact store as the default production posture.
8. Local architecture should replicate production storage/control planes as closely as practical (for example PostgreSQL + S3-compatible storage such as MinIO).
9. Lambda.ai is the distributed compute platform in scope for training/inference coordination, using Slurm orchestration with redundancy/failure-handling patterns.
10. AWS hosts the remaining platform services with Kubernetes as the default control/deployment substrate.
11. A notebook Web UI is required for ML engineers to upload/select notebooks and trigger runs without editing notebook code.
12. Infrastructure should be managed through Nix-driven Terranix generation of OpenTofu JSON from both flake and devenv paths, with hand-written Terraform/OpenTofu minimized.
13. Security is a permanent requirement.
14. Data lineage is a permanent requirement.
15. Experiment traceability, model traceability, and reproducibility are permanent requirements.

## Audience and scope decisions

- Primary audience: **ML engineers in hedge funds**.
- Expected material depth: **architecture plus runnable end-to-end reference patterns**.
- Deployment scope must cover **all three**: distributed training, batch inference, and online inference.
- AWS coverage should use **full production patterns**.
- Lineage scope should cover **datasets, features/transformations, experiments, model artifacts, model versions, deployments, and operational runs where relevant**.
- MLflow persistence defaults to **PostgreSQL tracking backend + S3 artifact store** in production-oriented examples.
- Lambda.ai paths should model **Slurm coordination/redundancy** for distributed training/inference workloads.
- AWS platform examples should default to **Kubernetes-based operations** for non-Lambda.ai platform services.
- Local replica work should mirror the same architecture layers (Kubernetes/Slurm/storage/control planes) where feasible.
- Nix may assist with Docker generation, but Docker remains the primary reproducible development artifact.
- The default MCP scope includes MLflow, observability, AWS cost visibility, Lambda.ai usage visibility, infrastructure interrogation when infrastructure MCP servers are available, and documentation/decision retrieval.
- Infrastructure interrogation minimum coverage includes IaC plans/state, Kubernetes runtime state, Lambda.ai/Slurm runtime state, cloud resource inventory, and cost/usage signals.
- Default monitoring stack: Evidently + Prometheus + Grafana + MLflow.
- Default cost stack: AWS Cost Explorer / CUR / Athena / Budgets + Python attribution layer for Lambda.ai.

## Working mode decision

Default posture remains **specification-first** for architecture and documentation quality, and implementation should proceed only when spec quality gates are explicitly passed or the user explicitly authorizes a specific build slice.

Current active posture:

- specification and documentation quality improvement is the active priority
- implementation should remain gated behind explicit scope confirmation plus spec-quality readiness
- wiki synchronization remains mandatory with each substantive change

## Implications for future implementation

Any eventual implementation should be judged against these questions:

- Is it primarily Python-driven?
- Does it work on Linux?
- Does it support PyTorch with GPU?
- Does it preserve security expectations?
- Does it preserve data lineage?
- Does it improve reproducibility and traceability rather than weaken them?
- Does it fit the MLflow + PostgreSQL/S3 + Terranix/OpenTofu (flake+devenv) + Lambda.ai(Slurm) + AWS(Kubernetes) direction?

## Open items still requiring explicit agreement

- explicit spec-quality gate definition (pass criteria, approvers, and required pages/spec sections)
- exact notebook-promotion approval workflow from local validation to Lambda.ai/AWS execution
- normalized run-state contract across local, Slurm, and Kubernetes backends
- exact boundary between Nix-assisted generation and hand-authored Docker workflow in practice
- how to separate reusable platform guidance from hedge-fund-specific operating guidance
