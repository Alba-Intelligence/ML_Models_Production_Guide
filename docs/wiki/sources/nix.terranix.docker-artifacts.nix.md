---
updated: 2026-05-12
summary: Nix Terranix source-of-truth for generated Docker and compose artifacts.
read_when:
  - You need to change generated Docker/compose content
source_file: ../../nix/terranix/docker-artifacts.nix
---

# Source summary: nix/terranix/docker-artifacts.nix

## Role

Declares generated Docker runtime artifacts as Nix data structures.

## Declared artifacts

- Dockerfile content
- local development compose config
- local AWS emulator compose config
- cloud profile compose config with Traefik + MLflow source validation env

## Practical implication

Artifact content is now defined once in Nix and emitted through generation scripts, reducing manual drift.
