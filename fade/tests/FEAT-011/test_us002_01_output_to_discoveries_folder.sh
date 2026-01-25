#!/bin/bash
# Test: discovery output saved to fade/discoveries/{slug}.md
# AC: Output saved to fade/discoveries/{slug}.md

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for discoveries folder path
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI" | head -800)

# Check that discoveries folder is used
if ! echo "$discover_content" | grep -q 'fade/discoveries\|discoveries_dir'; then
    echo "FAIL: Discovery doesn't save to fade/discoveries folder"
    echo "Expected: output goes to fade/discoveries/{slug}.md"
    echo "Actual: fade/discoveries path not found in discover command"
    exit 1
fi

# Check that output file uses .md extension
if ! echo "$discover_content" | grep -q '\.md'; then
    echo "FAIL: Discovery output doesn't use .md extension"
    echo "Expected: output file has .md extension"
    echo "Actual: .md extension not found"
    exit 1
fi

# Check that output path uses slug variable
if ! echo "$discover_content" | grep -q '\$slug\|${slug}'; then
    echo "FAIL: Discovery output doesn't use slug in filename"
    echo "Expected: output filename includes slug"
    echo "Actual: slug variable not used in output path"
    exit 1
fi

echo "PASS: discovery output saved to fade/discoveries/{slug}.md"
exit 0
