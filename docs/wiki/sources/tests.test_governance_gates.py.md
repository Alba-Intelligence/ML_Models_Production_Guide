---
updated: 2026-05-12
summary: Tests for spec-first implementation transition gating decisions.
read_when:
  - You are modifying phase transition or quality-gate behavior
source_file: ../../tests/test_governance_gates.py
---

# Source summary: tests/test_governance_gates.py

## Role

Asserts that implementation transitions are blocked without explicit confirmation and without a passed spec-quality gate.

## Coverage

- blocks without explicit confirmation
- blocks when quality gate is not passed
- allows transition when both are satisfied
