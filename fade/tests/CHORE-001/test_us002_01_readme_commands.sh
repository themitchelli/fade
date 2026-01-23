#!/bin/bash
# Test: verify README.md documents all current commands
# AC: README reflects all current commands (init, new, status, run, yolo, export, update, migrate, version)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
README="$PROJECT_ROOT/README.md"

# List of commands that must be documented (from AC)
# Note: AC explicitly lists these commands
COMMANDS=("init" "new" "status" "run" "yolo" "export" "update" "migrate" "version")

missing=()

for cmd in "${COMMANDS[@]}"; do
    # Check if the command is mentioned in README (as a heading or in backticks)
    if ! grep -qE "(fade ${cmd}|### \`fade ${cmd}\`|\`${cmd}\`)" "$README"; then
        missing+=("$cmd")
    fi
done

if [[ ${#missing[@]} -gt 0 ]]; then
    echo "FAIL: README.md is missing documentation for commands: ${missing[*]}"
    echo "Expected: All commands documented"
    echo "Actual: Missing: ${missing[*]}"
    exit 1
fi

echo "PASS: README.md documents all current commands"
exit 0
