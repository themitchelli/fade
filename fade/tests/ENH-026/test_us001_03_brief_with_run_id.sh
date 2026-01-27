#!/bin/bash
# Test: verify council brief saved to run-specific directory when --run-id provided
# AC: Council brief is saved to `fade/runs/<run_id>/council/` or `fade/council/` with timestamp.

# Setup - create a temporary test directory with required FADE structure
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Create minimal FADE structure
mkdir -p fade/prds fade/runs/test-run-123

cat > FADE.md << 'EOF'
# Test Project
EOF

cat > fade/prds/TEST-003-run-id-test.json << 'EOF'
{
  "type": "feature",
  "id": "TEST-003",
  "name": "Run ID test PRD",
  "description": "Testing council brief with run-id option.",
  "userStories": []
}
EOF

# Act - run fade council command with --run-id
fade council TEST-003 --run-id test-run-123 >/dev/null 2>&1

# Assert - council brief file exists in fade/runs/<run_id>/council/
if [[ ! -d "fade/runs/test-run-123/council" ]]; then
    echo "FAIL: Expected fade/runs/test-run-123/council/ directory to be created"
    echo "Expected: fade/runs/test-run-123/council/ exists"
    echo "Actual: directory not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief file exists in the run-specific directory
brief_files=$(ls fade/runs/test-run-123/council/*.md 2>/dev/null)
if [[ -z "$brief_files" ]]; then
    echo "FAIL: No council brief files found in run directory"
    echo "Expected: at least one .md file in fade/runs/test-run-123/council/"
    echo "Actual: no files found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief NOT in default fade/council/ when run-id provided
if [[ -d "fade/council" ]] && ls fade/council/*.md >/dev/null 2>&1; then
    echo "FAIL: Council brief should not be in fade/council/ when --run-id is provided"
    echo "Expected: brief only in fade/runs/test-run-123/council/"
    echo "Actual: brief also found in fade/council/"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Council brief saved to fade/runs/<run_id>/council/ when --run-id provided"
exit 0
