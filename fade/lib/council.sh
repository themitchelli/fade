#!/bin/bash
# FADE Council Library
# Extracted from fade-cli for maintainability
# Provides council brief generation for PRDs

# Color definitions (needed by council functions)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

cmd_council() {
    local prd_id="$1"
    local run_id=""

    # Parse optional --run-id flag
    if [[ "$2" == "--run-id" ]] && [[ -n "$3" ]]; then
        run_id="$3"
    fi

    if [[ -z "$prd_id" ]]; then
        echo -e "${RED}Error: PRD ID required${NC}"
        echo ""
        echo "Usage: fade council <prd_id> [--run-id <run_id>]"
        echo "Example: fade council ENH-026"
        echo "Example: fade council ENH-026 --run-id 20260127-014902-379"
        exit 1
    fi

    # Find the PRD file by ID
    local prd_file=""
    local prd_data=""

    # Check in active PRDs first (fade/prds/ or prds/)
    if [[ -d "fade/prds" ]]; then
        prd_file=$(find fade/prds -name "*${prd_id}*.json" -type f | head -1)
    fi

    if [[ -z "$prd_file" ]] && [[ -d "prds" ]]; then
        prd_file=$(find prds -name "*${prd_id}*.json" -type f | head -1)
    fi

    # Check in archives if not found
    if [[ -z "$prd_file" ]] && [[ -d "fade/prd-archive" ]]; then
        prd_file=$(find fade/prd-archive -name "*${prd_id}*.json" -type f | head -1)
    fi

    if [[ -z "$prd_file" ]] && [[ -d "prd-archive" ]]; then
        prd_file=$(find prd-archive -name "*${prd_id}*.json" -type f | head -1)
    fi

    if [[ -z "$prd_file" ]]; then
        echo -e "${RED}Error: PRD not found: $prd_id${NC}"
        exit 1
    fi

    # Extract PRD metadata
    local prd_name=$(grep -o '"name": "[^"]*"' "$prd_file" | cut -d'"' -f4 | head -1)
    local prd_type=$(grep -o '"type": "[^"]*"' "$prd_file" | cut -d'"' -f4 | head -1)
    local prd_description=$(grep -o '"description": "[^"]*"' "$prd_file" | cut -d'"' -f4 | head -1)

    # Get project context
    local project_context=""
    if [[ -f "FADE.md" ]]; then
        project_context=$(head -100 FADE.md | tail -50)
    fi

    # Determine council directory based on run_id
    local council_dir="fade/council"
    if [[ -n "$run_id" ]]; then
        council_dir="fade/runs/$run_id/council"
    elif [[ ! -d "fade" ]]; then
        council_dir="council"
    fi

    # Create council directory if it doesn't exist
    mkdir -p "$council_dir"

    # Generate timestamp
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local timestamp_slug=$(date +"%Y%m%d-%H%M%S")

    # Create council brief filename
    local council_brief_file="$council_dir/${prd_id}-${timestamp_slug}.md"

    # Build council brief content
    cat > "$council_brief_file" << 'COUNCIL_EOF'
# Council Brief

COUNCIL_EOF

    cat >> "$council_brief_file" << COUNCIL_EOF

**Generated:** $timestamp
**PRD ID:** $prd_id
**PRD Name:** $prd_name
**PRD Type:** $prd_type

---

## Executive Summary

This council brief requests perspective on implementation approach for: **$prd_name**

**Type:** $prd_type | **ID:** $prd_id

**Description:**
$prd_description

---

## Project Context

\`\`\`
$project_context
\`\`\`

---

## Council Request

For the above PRD, please provide:

1. **Recommended Approach**: What is the highest-confidence path to success?
   - Key architectural decisions
   - Technology choices
   - Implementation sequence
   - Risk mitigation

2. **Alternative Approaches**: What other viable paths exist?
   - Pros and cons of each
   - When to use instead of recommended path
   - Trade-offs to consider

3. **Key Risks**: What could go wrong?
   - Technical risks
   - Integration risks
   - Security/performance risks
   - Backwards compatibility concerns
   - Test coverage needs

4. **What to Watch For**: During implementation, monitor for:
   - Early warning signs of problems
   - Assumptions that should be validated
   - Inflection points where approach might need pivot
   - Common pitfalls in similar work

---

## Implementation Notes

- See full PRD file for complete acceptance criteria: $prd_file
- This brief preserves decision rationale for team alignment
- Council output will be reviewed before implementation begins

COUNCIL_EOF

    echo -e "${GREEN}✓ Council brief generated${NC}"
    echo ""
    echo "Council brief saved to: ${CYAN}$council_brief_file${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Review the brief above"
    echo "  2. Paste brief into multiple LLMs (ChatGPT, Gemini, etc.)"
    echo "  3. Capture responses and compare perspectives"
    echo "  4. Use consensus to guide implementation"
    echo ""
    echo "To view the brief:"
    echo "  cat $council_brief_file"
}

# ============================================================================
# WORKSPACE COMMANDS
# ============================================================================

