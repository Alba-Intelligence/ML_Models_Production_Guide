---
title: "System Interaction Analysis"
---

This page captures the five-layer interaction analysis used to reason about boundaries and coupling:

1. **Context layer** — actors, external systems, and trust boundaries.
2. **Component layer** — implementation modules and ownership.
3. **Contract layer** — invariant and interface obligations.
4. **Flow layer** — control, data, and artifact movement.
5. **Operations layer** — observability, cost, failure handling, and governance.

## Interaction checkpoints

- Request normalization and immutable notebook revision validation.
- Execution target routing (local, Slurm, Kubernetes).
- MLflow-linked run visibility and traceability.
- Artifact and deployment record integrity.
- Infrastructure parity and MCP interrogation readiness.

## Detailed entity relationships and responsibilities

This page carries the detailed entity relationship map that was removed from the
top-level narrative to keep the introduction focused.

```{mermaid}
classDiagram
    class Repository {
        +String name
        +RepositoryPhase phase
        +DeploymentProfile active_deployment_profile
        +Boolean spec_quality_gate_passed
        +Boolean local_emulation_verified
    }

    class DocumentationSeries {
        +Boolean is_complete_system_description
        +Boolean is_hierarchically_structured
        +Boolean makes_repository_source_browsing_unnecessary
        +Set~DocumentationAudience~ audiences_covered
    }

    class OpenTofuConfiguration {
        +Boolean generated_with_terranix
        +Boolean outputs_json_configuration
        +Boolean supports_local_emulation
        +Boolean supports_cloud_deployment
    }

    class MLflowTrackingServer {
        +String backend_store_uri
        +String artifacts_destination
        +ReverseProxyTool reverse_proxy_tool
        +Boolean model_version_source_validation_enabled
    }

    class ModelArtifact {
        +String artifact_id
        +PromotionStage stage
        +Boolean tracked_in_mlflow
        +Boolean promotion_approved
    }

    class PromotionStage {
        +String name
        +Set~QualityGate~ required_gates
    }

    Repository "1" --> "1" DocumentationSeries : provides
    Repository "1" --> "1" OpenTofuConfiguration : generates
    Repository "1" --> "1" MLflowTrackingServer : deploys
    Repository "1" --> "*" ModelArtifact : tracks
    ModelArtifact "N" --> "1" PromotionStage : transitions_to
```
