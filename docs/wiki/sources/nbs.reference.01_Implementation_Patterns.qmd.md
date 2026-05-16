---
updated: 2026-05-16
summary: Compact implementation-patterns reference for the EX-01 → EX-03 slice, focused on training, artifact bundling, and framework-neutral local serving.
read_when:
  - You are implementing the first vertical slice
  - You need the compact pattern summary instead of the full notebook source
source_file: ../../nbs/reference/01_Implementation_Patterns.qmd
sources:
  - ../architecture/first-vertical-slice.md
  - ../sources/ml_deploy.vertical_slice.py.md
  - ../sources/ml_deploy.execution_backends.py.md
---

# Source summary: nbs/reference/01_Implementation_Patterns.qmd

## Role

Compact reference for the first vertical slice patterns:

- EX-01 training with traceability
- EX-02 artifact bundling and versioning
- EX-03 framework-neutral local serving

## Main points

- Training should capture dataset version, feature revision, hyperparameters, metrics, and MLflow run identity.
- Artifact bundles should preserve version identity and links back to the producing run.
- Local serving should remain framework-neutral and focus on request handling, prediction logging, and model-version visibility.
- Prediction logging is part of the serving contract.
- The page now intentionally stays short and points readers to the implementation modules for details.

## Use when

- you want the compact explanation of the first slice
- you need to understand what the patterns are responsible for
- you want to avoid reading the implementation modules unless necessary
