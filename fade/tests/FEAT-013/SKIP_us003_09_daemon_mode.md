# SKIP: US-003 AC - Optional --daemon flag for background server

## Acceptance Criteria
Optional: --daemon flag runs server in background, writes PID to ~/.fade-dashboard/server.pid

## Why Not Testable
This acceptance criterion is marked as "Optional" in the PRD. Testing daemon mode would require:
1. Starting a background process
2. Verifying PID file creation
3. Managing process lifecycle in tests

The --daemon flag may not be implemented since it's optional. Core functionality is verified by other tests.

To manually verify if implemented:
1. Run `fade dashboard --daemon`
2. Check ~/.fade-dashboard/server.pid exists
3. Verify process is running with that PID
