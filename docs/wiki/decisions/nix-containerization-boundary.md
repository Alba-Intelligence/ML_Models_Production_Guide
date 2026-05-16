---
updated: 2026-05-16
summary: Boundary decision describing how Nix, Docker, and containerized runtime concerns are separated in the reference stack.
read_when:
  - You are changing shell, container, or packaging behavior
  - You need to know what Nix is allowed to do in this repo
sources:
  - ../../specs/ml-deploy-reference-repo.allium
  - ../architecture/dev-environment.md
  - ../architecture/target-system.md
---

# Nix Containerization Boundary

## Purpose

Define what Nix is for in the reference stack, and what it is not for.

## Decision

Use **Nix as the reproducible build / dev-shell / artifact-generation helper**, and use **Docker/container images as the runtime and emulation boundary**.

That means:

- Nix assembles the toolchain and reproducible inputs
- Docker composes the local emulation and developer runtime surfaces
- container images are the unit of runtime packaging
- Nix should not become the hidden runtime abstraction for everything

## Why this boundary exists

The repo needs both:

- a reliable development shell
- a predictable container-based runtime model

If Nix tries to do all runtime jobs, the stack becomes harder to reason about.
If Docker tries to do all build jobs, reproducibility suffers.

The boundary lets each tool do what it is best at.

## What Nix is for

Nix should handle:

- dev-shell provisioning
- package pinning
- reproducible build inputs
- generated artifact wiring
- Terranix/OpenTofu generation support
- convenience commands for local development

## What Nix is not for

Nix should not be treated as the primary runtime substrate for the reference ML workloads.
It is not the place to hide:

- service orchestration logic
- long-running platform behavior
- runtime policy decisions
- deployment approvals

## What Docker is for

Docker should handle:

- local reproducible runtime emulation
- service composition
- MLflow parity stacks
- local data-plane and compute-plane wiring
- containerized developer workflows

## Operational implication

When a component can be expressed as either a shell helper or a runtime container, ask:

1. Is this a build/dev concern? Use Nix.
2. Is this a runtime/service concern? Use Docker or the topology-specific runtime.

## Consequences

### Positive

- clear division between build and runtime concerns
- easier local reproduction
- less ambiguity in docs and implementation
- better support for generated Docker artifacts

### Tradeoffs

- some duplication between shell setup and container setup
- the repo must keep both layers documented
- contributors need to know which boundary they are changing

## Related decisions

- `docs/wiki/decisions/nix-terranix-opentofu-boundary.md`
- `docs/wiki/decisions/documentation-delivery-decision.md`
- `docs/wiki/architecture/dev-environment.md`

## Summary

Nix is the reproducible helper layer.
Docker is the runtime/emulation layer.
Do not blur the two.
