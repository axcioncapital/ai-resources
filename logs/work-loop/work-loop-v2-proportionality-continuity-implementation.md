---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S7 only**: make dispatcher runtime evidence collision-proof under the two
concurrency shapes accepted plan § 4.8 names. This is the final implementation slice in the
accepted S1–S7 sequence.

Excluded are changes to S1–S6 or their lifecycle decisions; another P-7 compaction; Phase 2 or its
remaining blockers; supervisor design; changes to lock identity or exit `17`; migration or deletion
of existing run evidence; edits outside `dispatch.sh`, the spike README if its old default must be
corrected, and this state file; changes to `dispatch.test.sh`; copying this active state file to
another checkout; worktrees, branches, pushes and unrelated cleanup. Temporary, independently
created test repositories under a disposable directory are permitted for P-5 and P-6; this task
remains bound to the saved Local checkout above.

## Lane and unit

Standard. Implementation mode. Unit 7 — make the dispatcher's default log location checkout-bound
and its run artifacts unique across same-second runs from different checkouts.

Named reason for the loop: this is the final separately committable slice of an accepted multi-slice
plan, and its concurrency behaviour needs independent evidence before the task can close.

## Brief

### Active S7 implementation brief — collision-proof dispatcher runtime evidence

S6 has entered normal operation with its live-causality limitation written down. S7 is ready now
because both the plan's S0 task and the later task that owned the same dispatcher targets are closed;
this final slice implements only accepted plan § 4.8 and proves P-5 and P-6 before the task closes.

**Required outcome.** In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, make the
no-`--log-dir` default resolve under the checkout being driven, for both a run and `--status`, while
an explicit `--log-dir` continues to win. Make a run ID unique enough that same-task runs started in
the same second from different checkouts into one shared explicit log directory cannot overwrite
their `.log`, `.hopN.<actor>.out` or `.unattended-settings.json` artifacts. Preserve chronological
sorting and preserve the existing same-checkout/same-task lock refusal at exit `17`. Update the
spike README only where it currently documents or depends on the old default.

**Governing sources and dispositions.** The accepted implementation plan § 4.8, § 5/S7, § 6/P-5
and P-6, § 8/R-3 and § 9 governs this slice. The executable core §§ 3–7 wins on process and evidence.
The current `dispatch.sh` and README are verify-first repository reality, not authority. The closed
records `work-loop-v2-contained-unattended-profile.md` and
`work-loop-v2-escaped-descendant-termination.md` establish that their ownership has ended; their
Phase 2 safety outcomes remain background and must not be changed by S7.

**Allowed paths.** Only:

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`, only if the old default is stated
- this state file

Do not edit `dispatch.test.sh`; the accepted plan does not authorise it. Use disposable test
fixtures outside the repository where P-5 or P-6 needs multiple repositories or checkouts, and
never copy this active task state into them.

**Claims Claude must check before acting.** Verify all of these against the live repository and
stop on a false load-bearing claim rather than improvising:

1. `pwd -P` is the bound Local checkout; this file's task identity matches its filename and incoming
   `turn:` is `claude`.
2. Both named predecessor task files have core § 4's four-heading closing-record shape, so neither
   still owns `dispatch.sh`, `dispatch.test.sh` or the README. Check current repository status too;
   stop on an actual dirty-target overlap even though the task records are closed.
3. In the current dispatcher, both the run path and `--status` still default to
   `$SPIKE_DIR/runs`, an explicit `--log-dir` still takes precedence, and `RUN_ID` is still only
   second-resolution timestamp plus task id. In the README, confirm exactly which statements still
   name the spike-local default.
4. The existing checkout-and-task-derived `LOCK_KEY` and the exit-`17` same-checkout refusal are
   present and can remain unchanged while § 4.8 is implemented.

**Required evidence.** Show the matched failing conditions first, against the pre-S7 dispatcher:
P-5 must place checkout B's default evidence under the dispatcher/script checkout rather than B;
P-6 must demonstrate an artifact collision or overwrite for same-task, same-second runs from two
different checkouts into one shared log directory. Then show both cases passing after the change.
For P-6, account separately for the run log, hop capture and unattended-settings filename when that
artifact is produced; do not infer all three from one filename. Show that explicit `--log-dir`
still wins, `--status` reports the same default a real run uses, chronological ordering remains, and
same-checkout/same-task concurrency still refuses the second dispatcher with exit `17`. Run the
existing `dispatch.test.sh` suite unchanged as regression protection and report its exact result.
Report any pre-existing unrelated dirty paths separately, the exact committed path list, and whether
the README needed changing.

**Completion and stop.** Complete when one bounded S7 commit implements both § 4.8 behaviours,
P-5 and P-6 plus their controls pass, the unchanged suite passes, only allowed paths enter the
commit, and `turn:` returns to `codex`. Stop and hand back on a false premise, target ownership or
dirty overlap, a need to weaken the lock, a need to edit `dispatch.test.sh` or another unapproved
path, an inability to create fail-capable same-second evidence, or any Phase 2/supervision
dependency. Claude may challenge stale plan line numbers or a false mechanism premise; preserve the
required behaviour and hand back rather than broadening the slice.

### Prior P-7 preparation step — registered live run

S6's implementation and versioning are accepted; what remains unknown is whether the installed
mechanism actually restores the correct durable orientation after a Codex root compaction. This
Adoption-mode unit will collect P-7's live operation evidence before the lifecycle decision. The
current Claude step prepares the registered-run witness only; it does not operate Codex, change the
hook, begin the unregistered control, or open S7.

**Required outcome.** In this state file only, create one short, unique witness value that has never
appeared in the Codex conversation and make it materially determine the post-compaction next move.
Place it in the current `## Next action` together with the exact active state-file path, bound Local
checkout, governing plan path, Work Loop v2 workflow, Adoption-mode Unit 6A, and an instruction for
the operator to return to the existing Codex task and invoke `/compact` as their very next input
without quoting or paraphrasing the witness. The next action must also tell post-compaction Codex to
re-read those durable sources, report the witness it found, and record the registered observation
before any further move.

**Why Claude owns this preparation.** Codex must not see the witness before compaction or the test
would not distinguish durable reorientation from conversational memory. Claude chooses and writes
the value; the operator carries only the `/compact` action and does not paste the value into chat.

**Governing sources.** This state file; accepted plan § 4.9 and § 6/P-7; executable core §§ 3–7;
Work Loop v2 skill; `AGENTS.md` § *Compaction*; the committed S6 result. The state file remains the
single interface. No new fixture, log, registry or evidence file is created.

**Required evidence and boundary.** Report the chosen value in the state file, show that it was
absent from the file before this preparation and present afterward, and commit only this state file.
Do not put the value in a message the operator must paste into Codex. Set `turn: operator`; this is
an intentional operational hand-off, not completion of Unit 6A. The registered run, pointer-retention
observation, multi-open-task observation and later unregistered control remain to be performed from
Codex. Stop if the witness cannot be kept out of the Codex transcript or if preparation would touch
another path.

### Accepted S6 completion step — operator choice (a), 2026-08-08

S6 is implemented and deterministically proved on disk; the remaining implementation step is to
make that exact result versioned. The operator explicitly chose option (a): deliberately track
`AGENTS.md`, `.codex/hooks.json` and `.codex/hooks/work-loop-reorient.sh`. This reopens the
2026-07-13 decision only for those three paths and does not adopt or maintain the rest of the Codex
mirror.

**Required outcome.** Amend `.gitignore` narrowly enough that the three exact S6 targets become
trackable while every other currently ignored Codex-mirror path remains ignored. Preserve the
implemented contents and executable mode already recorded below. Commit only `.gitignore`, the
three S6 targets and this state file; do not use a one-off force-add as a substitute for a durable,
narrow tracking rule.

**Governing authority.** The operator's explicit choice (a) in the Codex task on 2026-08-08; this
state file; `.gitignore` lines 56–64 and their 2026-07-13 operator decision; accepted plan § 4.9,
S6, P-7 and R-4; executable core §§ 3–7; repository current state. The new operator decision
supersedes the old non-tracking decision only for the three named files.

**Claims to verify before changing anything.** Confirm that the three named targets still carry the
S6 result recorded below and are still ignored/untracked; that no concurrent task owns `.gitignore`
or the three S6 targets; and that a narrow rule can expose only those files without exposing another
file under `.codex/`. Stop on a false claim or an actual overlap.

**Required evidence.** Show the red condition first: all three exact targets are ignored and absent
from `git ls-files`. After the change, show all three are tracked, the new script remains executable,
and representative non-S6 mirror files remain ignored. Validate the JSON structure, report the
exact committed path list, and confirm that no other `.codex/` path entered the commit. Reuse the
already reported deterministic script evidence unless a target's contents changed; do not repeat it
ceremonially.

**Completion and stop.** Complete when one bounded commit contains exactly `.gitignore`, the three
S6 targets and this state file, with the S6 implementation unchanged except for becoming tracked;
then set `turn: codex`. Stop and hand back if tracking the three files would expose another mirror
path, require a broader adoption decision, collide with concurrent ownership, or require changing
the S6 behaviour. Do not run the live P-7 compaction trial and do not begin S7 in this step.

### Prior S6 implementation brief — completed on disk; retained as evidence context

S6 restores durable orientation after compaction without guessing which of several open Work Loop
tasks is active. It implements accepted plan § 4.9 by splitting responsibility between the existing
AGENTS.md preservation owner and one minimal hook.

**Required outcome.**

1. Amend only `AGENTS.md` § *Compaction* with four further pointers the compacting session must
   preserve: the exact active `logs/work-loop/{task-id}.md` path; the bound checkout; the governing
   plan path plus workflow and phase; and the current `## Next action`.
2. Add exactly one `.codex/hooks.json` registration: `SessionStart`, matcher `compact`, one
   `type: command` hook invoking the new script by absolute `bash '<path>'`, with a small timeout and
   status message. Leave the existing unmatched `SessionStart` Friday reminder unchanged.
3. Add `.codex/hooks/work-loop-reorient.sh`, small and read-only. From the hook payload it emits JSON
   on stdout using `hookSpecificOutput.additionalContext`, containing only:
   - checkout identity: the received `cwd` plus the git common directory, so a worktree is
     distinguishable from its local checkout;
   - one instruction to reread the active Work Loop pointers preserved under AGENTS.md §
     *Compaction* from disk before moving, and not to continue from the compacted summary.
4. The script never identifies a task, scans `logs/work-loop`, chooses a turn, quotes repository
   content, writes a file or emits a project summary. Missing input, unreadable input, lookup failure
   or missing `jq` fails open: exit 0 with no `additionalContext`.
5. Add no `PreCompact` or `PostCompact` hook. One compaction produces one reorientation.

**Governing sources.** This state file; accepted plan § 4.9, S6, P-7 and R-4 in
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`;
`AGENTS.md` § *Compaction*; `.codex/hooks.json` and existing hook conventions; executable core §§
3–4; repository current state. The accepted plan settles the design; Claude chooses only the
smallest implementation consistent with the actual hook payload and schema.

**Allowed paths.**

- `AGENTS.md`
- `.gitignore`
- `.codex/hooks.json`
- `.codex/hooks/work-loop-reorient.sh` (new)
- `logs/work-loop/work-loop-v2-proportionality-continuity-implementation.md`

Nothing else may be changed or committed. Current non-fixture task inspection shows no other task
owns these targets: the project-progression task is confined to its own closing state file; the
escaped-descendant task owns dispatcher paths and excludes Work Loop rule changes; the remaining
open tasks are at `turn: codex`. Re-check immediately before editing and stop on actual overlap.

**Claims to check before acting.**

1. `pwd -P` is exactly
   `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; this state file matches its
   filename and its incoming turn is `claude`.
2. `AGENTS.md` § *Compaction* has the three existing preservation bullets and none of the four S6
   pointers.
3. `.codex/hooks.json` has one unmatched `SessionStart` Friday reminder, no matcher `compact`, and no
   `PreCompact` or `PostCompact` registration.
4. `.codex/hooks/work-loop-reorient.sh` does not exist.
5. The actual SessionStart payload and current hook schema can supply the accepted output without
   a task scan or repository-content read. If the accepted plan's payload premise is false, hand it
   back rather than inventing a second source of task identity.
6. At least three non-fixture Work Loop tasks are currently open, so P-7's multi-task witness is
   real rather than simulated.

**Required evidence.**

- Report all six claims, exact changed paths and the executable-bit state of the new script.
- Build the failing case first: show the four preservation pointers, compact registration and script
  behavior are absent before the change, then show the same checks passing afterward.
- Validate `.codex/hooks.json` structurally and show exactly one `SessionStart`/`compact`
  registration while the existing unmatched SessionStart hook is byte-for-byte unchanged.
- Run the script with valid synthetic stdin and show stdout contains checkout identity and the
  reread instruction, contains no task path or state content, writes nothing, and exits 0.
- Run malformed/missing-input and missing-`jq` controls. Every case must exit 0 without
  `additionalContext`; do not weaken this fail-open boundary.
- Run P-7's actual compaction case and its unregistered control with one material fact present only
  in the durable sources. The registered next move must open the exact preserved active task file,
  governing plan and workflow/phase source before acting, and match that file's `## Next action`;
  the unregistered control must differ or the proof measured nothing.
- In the repository's multi-open-task condition, confirm exactly the session's preserved active task
  is reoriented to—never several and never a task chosen by scanning.
- After compaction, inspect the retained context for all four AGENTS.md pointers. If the current
  runtime cannot trigger or observe an actual root compaction, do not substitute a static grep:
  return the deterministic witnesses separately and name the unproved live witness as the blocker.
- Report pre-existing unrelated dirty paths or failures separately; do not repair them.

**Completion condition.** The three accepted targets implement § 4.9 exactly; deterministic and
live P-7 witnesses pass with the unregistered and multi-task controls; only allowed paths are
committed by Claude; `turn:` returns to `codex`.

**Stop conditions.** Stop on wrong checkout, invalid state identity/turn, target collision, false
payload/schema premise, inability to produce the live P-7 witness, any need to identify the task by
filesystem scan, any nonzero error path in the script, or any excluded path or registration. Hand
back the evidence gap rather than broadening the hook.

## Latest result

### Claude implementation of S7 — collision-proof dispatcher runtime evidence (2026-08-08)

Inspected (2026-08-08):

- Claim (1): HOLDS — ran `pwd -P`; it returns
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`, the bound Local checkout. Read
  this file's frontmatter: `task:` is `work-loop-v2-proportionality-continuity-implementation`,
  matching the filename, and the incoming `turn:` was `claude`.
- Claim (2): HOLDS, in both halves. Ownership: read both predecessor files' headings with
  `grep -n '^## '`. `work-loop-v2-contained-unattended-profile.md` and
  `work-loop-v2-escaped-descendant-termination.md` each carry exactly core § 4's four closing
  headings — `## Outcome`, `## Decisions that matter`, `## Evidence`, `## Accepted limitations` —
  and each reads `turn: operator`. Neither still owns `dispatch.sh`, `dispatch.test.sh` or the
  README. Dirty-target half: ran `git status --short`; neither `dispatch.sh` nor `README.md` appeared
  as modified before this unit began, so there is no actual overlap. The one other open task at
  `turn: claude`, `work-loop-v2-descendant-supervision-discovery`, is Discovery mode and its own
  scope states it "must not implement or modify the dispatcher, tests, plan, README" — it holds no
  write claim on these targets.
- Claim (3): HOLDS — read the dispatcher, not recalled it. The run path defaulted at line 1044
  (`[ -n "$LOG_DIR" ] || LOG_DIR="$SPIKE_DIR/runs"`) and `--status` at line 1027
  (`st_logdir="$LOG_DIR"; [ -n "$st_logdir" ] || st_logdir="$SPIKE_DIR/runs"`), with `SPIKE_DIR` the
  script's own directory (line 183). Both branches read `$LOG_DIR` first, so an explicit `--log-dir`
  already won. `RUN_ID` at line 1056 was `"$(date '+%Y%m%dT%H%M%S')-$TASK"` — second-resolution
  timestamp plus task id, nothing else. In the README, `grep -n '<spike>'` returns exactly one line:
  the options table at line 44, `| \`--log-dir DIR\` | \`<spike>/runs\` |`. That is the only place
  the old default is *stated*. Two further places *depend* on it — see "What the README needed" below.
- Claim (4): HOLDS — `LOCK_KEY="$(printf '%s|%s' "$CHECKOUT" "$TASK" | shasum -a 256 | cut -c1-16)"`
  at line 433, with `CHECKOUT` canonicalized at line 332, i.e. before the key is derived; the
  `acquire_lock` refusal exits `17`. Both are above the § 4.8 targets and neither had to move: the
  final dispatcher changes no lock line, and the exit-`17` control below is measured, not assumed.

**The change.** Four functional lines, everything else in the diff is comment. `DEFAULT_LOG_DIR` is
resolved once, immediately after the checkout is canonicalized, and both the `--status` branch and the
run branch now read it — a `--status` that named a different directory from the one a real run writes
to would be a status report about nothing, and a single source is the only durable way to keep the two
in step. Its value is the spike's own relative path under `$CHECKOUT`, chosen so that driving this
repository's own checkout resolves to exactly the directory the existing logs are already in: nothing
was moved and `--status` still finds them. `RUN_ID` became
`<timestamp>-${LOCK_KEY:0:8}-$$-<task>` — timestamp first so the directory still sorts
chronologically, task id **last** so `--status`'s `*-$TASK.log` glob stays an exact match and keeps
matching run logs written before this change. The discriminator is the one already computed: within a
single task `LOCK_KEY` varies exactly when the checkout does. No new concept, and no lock line touched.

**What the README needed.** Three edits, all of them statements that documented or depended on the old
default. (1) The options table's default column, which stated `<spike>/runs`. (2) The walk-away worked
invocation, which passes no `--log-dir` and piped its console capture to a spike-relative
`runs/walkaway-$TASK.console`; with the run log now landing in `$REPO`, that example would have split
its own evidence across two checkouts, so the `tee` target was pointed at the same directory the run
uses. (3) The allowlist paragraph, which said a run "never flags its own evidence as foreign work" —
now on the ordinary path rather than only under an explicit `--log-dir`, and falsified in one shape by
the boundary measured below, so it is corrected and the limit is written down beside it.

Result: § 4.8 is implemented in `dispatch.sh`. With no `--log-dir`, run evidence and `--status` both
resolve under the checkout being driven; an explicit `--log-dir` still wins; two same-task runs
started in the same second from different checkouts into one shared log directory no longer overwrite
each other's run log, hop capture or unattended-settings file; chronological ordering and the
same-checkout exit-`17` refusal are unchanged. The unchanged suite is still 368/0.

Evidence — the matched failing case first, then the same harness against the changed dispatcher. Both
columns come from one script run twice: once against the pre-S7 dispatcher extracted from `HEAD` with
`git show`, once against the working tree. It builds its own disposable git checkouts under a temp
root and never touches this repository.

| Check | Pre-S7 | Post-S7 |
|---|---|---|
| P-5 — checkout B's default evidence stays out of the script's directory | **FAIL** — `script/runs` held `…-s7-p5.log`, `.hop1.claude.out`, `.hop1.claude.tree` | PASS — no `runs/` created there |
| P-5 — checkout B's default evidence lands under checkout B | **FAIL** — no run log under B | PASS — `20260808T134514-39095c59-94894-s7-p5.log` |
| P-6 — the two runs really did start in the same second | same second, `20260808T134456` | same second, `20260808T134514` |
| P-6 — run id A vs B | `20260808T134456-s7-collide` / `20260808T134456-s7-collide` — **identical** | `…-5a59748f-95234-s7-collide` / `…-2241ccde-95235-s7-collide` — distinct |
| P-6 — distinct **run logs** in the shared dir | **FAIL** — 1 | PASS — 2 |
| P-6 — distinct **hop captures** | **FAIL** — 1 | PASS — 2 |
| P-6 — distinct **unattended-settings** files | **FAIL** — 1 | PASS — 2 |
| control — an explicit `--log-dir` still wins | PASS | PASS |
| control — `--status` names the same directory the run used | not measurable (the run wrote elsewhere, so one side did not exist) | PASS |
| control — every run-log name still begins with the timestamp | PASS | PASS |
| control — same checkout + same task, concurrent → exit `17` | PASS | PASS |
| unchanged `dispatch.test.sh` | 368 pass, 0 fail | 368 pass, 0 fail |

The three P-6 artifact classes are counted separately, by three separate globs — `*.log`,
`*.hop1.claude.out`, `*.unattended-settings.json` — not inferred from one filename. A fourth artifact,
`*.hop1.claude.tree`, collided in the same way and is fixed by the same change; it is reported because
it was observed, not because the brief asked for it. Producing the unattended profile required the
fake-binary path rather than `--actor-cmd`: the dispatcher refuses to call a simulated run
"unattended" (exit `10`), which is itself the right behaviour and was left alone.

The checks can fail, and did. Every P-5 and P-6 line above is red in the left column against a
dispatcher that differs from the right column only by this commit. The P-6 harness also refuses to
report on runs that did not share a second — it re-runs until the two timestamps match and fails
outright after eight attempts, so a green P-6 cannot be produced by two runs that merely happened to
land in different seconds. The suite's own case 0 points itself at an absent dispatcher and asserts
the suite fails, so 368/0 is not a harness that passes with the subject removed. What the pair does
**not** show is live product transport: every actor here is a fake binary or a simulated command, so
this is controller-logic evidence, exactly as the suite's own header says of itself.

Backward compatibility, checked on real data rather than argued: `--status` run read-only against this
bound checkout still resolves the default to
`plans/work-loop-v2-v0.2/handoff-automation-spike/runs` and still reports the pre-change-named
`20260807T201627-work-loop-v2-proportionality-continuity-implementation.log`. Nothing was moved,
migrated or deleted, and `git status` after that call showed no new path.

**One boundary, measured and written down rather than fixed.** The dispatcher's pre-hop gate reads
`git status --porcelain`, and git collapses an untracked *directory* to its shortest path. In a
checkout where an ancestor such as `plans/` is itself untracked, the dispatcher's own new evidence is
reported as `?? plans/`, which the allowlist entry for the run directory does not match, so the run
stops at `18` before launching an actor. Pre-S7 the same fixture exited `22`, because the evidence
landed outside that checkout — so this shape is reachable only because the default now lands inside
it. It is not fixed here: the two candidate fixes are widening the allowlist to an ancestor, which
would let genuinely foreign changes under that ancestor pass unseen, and switching the gate to
`--untracked-files=all`, which changes a guard § 4.8 does not authorise. Every real checkout of this
repository tracks `plans/`, the failure is fail-closed and prints a recoverable next action, and the
realistic-checkout case was verified to run through the gate and file its evidence under the driven
checkout. Recorded in the README beside the paragraph it qualifies, and offered to Codex as the
decision it is.

**Commit and paths.** One commit, exactly three paths: `dispatch.sh`, `README.md` and this state file.
`dispatch.test.sh` is unchanged and unstaged. No fixture, probe or run artifact from this unit entered
the repository — all of it lives under disposable temp roots.

**Pre-existing dirty paths, reported and not repaired.** `logs/friction-log.md`,
`logs/session-notes.md`, the untracked `plans/axcion-harness-v0.2/` directory, and two untracked
`handoff-automation-spike/runs/*.log` files were dirty before this unit and were neither touched nor
staged. Separately, a concurrent writer moved `HEAD` during this unit: commit `8c15cef`
("correct: work-loop-v2 1a discovery — tighten ptrace, product-path and commit-scope evidence") landed
mid-run. `git diff --name-only 8cf2614..HEAD` shows it touched only
`logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` — no S7 target — so it is reported,
not treated as an overlap.

**New deferral from this unit, recorded and not done.** `SPIKE_DIR` (line 183) is now referenced
nowhere but a comment. Removing it is a third change § 4.8 does not authorise, and leaving a variable
that means "the script's own directory" is a standing invitation to reintroduce exactly the coupling
this slice removed. Named for a later cleanup, not taken here.

Accepted limitations carried forward, unchanged by S7:

1. S4's skill-fetch reads precede its `pwd` instruction, but no durable project/state source or
   mutation does.
2. P-4 is unexecuted under the operator's saved-Local-only constraint; no simulation replaces it.
3. **S6:** no hook-specific `additionalContext` was separately visible after the registered
   compaction, and no unregistered comparison ran. The trial proves that durable reorientation
   worked, not that the hook caused it. This is not recorded as full P-7 causal proof.

Deferrals carried forward, none implemented:

1. An ordinary unnamed request still activates Work Loop v1; outside this plan's targets.
2. The Work Loop v2 skill's 340-line harness ceiling is stale/red and exceeded; separate
   rebase-versus-trim decision required.
3. P-4 may run only in a future explicitly authorised isolated checkout.
4. The § 4.6 orientation paragraph may later be split for readability if authority permits.
5. Accepted plan § 4.9's `PostCompact` rationale is partly wrong on the current documentation; the
   conclusion stands on its other two grounds. Plan prose only.

## Blocker

None. S7 is implemented and proved; no premise failed and no target was contested.

## Next action

Codex: assess S7 against accepted plan § 4.8 and § 6/P-5 and P-6. The two § 4.8 behaviours are
implemented in one commit over three allowed paths, P-5 and P-6 are red-then-green against a
dispatcher differing only by this commit, all four controls hold, and the unchanged suite is 368/0.
Three points want a decision rather than a re-run: the exit-`18` boundary in a checkout with no
tracked ancestor above the run directory, recorded rather than fixed because both candidate fixes fall
outside § 4.8; the third README edit, which corrects a sentence this change made reachable and is the
one edit going beyond "states the old default"; and the `SPIKE_DIR` removal deferred for the same
reason. With S7 accepted, the task's S1–S7 exit condition is met and the task is ready to close.
