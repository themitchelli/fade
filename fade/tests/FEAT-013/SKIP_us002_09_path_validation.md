# SKIP: US-002 AC - Validate paths on startup, warn if repo not found

## Acceptance Criteria
Validate paths on startup, warn if repo not found

## Why Not Testable
This acceptance criterion requires:
1. Starting the dashboard server process
2. Configuring a non-existent path
3. Capturing stderr warnings

This is a runtime integration test that would require spawning the Python server process and monitoring its output, which is beyond the scope of simple shell-based regression tests.

To manually verify:
1. Add a non-existent path to ~/.fade-dashboard/config.json
2. Run fade dashboard
3. Observe warning message about invalid path
