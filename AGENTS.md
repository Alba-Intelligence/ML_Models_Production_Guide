<!-- rtk-instructions v2 -->

# RTK (Rust Token Killer) - Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged. This means RTK is always safe to use.

**Important**: Even in command chains with `&&`, use `rtk`:

```bash
# ❌ Wrong
git add . && git commit -m "msg" && git push

# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## RTK Commands by Workflow

### Build & Compile (80-90% savings)

```bash
rtk cargo build         # Cargo build output
rtk cargo check         # Cargo check output
rtk cargo clippy        # Clippy warnings grouped by file (80%)
rtk tsc                 # TypeScript errors grouped by file/code (83%)
rtk lint                # ESLint/Biome violations grouped (84%)
rtk prettier --check    # Files needing format only (70%)
rtk next build          # Next.js build with route metrics (87%)
```

### Test (60-99% savings)

```bash
rtk cargo test          # Cargo test failures only (90%)
rtk go test             # Go test failures only (90%)
rtk jest                # Jest failures only (99.5%)
rtk vitest              # Vitest failures only (99.5%)
rtk playwright test     # Playwright failures only (94%)
rtk pytest              # Python test failures only (90%)
rtk rake test           # Ruby test failures only (90%)
rtk rspec               # RSpec test failures only (60%)
rtk test <cmd>          # Generic test wrapper - failures only
```

### Git (59-80% savings)

```bash
rtk git status          # Compact status
rtk git log             # Compact log (works with all git flags)
rtk git diff            # Compact diff (80%)
rtk git show            # Compact show (80%)
rtk git add             # Ultra-compact confirmations (59%)
rtk git commit          # Ultra-compact confirmations (59%)
rtk git push            # Ultra-compact confirmations
rtk git pull            # Ultra-compact confirmations
rtk git branch          # Compact branch list
rtk git fetch           # Compact fetch
rtk git stash           # Compact stash
rtk git worktree        # Compact worktree
```

Note: Git passthrough works for ALL subcommands, even those not explicitly listed.

### GitHub (26-87% savings)

```bash
rtk gh pr view <num>    # Compact PR view (87%)
rtk gh pr checks        # Compact PR checks (79%)
rtk gh run list         # Compact workflow runs (82%)
rtk gh issue list       # Compact issue list (80%)
rtk gh api              # Compact API responses (26%)
```

### JavaScript/TypeScript Tooling (70-90% savings)

```bash
rtk pnpm list           # Compact dependency tree (70%)
rtk pnpm outdated       # Compact outdated packages (80%)
rtk pnpm install        # Compact install output (90%)
rtk npm run <script>    # Compact npm script output
rtk npx <cmd>           # Compact npx command output
rtk prisma              # Prisma without ASCII art (88%)
```

### Files & Search (60-75% savings)

```bash
rtk ls <path>           # Tree format, compact (65%)
rtk read <file>         # Code reading with filtering (60%)
rtk grep <pattern>      # Search grouped by file (75%). Format flags (-c, -l, -L, -o, -Z) run raw.
rtk find <pattern>      # Find grouped by directory (70%)
```

### Analysis & Debug (70-90% savings)

```bash
rtk err <cmd>           # Filter errors only from any command
rtk log <file>          # Deduplicated logs with counts
rtk json <file>         # JSON structure without values
rtk deps                # Dependency overview
rtk env                 # Environment variables compact
rtk summary <cmd>       # Smart summary of command output
rtk diff                # Ultra-compact diffs
```

### Infrastructure (85% savings)

```bash
rtk docker ps           # Compact container list
rtk docker images       # Compact image list
rtk docker logs <c>     # Deduplicated logs
rtk kubectl get         # Compact resource list
rtk kubectl logs        # Deduplicated pod logs
```

### Network (65-70% savings)

```bash
rtk curl <url>          # Compact HTTP responses (70%)
rtk wget <url>          # Compact download output (65%)
```

### Meta Commands

```bash
rtk gain                # View token savings statistics
rtk gain --history      # View command history with savings
rtk discover            # Analyze Claude Code sessions for missed RTK usage
rtk proxy <cmd>         # Run command without filtering (for debugging)
rtk init                # Add RTK instructions to CLAUDE.md
rtk init --global       # Add RTK to ~/.claude/CLAUDE.md
```

## Token Savings Overview

| Category         | Commands                       | Typical Savings |
| ---------------- | ------------------------------ | --------------- |
| Tests            | vitest, playwright, cargo test | 90-99%          |
| Build            | next, tsc, lint, prettier      | 70-87%          |
| Git              | status, log, diff, add, commit | 59-80%          |
| GitHub           | gh pr, gh run, gh issue        | 26-87%          |
| Package Managers | pnpm, npm, npx                 | 70-90%          |
| Files            | ls, read, grep, find           | 60-75%          |
| Infrastructure   | docker, kubectl                | 85%             |
| Network          | curl, wget                     | 65-70%          |

Overall average: **60-90% token reduction** on common development operations.

<!-- /rtk-instructions -->

# AGENTS.md

This repository uses a **living Karpathy-style wiki** in `docs/wiki` as its long-term memory layer. It also uses the @agentmemory/agentmemory AI assistant database / graph db to assist in memory retrieval.

## Prime directive

**If you change the repository or learn something durable about it: update `docs/wiki` before you finish, memory_save to the @agentmemory/agentmemory, make a git commit.**

Work is not complete until the wiki reflects the new reality.

## What the wiki is for

The wiki is the compact, curated knowledge layer that lets future agents avoid re-reading the entire repository every session.

- Repository files are the canonical raw sources.
- `docs/wiki` is the synthesized layer.
- Agents should read the wiki first, then drill into raw files only when needed.

## Required workflow

### 1) At the start of a task

Read:

1. `docs/wiki/index.md`
2. Only the routed pages relevant to the task
3. Raw repo files only as needed

### 2) During the task

When you discover durable facts, decisions, commands, constraints, or open questions, fold them into the wiki instead of leaving them trapped in the session.

If the user has put the project into a planning/specification phase, **do not write implementation code** until the user explicitly confirms the specs are understood well enough to proceed. In that phase, prefer wiki/spec updates, tradeoff analysis, and clarification questions.

### 3) Before the final response

If anything substantive changed, update all relevant parts of the wiki:

- relevant page(s) under `docs/wiki/sources/`
- relevant topical page(s) under `docs/wiki/architecture/`, `docs/wiki/runbooks/`, or `docs/wiki/decisions/`
- `docs/wiki/current-state.md`
- `docs/wiki/index.md` if pages were added, removed, or repurposed
- `docs/wiki/revisions/YYYY-MM-DD-*.md` for non-trivial changes
- `docs/wiki/log.md` with an append-only entry

### 4) After the final response

- update the @agentmemory/agentmemory with memory_save
- make a Git commit

## Wiki structure

- `docs/wiki/index.md` — primary router and catalog
- `docs/wiki/overview.md` — high-level project summary
- `docs/wiki/current-state.md` — current repo snapshot, gaps, and near-term reality
- `docs/wiki/architecture/` — durable technical structure
- `docs/wiki/runbooks/` — commands and operational steps
- `docs/wiki/decisions/` — durable decisions and rationale
- `docs/wiki/sources/` — one synthesized page per important raw source file
- `docs/wiki/plans/` — active project plans and tracking documents
- `docs/wiki/revisions/` — artifacts describing significant wiki-affecting updates
- `docs/wiki/queries/` — reusable answers worth keeping
- `docs/wiki/archive/` — superseded or demoted pages

## Page conventions

Prefer compact, high-signal pages.

Each active page should ideally include:

- what it is for
- when it should be read
- links to upstream source files or wiki pages
- concise facts, not raw dumps
- explicit uncertainty where needed
- progress tracking for active plans
- completion status and next steps
- risk assessment and dependencies

## Special Instructions for Active Plans

When working on active plans (found in `docs/wiki/plans/`):

1. **Read the full plan first** before starting work
2. **Update progress** as tasks are completed
3. **Report new risks or gaps** discovered during work
4. **Check dependencies** before starting new tasks
5. **Update completion status** when milestones are reached
6. **Document any deviations** from the original plan
7. **Archive the plan** when completed

### Plan Tracking Format

Active plans should include:

- Clear status indicators (🟢 COMPLETE, 🟡 IN PROGRESS, ⏳ PENDING, ❌ BLOCKED)
- Progress checklist with completion percentages
- Risk assessment with mitigation strategies
- Dependencies and blocking issues
- Next steps and milestones
- Success criteria and quality metrics

## Current Active Plans

### 🟡 Documentation Restructuring Plan

- **Location**: `docs/wiki/plans/documentation-restructuring-plan.md`
- **Goal**: Split documentation into Tutorial and Reference sections
- **Status**: Phase 2 (Content Restructuring) in progress
- **Next**: Tutorial Section Creation
- **Owner**: Emmanuel
- **Priority**: High
- **Deadline**: Within 2 weeks

This plan addresses critical issues with unclear terminology (EX-01, EX-02, EX-03) and mixed content types that confuse users.

## Maintenance rules

- Do not duplicate large raw file contents into the wiki.
- Summarize and link back to canonical files.
- Prefer updating an existing page over creating a near-duplicate.
- Keep cross-links and index entries in sync.
- Keep `docs/wiki/current-state.md` honest.
- If a change affects commands, dependencies, behavior, architecture, or project shape, the wiki must change too.
- If a task produces a reusable explanation, consider saving it under `docs/wiki/queries/`.

## Scope rules

- Use the active wiki for current, high-value knowledge.
- Move stale or superseded material to `docs/wiki/archive/` instead of deleting context blindly.
- External sources should only be added if the user asks or if they are necessary for durable project knowledge.

## Quality bar

The wiki should help a future agent answer:

- What is this repo?
- What exists right now?
- How do I run it?
- What are the important constraints?
- What changed recently?
- Which raw files matter for this task?

If the wiki cannot answer those quickly, improve it.
