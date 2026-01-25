#!/bin/bash
# Test: questions reference actual patterns in codebase
# AC: Questions reference actual patterns in codebase ('I see you use Express, should this endpoint follow...')

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for pattern-aware questions
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for example pattern-aware questions
if ! echo "$discover_content" | grep -qi "I see you\|I notice"; then
    echo "FAIL: Discovery doesn't include pattern-aware question examples"
    echo "Expected: examples like 'I see you use...' or 'I notice...'"
    echo "Actual: pattern-aware phrasing not found"
    exit 1
fi

# Check for framework detection integration
if ! echo "$discover_content" | grep -qi "detect_framework\|detected_frameworks"; then
    echo "FAIL: Discovery doesn't detect frameworks"
    echo "Expected: framework detection for pattern-aware questions"
    echo "Actual: detect_framework not called"
    exit 1
fi

# Check for architecture directory detection
if ! echo "$discover_content" | grep -qi "routes\|controllers\|services\|models\|arch_dirs"; then
    echo "FAIL: Discovery doesn't detect architecture directories"
    echo "Expected: detection of common architecture directories"
    echo "Actual: architecture directory detection not found"
    exit 1
fi

# Check for guidance to reference real files
if ! echo "$discover_content" | grep -qi "reference real files\|mention specific files"; then
    echo "FAIL: No guidance to reference real files"
    echo "Expected: guidance to mention specific files from codebase"
    echo "Actual: file reference guidance not found"
    exit 1
fi

echo "PASS: questions reference actual patterns in codebase"
exit 0
