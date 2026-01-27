#!/bin/bash
# Test: verify council brief is saved to fade/council/ with timestamp
# AC: Council brief is saved to `fade/runs/<run_id>/council/` or `fade/council/` with timestamp.

# Setup - create a temporary test directory with required FADE structure
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR" || exit 1

# Create minimal FADE structure
mkdir -p fade/prds
cat > FADE.md << 'EOF'
# Test Project
EOF

cat > fade/prds/TEST-002-timestamp-test.json << 'EOF'
{
  "type": "feature",
  "id": "TEST-002",
  "name": "Timestamp test PRD",
  "description": "Testing timestamp in council brief filename.",
  "userStories": []
}
EOF

# Act - run fade council command
fade council TEST-002 >/dev/null 2>&1

# Assert - council brief file exists in fade/council/
if [[ ! -d "fade/council" ]]; then
    echo "FAIL: Expected fade/council/ directory to be created"
    echo "Expected: fade/council/ exists"
    echo "Actual: directory not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - filename contains PRD ID and timestamp pattern (YYYYMMDD-HHMMSS)
brief_files=$(ls fade/council/*.md 2>/dev/null)
if [[ -z "$brief_files" ]]; then
    echo "FAIL: No council brief files found"
    echo "Expected: at least one .md file in fade/council/"
    echo "Actual: no files found"
    rm -rf "$TEST_DIR"
    exit 1
fi

brief_filename=$(basename "$(echo "$brief_files" | head -1)")

# Check filename matches pattern: TEST-002-YYYYMMDD-HHMMSS.md
if ! echo "$brief_filename" | grep -qE "TEST-002-[0-9]{8}-[0-9]{6}\.md"; then
    echo "FAIL: Council brief filename missing timestamp pattern"
    echo "Expected: filename matches TEST-002-YYYYMMDD-HHMMSS.md"
    echo "Actual: $brief_filename"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Assert - brief content contains generated timestamp
brief_content=$(cat fade/council/*.md | head -20)
if ! echo "$brief_content" | grep -qE "\*\*Generated:\*\* [0-9]{4}-[0-9]{2}-[0-9]{2}"; then
    echo "FAIL: Council brief missing timestamp in content"
    echo "Expected: content contains '**Generated:** YYYY-MM-DD'"
    echo "Actual: timestamp line not found"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Council brief saved to fade/council/ with timestamp in filename and content"
exit 0
