# Use-Case Investigation — Routine Task Improvement System

**Date:** 2026-06-12 (post-S11 session; no `/prime` marker — see workspace session-marker convention)
**Subject:** External build spec "Routine Task Improvement System with Routine Recognition Hook" + follow-up "Routine Improvement Consultant" idea
**Method:** Repo-wide infrastructure inventory (Explore agent) → consultant overlap check (direct file reads) → System Owner consultation (agent a0561cf15e90af564) → main-session verification of disputed claims → SO re-consult attempted (blocked by 1M-credit subagent gate; resolved inline per decision-point posture)
**Verdict:** **TRACK-FIRST** — do not build now; named re-evaluation trigger below.

---

## 1. What the spec asked for

Five components: (0) a Routine Recognition Hook classifying each session at wrap time (known routine / likely routine / routine-like maintenance / one-off / unclear, with confidence); (1) a routine registry (routine_id, cadence, time budget, detection signals, retirement condition); (2) a Routine Task Run Review section in `/wrap-session`; (3) a weekly Routine Task Improvement Review (in `/friday-checkup` or standalone `/routine-improvement-review`); plus the follow-up idea (4) a `/routine-improvement-consultant` command — evidence-gated advisory recommending the single highest-leverage routine change from a fixed decision menu.

Core question the spec wants answered: *"Is this recurring routine improving over time, or becoming operational drag?"*

## 2. Overlap map — original spec vs. repo

| Spec component | Status | Existing form |
|---|---|---|
| Wrap-time session classification | **PARTIAL → mostly EXISTS** | `/wrap-session` Step 6.4 Session Value Audit (`wrap-session.md:359-399`, shipped 2026-06-12): fresh-context subagent emits `TYPE: A–E` — A High-Leverage Build, B Necessary Maintenance, C Useful Diagnosis, D Low-Yield Maintenance Drift, E False Productivity. This is a session classification along the axis the spec cares about (build vs. maintenance vs. drag); what it lacks is routine *identity* (no routine_id match) |
| "Session Value Audit — 80/20 Review" (spec §3.1 asked whether it exists) | **EXISTS** | Same Step 6.4: `TYPE / VALUE (5 dims) / SCORE X-of-10 (five 0–2 components, max 3 if nothing concrete) / GATE / OPPORTUNITY / DECISION / LESSON / RULE` — written into `logs/session-notes.md` per session |
| Maintenance Justification Gate (spec §4.7, Test B) | **EXISTS** | Step 6.4 `GATE:` — asset-building vs. comfort maintenance; FAILED forces TYPE D/E (`wrap-session.md:389`) |
| Routine Value Score 0–10, five 0–2 components (spec §11) | **EXISTS** (session-level) | Step 6.4 `SCORE:` — components output / decision / time-saved / risk / reusability ≈ the spec's frequency-benefit / decision-value / risk-reduction / time-saved / compounding (`wrap-session.md:388`) |
| Per-run decision (keep/batch/redesign/retire) | **EXISTS** (session-level) | Step 6.4 `DECISION: Repeat / Repeat with constraints / Batch into maintenance / Redesign before repeating / Stop this session pattern` (`wrap-session.md:391`) |
| Weekly improvement review with lowest-yield + stop/batch + one-change-only | **EXISTS** | `/friday-checkup` item 14.5 Weekly Session Value Review (`friday-checkup.md:333-339`, all tiers, shipped 2026-06-12): highest-value + lowest-yield sessions by SCORE, session types to repeat/constrain/batch/stop, **ONE operating rule change only** — consumed by `/friday-act` Step 4.2 |
| Evidence thresholds ("don't change after one bad run; 2–3 occurrences") | **EXISTS** | gate-calibration (≥90% confirm over 30d), defect-recurrence ≥2 (`docs/defect-to-fix-loop.md`), improvement-log Review-cycle park, `docs/materiality-bar.md` |
| Per-run friction capture | **EXISTS** | Step 6.5 `session-feedback-collector` → `friction-log.md` + `improvement-log.md`; PostToolUse auto-capture (`friction-log-auto.sh`) |
| Routine registry with routine_id / cadence / detection signals | **PARTIAL** | `audits/pipeline-review-registry.md` (47 entries: Pipeline / Type / Tier / Last reviewed / Last memo / Friction flag). Already includes the maintenance machinery itself: `wrap-session.md`, `friday-checkup.md`, `friday-act.md`, `friday-so.md` (weekly tier), `usage-analysis.md` (quarterly) — registry lines 26–66. Lacks: cadence/time-budget/value metadata, routine_id semantics |
| Routine-IDENTITY aggregation across runs + cross-routine comparative ROI ranking | **ABSENT** | Weekly review ranks *sessions* and loose "session types"; nothing aggregates evidence per named recurring routine across runs, and nothing ranks routines against each other on a monthly horizon with merge/reduce-cadence/automate verbs |
| Recognition hook (shell) | **ABSENT — and unnecessary** | Routines here are slash-command-invoked; the invocation is the classification. Shell hooks cannot make judgment calls; `.claude/hooks/` has 17 hooks, none classify |
| Mission tracking as routine tracking | **N/A** | `logs/missions/{id}.md` exists (contra the first Explore report) but tracks multi-session *goals*, not recurring routines |

**Correction record:** the initial Explore-agent inventory reported the Session Value Audit ABSENT and the weekly roll-up ABSENT. Both shipped earlier the same day (2026-06-12, mirror note at `wrap-session.md:363`); main-session reads corrected this before the verdict. The spec was evidently written with partial knowledge of that same-day work ("whether the Session Value Audit — 80/20 Review exists" is its own §3.1 checklist item).

## 3. Overlap map — Routine Improvement Consultant vs. repo

| Consultant element | Status | Existing form |
|---|---|---|
| Evidence interpretation → prioritized recommendation | **EXISTS** | `/friday-so` — system-owner (Opus) reads full checkup report, writes prioritized Friday Advisory (`friday-so.md:1-58`) |
| Ranked improvement ideas (impact vs. effort) | **EXISTS** | `improvement-analyst` agent — ≤7 findings ranked by impact-to-effort, feeds `/friday-act` |
| Per-routine diagnosis (too heavy / unclear / duplicates / retire) | **EXISTS** | `/pipeline-review` memos: innovations / leanness / brokenness / recommended-next-session |
| Anti-overbuild check | **EXISTS** | `/implementation-triage` verdict shape + materiality bar |
| "Recommended, not implemented" default | **EXISTS** | `/friday-so` (advisory) → `/friday-act` (operator-driven execution) split |
| Fixed routine decision menu (Tighten/Template/Checklist/QC-Gate/Automate/Batch/Cadence/Merge/Retire) | **ABSENT** as fixed vocabulary | Step 6.4 `DECISION:` covers Repeat/Constrain/Batch/Redesign/Stop at session level; no Merge/Reduce-cadence/Automate verbs, no routine-level application |
| "One improvement only" | **EXISTS** | friday-checkup 14.5: "pick at most ONE recommendation from the collected RULE lines" (`friday-checkup.md:338`) |

## 4. System Owner consultation

First consult (agent a0561cf15e90af564) — formed **before** the Step 6.4 / 14.5 discovery:

- Reactive-vs-proactive distinction is architecturally real; `/pipeline-review` is the one existing proactive (non-triggered) lens.
- A distinct `/routine-improvement-consultant` command: **"real job, wrong container"** — comparative routine-yield ranking is genuine, but a standing command for a monthly pass is more process than the job needs.
- Home in `/friday-checkup` Step 6 (this investigation's preliminary verdict): **rejected** — dilutes a proactive redesign mandate into reactive housekeeping.
- Recommended shape: monthly **Routine-Yield Review** section in `/pipeline-review` + maintenance machinery as mandatory registry targets.

Re-consult with the corrected facts was attempted twice and blocked by the 1M-context credit gate (agents a79441c889115cc35, a1731c0a53e259b45 — zero tokens, API error). Resolved inline per decision-point posture, applying the SO's own framework; flagged for `/friday-so` confirmation at the next Friday cadence.

## 5. Per-component triage verdicts

| Component | Verdict | Named consequence (materiality) |
|---|---|---|
| Routine Recognition Hook (shell or wrap step) | **NOT-WORTH-DOING** | Solves a classification problem the repo doesn't have (routines are slash-command-invoked); adds a per-session tax to a 13-step wrap forever |
| 8-part Routine Task Run Review in wrap | **NOT-WORTH-DOING** | Duplicates Step 6.4's TYPE/SCORE/GATE/OPPORTUNITY/DECISION lines shipped same day; contradicts the operator's lightest-touch decision |
| New routine registry (`routine-registry.md/yml`) | **NOT-WORTH-DOING** | Second registry overlapping `pipeline-review-registry.md` (which already lists the maintenance machinery) — permanent dual-maintenance burden |
| Standalone `/routine-improvement-review` command | **NOT-WORTH-DOING** | Duplicates friday-checkup 14.5 weekly roll-up verbatim (lowest-yield, batch/stop, one-change-only) |
| `/routine-improvement-consultant` command | **NOT-WORTH-DOING** | Fourth advisory layer duplicating the `/friday-so` → `/friday-act` chain; fails the spec's own "adds more process than it removes" guardrail |
| usage-log session-type field | **NOT-WORTH-DOING** (was MARGINAL pre-discovery) | Step 6.4 `TYPE:` now captures session classification in session-notes; a second copy in usage-log is redundant metadata |
| Routine-Yield Review section in `/pipeline-review` (SO shape: monthly comparative routine ranking, decision menu incl. Merge/Reduce-cadence/Automate, two guardrails, one-improvement-only, maintenance machinery mandatory in ranking) | **MARGINAL → TRACK-FIRST** | The only genuine residual gap (routine-identity aggregation + cross-routine ROI). But the substrate it would aggregate (TYPE/SCORE/DECISION data) shipped today with zero accumulated entries — building now means designing aggregation before first evidence, the exact failure mode the spec's §7 threshold ("not enough evidence → track") prohibits |

## 6. Final verdict — TRACK-FIRST

**Do not build anything now.** The session-level 80/20 system (Step 6.4 + checkup 14.5 + friday-act consumption) shipped today and already answers the spec's core question at session granularity each week. The residual gap — routine-identity aggregation and a monthly cross-routine ROI ranking — is real but only worth building if the weekly session-level roll-up proves insufficient in practice.

**Named re-evaluation trigger:** at the first **monthly-tier `/friday-checkup` after ≥3 Weekly Session Value Review sections exist** (≈4 weeks), evaluate:

- Do the weekly roll-ups repeatedly flag the same recurring session types (Batch/Redesign/Stop decisions recurring ≥2–3 times without resolution)?
- Does drag fail to attribute to a *specific routine* because the data is session-grained?

If either holds → build the SO shape, trimmed: **one monthly Routine-Yield Review section in `/pipeline-review`** (registry targets already exist; add only "maintenance machinery mandatory in the monthly ranking"). If the weekly roll-up suffices → close as DROP. Either way, route the decision through `/friday-so` so the deferred SO confirmation happens on grounded citations.

**Mechanical pickup:** this trigger is parked as an `improvement-log.md` entry dated 2026-06-12 ("Routine-Yield Review in /pipeline-review: deferred build, named trigger"), `Review-cycle: monthly` — the Friday cadence reads that log; this memo is the reference record, not the pickup mechanism.

**Adopted from the spec regardless of trigger outcome** (no build needed — they live in this memo as the evaluation standard): the two guardrail rules ("recommend only if it reduces time/ambiguity/errors/work"; "reject any improvement that adds more process than it removes") and the automation gate (frequent + stable + decision-light, all required).

## 7. Side findings (routed separately)

1. **system-owner grounding scoping defect** — when spawned from `ai-resources/`, the system-owner agent globbed only the ai-resources tree, declared its grounding corpus "verified-absent," and fired its Shape-1 degraded mode. The corpus exists at `projects/axcion-ai-system-owner/references/` (workspace root). → logged to `logs/improvement-log.md` 2026-06-12.
2. **1M-credit subagent gate** blocked two consultation spawns mid-session (zero-token API errors) — consistent with the known gate in workspace CLAUDE.md § QC Independence; noted here as session context, no new defect.
3. **Same-day blindness in fan-out inventory** — the Explore inventory missed features shipped earlier the same day; main-session verification of load-bearing ABSENT claims caught it. Pattern worth remembering when auditing a repo that changed hours earlier; no structural fix proposed (materiality: one-off, evidence threshold not met).

## 8. Limitations

- SO re-consult with corrected facts could not run (credit gate); the TRACK-FIRST verdict applies the SO's framework inline and awaits `/friday-so` confirmation.
- The first Explore inventory's other EXISTS/ABSENT claims were spot-verified only where load-bearing (Step 6.4, 14.5, registry contents, missions, friday-so); non-load-bearing rows carry ordinary fan-out confidence.
