---
title: "Implementation Patterns: EX-01 → EX-03"
---

# Implementation Patterns: EX-01 → EX-03

This page is the compact reference for the first vertical slice. It explains the core patterns without duplicating the full implementation. The detailed code lives in:

- `ml_deploy/vertical_slice.py`
- `ml_deploy/webui_contracts.py`
- `ml_deploy/execution_backends.py`

## What the slice proves

The EX-01 → EX-03 slice demonstrates a complete path from training to deployment:

1. **EX-01** — train with traceability
2. **EX-02** — package and version the artifact
3. **EX-03** — run local deployment with prediction logging

The slice is intentionally small but production-shaped: every major artifact carries identity, version, and lineage metadata.

## Pattern 1: EX-01 training with traceability

EX-01 is the canonical training pattern.

### What it captures

- dataset version
- feature revision
- hyperparameters
- environment metadata
- metrics and model outputs
- MLflow run identity

### Minimal shape

```python
result = execute_first_vertical_slice(
    work_dir=Path("/tmp/experiment"),
    mlflow_config=resolve_mlflow_storage_config(profile="local_emulation"),
    run_name="baseline_experiment",
    experiment_config={
        "dataset_version": "v1.0",
        "feature_revision": "engineered_v2",
    },
)
```

### Practical rule

Keep the training step deterministic enough that a later reviewer can answer:

- what data was used
- what code revision ran
- what model was produced
- what metrics were recorded

## Pattern 2: EX-02 artifact bundling and versioning

EX-02 packages the trained output into a versioned artifact bundle.

### What it includes

- the trained model
- preprocessing state
- model-version metadata
- traceability links back to the training run

### Minimal shape

```python
bundle = register_model_artifact(
    artifact_bundle_path=result.artifact_path,
    model_name="reference_model",
    model_version="v1.0",
    description="Reference model bundle",
    run_id=result.run_id,
)
```

### Practical rule

Artifact metadata must be enough to reconstruct:

- which run created it
- which revision produced it
- which deployment record consumed it

## Pattern 3: EX-03 local deployment and serving

EX-03 is the local deployment pattern.

The reference stack keeps this framework-neutral: the page does not choose a web framework. Instead, it focuses on the serving contract.

### Core behavior

- load a packaged model
- accept an external prediction request
- validate input shape and provenance
- produce predictions
- log the request and response

### Minimal shape

```python
app = ServingApplication(title="ML Deploy Local Serving")

@app.route("POST", "/predict")
def predict(request: PredictionRequest):
    input_df = pd.DataFrame(request.data)
    result = model_serving.predict(input_df)
    prediction_logger.log_prediction(result, {"request_id": "generated_uuid"})
    return PredictionResponse(
        predictions=result["predictions"],
        model_version=result["model_version"],
        timestamp=result["timestamp"],
    )
```

### Practical rule

Prediction handling must preserve:

- model version
- request identity
- input shape or schema context
- result visibility links

## Pattern 4: prediction logging

Prediction logging is not an afterthought. It is part of the serving contract.

A valid prediction record should support later investigation of:

- what input arrived
- what model served it
- what output was returned
- how long it took
- whether the request was approved for that environment

## Pattern 5: workflow composition

The vertical slice is easiest to understand as a composition of the previous patterns:

1. train
2. package
3. serve locally
4. log the inference path

```python
training = execute_first_vertical_slice(...)
bundle = register_model_artifact(...)
serving = LocalModelServing(bundle)
```

That sequence is the canonical minimum viable ML lifecycle in this repository.

## Error handling and recovery

The patterns are intentionally conservative:

- bad inputs should fail early
- missing metadata should fail early
- deployment records should not be fabricated
- any unavailable resource should produce an explicit error

Do not silently continue when lineage or versioning information is missing.

## When to use these patterns

Use this page when you need to:

- implement or review the local vertical slice
- understand the minimum traceability requirements
- extend the slice into distributed or cloud topologies
- check whether a change still fits the reference workflow

## Not covered here

This page does **not** define:

- the complete API surface
- distributed scheduler clients
- cloud deployment orchestration
- notebook intake approvals
- auth/roles/policy

Those topics live in the other reference pages and wiki contracts.

## Related pages

- `nbs/reference/02_API_Documentation.qmd`
- `nbs/reference/03_Security_Authorization_and_Policy.qmd`
- `docs/wiki/architecture/first-vertical-slice.md`
- `docs/wiki/contracts/index.md`
