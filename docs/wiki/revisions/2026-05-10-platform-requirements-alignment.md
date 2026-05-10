---
updated: 2026-05-10
summary: Aligns architecture/decision docs to the new platform requirements for storage, orchestration, deployment substrate, and notebook execution UX.
read_when:
  - You need provenance for current non-negotiable platform requirements
  - You are implementing infrastructure or topology pages after requirement updates
sources:
  - ../decisions/project-scope-and-constraints.md
  - ../architecture/target-system.md
  - ../architecture/reference-architecture-skeleton.md
  - ../topologies/local-development-and-single-node-training.md
  - ../topologies/distributed-training-on-lambda-ai.md
  - ../topologies/batch-inference-on-aws-integrated-infrastructure.md
  - ../topologies/online-inference-under-production-controls.md
---

# Revision: 2026-05-10 platform requirements alignment

## Trigger

Additional non-negotiable requirements were provided for storage, orchestration, deployment substrate, local parity, notebook execution UX, and IaC authoring workflow.

## Requirements encoded

1. MLflow default storage posture: PostgreSQL backend store + S3 artifact store.
2. Lambda.ai distributed workloads: Slurm coordination/redundancy patterns for training/inference.
3. AWS platform posture: Kubernetes for non-Lambda.ai platform services.
4. Local architecture should replicate production control/storage layers as closely as practical.
5. Notebook Web UI should support engineer notebook upload/selection and trigger execution without notebook source mutation.
6. Infrastructure should be managed via Python-driven Terraform workflows with hand-written Terraform minimized.

## Pages updated

- `decisions/project-scope-and-constraints.md`
- `architecture/target-system.md`
- `architecture/reference-architecture-skeleton.md`
- `domains/serving-domain.md`
- `topologies/index.md`
- `topologies/local-development-and-single-node-training.md`
- `topologies/distributed-training-on-lambda-ai.md`
- `topologies/batch-inference-on-aws-integrated-infrastructure.md`
- `topologies/online-inference-under-production-controls.md`
- `architecture/example-matrix.md`
- `architecture/notebook-repository-web-ui.md`
- `decisions/documentation-delivery-decision.md`
- `architecture/assistant-integration-and-docs-delivery.md`
- `overview.md`
- `current-state.md`

## Outcome

The active architecture baseline is now aligned with the updated infrastructure and execution requirements while preserving the nbdev-first, specification-led repository posture.
