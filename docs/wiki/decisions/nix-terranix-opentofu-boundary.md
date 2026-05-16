---
updated: 2026-05-16
summary: Boundary decision for how Nix, Terranix, and OpenTofu divide responsibility in the infrastructure pipeline.
read_when:
  - You are changing infrastructure generation or deployment behavior
  - You need to know what belongs in Nix versus Terranix versus OpenTofu
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../architecture/target-system.md
  - ../architecture/local-emulation-stack.md
---

# Nix → Terranix → OpenTofu Boundary

## Purpose

Define a clean infrastructure-generation pipeline.

The stack should remain easy to explain:

- Nix prepares reproducible inputs and helper tooling
- Terranix renders infrastructure configuration from those inputs
- OpenTofu applies the rendered configuration to real targets

## Decision

Use **Nix as the source of reproducible infrastructure inputs**, **Terranix as the generator**, and **OpenTofu as the apply-time engine**.

That means:

- Nix is not the apply engine
- Terranix is not the cloud provider
- OpenTofu is not the place to encode high-level repository policy

## Why this boundary exists

The repository needs a predictable split between:

- declarative inputs
- generated infrastructure definitions
- real environment changes

If those concerns are mixed, the repo becomes hard to review and hard to audit.

## What belongs in Nix

Nix should own:

- reproducible inputs
- shell/toolchain setup
- local artifact generation helpers
- Terranix bootstrap wiring
- environment-specific helper packages

## What belongs in Terranix

Terranix should own:

- infrastructure shape generation
- environment profile rendering
- module composition
- local/cloud profile differences at the declaration layer

## What belongs in OpenTofu

OpenTofu should own:

- plan/apply execution
- state management
- provider interactions
- real infrastructure mutation
- drift detection at apply time

## Practical consequences

### Good outcomes

- generated infrastructure is reviewable
- local/cloud parity stays visible
- policy can be checked before apply
- generated artifacts can be re-created from source inputs

### Tradeoffs

- the pipeline has one more explicit layer
- generated files must be kept fresh
- contributors must understand where a change should live

## Runtime expectations

The reference stack expects infrastructure changes to be:

- explicit
- reviewable
- environment-scoped
- auditable
- compatible with local emulation where feasible

## What is out of scope

This decision does **not** require:

- a custom Terraform replacement
- hand-authored cloud templates as the primary source
- runtime mutation from notebook code

## Related pages

- `docs/wiki/architecture/local-emulation-stack.md`
- `docs/wiki/architecture/target-system.md`
- `docs/wiki/decisions/nix-containerization-boundary.md`
- `docs/wiki/decisions/project-scope-and-constraints.md`

## Summary

Keep the infrastructure pipeline layered:

**Nix → Terranix → OpenTofu**

Each layer should have one job.
