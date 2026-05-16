{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
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

  localPkgs = [
    alliumCli
    startJupyter
  ];

  jupyterPython = pkgs.python313.withPackages (ps: [ ps.ipykernel ]);
  startJupyterPy = pkgs.writeText "start-jupyter.py" ''
    import os
    import subprocess
    import sys
    from pathlib import Path

    KERNEL_NAME = "ml_ops"
    JUPYTER_DIR = "jupyter"
    KERNELS_DIR = "jupyter/kernels"


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
            "--ip=*",
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
in
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = devPkgs ++ localPkgs ++ pythonPkgs ++ llmPkgs;

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
    export UV_PYTHON_DOWNLOADS=never
    export UV_PROJECT_ENVIRONMENT="$PROJECT_ROOT/.venv"
    export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH

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
    start-jupyter --ensure-only >/dev/null
    echo
  '';

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
    echo
  '';
}
