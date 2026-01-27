# FADE Architecture

## Model Selection

FADE routes work to different Claude models based on explicit configuration and PRD complexity to optimize cost and quality. This section documents the simple, predictable routing logic.

### Routing Decision Flow

FADE uses a simple, predictable 3-path routing system:

```
┌──────────────────────────────┐
│ Start: fade run <PRD>        │
└──────────────┬───────────────┘
               │
               ▼
      ┌────────────────┐
      │ Path 1:        │
      │ --model flag?  │
      └────┬───────┬───┘
           │       │
         YES (use) NO
           │       │
           │       ▼
           │   ┌──────────────┐
           │   │ Path 2:      │
           │   │ FADE_MODEL   │
           │   │ env var?     │
           │   └──┬───────┬───┘
           │      │       │
           │    YES (use) NO
           │      │       │
           │      │       ▼
           │      │   ┌──────────────────┐
           │      │   │ Path 3:          │
           │      │   │ Read PRD         │
           │      │   │ complexity field │
           │      │   └──┬───────┬───┬───┘
           │      │      │       │   │
           │      │      │       │   └─── missing: default sonnet
           │      │      │       │
           │      │   simple  medium  complex
           │      │      │       │       │
           └──────┴──────┴───────┴───────┘
                        │
                        ▼
              ┌──────────────────┐
              │ Selected model:  │
              │ haiku/sonnet/    │
              │ opus             │
              └──────────────────┘
```

### Override Precedence

The model selection follows this strict precedence (highest to lowest):

1. **--model flag**: `fade run --model opus` (always wins)
2. **FADE_MODEL env var**: `FADE_MODEL=haiku fade run` (overrides complexity)
3. **Complexity routing**: PRD complexity field determines model
4. **Default**: `sonnet` if no complexity specified

### Complexity → Model Mapping

| Complexity | Model | Cost (per 1M tokens) | Use Case |
|------------|-------|---------------------|----------|
| `simple` | haiku | $0.25 in / $1.25 out | Quick fixes, typos, docs, simple tests |
| `medium` | sonnet | $3 in / $15 out | Standard features, endpoints, components |
| `complex` | opus | $15 in / $75 out | Architecture, multi-system integration, refactors |

### Example Routing Scenarios

#### Scenario 1: Simple PRD with no overrides
```json
{
  "id": "ENH-042",
  "name": "Fix typo in README",
  "complexity": "simple",
  ...
}
```
**Result**: haiku (complexity routing)

#### Scenario 2: Complex PRD with environment override
```bash
FADE_MODEL=sonnet fade run
```
```json
{
  "id": "FEAT-010",
  "name": "Multi-service integration",
  "complexity": "complex",
  ...
}
```
**Result**: sonnet (env var overrides complexity)

#### Scenario 3: Medium PRD with CLI override
```bash
fade run --model opus
```
```json
{
  "id": "FEAT-005",
  "name": "New API endpoint",
  "complexity": "medium",
  ...
}
```
**Result**: opus (CLI flag overrides everything)

#### Scenario 4: PRD without complexity field
```json
{
  "id": "BUG-003",
  "name": "Login timeout",
  ...
  // no complexity field
}
```
**Result**: sonnet (default when complexity missing)

### Setting Complexity

#### During PRD Creation

```bash
# Explicit complexity
fade new feature "User auth" --complexity=complex

# Interactive with heuristic suggestion
fade new enhancement "Dashboard UI"
# → Suggested complexity: medium (8 ACs, no special keywords)
# → Complexity? [simple/Medium/complex]:
```

#### For Existing PRDs

```bash
fade classify
# Scans all PRDs, suggests complexity, prompts to update
```

### Complexity Assignment

The complexity field in PRDs can be set:

1. **During PRD creation** with `fade new ... --complexity=simple|medium|complex`
2. **Interactively** when prompted during `fade new` (with heuristic suggestion)
3. **For existing PRDs** using `fade classify` to analyze and suggest complexity

#### Heuristic Analysis (for suggestions only)

When creating PRDs interactively, FADE suggests complexity based on analysis:

| Factor | Simple (-) | Complex (+) |
|--------|-----------|-------------|
| **AC count** | < 5 criteria (-1) | > 15 criteria (+2) |
| **Keywords** | "typo", "fix", "update docs", "add test" (-2) | "architecture", "refactor", "integrate", "migrate" (+2) |
| **Effort** | < 4 hours (-1) | > 1 week (+2) |
| **Dependencies** | 0-1 deps | > 2 deps (+1) |

**Score interpretation**: ≥ 3 = complex, ≤ -2 = simple, else medium

**Note:** Heuristic analysis is used for PRD creation suggestions only. It's not part of the runtime model selection logic.

---

## Implementation Notes

### Code Location

- **Model routing**: `bin/fade-cli` in `get_model_for_complexity()` function (lines ~736-790)
  - Implements the 3-path routing (flag → env → complexity → default)
  - Called during `cmd_run()` for both STOP and ALL modes
- **Complexity analysis**: `analyze_complexity()` function in `bin/fade-cli` (lines ~2142-2210)
  - Used only for PRD creation suggestions via `fade new` and `fade classify`
  - Not used in runtime model selection

### Tuning Complexity Heuristics

To adjust complexity thresholds (e.g., change AC count from 15 to 20 for complex):

1. Edit `analyze_complexity()` in `bin/fade-cli`
2. Update scoring thresholds in the scoring logic
3. Test with `fade classify` to verify new suggestions
4. Update this documentation when finalizing

### Future Work

Advanced model selection (learned heuristics, escalation tracking) has been deferred to v0.4.x. The current 3-path routing provides reliable, predictable model selection without machine learning complexity. See FADE.md Feature Stability section for details.
