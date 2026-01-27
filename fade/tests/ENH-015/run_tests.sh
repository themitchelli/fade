#!/bin/bash
# Test Runner for ENH-015 - Self-Improving Model Selection Learner
#
# Usage: ./run_tests.sh [pattern]
#   pattern: optional filter for test names (e.g., "us001" to run only US-001 tests)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

pattern="${1:-test_*.sh}"
if [[ "$1" ]]; then
    pattern="*${1}*.sh"
fi

passed=0
failed=0
skipped=0

echo "=========================================="
echo " ENH-015 Regression Tests"
echo "=========================================="
echo ""

for test in $(ls $pattern 2>/dev/null | sort); do
    if [[ ! -f "$test" ]]; then
        continue
    fi

    output=$(bash "$test" 2>&1)
    exit_code=$?

    if [[ $exit_code -eq 0 ]]; then
        if [[ "$output" == *"SKIP:"* ]]; then
            ((skipped++))
            echo "⏭️  SKIP: $test"
        else
            ((passed++))
            echo "✅ PASS: $test"
        fi
    else
        ((failed++))
        echo "❌ FAIL: $test"
        echo "   Output: $output"
    fi
done

echo ""
echo "=========================================="
echo " Results: $passed passed, $failed failed, $skipped skipped"
echo "=========================================="

if [[ $failed -gt 0 ]]; then
    exit 1
fi
exit 0
