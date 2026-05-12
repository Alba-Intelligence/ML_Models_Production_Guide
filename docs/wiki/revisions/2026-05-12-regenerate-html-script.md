# Added regenerate-html helper script

## Summary

Added a short script under `scripts/` to regenerate Quarto HTML docs outputs when `_docs/*.html` files are missing.

## What changed

- Added `scripts/regenerate-html.sh`.
- Documented usage in the Jupyter/shell runbook.
- Added wiki source summary and index/current-state references.

## Why it matters

This gives a fast, explicit command for rebuilding docs HTML without running the full finalize workflow.
