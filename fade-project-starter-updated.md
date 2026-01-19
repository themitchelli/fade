# FADE v0.2.0 - Getting Started

Quick start guide for FADE (Framework for Agentic Development and Engineering).

## Installation

```bash
# Clone the repository
git clone https://github.com/themitchelli/fade.git

# Add to PATH (add to ~/.zshrc or ~/.bashrc)
export PATH="$HOME/Documents/GitHub/fade:$PATH"

# Reload shell
source ~/.zshrc

# Verify installation
fade help
```

## Initialize a Project

```bash
cd /path/to/your/project
fade init
```

This creates:
- `FADE.md` - Project context (you fill this in)
- `progress.md` - Session history (Claude appends)
- `learned.md` - Discoveries (Claude appends)
- `prompt.md` - Execution instructions
- `prds/` - PRD queue folder

## Create Your First PRD

Create `prds/FEAT-001-my-feature.json`:

```json
{
  "type": "feature",
  "name": "My First Feature",
  "userStories": [
    {
      "id": "US-001",
      "title": "Implement feature X",
      "acceptanceCriteria": [
        "Criterion 1",
        "Criterion 2"
      ],
      "priority": 1,
      "passes": false
    }
  ]
}
```

## Check Your Work Queue

```bash
fade status
```

Shows all PRDs with incomplete stories, done/remaining counts.

For JSON output (scripting):
```bash
fade status --json
```

## Run Claude Code

```bash
fade run
```

1. Shows your work queue
2. Prompts for execution mode:
   - **STOP** (or S): Complete one story, then pause
   - **ALL** (or A): Process all stories automatically
3. Claude starts with full context loaded

## Execution Modes Explained

### STOP Mode
- Completes one story
- Session ends after `STORY_DONE` signal
- You review, then run `fade run` again

### ALL Mode (Bash Loop Orchestration)
- Processes stories continuously
- Fresh context loaded between each story
- Loop continues until:
  - `ALL_COMPLETE` - All work done
  - `BLOCKED` - Needs human intervention
  - No signal - Stops with warning

## Signal Protocol

Claude outputs these signals:

| Signal | When | What Happens |
|--------|------|--------------|
| `STORY_DONE: US-XXX` | Story done, more work | Loop continues (ALL mode) |
| `ALL_COMPLETE` | All stories done | Clean exit |
| `BLOCKED: [reason]` | Can't proceed | Exit for intervention |

## Git Conventions

Use these commit prefixes:

```bash
git commit -m "feat: add user authentication"
git commit -m "fix: resolve login timeout"
git commit -m "chore: update dependencies"
git commit -m "docs: update API documentation"
git commit -m "refactor: simplify error handling"
```

Note: Use `chore:` for maintenance tasks (not `toil:`).

## PRD Naming Convention

Files in `prds/` follow: `{TYPE}-{NUMBER}-{slug}.json`

| Type | Description |
|------|-------------|
| FEAT | Feature |
| BUG | Bug fix |
| CHORE | Maintenance/operational |
| ENH | Enhancement |
| SPIKE | Exploration |

Examples:
- `FEAT-001-authentication.json`
- `BUG-002-login-timeout.json`
- `CHORE-003-upgrade-deps.json`

## Priority PRD

Place urgent work in `prd.json` (root directory). It's processed before anything in `prds/`.

## Tips

1. **Fill in FADE.md** - The more context you provide, the better Claude performs
2. **Use STOP mode** for new projects until you trust the setup
3. **Check status** before running to see what's queued
4. **Review progress.md** to see what Claude has done
5. **Check learned.md** for insights Claude discovered
