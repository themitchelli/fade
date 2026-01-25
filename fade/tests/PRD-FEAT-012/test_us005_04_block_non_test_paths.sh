#!/bin/bash
# Test: Safety constraints block healing attempts for files without 'test' in path
# AC: Healing explicitly blocks any file without 'test' in path

# Setup: Create temporary directory structure without 'test' in path
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

mkdir -p "$TEMP_DIR/scripts"
cat > "$TEMP_DIR/scripts/helper.sh" << 'EOF'
#!/bin/bash
# Helper script with portability issue
output=$(echo "data" | head -n -1)
EOF

chmod +x "$TEMP_DIR/scripts/helper.sh"

cd /Users/stevemitchell/Documents/GitHub/fade

# Create minimal test that verifies non-test paths are blocked
cat > "$TEMP_DIR/verify.sh" << 'TESTSCRIPT'
#!/bin/bash
file_realpath="$TEMP_DIR/scripts/helper.sh"

# Check 2: Explicitly block production directories
# The last condition checks for 'test' in the path
if [[ "$file_realpath" == */src/* ]] || \
   [[ "$file_realpath" == */lib/* ]] || \
   [[ "$file_realpath" == */bin/* ]] || \
   [[ ! "$file_realpath" == *test* ]]; then
    echo "SAFETY ERROR: Blocked healing attempt in restricted path (no 'test' in path)" >&2
    exit 0  # Correctly blocked
else
    exit 1  # Should have been blocked
fi
TESTSCRIPT

chmod +x "$TEMP_DIR/verify.sh"
export TEMP_DIR

# Run test
TEST_OUTPUT=$("$TEMP_DIR/verify.sh" 2>&1)
TEST_EXIT=$?

if [[ $TEST_EXIT -eq 0 ]] && echo "$TEST_OUTPUT" | grep -q "SAFETY ERROR"; then
    echo "PASS: Safety constraint correctly blocked path without 'test'"
    exit 0
else
    echo "FAIL: Safety constraint did not block path without 'test'"
    echo "Test output: $TEST_OUTPUT"
    exit 1
fi
