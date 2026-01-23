# Skipped: US-001 AC-02 - Launches Claude Code

**Acceptance Criterion:** "Launches Claude Code with task description as prompt"

**Reason:** This criterion requires actually executing Claude Code with a task, which:
1. Would incur API costs for each test run
2. Requires Claude Code to be installed and authenticated
3. Has variable execution time and output
4. Cannot be reliably verified in an automated shell test

**Alternative:** Manual verification during development. The implementation can be inspected in `bin/fade-cli` at the `cmd_quick()` function where `exec $claude_cmd "$context"` is called.
