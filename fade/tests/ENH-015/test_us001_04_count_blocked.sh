#!/bin/bash
# Test: verify detect-sessions.sh counts BLOCKED signals
# AC: blocked_sessions = count of '## ... - PRD_ID:... - BLOCKED' (grep -c matches)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
TARGET_SCRIPT="$SCRIPT_DIR/fade/lib/detect-sessions.sh"

# Setup: create temp files
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

# Create progress.md with BLOCKED signals
cat > "$TEST_DIR/progress.md" << 'EOF'
## 2026-01-20 14:30 - US-001: First story (TEST-001) - BLOCKED
## 2026-01-20 15:00 - US-002: Second story (TEST-001) - COMPLETE
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
sessions=$(bash "$TARGET_SCRIPT" "TEST-001" "$TEST_DIR/progress.md" "$TEST_DIR/prd.json" 2>/dev/null | tail -1)

# Assert: 1 BLOCKED + 1 COMPLETE = 2 sessions
if [[ "$sessions" != "2" ]]; then
    echo "FAIL: Expected 2 sessions for 1 BLOCKED + 1 COMPLETE"
    echo "Expected: 2"
    echo "Actual: $sessions"
    exit 1
fi

echo "PASS: detect-sessions.sh correctly counts BLOCKED signals"
exit 0
