#!/bin/bash
# Test: verify fade help commands match README documented commands
# AC: Command help text matches README descriptions

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
FADE_CLI="$PROJECT_ROOT/bin/fade-cli"
README="$PROJECT_ROOT/README.md"

# Get commands from fade help
help_output=$("$FADE_CLI" help 2>&1)

# Commands that should appear in both (from AC)
# Note: AC lists these specific commands.
COMMANDS=("init" "new" "status" "run" "yolo" "export" "update" "migrate" "version")

help_missing=()
readme_missing=()

for cmd in "${COMMANDS[@]}"; do
    if ! echo "$help_output" | grep -qw "$cmd"; then
        help_missing+=("$cmd")
    fi
    if ! grep -qE "(fade ${cmd}|\`${cmd}\`)" "$README"; then
        readme_missing+=("$cmd")
    fi
done

if [[ ${#help_missing[@]} -gt 0 ]]; then
    echo "FAIL: Commands missing from fade help: ${help_missing[*]}"
    echo "Expected: All commands in help output"
    echo "Actual: Missing: ${help_missing[*]}"
    exit 1
fi

if [[ ${#readme_missing[@]} -gt 0 ]]; then
    echo "FAIL: Commands missing from README: ${readme_missing[*]}"
    echo "Expected: All commands in README"
    echo "Actual: Missing: ${readme_missing[*]}"
    exit 1
fi

echo "PASS: fade help commands match README documented commands"
exit 0
