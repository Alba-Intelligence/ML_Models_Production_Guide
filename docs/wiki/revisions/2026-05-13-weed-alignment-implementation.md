---
title: "Weed alignment implementation closure"
date: 2026-05-13
summary: "Implemented the user-classified code/spec drift fixes from weed check mode."
---

# What changed

1. Updated local parity assembly so the full local emulation compose includes data plane, compute plane, and AWS emulator services (`floci`, `floci_bootstrap`).
2. Updated governance transition logic so requests are allowed as a no-op when the repository is already in `implementation_enabled`.
3. Updated documentation freshness expectations to match numbered Quarto outputs and committed fresh rendered docs under `_docs/`.
4. Added explicit Allium `contract` declarations and top-level `invariant` declarations for promotion-gate and MLflow safety constraints.

# Why it changed

These changes implement the classified weed findings:

- Local emulation mismatch: **Code bug**
- Governance phase mismatch: **Code bug**
- Rendered docs presence/in-sync: **Code bug**
- Missing formal contracts/invariants for runtime guards: **Spec bug**

# Touched sources

- `ml_deploy/mlflow_parity.py`
- `ml_deploy/governance_gates.py`
- `tests/test_mlflow_parity.py`
- `tests/test_governance_gates.py`
- `tests/test_docs_freshness.py`
- `specs/ml-deploy-reference-repo.allium`
- `nbs/07_mlflow_parity.qmd`
- `nbs/17_governance_gates.qmd`
- `.gitignore`
- `_docs/**/*`
