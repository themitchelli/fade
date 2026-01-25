# Skipped: US-001 AC-04 - Session can be exited early with Ctrl+C

**Acceptance Criterion:** "Session can be exited early with Ctrl+C"

**Reason:** This requires interactive terminal testing with signal handling that cannot be reliably automated via a shell script. The behavior depends on the terminal's TTY handling and Claude's process behavior when receiving SIGINT.

**Alternative:** Manual testing by running `fade discover "test feature"` and pressing Ctrl+C to verify clean exit.

**Implementation Note:** The discover command uses `exec $claude_cmd` which transfers process control to Claude, making Ctrl+C handling dependent on the claude CLI tool itself rather than fade-cli.
