<!-- FADE FADE.md v0.3.1 -->

# FADE

<!-- FADE.md - Project context for AI coding agents. This file is READ-ONLY for agents. -->

---

## Project Overview

FADE (Framework for Agentic Development and Engineering) provides session memory, context management, and execution orchestration for AI coding agents like Claude Code. It solves the problem of starting every session with zero context by automatically loading project standards, progress history, and learnings from previous sessions.

**Tech Stack:**
- Language: Bash (shell script)
- Framework: None (standalone CLI)
- Database: None (file-based state)

**Repository:** https://github.com/themitchelli/fade

---

## Coding Standards

### Style Guides

- **Bash:** Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- **Markdown:** Use standard GitHub-flavored markdown

### Project Conventions

- Naming: `snake_case` for functions, `UPPER_CASE` for constants
- Tests: Shell scripts in `fade/tests/` with exit code semantics
- Commits: Conventional commits format (`feat:`, `fix:`, `chore:`)
- Always run `bash -n bin/fade-cli` to syntax-check before committing

---

## Standards

| Standard | Description |
|----------|-------------|
| [API Security](fade/standards/api-security.md) | Authentication, authorization, input validation, secure error handling |
| [Architecture](fade/standards/architecture.md) | Operational excellence, security, reliability, performance, cost, sustainability |
| [Git](fade/standards/git.md) | Commit messages, branch naming, FADE-specific conventions |
| [Coding](fade/standards/coding.md) | Naming, formatting, error handling, code organization |
| [Testing](fade/standards/testing.md) | Test pyramid, AAA pattern, mocking, coverage requirements |
| [Documentation](fade/standards/documentation.md) | README structure, API docs, code comments, what NOT to document |
| [Shell Portability](fade/standards/shell-portability.md) | BSD/GNU compatibility, portable alternatives for head/sed/tail |

---

## Architecture References

### System Overview

```
┌──────────────────────────────────────────────────────────────────────────┐
│                              fade-cli                                      │
│                         (bin/fade-cli)                                     │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  Commands:                                                                 │
│  ├── init       Create FADE structure in a project                        │
│  ├── new        Create new PRD files                                      │
│  ├── map        Analyze codebase for FADE.md context                      │
│  ├── run        Execute Claude Code with FADE context                     │
│  ├── yolo       Run in autonomous mode (skip permissions)                 │
│  ├── status     Show work queue                                           │
│  ├── export     Export context for Claude web                             │
│  ├── migrate    Move legacy files to contained structure                  │
│  ├── update     Update CLI and templates                                  │
│  └── version    Show version info                                         │
│                                                                            │
│  Context Files (per project):                                             │
│  ├── FADE.md        Project context (human-curated)                       │
│  ├── prompt.md      Execution protocol for Claude                         │
│  ├── progress.md    Session history (append-only)                         │
│  ├── learned.md     Discoveries (append-only)                             │
│  ├── standards/     Coding standards documents                            │
│  ├── prds/          PRD queue                                             │
│  └── tests/         Regression tests                                      │
│                                                                            │
└──────────────────────────────────────────────────────────────────────────┘
```

### Key Documents

| Document | Location | Description |
|----------|----------|-------------|
| CLI Script | `bin/fade-cli` | Main executable (~5000 lines) |
| Prompt Template | `fade/prompt.md` | Execution protocol embedded in context |
| Version Manifest | `version-manifest.json` | Version tracking for updates |

---

## Off-Limits Modules

| Path | Reason | Contact |
|------|--------|---------|
| None currently | - | - |

---

## Session Boundaries

### Allowed Actions

- Create, modify, delete files in `bin/`, `fade/`, `docs/`
- Run bash syntax checks (`bash -n bin/fade-cli`)
- Modify templates embedded in fade-cli
- Update documentation (README.md, standards/)

### Requires Human Approval

- Changing the update mechanism (could break user installations)
- Modifying version numbers (coordinated release)
- Changes to signal detection logic (could break loop)

### Never Do

- Push directly to `main` or `master`
- Commit broken syntax (always run `bash -n` first)
- Remove backwards compatibility for legacy structure

---

## System Context

### Current Challenges

- Test generation relies on Claude Code executing in non-interactive mode
- Rate limiting can interrupt long PRD executions

### Transition Plan

| Phase | Description | Status |
|-------|-------------|--------|
| v0.1.x | Basic loop orchestration | ✅ COMPLETE |
| v0.2.x | Contained structure, archives | ✅ COMPLETE |
| v0.3.x | Standards, testing, codebase mapping | ✅ COMPLETE |
| v0.4.x | NPM distribution, quick mode | ← PLANNED |

### Active Work Items

- [CHORE] Release 0.3.1 documentation update - in progress
- [FEATURE] Quick mode for ad-hoc tasks - FEAT-009 / queued
- [FEATURE] NPM distribution - FEAT-010 / queued
- [FEATURE] Discovery phase - FEAT-011 / queued

---

## Development Environment

### Local Development

```bash
# Test changes
bash -n bin/fade-cli  # Syntax check

# Link for testing
sudo ln -sf "$(pwd)/bin/fade-cli" /usr/local/bin/fade

# Run help to verify
fade help
```

### Version Bumping

When releasing:
1. Update `FADE_VERSION` in `bin/fade-cli`
2. Update `ARTIFACT_VERSION` in `bin/fade-cli`
3. Update version in `fade/prompt.md` header
4. Update `version-manifest.json`
5. Update `VERSION` file

---

## Additional Context

- FADE dogfoods itself - this repo uses FADE for development
- The `fade/` folder contains FADE's own context files
- PRDs drive all feature development

---

## Target Architecture

- Simple shell script (no Node.js, no Python runtime requirements)
- File-based state (no database, no network storage)
- Works offline (except for `fade update` which fetches from GitHub)

---

## Fragile Areas

| Area | Why it's fragile |
|------|------------------|
| `cmd_run()` loop | Complex signal detection and restart logic |
| Template strings | Heredocs with placeholders, easy to break quoting |
| `detect_interruption()` | Pattern matching for various Claude error states |
