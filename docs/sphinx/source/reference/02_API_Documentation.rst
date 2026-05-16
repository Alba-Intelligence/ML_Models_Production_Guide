API Documentation
=================

This page documents the compact API surface used by the ML Deploy reference stack. It is intentionally higher-level than the implementation modules and stays aligned with the current contract-first posture.

Primary references:

- `ml_deploy/webui_contracts.py`
- `ml_deploy/execution_backends.py`
- `ml_deploy/governance_gates.py`
- `ml_deploy/notebook_intake.py`

API families
------------

The stack's APIs fall into six families:

1. notebook execution requests and run visibility
2. execution orchestration and backend routing
3. notebook intake and approval gates
4. governance transition decisions
5. MLflow parity and storage wiring
6. serving and prediction visibility helpers

1. Notebook execution contracts
------------------------------

`NotebookRevision`
~~~~~~~~~~~~~~~~~~

Immutable reference to the source notebook revision.

Fields usually include:

- `commit`
- `tag`
- `approved_ref`

The revision is the primary provenance anchor for notebook-triggered execution.
