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
