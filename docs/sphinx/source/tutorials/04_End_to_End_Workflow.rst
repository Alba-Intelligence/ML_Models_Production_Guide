---
title: "End-to-End ML Workflow"
---

# End-to-End ML Workflow

This tutorial shows the complete reference workflow in compact form.
It connects the conceptual lifecycle to the actual implementation slice.

## The workflow in one sentence

Prepare data, train with traceability, package the artifact, serve locally, and log every prediction.

## Workflow overview

The repository uses the EX-01 → EX-02 → EX-03 sequence:

1. **EX-01** — training with traceability
2. **EX-02** — artifact bundling and versioning
3. **EX-03** — local deployment and serving

That is the minimum end-to-end path the stack promises today.

## Prerequisites

Before following the workflow, you should have:

- the dev shell available
- the notebook source checked out
- MLflow storage configured for the selected profile
- a mental model of the contracts in the reference pages

## Step 1: prepare the data

The data step should produce a stable, reproducible split with version metadata.

Key outputs:

- train/test split
- preprocessing state
- dataset version
- lineage metadata

The exact mechanics are intentionally delegated to the implementation notebook and the slice module.

## Step 2: train with traceability

The training step should record:

- code revision
- dataset version
- feature revision
- hyperparameters
- metrics
- MLflow run identity

A minimal call shape looks like this:

```python
result = execute_first_vertical_slice(
    work_dir=Path("/tmp/experiment"),
    mlflow_config=resolve_mlflow_storage_config(profile="local_emulation"),
    run_name="workflow_baseline",
    experiment_config={"dataset_version": "v1.0"},
)
```

The important part is not the code fragment itself; it is the metadata discipline.

## Step 3: package the artifact

After training, the model must be packaged into a deployable bundle.

A valid bundle should include:

- model serialization
- preprocessing state
- version identity
- traceability links to the run

```python
bundle = register_model_artifact(
    artifact_bundle_path=result.artifact_path,
    model_name="workflow_model",
    model_version="v1.0",
    description="Workflow model bundle",
    run_id=result.run_id,
)
```

## Step 4: deploy locally

The local deployment path proves that the bundle can be loaded and used for inference.

The serving path should:

- load the bundle
- accept a prediction request
- return predictions
- log the request and response

```python
serving = LocalModelServing(bundle)
```

## Step 5: log predictions

Prediction logging is part of the workflow, not an optional add-on.

A prediction record should make it possible to answer:

- what input arrived?
- which model served it?
- when did it happen?
- what came out?

## Step 6: inspect the result

The end-to-end path should leave behind a small set of inspectable artifacts:

- MLflow run record
- model artifact bundle
- deployment record
- prediction log
- provenance links tying them together

## What this workflow is for

Use this workflow to:

- validate a local implementation
- explain the first vertical slice to a new contributor
- check that a new feature still preserves the lifecycle
- build a benchmark before moving to distributed or cloud topologies

## What it is not

This is not the final production orchestration design.
It is the reference local slice that later topologies should preserve.

## Operational rules

A workflow step should fail rather than guess if:

- a revision is missing
- metadata is missing
- the bundle cannot be loaded
- the environment is wrong
- approval is missing

## Related docs

- `nbs/tutorials/03_Concepts_and_Architecture.rst`
- `nbs/reference/01_Implementation_Patterns.rst`
- `nbs/reference/02_API_Documentation.rst`
- `docs/wiki/architecture/first-vertical-slice.md`
