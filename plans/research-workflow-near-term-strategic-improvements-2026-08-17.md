# Canonical Research Workflow — Near-Term Strategic Improvements

**Date:** 2026-08-17  
**Revised:** 2026-08-17 after operator feedback  
**Decision horizon:** next ~8 weeks  
**Status:** revised proposal  
**Decision question:** What is the smallest set of canonical Research Workflow (RW) changes that will create the most value during Axcíon's next two months of work without over-engineering the system?

## Executive recommendation

Do **not** implement any of the three source reports wholesale and do not rebuild RW into a general research platform. Build a two-surface canonical RW focused explicitly on **high-volume macro, sector and trend intelligence**:

1. **Strengthen the retrieval foundation first.** Ship a narrow public-source registry for Nordic/European macro, sector structure and dynamics, structural trends, regulation/policy, M&A and private-capital activity. Add reliable source-access behavior and direct Eurostat/Statistics Finland pulls.
2. **Add one very small, consumer-neutral Targeted Research contract.** The abstraction is: `bounded question + scope + authorization + intended use → evidence + interpretation`. The caller owns planning and routing; canonical RW executes the approved scope. Content Programme is the first consumer, not the owner of the interface.
3. **Add a minimum sufficient canonical judgment layer immediately.** Every relevant Targeted output should explain what is happening, why, why it matters, implications for Nordic sectors/M&A/private capital, confidence and counterevidence. Founder authority remains required before an important proposed interpretation becomes an Axcíon House View.
4. **Add lightweight research reuse.** Before material retrieval, search existing Axcíon research, reuse still-valid evidence and retrieve only the gaps. Outputs carry enough metadata to support later discovery. This is a workflow behavior, not a memory platform.
5. **Apply the already-specified path-passing refactor to Deep Research** and preserve its load-bearing evidence controls. Do not disrupt the active Sector Intelligence batch with a broader structural rewrite.
6. **Defer monitoring, paid-data work, API-platform expansion, auto-routing and multi-agent machinery.** None is needed to increase research throughput during the launch period.
7. **Revisit the Deep artifact chain at a safe operating boundary.** Do not treat the current chain as permanent, but do not create a pre-deployment experiment or benchmarking programme. Deploy obvious low-risk improvements, observe real use and correct defects.

The two canonical surfaces are therefore:

- **Targeted Research:** bounded, reusable macro/sector/trend research with evidence and judgment; and
- **Deep Research:** the existing multi-stage report workflow, with stronger retrieval foundations and lower relay cost.

The objective is not merely more evidence. It is a high volume of reliable research whose interpretation is useful to Axcíon and visibly stronger than generic AI research.

## 1. Strategic frame and evidence freshness

### Authority caveat

The user-requested Strategic OS is useful as the last promoted statement of Axcíon's market-entry logic, but it is **dated, not current authority**. Its live strategy was last promoted on 2026-06-15, and a later repository instruction explicitly says `strategic-os` and `management-os` are retired and must not be treated as current sources of truth ([promoted strategy](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/strategy.md:12>); [retirement instruction](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-strategyos/AGENTS.md:45>)).

This proposal uses the promoted June strategy as the requested **strategic frame**, then corroborates near-term demand against live August project artifacts.

The still-useful frame is:

- build intelligence before credibility, service-fit testing and controlled pilots ([strategy sequence](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/strategy.md:12>));
- make the buy-side intelligence base the foundation ([priority P1](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/priorities.md:6>));
- manufacture credibility through strong research and useful market notes ([priority P2](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/priorities.md:10>)); and
- avoid both over-analysis and premature bureaucracy ([live risks](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/risks.md:6>)).

The June strategic review expected August to begin intelligence-building after a June–July preparation period ([review timeline](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:9>); [August launch claim](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:16>)). That timing claim is stale planning, but the August execution projects confirm that intensive sector and launch-intelligence work is now the relevant demand.

### Near-term research demand

| Active demand | What the live evidence says | Capability genuinely needed in the next ~8 weeks | Implication for canonical RW |
|---|---|---|---|
| **Sector Intelligence Phase A** | Ten sector units have been committed; gathering is designed to run across the slate before analysis and reporting are rationed ([batch slate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/phase-a-batch-slate-v1.md:16>); [phased model](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:29>)). | High-throughput evidence retrieval on sector structure, dynamics, demand drivers, regulation, M&A activity and investment relevance; strong interpretation; low relay overhead. | Make macro/sector/trend retrieval and judgment the core near-term optimization target. Do not redesign the active Deep analysis/report chain mid-batch. |
| **Sector execution-tool reality** | The current plan uses Codex as the flat-cost primary gatherer and Perplexity only as supplementary/high-stakes gap-fill; Codex concurrency has passed at ≥10 sessions ([cost model](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:170>); [Gate 6b](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:134>)). | Better source routing, direct-source access, reusable evidence and path-based handoffs for the proven gather path. | A broad Perplexity API runtime is not the first bottleneck. |
| **Launch macro/sector narratives** | A 2026-08-17 Content proposal sequences Finland's economic context → Europe's strategic reconfiguration → sector/company resolution → M&A implications and requires research execution outside the Content repository ([progression](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:113>); [external seam](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:402>)). It remains proposed, not approved authority. | Fast official statistics, policy/regulatory evidence, sector/trend evidence and an evidence-to-interpretation handoff. | Design the canonical Targeted contract around general research needs, then let Content consume it. Do not inherit Content's brief schema. |
| **Content execution seam** | The live editorial workflow already decides READY TO DRAFT, TARGETED RESEARCH or FULL RW and can produce a bounded approved brief ([route gate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:113>); [brief contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:151>)). | A reusable executor for bounded research—not another planning, editorial or routing layer. | Content is a first consumer and test case, not the canonical interface authority. |
| **Overlapping launch themes** | Sector and content work repeatedly touch the same macro conditions, sector structures, transaction evidence and public-source ladders. The Content evidence standard already says to search reusable internal knowledge before external research ([reuse rule](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/evidence-standard.md:126>)). | Prior-research discovery, validity checking and gap-only retrieval. | Make reuse a small canonical pre-retrieval step and make outputs findable through basic metadata. |
| **Website, LinkedIn and company-level work** | The website is in implementation/test closure rather than operating as a research programme ([pipeline state](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/pipeline-state.md:7>)). LinkedIn remains a potential downstream consumer, not a reason to shape the canonical interface now. | No company-level or Buyer Fit research architecture justified in this horizon. | Optimize for macro, sectors and trends. Other needs can use the generic bounded contract later if they qualify. |

### Demand-to-change conclusion

The next eight weeks require three things:

1. **repeatable public-source retrieval** for Nordic/European macro, sectors, trends, regulation and M&A/private-capital activity;
2. **bounded Targeted Research** that turns approved questions into evidence and interpretation; and
3. **efficient Deep work** for the Sector Intelligence batch.

Company-level research and Buyer Fit research may occur, but they do not drive the canonical design. The system also does not yet need monitoring, paid data, an autonomous router, a knowledge graph or a general multi-agent research organization.

## 2. Current canonical RW: preserve the core, fill the real gaps

The canonical template is a five-stage report workflow: Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production, with the artifact chain Task Plan → Research Plan → Answer Specs → Deep Research Reports → Extracts → Cluster Memos → Directives → Prose ([canonical template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md.template:52>)). Stage 3's permission/sufficiency gate constrains subsequent synthesis ([stage instructions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md:81>)).

Its strongest controls remain proportionate for consequential Deep work: source classes, facts before synthesis, claim IDs, permission classes, scarcity records, independent verification and explicit evidence/inference separation. The lean report also identifies these as load-bearing ([lean report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:51>)).

The near-term gaps are narrower and concrete:

- source intelligence still ships mainly as placeholders instead of a strong Nordic/European macro/sector/trend starting registry ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:38>));
- official statistical evidence has no direct structured path ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:32>));
- Perplexity lead handling and scarcity evidence are not canonicalized ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:41>));
- no consumer-neutral Targeted Research executor exists;
- no canonical lightweight reuse behavior exists;
- Targeted outputs have no required analytical judgment contract; and
- Deep still pays a known content-relay token penalty ([lean report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:40>)).

The current Deep artifact chain may ultimately contain unnecessary intermediate transformations. This proposal does **not** declare it permanent. It defers structural simplification until the active Sector batch reaches a safe boundary, and it rejects a formal comparison programme as a prerequisite to obvious improvements.

### Report-provenance limitation

The three improvement documents are dated 2026-08-17 but do not self-identify their model author. Decisions therefore cite document paths rather than inventing model-level attribution:

- [Lean Canonical Research Workflow](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:1>)
- [Judgment, Insight, Depth and Parallel Research Plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:1>)
- [Data Retrieval Layer Improvement Plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:1>)

## 3. Recommendation decision matrix

### Adopt now

| Recommendation | Why it fits the next 8 weeks | Minimum near-term scope |
|---|---|---|
| **A1. Macro/sector/trend retrieval foundation** | It directly serves the Sector batch and likely launch narratives, while improving quality before adding orchestration. | Filled registry covering Nordic/European macro, sector structure/dynamics, trends, regulation/policy, PE/M&A activity and public transaction evidence. Official, statistical, regulatory, association and high-quality free public sources first. No company-research or paid-data track. |
| **A2. Source-access and false-scarcity rules** | False scarcity is a demonstrated failure mode, and batch research multiplies systematic retrieval errors. | Unopened retrieval result = `[LEAD]`, not evidence; no claim ID or coverage movement. Search failure never proves absence. Log URL/source, access state, direct attempt, date and result. Resolve the authoritative domain before scarcity. |
| **A3. Minimal structured-statistics lane** | Macro and sector work repeatedly need official series and NACE structure data. | Eurostat and Statistics Finland first, emitting raw CSV/JSON, table/series identity, retrieval date and source pointer. Add other Nordic providers only when live work requires them. |
| **A4. Consumer-neutral Targeted Research executor** | A bounded execution seam is missing, while callers already know when research is needed. | Accept a small canonical request containing question, scope, authorization and intended use. Return evidence, source/access record, gaps and interpretation. No new planning artifact, queue, deployment profile or auto-router. Adapt caller formats at the edge. |
| **A5. Minimum canonical judgment layer** | Reliable retrieval alone produces generic research. Axcíon's differentiator is disciplined interpretation. | Every relevant output answers: What is happening? Why? Why does it matter? What does it imply for Nordic sectors, M&A or private capital? Confidence? What weakens the interpretation? Mark the result `proposed interpretation`; consequential House Views require founder approval. Do not import the full Unit Judgment Brief machinery by default. |
| **A6. Lightweight research reuse** | Launch themes overlap; repeated rediscovery wastes time and fragments the evidence base. | Before material retrieval, search nominated existing Axcíon research locations, assess relevance/freshness, reuse still-valid sources and retrieve gaps only. Each output records topic, geography, period, retrieval/as-of date, intended use and source references. No vector database, graph or new research-memory service. |
| **A7. Deep path-passing refactor** | Sector's multi-unit batch compounds the known relay/token penalty; the fix is already specified. | Apply only the existing path-passing change and verify output equivalence. Sync to active Sector consumers at a safe boundary; do not bundle QC/gate restructuring. |
| **A8. Preserve Deep evidence controls** | The Deep lane supports consequential sector reports; weakening the controls would create hidden quality risk. | Keep source classes, facts-only extraction, claim IDs, permission classes, sufficiency, scarcity records, evidence/inference separation and independent verification. |

### Defer with explicit trigger

| Recommendation | Disposition and revisit trigger |
|---|---|
| **Full Light/Standard/Deep platform and auto-classification** | Defer. Revisit only if 5–10 real Targeted runs and two Deep units show recurring ownership ambiguity that callers cannot resolve. |
| **Perplexity Agent API relay** | Defer. Sector already uses Codex as primary gatherer. Revisit only if manual Perplexity relay becomes a repeated material bottleneck and required API behavior is proven by execution. |
| **Broad Deep-pipeline simplification** | Defer until the current Sector batch reaches a safe boundary. Then inspect whether Task Plan, Research Plan, Answer Specs, Extracts, Cluster Memos and Directives can be collapsed without weakening evidence, judgment or traceability. Implement sensible units directly; do not require competing workflow variants or a formal benchmark programme. |
| **Full Unit Judgment Brief / House View architecture** | Defer the machinery, **not judgment**. The lean canonical questions ship now. Revisit the larger architecture only if real use shows a need for proposal/approval promotion artifacts, downstream fail-closed enforcement or a shared House View object. |
| **All-Nordic provider and local-language tooling expansion** | Defer until an approved macro/sector/trend brief cannot be answered reliably through the initial official/public routes. Then add the specific missing country/provider, not a platform. |
| **Monitoring systems, watchlists, release calendars and periodic retrieval** | Defer explicitly. Revisit only after recurring operations demonstrate missed releases or repeated rediscovery; none belongs in the immediate build. |

### Reject for this horizon

| Recommendation | Why reject now |
|---|---|
| **Content-specific canonical input contract** | Content is the first consumer, not the owner. Canonical RW must accept the smaller consumer-neutral request contract and use a thin adapter if needed. |
| **A second planning/routing layer inside RW** | Callers own the decision to research and the approved scope. Another router or planning artifact would duplicate authority and ceremony. |
| **Pre-deployment workflow experiments or formal comparison programme** | They delay obvious low-risk improvements. The operating rule is deploy sensible changes quickly, observe real use and correct where necessary. |
| **Paid-data exploration, benchmarking or procurement** | There is no near-term budget. Spend no implementation or investigation time on specialist paid M&A databases or subscriptions during this phase. |
| **General agent swarm, autonomous coordinator or shared agent memory** | Existing Codex concurrency already supports the batch. No named consumer justifies more coordination infrastructure. |
| **Monitoring infrastructure now** | Useful later, but unnecessary for immediate throughput. |
| **Company-level or Buyer Fit optimization as the canonical design center** | These topics may use the generic contract when needed, but macro, sectors and trends are the near-term system mandate. |
| **Universal API-first execution** | Current tools and credentials are heterogeneous. Standardize the research contract, source access and outputs first; automate only proven repetitive seams. |

## 4. Sequenced implementation plan

Impact and urgency use `High / Medium / Low`; effort uses `S` (one bounded session), `M` (roughly 2–4 bounded sessions), `L` (multi-part rollout).

| Order | Change | Impact | Effort | Urgency | Completion evidence |
|---|---|---:|---:|---:|---|
| **1** | Ship the macro/sector/trend public-source registry, Perplexity-lead/scarcity rule, Source Access Log and domain precheck. | High | M | **Now** | One macro query and one sector/trend query route to named first-party sources before general search; unopened leads cannot support claims; failed direct attempts are recorded. |
| **2** | Add Eurostat and Statistics Finland structured pulls. | High | M | **Now** | One reproducible table/series from each provider includes raw data, identity, retrieval date and source pointer. |
| **3** | Build the lean consumer-neutral Targeted Research executor. | High | M | **Now** | A generic authorized request runs without importing caller planning logic; out-of-scope or unauthorized requests stop; output contains evidence, access record, gaps and interpretation. |
| **4** | Implement the minimum canonical judgment layer in Targeted outputs. | High | S–M | **Now** | Output answers the six analytical questions, separates evidence from interpretation, states confidence/counterevidence and cannot become an approved House View without founder authority. |
| **5** | Add lightweight reuse discovery and metadata. | High efficiency | S–M | **Now** | A run locates relevant prior research, records what was reused and why still valid, then retrieves only named gaps. A later search can find the output by topic/geography/period/date. |
| **6** | Implement and verify Deep content-relay → path-passing. | High cost reduction | M | Before heavy Sector Stage 3/4 work | Representative output is unchanged in substance; affected command tests pass; main-session relay falls. |

### Implementation rules

- Implement the sequence as small deployable units; do not wait for a parallel-variant test.
- Use real work as the operating proof. Observe, log defects and correct them.
- Keep judgment generation immediate, but keep founder approval explicit for consequential House Views.
- Do not add a new reusable artifact unless an existing file or a small output section cannot carry the required information.
- Do not add a source, provider or integration without a named macro/sector/trend use case.

### Eight-week operating sequence

- **Week 1:** land orders 1–2 and validate them on real macro/sector questions.
- **Weeks 1–2:** define the tiny canonical request/output contract and build order 3.
- **Week 2:** add order 4 to the same Targeted output path; do not create a separate judgment workflow.
- **Weeks 2–3:** add order 5 using existing repository search and metadata—no indexing service.
- **Weeks 2–4:** land order 6 and sync active Sector consumers only at a safe boundary.
- **Weeks 4–8:** operate at volume; fix observed defects. Record Deep-chain simplification candidates without opening the larger refactor during Sector Phase A.

## 5. Target-state canonical RW after these changes

```text
CALLING PROJECT OWNS NEED, SCOPE AND AUTHORIZATION
    |
    |-- bounded canonical request --------------------------+
    |   question | scope | authorization | intended use    |
    |                                                       |
    |                                               TARGETED RESEARCH
    |                                               1. validate request
    |                                               2. find prior Axcíon research
    |                                               3. reuse valid evidence
    |                                               4. identify retrieval gaps
    |                                               5. source-registry routing
    |                                               6. direct/public retrieval
    |                                               7. structured stats if needed
    |                                               8. evidence + access record
    |                                               9. judgment + counterevidence
    |                                                       |
    |<-------------- evidence and proposed interpretation --+
    |
    |-- multi-unit / thesis / report brief ----------------+
                                                            |
                                                      DEEP RESEARCH
                                                      current evidence controls
                                                      shared retrieval foundation
                                                      reuse before new retrieval
                                                      path-based handoffs
                                                      existing stages for now
```

### Canonical Targeted request

The request is the smallest stable contract that can be expressed in an existing brief or invocation:

1. bounded research question(s);
2. scope and exclusions;
3. explicit authorization to execute;
4. intended use and consequence level; and
5. optional required geography/time period or named existing research locations.

It is **not** a new mandatory planning document. A caller's approved brief can supply these fields through an adapter or direct mapping.

### Canonical Targeted output

The output contains:

1. request identity, scope and authorization status;
2. reuse record: prior research found, relevance/freshness decision, evidence reused and remaining gaps;
3. answer/evidence by approved question;
4. evidence table: finding → opened direct source → source class → retrieval/as-of date → permitted wording;
5. facts / interpretation / inference separation;
6. analytical judgment:
   - What is happening?
   - Why is it happening?
   - Why does it matter?
   - What does it imply for Nordic sectors, M&A or private capital?
   - How confident are we?
   - What challenges or weakens this interpretation?
7. named gaps and direct attempts;
8. Source Access Log; and
9. discovery metadata: topic, geography, time period, retrieval/as-of date, intended use and source references.

The judgment is labelled **proposed interpretation** until the relevant founder/consumer authority approves it. Judgment generation is mandatory where the request concerns material macro, sector, trend, regulation or M&A implications; creating a separate House View artifact is not.

The Deep lane retains its current stages for now. The target is not to preserve every intermediate artifact forever—it is to avoid destabilizing the active batch while immediately improving retrieval, reuse, judgment and relay efficiency.

## 6. Non-goals and stop conditions

### Non-goals

- No general research platform or third independent workflow.
- No Content-specific canonical interface.
- No new planning artifact, queue or auto-router.
- No monitoring, watchlist, release-calendar or recurring-retrieval system.
- No paid-data exploration, benchmarking or procurement.
- No vector database, research-memory platform, knowledge graph or semantic index.
- No general agent swarm or autonomous coordinator.
- No company-level or Buyer Fit research optimization in this phase.
- No broad Deep rewrite during Sector Phase A.
- No automation of founder authority, evidence permission or sufficiency decisions.

### Stop conditions

Stop and narrow the implementation if:

1. the Targeted contract starts absorbing caller-specific planning or editorial rules—move that logic back to the consumer;
2. reuse requires a new storage/indexing service—use repository search and basic metadata instead;
3. judgment requires importing the full Unit Judgment Brief architecture—ship the six-question output section first and add machinery only after observed need;
4. a statistics integration exceeds two bounded sessions or cannot emit reproducible table identity—use a direct/manual pull and defer the wrapper;
5. path-passing changes research substance, permission outcomes or citation behavior—separate the optimization from workflow semantics;
6. a proposed provider, artifact or automation has no named macro/sector/trend consumer in the next eight weeks—defer it; or
7. a Deep simplification would require active Sector worktrees to migrate mid-phase—record it and wait for a safe boundary.

## 7. Cited source inventory

### Strategic frame and retirement

- [Strategic OS CLAUDE.md](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/CLAUDE.md:1>)
- [Promoted strategy](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/strategy.md:1>)
- [Promoted priorities](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/priorities.md:1>)
- [Promoted workstreams](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/workstreams.md:1>)
- [Promoted risks](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/risks.md:1>)
- [June strategic review](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:1>)
- [Retirement/current-authority instruction](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-strategyos/AGENTS.md:45>)

### Live August execution evidence

- [Sector Intelligence CLAUDE.md](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/CLAUDE.md:1>)
- [Sector Phase-A batch slate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/phase-a-batch-slate-v1.md:1>)
- [Sector parallelisation plan v3](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:1>)
- [Content evidence standard](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/evidence-standard.md:126>)
- [Content article workflow](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:113>)
- [Content launch amendment proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:1>)
- [Website pipeline state](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/pipeline-state.md:1>)

### Canonical RW and improvement reports

- [Canonical RW template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md.template:1>)
- [Canonical stage instructions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md:1>)
- [Canonical setup/deploy contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md:1>)
- [Lean RW proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:1>)
- [Judgment and insight plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:1>)
- [Retrieval-layer plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:1>)

## Final decision

**Build the public-source retrieval foundation for macro, sectors and trends first; add a tiny consumer-neutral Targeted executor; make judgment and reuse mandatory in their leanest useful form; reduce Deep relay cost; defer everything else.**

This is the smallest package that can materially increase launch-period research volume without sacrificing the analytical interpretation that should distinguish Axcíon research.
