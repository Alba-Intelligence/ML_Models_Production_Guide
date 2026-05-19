# devenv_modules/modules/shared.nix
# Terranix module: shared resource definitions common to both local and cloud profiles.
# These are imported by devenv_modules/profiles/local.nix and devenv_modules/profiles/cloud.nix.
#
# Terranix compiles these into OpenTofu-compatible *.tf.json.
# Reference: https://terranix.org/

{ config, lib, ... }:

with lib;

let
  cfg = config.mlDeploy;
in
{
  imports = [ ./defaults.nix ];

  options.mlDeploy = {
    profile = mkOption {
      type = types.enum [
        "local_emulation"
        "cloud"
      ];
      description = "Active deployment profile: local_emulation or cloud.";
    };

    mlflowTrackingUri = mkOption {
      type = types.str;
      description = "MLflow tracking server URI (set per profile).";
    };

    postgresHost = mkOption {
      type = types.str;
      description = "PostgreSQL hostname for MLflow backend store.";
    };
  };

  config = {
    # Constants from defaults.nix (fr-par for AWS region)
    mlDeploy.awsRegion = "fr-par";

    # Shared terraform provider configuration
    resource.aws_s3_bucket."${cfg.projectName}-artifacts" = {
      bucket = "mlflow-artifacts";
    };

    resource.aws_s3_bucket."${cfg.projectName}-model-registry" = {
      bucket = "model-registry";
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
