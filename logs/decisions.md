# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-22 — /prime redesign: slim brief + numbered task menu + session-start chaining

**Context.** The operator (a non-developer) reported `/prime`'s start-of-session brief was too dense — ~15–20 status-field lines in terse log shorthand, hard to scan and hard to understand. Request: shorter, plain-English, project-scoped, ending in a numbered 1–3 task menu where typing a number auto-runs the session-setup commands. Scoped via `/clarify` (4 questions) and an approved plan.

**Decisions.**
1. **Number flow — run both, then pause.** Typing 1–3 runs `/session-start` then `/session-plan`, shows the plan, and pauses for review. Not "start work immediately" — preserves the existing plan-review gate.
2. **Brief content — exception-based.** `/prime` shows only the last-session line, the numbered menu, and exception lines (carryover, HIGH-urgent problems, model mismatch, dirty tree, pull failure) that appear only when real. Inbox count, innovation count, and the decisions list are dropped from the default view; a footer points to `/open-items`.
3. **Task source — last-session + next-up, no subagent.** The 1–3 menu draws from last-session Next Steps and `next-up.md`; HIGH-urgent problems from a light `friction-log` / `improvement-log` scan are promoted into the menu. No subagent — `/prime` does the plain-English conversion inline (Sonnet).
4. **No project-scoping logic.** `/prime` already reads only the cwd repo's logs; the operator confirmed scope was already correct. The fix is density + wording only.
5. **Plan-mode guard.** Operator instruction mid-session: typing a number while plan mode is active must NOT start the `/session-start` chain — it defers until plan mode is exited (= ready to execute).

**Rationale.** The operator's `/clarify` answers drove decisions 1–4 directly. "Run both then pause" keeps the existing plan-review gate intact rather than auto-starting work. Exception-based density honors the operator's "only show next steps, carryover, urgent fixes" instruction while keeping rare-but-useful signals (model mismatch, pull failure) available when they fire. The no-subagent choice keeps session start fast and cheap. The plan-mode guard reflects the operator's mental model: plan mode = still planning; `/session-start` = ready to execute.

**Alternatives considered.**
- *Ultra-minimal brief (menu only):* Rejected by operator — wanted carryover + urgent-fix visibility.
- *Compressed all-fields brief:* Rejected by operator — chose exception-based over keeping every field.
- *Subagent-ranked task menu:* Rejected — adds cost and latency to every session start; last-session + next-up is sufficient.
- *Wide-scan task source (merge open-items, improvement-log, decisions and rank all):* Rejected — heavier read each session start; the lightweight source was chosen.

---

## 2026-05-22 — /prime scratchpad selection: sort by mtime, overriding the spec's anti-mtime rule

**Context.** A logged friction entry (2026-05-22 14:54) reported `/prime` Step 1b surfacing a stale "resumable scratchpad" as the resume point. Root cause: scratchpad filenames carry AI-typed `HH-MM` timestamps skewed 2–3 hours ahead of real write time (observed: a `16-30` filename written at 13:04, a `14-00` filename written at 11:25), and Step 1b selected the "most recent" by lexical filename sort. The friction entry's fix option (a) — "sort by mtime" — directly contradicted the `/prime` Step 1b spec, which explicitly forbade mtime sort ("a scratchpad's mtime can disagree with its filename ... an mtime sort can surface the wrong file").

**Decision.** Change `/prime` Step 1b to select the most-recent scratchpad by **filesystem mtime**, and rewrite the rationale. The downstream date-comparison bullet was also switched to the mtime date for internal consistency.

**Rationale.** The conflict resolves on a fact rather than a judgment call. The spec's anti-mtime rationale is the "pulled file carries checkout-time mtime, not write-time mtime" failure mode — but `logs/scratchpads/` is gitignored (`.gitignore` line 28, confirmed via `git check-ignore`). Git never writes gitignored files, so that failure mode cannot occur for this directory; mtime always reflects the actual local write time. The filename timestamp, by contrast, is typed by the AI session and is the unreliable signal here. The spec's rule is correct in general but wrong for this specific (gitignored) directory. Because the conflict was settled by fact, it was resolved without an operator stop (the `/session-plan` stop point only fires if the fix-approach cannot be resolved from the friction entry + spec).

**Alternatives considered.**
- *Keep lexical filename sort:* Rejected — it is the bug; filename times are skewed 2–3 h.
- *Monotonic filename time source (friction option b):* Rejected for this fix — it would edit `/handoff` and `/wrap-session` filename generators, outside the Min scope, and would not repair already-skewed filenames.
- *Prune stale scratchpads (friction option c):* Rejected — file deletion (Autonomy Rule #3 gate) and a `/wrap-session` change, not a `/prime` change; mtime sort solves the misrouting without deleting anything.

## 2026-05-22 — Session-issue investigation scoped to manual-only (auto-trigger hook dropped)

**Context.** Building an "investigate the issue" capability so that when Claude reports a session/workflow fault, it can be investigated and logged for the Friday fix cadence. The plan grew to include automatic triggering — an `[ISSUE]` guardrail flag + a workspace-`CLAUDE.md` rule, and a blocking `Stop`-hook backstop (`check-issue-investigated.sh`). That design passed `/qc-pass` (GO) and `/risk-check` (PROCEED-WITH-CAUTION; system-owner `/consult` concurred).

**Decision.** Drop the auto-trigger entirely — both the `[ISSUE]` flag/rule and the blocking hook. Ship manual-only: `/resolve-repo-problem` extended with MANUAL + AUTO modes (both operator-invoked) plus `/friday-checkup` pickup. 2 files instead of 6.

**Rationale.** The blocking `Stop` hook was the first of its kind in the repo and the highest-risk component, while being only a backstop of low marginal value — the rule alone already delivers the automatic behavior. The repo's own `session-guardrails.md` discipline says do not add hooks preemptively; promote a rule to a hook only after the rule proves unreliable. Dropping the hook also removes every `/risk-check`-gated change class from the change set.

**Alternatives considered.**
- *Keep the hook (full 6-file plan):* Rejected — QC-clean and risk-checked, but preemptive and low-value relative to its novelty risk.
- *Rule without hook (4 files):* Rejected by operator — preferred to avoid even the always-loaded rule for now; manual is simpler and the auto-trigger can be added later as a separate change.
- *Manual-only (chosen):* `/resolve-repo-problem` operator-invoked; revisit the auto-trigger later only if manual invocation proves easy to forget.


## 2026-05-25 — permission-sweep-auditor template-class detection: silence-not-downgrade

**Context.** The 2026-04-28 improvement-log entry booked a fix for `permission-sweep-auditor` to teach it to recognize workflow template settings files (e.g., `workflows/research-workflow/.claude/settings.json` with `{{WORKSPACE_ROOT}}`) and not flag the intentional `{{...}}` placeholders as Rule 8 violations. The existing Step 4a heuristic already detected the placeholder pattern and downgraded findings to ADVISORY — yet on 2026-05-11 a downstream `permission-sweep Bundle 1` session (commit `0514590`) treated the ADVISORY-tagged finding as actionable and replaced `{{WORKSPACE_ROOT}}` with a literal absolute path, breaking the template. The improvement-log entry's stated risk ("accidental 'fix' by a future agent") materialized as a real regression incident between booking and execution. Risk-check verdict on the planned fix was PROCEED-WITH-CAUTION; system-owner second opinion concurred and added a structural recommendation.

**Decisions.**

1. **Replace ADVISORY downgrade with full SILENCE for placeholder-bearing template files.** When BOTH the path-class signal (`**/workflows/*/.claude/settings.json`) AND the value-class signal (`{{[A-Z_]+}}` placeholder) fire, the auditor emits NO finding at any severity, not even ADVISORY. This removes the surface area for a future remediation pass to misread the finding as actionable.

2. **Add active regression detection — HIGH `Template integrity` finding when only the path-class signal fires.** A file matching `**/workflows/*/.claude/settings.json` whose placeholders have been replaced by literal paths triggers a HIGH finding with explicit remediation hint: "Restore the placeholder; do not 'fix' the literal path. `/deploy-workflow` fills placeholders at deploy time." This converts the regression mode into a true-positive detection.

3. **Restore the broken template file in the same bundle.** Line 34 of `workflows/research-workflow/.claude/settings.json` restored from the literal hardcoded path back to `{{WORKSPACE_ROOT}}` as part of Item A's commit.

**Rationale.** The 2026-05-11 incident demonstrated empirically that ADVISORY findings are insufficient protection — a downstream remediation pass can and did treat an ADVISORY as actionable. Two structural fixes are needed: (a) make the placeholder case unobservable to the remediation pass (silence, not downgrade), and (b) detect the regression mode actively so the system surfaces the failure if it recurs. Silencing alone would leave the system blind to the placeholder-replaced state; active detection alone would still leave the placeholder case as an attractive ADVISORY target. Both together are belt-and-suspenders without the cost of two parallel heuristics — the unified two-signal state machine handles all cases.

**Alternatives considered.**
- *Keep downgrade-to-ADVISORY, change nothing else:* Rejected — proven insufficient on 2026-05-11.
- *Path-based heuristic ALONGSIDE the placeholder heuristic (two parallel rules):* Rejected per system-owner advice — two heuristics targeting the same false-positive class create a silent conflict surface (which heuristic wins when they disagree?). Better to unify into one detection step with three outcomes.
- *Move the template file out of the workflow-templates directory:* Rejected — the directory contains other intact templates (CLAUDE.md still has `{{PROJECT_TITLE}}` etc.). The right fix is restoring the file's template state, not relocating it.
- *Add the parallel fix to `repo-health-analyzer/SKILL.md` in the same bundle:* Rejected per system-owner advice — each canonical agent/skill edit is its own change class; bundling expands blast radius without expanding the risk-check coverage. Deferred to its own session (also: grep confirms the skill has zero references to `additionalDirectories`, `{{`, `Rule 8`, or `template-class`, so there is currently nothing to mirror).


## 2026-05-25 — [FADING-GATE] generalization: verify-before-edit posture for booked items

**Context.** Two of three planned items in the 2026-05-25 session-plan (E: /note + /friction-log session-header format fix; F: Sequencing note Session 1 — Model Tier + subagent-summary cap) were caught as already-done by drift during execution. Item E's underlying work had shipped on 2026-05-22 (commit `3a7ad4c`); Item F's three rule components had been codified into workspace and ai-resources CLAUDE.md sections at some point after the source entries were logged. The session-plan was booked from stale historical references — the 2026-05-22 Triage block for E, and the older Sequencing note for F. The system-owner advisory on Item A explicitly named the "fading-gate" pattern as a missed risk in the original risk-check report and recommended verifying the trigger state before editing.

**Decisions.**

1. **Apply verify-before-edit as a posture for all booked-from-stale-references items**, not just the one item that surfaced it. After verifying Item A's premise (which turned out to also be partially stale — the template file had been regressed), generalized the same posture to Items E and F before any command-file edits were attempted. Both verifications caught the booking as a [FADING-GATE].

2. **Log annotation-only commits for already-done items.** Rather than skipping silently or marking the booking as "obsolete," wrote explicit annotation commits to the improvement-log preserving the audit trail: Item E's commit (`766c0ae`) annotated the 2026-05-22 Triage block with "SHIPPED 2026-05-22 commit 3a7ad4c"; Item F's commit (`d5ae398`) annotated the Sequencing note with "VERIFIED-DONE 2026-05-25" plus the codification evidence. This is cheaper than re-doing the work and keeps the historical record honest.

3. **Surface for monthly gate-calibration.** [FADING-GATE] fired twice in one session — recording in the next monthly `/friday-checkup` per the gate-calibration system memory.

**Rationale.** Bookings made in one session can become stale during the interval before execution. Trusting the booking's stated trigger without re-verifying the current state of the world risks two failure modes: (a) doing work that has already been done (wasted effort), or (b) doing the wrong work if the original problem has evolved (incorrect output). The verify-first posture protects against both. The cost is one Read per item before editing — much cheaper than the edit + QC + commit cycle for work that didn't need to happen.

**Alternatives considered.**
- *Skip silently when already done:* Rejected — leaves no record that the booking was checked. A future audit would re-discover the same situation.
- *Mark the booking obsolete and remove the entry:* Rejected — destroys the audit trail that tracks why the entry existed in the first place.
- *Annotate with verification evidence (chosen):* Preserves the improvement-log entry as historical context AND records that this session checked and found the work already shipped. Future sessions can read the annotation and understand the lifecycle.

---

### 2026-05-25 — Sonnet 200k efficiency plan: scope and rejection decisions

**Context:** Three rounds of ChatGPT advisories on Sonnet 200k session efficiency reviewed and triaged. System-owner consulted three times. The following decisions are load-bearing for the resulting implementation plan.

**Decision 1: ChatGPT rec #9 (90/10 Sonnet/Opus ratio doctrine) — Rejected**
The advisory recommended a 90/10 Sonnet/Opus ratio as a workspace posture. Rejected as a direct conflict with workspace CLAUDE.md § Model Tier, which prohibits model-default declarations anywhere. Per-task tier judgment (QS-5: "Is the hard part deciding what to do → Opus, or executing what is decided → Sonnet?") already covers the same concern correctly.
**Alternatives considered:** Accept as an operator-facing guideline doc (not a setting) — rejected as redundant with QS-5.

**Decision 2: Permission deny rules for archive directories — Rejected**
The second advisory recommended deny rules in `settings.json` for `archive/**`, `old-reports/**` etc. Rejected on three grounds: AP-7 (speculative scaffolding, no evidence of harm), OP-2 conflict (autonomy default), and blast radius on /log-sweep, /wrap-session, /repo-dd, /friday-checkup which all do legitimate archive reads.
**Alternatives considered:** Scope narrowly to workspace-level only — rejected, same blast radius on archival operations.
**Routed to:** `ai-resources/docs/heavy-read-discipline.md` (docs-only, Task 5 optional) instead.

**Decision 3: `read_budget` mandate field — Rejected**
Proposed adding a numeric read budget to session-start.md. Rejected: duplicates [HEAVY] guardrail, OP-2 binding-at-mandate conflict, and expands the parse contract against an uncalibrated number.
**Alternatives considered:** Separate `read_budget:` field vs. folding into `allowed_inputs` — both rejected.

**Decision 4: Task 4 (discovery-first pattern doc) — Deferred with strengthened bar**
System-owner strengthened the DR-7 trigger: the bar is that a command body must cite the pattern doc and would degrade without it — not merely that four commands "would benefit." Trigger: add inline instruction to one heavy command first; write pattern doc only when a second command needs the same instruction.

**Decision 5: Task 3 sequencing reframe**
Tasks 1, 2, and 3 are technically independent (disjoint files). Sequencing is risk-ordered not dependency-ordered. Execution session may proceed to Task 3 if Tasks 1 or 2 hit a blocker.


## 2026-05-25 — R9 (reference-skill symlinks) deferred — generic-vs-canonical divergence is intentional, not drift

**Context.** Token-audit R9 (2026-05-25 §9.2) recommended converting the 2 reference-copy skills under `workflows/research-workflow/reference/skills/` (`knowledge-file-producer`, `report-compliance-qc`) to symlinks pointing at canonical `skills/<name>/`, framed as a "drift-elimination quick win." Diagnostic backlog wave 1 session executed pre-flip verify before flipping.

**Decision.** Defer R9. Reframe before reattempting.

**Rationale.** Pre-flip verify ran `diff` between canonical and reference copies. Result: reference copies are NOT stale — they're substantively different. Canonical has acquired (a) `model:`/`effort:` frontmatter convention added after the workflow's Phase 0 lock, and (b) project-specific scoping ("serves the Claude Chat project for the Buy-Side Service Model" in canonical vs. generic "serves the Claude Chat project" in reference). Symlinking would propagate Buy-Side-specific content into every future `/deploy-workflow` instantiation of `research-workflow` — incorrect for any project that isn't Buy-Side.

**Alternatives considered.**
1. **Flip anyway** — rejected; breaks workflow deploy semantics.
2. **Restructure with a `reference-generic/skills/` location** — viable; preserves intentional divergence by namespace. Defers the decision on whether canonical should be Buy-Side-specific or whether Buy-Side scoping should move to a project-local override.
3. **Accept the divergence as intentional, close R9 in the audit backlog** — also viable; documents that drift between generic and canonical IS the design intent for these two skills, not a bug.

**Owner action.** A dedicated session with the research-workflow project owner to pick between (2) and (3). Until then, R9 is closed-as-deferred in this session's backlog, not closed-as-applied.


## 2026-05-25 — Diagnostic backlog bundle session

**Decision 1: SF2 dropped from this session per assumptions-gate**
The session mandate originally bundled SF2 (/compact checkpoints in 7 commands) into Wave 2 alongside R1. Pre-write assumptions check caught the most recent session-notes entry: "SF1 broad + SF2 / R5 — wait until Sonnet 200k Task 1 has landed (collision concern on compaction-protocol.md cross-references)." Reduced Wave 2 to R1 only; mandate rewritten before /session-start completed.
**Rationale:** SF2's checkpoint declarations in 7 command files would reference names not yet defined (Sonnet 200k Task 1 adds the named-checkpoint vocabulary). Either invent ad-hoc names that Task 1 may rename, or land collision-prone edits on overlapping infrastructure.
**Alternatives considered:** (a) Run SF2 anyway with ad-hoc names — rejected, creates cleanup work and potential rename collisions. (b) Cancel the whole session — rejected, R1 is independent. (c) Drop SF2, keep R1 — chosen.

**Decision 2: System-owner refinements to R1 design adopted in full**
Risk-check returned PROCEED-WITH-CAUTION with 2 mitigations. /consult system-owner second opinion (mandatory non-GO path) concurred and added: (a) 3rd mitigation — explicit fallback-passthrough rule in the subagent body and schema doc (no paraphrasing of `(section-target match failed — falling back to 30-line peek …)` notes); (b) agent tier sonnet not haiku (triage of which Recommendation lines materially differ from checkup tactical items is load-bearing judgment); (c) two-cycle validation not single-cycle (single cycle may not exercise section-name-variation fallback path).
**Rationale:** The system-owner identified a hidden-coupling risk that the dimension review missed — a summarizer in the middle could silently re-characterize a degraded SO advisory rather than surfacing the raw fallback. This couples four artifacts (friday-so, systems-review, friday-act, summarizer) through a behavioral contract that only fails downstream at the paste-disposition step.
**Alternatives considered:** Adopt only the 2 reviewer-mitigations — rejected, the silent re-summarization failure mode is plausible and the operator can't easily catch it.

**Decision 3: Session stopped at R1 plan-time gate per operator**
Mid-session, a concurrent session began overwriting `logs/session-plan.md` to run Item 8 (canonical templates). Operator chose option 1 (stop) over option 2 (continue R1 implementation in parallel).
**Rationale:** Parallel command-file edits across two sessions in the same repo are the documented concurrent-session collision class. R1's planned edits (new agent file + friday-act.md) and Item 8's planned edits (new templates + new-project.md) don't directly overlap, but the friction-log 14:10 entry confirms the pattern has bitten the workspace multiple times. The R1 risk-check report is a fully-specified resumable artifact — design captured on disk, picked up cleanly in a future session.
**Alternatives considered:** Continue R1 in parallel (option 2) — rejected per collision-avoidance precedent.
