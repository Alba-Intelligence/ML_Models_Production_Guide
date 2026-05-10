---
updated: 2026-05-10
summary: Captures the uv2nix/dev-shell fix that unblocks nix develop in a dirty nbdev workspace.
read_when:
  - You are troubleshooting uv2nix behavior in the dev shell
  - You need provenance for the nix develop failure fix
sources:
  - ../../flake.nix
  - ../sources/flake.nix.md
  - ../architecture/dev-environment.md
---

# Revision: 2026-05-10 uv2nix dev-shell fix

## Trigger

`nix develop` failed while building the editable workspace package (`ml-deploy`) through uv2nix in the shell dependency graph.

## Change

- Updated `flake.nix` so `devShells.default` no longer includes a uv2nix `mkVirtualEnv` package build.
- Kept uv2nix integration for workspace/lock processing and package outputs.
- Set `UV_PYTHON` directly from the base interpreter path in the shell environment.

## Result

- `nix develop --no-write-lock-file -c true` now succeeds.
- Local shell bootstrap is handled by `uv venv` + `uv sync`, which tolerates normal dirty/untracked workspace iteration better than forcing editable package builds in the Nix shell closure.
