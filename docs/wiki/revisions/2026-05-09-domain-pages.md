---
updated: 2026-05-09
summary: Captures the first pass of bounded domain pages derived from the reference architecture skeleton and contracts.
read_when:
  - You need provenance for the domain-planning layer
  - You want to know when the architecture moved from skeleton to domain pages
sources:
  - ../domains/index.md
  - ../architecture/reference-architecture-skeleton.md
  - ../contracts/index.md
---

# Revision: 2026-05-09 domain pages

## Trigger

Proceeding top-down, the next high-confidence step after the cross-cutting contracts was to define the bounded domain pages.

## Domain pages added

- `docs/wiki/domains/index.md`
- `docs/wiki/domains/data-domain.md`
- `docs/wiki/domains/training-domain.md`
- `docs/wiki/domains/artifact-domain.md`
- `docs/wiki/domains/serving-domain.md`
- `docs/wiki/domains/infrastructure-domain.md`
- `docs/wiki/domains/observability-domain.md`
- `docs/wiki/domains/governance-domain.md`
- `docs/wiki/domains/cost-domain.md`

## What these pages establish

- clearer ownership boundaries by domain
- lifecycle coverage per domain
- contract consumption per domain
- topology relevance per domain
- open questions that remain domain-specific
- assistant implications where those are clearly high value

## Architectural effect

These pages make it easier to:

- place future documentation correctly
- decide where a concern belongs
- prevent training, serving, infra, governance, and cost concerns from collapsing into one layer
- prepare for topology pages and decision records

## Remaining high-confidence follow-ons

- topology pages
- decision records for still-open stack choices
- domain-to-topology mapping examples
