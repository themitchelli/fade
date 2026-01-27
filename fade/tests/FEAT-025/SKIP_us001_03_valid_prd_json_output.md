# Skipped: US-001 AC-03 - Output is valid PRD JSON

**Acceptance Criterion:** Output is a valid PRD JSON file in `fade/prds/` with properly numbered US items and acceptance criteria.

**Reason:** This criterion requires executing a full interactive Claude session to generate a PRD. Automated shell tests cannot:
1. Run the interactive interview flow which requires LLM API calls
2. Wait for user input during the interview process
3. Pay for Claude API costs on each test run

**Alternative verification:**
- Manual testing by running `fade prd new "Test Feature"` and inspecting the output
- Integration tests in a controlled CI environment with mocked Claude responses
- Review of existing PRDs in fade/prds/ to confirm schema compliance
- Code review of PRD generation logic in `cmd_discover --prd` to verify it produces valid JSON
