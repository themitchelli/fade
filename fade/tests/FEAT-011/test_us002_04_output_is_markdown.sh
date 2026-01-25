#!/bin/bash
# Test: discovery output is markdown format
# AC: Output is markdown suitable for reference when writing PRD

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for markdown format
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function with template content
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for markdown header syntax in template
if ! echo "$discover_content" | grep -q '# Discovery:'; then
    echo "FAIL: Discovery template missing markdown title"
    echo "Expected: template includes '# Discovery:' header"
    echo "Actual: markdown title not found"
    exit 1
fi

# Check for markdown formatting elements
if ! echo "$discover_content" | grep -q '\*\*\['; then
    echo "FAIL: Discovery template missing markdown bold formatting"
    echo "Expected: template uses markdown bold for decision topics"
    echo "Actual: bold formatting pattern not found"
    exit 1
fi

# Check for checkbox syntax in template (for open questions)
if ! echo "$discover_content" | grep -q '\- \[ \]'; then
    echo "FAIL: Discovery template missing markdown checkbox syntax"
    echo "Expected: template uses '- [ ]' for open questions"
    echo "Actual: checkbox syntax not found"
    exit 1
fi

# Verify .md file extension is specified
if ! echo "$discover_content" | grep -q 'output_file=.*\.md'; then
    echo "FAIL: Output file doesn't specify .md extension"
    echo "Expected: output_file includes .md extension"
    echo "Actual: .md extension not in output_file assignment"
    exit 1
fi

echo "PASS: output is markdown suitable for PRD reference"
exit 0
