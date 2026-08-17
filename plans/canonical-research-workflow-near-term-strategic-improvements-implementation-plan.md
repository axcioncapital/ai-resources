# Canonical Research Workflow — Near-Term Strategic Improvements

**Status: Proposed**
**Date:** 2026-08-17
**Author:** Claude (Work Loop v2 task `canonical-rw-near-term-implementation-plan`, Unit 1)
**Method:** Axcíon Repository Development Operating Standard (`skills/axcion-repository-development/SKILL.md` + `references/operating-standard.md`)

This plan reconciles the three 2026-08-17 proposals — `plans/lean-research-workflow/proposal.md`, `plans/research-retrieval-layer-improvement-plan.md`, and `plans/canonical-research-workflow-judgment-and-insight-plan.md` — into one sequenced, repository-grounded near-term implementation path for the canonical Research Workflow (RW). All three sources are **proposed, not approved**; nothing in this plan converts a proposal into authority. Choices that require the operator are collected in § 7 and gate the slices that depend on them.

---

## 1. Operating outcome

During the launch period, Axcíon needs **substantially more research output at unchanged evidence standards, with substantially less operator and AI effort**. Concretely, the improved canonical RW must make three things possible that are not possible today:

1. **Fast and standard research has a canonical home.** Today a one-question fact check and a ten-chapter report enter the identical ~50-step pipeline, and the recorded consequence is that fast research bypasses the system entirely (3 of 8 candidate projects never adopted RW; 2 of 5 deployments built lighter parallel pipelines; zero fast research has ever run through RW — `plans/lean-research-workflow/proposal.md` § 1.3, evidence in `audits/working/rw-lean-usage-evidence.md`).
2. **The retrieval layer has a runtime.** Today every external fact arrives by the operator manually running browser sessions and pasting output back, with recurring mojibake repair — the workflow decides *what to ask* well and has no machinery for *getting it* (`plans/research-retrieval-layer-improvement-plan.md` § 1.1).
3. **False scarcity is mechanically resisted.** The dominant recorded retrieval failure mode is "we didn't find it" hardening into "it isn't there"; the best existing control reads a self-reported access log (`plans/research-retrieval-layer-improvement-plan.md` § 1.3).

For whom: the operator (less relay and gate labour per unit of research) and the consuming projects (Sector Intelligence, Content Programme, and tactical questions that currently have no home). Why now: launch-period research volume is the binding constraint, and one already-made operator ruling plus one fully-specified refactor are sitting unapplied.

## 2. Verified current substrate

Load-bearing current-state claims, each checked by inspection on 2026-08-17 in this checkout. Reuse decisions follow each finding.

| # | Finding | Evidence (inspected) | Disposition |
|---|---|---|---|
| 1 | The canonical RW is a deep-report pipeline: 30 commands, 5 stages, no fast path, no `scripts/` runtime directory | `ls workflows/research-workflow/.claude/commands/` → 30 files; `workflows/research-workflow/scripts/` does not exist | Keep as the deep route; do not slim it in the near term (deferred, § 8) |
| 2 | `execution-agent` exists and is wired **only** into chapter verification, not Stage-2 retrieval | `workflows/research-workflow/.claude/agents/execution-agent.md` exists; `grep -rln "execution-agent" workflows/research-workflow/.claude/commands/` → only `verify-chapter.md` | Reuse as the seed of the retrieval runtime **if** gate G2 approves (§ 7) |
| 3 | The content-relay → path-passing refactor is fully specified and still open | `audits/token-audit-2026-05-18-research-workflow.md` exists (8.3 KB) | Implement as specified — Slice S1 |
| 4 | The canonical Perplexity merge step has no lead-vs-source precondition | `workflows/research-workflow/reference/stage-instructions.md:77` (Step 2.S4) merges QC-approved supplementary results and tags `[SUPPLEMENTARY]`; no `LEAD` handling found (searched `stage-instructions.md` for `lead, not` / `LEAD]` — no match) | Canonize the 2026-08-14 operator ruling — Slice S2 |
| 5 | The canonical source-intelligence layer ships empty | `workflows/research-workflow/reference/source-class-hierarchy.template.md`: 16 `{{…}}` placeholder tokens in 108 lines | Ship it filled for the macro/sector/trend domain — Slice S3 |
| 6 | There is no measured quality baseline | `workflows/research-workflow/logs/research-quality-log.md`: header and column definitions only, zero data rows | Start writing rows as part of S4/S5 acceptance evidence |
| 7 | The Sector Intelligence judgment-layer pilot exists locally with passing regression suites, and canonical adoption was explicitly deferred | `projects/axcion-sector-intelligence/reports/analyst-judgment-layer-implementation-research-v1.md` and `projects/axcion-sector-intelligence/logs/work-loop/{analyst-judgment-layer-local-pilot,judgment-layer-workflow-integration}.md` exist | Run its representative operating trial (judgment plan Unit 1) as the near-term judgment step — Slice S6; canonical adoption stays deferred |
| 8 | Canonical skill edits take **live effect** in deployed projects | `logs/missions/research-workflow-deploy-fitness.md` § Pre-deployment corrections: two live projects symlink canonical skills; the mission's S11/S13/S14 record documents live blast radius | Every canonical slice enumerates live consumers before editing (risk R4, § 9) |
| 9 | The deploy-fitness mission is **active** and carries an operator "explicitly not to be built" list including **research tiers** and **Stage-2 execution automation** | `logs/missions/research-workflow-deploy-fitness.md` frontmatter `status: active`; § In/Out of scope, operator S10 list | Live authority conflict with the lean and retrieval proposals — gates G1/G2 (§ 7) |
| 10 | No more current approved canonical RW plan or authoritative current-state record supersedes the above | Searched `plans/` (listing + `grep -ril "research.workflow"`): only the three source proposals are RW plans; `logs/missions/`: `research-workflow-deploy-fitness.md` (active) and `promote-rw-canonical.md` (closed 2026-06-12, archived stub); `logs/work-loop/` listing: only this task is RW-named | The active mission and the three proposals are the complete authority surface this plan must reconcile |

## 3. Reconciling the three proposals into one sequence

The three proposals are not three roadmaps to append; they occupy three layers of one system, plus one collision that must be resolved once:

- **The lean proposal** is the *shape* layer: route research by consequence (R1 Rapid / R2 Standard / R3 Deep), automate the relay, slim the deep pipeline later.
- **The retrieval plan** is the *runtime* layer: it explicitly subordinates itself to the lean plan's Wave 1 ("this plan should be sequenced inside the lean plan's Wave 1, not run as a third competing track" — its § Relationship note) and details the execution relay, source registry, and anti-false-scarcity mechanics.
- **The judgment plan** is the *output-quality* layer: House View approval before content, insight extraction, and Light/Standard/Deep research modes. Its own sequence already begins with a **local, non-canonical operating trial** (Unit 1) and forbids canonical rollout before that trial.
- **The collision:** the lean plan's R1/R2/R3 routes and the judgment plan's Light/Standard/Deep modes are two vocabularies for the same assignment-level axis ("how much workflow machinery does this assignment need"). Neither proposal cites the other (verified: `grep` for each sibling's name in the other two files matches only in the retrieval plan). Building both would create the "three unrelated research workflows" the judgment plan itself lists as a non-goal. This plan treats them as **one axis decision** for the operator (gate G1) with one vocabulary to be chosen at that gate.

**Cross-source disposition of the major themes:**

| Theme | Source(s) | Disposition |
|---|---|---|
| Content-relay → path-passing refactor | lean § 2.4.2 | **Near-term implementation** (S1) — no open design, no authority conflict |
| Perplexity lead-not-source ruling canonization | retrieval C5 | **Near-term implementation** (S2) — operator ruling already made 2026-08-14; slice verifies the ruling record before editing |
| Filled canonical source registry | retrieval C2, P2 | **Near-term implementation** (S3), with an adjacency confirmation at the gate session (§ 7, G5 note) |
| Tiered routes / research modes (R1-R3 ≡ Light/Standard/Deep) | lean § 2.1, judgment § modes | **Prerequisite decision gate** (G1) — conflicts with the active mission's S10 rejection of research tiers; new usage evidence exists but reopening is the operator's |
| Execution relay + mechanical Source Access Log + statistical lane | lean § 2.4.1; retrieval C1, C3, C4, P1, P4 | **Prerequisite decision gate** (G2) — conflicts with the mission's S10 "Stage-2 execution automation" rejection; build only after reopening |
| `/research` entry command (R1+R2) | lean Wave 1.1 | **Near-term implementation after G1** (S5), qualified through `/develop-ai-resource` per repo rules |
| Judgment layer: representative local operating trial | judgment Unit 1 | **Near-term implementation** (S6) — local project only, no canonical change, no conflict |
| Judgment layer canonical adoption (Units 2–7) | judgment Units 2–7 | **Deferral** — the judgment plan itself forbids rollout before the Unit 1 trial; re-plan on its evidence |
| Deep-pipeline slimming (quality-standards compression, QC merge, gate consolidation) | lean Wave 2 | **Deferral** — real value, but horizontal refactor of a working pipeline; do after the volume unlock lands |
| Deployment/lifecycle leaning (opt-in Work Loop bundle, manifest, hooks) | lean Wave 3 | **Deferral** |
| Paid subscription (Nordic Financial News) + monitoring watchlist | retrieval P5 | **Prerequisite decision gate** (G3) — recurring spend is operator-owned; recommend deferring the spend until S4 operates |
| Bounded multi-agent experiment | lean; judgment Unit 9 | **Later experiment** — owned by the judgment plan's sequence, after mode calibration |
| Local-language pilot (C6), half-wired controls (C7), Nordic hardcoding (C8) | retrieval | **Deferral** — retrieval plan itself defers these beyond launch months |
| Research-mode empirical calibration (judgment Unit 8) | judgment | **Later experiment** — needs the routes/modes to exist first |
| Deploy-fitness threads 3–8, F-7, deferred cleanups | active mission | **Not absorbed.** They remain owned by `logs/missions/research-workflow-deploy-fitness.md`. Overlap note: mission thread 6 (scarcity search record) is directly strengthened by S4's mechanical Source Access Log; coordinate at the gate session (G5) rather than double-owning |

## 4. Operating mode, specification, and ticket split

**Mode: Normal** (operating standard § 3). The remaining planning uncertainty — which slices, in what order, behind which gates — is resolvable in one effective planning context, and this document is that context. The work is not Small/Clear (material product decisions exist: tiers, automation reopening, spend), and it is not Foggy: the open decisions are enumerable, separable, and all route to the same operator session rather than forming a dependent decision web. Escalate to `/wayfinder` only if the G1/G2 outcomes contradict each other in a way that re-opens the architecture (§ 9, stop condition 2).

**Specification: not useful now.** The design detail that a spec would carry already exists in the retrieval plan's C1–C8 specifications and `audits/token-audit-2026-05-18-research-workflow.md`; a separate spec would duplicate living documents. Per-slice detail lands in each slice's Work Loop brief.

**Ticket split: no separate artifact.** Each slice below runs as one Work Loop v2 unit (or a short unit sequence) whose state-file brief carries the ticket contract — objective, boundary, claims, evidence, stop conditions. This uses the repository's existing integration machinery (standard § 9) instead of creating a parallel ticket system. Neither artifact is created in this unit.

## 5. Implementation slices

Sequencing principles: reusable substrate first, earliest real operating proof before broad rollout, and no slice that requires an operator decision starts before its gate clears. S1–S3 and S6 are executable under existing authority; S4 and S5 are gated.

### S1 — Content-relay → path-passing refactor
- **Observable outcome:** Stage 3–4 subagent handoffs pass file paths instead of full draft content through the main session, per the existing specification.
- **Acceptance evidence / proof seam:** failing case = measured token cost of one fixture section under the current relay pattern; pass = same fixture section post-refactor with the specified reduction (spec estimates 10k–50k tokens/section) and byte-identical analytical outputs. Deterministic; no judgment eval needed.
- **Boundary:** only the command/skill files the token audit names; no semantic change to any output artifact.
- **Dependencies:** none. **Gate:** none — efficiency fix inside existing authority. Live-consumer check (risk R4) applies.

### S2 — Canonize the Perplexity lead-not-source ruling
- **Observable outcome:** canonical `stage-instructions.md` Step 2.S4 (and the adjudication surfaces it feeds) require a source to have been actually opened before it grades as accessed; unopened Perplexity citations merge as `[SUPPLEMENTARY — LEAD]` with no claim ID and no coverage movement; a retrieval-tool negative is never evidence of absence.
- **Acceptance evidence / proof seam:** failing case = current Step 2.S4 text (verified: no lead handling exists — § 2 finding 4); pass = a fixture merge run where an unopened citation demonstrably cannot acquire a claim ID or move a coverage verdict, plus the changed text quoted against what it replaced.
- **Boundary:** the ruling only — no Source Access Log automation (that is S4), no scarcity-record redesign (mission thread 6 territory).
- **Dependencies:** none. **Gate:** none new — the operator ruling is dated 2026-08-14. **Slice-time premise to verify first:** locate the ruling record in the worktree that carries it (claimed in retrieval § 1.5); if it cannot be produced, hand back rather than reconstructing the ruling from the proposal's paraphrase.

### S3 — Ship the canonical source registry filled
- **Observable outcome:** the canonical named-source appendix and evidence-need→source-class routing for the macro/sector/trend domain ship filled (from retrieval § 2.1, free sources only), so `source-class-mapper` is live on a fresh deployment instead of a no-op; the executor-routing guide joins canonical `reference/`.
- **Acceptance evidence / proof seam:** failing case = current template (16 placeholder tokens, § 2 finding 5); pass = fresh scratch deploy where `source-class-mapper` produces a non-empty, domain-correct mapping with no hand-authoring, and the placeholder-registry deploy checks still pass.
- **Boundary:** reference data only — no retrieval scripts, no subscriptions, no per-source automation; projects still specialize the registry.
- **Dependencies:** none technically. **Gate:** advisory confirmation at G5 that a filled registry is not the S10-rejected "source-memory infrastructure" (Claude's reading: it is static routing reference, not memory of past searches — flagged, not silently resolved).

### S4 — Retrieval runtime: execution relay + mechanical Source Access Log *(gated on G2)*
- **Observable outcome:** a script under the canonical workflow takes a session prompt file, calls the Perplexity **Agent API** with the domain/recency/language parameters the prompt-creator already specifies, writes the raw UTF-8 report to `execution/raw-reports/`, and emits Source Access Log entries (URL, accessed Y/N, HTTP status, date) mechanically; a domain-resolution precheck runs before any scarcity verdict. The Research Execution GPT lane stays manual (no public API) with batched paste blocks. The Cross-Model Rule is preserved: the assigned tool still executes the research; automation replaces the relay, not the work.
- **Acceptance evidence / proof seam:** failing case = no runtime exists (verified: no `scripts/` directory, § 2 finding 1). Deterministic: script-level tests including a planted-failure case (an unfetchable URL must produce `accessed: N`, not silence). Representative: one real research session executed end-to-end through the script, raw report graded by the existing extraction/QC layer, first data rows written to `research-quality-log.md`. API parameter parity verified **by execution** before build completes (Sonar API retires 2026-09-27 — build against the Agent API from the start).
- **Boundary:** Perplexity lane + log emission only. The statistical lane (retrieval C3) is a named follow-on slice, not part of S4.
- **Dependencies:** G2 cleared; S2 landed (the log feeds the ruling's scarcity precondition). **Gate:** G2.

### S5 — `/research` entry with R1 + R2 routes *(gated on G1)*
- **Observable outcome:** one shared ai-resources command classifies an incoming question and runs the two light routes (R1 note with evidence table; R2 plan→execute→synthesize memo with one consolidated QC pass) with zero project deployment; R3 hands off to the deployed RW. Vocabulary (R1/R2/R3 vs Light/Standard/Deep) is whichever G1 settled.
- **Acceptance evidence / proof seam:** deterministic: command-path tests for classification defaults and the one-word override. Representative AI-judgment proof: a small route-classification eval set (unambiguous R1/R2/R3 cases plus ambiguous-defaults-to-R2 cases) and one real R2 memo produced for a genuine launch-period question, judged against the evidence-vs-inference output contract. Operator-workflow proof: the operator runs one real R1 question end-to-end without touching workflow mechanics.
- **Boundary:** new command + its templates only; no change to the deep pipeline; qualification runs through `/develop-ai-resource` → `/create-skill` per `docs/ai-resource-creation.md` (this plan and the lean proposal are the qualification evidence, but the pipeline still decides form).
- **Dependencies:** G1 cleared; S3 useful but not required. **Gate:** G1.

### S6 — Judgment-layer representative local operating trial
- **Observable outcome:** one genuine Sector Intelligence unit runs through the existing local judgment implementation (judgment plan Unit 1): a real proposed Unit Judgment Brief from live evidence, founder revision/approval exercised, approved judgment demonstrably shaping directives and prose, no downstream component inventing an unapproved thesis, review/token burden recorded.
- **Acceptance evidence / proof seam:** operator-workflow and AI-judgment proof by design — the trial *is* the evidence. Deterministic floor: the four existing regression suites stay green (82 tests, per the judgment plan's verified count).
- **Boundary:** entirely inside `projects/axcion-sector-intelligence/`; **no canonical file changes**. Canonical adoption (judgment Units 2–7) remains deferred regardless of trial outcome and is re-planned on the trial's evidence.
- **Dependencies:** a live Sector Intelligence research unit to attach to. **Gate:** none for the trial itself; founder participation is inherent to the trial, not a blocking pre-decision.

**Sequence:** S1 → S2 → S3 (substrate, ungated, in this order of increasing blast radius); G-session (§ 7) scheduled as soon as the operator is available, in parallel with S1–S3; S6 as soon as a real unit exists (independent track); S4 then S5 after their gates clear. Earliest real operating proof arrives from S6 and S4's representative session — both before any broad rollout (S5 adoption beyond the first real uses, deep-pipeline slimming, consuming-project propagation are all behind that evidence).

## 6. Proof strategy

**Deterministic proof** (must fail before, pass after; runnable without judgment):
- S1 token measurement on a fixture section; byte-identity of analytical outputs.
- S2 fixture merge run (unopened citation cannot gain a claim ID).
- S3 scratch deploy with placeholder-registry checks and a non-empty mapper output.
- S4 script tests including planted-failure cases; log-emission invariants; API-parity checks run by execution.
- S5 command-path tests for routing defaults and overrides.
- S6 the four existing regression suites.
- Every canonical edit: the existing deploy validation (placeholder registry, template byte-identity) stays green.

**Representative AI-judgment / operator-workflow proof** (evaluated, not asserted):
- S4: one real research session through the runtime, graded by the existing QC layer.
- S5: route-classification eval set; one real R2 memo; one operator-run R1 question.
- S6: the judgment trial itself, including founder review burden.

**Review and integration:** each slice gets one independent review proportional to consequence per the workspace Independent Review rule (Codex is the reviewer); material slices route through `code-review`. Integration uses the existing Work Loop v2 machinery and the existing `/deploy-workflow` / `/sync-workflow` path for anything a deployed project must receive — canonical and deployed copies are assessed separately (a canonical change does not auto-update project-owned files). Commits are local; push stays gated to session wrap.

## 7. Operator decisions required (authority and cost)

None of these is decided by this plan. Each is a gate; slices behind a gate do not start until it clears. Recommended handling: one decision session covering G1–G5.

- **G1 — Reopen the research-tiers rejection.** The active mission `logs/missions/research-workflow-deploy-fitness.md` records "Research tiers" on the operator's S10 explicitly-not-to-be-built list, with re-litigation "without new pilot evidence" named as an off-mission signal. New evidence now exists (usage evidence: bypass pipelines, zero fast research through RW). Decision: reopen and approve tiered routes — and if so, settle the single vocabulary (R1/R2/R3 ≡ Light/Standard/Deep) — or keep the rejection. **Recommendation (Claude, attributed): reopen; the evidence is exactly the kind the mission contemplated.** Blocks S5.
- **G2 — Reopen the Stage-2 execution-automation rejection.** The same S10 list records "Stage-2 execution automation (the manual model is confirmed; `execution-agent` stays unwired for Stage 2)". The retrieval plan's entire runtime (C1/C4/P1) contradicts it. Decision: reopen for the relay-only automation (Cross-Model Rule preserved) or keep the manual model. **Recommendation: reopen for the relay only.** Blocks S4.
- **G3 — Paid source adoption.** Nordic Financial News subscription (~€290–790/yr) and any later Dealroom consideration (~€12k/yr). **Recommendation: defer both; adopt nothing paid until S4 operates and demonstrates the free stack's limits.** Blocks nothing near-term.
- **G4 — Approve the near-term cutoff.** Repository authority does not determine the exact near-term boundary; § 8's cutoff is Claude's attributed proposal and needs operator approval (or amendment).
- **G5 — Mission-contract mechanics and adjacency confirmations.** The deploy-fitness mission's Goal/scope/validation contract is frozen and `/mission` has no update verb (recorded in the mission file itself), so reopening G1/G2 items requires an operator-directed contract revision or an explicit successor decision — not a silent edit. Same session: confirm S3's filled registry is not the rejected "source-memory infrastructure" shape, and confirm the overlap handling with mission thread 6 (S4's mechanical log strengthens it; ownership stays with the mission).

An approved gate changes the *authority*, not the scope discipline: post-gate slices still carry their stated boundaries.

## 8. Near-term boundary (proposed cutoff — gate G4)

**In:** S1–S6 and the G-session. That is: the two zero-authority-conflict fixes (S1, S2), the substrate fill (S3), the gated volume unlocks (S4, S5), and the judgment trial (S6).

**Out, with reasons:**
- **Deep-pipeline slimming (lean Wave 2)** — horizontal refactor of a working pipeline; its ROI is real but not launch-blocking, and doing it while the route/runtime layers are moving multiplies drift risk.
- **Deployment/lifecycle leaning (lean Wave 3)** — depends on Wave-2 shape decisions.
- **Judgment canonical adoption (judgment Units 2–7)** — the judgment plan itself requires the Unit 1 trial first; re-plan on S6 evidence.
- **Research-mode calibration and the multi-agent experiment (judgment Units 8–9)** — need routes/modes to exist first.
- **Retrieval C3 (statistical lane), C6–C8** — C3 is the named first follow-on after S4; C6–C8 are deferred by the retrieval plan itself.
- **Deploy-fitness threads 3–8, F-7, and its deferred cleanups** — owned by the active mission; absorbing them here would create a second authority over the same files.
- **Consuming-project propagation (Content Programme integration, Editorial handoffs)** — behind the operating proof by design.
- **The R1 citation-fidelity-audit subagent (deferred 2026-04-24)** — disposition falls due at the next `/deploy-workflow`/`/sync-workflow` touch, per its standing reminder; it is not silently absorbed here.

## 9. Risks and stop conditions

**Risks:**
- **R1 — False-scarcity regression.** Any retrieval change that makes scarcity verdicts easier to reach without evidence of actual access re-opens the dominant recorded failure mode. S2 and S4 are sequenced so the ruling and the mechanical log land together-ish (S2 first).
- **R2 — Duplicated/competing authority.** Three proposals + one active mission + this plan all touch the same files. Mitigation: this plan's § 3 dispositions; on operator approval of this plan, each source proposal gets a one-line pointer to this plan as the sequencing authority (their content stays as design reference); the mission keeps its threads (G5).
- **R3 — Premature general automation.** The runtime automates the *relay* only; judgment steps (source-class review, grading, sufficiency, House View) stay with the existing skill/QC layer and the founder. No agent swarm; the multi-agent question stays in its bounded, deferred experiment.
- **R4 — Canonical-versus-deployed drift.** Canonical skills are live-symlinked into deployed projects (§ 2 finding 8), and the mission's history shows file-level reasoning about this workflow failing 3-for-3 until verified by execution. Every canonical slice: enumerate live consumers first, respect the chassis-version/lockstep guards, verify runtime behaviour by execution rather than file reading, and sync deployed copies deliberately via `/sync-workflow`.
- **R5 — Big build before first proof.** The earliest representative proofs (S6 trial; S4's real session) are sequenced before any broad rollout. S5 ships with two real uses, not a programme-wide adoption mandate.
- **R6 — External API deadline.** Perplexity's Sonar Chat Completions API retires 2026-09-27; S4 builds against the Agent API and verifies parameter parity by execution, not documentation.

**Stop conditions (any of these stops the affected slice and hands back):**
1. A slice's load-bearing premise fails at execution time (the standing Work Loop rule — including S2's ruling-record premise).
2. G1 and G2 resolve in a combination that contradicts this plan's architecture (e.g., tiers approved but all automation refused, making R1/R2 economically identical to the manual deep pipeline) — return to planning; escalate mode per § 4.
3. A slice cannot produce its named failing case (evidence that cannot fail is not evidence).
4. A canonical edit would take live effect in a deployed project whose state cannot be verified first.
5. Scope pressure to absorb a deferred item (Wave 2/3, judgment Units 2–9, mission threads) mid-slice — record the deferral, do not implement.
6. Evidence standards would drop anywhere: R1/R2 outputs carry the same evidence-vs-inference discipline and per-claim sourcing as the deep route, in table form; any slice that cannot preserve that stops.

## 10. Completion condition and first slice

**The near-term programme is complete when:**
1. S1–S3 have landed with their deterministic proofs green;
2. the G-session has produced recorded operator decisions on G1–G5 (whatever their outcome — a recorded "keep the rejection" completes the gate);
3. every gate-approved slice among S4–S5 has landed with both its deterministic proof and its representative operating proof (one real research session through the runtime; one real R2 memo and one operator-run R1 question through the routes);
4. S6's trial has run on a genuine unit and its evidence memo exists to drive the judgment layer's re-planning;
5. the three source proposals carry their disposition pointers and no competing sequencing authority remains; and
6. everything not in the near-term boundary is either a recorded deferral here or owned by a named authority elsewhere.

**First executable slice: S1 (content-relay → path-passing refactor).** It has zero authority conflict, a pre-existing specification, deterministic proof, and the highest token ROI per unit of effort in the entire backlog. It is not implemented by this planning unit.
