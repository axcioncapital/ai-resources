# Decision Journal

> Archive: [decisions-archive-2026-05.md](decisions-archive-2026-05.md)

## 2026-06-01 — DR-8 concurrent-session detection hook: Option B (read-only) over Option A (registry)

**Context.** Building the DR-8 hook (proactive concurrent-session early-warning). The session plan's recommended design (Option A) was a SessionStart hook maintaining a `logs/.active-sessions` registry file — append session_id+epoch per session, prune by TTL, warn if another live session_id survives.

**Decision.** Adopt Option B (read-only detector): the hook counts running Claude Code CLI processes via `pgrep -f 'native-binary/claude'` and warns if ≥2 are live. No state file of its own; reads `logs/.session-marker` only as read-only enrichment context.

**Rationale.** `/risk-check` returned PROCEED-WITH-CAUTION on Option A, Hidden coupling Medium driven by a non-atomic registry write window — a write race in the very file built to detect races (principles AP-10). The system-owner second opinion (Function B advisory) recommended Option B explicitly: reading an existing OS signal achieves the same proactive warning with (a) zero new shared-mutable state, so no inheritance of the `.session-marker` clobber bug; (b) no dependency on the undocumented harness `session_id` stdin field (an OP-3 gap); (c) no atomic-write mitigation needed (no write). Option B is a strict risk reduction vs the gated Option A, so the PROCEED-WITH-CAUTION gate covers it without re-gating. Signal verified live against the process table (1:1 process:session ratio; subagents run in-process and do not add matches).

**Alternatives considered.** (1) Option A registry — rejected per AP-10. (2) Marker-recency-only check — rejected: trusts the clobbered `.session-marker` oracle and false-positives on same-session `/prime` re-runs (the marker is used in Option B only as read-only enrichment, never as the detection signal). (3) PreToolUse write-to-session-notes guard — rejected: high firing frequency, overlaps the existing Step 0.5 / wrap Step 3.5 reactive guards, no proactive early warning. (4) TOCTOU Phase 4 structural rework — explicitly out of scope per the mandate (separate scheduled item).

**Known limitation (accepted).** The process count is machine-wide, not project-scoped — a session in an unrelated project also triggers the warning. Best-effort tradeoff for a non-blocking warning; a future `lsof` cwd-scoping enhancement is documented in `docs/session-marker.md`.

## 2026-06-01 (S2) — Context-Engine Phase 1: PASS, promote

**Context.** Deferred S6/S9 evaluation of the context engine MVP. Scored 5 real engine packs (3 from prior dev work, 2 fresh) against the 6 Brief-1 criteria. Pass threshold: ≥3 of 5 tasks ≥4-of-6.

**Decision.** PASS (5/5 tasks ≥4-of-6) → keep the engine and promote it past Phase 1.

**Rationale.** Citations precise and verified-accurate on every spot-check (first-hand on 2 packs I executed this session). Criteria 1–5 met on all 5 packs. The only criterion-6 misses are inherently operator-gated tasks (`sufficient_to_implement: false` by honest design) — the engine's caution is a feature. QC REVISE applied (Pack 3 staleness settled via git; criterion-6 framing softened to a rubric recommendation, scores kept at 5/6).

**Alternatives considered.** Run all 5 fresh (rejected — real-task packs are stronger evidence than synthetic test runs; used 3 real + 2 fresh). Defer again (rejected — multi-session carryover, operator chose to act).

## 2026-06-01 (S2) — Marker-clobber guard: Option 1 rejected, escalate to Option 2

**Context.** /wrap-session Step 3.5 marker-aware guard false-negatives when a concurrent /prime clobbers logs/.session-marker (incident 2026-05-29). Improvement-log specced Option 1 (a file-only clobber-suspicion sanity check).

**Decision.** Option 1 REJECTED at the dry-run (after implementation + risk-check + system-owner concur); reverted clean. Escalate to Option 2 (per-process `CLAUDE_SESSION_MARKER` env var).

**Rationale.** A temp-git fixture replaying the exact incident returned CLOBBER=0 FOREIGN=0 — the silent false-negative persisted. There is no clean file-only signal: in the real incident `.session-marker` reads the FOREIGN marker, so the foreign content matches MARKER while this session's own (committed) header is the "other." The uncommitted-only restriction (needed to avoid false-positives) therefore never fires on the incident; the broader signal false-positives on every second-or-later same-day session (rubber-stamp, AP-4). The clobber and benign-sequential cases are structurally identical in the files because the marker — the identity oracle — is the very thing clobbered. pgrep-at-wrap also unreliable (foreign session may have exited).

**Alternatives considered.** Ship the broader any-other-marker signal (rejected — constant false-positives). pgrep-at-wrap (rejected — foreign session may have exited by wrap). Keep marker-as-oracle (rejected — root cause; Option 2 replaces it).

## 2026-06-01 (S3) — CLAUDE.md mirror-block leanness: risk-tiered trim (decision only; execution deferred to gated session)

**Context.** Monday-prep 2026-W23 flagged that all 13 project `CLAUDE.md` files verbatim-duplicate 4 canonical workspace blocks — **Input File Handling**, **Commit Rules** (commit + push), **Compaction**, **Session Boundaries** — at ~430–720 tok/turn each (always-loaded, every turn, every project session). Each block carries an explicit footer: "This rule mirrors the canonical X in workspace CLAUDE.md. Repeated here because projects are sometimes opened without the parent workspace context loaded." The mandate (S3 item 3) was to decide keep-vs-trim and record the choice.

**Standing contradiction surfaced.** Workspace `CLAUDE.md` § CLAUDE.md Scoping already states: *"Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not."* The current mirror practice directly violates this canonical rule. Separately, the S2 push-policy incident (11 project files had drifted to "After committing, push automatically", contradicting the 2026-05-29 gated/batched inversion) is **empirical proof that verbatim mirroring across 14 files causes silent drift bugs** — the exact failure the scoping rule guards against.

**Decision — risk-tiered trim (not a blanket keep or trim):**
- **KEEP verbatim:** Input File Handling + Commit Rules. Rationale: these are *high-harm-if-absent* in a genuine standalone open (cwd = a project's own git repo with no workspace ancestor loaded) — losing the input-file read-only discipline risks data loss; losing the commit/push gate risks an unwanted push or a secret commit. A *pointer* gives zero protection in a standalone open (the pointed-to file isn't loaded), so for these two blocks the only safe shapes are "verbatim" or "absent" — and absent is unacceptable.
- **TRIM to a one-line canonical pointer:** Compaction + Session Boundaries. Rationale: *low-harm-if-absent* — losing these in a standalone open degrades efficiency only (worse compaction, dirtier context), never causes data loss or an external side effect. The scoping rule's "short pointer acceptable" shape fits cleanly.
- **Amend § CLAUDE.md Scoping** to document the safety carve-out explicitly: "verbatim duplication is not [permitted] — except for safety-critical rules (input-file discipline, commit/push gating) whose absence in a standalone-open project would risk data loss or an unwanted external write; those may mirror verbatim." This converts the silent contradiction into a documented, bounded exception.

**Net effect (when executed):** removes ~2 of 4 mirror blocks × 13 files (the Compaction + Session-Boundaries duplication, ~half the per-turn mirror token cost) while preserving the standalone safety floor and ending the canonical-rule contradiction.

**Execution deferred.** The trim itself is a cross-cutting CLAUDE.md edit across 13 project files + a workspace CLAUDE.md amendment — a structural change class per `audit-discipline.md` (cross-cutting CLAUDE.md edits). It needs its own plan-time `/risk-check` and should NOT be bundled into this session's context alongside the Option 2 marker fix (a second structural wave). Per the deliverable contract, the **decision is the S3 item-3 output**; the 13-file execution is a dedicated `/risk-check`-gated follow-up session.

**Alternatives considered.** (a) **Keep all 4 verbatim** — rejected: perpetuates the canonical-rule contradiction and the proven drift-bug surface (S2 push-policy) for two blocks whose absence is harmless. (b) **Trim all 4 to pointers** — rejected: a pointer is useless in a standalone open, so this silently strips the data-loss / unwanted-push safety floor the operator deliberately built. (c) **Keep all verbatim but add a drift-detection hook** — rejected for now as heavier than the harm warrants; revisit if the risk-tiered trim proves insufficient. (d) **Decide + execute the trim this session** — rejected: cross-cutting CLAUDE.md edit is structural, would stack a second risk-check-gated structural wave into one session (context-contamination per AP-8); the mandate asked to decide + record, not execute.

## 2026-06-01 (S3) — Option 2 marker fix: env-var mechanism infeasible → Option 2′ (session-id-keyed), implement fresh

**Context.** Marker-clobber root-cause fix. improvement-log specced Option 2 as "session-scoped marker via env var `CLAUDE_SESSION_MARKER` set at /prime." S3 Wave 4 set out to implement it.

**Decision.** (1) Option 2-as-worded is REJECTED as infeasible. (2) Redesigned as Option 2′: key the marker by the harness-injected `CLAUDE_CODE_SESSION_ID`. (3) Land Option 2′ as a GO-eligible spec; implement in a fresh dedicated session, NOT in this multi-wave session.

**Rationale.** Probed live: exported env vars do NOT persist across Bash tool calls (each call is a fresh shell — Bash-tool contract states this). A var /prime exports is gone before /session-start, let alone /wrap-session — the same look-right-do-nothing failure that killed Option 1. But `CLAUDE_CODE_SESSION_ID` is injected by the harness into every Bash env, probed stable across calls, unique per session, not a file → un-clobberable. Keying the per-session marker file by it removes the identity oracle from the clobber surface. Plan-time /risk-check = PROCEED-WITH-CAUTION (blast radius + hidden coupling High); system-owner concurred and explicitly advised fresh-session implementation. Three convergent signals for deferral: context state (3 waves + 14 subagents → Context-constraint-deferral, OP-4/AP-8), the S2 "validate before invest" lesson, and atomicity (a half-landed 9-consumer contract is the worst outcome).

**Alternatives considered.** (a) Implement now under a strict atomic-commit floor — rejected per both reviewers + the deferral rule; the operator's "do everything now" predated the infeasibility finding that reframed the work. (b) Implement a minimal core (wrap guard + /prime only) — rejected: leaves the contract half-migrated, the exact drift state DR-8/risk-topology §5 warns against. (c) Keep escalating reactive guards on the clobbered oracle — rejected; Option 1 proved no clean file-only signal exists. Full spec: `audits/option2-marker-redesign-2026-06-01.md`; risk-check: `audits/risk-checks/2026-06-01-option2-marker-redesign-claude-session-id-keyed.md`.

## 2026-06-01 — wrap-session as a system feedback loop (collector + outcome check)

**Context.** Operator wanted `/wrap-session` to stop being only a closeout ritual and start feeding "how the session went" back into the system — improvements, friction, optimization, dangerous events — measured against the system's goal state, plus "did Claude do what it was supposed to do, optimally."

**Decision.** Built two separate advisory, opt-in wrap passes: (1) a fresh-context feedback **collector** (Step 6.5) routing five-dimension signals (incl. safety/guardrail-gap) to existing consumer-backed stores; (2) a fresh-context **outcome check** (Step 6.4) grading completion + execution quality. Both never block. Collector writes only friction-log + improvement-log with an enforced ≤2/session cap + provenance tags. Reusable-component signals → `/innovation-sweep` nudge, not a registry write. Workspace-root mirror deferred (tracked). Outcome check reuses `/contract-check`'s mandate-resolution chain + inline-subagent pattern (no new agent).

**Rationale.** System-owner consult (twice) was decisive: the genuine non-overlapping gap is *per-session capture at wrap time* (every downstream analyzer runs after the session, reading logs). Building a second analyzer would duplicate `/improve` + `/friday-so` (AP-7), tax every session (§2.5), and risk a write-only open loop. The collector-not-analyzer framing + feed-existing-stores closes the loop through consumers that already exist. System-owner also caught the soft-cap starvation failure mode (a chatty collector crowding out operator-authored Friday signal) → enforced cap + provenance ranking. Goal state grounded in vault `system-doc.md` §2/§4.5 + `principles.md` OP-1/OP-9/OP-11.

**Alternatives considered.** (a) One combined "session reflection" pass — rejected: mixes two clean questions (system-goal vs mandate-completion); system-owner advised separation. (b) A 6th collector dimension for completion — rejected, same reason. (c) New dedicated feedback data store — rejected: no consumer yet = write-only open loop. (d) Fold optimality into `/usage-analysis`/`/coach` — rejected: those are telemetry/cross-session; this grades this run against this mandate. Risk-checks: feedback-collector PROCEED-WITH-CAUTION (6 mitigations applied); outcome-check GO. Commits d2cc3cd, 30fa2f0.
