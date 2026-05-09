---
updated: 2026-05-09
summary: Accepted boundary between Docker as the canonical reproducible environment and Nix as a helper layer.
read_when:
  - You are deciding whether Docker or Nix is canonical
  - You are defining local-dev or build-environment docs
sources:
  - ../architecture/target-system.md
  - ../domains/infrastructure-domain.md
  - ../current-state.md
---

# Decision: Docker / Nix boundary

## Status

**Accepted** on 2026-05-09.

## Decision

- **Docker is the canonical reproducible development artifact and default documented path.**
- **Nix is an optional helper/convenience layer** for contributors and local workflows.
- Docker files must exist explicitly in the repository even if Nix is used to help generate or support them.

## Why

This keeps the reference:

- easier to understand for a wider engineering audience
- aligned with Linux-only and container-first reproducibility expectations
- compatible with production-oriented workflows
- less dependent on readers adopting Nix to follow the project

At the same time, it preserves the option of using Nix productively for developer ergonomics and generation support.

## Alternatives considered

### Nix as a first-class canonical internal build tool

Pros:
- very strong reproducibility
- powerful developer tooling

Why not default:
- increases cognitive load for a broader audience
- creates risk of having two competing primary paths
- weakens the clarity of Docker as the standard reference artifact

## Consequences

- local-development docs should present Docker first
- Nix-specific guidance should be clearly labeled as helper/contributor workflow material
- future implementation should avoid making Nix a hidden required dependency for understanding the default path

## Revisit if

- Docker alone proves insufficient for maintaining the reference cleanly
- contributor workflows become materially worse without a stronger Nix role
- the project audience becomes much more Nix-native than currently assumed
