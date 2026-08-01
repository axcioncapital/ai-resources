# Session Notes

> Archive: [session-notes-archive-2026-07.md](session-notes-archive-2026-07.md)

## 2026-07-29 — `/work-loop` unit: `/leverage-idea` lifecycle-routing brief routed out to `/develop-ai-resource`

### Summary
Ran one `/work-loop` unit (skill `work-loop`, worktree `ai-resources-leverage-idea`) against a
Codex-authored brief asking `/leverage-idea` to become an evidence-grounded routing-and-handoff
command instead of stopping at an implementation plan. Verified all six of the brief's premises
(confirmed, with positive controls), classified the route `reviewed` (14 project symlinks), wrote
Frame evidence diagnosing five defects in the shipped command, and sent it to Codex for review. Codex's
review reversed the unit's initial judgment: the requested change moves the command's authority, input
domain and output contract at once, which is a material expansion under `docs/work-loop.md:48` and
belongs to `/develop-ai-resource`, not to a `/work-loop` settled correction. Adjudicated all four
review findings, wrote a raw handoff brief to `inbox/`, logged one `/work-loop` contract defect the
review also surfaced, and closed the unit `routed-out`. `.claude/commands/leverage-idea.md` was never
edited.

### Decisions Made
- **`routed-out`, not implemented here** — accepted Codex's MATERIAL 2 finding in full; the command's
  three-axis expansion (authority / input domain / output contract) is material, not a settled
  correction. Superseded, did not delete, the Frame evidence's original narrower judgment (append-only
  rule).
- **MATERIAL 1 rejected** — Codex's "agent authority gap" claim rested on inspecting 3 files; the
  governing rules doc `docs/ai-resource-creation.md` names agent definitions under
  `/develop-ai-resource`'s authority four times, uninspected by the reviewer. Kept the narrower true
  observation (the command's own list omits the word "agent") as a text-fix note in the handoff.
- **MATERIAL 3 (a real `/work-loop` contract/command disagreement) logged, not fixed inline** — fixing
  it would have edited `/work-loop`'s own files, outside this unit's declared object
  (`leverage-idea.md`). Logged to `logs/improvement-log.md` instead.
- **D1 (the bridge-matrix bypass) travels with the rest of the expansion rather than being split out**
  — it is very likely a settled correction on its own, but the brief's stated need was the whole
  expansion; splitting it out would be a new, narrower brief.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None — no destructive or external action taken; no gate skipped. One notable near-miss avoided: the
unit's initial route judgment (implement inside `/work-loop`) would have satisfied the brief's own
falsification condition ("any proposed new durable AI resource bypasses `/develop-ai-resource`") had
it not been caught by review before any edit was made.

### Next Steps
Run `/develop-ai-resource inbox/leverage-idea-lifecycle-routing.md` in a fresh session to qualify
whether and how `/leverage-idea` should be expanded. A legitimate outcome of that command is "no
build." Full evidentiary trail (premises, route reasoning, all five defects, adjudication) is
recoverable at commit `1a40c60` (`logs/loop/2026-07-29-leverage-idea-lifecycle-frame.*`, deleted from
the working tree at stream close per `docs/work-loop.md` § Artifacts).

### Open Questions
None.

## 2026-07-29 — /leverage-idea → routing-and-handoff command: qualified, built, gated, committed (merge pending)

### Summary
Ran `/develop-ai-resource` on `inbox/leverage-idea-lifecycle-routing.md` — the raw brief routed out of
`/work-loop`'s `2026-07-29-leverage-idea-lifecycle-frame` unit. Qualified through Step 1 (verdict:
improve an existing shared resource, no new component), built the expansion (Step 2), self-verified by
execution and a simplify pass (Step 3), then ran independent `/qc-pass` + `/risk-check` on operator
authorization. Both returned non-passing verdicts; all findings were independently re-verified, fixed
(re-QC waived by the operator), and the candidate was committed. Landed in this worktree
(`session/2026-07-29-leverage-idea`, commit `b2bb1bd`); merging into `main` was scoped, dry-run
verified clean, and left pending for the operator to trigger.

### Decisions Made
- **(Claude, `/develop-ai-resource` Step 1.6)** Verdict: improve an existing shared resource —
  `.claude/commands/leverage-idea.md`, no new component. Mechanism is direct edit, not `/improve-skill`
  (object is a command, not a skill). Complexity budget cleared on both prongs (net-simplification +
  cited evidence in `logs/improvement-log.md` 2026-07-12).
- **(Operator)** Authorized fresh-context subagents specifically for `/qc-pass` and `/risk-check` on
  this candidate (the session's default posture otherwise excludes the Agent tool), with a conditional
  rule: both PASS/GO → commit; either non-passing → stop and show findings before committing.
- **(Operator)** Keep the tracked `inbox/` write on the new-AI-resource route — the one genuinely new
  behavior flagged at the Step 4 report.
- **(Operator)** No edits to the System Owner sibling repo (`projects/axcion-ai-system-owner/`) in this
  change; `toolkit-relationship.md`'s stale `/leverage-idea` row is a named, deferred follow-up.
- **(Operator, risk-accepted — logged to `decisions.md`)** After both gates returned non-passing
  verdicts: apply the identified fixes and commit, **skipping the re-QC** that would ordinarily follow
  a QC-REVISE fix pass. See `decisions.md` 2026-07-29 for rationale and alternatives considered.
- **QC fixes applied** (`qc-reviewer` verdict: REVISE, all three fixed): `develop-ai-resource.md:22`
  stop-point wording updated (`/leverage-idea` no longer described as stopping at a plan); Step 7's
  `## Capability` heading-form clause added, preventing a brief from this command's own main route
  from tripping `/develop-ai-resource` Step 1.0's malformed-upstream-handoff check; `WORKSPACE` in the
  Step 4 investigator brief redefined by ancestor walk-up instead of parent-of-`AI_RESOURCES` (latent,
  not live today, but wrong once a worktree sits outside the workspace root).
- **Risk-check mitigations dispositioned** (`risk-check-reviewer` verdict: PROCEED-WITH-CAUTION, blast
  radius High — inherent to the 14-project symlink fan-out): `toolkit-relationship.md` — DEFERRED
  (sibling repo excluded by operator instruction); stale `leverage-idea.md` line citations in four
  `plans/2026-07-28-develop-capability-build-plan*.md` files — DECLINED (all four carriers are
  SUPERSEDED/HALTED with DO-NOT-IMPLEMENT banners; the live build authority cites the command nowhere);
  `/work-loop` input-shape compatibility — VERIFIED (accepts a plain-English need, matching the payload
  shape this command now hands it).

### Risky actions
The first commit attempt silently staged only the brief's deletion — a prior `git rm` had already
removed `inbox/leverage-idea-lifecycle-routing.md` from the pathspec list, so the follow-on `git add`
with that stale path in it aborted with a fatal pathspec error and staged nothing else, but the
subsequent `git commit` still ran against whatever was already staged (the deletion alone) rather than
failing loudly. Caught immediately by the mandated post-commit `git show --stat` self-verification,
before any push; corrected by re-staging the full file set and amending. No push occurred against the
incomplete commit. Worth a structural look: a `git add` that partially fails on a multi-path invocation
should probably be treated as blocking, not silently proceeding to commit whatever did stage.

### Findings Declined
- Stale `/leverage-idea.md` line-number citations in four `plans/2026-07-28-develop-capability-build-plan*.md`
  files — not queued: all four carriers are SUPERSEDED/HALTED with DO-NOT-IMPLEMENT banners, and the
  live build authority (`plans/2026-07-28-work-loop-consolidated-build-plan.md`) cites the command
  nowhere. No live consumer to protect. (Full check: this session's `/risk-check` report.)

### Next Steps
- **Land the branch.** `session/2026-07-29-leverage-idea` is 7 commits ahead of `main`; a dry-run merge
  (`git merge-tree --write-tree`) came back clean with no conflicts. Run
  `git -C ".../ai-resources" merge session/2026-07-29-leverage-idea` from the main checkout, then decide
  on push (gated, per this session's wrap prompt below).
- **The branch has no upstream and is not on GitHub** — until merged or pushed, these 7 commits exist
  on this machine only. Do not delete the `ai-resources-leverage-idea` worktree before that happens.
- Separate follow-up session: update `projects/axcion-ai-system-owner/references/toolkit-relationship.md`
  § 2's `/leverage-idea` row (sibling repo, excluded from this change by operator instruction) — now
  queued in `logs/improvement-log.md` 2026-07-29 (severity medium-high) so it stays reachable.
- 5 of 6 commands remain unretrofitted for the `general-purpose` dispatch-pinning carve-out (`tweak`,
  `decide`, `graduate-resource`, `promote-workflow`, `wrap-session`) — tracked, not blocking.
- New this session: a `git add`-with-stale-pathspec near-miss queued to `logs/improvement-log.md`
  2026-07-29 (severity medium) — see § Risky actions above.

### Open Questions
Whether to merge into `main` and/or push now, or leave both for a later session — explicitly left to
the operator, not yet decided as of this wrap.

## 2026-07-29 — Closed the review-layer-consolidation work-loop stream at G2

### Summary

Resumed from a `/handoff` scratchpad mid-Prove on the `2026-07-29-review-layer-consolidation` stream and took it through to stream close. Finished the P3/P4 verification the prior session left half-done, adjudicated Codex Prove review-1 (verdict REVISE), applied the resulting repairs, and closed the stream on the operator's G2 approval. Prove and the review together found **24 live references to machinery the four Build slices had already declared removed** — five caught by the protected-safeguard pass, nineteen more by adjudicating the review. Two were materially broken producer/consumer contracts that would have silently dropped a high-consequence item's review. All protected safeguards verified unchanged throughout.

### Decisions Made

**On the review adjudication**
- **M1 accepted in part** — 19 sites repaired, 7 declined. The line drawn: this stream removed the *automatic* firings, but `/qc-pass` and `/risk-check` survive as operator-invoked commands and `audit-discipline.md` § Risk-check change classes is a live heading. A site is a defect when it makes a review fire as a standing step or names a field/verdict no producer emits; a site that names the live taxonomy or describes an operator invoking a surviving command is not. Rekeying the latter would break valid pointers to simulate migration.
- **M2, m1, m2 accepted in full** — the `work-loop.md:105` omission, the falsifier 1/4 wording, and the missing LIMITATIONS section.
- **One of my own calls reversed mid-verification** — I initially declined the `parallel-sessions-playbook` sites, then the deterministic sweep flagged `:227`'s "`/risk-check`-gated" as the identical phrase I had just repaired in `lean-repo.md:92`. Treating the same phrase differently by file type is not defensible; repaired for consistency, reversal recorded in the evidence rather than dropped.
- **Two defects found by following the review's lead rather than its list** — `resolve-incident.md:217,243` still escalated on a "RECONSIDER verdict" the command no longer produces. Codex did not cite them.
- **Falsifier 2 closed structurally, not by re-counting** — plan-v3's counting scope could not be reproduced (three attempts, three different totals, none matching). Chose the structural argument over adjusting exclusions until the numbers agreed. Recorded as a limitation and queued as an improvement item.

**On closure (operator-directed)**
- **G2 APPROVED by the operator**, with all four remaining items deferred and no further review round. Closure executed per `docs/work-loop.md` § Artifacts as two commits — evidence marked `Status: complete` first (`b8ef77f`), then the stream-closing commit deleting all 19 `logs/loop/{STREAM}-*` files (`1c82aef`), so the final evidence state exists in git before deletion. Same two-commit resolution used at `94a4618`.
- **Telemetry not captured** — operator-directed (`core path only`). Deliberate, not an omission.
- **Concurrent session's dirty files left untouched** — operator-directed.

### Risky actions

**Deleted 19 files in the stream-closing commit** (`logs/loop/2026-07-29-review-layer-consolidation-*`) — contract-required, operator-directed, all recoverable at `b8ef77f`, and the other open stream (`2026-07-29-prime-minimum-responsibility-*`) was verified untouched before staging. Separately: the `check-foreign-staging.sh` guard was **off for all five commits** this session (no session marker on a `/handoff`-resumed session) while a concurrent session was actively writing to the same worktree — staged paths were verified by hand on every commit instead. Queued as a medium-high improvement item.

### Findings Declined

- **The pattern-scope method rule** (a reference sweep must be keyed on the concept, not the token — four consecutive units declared the sweep complete and each was wrong). Declined a separate improvement entry: it is recorded durably as the method rule in the stream's `logs/decisions.md` closure record, which is the right home for a rule derived from a closed stream.
- **The four deferred follow-ups** (prime-owned files; workspace-root `CLAUDE.md`; `projects/positioning-research`; `work-loop.md:105`). Declined queueing — the operator explicitly took ownership at G2 and all four are recorded with line numbers in the closure record. Duplicating them into `improvement-log.md` would create two backlogs for one set of items.
- **"This unit repaired what it reviewed"** — a real limitation (24 sites changed by the session judging them, no independent read of the repairs), but it is stated in the Prove evidence § 12 and in the closure record, and the operator adjudicated G2 with it visible. Nothing further to queue.

### Next Steps

- **Follow-up 4 is the one that matters** — `.claude/commands/work-loop.md:105` still orders two stacked `/risk-check` gates on the challenged route and cites `docs/audit-discipline.md:73-81`, a line range S1 deleted. Until it lands, the command running the loop contradicts the policy the loop just shipped. It was correctly excluded from this stream (a stream may not rewrite the contract it runs under) and is now unblocked, because that stream has closed.
- Follow-ups 1–3 (prime-owned files, workspace-root `CLAUDE.md`, `projects/positioning-research`) as the operator sequences them. Follow-up 2 is what makes the change visible in workspace-rooted sessions at all.
- The other open stream `2026-07-29-prime-minimum-responsibility` still has Frame evidence and a Shape brief on disk, awaiting its Shape unit.

### Open Questions

- A concurrent session was working this same stream in this worktree (four commits, plus dirty `logs/friction-log.md` and `logs/innovation-registry.md` left in place per instruction). Whether it still has uncommitted work is unknown from here — worth confirming before that worktree is used again.

## 2026-07-30 — Created and landed worktree `session/2026-07-29-2` into main (merge conflict resolved, log append-order fixed)

### Summary
Ran `/new-worktree-session` to create an isolated worktree (`ai-resources-2`, branch `session/2026-07-29-2`) for parallel work, opened it in a new VS Code window. Later ran `/close-worktree-session` to land it; the standard guard correctly blocked on uncommitted changes in the worktree (auto-generated log-append content), which was committed rather than discarded. The merge into `main` then conflicted in `logs/friction-log.md` and `logs/improvement-log.md` — both pure-append conflicts against a concurrent session's own merged-in work — resolved by combining both sides' entries rather than picking one. That combination left two other logs (`session-notes.md`, `decisions.md`, already union-merged) with entries out of the repo's required newest-last order, tripping the `check-append-order` pre-commit hook; fixed by relocating the misplaced blocks to file end, content and internal order unchanged. Merge committed (`b15880e`), post-merge duplicate-header and conflict-marker checks passed clean, worktree removed and branch deleted.

### Decisions Made
- **(Operator)** "Just merge this, don't ask me anything" — instruction to proceed through the uncommitted-changes and merge-conflict guards without further questions. Interpreted as authorization to resolve conflicts safely (preserve all content, never discard) rather than to bypass safety checks recklessly: committed the worktree's dirty files instead of discarding them, combined both sides of the append-only conflicts instead of picking one, and fixed the resulting append-order violation structurally rather than with `--no-verify`.
- **(Claude)** Resolved the `friction-log.md`/`improvement-log.md` merge conflicts by concatenating both sides (HEAD's block, then the branch's block) since both were pure appends with no in-place edits on either side — no content lost.
- **(Claude)** Did not use `--no-verify` when `check-append-order` blocked the merge commit; instead relocated the two misplaced blocks (`session-notes.md` lines 305–343, `decisions.md` lines 252–314) to end-of-file to satisfy the append-order contract.
- **(Claude, per operator's "2")** Named the worktree unit `2` (branch `session/2026-07-29-2`) since no descriptive unit name was supplied when `/new-worktree-session` was invoked.
- **(Claude)** Triaged 5 pre-existing `detected` innovation-registry rows (from the merged-in worktree's own session work, dated 2026-07-29: `promote-workflow.md`, `lean-repo.md`, `pipeline-review-auditor.md`, `resolve-incident.md`, `resolve-repo-problem.md`) as `triaged:project-specific` — all are edits to commands/agents already living in this canonical `ai-resources` repo, so no further graduation destination applies.

### Outcome
(Step 6.4 skipped — not requested)

### Risky actions
Resolved a git merge conflict on shared log files, combining content from a concurrent session, rather than stopping per `/close-worktree-session`'s normal guard ("never auto-resolve a merge conflict — stop and hand back control"). Done under explicit, repeated operator instruction after an initial guard trip on uncommitted worktree changes. Mitigated by verifying no conflict markers landed in the working tree or `HEAD` (both checks confirmed clean) and by never discarding either side's content. Also removed a worktree and deleted a branch — both guarded, both completed cleanly (worktree was clean at removal time, branch was fully merged before deletion).

### Next Steps
- Two other session worktrees remain open: `ai-resources-leverage-idea` (branch `session/2026-07-29-leverage-idea`, per its own session note 7 commits ahead, dry-run-clean) and `ai-resources-work-loop` (branch `session/2026-07-29-work-loop`). Neither was touched this session — landing each is a separate `/close-worktree-session` call from the main checkout.
- Commits are unpushed on `main` pending this wrap's push gate.

### Findings Declined
- **Operator override of the merge-conflict stop-and-handback guard.** Not queued as a separate improvement-log entry — it is a one-off, explicitly operator-directed override (not a recurring defect pattern), and it is already recorded above under `### Risky actions` with its mitigation.

### Open Questions
None.

## 2026-07-30 — Retired /qc-pass, /risk-check, /resolve, /refinement-deep — Codex is the second opinion

### Summary
Operator instruction: retire the QC-pass and risk-check gates, since Codex second-opinion review now covers that role. The 2026-07-29 review-layer consolidation had already made Codex the reviewer in policy but explicitly deferred the cross-project migration ("26 projects link to them"); this session completed that migration and executed the retirement. Deleted `/qc-pass`, `/risk-check`, `/resolve`, `/refinement-deep`, the `qc-reviewer` and `risk-check-reviewer` agents, their `.codex` twins, ~180 project symlinks, 3 forked `qc-pass.md` copies, and two `.codex` auto-nudge hooks that were still live-firing on every Write/Edit. Found and fixed five genuine functional breaks (not just stale prose) where deleted resources were still actively invoked or spawned: `/prime` 8c.11, `/new-project`'s symlink scaffolding, `/friday-journal` + `/cleanup-worktree`'s subagent spawns, and the research-workflow template's manifest + commands. Renamed `audit-discipline.md` § "Risk-check change classes" → "Structural change classes" throughout. Verified clean: no dead agent spawns, no broken symlinks, all touched JSON/shell parses.

### Decisions Made
- **(Operator, via AskUserQuestion)** Blast radius: retire the QC-loop machinery (`/resolve`, `/refinement-deep`) alongside the two named commands, not just the two, and not keeping `/qc-pass` as a Codex-unreachable fallback.
- **(Operator, via AskUserQuestion)** Sweep depth: fix wiring + docs (commands/agents/hooks/settings/CLAUDE.md/docs/skills/templates/workflow-templates); leave `logs/`, `audits/`, `plans/`, `reports/` untouched as historical record.
- **(Claude)** Repointed `/friday-journal` and `/cleanup-worktree`'s deleted `qc-reviewer` spawns to a tier-pinned `general-purpose` dispatch with the rubric inlined, rather than leaving them broken or inventing a replacement named agent.
- **(Claude)** Repointed the research-workflow template's spawns to its own pre-existing local `qc-gate` agent rather than the deleted canonical `qc-reviewer`.
- Full context, rationale, and alternatives considered logged in `logs/decisions.md` under this same date/title.

### Outcome
(Step 6.4 skipped — not requested)

### Risky actions
None — all deletions were of resources whose canonical successor (Codex review) already existed in policy since 2026-07-29; nothing irreversible outside normal git history, and everything deleted is recoverable from git immediately prior to the retirement commits.

### Next Steps
- Push the two unpushed commits (`ai-resources` `38981e5`, workspace root `dc30c9d`) via this wrap's push gate.
- Two other session worktrees remain open from a prior session (`ai-resources-leverage-idea`, `ai-resources-work-loop`) — untouched this session, landing each is a separate `/close-worktree-session` call.

### Findings Declined
None — no findings surfaced this session beyond the retirement work itself, which was fully executed and verified, not deferred.

### Open Questions
None.

## 2026-07-31 — Supervised work-loop repair, Slice 1 Shape — plan reviewed twice, G1 approved

### Summary
Acquired sole-writer ownership of the dedicated repair worktree (`ai-resources-g1-reviewed-plan`,
branch `codex/2026-07-31-g1-reviewed-plan-invariant`) per `docs/work-loop-repair-workflow.md`, after
verifying a prior session's committed release. Ran the Shape unit for Slice 1 (G1 reviewed-plan
integrity) to completion: transcribed and adjudicated an independent Codex review of plan-v2 (3
material findings), produced plan-v3, then plan-v4 after an operator-directed proportionality
withdrawal on one finding's design, transcribed and adjudicated a zero-finding closure review-2, ran
the mandated pre-G1 identity comparison, and presented the G1 package. **Operator approved G1**, bound
to the exact plan-v4/review-2 identities. Wrote the implementation handoff, released ownership, and
verified the worktree clean. No object under repair (`docs/work-loop.md`,
`.claude/commands/work-loop.md`, `.agents/skills/work-loop/SKILL.md`, `templates/capability-record.md`)
was touched — this unit is planning-and-review only; nothing has been implemented.

All substantive work happened in the dedicated repair worktree, on a branch not yet merged to `main`.
Nothing in this `ai-resources` checkout was modified by the repair work itself — only this wrap's own
bookkeeping touches this checkout.

### Decisions Made
- **Wrap-routing (mine, stated not asked).** This session's persistent shell cwd was confirmed to be
  this main checkout, not the repair worktree — verified before writing anything, since the repair
  workflow forbids writing to that worktree without re-acquiring ownership (already explicitly
  released) and forbids any diff there outside the approved four-file/`logs/loop/` scope. No conflict
  needed resolving in practice; confirmed rather than assumed.
- **Decisions-journal routing (mine, stated not asked).** The session's substantive operator decisions
  — widening Slice 1's implementation scope from three files to four (plan-v2), and withdrawing the
  RV2-01 byte-identity/verbatim-persistence requirement as disproportionate (plan-v4) — are **not**
  duplicated into this checkout's `logs/decisions.md`. They are already durably recorded, append-only,
  inside the repair unit's own Shape evidence artifact
  (`logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.evidence.md`, on the repair branch), per the
  repair workflow's own artifact discipline (§14: "Do not create multiple permanent planning-document
  families"). A `logs/decisions.md` pointer entry is the stream-close convention
  (`docs/work-loop.md` § Closing without a change) and belongs to this stream's eventual close, not to
  an in-flight Shape unit — recorded here so the omission reads as deliberate, not missed.
- **G1 approval, operator-issued, on the repair branch.** Bound to `plan-v4` (commit `df45a2b1a42a2140c85a56e71c395407dc9eb903`,
  blob `9ae4839afc8ccb23c4bd50a2644f32213273ed90`) and `review-2` (commit `12b22dd9acfc76094f0803f29d64b5935ead4f83`,
  blob `848ee9f940c562f421c6ef727e358d21c73a299f`). Authorizes only the exact one-slice, four-file
  package plan-v4 states; the zsh-syntax annotation permits safe shell forms during verification only,
  not additional scope.

### Risky actions
None. Every write this session was confined to `logs/loop/` on a dedicated branch, staged by explicit
pathspec; nothing under repair was touched; nothing was pushed mid-session.

### Session Assessment
Skipped (Step 6.5 not requested — no `+feedback`/`full` flag).

### Next Steps
- **The real continuation point is the repair handoff, not a command in this checkout:**
  `logs/loop/2026-07-31-g1-reviewed-plan-invariant-shape.handoff-2.md`
  (commit `833762c2a0570287f0e9ec31743bdeffbac59a2e`, worktree
  `ai-resources-g1-reviewed-plan`, branch `codex/2026-07-31-g1-reviewed-plan-invariant`). A new Claude
  session must verify it, explicitly acquire ownership, then open the Build unit and implement the
  G1-approved plan-v4 package — exactly the four files it names, nothing else.
- Two prior-session worktrees remain open and untouched (`ai-resources-leverage-idea`,
  `ai-resources-work-loop`) — same as noted in the entry above; still someone else's separate
  `/close-worktree-session` call.
- This wrap's push gate, if confirmed, ships both this checkout's wrap commit and the repair branch's
  accumulated commits (same origin, different branch) — see the push prompt below.

### Findings Declined
- **Shell-syntax hazard in the plan's mandatory shell note** (declined for `improvement-log.md`).
  Two distinct zsh hazards surfaced this session — unquoted word-splitting (silent false negative,
  Frame §1) and `:l` read as a lowercase parameter modifier (loud failure, Shape evidence §9.5). Not
  queued as a general-system finding: it is already actionable and recorded inside the repair stream's
  own artifacts (plan-v4 §11.5's shell note, and the handoff's method note), which the next Build
  session will read directly. Duplicating it into this checkout's `improvement-log.md` would be a
  second, less-precise copy of guidance that already has an owner and a concrete next reader.

### Open Questions
None. The repair stream's next action is fully specified in the handoff.

## 2026-07-31 — work-loop repair, Slice 1 (G1 reviewed-plan integrity) — Build, Prove, correction, closure

### Summary
Continued the `/work-loop` repair program from a G1-approved plan (prior session) through the full
Build → Prove → correction → closure sequence, entirely in the dedicated worktree
`ai-resources-g1-reviewed-plan` (branch `codex/2026-07-31-g1-reviewed-plan-invariant`). Implemented the
four-file G1-reviewed-plan-integrity slice, took a full Codex Prove review with two material findings,
adjudicated both, spent the single bounded correction pass under an explicit operator scope binding,
and closed the stream at operator direction: **G2 approved, G3 adopted.** Slice 1 is complete.

### Decisions Made
- **Build unit opened and implemented** — plan-v4's exact G1-approved four-file slice, one atomic
  commit (`8762fc7f…`). All 20 acceptance criteria and every fixture measured with positive controls
  in the Build evidence.
- **Prove review-1 adjudicated** — both material findings reproduced against live files before
  disposition (not accepted on the reviewer's word alone). G1-PV1-01 (Shape-only `hold-reframe` leaking
  into Prove/reviewed-route, introduced by my own Build rendering) → `deferred`. G1-PV1-02 (A20/F12 fail
  because the repair-workflow doc sits outside the approved-base diff, traced to a pre-Shape commit) →
  `operator`, three options presented, Option A recommended.
- **Operator approved Option A** — a narrow, Slice-1-only scope binding recognizing
  `docs/work-loop-repair-workflow.md` at its exact pre-existing blob as pre-Shape governance, not an S1
  target. Does not touch approved base, plan-v4's identity, or the four-file scope.
- **Correction pass spent once, on both findings together** — 5 sites corrected in 2 files (3 the
  review specified, 2 more surfaced by the required negative search — one of which was the most exposed
  leak of the five and unnamed in the review). Supersession entries appended to Build and Prove
  evidence; nothing rewritten. All affected criteria re-measured at the final HEAD.
- **Operator's "speed + 90%" priority override** arrived after the correction was already committed —
  ran only the four named checks against the completed work, reported nothing further to commit, and
  named the two ways prior work already exceeded that override's intended scope rather than silently
  conforming after the fact.
- **Operator closure override** — waived Prove `review-2` transcription, accepted the resolution,
  **G2 APPROVED** at candidate HEAD `179bc0d6…`, waived representative Use with residual limitations
  accepted, **G3 ADOPT**. Wrote and committed the `CLOSE` block (append-only). Released ownership.
  Chose to retain `logs/loop/` artifacts rather than delete them (this repair does not use
  `/work-loop`'s own stream-close deletion) — flagged as a judgment call rather than decided silently.

### Findings Declined
None this session beyond what the repair stream's own evidence already records as deferred (BF-1,
BF-2, OF-1, OF-3 — each with a reopening trigger, none new).

### Risky actions
None. Every commit in the worktree was staged by explicit pathspec; no destructive git operation was
run; every operator override was verified against Git before being acted on rather than taken on trust.

### Next Steps
Slices 2–8 of `docs/work-loop-repair-workflow.md` § 12 remain (Active-unit routing · G2 candidate
integrity · working state/ownership · transition/phase enforcement · review quality · Diagnose & Fix
adoption · legacy consolidation). Slice 1 is the worked template for the Shape→Build→Prove→G2/G3
sequence in that worktree. Deferred BF-1/BF-2/OF-1/OF-3 are candidates for a future slice's scope, not
orphaned.

### Open Questions
None. Slice 1 is closed and adopted; the durable Git pointer is recorded in the Prove evidence CLOSE
block.

### Review status (Step 12b)
The structural-class changes this session produced — `docs/work-loop.md`, `.claude/commands/work-loop.md`,
`.agents/skills/work-loop/SKILL.md`, `templates/capability-record.md` — were made in the separate
`ai-resources-g1-reviewed-plan` worktree, under `docs/work-loop-repair-workflow.md`'s own governance,
which deliberately excludes the standard `/work-loop` review-independence path for changes to
`/work-loop` itself. Independent review ran through that program's own mechanism instead: Codex Prove
`review-1` (2 material findings), both reproduced and adjudicated by Claude, one bounded correction pass
under an operator-approved scope binding, then operator-directed G2 approval and G3 adoption in lieu of
a closure `review-2` (explicitly waived by the operator). Reviewed, not unassessed — via the repair
program's substitute gate rather than this repo's ordinary QC path.

## 2026-08-01 — Installed the Work Loop v2 MVP project (Step 0)

### Summary
Setup-only session, per the operator's explicit instruction: build nothing, design nothing. Committed
the four documents governing the Work Loop v2 MVP build into a new project folder, wrote an authority
README, and created the mission contract. Ran `/placement` first since this was a new top-level project
folder in an ambiguous layer (`plans/` vs `docs/`); its recommendation (`plans/`) was followed. Corrected
one factual claim in the README before committing (the Playbook's named commands — `/to-spec`,
`/implement`, etc. — do exist, as user-level Pocock skills in `~/.claude/skills/`, not in this repo).

### Decisions Made
- Placed the project folder at `ai-resources/plans/work-loop-v2-mvp/`, not `ai-resources/docs/`, per
  `/placement`'s recommendation — `docs/` already hosts the live v1 work-loop runtime contract
  (`work-loop.md`, `work-loop-spec.md`), and colocating the v2 destination-reference document there would
  invite exactly the authority confusion the README is meant to prevent.
- Added a canonical-home row to `docs/repo-architecture.md` for "multi-document build project"
  (`plans/<project-slug>/` with an authority README), since the map's existing plan-artifact row only
  described a flat file.
- Added an authority notice directly inside the Complete System explainer file (not just the README), so
  a session that opens that file directly still sees the destination-reference-only warning.
- Mission's validation contract, non-negotiables, and off-mission signals were drafted from Proposal § 4
  and § 6 rather than left as template placeholders, since the operator's setup instruction said "keep it
  light" but the mission template's own contract calls for writing the validation contract now, while
  fresh.

### Risky actions
None.

### Findings Declined
None — no findings this session (setup-only, no review, no defects observed).

### Next Steps
Playbook Step 1 (next session): investigate Codex-side resource packaging in the real Codex app — how a
Codex-side resource is installed, invoked, and reads/writes repository files. Commit a short cited
findings note. Do not investigate Claude Code command conventions (Claude inspects the repository itself
when implementation starts).

### Open Questions
None.

## 2026-08-01 — Session S1-eb7

**Mandate:** Investigate Codex-side resource packaging by inspection of primary sources — how a Codex-side resource is installed, invoked, and reads/writes repository files, plus any format or size constraints — done when: `plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md` exists and is committed, every claim cited to an inspected source, and anything not inspectable from here named as an open gap rather than guessed.
- Out of scope: Claude Code command conventions (the repository answers repository questions at implementation time); building anything (no command, no resource, no executable core); any capability from the Complete System explainer (Consequential lane, worktrees, reviewer machinery, automation) — destination reference only, creates no requirements.
- Files in scope: (inferred)
- Stop if: answering a question would require asserting Codex behaviour that cannot be inspected from here — record it as an operator-checkable gap and continue with the rest.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, .agents/skills/work-loop/SKILL.md, docs/work-loop.md, ~/.codex/ and any Codex config or install surface present on this machine, Codex primary documentation
- Required outputs: plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 1 — investigate Codex-side resource packaging; commit a cited findings note

### Summary
Executed Playbook Step 1 for the Work Loop v2 MVP: answered the four Codex-packaging questions by
inspection, not guesswork. Established locally that `.agents/skills/` is scanned as a repo-level skill
source and that the five repo-side skills are all visible to Codex — but found that `.gitignore`
excludes all of them except `work-loop/`, so four exist only on this machine. Drafted a targeted
question set and handed it to the operator to run inside the real Codex app; verified every citation
Codex returned against the actual files (three line-number citations were wrong, substance correct each
time) before writing the findings note. Wrote and committed
`plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md`.

### Decisions Made
- Ran the context-discovery engine (Step 2.4 of `/session-start`) — skipped it deliberately: this
  session reads and produces one new file, it does not modify existing repo structure, so the engine's
  pre-change routing map has nothing to contribute.
- Chose not to redesign the Proposal's repository-round-trip transport when local inspection found
  Codex could write files but not commit in the observed session. Recorded the finding as Step 2's first
  premise to test rather than treating it as a settled fact or acting on it — the Proposal is
  authoritative per `plans/work-loop-v2-mvp/README.md`, and a transport redesign is its call, not this
  session's.
- Corrected three mis-cited line numbers in the Codex-supplied report (the `description` length cap,
  the 500-line/5k-word recommendation, and the push-prohibition line) before writing them into the
  findings note, rather than reproducing the citations uninspected.
- Recorded `.agents/skills/` being gitignored (except `work-loop/`) as a build-relevant finding for
  later steps, not as a fix to apply now — out of this step's declared scope.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None. All commands run this session were read-only inspection (file reads, `grep`, `codex --help`,
config inspection) except the final `git add` + `git commit` of the one new findings-note file, staged
by explicit path. No destructive or external action taken.

### Findings Declined
- **`codex --help` on this machine resolves to a macOS-blocked binary and fails silently** — not queued
  as a new improvement-log entry: it is fully recorded, with evidence and the practical workaround (use
  the ChatGPT.app path), inside the findings note itself (§5), which is the correct durable home for a
  Codex-runtime fact this build's later steps will read directly. Duplicating it into
  `improvement-log.md` would split one fact across two owners for no benefit — it is a fact about the
  machine's Codex install, not a recurring Claude Code workflow defect.

Findings: 1 — queued 0, declined 1. 0 + 1 = 1.

### Session Assessment
Feedback collection skipped (not requested).

### Next Steps
Playbook Step 2 (next session): prototype the transport seam (throwaway). Test the round trip — does a
minimal repository-based hand-off between Codex and Claude actually work cleanly? Its first, sharpened
question from this session's findings: **can Codex commit at all** — Step 1 observed `.git` write-protected
in one session and could not establish whether that is fixed policy or a clearable per-session state.
Also test whether a new skill placed in `.agents/skills/` needs an explicit `.gitignore` re-include (like
`!work-loop/`) to survive in the repository. Discard the prototype code; keep only the conclusions note
and the minimal viable schema, per Playbook Step 2.

### Open Questions
None blocking. Noted, not resolved: whether Codex's inability to commit in the observed session is a
fixed runtime property or a configurable/escalatable one — named as Step 2's first thing to test, not
answered here.

## 2026-08-01 — Session S2-af1

**Mandate:** Prototype the Work Loop v2 transport seam (throwaway) — run one repository-based Codex/Claude round trip through a minimal state file and record the seam's real behaviour plus the minimal viable schema — done when: the round trip has worked once end to end across both apps; `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` exists and is committed recording the seam's behaviour and the minimal viable schema; both sharpened questions (can Codex commit at all; does a new `.agents/skills/` skill need its own `.gitignore` re-include) are answered by execution or named as operator-checkable gaps; and the prototype artifacts are discarded.
- Out of scope: writing the executable core (Step 3); building the Claude command or the Codex resource; designing schema beyond what the prototype actually proves; any capability from the Complete System explainer (Consequential lane, worktrees, reviewer machinery, automation) — destination reference only, creates no requirements; editing, retiring or "aligning" Work Loop v1; keeping the prototype code.
- Files in scope: .gitignore, logs/missions/work-loop-v2-mvp.md
- Stop if: the Codex side cannot be driven at all from this machine — record it as an operator-checkable gap rather than simulating Codex's half of the round trip; or answering a question would require asserting Codex behaviour that cannot be observed — record the gap and continue with the rest.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md, .agents/skills/work-loop/SKILL.md, docs/work-loop.md, .gitignore, ~/.codex/ and any Codex config or install surface present on this machine
- Required outputs: plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, logs/loop/wl2-state.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 2 — transport-seam prototype (throwaway): test the Codex/Claude repository round trip

### Summary
Ran Playbook Step 2 to completion: a throwaway round trip between Codex and Claude through a
minimal state file (`logs/loop/wl2-state.md`). The round trip worked end to end (Codex writes brief
→ Claude reads/answers/commits → Codex reads result), but the key finding is that **git carried
none of the hand-off** — the file's full history is one commit (Claude's), so the shared working
tree did the transporting, not git. Both of Step 1's inherited premises were answered by execution:
Codex still cannot write `.git` (two independent sessions, same error), proven to be a Codex sandbox
restriction rather than a repo fault (positive control: Claude ran Codex's identical failing command
and it succeeded); and a new `.agents/skills/` skill needs exactly one `.gitignore` re-include line,
not four. Harvested a three-field minimal schema (`turn` / `Brief` / `Result`) with per-field
evidence, and flagged that `turn` is a protocol field absent from the Proposal's content ceiling —
for Step 3 to decide, not decided here. Wrote and committed the conclusions note, ticked both
mission threads with evidence pointers, and discarded the prototype (state file removed; one probe
skill folder remains — see Risky actions).

### Decisions Made
- Chose the shared-working-tree fallback (Codex writes/Claude commits) to *run* the round trip once
  Codex's `.git` block reproduced, rather than stopping the session — the Playbook explicitly allows
  this as a way to learn, and the mandate's `stop_if` only requires recording a gap, not halting on
  one. Did not treat the fallback as a transport redesign; the conclusions note states this
  explicitly as a Proposal-level decision reserved for the operator.
- Corrected the count sent back to Codex in the state file's Result section: the on-disk count of
  6 skill folders included the session's own throwaway probe folder. Rather than write a
  misleading number, both counts were recorded (6 raw / 5 excluding the probe) with the reason
  stated inline.
- Reverted the `.gitignore` re-include line immediately after using it to prove premise 2, rather
  than leaving it live — a live re-include is a commit hazard the plan's step 8 exists to prevent.
- Self-corrected the mandate line's `Files in scope` value mid-session after a hook flagged that
  `(inferred)` disables `check-foreign-staging.sh`'s guard regardless of what concrete paths are
  appended alongside it — removed the marker, kept the paths.

### Outcome
Outcome check skipped (not requested).

### Session Value Audit — 80/20 Review
Skipped (not requested).

### Risky actions
None destructive. One loose end: a throwaway probe skill folder (`.agents/skills/wl2-probe/`) is
still on disk — its removal was declined at the permission prompt twice (mid-session and at
cleanup). It is gitignored so it cannot be committed by accident, but it was not cleaned up as the
plan's step 8 intended. Flagged in the continuity scratchpad for the operator or the next session.

### Findings Declined
- **Probe folder deletion declined twice at the permission prompt.** Not queued — this is routine
  permission-in-the-loop behavior, not a system defect. Already recorded above under Risky actions
  with the continuity scratchpad as the operator-facing follow-up.
- **Codex cannot write `.git` (2 independent sessions); a new `.agents/skills/` skill needs exactly
  one `.gitignore` line, not four.** Not queued — both are fully recorded, with evidence and source
  tags, inside `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md`, the correct durable
  home for build-relevant Codex-runtime facts this project's later steps will read directly. Same
  reasoning Step 1 applied to its own declined finding (`codex --help` blocked): duplicating into
  `improvement-log.md` would split one fact across two owners for no benefit.

Findings: 3 — queued 1 (severity: medium), declined 2. 1 + 2 = 3.

## 2026-08-01 — Session S3-19b

**Mandate:** Write the Work Loop v2 executable core — the single short document the Claude command and the Codex resource link to instead of restating rules — containing the seven sections Playbook Step 3 names, synthesized from the Proposal's settled decisions plus the Step 1 and Step 2 notes, with no decision reopened — done when: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` exists and is committed with all seven sections present; the task-state interface section consciously decides where hand-off state lives (the `turn` field Step 2 proved is a protocol field the Proposal's content ceiling does not list) rather than silently dropping it; the core is checked against the skill-writing standard's Section 10 checklist; and the operator has read and approved it.
- Out of scope: Step 4's slice plan; building the Claude command or the Codex resource (Step 5); anything from the Complete System explainer (Consequential lane, worktrees, reviewer machinery, automation) — destination reference only, creates no requirements; editing, retiring or "aligning" Work Loop v1; reopening any settled decision in Proposal Section 3 or changing the Proposal's stated transport; closing the Step 2 § 6 open gaps that need the operator or the Codex app.
- Files in scope: logs/missions/work-loop-v2-mvp.md, plans/work-loop-v2-mvp/README.md
- Stop if: a section cannot be written without reopening a settled Proposal decision or making a Proposal-level call (e.g. formalising that Codex cannot write `.git`, or changing the transport from Git to the shared working tree) — surface it to the operator rather than deciding it; or the Complete System explainer is the only source for something the core would contain.
- Allowed inputs: plans/work-loop-v2-mvp/README.md, plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md, plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md, plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md, plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md, plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md, docs/work-loop.md, docs/work-loop-spec.md, .claude/commands/work-loop.md, .agents/skills/work-loop/SKILL.md (v1 read-only, form conventions only), logs/missions/work-loop-v2-mvp.md
- Required outputs: plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
- Mission: work-loop-v2-mvp

**Work:** Work Loop v2 MVP Step 3 — write the executable core; operator reads and approves it
