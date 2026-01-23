# Spike: Context Isolation via Sub-Agents

**Status:** In Progress
**Branch:** spike/context-isolation
**PRD:** SPIKE-001

---

## US-001: Research - Context Rot in FADE Sessions

### Context Size Analysis

Measured the typical context files that FADE loads at session start:

| File | Size (bytes) | Est. Tokens | Purpose |
|------|-------------|-------------|---------|
| FADE.md | 7,649 | ~1,912 | Project context (static) |
| prompt.md | 13,961 | ~3,490 | Execution protocol (static) |
| progress.md | 91,085 | ~22,771 | Session history (grows) |
| learned.md | 559 | ~139 | Cumulative discoveries |
| **Total** | **113,254** | **~28,313** | |

**Key Finding:** With 98 completed stories documented in progress.md, FADE context files consume ~28,000 tokens or **14% of Claude's 200k context window**.

### Context Growth Pattern

Progress.md is the primary growth driver. It currently contains:
- 98 story completion entries
- Average ~930 bytes per entry
- Total 1,464 lines

At this rate:
- After 200 stories: ~58,000 tokens from progress.md alone
- After 500 stories: ~145,000 tokens (72% of context)

However, FADE's **checkpoint-and-restart** pattern naturally prevents continuous context accumulation within a single session:

1. Each story completes with `STORY_DONE` signal
2. Fade script restarts Claude with fresh context
3. Only the committed progress.md content persists

### Session Boundary Analysis

Looking at archived PRDs:
- Largest PRD: ENH-009 (9 stories)
- Most PRDs: 5-6 stories
- Stories completed per session varies widely

The key question is: **Does context degrade WITHIN a single Claude session before STORY_DONE?**

### Intra-Session Context Degradation

Within a single story execution, context accumulates from:
1. Initial FADE context (~28k tokens)
2. Files read during implementation
3. Conversation turns with tool outputs
4. Code written to files

For a typical story:
- Read 3-5 files: ~10-15k tokens
- Tool outputs (grep, git): ~2-5k tokens
- Implementation discussion: ~5-10k tokens
- **Total per story: ~45-60k tokens**

This means a single story session uses **~25-30% of context** before reaching STORY_DONE.

### Quality Comparison: Story 1 vs Story N

Examining progress.md entries for the 9-story ENH-009-standards-folder PRD:

**US-001 (Story 1):**
- Clear, structured entry
- All files changed listed
- Tests documented

**US-009 (Story 9):**
- Same quality and structure
- Actually more detailed (12 bullet points vs 6)
- No degradation observed

This makes sense because FADE restarts Claude between stories. Each story gets a fresh context window.

### Conclusion for US-001

**Context rot is NOT a significant problem for FADE** because:

1. **Checkpoint-and-restart mitigates accumulation**: The STORY_DONE → restart cycle means each story gets a nearly fresh context window

2. **Progress.md growth is bounded by session**: Only the static file content (currently 28k tokens) loads at startup, not conversational history

3. **Intra-story context is manageable**: A single story rarely exceeds 60k tokens of context before completion

4. **Quality evidence**: No observable degradation in progress.md entries between early and late stories in multi-story PRDs

### When Context Isolation WOULD Help

Sub-agent isolation could provide value in specific scenarios:

| Scenario | Current Behavior | Isolated Would Help? |
|----------|------------------|---------------------|
| Normal story execution | Fresh context per story | No - already isolated |
| Very long single stories | Context grows during story | **Yes** - could spawn focused sub-tasks |
| Multi-file refactoring | Many files loaded | **Yes** - isolate per-file work |
| Parallel-capable tasks | Serial execution | **Yes** - parallel isolated workers |
| Rate limit recovery | Restart loses unsaved work | **Yes** - smaller isolated units complete faster |

### Recommendation

Based on US-001 research:

1. **Do NOT implement full sub-agent isolation** - FADE's current architecture already provides effective context isolation through checkpoint-and-restart

2. **Consider targeted isolation** for:
   - Long-running stories that exceed 100k context mid-execution
   - Parallelizable subtasks (e.g., generating tests for multiple stories)
   - Failure recovery scenarios

3. **Monitor progress.md growth** - At ~500 stories, the static context may need pruning or archiving

---

## US-002: Isolation Architecture Design

*[To be completed]*

---

## US-003: Prototype Isolated Story Execution

*[To be completed]*

---

## US-004: Comparison - Isolated vs Continuous

*[To be completed]*

---

## US-005: Learned.md Synchronization

*[To be completed]*

---

## Appendix: Data Sources

- FADE project: 98 completed stories across 24 archived PRDs
- Largest PRD analyzed: ENH-009 (9 stories)
- Context files measured: January 23, 2026
- Token estimation: ~4 characters per token (markdown/code)
