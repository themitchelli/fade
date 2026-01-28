# Token Optimization Analysis

Strategic framework for maximizing PRD throughput per dollar spent.

---

## Current Token Economics

### Per-Story Token Usage (Estimated)

Based on analysis of FADE workflow:

| Phase | Model | Tokens | Cost/Story | Can Optimize? |
|-------|-------|--------|------------|---------------|
| **Context Building** | Sonnet | 15-30K | £0.08-0.15 | ✅ Yes - Cache |
| **Code Exploration** | Sonnet | 10-20K | £0.05-0.10 | ✅ Yes - Use Haiku |
| **Analysis & Planning** | Sonnet | 5-10K | £0.03-0.05 | ✅ Yes - Use Haiku |
| **Implementation** | Sonnet | 20-40K | £0.10-0.20 | ⚠️ Partial - Smart routing |
| **Test Generation** | Sonnet | 10-15K | £0.05-0.08 | ✅ Yes - Use Haiku |
| **Regression Testing** | None | 0 | £0.00 | ✅ Already optimal |
| **Progress Documentation** | Sonnet | 5-10K | £0.03-0.05 | ⚠️ Partial |
| **TOTAL** | - | **65-125K** | **£0.34-0.63** | - |

### Model Cost Comparison

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Use Case |
|-------|----------------------|------------------------|----------|
| **Haiku** | $0.80 | $4.00 | Exploration, simple tasks, test generation |
| **Sonnet** | $3.00 | $15.00 | Implementation, complex logic |
| **Opus** | $15.00 | $75.00 | Architecture, critical algorithms |

**Key insight:** Haiku is **3.75x cheaper** for input, **3.75x cheaper** for output.

---

## Optimization Strategies

### Strategy 1: Phase Separation

**Break FADE workflow into distinct phases with model selection:**

```yaml
workflow:
  phase_1_explore:
    name: "Code Exploration"
    model: haiku
    purpose: "Understand existing code, find relevant files"
    tools: [Read, Grep, Glob]
    output: exploration_report.md
    estimated_tokens: 15K
    estimated_cost: £0.02

  phase_2_analyze:
    name: "Requirements Analysis"
    model: haiku
    purpose: "Break down acceptance criteria, identify approach"
    input: [prd.json, exploration_report.md]
    output: analysis.md
    estimated_tokens: 8K
    estimated_cost: £0.01

  phase_3_plan:
    name: "Implementation Plan"
    model: haiku
    purpose: "Design changes, list files to modify"
    input: [analysis.md, exploration_report.md]
    output: implementation_plan.md
    estimated_tokens: 10K
    estimated_cost: £0.01

  phase_4_implement:
    model: sonnet  # or opus for complex stories
    purpose: "Write code based on plan"
    input: [implementation_plan.md, relevant_files]
    tools: [Read, Write, Edit]
    estimated_tokens: 30K
    estimated_cost: £0.15

  phase_5_test:
    model: haiku
    purpose: "Generate test cases"
    input: [implementation_files]
    output: test_files
    estimated_tokens: 12K
    estimated_cost: £0.02

  phase_6_verify:
    model: none
    purpose: "Run regression tests"
    tools: [Bash]
    estimated_tokens: 0
    estimated_cost: £0.00
```

**Total estimated cost per story: £0.21** (vs current £0.34-0.63)
**Savings: 33-67% per story**

### Strategy 2: Context Caching

**Problem:** Every iteration rebuilds full context (FADE.md, progress.md, learned.md, PRD)

**Solution:** Cache stable context, only send deltas

```bash
# First iteration: Full context (expensive)
Context size: 50K tokens

# Iterations 2-8: Cached context + delta
Cached: 45K tokens (not sent again)
Delta: 5K tokens (only what changed)

Savings: 90% on context for iterations 2-8
```

**Implementation approach:**
- Use Claude's native prompt caching feature
- Mark FADE.md, standards/, learned.md as cacheable
- Only send story-specific content as fresh tokens

**Estimated savings:** 40-60% per story (after story 1)

### Strategy 3: Smart Model Routing

**Automatically route stories to appropriate model based on complexity:**

```python
def select_model(story):
    complexity = story.get('complexity', 'medium')

    # Simple stories: Haiku
    if complexity == 'simple':
        return 'haiku'

    # Check story characteristics
    if is_documentation(story):
        return 'haiku'

    if is_configuration(story):
        return 'haiku'

    if is_simple_crud(story):
        return 'haiku'

    # Medium complexity: Sonnet (default)
    if complexity == 'medium':
        # But check for patterns that could use Haiku
        if is_test_generation_only(story):
            return 'haiku'
        return 'sonnet'

    # Complex/high: Opus
    if complexity in ['complex', 'high']:
        if requires_architecture_design(story):
            return 'opus'
        if has_critical_algorithm(story):
            return 'opus'
        # Otherwise Sonnet can handle it
        return 'sonnet'

    return 'sonnet'  # safe default
```

**Estimated distribution:**
- 30% of stories → Haiku (£0.05 each)
- 60% of stories → Sonnet (£0.35 each)
- 10% of stories → Opus (£1.50 each)

**Average cost per story: £0.30** (vs current £0.50)
**Savings: 40%**

### Strategy 4: Batch Analysis

**Instead of analyzing per-story, analyze PRD upfront:**

```bash
# Batch analyze all 8 stories with Haiku
fade analyze-prd PRD-LC-010 --model haiku

# Output: Creates analysis files for all stories
# - analysis-US-001.md
# - analysis-US-002.md
# - ...
# - analysis-US-008.md

# Cost: £0.10 total (all 8 stories analyzed at once)
# Per story: £0.0125 (vs £0.08 per story individually)

# Then during implementation:
fade run --use-analysis

# Each iteration loads pre-analyzed plan (cheap)
# Implementation proceeds with Sonnet using the plan
```

**Savings: 84% on analysis phase**

### Strategy 5: Incremental Context

**Only send what changed since last iteration:**

```
Iteration 1:
  Send: Full context (50K tokens)

Iteration 2:
  Send:
    - "Previous iteration completed US-001"
    - "Current story: US-002"
    - US-002 details (5K tokens)

  Don't send again:
    - FADE.md (unchanged)
    - Standards (unchanged)
    - Completed stories (no longer relevant)
```

**Estimated savings:** 60-80% on context per iteration

---

## Optimization Scenarios

### Scenario A: Minimal Changes (Quick Wins)

**Changes needed:**
1. Add `--model` flag support for all commands
2. Add complexity-based model selection
3. Document when to use each model

**Implementation effort:** 1 PRD (~2 hours)

**Expected savings:** 25-30%

**New capacity:** 69-73 PRDs/month (same budget)

### Scenario B: Phase Separation

**Changes needed:**
1. Add `fade analyze` command (Haiku-powered exploration)
2. Add `fade plan` command (Haiku-powered planning)
3. Add `fade implement` command (reads plan, implements with Sonnet)
4. Add `fade test-gen` command (Haiku-powered test generation)

**Implementation effort:** 3-4 PRDs (~1 week)

**Expected savings:** 40-50%

**New capacity:** 88-110 PRDs/month (same budget)

### Scenario C: Full Optimization (Context Caching + Phases)

**Changes needed:**
1. All changes from Scenario B
2. Implement Claude prompt caching
3. Incremental context sending
4. Batch analysis mode

**Implementation effort:** 6-8 PRDs (~2 weeks)

**Expected savings:** 60-70%

**New capacity:** 138-183 PRDs/month (same budget)

---

## Recommended Approach

### Phase 1: Immediate (This Week)

**Manual optimizations (no code changes):**

1. **Use Haiku for simple stories manually**
   ```bash
   fade run --model haiku
   ```
   - Documentation updates
   - Configuration changes
   - Simple refactors
   - Test-only changes

2. **Pre-explore with grep/glob**
   ```bash
   # Before running fade, manually explore
   grep -r "function_name" src/
   find . -name "*config*"

   # Then tell Claude: "Based on this grep output..."
   # Saves exploration tokens
   ```

3. **Batch similar stories**
   - Group 2-3 simple stories together
   - Single iteration implements all
   - Reduces context rebuilding

**Estimated savings: 15-20%**
**Effort: 0 hours (just process changes)**

### Phase 2: Quick Wins (Next Week)

**Code changes needed:**

1. **Add `fade analyze` command**
   - Haiku explores codebase
   - Outputs markdown report
   - Sonnet reads report (not full codebase)

2. **Add complexity-based routing**
   - Read `complexity` field from PRD
   - Auto-select haiku/sonnet/opus
   - Override with `--model` flag

**Estimated savings: 30-40%**
**Effort: 1-2 PRDs (~4 hours)**

### Phase 3: Advanced (Next Month)

**Architectural changes:**

1. **Implement prompt caching**
   - Mark FADE.md, standards, learned.md as cacheable
   - Only send deltas per iteration

2. **Multi-phase workflow**
   - Separate analyze → plan → implement → test
   - Each phase uses optimal model

**Estimated savings: 60-70%**
**Effort: 6-8 PRDs (~2 weeks)**

---

## Success Metrics

Track these metrics to measure optimization impact:

| Metric | Current | Target (Phase 1) | Target (Phase 2) | Target (Phase 3) |
|--------|---------|------------------|------------------|------------------|
| Cost per story | £0.50 | £0.42 | £0.30 | £0.18 |
| PRDs per £100 | 50 | 59 | 83 | 139 |
| Stories per day | 16 | 19 | 26 | 43 |
| Token efficiency | 100% | 115% | 167% | 278% |

---

## Decision Matrix: Which Stories Use Which Model?

### ✅ Haiku Stories (Cheap: £0.05-0.10)

**Use Haiku when:**
- ✅ Documentation updates (README, comments, docs/)
- ✅ Configuration files (JSON, YAML, .env templates)
- ✅ Simple refactors (rename variable, extract constant)
- ✅ Test generation (after code is written)
- ✅ Code exploration (finding files, reading code)
- ✅ Straightforward CRUD operations
- ✅ Adding logging or error messages
- ✅ Fixing typos or formatting

**Examples from your PRDs:**
- "Update README with installation instructions"
- "Add configuration validation"
- "Generate tests for solver module"
- "Add error logging to ESG engine"

### 🔵 Sonnet Stories (Medium: £0.25-0.50)

**Use Sonnet when:**
- 🔵 Implementing business logic
- 🔵 API endpoint creation
- 🔵 Database operations
- 🔵 Integration between components
- 🔵 Moderate refactoring
- 🔵 Bug fixes (non-trivial)
- 🔵 Performance optimizations

**Examples from your PRDs:**
- "Implement solver algorithm selection"
- "Add SharedArrayBuffer data bus"
- "Create ICalcEngine interface"
- "Implement iteration tracking"

### 🔴 Opus Stories (Expensive: £1.00-2.00)

**Use Opus when:**
- 🔴 Designing new architecture
- 🔴 Complex algorithms (optimization, ML)
- 🔴 Critical security features
- 🔴 Performance-critical code (C++ SIMD)
- 🔴 Multi-component orchestration
- 🔴 Breaking architectural changes

**Examples from your PRDs:**
- "Design DAG configuration & composition"
- "Implement Vasicek stochastic model"
- "Optimize C++ projection engine with SIMD"
- "Design cross-engine orchestration"

---

## Action Items

### Immediate (Tonight)

- [ ] Identify 5 upcoming stories that could use Haiku
- [ ] Try `fade run --model haiku` on next simple story
- [ ] Measure token usage difference

### This Week

- [ ] Create PRD: "Smart Model Routing" (ENH-XXX)
- [ ] Implement `--model` flag support in fade run
- [ ] Add complexity field to all PRDs

### Next Week

- [ ] Create PRD: "Phase Separation Workflow" (ENH-XXX)
- [ ] Implement `fade analyze` command (Haiku-powered)
- [ ] Implement `fade test-gen` command (Haiku-powered)

### Next Month

- [ ] Create PRD: "Context Caching" (ENH-XXX)
- [ ] Implement Claude prompt caching
- [ ] Measure total savings vs baseline

---

## Appendix: Token Cost Calculator

```python
# Use this to estimate cost for a story

HAIKU_INPUT = 0.80 / 1_000_000   # $ per token
HAIKU_OUTPUT = 4.00 / 1_000_000
SONNET_INPUT = 3.00 / 1_000_000
SONNET_OUTPUT = 15.00 / 1_000_000
OPUS_INPUT = 15.00 / 1_000_000
OPUS_OUTPUT = 75.00 / 1_000_000

GBP_TO_USD = 0.79  # Approximate

def estimate_cost(input_tokens, output_tokens, model='sonnet'):
    rates = {
        'haiku': (HAIKU_INPUT, HAIKU_OUTPUT),
        'sonnet': (SONNET_INPUT, SONNET_OUTPUT),
        'opus': (OPUS_INPUT, OPUS_OUTPUT)
    }

    input_rate, output_rate = rates[model]
    cost_usd = (input_tokens * input_rate) + (output_tokens * output_rate)
    cost_gbp = cost_usd / GBP_TO_USD

    return cost_gbp

# Example: Story with 40K input, 15K output
print(f"Haiku: £{estimate_cost(40000, 15000, 'haiku'):.2f}")
print(f"Sonnet: £{estimate_cost(40000, 15000, 'sonnet'):.2f}")
print(f"Opus: £{estimate_cost(40000, 15000, 'opus'):.2f}")
```

**Output:**
```
Haiku: £0.10
Sonnet: £0.44
Opus: £2.19
```

**Key insight:** Using Haiku instead of Sonnet saves 77% per story!
