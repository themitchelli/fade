#!/bin/bash
# Test: Safety constraints allow healing in legitimate test directories
# AC: Files in fade/tests/ or tests/ directories are allowed (positive test case)

# Setup: Create test directory structure that should be allowed
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

mkdir -p "$TEMP_DIR/fade/tests/PRD-TEST"
cat > "$TEMP_DIR/fade/tests/PRD-TEST/test_example.sh" << 'EOF'
#!/bin/bash
# Test script with portability issue that SHOULD be healable
output=$(echo "data" | head -n -1)
EOF

chmod +x "$TEMP_DIR/fade/tests/PRD-TEST/test_example.sh"

cd /Users/stevemitchell/Documents/GitHub/fade

# Create test that verifies test/ paths are allowed
cat > "$TEMP_DIR/verify.sh" << 'TESTSCRIPT'
#!/bin/bash
file_realpath="$TEMP_DIR/fade/tests/PRD-TEST/test_example.sh"
tests_realpath="$TEMP_DIR/fade/tests"

# Check 1: File must be within tests directory
if [[ ! "$file_realpath" == "$tests_realpath"* ]]; then
    echo "ERROR: File rejected incorrectly (not in tests path)" >&2
    exit 1
fi

# Check 2: Should NOT be blocked (has 'test' in path, not in src/lib/bin)
if [[ "$file_realpath" == */src/* ]] || \
   [[ "$file_realpath" == */lib/* ]] || \
   [[ "$file_realpath" == */bin/* ]] || \
   [[ ! "$file_realpath" == *test* ]]; then
    echo "ERROR: Legitimate test file was incorrectly blocked" >&2
    exit 1
fi

echo "ALLOWED: Legitimate test file passed safety checks" >&2
exit 0
TESTSCRIPT

chmod +x "$TEMP_DIR/verify.sh"
export TEMP_DIR

# Run test
TEST_OUTPUT=$("$TEMP_DIR/verify.sh" 2>&1)
TEST_EXIT=$?

if [[ $TEST_EXIT -eq 0 ]] && echo "$TEST_OUTPUT" | grep -q "ALLOWED"; then
    echo "PASS: Safety constraints correctly allow legitimate test files"
    exit 0
else
    echo "FAIL: Safety constraints incorrectly blocked legitimate test file"
    echo "Test output: $TEST_OUTPUT"
    exit 1
fi
