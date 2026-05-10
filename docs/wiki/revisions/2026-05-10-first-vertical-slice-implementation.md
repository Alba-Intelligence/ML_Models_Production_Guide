---
updated: 2026-05-10
summary: Captures implementation of the first local vertical slice (EX-01 -> EX-03) and its tests.
read_when:
  - You need provenance for the first concrete implementation pass
  - You are extending the slice into Docker or production topologies
sources:
  - ../../ml_deploy/vertical_slice.py
  - ../../tests/test_vertical_slice.py
  - ../architecture/first-vertical-slice.md
  - ../sources/ml_deploy.vertical_slice.py.md
---

# Revision: 2026-05-10 first vertical-slice implementation

## Trigger

The architecture write-up had been ratified and the next required step was to implement the first concrete end-to-end slice rather than planning further.

## What was implemented

1. Added `ml_deploy/vertical_slice.py` with local implementations for:
   - EX-01 training with MLflow traceability metadata
   - EX-02 model/scaler artifact bundle + model-version record
   - EX-03 local deployment record + FastAPI `/predict` endpoint + prediction JSONL logging
2. Added `tests/test_vertical_slice.py` with end-to-end checks for:
   - required output records and linkage fields
   - prediction log linkage to model version and deployment
3. Updated dependencies in `pyproject.toml` to support local serving tests.

## Result

- The repository now has a concrete executable local slice aligned with `architecture/first-vertical-slice.md`.
- Contract-relevant metadata and linkages are verified by automated tests for this local slice.
- Broader topology implementations (distributed/batch/online production) remain future work.
