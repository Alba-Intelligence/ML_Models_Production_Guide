---
updated: 2026-05-12
summary: Helper script to regenerate Quarto HTML docs output.
read_when:
  - You need to recreate missing `_docs/*.html` outputs quickly
sources:
  - ../../../../scripts/regenerate-html.sh
---

# `scripts/regenerate-html.sh`

- Minimal helper script to regenerate HTML docs from Quarto sources.
- Uses `quarto render . --no-execute` when Quarto is already installed on PATH.
- Falls back to `nix-shell --packages quarto --run 'quarto render . --no-execute'` when Quarto is missing.
