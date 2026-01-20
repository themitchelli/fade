# FADE v0.2.3

**Framework for Agentic Development and Engineering**

FADE provides session memory, context management, and execution orchestration for AI coding agents like Claude Code. It solves the problem of starting every session with zero context by automatically loading project standards, progress history, and learnings from previous sessions.

## Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/themitchelli/fade.git

# 2. Add to PATH (add this line to ~/.zshrc)
export PATH="$HOME/Documents/GitHub/fade:$PATH"

# 3. Reload shell
source ~/.zshrc

# 4. Initialize FADE in your project
cd /path/to/your/project
fade init

# 5. Check your work queue
fade status

# 6. Run Claude Code with FADE context
fade run
```

## Installation

Add the following line to your `~/.zshrc` (or `~/.bashrc` for bash):

```bash
export PATH="$HOME/Documents/GitHub/fade:$PATH"
```

Then reload your shell:

```bash
source ~/.zshrc
```

Verify installation:

```bash
fade help
```

## Commands

### `fade init`

Creates the FADE file structure in your project:

```bash
fade init
```

This creates:
- `FADE.md` - Project context (you fill this in)
- `progress.md` - Session history log
- `learned.md` - Cumulative discoveries
- `prompt.md` - Execution instructions for Claude
- `prds/` - PRD queue folder with README

### `fade status`

Shows your current work queue without starting Claude:

```bash
fade status          # Pretty-printed with colours
fade status --json   # Machine-readable JSON output
```

Displays:
- Priority PRD (`prd.json`) if present
- Queue PRDs from `prds/` folder
- Done/remaining counts per PRD

### `fade run`

Starts a Claude Code session with FADE context:

```bash
fade run
```

Shows your work queue, then prompts for execution mode:

| Mode | Description |
|------|-------------|
| **STOP** (or S) | Complete one story, then pause for review |
| **ALL** (or A) | Process all stories with fresh context between each |

### `fade yolo` 🤘

Skip prompts and run in full autonomous mode with no permission prompts:

```bash
fade yolo
```

This is a shortcut for `fade run --yolo` that:
- Shows your work queue
- Skips the STOP/ALL mode prompt (goes straight to ALL mode)
- Starts Claude with `--dangerously-skip-permissions` (no permission prompts)
- Displays 🤘 YOLO MODE indicator

**What does `--dangerously-skip-permissions` do?**

Normally, Claude Code asks for permission before running commands, editing files, or performing other actions. With this flag enabled, Claude will execute all actions without asking - perfect for trusted PRDs where you want fully autonomous execution.

**Warning:** Only use YOLO mode when you trust your PRD and understand what changes will be made. Review your PRD acceptance criteria carefully before running.

### `fade run --yolo`

Equivalent to `fade yolo`:

```bash
fade run --yolo
```

## PRD Management

### PRD Locations

| Location | Purpose |
|----------|---------|
| `prd.json` | Priority PRD - processed first if it has incomplete stories |
| `prds/` | Standard queue - processed by filename order |

### PRD Naming Convention

Files in `prds/` follow: `{TYPE}-{NUMBER}-{slug}.json`

| Type | Description |
|------|-------------|
| FEAT | Feature |
| BUG | Bug fix |
| CHORE | Maintenance/operational |
| ENH | Enhancement |
| SPIKE | Exploration |

Examples:
- `FEAT-001-user-authentication.json`
- `BUG-002-login-timeout.json`
- `CHORE-003-upgrade-dependencies.json`

### PRD Structure

```json
{
  "type": "feature",
  "name": "Feature Name",
  "userStories": [
    {
      "id": "US-001",
      "title": "Story title",
      "acceptanceCriteria": ["Criterion 1", "Criterion 2"],
      "priority": 1,
      "passes": false
    }
  ]
}
```

## Execution Modes

### STOP Mode

- Completes one story
- Claude outputs `STORY_DONE: US-XXX`
- Session ends
- Run `fade run` again to continue

### ALL Mode (Bash Loop Orchestration)

- Processes stories continuously
- Fresh context loaded between each story
- Loop detects signals and restarts Claude automatically
- Continues until `ALL_COMPLETE` or `BLOCKED`

### Iteration Feedback (ALL/YOLO Mode)

After each story completion, the loop displays a rich summary:

| Information | Description |
|-------------|-------------|
| **Story Passed** | Shows `US-XXX - Story Title` |
| **Acceptance Criteria** | Lists all criteria accomplished |
| **New Learnings** | Shows any additions to `learned.md` |
| **Git Commit** | Displays the commit message used |
| **Progress** | Shows `X of Y stories complete` |
| **PRD Status** | Checkboxes showing story completion status |

Use `--quiet` or `-q` to suppress iteration summaries while keeping final messages:

```bash
fade run --yolo --quiet   # Minimal output, max speed
fade yolo --quiet         # Same as above
```

**Example iteration summary:**

```
═══════════════════════════════════════════════════════════════
                    Iteration 2 Complete
═══════════════════════════════════════════════════════════════

✓ USER STORY PASSED: US-002
  Add validation to user input form

Acceptance Criteria Accomplished:
  ✓ Form validates email format
  ✓ Form shows inline error messages
  ✓ Submit button disabled until valid

New Learnings Captured:
  + ## 2026-01-20 - Zod validation pattern
  + Using Zod with React Hook Form provides type-safe validation

Git Commit:
  feat: complete US-002 - Add validation to user input form (ENH-001)

Progress: 2 of 5 stories complete

Current PRD Status:
  ENH-001-user-forms.json
    [✓] US-001: Create basic form component
    [✓] US-002: Add validation to user input form
    [ ] US-003: Add form submission handling
    [ ] US-004: Add loading states
    [ ] US-005: Add success/error feedback

───────────────────────────────────────────────────────────────
Starting next iteration...
───────────────────────────────────────────────────────────────
```

### Signal Protocol

| Signal | Meaning |
|--------|---------|
| `STORY_DONE: US-XXX` | Story done, more work remains |
| `ALL_COMPLETE` | All stories completed |
| `BLOCKED: [reason]` | Cannot proceed, needs intervention |

## File Reference

| File | Purpose | Who writes it |
|------|---------|---------------|
| `FADE.md` | Project context, standards, architecture | Human (read-only for Claude) |
| `progress.md` | Log of completed stories | Claude (append-only) |
| `learned.md` | Discoveries from sessions | Claude (append-only) |
| `prompt.md` | Execution instructions | Generated by `fade init` |
| `prd.json` | Priority work items | Human creates, Claude updates |
| `prds/*.json` | Queued work items | Human creates, Claude updates |

## Git Commit Conventions

FADE uses conventional commit prefixes:

| Prefix | Use |
|--------|-----|
| `feat:` | New feature |
| `fix:` | Bug fix |
| `docs:` | Documentation |
| `chore:` | Maintenance, dependencies, operational |
| `refactor:` | Code restructure |
| `spike:` | Exploratory work |

## Requirements

- macOS (primary platform)
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- bash

## License

MIT
