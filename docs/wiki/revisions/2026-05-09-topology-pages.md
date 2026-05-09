---
updated: 2026-05-09
summary: Captures the first pass of reference topology pages derived from the architecture skeleton, domains, and contracts.
read_when:
  - You need provenance for the topology-planning layer
  - You want to know when the project moved from domain planning to deployment-shape planning
sources:
  - ../topologies/index.md
  - ../domains/index.md
  - ../contracts/index.md
---

# Revision: 2026-05-09 topology pages

## Trigger

Proceeding top-down, the next high-confidence step after the domain pages was to define the reference topology pages.

## Topology pages added

- `docs/wiki/topologies/index.md`
- `docs/wiki/topologies/local-development-and-single-node-training.md`
- `docs/wiki/topologies/distributed-training-on-lambda-ai.md`
- `docs/wiki/topologies/batch-inference-on-aws-integrated-infrastructure.md`
- `docs/wiki/topologies/online-inference-under-production-controls.md`

## What these pages establish

- the four major runtime shapes of the reference
- which domains are most active in each topology
- which contracts are most stressed in each topology
- what each topology is for and not for
- where assistant support is clearly high value

## Architectural effect

These pages make it easier to:

- keep local, distributed training, batch, and online concerns distinct
- place examples against realistic runtime shapes
- prevent production patterns from leaking into local convenience guidance
- prepare for decision records and example inventories

## Remaining lower-confidence follow-ons

- decision records for monitoring, cost, Docker/Nix, MCP default scope, and docs-delivery default scope
- code/example inventory mapped to the topologies
