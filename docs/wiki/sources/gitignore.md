---
updated: 2026-05-09
summary: Synthesized summary of root ignore rules.
read_when:
  - You need to understand what will not be tracked by git
  - You are reasoning about reproducibility or private docs
source_file: ../../.gitignore
---

# Source summary: .gitignore

## Role

The root `.gitignore` currently defines a very small ignore policy.

## Ignored paths

- `flake.lock`
- `docs/reference/private`

## Practical implications

- The repo keeps a local `flake.lock`, but it is currently ignored by git, so lockfile updates will not be tracked unless ignore rules change.
- There is an intended location for private reference material under `docs/reference/private`.
- Because the ignore policy is minimal, most new files will appear in git status unless explicitly ignored later.
