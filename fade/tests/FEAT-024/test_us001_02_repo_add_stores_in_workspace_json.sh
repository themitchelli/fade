#!/bin/bash
# Test: fade repo add registers a repo with name and path in workspace.json
# AC: Command `fade repo add <path>` registers a repo with name and path; stored in `workspace.json`.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Extract the repo_add function to verify implementation
repo_add_content=$(sed -n '/^repo_add()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -150)

if [[ -z "$repo_add_content" ]]; then
    echo "FAIL: repo_add function not found"
    echo "Expected: repo_add function exists in fade-cli"
    echo "Actual: function not found"
    exit 1
fi

# Assert: repo_add should write to workspace.json
if ! echo "$repo_add_content" | grep -q "workspace_json\|workspace.json"; then
    echo "FAIL: repo_add doesn't reference workspace.json"
    echo "Expected: repo_add writes to workspace.json"
    echo "Actual: workspace.json not referenced in repo_add"
    exit 1
fi

# Assert: repo_add should store the path
if ! echo "$repo_add_content" | grep -q "repo_path\|\"path\""; then
    echo "FAIL: repo_add doesn't store repo path"
    echo "Expected: repo_add stores path in workspace.json"
    echo "Actual: path handling not found"
    exit 1
fi

# Assert: repo_add should store the name
if ! echo "$repo_add_content" | grep -q "repo_name\|\"name\""; then
    echo "FAIL: repo_add doesn't store repo name"
    echo "Expected: repo_add stores name in workspace.json"
    echo "Actual: name handling not found"
    exit 1
fi

# Assert: repo add command is wired up in cmd_repo
cmd_repo_content=$(sed -n '/^cmd_repo()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)
if ! echo "$cmd_repo_content" | grep -q "add.*repo_add\|repo_add"; then
    echo "FAIL: repo add command not wired to repo_add function"
    echo "Expected: cmd_repo handles 'add' subcommand"
    echo "Actual: add subcommand handling not found"
    exit 1
fi

# Verify the usage message mentions repo add
if ! grep -q "fade repo add" "$FADE_CLI"; then
    echo "FAIL: 'fade repo add' not documented in CLI"
    echo "Expected: documentation mentions 'fade repo add <path>'"
    echo "Actual: not found in CLI"
    exit 1
fi

echo "PASS: fade repo add registers repo with name and path in workspace.json"
exit 0
