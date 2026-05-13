"""Specification-first implementation gating helpers."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Literal

RepositoryPhase = Literal["specification_first", "implementation_enabled"]
OperationKind = Literal["implementation_blocked", "implementation_allowed"]


@dataclass(frozen=True)
class RepositoryGovernanceState:
    phase: RepositoryPhase = "specification_first"
    spec_quality_gate_passed: bool = False


@dataclass(frozen=True)
class GovernanceDecision:
    allowed: bool
    operation: OperationKind
    reason: str
    next_state: RepositoryGovernanceState


def request_implementation_transition(
    state: RepositoryGovernanceState,
    *,
    explicit_user_confirmation: bool,
) -> GovernanceDecision:
    """Enforce spec-first phase transition gate."""
    if state.phase == "implementation_enabled":
        return GovernanceDecision(
            allowed=True,
            operation="implementation_allowed",
            reason="already implementation_enabled",
            next_state=state,
        )

    if not explicit_user_confirmation:
        return GovernanceDecision(
            allowed=False,
            operation="implementation_blocked",
            reason="explicit_spec_confirmation_required",
            next_state=state,
        )

    if not state.spec_quality_gate_passed:
        return GovernanceDecision(
            allowed=False,
            operation="implementation_blocked",
            reason="spec_quality_gate_not_passed",
            next_state=state,
        )

    return GovernanceDecision(
        allowed=True,
        operation="implementation_allowed",
        reason="explicit_confirmation_with_quality_gate",
        next_state=RepositoryGovernanceState(
            phase="implementation_enabled",
            spec_quality_gate_passed=state.spec_quality_gate_passed,
        ),
    )


__all__ = [
    "RepositoryPhase",
    "OperationKind",
    "RepositoryGovernanceState",
    "GovernanceDecision",
    "request_implementation_transition",
]
