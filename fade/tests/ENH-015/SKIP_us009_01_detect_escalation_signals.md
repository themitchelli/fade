# SKIP: US-009 AC-01 - Detect escalation signals in cmd_run loop

## Acceptance Criteria
In cmd_run() loop, detect escalation signals:
- Model takes >1.5x estimated duration for similar PRD
- Test failures or blocked state after session 1
- Multiple STORY_DONE iterations without progressing

## Why Not Testable via Shell
This AC requires:
1. Running a full fade run session with actual Claude Code execution
2. Monitoring real-time execution duration
3. Detecting test failures or blocked states during active execution
4. Tracking STORY_DONE iterations in real-time

These are runtime behaviors that cannot be tested with static shell scripts. This requires integration testing with actual PRD execution.
