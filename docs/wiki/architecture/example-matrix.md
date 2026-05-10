---
updated: 2026-05-10
summary: Example inventory mapped to lifecycle stages, domains, topologies, and contracts, with a defined first vertical slice.
read_when:
  - You are deciding what examples should exist before implementation
  - You want to avoid random tool demos and keep examples architecture-aligned
sources:
  - reference-architecture-skeleton.md
  - documentation-toc.md
  - ../contracts/index.md
  - ../domains/index.md
  - ../topologies/index.md
---

# Example matrix

## Purpose

Define the first-pass example inventory **before** implementation so examples remain architecture-aligned instead of becoming disconnected demos.

## Design rules

Every example should map to:

- one or more lifecycle stages
- one primary domain
- one reference topology
- explicit contracts consumed
- clear success criteria

## Proposed example inventory

### EX-01 — Local PyTorch training run with MLflow tracking

- lifecycle: experiment specification, training execution
- primary domain: training
- supporting domains: data, artifact
- topology: local development and single-node training
- contracts: data lineage, experiment traceability
- purpose: show the minimum viable training run with correct metadata and reproducibility context
- priority: **high**

### EX-02 — Model artifact packaging and version registration

- lifecycle: model packaging, model registration and promotion
- primary domain: artifact
- supporting domains: training, governance
- topology: local development and single-node training
- contracts: experiment traceability, model artifact
- purpose: show how a trained model becomes a traceable artifact and model version
- priority: **high**

### EX-03 — Local FastAPI serving of a registered model artifact

- lifecycle: local serving
- primary domain: serving
- supporting domains: artifact, security
- topology: local development and single-node training
- contracts: model artifact, prediction logging, security
- purpose: show the local inference contract without pretending to be production
- priority: **high**

### EX-04 — Distributed training job on Lambda.ai

- lifecycle: distributed training
- primary domain: training
- supporting domains: infrastructure, cost, artifact
- topology: distributed training on Lambda.ai
- contracts: experiment traceability, cost attribution, security
- purpose: show the remote/distributed training reference path with artifact recovery
- priority: **high**

### EX-05 — Batch inference job with lineage-preserving outputs

- lifecycle: batch inference
- primary domain: serving
- supporting domains: data, infrastructure, cost
- topology: batch inference on AWS-integrated infrastructure
- contracts: deployment, prediction logging, data lineage, cost attribution
- purpose: show offline scoring that preserves input/output provenance and cost visibility
- priority: **high**

### EX-06 — Online inference deployment with rollout metadata and rollback target

- lifecycle: online inference, deployment, rollback
- primary domain: serving
- supporting domains: governance, observability, artifact
- topology: online inference under production controls
- contracts: deployment, prediction logging, security, model artifact
- purpose: show a production-style online deployment model with explicit versioning and rollback context
- priority: **high**

### EX-07 — Monitoring pipeline for drift, service health, and model context

- lifecycle: monitoring and alerting
- primary domain: observability
- supporting domains: serving, artifact
- topology: batch and online topologies
- contracts: prediction logging, deployment, security
- purpose: show the accepted monitoring stack in a way that ties runtime signals to model/deployment context
- priority: **medium-high**

### EX-08 — Cost attribution report across AWS and Lambda.ai

- lifecycle: cost governance
- primary domain: cost
- supporting domains: training, infrastructure
- topology: distributed training and batch/online production topologies
- contracts: cost attribution, experiment traceability, deployment
- purpose: show the accepted cost stack and unified attribution story
- priority: **medium-high**

### EX-09 — Assistant-supported incident review workflow

- lifecycle: monitoring, incident response
- primary domain: observability
- supporting domains: governance, assistant integration
- topology: online inference under production controls
- contracts: prediction logging, deployment, security
- purpose: show how assistant tooling helps inspect metrics, deployments, and docs without becoming a shadow control plane
- priority: **medium**

### EX-10 — Optional FastAPI documentation delivery service

- lifecycle: documentation delivery
- primary domain: serving/documentation delivery
- supporting domains: governance, assistant integration
- topology: optional companion pattern
- contracts: security baseline where relevant
- purpose: show how markdown-in-git can be served with metadata/search/navigation while remaining non-canonical
- priority: **medium**

## Recommended implementation order

1. EX-01
2. EX-02
3. EX-03
4. EX-04
5. EX-05
6. EX-06
7. EX-07
8. EX-08
9. EX-09
10. EX-10

## First vertical slice definition

The first implementation-aligned slice is the composition **EX-01 -> EX-02 -> EX-03**.
See [first-vertical-slice.md](first-vertical-slice.md) for exact inputs, outputs, contract obligations, and success criteria.

## Rule

Do not add examples that are only tool showcases.
An example should exist because it proves part of the architecture, contracts, or topology design.
