# Decision Journal

> Archive: [decisions-archive-2026-06.md](decisions-archive-2026-06.md)

## 2026-07-04 — `/lean-repo` + `lean-repo-auditor` shipped under a loud OP-11 complexity-budget exception

**Context.** `/leverage-idea` on a pasted `/lean-repo` idea dump produced a plan; the operator chose the "Both, whole" option (doctrine + standalone command). Plan-time `/risk-check` returned **RECONSIDER** (Hidden coupling High, Principle alignment High); the mandatory System-Owner second opinion **CONCURRED**. Both said: ship the doctrine, but do **not** ship the command+agent standalone — fold the leanness lens into `/architecture-review` instead. The operator was shown both verdicts and **overrode the RECONSIDER**, directing the full legitimate build.

**Decision — ship the standalone command+agent under a recorded OP-11 exception, plus the doctrine.** Shipped: (1) `docs/ai-resource-creation.md` rule #7 (creation-time complexity-budget gate); (2) `/leverage-idea` Step 6 enforcement cap; (3) a thin complexity-budget cross-reference in `risk-check-reviewer.md` Dimension 6 (the agent that owns principle-alignment — item retargeted there, not to `risk-check.md`, and kept as a cross-ref not a parallel check); (4) `/lean-repo` command; (5) `lean-repo-auditor` agent.

**The OP-11 exception, stated loudly.** `/lean-repo` + `lean-repo-auditor` are two net-new components that **fail prong (a)** of their own rule #7 (they add components and remove none). They ship on **prong (b)** — an evidenced failure mode: capability sprawl and orphan commands (`friction-log.md` 2026-07-02 `/tech-consult` orphan; `coaching-log.md` "shipping capabilities faster than adopting them"), over-control (a rubber-stamp gate not earning its cost), and CLAUDE.md over its line target. **OP-12** is satisfied by the documented closure channel (a `/risk-check`-gated execution session / `/friday-act`), shipped in the same change. Auto-distribution mitigated: `lean-repo` added to `auto-sync-shared.sh` `EXCLUDE_COMMANDS` (consistent with `pipeline-review`/`scope-project`), so it does not symlink into the 21 downstream projects. This exception is recorded here, deliberately — not asserted in-line — per the doctrine's own "loud, recorded OP-11 exception" clause.

**Rationale.** The operator's override is a legitimate authority under the autonomy rules (`/risk-check` is advisory). The build was made *legitimate* rather than waved through: the three pieces the gates required for an override — a working closure channel, a recorded principle waiver (this entry), and an opt-out from distribution — all shipped. If a future review finds the leanness lens is rarely used, the lean move is to fold its three questions into `/architecture-review` and retire `/lean-repo` (noted in the command's provenance header).

**Alternatives considered.** (a) The gates' recommended path — ship the doctrine, fold the three leanness *questions* (not the disposition output) into `/architecture-review`, drop the standalone command — rejected by operator in favour of a named, standalone entry point. (b) Build a `/lean-act` closer for OP-12 — rejected (SO's point: command+agent+closer = three components to enforce an anti-component rule); reused the existing execution path instead. (c) Also wire the budget check into `system-owner.md`'s parallel dimension — rejected as parallel-check proliferation; `system-owner` picks up the doctrine via `ai-resource-creation.md`, and the enforcement points that matter are proposal-time (`/leverage-idea`) and land-time (`risk-check-reviewer`).

**Decided by.** Operator explicit override of the RECONSIDER after the `risk-check-reviewer` verdict and the System-Owner concurrence were both surfaced; Claude built the closure/waiver/opt-out legitimacy pieces the gates required for the override to hold. End-time `/risk-check` returned PROCEED-WITH-CAUTION (all dimensions Low/Medium; the OP-11 waiver converted the plan-time Dimension-6 High to Medium); its two required mitigations were applied before commit — this rollback-order note, and the `/lean-repo` adoption-watch entry in `improvement-log.md` (2026-07-04). Independent `/qc-pass` run before commit.

**Rollback order (per end-time risk-check mitigation).** To revert this change safely: (1) delete `.claude/commands/lean-repo.md` and `.claude/agents/lean-repo-auditor.md` **first**; (2) *then* revert the `auto-sync-shared.sh` `EXCLUDE_COMMANDS` addition — reverting the exclusion while the command still exists would re-distribute `/lean-repo` to ~18 projects on the next SessionStart. (3) Revert the three doctrine edits (`ai-resource-creation.md` rule #7, `leverage-idea.md` Step 6 cap, `risk-check-reviewer.md` cross-ref) independently — they stand on their own and need not be reverted with the command. (4) Remove only this dated OP-11 block from `decisions.md` and the adoption-watch block from `improvement-log.md` — surgical deletes, never a whole-file revert (both are shared append logs with other sessions' entries).

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

## 2026-07-05 — Lean the two most-used advisory gates: `/blindspot-scan` + `/risk-check` (retier + de-escalate)

**Context.** Weekly usage telemetry showed `/blindspot-scan` (~10%) and `/risk-check` (~10%) together consuming ~20% of usage. Both ran on Opus, and on a single structural plan they could stack up to four Opus passes — blindspot inline + risk-check orchestrator + `risk-check-reviewer` subagent + an auto-fired `/consult` second opinion on every non-GO verdict — with the two gates duplicating the consumer-inventory grep. Operator directive: make both leaner; Sonnet acceptable; some safety trade acceptable; consolidation on the table.

**Decision (Tier 1, this session).** (1) Retier `risk-check-reviewer`, the `/risk-check` orchestrator command, and `/blindspot-scan` from `opus` → `sonnet`. (2) `/risk-check` Step 4a: the System-Owner `/consult` second opinion is no longer auto-fired on non-GO verdicts — it is now an operator-invoked offer line surfaced in the Step 5 summary; no `## Architectural Commentary` is auto-appended. (3) Tighten the Blind-Spot Scan Gate trigger (workspace `CLAUDE.md`) so it fires only on `/risk-check` change classes, dropping the "or ≥3 files" branch. (4) The `/risk-check` project-session fallback (item 12a) re-asserts `model: sonnet` to match the new canonical reviewer tier. (5) `docs/agent-tier-table.md` risk-check-reviewer row updated to sonnet with a pointer to this entry.

**OP-11 exception (loud record).** Retiering `risk-check-reviewer` and `/blindspot-scan` to sonnet is a deliberate exception to the "judgment work → opus" convention (`docs/agent-tier-table.md`; workspace `CLAUDE.md` § Model Tier). The judgment classification is unchanged — the retier is a cost/safety trade, not a reclassification. Opus depth is preserved on demand: the operator-invoked `/consult` offer on non-GO verdicts routes genuinely contested changes to an Opus System-Owner pass.

**Blind-spot coverage note (do not "restore" the ≥3-files branch).** Dropping "or ≥3 files" means an ordinary *non-structural* multi-file plan no longer triggers a post-plan blind-spot scan. This is intentional, not an omission: the `/wrap-session` blind-spot nudge (the separate wrap-time coverage named in the same CLAUDE.md paragraph) still catches such work at session end. The post-plan gate is now reserved for `/risk-check`-class plans, where the cost is justified. A future maintainer should not re-add the ≥3-files branch without re-opening this cost decision.

**Rationale.** Model tier is the dominant cost lever (Sonnet is a fraction of Opus per token) and the two analytical passes plus the auto-second-opinion were the bulk of the spend. De-escalating the auto-`/consult` removes a whole Opus pass from exactly the non-GO cases that already ran the heaviest review, while keeping the escalation reachable. Tightening the trigger cuts blindspot-scan firings on ordinary multi-file edits. Estimated ~20% → ~5–7% of weekly usage for these two gates.

**Alternatives considered.** (1) Keep `risk-check-reviewer` on Opus, retier only the mechanical parts — rejected: the reviewer subagent is the heaviest single pass, so most of the saving would be forfeited; the `/consult` offer backstops the safety loss. (2) Full consolidation of the two gates into one combined pre-implementation pass (removing the duplicated consumer-inventory grep) — **deferred to a dedicated session (Tier 2)**: it means retiring two commands and rewriting both CLAUDE.md gates, the routing tables, and audit-discipline — a real rebuild with many consumers, not a same-session edit. (3) Removing a gate entirely — rejected: both catch real failure classes; leaning them preserves coverage at lower cost.

**Decided by.** Operator directive ("just fix both, make them lean, Sonnet OK, trade some safety, open to consolidation, proceed"). Gated end-time by `/risk-check` → **PROCEED-WITH-CAUTION** (report `audits/risk-checks/2026-07-05-lean-the-two-most-used-advisory-gates-executed-change-set.md`); all three required mitigations applied — this ledger entry (mitigations 1–2), and a verified symlink spot-check confirming every project copy of the three files resolves to canonical, so none is stranded on Opus (mitigation 3). `/blindspot-scan` was folded into the mandatory `/risk-check` (its consumer-inventory check is the duplicated work being removed). Independent `/qc-pass` gates the commit.

## 2026-07-05 (follow-up) — Narrow the `/blindspot-scan` auto-fire trigger to runnable-infrastructure changes only

**Context.** After the Tier 1 retier+de-escalate above, the operator flagged `/blindspot-scan` still fired too often: even leaned, it auto-fired on every `/risk-check` change class — including CLAUDE.md rule edits and config/tier edits to already-wired components, where its distinctive check (real-usage fit: *will this actually run and get used?*) has nothing to bite on and it duplicates `/risk-check`'s consumer/blast-radius work.

**Decision.** Narrow the workspace `CLAUDE.md` Blind-Spot Scan Gate trigger from "any `/risk-check` change class" to **only plans that create or rewire runnable infrastructure** — a new command/skill/agent/hook, a new symlink, or new/changed automation with shared-state effects. Explicitly skip: CLAUDE.md rule/wording edits, permission-only changes, model-tier/config/value edits to already-wired components, prose/doc edits, single-file edits, read/advisory sessions. The `/wrap-session` blind-spot nudge (broader trigger, one-line suggestion, near-zero cost) is retained as the wrap-time safety net for anything the narrow trigger skips.

**Rationale.** Concentrates the scan on the one failure class it uniquely catches — tooling that passes QC but ships inert because it won't actually run in the operator's VS Code / non-developer / multi-tool environment (e.g., the un-synced-hook and un-distributed-script catches on 2026-07-04). Everything else it checked overlaps `/risk-check`, which still fires on those classes.

**Alternatives considered.** (1) Manual-only + wrap nudge — rejected by operator: contradicts the gate's "operator won't remember" founding rationale. (2) Merge into `/risk-check` now (Tier 2) — still deferred; the bigger rebuild. (3) Leave the risk-check-class trigger — rejected: it was the source of the over-firing.

**Decided by.** Operator (AskUserQuestion → "Narrow auto-trigger"), who also explicitly waived `/risk-check` on this meta-edit. Verified inline per Subagent-Proportionality light-edit path: single-paragraph, reversible, advisory-gate trigger edit; blast radius grepped — the auto-fire trigger lives only in workspace `CLAUDE.md`; the `wrap-session` nudge was intentionally left unchanged. No independent subagent gate, per operator waiver.
