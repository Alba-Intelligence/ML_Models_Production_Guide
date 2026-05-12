#!/usr/bin/env bash
set -euo pipefail

# Regenerate published HTML docs from Quarto sources.
if command -v nix >/dev/null 2>&1; then
  nix develop -c quarto render . --no-execute
else
  quarto render . --no-execute
fi
