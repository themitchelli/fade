# PRD Template

Reference template for creating Product Requirement Documents in FADE.

---

## JSON Structure

All PRDs follow this JSON schema:

```json
{
  "type": "feature|bug|enhancement|chore|spike",
  "project": "Project Name",
  "id": "TYPE-NNN",
  "name": "Human-readable PRD name",
  "description": "Brief summary of what this PRD accomplishes and why it matters",
  "complexity": "simple|medium|complex",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Story title describing the capability",
      "description": "Detailed explanation of what this story delivers",
      "acceptanceCriteria": [
        "Criterion 1: Specific, measurable, testable requirement",
        "Criterion 2: Another specific requirement",
        "Criterion 3: Edge case or validation requirement"
      ],
      "priority": 1,
      "passes": false
    }
  ]
}
```

### Spike PRD Structure

Spikes include additional fields:

```json
{
  "type": "spike",
  "project": "Project Name",
  "id": "SPIKE-NNN",
  "name": "Research spike name",
  "description": "What needs to be researched and why",
  "complexity": "medium",
  "branchName": "spike/research-name",
  "outputArtifact": "docs/spike-research-name.md",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Investigation and documentation",
      "description": "Research and document findings",
      "acceptanceCriteria": [
        "Research completed",
        "Findings documented in output artifact",
        "Recommendations provided"
      ],
      "priority": 1,
      "passes": false
    }
  ]
}
```

---

## Field Definitions

### Required Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `type` | string | PRD type (feature, bug, enhancement, chore, spike) | `"feature"` |
| `project` | string | Project name | `"FADE"` |
| `id` | string | Unique identifier (TYPE-NUMBER) | `"FEAT-042"` |
| `name` | string | Human-readable name | `"Multi-repo dashboard"` |
| `description` | string | What and why (2-3 sentences) | `"Implements centralized monitoring for multiple FADE repos. Provides real-time visibility into progress."` |
| `userStories` | array | List of user stories (at least one) | See User Story Structure below |

### Optional Fields

| Field | Type | Description | Default |
|-------|------|-------------|---------|
| `complexity` | string | simple, medium, or complex | `"medium"` |
| `dependsOn` | array | IDs of PRDs that must complete first | `[]` |
| `branchName` | string | Feature branch name (spikes only) | `"spike/{slug}"` |
| `outputArtifact` | string | Deliverable location (spikes only) | `"docs/spike-{slug}.md"` |

---

## Complexity Field

**Purpose:** Determines which Claude model is used for execution.

| Complexity | Model | Use Case | Example PRDs |
|------------|-------|----------|--------------|
| `simple` | haiku | Quick fixes, typos, docs, single-file changes | Fix typo in README, Add logging statement, Update config value |
| `medium` | sonnet | Standard features, new endpoints, refactors | New API endpoint, UI component, Module refactor |
| `complex` | opus | Architecture changes, multi-system work | Multi-service integration, Framework migration, Cross-cutting refactor |

**How to set:**

```bash
# Explicit complexity during creation
fade new feature "User auth" --complexity=complex

# Interactive prompt (with heuristic suggestion)
fade new feature "User authentication"
# → Suggested complexity: complex (contains "authentication", estimated >1 week)
# → Complexity? [simple/Medium/complex]:

# Classify existing PRDs
fade classify
```

**When to omit:** If missing, defaults to `"medium"` (sonnet). Only omit if you're fine with the default.

---

## User Story Structure

Each user story must have:

```json
{
  "id": "US-001",
  "title": "Brief capability description",
  "description": "Detailed explanation of what gets built and why",
  "acceptanceCriteria": [
    "Specific, testable requirement 1",
    "Specific, testable requirement 2"
  ],
  "priority": 1,
  "passes": false
}
```

### User Story Guidelines

#### Good Story Titles
- "Add complexity field to PRD schema"
- "Heuristic complexity analyzer"
- "Intelligent model routing"

#### Bad Story Titles
- "Do the thing" (too vague)
- "Implement US-001" (circular reference)
- "Code changes" (not descriptive)

#### Good Acceptance Criteria
- "Add optional 'complexity' field to PRD JSON schema (values: 'simple', 'medium', 'complex')"
- "If missing, defaults to 'medium' (current behavior preserved)"
- "fade new --complexity=simple creates PRD with complexity field"

#### Bad Acceptance Criteria
- "Make it work" (not testable)
- "Do it right" (subjective)
- "Code is clean" (belongs in coding standards, not AC)

---

## Dependency Management

Use `dependsOn` to sequence PRDs when order matters:

```json
{
  "id": "FEAT-012",
  "name": "Dashboard authentication",
  "dependsOn": ["FEAT-010"],  // Must complete FEAT-010 first
  ...
}
```

**When to use dependencies:**
- Feature requires infrastructure from another PRD
- Bug fix needs architectural change from different PRD
- Enhancement builds on another enhancement

**When NOT to use:**
- General sequence preference (use priority instead)
- Same-PRD story ordering (use story priority)
- Soft preferences (document in description instead)

---

## Examples

### Example: Simple PRD

```json
{
  "type": "enhancement",
  "project": "FADE",
  "id": "ENH-042",
  "name": "Fix typo in README",
  "description": "Correct spelling error in installation section. Improves first-run experience.",
  "complexity": "simple",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Fix typo in README installation section",
      "description": "Change 'instal' to 'install' in README.md line 45",
      "acceptanceCriteria": [
        "Typo corrected in README.md",
        "No other text changed",
        "Markdown syntax still valid"
      ],
      "priority": 1,
      "passes": false
    }
  ]
}
```

### Example: Medium PRD

```json
{
  "type": "feature",
  "project": "FADE",
  "id": "FEAT-005",
  "name": "Add API endpoint for repo status",
  "description": "Implements /api/status endpoint for dashboard. Returns JSON with current PRD, work queue, and session status.",
  "complexity": "medium",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Create status API endpoint",
      "description": "Implement GET /api/status that returns current FADE session state",
      "acceptanceCriteria": [
        "Endpoint returns 200 with valid JSON",
        "JSON includes: currentPRD, workQueue, sessionStatus",
        "Authentication required (basic auth)",
        "Rate limited to 100 req/min per IP"
      ],
      "priority": 1,
      "passes": false
    },
    {
      "id": "US-002",
      "title": "Add error handling",
      "description": "Handle edge cases: no active PRD, empty queue, etc.",
      "acceptanceCriteria": [
        "Returns 404 if no FADE repo found",
        "Returns empty queue array if no PRDs",
        "Returns 500 with error message on server error"
      ],
      "priority": 2,
      "passes": false
    }
  ]
}
```

### Example: Complex PRD

```json
{
  "type": "feature",
  "project": "FADE",
  "id": "FEAT-010",
  "name": "Multi-service integration framework",
  "description": "Implements plugin system for integrating external services (GitHub, Jira, Slack). Provides standardized auth, event handling, and error recovery across all integrations.",
  "complexity": "complex",
  "dependsOn": ["FEAT-008", "FEAT-009"],
  "userStories": [
    {
      "id": "US-001",
      "title": "Design plugin architecture",
      "description": "Define plugin interface, lifecycle hooks, and service discovery pattern",
      "acceptanceCriteria": [
        "Plugin interface supports auth, webhooks, API calls",
        "Lifecycle hooks: init, connect, disconnect, error",
        "Service discovery via config.json + auto-detection",
        "Architecture documented in docs/architecture.md"
      ],
      "priority": 1,
      "passes": false
    },
    {
      "id": "US-002",
      "title": "Implement plugin loader",
      "description": "Create dynamic plugin loading system with error isolation",
      "acceptanceCriteria": [
        "Loads plugins from fade/plugins/ directory",
        "Plugin failures don't crash main process",
        "Validation: schema check before loading",
        "Error reporting: logs to fade/plugin-errors.log"
      ],
      "priority": 2,
      "passes": false
    }
  ]
}
```

---

## Creation Workflow

### Using fade new

```bash
# 1. Create PRD with interactive prompts
fade new feature "User authentication"
# → Suggested complexity: complex (contains "authentication")
# → Complexity? [simple/Medium/complex]: complex

# 2. Edit generated file
vim fade/prds/FEAT-042-user-authentication.json

# 3. Fill in description and user stories

# 4. Validate with fade status
fade status
# Should show new PRD in queue
```

### Manual Creation

If creating PRD manually (not recommended, use `fade new`):

1. Copy template above
2. Replace all placeholders
3. Ensure valid JSON (use `jq . < your-prd.json`)
4. Place in `fade/prds/` with correct naming: `TYPE-NNN-slug.json`
5. Validate with `fade status`

---

## Validation Checklist

Before running a PRD:

- [ ] All required fields present (type, project, id, name, description, userStories)
- [ ] `id` follows TYPE-NNN format (e.g., FEAT-042, BUG-003)
- [ ] Complexity set (simple/medium/complex) or omitted (defaults to medium)
- [ ] At least one user story with `passes: false`
- [ ] All acceptance criteria are specific and testable
- [ ] Dependencies exist and are complete (if `dependsOn` used)
- [ ] Valid JSON (run through `jq` or JSON validator)
- [ ] File named correctly: `{TYPE}-{NNN}-{slug}.json`

---

## Anti-Patterns to Avoid

### ❌ Bad: Vague acceptance criteria
```json
"acceptanceCriteria": [
  "Code works",
  "Make it fast",
  "Do it right"
]
```

### ✅ Good: Specific, testable criteria
```json
"acceptanceCriteria": [
  "Endpoint responds in < 200ms for queries with 1000 records",
  "Returns proper HTTP status codes (200, 404, 500)",
  "Input validation rejects malformed JSON with 400 error"
]
```

### ❌ Bad: Story per line of code
```json
{
  "id": "US-001",
  "title": "Add function declaration"
},
{
  "id": "US-002",
  "title": "Add function body"
}
```

### ✅ Good: Story per logical capability
```json
{
  "id": "US-001",
  "title": "Implement complexity analyzer",
  "description": "Create function that scores PRDs based on heuristics"
}
```

---

## When to Read This Standard

- Before creating a new PRD manually
- When `fade new` generated template needs customization
- When reviewing PRD quality before execution
- When adding new PRD types to the system

For automated PRD creation, use `fade new` which applies this template automatically.
