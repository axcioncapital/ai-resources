# Canonical Research Workflow — Near-Term Strategic Improvements

**Status:** Proposed
**Date:** 2026-08-17
**Author:** Claude (Work Loop v2 task `canonical-rw-near-term-implementation-plan`, Unit 1)
**Method:** Axcíon Repository Development Operating Standard (`skills/axcion-repository-development/SKILL.md` + `references/operating-standard.md`)
**Independent review:** Corrected against `audits/2026-08-17-canonical-research-workflow-near-term-plan-review.md`; approval is still required.

This plan reconciles the three 2026-08-17 proposals — `plans/lean-research-workflow/proposal.md`, `plans/research-retrieval-layer-improvement-plan.md`, and `plans/canonical-research-workflow-judgment-and-insight-plan.md` — into one sequenced, repository-grounded near-term implementation path for the canonical Research Workflow (RW). All three sources are **proposed, not approved**; nothing in this plan converts a proposal into authority. Choices that require the operator are collected in § 7 and gate the slices that depend on them.

---

## 1. Operating outcome

During the launch period, Axcíon needs **substantially more research output at unchanged evidence standards, with substantially less operator and AI effort**. Concretely, the improved canonical RW must make three things possible that are not possible today:

1. **Fast and standard research has a canonical home.** Today a one-question fact check and a ten-chapter report enter the identical deep pipeline, and the recorded consequence is that fast research bypasses the system entirely (3 of 8 candidate projects never adopted RW; 2 of 5 deployments built lighter parallel pipelines; zero fast research has ever run through RW — `plans/lean-research-workflow/proposal.md` § 1.3, evidence in `audits/working/rw-lean-usage-evidence.md`).
2. **The retrieval layer has a runtime.** Today every external fact arrives by the operator manually running browser sessions and pasting output back, with recurring mojibake repair — the workflow decides *what to ask* well and has no machinery for *getting it* (`plans/research-retrieval-layer-improvement-plan.md` § 1.1).
3. **False scarcity is mechanically resisted.** The dominant recorded retrieval failure mode is "we didn't find it" hardening into "it isn't there"; the best existing control reads a self-reported access log (`plans/research-retrieval-layer-improvement-plan.md` § 1.3).

For whom: the operator (less relay and gate labour per unit of research) and the consuming projects (Sector Intelligence, Content Programme, and tactical questions that currently have no home). Why now: launch-period research volume is the binding constraint, and a project-local source ruling plus several high-cost relay seams are sitting unapplied.

## 2. Verified current substrate

Load-bearing current-state claims, each checked by inspection on 2026-08-17 in this checkout. Reuse decisions follow each finding.

| # | Finding | Evidence (inspected) | Disposition |
|---|---|---|---|
| 1 | The canonical RW is a deep-report pipeline: 5 stages, no fast path, no top-level `scripts/` runtime directory; command count is ref-sensitive | At plan commit `52841b17`, the checkout has 30 tracked command entries; fetched `origin/main` at `3e7789cd` has 29 after retiring `inject-dependency.md`; `workflows/research-workflow/scripts/` does not exist | Reconcile latest `origin/main` before implementation; keep the deep route and do not slim it in the near term (deferred, § 8) |
| 2 | `execution-agent` exists and is wired **only** into chapter verification, not Stage-2 retrieval | `workflows/research-workflow/.claude/agents/execution-agent.md` exists; `grep -rln "execution-agent" workflows/research-workflow/.claude/commands/` → only `verify-chapter.md` | Reuse as the seed of the retrieval runtime **if** gate G2 approves (§ 7) |
| 3 | Four high-severity content-relay classes remain open; their live scope is broader than the May estimate and some relays may be intentional | `audits/token-audit-2026-07-03-ai-resources.md:253-291` (W4-H1–H4); the May audit explicitly lacked execution telemetry | Bound and instrument the live relay seams before changing them — Slice S1 |
| 4 | The canonical Perplexity merge step has no lead-vs-source precondition | `workflows/research-workflow/reference/stage-instructions.md:77` (Step 2.S4) merges QC-approved supplementary results and tags `[SUPPLEMENTARY]`; no `LEAD` handling found (searched `stage-instructions.md` for `lead, not` / `LEAD]` — no match) | Canonize the 2026-08-14 operator ruling — Slice S2 |
| 5 | The canonical source-intelligence template is deliberately project-instantiated and currently contains 22 placeholder occurrences / 21 distinct literal spellings | `workflows/research-workflow/reference/source-class-hierarchy.template.md`; `workflows/research-workflow/docs/required-reference-files.md:13-18,72-78` | Keep the generic template generic; provide an optional deploy-time domain profile only if G5 approves — Slice S3 |
| 6 | There is no measured quality baseline | `workflows/research-workflow/logs/research-quality-log.md`: header and column definitions only, zero data rows | Start writing rows as part of S4/S5 acceptance evidence |
| 7 | The Sector Intelligence judgment-layer pilot exists in a separate workspace checkout with passing regression suites, and canonical adoption was explicitly deferred | Workspace sibling `projects/axcion-sector-intelligence` at inspected commit `d0cb658b9266c4af553ad224181d942e473a61cd`; its `reports/analyst-judgment-layer-implementation-research-v1.md` and two judgment Work Loop logs | Re-bind that checkout and its four named test suites when S6 opens; run the representative local trial only — Slice S6 |
| 8 | Canonical skill edits take **live effect** in deployed projects | `logs/missions/research-workflow-deploy-fitness.md` § Pre-deployment corrections: two live projects symlink canonical skills; the mission's S11/S13/S14 record documents live blast radius | Every canonical slice enumerates live consumers before editing (risk R4, § 9) |
| 9 | The deploy-fitness mission is **active** and carries an operator "explicitly not to be built" list including **research tiers** and **Stage-2 execution automation** | `logs/missions/research-workflow-deploy-fitness.md` frontmatter `status: active`; § In/Out of scope, operator S10 list | Live authority conflict with the lean and retrieval proposals — gates G1/G2 (§ 7) |
| 10 | No more current approved canonical RW plan or authoritative current-state record supersedes the above in this reviewed repository checkout | Searched `plans/`, `logs/missions/`, and `logs/work-loop/`; current remote-main delta was separately inspected after `git fetch origin` | The active mission and three proposals are the plan's identified authority surface; each slice re-checks current refs and adjacent active records before implementation |
| 11 | Existing `/sync-workflow` cannot propagate the reference and runtime surfaces S2–S4 need | `.claude/commands/sync-workflow.md:30-54`; `audits/2026-08-13-workflow-sync-reconciliation-ruling.md:76-85` | Repair propagation semantics before those slices — Slice S0 |

## 3. Reconciling the three proposals into one sequence

The three proposals are not three roadmaps to append; they occupy three layers of one system, plus one collision that must be resolved once:

- **The lean proposal** is the *shape* layer: route research by consequence (R1 Rapid / R2 Standard / R3 Deep), automate the relay, slim the deep pipeline later.
- **The retrieval plan** is the *runtime* layer: it explicitly subordinates itself to the lean plan's Wave 1 ("this plan should be sequenced inside the lean plan's Wave 1, not run as a third competing track" — its § Relationship note) and details the execution relay, source registry, and anti-false-scarcity mechanics.
- **The judgment plan** is the *output-quality* layer: House View approval before content, insight extraction, and Light/Standard/Deep research modes. Its own sequence already begins with a **local, non-canonical operating trial** (Unit 1) and forbids canonical rollout before that trial.
- **The collision:** the lean plan's R1/R2/R3 routes and the judgment plan's Light/Standard/Deep modes address the same assignment-level axis ("how much workflow machinery does this assignment need") but prescribe different controls, especially for Standard/R2. Neither proposal cites the other (verified: `grep` for each sibling's name in the other two files matches only in the retrieval plan). Building both independently would create the "three unrelated research workflows" the judgment plan itself lists as a non-goal. Gate G1 therefore settles one behavioral control matrix first; vocabulary follows that decision.

**Cross-source disposition of the major themes:**

| Theme | Source(s) | Disposition |
|---|---|---|
| Reference/runtime propagation contract | independent review; existing sync reconciliation ruling | **Near-term prerequisite** (S0), gated on G5 — distinguish canonical immutable references, instantiated project references, and runtime files before S2–S4 |
| Content-relay → path-passing refactor | lean § 2.4.2; July token audit W4-H1–H4 | **Near-term implementation** (S1) — instrument and bound the four live relay classes before editing |
| Perplexity lead-not-source ruling canonization | retrieval C5 | **Near-term implementation** (S2) only when G4 explicitly authorizes canonical propagation; the 2026-08-14 project-local ruling supplies substantive evidence, not canonical authority |
| Filled source registry | retrieval C2, P2 | **Near-term implementation** (S3), gated on G5 — an optional deploy-time macro/sector/trend profile outside the generic template, not hard-coded country choices or a canonical runtime fallback |
| Tiered routes / research modes (R1-R3 and Light/Standard/Deep) | lean § 2.1, judgment § modes | **Prerequisite decision gate** (G1) — same effort axis but different controls; conflicts with the active mission's S10 rejection of research tiers |
| Execution relay + verified-access log + statistical lane | lean § 2.4.1; retrieval C1, C3, C4, P1, P4 | **Prerequisite decision gate** (G2) — conflicts with the mission's S10 "Stage-2 execution automation" rejection; build only after reopening |
| Shared research entry capability (R1+R2 behavior) | lean Wave 1.1 | **Near-term implementation after G1** (S5); mechanism remains command/skill/extension/no-build until `/develop-ai-resource` qualifies it |
| Judgment layer: representative local operating trial | judgment Unit 1 | **Near-term implementation** (S6) — local project only, no canonical change, no conflict |
| Judgment layer canonical adoption (Units 2–7) | judgment Units 2–7 | **Deferral** — the judgment plan itself forbids rollout before the Unit 1 trial; re-plan on its evidence |
| Deep-pipeline slimming (quality-standards compression, QC merge, gate consolidation) | lean Wave 2 | **Deferral** — real value, but horizontal refactor of a working pipeline; do after the volume unlock lands |
| Deployment/lifecycle leaning (opt-in Work Loop bundle, manifest, hooks) | lean Wave 3 | **Deferral** |
| Paid subscription (Nordic Financial News) + monitoring watchlist | retrieval P5 | **Prerequisite decision gate** (G3) — recurring spend is operator-owned; recommend deferring the spend until S4 operates |
| Bounded multi-agent experiment | lean; judgment Unit 9 | **Later experiment** — owned by the judgment plan's sequence, after mode calibration |
| Local-language pilot (C6), half-wired controls (C7), Nordic hardcoding (C8) | retrieval | **Deferral** — retrieval plan itself defers these beyond launch months |
| Research-mode empirical calibration (judgment Unit 8) | judgment | **Later experiment** — needs the routes/modes to exist first |
| Deploy-fitness threads 3–8, F-7, deferred cleanups | active mission | **Not absorbed.** They remain owned by `logs/missions/research-workflow-deploy-fitness.md`. Overlap note: mission thread 6 (scarcity search record) is directly strengthened by S4's verified-access log; coordinate at the gate session (G5) rather than double-owning |

## 4. Operating mode, specification, and ticket split

**Mode: Normal** (operating standard § 3). The remaining planning uncertainty — which slices, in what order, behind which gates — is resolvable in one effective planning context, and this document is that context. The work is not Small/Clear (material product decisions exist: tiers, automation reopening, spend), and it is not Foggy: the open decisions are enumerable, separable, and all route to the same operator session rather than forming a dependent decision web. Escalate to `/wayfinder` only if a gate resolves in a form none of this plan's stated paths covers (§ 9, stop condition 2).

**Specification: not useful now.** The corrected slices below carry the implementation-facing decisions this plan needs; source plans remain design evidence, not authority. Per-slice detail lands in each slice's Work Loop brief, and any mechanism that `/develop-ai-resource` leaves materially unsettled returns to planning rather than being invented during build.

**Ticket split: no separate artifact.** Each slice below runs as one Work Loop v2 unit (or a short unit sequence) whose state-file brief carries the ticket contract — objective, boundary, claims, evidence, stop conditions. This uses the repository's existing integration machinery (standard § 9) instead of creating a parallel ticket system. Neither artifact is created in this unit.

## 5. Implementation slices

Sequencing principles: reusable substrate first, earliest real operating proof before broad rollout, and no slice starts before its authority exists.

**Authority baseline.** Every slice below derives from proposed, unapproved sources, so technical readiness and authority are distinct: **no slice begins until the operator approves this plan (gate G4) or separately authorizes that slice.** Within that baseline, S1 and S6 need no additional operator decision; S2 needs G4 to say canonical propagation explicitly; S0 and S3 wait for G5; S4 and S5 are decision-gated (G2, G1). "Gate" lines below name what must clear beyond the plan-approval baseline.

### S0 — Make reference and runtime propagation truthful *(gated on G5)*
- **Observable outcome:** `/deploy-workflow` and `/sync-workflow` inventory every surface S2–S4 can change and distinguish three classes: canonical immutable references, canonical templates whose deployed counterparts are project-instantiated, and canonical runtime files. Existing projects can no longer be reported current while an immutable reference or required runtime file is missing or stale; instantiated project references are never blindly overwritten.
- **Acceptance evidence / proof seam:** pre-fix fixture = a deployed project with stale `reference/stage-instructions.md`, a legitimately specialized `reference/source-class-hierarchy.md`, and a missing runtime file is incorrectly reported current or invisible. Post-fix = immutable drift and missing runtime are offered for sync, the instantiated hierarchy is classified for conflict-aware/manual reconciliation, and fresh deploy coverage includes the selected runtime directory. Tests cover addition, update, project specialization, deletion/absence, and paths containing spaces. A risk-aware Codex review of cross-project write, overwrite, deletion, rollback, and conflict-classification behavior must clear **before** implementation.
- **Boundary:** propagation mechanics only; no S2 policy text, S3 profile content, or S4 runtime behavior. No automatic overwrite of project-owned instantiated references.
- **Dependencies:** latest `origin/main` reconciled before the slice opens. **Gate:** G5 must authorize this adjacency to the active mission and name the successor/supersession record that permits it.

### S1 — Content-relay → path-passing refactor
- **Observable outcome:** the July audit's W4-H1–H4 seams use disk-write-and-return-path or path-plus-capped-summary where the existing isolation contract allows it: full draft returns, duplicate verification responses, large operand relays, and repeated large-reference relays are removed from main-session payloads.
- **Acceptance evidence / proof seam:** before editing, instrument a fixed artifact fixture and enumerate the exact W4-H1–H4 seams in scope. Deterministic pass = 100% of those named seams pass paths plus summaries capped at 20 lines / 4 KB, with at least an 80% reduction in relayed payload bytes across the fixture and no unapproved full-content exception. Representative pass = one end-to-end chapter regression preserves required artifacts, claim IDs, verdicts, and analytical meaning under an explicit semantic/schema rubric. Record actual tokens if the harness exposes them, but do not treat the May 10k–50k estimate as an acceptance threshold or require byte identity from AI-authored prose.
- **Boundary:** W4-H1–H4 only, after reconciling any intentionally isolated relay against `workflows/research-workflow/docs/required-reference-files.md`; no compaction, model, or output-policy redesign.
- **Dependencies:** none. **Gate:** plan approval only (§ 5 authority baseline) — no additional operator decision. Live-consumer check (risk R4) applies.

### S2 — Canonize the Perplexity lead-not-source ruling
- **Observable outcome:** canonical `stage-instructions.md` Step 2.S4 (and the adjudication surfaces it feeds) require a source to have been actually opened before it grades as accessed; unopened Perplexity citations merge as `[SUPPLEMENTARY — LEAD]` with no claim ID and no coverage movement; a retrieval-tool negative is never evidence of absence.
- **Acceptance evidence / proof seam:** failing cases = current Step 2.S4 permits an unopened citation to merge normally and does not prevent a retrieval-tool negative from supporting absence. Pass = (1) an unopened citation cannot acquire a claim ID or move a coverage verdict, and (2) a negative-result fixture cannot create/upgrade a scarcity or non-existence verdict without the required direct-access record; quote the changed rule against what it replaced.
- **Boundary:** the ruling only — no Source Access Log automation (that is S4), no scarcity-record redesign (mission thread 6 territory).
- **Dependencies:** S0 landed. **Gate:** G4's approval record must explicitly authorize canonical propagation of the Perplexity lead-not-source rule; general plan approval without that sentence is insufficient. Locate the 2026-08-14 project-local ruling as evidence of the substantive rule, but do not treat that project-local record as canonical authority.

### S3 — Add an optional deploy-time macro/sector/trend source profile *(gated on G5)*
- **Observable outcome:** a reusable, explicitly selected source profile instantiates the project-owned `reference/source-class-hierarchy.md` for macro/sector/trend work. The profile lives outside the generic workflow template; the template remains placeholder-based and byte-identical, and projects can specialize the generated file. No profile acts as a hidden runtime fallback.
- **Acceptance evidence / proof seam:** deterministic = generic deploy without the profile leaves every `.template.md` byte-identical; profile-selected deploy creates one filled project file with zero unresolved profile-owned placeholders; sync classifies later project specialization as a conflict/manual reconciliation, not an overwrite. Judgment = a labeled question set spanning macro, sector, trend, and out-of-domain cases is mapped by `source-class-mapper`; an independent rubric checks class/ladder correctness and that out-of-domain questions fail or request specialization rather than receiving Nordic defaults.
- **Affected consumers:** `/deploy-workflow`, `/sync-workflow`, `source-class-mapper`, `research-prompt-creator`, `execution-manifest-creator`, `research-extract-verifier`, `country-parity-checker`, `transaction-table-builder`, and the `run-execution` / `run-cluster` / `run-sufficiency` paths named by `docs/required-reference-files.md`.
- **Boundary:** optional profile + instantiation/reconciliation contract only; no country choice enters the generic template, no retrieval scripts or subscriptions, and no automatic claim that one domain profile fits company or other research.
- **Dependencies:** S0 landed; at least two intended consumers are confirmed before generalization. **Gate:** G5 must approve the profile architecture, explicitly reconcile it with the mission's genericness and no-country-hardcoding rules, and confirm it is not rejected source-memory infrastructure. A negative G5 decision records S3 as a non-build disposition.

### S4 — Retrieval runtime: safe execution relay + verified-access log *(gated on G2)*
- **Observable outcome:** a script under the canonical workflow takes a session prompt file, previews request count and maximum spend, checks the prompt against the project's confidentiality/routing policy, and only then calls the selected Perplexity endpoint after explicit live-dispatch approval. It reads `PERPLEXITY_API_KEY` from the environment, never stores or logs the key, writes an atomic UTF-8 raw report, and records URL state separately as `attempted`, `retrieved`, `usable`, and `opened`. A Perplexity citation is always a lead and never sets `opened`. The assigned tool still executes the research; automation replaces the relay, not the work. The Research Execution GPT lane remains manual unless a first-party supported programmatic path is separately established.
- **Safety and failure contract:** redact secrets and confidential prompt content from logs; cap retries at two with backoff for retryable errors; fail closed on auth, budget, policy, malformed output, or partial-write errors; make reruns idempotent; and require direct fetch evidence for `retrieved` plus downstream read confirmation for `opened`. The domain-resolution precheck and verified-access record must guard every scarcity writer in Stage-2 supplementary and Stage-3 gap/sufficiency paths.
- **Acceptance evidence / proof seam:** pre-fix = no runtime exists. Deterministic = dry-run/spend gate, missing-key, denied-confidentiality, redaction, retry ceiling, atomic-write/idempotency, redirect, paywall, bot challenge, empty/partial body, unfetchable URL, and citation-only fixtures; no fixture may promote a citation to `opened`. Command-path tests prove every scarcity-emission route consumes the precheck/log. Representative = one approved live research session end-to-end, raw report graded by existing extraction/QC, first quality-log row written, actual spend recorded without sensitive content. Domain/recency/language and structured-output semantics are verified by execution against current [Agent API web-search documentation](https://docs.perplexity.ai/docs/agent-api/tools/web-search); unsupported parameters remain prompt-encoded or stop the slice. Current first-party materials support Agent API migration while the [Sonar quickstart](https://docs.perplexity.ai/docs/sonar/quickstart) remains live and the [official changelog](https://docs.perplexity.ai/docs/resources/changelog) provides no reviewed 2026-09-27 retirement notice, so no deadline drives this slice.
- **Boundary:** Perplexity lane + log emission only. The statistical lane (retrieval C3) is a named follow-on slice, not part of S4.
- **Dependencies:** G2 cleared; S0 and S2 landed. **Gate:** G2 plus a risk-aware Codex review of credential, confidentiality, spend, egress, and logging contracts **before** implementation.

### S5 — Shared research entry capability with two light routes *(gated on G1)*
- **Observable outcome:** one qualified shared entry surface classifies an incoming question and runs the two light behaviors G1 approved; the deep route hands off to the deployed RW. This plan does not pre-decide whether the surface is a command, skill, or extension of an existing resource. "Zero deployment" means no full RW template deployment; any command still requires normal shared-command sync/installation into the consuming project's `.claude/commands/`.
- **Acceptance evidence / proof seam:** deterministic = real invocation-path tests prove the selected entry surface loads in a non-RW project, classifies defaults/overrides, and dispatches the correct downstream behavior rather than merely printing a label. Representative = labeled route-classification evals; one genuine R2/Standard memo judged against G1's control matrix; one operator-run R1/Light question without workflow-mechanics intervention; escalation cases prove a load-bearing claim cannot stay on an under-controlled route.
- **Mechanism qualification and complexity budget:** run `/develop-ai-resource`, which chooses the mechanism and builds commands/scripts directly (only a new skill routes to `/create-skill`). Record: (1) recurring failure — fast/standard work bypasses RW; (2) observed frequency — 3/8 candidate projects did not adopt it, 2/5 deployments built lighter paths, zero fast runs used RW; (3) cost — one on-demand surface, its sync/install footprint, and measured per-run context; (4) conditionality — only fires on an explicit research need and escalates by consequence; (5) reuse — extend an existing resource if qualification finds an 80% owner. If a new command remains necessary, name what it replaces or why separate, wire a discoverable invocation path, and clear `docs/ai-resource-creation.md` rule 7 before build. If qualification selects a new command or skill, its structural risk-aware Codex review clears before implementation; reuse or a non-artifact operating change follows its own proportionate review class.
- **Boundary:** the qualified entry mechanism + R1/Light and R2/Standard behaviors only; no deep-pipeline change.
- **Dependencies:** G1 cleared **and G5's named successor/supersession record has made that reopening authoritative**. G1 must settle behavior, not merely vocabulary: the Light/R1 and Standard/R2 control matrix, load-bearing-claim escalation, evidence extraction and permission/sufficiency requirements, House-View trigger, default, and one-way escalation. S3 is useful but not required. **S5 remains independent of S4:** use S4 after it lands; otherwise use the manual batched execution model and record relay burden. **Gate:** G1 + the G5 authority record.

### S6 — Judgment-layer representative local operating trial
- **Observable outcome:** one genuine Sector Intelligence unit runs through the existing local judgment implementation (judgment plan Unit 1): a real proposed Unit Judgment Brief from live evidence, founder revision/approval exercised, approved judgment demonstrably shaping directives and prose, no downstream component inventing an unapproved thesis, review/token burden recorded.
- **Acceptance evidence / proof seam:** operator-workflow and AI-judgment proof by design — the trial *is* the evidence. Deterministic floor: the four existing regression suites stay green (82 tests, per the judgment plan's verified count).
- **Boundary:** entirely inside the separate workspace checkout `projects/axcion-sector-intelligence/`; **no canonical file changes**. Canonical adoption (judgment Units 2–7) remains deferred regardless of trial outcome and is re-planned on the trial's evidence.
- **Dependencies:** a live Sector Intelligence research unit; at slice open, bind the exact checkout/commit and run `logs/scripts/check-judgment-{contract,gate,producer,propagation}.test.sh` (82 assertions at the inspected record) before and after the trial. **Gate:** plan approval only (§ 5 authority baseline) — the trial needs no additional decision; founder participation is inherent to the trial, not a blocking pre-decision.

**Sequence:** the G-session (§ 7) comes first. Reconcile latest `origin/main` and freeze the § 6 baseline before any affected slice; then run S0 if G5 approves. S1 can run independently after G4 and its baseline capture; S2 follows S0 and explicit G4 canonization authority; S3 follows S0 and G5; S6 opens in its separately bound checkout when a real unit exists; S4 follows S0+S2 if G2 approves; S5 follows G1 plus G5's authority record and never waits for S4. Existing-project propagation of S2–S4 never precedes S0. Broad adoption stays behind the first real S4/S5/S6 operating evidence and the programme benchmark in § 6.

## 6. Proof strategy

**Deterministic proof** (must fail before, pass after; runnable without judgment):
- S0 conflict-aware inventory/deploy fixtures for immutable references, instantiated templates, and runtime files.
- S1 instrumented handoff-payload fixture: every scoped W4-H1–H4 seam path-based/capped, ≥80% payload-byte reduction.
- S2 fixture merge run (unopened citation cannot gain a claim ID).
- S3 generic/profile-selected scratch deploys, placeholder/template invariants, and conflict-aware resync.
- S4 safety, failure, access-state, scarcity-path, and API-parity tests stated in the slice.
- S5 real loading/invocation and dispatch-path tests for the mechanism `/develop-ai-resource` selects.
- S6 the four existing regression suites.
- Every canonical edit: the existing deploy validation (placeholder registry, template byte-identity) stays green.

**Representative AI-judgment / operator-workflow proof** (evaluated, not asserted):
- S1: one end-to-end chapter regression scored for schema and analytical equivalence.
- S3: labeled in-domain/out-of-domain source-mapping eval.
- S4: one real research session through the runtime, graded by the existing QC layer.
- S5: route-classification and escalation eval set; one real R2/Standard memo; one operator-run R1/Light question.
- S6: the judgment trial itself, including founder review burden.

**Programme outcome benchmark** (separate operability from improvement): before **S1, S4, or S5** changes any measured path, freeze a small comparable set of two Light/R1 questions, two Standard/R2 assignments, and one Deep/R3 section and record the current method. Capture the Deep relay-payload baseline before S1; capture current Light/Standard operator effort before S5; and capture current manual execution relay before S4. Measure elapsed time, operator active minutes, relay events, model/API cost or tokens, artifact count, load-bearing-claim source validity, evidence/inference violations, and disclosed unresolved gaps. The programme earns **DELIVERED** only when the approved routes show: at least 50% fewer operator relay events; at least 30% lower operator active minutes for R1/R2; at least 30% lower main-session payload bytes for the S1-affected Deep seam; 100% of load-bearing claims sourced or explicitly withheld; zero evidence/inference violations; and no undisclosed increase in unresolved gaps. Record source-validity as a rate and require no regression from baseline; with no existing quality-log rows, do not invent a historical percentage. If the benchmark is too small for a stable cost/turnaround conclusion, label the result provisional and extend real use before claiming "substantial" improvement.

**Review and integration:** each slice gets one independent review proportional to consequence per the workspace Independent Review rule (Codex is the reviewer); material slices route through `code-review`, and S4 receives its risk-aware review before build. Integration uses the existing Work Loop v2 machinery. S0 must prove `/deploy-workflow` / `/sync-workflow` can carry the relevant surfaces before S2–S4 rely on them; canonical and deployed copies are assessed separately. Commits are local; push stays gated to session wrap.

## 7. Operator decisions required (authority and cost)

None of these is decided by this plan. **G4 — approval of this plan and its cutoff — is the baseline authorization without which no slice starts at all** (§ 5); G1, G2, G3 and G5 gate their named slices on top of it. Recommended handling: one decision session covering G1–G5.

- **G1 — Reopen the research-tiers rejection and settle route behavior.** The active mission records "Research tiers" on the operator's S10 explicitly-not-to-be-built list, with re-litigation "without new pilot evidence" named as an off-mission signal. New usage evidence now exists. Decision: keep the rejection, or approve differentiated routes and settle their actual control matrix: Light/R1 and Standard/R2 evidence artifacts, extraction/permission/sufficiency controls, House-View trigger, load-bearing-claim escalation, default route, and one-way escalation. Vocabulary is secondary; R1/R2/R3 and Light/Standard/Deep are not behaviorally equivalent until this matrix is decided. **Recommendation (Claude, attributed): reopen and settle the matrix.** Blocks S5.
- **G2 — Reopen the Stage-2 execution-automation rejection.** The same S10 list records "Stage-2 execution automation (the manual model is confirmed; `execution-agent` stays unwired for Stage 2)". The retrieval plan's entire runtime (C1/C4/P1) contradicts it. Decision: reopen for the relay-only automation (Cross-Model Rule preserved) or keep the manual model. **Recommendation: reopen for the relay only.** Blocks S4.
- **G3 — Paid source adoption.** The proposed retrieval plan estimates Nordic Financial News at ~€290–790/yr and later Dealroom consideration at ~€12k/yr; verify current first-party pricing and terms at the decision. **Recommendation: defer both; adopt nothing paid until S4 operates and demonstrates the free stack's limits.** Blocks nothing near-term.
- **G4 — Approve this plan and its near-term cutoff.** Repository authority does not determine the exact near-term boundary; § 8's cutoff is Claude's attributed proposal and needs operator approval (or amendment). The approval record must separately state whether it **authorizes canonical propagation of the Perplexity lead-not-source rule**; that sentence is S2's authority. General plan approval authorizes S1 and S6 but does not silently manufacture S2 authority.
- **G5 — Mission successor/supersession and adjacency.** `/mission update` now exists, but it may revise only `## Open threads`; the deploy-fitness mission's Goal/scope/validation contract remains frozen. Reopening its G1/G2 rejections or its genericness/no-hardcoded-country rule therefore requires a named successor decision or explicit supersession record, not a silent mission edit. The same record decides whether S0's sync/deploy expansion and S3's optional external profile are permitted, confirms S3 is not source-memory infrastructure, and preserves mission-thread-6 ownership while allowing S4's verified-access log to strengthen it.

**Gate dispositions are terminal and explicit:**

| Gate outcome | Slice disposition | Programme meaning |
|---|---|---|
| G1 approved | S5 may open after its control matrix **and G5's successor/supersession authority** are recorded | Required for the fast/standard-home outcome |
| G1 rejected | S5 closes as operator-declined; do not build a disguised route | Programme may be operator-closed, but not called DELIVERED against § 1 |
| G2 approved | S4 may open after S0+S2 and pre-build risk review | Required for the retrieval-runtime outcome |
| G2 rejected | S4 closes as operator-declined; manual relay remains | Programme may be operator-closed, but not called DELIVERED against § 1 |
| G4 omits S2 canonization | S2 closes as unauthorized until separately decided | No proposal paraphrase substitutes for authority |
| G5 approves S0/S3 architecture | S0 opens, then S3 may open after two-consumer confirmation | Existing-project propagation becomes available |
| G5 rejects either item | The named slice closes as operator-declined; no hidden fallback | A rejected S3 does not leave completion impossible; a rejected S0 means S2–S4 are not propagated to existing projects and must be re-scoped or closed |

An approved gate changes the *authority*, not the scope discipline: post-gate slices still carry their stated boundaries.

## 8. Near-term boundary (proposed cutoff — gate G4)

**In:** S0–S6 and the G-session. That is: truthful propagation (S0), the relay refactor (S1), the explicitly authorized lead-not-source canonization (S2), the optional profile (S3), the gated volume unlocks (S4, S5), and the judgment trial (S6). A gate rejection yields a recorded non-build disposition, not permission to substitute a nearby shape.

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
- **R4 — Canonical-versus-deployed drift.** Canonical skills are live-symlinked into deployed projects (§ 2 finding 8), while references are project-owned copies that current sync cannot see. Every canonical slice: enumerate live consumers first, respect chassis-version/lockstep guards, verify runtime behaviour by execution, and propagate reference/runtime changes only through the S0-proven classification path.
- **R5 — Big build before first proof.** The earliest representative proofs (S6 trial; S4's real session) are sequenced before any broad rollout. S5 ships with two real uses, not a programme-wide adoption mandate.
- **R6 — External API drift.** Perplexity's [API platform](https://www.perplexity.ai/api-platform) favors Agent API migration while its [Sonar quickstart](https://docs.perplexity.ai/docs/sonar/quickstart) still documents Sonar; no reviewed first-party source supports the previously claimed 2026-09-27 retirement date. S4 pins no schedule to that claim and verifies endpoint/filter/output behavior at build time.
- **R7 — Credentialed paid egress.** S4 can leak confidential prompts, overspend, or convert partial retrieval into false access. Its pre-call policy/spend gate, environment-only credential, redacted logs, bounded retries, atomic writes, four-state access model, and pre-build risk review are acceptance requirements, not implementation details.

**Stop conditions (any of these stops the affected slice and hands back):**
1. A slice's load-bearing premise fails at execution time (the standing Work Loop rule — including S2's ruling-record-and-authorization premise).
2. An operator gate resolves in a form none of this plan's stated paths covers (every G1×G2 combination is covered by design — no tiers / runtime routes / manual-model routes — so this fires only on a conditioned or partial approval that neither the runtime nor the manual execution model can serve) — return to planning; escalate mode per § 4.
3. A slice cannot produce its named failing case (evidence that cannot fail is not evidence).
4. A canonical edit would take live effect in a deployed project whose state cannot be verified first.
5. Scope pressure to absorb a deferred item (Wave 2/3, judgment Units 2–9, mission threads) mid-slice — record the deferral, do not implement.
6. Evidence standards would drop anywhere: R1/R2 outputs carry the same evidence-vs-inference discipline and per-claim sourcing as the deep route, in table form; any slice that cannot preserve that stops.

## 10. Terminal conditions and first slice

The plan distinguishes **administrative closure** from **operating-outcome delivery**.

**The near-term programme is decision-complete / operator-closed when:**
1. the G-session records G1–G5 outcomes and the successor/supersession record each approved conflict requires;
2. every approved slice has landed with its named proof, while every rejected slice has a recorded non-build disposition and no disguised substitute;
3. S6's genuine-unit trial and evidence memo exist if G4 approved it and a live unit was available; otherwise the absence and trigger are recorded rather than called a pass;
4. the three source proposals carry disposition pointers; and
5. every deferred item has a named owner or trigger.

**The programme may be called DELIVERED against the § 1 operating outcome only when:**
1. S1 is green; S5 is approved and has passed its R1/Light and R2/Standard operating cases; S4 is approved and has passed its safe live runtime case; S0/S2 are green wherever existing-project propagation is claimed; and S3 is either green or explicitly shown unnecessary for the benchmark assignments;
2. S6's trial has run on a genuine unit and its evidence memo exists to drive judgment-layer re-planning;
3. the § 6 programme benchmark meets its numeric effort thresholds and quality non-regression rules; and
4. no completion claim depends on the unsupported Sonar deadline, an unbound external checkout, or a project-local ruling treated as canonical authority.

If G1 or G2 is rejected, the programme can close cleanly but **cannot** claim that the corresponding fast/standard-home or retrieval-runtime outcome was delivered. If an approved slice misses the benchmark, return to the smallest relevant slice or re-plan; do not weaken the threshold after seeing the result.

**First executable slice: S1 (content-relay → path-passing refactor), beginning once G4 approves this plan and latest `origin/main` is reconciled.** It needs no decision beyond that approval, but it begins with the July W4-H1–H4 seam inventory and baseline instrumentation; the old claim that no design work remains is retired. S0 may run in parallel only if G5 has supplied its explicit successor/supersession authority. Nothing is implemented by this planning unit.
