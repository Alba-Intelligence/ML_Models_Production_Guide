---
updated: 2026-05-10
summary: Synthesized summary of the local first-vertical-slice implementation module.
read_when:
  - You are implementing or debugging EX-01/EX-02/EX-03 locally
  - You need the concrete metadata and record shapes emitted by code
source_file: ../../ml_deploy/vertical_slice.py
---

# Source summary: ml_deploy/vertical_slice.py

## Role

`ml_deploy/vertical_slice.py` is the concrete local implementation for the first architecture slice:

- EX-01 local training + MLflow traceability
- EX-02 artifact packaging + model-version record
- EX-03 local FastAPI prediction path + prediction logging

## Main functions

- `generate_synthetic_dataset` — deterministic synthetic training data generation.
- `prepare_training_data` — split + scale pipeline.
- `train_with_traceability` — MLflow-tracked training with required lineage/traceability params.
- `package_and_register_model` — writes model/scaler bundle and artifact/model-version metadata.
- `create_local_deployment_record` — writes deployment record JSON for local serving.
- `create_prediction_app` — FastAPI app exposing `/healthz` and `/predict`, writing JSONL prediction logs.
- `execute_first_vertical_slice` — orchestration helper that runs the whole local flow.

## Records emitted

- `artifact_metadata.json`
- `model_version.json`
- `deployment_record.json`
- `prediction_logs.jsonl`

## Contract-relevant behavior

- Training records capture dataset/transformation/code/container/compute metadata.
- Artifact records capture run origin, schemas, serving modes, and evaluation summary.
- Deployment records capture model version, rollout metadata, and monitoring config reference.
- Prediction logs capture request identifier, model version, deployment identifier, schema reference, and runtime metadata.
