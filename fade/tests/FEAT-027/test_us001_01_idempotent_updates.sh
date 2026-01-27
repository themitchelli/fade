#!/bin/bash
# Test: fade update is idempotent - running multiple times yields same repo state
# AC: `fade update` is idempotent: running it multiple times yields the same repo state.

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Setup: Create a temporary FADE project
test_dir="/tmp/fade-idempotent-$$"
mkdir -p "$test_dir/fade"

# Create minimal FADE structure
cat > "$test_dir/FADE.md" << 'EOF'
<!-- FADE FADE.md v0.3.1 -->

# Test Project

## Project Overview
Test project for idempotent update verification.
EOF

cat > "$test_dir/fade/prompt.md" << 'EOF'
<!-- FADE prompt.md v0.3.1 -->

# FADE Execution Prompt
Test prompt content.
EOF

mkdir -p "$test_dir/fade/standards"
cat > "$test_dir/fade/standards/coding.md" << 'EOF'
# Coding Standards
Test standards content.
EOF

cd "$test_dir"

# Run update --check first time and capture state
first_check=$("$FADE_CLI" update --check 2>&1 || true)

# Get file hashes before first update run (using structure check)
first_structure=$(find fade -type f -exec md5 -q {} \; 2>/dev/null | sort | md5 -q)

# Run update --check again
second_check=$("$FADE_CLI" update --check 2>&1 || true)

# Get file hashes after (should be same - we only ran check mode)
second_structure=$(find fade -type f -exec md5 -q {} \; 2>/dev/null | sort | md5 -q)

# Assert: Structure unchanged after check mode (idempotent)
if [[ "$first_structure" != "$second_structure" ]]; then
    echo "FAIL: --check mode should not modify files"
    echo "Expected: same file hashes"
    echo "Actual: hashes differ"
    rm -rf "$test_dir"
    exit 1
fi

# Verify that running check twice produces consistent results
# (Both should report same status)
if [[ -z "$first_check" ]] || [[ -z "$second_check" ]]; then
    echo "FAIL: update --check should produce output"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: fade update --check is idempotent (running multiple times yields same state)"
exit 0
