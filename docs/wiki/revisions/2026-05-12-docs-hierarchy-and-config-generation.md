# Documentation hierarchy and generated config posture

## Summary

Elevated the docs contract so the website must read top-down, use Mermaid diagrams where helpful, and expose implementation-relevant code/config from the published pages. The repository posture also now expects Nix to generate Docker and Docker Compose config where practical.

## What changed

- Documentation series now requires a high-level introduction and hierarchical structure.
- Mermaid diagrams are explicitly required where they improve understanding.
- Published docs must surface copy-pastable Python source and generated config examples.
- The repository posture now expects Nix to generate Docker and Docker Compose artifacts as much as possible.

## Why it matters

This keeps the docs usable as an implementation reference instead of a flat notebook dump. It also narrows the gap between the published site and the actual generated configuration story, which helps future work on Nix-based config generation and notebook-owned source surfaces.
