#!/bin/bash
# Test: All fade commands are available in the CLI
# AC: All fade commands work via npx (init, run, status, etc.)

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that the CLI script exists and is executable
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Get help output to check available commands
HELP_OUTPUT=$("$FADE_CLI" help 2>&1) || true

# Check for essential commands
REQUIRED_COMMANDS=("init" "run" "status" "new" "update" "version")

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! echo "$HELP_OUTPUT" | grep -qw "$cmd"; then
        echo "FAIL: Command '$cmd' not found in help output"
        echo "Expected: '$cmd' to be listed in help"
        exit 1
    fi
done

echo "PASS: All required commands (init, run, status, new, update, version) are available"
exit 0
