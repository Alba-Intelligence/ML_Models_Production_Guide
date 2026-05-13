---
updated: 2026-05-13
summary: Synthesized summary of docs freshness tests that ensure rendered HTML is present and not stale versus numbered Quarto sources.
read_when:
  - You are validating docs generation currency
  - You are changing Quarto output paths or render workflow
source_file: ../../tests/test_docs_freshness.py
sources:
  - ../runbooks/jupyter-and-shell.md
  - _quarto.yml.md
---

# Source summary: tests/test_docs_freshness.py

## Role

Guards against stale documentation outputs by checking rendered HTML timestamps against `nbs/*.qmd` source timestamps.

## Main behavior

- Maps each `nbs/*.qmd` source to expected `_docs/nbs/*.html` output using the same filename stem (`00_core.qmd -> 00_core.html`).
- Asserts each expected rendered page exists.
- Asserts each rendered page modification time is not older than its source `.qmd`.

## Practical implication

If docs are not re-rendered after source edits, this test fails and surfaces stale publishable output immediately.
