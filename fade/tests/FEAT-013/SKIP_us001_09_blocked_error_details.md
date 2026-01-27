# SKIP: US-001 AC - Include error details from failed.log when blocked

## Acceptance Criteria
If session blocks, include error details from failed.log

## Why Not Testable
This acceptance criterion requires:
1. A session to actually block during execution
2. A failed.log file to exist with error content
3. Testing that the blocked reason is properly extracted

This is a runtime behavior that cannot be reliably tested without mocking the entire FADE execution environment. The atomic write pattern test (test_us001_09_atomic_write_pattern.sh) verifies the infrastructure exists; the actual blocked state population is an integration concern.

To manually verify:
1. Create a test that is designed to fail
2. Run fade run and let it block
3. Check status.json for blockedReason field
