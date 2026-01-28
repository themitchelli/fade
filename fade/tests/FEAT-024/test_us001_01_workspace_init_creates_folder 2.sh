#!/bin/bash
# Test: fade workspace init creates a workspace folder
# AC: Command `fade workspace init` creates a workspace folder (e.g., `~/.fade/workspaces/<name>/`).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"
TEST_WORKSPACE_NAME="test-workspace-$$"
WORKSPACE_DIR="$HOME/.fade/workspaces/$TEST_WORKSPACE_NAME"

# Cleanup function
cleanup() {
    rm -rf "$WORKSPACE_DIR" 2>/dev/null || true
}

# Cleanup before test
cleanup

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Act: Run workspace init command
output=$("$FADE_CLI" workspace init "$TEST_WORKSPACE_NAME" 2>&1)
exit_code=$?

# Assert: Command should succeed
if [[ $exit_code -ne 0 ]]; then
    echo "FAIL: workspace init command failed"
    echo "Expected: exit code 0"
    echo "Actual: exit code $exit_code"
    echo "Output: $output"
    cleanup
    exit 1
fi

# Assert: Workspace directory should exist at ~/.fade/workspaces/<name>/
if [[ ! -d "$WORKSPACE_DIR" ]]; then
    echo "FAIL: Workspace folder not created"
    echo "Expected: $WORKSPACE_DIR exists"
    echo "Actual: directory not found"
    cleanup
    exit 1
fi

# Assert: workspace.json should exist in the workspace folder
if [[ ! -f "$WORKSPACE_DIR/workspace.json" ]]; then
    echo "FAIL: workspace.json not created"
    echo "Expected: $WORKSPACE_DIR/workspace.json exists"
    echo "Actual: file not found"
    cleanup
    exit 1
fi

# Cleanup after successful test
cleanup

echo "PASS: fade workspace init creates a workspace folder at ~/.fade/workspaces/<name>/"
exit 0
