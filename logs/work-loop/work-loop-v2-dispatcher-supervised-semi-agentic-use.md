---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Implementation mode. Unit 20 — make the evidence path one trusted operand

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 19 is accepted at `1d100317be842aefe8584319f8f4f745b668841a`. It established that command data is already preserved as argv throughout the production dispatcher and that explicit option termination is present at the two actor-influenced Git/process positions where it materially matters. It also found one real behavior defect: `--log-dir -` can pass the pre-admission evidence check, after which Bash's special `cd -` behavior makes the canonical location disagree with the raw paths used for evidence. That can make an admitted run misdescribe where its durable result lives, so it is required Gate SA work rather than hardening for its own sake.

This unit deliberately folds that defect into the evidence-location slice of the next Change set A canonicalization clause. A standalone punctuation patch followed immediately by a second edit to normalize the same value would be waste. The remaining checkout, state, capture and changed-path canonicalization questions stay outside this unit.

Dominant deliverable: one admitted evidence-directory value that is treated as data, canonicalized once, and used consistently for every run artifact and reported path.
Evidence required in this hop: a targeted before/after case for a leading-dash evidence directory; a pre-admission refusal case for the exact special operand `-` proving no actor, owner/lease or evidence effect; a focused actor-controlled leading-dash changed-path case that fails if the existing Git `--` is removed; and the focused tests only.
Evidence explicitly deferred: a Codex-launch argv recorder, because fixed prompt prefixing, strict task grammar and double-quoted construction already settle that boundary and testing the shell's quoting rule would be ceremony; canonicalization and containment of checkout, state, capture and changed-path values; Git porcelain C-quote decoding; the lease helper's relative `--git-common-dir`; the experimental `--unattended` stream-json denial proof; `too-many-lines` defence-in-depth proof; Change sets B–D; full dispatcher regression; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.
Primary edit begins after: a focused fixture shows that a direct leading-dash `--log-dir` operand is not safely admitted and used as one evidence directory under the current code.

Required outcome:

- Make evidence-location admission distinguish the exact special operand `-` from an ordinary path and refuse it before run admission. The refusal must launch no actor, take no owner or lease, create no evidence, and return clear stderr with a nonzero usage/admission code.
- Treat other valid leading-dash evidence-directory operands as data rather than command syntax wherever the invoked tool supports explicit option termination. Do not blanket-reject valid paths merely because they begin with `-`.
- Establish one canonical absolute evidence-directory value before the first admitted-run effect that depends on it, then use that same value for directory creation, run logs, captures, terminal results, validation, allowlist treatment and operator-facing paths. Do not retain parallel raw and canonical values whose consumers can diverge.
- Preserve `--status` as strictly read-only and preserve the default evidence location.
- Add one focused regression for an actor-controlled dirty path whose basename begins with `-`, at the existing `git hash-object -- "$p"` boundary. It must prove the path is hashed as data and include a mutation/control showing removal of that `--` makes the case fail. Do not add the separate Codex argv-recording fixture.
- Keep this one evidence-path behavior. Do not expand into a general path helper, new parser, path-policy abstraction, broad hostile-path matrix, or the rest of the canonicalization clause.

Check against the repository:

1. Verify Unit 19 commit `1d100317be842aefe8584319f8f4f745b668841a`, its state-only scope and its accepted F7/F5/F2 dispositions without rerunning the discovery searches.
2. Verify in current executable code that evidence location is checked before admission but the run-evidence block still keeps raw `LOG_DIR` beside `LOG_DIR_ABS`, and that exact `-` reaches Bash's special directory behavior. If that premise is false, stop and hand back rather than implementing the proposed boundary.
3. Verify every production consumer of `LOG_DIR`/`LOG_DIR_ABS` affected by normalization and keep the edit bounded to `dispatch.sh` plus focused dispatcher tests.
4. Verify the actor-controlled leading-dash changed-path case reaches the existing `git hash-object -- "$p"` call. Do not reopen unrelated Git calls whose operands come only from strict task grammar or commit hashes.

Required fail-capable evidence:

- Quote the focused failing result captured before the primary edit for a direct leading-dash evidence-directory operand.
- After the edit, show that operand is handled as a path, its evidence is written and reported under one canonical absolute directory, and the focused case passes.
- Show exact `--log-dir -` refusal evidence: nonzero and clear stderr, no actor launch, no task/checkout lease, and no evidence artifact or directory created by the invocation.
- Show the leading-dash changed-path fixture passes with the production `git hash-object -- "$p"` and fails under a narrowly controlled mutation that removes only that option terminator.
- Run only the focused dispatcher cases added or directly affected. Report exact pass/fail counts and commands; defer the full suite.
- Report the implementation commit and confirm only `dispatch.sh`, its focused test file and this state file were committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 19 evidence and current dispatcher/tests; edit `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, its existing focused dispatcher test file and this task state; run focused local shell tests; and make local commits. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No live model launch, authentication attempt, network, external service, full-suite run, merge, push, deployment, destructive cleanup or other operator-reserved capability is permitted.

Completion condition: one committed implementation handback closes the material argv/option-termination gap and the evidence-location slice of canonicalization with focused fail-capable proof, preserves the pre-admission and read-only-status contracts, changes only the bounded files, and returns with `turn: codex`.

Stop and hand back if the evidence location cannot become one canonical value without changing the run-admission architecture, if the premise about `-` or the actor-controlled Git operand is false, if focused proof requires a broad hostile-path harness, or if the fix would expand into the remaining canonicalization clause.

## Latest result

Inspected (2026-08-19) — the correction round's reproduction first, then Unit 20's original record, which still stands:

- **Frozen finding 1: REPRODUCES, and the real behaviour is worse than the finding states.** The ordering is as described — `check_evidence_location` judged the raw operand, `mkdir -p -- "$LOG_DIR"` took the first filesystem effect from that same raw operand, and `cd -- … && pwd -P` established `LOG_DIR_ABS` only afterwards. An isolated probe confirmed `mkdir -p ghost/../runs` creates **both** `ghost` and `runs` while the canonical target is only `…/runs`. Running the new case 69b against the Unit 20 dispatcher `1ea4047e` showed the invocation was not merely leaving a stray directory: it was **fully admitted** — `expected exit 10, got 0`, a lease taken, the actor launched and its commit made, with `ghost` left inside the checkout. Four of 69b's seven assertions were red. The same inspection found a second instance of the finding in the same pre-admission code: the ancestor walk shelled out to `dirname "$probe"`, and `dirname -runs` is `dirname: illegal option -- r` on BSD — a leading-dash operand misread as syntax by the very function meant to judge it. It recovered only by accident (the failed call returns empty, and `dirname ""` is `.`).
- Packaging lines: HOLDS — all four present and non-empty for Implementation mode; `Dominant deliverable:` names one deliverable; `Primary edit begins after:` names a targeted failing case, which is the correct value here because the artifact is executable.
- Claim (1): HOLDS — `git show --stat 1d100317be842aefe8584319f8f4f745b668841a` returns the Unit 19 handback, 1 file changed, the state file only. Its F7/F5/F2 dispositions are read from the accepted record, not re-derived.
- Claim (2): HOLDS, and is stronger than the brief states — searched `dispatch.sh` for every `LOG_DIR`/`LOG_REL` occurrence. Admission ran at `:1642–1645` (`check_evidence_location "$LOG_DIR_WANTED"`), while raw `LOG_DIR` survived alongside `LOG_DIR_ABS` from `:3189` onward with **disjoint consumers**: raw fed `$RUN_LOG` (`:3232`), the hop captures (`:3934`), the unattended profile (`:3463`), `$final` in `finalize_terminal_result` (`:772`) and every operator-facing writability message (`:2002`, `:2038`, `:2130`, `:4427`, `:4432`); canonical fed `$promised` in `consume_terminal_result` (`:2189`), both result validators (`:2191`, `:2195`) and the `LOG_REL` allowlist (`:3190–3194`). So the run **writes** its terminal result from the raw value and **validates** it from the canonical one. An isolated `bash` probe confirmed `cd "$v"` with `v='-'` resolves to `OLDPWD` (`/private/tmp/wl2probe/a`) rather than to a directory named `-` (`…/b/-`), and `mkdir -p -` creates a real directory named `-`, which the admission ancestor walk then accepts.
- Claim (3): HOLDS — the enumeration above is the complete consumer list; the edit is confined to `dispatch.sh` and `dispatch.test.sh`.
- Claim (4): HOLDS — `$p` in `allowlisted_dirty_snapshot` (`:3067`) is the sole actor-named operand; it is populated from `git status --porcelain` and reaches `git hash-object -- "$p"`. No other Git call takes an operand outside strict task grammar, a canonical checkout or a commit hash, and none was reopened.

Result: the evidence directory is now one value, admitted as data, canonicalized once, and used by every consumer.

1. **`check_evidence_location` refuses the exact operand `-` before admission** (`dispatch.sh:1614–1633`), with stderr naming the boundary and offering `./-` for an operator who genuinely wants that directory name. `--` cannot settle this one: bash's `cd -` means OLDPWD however it is quoted, so the created directory and the canonicalized one are not the same directory.
2. **Option terminators where the value is genuinely operator free text** — `mkdir -p -- "$LOG_DIR"` and `cd -- "$LOG_DIR"` at the creation/canonicalization pair, and `ls -t --` plus two `grep -E … --` on the `--status` read path, which stays read-only and does not canonicalize because it takes no lease. Nothing else received `--`: after step 3 every other operand is a canonical absolute path, a commit hash or a bounded task id, and adding terminators there would be the cargo-cult the brief forbids.
3. **One value, chosen at admission** — this is what the correction moved. `check_evidence_location` now *selects* the single canonical absolute target read-only and sets `LOG_DIR_SELECTED`; the admission site copies it into both `LOG_DIR` and `LOG_DIR_ABS` before run identity, before either lease and before any write. The creation site is creation only. Unit 20 collapsed the two forms but did it at the creation site, which left the raw spelling live across exactly the span where the first effect happens.
4. **The selection rule, and its two halves.** Where the whole path exists, `cd -- "$want" && pwd -P` lets the kernel resolve every `..` and every symlink — so `ghost/../runs` with a real `ghost` is admitted and normalized (case 69c). Where it does not, the nearest existing ancestor is canonicalized read-only and the tail appended, and a `.` or `..` **below the last existing directory** is refused: those components do not exist, so there is nothing to resolve, and resolving them lexically would be this dispatcher deciding what a path means — the path framework the brief excludes. The ancestor walk now uses parameter expansion instead of `dirname`, which removes the finding's second instance and one external command from the pre-admission path.

Evidence:

- **Targeted failing case, captured before the primary edit.** `Case 69` red, 6 of 7 assertions failing, the dispatcher's own words: `mkdir: illegal option -- r` / `usage: mkdir [-pv] [-m mode] directory_name ...` / `STOP [10] cannot create log dir`. A legal directory name was refused as syntax.
- **`--log-dir -`, before the edit.** `Case 69a` red: `dispatch.sh: line 3189: cd: OLDPWD not set` / `STOP [10] cannot canonicalize log dir`, and the assertion that failed was `no evidence directory was created` — `a directory named '-' exists at …/co.qXrWQo/-`. An invocation that was never admissible had already written inside the checkout. **Reported precisely:** of 69a's four effect assertions only that one was red; no lease and no actor launch occurred in the red half either, so those three are preserved-behaviour assertions rather than newly-earned ones. The exit code was 10 before and after — what changed is *where* the refusal happens and that it now leaves nothing behind.
- **After the edit.** `Case 69` passes: exit 0 with `--log-dir -runs`; `$d/-runs` exists as a directory; the `.result`, `.log` and `.hop1.claude.out` are all inside it; `run_log` in the terminal result matches `/*-runs/*`, i.e. absolute; the default location was not created. Exit 0 is itself the divergence test — a write path and a consume path that disagreed would stop at 38 or at the untrusted-result funnel.
- **The `--` regression is mutation-controlled.** `Case 70` plants a dirty-before-launch untracked file `-note.md`, has the actor edit it during the hop, and asserts it is named inside `PARTIAL FILE EFFECTS`. Its porcelain line is byte-identical at both snapshots, so **only the blob hash makes the edit visible** — which is what makes the case about the terminator rather than about the path. `Case 70a` rebuilds `dispatch.sh` with `sed 's|hash-object -- "$p"|hash-object "$p"|'`, asserts the diff is exactly one line and that the terminator is gone, and asserts the path then goes **unreported**. Both halves behaved correctly before the edit too: this is protection for behaviour that was already right and had no proof.
- **The correction's own before/after.** New `Case 69b` uses `--log-dir ghost/../runs`. Against the Unit 20 dispatcher `1ea4047e` it is **red on four assertions**: `expected exit 10, got 0`, `a directory named 'ghost' exists at …/co.aeDLmq/ghost`, `a lease root exists`, `the actor recorded a call`. Against the corrected dispatcher it is green on all seven: exit 10, `STOP [10]` naming the run evidence location, and neither `ghost` nor `runs` created, no lease, no actor.
- **The refusal is not a blanket ban on `..`,** and `Case 69c` is what holds that line: the same spelling with `ghost` and `runs` present is admitted, exits 0, files its evidence in the resolved directory, reports a `run_log` with no unresolved `..`, and creates nothing under the traversed component. **69c passes against the Unit 20 dispatcher too** — it is a preservation control for behaviour the correction had to keep, not something the correction earned, and it is reported as such.
- **Focused runs.** Commands: `DISPATCH_BIN=$PWD/dispatch.sh REPO_ROOT=<checkout> bash <runner>`, where each runner is the harness header plus the case block, assembled in the scratchpad so the full suite stays deferred. Cases 69/69a/69b/69c/70/70a: **pass=31 fail=0**. Directly affected existing block (12h, 12h-ok, 12i, 27s, 27t, 27u, 27v, 27w, 27x): **pass=84 fail=6** — identical to the **pass=84 fail=6** from the same extract against both the Unit 20 dispatcher and the pre-Unit-20 `HEAD`. The six are the 27s/27v/27w/27x "simulated actor started" rows, which fail in isolation because they are signal-timing cases needing full-suite context; they are pre-existing and untouched.
- **Nothing already accepted broke.** `--dry-run` and `--status` both still exit 0 through the new admission, `--status` still declares itself read-only, and cases 69, 69a, 70 and 70a — the exact-`-` refusal, the valid leading-dash directory, and the mutation-controlled `git hash-object --` proof — are all still green.
- **The default evidence location is preserved, with one honest caveat.** A no-`--log-dir` run files its result in `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/` as documented. That check also exits 18 — but **identically on the corrected dispatcher, on Unit 20's, and on pre-Unit-20 `HEAD`** — because `new_sandbox` leaves `plans/` untracked, so `?? plans/` is an out-of-allowlist path present before launch. That is a property of the harness fixture, not of this change, and nothing was done about it here.
- **Two existing expectations were updated, and the change is deliberate, not accommodation.** `27u` compared `run_log` against the raw `$d/runs/…` and `12h` grepped the refusal output for the raw record path. Both now expect the canonical form, because reporting one evidence path in the operator's typed form while validating another canonically is precisely the defect this unit removes. The difference is visible on any host whose sandbox root is reached through a symlink — macOS `/var` — and the file-existence assertions beside them are unchanged, since opening a path follows symlinks.
- **Accepted limitation.** Operator-facing evidence paths are now always canonical, so a run under a symlinked directory reports the resolved path rather than the typed one. That is the intended consequence of having one value.

**Newly noticed during the correction, recorded and not implemented** (core § 5): no committed case exercises the default evidence location end-to-end, because every case passes an explicit `--log-dir` and the sandbox's own uncommitted `plans/` would stop such a run at 18. That is a harness coverage gap rather than a dispatcher defect, and closing it means changing `new_sandbox`, which is outside the frozen finding.

Only `dispatch.sh`, `dispatch.test.sh` and this state file are committed. The full dispatcher suite, live trials and final regression stay deferred per the brief. `logs/friction-log.md` remains unrelated and unstaged.

## Blocker

None.

## Next action

Codex: the closure check on frozen finding 1 only — is the ordering defect resolved, and did the correction break any already-accepted Unit 20 behaviour? Both questions are answered above with before/after evidence and exact counts. Two things are offered for the closure check to rule on rather than assumed settled: the refusal of a `.` or `..` below the last existing directory, which narrows accepted input by that one shape and is a judgment call inside the finding; and the recorded deferral about the harness's missing default-location coverage. Anything else newly noticed is a deferral, not a second round.
