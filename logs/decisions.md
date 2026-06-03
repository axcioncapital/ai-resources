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

## 2026-06-01 — /archive-project design

**Context.** Operator finished the `nordic-pe-macro-landscape-H1-2026` project and asked what system the System Owner would propose to archive a completed project. No prior whole-project closeout existed (only `/wrap-session` for sessions, `/log-sweep` for logs).

**Decision.** Build a single lean capstone command `/archive-project`. It runs a BLOCKING pre-archive checklist (hard mechanical gates: clean tree / pushed / no pending graduations + self-contained-repo guard; soft operator-attested: usage-analysis, innovation-sweep, Notion deliverables), removes skill symlinks, moves the whole project folder (with its independent `.git`) OUTSIDE the workspace to `~/Claude Code/Axcion AI Archive/{name}/`, writes a permanent index (`logs/archived-projects.md`) + a per-project restore manifest, and reports an un-archive recipe. `--dry-run` + a mandatory [y/n] gate guard the destructive phase. Project name is optional — a numbered picker lists archivable projects when omitted.

**Rationale.** Operator locked four scope choices via `/clarify`: single command (not a portfolio tracker / log-tier suite), move outside the workspace, remove symlinks, guided+blocking checklist. Lean by design: no `/unarchive-project` (the manifest IS the restore recipe), no portfolio state machine. Safety rides on manifest-before-destruction + mandatory remote backup (no-remote = hard block) since the move leaves git-tracked space and `git revert` cannot restore it. System Owner concurred with the PROCEED-WITH-CAUTION risk verdict and caught a missed risk — two grounding docs (`risk-topology.md`, `repo-state.md`) hard-list active projects by name and go stale on archive; fixed via a one-line Step 9 staging note (live-enumerating commands self-heal, so no code change needed there).

**Alternatives considered.** (a) Portfolio status tracker (Active/Dormant/Completed/Archived) — rejected, operator chose the lean single command. (b) Freeze-in-place + git tag (no move) — rejected, operator chose move-outside. (c) Convert symlinks to copies for provenance — rejected, operator chose removal. (d) Separate `/unarchive-project` command — rejected as scope creep; manifest + documented manual recipe suffices. QC: GO. Risk-check: PROCEED-WITH-CAUTION (mitigations satisfied). Commits: new command + picker enhancement (local, this session).

## 2026-06-01 — /fix-repo-issues in-session execution: two plan assumptions overridden (S4)

**Context.** Executed the `/fix-repo-issues` plan in-session (operator "Execute here"). Two of the four planned items carried plan-level assumptions that the actual files contradicted.

**Decision (id-03 — defer, do not edit).** Did NOT fold the G4 timberland/natural-resource naming into the nordic screening criteria. The live `locked-criteria.md` is v4.4, finalized the same day mid-S5 with an independent qc-reviewer PASS and a changelog that deliberately enumerated its scope (G9 + 4f only). The asset-class disqualifier text isn't even in the live file — it's a delta-changelog carrying G4 "verbatim from v4.3" — so the edit is not single-file. GreenGold was already correctly excluded via the out-of-scope-mandate route, so there is no live correctness gap. Editing signed-off live analytical criteria mid-run on a documented-as-optional naming nicety was surfaced as an Assumptions-Gate concern and deferred to a deliberate v4.5 / W2 pass.

**Decision (id-04 — reciprocal pointer, do not merge).** The plan assumed `pipeline/decisions.md` and `logs/decisions.md` were redundant and prescribed migrate-then-retire. On inspection they are a deliberate, documented split: pipeline-scaffold decisions (/new-project Stages 1–3c) vs execution-session decisions. `logs/decisions.md` already pointed to `pipeline/decisions.md`; merging would have destroyed the separation and mixed two decision classes under mismatched columns. Added only the missing reciprocal pointer to `pipeline/decisions.md`.

**Rationale.** Both align with the workspace rule "conflicts must be surfaced, not silently resolved" and the Assumptions Gate (surface a structural concern + recommended resolution, proceed with it). Each applied item passed an independent qc-reviewer GO; the deferral and the reshape were the load-bearing judgment calls.

**Alternatives considered.** id-03: force the edit per the literal plan (rejected — unsafe against just-finalized live criteria, no correctness gain). id-04: execute the migrate-then-retire as planned (rejected — destroys an intentional split). Decided by: Claude judgment; operator authorized the in-session execution.

## 2026-06-01 (S5) — Implement Option 2′ in a context-loaded session vs a fresh one

**Context.** The Option 2′ marker-fix spec carried an explicit instruction from BOTH reviewers (plan-time /risk-check + system-owner second opinion): implement in a fresh dedicated session, NOT bundled with other work — the atomic 7-file commit makes a half-landed state the worst outcome. At /prime the operator said "fix these" (#1 git divergence + #3 Option 2′). The fresh-session concern was surfaced via AskUserQuestion with a recommendation to /clear and run #3 clean.

**Decision.** Operator chose "proceed now in this session." Implemented #3 in the already-loaded session (post-/prime + two explanations + the git fix).

**Rationale.** Operator authority over the reviewers' advisory preference. Mitigated by keeping the spec's hard safety rails: edit-manifest-first, live re-probe of CLAUDE_CODE_SESSION_ID before building, bash validated by execution, independent qc-reviewer GO, single atomic commit per repo with the paired sibling in lockstep. Context never became constrained, so the spec's "hard-stop-and-revert on mid-edit context pressure" rule was available but unused.

**Alternatives considered.** Fresh session after /clear (the reviewers' and Claude's recommendation — rejected by operator for throughput). Defer #3 again (rejected — spec was GO-eligible and ready, no reason to re-defer).

**Decided by:** operator directive, concern surfaced first. Logged as a conscious principle-deviation (reviewer "fresh session" guidance overridden) per "watch only" — outcome was clean.

## 2026-06-01 (S6) — Parallel-sessions playbook: autonomy as a co-dominant lever

**Context.** Authoring `docs/parallel-sessions-playbook.md` from a brief whose core framing was "parallelism is a selective optimization on top of good decomposition" — treating decomposition as the dominant lever.

**Decision.** Elevated **autonomy** to a co-dominant lever alongside decomposition in § 0, rather than leaving it as the brief's weakness #2 footnote. The playbook now states both must be present: clean partition AND high per-session autonomy.

**Rationale.** The pre-draft system-owner consult judged the framing sound but flagged that the workspace artifacts (autonomy pause-triggers, the marker hard-fails, the detection hook, the origin run's landing lessons) show gates reconverge on the operator at merge/push *regardless* of how cleanly the work was split. Decomposition without autonomy yields low-autonomy parallel = operator thrash = no real speedup. The two are not sequential prerequisites; they are co-equal gates.

**Alternatives considered.** (a) Keep the brief's decomposition-dominant framing and leave autonomy as a noted weakness — rejected: under-delivers on the brief's explicit "resolve the weaknesses" instruction. (b) Make autonomy the *primary* lever — rejected: overcorrects; without a clean partition there is nothing to parallelize regardless of autonomy.

**Decided by:** Claude judgment grounded in the system-owner consult; no operator override. Surfaced at the Gated stop point; operator approved the resolution implicitly by directing the QC pass.

## 2026-06-03 — Split the System Owner grounding restore: recover now, re-author later

**Context.** Asked to consult the System Owner about `docs/parallel-sessions-playbook.md`. The SO grounding base was absent from disk (prior-session standing advisory), so a grounded consult was impossible. Investigation found the grounding splits cleanly into two halves: (a) the vault docs (`principles.md`, `risk-topology.md`, `blueprint.md`, `repo-state.md` + components) sitting committed on the `repo-documentation-2` remote but not checked out locally, and (b) the 4 SO `references/` files (persona, grounding, toolkit-relationship, systems-building-principles) present in NO git repo or remote — never committed, existed only on the prior machine.

**Decision.** Recover half (a) immediately via `git reset --hard origin/main` on the empty local `repo-documentation` repo; defer half (b) to a dedicated session. Did not run the consult degraded.

**Rationale.** Half (a) is a faithful, zero-risk mechanical recovery (local repo had no commits — nothing to lose). Half (b) can only be re-authored from scratch — reconstructing the SO's voice rules and per-function read-map from the agent definition + surviving principle codes. The agent is explicitly forbidden from inventing principles; reconstructing its constitution and then immediately consulting against it in the same flow would be rubber-stamping an invention. That re-authoring needs deliberate operator review, so it belongs in its own session. Running the consult on the partial base would only reproduce the prior session's `[CITATION NEEDED]` outcome — low value.

**Alternatives considered.** (a) Full rebuild this session — rejected: re-authoring the persona/read-map mid-flow and trusting it immediately defeats the review gate. (b) Recover half + consult degraded now — rejected: reproduces the known degraded outcome. (c) Stop at investigation, recover nothing — rejected: leaves zero-risk recoverable value on the table.

**Decided by:** Claude recommendation, operator-endorsed (operator asked "what's your recommendation?" and accepted the recommended path).
