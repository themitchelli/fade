#!/bin/bash
# Test: verify detect-sessions.sh adds 1 for incomplete stories
# AC: Read PRD JSON and check for incomplete user stories: userStories[].passes == false
# AC: If has_incomplete (resumed work with unfinished stories): sessions = (completed + blocked) + 1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Setup: create temp files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Create progress.md with 1 COMPLETE signal
cat > "$TEST_DIR/progress.md" << 'EOF'
## 2026-01-20 14:30 - US-001: First story (TEST-001) - COMPLETE
EOF

# Create PRD JSON with incomplete story (passes: false)
cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "userStories": [
    {"id": "US-001", "passes": true},
    {"id": "US-002", "passes": false}
  ]
}
EOF

# Act: run script
sessions=$(bash "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/progress.md" "$TEST_DIR/prd.json" 2>/dev/null | tail -1)

# Assert: 1 COMPLETE + 1 (for incomplete) = 2 sessions
if [[ "$sessions" != "2" ]]; then
    echo "FAIL: Expected 2 sessions (1 COMPLETE + 1 for incomplete stories)"
    echo "Expected: 2"
    echo "Actual: $sessions"
    exit 1
fi

echo "PASS: detect-sessions.sh adds 1 for incomplete stories"
exit 0
