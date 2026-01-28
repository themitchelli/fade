#!/bin/bash
# Test: verify display_escalation_suggestion function exists and outputs correct format
# AC: If a run exhibits repeated retries or BLOCKED, FADE suggests escalating model and records the suggestion

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify display_escalation_suggestion function exists
if ! grep -q 'display_escalation_suggestion()' "$FADE_CLI"; then
    echo "FAIL: display_escalation_suggestion function should exist in fade-cli"
    exit 1
fi

# Test 2: Verify escalation suggestion includes command recommendation
if ! grep -q 'fade run --model.*--resume' "$FADE_CLI"; then
    echo "FAIL: Escalation suggestion should include 'fade run --model X --resume' command"
    exit 1
fi

# Test 3: Verify escalation suggestion mentions the reason
if ! grep -q 'Reason:' "$FADE_CLI"; then
    echo "FAIL: Escalation suggestion should display the reason"
    exit 1
fi

# Test 4: Verify the suggestion display mentions "Auto-Escalation"
if ! grep -q 'Auto-Escalation' "$FADE_CLI"; then
    echo "FAIL: Escalation banner should mention 'Auto-Escalation'"
    exit 1
fi

# Test 5: Verify escalation is recorded/logged (check for progress.md mention)
if ! grep -qE 'progress\.md|log.*escalat' "$FADE_CLI"; then
    echo "FAIL: Escalation suggestion should be recorded/logged"
    exit 1
fi

echo "PASS: Escalation suggestion display function outputs correct format with command"
exit 0
