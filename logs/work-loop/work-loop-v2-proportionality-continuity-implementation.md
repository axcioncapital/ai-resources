---
task: work-loop-v2-proportionality-continuity-implementation
turn: operator
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S6 only**: add the accepted post-compaction preservation pointers, one
`SessionStart`/`compact` registration, and its small fail-open reorientation script.

Excluded are S7; changes to S1–S5; edits to the executable core, Claude command, Work Loop skill,
harness, fixtures, dispatcher or another task file; `PreCompact` or `PostCompact` registration; a
task scan, task registry, phase copy, new state field, cached summary or second hook; installation,
propagation, worktrees, branches, pushes and unrelated cleanup.

## Lane and unit

Standard. Implementation mode. Unit 6 — accepted plan slice S6: post-compaction reorientation.

Named reason for the loop: this hook runs at a continuity boundary across every root compaction in
the repository, so its scope and fail-open evidence need independent assessment before it counts.

## Brief

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

Result: S6 is implemented on disk on all three accepted targets, and **none of the three can be
committed** — `git add` refused them, because `.gitignore` lines 56–64 deliberately exclude `.codex/`
and `AGENTS.md` by a recorded operator decision. That is the first blocker below and it goes to the
operator, not to Codex. **P-7's live witness could not be produced either**, and is the second
blocker. `AGENTS.md` § *Compaction* gained the four Work Loop pointers; `.codex/hooks.json` gained
exactly one `SessionStart`/`compact` registration; `.codex/hooks/work-loop-reorient.sh` was added,
mode `-rwxr-xr-x`. No `PreCompact` or `PostCompact` registration was added. Only this state file is
committed by this invocation.

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

**Blocker 1 — S6's three targets are gitignored by a recorded operator decision, so the slice cannot
be committed. This is the operator's call, not Codex's.**

`git add AGENTS.md .codex/hooks.json .codex/hooks/work-loop-reorient.sh` was refused.
`git check-ignore -v` attributes it to `.gitignore:63` (`.codex/`) and `.gitignore:64` (`AGENTS.md`).
`git ls-files` returns nothing for either path, so they have never been tracked. The rule's own
comment (lines 56–62) states the ground, dated **operator call, 2026-07-13 S12**: the Codex mirror is
an "operator experiment, NOT a maintained artifact", it was ignored "so it cannot be committed by
accident", and — the decisive sentence — "If Codex is ever adopted for real, the decision to track
and sync this mirror is a deliberate one to make — not an outcome of a wildcard staging command."

Committing S6 needs `git add -f`, which is exactly the deliberate act that comment reserves for the
operator. Core § 7 sends this to them: proceeding would reopen a settled decision. Nothing was forced
and nothing was reverted.

Three facts the decision turns on:

1. **The implementation is live on disk regardless of git.** Codex reads `.codex/hooks.json` from the
   filesystem, so the reorientation hook fires in this repository now, tracked or not.
2. **Untracked means unprotected.** The three files are invisible to `git status`, carried by no
   commit, and would be destroyed by a `git clean -x`. S6 would silently cease to exist.
3. **The accepted plan did not notice this.** Its § 9 lists `ai-resources/.codex/hooks.json` and
   `ai-resources/AGENTS.md` under "files this plan authorises changes to", and its § 8 rollout assumes
   each slice ships as a revertible commit. For S6 there is no commit to revert.

The operator's choice, in plain terms: **(a)** track these three paths — narrow `.gitignore`
negations for `AGENTS.md`, `.codex/hooks.json` and `.codex/hooks/`, leaving the rest of the mirror
ignored, which also reopens the 2026-07-13 "is Codex adopted for real" question; **(b)** leave them
untracked and accept S6 as a live-but-unversioned change, recorded as a limitation; or **(c)** revert
the three on-disk changes and park S6 until the tracking question is settled on its own.

**Blocker 2 — P-7's live witness cannot be produced from this runtime, and no static substitute was
accepted.**

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

**Operator: choose (a), (b) or (c) under Blocker 1** — whether `AGENTS.md`, `.codex/hooks.json` and
`.codex/hooks/work-loop-reorient.sh` become tracked files. S6 is written and working on disk but
cannot be committed without `git add -f`, which would override your 2026-07-13 decision to keep the
Codex mirror out of the repository. Nothing has been forced and nothing reverted; the three files are
sitting untracked in the working tree.

Once that is settled, the turn returns to Codex, which still has three things to assess: whether S6
ships accepted-with-a-limitation and P-7's live witness becomes its own Adoption-mode unit run from
the Codex side, or whether S6 stays open until that compaction can be staged; whether the
`PostCompact` documentation discrepancy recorded in `## Latest result` is a deferral or a correction
to the accepted plan; and S7's S0 gate, which must be re-evaluated from current state because another
writer moved `dispatch.sh` and `dispatch.test.sh` during S5.
