# Skipped: US-001 AC-04 - PRD includes complexity recommendation

**Acceptance Criterion:** PRD includes an explicit `complexity` recommendation and stores the estimator rationale (brief) in the PRD description or a sidecar file.

**Reason:** Like AC-03, this criterion requires executing a full interactive Claude session to generate a PRD. The complexity field and rationale are determined by Claude during the interview process, which cannot be tested without:
1. Running the interactive LLM-powered interview flow
2. Inspecting the generated PRD for the complexity field
3. Paying API costs for each test execution

**Alternative verification:**
- Manual testing by running `fade prd new "Test Feature"` and checking the generated PRD includes `"complexity": "simple|medium|complex"`
- Code review of PRD generation template to confirm complexity field is included in the schema
- Review existing PRDs in fade/prds/ to verify they contain complexity fields
