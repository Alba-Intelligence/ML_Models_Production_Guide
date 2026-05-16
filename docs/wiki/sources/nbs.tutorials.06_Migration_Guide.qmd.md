---
updated: 2026-05-16
summary: Compact migration guide for translating legacy ML workflows into the reference stack's contract model.
read_when:
  - You are migrating older notebook or serving patterns into this repository
source_file: ../../nbs/tutorials/06_Migration_Guide.qmd
sources:
  - ../architecture/reference-architecture-skeleton.md
  - ../architecture/first-vertical-slice.md
  - ../decisions/security-authorization-architecture.md
---

# Source summary: nbs/tutorials/06_Migration_Guide.qmd

## Role

Explains how to map older training, serving, deployment, and policy patterns into the ML Deploy reference style.

## Main points

- keep the useful model code
- remove tangled coupling
- preserve traceability and policy
- keep topology boundaries explicit

## Use when

- you are porting a legacy workflow into the reference stack
- you need a checklist for preserving the contract model
