# nix/modules/local.nix
# Terranix module: local_emulation profile overrides.
# Wires all services to Docker Compose endpoints (Floci, K3s, Slurm-Docker).
# Import alongside shared.nix in nix/profiles/local.nix.

{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile             = "local_emulation";
    mlflowTrackingUri   = "http://localhost:5001";
    awsEndpointUrl      = "http://localhost:4566";  # Floci
    postgresHost        = "localhost";
  };

  # Floci-compatible provider configuration
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

  # Kubernetes provider pointing at K3s in Docker
  config.provider.kubernetes = {
    config_path = "/output/kubeconfig.yaml";  # mounted from k3s container
  };

  config.output.kubernetes_endpoint = {
    value       = "https://localhost:6443";
    description = "K3s local Kubernetes API endpoint.";
  };

  config.output.slurm_controller = {
    value       = "localhost:6817";
    description = "Local Slurm controller endpoint (slurmctld).";
  };

  config.output.s3_endpoint = {
    value       = "http://localhost:4566";
    description = "Floci S3 endpoint (local_emulation profile).";
  };
}
