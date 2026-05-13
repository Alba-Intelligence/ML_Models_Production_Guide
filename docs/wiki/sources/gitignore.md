---
updated: 2026-05-13
summary: Synthesized summary of root ignore rules, including tracked rendered docs policy.
read_when:
  - You need to understand what will not be tracked by git
  - You are reasoning about reproducibility or private docs
source_file: ../../.gitignore
---

# Source summary: .gitignore

## Role

The root `.gitignore` defines ignore rules for lockfiles, generated docs/build artifacts, local environment outputs, and common Python/tooling caches.

## Notable ignored paths

- lockfiles: `flake.lock`, `devenv.lock`, `uv.lock`
- generated docs/build artifacts: `docs/*`, `_proc/`, `.quarto/`, `**/*.quarto_ipynb`
- nbdev generated metadata: `nbs/_quarto.yml`, `nbs/nbdev.yml`, `nbs/sidebar.yml`
- local env and tooling: `.venv`, `.devenv*`, `.tools/`, logs/cache folders

## Practical implications

- `flake.lock` stays local-only, which avoids noisy lockfile churn from normal `nix develop` runs.
- Rendered docs under `_docs/` are now tracked so docs freshness checks can validate committed publishable outputs.
- New operational files still appear in git unless covered by these explicit patterns.
