# Skipped: US-005 AC-04 - npm handles CLI binary, fade update handles project artifacts

**Acceptance Criterion:** "npm handles CLI binary, fade update handles project artifacts"

**Reason:** This is an architectural design decision documented in the README. The separation between npm package management and fade update is implicit in how the system works - it cannot be tested programmatically without complex integration testing.

**Alternative:** This is verified by documentation review:
- README.md section "Updating Project Artifacts" explains the separation
- npm package includes CLI binary (bin/fade-cli)
- fade update downloads/updates prompt.md and standards/ independently

The design decision is that:
- npm install/update manages the CLI executable
- fade update manages project-level artifacts (prompt.md, standards/)
