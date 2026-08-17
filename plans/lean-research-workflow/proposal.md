# Lean Canonical Research Workflow — Diagnosis and Proposal

**Date:** 2026-08-17
**Mandate:** Make the canonical Research Workflow (RW) materially leaner for the launch period: substantially more high-quality research with substantially less operator and AI effort, preserving sourcing reliability, factual accuracy, evidence/inference separation, traceability, freshness, and original judgment.
**Evidence base:** Four independent investigations of the actual implementation (not design intent). Full notes:
- `audits/working/rw-lean-spine.md` — end-to-end pipeline trace
- `audits/working/rw-lean-quality.md` — quality/governance layer verdicts
- `audits/working/rw-lean-deployment.md` — setup, config, lifecycle burden
- `audits/working/rw-lean-usage-evidence.md` — real-usage evidence across consuming projects

---

## Part 1 — Diagnosis

### 1.1 What RW actually is

The canonical RW (`workflows/research-workflow/`) is a **deep-study report factory**: 5 stages, a four-pass research model, ~50 traced steps, ~15+ operator gates per section, 30 commands, 50 directories, ~67,000 words of template/instruction text. It was designed for — and has only ever been used for — multi-week, multi-unit advisory research programmes.

### 1.2 The core finding: value is concentrated, process is not

Research value concentrates in **roughly 4 of the ~50 steps**:

1. Source execution (Research Execution GPT + Perplexity sessions — currently fully manual operator copy-paste),
2. Evidence extraction (facts-only extracts with claim IDs),
3. Sufficiency judgment (`/run-sufficiency` permission verdicts),
4. Synthesis/report writing (`cluster-synthesis-drafter`, `evidence-to-report-writer`).

Everything else is planning ceremony, QC-of-QC, routing, checkpointing, formatting, or workflow-improvement meta-process.

### 1.3 There is no fast path — and the ecosystem has already voted

- **No task-size routing exists anywhere.** A one-question fact check and a 10-chapter report enter the identical pipeline.
- Of 8 candidate research projects, **3 never adopted RW at all** (bespoke pipelines), and of the 5 that deployed it, **2 ran it zero times / stalled pre-report and built their own lighter parallel pipeline instead** (`axcion-content-programme`'s `article-workflow-v2.md`; `buy-side-service-plan`'s `output/` + `parts/drafts`). Only 2 deployments completed end-to-end.
- **No fast/tactical research has ever run through RW.** The high-volume launch research types (content/editorial evidence, tactical questions, buyer looks, quick market reads) currently have *no canonical home at all* — they either bypass the system or don't happen.

This is the central diagnosis: **RW is not a bottleneck that slows fast research down; it is a wall that fast research goes around.** Leanness for launch is less about trimming the deep pipeline and more about giving the 80% of research volume a lightweight canonical path that doesn't exist today.

### 1.4 Largest friction sources (evidence-cited)

| # | Friction | Evidence |
|---|----------|----------|
| 1 | **Manual execution relay**: operator hand-runs GPT/Perplexity sessions, pastes raw reports back, repairs UTF-8/mojibake on every intake | friction-log 2026-06-02 (research-pe-regime-shift); Step 2.2 trace |
| 2 | **Highest token load of any workflow in the repo**, driven by content-relay antipattern (full drafts passed through main session instead of paths). Fix already fully specified, still open | `audits/token-audit-2026-05-18-research-workflow.md`; est. 10k–50k tokens/section |
| 3 | **Setup cost 45–90 min** per project (13 placeholders, 4 gated templates, 19 symlinks, per-machine path grant) vs. claimed 15–20 min; no lighter deploy profile exists; `/new-project` refuses RW projects | rw-lean-deployment.md |
| 4 | **~15+ operator gates per section**, incl. an unconditional per-chapter blocking gate and a 4-subagent-hop chain (Steps 3.6→3.6d) just to approve editorial decisions | rw-lean-spine.md |
| 5 | **`quality-standards.md` (10,631 words) re-read/re-passed at 6–8+ points** across Stages 2–4; ~40% of its largest section is historical self-audit commentary, not operative rule | rw-lean-quality.md |
| 6 | **Unconditional meta-machinery**: 1,000+ lines of Work Loop v2 ownership scripting, 8 hooks on 5 lifecycle events (incl. auto-commit on every Write → dozens of commits/section), innovation registry — all deployed regardless of project size | rw-lean-deployment.md |
| 7 | **Dead and phantom machinery ships with every deploy**: permission verb-list enforcement claimed at Stage 4.3 but wired nowhere; `check-claim-ids.sh` unregistered; `friction-log-auto.sh` dead branch; `execution-agent` + Evidence Pack Compressor SOP defined but never invoked; `report/enrichment/`, `usage/`, `reference/templates/` orphaned; Stage 5 flagged 3+ months ago as lacking orchestration, unresolved | rw-lean-spine.md, rw-lean-quality.md, rw-lean-usage-evidence.md |
| 8 | **Duplicated QC**: `/review-chapter` vs `report-compliance-qc` near-identical checks at two pipeline points; chassis-provenance recovery text duplicated verbatim in two commands; two-mirror placeholder registry requiring dedicated drift checks | rw-lean-quality.md, rw-lean-deployment.md |

### 1.5 What is genuinely load-bearing (do not weaken)

The quality-layer audit confirms these earn their cost **for deep, high-consequence research**:

- **Claim IDs + claim-permission classes** (SUPPORTED / PROXY-SUPPORTED / ILLUSTRATIVE-ONLY / NOT-SUPPORTED) — the deepest overclaiming safeguard and the traceability backbone.
- **Source-class hierarchy** — cheap one-time setup that feeds permission grading.
- **The sufficiency gate** (`/run-sufficiency` Phase A + F) — the actual enforcement point where evidence is judged before prose exists.
- **Evidence-vs-inference separation and facts-only extraction** — a writing discipline more than a process cost.
- **Cross-model fact verification for finished chapters** — genuine independent check.
- **The finder-doesn't-judge principle** (Pass 2 vs Pass 3 separation) — the structural idea worth keeping even where the ceremony around it is cut.

---

## Part 2 — Proposal: Lean Canonical Research Workflow

### Design principle

> **Minimum sufficient research process for the required level of confidence.**
> Confidence requirements are set by *consequence and claim strength*, not by task existence. Process attaches to claims that need it, not to every task by default.

### 2.1 Three routes, auto-selected

| Route | For | Turnaround | Process | Operator touchpoints |
|-------|-----|-----------|---------|---------------------|
| **R1 Rapid** | Fast tactical questions, content/editorial evidence, quick market reads, single-fact checks | Minutes–1 hour | Single session, single command, no deployment, no stages. Direct retrieval (Perplexity API / web), output = one research note: answer, evidence table (claim → source → date), explicit inference labeling, gaps stated | 0 (operator reads the note) |
| **R2 Standard** | Sector scans, theme investigations, buyer profiles, commentary research, most launch-period work | Same day | One working directory, three phases in one or two sessions: **Plan** (auto-drafted brief, ≤10 questions), **Execute** (batched retrieval, API-first), **Synthesize** (one memo with claims-and-sources table + Axcíon judgment section). One consolidated QC pass, source-checking load-bearing claims only | 0–2 (optional brief confirm; memo review) |
| **R3 Deep** | Multi-week studies, advisory reports, high-consequence theses | Weeks | Current pipeline, slimmed per § 2.4–2.7: four-pass model, claim-permission machinery, sufficiency gate, per-wave chapter review retained | Reduced from ~15+ to ~6–8 gates per section |

**Routing is automatic.** A single entry point — `/research "<question or brief>"` — classifies the task by (a) expected output form (fact / memo / report), (b) consequence (internal orientation vs. external claim-bearing publication vs. advisory deliverable), (c) scope (question count, sector/multi-country breadth). Defaults: ambiguous → R2. Operator can override with one word (`/research quick …`, `/research deep …`). Escalation is one-way mid-flight: an R1 that turns out bigger becomes an R2 brief; an R2 memo can seed an R3 section (its evidence table imports as pre-approved extracts).

**R1/R2 require zero deployment.** They run as shared commands from `ai-resources` in whatever project the question arises in (output to that project's `output/research/`). Only R3 uses the deployed template. This eliminates the 45–90 min setup for the research types that dominate launch volume — the single largest throughput unlock available.

### 2.2 What stays (unchanged in substance)

1. Claim-permission classes + claim IDs — **R3 mandatory**, and the *concept* (every load-bearing claim carries a source and a strength label) propagates to R2/R1 in lightweight table form.
2. Source-class hierarchy (project-level, one-time).
3. `/run-sufficiency` Phases A + F as the hard Pass-3→Pass-4 gate in R3.
4. Facts-only extraction before synthesis in R3; finder ≠ judge ≠ writer separation.
5. Scarcity register (R3) — honest "we looked, it isn't there" records.
6. Cross-model fact verification — for finished R3 chapters and flagged R2 claims.
7. Per-chapter operator review in R3 — but batched (§ 2.5).
8. Evidence-vs-inference separation as an output-template requirement on **all** routes.

### 2.3 What should be simplified

1. **`quality-standards.md`: compress by ~50%** into an operative rule-table + historical appendix split. It is re-read 6–8× per section; every saved word pays repeatedly.
2. **Merge `/review-chapter` into `report-compliance-qc`** — one chapter QC, not two near-identical ones.
3. **Collapse the editorial chain** (Steps 3.6 → 3.6b → 3.6c → 3.6d, four subagent hops) into one QC pass with auto-approve/pause logic.
4. **Deduplicate chassis-provenance recovery text** (verbatim ~25 lines in two commands) into one referenced doc section.
5. **Kill the two-mirror placeholder registry** — one machine-readable manifest; delete the SETUP.md mirror and its drift-check steps.
6. **Deferred-feature prose out of live rule text** (Phase B counter-search, process ceiling) → deferred appendix; live text describes what runs.

### 2.4 What should be automated

1. **The execution relay (highest-value automation).** Wire the already-defined-but-never-invoked `execution-agent` to run Perplexity via API and GPT-5 via API for retrieval sessions, writing raw reports directly to disk. This deletes the manual paste loop, the recurring mojibake repair, and most of `/intake-reports`. The cross-model rule is preserved: the assigned tool still executes the research — Claude automates the *relay*, not the *work*. Where the Research Execution GPT (CustomGPT) is not API-reachable, fall back to batching all session prompts into a single operator paste block per wave.
2. **Content-relay → path-passing refactor** — already fully specified in `audits/token-audit-2026-05-18-research-workflow.md`, still open, est. 10k–50k tokens/section. Implement as specified; highest token ROI, zero design work remaining.
3. **Auto-commit consolidation** — per-Write commit hook → one consolidated commit per step/session.
4. **Route classification** at `/research` intake (the operator should never manage workflow complexity manually).

### 2.5 What becomes conditional (was mandatory)

1. **Per-chapter blocking gate → per-wave batch review** in R3: chapters accumulate; operator reviews a batch; unconditional halt only for chapters whose QC flagged permission-class violations.
2. **Cross-model fact verification**: after prose review passes, not on every revision; R2 only for flagged/load-bearing claims.
3. **Country-parity check, transaction table**: only when the project profile declares multi-country scope / named-transaction content (already partly conditional — make it profile-driven, not skill-side no-op).
4. **Style/jargon-gloss/formatting passes (Stage 5 polish)**: only for external-facing deliverables; internal research memos ship at R2 formatting.
5. **Work Loop v2 bundle (1,000+ lines) + Codex hooks**: opt-in deploy flag for projects that actually run Codex-shared sessions — not default RW freight.
6. **Stage-1 planning ceremony in R3**: task plan + research plan + answer specs remain, but with **one** consolidated operator gate (approve the plan pack) instead of four sequential gates; QC verdicts attach to the pack rather than gating individually.

### 2.6 What should be removed entirely

1. Dead guards: `check-claim-ids.sh` (unregistered), `friction-log-auto.sh` dead branch.
2. Orphaned infrastructure: `report/enrichment/`, `usage/`, `reference/templates/`, Evidence Pack Compressor GPT SOP (if the execution-agent automation supersedes it), forked non-symlinked copies of shared infra (`split-log.sh` etc. → symlink to canonical).
3. The **phantom check**: quality-standards' claim that verb-list enforcement runs at Stage 4.3. Either wire it into the merged chapter QC (small cost, real value — recommended) or delete the claim; a documented-but-nonexistent control is worse than neither.
4. Innovation registry + detect-innovation hook from the RW template (workspace-level `/innovation-sweep` already owns this concern).
5. The 4-gate sequential Stage-1 approval ladder (absorbed into § 2.5.6).

### 2.7 Routing summary (question 6 of the brief)

Consequence, not effort, selects the route:

- **Internal orientation, single question, no publication** → R1.
- **Claim-bearing but internal or single-deliverable output** (LinkedIn post evidence, sector memo, buyer profile) → R2.
- **External advisory deliverable, thesis-grade, or multi-section report** → R3.
- Ambiguity → R2, escalate one-way if the evidence demands it.

### 2.8 New end-to-end shape

```
Research need
   │
   ▼
/research "<question>"          (any project; no deployment)
   │  auto-classify: R1 / R2 / R3 (operator can override)
   │
   ├─ R1: retrieve (API) → research note w/ evidence table → done (minutes)
   │
   ├─ R2: auto-brief (≤10 Qs) ─[optional confirm]→ batched API execution
   │       → synthesis memo (claims+sources table, judgment section)
   │       → one consolidated QC pass → operator reads → done (same day)
   │
   └─ R3: deployed project template (slimmed):
          Plan pack ─[1 gate]→ automated execution relay → extracts
          → sufficiency gate (Phase A+F) → synthesis → per-wave chapter
          review ─[batch gate]→ cited final       (weeks, ~6–8 gates)
```

---

## Part 3 — Staged implementation plan

Ordered by throughput-gain per unit of implementation effort. Waves are independently shippable.

**Wave 1 — unlock launch volume (days of work; largest ROI)**
1. Build `/research` with R1 + R2 routes as a shared ai-resources command (route through `/develop-ai-resource` → `/create-skill` per repo rules; this proposal is the qualification evidence). R3 initially = "hand off to deployed RW."
2. Wire `execution-agent` API execution for Perplexity (and GPT-5 where reachable); fall back to batched paste blocks. Kills the manual relay + mojibake friction for all routes.
3. Apply the already-specified content-relay → path-passing refactor (token-audit 2026-05-18). No design work; just implementation.

**Wave 2 — slim the deep pipeline (R3) (roughly a session or two)**
4. Compress `quality-standards.md` (rule tables + appendix); dedupe chassis-provenance text.
5. Merge chapter QCs; collapse the editorial 4-hop chain; consolidate Stage-1 gates into one plan-pack gate; per-wave batch chapter review.
6. Delete dead/orphaned machinery (§ 2.6); wire or delete the phantom verb-list check.

**Wave 3 — deployment and lifecycle (cleanup tier)**
7. Lean deploy profile: Work Loop v2 and Codex hooks opt-in; single-manifest placeholder resolution; auto-commit consolidation; hook set trimmed by default.
8. Route-escalation plumbing (R2 memo → R3 pre-approved extracts); retire `/sync-workflow` mirror drift-checks accordingly.

**Explicitly not proposed:** lowering evidence standards anywhere. R1/R2 outputs carry the same evidence-vs-inference discipline and per-claim sourcing as R3 — in table form rather than pipeline form. The confidence machinery (permission classes, sufficiency gate, scarcity register) remains fully intact where consequence demands it.

---

## Part 4 — Open items and surfaced conflicts

1. **Conflict — "research tiers" previously rejected.** The active deploy-fitness mission recorded differentiated research tiers as a rejected non-negotiable, reopenable only on new evidence. This proposal's mandate (operator brief, 2026-08-17) explicitly directs consideration of differentiated routes, and the usage evidence (2 of 5 deployments bypassing RW with self-built lighter pipelines; zero fast research ever run through RW) is exactly the new evidence contemplated. **Recommended resolution: treat the 2026-08-17 brief as the reopening authority and update the mission contract when Wave 1 is approved.** Flagged here rather than silently overridden.
2. **Deferred item to disposition:** the R1 citation-fidelity-audit subagent (deferred 2026-04-24, reminder bound to next `/deploy-workflow`/`/sync-workflow`). Recommendation: fold into the merged R3 chapter QC as a conditional check, or close as superseded by this redesign. Operator call at Wave 2.
3. **Thread 7 frozen acceptance test** (verification-posture wiring, cites a nonexistent config enum) — needs an operator decision; unaffected by, but adjacent to, Wave 2 item 6.
4. **Prior-lesson guardrail for implementation:** the retired pre-deploy gate's audit lesson — *"premises that assert what a file lacks survive verification; premises that predict what the runtime does fail it"* — applies to this proposal too. Wave items 2 (API reachability of the CustomGPT) and 6 (phantom check wiring) must be verified by execution, not by reading.
