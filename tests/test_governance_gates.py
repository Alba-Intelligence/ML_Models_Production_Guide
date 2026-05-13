"""Tests for specification-first governance gates."""

from __future__ import annotations

import unittest

from ml_deploy.governance_gates import (
    RepositoryGovernanceState,
    request_implementation_transition,
)


class TestGovernanceGates(unittest.TestCase):
    def test_blocks_without_explicit_confirmation(self) -> None:
        state = RepositoryGovernanceState(
            phase="specification_first",
            spec_quality_gate_passed=True,
        )
        decision = request_implementation_transition(
            state,
            explicit_user_confirmation=False,
        )
        self.assertFalse(decision.allowed)
        self.assertEqual(decision.operation, "implementation_blocked")
        self.assertEqual(decision.reason, "explicit_spec_confirmation_required")

    def test_blocks_when_quality_gate_not_passed(self) -> None:
        state = RepositoryGovernanceState(
            phase="specification_first",
            spec_quality_gate_passed=False,
        )
        decision = request_implementation_transition(
            state,
            explicit_user_confirmation=True,
        )
        self.assertFalse(decision.allowed)
        self.assertEqual(decision.reason, "spec_quality_gate_not_passed")

    def test_allows_transition_when_both_requirements_met(self) -> None:
        state = RepositoryGovernanceState(
            phase="specification_first",
            spec_quality_gate_passed=True,
        )
        decision = request_implementation_transition(
            state,
            explicit_user_confirmation=True,
        )
        self.assertTrue(decision.allowed)
        self.assertEqual(decision.operation, "implementation_allowed")
        self.assertEqual(decision.next_state.phase, "implementation_enabled")


if __name__ == "__main__":
    unittest.main()
