---
updated: 2026-05-10
summary: Synthesized summary of tests validating the local first-vertical-slice behavior.
read_when:
  - You need to understand what the current vertical-slice tests guarantee
source_file: ../../tests/test_vertical_slice.py
---

# Source summary: tests/test_vertical_slice.py

## Role

`tests/test_vertical_slice.py` validates the local EX-01/EX-02/EX-03 implementation behavior.

## What is covered

1. End-to-end local orchestration writes required files and core metadata:
   - model/scaler bundle
   - artifact metadata
   - model-version record
   - deployment record
2. Artifact and deployment records include contract-critical linkage fields.
3. Local prediction helper writes JSONL logs linking:
   - request identifier
   - model version
   - deployment identifier
   - runtime metadata

## What is intentionally not covered yet

- Dockerized execution of the slice
- distributed training topology behavior
- AWS-integrated batch/online rollout behavior
