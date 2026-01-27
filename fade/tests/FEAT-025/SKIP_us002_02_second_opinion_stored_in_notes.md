# Skipped: US-002 AC-02 - Second-opinion stored in _notes

**Acceptance Criterion:** Second-opinion output is stored alongside PRD in `fade/prds/_notes/` or similar.

**Reason:** Testing this criterion requires executing a full `fade prd new --second-opinion "Feature"` command which:
1. Runs an interactive Claude session to generate the PRD
2. Calls `cmd_council` to generate the second opinion
3. Requires API costs and LLM execution time

**Alternative verification:**
- Code review of `cmd_prd_new` function (lines ~6076-6086 in fade-cli) confirms:
  - It creates `$prds_dir/_notes/` directory
  - It saves council output to `$prds_dir/_notes/${new_prd_id}-council.md`
- Manual testing by running `fade prd new --second-opinion "Test Feature"` and checking `fade/prds/_notes/` for the council file
