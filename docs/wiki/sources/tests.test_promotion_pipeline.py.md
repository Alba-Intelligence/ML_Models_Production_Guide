---
updated: 2026-05-12
summary: Tests for staged model promotion gate enforcement.
read_when:
  - You need to see what DEV/UAT/REGRESSION/PROD gates are executable today
source_file: ../../tests/test_promotion_pipeline.py
---

# Source summary: tests/test_promotion_pipeline.py

## Role

Validates stage-gate enforcement for `promote_model_artifact`.

## Coverage

- UAT requires smoke-test success
- REGRESSION requires UAT/data-leakage/metric checks
- PROD requires approval plus regression/security/pytorch optimization checks
