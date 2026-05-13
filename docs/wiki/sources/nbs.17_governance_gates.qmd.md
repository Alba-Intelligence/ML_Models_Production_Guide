---
updated: 2026-05-13
summary: Quarto nbdev source page for specification-first governance gate helpers, including already-enabled phase behavior.
read_when:
  - You need to edit implementation transition gate behavior in notebook source-of-truth form
source_file: ../../nbs/17_governance_gates.qmd
---

# Source summary: nbs/17_governance_gates.qmd

## Role

Defines the notebook source-of-truth for governance gate logic that enforces explicit confirmation + spec-quality gate requirements, while allowing no-op requests once implementation is already enabled.

## Main exported objects

- `RepositoryGovernanceState`
- `GovernanceDecision`
- `request_implementation_transition(...)`

## Practical implication

Implementation transition policy is now encoded as executable code, not only process guidance.
