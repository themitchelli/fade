# FADE — Copilot Context

FADE (Framework for Agentic Development and Engineering) is a Bash CLI that gives
AI coding agents session memory, context management, and execution orchestration.
It solves the problem of starting every session with zero context by loading project
standards, progress history, and learnings from previous sessions.

**Tech Stack:** Bash (shell script) · No runtime dependencies · File-based state
**Repo:** https://github.com/themitchelli/fade
**Full project context:** `FADE.md` — architecture, standards, fragile areas, session
boundaries. This file is the strategic summary; FADE.md has the detail.

---

## Where We Are — v0.3.1

| Phase  | Description                          | Status      |
|--------|--------------------------------------|-------------|
| v0.1.x | Basic loop orchestration             | ✅ Complete |
| v0.2.x | Contained structure, archives        | ✅ Complete |
| v0.3.x | Standards, testing, codebase mapping | ✅ Complete |
| v0.4.x | NPM distribution, quick mode         | 📋 Planned  |

**Active work in `fade/prds/`:**
- FEAT-009: Quick mode for ad-hoc tasks
- FEAT-010: NPM distribution
- FEAT-011: Discovery phase
- FEAT-028: Scope and PR mode execution matrix

---

## Where We're Going — v0.4.x

Priorities in order:

1. **NPM distribution (FEAT-010)** — `npm install -g fade`. All templates must stay
   self-contained in `bin/fade-cli`. Nothing that requires the full repo at runtime.

2. **Quick mode (FEAT-009)** — `fade quick "fix this bug"` for tasks that don't
   warrant a full PRD. Reduces friction for small work.

3. **Scope + PR mode (FEAT-028)** — `--scope` and `--mode` flags for enterprise repos
   with branch protection. The unlock for Milliman and similar environments.

Bear this roadmap in mind. Changes that complicate NPM packaging or bloat the
self-contained script are a step backward.

---

## Fragile Areas

| Area | Risk |
|------|------|
| `cmd_run()` loop | Complex signal detection and restart logic — test carefully |
| Template heredocs | Easy to break quoting — run `bash -n` after any edit |
| `detect_interruption()` | Pattern-matches Claude error strings — brittle |
| Signal strings (`STORY_DONE`, `ALL_COMPLETE`) | Loop depends on exact match — no variants |
| Update mechanism | Changes could break all installed user copies |

---

## Hard Rules

- Never push directly to `main` — branch and PR
- Never remove backwards compatibility for legacy structure
- Always run `bash -n bin/fade-cli` before committing
- Version number changes need coordination (5 files — see FADE.md)
- Changing the update mechanism requires human approval

---

## LEARNINGS.md

Cross-session discoveries live in `LEARNINGS.md` at the repo root. Read it before
starting significant changes. Append to it when you find something non-obvious.
