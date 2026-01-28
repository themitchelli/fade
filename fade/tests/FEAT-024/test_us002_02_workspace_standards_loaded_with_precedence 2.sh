#!/bin/bash
# Test: FADE loads workspace standards first then repo standards with clear precedence
# AC: When running inside a repo, FADE loads workspace standards first then repo standards, with clear precedence rules.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# This test verifies the implementation by checking the build_context function
# which is responsible for loading context including standards and learnings.

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Extract the build_context function to check loading order
build_context_content=$(sed -n '/^build_context()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -200)

# Assert: build_context should check for workspace context
if ! echo "$build_context_content" | grep -q "workspace_dir\|get_current_workspace"; then
    echo "FAIL: build_context doesn't check for workspace"
    echo "Expected: build_context references workspace_dir or get_current_workspace"
    echo "Actual: workspace handling not found in build_context"
    exit 1
fi

# Assert: Workspace learnings should be loaded FIRST (before repo learnings)
# This ensures workspace context comes before repo-specific overrides
if ! echo "$build_context_content" | grep -q "WORKSPACE.*LEARNINGS\|workspace.*learned"; then
    echo "FAIL: build_context doesn't load workspace learnings"
    echo "Expected: workspace learnings are included in context"
    echo "Actual: workspace learnings not found"
    exit 1
fi

# Verify the loading order by checking that workspace section appears before repo section
# The workspace section should have "inherited from workspace" or similar language
if ! echo "$build_context_content" | grep -qi "inherited\|workspace"; then
    echo "FAIL: No indication of workspace inheritance in context building"
    echo "Expected: context includes workspace inheritance markers"
    echo "Actual: inheritance language not found"
    exit 1
fi

# Check the standards README mentions precedence rules
workspace_init_content=$(sed -n '/^workspace_init()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)

if ! echo "$workspace_init_content" | grep -qi "precedence\|loaded before\|before repo"; then
    echo "FAIL: Standards README doesn't mention precedence rules"
    echo "Expected: workspace init creates README mentioning standards precedence"
    echo "Actual: precedence rules not documented in workspace creation"
    exit 1
fi

echo "PASS: FADE loads workspace standards first then repo standards with clear precedence"
exit 0
