#!/bin/bash
# Test: --diagram-title='My System' sets custom system name
# AC: --diagram-title='My System' sets custom system name

# Setup - create a test project
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create package.json with different name
cat > package.json << 'EOF'
{
  "name": "package-name",
  "version": "1.0.0"
}
EOF

# Act - run fade map with custom title
custom_title="My Custom System Title"
fade map --diagram --diagram-title="$custom_title" > /dev/null 2>&1

# Assert
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check that custom title appears in HTML
if ! grep -q "$custom_title" architecture.html; then
    echo "FAIL: Custom system title not found in HTML"
    echo "Expected: '$custom_title' in HTML"
    echo "Actual: $(grep -i 'title\|<h1>' architecture.html | head -3)"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Verify package name is NOT used as title
if grep -q "package-name - C4" architecture.html; then
    echo "FAIL: Package name used instead of custom title"
    echo "Expected: Custom title '$custom_title'"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: --diagram-title sets custom system name"
exit 0
