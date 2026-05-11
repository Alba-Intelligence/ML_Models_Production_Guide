---
updated: 2026-05-11
summary: Cleaned literal escape-n sequences from infrastructure overview notebook markdown so rendered docs show real paragraph and list breaks.
read_when:
  - You see literal `\n` text in rendered docs pages
  - You are editing notebook JSON directly and need markdown formatting guidance
sources:
  - ../../nbs/11_infrastructure_overview.ipynb
  - ../sources/nbs.11_infrastructure_overview.ipynb.md
---

# Revision: 2026-05-11 notebook escaped-newline cleanup

## Trigger

Rendered docs showed raw `\n` text in the infrastructure overview page, making paragraphs and bullets unreadable.

## Root cause

Several markdown cells in `nbs/11_infrastructure_overview.ipynb` were stored as single strings containing literal backslash sequences (`\n`) instead of line-separated markdown entries.

## What changed

1. Rewrote affected markdown cell `source` arrays with real line breaks.
2. Updated the diagram fence to Quarto-native Mermaid syntax (` ```{mermaid} `).
3. Simplified Mermaid node labels and quoted labels with special characters for stable rendering.
4. Re-rendered docs and confirmed the page now shows normal paragraphs/lists and a rendered Mermaid graph.

## Durable rule

When editing `.ipynb` JSON manually:

- Use per-line markdown entries in the `source` array.
- Avoid storing full markdown blocks as one string with literal `\n`.
- For Mermaid labels with special characters (`+`, `/`, `:`), wrap label text in quotes.
