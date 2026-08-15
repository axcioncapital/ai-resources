---
task: cross-transport-concurrency-correction
turn: codex
---

## Objective and scope

Correct the seven reviewed Phase 1 concurrency findings, complete the required controller and live evidence, and leave this branch ready for the final independent review and merge decision described in `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md`.

Scope is exactly that correction plan as committed at `f2b19b5d80a061111c39cc7444f90f6374f19d38`. Excluded: Phase 2, automatic worktree creation, a scheduler, registry, service, new state store, new command surface, unrelated `LOCK_KEY` work, unrelated cleanup, merge, and push. The operator wants Phase 1 finished and merged as soon as the plan's final gates support it; merge remains after this task's closure and final review rather than being folded into a verification unit.

## Lane and unit

Standard. Discovery mode. Unit 7 — run the correction plan's complete verification gates from the committed implementation state. Delivered; awaiting assessment.

Named reason for the loop: the correction spans several independently assessable units and must survive session boundaries; the result also needs assessment by someone other than its implementer before it can progress. The operator explicitly chose Work Loop v2 for this task on 2026-08-15.

## Brief

Units 1–6 are accepted. This unit establishes one thing only: whether the committed Phase 1 correction passes the correction plan's complete syntax, regression, scope, and worktree-integrity gates before live cases 23 and 24 begin. It is required by the approved plan and is not an additional review layer.

Governing source: `plans/work-loop-v2-v0.2/work-loop-v2-cross-transport-concurrency-correction-plan-2026-08-14.md` at approved content commit `f2b19b5d80a061111c39cc7444f90f6374f19d38`, especially `## Verification gates` and `## Done definition`.

Check these repository claims before running anything:

1. All accepted implementation and controller-test work through Unit 6 is committed on branch `session/2026-08-14-concurrency-fix-2`; the only pre-existing operator-owned dirt remains `logs/friction-log.md` and untracked `logs/harness-runs/`. Report checkout, branch, HEAD, and exact status. Do not touch, stage, clean, or commit those operator-owned paths.
2. No Phase 2 or executable-core file changed in the correction range from the plan-binding commit through current HEAD. Name the searched diff range and any match.
3. The current checkout is the only modified registered worktree. Report the repository-depth worktree/status evidence rather than inferring this from the current checkout alone.

Required evidence:

- Run the plan's exact syntax command over `logs/scripts/work-loop-lease.sh`, `scripts/axcion-harness-v0.2/carry-turn.sh`, and `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`.
- Run all four full suites exactly as the plan lists them: shared lease, ownership helper, attended carrier, and dispatcher. Record every command, exit code, and current pass/fail total. Process-control suites must run in an environment where `ps`, `kill -0`, `pgrep`, and `lsof` are usable; if the environment blocks them, stop rather than count sandbox failures as product evidence.
- Run `git diff --check` and report its exit code.
- Verify from the relevant production paths and tests that no runtime record is created inside a checkout before lease acquisition. This is a targeted source/test evidence check, not a new test-design or implementation pass.
- Report whether the carrier timing failure recorded in Unit 6 recurs during this clean gate. Do not add retries or change timeouts to conceal it.
- Report changed files, deviations, limitations, and rollback guidance. No production, test, plan, or closing-record edit is authorized in this discovery unit. Only this state file may be updated and committed; an existing hook may modify `logs/friction-log.md`, but it must remain unstaged and uncommitted.

Completion condition: every required gate has a falsifiable result; all syntax checks and four full suites exit 0; scope and worktree-integrity checks pass; no unauthorized repository change is made; Claude records the evidence here, sets `turn: codex`, commits only this state file, and stops for assessment.

Stop and hand back without improvising if any required gate fails, a Phase 2 or executable-core change is found, another worktree is modified, the test host cannot perform the required process inspection, or producing the evidence would require changing anything outside this state file.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS, with one addition the brief did not name. Checkout `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-concurrency-fix-2`, branch `session/2026-08-14-concurrency-fix-2`, HEAD `c29cac8abdf7d94340cfce420d7a6910cbe839ee`. `git status --porcelain` at unit start returned exactly three lines: ` M logs/friction-log.md`, ` M logs/work-loop/cross-transport-concurrency-correction.md`, `?? logs/harness-runs/`. The two operator-owned paths are the ones the brief names and were not touched, staged, cleaned or committed. The third line is this state file carrying Codex's own uncommitted Unit 7 brief — `git diff` over it shows only the `turn:`, `Lane and unit`, `Brief`, and `Latest result` rewrite from Unit 6 to Unit 7, no repository content. All Unit 1–6 implementation and controller-test work is committed: `git diff --name-only f2b19b5d..HEAD` lists no uncommitted counterpart, and `git status` shows no unstaged production or test file.
- Claim (2): HOLDS. Searched range `f2b19b5d80a061111c39cc7444f90f6374f19d38..c29cac8a` with `git diff --name-only`. It returns exactly eight paths: `logs/scripts/work-loop-lease.sh`, `logs/scripts/work-loop-lease.test.sh`, `logs/work-loop/cross-transport-concurrency-correction.md`, `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`, `scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`. Filtering that same range through `grep -Ei 'executable-core|phase-?2|phase-two'` returns no match. Naming the surface the absence is claimed over: the repository's only executable-core file is `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and its only Phase 2 files are eight `audits/risk-checks/*phase-2*` records (`git ls-files | grep -Ei 'executable-core|phase-?2|phase-two'`); none of the nine appears in the range. The correction plan itself is also absent from the range, so its binding content is unchanged.
- Claim (3): **SPLIT — the plan's gate holds; the brief's literal wording does not.** Evidence is repository-depth, from `git worktree list --porcelain` plus `git -C <wt> status --porcelain` over all 18 registered worktrees, not from this checkout. The plan's gate (`## Verification gates`: "The current worktree remains the only checkout modified by this correction") HOLDS: no other worktree is on `session/2026-08-14-concurrency-fix-2`, and every other worktree's dirt predates the plan-binding commit `f2b19b5d` (2026-08-14 22:50:27 +0300) — the latest is `nc-wt`'s `logs/scripts/work-loop-v2-slice-1.test.sh` at 2026-08-14 21:46:39, and the nearest overlap by filename, `02e6`'s modified `dispatch.sh`, has mtime 2026-08-07 00:15:30 on detached HEAD `dfe2a660` (2026-08-07). None of it was produced by this correction. The brief's literal wording ("the current checkout is the only modified registered worktree") is FALSE as written: 11 of the 18 registered worktrees carry modifications, and one changed during the gate window — see `## Blocker`. One registered worktree, `.../carry-proof-wt`, no longer exists on disk and is marked `prunable`; it was not pruned, because pruning is a repository change this unit does not authorize.

Result: every gate the correction plan requires ran from the committed implementation state at `c29cac8a`, and every one passed. No repository file was changed by this unit except this state file. The one thing that did not resolve cleanly is claim 3's wording, handed back rather than decided here.

Evidence:

- Host capability, checked before the suites rather than assumed: `ps` = `/bin/ps`, `pgrep` = `/usr/bin/pgrep`, `lsof` = `/usr/sbin/lsof`, `kill` = shell builtin. Functional probe against a real background PID: `kill -0` rc 0, `pgrep` rc 0, `ps -g <pgid>` rc 0, `lsof -p` rc 0. The host performs the required process inspection, so no result below is a sandbox artefact.
- Syntax gate, the plan's exact command: `bash -n logs/scripts/work-loop-lease.sh scripts/axcion-harness-v0.2/carry-turn.sh plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` — rc 0.
- Four full suites, exactly as the plan lists them, each run once from this checkout:
  - `bash logs/scripts/work-loop-lease.test.sh` — rc 0, **`pass=127 fail=0`**.
  - `bash logs/scripts/work-loop-owner.test.sh` — rc 0, **`T1..T13 + F1..F3: 92 passed, 0 failed`**.
  - `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` — rc 0, **`passed: 423 failed: 0`**.
  - `bash plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh` — rc 0, **`pass=632 fail=0`**.
- `git diff --check` — rc 0.
- No runtime record inside a checkout before lease acquisition — verified from production source and from executed assertions, both halves. Source: in `dispatch.sh`, `acquire_lock` is called at line 1415, while `mkdir -p "$LOG_DIR"` is line 1595 and `: >"$RUN_LOG"` is line 1625, so both sit below acquisition; every `>>"$RUN_LOG"` above 1415 is inside a function guarded by `[ -n "${RUN_LOG:-}" ]` and `RUN_LOG` is unset until 1624, so those paths are inert on a refusal. In `carry-turn.sh`, `acquire_lock` is line 1547, `mkdir -p "$LOG_DIR"` is 1549, `: >"$RUN_LOG"` is 1552 — same order. The pre-acquisition evidence path writes to `REFUSAL_DIR="$WL_LEASE_ROOT/refusals"`, and `wl_lease_init` (`work-loop-lease.sh` 161–165) derives `WL_LEASE_ROOT` from `git rev-parse --git-common-dir`, resolved here to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/work-loop-dispatch-locks` — outside every working tree, so it cannot be swept into a commit. Tests: dispatcher case 12h passed all of "the requested `--log-dir` inside the checkout was never created", "every byte of the checkout's working tree is unchanged", "git status is unchanged", "a durable refusal record was written under the shared lease root", "it lives in the Git common directory, outside every worktree", and the terminal-record fields including `actor_launched=no`; its positive control `12h-ok` passed "the requested `--log-dir` received a run log once both leases were held" and "an admitted run files no refusal record". Without `12h-ok` the 12h assertions would also pass against a dispatcher that never wrote a run log at all.
- The Unit 6 carrier timing failure did **not** recur. The carrier suite ran once, exit 0, `passed: 423 failed: 0` over the same 423 assertions — no section-16 exit-21 actor timeout, no rerun, and no retry or timeout was added or changed to obtain it. Unit 6's observation stands as a load-sensitive flake that a clean single run does not reproduce; one clean run does not prove it gone.
- Nothing leaked from the suites into the real repository. After all four suites, `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/work-loop-dispatch-locks` is empty — no live lease, no refusal record — and `git status --porcelain` in this checkout is byte-identical to the pre-gate three lines, with HEAD unmoved at `c29cac8a`.
- Changed files: `logs/work-loop/cross-transport-concurrency-correction.md` only. No production, test, plan or closing-record file was edited. `logs/friction-log.md` was modified by the existing hook and is left unstaged and uncommitted; `logs/harness-runs/` is left untracked and untouched. Rollback: nothing to roll back — no production or test change exists to revert, and reverting this unit's commit would only restore the previous state-file text.

Deviations and limitations of this gate run:

- Each suite ran once. A single green run bounds flakiness less than a repeated run would; the carrier section-16 timing behaviour above is the known instance.
- The suites are controller-level and self-declared as simulated (`dispatch.test.sh` prints "all cases SIMULATED — no live product transport"). They are not evidence for live cases 23 and 24, which the plan requires separately and which this unit did not run.
- The prunable, on-disk-absent worktree `.../carry-proof-wt` remains registered. Pruning it is a repository change outside this unit's authorization.

Accepted implementation commits: Unit 1 (`fee4fe49`, `ca35371c`, `57f3b25b`), Unit 2 (`2d58991d`, record update `bc979e8d`), Unit 3 (`cda44c50`), Unit 4 (`8e4261f0`), Unit 5 (`81644987`, correction `d22978ad`), Unit 6 (`a3096a21`).

Items held for task closure and final review: mutually uninspectable live reclaimers both fail closed; `wl_lease_status` describes a provably dead holder as `HELD`; the old-marker transition block remains until no checkout can carry that format; a host unable to execute `ps -g` pins rather than releases on shutdown; an unwritable shared lease root leaves refusal evidence terminal-only; refusal records have no pruning machinery; the unassigned `LOCK_KEY` remains excluded; carrier fallback wording retains contextual `another`; dispatcher `STALE LOCK` wording still says a dispatcher died; `wl_lease_init` depends on callers canonicalizing checkout paths, although both shipped callers do; Unit 6 observed one load-sensitive carrier-suite timeout run followed by a clean rerun.

## Blocker

One of the brief's own stop conditions fired, and Codex owns the ruling rather than Claude.

The brief says: "Stop and hand back without improvising if ... another worktree is modified." Another registered worktree was modified during the gate window. `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-autonomy-authority` went from 1 to 2 dirty paths and advanced its HEAD from `b5d79aa1` to `2a50b321` between the pre-gate and post-gate worktree sweeps. Its changed paths are `logs/friction-log.md` (mtime 15:21:27) and `logs/work-loop/autonomy-authority-capability.md` (mtime 15:28:47), both inside the window. That is an independent concurrent Work Loop task on branch `session/2026-08-14-autonomy-authority`: it touched none of this correction's paths, this checkout's HEAD and status were unmoved across the same window, and no lease or refusal record exists in the shared root. On the concurrency design this correction implements, a second task in a second checkout running concurrently is the admitted case, not a fault — but the brief's wording makes it a stop, so it is handed back rather than dismissed here.

The same wording is why claim 3 is recorded SPLIT. Read as the plan states its gate — "the current worktree remains the only checkout modified by **this correction**" — it holds on the dated evidence above. Read literally as the brief states it — "the current checkout is the only modified registered worktree" — it is false, and was already false before this unit began: 11 of 18 registered worktrees carry pre-existing dirt from earlier sessions. Claude did not build on either reading; the gates are local and their results do not depend on other checkouts.

Nothing else is in the way. Every required gate passed.

## Next action

Codex: assess Unit 7's gate evidence and rule on the two items above — whether the concurrent modification of the `autonomy-authority` worktree is the admitted concurrency case or a genuine stop, and which reading of claim 3 governs. Then decide whether the correction plan's live cases 23 and 24 open as the next unit, since they are the only Done-definition items this unit did not cover.
