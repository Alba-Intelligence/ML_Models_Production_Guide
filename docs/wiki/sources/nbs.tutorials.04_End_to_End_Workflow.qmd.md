---
updated: 2026-05-16
summary: Compact end-to-end workflow tutorial for the EX-01 → EX-03 reference slice.
read_when:
  - You need the short workflow walkthrough instead of the long notebook
source_file: ../../nbs/tutorials/04_End_to_End_Workflow.qmd
sources:
  - ../architecture/first-vertical-slice.md
  - ../sources/ml_deploy.vertical_slice.py.md
---

# Source summary: nbs/tutorials/04_End_to_End_Workflow.qmd

## Role

Walks through the reference local workflow: prepare data, train with traceability, package the artifact, deploy locally, and log predictions.

## Main points

- each step preserves provenance and MLflow linkage
- the workflow is the minimum viable local lifecycle for the repo
- it is a reference slice, not the final production orchestration design

## Use when

- you need the end-to-end slice in one place
- you are checking whether a change still fits the lifecycle
