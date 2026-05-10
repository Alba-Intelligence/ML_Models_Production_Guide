---
updated: 2026-05-10
summary: Accepted gate model for notebook intake so Web UI execution always resolves to immutable, approved notebook revisions.
read_when:
  - You are implementing notebook intake or promotion workflows
  - You need to decide if a notebook revision is executable
sources:
  - ../architecture/notebook-repository-web-ui.md
  - ../architecture/webui-backend-contract.md
---

# Decision: notebook intake validation and approval

## Status

Accepted.

## Context

The project requires Web UI-triggered notebook execution without notebook source mutation. To preserve lineage and reproducibility, execution must be tied to immutable notebook revisions, not mutable UI state.

## Decision

Notebook execution follows this intake gate model:

1. **Immutable source gate**: execution source must be a Git commit, tag, or approved-ref.
2. **Structural validation gate**: notebook must parse via `nbformat` and export through `nbdev-export` without mutation.
3. **Safety gate**: notebook and execution config must pass secret/policy scanning rules before approval.
4. **Approval gate**: an explicit reviewer approval produces an executable `approved-ref`.
5. **Execution gate**: Web UI backend accepts only immutable refs and records request metadata for audit.

## Consequences

- UI uploads may exist as staging inputs, but they are non-executable until converted into Git-traceable immutable revisions and approved.
- Execution contracts can stay uniform across local, Slurm, and Kubernetes targets.
- Auditability improves because every run points to a validated, approved notebook revision.

## Rejected alternatives

- Executing mutable in-UI notebook buffers directly.
- Treating unapproved branches as executable production candidates.
