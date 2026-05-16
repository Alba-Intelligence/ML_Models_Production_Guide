# OpenTofu Infrastructure Profiles


# Platform Narrative

## Platform architecture

<div>

<figure class=''>

<div>

<img
src="01_05-platform_narrative_files/figure-commonmark/mermaid-figure-1.png"
style="width:7in;height:5.23in" />

</div>

</figure>

</div>

This document provides a high-level narrative of the ML Deploy platform,
its architecture, and its core principles.

## 1. System Components & Roles

This section describes the main system components and roles in the ML
Deploy platform.

The ML Deploy platform is organized into several major components: - ML
Training / Inference (including MLflow for experiment tracking and model
registry) - Data Catalog & Lineage - Orchestration (Kubeflow, Airflow,
Kubernetes) - Backends (Cloud, Local, Slurm) - Configuration (Nix,
Terranix, Opentofu) - OpenTofuConfiguration - DocumentationSeries -
Repository - MLflowTrackingServer - ModelArtifact - PromotionStage

``` mermaid
%% Diagram 1: System Components & Roles
classDiagram
    class Repository
    class DocumentationSeries
    class OpenTofuConfiguration
    class MLflowTrackingServer
    class ModelArtifact
    class PromotionStage
    PromotionStage : DEV
    PromotionStage : UAT
    PromotionStage : REGRESSION
    PromotionStage : PROD
    User <|-- MLResearcher
    User <|-- SoftwareEngineer
    MLResearcher : +write_notebooks()
    SoftwareEngineer : +integrate_catalog()
    Notebook <|-- MLflow
    MLflow <|-- ModelRegistry
    ModelRegistry <|-- Orchestrator
    Orchestrator <|-- Deployment
    ModelRegistry <|-- ModelArtifact
    MLflow <|-- ModelArtifact
    ModelArtifact <|-- PromotionStage
```

## 2. Execution & Data Flow

### Notebook Execution Workflow

The Notebook Execution Workflow describes how a notebook is authored,
tracked, registered, and deployed in the ML Deploy platform.

``` mermaid
%% Diagram 2: Notebook Execution Workflow
sequenceDiagram
    participant User
    participant Notebook
    participant MLflow
    participant ModelRegistry
    participant Orchestrator
    participant Deployment
    User->>Notebook: Author ML code
    Notebook->>MLflow: Track experiment
    MLflow->>ModelRegistry: Register model
    ModelRegistry->>Orchestrator: Trigger pipeline
    Orchestrator->>Deployment: Deploy model
```

### Artifact Tracking Workflow

The Artifact Tracking Workflow describes how artifacts are tracked and
managed in the ML Deploy platform.

``` mermaid
%% Diagram 3: Artifact Tracking Workflow
sequenceDiagram
    participant Notebook
    participant MLflowTrackingServer
    participant ArtifactStore
    participant ModelArtifact
    Notebook->>MLflowTrackingServer: Log artifact
    MLflowTrackingServer->>ArtifactStore: Store artifact
    ArtifactStore->>ModelArtifact: Register artifact
```

### Model Promotion Workflow

``` mermaid
%% Diagram 4: Model Promotion Workflow
sequenceDiagram
    participant Dev
    participant UAT
    participant Regression
    participant Prod
    Dev->>UAT: Promote model
    UAT->>Regression: Validate
    Regression->>Prod: Release
```

### Promotion Gate Architecture

The Promotion Gate Architecture is structured around explicit promotion
stages: DEV, UAT, REGRESSION, and PROD. Each stage acts as a governance
checkpoint, ensuring only validated artifacts and configurations
progress to the next environment.

``` mermaid
graph TD
    Dev[Development] --> UAT[User Acceptance Testing]
    UAT --> Regression[Regression Testing]
    Regression --> Prod[Production]
    Dev -->|Approval| UAT
    UAT -->|Validation| Regression
    Regression -->|Release| Prod
```

## Lifecycle notebooks

The ML Deploy platform is built around the concept of lifecycle
notebooks, which enable: - End-to-end traceability - Reproducible ML
workflows - Seamless promotion from development to production

## Implementation steps

1.  Author a notebook for ML training or inference
2.  Register the notebook with the platform
3.  Track experiments and models using MLflow
4.  Deploy and monitor models using orchestrated pipelines

## 5. Learning Paths

## ML researcher learning path

**ML Researcher Learning Path**

``` mermaid
graph TD
    LocalDevelopment --> NotebookAuthoring
    NotebookAuthoring --> MLflowTracking
    MLflowTracking --> ExperimentRegistration
    ExperimentRegistration --> Orchestration
    Orchestration --> Deployment
```

``` mermaid
graph TD
    LocalDevelopment --> NotebookAuthoring
    NotebookAuthoring --> MLflowTracking
    MLflowTracking --> ExperimentRegistration
    ExperimentRegistration --> Orchestration
    Orchestration --> Deployment
```

## Software engineer learning path

**Software Engineer Learning Path**

``` mermaid
graph TD
    DataCatalogIntegration --> WorkflowAutomation
    WorkflowAutomation --> InfraReproducibility
    InfraReproducibility --> Deployment
```

``` mermaid
graph TD
    DataCatalogIntegration --> WorkflowAutomation
    WorkflowAutomation --> InfraReproducibility
    InfraReproducibility --> Deployment
```

## Platform architect learning path

``` mermaid
graph TD
    Requirements --> SystemDesign
    SystemDesign --> InfraProvisioning
    InfraProvisioning --> PolicyEnforcement
    PolicyEnforcement --> Deployment
```

## Governance & safety learning path

``` mermaid
graph TD
    Draft --> Review
    Review --> Approved
    Approved --> Deployed
    Deployed --> Monitoring
    Monitoring --> [*]
```

#### Artifact Lifecycle Diagram

``` mermaid
graph TD
    Notebook --> MLflowTrackingServer
    MLflowTrackingServer --> ArtifactStore
    ArtifactStore --> ModelArtifact
    ModelArtifact --> ModelRegistry
    ModelRegistry --> Orchestrator
    Orchestrator --> Deployment
```

#### Promotion Stages Diagram

``` mermaid
graph TD
    DEV --> UAT
    UAT --> REGRESSION
    REGRESSION --> PROD
```

#### Policy Enforcement Diagram

``` mermaid
graph TD
    User --> PolicyEngine
    PolicyEngine --> Platform
```

## Security considerations

- OIDC-backed authentication
- Centralized policy engine for RBAC
- Full auditability and traceability

## 4. Governance & Safety

Spec-First Governance

The ML Deploy platform is governed by a spec-first approach, ensuring
that all changes and workflows are validated against explicit
specifications before being promoted. This guarantees traceability,
compliance, and safety at every stage.

Promotion Gate Architecture

The ML Deploy platform uses a Promotion Gate Architecture to ensure that
models and infrastructure changes are validated at each stage before
reaching production. This architecture enforces governance and safety by
requiring explicit approvals and validations at each gate.

``` mermaid
%% Diagram 9: Governance State Machine
stateDiagram-v2
    [*] --> Draft
    Draft --> Review
    Review --> Approved
    Approved --> Deployed
    Deployed --> [*]
```

### Policy Enforcement Workflow

``` mermaid
%% Diagram 10: Policy Enforcement Workflow
sequenceDiagram
    participant User
    participant PolicyEngine
    participant Platform
    User->>PolicyEngine: Request action
    PolicyEngine->>Platform: Authorize/deny
```

## Trade-offs

- Nix-based infra increases reproducibility but has a learning curve
- Centralized policy engine simplifies governance but adds complexity

## Examples of use

- ML researcher submits a notebook, tracks with MLflow, deploys via
  Kubeflow
- Engineer automates data lineage and orchestrates batch jobs

## 3. Deployment & Infrastructure

Local Emulation Stack

The ML Deploy platform provides a Local Emulation Stack for development
and testing, enabling users to run all core services (MLflow, Postgres,
MinIO, etc.) locally using Docker Compose or Nix shells. This stack
mirrors the production environment for reliable experimentation.

``` mermaid
%% Diagram 5: Local Emulation Stack
graph TD
    subgraph Local Emulation Stack
        User --> Notebook
        Notebook --> MLflow
        MLflow --> ModelRegistry
        ModelRegistry --> Orchestrator
        Orchestrator --> Deployment
    end
```

Local Development

``` mermaid
%% Diagram 6: Local Development
graph TD
    User --> Notebook
    Notebook --> MLflow
    MLflow --> ModelRegistry
    ModelRegistry --> Orchestrator
    Orchestrator --> Deployment
```

## Cloud Deployment Topology

The Cloud Deployment Topology describes how the ML Deploy platform is
deployed in a cloud environment, including the use of managed services,
cloud orchestration, and integration with enterprise infrastructure.

``` mermaid
%% Diagram 7: Cloud Deployment Topology
graph TD
    subgraph Cloud Deployment Topology
        User --> CloudNotebook
        CloudNotebook --> CloudMLflow
        CloudMLflow --> CloudModelRegistry
        CloudModelRegistry --> CloudOrchestrator
        CloudOrchestrator --> CloudDeployment
    end
```

### Infrastructure Parity

The ML Deploy platform enforces Infrastructure Parity between local and
cloud environments. All core services, orchestration, and deployment
workflows are mirrored, ensuring that what works locally will work in
production. This is achieved through Nix-based reproducibility and
Docker Compose/Nix shells for local emulation.

### Infrastructure Provisioning Workflow

``` mermaid
%% Diagram 8: Infrastructure Provisioning Workflow
sequenceDiagram
    participant User
    participant Nix
    participant Terranix
    participant OpenTofuConfiguration
    participant CloudInfra
    User->>Nix: Define environment
    Nix->>Terranix: Generate config
    Terranix->>OpenTofuConfiguration: Create infra JSON
    OpenTofuConfiguration->>CloudInfra: Provision resources
```

## Audience

- ML Researchers
- Infrastructure & Operations Engineers
- Platform Architects

## Additional Diagrams

``` mermaid
%% Diagram 11: Data Lineage
flowchart TD
    DataSource --> DataIngest
    DataIngest --> DataCatalog
    DataCatalog --> Notebook
```

``` mermaid
%% Diagram 12: Model Monitoring
flowchart TD
    Deployment --> Monitoring
    Monitoring --> Alerting
```

``` mermaid
%% Diagram 13: User Roles
classDiagram
    User <|-- MLResearcher
    User <|-- SoftwareEngineer
    User <|-- PlatformArchitect
```

``` mermaid
%% Diagram 14: Security Flow
sequenceDiagram
    participant User
    participant AuthService
    participant PolicyEngine
    participant Platform
    User->>AuthService: Authenticate
    AuthService->>PolicyEngine: Authorize
    PolicyEngine->>Platform: Grant/Deny
```

``` mermaid
%% Diagram 15: Data Governance
stateDiagram-v2
    [*] --> Raw
    Raw --> Processed
    Processed --> Validated
    Validated --> [*]
```

*This is a stub. Expand with detailed narrative as required by
documentation tests.*

This page summarizes the dual-profile infrastructure posture.

## Profiles

- **local_emulation**: Floci + K3s + Slurm-Docker paired with
  MLflow/PostgreSQL.
- **cloud**: AWS-backed infrastructure with Kubernetes control plane and
  Lambda.ai integration surfaces.

## Generation model

- Terranix modules under `nix/modules/` provide shared plus
  profile-specific definitions.
- Profile entrypoints under `nix/profiles/` compose modules into
  OpenTofu-compatible JSON.
- Apply flow is profile-scoped and local-emulation validation should
  precede cloud rollout.

## Key outputs

- Deployment profile identification.
- MLflow tracking URI per profile.
- Storage and scheduler endpoint references required by orchestration
  layers.

## Copy-pasteable Terranix entrypoints

The notebook pages document the same source that lives under `nix/` so
the infrastructure story can be read without directory spelunking.

``` nix
# nix/modules/local.nix
{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile           = "local_emulation";
    mlflowTrackingUri = "http://localhost:5001";
    awsEndpointUrl    = "http://localhost:4566";
    postgresHost      = "localhost";
  };

  config.provider.aws = {
    region                      = config.mlDeploy.awsRegion;
    access_key                  = "test";
    secret_key                  = "test";
    skip_credentials_validation = true;
    skip_metadata_api_check     = true;
    skip_requesting_account_id  = true;
    endpoints = {
      s3             = config.mlDeploy.awsEndpointUrl;
      iam            = config.mlDeploy.awsEndpointUrl;
      sts            = config.mlDeploy.awsEndpointUrl;
      ec2            = config.mlDeploy.awsEndpointUrl;
      secretsmanager = config.mlDeploy.awsEndpointUrl;
      cloudwatch     = config.mlDeploy.awsEndpointUrl;
      logs           = config.mlDeploy.awsEndpointUrl;
    };
  };
}
```

``` nix
# nix/modules/cloud.nix
{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile           = "cloud";
    mlflowTrackingUri = "\${var.mlflow_tracking_uri}";
    awsEndpointUrl    = null;
    postgresHost      = "\${var.postgres_host}";
  };

  config.provider.aws = {
    region = config.mlDeploy.awsRegion;
  };
}
```

``` nix
# nix/modules/shared.nix
{ config, lib, ... }:

with lib;

let
  cfg = config.mlDeploy;
in {
  options.mlDeploy = {
    profile = mkOption {
      type = types.enum [ "local_emulation" "cloud" ];
    };
    projectName = mkOption {
      type = types.str;
      default = "ml-deploy";
    };
    mlflowTrackingUri = mkOption {
      type = types.str;
    };
    s3BucketArtifacts = mkOption {
      type = types.str;
      default = "mlflow-artifacts";
    };
    s3BucketModelRegistry = mkOption {
      type = types.str;
      default = "model-registry";
    };
    awsRegion = mkOption {
      type = types.str;
      default = "us-east-1";
    };
    awsEndpointUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    postgresHost = mkOption {
      type = types.str;
    };
    postgresPort = mkOption {
      type = types.int;
      default = 5432;
    };
    postgresDb = mkOption {
      type = types.str;
      default = "mlflow";
    };
  };

  config = {
    resource.aws_s3_bucket."${cfg.projectName}-artifacts" = {
      bucket = cfg.s3BucketArtifacts;
    };

    resource.aws_s3_bucket."${cfg.projectName}-model-registry" = {
      bucket = cfg.s3BucketModelRegistry;
    };

    output.mlflow_tracking_uri = {
      value = cfg.mlflowTrackingUri;
    };
  };
}
```
