#!/bin/bash
# Test: verify detect-sessions.sh returns minimum 1 session
# AC: Return: integer >= 1
# AC: Ongoing PRD (not yet ALL_COMPLETE, has incomplete stories) = 1 session (current)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Setup: create temp files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Create empty progress.md (ongoing PRD with no signals yet)
cat > "$TEST_DIR/progress.md" << 'EOF'
# Progress Log
Started working on TEST-001
EOF

# Create PRD JSON with all stories incomplete
cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "userStories": [
    {"id": "US-001", "passes": false}
  ]
}
EOF

# Act: run script
sessions=$(bash "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/progress.md" "$TEST_DIR/prd.json" 2>/dev/null | tail -1)

# Assert: minimum 1 session for ongoing PRD
if [[ "$sessions" -lt 1 ]]; then
    echo "FAIL: Expected at least 1 session for ongoing PRD"
    echo "Expected: >= 1"
    echo "Actual: $sessions"
    exit 1
fi

echo "PASS: detect-sessions.sh returns minimum 1 session"
exit 0
