# OpenTofu Infrastructure Profiles


# Platform Overview

This page is the compact overview of the ML Deploy platform. It explains
the major layers and the main contracts without duplicating the detailed
interaction analysis.

For the detailed entity map and relationship view, see:

- `12_system_interaction_analysis.qmd`
- `docs/wiki/architecture/full-system-interaction-analysis.md`

## What the platform is

The repository is a specification-first, notebook-driven reference for
ML deployment. It emphasizes:

- immutable notebook source-of-truth
- MLflow-linked traceability
- local/cloud parity
- contract-first execution
- explicit security and approval boundaries

## Core layers

The platform is easiest to understand in five layers:

1.  **Interface layer** — notebook repository and Web UI
2.  **Execution layer** — local, Slurm, and Kubernetes backends
3.  **Data/model layer** — MLflow, artifacts, prediction logging
4.  **Infrastructure layer** — Nix/Terranix/OpenTofu, local emulation,
    cloud
5.  **Governance layer** — auth, policy, approvals, cost controls

## Core entities

The most important entities are:

- **Repository** — owns the phase and the docs/contracts
- **Notebook revision** — immutable execution source
- **Execution request** — normalized request to run a notebook
- **MLflow run** — the traceability anchor for experiment and prediction
  history
- **Model artifact** — versioned bundle with deployment metadata
- **Promotion decision** — approval-aware transition between stages
- **Infrastructure profile** — local or cloud rendering of the runtime
  shape

## Execution flow

A typical workflow looks like this:

1.  a notebook revision is selected
2.  a request is normalized and validated
3.  policy checks are applied
4.  the request is dispatched to the selected backend
5.  MLflow records run metadata and artifacts
6.  a run summary or deployment record is returned

That flow is shared across local, distributed, batch, and online paths.

## Contract checkpoints

The platform checks a small set of invariants repeatedly:

- notebook revisions are immutable
- artifact versions are explicit
- environment boundaries are explicit
- privileged actions are audited
- prediction logging preserves enough context for investigation
- promotion is approval-aware

## Topology view

The reference stack supports four deployment shapes:

- local development and single-node training
- distributed training on Lambda.ai
- batch inference on AWS
- online inference under production controls

Each topology uses the same architectural ideas but a different
execution substrate.

## Governance view

The governance layer provides:

- implementation gating
- auth/roles/policy decisions
- notebook approval controls
- promotion gates
- cost and audit visibility

The stack is deliberately conservative about mutation.

## Learning path

Use this page as the front door, then move to:

- `nbs/tutorials/03_Concepts_and_Architecture.qmd` for the conceptual
  spine
- `nbs/tutorials/04_End_to_End_Workflow.qmd` for the complete slice
- `nbs/reference/01_Implementation_Patterns.qmd` for the slice mechanics
- `nbs/reference/03_Security_Authorization_and_Policy.qmd` for auth and
  policy

## Practical rule

If a change weakens traceability, policy clarity, or topology
boundaries, it is probably not aligned with the platform narrative.

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
