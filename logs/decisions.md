# Decision Journal

> Archive: [decisions-archive-2026-06.md](decisions-archive-2026-06.md)

## 2026-06-05 (S11) — Grounding-absent halt: verify-before-act as the primary invariant (#14 fix)

**Context.** Implementing repo-maintenance sweep item #14 — advisory agents (system-owner et al.) self-resolved as "proceed-degraded" when grounding reference files were absent, producing plausible-but-unanchored advice (incident 2026-06-02). The /prime mandate framed the fix as "halt when grounding files are absent."

**Decision.** Adopt **verify-before-act** as the primary design invariant, with required-vs-optional as the partition under it — not required-vs-optional alone. The halt fires ONLY on a verified `Read`-failure of a REQUIRED grounding file; never on an asserted state (present or absent), never on a thin/sparse topic match. Implemented in `system-owner.md` (new Phase 1.5 + Shape 1/Shape 2 split) and `expert-check-reviewer.md` (GROUNDING UNAVAILABLE separated from NO APPLICABLE REFERENCE). `project-manager.md` left unedited — it already satisfies the invariant.

**Rationale.** The risk-check's system-owner second opinion identified that #14 and its mirror (acting on an *asserted* grounding state without checking the disk) are the same root failure: trusting a claim over the filesystem. Required-vs-optional answers "halt on which files"; verify-before-act answers "halt on what evidence" — the deeper lever. Proven live in-session: the main session asserted the vault docs were absent (a wrong-path `ls`); the system-owner agent verified the filesystem, found them present (`vault/principles/principles.md`, `vault/blueprint/blueprint.md`), and correctly refused the false claim — the exact behavior the fix protects.

**Alternatives considered.** (a) Required-vs-optional partition alone (the original framing) — kept, but demoted to a sub-lever; it does not prevent acting on a false asserted-absent claim. (b) Edit all 10 grounding-referencing agents — rejected as scope creep; only the 3 corpus-dependent advisory agents were in the audit's scope, and 1 of those (PM) already complied. (c) A coded smoke test — rejected (agent halt behavior isn't mechanically unit-testable); documented 7 behavioral scenarios in the risk-check report instead.

**Decided by:** Claude recommendation on the risk-check + system-owner second opinion; operator authorized via "go". Cleared /risk-check (PROCEED-WITH-CAUTION, mitigations applied) + /qc-pass (GO). Commit `e1a60d6`.

## 2026-06-05 — /diagnostics-plan ai-resources: declined 3 SO-vetted Do-now items on pre-execution reconciliation

**Context.** `/diagnostics-plan` (ai-resources) produced a System-Owner-vetted 7-item Do-now batch. The operator authorized execution ("go"). A batched `/risk-check` (PROCEED-WITH-CAUTION) + a DR-9 top-3 consumer check + an SO Function-B second opinion ran before any edit landed.

**Decision.** Execute only 1 of the 7 (the ai-resources CLAUDE.md de-dup pass, id-25 + id-26). Decline the other 6: 3 verified already-applied (id-01/02/03, id-04, id-18 — done by S2/S3/S4 earlier today; the scan read stale dated reports, not live files); id-06 SKIP; id-22 DEFER; id-37 DEFER.

**Rationale.** Each decline is evidence-grounded: (id-06) "add Read(audits/working/**) deny" directly contradicts `docs/permission-template.md:141`, a dated canonical rule ("retired 2026-04-28. Do not restore it") — restoring it would break /permission-sweep Step 4 + the Subagent Contract read-back; surfaced the conflict per the workspace "surface, don't silently resolve" rule, resolution unambiguous from context. (id-22) the Read(logs/*archive*.md) deny is load-bearing — resolve-improvement-log.md:103 deliberately builds its append-only archive procedure around it; narrowing it is a 3-canonical-file contract change with a guard-removal tradeoff, exceeding a fix-slot → park. (id-37) target is workflows/research-workflow/.claude/commands/, out of the ai-resources scope and part of the already-deferred cross-repo symlink cluster. Within the executed CLAUDE.md pass, kept id-10 (DR-5 self-labeled context-less-open mirror) and id-11 (no-model-field rule kept verbatim/visible — diverged from the SO's "trim to pointer" on rule-visibility + materiality grounds, noted).

**Alternatives considered.** (a) Execute all 7 as authorized — rejected: 3 were no-ops and 3 conflicted with live canonical state the stale scan didn't see; blind execution would have restored a retired deny (id-06) and weakened a load-bearing guard (id-22). (b) Trim id-11 Model Selection to a pointer per the SO advisory — rejected: the no-model-field rule is one the operator cares about most; trimming its always-loaded visibility to save ~80 tok is a bad trade. (c) Apply id-22 with the deny narrowed — rejected: it is a design decision with a guard-removal tradeoff across 3 canonical files, not a mechanical fix.

**Decided by:** Claude recommendation on the risk-check + DR-9 check + SO second opinion; operator authorized the batch via "go". Cleared /risk-check (PROCEED-WITH-CAUTION) + /qc-pass (GO). Commits `f0959f7`, `b18d212`.

**Process recommendation (also logged to improvement-log b18d212).** `/diagnostics-plan` candidate scans are built from dated reports; when those lag fast-moving same-day work, the scan over-reports actionable items. Reconcile candidates against live file state before treating them as Do-now — worth a standing /diagnostics-plan caveat.

## 2026-06-05 (S12) — /resolve-improvement-log: treat `applied`+commit-ref as the de-facto "resolved" state

**Context.** `/resolve-improvement-log` classifies an entry as resolved only if it carries BOTH `**Status:** applied` AND a separate `**Verified:**` field. A scan of `logs/improvement-log.md` found 8 substantively-applied entries (commit refs + "Independent QC GO" written inline) but ZERO entries with a `**Verified:**` field — the only occurrence is the schema description itself. Following the strict rule literally would archive nothing, which contradicts the operator's mandate to archive resolved/decided entries.

**Decision.** Surfaced the conflict to the operator (per workspace "conflicts must be surfaced, not silently resolved") and treated `applied` + commit ref + inline QC-GO as the repo's de-facto resolved state. Operator confirmed (`y`); archived the 8 entries to `improvement-log-archive.md` (commit `6e98d7c`). Recommended keeping the 2 Step-3c no-active-friction matches (both live work, not dead) — operator concurred.

**Rationale.** The repo's actual convention (per the schema note at improvement-log.md line 8) marks unresolved entries as `logged (pending)` and done entries as `applied YYYY-MM-DD` with a commit ref; the separate `**Verified:**` field is not used in practice. Honoring the strict rule would make the command a permanent no-op here. Each archived entry has a commit ref + QC confirmation, so it is verified-in-substance.

**Alternatives considered.** (a) Follow the strict rule → archive nothing — rejected: defeats the mandate and the command's purpose in this repo. (b) Silently override the rule and archive — rejected: a conflict between skill rule and repo convention is exactly the "surface, don't silently resolve" case; presented it for an explicit operator call instead.

**Follow-up (logged as a Next Step, not actioned).** Either start adding a `**Verified:**` line on entry close, or relax the skill rule to accept `applied`+commit-ref — so the manual-override surfacing does not recur every run.

**Decided by:** Claude recommendation + operator confirmation (`y`). No risk-check (non-structural log maintenance).

## 2026-06-05 — /fix-project-issues ai-resources (2nd run): apply id-08, defer id-06

**Context.** Operator requested a fresh re-run of the morning /diagnostics-plan (now /fix-project-issues) on ai-resources. SO Function-A vetting reduced 23 candidates to 3 Do-now; live-state verification reduced the actionable set to 1.

**Decision.** Apply id-08 (delete the stale dated "Subsumed /audit-critical-resources on 2026-05-29 …" change-log clause from CLAUDE.md). Defer id-06 (relocating the ~330-tok directory map out of always-loaded CLAUDE.md). Treat id-05/07/09/12 as no-op/skip (already-applied or canonical conflict).

**Rationale.** id-08 is a clean DR-5 deletion with no rule change and no consumer dependency (risk-check GO, all six dimensions Low; 7 refs to audit-critical-resources elsewhere, 0 must-change). id-06 carries a genuine always-loaded-visibility tradeoff (the directory listing is reference content, but the lead paragraph + multi-tool design rule are load-bearing per-turn) AND requires creating a new docs/ destination — a keep-vs-move editorial call on always-loaded content. This mirrors the morning run's deliberate KEEP of id-11 (Model Selection) on identical visibility grounds. Per the workspace structural-fix-as-default + ROI gate, a content relocation with a real visibility tradeoff earns a deliberate dedicated decision, not a same-session diagnostics patch.

**Alternatives considered.** (a) Apply all 3 SO Do-now items as vetted — rejected: id-09 was already a no-op (R-codes gone since f0959f7) and id-06 is the visibility-tradeoff call above. (b) Auto-relocate id-06 to a new docs/repo-layout.md — rejected: removes always-loaded orientation + creates unrequested infra; the operator has a demonstrated preference to make keep-vs-move calls on always-loaded CLAUDE.md content. (c) Skip the end-time risk-check on a one-clause deletion as trivial — rejected: project-level CLAUDE.md edits are a bright-line risk-check change class (audit-discipline.md); ran the gate (GO).

**Decided by:** Claude recommendation (decision-point posture, pick-and-proceed) on SO Function-A advisory + live-state reconciliation + risk-check GO. No operator override sought (no operator-decision-class gate triggered). Commit `5274551`.

## 2026-06-05 (S14) — /improve diagnostics-lag: record-don't-build on a stale mandate premise; non-destructive concurrent-collision handling

**Context.** `/prime` auto-mode ran `/improve` to route the recurring diagnostics-lag friction (diagnostics-scanner builds candidates from dated reports without live-state reconciliation; logged 2× on 2026-06-05). The mandate asked me to *propose* a structural fix.

**Decision.** Do NOT propose/build a fix. Instead log a RESOLUTION record + annotate the friction entry. The fix already shipped same-day (commit `23c9143`: `docs/backlog-reconciliation.md` + `fix-project-issues.md` Step 2.5 + `fix-repo-issues.md` Step 3.0). Separately: handle the S13 concurrent-edit collision by committing only my own content (surgical staging) and NOT re-attributing the deliverable S13's commit swept up.

**Rationale.** (1) The friction's own proposed direction — a reconciliation pass *inside* the `diagnostics-scanner` agent — is the wrong layer: the scanner is read-only (`tools:` = Read/Glob/Grep, no Bash/git) and cannot run `git log`. The fix correctly landed one layer up, in the command body. Building the scanner-layer pass would duplicate shipped work at the wrong layer. (2) The "morning `/diagnostics-plan` un-gated entry point" risk dissolved on inspection — `/diagnostics-plan` was renamed to `/fix-project-issues` (commit `0c97a1b`), so it carries Step 2.5. (3) Per workspace "conflicts must be surfaced, not silently resolved," I surfaced the stale premise rather than mechanically producing a proposal. (4) Re-attributing my swept-up deliverable would require rewriting shared commit `2bc89d9` — a forbidden destructive git op; the work is intact and committed, only the attribution is cosmetic.

**Alternatives considered.** (a) Build the scanner-layer reconciliation pass as the mandate literally asked — rejected: duplicate + wrong layer. (b) Skip logging entirely since the fix exists — rejected: without a resolution record, the next `/improve`/Friday-act re-reads the same friction and re-proposes the rejected fix (the dead-candidate waste applied to the meta-process); without the friction annotation, both backlog scanners re-extract the dead finding every run. (c) On the collision, wrap S13 first (option A) — operator chose to have me commit S14 surgically (option B) since S13 was unwrapped/stalled.

**Decided by:** Claude recommendation (decision-point posture) + improvement-analyst finding, all claims verified live (commits, file existence, scanner tool list, no-duplicate). Operator approved option B for the collision. Deliverable committed under `2bc89d9`; this wrap commits S14 notes only.

## 2026-06-05 (S15) — /fix-repo-issues plan: two items deviated from the written plan

**Context.** Auto-mode executed the 4-item `/fix-repo-issues` plan. Risk-check (PROCEED-WITH-CAUTION) + SO second opinion (split-by-item) surfaced that two items rested on premises conflicting with live canonical state.

**Decision 1 — Item 2 (wrap-session Step 3.5) NOT edited.** Diagnosed the chained-task false-positive as already prevented by the marker-aware own-subtraction (wrap-session.md lines 168–197), which landed with id-31 Phase 2 — the exact resolution the 2026-05-28 14:20 friction predicted. Closed as already-resolved.
- **Rationale.** Editing a High load-bearing detector on a stale premise risks regressing existing branches + drifting the workspace-root paired copy. The plan's premise (a live false-positive) was disproven by reading the code. SO + risk-check both endorsed diagnosis-first.
- **Alternatives.** (a) Edit Step 3.5 per the plan — rejected (would re-anchor working logic on a resolved premise). (b) Defer pending re-diagnosis — unnecessary; the diagnosis resolved cleanly in-session.

**Decision 2 — Item 4 (/clarify markerless) reshaped to nudge-only.** The plan asked `/clarify` to create the marker-trio; applied a detect-and-nudge-only check instead.
- **Rationale.** `docs/session-marker.md` (line ~100) designates `/prime` the SINGLE marker creator; `/session-start` does not create it either (it hard-fails and points to `/prime`). A `/clarify` creator would violate the single-source contract and require unvetted changes to the `/prime`-anchored reader logic. The nudge is the canon-faithful realization of the friction's intent.
- **Alternatives.** (a) Create the trio per the plan/friction request — rejected (contract violation). (b) Do nothing (downstream already hard-fails) — rejected (the nudge surfaces the gap earlier, before a markerless entry or a hard-fail).

**Decided by:** Claude recommendation (decision-point posture) + risk-check + SO second opinion; conflicts surfaced per workspace "conflicts must be surfaced, not silently resolved." All premises verified live against the command files.

## 2026-06-05 (S16) — Orphaned F4 risk-check: commit, not delete/gitignore

**Context.** `/cleanup-worktree` found one dirty path — an untracked S14-orphan risk-check report (`audits/risk-checks/2026-06-05-proposed-change-f4-*.md`, GO verdict) that authorized change F4, which was applied today (`2add1f2`). The `/prime` carryover framed it as "commit or delete."

**Decision.** Commit it (landed `7b1b153`).

**Rationale.** Repo convention is decisive: `audits/risk-checks/` is NOT gitignored (only `audits/working/` is, .gitignore line 25); 215 risk-check reports are already tracked; the file matches the `YYYY-MM-DD-<desc>.md` naming exactly; it is not a duplicate (the two tracked `f4`-named risk-checks cover unrelated changes); and it is the authorizing audit record for a change that shipped. Deleting the authorizing record while keeping the applied change is the wrong asymmetry.

**Alternatives.** (a) Delete — rejected: loses a valid audit record for an applied change. (b) Gitignore `audits/risk-checks/` — rejected: contradicts the directory-wide tracking convention (215 committed siblings).

**Decided by:** Claude recommendation (decision-point posture), validated by independent qc-reviewer (PASS) + triage-reviewer (history-only; commit confirmed correct) inside the `/cleanup-worktree` protocol.

## 2026-06-05 (S17) — Triage Do-items: #1 verify-first no-op, #2 doc-only scope, /risk-check reconsidered

**Context.** Triage promoted #1 (id-40 consumer-inventory hardening) + #7 (log archival); operator added #2 (1M-credit QC-gate fallback) mid-session. Executed under Gated autonomy.

**Decision 1 — #1 is a verified no-op, not an edit.** The `skills/ai-resource-builder/SKILL.md` Consumer-Inventory Gate (L367 invariant-stem grep "never the templated form"; L369 bidirectional `docs/session-marker.md` registry reconcile; shipped `afad146`) already mandates both clauses the triage proposed to add. The improvement-log entry it referenced was already archived. Residual work = a friction-log S7 closure annotation only.
- **Rationale.** Editing a live, already-correct rule would duplicate it and risk drift. This is the reconcile-against-live-state pattern the items themselves concern — the mandate was satisfied before the session opened.
- **Alternatives.** (a) Re-author the rule per the literal mandate — rejected (duplication). (b) Mark the entry applied without verifying the Gate — rejected (would assert a fix not confirmed live).

**Decision 2 — #2 doc-only, hook parked.** Landed the fallback posture in `docs/qc-independence.md` (sanctioned inline self-QC + mandatory surfacing + provisionally-cleared + `/model` prevention pointer). The pre-dispatch credit-detection hook stays parked per the triage verdict.
- **Rationale.** qc-independence.md is the home for "what to do when the QC gate is unreachable" (the fallback); the entry's session-start.md/agent-tier-table.md candidates address prevention, a different axis. The hook is novel harness infra warranting a dedicated session.

**Decision 3 — /risk-check reconsidered, not run.** With #1 dissolved, the only structural surface was a single additive bullet on an on-demand (non-always-loaded) doc + log edits + reversible archival — below the hard-gated change-class bar (no hook/permission/symlink/new-command/always-loaded/shared-state-reordering). Ran an independent `/qc-pass` instead (GO, zero findings).
- **Rationale.** The plan declared a plan-time /risk-check assuming #1 would edit a process doc; #1's dissolution narrowed the surface below the bar. Spending a possibly-credit-exhausting subagent on a low-risk doc bullet is also the prudent application of #2's own lesson.

**Decided by:** Claude recommendation (decision-point posture), validated by independent qc-reviewer (GO) on the substantive #2 edit.
