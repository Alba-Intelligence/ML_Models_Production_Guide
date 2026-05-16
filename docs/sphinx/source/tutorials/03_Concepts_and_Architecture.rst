Core Concepts and Architecture
=============================

This tutorial gives the compact conceptual model for the ML Deploy platform.

It is meant to help you read the rest of the docs in the right order. The key idea is simple: the repository is organized around a **contract-based, specification-first ML deployment lifecycle**.

The architectural spine
-----------------------

The platform is built around a small set of permanent ideas:

1. **Separation of concerns** — data, training, artifacts, serving, infrastructure, governance, and cost each have their own responsibilities.
2. **Contracts first** — the system defines the interfaces before it chases implementation detail.
3. **Immutability** — notebook revisions are fixed; execution configuration is external.
4. **Traceability** — every meaningful artifact must link back to provenance.
5. **Reproducibility** — local and cloud paths should be explainable and repeatable.
6. **Environment awareness** — local, distributed, batch, and online topologies are not interchangeable.

Lifecycle view
--------------

The repository follows a practical ML lifecycle:

- data intake and preparation
- training and experiment tracking
- artifact packaging and versioning
- local serving and prediction logging
- distributed training and batch inference
- online inference and monitoring
- governance and cost attribution

That lifecycle is the backbone for the docs and the implementation slices.
