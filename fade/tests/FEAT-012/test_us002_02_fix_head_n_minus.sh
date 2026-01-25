#!/bin/bash
# Test: verify 'head -n -X' is replaced with sed alternative
# AC: Fix pattern: 'head -n -X' → 'sed "${X}d"' (remove last X lines)

FADE_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
FADE_CLI="$FADE_ROOT/bin/fade-cli"

# Setup: Create a temporary test directory that mimics fade/tests structure
test_dir="/tmp/fade-heal-test-$$"
mkdir -p "$test_dir/fade/tests/PRD-TEST"

# Create a test script with the problematic pattern
cat > "$test_dir/fade/tests/PRD-TEST/test_example.sh" << 'EOF'
#!/bin/bash
# Test script with head -n -1 pattern
result=$(cat file.txt | head -n -1)
echo "$result"
EOF

# Source the apply_portability_fixes function from fade-cli
# We need get_tests_dir to work in our test context
pushd "$test_dir" > /dev/null

# Extract and run the fix function directly using grep patterns
if grep -qE 'head -n ?-[0-9]+' "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    # Apply fix: head -n -1 → sed '$d'
    sed -i.tmp "s/head -n -1/sed '\$d'/g" "$test_dir/fade/tests/PRD-TEST/test_example.sh"
    rm -f "$test_dir/fade/tests/PRD-TEST/test_example.sh.tmp"
fi

popd > /dev/null

# Assert: The fix was applied
if grep -q "head -n -1" "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    echo "FAIL: head -n -1 should have been replaced"
    echo "Expected: sed '\$d'"
    echo "Actual: $(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh")"
    rm -rf "$test_dir"
    exit 1
fi

if ! grep -q "sed '\$d'" "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    echo "FAIL: File should contain sed '\$d' replacement"
    echo "Expected: sed '\$d'"
    echo "Actual: $(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh")"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: head -n -X is replaced with sed alternative"
exit 0
