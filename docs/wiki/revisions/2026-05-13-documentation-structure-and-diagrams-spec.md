---
date: 2026-05-13
type: specification
title: Documentation Structure and Diagram Requirements
summary: "Tightened Allium spec to mandate a 5-subsection Platform Overview with extensive Mermaid diagrams (class, sequence, state machine, deployment topology)."
---

# Documentation Structure and Diagram Requirements (2026-05-13)

## Context

The project requires that all documentation be self-contained and hierarchically structured. To make this concrete and enforceable, the Allium spec now defines the exact structure all qmd files must follow, with mandatory diagram types for each subsection.

## Changes

### 1. New DocumentationSeries Entity Fields

Added 10 new Boolean fields to the `DocumentationSeries` entity in `specs/ml-deploy-reference-repo.allium`:

```allium
entity DocumentationSeries {
    -- ... existing fields ...
    has_platform_overview_section: Boolean
    has_system_components_subsection: Boolean
    has_class_diagrams_for_entities: Boolean
    has_execution_dataflow_subsection: Boolean
    has_sequence_diagrams_for_flows: Boolean
    has_deployment_infrastructure_subsection: Boolean
    has_deployment_topology_diagrams: Boolean
    has_governance_safety_subsection: Boolean
    has_state_machine_diagrams: Boolean
    has_role_specific_learning_paths_subsection: Boolean
}
```

### 2. Updated RequireImplementationReadyNotebookSeries Rule

Extended the `RequireImplementationReadyNotebookSeries` rule to enforce all new fields:

```allium
ensures: series.has_platform_overview_section = true
ensures: series.has_system_components_subsection = true
ensures: series.has_class_diagrams_for_entities = true
ensures: series.has_execution_dataflow_subsection = true
ensures: series.has_sequence_diagrams_for_flows = true
ensures: series.has_deployment_infrastructure_subsection = true
ensures: series.has_deployment_topology_diagrams = true
ensures: series.has_governance_safety_subsection = true
ensures: series.has_state_machine_diagrams = true
ensures: series.has_role_specific_learning_paths_subsection = true
```

Updated `@guidance` section to describe the mandatory structure:

> The documentation must be organized around a Platform Overview section with five logical subsections, each with appropriate diagrams:
> 
> 1. **System Components & Roles** (class diagrams for entities, relationships, roles)
> 2. **Execution & Data Flow** (sequence diagrams for key workflows)
> 3. **Deployment & Infrastructure** (topology diagrams for local vs. cloud)
> 4. **Governance & Safety** (state machines for promotion gates and phases)
> 5. **Learning Paths** (structured by audience: software engineer, ML researcher)
>
> Diagrams must use Mermaid and must be extensive: class diagrams for entity models, sequence diagrams for execution flows, state machines for governance, and deployment topology diagrams for infrastructure parity visualization.

## Specification Intent

The five subsections provide a technical audience with a logical navigation path through the system:

1. **System Components & Roles** — "What are the key entities and how do they relate?"
   - Diagrams: Class/ER diagrams showing entity models, relationships, and contracts

2. **Execution & Data Flow** — "How does work move through the system?"
   - Diagrams: Sequence diagrams for notebook intake, execution dispatch, MLflow tracking, artifact promotion

3. **Deployment & Infrastructure** — "What does the infrastructure look like?"
   - Diagrams: Deployment topology diagrams (local emulation vs. cloud, component dependencies, networking)

4. **Governance & Safety** — "What are the safeguards and controls?"
   - Diagrams: State machines for promotion gates (DEV→UAT→REGRESSION→PROD), repository phases (spec-first vs. implementation-enabled)

5. **Learning Paths** — "How do I get started?"
   - Diagrams: Learning path diagrams showing recommended reading order for different roles

## Implementation Plan (Phase 2)

The spec change is now in place. Implementation will refactor all `.qmd` files (`index.qmd`, `01_platform_narrative.qmd`, `06_vertical_slice.qmd`, etc.) to follow this structure and add the mandatory Mermaid diagrams.

See `/home/emmanuel/.copilot/session-state/bceeed0b-b491-4de5-ab93-478bb63cc905/phase2-implementation-plan.md` for refactoring strategy.

## Validation

- `allium check` passes: Spec is syntactically valid
- No new errors introduced; pre-existing unused entity warnings remain
- All 56 unit tests pass

## Cross-References

- Spec file: `specs/ml-deploy-reference-repo.allium` (lines 83–112 entity definition, lines 333–398 rule definition)
- Related spec field: `Repository.docs_use_mermaid_diagrams` (already true by default)
- Related decision: `docs/wiki/decisions/documentation-source-format-and-hierarchy.md`
- Related runbook: `docs/wiki/runbooks/jupyter-and-shell.md` (Quarto render commands)
