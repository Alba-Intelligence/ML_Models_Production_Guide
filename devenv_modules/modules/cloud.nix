# devenv_modules/modules/cloud.nix
# Terranix module: cloud profile overrides.
# Targets real AWS endpoints and Lambda.ai training infrastructure.
# Import alongside shared.nix in devenv_modules/profiles/cloud.nix.
#
# Secrets are never hardcoded here — they are injected via environment variables
# (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, MLFLOW_TRACKING_URI, etc.)
# or via a secrets manager at apply time.

{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile = "cloud";
    # Real MLflow tracking URI is injected at apply time via TF_VAR_mlflow_tracking_uri
    mlflowTrackingUri = "\${var.mlflow_tracking_uri}";
    awsEndpointUrl = null; # use real AWS
    postgresHost = "\${var.postgres_host}";
  };

  # Real AWS provider — credentials via environment variables
  config.provider.aws = {
    region = config.mlDeploy.awsRegion;
  };

  # Real Kubernetes provider (EKS)
  config.provider.kubernetes = {
    host = "\${data.aws_eks_cluster.main.endpoint}";
    cluster_ca_certificate = "\${base64decode(data.aws_eks_cluster.main.certificate_authority[0].data)}";
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1";
      command = "aws";
      args = [
        "eks"
        "get-token"
        "--cluster-name"
        "\${var.eks_cluster_name}"
      ];
    };
  };

  config.variable.mlflow_tracking_uri = {
    type = "string";
    description = "MLflow tracking server URI (injected from secrets manager or CI).";
    sensitive = true;
  };

  config.variable.postgres_host = {
    type = "string";
    description = "PostgreSQL hostname for MLflow backend (RDS or external).";
    sensitive = true;
  };

  config.variable.eks_cluster_name = {
    type = "string";
    description = "EKS cluster name for the cloud Kubernetes target.";
  };

  config.output.s3_endpoint = {
    value = "https://s3.amazonaws.com";
    description = "Real AWS S3 endpoint (cloud profile).";
  };
}
