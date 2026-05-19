# devenv_modules/defaults.nix
# Constant default parameters for local and cloud profiles.
# All defaults are defined here in one place for easy maintenance.

{ ... }:

{
  # ── Project defaults ────────────────────────────────────────────────
  mlDeploy.projectName = "ml-deploy";
  mlDeploy.s3BucketArtifacts = "mlflow-artifacts";
  mlDeploy.s3BucketModelRegistry = "model-registry";
  mlDeploy.postgresDb = "mlflow";

  # ── AWS/Cloud defaults ─────────────────────────────────────────────
  mlDeploy.awsRegion = "fr-par"; # Paris, France
  mlDeploy.awsAccessKey = "test";
  mlDeploy.awsSecretKey = "test";

  # ── MLflow defaults ────────────────────────────────────────────────
  mlDeploy.mlflowBackendStoreUri = "postgresql://mlflow:mlflow@postgres:5432/mlflow";
  mlDeploy.mlflowArtifactsDestination = "s3://mlflow";
  mlDeploy.mlflowTrackingUri = "http://mlflow-service:5000";

  # ── Docker defaults ────────────────────────────────────────────────
  mlDeploy.dockerSock = "/var/run/docker.sock";

  # ── Kubernetes defaults ────────────────────────────────────────────
  mlDeploy.k8sEndpoint = "https://localhost:8443";
  mlDeploy.k8sCertPath = "~/.minikube/certs/ca.crt";

  # ── Docker compose service ports ───────────────────────────────────
  mlDeploy.mlflowPort = 5000;
  mlDeploy.postgresPort = 5432;
  mlDeploy.flociPort = 4566;
  mlDeploy.traefikWebPort = 80;
  mlDeploy.traefikWebsecurePort = 443;
  mlDeploy.traefikDashboardPort = 8080;

  # ── Minikube k8s ports ─────────────────────────────────────────────
  mlDeploy.minikubeMlflowPort = 30000;
  mlDeploy.minikubeFlociPort = 30001;

  # ── Container images ───────────────────────────────────────────────
  mlDeploy.mlflowImage = "ghcr.io/mlflow/mlflow:v2.14.2";
  mlDeploy.postgresImage = "postgres:16-alpine";
  mlDeploy.flociImage = "floci/floci:latest";
  mlDeploy.traefikImage = "traefik:v3.1.1";
  mlDeploy.awsCliImage = "amazon/aws-cli:2.15.56";

  # ── Floci bootstrap ────────────────────────────────────────────────
  mlDeploy.flociInitBuckets = [
    "mlflow-artifacts"
    "model-registry"
  ];
  mlDeploy.flociIamRole = "ml-deploy-local";
}
