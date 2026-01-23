# FADE v0.3.1

**Framework for Agentic Development and Engineering**

FADE provides session memory, context management, and execution orchestration for AI coding agents like Claude Code. It solves the problem of starting every session with zero context by automatically loading project standards, progress history, and learnings from previous sessions.

## Quick Start

```bash
# 1. Initialize FADE in your project (no install needed)
cd /path/to/your/project
npx fade-dev init

# 2. Check your work queue
npx fade-dev status

# 3. Run Claude Code with FADE context
npx fade-dev run
```

Or install globally for shorter commands:

```bash
npm install -g fade-dev
fade init
fade status
fade run
```

## Installation

### Option 1: npx (No Install)

Run FADE without installing anything:

```bash
npx fade-dev init
npx fade-dev status
npx fade-dev run
```

The first run downloads the package; subsequent runs use the npm cache.

### Option 2: Global Install (Recommended)

Install once, use the shorter `fade` command everywhere:

```bash
npm install -g fade-dev
```

Verify installation:

```bash
fade help
fade version
```

### Option 3: Manual Installation

For development or if you prefer not to use npm:

```bash
git clone https://github.com/themitchelli/fade.git
sudo ln -s ~/path/to/fade/bin/fade-cli /usr/local/bin/fade
```

Or add to your `~/.zshrc` (or `~/.bashrc`):

```bash
export PATH="$HOME/path/to/fade/bin:$PATH"
```

### Upgrading

**npm users:**

```bash
# Global install: update to latest version
npm update -g fade-dev

# npx users: always get latest with @latest tag
npx fade-dev@latest init
```

**Manual install users:**

```bash
fade update
```

### Updating Project Artifacts

The npm package includes the CLI binary. Project artifacts (`prompt.md`, `standards/`, etc.) are managed separately via `fade update`:

```bash
# Check if project artifacts need updates
fade update --check

# Update prompt.md and sync standards/
fade update
```

This separation means:
- **npm** handles CLI version updates
- **fade update** handles project-level template updates

Both npm users and manual install users should run `fade update` periodically to get the latest prompt templates and standards.

## Project Structure

After running `fade init`, your project will have:

```
your-project/
├── FADE.md              # Project context (human-curated, read-only for AI)
├── CLAUDE.md            # Redirect for Claude Code discovery
└── fade/
    ├── prompt.md        # Execution protocol for Claude
    ├── progress.md      # Session history (append-only)
    ├── learned.md       # Cumulative discoveries (append-only)
    ├── prd.json         # Priority PRD (optional)
    ├── prds/            # PRD queue
    ├── prd-archive/     # Completed PRDs
    ├── standards/       # Coding standards (loaded by Claude when relevant)
    └── tests/           # Regression tests
```

**Key design decisions:**
- `FADE.md` stays at root for visibility - it's the "front door" to your project context
- `CLAUDE.md` redirects Claude Code to the right files
- Everything else is contained in `fade/` to keep root clean

### Legacy Structure (Still Supported)

Projects with the old flat structure still work:

```
your-project/
├── FADE.md
├── prompt.md
├── progress.md
├── learned.md
├── prd.json
└── prds/
```

Use `fade migrate` to upgrade to the contained structure.

## Commands

### `fade init`

Creates the FADE file structure in your project:

```bash
fade init
```

### `fade status`

Shows your current work queue without starting Claude:

```bash
fade status          # Pretty-printed with colours
fade status --json   # Machine-readable JSON output
```

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

Skip prompts and run in full autonomous mode:

```bash
fade yolo
```

This is a shortcut for `fade run --yolo` that:
- Shows your work queue
- Skips the STOP/ALL mode prompt (goes straight to ALL)
- Starts Claude with `--dangerously-skip-permissions`
- Displays 🤘 YOLO MODE indicator

**Warning:** Only use YOLO mode when you trust your PRD and understand what changes will be made.

### `fade new`

Create a new PRD:

```bash
fade new feature "User authentication"
fade new bug "Login timeout"  
fade new spike "Evaluate caching options"
fade new enhancement "Improve error messages"
fade new chore "Update dependencies"
```

### `fade migrate`

Upgrade from legacy flat structure to contained `fade/` structure:

```bash
fade migrate           # Interactive migration
fade migrate --dry-run # Preview without changes
fade migrate --yes     # Skip confirmation
```

### `fade map`

Analyze an existing codebase and generate FADE.md context (useful for brownfield projects):

```bash
fade map               # Analyze codebase, show results
fade map --init        # Generate draft FADE.md from analysis
fade map --init --force # Overwrite existing FADE.md
```

Detects:
- **Languages**: Counts files by extension
- **Frameworks**: Parses package.json, requirements.txt, Cargo.toml, go.mod, Gemfile
- **Architecture patterns**: MVC, API structure, service layer, monorepo, etc.
- **Dependencies**: Categorized by type (frameworks, database, testing, utilities)
- **Fragile areas**: Large files, tangled directories, legacy markers, TODO density
- **Directory structure**: Describes common folder purposes

Respects `.gitignore` and excludes common directories (node_modules, .git, venv, etc.).

### `fade export`

Export FADE context to a single file for use with Claude web:

```bash
fade export            # Creates fade-export.txt
```

Exports:
- Version info
- Folder structure
- FADE.md content
- Standards documents
- Current PRD queue
- Active PRD with stories

Useful for sharing project context outside of Claude Code.

### `fade update`

Update FADE CLI and templates:

```bash
fade update            # Update CLI and prompt.md
fade update --check    # Check for updates without applying
fade update --cli-only # Update CLI only, keep local prompt.md
```

### `fade version`

Show FADE version information:

```bash
fade version           # Show CLI version
fade version --all     # Show CLI version and all artifact versions
```

## PRD Management

### PRD Locations

| Location | Purpose |
|----------|---------|
| `fade/prd.json` | Priority PRD - processed first (new structure) |
| `fade/prds/` | Standard queue (new structure) |
| `prd.json` | Priority PRD (legacy, still supported) |
| `prds/` | Standard queue (legacy, still supported) |

The script checks the contained structure (`fade/`) first, then falls back to root for backwards compatibility.

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

After each story completion, the loop displays:

| Information | Description |
|-------------|-------------|
| **Story Passed** | Shows `US-XXX - Story Title` |
| **Acceptance Criteria** | Lists all criteria accomplished |
| **New Learnings** | Shows any additions to `learned.md` |
| **Git Commit** | Displays the commit message used |
| **Progress** | Shows `X of Y stories complete` |
| **PRD Status** | Checkboxes showing story completion status |

Use `--quiet` or `-q` to suppress iteration summaries:

```bash
fade yolo --quiet
```

### Regression Testing

FADE includes lightweight regression testing that runs after each story completion.

| Folder | Purpose |
|--------|---------|
| `fade/tests/` | Test folder root |
| `fade/tests/run.sh` | Test runner (auto-generated) |
| `fade/tests/PRD-*/` | Tests for each PRD |
| `fade/tests/PRD-*/prd.json` | Source PRD for test traceability |
| `fade/tests/failed.log` | Failure details (created on failures) |

**How it works:**
1. When `ALL_COMPLETE` is signalled, tests are generated from the PRD's acceptance criteria
2. After each `STORY_DONE`, the test runner executes all tests in `fade/tests/PRD-*/`
3. If tests pass, iteration continues
4. If tests fail, iteration blocks with details in `failed.log`

#### Managing Test Scope (Delete to Focus)

Tests accumulate as PRDs complete. To manage which tests run:

- **Delete PRD folders to exclude them:** `rm -rf fade/tests/PRD-001/`
- **Empty folder = pass:** With no `PRD-*/` folders, `run.sh` exits 0
- **No archive mechanism:** Just delete what you don't want

This gives you simple control over test scope. If you're working on PRD-005 and don't care about PRD-001 tests, delete that folder.

```bash
# Focus on current work
rm -rf fade/tests/PRD-001/
rm -rf fade/tests/PRD-002/

# Run remaining tests
fade/tests/run.sh
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
| `CLAUDE.md` | Redirect for Claude Code | Generated by `fade init` |
| `fade/prompt.md` | Execution instructions | Generated by `fade init` |
| `fade/progress.md` | Log of completed stories | Claude (append-only) |
| `fade/learned.md` | Discoveries from sessions | Claude (append-only) |
| `fade/standards/*.md` | Coding standards (api-security, git, coding, testing, documentation) | Generated by `fade init` |
| `fade/prd.json` | Priority work items | Human creates, Claude updates |
| `fade/prds/*.json` | Queued work items | Human creates, Claude updates |
| `fade/prd-archive/` | Completed PRDs | Automatic on `ALL_COMPLETE` |
| `fade/tests/` | Regression tests | Generated on `ALL_COMPLETE` |

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

- macOS or Linux
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
- bash

## Repository Structure

```
fade/
├── bin/
│   └── fade-cli         # The CLI executable
├── docs/
│   └── index.html       # Configuration wizard
├── fade/                # FADE's own context files (dogfooding!)
│   ├── prompt.md
│   ├── progress.md
│   ├── learned.md
│   ├── standards/       # Coding standards documents
│   ├── prds/
│   ├── prd-archive/
│   └── tests/           # Regression tests (run.sh + PRD-*/ folders)
├── FADE.md              # Project context for FADE itself
├── CLAUDE.md            # Claude Code redirect
├── README.md            # This file
├── VERSION              # Release version number
└── version-manifest.json # Version manifest for updates
```

## Version Manifest

The version manifest (`version-manifest.json`) provides version information for all FADE artifacts. It's used by `fade update` to check for and apply updates.

**Location:** `https://raw.githubusercontent.com/themitchelli/fade/main/version-manifest.json`

**Format:**

```json
{
  "release": "0.3.1",
  "artifacts": {
    "fade-cli": "0.3.1",
    "prompt.md": "0.3.1",
    "FADE.md": "0.3.1",
    "CLAUDE.md": "0.3.1",
    "learned.md": "0.3.1",
    "progress.md": "0.3.1"
  }
}
```

| Field | Description |
|-------|-------------|
| `release` | Current release version (semver) |
| `artifacts` | Map of artifact names to their individual versions |

The manifest allows the CLI to check versions without requiring GitHub repo access, and supports independent versioning of each artifact.

## License

MIT
