# Global Copilot Instructions — Template

This file is a template. To install it, copy it to:
  `~/.copilot/copilot-instructions.md`   (macOS / Linux)
  `C:\Users\<you>\.copilot\copilot-instructions.md`  (Windows)

It loads automatically for every Copilot CLI session across all repos.

---

# Global Instructions

## Engineering Standards
Team standards are maintained centrally in the `LTS-LABS/engineering.standards` repo.

**Setup (one-time):**
1. Clone `LTS-LABS/engineering.standards` to a stable local path
2. Set this environment variable in your shell profile:
   - Windows: `$env:COPILOT_CUSTOM_INSTRUCTIONS_DIRS = "C:\Users\<you>\Documents\GitHub\engineering.standards"`
   - macOS/Linux: `export COPILOT_CUSTOM_INSTRUCTIONS_DIRS="$HOME/engineering.standards"`
3. Keep current: `git pull` in that repo periodically

Once set, Copilot loads the standards automatically for every session.

## Before You Start
1. Read `.github/copilot-instructions.md` for project context, strategic direction,
   and constraints. This shapes every decision — don't skip it.
2. Read `AGENTS.md` if present — it contains the execution protocol for this repo.
3. Read the Issue or spec for the task. Understand acceptance criteria before
   writing a line of code.
4. For complex work (multiple files, architectural decisions), use `/plan` first.

## Spec-First Rule
Never implement a feature without written acceptance criteria. If none exist,
stop and ask. The cost of building the wrong thing always exceeds the cost of
writing a spec first.

## When Stuck or Blocked
- Say clearly what's blocking and what input or decision is needed
- Don't invent requirements or make up behaviour to keep moving
- Partial coherent work with a clear note beats silent wrong work
- For ambiguous requirements: ask one focused question, don't bundle multiple

## Raising Pull Requests
- Use `/delegate` to raise a PR from the current session
- Always work on a branch — never commit directly to `main` in protected repos
- Commit and checkpoint before delegating
