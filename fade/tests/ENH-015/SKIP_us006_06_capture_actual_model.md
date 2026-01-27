# SKIP: US-006 AC-06 - Capture what model was actually used

## Acceptance Criteria
Capture what model was actually used and log to outcome

## Why Not Testable via Shell
This AC requires running a full fade run session and verifying that the actual model used is captured and logged. Testing this would require:
1. Executing a complete fade run session
2. Having Claude Code actually run with a model
3. Verifying the outcome is logged post-completion

This is an end-to-end integration concern that cannot be tested in isolation with shell scripts.
