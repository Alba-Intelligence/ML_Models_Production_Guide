---
updated: 2026-05-10
summary: Router for the reference topologies that map domains/contracts into concrete deployment shapes with explicit flow specs.
read_when:
  - You are deciding how a lifecycle/domain design becomes a runnable topology
  - You are comparing local, distributed training, batch, and online patterns
sources:
  - ../architecture/reference-architecture-skeleton.md
  - ../domains/index.md
  - ../contracts/index.md
---

# Topologies

## Purpose

These pages map the architecture into concrete deployment shapes.

They are where the project answers:

- which domains are active in a given runtime shape
- which contracts matter most in that shape
- what the operational boundaries are
- what is local-only vs production-like

## Topology pages

- [local-development-and-single-node-training.md](local-development-and-single-node-training.md) — Docker-based local iteration, local serving, and single-node GPU training.
- [distributed-training-on-lambda-ai.md](distributed-training-on-lambda-ai.md) — multi-GPU or multi-node remote training on Lambda.ai.
- [batch-inference-on-aws-integrated-infrastructure.md](batch-inference-on-aws-integrated-infrastructure.md) — scheduled or event-driven offline inference with strong lineage and cost controls.
- [online-inference-under-production-controls.md](online-inference-under-production-controls.md) — Kubernetes-based request/response serving under production deployment and observability controls.

## Rule

Topology pages should **implement** the architecture and contracts.
They should not redefine domain ownership or cross-cutting rules from scratch.
Each topology page should include explicit control/data/artifact flows and contract checkpoints.
