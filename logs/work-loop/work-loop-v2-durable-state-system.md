---
task: work-loop-v2-durable-state-system
turn: codex
---

## Objective and scope

Implement the frozen Work Loop v2 durable-state plan sequentially until the accepted state system is demonstrated end to end and ready for the operator's landing decision.

Scope is the capabilities, migration order, eight tracer bullets, assessment gates, and completion proof in `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`. The plan's explicit exclusions remain excluded; repository evidence may challenge a factual premise or expose a safety contradiction, but may not silently redesign the accepted architecture.

## Lane and unit

Standard. Implementation mode. Unit 3 — retire the three operator-authorized old-semantics tasks and establish the frozen pre-Tracer-2 baseline.

Named reason for the loop: this is a high-risk, multi-unit lifecycle-state migration whose scope must remain bounded and whose implementation requires independent assessment before it can progress.

## Brief

Tracer bullet 1 is accepted, shared-lease Phase 1 and autonomy authority are integrated at the 2026-08-15 baseline, and the operator has now resolved the final intent gate before record migration. This unit performs only the prerequisite retirement and baseline transition required by Safe ordering step 2; Tracer bullet 2 remains a later unit.

**Required outcome:** Convert exactly these three unowned old-semantics task records to honest old-contract closing records, preserving rather than erasing what each task did and did not complete:

- `logs/work-loop/work-loop-v2-intake-router.md`
- `logs/work-loop/axcion-harness-v0-2-attended-release.md`
- `logs/work-loop/work-loop-v2-concurrent-task-isolation.md`

Also record in this task's result that the operator paused all new Work Loop admissions in this repository from 2026-08-15 through operational proof and the final landing decision. The pause is an operator operating instruction recorded in this existing state file, not authorization to add a pause marker, a second state artifact, or new runtime machinery.

**Governing authority and dispositions:**

- Current operator decision, 2026-08-15: “Approved: pause admissions and retire the three tasks as recommended.” It supersedes only the three records' open `Next action` dispositions and establishes the admission pause; it does not declare their unfinished outcomes achieved.
- Frozen plan `plans/work-loop-v2-v0.2/work-loop-v2-durable-state-system-implementation-plan-v0.1.md`, especially Pre-implementation gates and Safe ordering step 2, requires the pause, closure of every other old-semantics task, integration of their closing records, and a rebaseline before Tracer 2.
- Canonical executable core `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs the old-runtime closing shape: `turn: operator` plus exactly `## Outcome`, `## Decisions that matter`, `## Evidence`, and `## Accepted limitations`.
- The three target records are authoritative source material for their own last accepted results and unresolved conditions. Preserve those facts in compressed closing records; do not resume their workflows, rerun their evidence, or imply successful completion where the record says otherwise.
- Accepted Phase 1 and autonomy closing records are governing repository evidence for their own completed dependencies. Do not reopen or edit them.

**Check against the repository before editing:**

1. Verify this is task `work-loop-v2-durable-state-system` in this checkout, its local `.owner` names this task under the old `{task-id} {date}` contract, and repository-depth ownership still finds no other declared task. Establish this from the owner helper/worktree evidence rather than the brief's claim.
2. Verify shared-lease status shows no actor in flight for any of the three target task IDs and no registered checkout contains an owner for one. A live owner, lease, or ambiguous replica is a stop, not permission to retire it.
3. Verify the three target files are still the only non-fixture, non-current Work Loop records on HEAD without a valid four-heading closing shape. Search `logs/work-loop/*.md`, explicitly excluding intentional `fixture-*` and non-state target fixtures, and report the classification rule used.
4. Verify closing/integration commits `7f7e134e`, `9cf6b56b`, `15c93285`, and `814ca984` are ancestors of the implementation baseline and report the exact HEAD being rebaselined. Do not rerun those tasks' accepted suites.
5. Read each target record's last accepted result, blocker, and next action before reducing it. If a target cannot be retired without guessing what remained incomplete, stop and hand back instead of inventing closure content.

**Implementation boundary:** Reduce only the three named target records to the canonical old-contract closing shape. Each outcome must say it was retired by the operator to permit the durable-state migration; each decisions section must distinguish accepted work from the superseded open next action; each evidence section must cite the durable commit or evidence already present in that record; and each accepted-limitations section must retain its unresolved completion condition. Update only this current task record for the handback. Do not add `status`, migrate any other record, rewrite `.owner`, alter the validator or a consumer, edit the frozen plan or core, create a pause artifact, clean unrelated files, merge, push, or begin Tracer 2.

**Codex framing decision:** Retirement, admission-pause recording, and the pre-Tracer-2 rebaseline are one dominant prerequisite deliverable because none has independent value outside Safe ordering step 2, and Tracer 2 is prohibited until all three are true. Record migration is deliberately held outside this unit because it is the next tracer's observable behaviour and evidence set.

**Capability subset:** Baseline only — read/search/history inspection, repository-depth ownership and lease status, edits to the four exact state files named above, focused structural checks, and one local commit by Claude. Nothing is selected from the pre-authorizable set, which is empty today. No operator-reserved capability is needed beyond the operator decisions already recorded; no merge, push, deployment, network, credential, destructive action, or policy expansion is authorized. This is an operator-carried interactive turn, so no courier runtime profile is claimed.

**Required evidence:**

- A failing-first inventory showing the three target records as the remaining non-closed records before the edit, followed by the same bounded inventory showing only the current implementation task remains active afterward.
- For each retired record: exact frontmatter and heading classification, the preserved accepted result/evidence pointer, and the unresolved condition carried into `## Accepted limitations`.
- Repository-depth owner and shared-lease evidence capable of exposing a live or ambiguous task, not only a claim that none exists.
- Ancestry evidence for the four integrated dependency commits and the exact implementation baseline.
- A scoped diff/status proving only the current state file and three target records changed, followed by an explicit-pathspec commit containing exactly those four files. State-only structural checks are proportionate here; do not invent a runtime test for records whose workflows are intentionally not resumed.

**Completion condition:** Commit exactly the four allowed state files, replace `## Latest result` here with the retirement, admission-pause, inventory, ownership/lease, ancestry, structural and commit evidence, set `turn: codex`, and hand back for assessment. The result must state explicitly that Tracer 2 has not started.

**Stop conditions:** Stop without retirement if any target is owned, leased, duplicated ambiguously, newer in another checkout, or cannot be summarized without guessing; if another real old-semantics task remains open; if the operator decision conflicts with a later durable authority; if a valid closing record would require claiming an unmet outcome passed; or if any edit outside the four allowed files is required. Challenge a false premise or stale direction explicitly rather than improvising.

## Latest result

Unit 3 did not begin: premise (3) is false. No target record was reduced and no baseline was frozen. Tracer bullet 2 has not started.

Inspected (2026-08-15) at HEAD `87f9fd07` — `Merge branch 'session/2026-08-14-autonomy-authority' into session/2026-08-14-durable-state`. Working tree carried one modification, this state file (Codex's uncommitted brief); every other check below read HEAD via `git show`, not the working tree.

- Claim (1): HOLDS — read `logs/work-loop/.owner` in this checkout: `work-loop-v2-durable-state-system 2026-08-14`, matching the old `{task-id} {date}` contract. Ran `work-loop-owner.sh check --depth repo` → `verdict: PROCEED` ("this checkout already declares task 'work-loop-v2-durable-state-system'"). Independently enumerated `logs/work-loop/.owner` across all 18 registered worktrees from `git worktree list --porcelain`: exactly one exists — this checkout's — and no other checkout declares any task.
- Claim (2): HOLDS — sourced `logs/scripts/work-loop-lease.sh` and ran `wl_lease_init` + `wl_lease_status` read-only for each of the three target task IDs against lease root `.../ai-resources/.git/work-loop-dispatch-locks`. All three report `task-lease: FREE`, and `checkout-lease: FREE` for this checkout. Listed the lease root: it contains only `refusals/` — no `task-*.lock` or `checkout-*.lock` directory exists on disk for any task. Combined with claim (1)'s enumeration, no registered checkout holds an owner for any target.
- Claim (3): **FALSE** — searched every `logs/work-loop/*.md` on HEAD via `git ls-tree -r --name-only HEAD`, classifying each by frontmatter `turn:` and by its exact `^## ` heading sequence. Classification rule used: a record is closed only if its heading sequence is exactly `## Outcome`, `## Decisions that matter`, `## Evidence`, `## Accepted limitations` — core § 4's "exactly these four sections, under these exact headings". Excluded `fixture-*` (all 26, including the three non-state `fixture-target*` files) and the current task's own record. Under that rule **five** non-fixture, non-current records lack a valid closing shape, not three. The three named targets, plus two the brief does not name:
  - `logs/work-loop/context-engineering-implementation-plan.md` — `turn: operator`; headings `## Outcome | ## Decisions that matter | ## Evidence pointer | ## Accepted limitations | ## Next action`. Two deviations: `Evidence pointer` is not `Evidence`, and a fifth section survives.
  - `logs/work-loop/foreign-staging-target-repo.md` — `turn: operator`; headings `## Outcome | ## Decisions that matter | ## Final commit and evidence | ## Accepted limitations`. Four headings, but `Final commit and evidence` is not `Evidence`.

  Both read as substantively closed — each opens "Closed 2026-08-01"/"Closed 2026-08-02 by operator approval" and is retrospective throughout — so neither is an open old-semantics task and the brief's "another real old-semantics task remains open" stop condition does not fire. What is falsified is the completeness of the target set against the shape rule, not the openness of those two.
- Claim (4): HOLDS — `git merge-base --is-ancestor <c> HEAD` returned true for all four: `7f7e134e` (closing cross-transport-concurrency-correction), `9cf6b56b` (Unit 11 close), `15c93285` (close autonomy-authority-capability), `814ca984` (2026-08-15 wrap). The baseline that would have been frozen is HEAD `87f9fd07`. No dependency suite was rerun.
- Claim (5): HOLDS — read each target's `## Latest result`, `## Blocker` and `## Next action` on HEAD. Each states its unresolved condition explicitly, so none would require guessing: `work-loop-v2-intake-router` (`turn: codex`, the only genuinely mid-handoff target) carries an accepted correction at 275 passed / 2 failed with a recorded, unimplemented deferral — a sweep for assertions that can pass for an unrelated reason; `axcion-harness-v0-2-attended-release` carries a live blocker, the canonical live carry stopped at exit 18 on unrelated dirty paths, awaiting an operator choice of clean checkout; `work-loop-v2-concurrent-task-isolation` carries a blocker that representative ordinary use has not yet happened, so its SOP does not permit "Resolved".

Operator decision recorded 2026-08-15, still in force and carried forward: pause all new Work Loop admissions in this repository through operational proof and the final landing decision, and retire `work-loop-v2-intake-router`, `axcion-harness-v0-2-attended-release`, and `work-loop-v2-concurrent-task-isolation`, preserving unfinished outcomes as explicit deferrals or limitations. It does not authorize Tracer 2, landing, or merge to `main`.

## Blocker

Premise (3) is false. The brief asserts the three named targets are the only non-fixture, non-current records on HEAD without a valid four-heading closing shape; under core § 4's exact-heading rule the set is five. `context-engineering-implementation-plan.md` and `foreign-staging-target-repo.md` are closed in substance but carry non-canonical closing headings (`Evidence pointer` plus a surviving `## Next action`; and `Final commit and evidence`).

This is load-bearing for what the unit exists to produce. Safe ordering step 2 requires the pre-Tracer-2 baseline to hold every other old-semantics task closed with its closing record integrated. Freezing that baseline on a completeness claim that is false would record as established a condition that inspection does not support, and would leave two records whose shape a migration or validator keyed on the four headings could mishandle at exactly the point Tracer 2 starts reading them.

The brief's implementation boundary forbids migrating, editing or dispositioning any record beyond the three targets, so this cannot be repaired inside this unit. The choice is Codex's framing decision, not Claude's: either the strict shape rule governs, in which case the two extra records need a disposition before the baseline is frozen, or a looser substantive rule governs (`turn: operator` plus a retrospective Outcome-led body), in which case claim (3) needs restating so the baseline record is honest about which rule it was checked under. The brief asking Claude to "report the classification rule used" is where the rule was left unpinned.

Nothing outside this state file changed. No target record was reduced, `.owner` was not rewritten, and no baseline was declared.

## Next action

Codex: decide which closing-shape classification rule governs the pre-Tracer-2 baseline, then reframe Unit 3 accordingly.

1. If the strict rule (core § 4's exact four headings) governs — decide the disposition of `context-engineering-implementation-plan.md` and `foreign-staging-target-repo.md`. Both are substantively closed, so this is a shape-conformance question, not a retirement question, and the operator's 2026-08-15 retirement decision names only the three targets and does not reach these two.
2. If a substantive rule governs — restate claim (3) in the reissued brief so the frozen baseline records which rule it was verified under, and confirm the two non-conforming shapes are accepted as-is into Tracer 2's inputs.

Either way, reissue the unit with the classification rule pinned by Codex rather than chosen by Claude. Claims (1), (2), (4) and (5) were verified and need no rework: ownership and leases are clear, the four dependency commits are ancestors of `87f9fd07`, and all three targets can be summarized without guessing. Tracer bullet 2 remains unstarted.
