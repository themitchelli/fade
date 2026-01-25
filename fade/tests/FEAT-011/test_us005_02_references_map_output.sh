#!/bin/bash
# Test: discovery references fade map output if available
# AC: If fade map was run, discovery references its output

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for map detection
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for detection of fade map having been run
if ! echo "$discover_content" | grep -qi "has_map_context\|map.*run\|AUTO-GENERATED\|Architecture References"; then
    echo "FAIL: Discovery doesn't detect if fade map was run"
    echo "Expected: detection of map-generated content in FADE.md"
    echo "Actual: map detection not found"
    exit 1
fi

# Check for mention of codebase analysis
if ! echo "$discover_content" | grep -qi "codebase.*analysis\|analyzed.*map"; then
    echo "FAIL: Discovery doesn't mention codebase analysis"
    echo "Expected: reference to fade map analysis"
    echo "Actual: codebase analysis mention not found"
    exit 1
fi

# Check that it mentions detected patterns
if ! echo "$discover_content" | grep -qi "detected\|languages\|frameworks\|patterns"; then
    echo "FAIL: Discovery doesn't mention detected patterns"
    echo "Expected: reference to detected languages/frameworks/patterns"
    echo "Actual: detected patterns not mentioned"
    exit 1
fi

echo "PASS: discovery references fade map output when available"
exit 0
