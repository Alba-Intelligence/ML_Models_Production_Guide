---
title: "Terranix Infrastructure Source"
---

This page mirrors the Nix/Terranix source that generates the OpenTofu inputs.
It exists so the infra story is readable from the website without browsing the
source tree.

```{mermaid}
graph TD
  page[nbs/16_terranix_infra.rst] --> shared[nix/modules/shared.nix]
  page --> local[nix/modules/local.nix]
  page --> cloud[nix/modules/cloud.nix]
  local --> terranix[Terranix]
  cloud --> terranix
  terranix --> json[OpenTofu JSON]
```

## Shared module

```nix
# nix/modules/shared.nix
{ config, lib, ... }:

with lib;

let
  cfg = config.mlDeploy;
in {
  options.mlDeploy = {
    profile = mkOption {
      type = types.enum [ "local_emulation" "cloud" ];
      description = "Active deployment profile: local_emulation or cloud.";
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
      description = "Override AWS endpoint URL (used for Floci in local_emulation profile).";
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

## Local profile

```nix
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

  config.provider.kubernetes = {
    config_path = "/output/kubeconfig.yaml";
  };
}
```

## Cloud profile

```nix
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

## Entrypoints

```nix
# nix/profiles/local.nix
{ pkgs, ... }:

{
  imports = [
    ../modules/local.nix
  ];

  terraform.required_providers.aws = {
    source  = "hashicorp/aws";
    version = "~> 5.0";
  };

  terraform.required_providers.kubernetes = {
    source  = "hashicorp/kubernetes";
    version = "~> 2.0";
  };
}
```

```nix
# nix/profiles/cloud.nix
{ pkgs, ... }:

{
  imports = [
    ../modules/cloud.nix
  ];

  terraform.required_providers.aws = {
    source  = "hashicorp/aws";
    version = "~> 5.0";
  };

  terraform.required_providers.kubernetes = {
    source  = "hashicorp/kubernetes";
    version = "~> 2.0";
  };
}
```

## How to apply

Generate JSON from the profile you want, write it to `infra/<profile>/main.tf.json`,
then run OpenTofu from that directory.
