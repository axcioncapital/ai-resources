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

### 2026-06-03 — git init on axcion-ai-system-owner project (local, no remote yet)

**Context.** The axcion-ai-system-owner project had no git backing — this was the root cause of the SO references files being permanently unrecoverable when lost. All other active projects have their own git repos; this project was the exception.

**Decision.** Run `git init` on `projects/axcion-ai-system-owner/`, stage all existing files (the 4 reconstructed references, the surviving consult output, a .gitignore), and commit as the initial commit (9c50e18, branch main, local only). Remote setup and first push are deferred — treated as a follow-up paired with the nordic-pe-screening remote decision.

**Rationale.** The local commit brings the project in line with every other project and makes the references files recoverable against accidental deletion. Deferring the remote means no external-write gate fires this session; the operator can set up the remote and push in a dedicated step.

**Alternatives considered.** (a) Leave uncommitted — rejected: exposes the reconstruction to the same re-loss risk. (b) git init + remote + push this session — rejected: external write (Autonomy Rule #2) + remote-naming decision; deferred per operator choice.

**Decided by:** operator-selected from a three-option prompt.

### 2026-06-03 — grounding.md §1 vault path map points at output/phase-1/ (not vault/)

**Context.** The agent definition's Phase 3 prose says the SO should read vault docs from `projects/repo-documentation/vault/`. The recovered docs actually live under `projects/repo-documentation/output/phase-1/`. `vault/references/` does not exist. The grounding.md §1 path map is what the agent actually reads for paths (Phase 3 instructs the agent to defer to §1).

**Decision.** Point grounding.md §1 at the real location (`output/phase-1/`), document the mismatch in-file as a follow-up, and leave the agent-def Phase 3 prose as a deferred one-line reconciliation. The agent reads §1 for paths, so it will route correctly to the real docs.

**Rationale.** Pointing at the actual on-disk location is the safe, working choice. The alternative — moving/wiring the docs into a `vault/` location — is a larger structural change that should be its own session + risk-check. Keeping the in-file note transparent rather than silently resolving.

**Alternatives considered.** (a) Move docs into vault/ now — rejected: restructuring a git-committed repo (repo-documentation) mid-session is out of mandate. (b) Update agent-def Phase 3 to match grounding.md §1 — will be done as a follow-up one-liner, not this session.

**Decided by:** Claude recommendation, accepted at operator review gate (implicitly — operator did not override at the between-gate summary).

## 2026-06-04 — Strategy governing document placement: complete strategic-os, not a new project

**Context.** Operator pasted the consolidated Axcíon AI Strategy governing document and said "make this into a project within AI resources." Discovery found the document's three companion files already live in `projects/strategic-os/ai-strategy/`, and strategic-os is a workspace-root project purpose-built as the firm's strategy layer.

**Decision.** Save the governing document + its execution companion (roadmap) + tracker into the existing `projects/strategic-os/ai-strategy/` folder — completing that project rather than spawning a new standalone project.

**Rationale.** A new project would fragment the strategy material — the governing doc depends on companions that already sit in strategic-os. "Within AI resources" read as the broad Axcíon AI workspace (projects live at workspace root by convention, not literally inside the ai-resources git repo). Confirmed by operator selection in the /clarify question round.

**Alternatives considered.** (a) New dedicated project `projects/ai-strategy/` — rejected: fragments material. (b) Save + promote to strategic-os `state/live/strategy.md` via /promote-to-live — operator declined (heavier; engages promotion gating).

**Decided by:** Claude recommendation, operator-confirmed via /clarify multiple-choice selection.

## 2026-06-04 (S2) — F6 Session-Boundaries: blanket consolidation, overriding the S1 selective verdict

**Context.** AI-strategy candidate F6. S1 (earlier same day) recorded F6 as "CONVERT but NOT a blanket find-replace — keep verbatim where it loads every turn; DR-5 protects deliberate cross-level CLAUDE.md duplication." The operator then directed a blanket consolidation of all carrying CLAUDE.md files into a single source doc + pointers.

**Decision.** Override the S1 selective verdict: blanket-convert all 17 locations (workspace-root + ai-resources + 14 project CLAUDE.md + the /new-project template fragment) to a thin every-turn behavioural cue + a pointer to new `ai-resources/docs/session-boundaries.md` (pointer pattern "Option A"). Record the override in `slot-1-decisions.md` per OP-11.

**Rationale.** (a) Serves OP-12's consolidation clause (17 verbatim copies → one source). (b) DR-5's exception did not actually protect these copies — DR-5 only sanctions *self-identifying* duplication, and these copies were silent, so the change moves toward DR-5 compliance. (c) Option A keeps the imperative cue loading every turn, preserving F6's one valid concern (the rationale sentence is what moves to the pointer target, not the directive). Gated by /risk-check (PROCEED-WITH-CAUTION, 5 mitigations applied) and /qc-pass (GO).

**Alternatives considered.** (a) Honor F6 selective + own /risk-check session — operator rejected in favour of blanket. (b) Pure-pointer stubs (Option B) — rejected: drops the every-turn behavioural cue, re-opening F6's objection. (c) Defer F6 to its own session — rejected: operator wanted it done now.

**Decided by:** Operator override, surfaced as a conflict (S1 verdict vs operator framing) and confirmed via /clarify multiple-choice. Recorded per OP-11 (surface, don't silently drift).

## 2026-06-04 (S4) — Auto-mode scope reduction via gate-time cross-repo conflict check

**Context.** Operator picked menu items 1,2,3,4,6 in auto mode. The context-discovery engine, run at the auto-mode mandate-derivation step, surfaced that items 2 (AI-strategy Slot 1) and 3 (Session Boundaries consolidation) were recorded as already executed 2026-06-04, and item 4 was unscoped.

**Decision.** Reduced the batch from 5 items to 1+6 at the single approval gate. Verified the conflict against the strategic-os repo git log + implementation-tracker before recommending the drop (items 2/3 done by S1/S2; only E1/E4 graduations remain on item 2). Dropped item 4 as unscoped, item 2 also for active-collision risk with the live S3 session.

**Rationale.** Executing 2/3 would have been redundant work; item 2 additionally risked colliding with a concurrent session holding the strategic-os tree dirty. Conflict surfaced explicitly to the operator per the Design Judgment "conflicts must be surfaced, not silently resolved" principle, with the reduced subset recommended.

**Alternatives considered.** (a) Run all 5 as picked — rejected: redundant + collision. (b) Run 1+6 + item 2's E1/E4 remainder — deferred: collision risk until S3 wraps.

**Process gap noted (routed to /resolve-repo-problem):** /prime's git cross-check scans only ai-resources + workspace-root, not sibling project repos like strategic-os — so it surfaced items 2/3 as still-open when they were done-and-committed elsewhere. The context-discovery engine caught it; /prime did not.

**Decided by:** Claude recommendation, operator-approved (`go` at the reshaped gate).

## 2026-06-04 (S5) — Bounded the leftover-commit cleanup + corrected a stale graduation verdict

**Context.** Auto-mode picked items 1 (commit leftover S2 work) + 3 (/prime gap) + 2 (graduate E4, E1 deferred). A full workspace git survey showed the leftovers were entangled in workspace-wide uncommitted drift across ~16 repos (mass `.claude/` library deletions, dozens of untracked command/agent files), not a tidy S2 commit.

**Decision 1 — bound item 1 to the two mandate-named repos.** Committed only ai-resources + strategic-os, explicit paths, foreign drift untouched (never `git add -A`). Flagged the 14-repo CLAUDE.md remainder + the systemic `.claude/` sync/tracking question as a dedicated git-hygiene session.

**Rationale.** The mandate named ai-resources + strategic-os only; the full 16-repo consolidation exceeds that scope and committing piecemeal across dirty shared repos is a hard-to-cleanly-reverse action that deserves a deliberate reviewed pass. Per the conflict-surfacing principle.

**Decision 2 — corrected E4 to already-done instead of running /graduate-resource.** Filesystem + git history showed `resolve-improvement-log` already canonical in ai-resources and symlink-distributed to every project. The slot-1-decisions GRADUATE verdict was stale. Updated records to CONFIRMED-DONE; the planned structural risk-check was moot (no new canonical resource created). E1 confirmed genuinely project-local and correctly deferred.

**Alternatives considered.** (1a) Commit all 16 repos' conversions — rejected: out of mandate scope, entangled with heavy foreign drift. (2a) Run /graduate-resource on E4 as picked — rejected: no-op on an already-canonical resource.

**Decided by:** Claude recommendation under auto-mode autonomy; operator `go` at the reshaped gate.

## 2026-06-04 (S6) — E1 graduation reversed to KEEP-LOCAL; research-pe CLAUDE.md deferred

**Context.** Auto-mode session picked items 1,2,3,5. A Stage-0 `/risk-check` on the structural pieces (item 1's tracking-model decision + item 2's E1 graduation) returned RECONSIDER, corroborated by a system-owner second opinion.

**Decision 1 — reverse E1's GRADUATE verdict to KEEP-LOCAL.** Did NOT run `/graduate-resource doc-scanner-agent`. Corrected slot-1-decisions.md + implementation-tracker.md to KEEP-LOCAL (original GRADUATE struck through, not overwritten, per OP-11).

**Rationale.** doc-scanner-agent is genuinely project-local: its sole caller (`friday-checkup.md:202`) is scope-locked to repo-documentation, and `auto-sync-shared.sh` (no exclude glob) would fan it out as symlinks into ~10 unrelated projects on graduation — speculative abstraction with N=1 real consumer (OP-9/AP-7/DR-7). The S5-wrap GRADUATE verdict was stale; it skipped the second-consumer test.

**Decision 2 — defer research-pe-regime-shift CLAUDE.md entirely.** Its Session-Boundaries conversion (legit F6 work) is entangled with an unrelated 2026-06-01 project re-aim (advisory-gap → positioning). Left the whole file untouched rather than sweep foreign drift into an SB-labeled commit. Committed only the 12 cleanly-isolated repos.

**Decision 3 — defer the `.claude/` commit-vs-symlink tracking-model decision** to its own risk-checked session, with `auto-sync-shared.sh` as a binding constraint. It is an architecture question, not an auto-mode task.

**Alternatives considered.** (1a) Run E1 graduation as picked — rejected: speculative fan-out, pipeline would strip the project-specific lens. (2a) Patch-stage only research-pe's SB hunk — rejected: fragile non-interactive partial-stage; cleaner to defer the file to its owning session. (3a) Decide the tracking model inline under auto-mode autonomy — rejected: high blast radius, S5 reserved it for a reviewed pass.

**Decided by:** risk-check RECONSIDER + system-owner concurrence; operator directive "Don't graduate it. Proceed."

## 2026-06-04 (S7) — Defect-capture scaffolding: 5 architecture decisions

**Context.** Implementing §5.8 (Defect capture) of the AI strategy governing document — a defect log + a defect-to-fix loop. Five architecture questions surfaced via `/clarify`, pre-researched via `/decide` with a system-owner consult, accepted by operator with "proceed."

**Decisions.**
1. **Home — canonical `ai-resources`** (`logs/defect-log.md` + `docs/defect-to-fix-loop.md`). Output-quality defects appear in every project; DR-1 multi-project test passes on first pass. No symlink fan-out (logs live once); no `/placement` needed (siblings in established folders).
2. **A separate fourth log, not an extension** of friction/improvement/coaching. The defining behaviour — count occurrences per class, act on the 2nd — needs a stable class register; improvement-log is an unordered queue that would bury the recurrence signal. Tracks "how good the output was" (unserved axis) vs the existing "how the work ran."
3. **Eval branch routes by locality** — cross-cutting classes → qc-reviewer / `review-principles.md`; skill-local classes → that skill's quality-check section. Feeds the future slot-5 eval substrate rather than forking one. A standalone checklist doc was rejected (a doc a human re-reads is the hand-correction the loop exists to retire).
4. **Firing — capture per-session + recurrence scan fortnightly on the Friday cadence** (gated step), not a hook and not fully manual. Precedent: gate-calibration suppression check fires monthly+ in `/friday-checkup`. Routing is judgment work → stays gated.
5. **Scaffolding-only this session; wiring deferred to a risk-checked session 2.** Binding principle: closure-before-detection (governing-doc intro) — design the closing channel before the log collects defects. `/log-defect`, the scan step, and real routing are gated change classes anyway.

**Rationale.** All five grounded in governing-doc §5.8 + the roadmap slot ordering (instrument upstream calls before the slot-5 eval substrate; the flagship build must not break the flagship closure-before-detection rule). System-owner concurred and flagged the one real risk: a log that captures but never closes — hence the acceptance test is "first defect class actually closed."

**Alternatives considered.** Project-scoped home (rejected — defects are cross-project); extend improvement-log (rejected — buries recurrence); checklist-doc eval landing (rejected — re-read-by-human anti-pattern); fully-automated hook firing (rejected — routing is judgment); full wiring this session (rejected — gated classes + closure-before-detection argues design-first).

**Decided by:** Claude recommendation via `/decide` + system-owner concurrence; operator accept ("proceed") then "yes add it and proceed" for the gated pointer.

## 2026-06-04 — /fix-repo-issues in-session execution (3 fixes) + prime.md bounding choice

**Context.** `/fix-repo-issues` produced a 3-item fix plan and recommends a two-session plan-then-execute split. Operator directed "proceed here" — execute in the same session.

**Decision 1 — execute the plan in-session, with independent QC before commit.** Overrode the two-session split per explicit operator directive, but ran `/qc-pass` (independent qc-reviewer) on the two command-logic edits before committing, preserving the safety the split otherwise provides. QC verdict GO.

**Decision 2 — prime.md id-01 scans all `projects/*/`, not an "active/selected" subset.** The plan's "bound to active/selected projects" wording mirrors `/fix-repo-issues` Step 1, whose filter is an *interactive operator scope menu*. `/prime` has no menu and cannot replicate the filter without a prompt, so the faithful resolution is an unconditional `projects/*/` scan, bounded by `--since` output (empty for quiet repos) rather than by invocation count. The cost note was corrected to state this rather than imply the plan's bounding directive was satisfied.

**Alternatives considered.** (1a) Defer execution to a fresh session per the split — rejected: operator directed in-session. (2a) Add an active-project filter to `/prime` — rejected: would require a new interactive prompt in a read-and-brief command; out of scope for a backlog fix, and divergence is benign at 4-repo scale (QC-confirmed).

**Decided by:** operator directive ("proceed here") + Claude scoping judgment; independent QC GO; one optional QC finding applied.

## 2026-06-04 (S8) — .claude/ shared-resource git-hygiene: gitignore + regenerate (Option B); implementation gated to a dedicated session

**Context.** Carryover decision flagged repeatedly as "highest-value git-hygiene item": should per-project `.claude/` shared command/agent files be committed as-is, or gitignored and regenerated from canonical `ai-resources/.claude/`? Investigated the actual on-disk + in-git state across all 14 project repos before deciding.

**Findings (evidence).** Project `.claude/commands/*.md` and `agents/*.md` are already **relative symlinks** to canonical ai-resources (`../../../../ai-resources/.claude/...`), and these symlinks are currently **committed** (tracked, not gitignored) — e.g. marketing-positioning tracks 95 files under `.claude/`. The state is **mixed and drifting**: most tracked entries are symlink-mode (git mode 120000), but several repos also commit real-file **copies** (buy-side-service-plan 22 copies, research-pe 20, global-macro 13, strategic-os 9, project-planning 7, repo-documentation 1). The binding constraint — `ai-resources/.claude/hooks/auto-sync-shared.sh` (SessionStart) — **regenerates**: it emits a relative symlink for every canonical command/agent missing in a project (never overwrites; bails if no `shared-manifest.json`), and separately warns on real-file drift (does not auto-replace).

**Decision — Option B: gitignore the synced shared symlinks/copies in each project repo; let `auto-sync-shared.sh` regenerate them at SessionStart.** Only the *synced shared* command/agent files are gitignored. Per-project real files stay tracked: `settings.json`, `shared-manifest.json`, manifest-`.local` project-owned commands/agents, project-owned hooks. (`settings.local.json` and `.claude/worktrees/` are already gitignored workspace-wide.)

**Rationale.** (1) The hook is *built to regenerate* — gitignoring loses nothing operationally; symlinks reappear on next session start. (2) Eliminates the symlink-vs-copy drift (the copies stop being tracked; the hook / `/sync-workflow` reconciles them). (3) Stops polluting project git history — today every new canonical command means a symlink-add commit in 14 repos. (4) Makes canonical ai-resources the unambiguous single source of truth, matching the repo's stated "projects reference, do not own" model. (5) Committed relative symlinks only resolve when the exact workspace layout is reproduced; they are noise in a standalone project clone.

**Alternatives considered.** (A) Commit symlinks as-is (status quo formalized) — rejected: leaves the symlink/copy drift unresolved, keeps 50–70 churn-prone shared entries per repo, and couples each project repo to the workspace layout. (Decision-only fallback was also considered and is what we are doing for *execution* — see scope below.)

**Scope this session — DECISION ONLY.** Implementation (a multi-repo `git rm --cached` of ~700 shared entries + per-repo `.gitignore` patterns + a regenerate-verification pass, relying on the hook) is a structurally gated change class with real cross-repo blast radius. It was **not** part of this session's plan-time `/risk-check` (which covered only Items 1–2). Logged as a gated follow-up in `improvement-log.md` — requires its own `/risk-check` + a dedicated execution session. Do not execute the untrack/gitignore now.

**Decided by:** Claude analysis grounded in on-disk + in-git evidence across 14 repos and the `auto-sync-shared.sh` regeneration contract; recorded under decision-point posture (pick-and-proceed). Execution deferred + gated.

## 2026-06-05 — Concurrency (C3 / Flag #8): ratify technical route (Option 2′ marker), item closed

**Context.** The AI strategy plan (`projects/strategic-os/ai-strategy/`) carried a "Concurrency Decision" item (C3 / current-state Flag #8) framed as **DECIDE — conditional BUILD**: decide whether to engineer around concurrent-session risks (build the marker-clobber fix) or change the working pattern to avoid them. The decision was meant to precede any build. However, the technical fix — **Option 2′, a `CLAUDE_CODE_SESSION_ID`-keyed per-session marker file** — was designed, risk-checked, system-owner-concurred, and **shipped 2026-06-01** (ai-resources commit `5e2afdc` + workspace-root `2e95f7f`, all 9 consumers migrated atomically) under incident pressure, out of the strategy's intended decide-first sequence. Two further edge-case hardenings landed since (date-rollover grace window; no-own-marker guard, 2026-06-04). The cheaper alternatives were empirically eliminated: Option 1 (file-only sanity check) was implemented, dry-run-tested, and **rejected** the same day (silent false-negative — no clean file-only signal); env-var Option 2 was **proven infeasible** (exported vars do not persist across Bash tool calls). A parallel operational layer also exists: `docs/parallel-sessions-playbook.md` (partition/landing discipline) + a `detect-concurrent-session.sh` SessionStart hook. The five strategic-os strategy docs still described C3 as an un-built, un-decided env-var candidate — making them internally inconsistent with the shipped state.

**Decision.** Adopt the **technical route** as the standing answer to the concurrent-session class. Concurrency is treated as a real, recurring working pattern — not one that can be managed away by process discipline alone. The **Option 2′ session-id-keyed marker** (shipped 2026-06-01) is the chosen mechanism and stays. `docs/parallel-sessions-playbook.md` is the **operational complement** (lowers collision *rate* via partition/landing discipline), not a substitute (the marker makes within-session races *structurally impossible*). The concurrency item (Flag #8 / C3) is **CLOSED**.

**Rationale.** (1) The working pattern is genuinely multi-session: S1–S9 same-day runs observed; 3–4 concurrent-session incidents in 5 days late-May/early-June 2026 — process-only avoidance is unrealistic. (2) The fix is shipped, QC-GO, system-owner-concurred, and actively being hardened (two edge-case fixes since the original ship) — evidence the machinery is maintainable. (3) Cheaper options were empirically eliminated: Option 1 (file-only) produced a structurally un-fixable silent false-negative; env-var Option 2 was broken by the Bash-tool fresh-shell contract. Option 2′ (harness-injected `CLAUDE_CODE_SESSION_ID` oracle, un-clobberable) is the architecturally clean path. (4) Belt + suspenders: the playbook reduces collision frequency; the marker resolves identity correctly even under concurrent access.

**Scope / consequence.** The strategy's "DECIDE — conditional BUILD" gate resolves to **already BUILT**; the slot-2 / slot-6 conditionals in the implementation tracker and roadmap collapse — no further concurrency build is queued. Further engineering is bounded to **maintenance of existing machinery** (edge-case fixes as they surface, per the Friday cadence). Strategy docs (candidate-backlog, governing-document, implementation-tracker, ai-operator-roadmap, ai-infrastructure-current-state) updated to reflect C3 as decided + shipped in the same session.

**Alternatives considered.** (1) Process-primary / freeze tech — change the working pattern to minimize concurrent sessions; treat the shipped machinery as a backstop but stop extending it. Rejected: multi-session is the actual daily pattern (S1–S9 evidence); reducing collision *frequency* via the playbook is already done; removing the structural fix would leave the system vulnerable to the incident class that prompted the original build. (2) Genuine rollback / revert — treat the shipped fix as provisional and weigh reverting. Rejected: the fix is already QC'd, system-owner-concurred, and has accumulated subsequent hardenings; the rationale is evidence-grounded, not ad-hoc; reverting would remove a structurally sound mechanism with no benefit.

**Decided by:** Operator directive (2026-06-05), grounded in shipped-state evidence from `logs/improvement-log.md`, `logs/decisions.md`, and live commit history.

## 2026-06-05 — Context Engine Slot 7 decision (ai-strategy): keep manual, demote auto-fire, park enforcement

**Context.** AI strategy Slot 7 required resolving the context-engine extension (`B1`/`B2`) — land vs. cut against three tests (reduce session-start time / reduce wrong-context loading / improve eval-case success; "if none, cut"). The engine is ai-resources infrastructure; the verdict is recorded here for discoverability. Full record: `projects/strategic-os/ai-strategy/slot-7-context-engine-decision.md`.

**Decision (decision-only — no code edits this session).** Three-layer verdict. **Phase 1** (manual `/build-context` + `context-discovery` agent + `context-pack-schema.md`): **LAND** as an opt-in tool — passed its own eval (5/5, 2026-06-01), zero per-session cost when idle. **Phase 2 auto-fire** (`session-start.md:184` Step 2.4, `prime.md:315` Step 8c.4.5): **REVISE → demote to opt-in** — FAILS the session-start-time test (adds ~300–400 tokens + an unenforced-timeout Opus run per loaded session), WEAK/UNPROVEN on wrong-context (n=2; the one S4 catch masked a `/prime` sibling-repo-scan bug), UNMEASURABLE on eval-success (no eval substrate exists yet — Slot 5). **Phase 2+ enforcement** (pre-edit check / drift-to-pack / closeout-to-contract, unbuilt): **PARK** behind the Slot 5 eval substrate.

**Rationale.** Under the strategy's own burden-of-proof rule, no layer affirmatively passes any of the three tests, and the costly layer is the every-session auto-fire — exactly the "detection without demonstrated closure" the strategy exists to catch ("prior momentum does not protect it", governing-doc §5.6). Phase 1 survives because, as an opt-in tool, the session-level tests do not bind it and it costs nothing idle. Also corrected a stale-status conflict: strategy docs said Phase 2 "not yet landed" but it had landed and written 25 packs across 5 project areas.

**Gated follow-up.** The L2-REVISE (sever the auto-fire from the two session-init commands) is a structural change with the blast radius mapped in `audits/risk-checks/2026-05-29-context-engine-phase-2-session-init-edits.md`; it requires its own `/risk-check` session and must pre-flight the 2 unverified mandate-readers (`monday-prep.md`, `contract-check.md`). Residual `- Context pack:` bullets in past session-notes are harmless (fixed-list parsers ignore them).

**Decided by:** Claude analysis grounded in on-disk + in-git evidence (Phase 1 eval, 2026-05-29 risk-check, live command files, usage/decision logs, pack count), under operator instruction (full-stack / decision-only / decide-on-current-evidence). Independent `/qc-pass` GO on the governing plan.
