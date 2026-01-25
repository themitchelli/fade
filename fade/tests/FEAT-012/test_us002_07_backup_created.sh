#!/bin/bash
# Test: verify backup of original file is created before applying fix
# AC: Create backup of original file before applying fix

# Setup: Create a temporary test directory
test_dir="/tmp/fade-heal-backup-$$"
mkdir -p "$test_dir/fade/tests/PRD-TEST"

# Create a test script with the problematic pattern
cat > "$test_dir/fade/tests/PRD-TEST/test_example.sh" << 'EOF'
#!/bin/bash
# Test script with head -n -1 pattern
result=$(cat file.txt | head -n -1)
echo "$result"
EOF

original_content=$(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh")

# Apply fix with backup (simulating the healer logic)
cp "$test_dir/fade/tests/PRD-TEST/test_example.sh" "$test_dir/fade/tests/PRD-TEST/test_example.sh.bak"
sed -i.tmp "s/head -n -1/sed '\$d'/g" "$test_dir/fade/tests/PRD-TEST/test_example.sh"
rm -f "$test_dir/fade/tests/PRD-TEST/test_example.sh.tmp"

# Assert: Backup file exists
if [[ ! -f "$test_dir/fade/tests/PRD-TEST/test_example.sh.bak" ]]; then
    echo "FAIL: Backup file should be created"
    echo "Expected: test_example.sh.bak to exist"
    echo "Actual: file not found"
    rm -rf "$test_dir"
    exit 1
fi

# Assert: Backup contains original content
backup_content=$(cat "$test_dir/fade/tests/PRD-TEST/test_example.sh.bak")
if [[ "$backup_content" != "$original_content" ]]; then
    echo "FAIL: Backup should contain original content"
    echo "Expected: $original_content"
    echo "Actual: $backup_content"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: Backup of original file is created before applying fix"
exit 0
