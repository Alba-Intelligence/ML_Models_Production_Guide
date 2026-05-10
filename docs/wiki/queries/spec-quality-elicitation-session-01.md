---
updated: 2026-05-11
summary: Prioritized elicitation questions to raise specification quality before additional implementation work.
read_when:
  - You need to run a structured clarification session
  - You are deciding if specs are complete enough to permit implementation
sources:
  - ../decisions/project-scope-and-constraints.md
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/notebook-repository-web-ui.md
  - ../../specs/ml-deploy-reference-repo.allium
---

# Spec quality elicitation — session 01

## Why this exists

Current specs contain useful structure, but there are unresolved ambiguities and acceptance gaps that will cause implementation drift.
This page defines the exact questions to close first.

## Session boundary

- **In scope:** architecture contracts, topology handoff semantics, notebook execution governance, and implementation gating criteria.
- **Out of scope:** UI framework/library selection details, infra vendor internals, and low-level code design.

## Priority questions (answer in order)

1. **Spec quality gate**
   - What concrete evidence marks `spec_quality_gate_passed = true`?
   - Which pages/spec sections are mandatory for gate evaluation?
   - Who is the approver role for passing the gate?

2. **Notebook intake + promotion control**
   - What exact approval states are required before a notebook revision can run on Lambda.ai/AWS targets?
   - What is the rejection/remediation path when intake checks fail?
   - Which metadata fields are mandatory for promotion requests?

3. **Execution-contract obligations across topologies**
   - Which request fields are invariant across local, Slurm, and Kubernetes execution?
   - Which fields are topology-specific and must be transformed?
   - What failure states must be normalized into a shared run-status model?

4. **Run visibility and auditability**
   - Which run-state transitions are mandatory to expose in the Web UI?
   - What minimum audit trail is required for "who triggered what, when, from which immutable revision"?
   - Which links are required on every run summary (MLflow run, artifact, model version, deployment)?

5. **Contract enforcement model**
   - Which checks are hard failures vs warnings for each topology?
   - Where do checks execute (pre-submit, post-submit, post-run)?
   - What is the escalation path for repeated contract violations?

## Minimum acceptance criteria for this session

- A written and approved spec-quality gate checklist exists.
- Notebook execution state model is explicitly defined and topology-normalized.
- Promotion gates from local -> Lambda.ai/AWS are unambiguous.
- Required audit fields and run links are specified for every run.
- Open questions are either resolved or explicitly deferred with owner + next review point.
