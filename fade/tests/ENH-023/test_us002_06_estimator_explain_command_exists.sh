#!/bin/bash
# Test: verify fade estimator explain command exists
# AC: Provide `fade estimator explain` to print the rubric decision for a given PRD

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify cmd_estimator function exists
if ! grep -q 'cmd_estimator()' "$FADE_CLI"; then
    echo "FAIL: cmd_estimator function should exist in fade-cli"
    exit 1
fi

# Test 2: Verify estimator command is wired up in main dispatch
if ! grep -q 'estimator)' "$FADE_CLI"; then
    echo "FAIL: 'estimator' command should be in command dispatch"
    exit 1
fi

# Test 3: Verify explain subcommand is handled
if ! grep -qE '\[.*explain.*\]|explain)' "$FADE_CLI"; then
    echo "FAIL: 'explain' subcommand should be handled"
    exit 1
fi

# Test 4: Verify usage message mentions explain
if ! grep -q 'fade estimator explain' "$FADE_CLI"; then
    echo "FAIL: Usage message should mention 'fade estimator explain'"
    exit 1
fi

echo "PASS: fade estimator explain command exists"
exit 0
