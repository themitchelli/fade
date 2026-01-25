#!/bin/bash
# Test: discovery reads FADE.md for project context
# AC: Discovery reads FADE.md for project context

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for FADE.md reading
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for FADE.md file check
if ! echo "$discover_content" | grep -q '\-f.*FADE\.md\|FADE\.md.*\-f'; then
    echo "FAIL: Discovery doesn't check for FADE.md existence"
    echo "Expected: check if FADE.md file exists"
    echo "Actual: FADE.md file check not found"
    exit 1
fi

# Check that FADE.md content is loaded
if ! echo "$discover_content" | grep -q 'cat FADE.md\|$(cat.*FADE\.md'; then
    echo "FAIL: Discovery doesn't load FADE.md content"
    echo "Expected: cat FADE.md to load content"
    echo "Actual: FADE.md content loading not found"
    exit 1
fi

# Check for "Project Context" section in context
if ! echo "$discover_content" | grep -qi "project context"; then
    echo "FAIL: Discovery doesn't label FADE.md as project context"
    echo "Expected: 'Project Context' section header"
    echo "Actual: 'Project Context' not found"
    exit 1
fi

echo "PASS: discovery reads FADE.md for project context"
exit 0
