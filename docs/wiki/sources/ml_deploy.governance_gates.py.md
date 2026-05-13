---
updated: 2026-05-12
summary: Specification-first phase transition helpers for explicit implementation gating.
read_when:
  - You need implementation gate logic tied to spec-quality and explicit confirmation
source_file: ../../ml_deploy/governance_gates.py
---

# Source summary: ml_deploy/governance_gates.py

## Role

Provides executable gating decisions for transitions from `specification_first` to `implementation_enabled`.

## Main components

- `RepositoryGovernanceState`
- `GovernanceDecision`
- `request_implementation_transition(...)`

## Practical implication

The previously policy-only implementation gate now has code-level state/decision logic aligned with the distilled Allium rule set.
