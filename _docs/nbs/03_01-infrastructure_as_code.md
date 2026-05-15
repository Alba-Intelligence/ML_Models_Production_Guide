# OpenTofu Infrastructure Profiles


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
