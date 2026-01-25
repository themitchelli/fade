#!/bin/bash
# Test: Database containers detected from ORM/driver dependencies
# AC: Database containers detected from ORM/driver dependencies

# Setup - create a test project with database ORM
TEST_DIR="/tmp/fade-test-diagram-$$"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR" || exit 1

# Create a package.json with Prisma (ORM)
cat > package.json << 'EOF'
{
  "name": "test-db-app",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "@prisma/client": "^5.0.0"
  },
  "devDependencies": {
    "prisma": "^5.0.0"
  }
}
EOF

# Act - run fade map with container level diagram
fade map --diagram=container > /dev/null 2>&1

# Assert - check for database container
if [[ ! -f "architecture.html" ]]; then
    echo "FAIL: architecture.html was not created"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Check for database-related containers (ContainerDb or SystemDb)
if ! grep -qiE "ContainerDb|SystemDb|Database|Prisma" architecture.html; then
    echo "FAIL: No database container detected from Prisma dependency"
    echo "Expected: Database container in diagram"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
rm -rf "$TEST_DIR"

echo "PASS: Database containers detected from ORM/driver dependencies"
exit 0
