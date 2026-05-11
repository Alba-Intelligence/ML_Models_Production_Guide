---
updated: 2026-05-11
summary: Hardened index homepage Mermaid graph with parser-safe labels and simplified node shapes to eliminate rendering errors.
read_when:
  - You are troubleshooting Mermaid rendering on the docs homepage
  - You are editing `nbs/index.ipynb` architecture diagram content
sources:
  - ../../nbs/index.ipynb
  - ../sources/nbs.index.ipynb.md
---

# Revision: 2026-05-11 index Mermaid hardening

## Trigger

The homepage architecture diagram in `nbs/index.ipynb` still showed Mermaid rendering errors in-browser.

## What changed

1. Rewrote labels into parser-safe quoted strings for all major nodes.
2. Replaced symbol-heavy wording (`+`, `/`, `:`) with plain connective phrasing where possible.
3. Simplified backend node shapes to standard rectangle labels to reduce parser edge-cases.
4. Regenerated docs so `_docs/index.html` reflects the hardened diagram.

## Result

The index Mermaid block now renders with stable, simple syntax and preserves the same architectural flow:

- engineer -> notebook revision -> UI -> orchestration
- orchestration -> local / Slurm / Kubernetes
- execution paths -> MLflow -> storage + observability -> engineer feedback loop
