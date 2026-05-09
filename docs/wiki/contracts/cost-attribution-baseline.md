---
updated: 2026-05-09
summary: Minimum tagging and attribution requirements for cost visibility across training, batch inference, and online inference.
read_when:
  - You are defining cost visibility or spend attribution
  - You are deciding what metadata every resource must carry
sources:
  - index.md
  - ../architecture/reference-architecture-skeleton.md
---

# Cost attribution baseline

## Purpose

Define the minimum metadata and tagging requirements required to understand cost by environment, workload, run, model, or deployment.

## Applies to

- training compute
- batch inference compute
- online inference infrastructure
- shared storage and supporting cloud resources where attribution matters
- Lambda.ai and AWS resources in scope for the reference

## Every attributable resource/workload must define

- environment
- workload type
- owning system/domain
- experiment/job/deployment linkage
- provider-specific tags/labels required for billing visibility

## Recommended attribution dimensions

The reference should make it possible to group spend by:

- environment
- topology
- training run or experiment group
- batch job
- deployment/service
- model version
- provider
- team or owner

## Mandatory rules

- Cost attribution must be designed up front, not retrofitted after spend grows.
- Every major topology must define where billing data comes from and how it is joined back to runs, jobs, or deployments.
- Resources without attribution tags/labels should be considered non-compliant.
- Cross-provider cost visibility must be possible at least at the reporting layer, even if collection mechanisms differ.

## Relationship to other contracts

- consumes [experiment-traceability-baseline.md](experiment-traceability-baseline.md)
- consumes [deployment-baseline.md](deployment-baseline.md)
- consumes [prediction-logging-baseline.md](prediction-logging-baseline.md) when runtime usage helps unit-economics analysis

## Assistant implications

Assistant tooling should be able to answer:

- what caused a cost spike?
- which training run or deployment is most expensive?
- which resources are missing attribution tags?
- how do batch and online inference compare on unit economics?

## Open decisions

- exact AWS tag schema
- exact Lambda.ai usage/billing ingestion path
- exact unit-economics metrics to standardize across examples
