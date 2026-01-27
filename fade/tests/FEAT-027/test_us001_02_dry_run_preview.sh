#!/bin/bash
# Test: fade update --dry-run shows planned changes without applying
# AC: `fade update --dry-run` shows planned file changes (add/modify) without applying them.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Setup: Create a temporary FADE project missing some structure
test_dir="/tmp/fade-dryrun-$$"
mkdir -p "$test_dir/fade"

# Create minimal FADE structure (missing tests folder to trigger "would create")
cat > "$test_dir/FADE.md" << 'EOF'
<!-- FADE FADE.md v0.3.1 -->

# Test Project

## Project Overview
Test project.
EOF

cat > "$test_dir/fade/prompt.md" << 'EOF'
<!-- FADE prompt.md v0.3.1 -->

# FADE Execution Prompt
Test prompt content.
EOF

cd "$test_dir"

# Capture file state before dry-run
before_files=$(find . -type f 2>/dev/null | sort)

# Run update --dry-run
dry_run_output=$("$FADE_CLI" update --dry-run 2>&1 || true)

# Capture file state after dry-run
after_files=$(find . -type f 2>/dev/null | sort)

# Assert: dry-run outputs "DRY RUN" indicator
if ! echo "$dry_run_output" | grep -qi "dry.run\|DRY RUN"; then
    echo "FAIL: dry-run should indicate DRY RUN mode in output"
    echo "Expected: Output containing 'DRY RUN'"
    echo "Actual: $dry_run_output"
    rm -rf "$test_dir"
    exit 1
fi

# Assert: dry-run shows "would" language for planned changes
if ! echo "$dry_run_output" | grep -qiE "would|no changes"; then
    echo "FAIL: dry-run should show 'would' language for planned changes"
    echo "Expected: Output containing 'would' or 'no changes'"
    echo "Actual: $dry_run_output"
    rm -rf "$test_dir"
    exit 1
fi

# Assert: No files were actually modified (before and after match)
if [[ "$before_files" != "$after_files" ]]; then
    echo "FAIL: --dry-run should not modify any files"
    echo "Expected: same file list before and after"
    echo "Before: $before_files"
    echo "After: $after_files"
    rm -rf "$test_dir"
    exit 1
fi

# Assert: No update-backups folder created in dry-run mode
if [[ -d "$test_dir/fade/update-backups" ]]; then
    echo "FAIL: --dry-run should not create backup directory"
    echo "Expected: no fade/update-backups directory"
    echo "Actual: directory exists"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: fade update --dry-run shows planned changes without applying them"
exit 0
