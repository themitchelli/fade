#!/bin/bash
# Test: Workspace contains standards/ and learned.json/learned.md at workspace level
# AC: Workspace contains `standards/` and `learned.json` (or `learned.md` + json) at workspace level.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_WORKSPACE_NAME="test-workspace-$$"
WORKSPACE_DIR="$HOME/.fade/workspaces/$TEST_WORKSPACE_NAME"

# Cleanup function
cleanup() {
    rm -rf "$WORKSPACE_DIR" 2>/dev/null || true
}

# Cleanup before test
cleanup

# Act: Create a workspace
output=$("$FADE_CLI" workspace init "$TEST_WORKSPACE_NAME" 2>&1)
exit_code=$?

# Assert: Command should succeed
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: workspace init failed"
    echo "Expected: exit code 0"
    echo "Actual: exit code $exit_code"
    echo "Output: $output"
    cleanup
    exit 1
fi

# Assert: standards/ directory should exist at workspace level
if [[ ! -d "$WORKSPACE_DIR/standards" ]]; then
    echo "FAIL: standards/ directory not created"
    echo "Expected: $WORKSPACE_DIR/standards/ exists"
    echo "Actual: directory not found"
    cleanup
    exit 1
fi

# Assert: learned.md or learned.json should exist at workspace level
if [[ ! -f "$WORKSPACE_DIR/learned.md" ]] && [[ ! -f "$WORKSPACE_DIR/learned.json" ]]; then
    echo "FAIL: learned file not created"
    echo "Expected: $WORKSPACE_DIR/learned.md or learned.json exists"
    echo "Actual: neither file found"
    cleanup
    exit 1
fi

# Assert: workspace.json should exist (for completeness)
if [[ ! -f "$WORKSPACE_DIR/workspace.json" ]]; then
    echo "FAIL: workspace.json not created"
    echo "Expected: $WORKSPACE_DIR/workspace.json exists"
    echo "Actual: file not found"
    cleanup
    exit 1
fi

# Cleanup after successful test
cleanup

echo "PASS: Workspace contains standards/ and learned.md at workspace level"
exit 0
