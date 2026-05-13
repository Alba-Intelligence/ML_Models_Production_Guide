---
updated: 2026-05-14
summary: Introductory Quarto page summarizing the full platform stack in purpose-first, top-down order, including canonical nbdev/QMD authoring, uv2nix-based Python environments, WebUI, shared notebook flow, Airflow, Kubeflow, central authorization, MLOps promotion, and Nix/Terranix artifact generation.
read_when:
  - You need a concise overview of the entire repository stack
  - You are onboarding and want the shortest architecture/software orientation
source_file: ../../nbs/00_introduction.qmd
---

# Source summary: nbs/00_introduction.qmd

## Role

Provides a single introduction page that summarizes the end-to-end stack before deeper module pages.

## What it contains

- Repository purpose and system-at-a-glance description.
- Software stack table ordered from structuring choices to implementation-local concerns, covering authorization, promotion, infrastructure, authoring workflow, Python environment, docs, WebUI, orchestration, tracking, execution, stores, local emulation, observability, cost, assistant access, runtime, CI, and testing.
- Local vs cloud topology posture summary.
- Lifecycle flow diagram connecting purpose, shared notebook source, docs, modules, WebUI, Airflow orchestration, optional Kubeflow in the Kubernetes lane, runtime, tracking, promotion, authorization, observability, cost, and infrastructure.
- Pointers to key follow-on pages for architecture, runtime, and governance.

## Practical implication

New readers can quickly understand what technologies are in use and how layers fit together before diving into detailed notebook pages.
