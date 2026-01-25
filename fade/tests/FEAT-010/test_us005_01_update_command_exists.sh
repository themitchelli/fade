#!/bin/bash
# Test: fade update command still exists for project artifacts
# AC: fade update still updates local prompt.md from latest template

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that update command exists in help
HELP_OUTPUT=$("$FADE_CLI" help 2>&1) || true

if ! echo "$HELP_OUTPUT" | grep -q "update"; then
    echo "FAIL: 'update' command not found in fade help"
    exit 1
fi

# Check that the update function exists in the script
if ! grep -q "cmd_update()" "$FADE_CLI"; then
    echo "FAIL: cmd_update function not found in fade-cli"
    exit 1
fi

# Verify update handles prompt.md updates (via check_prompt_path or FADE_PROMPT_URL)
if ! grep -q "check_prompt_path\|FADE_PROMPT_URL\|prompt.md" "$FADE_CLI"; then
    echo "FAIL: cmd_update doesn't appear to handle prompt.md"
    exit 1
fi

# Verify the prompt URL is defined
if ! grep -q "FADE_PROMPT_URL" "$FADE_CLI"; then
    echo "FAIL: FADE_PROMPT_URL not defined for remote prompt.md updates"
    exit 1
fi

echo "PASS: fade update command exists and handles prompt.md updates"
exit 0
