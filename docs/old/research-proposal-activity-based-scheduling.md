# Research Proposal: Activity-Based Multi-Repository Scheduling for Agentic Software Development

**Status:** Proposal for Academic Collaboration
**Target Venue:** ICSE 2027 (International Conference on Software Engineering) - Experience Reports Track
**Alternative Venues:** FSE 2027, ASE 2027, CHI 2027 (Human-AI Collaboration)
**Proposed Title:** "Beyond Sequential Execution: Activity-Based Scheduling for Multi-Repository Agentic Development Under API Usage Constraints"

---

## Executive Summary

We propose research into **activity-based scheduling for agentic software development**—a novel approach that optimizes autonomous AI work across multiple repositories by batching similar activities and scheduling based on API session constraints rather than traditional project boundaries.

**What exists today:** FADE (Framework for Agentic Development), a production system processing PRDs via Claude Code across 5 real-world repositories with 21 completed features, 807 commits, and demonstrated autonomous overnight execution.

**What we're proposing:** Extend FADE with intelligent cross-repository scheduling that classifies work by activity type, builds dependency graphs, and optimizes execution for AI session economics (5-hour windows, message budgets, cost minimization).

**Expected contribution:** First system to demonstrate AI-native project management optimized for LLM session constraints, with empirical validation showing 3-5x throughput improvement and 40-60% cost reduction over sequential execution.

**Industry impact:** Fundamentally changes how organizations manage large-scale autonomous development, potentially influencing API design at Anthropic, GitHub Copilot roadmap, and spawning new developer productivity tools.

---

## 1. Problem Statement

### 1.1 The Multi-Repository Development Challenge

Modern software organizations manage portfolios of 10-100+ repositories:
- Microservices architectures (dozens of service repos)
- Multi-platform products (iOS, Android, web, backend repos)
- Tool ecosystems (CLI, SDK, documentation, examples)
- Enterprise polyglot environments (polyrepo > monorepo trend)

**Current autonomous development tools are fundamentally repository-bound:**
- GitHub Copilot Workspace: Single-repo, single-issue
- Devin: Operates on one task at a time, no cross-project optimization
- Cursor/Windsurf: IDE-bound, single active context
- AutoGPT/BabyAGI: General agents with no software-specific multi-repo awareness

### 1.2 The Sequential Execution Bottleneck

**Existing workflow:**
```
Repository A: Complete PRD-001 (6 stories) → 3 hours
Repository B: Complete PRD-002 (8 stories) → 4 hours
Repository C: Complete PRD-003 (4 stories) → 2 hours

Total: 9 hours, 3 separate sessions, no knowledge transfer
```

**Problems:**
1. **Inefficient context switching:** AI writes tests, then fixes bugs, then writes tests again (different mental models interleaved)
2. **Blocking dependencies across repos:** Repo B needs schema changes from Repo A/Story-3 but must wait for all of Repo A
3. **No pattern reuse:** Same shell script portability bug fixed in 3 repos over 3 weeks, zero learning transfer
4. **Suboptimal resource utilization:** Hit API limits mid-PRD, waste session capacity
5. **Manual model selection:** User guesses whether task needs Opus vs Haiku, often wrong

### 1.3 The API Economics Constraint (Novel)

Large Language Models impose usage constraints fundamentally different from human work:

**Claude Max Plan (current real-world constraint):**
- 5-hour session windows (hard reset)
- 900 messages per window (at 20x tier)
- Pricing: Opus $15/$75, Sonnet $3/$15, Haiku $0.25/$1.25 per 1M tokens
- No priority queuing, no elastic scaling

**This creates a novel optimization problem:**
- How to maximize value per session window?
- How to select cheapest viable model per task?
- How to batch work to reduce context-loading overhead?
- How to schedule across repos to exploit pattern reuse?

**No existing system optimizes for these constraints.**

### 1.4 Research Questions

**RQ1:** Can activity-based batching (grouping similar work across repos) improve throughput vs. sequential PRD execution?

**RQ2:** Can automatic dependency analysis and prioritization reduce critical path duration in multi-repository portfolios?

**RQ3:** Can intelligent model selection based on activity classification reduce costs while maintaining quality?

**RQ4:** Do cross-repository patterns (e.g., shell script fixes, testing strategies) enable knowledge transfer that improves success rates?

**RQ5:** How do users perceive activity-based scheduling vs. traditional PRD-sequential execution in terms of control, predictability, and trust?

---

## 2. Related Work

### 2.1 Autonomous Software Engineering Agents

**GitHub Copilot Workspace (Microsoft, 2024)**
- Generates code from natural language issue descriptions
- Single-repo scope, user-initiated tasks
- No cross-project intelligence or scheduling
- **Gap:** Sequential task model, no multi-repo optimization

**Devin (Cognition Labs, 2024)**
- Autonomous software engineer, end-to-end task completion
- Impressive demos: training ML models, fixing bugs, building apps
- Uses traditional ticket-based workflow
- **Gap:** Single-task focus, no portfolio-level scheduling

**SWE-agent (Princeton, 2024 - arXiv:2405.15793)**
- Repository-level coding agent with tool use
- Browses code, edits files, runs tests
- Designed for single-repo benchmark tasks
- **Gap:** No multi-repo awareness, no activity batching

**AutoGPT / BabyAGI (2023)**
- General autonomous agents with goal decomposition
- No software development specialization
- Manual orchestration by user
- **Gap:** No software-specific optimizations, no cost awareness

### 2.2 Multi-Agent Systems

**Microsoft AutoGen (2023)**
- Framework for conversational multi-agent systems
- User defines agent roles and orchestration patterns
- Used for coding, math, research tasks
- **Gap:** User-defined orchestration (not automatic), no scheduling optimization

**MetaGPT (2024 - ICLR)**
- Simulates software company with role-based agents (PM, architect, engineer, QA)
- Structured output passing between roles
- Evaluated on single-repo tasks
- **Gap:** Still sequential (PM → architect → engineer), no cross-project batching

**Stanford Generative Agents (2023)**
- Simulated human-like behaviors in virtual environment
- Not focused on production software development
- **Gap:** Simulation vs. real-world production systems

### 2.3 Software Project Management & Scheduling

**Classical project management:**
- PERT/CPM: Critical path analysis for project scheduling
- Agile/Scrum: Sprint-based, human-centric time boxing
- Kanban: Work-in-progress limits, pull-based flow

**Gap:** All assume human workers with flexible context switching. None optimize for AI session constraints (5-hour windows, message budgets, cost per invocation).

**Task scheduling literature:**
- Job shop scheduling, multi-processor scheduling
- Dependency-aware task graphs
- Resource-constrained optimization

**Gap:** Assumes homogeneous resources. AI agents have heterogeneous capabilities (Opus vs Haiku), context-loading costs, and session boundaries.

### 2.4 Code Clone Detection & Pattern Mining

**Research on cross-repository analysis:**
- Jiang et al., "Large-Scale Mining of Cross-Project Code Clones" (ICSE 2019)
- Lopes et al., "DéjàVu: A Map of Code Duplicates on GitHub" (OOPSLA 2017)

**Gap:** Detection only, not actionable scheduling. Our work: detect AND batch similar fixes across repos.

### 2.5 Positioning: What's Novel?

| System | Multi-Repo | Activity Batching | Dependency-Aware | Cost-Optimized | Session-Aware |
|--------|-----------|------------------|------------------|----------------|---------------|
| GitHub Copilot | ❌ | ❌ | ❌ | ❌ | ❌ |
| Devin | ❌ | ❌ | ❌ | ❌ | ❌ |
| SWE-agent | ❌ | ❌ | ❌ | ❌ | ❌ |
| AutoGen | Manual | ❌ | Manual | ❌ | ❌ |
| MetaGPT | ❌ | ❌ | Sequential | ❌ | ❌ |
| **FADE-Scheduler** | ✅ | ✅ | ✅ | ✅ | ✅ |

**Our contribution is the intersection of all five dimensions.**

---

## 3. Existing Foundation: FADE Production System

### 3.1 What Already Exists (Validated)

**FADE (Framework for Agentic Development)** is a production system with:

**Architecture:**
- 8,899 lines of bash orchestrating Claude Code
- PRD-driven workflow: JSON specifications → User stories → Acceptance criteria
- Autonomous execution modes: STOP (single story), ALL (loop), YOLO (unattended)
- Model selection: Opus, Sonnet, Haiku (manual selection via `--model` flag)

**Production deployment:**
- 5 active repositories: fade, ai-built-actuarial-model, fade-prd-generator, assumptionsmanager, livecalc
- 21 completed PRDs (features, bugs, enhancements, chores)
- 807 git commits with conventional commit messages
- Overnight autonomous execution (YOLO mode runs 01:30-07:00 unattended)

**Key capabilities already proven:**
- ✅ Autonomous test-driven development (generates tests, runs regressions)
- ✅ Self-healing (detects shell portability errors, applies fixes, retries—FEAT-012 shipped)
- ✅ Documentation generation (FADE.md, progress.md logging)
- ✅ Safe execution (directory constraints, backup files, audit logging)
- ✅ Multi-model support (can call Opus/Sonnet/Haiku)

**Empirical data available:**
- User story completion times (logged in progress.md)
- Test pass/fail rates (regression test results)
- Failure patterns (healing-log.md for shell portability issues)
- Git history showing real-world code changes

### 3.2 What's Missing (Research Gap)

**Current FADE limitations:**
1. **Sequential PRD execution:** Processes one PRD at a time, in queue order
2. **No cross-repository intelligence:** Each repo is isolated, no pattern sharing
3. **Manual model selection:** User guesses complexity, often uses wrong model
4. **No dependency awareness:** Can't prioritize stories that unblock others
5. **No activity batching:** "Write tests" tasks scattered across time, repos

**This is the research opportunity:** Extend proven production system with intelligent scheduling.

---

## 4. Proposed Solution: Activity-Based Multi-Repo Scheduler

### 4.1 System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                  FADE Multi-Repo Scheduler                   │
└─────────────────────────────────────────────────────────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
   ┌─────────┐      ┌─────────┐      ┌─────────┐
   │ Repo A  │      │ Repo B  │      │ Repo C  │
   │ 3 PRDs  │      │ 2 PRDs  │      │ 4 PRDs  │
   │ 12 stor.│      │ 8 stor. │      │ 18 stor.│
   └─────────┘      └─────────┘      └─────────┘
        │                  │                  │
        └──────────────────┴──────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │   Story Extractor        │
              │   - Parse all PRDs       │
              │   - Extract user stories │
              │   - Build global pool    │
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Activity Classifier     │
              │  - Testing (simple)      │
              │  - Shell script (simple) │
              │  - Refactoring (medium)  │
              │  - Architecture (complex)│
              │  - Documentation (simple)│
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Dependency Analyzer     │
              │  - Parse "dependsOn"     │
              │  - Build story graph     │
              │  - Compute blocking sets │
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Priority Scorer         │
              │  - Dependency weight     │
              │  - Activity batching     │
              │  - Cross-repo patterns   │
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Batch Optimizer         │
              │  - Fit to 5hr window     │
              │  - Respect 900 msg budget│
              │  - Minimize cost         │
              │  - Group by activity     │
              └─────────────────────────┘
                           │
                           ▼
              ┌─────────────────────────┐
              │  Execution Engine        │
              │  - Claude Code invocation│
              │  - Cross-repo commits    │
              │  - Progress tracking     │
              └─────────────────────────┘
```

### 4.2 Key Algorithms

#### 4.2.1 Activity Classification

**Input:** User story with title, description, acceptance criteria
**Output:** Activity type + complexity score

**Classifier (rule-based, extensible to ML):**
```python
activity_patterns = {
    "testing": {
        "keywords": ["write test", "add test", "test coverage", "integration test"],
        "complexity": "simple",
        "model": "haiku"
    },
    "shell_scripting": {
        "keywords": ["shell", "bash", "portability", "sed", "awk"],
        "complexity": "simple",
        "model": "haiku"
    },
    "refactoring": {
        "keywords": ["refactor", "extract", "restructure", "decouple"],
        "complexity": "medium",
        "model": "sonnet"
    },
    "architecture": {
        "keywords": ["architecture", "design", "integrate", "migrate"],
        "complexity": "complex",
        "model": "opus"
    },
    "documentation": {
        "keywords": ["document", "readme", "guide", "example"],
        "complexity": "simple",
        "model": "haiku"
    }
}

def classify_story(story):
    text = f"{story.title} {story.description}".lower()

    # Pattern matching
    for activity, spec in activity_patterns.items():
        if any(kw in text for kw in spec["keywords"]):
            return activity, spec["complexity"], spec["model"]

    # Heuristic fallbacks
    ac_count = len(story.acceptance_criteria)
    if ac_count > 10:
        return "unknown", "complex", "opus"
    elif ac_count < 3:
        return "unknown", "simple", "haiku"
    else:
        return "unknown", "medium", "sonnet"
```

#### 4.2.2 Dependency Graph Construction

**Input:** All stories across all repos
**Output:** Directed acyclic graph (DAG) with blocking relationships

```python
def build_dependency_graph(stories):
    graph = {}

    for story in stories:
        graph[story.id] = {
            "story": story,
            "blockedBy": [],
            "blocks": []
        }

    # Parse explicit dependencies from PRD
    for story in stories:
        if story.dependsOn:
            for dep_id in story.dependsOn:
                graph[story.id]["blockedBy"].append(dep_id)
                graph[dep_id]["blocks"].append(story.id)

    # Detect implicit dependencies (heuristic)
    # E.g., if Story A creates schema, Story B uses schema → A blocks B
    detect_implicit_dependencies(graph)

    # Validate DAG (no cycles)
    assert is_dag(graph), "Circular dependency detected"

    return graph
```

#### 4.2.3 Priority Scoring

**Input:** Story + dependency graph + activity type
**Output:** Priority score (higher = schedule sooner)

```python
def calculate_priority_score(story, graph, activity):
    score = 0

    # Factor 1: Dependency weight (how many stories does this unblock?)
    downstream_count = count_transitive_blocks(story.id, graph)
    score += downstream_count * 10  # High weight

    # Factor 2: Activity batching potential
    similar_stories = count_similar_activity(story, all_stories)
    score += min(similar_stories, 5) * 3  # Diminishing returns after 5

    # Factor 3: Cross-repo pattern (applies to multiple repos?)
    if is_cross_repo_pattern(story):
        score += 8

    # Factor 4: Complexity (simple tasks score higher for quick wins)
    complexity_bonus = {"simple": 5, "medium": 2, "complex": 0}
    score += complexity_bonus.get(story.complexity, 0)

    # Factor 5: Age (older stories get slight boost)
    days_old = (datetime.now() - story.created_date).days
    score += min(days_old * 0.1, 5)  # Cap at 5 points

    return score
```

#### 4.2.4 Batch Optimization

**Input:** Ranked stories, session constraints (5hr, 900 msgs, cost budget)
**Output:** Optimized batch schedule

```python
def optimize_batches(stories, window_hours=5, message_budget=900, cost_budget=100):
    """
    Knapsack-style optimization with multiple constraints
    """
    batches = []
    remaining_time = window_hours * 60  # minutes
    remaining_messages = message_budget
    remaining_cost = cost_budget

    # Group by activity type
    activity_groups = group_by_activity(stories)

    for activity, group_stories in activity_groups.items():
        # Estimate resources for this batch
        estimated_time = estimate_batch_time(group_stories)
        estimated_messages = estimate_batch_messages(group_stories)
        estimated_cost = estimate_batch_cost(group_stories)

        # Check constraints
        if (estimated_time <= remaining_time and
            estimated_messages <= remaining_messages and
            estimated_cost <= remaining_cost):

            batches.append({
                "activity": activity,
                "stories": group_stories,
                "model": group_stories[0].suggested_model,
                "time": estimated_time,
                "messages": estimated_messages,
                "cost": estimated_cost
            })

            remaining_time -= estimated_time
            remaining_messages -= estimated_messages
            remaining_cost -= estimated_cost

    return batches
```

### 4.3 Execution Model

**Batch execution flow:**
1. Schedule selects next batch (e.g., "All testing stories, use Haiku")
2. Context builder loads shared context ONCE (testing patterns, standards)
3. Execute all stories in batch with same model
4. Commit to all affected repos simultaneously
5. Update dependency graph (mark completed stories, unblock downstream)
6. Repeat until session limit or queue empty

**Cross-repo commit strategy:**
```bash
# After batch completes
for repo in affected_repos:
    cd $repo
    git add .
    git commit -m "chore: complete testing batch (Stories: A/US-001, B/US-003, C/US-005)"
done
```

---

## 5. Evaluation Methodology

### 5.1 Experimental Design

**Comparison:** Activity-based scheduling vs. Sequential PRD execution

**Setup:**
- 5 production repositories (fade, livecalc, assumptionsmanager, ai-actuarial-model, fade-prd-generator)
- Controlled PRD set: 20 PRDs, ~60 user stories total
- Balanced distribution: 30% testing, 25% refactoring, 20% shell scripting, 15% architecture, 10% documentation

**Procedure:**
1. **Baseline (Sequential):** Process PRDs one-at-a-time in queue order, record metrics
2. **Treatment (Activity-based):** Enable scheduler, process via batching, record metrics
3. **Within-subjects design:** Alternate weeks between baseline and treatment to control for learning effects

### 5.2 Metrics

**Primary metrics (RQ1: Throughput):**
- Stories completed per 5-hour session
- Time to complete all 60 stories
- Session utilization (% of 900-message budget used)

**Secondary metrics (RQ2: Dependencies):**
- Critical path duration (time until all dependencies satisfied)
- Blocking events (count of times work stopped waiting for dependencies)
- Dependency satisfaction rate (% of blockers resolved on time)

**Cost metrics (RQ3: Model selection):**
- Total API cost (estimated from token usage)
- Model usage breakdown (% Haiku, Sonnet, Opus)
- Cost per story completed
- Cost per repo updated

**Quality metrics:**
- Test pass rate (regression tests after completion)
- Rework rate (stories requiring fixes after initial completion)
- Commit revert rate (changes rolled back)

**Pattern reuse metrics (RQ4: Cross-repo learning):**
- Cross-repo pattern detection events (e.g., "same bug in 3 repos")
- Pattern application success rate (did batch fix work across all repos?)
- Learning transfer time (time from first fix to all repos fixed)

**User perception (RQ5: Qualitative):**
- Semi-structured interviews (n=5 developers using FADE)
- Survey: Control, predictability, trust (5-point Likert)
- Think-aloud protocol during PRD planning

### 5.3 Hypotheses

**H1 (Throughput):** Activity-based scheduling completes ≥2x more stories per session than sequential execution.

**H2 (Dependencies):** Activity-based scheduling reduces critical path duration by ≥30% via dependency prioritization.

**H3 (Cost):** Activity-based scheduling reduces API costs by ≥40% via intelligent model selection and batching.

**H4 (Quality):** No significant difference in test pass rate or rework rate (maintains quality while improving efficiency).

**H5 (Pattern reuse):** Cross-repo pattern batching improves fix success rate by ≥50% vs. isolated sequential fixes.

**H6 (User perception):** Users perceive activity-based scheduling as more efficient but potentially less predictable than sequential execution.

### 5.4 Threats to Validity

**Internal validity:**
- Learning effects: Mitigate via within-subjects design with counterbalancing
- API variability: Claude performance varies; control via same time-of-day testing
- PRD quality differences: Use curated PRD set with balanced complexity

**External validity:**
- Generalizability: 5 repos in one organization; need broader deployment
- Task diversity: Current focus on web apps; validate on embedded, mobile, data science
- Team size: Single developer; unclear if scales to multi-developer teams

**Construct validity:**
- "Activity type" classification subjective; validate with inter-rater reliability study
- "Pattern detection" heuristic may miss nuanced similarities; needs human validation

**Conclusion validity:**
- Small sample size (60 stories); power analysis suggests need 100+ for strong claims
- Multiple comparisons: Apply Bonferroni correction for significance testing

---

## 6. Expected Contributions

### 6.1 Scientific Contributions

**C1: Novel optimization problem formulation**
- First formal definition of multi-repository agentic scheduling under API session constraints
- Extends classical job-shop scheduling with AI-specific constraints (context cost, model heterogeneity)

**C2: Activity-based batching algorithm**
- Demonstrated improvement over sequential execution
- Open-source reference implementation
- Reusable for other agentic systems (not FADE-specific)

**C3: Empirical validation of cross-repo intelligence**
- First measurement of pattern reuse across repositories in autonomous development
- Quantifies value of multi-repo context vs. single-repo isolation

**C4: API economics analysis**
- First study of developer cost optimization strategies for LLM-based coding assistants
- Informs API pricing and product design at AI companies

### 6.2 Practical Contributions

**P1: Production-ready system**
- Deployable FADE extension (open-source, MIT license)
- Used in 5 real-world repos with 21 shipped features
- Replicable by other organizations

**P2: Decision-making guidance**
- When to use activity-based vs. sequential scheduling?
- ROI analysis: Cost of building scheduler vs. efficiency gains
- Operational playbook for multi-repo autonomous development

**P3: Tool for researchers**
- FADE as research platform for agentic software engineering experiments
- Extensible architecture for testing new scheduling heuristics
- Dataset: 60 PRDs, 807 commits, execution traces for future research

---

## 7. Industry Impact Analysis

### 7.1 Immediate Impact: Developer Productivity Tools

**Anthropic (Claude API/Max Plan):**
- **Opportunity:** Showcase real-world ROI of Max plan ($200/month)
- **Potential collaboration:** Joint research, co-marketing, API design feedback
- **Impact timeline:** 6-12 months (case study, blog post, conference presentation)

**GitHub (Copilot Workspace):**
- **Gap:** Currently single-repo, no cross-project scheduling
- **Adoption path:** Integrate activity-based scheduling into Copilot Workspace roadmap
- **Impact timeline:** 12-18 months (product team evaluation, pilot integration)

**Cursor / Windsurf:**
- **Gap:** IDE-bound, single active context
- **Adoption path:** Multi-repo workspace with intelligent batching
- **Impact timeline:** 6-12 months (fast-moving startups, quick integration)

### 7.2 Medium-Term Impact: Enterprise Development

**Large organizations (Google, Meta, Amazon, Microsoft):**
- Manage 1000+ repositories
- Cross-repo pattern detection = massive value (bug fixes, security patches)
- Dependency management already critical pain point

**Potential use cases:**
- Security patch rollout: Detect vulnerable pattern in 1 repo, auto-fix across 100 repos
- Dependency upgrades: Batch all "upgrade React 17→18" stories across microservices
- Testing standardization: Batch all "add integration tests" work across portfolio

**Impact timeline:** 18-24 months (enterprise sales cycles, security reviews)

### 7.3 Long-Term Impact: AI-Native Software Development

**Paradigm shift: From human-centric to AI-centric project management**

**Current (human-centric):**
- Sprints: 2-week time boxes aligned with human meeting cadence
- Epics/Features: Organized by business value for human stakeholders
- Story points: Estimated based on human effort and context switching cost

**Future (AI-centric):**
- Sessions: 5-hour windows aligned with API limits
- Activity batches: Organized by AI context efficiency and model capability
- Message budgets: Estimated based on API cost and throughput optimization

**Implications:**
- Engineering management tools redesigned for agentic workflows
- New roles: "AI Workflow Architect" optimizing activity batching
- Training: Developers learn to write "AI-friendly PRDs" optimized for batching

**Impact timeline:** 3-5 years (cultural shift, education, tool ecosystem maturation)

---

## 8. Competitive Landscape Analysis

### 8.1 Current State of Competition (January 2026)

**Tier 1: Commercial Leaders (Well-Funded, Shipping Products)**

| Company | Product | Multi-Repo | Activity Batching | AI-Native Scheduling | Gap Analysis |
|---------|---------|-----------|------------------|---------------------|--------------|
| **GitHub (Microsoft)** | Copilot Workspace | ❌ | ❌ | ❌ | Single-repo only. Roadmap likely includes multi-repo but no public timeline. 12-18mo behind. |
| **Cognition Labs** | Devin | ❌ | ❌ | ❌ | Task-at-a-time execution. No public plans for portfolio scheduling. 18-24mo behind. |
| **Cursor** | Cursor IDE | ❌ | ❌ | ❌ | IDE-bound, single workspace. Fast-moving startup could add multi-repo but need different architecture. 12mo behind. |
| **Poolside** | AI Developer | ❌ | ❌ | ❌ | Stealth mode, limited public info. Likely focused on single-repo completion. 18mo+ behind. |

**Tier 2: Research Systems (Academic/Open Source)**

| System | Institution | Multi-Repo | Activity Batching | AI-Native Scheduling | Gap Analysis |
|--------|-------------|-----------|------------------|---------------------|--------------|
| **SWE-agent** | Princeton | ❌ | ❌ | ❌ | Benchmark-focused, single-repo tasks. No multi-repo in research roadmap. 24mo+ behind. |
| **AutoGen** | Microsoft Research | Manual | ❌ | ❌ | Framework not product. Users could build this but none have publicly. 12-18mo behind if pursued. |
| **MetaGPT** | ICLR 2024 | ❌ | ❌ | ❌ | Role-based agents, not scheduling-focused. Would require significant rearchitecture. 24mo+ behind. |

**Tier 3: Emerging Startups (Stealth/Early Stage)**

- **Magic.dev:** Reported $100M+ funding, building AI coding assistant. No public product yet. Unknown positioning but likely single-repo initially. 12-24mo behind.
- **Factory AI:** Stealth, ex-Stripe/Dropbox founders. Likely enterprise-focused. Unknown if multi-repo is priority. 18mo+ behind.
- **Numerous others:** >20 AI coding assistant startups funded in 2024-2025. Most focused on chat interfaces, not autonomous scheduling.

### 8.2 Competitive Moats

**If you publish this research and ship FADE-Scheduler:**

**Moat 1: First-mover academic credibility**
- First peer-reviewed publication on AI-native multi-repo scheduling
- Establishes terminology, problem formulation, evaluation methodology
- Competitors must cite your work, reinforcing your thought leadership

**Moat 2: Production validation**
- 5 real-world repositories, 60+ stories, empirical data
- GitHub/Cursor can build similar features but lack validation data
- You have 12-18 month head start on operational learnings

**Moat 3: Open-source reference implementation**
- FADE is MIT licensed, forkable, extensible
- Community adoption creates ecosystem lock-in
- Competitors must build from scratch or fork (and credit you)

**Moat 4: Anthropic partnership potential**
- If Anthropic collaborates (joint paper, API access, co-marketing)
- Gives you access to usage data, pre-release API features
- Competitors can't replicate this relationship advantage

**Moat 5: Research velocity**
- Academic colleagues accelerate iteration (PhD students, grants)
- Can publish follow-up papers (CHI on UX, ICSE on scaling, FSE on quality)
- Competitors focused on product shipping, not research depth

### 8.3 Risk: How Quickly Could Competitors Catch Up?

**Optimistic scenario (You maintain lead):**
- Publish at ICSE 2027 (Sept 2026 deadline)
- GitHub reads paper, evaluates approach (6 months)
- GitHub decides to integrate, assigns team (3 months)
- GitHub builds MVP (6 months)
- GitHub ships beta (3 months)
- **Timeline: 18 months from your publication to GitHub shipping**
- You have 2+ years lead if you start now

**Pessimistic scenario (Fast follower):**
- Cursor reads paper, recognizes value (1 month)
- Cursor pivots roadmap (fast startup, 1 week)
- Cursor builds prototype (3 months)
- Cursor ships beta (1 month)
- **Timeline: 5-6 months from your publication to Cursor shipping**
- You have 12-15 months lead if you start now

**Mitigation strategies:**
- Patent core algorithm (provisional patent before publication)
- Build network effects via open source (FADE community)
- Continuous research innovation (publish yearly improvements)
- Enterprise partnerships (lock in customers with integrations)

---

## 9. Validation Plan: What We've Proved vs. What We Need to Prove

### 9.1 Already Validated ✅

**Production system maturity:**
- ✅ FADE executes PRDs autonomously (21 completed features)
- ✅ Overnight YOLO mode works reliably (runs 01:30-07:00 unattended)
- ✅ Multi-model support exists (Opus/Sonnet/Haiku callable)
- ✅ Test-driven development works (generates tests, runs regressions)
- ✅ Self-healing works (shell portability auto-fix shipped)
- ✅ 5-repo deployment (fade, livecalc, assumptionsmanager, ai-actuarial-model, prd-generator)

**Data availability:**
- ✅ 807 git commits (real code changes, not toy examples)
- ✅ User story execution times (logged in progress.md)
- ✅ Test results (pass/fail, healing events)
- ✅ Cost data (model usage, rough token estimates)

**Technical feasibility:**
- ✅ Can parse PRDs from multiple repos
- ✅ Can invoke Claude Code programmatically
- ✅ Can commit to multiple repos in single session
- ✅ Can classify activities (keyword-based heuristics work)

### 9.2 Needs Validation 🔬

**Scheduler effectiveness (RQ1):**
- ❓ Does batching improve throughput? (Need A/B test)
- ❓ What's the actual speedup? (Need controlled experiment)
- ❓ Does it work across different repo types? (Need diverse dataset)

**Dependency management (RQ2):**
- ❓ Can we detect implicit dependencies? (Heuristics TBD)
- ❓ Does prioritization reduce blocking? (Need measurement)
- ❓ False positive rate for dependency detection? (Need accuracy metrics)

**Cost optimization (RQ3):**
- ❓ Accuracy of model-to-task matching? (Haiku for simple tasks—does it actually work?)
- ❓ Quality-cost tradeoff? (Does Haiku produce worse code than Sonnet?)
- ❓ Actual cost savings? (Need billing data from real runs)

**Pattern reuse (RQ4):**
- ❓ How often do cross-repo patterns occur? (Need frequency analysis)
- ❓ Success rate of batch fixes? (Do fixes transfer reliably?)
- ❓ False positive rate for pattern detection? (Do we batch things that shouldn't be batched?)

**User experience (RQ5):**
- ❓ Do users trust activity-based scheduling? (Need interviews)
- ❓ Loss of control acceptable? (Need surveys)
- ❓ Debugging harder when batched? (Need usability study)

### 9.3 Research Timeline

**Phase 1: Build (Months 1-3)**
- Month 1: Implement activity classifier and dependency analyzer
- Month 2: Implement priority scorer and batch optimizer
- Month 3: Integrate into FADE, add logging/instrumentation

**Phase 2: Validate (Months 4-6)**
- Month 4: Controlled A/B testing (sequential vs. batched)
- Month 5: Collect empirical data across 60 stories
- Month 6: User interviews and surveys (n=5-10 developers)

**Phase 3: Analyze (Months 7-8)**
- Month 7: Statistical analysis, hypothesis testing
- Month 8: Qualitative coding of interviews, identify themes

**Phase 4: Write (Months 9-10)**
- Month 9: Draft paper (intro, related work, method, results)
- Month 10: Revisions, polish, submission preparation

**Phase 5: Submit & Present (Months 11-12)**
- Month 11: Submit to ICSE 2027 (deadline ~Sept 2026)
- Month 12: Blog posts, preprint, community release

**Total: 12 months from start to submission**

---

## 10. Academic Collaboration Model

### 10.1 Roles & Responsibilities

**Industry Partner (You):**
- System architecture and implementation
- Production deployment and data collection
- Real-world validation and case studies
- Co-author on paper (first author)

**Academic Partner (Your Colleagues):**
- Research design and methodology
- Statistical analysis and evaluation
- User studies and qualitative analysis
- Co-author on paper (second/third author)

**Potential Additional Collaborators:**
- Anthropic Research (if interested): API usage data, co-marketing
- PhD students: Implementation support, paper writing, experiments
- Industry practitioners: External validation (deploy FADE in their orgs)

### 10.2 Intellectual Property

**Open source commitment:**
- FADE remains MIT licensed (no patent restrictions on implementation)
- Algorithm published openly (reproducible science)

**Patent strategy (optional):**
- File provisional patent on core scheduling algorithm (defensive)
- Public disclosure via paper = prior art (prevents others from patenting)
- Allows commercial licensing if startup path pursued

**Data sharing:**
- Anonymized PRDs, execution logs, git histories shared as research dataset
- Enables replication studies and follow-up research

### 10.3 Publication Strategy

**Primary venue: ICSE 2027 Experience Reports**
- Deadline: ~September 2026
- Acceptance rate: ~25% (competitive but achievable)
- Audience: Software engineering researchers + practitioners
- Format: 8-10 pages, emphasize real-world impact

**Backup venues (if ICSE rejects):**
- FSE 2027 (Foundations of Software Engineering)
- ASE 2027 (Automated Software Engineering)
- CHI 2027 (Human-AI Collaboration track)

**Follow-up publications:**
- Short paper: Activity classification heuristics (MSR 2027)
- Tool demo: FADE-Scheduler walkthrough (ICSE 2028 Demo Track)
- Journal extension: IEEE TSE (detailed empirical study)

---

## 11. Success Criteria

### 11.1 Research Success

**Minimum viable outcome:**
- Demonstrate >50% throughput improvement over baseline
- Publish paper at top-tier conference (ICSE, FSE, or ASE)
- Open-source FADE-Scheduler with community adoption (>100 GitHub stars)

**Strong outcome:**
- Demonstrate >2x throughput improvement, 40%+ cost reduction
- Publish at ICSE with industry recognition (best paper nomination)
- Anthropic partnership or case study
- 5+ organizations deploy FADE in production

**Home run outcome:**
- Demonstrate 3-5x throughput improvement, 60%+ cost reduction
- ICSE best paper award
- GitHub/Anthropic integrate ideas into products
- Spinout startup or acquisition interest

### 11.2 Industry Impact Success

**12 months:**
- 10+ organizations using FADE-Scheduler
- Cited by GitHub Copilot team in roadmap discussions
- Speaking invitations at developer conferences (QCon, StrangeLoop)

**24 months:**
- Activity-based scheduling becomes standard practice
- Competitors ship similar features (validates market)
- Academic citations (>10 papers building on your work)

**36 months:**
- Established as thought leader in agentic development
- Consulting opportunities with AI companies
- Follow-up research grants or industry partnerships

---

## 12. Call to Action for Academic Colleagues

### 12.1 Why This Collaboration Matters

**For your academic career:**
- High-impact publication at top venue (ICSE)
- Novel research area (AI-native software development)
- Real-world validation (not toy benchmarks)
- Industry collaboration (Anthropic, GitHub)
- Follow-up research opportunities (3-5 years of papers)

**For the field:**
- Establishes new research direction (AI-centric project management)
- Open-source artifact for community (FADE as research platform)
- Empirical data for future studies (dataset contribution)
- Bridges research and practice (production system, not prototype)

**For industry:**
- Accelerates adoption of autonomous development
- Informs product design at AI companies
- Potential for real-world impact (developer productivity)

### 12.2 What We Need from Collaboration

**Research design:**
- Experimental methodology (A/B testing, control variables)
- Statistical analysis plan (power analysis, significance testing)
- IRB approval for user studies (interviews, surveys)

**Evaluation expertise:**
- Quantitative analysis (regression, ANOVA, effect sizes)
- Qualitative analysis (thematic coding, interview protocols)
- Threats to validity assessment

**Writing support:**
- Paper structure and argumentation
- Related work survey (ensure we cover all relevant literature)
- Revisions based on reviewer feedback

**Student support (if applicable):**
- MS/PhD students for implementation help
- Undergraduate research assistants for data collection
- Co-authorship for substantial contributions

### 12.3 Time Commitment

**Estimated effort:**
- Initial meetings: 4-8 hours (scope, design, timeline)
- Monthly check-ins: 2 hours/month × 12 months = 24 hours
- Data analysis: 20-40 hours (months 7-8)
- Paper writing: 40-80 hours (months 9-10)
- **Total: 100-150 hours over 12 months**

**Milestones:**
- Month 3: Research design finalized
- Month 6: Data collection complete
- Month 8: Analysis complete, results known
- Month 10: Paper draft complete
- Month 11: Submission to ICSE 2027

---

## 13. Conclusion

**Summary:**
We propose research into activity-based scheduling for multi-repository agentic software development—a novel approach that optimizes autonomous AI work by batching similar activities, respecting dependency constraints, and maximizing value within API session limits.

**What's novel:**
First system to optimize for AI session economics (5-hour windows, message budgets, cost minimization) rather than traditional human project boundaries. No competitor addresses cross-repository pattern batching or activity-type scheduling.

**What's proven:**
Production system (FADE) with 5 repos, 21 shipped features, 807 commits. Autonomous overnight execution, test-driven development, self-healing already validated.

**What we need to prove:**
Does activity-based batching improve throughput (RQ1)? Does dependency prioritization reduce blocking (RQ2)? Does model selection reduce costs (RQ3)? Do cross-repo patterns enable knowledge transfer (RQ4)?

**Expected impact:**
Academic: Top-tier publication (ICSE), novel research direction, 3-5 years of follow-up work.
Industry: Influences GitHub/Anthropic roadmaps, spawns new productivity tools, establishes AI-native project management paradigm.

**Timeline:**
12 months from start to ICSE 2027 submission (Sept 2026 deadline).

**Call to action:**
Partner with us to design experiments, analyze data, and write the paper that defines AI-native software development for the next decade.

---

## Appendix A: Preliminary Data (From Existing FADE Deployment)

### A.1 PRD Completion Statistics

**From progress.md analysis (21 completed PRDs):**
- Average stories per PRD: 4.2 (range: 2-11)
- Average completion time per story: ~18 minutes (varies widely)
- Test generation success rate: ~85% (some PRDs have incomplete tests)
- Healing events: 4 auto-fixes in FEAT-012 (shell portability)

**PRD type distribution:**
- FEAT (features): 9 PRDs (43%)
- BUG (bugs): 6 PRDs (29%)
- ENH (enhancements): 4 PRDs (19%)
- CHORE (chores): 1 PRD (5%)
- SPIKE (spikes): 1 PRD (5%)

### A.2 Repository Profiles

| Repo | Language | LoC | PRDs Completed | Primary Focus |
|------|----------|-----|----------------|---------------|
| fade | Bash | 8,899 | 15 | Framework development |
| livecalc | JavaScript | ~5,000 | 3 | Web app (actuarial) |
| assumptionsmanager | Svelte | ~3,000 | 2 | Version control (actuarial) |
| ai-actuarial-model | HTML/JS | ~2,000 | 1 | Educational tool |
| fade-prd-generator | TypeScript | ~1,500 | 0 | PRD creation assistant |

### A.3 Activity Type Frequencies (Manual Classification of 60 Stories)

**Estimated from PRD review:**
- Testing: 18 stories (30%)
- Refactoring: 15 stories (25%)
- Shell scripting: 12 stories (20%)
- Architecture: 9 stories (15%)
- Documentation: 6 stories (10%)

**Cross-repo patterns identified:**
- Shell portability (head -n -1): 3 repos affected
- Test generation patterns: All repos need tests
- Documentation updates: 4 repos have README gaps

### A.4 Cost Estimates (Rough)

**Model usage (manual selection, current state):**
- Sonnet: ~90% of stories (default)
- Opus: ~8% of stories (complex architecture)
- Haiku: ~2% of stories (simple docs)

**Estimated costs (based on 60 stories, ~4M tokens total):**
- Current approach (mostly Sonnet): ~$60-80
- Optimal batching (estimated): ~$25-35 (60% reduction)

---

## Appendix B: Sample PRD for Illustration

```json
{
  "type": "enhancement",
  "project": "FADE",
  "id": "ENH-014",
  "name": "Complexity-Based Model Selection",
  "description": "Implements intelligent model selection based on PRD complexity, automatically routing simple work to Haiku, complex work to Opus, and balanced work to Sonnet.",
  "dependsOn": [],
  "userStories": [
    {
      "id": "US-001",
      "title": "Add complexity field to PRD schema",
      "description": "As a FADE user, I want to specify PRD complexity so intelligent routing can select the right model.",
      "acceptanceCriteria": [
        "Add optional 'complexity' field to PRD JSON schema (values: 'simple', 'medium', 'complex')",
        "If missing, defaults to 'medium' (current behavior preserved)",
        "fade new --complexity=simple creates PRD with complexity field"
      ],
      "priority": 1,
      "passes": false,
      "activity_type": "schema_change",
      "estimated_duration": 30,
      "suggested_model": "haiku"
    }
  ]
}
```

---

**Document prepared for:** Academic collaboration pitch
**Version:** 1.0
**Date:** January 25, 2026
**Contact:** [Your details]
**Next steps:** Schedule meeting to discuss research design and collaboration model
