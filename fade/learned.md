<!-- FADE learned.md v0.3.1 -->

# Learned

Discoveries and insights from development sessions. Append-only.

<!--
Entry format (append new entries below the line):

## YYYY-MM-DD - Discovery Title

**Context:** What were you doing when you discovered this?
**Learning:** What did you learn?
**Relevance:** Why does this matter for future work?
**Files affected:** Which modules/files does this apply to?

Only add learnings that are:
- Reusable (not story-specific details)
- Non-obvious (things a future session wouldn't know)
- Actionable (helps avoid mistakes or speeds up work)
-->

---


## 2026-01-25 - FADE's Checkpoint Pattern Prevents Context Rot

**Source:** SPIKE-001 US-001

**What:** Analyzed 25 completed PRDs (104 user stories) to measure context accumulation and quality degradation. Found FADE sessions use only 16-19% of Claude's 200k token window, with 100% completion rate regardless of PRD size. The checkpoint-and-restart pattern (commit after each story, load fresh context from files) achieves the same isolation benefits as GSD's sub-agent architecture without the complexity.

**Why it matters:** Prevents over-engineering. No need to implement isolated sub-agents or optimize context loading. The file-based state design already solves the context rot problem that plagues conversation-history-based systems. Focus optimization efforts elsewhere (test generation, model routing, multi-repo orchestration).

**Key metrics:**
- Session start: ~31,555 tokens (15.8% of window)
- Session end (6-story PRD): ~35,000 tokens (17.5% of window)
- Largest PRD (9 stories): ~38,000 tokens (19% of window)
- Completion rate: 100% across all sizes

**Files affected:** All FADE execution flows (cmd_run, checkpoint protocol, context building)

## $(date +"%Y-%m-%d") - Blocked State Recovery Patterns

**Source:** FEAT-022 US-002

**What:** Implemented automatic triage for BLOCKED states by categorizing reasons into recoverable vs unrecoverable types. Pattern matching on blocked reasons enables targeted resolution strategies: test failures delegate to self-healing, missing dependencies prompt operator questions, unclear requirements request clarification. Each category gets specific guidance in operator_questions.md rather than generic "blocked" messages.

**Why it matters:** Reduces human interruption for recoverable BLOCKED states. Instead of halting on every BLOCKED signal, FADE can now distinguish between "I need help" (operator question) vs "I'm broken" (unrecoverable). This enables better autonomous flow while maintaining safety guardrails. Pattern matching on blocked reason text is brittle but effective—future sessions should maintain the category patterns when updating BLOCKED detection logic.

**Key patterns:**
- Test failures: "test.*fail", "regression.*fail", "assertion.*fail"
- Missing deps: "command not found", "missing.*package", "no such file.*bin"
- Unclear reqs: "unclear", "ambiguous", "missing.*context"
- Environment: "env.*var", "database.*url", "api.*key"
- Permissions: "permission denied", "cannot.*write", "read-only"

**Files affected:** bin/fade-cli (categorize_blocked_reason, attempt_blocked_resolution, create_operator_question, BLOCKED handler in cmd_run)
