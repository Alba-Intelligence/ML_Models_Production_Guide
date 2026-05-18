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
      imports = [./devenv_modules/modules/local.nix];
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
  '';

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    echo
  '';
}
