---
updated: 2026-05-11
summary: Synthesized summary of the distilled repository-level Allium specification with spec-quality and documentation-series implementation gating.
read_when:
  - You need the repo behavior expressed as a formal spec
  - You are planning spec-first changes and need the current baseline
source_file: ../../specs/ml-deploy-reference-repo.allium
---

# Source summary: ml-deploy-reference-repo.allium

## Role

`specs/ml-deploy-reference-repo.allium` is the distilled behavioral specification for the current repository.

It converts the repository's implemented shell behavior and governance decisions into an explicit Allium model.

## Scope decisions encoded in the file

- Includes the current Nix shell + Jupyter helper behavior.
- Includes wiki maintenance obligations from `AGENTS.md`.
- Includes accepted project constraints/default stack choices captured in decision pages.
- Excludes implementation internals for external platforms and future code not yet present in the repo.

## Main entities

- `Repository` — phase, constraints, stack posture, and accepted defaults.
- `Wiki` — required memory-layer maintenance surfaces.
- `DocumentationSeries` — series-level documentation completeness obligations for software engineers and ML researchers.
- `ShellSession` — shell-entry, environment, and Jupyter runtime state.
- `OperationRecord`, `WikiArtifact`, `WorkBlocked` — emitted operational outcomes.

## Main behavior captured

- Repository default posture initialization.
- Spec-quality readiness state modeled on the repository (`spec_quality_gate_passed`).
- Shell entry behavior with and without `pyproject.toml`.
- Jupyter kernel ensure + JupyterLab launch behavior.
- Mandatory wiki update workflow after durable changes.
- Notebook-series completeness gate for implementation-ready architecture documentation (steps, trade-offs, security, examples, audience coverage, and implementation/docs-module linkage).
- Specification-first gate that blocks implementation without explicit approval.
- Additional implementation readiness gate requiring passed spec quality unless explicitly overridden.

## Practical implication

The repo now has a machine-readable baseline for what it currently does and what constraints it enforces, which can be refined with `tend` and checked for drift with `weed` as implementation starts later.
