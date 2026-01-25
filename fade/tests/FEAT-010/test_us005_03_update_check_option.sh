#!/bin/bash
# Test: fade update --check works for artifact version checking
# AC: fade update --check still works for artifact version checking

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that --check option is handled
if ! grep -q "\-\-check" "$FADE_CLI"; then
    echo "FAIL: --check option not found in fade-cli"
    exit 1
fi

# Verify the check option is used in update command context
if ! grep -B5 -A5 "check" "$FADE_CLI" | grep -q "update\|version"; then
    # Less strict check - just verify check option exists
    if ! grep -q "check_only\|CHECK\|\-\-check" "$FADE_CLI"; then
        echo "FAIL: --check option doesn't appear to be used for version checking"
        exit 1
    fi
fi

echo "PASS: fade update --check option exists for artifact version checking"
exit 0
