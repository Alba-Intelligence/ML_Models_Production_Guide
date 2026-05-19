# devenv_modules/defaults.nix
# Constant default parameters for local and cloud profiles.
# All defaults are defined here in one place for easy maintenance.

{ ... }:

{
  # Project defaults
  mlDeploy.projectName = "ml-deploy";
  mlDeploy.s3BucketArtifacts = "mlflow-artifacts";
  mlDeploy.s3BucketModelRegistry = "model-registry";
  mlDeploy.postgresDb = "mlflow";
  mlDeploy.postgresPort = 5432;

  # AWS/Cloud defaults
  mlDeploy.awsRegion = "fr-par";  # Paris, France
  mlDeploy.awsAccessKey = "test";
  mlDeploy.awsSecretKey = "test";

  # MLflow defaults
  mlDeploy.mlflowBackendStoreUri = "postgresql://mlflow:mlflow@postgres:5432/mlflow";
  mlDeploy.mlflowArtifactsDestination = "s3://mlflow";

  # Docker defaults
  mlDeploy.dockerSock = "/var/run/docker.sock";

  # Kubernetes defaults
  mlDeploy.k8sEndpoint = "https://localhost:8443";
  mlDeploy.k8sCertPath = "~/.minikube/certs/ca.crt";
}
