# FADE v0.2.0 - Project Description

**Framework for Agentic Development and Engineering**

## Overview

FADE provides session memory, context management, and execution orchestration for AI coding agents like Claude Code. It solves the problem of starting every session with zero context by automatically loading project standards, progress history, and learnings from previous sessions.

## Version 0.2.0 Features

### Execution Modes: STOP and ALL

FADE v0.2.0 introduces two execution modes for processing user stories:

| Mode | Behavior | Use Case |
|------|----------|----------|
| **STOP** | Complete one story, then pause | Review each story before continuing |
| **ALL** | Process all stories automatically | Batch processing with fresh context between stories |

When you run `fade run`, you choose your execution mode:
- Enter `STOP` or `S` for single-story mode
- Enter `ALL` or `A` for continuous processing

### Bash Loop Orchestration (ALL Mode)

In ALL mode, FADE uses bash loop orchestration to process multiple stories:

1. Claude completes a story and outputs `STORY_DONE: US-XXX`
2. The bash loop detects the signal
3. Loop restarts Claude with **fresh context** (updated progress.md)
4. Process repeats until `ALL_COMPLETE` or `BLOCKED`

This ensures each story starts with clean context while maintaining session memory through files.

### Signal Protocol

Claude signals completion status to the orchestrator:

| Signal | Meaning | Loop Behavior |
|--------|---------|---------------|
| `STORY_DONE: US-XXX` | Story completed, more work remains | Continue to next story |
| `ALL_COMPLETE` | All stories done | Exit with success message |
| `BLOCKED: [reason]` | Cannot proceed | Exit for human intervention |

### Work Queue Management

The `fade status` command shows your work queue without starting Claude:

```bash
fade status          # Pretty-printed with colours
fade status --json   # Machine-readable JSON output
```

Features:
- Priority PRD (`prd.json`) shown separately from queue (`prds/`)
- Done/remaining counts per PRD
- Helpful message when queue is empty

## Git Commit Conventions

FADE uses conventional commit prefixes:

| Prefix | Use |
|--------|-----|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation |
| `chore:` | Maintenance, dependencies, operational tasks |
| `refactor:` | Code restructure, no behaviour change |
| `spike:` | Exploratory work (spike branches only) |

Note: Use `chore:` for operational/maintenance work (not `toil:`).

## Commands

| Command | Description |
|---------|-------------|
| `fade init` | Create FADE structure (FADE.md, progress.md, learned.md, prompt.md, prds/) |
| `fade run` | Show work queue, choose STOP/ALL mode, start Claude Code |
| `fade status` | Show current work queue |
| `fade help` | Show help message |

## PRD File Locations

```
./prd.json      # Priority PRD (processed first if has incomplete work)
./prds/         # Standard queue (processed by filename order)
```

PRD naming convention: `{TYPE}-{NUMBER}-{slug}.json`
- Types: FEAT, BUG, CHORE, ENH, SPIKE
- Example: `FEAT-001-user-authentication.json`
