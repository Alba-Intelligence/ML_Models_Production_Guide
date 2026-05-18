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

    # LaTeX for Sphinx PDF export
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

    # Safely set LD_LIBRARY_PATH (= sign means "set only if unset")
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

  localPkgs = [
    alliumCli
  ];

in
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # Define a local profile and a cloud profile for development and deployment, respectively.
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

  # Full list of packages
  packages = devPkgs ++ localPkgs ++ pythonPkgs ++ llmPkgs;

  # Scripts
  scripts = {
    "start-jupyter.py".exec = startJupyterScript;
  };

  # Docker compose configuration for local MLFlow stack
  files."docker-compose.yml".text = builtins.toJSON {
    version = "3.8";
    services = {
      # ── MLFlow tracking server ──────────────────────────────────────
      mlflow = {
        image = "ghcr.io/mlflow/mlflow:v2.14.2";
        ports = [ "5000:5000" ];
        command = [
          "mlflow"
          "server"
          "--host" "0.0.0.0"
          "--port" "5000"
          "--backend-store-uri" "postgresql://mlflow:mlflow@postgres:5432/mlflow"
          "--artifacts-destination" "s3://mlflow"
        ];
        environment = {
          "AWS_ACCESS_KEY_ID" = "test";
          "AWS_SECRET_ACCESS_KEY" = "test";
          "AWS_DEFAULT_REGION" = "us-east-1";
          "MLFLOW_S3_ENDPOINT_URL" = "http://floci:4566";
        };
        depends_on = [
          { condition = "service_healthy"; service = "postgres"; }
        ];
      };

      # ── PostgreSQL for MLFlow ───────────────────────────────────────
      postgres = {
        image = "postgres:16-alpine";
        ports = [ "5432:5432" ];
        environment = {
          "POSTGRES_USER" = "mlflow";
          "POSTGRES_PASSWORD" = "mlflow";
          "POSTGRES_DB" = "mlflow";
        };
        healthcheck = {
          test = [ "CMD-SHELL" "pg_isready -U mlflow" ];
          interval = "5s";
          timeout = "3s";
          retries = 20;
        };
      };

      # ── Floci (LocalStack) for AWS emulation ────────────────────────
      floci = {
        image = "floci/floci:latest";
        ports = [ "4566:4566" ];
        environment = {
          "FLOCI_HOSTNAME" = "floci";
          "FLOCI_STORAGE_MODE" = "persistent";
          "AWS_DEFAULT_REGION" = "us-east-1";
        };
        volumes = [
          { type = "volume"; source = "floci_data"; target = "/var/lib/floci"; }
        ];
        healthcheck = {
          test = [ "CMD" "curl" "-f" "http://localhost:4566/_localstack/health" ];
          interval = "15s";
          timeout = "10s";
          retries = 5;
          start_period = "20s";
        };
      };

      # ── Traefik reverse proxy ───────────────────────────────────────
      traefik = {
        image = "traefik:v3.1.1";
        ports = [ "80:80" "443:443" "8080:8080" ];
        volumes = [
          { type = "bind"; source = "/var/run/docker.sock"; target = "/var/run/docker.sock"; }
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

      # ── Bootstrap script to init Floci ──────────────────────────────
      floci-init = {
        image = "amazon/aws-cli:2.15.56";
        depends_on = [
          { condition = "service_healthy"; service = "floci"; }
        ];
        environment = {
          "AWS_ACCESS_KEY_ID" = "test";
          "AWS_SECRET_ACCESS_KEY" = "test";
          "AWS_DEFAULT_REGION" = "us-east-1";
          "AWS_ENDPOINT_URL" = "http://floci:4566";
        };
        entrypoint = [ "/bin/sh" "-c" ];
        command = [
          ''
          echo "Initializing Floci buckets..."
          aws s3 mb s3://mlflow-artifacts --endpoint-url=http://floci:4566 || true
          aws s3 mb s3://model-registry --endpoint-url=http://floci:4566 || true
          echo "Floci init complete."
          ''
        ];
      };
    };
    volumes = {
      floci_data = {};
    };
  };

  # Files to write on shell enter
  enterShell = ''
    export PROJECT_ROOT="$PWD"
    unset PYTHONPATH
    export REPO_ROOT=$(git rev-parse --show-toplevel)
    export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"
    export JUPYTER_PATH="$PROJECT_ROOT/jupyter''${JUPYTER_PATH:+:$JUPYTER_PATH}"

    # Safely set LD_LIBRARY_PATH (= sign means "set only if unset")
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
    echo "MLFlow UI: http://localhost:5000"
    echo "Floci S3: http://localhost:4566"
    echo "Traefik dashboard: http://localhost:8080"
  '';

  # https://devenv.sh/languages/
  languages = {
    python = {
      enable = true;
      # Keep the shell's base interpreter lean and let uv manage project
      # dependencies in UV_PROJECT_ENVIRONMENT. We activate that environment in
      # enterShell so plain `python` and the Jupyter kernel both see `uv add`ed
      # packages such as torch.
      package = pkgs.python3;

      venv.enable = false;
      uv = {
        enable = true;
        sync = {
          enable = true;
          allGroups = true; # Install all dependency groups
        };
      };
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
