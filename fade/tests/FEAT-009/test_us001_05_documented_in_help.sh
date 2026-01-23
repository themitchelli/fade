#!/bin/bash
# Test: verify fade quick is documented in fade help
# AC: Documented in fade help

FADE_CLI="${FADE_CLI:-fade}"

# Act - get help output
output=$($FADE_CLI help 2>&1)

# Assert 1 - quick command is listed in commands section
if ! echo "$output" | grep -qE "^\s*quick\s"; then
    echo "FAIL: 'quick' not listed as a command in help"
    echo "Expected: 'quick' listed as a command"
    echo "Actual help output (first 50 lines):"
    echo "$output" | head -50
    exit 1
fi

# Assert 2 - quick command has usage description
if ! echo "$output" | grep -qE "quick.*task|quick.*PRD"; then
    echo "FAIL: 'quick' command lacks description"
    echo "Expected: description of quick command purpose"
    exit 1
fi

# Assert 3 - Quick Command section exists with usage details
if ! echo "$output" | grep -q "Quick Command"; then
    echo "FAIL: 'Quick Command' section not found in help"
    echo "Expected: dedicated 'Quick Command' section"
    exit 1
fi

# Assert 4 - Quick Options section exists (for --yolo flag)
if ! echo "$output" | grep -q "Quick Options"; then
    echo "FAIL: 'Quick Options' section not found in help"
    echo "Expected: 'Quick Options' section documenting --yolo"
    exit 1
fi

# Assert 5 - --yolo option is documented for quick
quick_options=$(echo "$output" | grep -A5 "Quick Options")
if ! echo "$quick_options" | grep -q "\-\-yolo"; then
    echo "FAIL: --yolo option not documented in Quick Options"
    echo "Expected: --yolo documented"
    echo "Actual Quick Options section: $quick_options"
    exit 1
fi

echo "PASS: fade quick is fully documented in help"
exit 0
