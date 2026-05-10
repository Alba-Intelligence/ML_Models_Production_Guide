---
updated: 2026-05-10
summary: Accepted position for nbdev/Quarto-first documentation delivery in the reference architecture.
read_when:
  - You are deciding whether docs delivery is core or optional
  - You are designing the documentation-serving model
sources:
  - ../architecture/assistant-integration-and-docs-delivery.md
  - ../architecture/target-system.md
  - ../domains/serving-domain.md
---

# Decision: documentation delivery model

## Status

**Accepted** on 2026-05-09.

## Decision

- **Markdown in git remains the canonical documentation source.**
- **nbdev/Quarto remains the default documentation delivery path.**
- Dynamic docs-serving layers are optional companion patterns, not required core architecture elements.

## Why

This preserves:

- version-controlled, reviewable documentation as the source of truth
- Python-first extensibility when richer docs delivery is desired
- architectural clarity by avoiding unnecessary coupling between model serving and docs serving

Treating docs delivery as optional keeps the core reference simpler while still leaving room for a powerful documentation experience.

## Alternatives considered

### Make a dynamic docs API/service part of the default mandatory architecture

Pros:

- unified stack story
- powerful dynamic docs surface

Why not default:

- increases complexity in the core reference
- risks conflating documentation delivery with model-serving concerns
- not required to preserve restartability or documentation quality

## Consequences

- docs should be authored as markdown first
- any dynamic docs-serving implementation should be clearly labeled as optional/companion
- documentation-serving routes and deployment concerns should stay separate from model-serving routes and controls

## Revisit if

- the documentation experience becomes a flagship part of the project's value proposition
- assistant/documentation workflows strongly benefit from a default dynamic docs service
- static markdown-only delivery proves insufficient for the intended reference
