---
title: "Migration Guide"
---

# Migration Guide

This guide helps you map older notebook or serving patterns into the ML Deploy reference style.

The important thing is not to copy every old construct. The important thing is to keep the reference contracts intact:

- immutable notebook revisions
- explicit execution context
- MLflow-linked traceability
- versioned artifacts
- policy-aware promotion
- auditable serving and deployment actions

## What usually changes during migration

A legacy workflow often bundles too many concerns together.
The reference stack separates them into a small set of responsibilities:

1. notebook source and revision identity
2. training and experiment tracking
3. artifact packaging and versioning
4. serving and prediction logging
5. policy and approval boundaries
6. backend-specific execution adapters

## Migration targets

### Training code

Replace ad hoc training scripts with the reference training slice or an equivalent traced workflow.

What to keep:

- model code
- dataset handling
- metrics
- reproducible configuration

What to add:

- MLflow run identity
- dataset version metadata
- feature revision metadata
- artifact lineage links

### Serving code

Older serving code often hardcodes a specific web stack.

The reference stack does not require that.
Instead, keep the serving layer framework-neutral and focus on the contract:

- input validation
- model loading
- prediction logging
- response shaping
- request provenance

### Deployment code

Old deployment code often mixes artifact creation with environment mutation.

The reference model separates them:

- artifact creation happens first
- environment submission happens later
- approval gates sit in between when needed

## Practical migration checklist

Use this checklist when porting old work into the reference stack:

- [ ] identify the notebook revision or source commit
- [ ] make input data/version explicit
- [ ] separate training from packaging
- [ ] ensure the artifact has a stable version identity
- [ ] ensure serving logs predictions
- [ ] ensure promotion decisions are auditable
- [ ] ensure environment-specific credentials are not embedded in source
- [ ] ensure the workflow still reads cleanly in the docs

## Common migration patterns

### Pattern A: single script to reference workflow

Legacy:

- one file trains, saves, serves, and deploys

Reference:

- one notebook trains
- one bundle packages the model
- one serving path loads the bundle
- one policy layer controls promotion

### Pattern B: hardcoded environment to declared topology

Legacy:

- local paths and production paths are mixed together

Reference:

- topology is declared explicitly
- local, Slurm, Kubernetes, and batch paths stay separate

### Pattern C: implicit access to explicit policy

Legacy:

- access is assumed because a user is “trusted”

Reference:

- access is checked against role and capability policy
- privileged actions are audited

## Source mapping

When migrating, these source files are the most useful anchors:

- `ml_deploy/vertical_slice.py`
- `ml_deploy/webui_contracts.py`
- `ml_deploy/execution_backends.py`
- `ml_deploy/governance_gates.py`
- `nbs/reference/01_Implementation_Patterns.qmd`
- `nbs/reference/02_API_Documentation.qmd`
- `nbs/reference/03_Security_Authorization_and_Policy.qmd`

## When to stop migrating

Stop when the reference contracts are clear and the remaining work is clearly topology-specific.
At that point, you should not keep reshaping the reference stack to fit the legacy design.

## Practical summary

The migration goal is simple:

- keep the useful model code
- discard the tangled coupling
- preserve traceability
- preserve policy
- preserve topology boundaries
