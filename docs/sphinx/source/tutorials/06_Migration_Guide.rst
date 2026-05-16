Migration Guide
===============

This guide helps you map older notebook or serving patterns into the ML Deploy reference style.

The important thing is not to copy every old construct. The important thing is to keep the reference contracts intact:

- immutable notebook revisions
- explicit execution context
- MLflow-linked traceability
- versioned artifacts
- policy-aware promotion
- auditable serving and deployment actions

What usually changes during migration
------------------------------------

A legacy workflow often bundles too many concerns together.
The reference stack separates them into a small set of responsibilities:

1. notebook source and revision identity
2. training and experiment tracking
3. artifact packaging and versioning
4. serving and prediction logging
5. policy and approval boundaries
6. backend-specific execution adapters
