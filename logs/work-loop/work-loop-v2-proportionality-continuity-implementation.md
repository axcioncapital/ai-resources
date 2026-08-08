---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S6 only**: complete the accepted post-compaction slice under the operator's
2026-08-08 choice (a) by making its three implemented targets deliberately tracked without adopting
the rest of the Codex mirror.

Excluded are S7; changes to S1–S5; edits to the executable core, Claude command, Work Loop skill,
harness, fixtures, dispatcher or another task file; any `.codex/` path except the two exact S6
targets; `PreCompact` or `PostCompact` registration; a task scan, task registry, phase copy, new
state field, cached summary or second hook; installation, propagation, worktrees, branches, pushes
and unrelated cleanup.

## Lane and unit

Standard. Implementation mode. Unit 6 — complete accepted plan slice S6 by deliberately tracking
its three implemented targets under operator choice (a).

Named reason for the loop: this hook runs at a continuity boundary across every root compaction in
the repository, so its scope and fail-open evidence need independent assessment before it counts.

## Brief

### Current completion step — operator choice (a), 2026-08-08

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

**One correction to the record.** This unit's brief states the operator "explicitly chose option
(a)". They did not choose it; asked to pick among (a), (b) and (c), they handed the choice back
("ur turn"), and Claude chose (a) on the grounds recorded above. The outcome is the same and the
authority is sound — the operator delegated it — but a delegated choice should not be recorded as an
operator requirement.

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

**Current disposition (2026-08-08).** Blocker 1 is resolved by the operator's explicit choice (a)
and is now the bounded completion step in `## Brief`. Blocker 2 remains an evidence gap, routed to a
later Adoption-mode live trial; it does not authorise a static substitute or S7 work. The detailed
evidence below is retained because Claude needs it to make the tracking change without broadening
the 2026-07-13 decision.

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

Codex: assess S6, now that its three targets are tracked and committed.

The tracking step is done as briefed — a durable narrow rule, no force-add, exactly five paths in one
commit, with the fail-capable before/after table in `## Latest result`. Four things warrant your
judgment. First, whether S6 now ships accepted-with-a-limitation, with P-7's live compaction witness
becoming its own Adoption-mode unit run from the Codex side, or whether S6 stays open until that
compaction can be staged. Second, the record correction noted in `## Latest result`: the operator
delegated choice (a) rather than choosing it, and this unit's brief recorded it as an explicit
operator choice — decide whether the brief is corrected or the note suffices. Third, the `PostCompact`
documentation discrepancy: the accepted plan's stated reason for rejecting that event no longer
matches current documentation, though its conclusion is unaffected — a deferral or a plan correction.
Fourth, S7's S0 gate must be re-evaluated from current state, because another writer moved
`dispatch.sh` and `dispatch.test.sh` during S5 and both are still dirty in the tree.
