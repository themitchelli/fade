#!/bin/bash
# Test: verify README.md internal links are valid
# AC: Badges and links are valid

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"
README="$PROJECT_ROOT/README.md"

# Extract relative markdown links (not http links)
# Look for patterns like [text](relative/path)
relative_links=$(grep -oE '\]\([^)]+\)' "$README" | grep -v 'http' | sed 's/\](\(.*\))/\1/' | sort -u)

invalid=()

for link in $relative_links; do
    # Remove anchor fragments
    path="${link%%#*}"

    # Skip empty paths (pure anchor links)
    if [[ -z "$path" ]]; then
        continue
    fi

    # Check if path exists relative to project root
    if [[ ! -e "$PROJECT_ROOT/$path" ]]; then
        invalid+=("$link")
    fi
done

if [[ ${#invalid[@]} -gt 0 ]]; then
    echo "FAIL: README.md contains invalid internal links"
    echo "Expected: All internal links resolve"
    echo "Actual: Invalid links: ${invalid[*]}"
    exit 1
fi

echo "PASS: README.md internal links are valid"
exit 0
