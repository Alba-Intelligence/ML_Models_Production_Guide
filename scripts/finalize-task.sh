#!/usr/bin/env bash
set -euo pipefail

install_local_quarto() {
  local version arch tar_arch url tmp_tar target_dir
  version="${QUARTO_VERSION:-1.6.42}"
  arch="$(uname -m)"
  case "$arch" in
    x86_64) tar_arch="amd64" ;;
    aarch64|arm64) tar_arch="arm64" ;;
    *)
      echo "Unsupported architecture for local Quarto bootstrap: $arch" >&2
      return 1
      ;;
  esac

  target_dir=".tools/quarto"
  mkdir -p "$target_dir"
  tmp_tar="$(mktemp)"
  url="https://github.com/quarto-dev/quarto-cli/releases/download/v${version}/quarto-${version}-linux-${tar_arch}.tar.gz"
  curl -fsSL "$url" -o "$tmp_tar"
  tar -xzf "$tmp_tar" -C "$target_dir" --strip-components=1
  rm -f "$tmp_tar"
}

# Standard end-of-task workflow:
# 1) export notebook code, 2) render publishable docs, 3) run tests.
if ! command -v quarto >/dev/null 2>&1; then
  install_local_quarto
  export PATH="$PWD/.tools/quarto/bin:$PATH"
fi

if command -v nix >/dev/null 2>&1; then
  python scripts/generate-docker-artifacts.py
fi

uv run nbdev-export --path nbs/
quarto render . --to html --no-execute
uv run python -m unittest discover -s tests -q
