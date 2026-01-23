#!/bin/bash
# Test: verify fade help output matches documented commands
# AC: fade help output matches documented commands

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_CLI="$PROJECT_ROOT/bin/fade-cli"

# Get help output
help_output=$("$FADE_CLI" help 2>&1)

# Check that help output contains expected sections
if ! echo "$help_output" | grep -q "Usage:"; then
    echo "FAIL: fade help missing Usage section"
    echo "Expected: Usage section present"
    echo "Actual: Not found"
    exit 1
fi

if ! echo "$help_output" | grep -q "Commands:"; then
    echo "FAIL: fade help missing Commands section"
    echo "Expected: Commands section present"
    echo "Actual: Not found"
    exit 1
fi

# Verify essential commands are listed
ESSENTIAL=("init" "run" "status" "new")
for cmd in "${ESSENTIAL[@]}"; do
    if ! echo "$help_output" | grep -qw "$cmd"; then
        echo "FAIL: fade help missing command: $cmd"
        echo "Expected: $cmd in help output"
        echo "Actual: Not found"
        exit 1
    fi
done

echo "PASS: fade help output contains expected structure and commands"
exit 0
