# nix/modules/shared.nix
# Terranix module: shared resource definitions common to both local and cloud profiles.
# These are imported by nix/profiles/local.nix and nix/profiles/cloud.nix.
#
# Terranix compiles these into OpenTofu-compatible *.tf.json.
# Reference: https://terranix.org/

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
      description = "Base name used to prefix all resources.";
    };

    mlflowTrackingUri = mkOption {
      type = types.str;
      description = "MLflow tracking server URI (set per profile).";
    };

    s3BucketArtifacts = mkOption {
      type = types.str;
      default = "mlflow-artifacts";
      description = "S3 bucket name for MLflow artifact storage.";
    };

    s3BucketModelRegistry = mkOption {
      type = types.str;
      default = "model-registry";
      description = "S3 bucket name for model registry storage.";
    };

    awsRegion = mkOption {
      type = types.str;
      default = "us-east-1";
    };

    awsEndpointUrl = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override AWS endpoint URL (used for LocalStack in local_emulation profile).";
    };

    postgresHost = mkOption {
      type = types.str;
      description = "PostgreSQL hostname for MLflow backend store.";
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
    # Shared terraform provider configuration — endpoint override is null in cloud profile
    resource.aws_s3_bucket."${cfg.projectName}-artifacts" = {
      bucket = cfg.s3BucketArtifacts;
    };

    resource.aws_s3_bucket."${cfg.projectName}-model-registry" = {
      bucket = cfg.s3BucketModelRegistry;
    };

    output.mlflow_tracking_uri = {
      value = cfg.mlflowTrackingUri;
      description = "MLflow tracking server URI for this deployment profile.";
    };

    output.deployment_profile = {
      value = cfg.profile;
      description = "Active deployment profile.";
    };
  };
}
