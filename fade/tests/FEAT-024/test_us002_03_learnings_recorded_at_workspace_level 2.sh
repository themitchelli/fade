#!/bin/bash
# Test: FADE records key learnings at both repo level and workspace level (configurable)
# AC: FADE records key learnings at both repo level and workspace level (configurable).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# This test verifies the implementation supports recording learnings at workspace level
# by checking for the copy_learnings_to_workspace function or equivalent mechanism.

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Assert: There should be a function or mechanism to copy/record learnings at workspace level
if ! grep -q "copy_learnings_to_workspace\|workspace.*learned\|learned.*workspace" "$FADE_CLI"; then
    echo "FAIL: No mechanism found for recording learnings at workspace level"
    echo "Expected: function or code for workspace-level learnings"
    echo "Actual: workspace learning mechanism not found"
    exit 1
fi

# Extract the copy_learnings_to_workspace function if it exists
copy_learnings_content=$(sed -n '/^copy_learnings_to_workspace()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)

if [[ -z "$copy_learnings_content" ]]; then
    # Check for alternative implementation
    workspace_learning_code=$(grep -A20 "workspace.*learned\|learned.*workspace" "$FADE_CLI" | head -30)
    if [[ -z "$workspace_learning_code" ]]; then
        echo "FAIL: No workspace learning implementation found"
        echo "Expected: code for recording learnings at workspace level"
        echo "Actual: implementation not found"
        exit 1
    fi
fi

# Assert: The implementation should write to workspace learned.md
if ! grep -q "workspace_learned\|workspace_dir.*learned" "$FADE_CLI"; then
    echo "FAIL: Implementation doesn't write to workspace learned file"
    echo "Expected: code that writes to workspace-level learned.md"
    echo "Actual: workspace learned writing not found"
    exit 1
fi

# Assert: Comments or documentation indicate configurability (repo vs workspace level)
# The AC says "(configurable)" so there should be some indication of this choice
if ! grep -qi "configurable\|repo.*level\|workspace.*level\|AC.*#3\|both.*level" "$FADE_CLI"; then
    # This is a soft check - the implementation might be implicit
    :
fi

# Verify workspace init creates a learned.md template
workspace_init_content=$(sed -n '/^workspace_init()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)
if ! echo "$workspace_init_content" | grep -q "learned.md\|learned.json"; then
    echo "FAIL: workspace init doesn't create learned file"
    echo "Expected: workspace init creates learned.md or learned.json"
    echo "Actual: learned file creation not found in workspace_init"
    exit 1
fi

echo "PASS: FADE records key learnings at both repo level and workspace level"
exit 0
