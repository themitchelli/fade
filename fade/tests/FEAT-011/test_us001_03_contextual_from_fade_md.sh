#!/bin/bash
# Test: discovery reads FADE.md for project context
# AC: Questions are contextual based on project type (from FADE.md)

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script content for FADE.md integration
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI" | head -800)

# Check that discover reads FADE.md
if ! echo "$discover_content" | grep -q 'FADE\.md'; then
    echo "FAIL: Discovery doesn't reference FADE.md"
    echo "Expected: cmd_discover reads FADE.md for context"
    echo "Actual: FADE.md not referenced in discover command"
    exit 1
fi

# Check that FADE.md content is included in context
if ! echo "$discover_content" | grep -q 'cat FADE.md\|cat.*FADE\.md\|$(cat FADE'; then
    echo "FAIL: Discovery doesn't include FADE.md content in context"
    echo "Expected: FADE.md content loaded into discovery context"
    echo "Actual: cat FADE.md not found in discover command"
    exit 1
fi

# Check that there's project-specific question guidance
if ! echo "$discover_content" | grep -qi "project context\|project-specific"; then
    echo "FAIL: Discovery doesn't mention using project context"
    echo "Expected: guidance to ask project-specific questions"
    echo "Actual: 'project context' or 'project-specific' not found"
    exit 1
fi

echo "PASS: discovery reads FADE.md for contextual questions"
exit 0
