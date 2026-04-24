# Learnings

Cross-session discoveries that shape future work. Append-only.

Only add entries that are:
- **Reusable** — applies beyond the specific story that surfaced it
- **Non-obvious** — something a fresh session wouldn't know
- **Actionable** — helps avoid mistakes or speeds up work

Format:
```
## YYYY-MM-DD - Discovery Title
- **What:** Brief description
- **Why it matters:** How this helps future work
- **Files:** Which modules or paths this applies to
```

---

## 2026-01-25 - Checkpoint Pattern Prevents Context Rot

- **What:** FADE sessions use only 16–19% of a 200k token window. The
  commit-after-each-story pattern achieves context isolation without sub-agents.
  File-based state (progress.md, learned.md) is the memory — not conversation history.
- **Why it matters:** Don't over-engineer context management. The current design
  already solves the problem. Optimisation effort is better spent on test generation
  and model routing.
- **Files:** All execution flows — `cmd_run()`, checkpoint protocol, context building.
