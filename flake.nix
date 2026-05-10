{
  description = "ML Ops";

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      llmpkgs,
      naersk,
      pyproject-nix,
      uv2nix,
      pyproject-build-systems,
      ...
    }:
    let
      kernelName = "ml_ops";
      jupyterDir = "jupyter";
      kernelsDir = "${jupyterDir}/kernels";

      workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

      overlay = workspace.mkPyprojectOverlay {
        sourcePreference = "wheel";
      };

      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs lib.systems.flakeExposed;
      pythonSets = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          python = pkgs.python3;
        in
        (pkgs.callPackage pyproject-nix.build.packages {
          inherit python;
        }).overrideScope
          (
            lib.composeManyExtensions [
              pyproject-build-systems.overlays.wheel
              overlay
            ]
          )
      );

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
        naerskLib = pkgs.callPackage naersk { };
        cargoBuild = with pkgs; [
          rustc
          cargo
        ];

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

        pythonPkgs =
          (with pkgs; [
            uv
            sphinx
            pyright
            # jupyter-all
          ])
          ++ (with pkgs.python313Packages; [ ipykernel ]);

        devPkgs = with pkgs; [
          bash
          bun
          curl
          gawk
          gh
          git

          # Python
          basePython
          alliumCli
          startJupyter

          typst
          typst-live
          typstyle
          poppler-utils

          # awscli
        ];
        typstPkgs = with pkgs.typstPackages; [
          ori
          ilm
          tbl
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

        basePython = pkgs.python313;
        jupyterPython = pkgs.python313.withPackages (ps: [ ps.ipykernel ]);
        startJupyterPy = pkgs.writeText "start-jupyter.py" ''
          import os
          import subprocess
          import sys
          from pathlib import Path

          KERNEL_NAME = ${builtins.toJSON kernelName}
          JUPYTER_DIR = ${builtins.toJSON jupyterDir}
          KERNELS_DIR = ${builtins.toJSON kernelsDir}


          def ensure_kernel(project_root: Path) -> None:
              jupyter_path = os.environ.get("JUPYTER_PATH")
              project_jupyter_dir = str(project_root / JUPYTER_DIR)
              os.environ["JUPYTER_PATH"] = f"{project_jupyter_dir}:{jupyter_path}" if jupyter_path else project_jupyter_dir

              kernel_dir = project_root / KERNELS_DIR / KERNEL_NAME
              kernel_dir.mkdir(parents=True, exist_ok=True)

              subprocess.run(
                  [sys.executable, "-m", "ipykernel", "install", "--user", "--name", KERNEL_NAME, "--display-name", KERNEL_NAME],
                  check=True,
              )

              cfg_dir = Path.home() / ".jupyter"
              cfg_dir.mkdir(parents=True, exist_ok=True)
              (cfg_dir / "jupyter_server_config.py").write_text("c.ServerApp.disable_check_xsrf = True\n")
              (cfg_dir / "jupyter_notebook_config.py").write_text("c.NotebookApp.disable_check_xsrf = True\n")


          def main() -> None:
              project_root = Path(os.environ.get("PROJECT_ROOT", os.getcwd())).resolve()
              os.environ["PROJECT_ROOT"] = str(project_root)

              ensure_only = False
              passthrough_args = []
              for arg in sys.argv[1:]:
                  if arg == "--ensure-only":
                      ensure_only = True
                  else:
                      passthrough_args.append(arg)

              ensure_kernel(project_root)
              if ensure_only:
                  return

              cmd = [
                  "jupyter-lab",
                  "--no-browser",
                  '--ip=*',
                  "--NotebookApp.token=",
                  "--NotebookApp.password=",
                  "--ServerApp.disable_check_xsrf=True",
                  *passthrough_args,
              ]
              os.execvp(cmd[0], cmd)


          if __name__ == "__main__":
              main()
        '';

        startJupyter = pkgs.writeShellScriptBin "start-jupyter" ''
          set -euo pipefail

          exec ${jupyterPython}/bin/python ${startJupyterPy} "$@"
        '';

        shellEntryHook = ''
          export PROJECT_ROOT="$PWD"

          if [ -f .env ]; then
            set -a
            . ./.env
            set +a
          fi

          unset PYTHONPATH
          export REPO_ROOT=$(git rev-parse --show-toplevel)

          export JUPYTER_CONFIG_DIR="$HOME/.config/jupyter"
          export JUPYTER_PATH="$PROJECT_ROOT/${jupyterDir}''${JUPYTER_PATH:+:$JUPYTER_PATH}"
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

          start-jupyter --ensure-only >/dev/null

          echo
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = cargoBuild;
          packages = pythonPkgs ++ devPkgs ++ typstPkgs ++ llmPkgs;
          shellHook = shellEntryHook;
          env = {
            UV_NO_SYNC = "1";
            UV_PYTHON = "${basePython}/bin/python";
            UV_PYTHON_DOWNLOADS = "never";
          };
        };

        packages = forAllSystems (system: {
          default = pythonSets.${system}.mkVirtualEnv "ml_deploy" workspace.deps.default;
        });

        formatter = pkgs.nixfmt;
      }
    );

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    llmpkgs.url = "github:numtide/llm-agents.nix";
    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
