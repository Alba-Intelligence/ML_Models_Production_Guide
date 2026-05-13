---
title: "Stack introduction page"
date: 2026-05-14
summary: "Added a new QMD introduction page that summarizes the full stack, including software stack layers."
---

# What changed

1. Added `nbs/00_introduction.qmd` as a stack-wide introduction page.
2. Linked the page from `nbs/index.qmd` under Foundations.
3. Added the page to root Quarto sidebar navigation in `_quarto.yml`.
4. Rendered docs now include `_docs/nbs/00_introduction.html`.

# Why it changed

To provide a single onboarding page that summarizes the full stack (software, infrastructure, workflow) before readers dive into detailed architecture and module pages.

# Touched sources

- `nbs/00_introduction.qmd`
- `nbs/index.qmd`
- `_quarto.yml`
- `_docs/nbs/00_introduction.html`
