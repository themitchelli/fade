#!/bin/bash
# Test: verify fade quick command exists and is recognized
# AC: fade quick "task description" command exists

# Setup - get fade CLI path
FADE_CLI="${FADE_CLI:-fade}"

# Act - check if fade quick is a recognized command (without actually executing)
# We check the help output rather than running the command which would invoke Claude
output=$($FADE_CLI help 2>&1)

# Assert - quick command appears in help
if ! echo "$output" | grep -q "quick"; then
    echo "FAIL: 'quick' command not found in fade help"
    echo "Expected: 'quick' to be listed in help output"
    echo "Actual help output:"
    echo "$output"
    exit 1
fi

# Assert - quick command has proper usage description
if ! echo "$output" | grep -qE "quick.*task|quick.*PRD"; then
    echo "FAIL: 'quick' command description not found in help"
    echo "Expected: description mentioning 'task' or 'PRD'"
    echo "Actual: $(echo "$output" | grep -i quick)"
    exit 1
fi

echo "PASS: fade quick command exists and is documented"
exit 0
