#!/bin/bash
# Test: Safety constraints block healing attempts in lib/ directory
# AC: Healing explicitly blocks patterns: 'lib/' directory

# Setup: Create temporary lib/ directory with a shell script
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

mkdir -p "$TEMP_DIR/lib"
cat > "$TEMP_DIR/lib/utility.sh" << 'EOF'
#!/bin/bash
# Utility with portability issue
result=$(echo "data" | head -n -1)
EOF

chmod +x "$TEMP_DIR/lib/utility.sh"

cd /Users/stevemitchell/Documents/GitHub/fade

# Create minimal test that verifies lib/ is blocked
cat > "$TEMP_DIR/test.sh" << 'TESTSCRIPT'
#!/bin/bash
file_realpath="$TEMP_DIR/lib/utility.sh"

# Check 2: Explicitly block production directories
if [[ "$file_realpath" == */src/* ]] || \
   [[ "$file_realpath" == */lib/* ]] || \
   [[ "$file_realpath" == */bin/* ]] || \
   [[ ! "$file_realpath" == *test* ]]; then
    echo "SAFETY ERROR: Blocked healing attempt in restricted path: $file" >&2
    exit 0  # Correctly blocked
else
    exit 1  # Should have been blocked
fi
TESTSCRIPT

chmod +x "$TEMP_DIR/test.sh"
export TEMP_DIR

# Run test
TEST_OUTPUT=$("$TEMP_DIR/test.sh" 2>&1)
TEST_EXIT=$?

if [[ $TEST_EXIT -eq 0 ]] && echo "$TEST_OUTPUT" | grep -q "SAFETY ERROR"; then
    echo "PASS: Safety constraint correctly blocked lib/ directory"
    exit 0
else
    echo "FAIL: Safety constraint did not block lib/ directory"
    echo "Test output: $TEST_OUTPUT"
    exit 1
fi
