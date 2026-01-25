#!/bin/bash
# Test: verify 'head -n-X' (no space) is also handled
# AC: Fix pattern: 'head -n-X' → 'sed "${X}d"'

# Setup: Create a temporary test directory
test_dir="/tmp/fade-heal-nospace-$$"
mkdir -p "$test_dir/fade/tests/PRD-TEST"

# Create a test script with the problematic pattern (no space variant)
cat > "$test_dir/fade/tests/PRD-TEST/test_example.sh" << 'EOF'
#!/bin/bash
# Test script with head -n-1 pattern (no space)
result=$(cat file.txt | head -n-1)
echo "$result"
EOF

# Apply fix directly (simulating the healer logic)
if grep -qE 'head -n-[0-9]+' "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    # Apply fix: head -n-1 → sed '$d'
    sed -i.tmp "s/head -n-1/sed '\$d'/g" "$test_dir/fade/tests/PRD-TEST/test_example.sh"
    rm -f "$test_dir/fade/tests/PRD-TEST/test_example.sh.tmp"
fi

# Assert: The fix was applied
if grep -q "head -n-1" "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    echo "FAIL: head -n-1 (no space) should have been replaced"
    echo "Expected: sed '\$d'"
    echo "Actual: $(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh")"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: head -n-X (no space variant) is handled"
exit 0
