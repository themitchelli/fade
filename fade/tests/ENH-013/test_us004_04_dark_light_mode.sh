#!/bin/bash
# Test: Dark/light mode toggle
# AC: Dark/light mode toggle

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

# Assert - check for dark/light mode support
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for theme toggle function
if ! grep -q 'toggleTheme\|themeBtn\|dark.*mode\|Dark Mode' architecture.html; then
    echo "FAIL: Theme toggle function/button not found"
    echo "Expected: toggleTheme() function or Dark Mode button"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for dark theme CSS
if ! grep -qi 'data-theme.*dark\|dark.*theme\|theme.*dark' architecture.html; then
    echo "FAIL: Dark theme CSS support not found"
    echo "Expected: data-theme='dark' or similar dark theme styling"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for CSS variables (commonly used for theming)
if ! grep -q '\-\-bg-color\|:root' architecture.html; then
    echo "FAIL: CSS variables for theming not found"
    echo "Expected: CSS custom properties like --bg-color"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Dark/light mode toggle"
exit 0
