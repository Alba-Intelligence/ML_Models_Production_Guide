Security, Roles, and Policy
==========================

This page defines the reference **traditional authorization posture** for the ML Deploy stack.

The design is deliberately conservative:

- OIDC-backed authentication for humans
- scoped service identities for automation
- centralized policy decisions
- human RBAC plus capability catalogs
- audit trails for every privileged action

The goal is not to invent a new auth model. The goal is to describe the enterprise shape that fits this repository.

Why this page exists
--------------------

The repository already has:

- immutable notebook source-of-truth behavior
- Web UI-triggered execution contracts
- local, distributed, and cloud topology separation
- MLflow tracking and lineage
- governance gates for specification-first transitions

What was still missing was the **who may do what, under which conditions, and how is that decision enforced** narrative.

Canonical posture
-----------------

The reference posture is:

1. authenticate identities with OIDC
2. authorize requests centrally
3. keep authentication separate from authorization
4. use policy-as-code for privileged actions
5. audit every allow/deny and every sensitive mutation
