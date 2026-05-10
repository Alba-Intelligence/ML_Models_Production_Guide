---
updated: 2026-05-11
summary: Added explicit Quarto availability in both flake and devenv shells and synchronized wiki source coverage.
read_when:
  - You need provenance for docs-tooling shell changes
  - You are troubleshooting nbdev-docs/render behavior across shell entrypoints
sources:
  - ../../flake.nix
  - ../../devenv.nix
  - ../sources/flake.nix.md
  - ../sources/devenv.nix.md
---

# Revision: 2026-05-11 Quarto shell packages

## Trigger

Uncommitted shell changes introduced explicit `quarto` packaging in both shell definitions and needed durable wiki synchronization.

## What changed

1. Added `quarto` to flake dev shell package set.
2. Added `quarto` to `devenv.nix` packages.
3. Added source summary coverage for `devenv.nix`.
4. Updated architecture/current-state/wiki index references to reflect docs-tooling availability in both shell paths.

## Outcome

nbdev docs rendering dependencies are now explicit and aligned across both shell entrypoints, reducing local render drift.
