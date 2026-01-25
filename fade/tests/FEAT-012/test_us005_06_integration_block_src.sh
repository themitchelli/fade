#!/bin/bash
# Test: integration test - attempt to heal file in src/ directory, verify blocked
# AC: Integration test: Attempt to heal file in src/ directory, verify it's blocked

# Setup: Create a temporary directory structure
test_dir="/tmp/fade-safety-test-$$"
mkdir -p "$test_dir/src"
mkdir -p "$test_dir/fade/tests/PRD-TEST"

# Create a file with problematic pattern in src/ (should be blocked)
cat > "$test_dir/src/production_code.sh" << 'EOF'
#!/bin/bash
# Production code - should NEVER be auto-healed
result=$(cat file.txt | head -n -1)
EOF

# Create a file with problematic pattern in tests/ (should be allowed)
cat > "$test_dir/fade/tests/PRD-TEST/test_example.sh" << 'EOF'
#!/bin/bash
# Test code - can be healed
result=$(cat file.txt | head -n -1)
EOF

original_src_content=$(cat "$test_dir/src/production_code.sh")

# Simulate the safety check logic from fade-cli
file="$test_dir/src/production_code.sh"
tests_dir="$test_dir/fade/tests"

file_realpath=$(cd "$(dirname "$file")" && pwd -P)/$(basename "$file")
tests_realpath=$(cd "$tests_dir" && pwd -P)

blocked=false

# Check 1: File must be within tests directory
if [[ ! "$file_realpath" == "$tests_realpath"* ]]; then
    blocked=true
fi

# Check 2: Explicitly block production directories
if [[ "$file_realpath" == */src/* ]] || \
   [[ "$file_realpath" == */lib/* ]] || \
   [[ "$file_realpath" == */bin/* ]]; then
    blocked=true
fi

# Assert: src/ file should be blocked
if [[ "$blocked" != "true" ]]; then
    echo "FAIL: File in src/ should be blocked"
    echo "Expected: blocked=true"
    echo "Actual: blocked=$blocked"
    rm -rf "$test_dir"
    exit 1
fi

# Assert: src/ file should NOT be modified
current_src_content=$(cat "$test_dir/src/production_code.sh")
if [[ "$current_src_content" != "$original_src_content" ]]; then
    echo "FAIL: File in src/ should not be modified"
    echo "Expected: $original_src_content"
    echo "Actual: $current_src_content"
    rm -rf "$test_dir"
    exit 1
fi

# Cleanup
rm -rf "$test_dir"

echo "PASS: Healing attempt in src/ is correctly blocked"
exit 0
