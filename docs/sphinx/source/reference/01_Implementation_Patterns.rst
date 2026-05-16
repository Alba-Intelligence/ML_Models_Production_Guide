Implementation Patterns: EX-01 → EX-03
========================================

This page is the compact reference for the first vertical slice. It explains the core patterns without duplicating the full implementation. The detailed code lives in:

- `ml_deploy/vertical_slice.py`
- `ml_deploy/webui_contracts.py`
- `ml_deploy/execution_backends.py`

What the slice proves
---------------------

The EX-01 → EX-03 slice demonstrates a complete path from training to deployment:

1. **EX-01** — train with traceability
2. **EX-02** — package and version the artifact
3. **EX-03** — run local deployment with prediction logging

The slice is intentionally small but production-shaped: every major artifact carries identity, version, and lineage metadata.

Pattern 1: EX-01 training with traceability
------------------------------------------

EX-01 is the canonical training pattern.

What it captures
~~~~~~~~~~~~~~~~

- dataset version
- feature revision
- hyperparameters
- environment metadata
- metrics and model outputs
- MLflow run identity

Minimal shape
~~~~~~~~~~~~~

.. code-block:: python

   result = execute_first_vertical_slice(
       work_dir=Path("/tmp/experiment"),
   # ... (rest of code omitted for brevity)
