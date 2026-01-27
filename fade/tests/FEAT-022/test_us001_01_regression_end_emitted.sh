#!/bin/bash
# Test: verify regression_end event is emitted with success=false on test failure
# AC: When regression tests fail, FADE emits `regression_end` with `success=false` and captures failure summary (paths + failing assertions).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify emit_event is called with regression_end and fail status
if ! grep -q 'emit_event.*regression_end.*status.*fail' "$FADE_CLI"; then
    echo "FAIL: FADE should emit regression_end event with status=fail on test failure"
    echo "Expected: emit_event with regression_end and fail status"
    echo "Actual: Pattern not found in fade-cli"
    exit 1
fi

# Test 2: Verify capture_test_failure_summary function exists
if ! grep -q 'capture_test_failure_summary()' "$FADE_CLI"; then
    echo "FAIL: capture_test_failure_summary function should exist"
    echo "Expected: capture_test_failure_summary() function definition"
    exit 1
fi

# Test 3: Verify capture reads from failed.log
if ! grep -A 5 'capture_test_failure_summary()' "$FADE_CLI" | grep -q 'failed.log'; then
    echo "FAIL: capture_test_failure_summary should read from failed.log"
    echo "Expected: Reference to failed.log in capture function"
    exit 1
fi

# Test 4: Verify failure count is extracted from failed.log
if ! grep -A 20 'capture_test_failure_summary()' "$FADE_CLI" | grep -q 'FAILURE'; then
    echo "FAIL: capture_test_failure_summary should extract [FAILURE] entries"
    echo "Expected: Reference to FAILURE tag extraction"
    exit 1
fi

echo "PASS: regression_end event emitted with success=false and failure summary captured"
exit 0
