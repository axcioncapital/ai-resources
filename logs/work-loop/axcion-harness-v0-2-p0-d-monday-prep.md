---
task: axcion-harness-v0-2-p0-d-monday-prep
turn: claude
---

## Objective and scope

Sever `/monday-prep` from the retired Axcíon Harness session-state surface before root P0-D
retires that surface. The command must stop presenting `harness/CHANGELOG.md` and
`harness/session/` as current harness state, and must write future week mandates to the live
workspace path `logs/week-mandates/week-mandate-{WEEK}.md` instead of
`harness/session/week-mandate-{WEEK}.md`, while preserving the cadence's confirmation and logging
behavior.

This task is bound only to the Local `ai-resources` checkout at
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. Implementation scope is
`.claude/commands/monday-prep.md`; the administrative path is this state file. The workspace-root
checkout is read-only. Excluded: executing `/monday-prep`; creating a real week mandate; changing
any root file; `session-start.md`; cadence/reference documentation; retired harness content; root
P0-D implementation; unrelated dirty work; pushing, merging, deleting, or creating a worktree.

## Lane and unit

Standard. Implementation mode. Unit 1 — remove `/monday-prep` B11/C14's active reader/writer
coupling to retired harness state and redirect the weekly output without changing the rest of the
cadence.

Named reason for the loop: this cross-repository dependency gates a destructive root P0-D unit and
needs its own checkout binding, commit boundary, fail-capable evidence, and independent assessment
before the root surface can be removed.

## Brief

**Why this unit now.** Root task
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/work-loop/axcion-harness-v0-2-phase0-p0-d.md`
is authoritative for the dependency. It records the operator's G3 choice (a), lifting the standing
no-nested-binding instruction for exactly this separately bound `/monday-prep` flow. The root task
stays paused until this dependency is accepted. P0-C and the old closed task remain closed and must
not be modified or reassessed.

**Authority and dispositions.** Verify each source before relying on it:

- The root P0-D state must still record G3 choice (a), the corrected two-flow sequence, and the
  nested dependency preceding root Unit 2. It governs why this task exists but is read-only here.
- The Work Loop v2 executable core resolved from this exact nested checkout governs the unit. Claude
  checks repository reality, implements, records the handback, and makes the commit; Codex assesses.
- `.claude/commands/monday-prep.md` is the only implementation target. Its current B11/C14 text is
  repository reality, not authority to preserve the retired path.
- `logs/week-mandates/` at workspace root is a **Codex framing decision** for this unit: it preserves
  week scope under the live root `logs/` namespace and is reversible. The command must create the
  directory before a future write; this unit must not create it or execute the command.
- `docs/weekly-cadence.md`, `docs/weekly-session-guide.md`, and `docs/session-rituals.md` still name
  the old destination. They are a recorded deferral, not hidden scope: G3 authorized the bounded
  command dependency described in the accepted design. Do not edit them in this unit.
- Historical logs, plans, memory indexes, and retired harness files are non-governing background.

**Check against the repository before editing.** Each numbered item is a verify-first claim. A
materially false claim requires a handback instead of a silent repair.

1. Confirm `pwd -P` and Git top-level both equal the exact nested checkout above. Validate this
   state file's task id, headings, `turn: claude`, and path before changing anything. Inspect nested
   and root dirty/staged state read-only; preserve every pre-existing unrelated path and do not
   bypass any guard.
2. Confirm the root P0-D state still carries the operator decision and dependency order described
   above. Stop if it has been superseded, closed, or no longer authorizes this flow.
3. In `.claude/commands/monday-prep.md`, confirm the current red control: one `HARNESS=` constant;
   B11 reads both `$HARNESS/CHANGELOG.md` and `$HARNESS/session/`; C14 names
   `$HARNESS/session/week-mandate-{WEEK}.md`. The bounded command should therefore produce four
   matching lines for `rg -n 'HARNESS=|\$HARNESS|harness/session|harness/CHANGELOG'` before the edit.
4. Search active `.claude/commands/` for `week-mandate`, `harness/session`, and the C14 destination.
   The premise is that no active command other than `/monday-prep` consumes a week mandate from the
   old path; `session-start.md` only contains an inert format-boundary note. Report the searched
   surface. Stop if another active reader/writer makes this command-only change unsafe.
5. Confirm the command's post-C14 flow: its confirmation loop, optional session-plan scaffold, D16
   session-notes append, D17 scoped commit behavior, and final summary. These behaviors must survive
   the edit. Confirm whether `HARNESS` has any remaining use after B11/C14 are changed before
   deleting the constant.
6. Confirm the root `logs/week-mandates/` directory does not presently exist and that the proposed
   destination does not collide with an existing file or conflicting active convention. Absence
   must name the searched root surfaces. The absent directory is expected and is handled by a
   command-level `mkdir -p`; do not create it during implementation.

**Implement only if the claims hold.** Make the smallest coherent edit within
`.claude/commands/monday-prep.md`:

- Replace B11's current-state inspection with a retirement-boundary/status step that may read the
  root `harness/README.md`, but never reads or summarizes `harness/CHANGELOG.md` or
  `harness/session/` as operational state. Keep the numbered cadence coherent.
- Set C14's full path to
  `$WORKSPACE/logs/week-mandates/week-mandate-{WEEK}.md` and ensure the destination directory is
  created immediately before the future existence/write flow. Preserve the existing
  overwrite/edit/skip confirmation semantics.
- Remove the `HARNESS` constant if it becomes unused. Adjust labels and references later in this
  same command only where needed to keep B11, D16, and the final summary internally accurate.
- Do not execute the command: it performs `git pull`, prompts the operator, may repair symlinks,
  writes logs and a mandate, and may commit. Structural verification is the proportional evidence
  for this Markdown command change.

**Required fail-capable evidence.** Record exact commands and decisive output in `## Latest result`:

- Failing case: the four-line red control from claim 3, plus the exact B11/C14 anchors before edit.
- Implemented result: the same search returns no `HARNESS=`, `$HARNESS`, `harness/session`, or
  `harness/CHANGELOG` hit in the command; exactly one live destination names
  `$WORKSPACE/logs/week-mandates/week-mandate-{WEEK}.md`; and the adjacent directory-creation step
  is present.
- Regression protection: structural checks show B11 still produces a status for D16, the C14
  approval loop retains `y / edit / skip` and overwrite protection, C15 still forbids inline
  `/session-plan`, D16 still appends the mandate path to `logs/session-notes.md`, and D17 still stages
  only cadence-produced changes. State why no live invocation or fresh-session check is warranted.
- Containment: root dirty/staged state is unchanged from the pre-edit snapshot; the nested staged
  path list immediately before commit is exactly `.claude/commands/monday-prep.md` and
  `logs/work-loop/axcion-harness-v0-2-p0-d-monday-prep.md`. Show the exact list, not merely a clean
  exit status.

**Completion condition.** The command meets the implemented-result and regression checks; no root
file or excluded nested file changed; `## Latest result` records the evidence and the known active-doc
deferral; this file is set to `turn: codex`; and Claude makes one nested-repository commit containing
exactly the command and this state file. Stop and hand back to Codex if a verify-first claim is
false, an additional implementation file is necessary, the destination conflicts with an active
convention, the required evidence cannot be produced, or unrelated dirty work prevents exact
containment. Stop for the operator if proceeding would reopen the approved boundary or require a
hard-to-reverse decision.

**Adjacent work held back.** Updating the three active cadence/reference documents to the new
destination; the inert `session-start.md` note; root P0-D archival/deletion work; optional local
`HARNESS_*` cleanup; Work Loop v1; P0-F permission/launch work; and all Phase 1+ harness work. These
are not part of this unit because they have separate authorization or exit conditions.

## Latest result

Cancelled before implementation by the operator on 2026-08-09: `/monday-prep` is no longer in use,
so changing its retired-harness reader/writer paths does not advance the live Axcíon Harness v0.2
critical path. No command, root path, or runtime behavior was changed.

## Blocker

None.

## Next action

Close the task:

Record the outcome as cancelled before implementation because `/monday-prep` is unused and the
operator redirected priority to making Harness v0.2 live. Record the unimplemented command cleanup
and its stale documentation references as an accepted, non-gating limitation. Evidence is this
operator decision and the absence of any implementation result or target-file change. Then reduce
this file to the four-section closing record, set `turn: operator`, and commit only this state file;
do not edit `.claude/commands/monday-prep.md` or any root path.
