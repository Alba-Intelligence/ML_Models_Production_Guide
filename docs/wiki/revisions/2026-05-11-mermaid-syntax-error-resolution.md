---
updated: 2026-05-11
summary: Resolved Mermaid 11.2.0 "Syntax Error in text" by removing escaped newlines from node labels.
read_when:
  - You are debugging Mermaid diagram rendering failures
  - You encounter "Syntax Error in Mermaid version X.Y.Z" in the browser console
  - You are creating flowcharts with multi-line node labels
sources:
  - ../../nbs/index.ipynb
  - ../sources/nbs.index.ipynb.md
commits:
  - b221176
---

# Revision: 2026-05-11 Mermaid syntax error resolution

## Trigger

After fixing the Mermaid block syntax in the index notebook, the diagram rendered but the browser console reported:
```
Syntax Error in text Mermaid version 11.2.0
```

The issue appeared despite correct Quarto markdown setup and mermaid runtime assets being loaded.

## Root cause

Mermaid 11.2.0 does not tolerate escaped newlines (`\n`) within node label strings when defined inline in the flowchart. Example:

```
ENG[ML Engineer] --> NB[Notebook revision in Git\n(immutable source)]
                                              ^^
                                    Mermaid 11.2.0 rejects this
```

While older or configuration-dependent Mermaid versions might permit this, version 11.2.0 (the version Quarto includes by default) parses it as a syntax violation.

## What changed

1. Rewrote the Mermaid diagram in `nbs/index.ipynb` to flatten multi-line node labels into single lines.
2. Preserved content clarity by restructuring descriptions into parenthetical or abbreviated form:
   - `Notebook revision in Git\n(immutable source)` → `Notebook revision in Git (immutable source)`
   - `Notebook Web UI\ntrigger + visibility` → `Notebook Web UI trigger + visibility`
   - `Execution orchestration\npolicy + contract checks` → `Execution orchestration policy + contract checks`

3. Regenerated docs via `./scripts/finalize-task.sh`.

## Outcome

✅ The index page diagram now renders without console errors.
✅ All information is preserved; labels are clear despite single-line format.
✅ Diagram displays the complete architecture flow:
  - ML Engineer → Notebook revision
  - Three execution pathways (local, Slurm, K8s)
  - Convergence at MLflow
  - Storage backends (PostgreSQL, S3/MinIO)
  - Observability loop back to engineer

## Constraint for future Mermaid work

**Do not use `\n` in Mermaid 11.2.0 node labels.** If a label must convey multiple concepts:
- Use parentheses for secondary info: `Execution (policy + contract checks)`
- Use abbreviations: `UI (Web trigger + visibility)`
- Split into separate nodes and link them if complexity grows
- Consider restructuring the diagram for clarity rather than cramming multi-line text

## Testing

Verified by:
1. Opening `_docs/index.html` in browser
2. Inspecting the rendered Mermaid SVG in DevTools
3. Confirming no console errors
4. Checking that all nodes and edges render visually
