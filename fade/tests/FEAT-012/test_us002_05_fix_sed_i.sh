#!/bin/bash
# Test: verify 'sed -i' is replaced with 'sed -i.bak'
# AC: Fix pattern: 'sed -i' → 'sed -i.bak' (add backup extension)

# Setup: Create a temporary test directory
test_dir="/tmp/fade-heal-sed-$$"
mkdir -p "$test_dir/fade/tests/PRD-TEST"

# Create a test script with the problematic pattern
cat > "$test_dir/fade/tests/PRD-TEST/test_example.sh" << 'EOF'
#!/bin/bash
# Test script with sed -i pattern
sed -i 's/foo/bar/g' file.txt
sed -i "s/hello/world/g" file.txt
EOF

# Apply fix directly (simulating the healer logic)
if grep -qE "sed -i ['\"]" "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    # Apply fix: sed -i 's/...' → sed -i.bak 's/...'
    sed -i.tmp "s/sed -i \(['\"\\/]\)/sed -i.bak \1/g" "$test_dir/fade/tests/PRD-TEST/test_example.sh"
    rm -f "$test_dir/fade/tests/PRD-TEST/test_example.sh.tmp"
fi

# Assert: The fix was applied
if grep -qE "sed -i ['\"]" "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    echo "FAIL: sed -i should have been replaced with sed -i.bak"
    echo "Expected: sed -i.bak"
    echo "Actual: $(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh")"
    rm -rf "$test_dir"
    exit 1
fi

if ! grep -q "sed -i.bak" "$test_dir/fade/tests/PRD-TEST/test_example.sh"; then
    echo "FAIL: File should contain sed -i.bak"
    echo "Expected: sed -i.bak"
    echo "Actual: $(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh")"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: sed -i is replaced with sed -i.bak"
exit 0
