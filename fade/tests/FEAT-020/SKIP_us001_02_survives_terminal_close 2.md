# Skipped: US-001 AC-02 - Run continues after terminal close

**Acceptance Criterion:** "A run started with `--detach` continues running if the invoking shell session is closed (within reason for OS process handling)."

**Reason:** Testing process survival after terminal close requires spawning and closing actual terminal sessions, which cannot be reliably automated in a shell-based test. This depends on OS-specific process handling (SIGHUP, nohup behavior) and TTY allocation that varies across environments.

**Alternative:** Manual testing by:
1. Start a detached run with `fade run --detach`
2. Close the terminal window
3. Open new terminal and verify run is still active with `fade status`

Integration tests in CI/CD could potentially verify this using session management tools.
