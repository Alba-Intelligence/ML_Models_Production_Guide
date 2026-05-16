# Implementation Patterns: EX-01 → EX-03

Compact rendered summary for `nbs/reference/01_Implementation_Patterns.qmd`.

## Scope

- EX-01 training with traceability
- EX-02 artifact bundling and versioning
- EX-03 framework-neutral local serving

## Key points

- Training should capture dataset version, feature revision, hyperparameters, metrics, and MLflow run identity.
- Artifacts should preserve version identity and links back to the producing run.
- Local serving should focus on request handling, prediction logging, and model-version visibility.
- Prediction logging is part of the serving contract.

## See also

- `nbs/reference/01_Implementation_Patterns.qmd`
- `docs/wiki/architecture/first-vertical-slice.md`
- `docs/wiki/sources/nbs.reference.01_Implementation_Patterns.qmd.md`
