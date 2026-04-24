---
applyTo: "bin/**,fade/tests/**,fade/lib/**,**/*.sh"
---

# Bash / Shell Script Standards

Applies to all shell scripts in this repo, especially `bin/fade-cli`.

## Style
- Follow [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Functions: `snake_case`
- Constants and env vars: `UPPER_SNAKE_CASE`
- Two-space indentation
- Always quote variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals, not `[ ]`

## Safety
- Every script starts with `set -e` (exit on error)
- Never use `eval` unless absolutely unavoidable
- Validate inputs at function entry — don't assume callers sanitise

## Portability
- This script runs on macOS (BSD) and Linux (GNU) — avoid GNU-only flags
- `sed -i` requires `sed -i ''` on BSD — use the portable form or check `fade/standards/shell-portability.md`
- Avoid `head -c`, `tail -n +N` differences — see `fade/standards/shell-portability.md`

## Before Every Commit
```bash
bash -n bin/fade-cli
```
This is non-negotiable. A syntax error in `bin/fade-cli` breaks all users.

## Fragile Areas — Extra Caution
- **`cmd_run()` loop** — signal detection and restart logic. Test every branch.
- **Template heredocs** — quoting is easy to break. Run `bash -n` and manually
  inspect the rendered template after any change.
- **`detect_interruption()`** — pattern-matches error strings. Changing patterns
  can break recovery from rate limits or service errors.
- **Signal strings** — `STORY_DONE`, `ALL_COMPLETE`, `BLOCKED` — the loop uses
  exact string matching. Never change format without updating both sides.

## Adding Functions to bin/fade-cli
- Keep functions focused (one job, ~30–50 lines target)
- Add to the appropriate section (commands, helpers, templates)
- New commands must be added to the help text in `cmd_help()`
- New templates must handle the `__FADE_VERSION__` placeholder substitution
