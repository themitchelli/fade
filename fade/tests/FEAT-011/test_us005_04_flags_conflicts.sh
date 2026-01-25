#!/bin/bash
# Test: discovery flags potential conflicts with existing code
# AC: Flags if proposed feature might conflict with existing code

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for conflict detection
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for conflict detection section
if ! echo "$discover_content" | grep -qi "conflict detection\|detect.*conflict"; then
    echo "FAIL: Discovery missing conflict detection section"
    echo "Expected: 'Conflict Detection' section"
    echo "Actual: conflict detection not found"
    exit 1
fi

# Check for guidance on similar features
if ! echo "$discover_content" | grep -qi "similar.*feature\|existing feature\|already have"; then
    echo "FAIL: No guidance on detecting similar existing features"
    echo "Expected: guidance to check for similar/existing features"
    echo "Actual: similar feature check not mentioned"
    exit 1
fi

# Check for naming collision guidance
if ! echo "$discover_content" | grep -qi "naming collision\|similar name"; then
    echo "FAIL: No guidance on naming collisions"
    echo "Expected: guidance to check for naming collisions"
    echo "Actual: naming collision check not mentioned"
    exit 1
fi

# Check for architectural mismatch guidance
if ! echo "$discover_content" | grep -qi "architectural.*mismatch\|pattern.*different\|different.*pattern"; then
    echo "FAIL: No guidance on architectural mismatches"
    echo "Expected: guidance to flag architectural mismatches"
    echo "Actual: architectural mismatch check not mentioned"
    exit 1
fi

echo "PASS: discovery flags potential conflicts with existing code"
exit 0
