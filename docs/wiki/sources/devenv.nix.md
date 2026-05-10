---
updated: 2026-05-11
summary: Synthesized summary of the auxiliary devenv shell and its mirrored notebook/docs toolchain.
read_when:
  - You are changing devenv-based shell behavior
  - You need parity details between flake and devenv entrypoints
source_file: ../../devenv.nix
---

# Source summary: devenv.nix

## Role

`devenv.nix` provides an alternative development-shell entrypoint mirroring core `flake.nix` behavior.

## Key behavior

- Builds `allium-cli` 3.2.3 with `naersk` (`singleStep = true`).
- Provides Python-backed `start-jupyter` helper that ensures the `ml_ops` kernel.
- Includes `nbdev` and `quarto` in the shell package set for notebook export/docs workflows.
- Configures `uv` as the Python dependency workflow and uses `.venv` via `UV_PROJECT_ENVIRONMENT`.

## Practical implication

Developers using `devenv` get the same nbdev-first and docs-rendering workflow expectations as the flake shell.
