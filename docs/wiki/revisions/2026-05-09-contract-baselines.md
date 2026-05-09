---
updated: 2026-05-09
summary: Captures the first pass of cross-cutting contract pages for the reference architecture.
read_when:
  - You need provenance for the current contract drafts
  - You want to know which invariants were frozen before domain pages were written
sources:
  - ../contracts/index.md
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/documentation-toc.md
---

# Revision: 2026-05-09 contract baselines

## Trigger

Proceeding top-down, the next agreed planning step was to define the cross-cutting contracts before writing domain pages or implementation code.

## Contract pages added

- `docs/wiki/contracts/index.md`
- `docs/wiki/contracts/security-baseline.md`
- `docs/wiki/contracts/data-lineage-baseline.md`
- `docs/wiki/contracts/experiment-traceability-baseline.md`
- `docs/wiki/contracts/model-artifact-baseline.md`
- `docs/wiki/contracts/deployment-baseline.md`
- `docs/wiki/contracts/prediction-logging-baseline.md`
- `docs/wiki/contracts/cost-attribution-baseline.md`

## What these pages establish

- a minimum security posture
- dataset and transformation lineage requirements
- experiment and training traceability requirements
- model artifact and model-version metadata requirements
- deployment-record requirements
- prediction logging requirements for batch and online inference
- cost attribution and tagging requirements

## Architectural effect

These contracts are intended to be consumed by:

- future domain pages
- future topology pages
- future code examples
- future assistant/MCP integration designs

## Remaining work

- review and revise the contract pages as needed
- create domain pages that consume the contracts
- create topology pages that implement the contracts
- turn key open questions into explicit decision records where needed
