---
updated: 2026-05-13
summary: Specification-first phase transition helpers for explicit implementation gating, including no-op allowance once implementation is already enabled.
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

## Behavior notes

- Blocks transition without explicit confirmation while in `specification_first`.
- Blocks transition when `spec_quality_gate_passed` is false.
- Returns an allowed no-op decision when phase is already `implementation_enabled`.

## Practical implication

The previously policy-only implementation gate now has code-level state/decision logic aligned with the distilled Allium rule set.
