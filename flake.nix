{
  description = "ML Ops";

  outputs =
    {
      flake-utils,
      nixpkgs,
      llmpkgs,
      ...
    }:
    let
      kernelName = "ml_ops";
      jupyterDir = "jupyter";
      kernelsDir = "${jupyterDir}/kernels";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          # config.cudaSupport = true;
        };
        lib = pkgs.lib;
        llms = llmpkgs.packages.${system};
        basePython = pkgs.python313;
        ensureJupyterKernel = pkgs.writeShellScriptBin "ensure-jupyter-kernel" ''
          set -euo pipefail

          project_root="''${PROJECT_ROOT:-$PWD}"
          export kernel_name=${lib.escapeShellArg kernelName}
          export JUPYTER_PATH="$project_root/${jupyterDir}''${JUPYTER_PATH:+:$JUPYTER_PATH}"

          mkdir -p "$project_root/${kernelsDir}/$kernel_name"
          chmod -R u+w "$project_root/${kernelsDir}/$kernel_name"

          if ! python -c 'import ipykernel' >/dev/null 2>&1; then
            echo "error: ipykernel is not installed in the active Python environment: $(command -v python)" >&2
            echo "hint: run 'uv sync' (or add jupyter/ipykernel to pyproject.toml) before installing the kernel" >&2
            exit 1
          fi

          python -m ipykernel install \
            --user \
            --name "$kernel_name" \
            --display-name "$kernel_name"

          for cfg_dir in \
            "$HOME/.jupyter" \
            "$HOME/.config/Cursor/User/globalStorage/ms-toolsai.jupyter/version-2025.9.1"; do
            mkdir -p "$cfg_dir"
            echo "c.ServerApp.disable_check_xsrf = True" > "$cfg_dir/jupyter_server_config.py"
            echo "c.NotebookApp.disable_check_xsrf = True" > "$cfg_dir/jupyter_notebook_config.py"
          done
        '';
        startJupyter = pkgs.writeShellScriptBin "start-jupyter" ''
          set -euo pipefail

          export PROJECT_ROOT="''${PROJECT_ROOT:-$PWD}"
          export kernel_name=${lib.escapeShellArg kernelName}

          ${ensureJupyterKernel}/bin/ensure-jupyter-kernel >/dev/null

          exec jupyter-lab \
            --no-browser \
            --ip="*" \
            --NotebookApp.token="" \
            --NotebookApp.password="" \
            --ServerApp.disable_check_xsrf=True \
            "$@"
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages =
            (with pkgs; [
              bash
              bun
              curl
              gawk
              gh
              git

              # Python
              basePython
              ensureJupyterKernel
              startJupyter
              pyright
              sphinx
              uv
              # jupyter-all

              typst
              typst-live
              typstyle
              poppler-utils

              # awscli
            ])
            ++ (with pkgs.typstPackages; [
              ori
              ilm
              tbl
            ])
            ++ (with llms; [
              claude-code
              copilot-cli
              kilocode-cli
              opencode
              openskills
              openspec
              pi
              spec-kit
              rtk
            ]);

          shellHook = ''
            export PROJECT_ROOT="$PWD"

            if [ -f .env ]; then
              set -a
              . ./.env
              set +a
            fi

            export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"
            export JUPYTER_PATH="$PROJECT_ROOT/${jupyterDir}''${JUPYTER_PATH:+:$JUPYTER_PATH}"
            export kernel_name=${lib.escapeShellArg kernelName}
            export UV_PYTHON_DOWNLOADS=never
            export UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"
            # export LD_LIBRARY_PATH=${pkgs.cudaPackages.cuda_cudart}/lib64:${pkgs.cudaPackages.cuda_cudart}/lib:$LD_LIBRARY_PATH
            export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH

            if [ -f pyproject.toml ]; then
              if [ ! -x "$UV_PROJECT_ENVIRONMENT/bin/python" ]; then
                echo "Creating project virtualenv in $UV_PROJECT_ENVIRONMENT"
                uv venv --python ${basePython}/bin/python "$UV_PROJECT_ENVIRONMENT" >/dev/null
                uv sync >/dev/null
              fi

              . "$UV_PROJECT_ENVIRONMENT/bin/activate"
            fi

            python --version
            git --version

            if python -c 'import ipykernel' >/dev/null 2>&1; then
              ensure-jupyter-kernel >/dev/null
            fi

            echo
          '';
        };

        formatter = pkgs.nixfmt;
      }
    );

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    llmpkgs.url = "github:numtide/llm-agents.nix";
  };
}
