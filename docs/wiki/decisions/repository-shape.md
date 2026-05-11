---
updated: 2026-05-09
summary: Durable decisions and implications behind the repo's current implementation-light shape.
read_when:
  - You are wondering why the repo is sparse
  - You are deciding how to extend the project
sources:
  - ../overview.md
  - ../sources/flake.nix.md
---

# Repository shape

## Decision: keep the repo implementation-light until the specification is settled

Right now the repository is centered on a development shell and wiki, not on application code. That is a real design fact, even if it is temporary.

### Why this matters

- Changes to `flake.nix` and `docs/wiki/` currently have outsized impact because there are almost no other implementation files.
- Documentation and memory should reflect the real center of gravity instead of pretending the repo already has a fuller ML system.
- The user has explicitly requested a specification-first phase with no implementation code until the specs are comfortable.

## Decision: treat repository files as raw sources and `docs/wiki` as the compiled memory layer

This repo now follows the Karpathy-style pattern:

- raw truth lives in the repository files
- synthesized truth lives in `docs/wiki`
- future agents should read the wiki first and only then inspect raw files as needed

## Decision: keep the active wiki compact

The wiki should help future agents load only what they need.

That implies:

- concise summaries over large excerpts
- source summaries for important root files
- a small number of high-value topical pages
- append-only logging and targeted revision artifacts instead of giant narrative docs

## Current architectural implication

Until real project code lands, the practical areas of concern are:

- project purpose and constraints
- target platform and documentation scope
- dev shell behavior
- Python bootstrap behavior
- Jupyter workflow
- upstream pinning through `flake.lock`

## Decision: keep `flake.lock` local-only (gitignored)

`flake.lock` remains intentionally ignored in this repository.

### Why this matters

- `nix develop` in this environment may rewrite lockfile inputs during routine commands.
- Tracking that file today would create noisy diffs unrelated to core spec/docs/code changes.
- Reproducibility is still available locally, but lock updates are not treated as canonical history yet.

See also: [project-scope-and-constraints.md](project-scope-and-constraints.md) and [../architecture/target-system.md](../architecture/target-system.md).

## When this page should change

Update this page when the repo's center of gravity changes, for example if it gains:

- a Python package or app
- notebooks and data workflows
- CI/CD or deployment infrastructure
- a stronger opinionated project architecture beyond the shell bootstrap
