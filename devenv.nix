{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  nixUnstable = inputs.nixpkgs-unstable.packages.${pkgs.stdenv.hostPlatform.system};
  llms = inputs.llmpkgs.packages.${pkgs.stdenv.hostPlatform.system};
  naerskLib = pkgs.callPackage inputs.naersk { };

  alliumCliSrc = pkgs.runCommand "allium-cli-3.2.3-src" { } ''
    mkdir -p "$out"
    tar -xzf ${
      pkgs.fetchurl {
        url = "https://static.crates.io/crates/allium-cli/allium-cli-3.2.3.crate";
        hash = "sha256-Hf74VsRGSyFsyODyBnMVFIGHwQt3Nebjhgz6LJmmZ9k=";
      }
    } -C "$out" --strip-components=1
  '';

  alliumCli = naerskLib.buildPackage {
    pname = "allium-cli";
    version = "3.2.3";
    src = alliumCliSrc;
    singleStep = true;
  };

  devPkgs = with pkgs; [
    bun
    git
    pandoc
    quarto
    sphinx
    sphinx-lint
    sphinx-autobuild
    d2
    texlive.combined.scheme-full
  ];

  llmPkgs = with llms; [
    claude-code
    copilot-cli
    kilocode-cli
    opencode
    openskills
    openspec
    pi
    spec-kit
    rtk
  ];

  pythonPkgs = with pkgs.python313Packages; [
    nbdev
    ipykernel
  ];

  startJupyterScript = ''
    #!/usr/bin/env bash

    set -e
    export PROJECT_ROOT="$PWD"
    unset PYTHONPATH
    export REPO_ROOT=$(git --version 2>/dev/null && git rev-parse --show-toplevel || echo "$PROJECT_ROOT")
    export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"
    export JUPYTER_PATH="$PROJECT_ROOT/jupyter''${JUPYTER_PATH:+:$JUPYTER_PATH}"

    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.system}/lib:$(LD_LIBRARY_PATH="")
    export UV_PYTHON_DOWNLOADS=never
    export UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"
    if [ -f pyproject.toml ]; then
      if [ ! -x "$UV_PROJECT_ENVIRONMENT/bin/python" ]; then
        uv venv --python ${pkgs.python313}/bin/python "$UV_PROJECT_ENVIRONMENT" >/dev/null
      fi
      . "$UV_PROJECT_ENVIRONMENT/bin/activate"
      NEED_UV_SYNC=0
      if [ "''${UV_SYNC_REQUESTED:-0}" = "1" ]; then
        NEED_UV_SYNC=1
      elif ! uv sync --check >/dev/null 2>&1; then
        NEED_UV_SYNC=1
      fi
      if [ "$NEED_UV_SYNC" -eq 1 ]; then
        uv sync >/dev/null
      fi
    fi
    echo "Development environment ready"
    echo "Project root: $PROJECT_ROOT"
    echo "Repository root: $REPO_ROOT"
  '';

  localPkgs = [ alliumCli ];

  # K8s manifests as Nix strings
  k8sNamespace = ''
    # MLFlow namespace in Minikube
    apiVersion: v1
    kind: Namespace
    metadata:
      name: mlflow
  '';

  k8sPostgresDeployment = ''
    # PostgreSQL for MLFlow backend store
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mlflow-postgres
      namespace: mlflow
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mlflow-postgres
      template:
        metadata:
          labels:
            app: mlflow-postgres
        spec:
          containers:
            - name: postgres
              image: postgres:16-alpine
              ports:
                - containerPort: 5432
              env:
                - name: POSTGRES_USER
                  value: mlflow
                - name: POSTGRES_PASSWORD
                  value: mlflow
                - name: POSTGRES_DB
                  value: mlflow
              volumeMounts:
                - name: pgdata
                  mountPath: /var/lib/postgresql/data
              resources:
                requests:
                  memory: "128Mi"
                  cpu: "50m"
                limits:
                  memory: "256Mi"
                  cpu: "100m"
              livenessProbe:
                exec:
                  command: ["pg_isready", "-U", "mlflow"]
                initialDelaySeconds: 15
                periodSeconds: 10
          volumes:
            - name: pgdata
              persistentVolumeClaim:
                claimName: mlflow-postgres-pvc
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: mlflow-postgres
      namespace: mlflow
    spec:
      selector:
        app: mlflow-postgres
      ports:
        - port: 5432
          targetPort: 5432
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: mlflow-postgres-pvc
      namespace: mlflow
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
  '';

  k8sFlociDeployment = ''
    # Floci (LocalStack) for local AWS emulation
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mlflow-floci
      namespace: mlflow
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mlflow-floci
      template:
        metadata:
          labels:
            app: mlflow-floci
        spec:
          containers:
            - name: floci
              image: floci/floci:latest
              ports:
                - containerPort: 4566
              env:
                - name: FLOCI_HOSTNAME
                  value: "floci"
                - name: FLOCI_STORAGE_MODE
                  value: "persistent"
              volumeMounts:
                - name: floci-data
                  mountPath: /var/lib/floci
              resources:
                requests:
                  memory: "128Mi"
                  cpu: "50m"
                limits:
                  memory: "256Mi"
                  cpu: "100m"
              livenessProbe:
                httpGet:
                  path: /_localstack/health
                  port: 4566
                initialDelaySeconds: 30
                periodSeconds: 15
          volumes:
            - name: floci-data
              persistentVolumeClaim:
                claimName: mlflow-floci-pvc
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: mlflow-floci
      namespace: mlflow
    spec:
      selector:
        app: mlflow-floci
      ports:
        - port: 4566
          targetPort: 4566
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: mlflow-floci-pvc
      namespace: mlflow
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
  '';

  k8sFlociInitJob = ''
    # Floci bootstrap job to initialize S3 buckets and IAM roles
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: mlflow-floci-init
      namespace: mlflow
    spec:
      template:
        spec:
          restartPolicy: OnFailure
          containers:
            - name: floci-init
              image: amazon/aws-cli:2.15.56
              env:
                - name: AWS_ACCESS_KEY_ID
                  value: "test"
                - name: AWS_SECRET_ACCESS_KEY
                  value: "test"
                - name: AWS_DEFAULT_REGION
                  value: "fr-par"
                - name: AWS_ENDPOINT_URL
                  value: "http://mlflow-floci:4566"
              command:
                - /bin/sh
                - -c
                - |
                  echo "Initializing Floci buckets and roles..."
                  aws s3 mb s3://mlflow-artifacts --endpoint-url=http://mlflow-floci:4566 || true
                  aws s3 mb s3://model-registry --endpoint-url=http://mlflow-floci:4566 || true
                  aws iam create-role \\
                    --role-name ml-deploy-local \\
                    --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}' \\
                    --endpoint-url=http://mlflow-floci:4566 || true
                  echo "Floci init complete."
  '';

  k8sMlflowDeployment = ''
    # MLFlow server
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mlflow
      namespace: mlflow
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mlflow
      template:
        metadata:
          labels:
            app: mlflow
        spec:
          containers:
            - name: mlflow
              image: ghcr.io/mlflow/mlflow:v2.14.2
              ports:
                - containerPort: 5000
              env:
                - name: AWS_ACCESS_KEY_ID
                  value: "test"
                - name: AWS_SECRET_ACCESS_KEY
                  value: "test"
                - name: AWS_DEFAULT_REGION
                  value: "fr-par"
                - name: MLFLOW_S3_ENDPOINT_URL
                  value: "http://mlflow-floci:4566"
                - name: MLFLOW_TRACKING_URI
                  value: "http://mlflow-service:5000"
                - name: MLFLOW_BACKEND_STORE_URI
                  value: "postgresql://mlflow:mlflow@mlflow-postgres:5432/mlflow"
                - name: MLFLOW_ARTIFACTS_DESTINATION
                  value: "s3://mlflow"
              resources:
                requests:
                  memory: "256Mi"
                  cpu: "100m"
                limits:
                  memory: "512Mi"
                  cpu: "200m"
              livenessProbe:
                httpGet:
                  path: /
                  port: 5000
                initialDelaySeconds: 30
                periodSeconds: 10
              readinessProbe:
                httpGet:
                  path: /
                  port: 5000
                initialDelaySeconds: 10
                periodSeconds: 5
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: mlflow-service
      namespace: mlflow
    spec:
      selector:
        app: mlflow
      ports:
        - port: 5000
          targetPort: 5000
      type: ClusterIP
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: mlflow
      namespace: mlflow
    spec:
      selector:
        app: mlflow
      ports:
        - port: 5000
          targetPort: 5000
      type: NodePort
  '';

in
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # Profiles
  profiles = {
    localDev.module = {
      imports = [ ./devenv_modules/modules/local.nix ];
      env.ENVIRONMENT = "LOCAL";
    };
    cloudProd.module = {
      env.ENVIRONMENT = "CLOUD";
    };
    fullstack = {
      extends = [
        "localDev"
        "cloudProd"
      ];
    };
  };

  # Packages
  packages = devPkgs ++ localPkgs ++ pythonPkgs ++ llmPkgs;

  # Scripts
  scripts = {
    "start-jupyter.py".exec = startJupyterScript;
    "k8s/install.sh".exec = ''
      #!/usr/bin/env bash
      set -e
      echo "🚀 Installing MLFlow in Minikube..."
      if ! minikube status &>/dev/null; then
        echo "Starting Minikube..."
        minikube start --driver=docker
      fi
      echo "Applying Kubernetes manifests..."
      kubectl apply -f namespace.yaml
      kubectl apply -f postgres-deployment.yaml
      kubectl apply -f floci-deployment.yaml
      kubectl apply -f floci-init-job.yaml
      kubectl apply -f mlflow-deployment.yaml
      echo "Waiting for services to be ready..."
      kubectl wait --for=condition=ready pod -l app=mlflow-postgres -n mlflow --timeout=60s
      kubectl wait --for=condition=ready pod -l app=mlflow-floci -n mlflow --timeout=60s
      kubectl wait --for=condition=ready pod -l app=mlflow -n mlflow --timeout=60s
      echo ""
      echo "✅ MLFlow installed successfully!"
      echo ""
      echo "MLFlow UI: http://$(minikube ip):30000"
      echo "Floci S3: http://$(minikube ip):30001"
      echo ""
      echo "Commands:"
      echo "  kubectl get pods -n mlflow"
      echo "  kubectl get svc -n mlflow"
      echo "  minikube service mlflow-service -n mlflow"
    '';
  };

  # Docker compose configuration
  files."docker-compose.yml".text = builtins.toJSON {
    version = "3.8";
    services = {
      mlflow = {
        image = "ghcr.io/mlflow/mlflow:v2.14.2";
        ports = [ "5000:5000" ];
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
        environment = {
          "MLFLOW_S3_ENDPOINT_URL" = "http://floci:4566";
        };
        depends_on = [
          {
            condition = "service_healthy";
            service = "postgres";
          }
        ];
      };
      postgres = {
        image = "postgres:16-alpine";
        ports = [ "5432:5432" ];
        environment = {
          "POSTGRES_USER" = "mlflow";
          "POSTGRES_PASSWORD" = "mlflow";
          "POSTGRES_DB" = "mlflow";
        };
        healthcheck = {
          test = [
            "CMD-SHELL"
            "pg_isready -U mlflow"
          ];
          interval = "5s";
          timeout = "3s";
          retries = 20;
        };
      };
      floci = {
        image = "floci/floci:latest";
        ports = [ "4566:4566" ];
        environment = {
          "FLOCI_HOSTNAME" = "floci";
          "FLOCI_STORAGE_MODE" = "persistent";
        };
        volumes = [
          {
            type = "volume";
            source = "floci_data";
            target = "/var/lib/floci";
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
      traefik = {
        image = "traefik:v3.1.1";
        ports = [
          "80:80"
          "443:443"
          "8080:8080"
        ];
        volumes = [
          {
            type = "bind";
            source = "/var/run/docker.sock";
            target = "/var/run/docker.sock";
          }
        ];
        command = [
          "--api.insecure=true"
          "--api.dashboard=true"
          "--entrypoints.web.address=:80"
          "--entrypoints.websecure.address=:443"
          "--providers.docker=true"
          "--providers.docker.exposedbydefault=false"
          "--entrypoints.websecure.http.tls.certresolver=local"
        ];
      };
      floci-init = {
        image = "amazon/aws-cli:2.15.56";
        depends_on = [
          {
            condition = "service_healthy";
            service = "floci";
          }
        ];
        environment = {
          "AWS_ENDPOINT_URL" = "http://floci:4566";
        };
        entrypoint = [
          "/bin/sh"
          "-c"
        ];
        command = [
          ''echo "Initializing Floci buckets..." && aws s3 mb s3://mlflow-artifacts --endpoint-url=http://floci:4566 || true && aws s3 mb s3://model-registry --endpoint-url=http://floci:4566 || true && echo "Floci init complete."''
        ];
      };
    };
    volumes = {
      floci_data = { };
    };
  };

  # K8s manifests generated from Nix
  files."k8s/namespace.yaml".text = k8sNamespace;
  files."k8s/postgres-deployment.yaml".text = k8sPostgresDeployment;
  files."k8s/floci-deployment.yaml".text = k8sFlociDeployment;
  files."k8s/floci-init-job.yaml".text = k8sFlociInitJob;
  files."k8s/mlflow-deployment.yaml".text = k8sMlflowDeployment;

  # Enter shell
  enterShell = ''
    export PROJECT_ROOT="$PWD"
    unset PYTHONPATH
    export REPO_ROOT=$(git rev-parse --show-toplevel)
    export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"
    export JUPYTER_PATH="$PROJECT_ROOT/jupyter''${JUPYTER_PATH:+:$JUPYTER_PATH}"
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.system}/lib:$(LD_LIBRARY_PATH="")
    export UV_PYTHON_DOWNLOADS=never
    export UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"
    if [ -f pyproject.toml ]; then
      if [ ! -x "$UV_PROJECT_ENVIRONMENT/bin/python" ]; then
        uv venv --python ${pkgs.python313}/bin/python "$UV_PROJECT_ENVIRONMENT" >/dev/null
      fi
      . "$UV_PROJECT_ENVIRONMENT/bin/activate"
      NEED_UV_SYNC=0
      if [ "''${UV_SYNC_REQUESTED:-0}" = "1" ]; then
        NEED_UV_SYNC=1
      elif ! uv sync --check >/dev/null 2>&1; then
        NEED_UV_SYNC=1
      fi
      if [ "$NEED_UV_SYNC" -eq 1 ]; then
        uv sync >/dev/null
      fi
    fi
    git --version
    start-jupyter.py --ensure-only >/dev/null
    echo
    echo "Development environment ready"
    echo "Project root: $PROJECT_ROOT"
    echo "Repository root: $REPO_ROOT"
    echo ""
    echo "To start local MLFlow stack:"
    echo "  docker compose up -d"
    echo ""
    echo "To install MLFlow in Minikube:"
    echo "  k8s/install.sh"
    echo ""
    echo "MLFlow UI: http://localhost:5000"
    echo "Floci S3: http://localhost:4566"
    echo "Traefik dashboard: http://localhost:8080"
  '';

  # Languages
  languages = {
    python = {
      enable = true;
      package = pkgs.python3;
      venv.enable = false;
      uv.enable = true;
      uv.sync.enable = true;
      uv.sync.allGroups = true;
    };
    rust = {
      enable = true;
      channel = "stable";
      components = [
        "rustc"
        "cargo"
        "rust-std"
      ];
    };
  };

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    echo
  '';
}
