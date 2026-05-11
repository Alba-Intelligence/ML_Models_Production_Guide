---
updated: 2026-05-11
summary: Added spec-propagated test coverage for documentation-series completeness obligations, including aspirational-gap tracking.
read_when:
  - You are checking how Allium documentation-series obligations map to executable tests
  - You need to understand which obligations are currently enforced vs deferred
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../../tests/test_documentation_series_contracts.py
  - ../sources/tests.test_documentation_series_contracts.py.md
---

# Revision: 2026-05-11 propagated doc-series tests

## Trigger

User selected propagation from the Allium spec and requested implementation of the first slice around notebook-series completeness and docs-site module coverage.

## What changed

1. Added `tests/test_documentation_series_contracts.py` as spec-propagated tests mapped to `RequireImplementationReadyNotebookSeries`.
2. Added passing checks for implemented obligations (architecture narrative, module section linkage, docs rendering coverage).
3. Added explicit skipped tests for agreed aspirational obligations (trade-offs, examples, ML researcher path).

## Result

The suite now captures documentation-series obligations as executable tests while transparently tracking deferred specification goals.
