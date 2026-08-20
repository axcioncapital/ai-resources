# Canonical Research Workflow — Near-Term Strategic Improvements

**Date:** 2026-08-17  
**Revised:** 2026-08-17 after operator feedback, repository-reality QC and structural-insight review  
**Decision horizon:** next ~8 weeks  
**Status:** revised proposal  
**Decision question:** What is the smallest set of canonical Research Workflow (RW) changes that will create the most value during Axcíon's next two months of work without over-engineering the system?

## Executive recommendation

Do **not** implement any of the three source reports wholesale and do not rebuild RW into a general research platform. Build a two-surface canonical RW focused explicitly on **high-volume macro, sector and trend intelligence**:

1. **Strengthen the retrieval foundation first, but implement only the missing delta.** Ship a narrow Nordic/European macro-sector-trend source seed, canonize the Perplexity-lead rule and authoritative-domain check, and add direct Eurostat/Statistics Finland pulls with mechanical access logging. Do not rebuild source-access controls that already exist in the canonical executor and verifier.
2. **Add one very small, consumer-neutral Targeted Research contract.** The abstraction is: `bounded question + scope + authorization + intended use → evidence + proposed interpretation + conditional downstream signals`. Implement it as an Axcíon contract that composes with the existing user-scoped `$research` capability rather than creating a second generic `/research` router. The caller owns planning and routing; Content Programme is the first consumer, not the owner of the interface.
3. **Split judgment by research surface and adopt both forms now.** Targeted outputs use a compact proposed-interpretation section with materiality-gated Axcíon implications, second-order reasoning, editorial potential and follow-up questions. Deep Research generalizes the already-built Sector Intelligence Unit Judgment Brief instead of creating a second, weaker judgment mechanism; its analyst standard gains only bounded topic lenses and second-order reasoning, not an editorial appendix. The next real Sector unit is the first production rollout of the local Deep lane; independent QC must be wired before broad canonical deployment. Founder authority remains required before an important proposed interpretation becomes an Axcíon House View.
4. **Add lightweight, authority-aware research reuse.** Before material retrieval, consult caller-approved inventories or reuse roots, distinguish completed evidence from leads and decision context, reuse still-valid evidence and retrieve only the gaps. Targeted carries a compact reuse record; Deep uses the existing `reference/source-map.md` seam. This is workflow behavior, not a memory platform or broad workspace crawl.
5. **Reduce Deep content relay with explicit safety boundaries.** Pass bulky reports, extracts, memos and drafts by path and have producers return paths, while continuing to deliver compact load-bearing authorities as content unless the dispatch can prove it read the path. Preserve the approved judgment and evidence-control inputs. Do not disrupt active Sector work with a broader structural rewrite.
6. **Defer monitoring, paid-data work, API-platform expansion, auto-routing and multi-agent machinery.** None is needed to increase research throughput during the launch period.
7. **Revisit the Deep artifact chain at a safe operating boundary.** Do not treat the current chain as permanent, but do not create a pre-deployment experiment or benchmarking programme. Deploy obvious low-risk improvements, observe real use and correct defects.

The two canonical surfaces are therefore:

- **Targeted Research:** bounded, reusable macro/sector/trend research with evidence, a lean proposed interpretation and conditional downstream signals; and
- **Deep Research:** the existing multi-stage report workflow, with stronger retrieval foundations, authority-aware reuse, an approved Unit Judgment Brief and lower relay cost.

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
| **Sector Intelligence Phase A** | Ten sector units have been committed; gathering is designed to run across the slate before analysis and reporting are rationed ([batch slate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/phase-a-batch-slate-v1.md:16>); [phased model](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:29>)). | High-throughput evidence retrieval on sector structure, dynamics, demand drivers, regulation, M&A activity and investment relevance; strong interpretation; low relay overhead. | Make macro/sector/trend retrieval and judgment the core near-term optimization target. Generalize the existing local judgment lane deliberately; do not otherwise redesign the active Deep analysis/report chain mid-batch. |
| **Sector execution-tool reality** | The current plan uses Codex as the flat-cost primary gatherer and Perplexity only as supplementary/high-stakes gap-fill; Codex concurrency has passed at ≥10 sessions ([cost model](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:170>); [Gate 6b](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/roadmap/parallelisation-plan-v3.md:134>)). | Better source routing, direct-source access, reusable evidence and path-based handoffs for the proven gather path. | A broad Perplexity API runtime is not the first bottleneck. |
| **Launch macro/sector narratives** | A 2026-08-17 Content proposal sequences Finland's economic context → Europe's strategic reconfiguration → sector/company resolution → M&A implications and requires research execution outside the Content repository ([progression](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:113>); [external seam](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:402>)). It remains proposed, not approved authority. | Fast official statistics, policy/regulatory evidence, sector/trend evidence and an evidence-to-interpretation handoff. | Design the canonical Targeted contract around general research needs, then let Content consume it. Do not inherit Content's brief schema. |
| **Content execution seam** | The live editorial workflow already decides READY TO DRAFT, TARGETED RESEARCH or FULL RW and can produce a bounded approved brief ([route gate](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:113>); [brief contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:151>)). | A reusable executor for bounded research—not another planning, editorial or routing layer. | Content is a first consumer and test case, not the canonical interface authority. |
| **Overlapping launch themes** | Sector and content work repeatedly touch the same macro conditions, sector structures, transaction evidence and public-source ladders. Content already uses a curated inventory and shared source pack ([reuse rule](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/evidence-standard.md:126>)); Sector already distinguishes completed reusable research, leads and decision context in `reference/source-map.md` ([Sector reuse map](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/source-map.md:1>)). | Authority-aware prior-research discovery, validity checking and gap-only retrieval. | Generalize the existing curated patterns. Do not introduce a broad workspace crawl or imply that metadata alone creates cross-repository discovery. |
| **Website, LinkedIn and company-level work** | The website is in implementation/test closure rather than operating as a research programme ([pipeline state](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/pipeline-state.md:7>)). LinkedIn remains a potential downstream consumer, not a reason to shape the canonical interface now. | No company-level or Buyer Fit research architecture justified in this horizon. | Optimize for macro, sectors and trends. Other needs can use the generic bounded contract later if they qualify. |

### Demand-to-change conclusion

The next eight weeks require three things:

1. **repeatable public-source retrieval** for Nordic/European macro, sectors, trends, regulation and M&A/private-capital activity;
2. **bounded Targeted Research** that turns approved questions into evidence and a lean proposed interpretation; and
3. **efficient Deep work** for the Sector Intelligence batch, including the already-built local judgment lane and lower bulk-relay cost.

Company-level research and Buyer Fit research may occur, but they do not drive the canonical design. The system also does not yet need monitoring, paid data, an autonomous router, a knowledge graph or a general multi-agent research organization.

## 2. Current canonical RW: preserve the core, fill the real gaps

The canonical template is a five-stage report workflow: Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production, with the artifact chain Task Plan → Research Plan → Answer Specs → Deep Research Reports → Extracts → Cluster Memos → Directives → Prose ([canonical template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md.template:52>)). Stage 3's permission/sufficiency gate constrains subsequent synthesis ([stage instructions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md:81>)).

Its strongest controls remain proportionate for consequential Deep work: source classes, facts before synthesis, claim IDs, permission classes, scarcity records, independent verification and explicit evidence/inference separation. The lean report also identifies these as load-bearing ([lean report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:51>)).

The near-term gaps are narrower and concrete. Some controls already exist and should be extended rather than rebuilt:

- source intelligence still ships mainly as project-fillable placeholders instead of an optional Nordic/European macro/sector/trend starting seed ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:38>));
- official statistical evidence has no direct structured path ([retrieval report](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:32>));
- the executor SOP already says snippets are not accessed evidence and already requires a Source Access Log ([executor SOP](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/sops/research-executor-gpt.md:35>)); what is missing is the canonical Perplexity-supplementary lead rule, authoritative-domain precheck and mechanical logging for scripted pulls;
- the user-scoped `$research` skill already provides consumer-neutral primary-source research into one Markdown file ([research skill](</Users/patrik.lindeberg/.codex/skills/research/SKILL.md:1>)), but no Axcíon-owned Targeted contract adds authorization, reuse, source-access and interpretation behavior;
- reuse exists locally in Sector and Content, but no small canonical contract generalizes their authority/provenance rules;
- Targeted outputs have no required analytical judgment contract;
- Deep judgment already exists as a local Sector implementation with 82 passing structural regression assertions, but independent editorial/compliance QC and a representative live operating run remain open ([integration outcome](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/logs/work-loop/judgment-layer-workflow-integration.md:8>); [accepted limitations](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/logs/work-loop/judgment-layer-workflow-integration.md:33>)); and
- Deep still pays a known content-relay token penalty, while the old path-passing recommendation conflicts with the newer context-isolation and judgment-propagation contracts and therefore needs an explicit carve-out ([token audit](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-18-research-workflow.md:45>); [current path convention](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/required-reference-files.md:72>)).

The current Deep artifact chain may ultimately contain unnecessary intermediate transformations. This proposal does **not** declare it permanent. It defers structural simplification until the active Sector batch reaches a safe boundary, and it rejects a formal comparison programme as a prerequisite to obvious improvements.

### Report-provenance limitation

The three improvement documents are dated 2026-08-17 but do not self-identify their model author. Decisions therefore cite document paths rather than inventing model-level attribution:

- [Lean Canonical Research Workflow](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:1>)
- [Judgment, Insight, Depth and Parallel Research Plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:1>)
- [Data Retrieval Layer Improvement Plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:1>)

### Implementation-source caveat

The evidence and implementation substrates do not all live on the same landed branch:

- the three source reports live in the `ai-resources-research-workflow-fixes` worktree on `session/2026-08-17-research-workflow-fixes`; they are decision evidence, not a second implementation owner;
- the accepted judgment implementation lives in Sector Intelligence on `codex/florian-demo-continue`, not on that repository's `main`; and
- this proposal lives in `ai-resources` `main`, which remains the canonical implementation owner.

Before implementation, inventory the portable judgment files and tests from the Sector branch and classify each as canonical, project-specific or obsolete. Do not independently recreate the mechanism from the reports, and do not assume a canonical change automatically updates deployed project copies.

## 3. Recommendation decision matrix

### Adopt now

| Work package | Why it fits the next 8 weeks | Minimum near-term scope |
|---|---|---|
| **A1. Retrieval delta for macro, sectors and trends** | It directly serves the Sector batch and launch narratives while correcting the highest-confidence retrieval gaps. | Add an optional Nordic/European source seed covering macro, sector structure/dynamics, trends, regulation/policy and public PE/M&A evidence. Canonize the Perplexity-supplementary lead rule and authoritative-domain precheck. Add Eurostat and Statistics Finland pulls that emit raw data, exact query/filters, unit, selected dimensions, table/dataset identity, retrieval timestamp, source URL and mechanical access-log rows. Do not replace the existing generic project source hierarchy or rebuild its opened-source and false-scarcity controls. |
| **A2. One lean Targeted Research capability plus the minimum reusable-evidence contract** | Callers already decide when bounded research is needed, the user-scoped `$research` skill already supplies a generic primary-source execution primitive, and both live consumers already use curated reuse patterns. | Add one Axcíon-owned request/output contract that composes with `$research` or the environment's equivalent retrieval capability. Request: question, scope, authorization, intended use/consequence and caller-approved reuse roots. Single output: authority-aware reuse record, evidence, access record, gaps, metadata and lean proposed interpretation. Where material, apply a topic-selected macro/sector/trend lens and include the strongest supported second-order consequence, a specific Axcíon implication, editorial potential and zero to three ranked follow-up questions. For Deep, add the smallest project-fillable `source-map` template/contract that distinguishes completed reusable evidence, leads requiring validation and decision context; the runtime already expects this seam but canonical deployment provides no template. No central catalog, router, queue, deployment profile or new planning artifact. |
| **A3. Deep judgment graduation** | Judgment is strategically urgent and the active Sector branch already proves the core artifact, approval, fail-closed and propagation mechanics. Rebuilding a second judgment layer would waste the strongest existing work. | Generalize the local Unit Judgment Brief and analyst standard by removing Sector-specific verdict vocabulary and document-architecture assumptions; add bounded macro/sector/trend analytical lenses and require the most material supported second-order consequence where one exists; preserve materiality, causal discipline and countercase safeguards; keep proposed/approved forms and explicit founder authority; wire independent editorial/compliance QC. Use the next real Sector unit as the first production rollout before broad deployment to other projects. Do not add an editorial appendix, the larger external-insight ladder or a separate House View artifact now. |
| **A4. Bounded Deep relay reduction** | Sector's multi-unit work compounds the known relay/token penalty, but path-only propagation can silently drop load-bearing authorities. | Path-pass bulky raw reports, extracts, memos, architectures and drafts; producers write to disk and return paths. Continue content-passing compact governing inputs such as the approved Unit Judgment Brief unless the dispatch has a tested read-and-attestation contract. Verify evidence, judgment and output equivalence. Sync active Sector consumers only at a safe boundary. |
| **Standing constraint: preserve Deep evidence controls** | The Deep lane supports consequential sector reports; weakening controls would create hidden quality risk. | Keep source classes, facts-only extraction, claim IDs, permission classes, sufficiency, scarcity records, evidence/inference separation and independent verification. This constrains A1–A4; it is not a fifth implementation project. |

### Defer with explicit trigger

| Recommendation | Disposition and revisit trigger |
|---|---|
| **Full Light/Standard/Deep platform and auto-classification** | Defer. Revisit only if 5–10 real Targeted runs and two Deep units show recurring ownership ambiguity that callers cannot resolve. |
| **Perplexity Agent API relay** | Defer. Sector already uses Codex as primary gatherer. Revisit only if manual Perplexity relay becomes a repeated material bottleneck and required API behavior is proven by execution. |
| **Broad Deep-pipeline simplification** | Defer until the current Sector batch reaches a safe boundary. Then inspect whether Task Plan, Research Plan, Answer Specs, Extracts, Cluster Memos and Directives can be collapsed without weakening evidence, judgment or traceability. Implement sensible units directly; do not require competing workflow variants or a formal benchmark programme. |
| **Expanded House View and external-insight architecture** | Defer the larger machinery: candidate-interpretation sets, formal insight ladder, publication-readiness object and separate content handoff. The proven Deep Unit Judgment Brief core ships; the broader expansion waits for recurring evidence that the lean Targeted output and approved Deep brief are insufficient. |
| **Shared research agenda or cross-project question queue** | Defer. Prefer questions that can serve more than one legitimate use, but do not create a central agenda now. Revisit only if 5–10 Targeted runs and two Deep units reveal repeated duplication, priority conflicts or valuable follow-up questions that callers consistently lose. |
| **All-Nordic provider and local-language tooling expansion** | Defer until an approved macro/sector/trend brief cannot be answered reliably through the initial official/public routes. Then add the specific missing country/provider, not a platform. |
| **Monitoring systems, watchlists, release calendars and periodic retrieval** | Defer explicitly. Revisit only after recurring operations demonstrate missed releases or repeated rediscovery; none belongs in the immediate build. |

### Reject for this horizon

| Recommendation | Why reject now |
|---|---|
| **Content-specific canonical input contract** | Content is the first consumer, not the owner. Canonical RW must accept the smaller consumer-neutral request contract and use a thin adapter if needed. |
| **A second planning/routing layer inside RW** | Callers own the decision to research and the approved scope. Another router or planning artifact would duplicate authority and ceremony. |
| **Separate “Axcíon Insight” artifact, store or workflow layer** | Its useful fields fit inside the existing Targeted output and Deep judgment contract. A new named layer would duplicate the proposed-interpretation and Unit Judgment Brief mechanisms. |
| **Mandatory multi-use or output quotas** | A question need not serve two of strategy, market intelligence and Content to be worth answering. Do not require an editorial angle or three new hypotheses from every run; `none` and zero are valid when the evidence does not support them. |
| **Pre-deployment workflow experiments or formal comparison programme** | They delay obvious low-risk improvements. The operating rule is deploy sensible changes quickly, use the next real assignment as the first production rollout, observe and correct. A real operating run of the already-integrated local judgment lane is rollout evidence, not a parallel-variant experiment. |
| **Paid-data exploration, benchmarking or procurement** | There is no near-term budget. Spend no implementation or investigation time on specialist paid M&A databases or subscriptions during this phase. |
| **General agent swarm, autonomous coordinator or shared agent memory** | Existing Codex concurrency already supports the batch. No named consumer justifies more coordination infrastructure. |
| **Monitoring infrastructure now** | Useful later, but unnecessary for immediate throughput. |
| **Company-level or Buyer Fit optimization as the canonical design center** | These topics may use the generic contract when needed, but macro, sectors and trends are the near-term system mandate. |
| **Universal API-first execution** | Current tools and credentials are heterogeneous. Standardize the research contract, source access and outputs first; automate only proven repetitive seams. |

## 4. Sequenced implementation plan

Impact and urgency use `High / Medium / Low`; effort uses `S` (one bounded session), `M` (roughly 2–4 bounded sessions), `L` (multi-part rollout).

| Order | Change | Impact | Effort | Urgency | Completion evidence |
|---|---|---:|---:|---:|---|
| **0** | Reconcile the implementation sources and ownership boundary. | High risk reduction | S | **Before edits** | The local Sector judgment branch is identified as the source substrate; its project-specific pieces and canonical candidates are listed. The separate research-fixes worktree remains evidence, not a second implementation owner. No canonical implementation assumes either branch has already landed on project or `ai-resources` main. |
| **1** | Ship the retrieval delta: optional macro/sector/trend source seed, missing Perplexity-lead/domain rules and Eurostat/Statistics Finland pulls with mechanical access logging. | High | M | **Now** | One macro query and one sector/trend query route to named first-party sources before general search. One reproducible pull from each statistics provider records query, filters, unit, dimensions, identity, raw response, retrieval time and source. A single retrieval negative cannot establish absence; existing evidenced-negative rules still apply. |
| **2** | Build one lean Targeted Research capability, including authority-aware reuse, lean proposed interpretation and conditional downstream signals in the same output; add the minimal Deep `source-map` template/contract. | High | M | **Now** | An authorized generic request runs through the existing `$research` capability or an equivalent environment adapter without importing caller planning logic. It consults only caller-approved reuse roots, distinguishes evidence/leads/context, retrieves named gaps, applies only the relevant analytical lens, and returns one artifact. Where evidence supports them, the artifact identifies the strongest second-order consequence, a specific Axcíon implication, an editorial lead and zero to three ranked next questions. `None` is an acceptable result for every conditional field; no follow-up executes automatically. Consequential interpretations remain proposed until explicitly approved. A fresh Deep deployment can instantiate the same three-way reuse classification without recreating Sector's large project-specific register. |
| **3** | Generalize and complete the existing Deep Unit Judgment Brief lane. | High | M | **Now, at the next safe Sector boundary** | Canonical artifacts contain no Sector-specific verdict or chapter assumptions; the analyst standard selects relevant rather than exhaustive macro/sector/trend lenses and tests supported second-order consequences without relaxing causal discipline; proposed/approved identity and founder authority remain fail-closed; independent QC consumes the brief and standard. The next real Sector unit completes the path without an invented thesis, forced implication or unacceptable review/token burden before deployment widens. |
| **4** | Reduce Deep bulk relay with the judgment/evidence carve-out in place. | High cost reduction | M | Before heavy subsequent Sector Stage 3/4 work | Bulky inputs are read from tested paths and large outputs return by path; compact governing authorities still reach each consumer reliably; evidence and judgment propagation tests pass; representative output is unchanged in substance and main-session relay falls. |

### Implementation rules

- Implement the sequence as small deployable units; do not wait for a parallel-variant test.
- Use real work as the operating proof. The next genuine Targeted assignment and next real Sector unit are production rollouts, not benchmark programmes. Observe, log defects and correct them.
- Keep Targeted judgment generation immediate. For Deep, generalize the existing Unit Judgment Brief rather than adding the Targeted judgment section to the report pipeline. Keep founder approval explicit for consequential House Views.
- Treat macro/sector/trend lenses as optional reasoning aids selected by the question, not as checklists every output must satisfy. Require a second-order consequence only when the evidence supports a credible mechanism and its countercase.
- Label editorial potential as a downstream lead, never a publication decision. Allow `none`; Content and its publication gates decide whether an external position exists.
- Produce zero to three follow-up questions only when they could materially improve a decision or view. Rank them, state why they matter and never execute them automatically.
- Treat a single retrieval-tool negative as non-evidence. Preserve the canonical evidenced-negative path where documented direct-source and ladder exhaustion genuinely support a zero.
- Search only caller-approved reuse inventories or roots. Never broad-crawl the workspace by default, and never treat an internal synthesis, lead or strategy statement as external evidence merely because it is relevant.
- Do not add a new reusable artifact unless an existing file or a small output section cannot carry the required information.
- Do not add a source, provider or integration without a named macro/sector/trend use case.

### Eight-week operating sequence

- **Week 1:** reconcile the branch/ownership boundary, then land the retrieval delta and validate it on real macro and sector questions.
- **Weeks 1–2:** build the one-file Targeted capability with reuse, lean judgment and conditional downstream signals already inside it. Do not create separate reuse, insight or judgment workflows.
- **Weeks 2–4:** generalize the existing Deep Unit Judgment Brief and analyst standard with bounded topic lenses and supported second-order reasoning, wire independent QC and run the next real Sector unit through it at the next safe boundary.
- **Weeks 3–5:** land bounded bulk path-passing after the judgment input/output carve-out is explicit; sync active Sector consumers only at a safe boundary.
- **Weeks 4–8:** operate both surfaces at volume and fix observed defects. Record Deep-chain simplification candidates without opening the larger refactor during Sector Phase A.

## 5. Target-state canonical RW after these changes

```text
CALLING PROJECT OWNS NEED, SCOPE AND AUTHORIZATION
    |
    |-- bounded canonical request --------------------------+
    |   question | scope | authorization | intended use    |
    |   consequence | approved reuse roots                 |
    |                                                       |
    |                                               TARGETED RESEARCH
    |                                               1. validate request
    |                                               2. consult approved inventory/roots
    |                                               3. classify evidence / lead / context
    |                                               4. reuse valid evidence
    |                                               5. identify retrieval gaps
    |                                               6. route through Nordic source seed
    |                                               7. execute via $research / adapter
    |                                               8. structured stats if needed
    |                                               9. evidence + access record
    |                                              10. proposed interpretation
    |                                              11. conditional downstream signals
    |                                                       |
    |<-------------- evidence, interpretation and signals --+
    |
    |-- multi-unit / thesis / report brief ----------------+
                                                            |
                                                      DEEP RESEARCH
                                                      current evidence controls
                                                      shared retrieval foundation
                                                      source-map reuse before retrieval
                                                      proposed → approved judgment brief
                                                      bulk path-based handoffs
                                                      compact authority delivery
                                                      existing stages for now
```

### Canonical Targeted request

The request is the smallest stable contract that can be expressed in an existing brief or invocation:

1. bounded research question(s);
2. scope and exclusions;
3. explicit authorization to execute;
4. intended use and consequence level;
5. optional required geography/time period; and
6. caller-approved reuse inventory or roots, where reuse is authorized.

It is **not** a new mandatory planning document. A caller's approved brief can supply these fields through an adapter or direct mapping.

### Canonical Targeted output

The output contains:

1. request identity, scope and authorization status;
2. reuse record: approved locations checked; prior research found; completion/authority, provenance, scope, geography, freshness and intended-use decision; evidence reused; leads/context retained separately; and remaining gaps;
3. answer/evidence by approved question;
4. evidence table: finding → opened direct source → source class → retrieval/as-of date → permitted wording;
5. facts / interpretation / inference separation;
6. analytical judgment:
   - What is happening?
   - Why is it happening?
   - Why does it matter?
   - What does it imply for Nordic sectors, M&A or private capital?
   - What is the most material supported second-order consequence, if any, and through what mechanism?
   - What might this change for Axcíon's priorities, decisions, sourcing or positioning?
   - How confident are we?
   - What challenges or weakens this interpretation?
7. conditional downstream signals:
   - **editorial potential:** a differentiated external angle and why it may be worth testing, or `none`; this is a lead for Content, not a publishable position; and
   - **next questions:** zero to three ranked follow-up questions or hypotheses, each naming why it could materially improve a decision or view; none executes automatically;
8. named gaps and direct attempts;
9. Source Access Log; structured-stat rows also record exact query/filters, unit, dimensions, dataset/table identity and raw-response path; and
10. discovery metadata: topic, geography, time period, retrieval/as-of date, intended use and source references.

The judgment is labelled **proposed interpretation** until the relevant founder/consumer authority approves it. Judgment generation is mandatory where the request concerns material macro, sector, trend, regulation or M&A implications; creating a separate Targeted House View artifact is not. Topic lenses are selected only where relevant, and `none` is valid for editorial potential, second-order consequence or follow-up questions when the evidence does not support them. External publication, advisory use or a consequential strategic decision requires explicit approval before the interpretation is presented as an Axcíon view. Internal orientation may retain the `proposed interpretation` label without an approval ceremony. RW never labels an interpretation publishable; Content and its publication gates own that decision.

The Deep lane retains its current stages for now and adds the generalized Unit Judgment Brief at the already-proven Stage 3→4 seam. Its analyst standard gains bounded macro/sector/trend lenses and asks for the most material supported second-order consequence where one exists, while retaining materiality, evidence-permission, causal-discipline and countercase safeguards. It does not gain an editorial appendix or follow-up-question quota. Deep uses the existing proposed/approved artifact distinction and fail-closed founder authority because its report-bound outputs need a durable analytical spine; it does not reuse the lighter Targeted approval treatment. The target is not to preserve every intermediate artifact forever—it is to avoid destabilizing active work while immediately improving retrieval, reuse, judgment and relay efficiency.

## 6. Non-goals and stop conditions

### Non-goals

- No general research platform or third independent workflow.
- No second generic `/research` router alongside the existing user-scoped `$research` capability.
- No Content-specific canonical interface.
- No new planning artifact, queue or auto-router.
- No shared research-agenda artifact or cross-project question queue in this phase.
- No separate “Axcíon Insight” artifact, store or workflow layer.
- No rule that a research question must serve two of strategy, market intelligence and Content.
- No mandatory editorial implication or fixed follow-up-hypothesis quota.
- No RW-issued publication-readiness or “publishable position” decision.
- No monitoring, watchlist, release-calendar or recurring-retrieval system.
- No paid-data exploration, benchmarking or procurement.
- No vector database, research-memory platform, knowledge graph or semantic index.
- No broad workspace research crawl by default; reuse is caller-authorized and authority-aware.
- No Nordic-specific hardwiring of the generic project source hierarchy; the Nordic registry is an optional domain seed.
- No general agent swarm or autonomous coordinator.
- No company-level or Buyer Fit research optimization in this phase.
- No broad Deep rewrite during Sector Phase A.
- No automation of founder authority, evidence permission or sufficiency decisions.

### Stop conditions

Stop and narrow the implementation if:

1. the Targeted contract starts absorbing caller-specific planning, editorial rules or a second routing decision—move that logic back to the consumer;
2. the Targeted implementation duplicates the generic `$research` entry point instead of composing with it—stop and settle capability ownership;
3. reuse requires a new storage/indexing service or a default broad workspace crawl—use caller-approved inventories/roots, existing `source-map.md`/source-pack patterns, repository search and basic metadata instead;
4. reused material cannot be classified as completed evidence, lead or decision context, or lacks adequate provenance/scope/freshness information—retrieve the gap rather than silently promote it;
5. the Targeted judgment section starts acquiring proposed/approved duplicate files, promotion scripts or Deep report orchestration—keep it in the single Targeted output;
6. topic lenses become an exhaustive checklist or force unsupported M&A, Axcíon or second-order implications—select only relevant lenses and allow `none`;
7. editorial potential becomes a publication decision, required output or Content-specific drafting instruction—return it to an optional lead and preserve Content's authority;
8. follow-up questions default to three, execute automatically or form a central queue—keep zero to three material suggestions inside the originating output;
9. Deep judgment implementation begins from scratch rather than generalizing the accepted local Unit Judgment Brief, carries Sector-specific verdict/chapter language into canonical files, or adds an implications appendix—stop and narrow to the portable core;
10. a statistics integration exceeds two bounded sessions or cannot emit query, filters, unit, dimensions, reproducible table identity and raw response—use a direct/manual pull and defer the wrapper;
11. path-passing causes a consumer to miss an approved judgment, permission input or other compact governing authority, or changes research substance, citation behavior or permission outcomes—restore content delivery for that authority and separate optimization from semantics;
12. a proposed provider, artifact or automation has no named macro/sector/trend consumer in the next eight weeks—defer it; or
13. a Deep simplification or propagation change would require active Sector worktrees to migrate mid-phase—record it and wait for a safe boundary.

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
- [Sector authority-aware source map](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/source-map.md:1>)
- [Sector judgment local-pilot outcome](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/logs/work-loop/analyst-judgment-layer-local-pilot.md:6>)
- [Sector judgment workflow integration outcome](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/logs/work-loop/judgment-layer-workflow-integration.md:6>)
- [Sector Unit Judgment Brief template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/templates/unit-judgment-brief-template.md:1>)
- [Sector analyst/judgment standard](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/reference/analyst-judgment-standard.md:1>)
- [Content evidence standard](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/evidence-standard.md:126>)
- [Content article workflow](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/article-workflow.md:113>)
- [Content launch amendment proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/workflow/launch-content-programme-amendment-plan.md:1>)
- [Website pipeline state](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-website/pipeline/pipeline-state.md:1>)

### Canonical RW and improvement reports

- [Canonical RW template](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md.template:1>)
- [Canonical stage instructions](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md:1>)
- [Canonical setup/deploy contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md:1>)
- [Canonical Research Executor SOP](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/sops/research-executor-gpt.md:1>)
- [Canonical required-reference/path-passing contract](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/docs/required-reference-files.md:1>)
- [Existing user-scoped research skill](</Users/patrik.lindeberg/.codex/skills/research/SKILL.md:1>)
- [Research Workflow token audit](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/token-audit-2026-05-18-research-workflow.md:1>)
- [Lean RW proposal](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/lean-research-workflow/proposal.md:1>)
- [Judgment and insight plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/canonical-research-workflow-judgment-and-insight-plan.md:1>)
- [Retrieval-layer plan](</Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow-fixes/plans/research-retrieval-layer-improvement-plan.md:1>)

## Final decision

**Build only the missing public-retrieval delta for macro, sectors and trends; add one tiny Targeted contract over the existing research capability with authority-aware reuse, lean proposed interpretation and conditional downstream signals; graduate the proven Deep Unit Judgment Brief with bounded topic lenses and second-order reasoning; reduce bulk relay without dropping governing authorities; defer everything else.**

This is the smallest package that can materially increase launch-period research volume without sacrificing the analytical interpretation that should distinguish Axcíon research.
