# Decision Journal

> Archive: [decisions-archive-2026-06.md](decisions-archive-2026-06.md)

## 2026-07-03 (S3) — Dropped two candidate `/open-items` tasks on live evidence; shipped a third instead

**Context.** Session S3 was planned around the two top candidates from an `/open-items` backlog scan: hardening `session-feedback-collector` to append-only, and migrating orphaned workspace-root commands into the canonical `ai-resources/.claude/commands/` library. Both were dropped before any file was touched.

**Decision 1 — collector-hardening task dropped, not built.** Live inspection of `.claude/agents/session-feedback-collector.md` found the fix already shipped (commit `0ee6177`): the agent's toolset no longer includes `Write`, and an explicit append-only Constraint E is already in the file. The backlog item was stale.

**Decision 2 — command-migration task dropped after a System-Owner disagreement, operator confirmed.** Plan-time `/risk-check` returned PROCEED-WITH-CAUTION (migration itself judged low-risk). The mandatory System-Owner second opinion then disagreed with the underlying premise, not just the risk mitigations: `repo-architecture.md:19` names `validate` as an intentional workspace-only example, not an orphan, and `GAP-2` in `principles-base.md` marks the whole workspace-root-vs-canonical question as system-level "known debt — PARKED." Rather than pick a side unilaterally, the disagreement was surfaced to the operator with three options; operator chose "A" (drop the task, pick a different one).

**Decision 3 — pivoted to fixing `check-foreign-staging.sh`'s semicolon-tokenizer bug.** Verified still-open by direct code read (line 301 split regex lacked `;`), single-file, mechanical, zero file-overlap with the concurrent Session S2. Shipped: `/risk-check` GO, committed `964d626`, retroactive `/qc-pass` GO (closing a gap where the earlier commit had cleared risk-check but not independent QC).

**Rationale.** Both drops were evidence-driven, not judgment calls dressed up as evidence — one was a direct contradiction between the backlog item and the live file content, the other a direct textual contradiction between the proposed change's premise and an existing canonical doc. Per workspace "conflicts must be surfaced, not silently resolved," the second disagreement was not something to adjudicate solo given it rested on interpreting standing architectural intent (a doc example + a parked system-level decision), not a mechanical fact.

**Alternatives considered.** (a) Push through the collector-hardening plan anyway — rejected, would have been a no-op edit against an already-correct file. (b) Resolve the System-Owner disagreement myself (e.g., side with the risk-check's DR-1 framing over the SO's GAP-2/example-citation framing) — rejected; this is exactly the class of structural disagreement the workspace rule says to surface, not silently pick a side on. (c) Migrate only the less-contested file (`run-qc.md`, which has no explicit "keep local" citation) and leave `validate.md`/`update-md.md` alone — considered but not chosen this session; operator's "pick a different, cleaner item" reply was read as declining the whole migration task for today, not asking for a scoped-down version.

**Decided by:** Claude recommendation (decision-point posture) on live evidence for Decision 1; operator explicit choice ("A") for Decision 2 after the conflict was surfaced; Claude recommendation for Decision 3 (verified-open, zero-overlap candidate). Risk-check GO + independent QC GO on the shipped fix.

### 2026-07-03 (S6) — Small-fix batch: gate reuse, 5-site fallback scope, class-boundary carve-out shape

**Context.** Small-fix session executed the 4-fix envelope a same-day abandoned session (S4) had planned and risk-checked (PWC + SO second opinion with material pushback), plus 14 more backlog fixes.

**Decisions.** (1) Reused S4's plan-time risk-check report instead of re-running the gate; end-time gate skipped per the standing skip rule (plan-time covered, mitigations applied, commits shipped, drift bounded — documented in the wrap note). (2) Spawn fallback shipped to ALL 5 confirmed spawn sites (risk-check, qc-pass, refinement-pass, refinement-deep, friday-journal), not the 3 originally scoped — per SO: do not leave known-broken siblings; each fallback hard-asserts `model: opus` (SO blocking point) and resolves paths by walk-up. (3) The risk-check-skip hole was closed as a bounded class-boundary clarification + explicit no-self-waiver rule in audit-discipline.md — the SO's structural option — NOT the discretionary logged carve-out from the original proposal. (4) After the wrap-time CONCURRENT guard fired, the operator directed a union wrap ("just wrap"): foreign S4/S5 session-note blocks ship under the S6 wrap commit, loudly attributed.

**Alternatives considered.** Re-running a fresh risk-check for the widened envelope — rejected as duplicate gating for marginal signal (the additions were non-listed-class text edits; the command itself warns against mid-session gate multiplication). Parking the whole fallback item (SO's stated alternative if 5-site coverage was too large) — rejected; the coverage WAS affordable this session. Confirm-before-skip-only shape for the carve-out — folded in: it remains the rule for everything outside the bounded class-boundary shape.

**Decided by.** Claude recommendation under decision-point posture for 1–3 (SO advisory + risk-check mitigations as the deciding inputs; QC GO post-hoc); operator explicit direction for 4.

## 2026-07-03 — Session S5: System Owner v2 build stage S0

**Context.** Kicked off the multi-session SO v2 build (12-piece control pack, Reduce Scope). Stage S0 = per-unit plan + B14 vault refresh + B15 baseline + R1 mitigation wiring + bundled grounding-corpus backlog item.

**Decision 1 — improvement-log status flip deferred, not landed.** The plan-time /risk-check (PROCEED-WITH-CAUTION, Hidden coupling High) plus the mandatory SO second opinion both flagged the 2026-06-02 grounding-corpus entry status flip as the one elevated risk: it is an in-place mutation of a shared non-append log, landing on a documented lost-update surface while a foreign session marker was live and two earlier abandoned-session flips already sat in the same file. The SO's decisive point: the flip cannot be hunk-split from those two earlier flips, so the risk-check's "land it now under five guards" mitigation was internally contradictory (guard 2 explicit-pathspec + guard 4 own-commit-boundary are mutually unsatisfiable). Routed the flip to a dedicated /resolve-improvement-log session; recorded the verification evidence (the entry is already substantively resolved) in the session plan's Gate-outcomes section instead.

**Decision 2 — backlog part 2 closed as already-implemented, not built.** The proposed "pre-consult grounding existence check" was found already live agent-side (system-owner.md Phase 1.5 REQUIRED-halt + consult.md Step 5a post-return existence check, June rebuild) — stronger than the original proposal. Verified by direct read; no new code written.

**Decision 3 — inputs/ as the R1 mitigation home in the redesign repo.** The redesign project's CLAUDE.md convention is window-outputs/ for unit inputs, but the approved SO v2 control pack (risk register R1) explicitly names inputs/. Surfaced the conflict (not silently resolved) and followed R1 — the purpose-built, operator-approved directive — while documenting the exception in the redesign's CLAUDE.md + a write-once-lifecycle inputs/README.md so convention and practice do not drift.

**Alternatives considered.** (Decision 1) Land the flip this session under the five guards — rejected as internally contradictory per the SO. (Decision 2) Build the check anyway — rejected as duplicate of a live implementation. (Decision 3) Use window-outputs/ per local convention — rejected; R1 is the senior, operator-approved directive, and the exception is cheaper than contradicting the control pack.

**Decided by.** Claude recommendation under decision-point posture, with the plan-time /risk-check + mandatory SO second opinion as the deciding inputs for Decision 1; independent /qc-pass GO post-hoc. Wrap completed as an operator-directed union wrap after the CONCURRENT guard fired on a live S7 session.

## 2026-07-03 (S9) — Friction-log Failure Mode Analysis: scope and taxonomy-relationship decisions

**Context.** Operator asked to add a Failure Mode Analysis to `logs/friction-log.md` — an 8-category taxonomy (Context/Mandate/Workflow/Authority/Validation/Autonomy/Safety/Traceability) plus a Failure → Root cause → Prevention → Owner artifact chain. Research surfaced that `friction-log.md` has no existing schema (unlike sibling logs `improvement-log.md`/`defect-log.md`), that four separate producers append to it, and that four separate consumers hardcode-parse it for open/closed status.

**Decision 1 — going-forward only, no retrofit.** The new schema applies to entries dated 2026-07-03 onward; the ~40 pre-existing entries are left untouched.

**Decision 2 — the new enum supplements, not replaces, the existing free-text "Friction type" tag.** Both fields now coexist on substantive entries.

**Decision 3 — only "substantive" writers (hand-authored entries + the `session-feedback-collector` wrap-time agent) must produce the full structure.** The lightweight one-liner writers (`/friction-log`, `/note`'s `friction:` prefix, `friction-log-auto.sh`) stay exempt and unclassified.

**Decision 4 — "Owner artifact" is additive to the existing closure mechanism**, not a replacement. The `Resolved:` / `[FADING-GATE] verified` stamps still do the actual open/closed signaling; the four consumer files that parse them needed no changes.

**Alternatives considered.** (1) Full or selective retrofit of existing entries — rejected as disproportionate cost for a taxonomy that only helps future entries. (2) Replacing "Friction type" with the new enum — rejected; the two answer different questions (which component vs. why it failed) and replacing would lose information with no consumer benefit. (3) Requiring all four writers (including the one-liner and auto-hook writers) to classify — rejected; those writers are deliberately terse by design and forcing classification would degrade their usefulness. (4) Restructuring closure tracking around "Owner artifact" — rejected; would have required updating four separate parser files for no functional gain, since the existing stamps already do the job.

**Decided by.** Operator, via structured `/clarify` → `/scope` questions with explicit options and a recommended default on each; all four decisions were operator selections, not Claude's own judgment calls. A related but separate finding — that the new 8-category enum diverges from AP-9's own canonical 4-value failure axis (`principles-base.md:87`) — surfaced during the mandatory `/risk-check` System-Owner second opinion and was deliberately left open (not decided this session) as a future principles-doc reconciliation item.

---

## 2026-07-04 — Disposition of the inert project copies of `detect-concurrent-session.sh`

**Context.** Making the worktree flow VS Code-native meant editing the concurrency-hook nudge text in the canonical `ai-resources` hook. A blind-spot scan found the hook is NOT symlinked like the commands — two projects (`positioning-research`, `research-pe-regime-shift-advisory-gap`) carry byte-identical **real-file, git-tracked** copies in separate repos. Both are **unregistered** in their projects' `settings.json` (they never fire — confirmed inert).

**Decision.** Apply the same nudge-text edit to all three copies and commit the two project copies into their own repos, preserving the pre-existing "copy == canonical" byte-parity invariant.

**Rationale.** The invariant is what a future drift-audit checks; preserving it means no future audit flags divergence, and no project repo is left with a dirty working tree. Cost is two tiny sync commits.

**Alternatives considered.** (1) Revert the two copies, commit only `ai-resources` — rejected: re-introduces byte-divergence (the exact drift the scan flagged) and leaves the two copies on stale text. (2) Delete the dead copies now — rejected as out-of-scope for a VS Code-native change, and file deletion in other repos is an autonomy-gated action. The "why do these unregistered duplicates exist at all" cleanup was routed to a future dedicated pass.

**Decided by.** Claude judgment (not operator-directed), surfaced via `/blindspot-scan`; the underlying hook edit was independently `/risk-check`'d (GO) and `/qc-pass`'d (PASS).

## 2026-07-04 — Build /reconcile-activate as the "build→activate" answer to the K2 reconciliation proposal

**Context.** Operator pasted an external proposal (K2) to build a "Project Workflow Reconciliation Agent." Investigation found the capability already exists (`/reconcile` + `reconcile-reviewer`, ~1:1) but is dormant in ~20 of 21 projects because its two required reference files are hand-authored and only buy-side-service-plan has them.

**Decision.** Do not build the proposal as written. Build one new command, `/reconcile-activate`, that scaffolds starter DRAFT versions of the two files (structure + resource inventory + candidate dimension names; every judgment cell an `{{AUTHOR:}}` placeholder), gated so `/reconcile` aborts against an un-ratified draft. Decline the genericness-detector + mandatory-trace ideas; defer contradiction-scan (→ `/qc-pass`) and cross-run failure-trend.

**Rationale.** The binding constraint on adoption is the blank-page authoring cost, which the scaffolder removes directly, while the ratification gate preserves the "operator-authored, not generated" intent. Net shape: 1 new command, 2 folds/defers, 2 declines — minimal surface against an already-large command set.

**Alternatives considered.** (1) Build the full K2 proposal — rejected as speculative duplication of a live component (AP-7). (2) Indicative-run mode instead of hard-abort — deferred (bigger blast radius: reconcile-reviewer + verdict-definitions; logged to improvement-log for a data-gated revisit). (3) Gate on banner-removal alone — rejected on SO advice; a generated rubric could pass by deleting the banner without editing, so the gate keys on `{{AUTHOR:}}` placeholders.

**Decided by.** Claude judgment on operator instruction ("do the build now"); SO-vetted via `/consult` + a risk-check SO second opinion; independently `/qc-pass`'d.

## 2026-07-04 — /wrap-session leanness refactor: guard distribution + telemetry default

**Context.** Operator asked to make `/wrap-session` leaner (too slow, too many tokens, overcomplicated). Plan-time /risk-check returned RECONSIDER (two Highs: blast radius across ~16 project symlinks; hidden coupling of a byte-identical 250-line extraction). Blindspot scan then found scripts are NOT auto-distributed with commands.

**Decision.** (1) Externalize the foreign-session guard to a single ai-resources script reached by ancestor walk-up — chosen over per-project script copies (no distribution mechanism exists) and over keeping it inline (would forfeit ~80% of the leanness win). (2) Flip telemetry to opt-in (operator directive), reworded the always-loaded CLAUDE.md rule as a loud revision, and placed the compensating gap-nudge in /prime (runs every session, already reads usage-log) rather than /session-start (Phase-3 only). (3) Unbundle into 3 sequenced commits per the risk-check redesign.

**Rationale.** Walk-up reuses the exact pattern auto-sync-shared.sh already relies on (low novelty), reaches every checkout, and fixes the same latent gap affecting check-archive.sh. Byte-identical extraction verified by mechanical diff (0 diffs) so behavior is provably preserved before the change reaches projects.

**Alternatives considered.** (a) Per-project script distribution — rejected (needs a new mechanism = bigger structural project). (b) Keep guard inline, take only the smaller B/C win — rejected (guard is most of the weight). (c) Nudge in /session-start — rejected (doesn't run every session → weak baseline protection).

**Decided by.** Operator approval on the two AskUserQuestion forks (telemetry opt-in; Path A walk-up); risk-check + blindspot + independent qc-pass all applied.
