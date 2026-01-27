# Activity-Based Multi-Repository Scheduling for Agentic Software Development

**Executive Summary for Academic Collaboration**

---

## The Opportunity: A Novel Research Direction

We're proposing research into **AI-native project management**—specifically, how to optimize autonomous AI work across multiple software repositories by scheduling based on activity types and API session constraints rather than traditional human project boundaries.

**Why this matters:** Every major AI coding assistant (GitHub Copilot, Devin, Cursor) processes work sequentially within single repositories. None optimize for the fundamental constraints of LLM APIs: 5-hour session windows, message budgets, and heterogeneous model costs. This is a **first-mover research opportunity** with clear paths to top-tier publication (ICSE, FSE) and industry impact (Anthropic, GitHub).

**What we have:** A production system (FADE) deployed across 5 repositories with 21 shipped features, 807 commits, and proven autonomous overnight execution. This isn't a prototype—it's a real system processing real work with measurable outcomes.

**What we need:** Academic partners to design controlled experiments, analyze empirical data, conduct user studies, and co-author a research paper targeting ICSE 2027 (submission deadline: September 2026).

---

## The Research Problem

### Current State: Sequential, Single-Repo Execution

**How autonomous coding tools work today:**
```
Repository A: Complete Feature-001 (6 tasks) → 3 hours
Repository B: Complete Feature-002 (8 tasks) → 4 hours
Repository C: Complete Feature-003 (4 tasks) → 2 hours

Total: 9 hours sequential, zero knowledge transfer
```

**Problems with this approach:**
1. **Inefficient context switching:** AI writes tests, then fixes bugs, then writes tests again (different mental models interleaved)
2. **Dependency blocking:** Repo B needs schema from Repo A/Task-3 but waits for all of Repo A to complete
3. **No pattern reuse:** Same shell script bug fixed in 3 repos over 3 weeks, zero learning transfer
4. **Suboptimal model selection:** User guesses whether task needs expensive Opus ($75/M tokens) vs. cheap Haiku ($1.25/M tokens)
5. **Poor session utilization:** Hit 5-hour API limits mid-feature, waste remaining capacity

### Proposed Solution: Activity-Based Batching Across Repositories

**How intelligent scheduling could work:**
```
Session 1 (45min, Haiku): Batch all "write tests" tasks
  → Repo A/Task-3, Repo B/Task-5, Repo C/Task-6
  → Same mental model, cheap model, pattern reuse
  → Cost: $1.50 vs. $15 (10x cheaper)

Session 2 (90min, Sonnet): Batch all "refactor code" tasks
  → Repo A/Task-1, Repo B/Task-2
  → Medium complexity, balanced cost/capability

Session 3 (2hr, Opus): Critical blocking work
  → Repo A/Task-4 (unblocks 5 downstream tasks across repos)
  → High-value, strategic use of expensive model

Total: 4 hours batched, 80% cost reduction, unblocks work early
```

**Novel contributions:**
- **First AI-native scheduling:** Optimizes for API session constraints (5-hour windows, message budgets, model pricing)
- **Cross-repo intelligence:** Detects patterns across repositories ("shell bug in 3 repos → fix together")
- **Activity-type classification:** Groups similar work for context efficiency ("batch all testing tasks")
- **Dependency-aware prioritization:** Schedules work that unblocks others first

---

## Research Questions & Hypotheses

**RQ1 (Throughput):** Can activity-based batching improve completion rates vs. sequential execution?
- **H1:** Activity-based scheduling completes ≥2x more tasks per 5-hour session than sequential execution

**RQ2 (Dependencies):** Can intelligent prioritization reduce blocking time?
- **H2:** Activity-based scheduling reduces critical path duration by ≥30% via dependency prioritization

**RQ3 (Cost Optimization):** Can automatic model selection reduce API costs while maintaining quality?
- **H3:** Activity-based scheduling reduces API costs by ≥40% via intelligent model routing
- **H4:** No significant difference in code quality (test pass rate, rework rate)

**RQ4 (Pattern Reuse):** Do cross-repo patterns enable knowledge transfer?
- **H5:** Cross-repo pattern batching improves fix success rate by ≥50% vs. isolated sequential fixes

**RQ5 (User Experience):** How do developers perceive activity-based scheduling?
- **H6:** Users perceive activity-based scheduling as more efficient but potentially less predictable

---

## What's Already Validated (Production System)

**FADE (Framework for Agentic Development)** is a production system with:

**Deployment scale:**
- 5 active repositories (fade, livecalc, assumptionsmanager, ai-built-actuarial-model, fade-prd-generator)
- 21 completed feature releases (bugs, enhancements, refactorings)
- 807 git commits over 4 weeks of development
- Autonomous overnight execution (YOLO mode: runs 01:30-07:00 unattended)

**Validated capabilities:**
- ✅ Autonomous test-driven development (generates tests, runs regressions, commits fixes)
- ✅ Self-healing (detects shell portability errors, applies fixes, retries tests—shipped in FEAT-012)
- ✅ Multi-model support (can invoke Claude Opus/Sonnet/Haiku via API)
- ✅ Safe execution (directory constraints, backup files, audit logging in healing-log.md)
- ✅ Real-world code generation (not toy examples: bash scripts, web apps, documentation)

**Available empirical data:**
- Execution traces: User story completion times logged in progress.md
- Test results: Regression test pass/fail rates, healing event logs
- Git history: 807 commits showing real code changes, not synthetic benchmarks
- Cost estimates: Model usage patterns, rough token consumption

**This foundation means:** We're not building a research prototype from scratch. We have a working system that processes real work. The research is about **optimizing** an already-functional autonomous development pipeline.

---

## What Needs Validation (The Research)

**Phase 1: Build the Scheduler (Months 1-3)**
- Implement activity classifier (keyword-based heuristics: "testing" vs. "refactoring" vs. "architecture")
- Build dependency graph analyzer (parse PRD dependencies, detect implicit blockers)
- Create priority scorer (weight by: unblocks others, batching potential, cross-repo patterns)
- Implement batch optimizer (fit work to 5-hour window, 900-message budget, cost constraints)

**Phase 2: Controlled Experiments (Months 4-6)**
- **A/B testing:** Sequential execution (baseline) vs. Activity-based batching (treatment)
- **Dataset:** 60 user stories across 5 repos, balanced distribution (30% testing, 25% refactoring, 20% shell, 15% architecture, 10% docs)
- **Metrics:** Stories/session, critical path duration, API cost, test pass rate, pattern reuse frequency

**Phase 3: User Studies (Months 7-8)**
- Semi-structured interviews (n=5-10 developers using FADE)
- Surveys: Perceived control, predictability, trust (5-point Likert scales)
- Think-aloud protocol: Observe developers planning PRDs, using scheduler

**Phase 4: Analysis & Writing (Months 9-10)**
- Statistical analysis (ANOVA, regression, effect sizes)
- Qualitative coding (thematic analysis of interviews)
- Paper writing (ICSE format: 8-10 pages)

**Phase 5: Submission (Month 11)**
- Target: ICSE 2027 Experience Reports track (deadline ~September 2026)
- Backup: FSE 2027, ASE 2027, CHI 2027 (Human-AI Collaboration)

---

## Competitive Landscape: 12-18 Month Head Start

| Company/System | Multi-Repo | Activity Batching | Session-Aware | Status | Gap |
|---------------|-----------|------------------|---------------|--------|-----|
| **GitHub Copilot** | ❌ | ❌ | ❌ | Shipping (single-repo) | 12-18mo behind |
| **Devin** | ❌ | ❌ | ❌ | Shipping (task-at-a-time) | 18-24mo behind |
| **Cursor** | ❌ | ❌ | ❌ | Shipping (IDE-bound) | 12mo behind (fast follower risk) |
| **SWE-agent** | ❌ | ❌ | ❌ | Research (benchmark-focused) | 24mo+ behind |
| **MetaGPT** | ❌ | ❌ | ❌ | Research (role-based agents) | 24mo+ behind |
| **FADE-Scheduler** | ✅ | ✅ | ✅ | Proposed (this research) | **First mover** |

**Why they're behind:**
- GitHub Copilot: Product roadmap focused on single-repo improvements, multi-repo not publicly announced
- Devin: Demo-driven, no published research on portfolio optimization
- Cursor: Fast-moving startup, could catch up in 5-6 months (biggest competitive risk)
- Academic systems: Focused on benchmarks (SWE-bench), not real-world multi-repo workflows

**Our moat if we publish first:**
- Academic credibility (first peer-reviewed publication on AI-native scheduling)
- Production validation (empirical data from real system)
- Open-source reference implementation (community adoption, ecosystem lock-in)
- Potential Anthropic partnership (case study, co-marketing, API access)

---

## Expected Contributions & Impact

### Scientific Contributions

**C1: Novel optimization problem**
- First formalization of multi-repository agentic scheduling under API session constraints
- Extends classical job-shop scheduling with AI-specific factors (context cost, model heterogeneity, session boundaries)

**C2: Activity-based batching algorithm**
- Empirically validated improvement over sequential execution
- Open-source reference implementation (reusable beyond FADE)

**C3: Cross-repo pattern reuse**
- First measurement of knowledge transfer across repositories in autonomous development
- Quantifies value of multi-repo context vs. single-repo isolation

**C4: API economics analysis**
- First study of cost optimization strategies for LLM-based coding assistants
- Informs API pricing and product design at AI companies (Anthropic, OpenAI)

### Practical Impact

**Immediate (12 months):**
- Publication at top-tier venue (ICSE/FSE/ASE)
- Open-source tool (FADE-Scheduler) for community adoption
- Case study at Anthropic (shows Max plan ROI: $200/month justified by 5x efficiency)

**Medium-term (24 months):**
- GitHub/Cursor integrate activity-based scheduling into products
- 10+ organizations deploy FADE in production
- Follow-up research (CHI on UX, MSR on patterns, TSE journal extension)

**Long-term (3-5 years):**
- Paradigm shift from human-centric (sprints, epics) to AI-centric (sessions, batches) project management
- New category of "AI workflow optimization tools"
- Academic citations (research community builds on your work)

### Industry Impact Paths

**Anthropic:** Joint research paper, API design feedback, co-marketing (flagship case study)
**GitHub:** Copilot Workspace multi-repo roadmap influenced by published results
**Cursor/Windsurf:** Fast follower integration (validates market, cites your work)
**Enterprise:** Google/Meta/Amazon dev infrastructure teams adopt for 1000+ repo portfolios

---

## Collaboration Model & What We Need

### Your Role (Industry Partner)
- System architecture & implementation (FADE-Scheduler extension)
- Production deployment & data collection (5 repos, 60 stories)
- Real-world validation & case studies
- **First authorship on paper**

### Academic Partner Role
- Research design & methodology (experimental protocols, control variables)
- Statistical analysis (power analysis, hypothesis testing, effect sizes)
- User studies (IRB approval, interview protocols, qualitative coding)
- **Co-authorship on paper (second/third author)**

### Time Commitment (Estimate)
- **Academic partner:** 100-150 hours over 12 months
  - Initial design: 4-8 hours (scope, methodology)
  - Monthly check-ins: 2 hrs/month × 12 = 24 hours
  - Data analysis: 20-40 hours (months 7-8)
  - Paper writing: 40-80 hours (months 9-10)

- **Industry partner (you):** 200-300 hours over 12 months
  - Implementation: 80-120 hours (months 1-3)
  - Experiments: 40-60 hours (months 4-6)
  - Analysis support: 20-40 hours (months 7-8)
  - Paper writing: 60-80 hours (months 9-10)

### Intellectual Property
- **Open source:** FADE remains MIT licensed (no patent restrictions)
- **Defensive patent (optional):** File provisional on core algorithm, publish openly
- **Data sharing:** Anonymized PRDs, execution logs, git histories as research dataset

---

## Success Criteria

### Minimum Viable Outcome
- ✅ Demonstrate >50% throughput improvement over baseline
- ✅ Publish at top-tier conference (ICSE, FSE, or ASE)
- ✅ Open-source FADE-Scheduler with community adoption (>100 GitHub stars)

### Strong Outcome
- ✅ Demonstrate >2x throughput improvement, 40%+ cost reduction
- ✅ Publish at ICSE with industry recognition (best paper nomination)
- ✅ Anthropic partnership or case study
- ✅ 5+ organizations deploy FADE in production

### Home Run Outcome
- ✅ Demonstrate 3-5x throughput, 60%+ cost reduction
- ✅ ICSE best paper award
- ✅ GitHub/Anthropic integrate ideas into products (cited in roadmaps)
- ✅ Spinout startup or acquisition interest

---

## Why This Research Matters Now

**Timing is critical:**
1. **Market explosion:** Autonomous coding tools raised $500M+ in 2024-2025 (Devin, Magic.dev, Factory AI, Poolside)
2. **Research gap:** Academic community focused on single-repo benchmarks (SWE-bench), missing multi-repo reality
3. **Industry need:** Enterprises manage 100+ repos, desperately need portfolio optimization
4. **First-mover advantage:** 12-18 month head start before GitHub ships competing features

**If we don't publish now:**
- Cursor could build this in 5-6 months (fast startup, no research rigor)
- Someone else publishes at ICSE 2027, we lose academic priority
- GitHub ships multi-repo features without citing academic research
- Opportunity to define the field is lost

**If we publish successfully:**
- Establish terminology, evaluation methodology, research agenda
- Position for 3-5 years of follow-up papers (CHI, MSR, TSE)
- Influence $1B+ market (developer productivity tools)
- Potential for spinout, consulting, speaking opportunities

---

## Next Steps

**Immediate:**
1. **Review this proposal** with academic colleagues
2. **Schedule 1-hour kickoff meeting** to discuss research design
3. **Identify potential co-authors** (faculty, PhD students)

**Phase 1 (Months 1-3):**
4. **Finalize research protocol** (experiments, metrics, IRB if needed)
5. **Begin implementation** of FADE-Scheduler (activity classifier, batch optimizer)
6. **Monthly check-ins** to track progress

**Phase 2 (Months 4-6):**
7. **Run controlled experiments** (A/B testing across 60 stories)
8. **Collect empirical data** (logs, metrics, traces)

**Target:**
9. **Submit to ICSE 2027** by September 2026 deadline
10. **Publish open-source release** concurrent with submission

---

## Contact & Resources

**Full research proposal:** 53 pages covering detailed methodology, competitive analysis, algorithms, evaluation plan
- Location: `docs/research-proposal-activity-based-scheduling.md`

**FADE system:** Production code, PRDs, execution logs available for review
- GitHub: github.com/themitchelli/fade
- Documentation: FADE.md, progress.md, healing-log.md

**Questions to discuss:**
- What research methodologies are most compelling for ICSE?
- Do we need IRB approval for user studies?
- Are there existing research grants we could leverage?
- Who should be additional co-authors (students, collaborators)?

---

**Let's define the future of AI-native software development together.**

*This is a first-mover opportunity to establish a new research direction, publish at top venues, and influence billion-dollar industry trends. The production system exists. The empirical data is ready. We just need academic rigor to validate the approach and publish the results.*

**Ready to discuss?**
