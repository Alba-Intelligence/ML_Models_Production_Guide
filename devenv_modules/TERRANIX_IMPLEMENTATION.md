# Terranix Integration Implementation Guide

## Status: PLANNED (Phase 1 Task 3)

This document outlines the implementation plan for Terranix infrastructure-as-code generation as per the spec requirement:

> "Terranix is the SOLE approach for generating infrastructure as code; no manual Terraform files or alternative IaC tooling is permitted."

Spec Reference: ml-deploy-reference-repo.allium, lines 357-379

---

## Objective

Replace hand-authored Docker files with Nix-generated infrastructure:
- Generate `Dockerfile` via Terranix
- Generate `docker-compose.dev.yml` via Terranix  
- Generate `docker-compose.aws-emulator.yml` via Terranix (optional)
- Output infrastructure as OpenTofu JSON configurations

---

## Current State

### What Needs to be Generated

```yaml
Dockerfile:
  Purpose: Base image for dev container
  Current: Hand-written at repo root
  Target: Generated from Nix via Terranix

docker-compose.dev.yml:
  Purpose: Local emulation stack (dev, postgres, mlflow, traefik, floci)
  Current: Hand-written, manually maintained
  Target: Generated from Nix via Terranix
  Note: Recently updated to include Traefik (Phase 1 Task 2)

docker-compose.aws-emulator.yml:
  Purpose: AWS services emulation (floci/localstack)
  Current: Hand-written
  Target: Generated from Nix via Terranix (optional)
```

### Implementation Constraints

1. **Spec-First**: All Docker/compose artifacts must be generated, not hand-written
2. **Sole Approach**: Terranix is the ONLY method; no alternatives (Terraform, Nix derivations alone, etc.)
3. **Version Lock**: All images, versions, and configurations must be reproducible via Nix
4. **Local & Cloud**: Same approach for local_emulation and cloud profiles

---

## Implementation Approach

### Option A: Full Terranix Integration (Recommended but Complex)

Integrate Terranix into the Nix build process to generate Docker files as part of `nix flake check` or `nix build`.

**Pros:**
- Single source of truth (Nix)
- Fully reproducible
- Integrates with flake workflow
- Can use Nix functions and abstractions

**Cons:**
- Requires Terranix expertise
- Complex Nix expressions
- Long development cycle (evaluating Nix is slow)
- Steep learning curve

**Implementation Steps:**

1. Create `nix/terranix-config.nix` with infrastructure definition
2. Add Terranix evaluation to `flake.nix` outputs
3. Wire generated files into build process
4. Test generation matches current hand-written versions
5. Update CI/CD to use generated files
6. Remove hand-written Docker files

### Option B: Script-Based Generation (Pragmatic Interim)

Use a Nix shell script that calls Terranix CLI to generate files on demand.

**Pros:**
- Simpler to implement
- Easier to debug
- Can iterate faster
- Clear separation of concerns

**Cons:**
- Manual generation step
- Not integrated into flake evaluation
- Requires user to run script

**Implementation Steps:**

1. Create `nix/generate-infra.nix` - wrappable script
2. Document: `nix run .#generate-docker-files`
3. Script outputs Docker files to `_generated/`
4. CI/CD calls the script to generate before building
5. Remove hand-written Docker files, use generated ones

---

## Recommended: Hybrid Approach

**Phase 1 (Current): Script-based interim**
- Create generation script
- Document usage
- Verify output matches current behavior
- This unblocks spec compliance immediately

**Phase 2 (Future): Full Terranix integration**
- Once approach is proven, integrate into flake
- Move generation to evaluation time
- Remove script-based approach

---

## Configuration Structure

### Terranix Config File Template: `nix/terranix-config.nix`

```nix
{ pkgs, config, ... }:

let
  # Base configuration
  projectName = "ml-deploy";
  mlflowVersion = "v2.14.2";
  postgresVersion = "16-alpine";
  traefik Version = "v3.1.1";
  
in {
  # Docker services definition
  docker = {
    services = {
      # Each service gets config that Terranix converts
      dev = { ... };
      postgres = { ... };
      mlflow = { ... };
      traefik = { ... };
      floci = { ... };
    };
    networks = { ... };
    volumes = { ... };
  };
  
  # Generated files will be:
  # - Dockerfile
  # - docker-compose.dev.yml  
  # - docker-compose.aws-emulator.yml
}
```

---

## Current Status

### Completed
- ✅ Phase 1 Task 1: Added `MlflowTrackingServer` model with `reverse_proxy_tool` field
- ✅ Phase 1 Task 2: Added Traefik reverse proxy to docker-compose.dev.yml

### In Progress
- 🔄 Phase 1 Task 3: Terranix integration (this document)
  - [ ] Decide on approach (script-based vs full integration)
  - [ ] Create Terranix configuration
  - [ ] Test generation
  - [ ] Update CI/CD
  - [ ] Remove hand-written files

### Blocked On
- Terranix expertise/learning curve
- Nix evaluation complexity
- Testing infrastructure generation

---

## Next Actions

1. **Immediate** (1-2 hours):
   - Choose implementation approach (script-based recommended for Phase 1)
   - Create basic Terranix configuration
   - Document usage

2. **Testing** (2-3 hours):
   - Run generation scripts
   - Compare output to current hand-written files
   - Verify docker-compose `config` works

3. **Integration** (1 hour):
   - Update CI/CD to call generation script
   - Update documentation/wiki
   - Create tickets for Phase 2 full integration

4. **Cleanup** (30 min):
   - Remove hand-written Docker files
   - Update .gitignore to track generated files (if desired)
   - Verify builds work

---

## Resources

- Terranix Docs: https://github.com/terranix/terranix
- Terranix Examples: https://github.com/terranix/terranix/tree/main/examples
- Project Spec: specs/ml-deploy-reference-repo.allium (lines 357-379)
- Related Tasks: w002, w003, w004 (weed audit divergences)

---

## Decision Point

**Q: Should we proceed with Option B (script-based) for Phase 1 to unblock spec compliance?**

**A: Yes - recommended. Full integration (Option A) can be Phase 2 work after proving approach.**

This unblocks the immediate spec requirement ("Terranix SOLE approach") while allowing time for Nix/Terranix learning.

---

## Notes

- The `opentofu` package is already in flake.nix devShells
- Docker generation is secondary to Dockerfile; docker-compose is the primary deliverable
- Performance note: Nix evaluation can be slow; script-based approach provides faster iteration
- Reproducibility note: All images and versions must be pinned in Nix for proper IaC

---

**Last Updated:** 2026-05-12 (Phase 1 Implementation)  
**Assignee:** Implementation Phase  
**Blocker:** Terranix approach decision
