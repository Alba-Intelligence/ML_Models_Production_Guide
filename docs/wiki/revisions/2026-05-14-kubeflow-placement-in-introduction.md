---
title: "Kubeflow placement in introduction"
date: 2026-05-14
summary: "Updated the stack introduction to describe Kubeflow as an optional Kubernetes-lane component with local K3s testing/emulation support."
---

# What changed

1. Added Kubeflow Pipelines to the software stack table as an optional Kubernetes-lane component.
2. Clarified where Kubeflow sits relative to Airflow and execution backends.
3. Added explicit note that Kubeflow can run locally on K3s for testing and local emulation.
4. Updated the lifecycle flow diagram to include Kubeflow in the Kubernetes lane.

# Touched sources

- `nbs/00_introduction.qmd`
- `_docs/nbs/00_introduction.html`
- `docs/wiki/sources/nbs.00_introduction.qmd.md`
- `docs/wiki/current-state.md`
- `docs/wiki/log.md`
