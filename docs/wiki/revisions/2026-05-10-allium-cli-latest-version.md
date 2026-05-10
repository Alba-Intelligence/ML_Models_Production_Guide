---
updated: 2026-05-10
summary: Captures the flake update that makes allium resolve to the latest crate release at runtime.
read_when:
  - You need provenance for the latest-version allium behavior
  - You are deciding between pinned Nix builds and runtime cargo-managed tooling
sources:
  - ../../flake.nix
  - ../sources/flake.nix.md
  - ../architecture/dev-environment.md
---

# Revision: 2026-05-10 allium-cli latest version

## Trigger

The pinned crate version in `flake.nix` was behind current `allium-cli` releases, and the requirement changed to always use the latest version.

## Change

- Removed pinned `naersk` crate packaging for `allium-cli`.
- Added an `allium` shell wrapper that:
  - resolves the newest release using `cargo search allium-cli --limit 1`
  - installs that version with `cargo install --locked ... --version <latest>` when needed
  - executes the installed binary from `~/.local/allium-cli` (or `ALLIUM_INSTALL_ROOT`).

## Result

- `allium` now tracks the latest crates.io release automatically.
- Version drift from pinned flake metadata is eliminated for this tool.
- First use on a machine may incur network + compile/install cost before local cache is populated.

## Later change

This runtime-latest approach was superseded later the same day:

- `allium` was moved back to `naersk` packaging by user preference.
- The shell now uses a reproducible Nix-built `allium-cli` package instead of runtime `cargo install`.
