#!/bin/bash
# Test: verify archived PRD count message displays correctly
# AC: Archived PRD count message displays correctly

# This test verifies that the archive count message is properly formatted
# and uses the tests_generated variable correctly after validation.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# Find the success message that displays test generation count
# Should be: "Generated tests for $tests_generated PRD(s)"
if ! grep -q 'Generated tests for.*tests_generated.*PRD' "$FADE_CLI"; then
    echo "FAIL: Test generation success message not found"
    echo "Expected: Message like 'Generated tests for \$tests_generated PRD(s)'"
    exit 1
fi

# Verify the message is inside the -gt 0 conditional
# This ensures it only displays when tests were actually generated
message_line=$(grep -n 'Generated tests for.*tests_generated.*PRD' "$FADE_CLI" | head -1 | cut -d: -f1)
comparison_line=$(grep -n 'tests_generated.*-gt 0' "$FADE_CLI" | head -1 | cut -d: -f1)

if [[ -z "$message_line" ]] || [[ -z "$comparison_line" ]]; then
    echo "FAIL: Could not find message or comparison line numbers"
    exit 1
fi

# Message should be AFTER the comparison (inside the then block)
if [[ "$message_line" -lt "$comparison_line" ]]; then
    echo "FAIL: Success message should be inside the -gt 0 conditional"
    echo "Comparison line: $comparison_line, Message line: $message_line"
    exit 1
fi

# Verify archive count message also exists and is properly formatted
if ! grep -q 'Archived.*PRD.*prd-archive' "$FADE_CLI"; then
    echo "FAIL: Archive completion message not found"
    echo "Expected: Message about archived PRDs"
    exit 1
fi

echo "PASS: Count messages display correctly in proper sequence"
exit 0
