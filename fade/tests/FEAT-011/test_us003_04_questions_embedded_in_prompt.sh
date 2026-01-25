#!/bin/bash
# Test: question sets are defined (embedded in prompt)
# AC: Question sets defined in standards/ or embedded in prompt

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for domain-specific question sections
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function with full content
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for domain-specific questions section header
if ! echo "$discover_content" | grep -qi "Domain-Specific Questions\|domain.*question"; then
    echo "FAIL: Discovery missing domain-specific questions section"
    echo "Expected: 'Domain-Specific Questions' section header"
    echo "Actual: section header not found"
    exit 1
fi

# Check for multiple domain categories (at least API, UI, Data)
domain_count=0
if echo "$discover_content" | grep -qi "API Endpoint"; then
    ((domain_count++))
fi
if echo "$discover_content" | grep -qi "UI Component"; then
    ((domain_count++))
fi
if echo "$discover_content" | grep -qi "Data.*Feature\|Database"; then
    ((domain_count++))
fi

if [[ $domain_count -lt 3 ]]; then
    echo "FAIL: Discovery missing required domain categories"
    echo "Expected: at least 3 domain categories (API, UI, Data)"
    echo "Actual: found $domain_count categories"
    exit 1
fi

# Check for guidance on when to use domain questions
if ! echo "$discover_content" | grep -qi "how to use\|detect the domain\|based on.*feature"; then
    echo "FAIL: Discovery missing guidance on using domain questions"
    echo "Expected: guidance on detecting domain and using appropriate questions"
    echo "Actual: usage guidance not found"
    exit 1
fi

echo "PASS: question sets embedded in prompt with domain detection guidance"
exit 0
