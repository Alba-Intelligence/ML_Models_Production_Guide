---
updated: 2026-05-10
summary: Captures the flake fix that makes allium-cli build successfully in the dev shell.
read_when:
  - You need provenance for the allium-cli packaging fix
  - You are troubleshooting flake shell toolchain composition
sources:
  - ../../flake.nix
  - ../sources/flake.nix.md
  - ../architecture/dev-environment.md
---

# Revision: 2026-05-10 allium-cli build fix

## Trigger

`allium-cli` failed during shell build in the `naersk` split build path with a dummy-manifest "no targets specified" error.

## Change

- Updated `flake.nix` to build `allium-cli` with:
  - `singleStep = true`

## Result

- `nix develop --no-write-lock-file -c ...` now resolves a working `allium` binary in the shell.
- `.allium` parse/check workflows can run inside the dev shell without the previous build failure.

## Later change

This pinned-build approach was superseded later the same day by:

- `revisions/2026-05-10-allium-cli-latest-version.md`
