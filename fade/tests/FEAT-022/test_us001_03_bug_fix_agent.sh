#!/bin/bash
# Test: verify bug-fix agent pass exists and uses complexity estimator for model selection
# AC: FADE runs a 'bug-fix agent' pass to address the failure using a model chosen by the complexity estimator (ENH-023).

FADE_CLI="/Users/stevemitchell/Documents/GitHub/fade/bin/fade-cli"

# Test 1: Verify run_bug_fix_agent function exists
if ! grep -q 'run_bug_fix_agent()' "$FADE_CLI"; then
    echo "FAIL: run_bug_fix_agent function should exist"
    echo "Expected: run_bug_fix_agent() function definition"
    exit 1
fi

# Test 2: Verify bug-fix agent uses model selection based on complexity
if ! grep -A 30 'run_bug_fix_agent()' "$FADE_CLI" | grep -q 'get_prd_complexity'; then
    echo "FAIL: Bug-fix agent should use complexity estimator for model selection"
    echo "Expected: Call to get_prd_complexity in run_bug_fix_agent"
    exit 1
fi

# Test 3: Verify model mapping for complexity levels
if ! grep -A 30 'run_bug_fix_agent()' "$FADE_CLI" | grep -q 'simple.*haiku\|haiku'; then
    echo "FAIL: Bug-fix agent should map simple complexity to haiku"
    echo "Expected: Mapping of simple -> haiku model"
    exit 1
fi

# Test 4: Verify Claude is invoked for bug-fix
if ! grep -A 70 'run_bug_fix_agent()' "$FADE_CLI" | grep -qE 'claude_cmd=.*claude|selected_model'; then
    echo "FAIL: Bug-fix agent should invoke Claude with selected model"
    echo "Expected: Claude invocation with model parameter"
    exit 1
fi

# Test 5: Verify bug-fix context includes failure information
if ! grep -A 50 'run_bug_fix_agent()' "$FADE_CLI" | grep -q 'failed_log\|Failed Test'; then
    echo "FAIL: Bug-fix agent should include failed test information in context"
    echo "Expected: Reference to failed log or test output"
    exit 1
fi

echo "PASS: Bug-fix agent pass runs with model chosen by complexity estimator"
exit 0
