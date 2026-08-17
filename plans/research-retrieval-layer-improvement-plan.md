# Research Workflow — Data Retrieval Layer Improvement Plan

**Status:** Proposed
**Date:** 2026-08-17
**Scope:** macro, sector and trend research (Nordic macro, M&A/private-capital activity, sector structure, industry trends, regulation, technology/demand trends, market statistics, valuation evidence). Explicitly **not** individual-company research.
**Inputs:** full inspection of the canonical research-workflow template and its filled project instances; three external research sweeps (Nordic/European statistical & regulatory sources; M&A/PE/valuation sources; AI retrieval methods and tooling), verified against provider sites as of August 2026.
**Relationship to sibling plans:** this plan details the retrieval half of `plans/lean-research-workflow/proposal.md` (whose §2.4 item 1 names the execution relay as the highest-value automation) and adopts the Deep-mode acceptance target ("full source ladder; systematic counter-search") from `plans/canonical-research-workflow-judgment-and-insight-plan.md`. Neither sibling plan cites the other; this plan should be sequenced inside the lean plan's Wave 1, not run as a third competing track.

---

## Summary

The workflow's retrieval layer is a **sophisticated prompt compiler with no runtime**. It is genuinely good at deciding *what to ask* (source-class ladders, stop conditions, false-scarcity checks, local-language blocks) and has **zero machinery for getting it**: every piece of external evidence enters via the operator manually running browser sessions and pasting output back. There is no API call, no statistical-database path, no PDF fetch, no mechanical record of what was actually searched.

The fix is not more process or more databases. It is:

1. **Give the compiler a runtime** — one thin script layer that executes Perplexity queries, statistical-API pulls and direct URL fetches, writing raw reports and a ground-truth Source Access Log to disk.
2. **Encode the analyst's instinct as a filled source registry** — a canonical Nordic/European source-routing table (almost entirely free sources) so "which source for which question" is answered before any web search runs.
3. **Canonize one already-made ruling** — Perplexity output is a lead, not a source; a Perplexity negative is not evidence of absence.

Estimated new recurring cost: **~€300–800/yr** (one news-API subscription). Everything else in the core plan is free.

---

## 1. Where the current retrieval workflow is weakest

Findings from the repo inspection, ordered by consequence.

### 1.1 No programmatic retrieval exists at all
Every external fact arrives through a manual browser relay (Research Execution GPT, Perplexity Pro UI, Codex) and hand-pasting, with recurring UTF-8/mojibake repair on intake. The `execution-agent` that declares "You handle external API calls (GPT-5 or Perplexity)" is a phantom — no script, no key management, no endpoint, never invoked. Claude's own WebSearch/WebFetch are permitted in settings but invoked by zero commands. The single API-like parameter in the whole workflow (`search_recency_filter`) is an instruction telling the *operator* which UI toggle to set.

### 1.2 No structured-data path
No handling of statistical databases (Eurostat, SCB, SSB, DST, Statistics Finland), no registry fetch, no PDF table extraction. For Nordic macro/sector work, official statistics carry most of the quantitative evidence — the workflow can only reach them as search-engine strings. Recorded consequence: Perplexity returned nothing from three Finnish government repositories across two attempts while plain web search found the document immediately.

### 1.3 False scarcity is the dominant, best-evidenced failure mode
Three independent recorded causes: a wrong domain (`administergroup.fi` vs `.com` — the company's own filings never reached), unindexed government repositories, and unsearched top-of-ladder surfaces. False scarcity is the dangerous direction: it hardens into a "confirmed scarcity" register entry that suppresses future search effort. The best control against it (extract-verifier Check 7) reads a Source Access Log that is currently **GPT-self-reported**, and silently degrades to "unverifiable" when the log or the source hierarchy is missing.

### 1.4 The source intelligence is project-local; canonical ships empty
The source-class hierarchy, named-source appendix, source map and executor-routing guide — the layer that encodes "which source answers which question" — exist only as 100%-placeholder templates canonically. Real intelligence lives in individual project instances and diverges (a German-scoped routing rule was found governing a Finland programme; the routing guide is missing entirely from one of eleven worktrees). `source-class-mapper` is a no-op on every fresh deployment until someone hand-authors the hierarchy.

### 1.5 One critical ruling is uncanonized
The 2026-08-14 operator ruling — Perplexity citations are leads, not accessed sources; unopened material merges as `[SUPPLEMENTARY — LEAD]` with no claim ID and no coverage-verdict movement; a Perplexity negative is never evidence of absence — exists in **one worktree only**. Canonical `stage-instructions.md` Step 2.S4 still merges Perplexity output into approved extracts.

### 1.6 Half-wired controls and no empirical baseline
The ladder-depth field is declared at the consumer end but produced by nothing (silent grading error for genuinely deep-ladder evidence). The reciprocal stop rule ("may not stop until a stop condition is true") is stated intent, implemented nowhere at Pass 3. The research-quality log has zero rows ever written, so there is no measured baseline for first-pass approval, re-extraction, or scarcity rates. ~33% of deep citation permalinks on one delivered project were dead within four days, and the Evidence Pack lane has no Source Log at all.

### 1.7 Nordic specificity is hardcoded and drifting
Language blocks are properly parameterized, but per-country session ordering and country→language routing are hardcoded to SE/NO/FI across three surfaces with no consistency check. Fine while every project is SE/NO/FI; already bitten once (see 1.4).

---

## 2. Which sources and tools for which research type

Two structural facts make this cheap: **five Nordic statistics offices share one API grammar (PxWeb)** and **Eurostat, ECB, OECD, IMF, BIS and Norges Bank share another (SDMX)**. Two query patterns cover nearly all official Nordic/European data — one thin wrapper, not six integrations.

### 2.1 Source-routing table (the registry to canonize)

| Research need | Primary source(s) | Secondary / fallback | Access |
|---|---|---|---|
| Nordic macro series (GDP, inflation, employment, trade) | SCB, SSB, DST, Statistics Finland via **PxWeb APIs** | Eurostat, OECD | Free, no auth |
| Rates & FX | **Norges Bank** (SDMX REST, no auth), **Riksbank** (new REST; SOAP is dead), Bank of Finland (`boffsaopendata.fi`) | ECB Data Portal | Free |
| Danish monetary/financial stats | **DST Statistikbanken** (Nationalbanken has *no* separate API — its data lives in DST) | — | Free |
| Eurozone / cross-country comparison | **Eurostat** (JSON-stat "Statistics" API or SDMX 3.0), **OECD Data Explorer** (old OECD.Stat is dead since July 2024) | IMF, World Bank, BIS (banking/credit niche) | Free, no auth |
| Sector structure (counts, turnover, value added, employment by NACE) | **Eurostat SBS** + national PxWeb sector tables | Business registries below | Free |
| Business demography / sector composition | **Brønnøysund** (open API, no key), **CVR** (open, registration for bulk), **Bolagsverket free bulk files** (new under EU high-value-datasets), PRH/YTJ (open, thin fields) | allabolag et al. — skip (scrape-only) | Free |
| EU regulation & policy | **EUR-Lex / Cellar** (REST + SPARQL + filtered RSS — the only real API in this category), ESMA (`esma_data_py`) | Commission "Have Your Say" — manual only, no confirmed API | Free |
| Nordic FSA monitoring | Finanstilsynet NO (RSS hub), FIN-FSA via BoF open-data portal | FI (SE) RSS; Finanstilsynet DK + competition authorities — periodic manual check only | Free |
| Nordic PE/M&A market activity | **Argentum State of Nordic PE**, **Invest Europe activity statistics**, **KPMG Nordic Deal Trend Report** (quarterly), national associations (SVCA, NVCA, FVCA, Active Owners Denmark) | Deloitte Nordic sector M&A reports; PitchBook's *free* Nordic Private Capital Breakdown; Preqin free tier | Free |
| Nordic mid-market valuation multiples | **Dealsuite Nordic M&A Monitor** (biannual, advisor-survey, €1m–€200m segment), KPMG/Deloitte trend reports | **Damodaran (NYU)** as global baseline; Argos Index *(eurozone-only — only Finland in scope; flag every citation)* | Free |
| Deal-flow news | **Nordic Financial News** (API + MCP + Claude Code skill; aggregates/translates 70+ Nordic sources — solves the DI/DN/Børsen/Kauppalehti paywall problem by proxy) | EU-Startups RSS, ArcticStartup, Nordic9 free tier | ~€290–790/yr |
| Deal-level database (only if later justified) | **Dealroom** (~€12k/yr, real API/MCP, explicit Nordic strength) | Unquote Nordics package (PE-specific) | Paid — defer |

### 2.2 What to explicitly skip
Mergermarket/ION, PitchBook subscription, Preqin paid, Capital IQ, Dealogic, Tracxn, Grata (cost or region mismatch for market-level work); Kroll cost-of-capital (fairness-opinion-grade only); Statista/Euromonitor as automation targets (manual lookups only); the thin community MCP servers for Eurostat/ECB (1-commit projects — use Python clients instead).

### 2.3 Verify-before-relying list
Clearwater Multiples Heatmap (last confirmed edition Q3 2022); a PwC Nordic M&A report equivalent to KPMG/Deloitte (not confirmed to exist); IBISWorld Nordic coverage (API exists, regional depth unconfirmed); Riksbank key/registration requirements on the new REST portal.

### 2.4 Retrieval tooling (the "how")

| Job | Tool | Note |
|---|---|---|
| General web retrieval workhorse | **Perplexity API** with domain/recency/language filters | ⚠ Sonar Chat Completions API retires **2026-09-27** in favour of the Agent API; parameter carry-over unconfirmed. Build against the Agent API from the start. |
| Finding PDFs/reports; genuine local-language recall | **Serper.dev** (or SerpAPI with legal shield) — Google operators `site:`/`filetype:pdf` with `gl`/`hl` | The one gap Perplexity doesn't cover; Google's index is strongest for Swedish/Norwegian/Danish/Finnish. Named legal-exposure tradeoff: Google v. SerpAPI ToS question unresolved. |
| Statistical APIs | **`sdmx1`** (one client for Eurostat + ECB + OECD + 40 providers) + **`pxwebpy`/`pyaxis`** for the PxWeb five | Plain Python, callable from Bash — no MCP infra needed |
| PDF ingestion | **Claude native PDF reading, chunked** (fetch to disk first — the Read tool can't fetch URLs and caps at 20 pages/call); **Jina Reader** as free fallback for scanned/numeric-heavy documents | Skip Firecrawl/marker/docling at this scale |
| Independent-index cross-check for news triangulation | Brave Search API or Tavily | Optional, cheap |

---

## 3. How the retrieval workflow should change

Ordered changes; each preserves the existing (good) grading and QC layer and the Cross-Model Rule — the assigned tool still executes the research; automation replaces the *relay*, not the *work*.

**C1 — Wire the execution relay (make `execution-agent` real).**
One script (or small script set) under the workflow's `scripts/`: takes a session prompt file, calls the Perplexity **Agent API** with the domain/recency/language parameters the prompt-creator already specifies as prose, writes the raw report to `execution/raw-reports/` in UTF-8. Deletes the paste loop, the mojibake repair, and most of `/intake-reports` for the Perplexity lane. The Research Execution GPT (CustomGPT) has **no public API** — that lane stays manual, mitigated by batching all session prompts into one paste block per wave (per the lean plan). Verify API reachability by execution, not assumption.

**C2 — Ship the canonical source registry filled, not blank.**
Turn §2.1 into a canonical, machine-readable named-source appendix + evidence-need→source-class table for the macro/sector/trend domain (the current template is 100% placeholder, which makes `source-class-mapper` a no-op on every new project). Projects then *specialize* a working registry instead of authoring one from nothing. This is the single biggest step toward "M&A-analyst instinct": source-first routing — decide which database/registry/report answers the question **before** any general web search runs. Include the executor-routing guide (currently project-only, missing from one worktree) in canonical `reference/`.

**C3 — Add the structured-data lane.**
`fetch-stats` script wrapping `sdmx1` + `pxwebpy`: input = series/table request, output = CSV/JSON evidence file with source URL, retrieval date, and table identity. Statistical evidence stops being "whatever a search engine surfaced about SCB" and becomes a direct, citable pull. Registry pulls (Brønnøysund, CVR) join the same lane later if needed.

**C4 — Make the Source Access Log mechanical ground truth.**
Every scripted retrieval (C1, C3, PDF fetches) emits Source Access Log entries automatically (URL, accessed Y/N, HTTP status, date). This converts the workflow's best anti-false-scarcity control (Check 7) from advisory-on-self-reported-data to deterministic, and closes the Evidence-Pack-lane no-log gap. Add a domain-resolution precheck: before any scarcity verdict, resolve the named organisation's actual domain (the `.fi`/`.com` failure).

**C5 — Canonize the Perplexity ruling.**
Promote the 2026-08-14 worktree ruling into canonical `stage-instructions.md`: Step 2.S4 gains the source-opening precondition; unopened material merges as `[SUPPLEMENTARY — LEAD]` (no claim ID, no coverage movement); **a retrieval-tool negative is never evidence of absence** — a scarcity verdict additionally requires the C4 log to show the ladder's named surfaces were actually opened, or a direct fetch attempt against the named repository.

**C6 — Local-language: keep the design, add the missing index and test it.**
The parallel (not fallback) local-language blocks are the right design — keep them. Route local-language passes through Serper/Google (`gl`/`hl`) where the executor's search engine under-serves Nordic languages; add a cheap LLM query-expansion step generating the sv/no/da/fi variants from the curated term pairs. Run the empirical pilot once: same topic, parallel English vs native queries per tool — no vendor's Nordic recall is verified anywhere.

**C7 — Finish the half-wired controls (small fixes).**
(a) Producer emits the ladder-depth field (activates the already-built auto-downgrade). (b) Refined cluster memos carry the stop-condition/completeness field so the reciprocal rule becomes checkable at Pass 3. (c) Start writing rows to `research-quality-log.md` — without a baseline, none of the above is measurable. The existing five stop conditions and role-based triangulation need **no redesign** — they match or exceed current industry practice (3/2/1-source tiers, declared sufficiency bar, iteration ceiling); the problem is enforcement, not design.

**C8 — Fix the Nordic-hardcoding drift (housekeeping).**
Single canonical surface for country→language/source routing (registry from C2), consumed by prompt-creator and manifest-creator, replacing the three divergent hardcoded copies.

---

## 4. What can be automated

**Automate now (deterministic, high ROI):**
- Perplexity execution + raw-report intake (C1) — removes the operator relay per session.
- Statistical pulls via PxWeb/SDMX scripts (C3).
- Source Access Log emission + domain precheck (C4).
- Direct PDF fetch-to-disk + chunked native reading for named reports.
- **Monitoring watchlist:** RSS polling (EUR-Lex filtered feeds, Finanstilsynet NO, FIN-FSA/BoF, EU-Startups) plus a small release calendar for the periodic reports (KPMG quarterly, Dealsuite biannual, Argentum/Invest Europe/association annuals, PitchBook Nordic breakdown) — a per-session "what's new in scope" check instead of rediscovering each report by search.
- Nordic Financial News via its API/MCP — paywalled Nordic dailies by proxy.

**Do not automate:**
- The Research Execution GPT lane (no API — batch the paste instead).
- Nordic FSA (DK/SE) and competition-authority monitoring beyond periodic manual checks (no feeds worth building against; low volume).
- Statista/Euromonitor/premium platforms (no accessible APIs at sane cost).
- Judgment steps: source-class mapping review, evidence grading, sufficiency verdicts stay with the existing skill/QC layer.

---

## 5. Launch-month priorities (ranked)

The few improvements with the most material effect on speed and quality, in order:

| # | Improvement | Why first | New cost |
|---|---|---|---|
| **P1** | **C1 execution relay** (Perplexity Agent API script + raw-report intake) | Removes the largest per-session time sink; unblocks everything downstream. Deadline-sensitive: build against the Agent API (Sonar retires 2026-09-27). | API usage (~$3–15/1M tok + search fees) |
| **P2** | **C2 filled canonical source registry** + adopt the §2.1 free source stack | Encodes analyst instinct; turns `source-class-mapper` from no-op to live on day one; kills over-dependence on general web search | Free |
| **P3** | **C5 Perplexity ruling canonized** + **C4 mechanical Source Access Log** | Directly attacks the dominant recorded failure mode (false scarcity); ruling is already made, just unpropagated | Free |
| **P4** | **C3 statistical-data lane** (`sdmx1` + `pxwebpy`) | Closes the biggest capability gap for macro/sector evidence; two grammars cover ~all official data | Free |
| **P5** | **Nordic Financial News subscription** + monitoring watchlist | Highest automation ROI per euro in the entire source sweep; continuous deal-flow awareness | ~€290–790/yr |

Deferred beyond launch months: C6 pilot and Serper adoption (do when a local-language-heavy project starts), C7/C8 (fold into the next canonical-maintenance session), Dealroom (revisit only when deal-level screening becomes a recurring mandate), the lean plan's bounded multi-agent experiment (owned by the judgment plan).

---

## Open items / verification before build

1. Perplexity Agent API: confirm domain/recency/language filter and structured-output parity by **execution** before P1 ships.
2. Riksbank REST API registration requirements; SCB/SSB PxWebApi **v2** endpoints (don't code against v1 docs).
3. Nordic Financial News: verify current tiers/pricing and MCP quality on the free tier before subscribing.
4. §2.3 verify-before-relying list (Clearwater, PwC, IBISWorld).
5. Coordinate sequencing with `plans/lean-research-workflow/proposal.md` Wave 1 — same owner, same wave; do not run as parallel tracks.
