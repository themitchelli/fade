#!/bin/bash
# Test: Session detection correctly counts ALL_COMPLETE signals
# AC: Count terminal conditions in progress.md

set -e

# Create test data
temp_progress=$(mktemp)
trap "rm -f $temp_progress" EXIT

cat > "$temp_progress" <<'EOF'
## 2026-01-25 17:30 - US-002: Test (ENH-015) - COMPLETE
- Work done

## 2026-01-25 18:30 - US-003: Test (ENH-015) - COMPLETE
- More work

## 2026-01-25 19:30 - US-004: Test (ENH-015) - COMPLETE
- Even more work
EOF

# Create minimal PRD with all passes: true (no incomplete stories)
temp_prd=$(mktemp)
trap "rm -f $temp_prd $temp_progress" EXIT

cat > "$temp_prd" <<'EOF'
{
  "type": "enhancement",
  "id": "ENH-015",
  "name": "Test",
  "userStories": [
    {"id": "US-001", "passes": true},
    {"id": "US-002", "passes": true}
  ]
}
EOF

# Test: Should detect 3 completed sessions, 0 blocked, 0 incomplete = 3 total
result=$(bash fade/lib/detect-sessions.sh "ENH-015" "$temp_progress" "$temp_prd" 2>&1 | tail -1)

if [[ "$result" == "3" ]]; then
    echo "PASS: Detected 3 completed sessions correctly"
    exit 0
else
    echo "FAIL: Expected 3 sessions, got $result"
    exit 1
fi
