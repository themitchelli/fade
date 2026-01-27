#!/bin/bash
# Test: verify detect-sessions.sh counts COMPLETE signals
# AC: Count terminal conditions in progress.md matching PRD ID: completed_sessions = count of '## ... - PRD_ID:... - COMPLETE'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Setup: create temp files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Create progress.md with COMPLETE signals
cat > "$TEST_DIR/progress.md" << 'EOF'
## 2026-01-20 14:30 - US-001: First story (TEST-001) - COMPLETE
## 2026-01-20 15:00 - US-002: Second story (TEST-001) - COMPLETE
## 2026-01-21 10:00 - US-003: Third story (TEST-002) - COMPLETE
EOF

# Create PRD JSON with all stories passing
cat > "$TEST_DIR/prd.json" << 'EOF'
{
  "id": "TEST-001",
  "userStories": [
    {"id": "US-001", "passes": true},
    {"id": "US-002", "passes": true}
  ]
}
EOF

# Act: run script
output=$(bash "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/progress.md" "$TEST_DIR/prd.json" 2>&1)
sessions=$(echo "$output" | tail -1)
stderr=$(echo "$output" | grep -v "^[0-9]")

# Assert: 2 COMPLETE signals for TEST-001 = 2 sessions
if [[ "$sessions" != "2" ]]; then
    echo "FAIL: Expected 2 sessions for 2 COMPLETE signals"
    echo "Expected: 2"
    echo "Actual: $sessions"
    echo "Stderr: $stderr"
    exit 1
fi

echo "PASS: detect-sessions.sh correctly counts COMPLETE signals"
exit 0
