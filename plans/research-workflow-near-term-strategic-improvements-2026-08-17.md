# Canonical Research Workflow — Near-Term Strategic Improvements

**Date:** 2026-08-17  
**Decision horizon:** next ~8 weeks  
**Status:** proposal  
**Decision question:** What is the smallest set of canonical Research Workflow (RW) changes that will create the most value during Axcíon's next two months of work without over-engineering the system?

## Executive recommendation

Do **not** implement any of the three reports wholesale. The smallest high-value package is:

1. **Add one shared targeted-research execution contract** that consumes an already-approved bounded brief and returns one evidence memo, source table and Source Access Log. It should supply the live Content Programme gate instead of creating another routing system.
2. **Ship a narrow Nordic/European source-routing registry** for the research Axcíon is actually about to do: Finland/Europe macro, sector structure, private-capital/M&A activity and public transaction evidence.
3. **Canonize the evidence-access guardrails immediately:** Perplexity output is a lead until the underlying source is opened; a retrieval-tool negative is never proof of absence; source access and failed direct attempts are recorded.
4. **Add a minimal structured-statistics path** for Eurostat and Statistics Finland first. Extend it to the other Nordic providers only when an approved brief requires them.
5. **Apply the already-specified path-passing refactor to the Deep workflow**, then leave the rest of the five-stage machinery substantially unchanged during the Sector Intelligence batch.
6. **Run one real operating trial of Sector Intelligence's existing judgment layer.** Do not canonize the full Unit Judgment Brief/House View system until that trial proves the analytical value and operator burden.

This produces a **two-surface canonical RW**, not a three-workflow platform:

- a lightweight **Targeted Research** surface for an approved brief; and
- the existing **Deep Research** surface for multi-unit studies and reports, with lower token relay cost and stronger source-access rules.

The calling project continues to decide whether research is needed. RW executes and returns evidence; it does not duplicate editorial, commercial or project-level routing.

## 1. Strategic frame and evidence freshness

### Authority caveat

The user-requested Strategic OS is useful as the last promoted statement of Axcíon's market-entry logic, but it is **dated, not current authority**. Its live strategy was last promoted on 2026-06-15, and a later repository instruction explicitly says `strategic-os` and `management-os` are retired and must not be treated as current sources of truth ([promoted strategy](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/strategy.md:12>); [retirement instruction](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-strategyos/AGENTS.md:45>)).

I therefore use the promoted June strategy as the requested **strategic frame**, not as a current execution plan, and corroborate near-term demand with live August project artifacts.

The still-useful strategic frame is:

- build intelligence before credibility, service-fit testing and controlled pilots ([strategy sequence](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/strategy.md:12>));
- make the buy-side intelligence base the foundation ([priority P1](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/priorities.md:6>));
- manufacture credibility through strong research and useful market notes ([priority P2](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/priorities.md:10>)); and
- avoid both over-analysis and premature scaling ([live risks](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/risks.md:6>)).

The June strategic review expected August to begin buy-side outreach and intelligence-building after a June–July preparation period, while real introductions, fees and legal exposure were expected later ([review timeline](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:9>); [August launch claim](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:16>); [operations timing](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:69>)). That timing claim is stale planning, but the August execution projects below confirm that intensive intelligence and launch-content work are now the relevant demand.

### Near-term research demand

| Active demand | What the live evidence says | Capability genuinely needed in the next ~8 weeks | Implication for canonical RW |
|---|---|---|---|
| **Sector Intelligence Phase A** | Ten sector units have been committed and staged; Stage 1→2 gather is designed to run across the slate before analysis is rationed ([batch slate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/phase-a-batch-slate-v1.md:16>); [phased model](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:29>)). The 2026-08-06 session record says all ten worktrees were launched and E0-cleared ([live staging record](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/logs/session-notes.md:262>)). | High-throughput source gathering; repeatable source-first routing; primary-source access; reliable scarcity handling; low relay/token overhead. | Optimize the current Deep gather lane and retrieval substrate. Do not redesign analysis/report stages while the batch is live. |
| **Sector execution-tool reality** | Sector Intelligence explicitly routes Research GPT as default but permits Codex for qualifying sessions; its current batch plan uses Codex as the flat-cost primary gatherer and Perplexity only as supplementary/high-stakes gap-fill ([tool rule](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/CLAUDE.md:83>); [cost model](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:170>)). Codex concurrency has already passed at ≥10 sessions ([Gate 6b](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:134>)). | Better inputs and source controls for the chosen Codex gather path; less main-session content relay. | A Perplexity API relay is not the first bottleneck for this workload. |
| **Content Programme launch research** | The live editorial workflow already has its own three-way gate: READY TO DRAFT, TARGETED RESEARCH REQUIRED or FULL RW REQUIRED ([live gate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:113>); [route decisions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:141>)). It creates a one-page bounded brief and one operator approval, then expects execution within that boundary ([brief contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:151>)). | A missing **targeted execution/output contract**, not another gate, queue or auto-router. | RW should accept the approved brief as input and return evidence in the consumer's expected shape. |
| **First launch-cycle narratives** | A 2026-08-17 amendment proposal would sequence Finland's economic context → Europe's strategic reconfiguration → sector/company resolution → M&A implications → Buyer Fit, and explicitly requires research to execute outside the Content repository ([progression](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:113>); [external research seam](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:402>)). It is still a draft, so this is a likely demand, not approved authority. | Fast, sourced macro/sector retrieval; official statistics; a compact evidence-to-interpretation handoff. | Build the reusable retrieval/input seam, but do not hard-wire the unapproved launch programme into RW. |
| **Concrete targeted briefs** | The Content Programme already has approved bounded briefs shaped around direct source tracing, fund criteria, transaction announcements, public portfolio behavior, limitations and claim strength ([Buyer Fit brief](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/articles/drafts/what-buyer-fit-means-in-practice.research-brief.md:25>); [minimum scope](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/articles/drafts/what-buyer-fit-means-in-practice.research-brief.md:77>)). One later brief records that the operator declined execution, showing that scope approval and execution authorization are distinct ([declined brief](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/articles/drafts/how-private-capital-firms-screen.research-brief.md:1>)). | Brief-path input, explicit authorization check, direct-source tracing, findings by question, named gaps. | The executor must never infer that a brief's existence authorizes work. |
| **LinkedIn foundation** | The LinkedIn OS proposes a future research-grade knowledge foundation, but the roadmap remains pending Phase 0 ratification ([proposal status](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-linkedin-os/pipeline/roadmap-v2-engagement-os.md:1>); [research foundation](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-linkedin-os/pipeline/roadmap-v2-engagement-os.md:67>)). | Potential Standard/Targeted research consumer after ratification. | Do not build extra capability for this yet; let it use the same targeted seam if approved. |
| **Website and operational systems** | The website is at implementation/test closure rather than operating as a research programme ([pipeline state](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/pipeline-state.md:7>)). The Strategic OS's June review placed real introductions and fee-bearing operations later ([review](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:69>)). | No new RW capability justified by these projects in this horizon. | Do not optimize for hypothetical buyer/company automation or live-deal scale now. |

### Demand-to-change conclusion

The near-term portfolio has **two real research jobs**:

1. **many repeatable Deep gathers** for the Sector Intelligence batch; and
2. **bounded targeted evidence requests** for launch content.

It does not yet need a universal research operating system, autonomous routing, a paid data stack, or a general multi-agent research organization.

## 2. Current canonical RW: what must be preserved and what is missing

The canonical template is a five-stage report workflow: Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production, with the artifact chain Task Plan → Research Plan → Answer Specs → Deep Research Reports → Extracts → Cluster Memos → Directives → Prose ([canonical template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md.template:52>)). Stage 3's permission/sufficiency gate is hard and constrains subsequent synthesis ([stage instructions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md:81>)).

The workflow's strongest controls match the risk profile of Axcíon's serious sector work: source classes, facts-before-synthesis, claim IDs, permission classes, scarcity records, independent verification and explicit evidence/inference separation. The lean report also identifies these as load-bearing and recommends preserving them for Deep work ([lean report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:51>)).

What is missing for the next eight weeks is narrower:

- no canonical targeted executor exists between Content's approved brief and its source pack/findings summary;
- source intelligence ships mainly as placeholders rather than a useful Nordic/European starting registry ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:38>));
- official statistical data has no direct structured path ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:32>));
- Perplexity lead handling and scarcity evidence are not canonicalized ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:41>)); and
- the Deep workflow still pays the known content-relay token penalty ([lean report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:40>)).

### Report-provenance limitation

The three improvement documents are all dated 2026-08-17, but none identifies itself as authored by Fable or Codex, and their commits carry only the repository author's Git identity. I therefore do **not** invent model-level attribution. Decisions below cite the report title/path, not an unsupported Fable-versus-Codex label. The three reports are:

- [Lean Canonical Research Workflow](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:1>) (`f13c638f`)
- [Judgment, Insight, Depth and Parallel Research Plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:1>) (`23e23f02`)
- [Data Retrieval Layer Improvement Plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:1>) (`1e4b50ca`)

## 3. Recommendation decision matrix

### Adopt now

| Recommendation | Source recommendation | Why it fits the next 8 weeks | Near-term scope |
|---|---|---|---|
| **A1. Shared targeted-research executor** | Lean report's R1/R2 idea, reduced to the missing execution seam ([three-route proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:71>)). | Content already owns route selection and produces a bounded approved brief. Duplicating that judgment would add ceremony. | One skill/entrypoint that accepts a brief path plus explicit authorization, executes only its questions, and writes: findings by question, claims/sources table, gaps, Source Access Log and a compact interpretation section. No deployment and no auto-classification. |
| **A2. Filled, narrow source registry** | Retrieval C2 ([C2](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:98>)). | Sector batch and launch narratives repeatedly need the same official/statistical/M&A source classes. Starting from placeholders wastes effort and increases drift. | Canonize sources for Finland/Europe macro, Nordic sector structure, PE/M&A activity, public transaction evidence and regulation. Exclude company-research and paid-database expansion. |
| **A3. Perplexity-lead rule + mechanical access evidence** | Retrieval C4/C5 ([C4–C5](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:104>)). | False scarcity is more dangerous than an incomplete result, and the Sector batch multiplies any systematic retrieval error. | Canonical rule: unopened results are `[LEAD]`; no claim ID or coverage movement; negative search output never proves absence. Record URL, date, access state/status and direct-attempt result. Domain resolution required before scarcity. |
| **A4. Minimal structured-statistics lane** | Retrieval C3 ([C3](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:101>)). | Finland-cycle and Europe-reconfiguration content will require official series; sector work needs NACE structure data. | First implementation supports Eurostat and Statistics Finland, emitting CSV/JSON plus source/table identity, retrieval date and access-log row. Add SCB/SSB/DST only when an approved brief names them. |
| **A5. Path-passing refactor** | Lean automation item 2 ([path-passing recommendation](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:103>)). | Sector's ten-unit batch is exactly where a per-unit/section relay cost compounds. The design already exists, so this is implementation rather than a new architecture debate. | Apply only the previously specified command/skill refactor; verify the affected Deep paths; sync deliberately into active Sector worktrees. Do not combine it with broader QC/gate changes. |
| **A6. One real local judgment trial** | Judgment plan Unit 1 ([trial](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:329>)). | Sector already has the implementation and 82 passing regression tests, but no representative operating proof ([pilot limits](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:58>)). | Run one actual unit through proposal → founder revise/approve/reject → downstream prose. Measure operator time, token burden and whether the approved view materially improves output. This is a decision gate, not canonical rollout. |
| **A7. Preserve Deep controls** | Lean report §2.2 ([what stays](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:83>)). | The Deep lane is actively supporting consequential sector reports. Weakening evidence controls during a batch would trade visible ceremony for hidden quality risk. | Keep claim IDs, permission classes, sufficiency, facts-only extraction, scarcity register, source-class hierarchy and independent fact verification. |

### Defer with explicit trigger

| Recommendation | Disposition | Revisit trigger |
|---|---|---|
| **Full Light/Standard/Deep route architecture** | Defer. The concept is sound, but exact mode calibration is explicitly untested ([judgment plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:225>)). The live Content Programme already supplies the needed route gate. | After 5–10 targeted runs and two Deep units, if repeated ambiguity remains about which path owns a request. |
| **Perplexity Agent API relay as Wave-1 priority** | Defer. It solves a real manual relay, but it is secondary to Sector's chosen Codex-primary gather path and depends on unverified API parity ([retrieval P1](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:139>)). | Three targeted runs in four weeks show manual Perplexity relay is the dominant elapsed-time/operator bottleneck, and API reachability/filters are proven by execution. |
| **Broad Deep-pipeline slimming** — quality-standard compression, merged chapter QC, editorial-hop collapse, Stage-1 gate consolidation, dead-code removal | Defer as one bundled change. Each may be worthwhile, but combining them while ten Sector worktrees are in flight creates sync and behavior risk. | After Phase A gather reaches its re-evaluation gate, or one change becomes a measured blocker to Phase B/C. Implement one independently verifiable unit at a time. |
| **Full canonical Unit Judgment Brief rollout (Units 2–7)** | Defer. The local pilot lacks the report/content operating proof its own plan requires, and Content may retire its local RW deployment under the 2026-08-17 amendment. | Local Sector trial passes; Content Programme's L1-D5/cutover decision is settled; a real second consumer still exists. |
| **Local-language Serper/Google expansion and all-Nordic provider support** | Defer. Useful but not yet proven as the binding failure for the immediate briefs. | First approved brief whose required Finnish/Swedish/Norwegian/Danish evidence fails through direct official and standard search routes. |
| **C7/C8 half-wired controls, full country→language consolidation, broad telemetry** | Defer to the next bounded canonical-maintenance session. | After the targeted lane and access log produce a baseline; then fix only fields or drift that the baseline shows matter. |
| **Monitoring watchlist / release calendar** | Defer. It is a recurring operation, not necessary to complete the first launch research. | At least two consecutive content/sector cycles re-discover the same periodic sources or miss a scheduled release. |

### Reject for this horizon

| Recommendation | Why reject now |
|---|---|
| **A second elaborate auto-router inside RW** | Route ownership already exists in the live Content workflow, while Sector Intelligence makes an explicit execution decision per session. Another classifier would create two authorities for the same question. |
| **Judgment plan Unit 7 as written — integrate canonical RW directly into Content Programme** | The current 2026-08-17 Content proposal moves research execution outside that repo and retires its live RW deployment ([A7](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:402>)). Until that decision is approved or declined, a direct integration would build against a possibly-retired surface. Supply an external input contract instead. |
| **General multi-agent/swarm research or autonomous coordination** | Sector already achieved ≥10 concurrent Codex gather sessions without new agent infrastructure. The judgment report itself says not to build a general swarm ([experiment boundary](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:292>)). No current need justifies autonomous memory or coordination machinery. |
| **Paid deal databases or Nordic Financial News subscription now** | Current near-term questions can be answered mainly from official statistics, public filings/announcements and free market reports. The retrieval report itself defers Dealroom ([source table](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:56>)). Subscription purchase should follow observed coverage failure, not precede it. |
| **Universal API-first execution** | It conflicts with current tool reality: Research Execution GPT has no public API, Sector uses Codex as primary gatherer, and credentials/API parity are unproven. Standardize artifacts and access evidence first; automate a relay only where repeated use proves the return. |

## 4. Sequenced implementation plan

Impact and urgency use `High / Medium / Low`; effort uses `S` (one bounded session), `M` (roughly 2–4 bounded sessions), `L` (multi-part rollout).

| Order | Change | Impact | Effort | Urgency | Completion evidence |
|---|---|---:|---:|---:|---|
| **1** | Canonize the Perplexity-lead/scarcity rule; define the Source Access Log; add domain precheck; publish the narrow source registry. | High | S–M | **Now** | One fixture proves an unopened lead cannot receive a claim ID or move coverage; one failed direct attempt is logged; one Finland/Europe query routes to named first-party sources before general search. |
| **2** | Build the shared targeted-research executor around the Content brief contract. | High | M | **Now** | Run it against one approved, still-authorized brief. It refuses a declined/unapproved brief; writes findings by question, claim/source table, gaps and access log; makes no out-of-scope query. |
| **3** | Add Eurostat + Statistics Finland structured pulls to the executor. | High for launch narratives; Medium overall | M | Before the first approved Finland/Europe launch brief | One table from each provider is reproducibly fetched with table/series identity, retrieval date, raw data and a citable source pointer. No other provider is added without a live brief. |
| **4** | Implement and verify the Deep content-relay → path-passing refactor; propagate only to active Sector consumers. | High cost reduction | M | Before the batch reaches heavy Stage 3/4 work | Existing regression/command-path tests pass; representative unit output is unchanged in substance; measured main-session token relay falls. |
| **5** | Run the real Sector judgment-layer operating trial. | Medium–High quality | S operationally (implementation exists) | Before any canonical judgment rollout | Founder decision works; approved content shapes downstream prose; no unapproved thesis appears; operator/token burden recorded. |

### Why this order

The first two changes make immediate research safer and executable. The statistics lane then serves the likely first launch briefs without prebuilding every Nordic integration. The path-passing change improves the batch already in motion but is isolated from the retrieval semantics. The judgment trial is last because it informs a later adoption decision; it is not a prerequisite for gathering evidence.

### Eight-week operating sequence

- **Week 1:** land order 1; freeze the targeted executor's input/output contract against the live Content brief.
- **Weeks 1–2:** build and run order 2 on one authorized real brief.
- **Weeks 2–3:** add order 3 only if the approved launch brief requires official series; otherwise hold it.
- **Weeks 2–4:** land order 4 and deliberately sync the Sector consumers that will use it.
- **Weeks 3–6:** run order 5 on the first suitable Sector unit crossing the judgment boundary.
- **Weeks 6–8:** operate; fix only observed defects. Decide whether the API relay or canonical judgment rollout has earned a new proposal.

## 5. Target-state canonical RW after these changes

```text
CALLING PROJECT OWNS THE ROUTE
    |
    |-- approved bounded brief ------------------------------+
    |                                                        |
    |                                                TARGETED RESEARCH
    |                                                1. authorization check
    |                                                2. source-registry routing
    |                                                3. Codex/web/direct retrieval
    |                                                4. direct source opening
    |                                                5. optional structured stats
    |                                                6. findings + claims/sources
    |                                                7. gaps + Source Access Log
    |                                                        |
    |<---------------- evidence input returned ---------------+
    |
    |-- multi-unit / thesis / report brief ------------------+
                                                             |
                                                       DEEP RESEARCH
                                                       existing 5 stages
                                                       path-passing relay
                                                       claim IDs/classes
                                                       sufficiency gate
                                                       scarcity register
                                                       independent verification
```

The Targeted output should contain only:

1. brief identity and authorization status;
2. answer to each approved question;
3. evidence table: claim/finding → direct source → source class → retrieval date → permitted wording;
4. explicit facts / interpretation / inference separation;
5. contradictions and disconfirming evidence;
6. named gaps and what was directly attempted;
7. Source Access Log; and
8. a compact **proposed interpretation** section where the caller needs one.

That proposed interpretation is not automatically Axcíon authority. For content, the Content Programme's House View/founder gate owns promotion. For Sector Intelligence, the existing local Unit Judgment Brief owns it until the trial supports canonical adoption.

The Deep lane remains the current five-stage workflow. The near-term change is not to weaken it; it is to remove avoidable content relay and share stronger retrieval foundations.

## 6. Non-goals and stop conditions

### Non-goals

- No third independent research workflow.
- No duplicate editorial or project routing layer.
- No general agent swarm, autonomous coordinator or shared agent memory.
- No full canonical judgment rollout before a real operating trial.
- No broad Deep-workflow rewrite during Sector Phase A.
- No paid database or news subscription before a documented public-source failure.
- No company-level research automation in this scope.
- No all-Nordic API platform before the first two providers prove useful.
- No automation of founder judgment, permission grading or sufficiency decisions.

### Stop conditions

Stop and reassess the sequence if any of the following occurs:

1. The Content Programme declines the 2026-08-17 amendment and keeps local RW execution; re-evaluate the executor's deployment boundary, but keep one output contract.
2. The first targeted run cannot consume the live brief without copying its gate logic; change the interface, not the caller's authority.
3. Eurostat/Statistics Finland integration takes more than two bounded implementation sessions or cannot emit reproducible table identity; use direct fetch/manual evidence for the first launch brief and defer the wrapper.
4. The path-passing change alters research substance, permission outcomes or citation behavior; revert that unit and separate token optimization from workflow semantics.
5. The Sector judgment trial does not materially improve the output or imposes disproportionate operator burden; keep it project-local and do not canonize it.
6. A proposed addition has no named consumer in the next eight weeks; defer it.

## 7. Cited source inventory

### Strategic frame and retirement

- [Strategic OS CLAUDE.md](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/CLAUDE.md:1>)
- [Promoted strategy](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/strategy.md:1>)
- [Promoted priorities](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/priorities.md:1>)
- [Promoted workstreams](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/workstreams.md:1>)
- [Promoted risks](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/risks.md:1>)
- [Promoted open decisions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/state/live/open-decisions.md:1>)
- [June strategic review](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/strategic-os/reviews/strategic/2026-06-strategic-review.md:1>)
- [Retirement/current-authority instruction](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-systems-builder-strategyos/AGENTS.md:45>)

### Live August execution evidence

- [Sector Intelligence CLAUDE.md](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/CLAUDE.md:1>)
- [Sector Phase-A batch slate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/phase-a-batch-slate-v1.md:1>)
- [Sector parallelisation plan v3](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:1>)
- [Sector live session record](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/logs/session-notes.md:262>)
- [Content evidence standard](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/evidence-standard.md:126>)
- [Content live article workflow](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:113>)
- [Content launch amendment proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:1>)
- [Buyer Fit targeted brief](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/articles/drafts/what-buyer-fit-means-in-practice.research-brief.md:1>)
- [Declined screening brief](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/articles/drafts/how-private-capital-firms-screen.research-brief.md:1>)
- [LinkedIn OS proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-linkedin-os/pipeline/roadmap-v2-engagement-os.md:1>)
- [Website pipeline state](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/pipeline-state.md:1>)

### Canonical RW and improvement reports

- [Canonical RW template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md.template:1>)
- [Canonical stage instructions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md:1>)
- [Canonical setup/deploy contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md:1>)
- [Lean RW proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:1>)
- [Judgment and insight plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:1>)
- [Retrieval-layer plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:1>)

## Final decision

**Adopt the retrieval foundation and the targeted-research execution seam now; reduce Deep relay cost; prove the judgment layer locally. Defer the platform redesign.**

This is the minimum package that directly supports the two workloads Axcíon is actually entering: ten parallel sector gathers and bounded launch-content research. Everything else waits for use evidence.
