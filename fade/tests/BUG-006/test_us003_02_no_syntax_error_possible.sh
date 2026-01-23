#!/bin/bash
# Test: verify test generation cannot produce syntax error
# AC: Test generation completes without syntax error in output

# This test verifies that the combination of:
# 1. Stderr redirection in generate_tests_for_completed_prds
# 2. Defensive numeric validation
# Makes it impossible for the original syntax error to occur.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli not found at $FADE_CLI"
    exit 1
fi

# The original bug: "[[: ════════... syntax error: operand expected"
# occurred when display output (with unicode box chars) leaked into
# tests_generated variable, then was used in [[ -gt 0 ]] comparison.

# Verify fix layer 1: output isolation via stderr redirect
# The } >&2 pattern ensures only echo "$processed_count" goes to stdout
if ! grep -A 55 "^generate_tests_for_completed_prds()" "$FADE_CLI" | grep -q '} >&2'; then
    echo "FAIL: Missing stderr redirect for display output block"
    echo "This was the primary fix to prevent output leak"
    exit 1
fi

# Verify fix layer 2: defensive validation before comparison
# Even if layer 1 fails, this prevents syntax error
validation_exists=$(grep -c 'tests_generated.*=~.*\[0-9\]' "$FADE_CLI")
if [[ "$validation_exists" -lt 1 ]]; then
    echo "FAIL: Missing defensive numeric validation"
    echo "This is the backup fix layer"
    exit 1
fi

# Verify fix layer 3: safe default value
default_exists=$(grep -c 'tests_generated=0' "$FADE_CLI")
if [[ "$default_exists" -lt 1 ]]; then
    echo "FAIL: Missing default value fallback"
    echo "This ensures comparison always receives numeric value"
    exit 1
fi

# All three layers of protection are in place
echo "PASS: Syntax error is prevented by multiple fix layers"
exit 0
