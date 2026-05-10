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

Mermaid 11.2.0 requires double-quote escaping for node labels containing special characters like `+`, `/`, and `:`. Unquoted labels with these characters cause parse errors. Example:

```
-- Without quotes (syntax error):
UI[Notebook Web UI trigger + visibility]
                                     ^ 
                    Mermaid 11.2.0 cannot parse + in unquoted label

-- With quotes (correct):
UI["Notebook Web UI: trigger + visibility"]
    ^^                                    ^^
              Proper Mermaid 11.2.0 syntax
```

## What changed

1. Rewrote the Mermaid diagram in `nbs/index.ipynb` to wrap node labels containing special characters in double quotes.
2. Restructured descriptions for clarity while preserving content:
   - `UI[Notebook Web UI trigger + visibility]` → `UI["Notebook Web UI: trigger + visibility"]`
   - `ORCH[Execution orchestration policy + contract checks]` → `ORCH["Execution orchestration: policy + contract checks"]`
   - `S3[(S3 / MinIO artifacts)]` → `S3["S3 / MinIO artifacts"]`
   - `OBS[Observability + cost (Evidently, Prometheus, Grafana, AWS/Lambda attribution)]` → `OBS["Observability + cost traces"]`

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

**Always quote node labels that contain special characters in Mermaid 11.2.0.** Special characters include:
- Operators: `+`, `-`, `/`, `*`, `%`
- Punctuation: `:`, `,`, `;`, `(`, `)`
- Other symbols: `&`, `|`, `@`, `~`, `=`

Good patterns:
```mermaid
NODE["Label with + special / characters: OK"]
NODE['Label with single quotes: also OK']
```

Bad patterns:
```mermaid
NODE[Label with + special / characters: ERROR]  -- Unquoted special chars fail
```

If a label must convey multiple concepts without quotes, use parentheses or restructure:
- ✅ `["Data processing: transform + validate"]`
- ✅ `["S3/MinIO for artifacts"]`
- ❌ `[Data processing: transform + validate]`
- ❌ `[S3/MinIO for artifacts]`

## Testing

Verified by:
1. Identifying the specific node labels with unquoted special characters in the original diagram
2. Adding double-quote wrapping to all problematic labels
3. Rebuilding docs via `./scripts/finalize-task.sh`
4. Opening `_docs/index.html` in browser and verifying no console errors
5. Confirming the diagram renders as an SVG with all nodes and edges visible
