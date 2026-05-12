#!/usr/bin/env bash
set -euo pipefail

# Regenerate published HTML docs from Quarto sources.
if command -v quarto >/dev/null 2>&1; then
  quarto render . --no-execute
elif command -v nix-shell >/dev/null 2>&1; then
  nix-shell --packages quarto --run 'quarto render . --no-execute'
else
  echo "Error: quarto is not installed and nix-shell is unavailable." >&2
  exit 1
fi
