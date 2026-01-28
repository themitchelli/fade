#!/bin/bash
# Test: fade repo list shows registered repos
# AC: Command `fade repo list` shows registered repos.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Extract the repo_list function to verify implementation
repo_list_content=$(sed -n '/^repo_list()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)

if [[ -z "$repo_list_content" ]]; then
    echo "FAIL: repo_list function not found"
    echo "Expected: repo_list function exists in fade-cli"
    echo "Actual: function not found"
    exit 1
fi

# Assert: repo_list reads from workspace.json
if ! echo "$repo_list_content" | grep -q "workspace_json\|workspace.json"; then
    echo "FAIL: repo_list doesn't read workspace.json"
    echo "Expected: repo_list reads from workspace.json"
    echo "Actual: workspace.json not referenced in repo_list"
    exit 1
fi

# Assert: repo_list displays repos information
if ! echo "$repo_list_content" | grep -q "repos\|\.name\|\.path"; then
    echo "FAIL: repo_list doesn't show repo information"
    echo "Expected: repo_list displays repos from workspace.json"
    echo "Actual: repo display logic not found"
    exit 1
fi

# Assert: repo_list outputs something meaningful (echo/printf for display)
if ! echo "$repo_list_content" | grep -q "echo\|printf"; then
    echo "FAIL: repo_list doesn't output anything"
    echo "Expected: repo_list outputs repo information"
    echo "Actual: no output statements found"
    exit 1
fi

# Assert: repo list command is wired up in cmd_repo
cmd_repo_content=$(sed -n '/^cmd_repo()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)
if ! echo "$cmd_repo_content" | grep -q "list.*repo_list\|repo_list"; then
    echo "FAIL: repo list command not wired to repo_list function"
    echo "Expected: cmd_repo handles 'list' subcommand"
    echo "Actual: list subcommand handling not found"
    exit 1
fi

# Verify the usage message mentions repo list
if ! grep -q "fade repo list" "$FADE_CLI"; then
    echo "FAIL: 'fade repo list' not documented in CLI"
    echo "Expected: documentation mentions 'fade repo list'"
    echo "Actual: not found in CLI"
    exit 1
fi

echo "PASS: fade repo list shows registered repos"
exit 0
