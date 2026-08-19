---
task: experimental-dispatcher-main-integration
status: active
turn: codex
---

## Objective and scope

Produce one merge-ready experimental dispatcher candidate by integrating current `main` into `session/2026-08-16-dispatcher-last-fixes`, while preserving both histories and the accepted dispatcher work through Unit 31.

Scope: reconcile the two branches in this bound checkout, resolve only real integration conflicts, run proportionate local proof, and commit the integrated candidate. Excluded: updating `main`, push, deployment, Gate SA, the abandoned Unit 32 implementation, full reliability claims, destructive cleanup, and the unrelated modified `logs/friction-log.md`.

Task exit condition: the session branch contains current `main` and the accepted experimental candidate in one committed, locally verified integration result ready for the separately authorized update of `main`, or a concrete blocker is handed back.

## Lane and unit

Standard. Implementation mode. Unit 1 — integrate current main into the experimental candidate

Named reason for the loop: `main` and the candidate have materially divergent histories, integration may require conflict judgment, and the result needs independent assessment before the protected branch is updated.

## Brief

Patrik chose an explicitly experimental supervised deployment, and the former Gate SA task closed at `6cd071ef0f2e182dc7112ab9b7d6056b53aacffd`. The immediate objective is only to make that accepted candidate merge-ready against current `main`; no unfinished reliability work is revived. The repository currently reports 46 commits unique to `main` and 93 unique to the session branch.

Dominant deliverable: one committed session-branch integration result containing current `main` and the accepted experimental candidate.
Evidence required in this hop: exact pre/post branch identities and divergence; every conflict and its disposition; changed paths attributable to integration; proportionate dispatcher and Work Loop checks capable of failing; proof that abandoned Unit 32 edits and temporary scripts did not re-enter; proof that the unrelated friction log remains uncommitted and unchanged by this unit.
Evidence explicitly deferred: updating `main`; push; deployment; Gate SA; live trials; independent `ADOPT`; the fixed three-hop ceiling, correction corridor, nested-AI control and other accepted experimental limitations.
Primary edit begins after: verify the live branch heads, quote the pre-integration divergence, confirm no merge is already in progress, and preserve the pre-existing `logs/friction-log.md` modification without staging or editing it.

Governing decisions and boundaries:

- Patrik's 2026-08-19 `SHRINK` decision authorizes only an explicitly experimental supervised deployment. Do not add either **Ready for supervised semi-agentic use** label or a durable-terminal-result guarantee.
- The closed source task at `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md` is authoritative for accepted work and limitations. Do not reopen or edit it.
- Codex repaired a post-closure repository-state fault before this brief: uncommitted Unit 32 edits were restored to HEAD and eight generated scripts were moved outside the repository. Verify that `dispatch.sh`, `dispatch.test.sh` and `README.md` are clean at entry and that none of `b28.sh`, `early.sh`, `focus.sh`, `green.sh`, `green8.sh`, `msgbase.sh`, `red8.sh` or `usage.sh` exists under the spike directory. If that premise is false, stop rather than choosing which partial work to keep.
- Preserve all current-main work. Resolve conflicts from the governing sources and current repository behavior, not by choosing one whole side indiscriminately.
- Do not update `main`, push, deploy, delete branches/worktrees, or touch unrelated dirty files in this unit.

Required outcome:

- Merge current `main` into `session/2026-08-16-dispatcher-last-fixes` using a normal non-destructive integration commit; do not rebase or rewrite either history.
- Resolve any conflicts minimally and explain each resolution against the relevant governing source or verified repository behavior.
- Preserve the accepted Unit 28, Unit 30 and Unit 31 dispatcher behavior and the closed experimental limitations. Do not smuggle the abandoned Unit 32 implementation into the result.
- Run the existing local checks proportionate to every overlapping or conflicted surface, plus syntax and focused dispatcher proof sufficient to catch integration breakage. Do not claim the deferred Gate SA regression gate.
- Commit the integration and this handback, then set `turn: codex`.

Capability subset: read, repository inspection, local tests, conflict edits, a normal merge of current `main` into the current session branch, and local commits by Claude. No rebase, history rewrite, update of `main`, push, deployment, credentials, destructive cleanup, or changes outside integration-conflicted/task-state paths. The unrelated `logs/friction-log.md` modification is excluded and must remain unstaged.

Completion condition: one committed integration candidate contains current `main`, retains the accepted experimental dispatcher behavior and limitations, passes proportionate fail-capable local checks, and hands back exact evidence with `turn: codex`.

Stop and hand back on a false premise, an unrelated dirty path that prevents safe integration, a conflict requiring operator-owned product or risk judgment, inability to preserve both accepted histories, required destructive/history-rewriting action, or inability to produce proportionate fail-capable proof.

## Latest result

Inspected (2026-08-19):
- Claim (1) — branch heads and divergence: HOLDS — `git rev-parse HEAD main` in this checkout returns `6cd071ef0f2e182dc7112ab9b7d6056b53aacffd` (session/2026-08-16-dispatcher-last-fixes) and `2bfb82d1cab6f256d6fa24f42b1f4f9070650e81` (main); `git rev-list --left-right --count main...HEAD` returns `46	93`, matching the brief exactly. Merge base is `698383207208dbfccf04672a8263bbc55d001abf`.
- Claim (2) — HEAD is the closing commit of the source task: HOLDS — HEAD is `6cd071ef…`, the commit the brief names.
- Claim (3) — no merge/rebase in progress: HOLDS — searched the resolved git dir `…/ai-resources/.git/worktrees/ai-resources-dispatcher-last-fixes` for `MERGE_HEAD`, `CHERRY_PICK_HEAD`, `REVERT_HEAD`, `rebase-merge`, `rebase-apply`; none present. (This is a linked worktree, so `.git` is a file — a check against `.git/MERGE_HEAD` would have mis-reported.)
- Claim (4) — the three tracked dispatcher files are clean at entry: HOLDS — `git status --porcelain -- plans/work-loop-v2-v0.2/handoff-automation-spike/{dispatch.sh,dispatch.test.sh,README.md}` returned no lines.
- Claim (5) — the eight generated scripts are absent from the spike directory: HOLDS — tested each of `b28.sh`, `early.sh`, `focus.sh`, `green.sh`, `green8.sh`, `msgbase.sh`, `red8.sh`, `usage.sh` under `plans/work-loop-v2-v0.2/handoff-automation-spike/`; none exists. The directory holds only `README.md`, `dispatch.sh`, `dispatch.test.sh`, `parallel-isolation-check.sh`, `parallel-landing-qc.sh`, `parallel-sampler.sh`, `ps-sampler.sh`, `runs/`.
- Claim (6) — the closed source task file is present and untouched: HOLDS — `logs/work-loop/work-loop-v2-dispatcher-supervised-semi-agentic-use.md` exists and is not reported by `git status --porcelain`.
- Claim (7) — `logs/friction-log.md` carries a pre-existing unrelated uncommitted modification: HOLDS — `git status --porcelain` reports exactly ` M logs/friction-log.md` plus the untracked state file; `sha256 = c056dbb38da193efe507f5b8794f0f9ba9ef4ed5e37c66ae57aadc56e34ca8f7`. See the blocker below: this claim holding is what stops the unit.
- Packaging lines: HOLD — `Dominant deliverable:` names one deliverable; `Evidence required in this hop:`, `Evidence explicitly deferred:` and (Implementation mode) `Primary edit begins after:` are all present and non-empty.

Result: the merge was NOT performed. Every brief claim holds, but the brief's named stop condition fired at the last precondition of `Primary edit begins after:` — the excluded dirty path prevents the integration, and every route around it requires touching a file the brief excludes. Details in `## Blocker`. No primary edit was started; `git diff` against every file the brief named is empty and the only repository change in this hop is this state file.

Evidence (the failing case, produced before any edit): `git merge --no-commit --no-ff main` refuses and aborts atomically —

```
error: Your local changes to the following files would be overwritten by merge:
	logs/friction-log.md
Please commit your changes or stash them before you merge.
Aborting
Merge with strategy ort failed.
```

After that probe, `git status --porcelain` is unchanged (` M logs/friction-log.md` + the untracked state file) and no `MERGE_HEAD` exists — the refusal left no partial merge state. The check can fail: it would have succeeded and started a merge had the path been clean.

Prepared for the next hop, so the decision below is the only work it needs to do first:

- Conflict inventory from `git merge-tree --write-tree --name-only HEAD main` (read-only preview, wrote nothing): three conflicted files — `.agents/skills/work-loop-v2/SKILL.md`, `logs/improvement-log.md`, `logs/scripts/work-loop-v2-slice-1.test.sh`. `.claude/commands/work-loop-v2.md`, `logs/next-up.md`, `logs/session-notes.md` and `workflows/research-workflow/logs/scripts/work-loop-owner.sh` overlap but auto-merge clean. Main touches 45 paths, none of them `dispatch.sh` or `dispatch.test.sh`, but it does modify `logs/scripts/work-loop-capability.sh` and the `slice-1`, `core-resolver` and `tracer-7` test files, so dispatcher and Work Loop proof after the merge is still warranted.
- Pre-merge test baseline, captured so post-merge failures can be attributed (this baseline is already red, and knowing that is load-bearing): `work-loop-v2-slice-1` 362/0 PASS; `work-loop-state` PASS; `work-loop-owner` PASS; `work-loop-capability` 77/0 PASS; `work-loop-v2-core-resolver` 4/0 PASS; `work-loop-lease` 145/0 PASS; `work-loop-session-preflight` 60/0 PASS; **`work-loop-v2-tracer-6` 73/1 FAIL** at S3 "control: but it IS retried once, so the retry rule is real"; **`work-loop-v2-tracer-7` 116/2 FAIL** at S5 "attended/unattended collision contends through the same task and checkout leases" and S8 "a live compaction/Reorient recovery cannot be overridden by a misleading summary". Both failures are pre-existing on the session branch before any integration.

## Blocker

**The excluded dirty path blocks the merge, and no route around it stays inside the brief.** This is the brief's own stop condition — "an unrelated dirty path that prevents safe integration" — reached at the last precondition of `Primary edit begins after:`. It is not a false premise: claim (7) holds exactly as the brief states it.

What was found:

- `logs/friction-log.md` at HEAD is byte-identical to the merge base (`5a2991c8c1caa8687cf37648d0a6563c8fafd018` for both), and `main` changed it (`8b8517a9…`). So the merge must update that path in the working tree — and the working tree copy is dirty, which is why git refuses.
- The uncommitted change is a 623-line insertion under `#### Write Activity`, generated by this checkout's `log-write-activity.sh` hook during the previous session. `main` inserts 14 lines at that same anchor plus the two-line `FROZEN — 2026-08-17` banner at the top of the file. Both sides insert at the same point, so a `git stash push -- logs/friction-log.md` followed by `git stash pop` will conflict on that hunk after the merge.
- Context that bears on the disposition: the workspace `CLAUDE.md` freezes this log workspace-wide and the hooks on `main` carry the freeze guard. This checkout's hooks predate that guard, which is why the append exists at all. Merging `main` is what brings the guard and the banner into this checkout.

Every available route touches the excluded file, and the brief forbids exactly that ("do not ... touch unrelated dirty files in this unit"; the capability subset allows "no changes outside integration-conflicted/task-state paths" and requires the modification to "remain unstaged"). The three routes, so the decision is a single choice and not an investigation:

1. **Stash and leave stashed.** `git stash push -- logs/friction-log.md`, merge, and leave the change in the stash with its ref reported. Nothing is lost and nothing conflicts, but the working tree no longer carries the modification.
2. **Stash, merge, reconstruct.** As above, then re-apply the same 623 added lines onto the merged file at the same anchor, verifying the resulting unstaged diff carries exactly those lines and nothing else. Preserves the modification on the new base and keeps it unstaged, but writes to the excluded file.
3. **Discard it.** Stash it as a recovery point and do not restore it — the content is hook-generated write-activity noise appended in violation of a standing operator freeze, and `main` fixes the hook that produced it.

**Recommended: route 1** — it is the only one that neither writes to the excluded file nor discards anything, it needs no conflict resolution, and the stash ref is a durable recovery point that leaves the disposition open for the operator. Route 3 is a discard against a file under an operator freeze and should be the operator's call, not Codex's or mine.

Deferred, recorded and not done (noticed during this hop, outside `## Objective and scope`): this checkout's `log-write-activity.sh` and `friction-log-auto.sh` lack the freeze guard that `main` carries, which is why the log was appended to under a standing freeze. Merging `main` fixes it as a side effect; no separate work is proposed here.

## Next action

Codex: choose the disposition of the excluded `logs/friction-log.md` modification — route 1, 2 or 3 above, or escalate the discard to Patrik — and authorize the one action on that path that the next hop may take. Everything else is ready: the conflict inventory is three files, the pre-merge test baseline is recorded above with its two pre-existing failures, and the merge runs the moment that path is clear.
