---
updated: 2026-05-11
summary: Added a dedicated nbdev notebook to visually present the full infrastructure with a Mermaid architecture diagram.
read_when:
  - You need provenance for the new high-level architecture visual
  - You are preparing onboarding/presentation assets
sources:
  - ../../nbs/11_infrastructure_overview.ipynb
  - ../sources/nbs.11_infrastructure_overview.ipynb.md
---

# Revision: 2026-05-11 infrastructure overview notebook

## Trigger

Need for one audience-friendly notebook that communicates the complete infrastructure clearly and visually.

## What changed

1. Added `nbs/11_infrastructure_overview.ipynb`.
2. Included a Mermaid architecture diagram spanning local parity, Lambda.ai Slurm, AWS Kubernetes, MLflow, and observability/cost surfaces.
3. Added concise audience-specific narrative and explicit non-negotiable stack constraints.
4. Synced wiki source/index/current-state/log to include the new notebook as a first-stop visual briefing asset.

## Outcome

The repository now has a single, presentation-ready notebook that explains the overall structure before deep technical docs.
