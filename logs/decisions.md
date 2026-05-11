# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-05-08 — Ship session-class classification as Step 1 only (defer downstream rules)

**Context.** Operator proposed a session-class declaration mechanism (design vs execution vs mixed) for `/session-plan` to fix asymmetric failure modes — design sessions accumulate rework when constraints surface late, execution sessions pass cleanly. Full proposal included a five-rule package (constraint-set, path verification, higher QC expectations, heavier risk-check bias for design; trust-the-plan, first-pass-clean, skip-constraint-set for execution). The operator's own writeup recommended a phased rollout: ship the classification prompt only, run for a week, layer rules after.

**Decision.** Implement only Step 1: the classification prompt in `/session-plan` plus persistence to `session-plan.md` and `session-notes.md`. Defer all downstream class-specific rules (constraint-set, path verification, frontmatter declarations on existing commands, QC-expectation adjustments) until after a one-week observation window.

**Rationale.** Cost of a five-rule package on day one: high — five rules to debug simultaneously if the classification itself turns out to be wrong. Cost of Step 1 alone: minimal — one prompt, two writes, fully reversible by editing one file. Observability gain: Step 1 produces the data (`Class:` lines in session-notes) that lets the operator and downstream coaching see whether the classification feels natural before committing to rule wiring. Matches the operator's stated preference (memory: prefers automated infrastructure that fires automatically over disciplines maintained by hand) but also matches the proposal's own "smallest first move" framing.

**Alternatives considered.**
- *Ship the full five-rule package now:* Rejected. Higher debugging surface, harder to roll back, and the proposal itself recommended phased rollout.
- *Add frontmatter class declarations to existing commands now (skip the prompt for known-class commands):* Deferred. The prompt is universal; frontmatter is an optimization that can land in week 2 once the classification taxonomy is validated.

---

## 2026-05-08 — Fading-gate detection: [FADING-GATE] items need no /friday-act intercept

**Context.** Implementing the gate-health monitoring feature (deferred from the autonomy-posture-change session). Original plan included a dedicated triage handler in `/friday-act` that would intercept `[FADING-GATE]` items and present the three remediation options (retire / lower-frequency / recalibrate) before writing to `improvement-log.md`. QC pass flagged the insertion point was underspecified — specifically, how `[FADING-GATE]` items would be excluded from the standard `f/d/s` prompt to avoid double-disposition.

**Decision.** No `/friday-act` change. `[FADING-GATE]` items are treated as standard medium-risk tactical follow-ups, flowing through the existing Step 3 `f/d/s` loop unchanged. When dispositioned `f`, Step 3.6 generates a plan file. The three-option pick (retire / lower-frequency / recalibrate) and the `improvement-log.md` write happen in the plan-file execution session, not during `/friday-act` triage.

**Rationale.** Reading `/friday-act` in full showed the Step 3 `f/d/s` loop already handles all tactical items generically — there is no per-tag dispatch, and none is needed. `[FADING-GATE]` items contain the three-option prompt in their text (`"Pick: retire / lower-frequency / recalibrate"`), which is visible in the plan file the execution session receives. Adding an intercept in `/friday-act` would require specifying which sub-step intercepts the item, how to exclude it from the standard prompt, and how to route the chosen disposition — all overhead that the existing plan-file pattern handles for free.

**Alternatives considered.**
- *New intercept in /friday-act Step 3:* Rejected. Adds control-flow complexity (intercept point, exclusion from f/d/s, inline improvement-log write) for no practical gain — the plan file is sufficient context for the execution session.
- *New sub-step in /friday-act Step 3.5 (SO-derived / journal-derived additions):* Rejected. Same overhead; [FADING-GATE] items are checkup-derived, not SO-derived.

---
- *Write only to `session-plan.md`, not `session-notes.md`:* Rejected. Downstream rules need a persistent grep target; session-plan.md is overwritten each session and can't carry historical signal.

## 2026-05-11 — Abandon /session-plan to recover from session-mandate drift

**Context.** Session started with operator intent: run /prime → /session-start → /monday-prep. During /session-start mandate confirmation, operator replied `c. Next /session-plan` meaning "confirm; next session will be /session-plan." Claude parsed `c.` as a correction to field c ("Done when") and silently baked /session-plan into the current session's mandate. Cadence ran through Phase D successfully, then /session-plan was invoked. Mid-/session-plan, operator detected the drift ("we have completely drifted off to something else") and halted execution.

**Decision.** Recovery option 1: abandon /session-plan for this session, log the two instruction gaps in friction-log, wrap normally. /monday-prep is the work; it is done.

**Rationale.** Three recovery options were considered: (1) abandon /session-plan, (2) write a session-plan.md scaffolded for a future session, (3) treat scratchpads-convention as legitimate work and execute now. Option 1 matches what the operator actually intended (/monday-prep was the session). Option 2 produces an artifact for a session we may not run with this framing. Option 3 doubles down on the drift. Option 1 also preserves the discovered instruction gaps as friction-log evidence for a separate fix-session.

**Alternatives considered.**
- *Continue /session-plan and execute the scratchpads-convention work:* Rejected. The work item is real but it was not the session's intent; conflating drifted-intent with operator-intent erodes the trust contract.
- *Continue /session-plan but stop after writing session-plan.md (Option 2):* Rejected. The session-plan file would describe a future session we may run with a different framing; better to write that file fresh when actually starting that work.
- *Roll back monday-prep commits and re-run:* Rejected. /monday-prep ran correctly through Phase D; the drift was only in the trailing /session-plan invocation, which produced no committed artifact.
