#!/bin/bash
# Test: fade discover --prd option exists
# AC: fade discover --prd generates PRD JSON after discovery session

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for --prd flag handling
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI" | head -100)

# Check that --prd flag is parsed
if ! echo "$discover_content" | grep -q '\-\-prd'; then
    echo "FAIL: --prd flag not handled in discover command"
    echo "Expected: --prd option parsing"
    echo "Actual: '--prd' not found in argument parsing"
    exit 1
fi

# Check that there's a generate_prd variable
if ! echo "$discover_content" | grep -q 'generate_prd'; then
    echo "FAIL: generate_prd variable not found"
    echo "Expected: generate_prd flag to control PRD generation"
    echo "Actual: 'generate_prd' variable not found"
    exit 1
fi

# Verify --prd is documented in help
help_output=$("$FADE_CLI" help 2>&1)
if ! echo "$help_output" | grep -q '\-\-prd'; then
    echo "FAIL: --prd not documented in help"
    echo "Expected: --prd appears in help output"
    echo "Actual: --prd not found in help"
    exit 1
fi

echo "PASS: fade discover --prd option exists and is documented"
exit 0
