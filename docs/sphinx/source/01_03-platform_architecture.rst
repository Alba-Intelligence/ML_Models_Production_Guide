Platform Overview
=================

This page is the compact overview of the ML Deploy platform. It explains the major layers and the main contracts without duplicating the detailed interaction analysis.

For the detailed entity map and relationship view, see:
- 12_system_interaction_analysis.rst
- docs/wiki/architecture/full-system-interaction-analysis.md

What the platform is
--------------------
The repository is a specification-first, notebook-driven reference for ML deployment. It emphasizes:
- immutable notebook source-of-truth
- MLflow-linked traceability
- local/cloud parity
- contract-first execution
- explicit security and approval boundaries

Core layers
-----------
The platform is easiest to understand in five layers:
1. **Interface layer** — notebook repository and Web UI
2. **Execution layer** — local, Slurm, and Kubernetes backends
3. **Data/model layer** — MLflow, artifacts, prediction logging
4. **Infrastructure layer** — Nix/Terranix/OpenTofu, local emulation, cloud
5. **Governance layer** — auth, policy, approvals, cost controls

Core entities
-------------
The most important entities are:
- **Repository** — owns the phase and the docs/contracts
- **Notebook revision** — immutable execution source
- **Execution request** — normalized request to run a notebook
- **MLflow run** — the traceability anchor for experiment and prediction history
- **Model artifact** — versioned bundle with deployment metadata
- **Promotion decision** — approval-aware transition between stages
- **Infrastructure profile** — local or cloud rendering of the runtime shape

Execution flow
--------------
A typical workflow looks like this:
1. a notebook revision is selected
2. a request is normalized and validated
3. policy checks are applied
4. the request is dispatched to the selected backend
5. MLflow records run metadata and artifacts
6. a run summary or deployment record is returned
That flow is shared across local, distributed, batch, and online paths.

Contract checkpoints
--------------------
The platform checks a small set of invariants repeatedly:
- notebook revisions are immutable
- artifact versions are explicit
- environment boundaries are explicit
- privileged actions are audited
- prediction logging preserves enough context for investigation
- promotion is approval-aware

Topology view
-------------
The reference stack supports four deployment shapes:
- local development and single-node training
- distributed training on Lambda.ai
- batch inference on AWS
- online inference under production controls
Each topology uses the same architectural ideas but a different execution substrate.

Governance view
---------------
The governance layer provides:
- implementation gating
- auth/roles/policy decisions
- notebook approval controls
- promotion gates
- cost and audit visibility
The stack is deliberately conservative about mutation.

Learning path
-------------
Use this page as the front door, then move to:
- nbs/tutorials/03_Concepts_and_Architecture.rst for the conceptual spine
- nbs/tutorials/04_End_to_End_Workflow.rst for the complete slice
- nbs/reference/01_Implementation_Patterns.rst for the slice mechanics
- nbs/reference/03_Security_Authorization_and_Policy.rst for auth and policy

Practical rule
--------------
If a change weakens traceability, policy clarity, or topology boundaries, it is probably not aligned with the platform narrative.
