#!/bin/bash
# Test: slug is derived from feature name
# AC: Slug derived from feature name provided at start of session

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for slug generation
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI" | head -200)

# Check that slug is generated from feature_name
if ! echo "$discover_content" | grep -q 'generate_slug.*feature_name\|slug=.*feature_name\|slug.*\$feature_name'; then
    echo "FAIL: Slug not derived from feature name"
    echo "Expected: slug generated from feature_name variable"
    echo "Actual: slug generation from feature_name not found"
    exit 1
fi

# Check that generate_slug function exists in the CLI
if ! grep -q '^generate_slug()' "$FADE_CLI"; then
    echo "FAIL: generate_slug function not found"
    echo "Expected: generate_slug() function exists"
    echo "Actual: function not found"
    exit 1
fi

echo "PASS: slug derived from feature name"
exit 0
