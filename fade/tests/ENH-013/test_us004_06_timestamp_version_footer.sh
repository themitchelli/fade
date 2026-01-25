#!/bin/bash
# Test: Generated timestamp and FADE version shown in footer
# AC: Generated timestamp and FADE version shown in footer

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0"
}
EOF

# Act - run fade map --diagram
fade map --diagram > /dev/null 2>&1

# Assert - check for footer with timestamp and version
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for footer element
if ! grep -q 'class="footer"' architecture.html; then
    echo "FAIL: Footer element not found"
    echo "Expected: Element with class='footer'"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for FADE reference in footer area
if ! grep -qi 'FADE' architecture.html; then
    echo "FAIL: FADE reference not found in HTML"
    echo "Expected: FADE name/version mentioned"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for timestamp pattern (YYYY-MM-DD or similar date format)
if ! grep -qE '[0-9]{4}-[0-9]{2}-[0-9]{2}|Generated|timestamp' architecture.html; then
    echo "FAIL: Timestamp pattern not found in HTML"
    echo "Expected: Date timestamp like YYYY-MM-DD or 'Generated' text"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Generated timestamp and FADE version shown in footer"
exit 0
