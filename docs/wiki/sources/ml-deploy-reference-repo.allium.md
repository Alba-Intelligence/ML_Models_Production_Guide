---
updated: 2026-05-13
summary: Synthesized summary of the distilled repository-level Allium specification, including explicit contracts and invariants for governance/promotion safety.
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
- `OpenTofuConfiguration` — infrastructure generation obligations for Terranix/OpenTofu JSON outputs from flake and devenv.
- `ShellSession` — shell-entry, environment, and Jupyter runtime state.
- `OperationRecord`, `WikiArtifact`, `WorkBlocked` — emitted operational outcomes.

## Main behavior captured

- Repository default posture initialization.
- Spec-quality readiness state modeled on the repository (`spec_quality_gate_passed`).
- Shell entry behavior with and without `pyproject.toml`.
- Conditional dependency synchronization on shell entry (only when dependencies are missing or explicitly requested).
- Jupyter kernel ensure + JupyterLab launch behavior.
- Mandatory wiki update workflow after durable changes.
- Notebook-series completeness gate for implementation-ready architecture documentation (steps, trade-offs, security, examples, audience coverage, and implementation/docs-module linkage).
- Explicit requirement that published documentation must make repository source browsing unnecessary for implementation-relevant behavior and configuration.
- OpenTofu configuration gate requiring Terranix-generated JSON configuration from both flake and devenv pathways.
- Specification-first gate that blocks implementation without explicit approval.
- Additional implementation readiness gate requiring passed spec quality unless explicitly overridden.
- Explicit contract declarations for promotion-gate checks and MLflow safety obligations.
- Top-level invariants asserting implementation gate correctness (`implementation_enabled` implies passed quality gate), production-stage promotion safety, and cloud MLflow safety requirements.
- Conditional infrastructure MCP requirement: when infrastructure MCP servers are available, infrastructure interrogation must be included in the default assistant surface.
- Infrastructure interrogation minimum coverage is now explicit and testable: IaC plans/state, Kubernetes runtime state, Lambda.ai/Slurm runtime state, cloud resource inventory, and cost/usage signals.
- Surface declarations that make key governance, shell, and documentation triggers reachable for executable analysis.

## Practical implication

The repo now has a machine-readable baseline for what it currently does and what constraints it enforces, which can be refined with `tend` and checked for drift with `weed` as implementation starts later.
