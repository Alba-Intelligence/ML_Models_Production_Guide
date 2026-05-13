---
updated: 2026-05-14
summary: Introductory Quarto page summarizing the full platform stack, including WebUI, shared notebook repository flow, Airflow orchestration, optional Kubeflow in the Kubernetes lane, central authorization, MLOps promotion, and canonical Nix/Terranix artifact generation.
read_when:
  - You need a concise overview of the entire repository stack
  - You are onboarding and want the shortest architecture/software orientation
source_file: ../../nbs/00_introduction.qmd
---

# Source summary: nbs/00_introduction.qmd

## Role

Provides a single introduction page that summarizes the end-to-end stack before deeper module pages.

## What it contains

- Repository posture and system-at-a-glance description.
- Software stack table covering runtime, packaging, WebUI control plane, notebook source management, orchestration, optional Kubeflow placement, authorization, lineage, infrastructure, observability, cost, assistant access, CI, and testing.
- Local vs cloud topology posture summary.
- Lifecycle flow diagram connecting shared notebook source, docs, modules, WebUI, Airflow orchestration, optional Kubeflow in the Kubernetes lane, runtime, tracking, promotion, authorization, observability, cost, and infrastructure.
- Pointers to key follow-on pages for architecture, runtime, and governance.

## Practical implication

New readers can quickly understand what technologies are in use and how layers fit together before diving into detailed notebook pages.
