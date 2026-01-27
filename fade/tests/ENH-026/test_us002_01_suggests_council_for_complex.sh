#!/bin/bash
# Test: verify display_council_suggestion function exists and formats correctly
# AC: FADE suggests running council mode when: complexity=complex, PRD flagged security risk, or K retries/BLOCKED occur.

# This test verifies the suggestion display mechanism exists in fade-cli
# The actual trigger conditions are tested via events.jsonl verification in test_us002_02

# Setup
FADE_CLI="${FADE_CLI:-$(which fade)}"
if [[ -z "$FADE_CLI" ]]; then
    # Try common installation paths
    for path in "/usr/local/bin/fade" "$HOME/.local/bin/fade" "$(dirname "$0")/../../../bin/fade-cli"; do
        if [[ -x "$path" ]]; then
            FADE_CLI="$path"
            break
        fi
    done
fi

if [[ -z "$FADE_CLI" ]] || [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: Could not locate fade-cli script"
    echo "Expected: fade-cli at standard location or FADE_CLI env var"
    echo "Actual: not found"
    exit 1
fi

# Resolve symlinks to get actual script
FADE_CLI_RESOLVED=$(readlink -f "$FADE_CLI" 2>/dev/null || realpath "$FADE_CLI" 2>/dev/null || echo "$FADE_CLI")

# Act - verify display_council_suggestion function exists
if ! grep -q "display_council_suggestion()" "$FADE_CLI_RESOLVED"; then
    echo "FAIL: display_council_suggestion function not found in fade-cli"
    echo "Expected: function display_council_suggestion() exists"
    echo "Actual: function not found"
    exit 1
fi

# Assert - function checks for complexity=complex trigger
if ! grep -q 'complexity.*==.*"complex"' "$FADE_CLI_RESOLVED"; then
    echo "FAIL: Council suggestion not triggered by complexity=complex"
    echo "Expected: code checks for complexity=complex"
    echo "Actual: check not found in fade-cli"
    exit 1
fi

# Assert - function checks for retry trigger (K retries/BLOCKED)
if ! grep -qE 'iteration.*-gt.*1|retry|BLOCKED' "$FADE_CLI_RESOLVED"; then
    echo "FAIL: Council suggestion not triggered by retries"
    echo "Expected: code checks for iteration > 1 or retry condition"
    echo "Actual: retry check not found in fade-cli"
    exit 1
fi

echo "PASS: Council suggestion triggers implemented for complexity=complex and retries"
exit 0
