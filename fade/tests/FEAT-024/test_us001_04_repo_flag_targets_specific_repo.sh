#!/bin/bash
# Test: fade --repo <name> targets a specific registered repo without cd-ing
# AC: Command `fade --repo <name> status|run|metrics` targets a specific registered repo without cd-ing into it (optional but strongly preferred).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check that fade-cli script exists
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    echo "Expected: $FADE_CLI exists"
    echo "Actual: file not found"
    exit 1
fi

# Assert: --repo flag is parsed in the argument handling section
if ! grep -q '"\-\-repo")\|--repo)' "$FADE_CLI"; then
    echo "FAIL: --repo flag is not handled in argument parsing"
    echo "Expected: --repo case in argument handling"
    echo "Actual: --repo case not found"
    exit 1
fi

# Assert: resolve_repo_name_to_path function exists (used to resolve repo name to path)
if ! grep -q "resolve_repo_name_to_path\|repo_name_to_path" "$FADE_CLI"; then
    echo "FAIL: No function to resolve repo name to path"
    echo "Expected: function to resolve repo name to filesystem path"
    echo "Actual: resolve function not found"
    exit 1
fi

# Extract the resolve function to verify it searches workspaces
resolve_content=$(sed -n '/^resolve_repo_name_to_path()/,/^[a-z_]*() {/p' "$FADE_CLI" | head -100)
if [[ -n "$resolve_content" ]]; then
    if ! echo "$resolve_content" | grep -q "workspace\|workspaces"; then
        echo "FAIL: resolve_repo_name_to_path doesn't search workspaces"
        echo "Expected: function searches workspaces for repo name"
        echo "Actual: workspace search not found"
        exit 1
    fi
fi

# Assert: --repo flag is mentioned in usage/help or documentation within the CLI
# Note: The AC says "optional but strongly preferred", so we check if the feature exists
# even if not prominently documented
if ! grep -q "\-\-repo" "$FADE_CLI"; then
    echo "FAIL: --repo flag not found in CLI"
    echo "Expected: --repo flag is implemented"
    echo "Actual: --repo not found anywhere in CLI"
    exit 1
fi

# Assert: The --repo handling changes directory or sets context for the target repo
repo_handling=$(grep -A20 '"\-\-repo")\|--repo)' "$FADE_CLI" | head -25)
if ! echo "$repo_handling" | grep -qi "cd\|repo_path\|repo_name"; then
    echo "FAIL: --repo flag doesn't set up repo context"
    echo "Expected: --repo flag resolves and uses repo path"
    echo "Actual: repo path/name handling not found"
    exit 1
fi

# Verify the feature is mentioned somewhere (workspace init mentions it)
if ! grep -q "fade --repo.*status\|--repo <name>" "$FADE_CLI"; then
    echo "FAIL: --repo usage not shown anywhere in CLI"
    echo "Expected: --repo usage mentioned (e.g., in workspace init message)"
    echo "Actual: not found"
    exit 1
fi

echo "PASS: fade --repo <name> targets a specific registered repo"
exit 0
