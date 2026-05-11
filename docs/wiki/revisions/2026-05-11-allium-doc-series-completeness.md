---
updated: 2026-05-11
summary: Extended distilled Allium spec with series-level notebook documentation completeness requirements for engineers and ML researchers.
read_when:
  - You are deciding what the notebook series must contain before implementation work
  - You are updating spec-level documentation governance requirements
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../sources/ml-deploy-reference-repo.allium.md
---

# Revision: 2026-05-11 Allium doc-series completeness

## Trigger

Requirement clarified: the notebook series must function as a complete working architecture/implementation document for software engineers, including trade-offs, security, examples, ML researcher learning material, implementation module linkage, and docs-site module coverage.

## What changed

1. Added `DocumentationAudience` enum with `software_engineer` and `ml_researcher`.
2. Added `DocumentationSeries` entity capturing required series-level qualities and deliverables.
3. Added `RequireImplementationReadyNotebookSeries` rule to enforce that a declared documentation series includes:
   - complete system description
   - architecture description
   - implementation steps
   - trade-off analysis
   - security considerations
   - usage examples
   - role-specific learning paths for both audiences
   - Python implementation module
   - website/docs module section

## Result

The spec now models notebook documentation as an implementation-readiness obligation, not just narrative context.
