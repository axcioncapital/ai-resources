---
task: experimental-dispatcher-main-integration
status: closed
turn: operator
---

## Outcome

Current `main` was integrated non-destructively into the experimental dispatcher candidate on `session/2026-08-16-dispatcher-last-fixes` at merge commit `7617add7ecbe35b1629719df30891826c45b382b` — a normal two-parent merge (`b1baa91a` + `2bfb82d1`), no rebase and no history rewrite, so both histories and the accepted dispatcher work through Unit 31 are preserved. Three conflicts were resolved: `logs/improvement-log.md` kept both appended entries in the file's verified ascending-date order; `.agents/skills/work-loop-v2/SKILL.md` adopted `main`'s extraction into `references/`, with mechanical proof that the session branch's additions survived; and `logs/scripts/work-loop-v2-slice-1.test.sh` kept the session branch's discovery sweep, because `main`'s hard-coded live-task pointer targets a record that is now closed and would have gone red on contact.

The frozen word-budget regression that integration exposed was corrected at `ae96abf4` under the one bounded correction round: duplicated assessment mechanics in `SKILL.md` were condensed to a pointer at executable core § 3, and the 2026-08-14 packaging-outcomes history was moved beside the rules it describes in `references/unit-framing.md`. `work-loop-v2-slice-1` is green at 410/0 and `SKILL.md` sits at 236 lines / 4,974 words inside the unchanged `<500` / `<5000` limits.

The session branch contains both histories and is ready for the separately authorized update of `main` after this closing commit.

## Decisions that matter

- **Patrik's 2026-08-19 `SHRINK` decision still governs.** This is an explicitly experimental supervised deployment only. No **Ready for supervised semi-agentic use** label, and no durable-terminal-result, unattended, walk-away or reliable semi-autonomous claim is made or implied by this integration.
- **The frozen `logs/friction-log.md` working-tree modification was isolated, not resolved.** Unit 1 established that Git had to overwrite that path for the merge to proceed and that every route around it touched a file the brief excluded; Codex chose the reversible route. The modification remains recoverable and unapplied at stash object `da189ef02b22382e57734120ff85838842ddd5c3`. **Deferred:** applying or dropping it, because it was excluded from integration and is not this task's to decide. The pre-existing `stash@{1}` is untouched.
- **The three conflict resolutions were each made from a governing source or verified repository behaviour**, never by taking one whole side. The `slice-1` resolution in particular was decided on live repository state — the record `main` pins is `status: closed` with no `## Lane and unit`.
- **Updating `main`, pushing and deployment remain outside this task**, as does Gate SA. Neither actor merges or authorizes its own work.
- **Side effect, recorded:** the merge brought `main`'s friction-log freeze guard into this checkout's hooks, so `log-write-activity.sh` now exits early and the frozen log is no longer appended to here.

## Evidence

- Integration commit `7617add7ecbe35b1629719df30891826c45b382b`; correction commit `ae96abf4`; this closing commit.
- `git rev-list --left-right --count main...HEAD` returns `0	97` after integration — zero commits unique to `main`. `git merge-base --is-ancestor main HEAD` and `git merge-base --is-ancestor 6cd071ef… HEAD` both succeed, so `main` and the accepted candidate's closing commit are contained.
- Suite evidence at close: `work-loop-v2-slice-1` 410/0 PASS; `work-loop-state` 100/0; `work-loop-owner` 133/0; `work-loop-capability` 94/0; `work-loop-v2-core-resolver` 5/0; `work-loop-lease` 145/0; `work-loop-session-preflight` 60/0. All 14 changed shell scripts pass `bash -n`.
- Non-loss proof for the `SKILL.md` resolution: of the 46 substantive lines the session branch added over the merge base, 44 are present verbatim in the merged `SKILL.md` plus `references/`; the two reported misses were checked individually and are `main`'s own superset description line and one capitalisation variant.
- Unit 32 containment: the dispatcher was untouched by the merge, `dispatch.sh` / `dispatch.test.sh` / `README.md` are unchanged against the accepted candidate, and all eight generated scripts (`b28.sh`, `early.sh`, `focus.sh`, `green.sh`, `green8.sh`, `msgbase.sh`, `red8.sh`, `usage.sh`) remain absent.
- Friction-log stash recoverability: `git show da189ef0:logs/friction-log.md | shasum -a 256` returns `59623e32a64d9a994a41203c3b8ec9d57fbdadd394a7ceb04535e6b46b43ccb2`, byte-identical to the pre-stash working file.

## Accepted limitations

- **All experimental limitations from the closed source task `work-loop-v2-dispatcher-supervised-semi-agentic-use` are retained unchanged** — the fixed three-hop ceiling, the correction corridor, nested-AI control, and the rest recorded there. That record remains authoritative and was not reopened or edited.
- **Pre-existing test failures, unchanged by this integration and not repaired:** `work-loop-v2-tracer-6` at 73/1 and `work-loop-v2-tracer-7` at 163/2. Both were compared against the pre-merge baseline by failure name rather than by count, and both diffs are empty.
- **The dispatcher suite stands at 1843/3, and the merge is not the cause.** Its three failures are `the --settings argument points at the written profile`, `50k — a clean 22 still exits 22, advertises its one complete NO_TRANSITION result, and releases both leases`, and `50k — a clean 18 still exits 18, advertises its one complete FOREIGN_UNSTAGED result, and releases both leases`. Merge-neutrality was proved by dependency rather than assumed: `dispatch.sh` and `dispatch.test.sh` read exactly four checkout paths — `work-loop-lease.sh`, `work-loop-state.sh`, `work-loop-owner.sh`, `prime-session-entry.sh` — and all four, plus the two spike files themselves, are byte-identical either side of the merge. They were not repaired because Patrik chose the experimental `SHRINK` scope and they were proven not to be integration regressions.
- **The friction-log modification is preserved but undecided** — stash object `da189ef02b22382e57734120ff85838842ddd5c3`, unapplied. It survives outside the branch, so a stash prune would lose it.
