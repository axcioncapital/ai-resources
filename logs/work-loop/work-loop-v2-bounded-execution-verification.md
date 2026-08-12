---
task: work-loop-v2-bounded-execution-verification
turn: codex
---

## Objective and scope

Determine whether the bounded-execution repair now merged into `main` is technically good enough to
proceed to its separately authorised attended pilot. Verify the current merged result; do not
implement corrections in this unit.

Scope: the bounded-execution behaviour in
`plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its tests and README, and
`.agents/skills/work-loop-v2/SKILL.md`; the repository and recorded review evidence needed to verify
those surfaces; and a safe recovery-path check performed away from the current checkout.

Excluded: a live Claude/Codex actor run; nested AI; the attended pilot; implementation or correction;
`acceptEdits`; incident-2 content repairs; settings, executable-core, command or agent changes; merge,
push, cleanup of unrelated work, and ceremony-branch features except where their merged interaction
could regress the bounded-execution outcomes.

## Lane and unit

Standard. Discovery mode. Unit 1 — independently establish the technical state of the merged
bounded-execution repair and return evidence for Codex's assessment.

Named reason for the loop: this shared dispatcher change affects permissions, concurrent state and
background processes, and its result needs assessment by someone other than its builder before it
counts as technically verified.

## Brief

The implementation is merged, but integration is not the same as technical verification or
operational closure. This unit performs only the proportionate Gate-4 check needed before the
already-defined one-run pilot; it does not reopen design or add another review layer.

Required outcome: establish from the live `main` checkout whether the merged implementation satisfies
O1–O5 at the strength actually claimed, whether the known review findings remain material, whether
the regression evidence can fail, and whether recovery remains usable. Return repository facts and
executed evidence; make no target-file change.

Source dispositions:

- Governing: the Work Loop v2 executable core and Codex skill; the operator's current instruction to
  check the merged result.
- Authoritative current-state leads, to verify against the repository rather than trust:
  `logs/decisions.md` entry "Unauthorized Codex commit taken over rather than trusted or discarded
  wholesale" and `logs/session-notes.md` entry "Took ownership of an unauthorized Codex commit, then
  fixed two more review findings". They identify `6ab33a2`, `570c4fb`, `7ee93d7`, and `8b9a63d` and
  say the last three superseded or corrected earlier work; confirm the actual merged lineage and
  current tree.
- Non-governing verification specification:
  `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.2.md` §§ 3.4, 4, 5 and 6. It explicitly calls
  its constructions proposals rather than an approved design, so use its O1–O5 claims, evidence
  boundaries and closure separation as tests of the implemented result—not as proof that they hold.
- Non-governing methodology: `.agents/skills/work-loop-v2/references/repository-problem-resolution-sop.md`,
  especially Gate 4 and B9. Its unresolved vocabulary/authority caveats do not override the Work
  Loop core. Apply its useful standard: executed, fail-capable, proportionate evidence and a tested
  recovery path for the high-risk shared dispatcher.
- Prior review leads, not present truth: the two audit files named
  `audits/working/code-review-6ab33a2-{spec,standards}.md` and the remaining-finding summary in
  `logs/session-notes.md:506-518`. Check each named finding against current code: contradictory
  `claude_deny=none` wording; untracked-file recovery instruction; fabricated U3 fixture; stale README
  deny-rule sentence; early P1 prohibition; duplicated allowlist logic; and mislabeled case 31b.

Check against the repository:

1. Report the current checkout, branch, HEAD, worktree status, and the merged ancestry or replacement
   relationship of the four commits named above. Separate unrelated dirt from this task and do not
   stage or modify it.
2. Inspect the merged diff and current files. For each outcome, give a supported PASS, FAIL or
   LIMITATION:
   - O1: the supported direct nested-Claude/Codex launch route is denied by default at the child
     permission layer, the requested policy is visible in argv and the run log, no supported switch
     removes the default, and neither code nor docs overclaims containment. Confirm the settled
     unattended profile was not unintentionally widened.
   - O2: every relevant post-launch nonzero stop reports in-allowlist partial file effects, including
     exit 21; state-file attribution distinguishes this-hop changes from pre-existing dirt and does
     not falsely address Codex or Claude.
   - O3: a permission denial becomes a named stop with the exact denied tool, full target and needed
     operator decision, including the supported no-`jq` path; a clean capture does not trigger it.
   - O4: the Work Loop skill carries all five recovery clauses together at the point a stop is read,
     without weakening the no-bypass/no-blind-rerun rules or changing the executable core.
   - O5: the existing brief-writing step—not a new stage, field or artifact—sizes timed units by one
     dominant deliverable and proportionate evidence, states that an allowlist does not bound
     reasoning workload, identifies the plan's oversizing shapes, and does not raise the timeout.
3. Resolve every prior review lead listed above against current code. For each, say fixed, still
   present, superseded, or deliberately retained, with the exact evidence and material consequence.
4. Run the current simulated harness once and quote its final counts and exit status. Establish
   fail-capability for the bounded-execution regression assertions using the plan's pre-change
   baseline or targeted mutants in a disposable temporary surface; report which relevant assertions
   fail before/mutated and pass now. Do not invoke a model and do not manufacture an exhaustive
   matrix. Distinguish controller evidence from containment or real-actor evidence.
5. Demonstrate, without altering this checkout, that the merged bounded-execution changes have a
   usable recovery path. State exactly what was tested, what would be reversed, and any interaction
   with later overlapping changes. A written command without execution is not sufficient evidence.

Completion condition: write the verified facts, per-outcome results, prior-finding dispositions,
executed harness/fail-capability evidence, recovery evidence, limitations and any material technical
findings into `## Latest result`; set `turn: codex`; commit only this state-file handback if target
files need no change. Do not decide closure and do not implement a finding.

Stop and hand back without improvising if the merged implementation cannot be identified, evidence
requires a live or nested model run, a safe recovery check cannot be performed away from this
checkout, a target-file change would be required, or unrelated work prevents a safe exact-file
commit.

## Latest result

The one bounded correction ran against the three frozen findings. Each was reproduced by inspection
first, then corrected. Nothing outside the three was changed.

Reproduced (2026-08-12):

- Finding (1): REPRODUCES — read `.agents/skills/work-loop-v2/SKILL.md:277` and `:289` at `f994900`;
  both name `35` as the permission dead end. Cross-checked the other three bounded-execution
  surfaces and they already carry the merged mapping: `dispatch.sh:231` `37 PERMISSION_DENIED` and
  `:199` `35 OWNERSHIP_UNAVAILABLE`; `README.md:574` `37`/`:572` `35`; `dispatch.test.sh:2957,2993,3023`
  expect `37` for a denial and `:410,:446` expect `35` for an absent or broken ownership helper.
  Searched every live instruction surface outside the spike — `.claude/`, `.agents/`, `docs/` — for an
  exit code tied to a permission stop: the only other hit is
  `docs/parallel-sessions-playbook.md:128`, which already maps `35` to the ownership check.
- Finding (2): DOES NOT REPRODUCE — see the diagnosis below.
- Finding (3): REPRODUCES — searched `dispatch.sh` and `README.md` for a claim that nothing is denied
  without `--claude-deny`; four hits at `f994900`: `dispatch.sh:36` (the `--claude-deny` usage
  header), `dispatch.sh:1382` (the attended run-log line), `README.md:183` and `README.md:973`. All
  four are false on the attended path, where `NESTED_ACTOR_DENY` (`dispatch.sh:340-345`, four rules)
  is always applied — `dispatch.sh:2203` merges it into every attended launch and `--claude-deny` can
  only append to it.

Result:

- Finding (1) — RESOLVED. `SKILL.md:277` now names the permission dead end as `37` and adds the
  ownership stop `33`,`34`,`35`; `SKILL.md:289` now explains `37`, distinguishes `35` as the
  ownership-check-unavailable stop with its different remedy, and states that any record written
  before 2026-08-11 naming `35` for a permission stop is to be read as `37`. No conflicting live
  instruction remains on any of the four surfaces or elsewhere in the repository.
- Finding (2) — DOES NOT REPRODUCE; the 15 failures are environmental, not a merge regression. The
  reviewers' failures were concentrated in the 27-series *controls* — "escapee alive and OUTSIDE the
  actor's group", "the orphan is re-parented to pid 1", "a live root-owned PID is available". Those
  are probes of whether the host permits process-group and ancestry inspection at all, not
  assertions about dispatcher behaviour, and a run whose controls fail cannot reach the behavioural
  assertions behind them. Every one of those controls passes in the normal supported test
  environment. No repair was made, and none is warranted.
- Finding (3) — RESOLVED. All four statements now say that `none` means the operator supplied no
  extra rule, and say explicitly that this does not mean nothing is denied, pointing at the
  always-applied nested-actor set (attended) and the contained profile's base denies
  (`--unattended`). The default deny set was neither widened nor removed, and no containment claim
  was added — `README.md` § *The default nested-actor deny set* still reads "It is not containment".

Evidence:

- Findings (1) and (3), fail-capable greps run against `f994900` and against the corrected tree.
  Finding (1): a search of the live instruction surfaces for `35` tied to a permission stop and not
  to ownership returned `SKILL.md:277` and `:289` before, and returns nothing now. Finding (3): a
  search of `dispatch.sh` and `README.md` for "no tool is denied" / "no tool denied" / "there is **no
  deny rule**" returned four lines before, and now returns only `dispatch.sh:1385`, a comment that
  quotes the retired wording to record why it is not restored. Both checks fail on the pre-fix tree,
  so neither is a check that cannot fail.
- Finding (2), one full integrated harness run on the corrected tree, in the normal supported test
  environment: `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` →
  **exit 0, `pass=454 fail=0`**. Full log:
  `/private/tmp/claude-501/.../scratchpad/harness-run-3.log`. Every case the reviewers reported
  failing passed: `27` (lock released), `27b`, `27c`, `27d`, `27e`, `27f`, `27g`, `27h`, `27i`,
  `27j`, `27L`, `27m`, `27n`. Bounded-execution cases `40`–`47` passed. The suite is demonstrably
  fail-capable: it exited `1` with `fail=15` for the reviewers, and its own controls are written to
  fail loudly when the environment cannot establish the process facts — which is exactly what they
  did there and did not do here.
- The green result is attributable to the merged code, not to this correction. The dispatcher diff
  against `f994900` changes exactly one executable line — the `claude_deny=none` log string — and
  everything else in `dispatch.sh` is comment text. No control-flow, guard, taxonomy or launch
  argument was touched.
- Suite totals differ between the two runs (423 assertions there, 454 here) because failed controls
  short-circuit the assertions behind them. The reviewers' `pass=408 fail=15` is therefore not
  comparable to a green total, and cannot be read as "31 assertions were added".

Limitations carried forward, unchanged by this correction:

- O1 remains proof of *requested* permission policy, not containment or real-actor enforcement.
- O3's fixture remains modelled rather than replayed from preserved raw evidence.
- All 454 cases are simulated. No live model, nested AI or pilot ran.
- The environmental diagnosis for finding (2) rests on this host. It shows the merged suite is green
  where process inspection is permitted; it does not certify any other environment.

Deferral noticed during this correction, recorded and not done:

- No harness assertion pins the honest wording of the attended `claude_deny=none` log line. Case 31b
  greps only the `claude_deny=none` prefix, which the old false wording and the new one both satisfy,
  so a regression to the old sentence would pass. Not added here: the correction boundary excludes
  case 31b and limits the method to static inspection plus one integrated harness run.

## Blocker

None.

## Next action

Codex: run the closure check on the three frozen findings only — are (1), (2) and (3) resolved, and
did the correction break anything? The correction touched three files; the dispatcher's only
executable change is one log string, and the full integrated harness is green at `pass=454 fail=0`.
