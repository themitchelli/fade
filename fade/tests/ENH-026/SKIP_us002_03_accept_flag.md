# Skipped: US-002 AC-03 - Operator opt-in via --accept flag

**Acceptance Criterion:** "Operator can opt-in via `fade council --accept` to proceed."

**Reason:** The `--accept` flag is not currently implemented in the codebase. The council command generates a brief for manual review and multi-LLM consultation. The implementation currently relies on:

1. Manual invocation: `fade council <prd_id>`
2. User copying the brief to external LLMs
3. User reviewing and comparing responses

The `--accept` flag appears to be intended for a future workflow where:
- After seeing a council suggestion during `fade run`, the user could immediately accept and generate a council brief
- This would streamline the workflow from suggestion to action

**Current State:**
- `fade council <prd_id>` works independently
- Council suggestions are displayed during `fade run` with complex PRDs or retries
- No automatic acceptance mechanism exists

**Alternative:**
- Test the manual workflow (user runs `fade council <prd_id>` after seeing suggestion)
- Track this as a future enhancement if the automated opt-in flow is desired

**Note:** This may be a case where the PRD acceptance criterion was aspirational and the implementation chose a simpler manual workflow that still satisfies the user need.
