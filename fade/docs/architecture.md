# FADE Architecture

## Model Routing Decision Tree

FADE uses intelligent model selection based on PRD complexity to optimize cost and quality. This decision tree shows how the system determines which Claude model to use for each PRD.

### Decision Flow

```
┌─────────────────────────────────────────┐
│   Start: fade run detects active PRD    │
└────────────────┬────────────────────────┘
                 │
                 ▼
         ┌───────────────┐
         │ Check --model │  ◄─── Override 1: CLI flag (highest priority)
         │  flag present? │
         └───────┬───────┘
                 │
        ┌────────┴────────┐
        │                 │
      YES (use --model)  NO
        │                 │
        │                 ▼
        │         ┌───────────────┐
        │         │ Check FADE_   │  ◄─── Override 2: Environment variable
        │         │MODEL env var? │
        │         └───────┬───────┘
        │                 │
        │        ┌────────┴────────┐
        │        │                 │
        │       YES (use env)     NO
        │        │                 │
        │        │                 ▼
        │        │         ┌───────────────┐
        │        │         │ Read PRD      │
        │        │         │ complexity    │
        │        │         │ field         │
        │        │         └───────┬───────┘
        │        │                 │
        │        │         ┌───────┴────────┐
        │        │         │                │
        │        │    complexity?        (missing)
        │        │         │                │
        │        │         │                ▼
        │        │         │         DEFAULT: sonnet
        │        │         │
        │        │   ┌─────┴─────┬─────────┐
        │        │   │           │         │
        │        │ simple      medium   complex
        │        │   │           │         │
        │        │   │           │         │
        ▼        ▼   ▼           ▼         ▼
┌────────┬─────────┬──────────┬──────────┬─────────┐
│ --model│FADE_MODEL│  haiku   │  sonnet  │  opus   │
│  value │  value   │          │ (default)│         │
└────────┴─────────┴──────────┴──────────┴─────────┘
        │        │       │          │         │
        └────────┴───────┴──────────┴─────────┘
                         │
                         ▼
              ┌──────────────────┐
              │ Execute Claude   │
              │ with selected    │
              │ model            │
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

### Heuristic Analysis

The `analyze_complexity()` function scores PRDs based on:

| Factor | Simple (-) | Complex (+) |
|--------|-----------|-------------|
| **AC count** | < 5 criteria (-1) | > 15 criteria (+2) |
| **Keywords** | "typo", "fix", "update docs", "add test" (-2) | "architecture", "refactor", "integrate", "migrate" (+2) |
| **Effort** | < 4 hours (-1) | > 1 week (+2) |
| **Dependencies** | 0-1 deps | > 2 deps (+1) |

**Score interpretation**: ≥ 3 = complex, ≤ -2 = simple, else medium

### Cost Impact

Example: 40-50 PRDs/day across 5 repos

| Scenario | Model Mix | Est. Monthly Cost |
|----------|-----------|------------------|
| **No routing** (all sonnet) | 100% sonnet | ~$500/month |
| **Smart routing** | 30% haiku, 60% sonnet, 10% opus | ~$350/month (30% savings) |
| **Over-optimization** (all haiku) | 100% haiku | ~$50/month (but quality suffers on complex work) |

### Audit Trail

Model selections are logged in two locations:

1. **progress.md**: After each PRD completion
   ```
   ## Model Usage: haiku (complexity: simple, duration: 23m, cost est: $0.15)
   ```

2. **fade/model-usage.md**: Detailed log with aggregate stats
   ```
   | Date | PRD | Complexity | Model | Override | Duration | Est. Cost |
   |------|-----|-----------|-------|----------|----------|-----------|
   | 2026-01-25 | ENH-042 | simple | haiku | none | 18m | $0.12 |
   ```

---

## Implementation Notes

### Code Location

- **Model routing**: `bin/fade-cli` in `cmd_run()` function (lines ~1400-1450)
- **Complexity analysis**: `analyze_complexity()` function in `bin/fade-cli`
- **Heuristics**: Embedded directly in `analyze_complexity()`, tunable via threshold constants

### Extension Points

To add new complexity factors:

1. Edit `analyze_complexity()` in `bin/fade-cli`
2. Add scoring rule (e.g., `if grep -q "database migration" "$prd_file"; then score=$((score + 2)); fi`)
3. Log reasoning to learned.md for review
4. Update heuristics table in README.md and this document

### Future Enhancements

- **Learning feedback**: Track which complexity assignments led to PRD failures, auto-adjust heuristics
- **Project-specific tuning**: Allow `.fade-config` to override default thresholds
- **Model auto-upgrade**: If haiku fails, auto-retry with sonnet (requires failure detection)
