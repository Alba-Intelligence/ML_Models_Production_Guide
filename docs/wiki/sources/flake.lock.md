---
updated: 2026-05-09
summary: Synthesized summary of pinned flake inputs.
read_when:
  - You need to know what upstreams are pinned
  - You are debugging reproducibility or dependency drift
source_file: ../../flake.lock
---

# Source summary: flake.lock

## Role

`flake.lock` pins the upstream Nix inputs that define the reproducible development environment.

## Primary pinned inputs

- `nixpkgs`: `NixOS/nixpkgs`, ref `nixpkgs-unstable`, rev `68a8af93ff4297686cb68880845e61e5e2e41d92`
- `flake-utils`: `numtide/flake-utils`, rev `11707dc2f618dd54ca8739b309ec4fc024de578b`
- `llmpkgs`: `numtide/llm-agents.nix`, rev `c741913095c4815f6651aa0a2c24b3ce15e414e4`

## Indirect inputs worth noticing

Through `llmpkgs`, the repo also inherits pins for:

- `blueprint`
- `bun2nix`
- `flake-parts`
- `treefmt-nix`
- `systems`

## Structural observation

There are effectively two `nixpkgs` nodes in the lock graph:

- one used internally by `llmpkgs`
- one exposed at the repo root as the direct project input

Both currently resolve to the same upstream revision.

## Practical implications

- The dev shell depends not only on `nixpkgs` but also on the evolution of `llm-agents.nix` and its transitive graph.
- When tool versions change unexpectedly, inspect both `flake.nix` package selection and this lockfile.
- Because the repo's main functionality currently lives in the shell, changes to this lockfile are operationally significant.
