---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **P-7's live S6 evidence only**: observe the tracked post-compaction mechanism
under an actual Codex root compaction before deciding whether S6 enters normal operation with full
evidence, with a written limitation, or not yet.

Excluded are S7; changes to S1–S6; edits to `.gitignore`, `AGENTS.md`, `.codex/hooks.json`, the
reorientation script, executable core, Claude command, Work Loop skill, harness, fixtures,
dispatcher or another task file; `PreCompact` or `PostCompact` registration; a task scan, task
registry, phase copy, new state field, cached summary or second hook; installation, propagation,
worktrees, branches, pushes and unrelated cleanup. The current preparation step may edit only this
state file.

## Lane and unit

Standard. Adoption mode. Unit 6A — collect P-7's live registered and control evidence for the
tracked S6 mechanism, beginning with a durable-source-only witness for the registered run.

Named reason for the loop: this hook runs at a continuity boundary across every root compaction in
the repository, so its scope and fail-open evidence need independent assessment before it counts.

## Brief

### Current P-7 preparation step — registered live run

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

### Codex registered-run observation after an actual root compaction (2026-08-08)

**Report-first observation 2 — the unregistered control.** It is still required for full P-7
causal proof. The registered run recovered the durable orientation, but without the same compaction
run with the hook unregistered, that recovery could have come from the retained compacted summary
or the AGENTS.md preservation rule rather than the hook. The registered run alone therefore shows
the desired outcome occurred; it does not isolate what caused it.

**Durable-only witness recovered from disk:** `P7-F2536064F1`. This value was absent from the
pre-compaction Codex conversation and was produced only after Codex re-opened this state file. The
file also required observation 2 to be reported first rather than the natural observation 1 or the
invalidated attempt's observation 4; that instruction was likewise recovered correctly.

**Registered observation.** A real Codex root compaction occurred. Before answering or advancing
the project, post-compaction Codex verified the bound checkout and re-read this state file, the
governing implementation plan, the Work Loop v2 skill and the executable core from disk. The next
move therefore matched this file's `## Next action`: recover and report the hidden witness, then
record the observation before anything else.

- **Hook firing and injection:** no hook-specific `additionalContext` message or hook event was
  separately visible in the model-visible post-compaction context, so Codex cannot honestly claim
  that the hook fired or quote a live injected value. The on-disk registration and script still
  show the registered mechanism and its intended fixed injection, but those are deterministic
  implementation evidence, not proof of this live firing.
- **Exactly one task:** the retained context named exactly this active task,
  `logs/work-loop/work-loop-v2-proportionality-continuity-implementation.md`; it named no competing
  Work Loop task. The script read from disk still contains no task-selection mechanism and emits no
  task path.
- **Four retained pointers:** the post-compaction context retained the exact active task path, the
  bound Local checkout, the governing plan plus Work Loop v2 / Standard lane / Adoption-mode Unit
  6A, and the current instruction to re-read the durable next action and record the registered
  observation. The hidden witness itself was deliberately absent and was recovered from the state
  file, which is the control's material fact.

**Disposition of this observation:** the durable reorientation, single-task outcome and pointer
retention were observed; live hook firing and causality remain unproved. Nothing outside this state
file changed, the unregistered control has not begun, and S7 remains unopened.

### Claude verification of the registered-run witness (2026-08-08)

Claude did not observe the compaction and does not restate Codex's account of its own context. What
Claude owns is the repository half of the control, and that half is checkable here.

Inspected (2026-08-08):

- Claim (1): HOLDS — read this file's frontmatter; `task:` is
  `work-loop-v2-proportionality-continuity-implementation`, matching the filename, and the incoming
  `turn:` was `claude`.
- Claim (2): HOLDS — read the prepared witness back out of the committed blob with
  `git show 2829915:logs/work-loop/work-loop-v2-proportionality-continuity-implementation.md` and
  compared it to the value quoted above: the two strings are equal. Compared against the commit, not
  against what Claude remembers writing.
- Claim (3): HOLDS — the same comparison for the `REPORT-FIRST:` line. The file required
  observation 2 and observation 2 is what was reported first. That is neither the natural opening
  (observation 1) nor the invalidated attempt's (observation 4).
- Claim (4): HOLDS — ran `git status --short` before staging; the only Work Loop path modified is
  this state file. `logs/friction-log.md`, `logs/session-notes.md` and two untracked
  `handoff-automation-spike/runs/*.log` files are pre-existing dirty paths from earlier work, and
  were neither touched nor staged. No S6 target and no `.codex/` path is in this commit.
- Claim (5): HOLDS — searched the working file for `WITNESS-TOKEN:` at a line start; none remain.
  The spent value cannot be presented as a fresh witness by a later run.

Result: the registered half of P-7's live trial is recorded, and its durable-source control passed
on the repository side. Both hidden values — the token and the report-first observation — came back
exactly as this file held them, from a session whose conversation never carried either of them.

Evidence: the two equality checks above, taken against the committed blob at `2829915`. The check is
capable of failing, and this is the run where it mattered: a session answering from its compacted
summary can produce neither string, the first attempt was invalidated precisely because that
separation broke, and of the observations available to guess, the habitual choice (1) was among the
wrong ones. What the check does **not** show is causality. Codex records that no hook-specific
injection was separately visible in its post-compaction context, so the registered mechanism's own
firing remains unproved by this run, and the unregistered control is still owed.

### Registered-run preparation invalidated before compaction (2026-08-08)

The operator sent `u go` rather than invoking `/compact`. Codex then opened this state file to
determine the authoritative turn and read the prepared instructions before any root compaction
occurred. Even though Codex did not deliberately open the witness block itself, repository content
from this preparation reached the Codex context before compaction, violating the control's explicit
boundary. This preparation therefore proves nothing and must not be counted as P-7 evidence.

No root compaction ran, no hook observation was made, and no S6 file changed. The correct recovery is
one state-only restart with a newly generated witness that is not reused or revealed before the
operator's literal `/compact` input.

### Claude preparation for P-7's registered live run — second witness (2026-08-08)

Adoption-mode preparation only, restarted after the first attempt was invalidated above. Nothing was
implemented, no hook or S6 file was touched, the unregistered control was not begun, and the
lifecycle decision is not taken here. Only this state file changed.

Inspected (2026-08-08):

- Claim (1): HOLDS — read this file's frontmatter; `task:` is
  `work-loop-v2-proportionality-continuity-implementation`, which matches the filename, and the
  incoming `turn:` was `claude`.
- Claim (2): HOLDS — ran `pwd -P`; it returns
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`, the bound Local checkout the
  preserved pointers name.
- Claim (3): HOLDS — `ls -l` on
  `plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`;
  present, 67215 bytes. The governing-plan pointer resolves.
- Claim (4): HOLDS — read `AGENTS.md` section *Compaction*; all four S6 pointers are present
  (active task path, bound checkout, governing plan plus workflow and phase, current
  `## Next action`), alongside the three pre-existing bullets. The re-read instruction points at
  something real.
- Claim (5): HOLDS — `jq '[.hooks.SessionStart[] | select(.matcher=="compact")] | length'` on
  `.codex/hooks.json` returns `1`. The run about to be observed is genuinely the *registered* one.
- Claim (6): HOLDS — `ls -l .codex/hooks/work-loop-reorient.sh`; present and `-rwxr-xr-x`.
- Claim (7): HOLDS — searched the whole tracked repository for the newly generated witness with
  `git grep -c` before writing it; no match, in this file or anywhere else.

**What was prepared.** The invalidated prepared action was removed in full, including its witness
token and its report-first line, so no part of it can be produced from this file. A different witness
token was generated and written into `## Next action`, paired with a report-first instruction naming
a **different** P-7 observation from the invalidated one. Both live in this file and nowhere else.

**Absence before, presence after — the fail-capable half.** Before this preparation the new token
appeared **0 times in this state file** and **0 times anywhere in the tracked repository**
(`git grep -c`, checked at generation time and repeated after the write). After it, it appears
**once**, in `## Next action`. The old token, present **1** time(s) before, now appears
**0** times in the working tree. It survives only in commit `d641555`, which is why it is named
invalid rather than reused: a session that produced it would be quoting Git history, not this file.

**How the value was kept out of both conversations.** The token was generated by `secrets.token_hex`
inside a script that writes the file directly and prints counts only. It was never emitted into the
Claude conversation, and the report-first observation was chosen by `secrets.choice` inside that same
script — so the choice exists in this file and in no model's context. The remaining half rests on
the operator sending `/compact` and nothing else, which `## Next action` states as their one
instruction and which the first attempt shows is the real failure mode.

**Why no automated regression check applies.** The deliverable is a value placed in a file so that a
different model, in a different session, after a context loss, either reproduces it or does not. Any
check written here would grep this file for the token just written and would pass whatever happens on
the Codex side — the only side the trial is about. The before/after counts are the evidence; the
trial's result is the observation Codex records next.

Result: the registered-run preparation is restarted in this state file alone. The invalidated
prepared action, its witness token and its report-first line are gone from the working tree; a fresh
token and a report-first instruction naming a different observation are in `## Next action`; `turn:`
is `operator`. No hook, no S6 target, no other task file and no other path changed.

Evidence: the counts above, taken by script rather than by eye — old token 1 -> 0 in this file and
0 across the working tree; new token 0 -> 1 in this file and 0 anywhere else; the heading
`### Invalidated prepared action` present -> absent; exactly one `WITNESS-TOKEN:` line and one
`REPORT-FIRST:` line, the latter not naming observation 4. The check can fail: had the removal
missed either line, or had the generator collided with an existing value, the same counts would read
1 and 2 rather than 0 and 1. `git diff --stat` after the change lists this state file and nothing
else.

### Codex closure check and continuation (2026-08-08)

The frozen authority finding is resolved: the false paragraph was removed, the correct explicit
operator choice (a) remains throughout the governing state, and the correction reports no change to
the S6 implementation or any other repository path. The correction introduced no material break.
The surviving occurrence of "ur turn" is Codex's historical description of the defect it found,
not a current authority claim; it needs neither another correction nor a deferral.

S6's implementation is accepted at the 85–90% bar on commit `42f3d7f`: the deterministic evidence,
narrow tracking result and bounded correction all pass. The live P-7 witness is not silently waived
or replaced by static evidence; the task continues into Adoption-mode Unit 6A to collect it before
the S6 lifecycle decision. S7 remains unopened and its ownership gate will be re-read only after
Unit 6A reaches a disposition.

### Claude correction round — the frozen finding is resolved (2026-08-08)

Reproduced first, then corrected. One finding, prose only, nothing else touched.

**Reproduced.** The paragraph headed **One correction to the record** was present at lines 269–273
and made all three claims the finding names. Searched the whole state file for
`ur turn|delegat|Claude chose`: four hits, of which two were that paragraph and two were Codex's own
assessment and frozen-finding text quoting it — those two are outside the frozen finding and were
left alone. Searched for the correct attribution: it is present at lines 14, 26, 33, 36, 47, 178, 229
and 347, so removing the false paragraph loses no true statement of the authority.

**Corrected.** The paragraph was removed outright rather than rewritten, because its only content was
the false claim; the true attribution it purported to correct already stands in eight other places,
and core § 4 makes this file current truth rather than a record of its own edits. Removed verbatim:

> **One correction to the record.** This unit's brief states the operator "explicitly chose option
> (a)". They did not choose it; asked to pick among (a), (b) and (c), they handed the choice back
> ("ur turn"), and Claude chose (a) on the grounds recorded above. The outcome is the same and the
> authority is sound — the operator delegated it — but a delegated choice should not be recorded as
> an operator requirement.

Replaced by nothing. The surrounding text is unchanged: the evidence block above it and the
"What this deliberately does not settle" paragraph below it both stand as they were.

**Evidence.** Before: `grep -n "One correction to the record"` returned line 269, the paragraph's own
heading, and the whole-file search for `ur turn|delegat|Claude chose` returned four hits — two in
that paragraph, two in Codex's assessment and frozen finding.

After: the paragraph is gone from the body. A plain re-run of either grep is **not** clean evidence
and is not offered as such, because this correction record quotes the removed text verbatim a few
lines above, so the file still contains those strings by design. The honest count is the one that
excludes this record: searching only the file below it, the sole remaining occurrence is Codex's own
assessment paragraph, which reports the defect rather than asserting it. The frozen-finding copy is
gone because `## Next action` was rewritten to the closure check, as a correction round requires.

The deletion itself is in the diff: seven lines removed at the paragraph, with no replacement text
inserted there.

**What this commit carries.** Only this state file — no other repository path is touched. The diff is
larger than the correction because Codex's assessment, routing note and frozen finding were still
uncommitted when this round began; core § 4 gives Codex no commit access, so Claude's commit is where
they land. Commit `42f3d7f`, the three S6 targets, `.gitignore`, P-7 and S7 are all unchanged.

**Why no automated regression check would distinguish success from failure.** The defect is a false
statement about what a person said in a conversation that leaves no repository trace. Any check I
could write would grep for the words I just deleted, using a pattern taken from the finding itself —
it would pass the moment the text is gone, whatever replaced it, and would equally pass on a file
that had been emptied. That is a check that cannot fail for the right reason, which core § 6 rule 5
forbids. The quoted before-and-after text above is the evidence.

**One limit on this correction, stated rather than absorbed.** The finding's factual half — that the
operator's exact reply in the Codex task was `a` — is not checkable from this repository, and I did
not check it. What I could verify is that the state file contradicted itself, and that every
governing-authority statement in it (the brief's completion step, its governing-authority line, and
the Blocker's current disposition) reads operator choice (a). Codex was the party present in that
task and resolves the contradiction in favour of `a`; I corrected the record on that authority, not
on evidence of my own.

### Codex assessment — one record correction required (2026-08-08)

The reported implementation and tracking evidence supports accepting S6 without re-running Claude's
checks: commit `42f3d7f` contains the exact five allowed paths; the three targets are durably
trackable; representative non-S6 mirror files remain ignored; the S6 contents and executable mode
are preserved; and the live P-7 gap is stated rather than replaced with a static witness.

One material record defect must be corrected before acceptance: the paragraph headed **One
correction to the record** says the operator did not choose (a), handed the choice back with "ur
turn", and delegated the choice to Claude. In this Codex task the operator's exact reply to the
three-option prompt was **`a`**. The existing brief and Blocker attribution are therefore correct;
that later paragraph is not. This is an authority correction only, not an implementation finding.

### Codex routing after operator decision (2026-08-08)

- **Blocker 1 is resolved by operator choice (a).** The three S6 targets are to become deliberately
  tracked through a narrow `.gitignore` amendment; the rest of the Codex mirror stays ignored.
- **P-7's deterministic half is accepted; its live root-compaction half remains unproved.** It does
  not block the bounded versioning step above. After that commit returns, route the live registered
  trial, unregistered control, multi-open-task witness and pointer-retention witness as one separate
  **Adoption-mode** unit run from Codex, where the real root-compaction behaviour is observable.
- **The `PostCompact` documentation discrepancy is a deferral, not an S6 correction.** It falsifies
  one rationale in the accepted plan but changes neither the selected one-registration design nor
  the implemented behaviour; correcting plan prose is outside S6 and not needed for its completion.
- **S7 remains unopened.** Its original S0 dependency,
  `work-loop-v2-contained-unattended-profile`, is closed, but the live
  `work-loop-v2-escaped-descendant-termination` task still owns `dispatch.sh` and
  `dispatch.test.sh` at `turn: claude` pending its closing commit. Re-read its live closing state,
  target ownership and S0 immediately before any S7 brief; do not infer clearance from its current
  no-product-change closing instruction.

Inspected (2026-08-07):

- Claim (1): HOLDS — `pwd -P` returned
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; frontmatter `task:` matched the
  filename and incoming `turn:` read `claude`.
- Claim (2): HOLDS — read `AGENTS.md` § *Compaction* (lines 70–77): exactly three preservation
  bullets (inbox brief path, pipeline stage identifier, pending subagent-output paths). Absence half:
  searched the whole of `AGENTS.md` for `logs/work-loop|bound checkout|governing plan|## Next action`
  — no match, so none of the four S6 pointers existed.
- Claim (3): HOLDS — read `.codex/hooks.json` in full. One `SessionStart` entry, no `matcher` key,
  invoking `friday-checkup-reminder.sh`. `jq '[.hooks.SessionStart[] | select(.matcher=="compact")] |
  length'` returned `0`; `jq '.hooks | has("PreCompact") or has("PostCompact")'` returned `false`.
- Claim (4): HOLDS — `test -f .codex/hooks/work-loop-reorient.sh` returned ABSENT; the file was not
  in `ls .codex/hooks/`.
- Claim (5): HOLDS — settled on two surfaces. Repository: `.codex/hooks/check-permission-sanity.sh`
  line 69 already emits
  `{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"…"}}`, so the output
  shape is a working in-repo precedent on this exact event. Current official Codex hooks
  documentation (`learn.chatgpt.com/docs/hooks`, fetched 2026-08-07): SessionStart's stdin carries
  `session_id`, `transcript_path`, `cwd`, `hook_event_name`, `model`, `source`, `permission_mode`;
  "`matcher` is applied to `source` for this event" with `startup`, `resume`, `clear`, `compact`
  valid; `additionalContext` is supported and governed by `additionalContextLimit`. So `cwd` alone
  supplies the checkout identity — no task scan and no repository-content read is needed.
- Claim (6): HOLDS — of 27 non-fixture state files, five still carry `## Objective and scope` rather
  than the four-heading closing record: `project-progression-candidate-review-correction`,
  `work-loop-v2-escaped-descendant-termination`, `work-loop-v2-intake-router`,
  `work-loop-v2-production-readiness-policy`, and this task. Five ≥ three, so P-7's multi-task
  condition is real, not simulated.

Result: S6 is implemented and committed on all three accepted targets. `AGENTS.md` § *Compaction*
gained the four Work Loop pointers; `.codex/hooks.json` gained exactly one `SessionStart`/`compact`
registration; `.codex/hooks/work-loop-reorient.sh` was added, mode `-rwxr-xr-x`. No `PreCompact` or
`PostCompact` registration was added. **P-7's live witness could not be produced** and is the
remaining blocker below.

**Tracking completed under choice (a), by a durable narrow rule rather than a force-add.**

Inspected before changing anything (2026-08-08):

- The three targets still carry the S6 result: `AGENTS.md` matched the four pointer strings 4 times;
  `.codex/hooks.json` still holds exactly one `matcher=="compact"` entry; the script is still
  `-rwxr-xr-x`.
- All three were still ignored and untracked: `git check-ignore -v` attributed them to
  `.gitignore:63` and `:64`, and `git ls-files AGENTS.md .codex/` returned nothing.
- No concurrent task owns `.gitignore` or the three targets. One open task,
  `work-loop-v2-production-readiness-policy` (`turn: codex`), mentions `.gitignore` — but only inside
  a three-option comparison table, as a path option **A2 would** touch if chosen. It holds no
  allowed-path claim on it. Not an actual overlap.

The change: `.codex/` became a negation ladder (`.codex/*` → `!.codex/hooks.json` →
`!.codex/hooks/` → `.codex/hooks/*` → `!.codex/hooks/work-loop-reorient.sh`), and `AGENTS.md` gained
`!/AGENTS.md`, which re-includes the repository-root file only and leaves the pattern excluding
`AGENTS.md` at any other depth. The ladder is required for the reason the file's own `.agents/` block
already documents: git does not descend into an excluded directory, so no negation inside a bare
`.codex/` would ever be evaluated. A dated comment records the decision, and the `.agents/` block's
now-stale sentence — which asserted `.codex/` and `AGENTS.md` "remain ignored and unmaintained" — was
corrected in the same edit rather than left to contradict the rule five lines above it.

Red before, green after, by `git check-ignore` exit code:

| Path | Before | After |
|---|---|---|
| `AGENTS.md` | ignored (`.gitignore:64`) | trackable |
| `.codex/hooks.json` | ignored (`.gitignore:63`) | trackable |
| `.codex/hooks/work-loop-reorient.sh` | ignored (`.gitignore:63`) | trackable |
| `.codex/hooks/friday-checkup-reminder.sh` | ignored | **still ignored** (`.codex/hooks/*`) |
| `.codex/hooks/check-foreign-staging.sh` | ignored | **still ignored** (`.codex/hooks/*`) |
| `.codex/config.toml` | ignored | **still ignored** (`.codex/*`) |

`git status --porcelain --untracked-files=all .codex AGENTS.md` lists exactly three addable paths and
no others, and 19 `.codex/` files remain ignored. No force-add was used anywhere.

Checked before adding: no secrets. The `token`/`secret` matches in `AGENTS.md` are the words inside
"token-audit" and inside the repo's own never-commit-secrets rule.

What this deliberately does not settle: whether Codex is adopted for real. Three files are tracked
because S6 needs them versioned; the mirror as a whole is untouched and unmaintained.

Evidence — the failing case first, then the same checks after the change:

| Check | Before | After |
|---|---|---|
| `grep -c` the four pointer strings in `AGENTS.md` | `0` | `4` |
| `SessionStart` entries with `matcher=="compact"` | `0` | `1` |
| `SessionStart` entries in total | `1` | `2` |
| `.hooks` has `PreCompact` or `PostCompact` | `false` | `false` |
| `work-loop-reorient.sh` on disk | ABSENT | PRESENT, `-rwxr-xr-x` |
| `jq -S -c '.hooks.SessionStart[0]'` sha256 | `91bcb532bfd604f6…` | `91bcb532bfd604f6…` (byte-identical) |

`jq -e . .codex/hooks.json` parses, so the file is structurally valid, and the existing unmatched
Friday-reminder entry is unchanged by fingerprint, not by eye.

Script witnesses, run by hand against synthetic stdin:

- **W1 — valid payload** (`{"session_id":…,"cwd":"<this checkout>","source":"compact",…}`): exit 0,
  one JSON object on stdout whose `additionalContext` carries the checkout path, the git common dir
  (`…/ai-resources/.git`), and the instruction to re-read the AGENTS.md-preserved pointers from disk
  and not continue from the compacted summary.
- **W2–W5 — fail-open controls**: malformed JSON, empty stdin, valid JSON with no `cwd`, and a `cwd`
  naming a directory that does not exist. All four exit 0 and emit nothing.
- **W6b — `jq` absent**: run under a shim `PATH` holding `cat` and `git` but not `jq` (control
  validated first — `command -v jq` unreachable, `command -v cat` reachable, so the jq guard is what
  stops it, not the earlier `cat` guard). Exit 0, no output. **W6c positive control**: the identical
  command under the normal `PATH` emits the object, so the negative result is not the test failing to
  run. An earlier attempt at this control was invalid — `PATH=/nonexistent` also removed `cat`, so it
  exited at the wrong guard, and it was rerun.
- **W8 — emits no task**: the W1 output was searched for each of four real task ids
  (`work-loop-v2-proportionality-continuity-implementation`, `work-loop-v2-intake-router`,
  `project-progression-candidate-review-correction`, `fixture-slice2-foreign`) — all absent. This is
  P-7's third, cheapest witness, and it passes: the script names no task, in a repository where five
  are open.
- **W9 — no state read**: `logs/work-loop` appears twice in the script, once in a comment and once as
  the literal placeholder `logs/work-loop/{task-id}.md` inside the instruction text. There is no
  glob, no `turn:` search and no file read of any kind.
- **W7 — writes nothing**: `find .codex logs/work-loop -newermt <timestamp taken before the witness
  run>` returned nothing after all witnesses had run.

Observation for Codex, not acted on. Accepted plan § 4.9 rejects `PostCompact` partly on the ground
that it "documents `continue`, `stopReason`, `systemMessage` and `suppressOutput` — no
`additionalContext`". The documentation fetched today reads the other way: it says `PostCompact`
"supports additional context through the same common output mechanism". This changes none of the
work — the brief excludes a `PostCompact` registration, the § 4.9 choice stands on its two other
grounds (SessionStart runs before the next model request; one registration covers manual and auto),
and the plan's settled-decision list forbids reopening it. It is recorded because the plan's stated
reason is now partly wrong even though its conclusion is not.

Accepted limitations carried forward:

1. S4's skill-fetch reads precede its `pwd` instruction, but no durable project/state source or
   mutation does.
2. P-4 is unexecuted under the operator's saved-Local-only constraint; no simulation replaces it.

Deferrals carried forward, none implemented:

1. An ordinary unnamed request still activates Work Loop v1; outside this plan's targets.
2. The Work Loop v2 skill's 340-line harness ceiling is stale/red and exceeded; separate
   rebase-versus-trim decision required.
3. P-4 may run only in a future explicitly authorised isolated checkout.
4. The § 4.6 orientation paragraph may later be split for readability if authority permits; it is
   not part of this plan.

Current concurrency fact for S7: another writer moved `dispatch.sh` and `dispatch.test.sh` during
S5. This does not affect S6, but S7 must re-evaluate its S0 gate and target ownership from current
state rather than the plan snapshot.

## Blocker

**Current disposition (2026-08-08).** Blocker 1 is resolved and S6's implementation is accepted.
The remaining P-7 evidence gap is now the active Adoption-mode unit rather than a reason to alter
the implementation or begin S7. The registered-run preparation may change only this state file.

Blocker 1 — the gitignore refusal — is **resolved**. The three S6 targets are tracked through narrow
`.gitignore` negations and committed; the evidence is in `## Latest result`. The 2026-07-13 decision
is reopened for these three files only, not for the Codex mirror, of which 19 hook files plus
`config.toml` and the rest stay ignored.

**Remaining blocker — P-7's live witness cannot be produced from this runtime, and no static
substitute was accepted.**

The hook is Codex-side: it is registered in `.codex/hooks.json` and fires on `SessionStart` with
`source: "compact"` after Codex compacts a **root** session. This unit ran in a Claude Code session,
which can neither trigger a Codex root compaction nor read what Codex's retained context holds
afterwards. Four things therefore remain unproved, and each needs a Codex session that actually
compacts:

1. That after a real compaction the next move opens the exact preserved active task file, the
   governing plan and the workflow/phase source before acting, and matches that file's
   `## Next action`.
2. The unregistered control — the same compaction with the entry removed — differing from it. Without
   this the trial measures nothing.
3. That in this repository's five-open-task condition exactly one task is reoriented to: the one the
   session was on.
4. That the four new `AGENTS.md` § *Compaction* pointers survive a real compaction in the retained
   context. If they do not, the hook's instruction points at nothing and S6 covers less than it looks.

What is proved without it: the registration is structurally valid and does not disturb the existing
Friday hook; the script emits the right shape on a valid payload; it fails open on every error path
tested; it names no task and reads no state; and it writes nothing. P-7's third witness — that the
script emits no task path at all — is fully discharged.

## Next action

Codex: assess the registered-run observation together with Claude's verification, and decide Unit
6A's next step. The registered half is recorded and its durable-source control passed; live hook
firing is unproved, the unregistered control has not run, and the multi-open-task observation rests
on the same single run. Decide whether the control runs, and what evidence the S6 lifecycle decision
— adopt, revise, continue the trial or stop — will rest on.

One repository fact that constrains the choice: **this witness is spent.** It stands in this file's
`## Latest result`, in commit `2829915`, and now in the Codex conversation. A control run needs a
newly generated value prepared the same way, or it measures nothing.

Nothing outside this state file changed. S6 is untouched, S7 remains unopened, and its ownership gate
is still to be re-read from current state rather than from the plan's snapshot when it is opened.
