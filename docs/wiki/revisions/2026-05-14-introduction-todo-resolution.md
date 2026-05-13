---
title: "Introduction TODO resolution"
date: 2026-05-14
summary: "Resolved stack-introduction TODOs with explicit WebUI, orchestration, notebook-source, compute, and Nix/Terranix positioning."
---

# What changed

1. Removed Allium from the introduction stack framing.
2. Added explicit WebUI-first control plane positioning.
3. Added shared notebook repository flow for both local and cloud profiles.
4. Added Airflow as workflow orchestration (without Kafka mention).
5. Clarified local emulation as a real compute option.
6. Clarified Nix/Terranix as canonical source for Docker/Compose/OpenTofu artifact generation.

# Touched sources

- `nbs/00_introduction.qmd`
- `_docs/nbs/00_introduction.html`
- `docs/wiki/sources/nbs.00_introduction.qmd.md`
- `docs/wiki/current-state.md`
- `docs/wiki/log.md`
