# devenv_modules/modules/local.nix
# Terranix module: local_emulation profile overrides.
# Wires all services to Docker Compose endpoints (Floci, K3s, Slurm-Docker).
# Import alongside shared.nix in devenv_modules/profiles/local.nix.

{ config, lib, ... }:

with lib;

{
  imports = [ ./shared.nix ];

  config.mlDeploy = {
    profile = "local_emulation";
    mlflowTrackingUri = "http://localhost:5001";
    awsEndpointUrl = "http://localhost:4566"; # Floci
    postgresHost = "localhost";
  };

  # Floci-compatible provider configuration
  config.provider.aws = {
    region = config.mlDeploy.awsRegion;
    access_key = "test";
    secret_key = "test";
    skip_credentials_validation = true;
    skip_metadata_api_check = true;
    skip_requesting_account_id = true;
    endpoints = {
      s3 = config.mlDeploy.awsEndpointUrl;
      iam = config.mlDeploy.awsEndpointUrl;
      sts = config.mlDeploy.awsEndpointUrl;
      ec2 = config.mlDeploy.awsEndpointUrl;
      secretsmanager = config.mlDeploy.awsEndpointUrl;
      cloudwatch = config.mlDeploy.awsEndpointUrl;
      logs = config.mlDeploy.awsEndpointUrl;
    };
  };

  # Kubernetes provider pointing at Minikube
  config.provider.kubernetes = {
    host                   = "https://localhost:8443";
    cluster_ca_certificate = "$(cat ~/.minikube/certs/ca.crt)";
    skip_tls_verify       = true;
  };

  config.output.kubernetes_endpoint = {
    value = "https://localhost:8443";
    description = "Minikube local Kubernetes API endpoint.";
  };

  config.output.slurm_controller = {
    value = "localhost:6817";
    description = "Local Slurm controller endpoint (slurmctld).";
  };

  config.output.s3_endpoint = {
    value = "http://localhost:4566";
    description = "Floci S3 endpoint (local_emulation profile).";
  };

  # ===== Local Opentofu Setup =====
  # Provides local OpenTofu (Terraform fork) configuration for local development

  # OpenTofu configuration for local profile
  config.opentofu.local = {
    backend = {
      # Use local backend for state management
      type = "local";
    };

    required_providers = {
      aws = {
        source = "hashicorp/aws";
        version = "~> 5.0";
      };
      docker = {
        source = "kreuzwerker/docker";
        version = "~> 3.0";
      };
      kubernetes = {
        source = "hashicorp/kubernetes";
        version = "~> 2.0";
      };
    };

    # Local AWS provider with Floci endpoint
    provider.aws = {
      region = config.mlDeploy.awsRegion;
      skip_credentials_validation = true;
      skip_metadata_api_check = true;
      skip_requesting_account_id = true;
      endpoints = {
        s3 = config.mlDeploy.awsEndpointUrl;
        iam = config.mlDeploy.awsEndpointUrl;
        sts = config.mlDeploy.awsEndpointUrl;
        ec2 = config.mlDeploy.awsEndpointUrl;
        secretsmanager = config.mlDeploy.awsEndpointUrl;
        cloudwatch = config.mlDeploy.awsEndpointUrl;
        logs = config.mlDeploy.awsEndpointUrl;
      };
    };

    # Local Docker provider
    provider.docker = {
      host = "unix:///var/run/docker.sock";
    };

    # Local Kubernetes provider (Minikube)
    provider.kubernetes = {
      host                   = "https://localhost:8443";
      cluster_ca_certificate = "$(cat ~/.minikube/certs/ca.crt)";
      skip_tls_verify       = true;
    };

    # Docker network for local services
    resource.docker_network.ml_local = {
      name = "ml_local";
      driver = "bridge";
    };

    # Traefik reverse proxy for local services
    resource.docker_container.traefik = {
      name = "ml_deploy_traefik";
      image = "traefik:v3.1.1";
      ports = [
        {
          internal = 80;
          external = 80;
        }
        {
          internal = 443;
          external = 443;
        }
        {
          internal = 8080;
          external = 8080;
        }
      ];
      volumes = [
        {
          host_path = "/var/run/docker.sock";
          container_path = "/var/run/docker.sock";
        }
      ];
      networks_advanced = [ { name = "ml_local"; } ];
      command = [
        "--api.insecure=true"
        "--api.dashboard=true"
        "--entrypoints.web.address=:80"
        "--entrypoints.websecure.address=:443"
        "--providers.docker=true"
        "--providers.docker.exposedbydefault=false"
        "--providers.docker.network=ml_local"
      ];
      depends_on = [ "docker_network.ml_local" ];
    };

    # PostgreSQL for MLflow
    resource.docker_container.postgres = {
      name = "ml_deploy_postgres";
      image = "postgres:16-alpine";
      env = [
        "POSTGRES_USER=mlflow"
        "POSTGRES_PASSWORD=mlflow"
        "POSTGRES_DB=mlflow"
      ];
      ports = [
        {
          internal = 5432;
          external = 5432;
        }
      ];
      networks_advanced = [ { name = "ml_local"; } ];
      healthcheck = {
        test = [
          "CMD-SHELL"
          "pg_isready -U mlflow"
        ];
        interval = "5s";
        timeout = "3s";
        retries = 20;
      };
      depends_on = [ "docker_network.ml_local" ];
    };

    # MLflow server
    resource.docker_container.mlflow = {
      name = "ml_deploy_mlflow";
      image = "ghcr.io/mlflow/mlflow:v2.14.2";
      env = [
        "AWS_ACCESS_KEY_ID=test"
        "AWS_SECRET_ACCESS_KEY=test"
        "AWS_DEFAULT_REGION=fr-par"
        "MLFLOW_S3_ENDPOINT_URL=http://floci:4566"
      ];
      ports = [
        {
          internal = 5000;
          external = 5000;
        }
      ];
      networks_advanced = [ { name = "ml_local"; } ];
      command = [
        "mlflow"
        "server"
        "--host"
        "0.0.0.0"
        "--port"
        "5000"
        "--backend-store-uri"
        "postgresql://mlflow:mlflow@postgres:5432/mlflow"
        "--artifacts-destination"
        "s3://mlflow"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.mlflow.rule" = "Host(`mlflow.local`)";
        "traefik.http.routers.mlflow.entrypoints" = "web";
        "traefik.http.services.mlflow.loadbalancer.server.port" = "5000";
      };
      depends_on = [
        "docker_container.postgres"
        "docker_network.ml_local"
      ];
    };

    # Floci (LocalStack) for local AWS emulation
    resource.docker_container.floci = {
      name = "ml_deploy_floci";
      image = "floci/floci:latest";
      container_name = "ml_deploy_floci";
      user = "root";
      networks_advanced = [ { name = "ml_local"; } ];
      ports = [
        {
          internal = 4566;
          external = 4566;
        }
      ];
      environment = {
        FLOCI_HOSTNAME = "floci";
        FLOCI_STORAGE_MODE = "persistent";
        AWS_DEFAULT_REGION = "us-east-1";
      };
      volumes = [
        {
          host_path = "/var/run/docker.sock";
          container_path = "/var/run/docker.sock";
        }
        {
          host_path = "floci_data";
          container_path = "/var/lib/floci";
        }
      ];
      healthcheck = {
        test = [
          "CMD"
          "curl"
          "-f"
          "http://localhost:4566/_localstack/health"
        ];
        interval = "15s";
        timeout = "10s";
        retries = 5;
        start_period = "20s";
      };
    };

    # Floci bootstrap script to initialize buckets
    resource.docker_container.floci_bootstrap = {
      name = "ml_deploy_floci_bootstrap";
      image = "amazon/aws-cli:2.15.56";
      depends_on = [
        {
          condition = "service_healthy";
          container_name = "ml_deploy_floci";
        }
      ];
      networks_advanced = [ { name = "ml_local"; } ];
      environment = {
        AWS_ACCESS_KEY_ID = "test";
        AWS_SECRET_ACCESS_KEY = "test";
        AWS_DEFAULT_REGION = "us-east-1";
        AWS_ENDPOINT_URL = "http://floci:4566";
      };
      entrypoint = [
        "/bin/sh"
        "-c"
      ];
      command = [
        ''
          echo "Initialising Floci buckets and roles..."
          aws s3 mb s3://mlflow-artifacts --endpoint-url=http://floci:4566 || true
          aws s3 mb s3://model-registry --endpoint-url=http://floci:4566 || true
          aws iam create-role \
            --role-name ml-deploy-local \
            --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}' \
            --endpoint-url=http://floci:4566 || true
          echo "Floci init complete."
        ''
      ];
    };

    # Outputs
    output.local_infra_id = {
      value = "docker_network.ml_local.id";
      description = "Local infrastructure network ID";
    };

    output.opentofu_local_endpoint = {
      value = "http://localhost:8080";
      description = "Traefik dashboard endpoint";
    };

    output.floci_endpoint = {
      value = "http://localhost:4566";
      description = "Floci S3 endpoint";
    };
  };
}
