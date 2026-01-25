#!/bin/bash
# Test: discovery asks API-specific questions for API features
# AC: If building API endpoint: asks about auth, validation, error handling, response format

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Check the fade-cli script for API questions
if [[ ! -f "$FADE_CLI" ]]; then
    echo "FAIL: fade-cli script not found"
    exit 1
fi

# Extract cmd_discover function with full content
discover_content=$(sed -n '/^cmd_discover()/,/^cmd_/p' "$FADE_CLI")

# Check for API Endpoint section header
if ! echo "$discover_content" | grep -qi "API Endpoint"; then
    echo "FAIL: Discovery missing API Endpoint question section"
    echo "Expected: section for API Endpoint questions"
    echo "Actual: 'API Endpoint' not found"
    exit 1
fi

# Check for authentication questions
if ! echo "$discover_content" | grep -qi "authentication\|auth"; then
    echo "FAIL: Discovery missing auth questions for APIs"
    echo "Expected: questions about authentication"
    echo "Actual: 'authentication' or 'auth' not found"
    exit 1
fi

# Check for validation questions
if ! echo "$discover_content" | grep -qi "validation\|validate"; then
    echo "FAIL: Discovery missing validation questions for APIs"
    echo "Expected: questions about input validation"
    echo "Actual: 'validation' or 'validate' not found"
    exit 1
fi

# Check for error handling questions
if ! echo "$discover_content" | grep -qi "error handling\|error response"; then
    echo "FAIL: Discovery missing error handling questions for APIs"
    echo "Expected: questions about error handling"
    echo "Actual: 'error handling' or 'error response' not found"
    exit 1
fi

# Check for response format questions
if ! echo "$discover_content" | grep -qi "response format\|response.*look"; then
    echo "FAIL: Discovery missing response format questions for APIs"
    echo "Expected: questions about response format"
    echo "Actual: response format questions not found"
    exit 1
fi

echo "PASS: discovery includes API endpoint questions (auth, validation, error handling, response format)"
exit 0
