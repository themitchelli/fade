# Skipped: US-001 AC-02 - Flow references repo context

**Acceptance Criterion:** The flow automatically references: repo structure, `FADE.md`, relevant standards, and (if present) `fade/map.md` or existing docs.

**Reason:** This criterion describes the internal behavior of the LLM interview flow during PRD generation. The specific context that Claude reads and references during the interview cannot be verified by automated shell tests without inspecting the internal prompt construction.

**Alternative verification:**
- Code review of `cmd_discover` function in fade-cli to confirm it builds context from FADE.md, standards/, and map.md
- Manual testing to observe the interview flow references project context
- Review of generated PRDs to confirm they reflect repo-specific details
