---
name: reorient
description: "Reconstructs the active Work Loop v2 state after Codex context compaction or suspected context degradation, using durable repository evidence before any continuation. Use when the user invokes $reorient or asks to reorient after compaction. Do not use for routine session starts or non-Work-Loop work."
---

# Reorient

Re-establish the current Work Loop v2 state from durable repository evidence.
Treat compacted conversation as navigation only, never as authority.

## Workflow

### 1. Verify the checkout and reload Work Loop v2

Run `pwd` on its own before reading anything else. The directory actually open
determines which checkout and task state can be authoritative.

Read the complete `work-loop-v2` skill available in the current scope. Follow
its executable-core resolver and current instructions; where this skill and
Work Loop v2 disagree, Work Loop v2 wins and the difference is a defect to
report.

Re-establish the role split from that authority:

- The operator owns intent, priorities, business judgment, scope, and
  consequential decisions.
- Codex owns context and session control, instruction quality, independent
  review, drift prevention, and protection of project value.
- Claude owns live repository investigation, technical design,
  implementation, tests, technical evidence, and commits.

Do not take over Claude's technical role because conversational context was
compacted.

### 2. Resolve the authoritative task without guessing

Resolve the task by the routes below, in order. **An unavailable route is not a
failure** — it advances to the next route. A route that is available but fails
any of its validations stops reorientation immediately, and no later route may
be tried after a validation failure.

**First — the preserved path.** Use the exact active `logs/work-loop/{task-id}.md`
path and bound checkout preserved through compaction. Verify that the path is
inside the checkout reported by `pwd`. This is the primary route; the fallback
below applies only when it is unavailable.

**Second — a strictly validated checkout declaration.** Only if the exact path
did not survive, read this checkout's `logs/work-loop/.owner`. It is one
gitignored line, `{task-id} {YYYY-MM-DD}`. Accept the task id it names **only
when every one of these passes**:

1. The file **exists** and holds exactly one task id and one claim date, in that
   shape. If there is no declaration, the fallback does not apply — go to
   *Third* and stop. There is no id to validate, and nothing downstream may
   stand in for one.
2. `logs/scripts/work-loop-owner.sh check --depth local --checkout {pwd} --task {declared-id}`
   returns `PROCEED`. `REFUSE` or `AMBIGUOUS` ends reorientation. Where the
   checkout does not carry that script, make the same reads by hand — they are
   plain file reads and need no git. **Read this verdict only as confirmation of
   an id you already read in check 1.** The same command answers `PROCEED` for a
   checkout that declares no writer at all, so a bare `PROCEED` is not evidence
   that a task exists.
3. `logs/work-loop/{declared-id}.md` exists in this checkout.
4. That file's frontmatter `task:` is identical to the declared id.
5. Its `turn:` is present and is one of `claude`, `codex`, `operator`.
6. `turn:` is not `operator`. A closed task's declaration is stale, not a
   pointer to resume from.

Any failure stops reorientation with the specific check named. Every check above
is local to this checkout and runs no git, which is what keeps the fallback
inside Codex's authority.

**What the fallback does not establish.** It cannot tell you whether this task is
also claimed in another checkout, or whether its state file is replicated — both
need `git worktree list`. Those are repository-depth checks owned by Claude at
its Step 1 and by the dispatcher at admission, and recovering a pointer here does
not substitute for them. State that residual plainly when you report.

**Third — stop.** If neither route establishes the task, stop. Do not scan
`logs/work-loop/`, choose the newest file, select among candidates, infer a task
from branch names, or create replacement state. Ask the operator for the missing
task id or path. The fallback recovers *one declared* task; it never discovers a
task.

If an unattended run may be active, use the Work Loop dispatcher's read-only
`--status` operation before reading or touching task state. Never edit a task
file while a run is in flight.

### 3. Read the minimum authoritative context

Read only what is needed to establish the next justified move, in this order:

1. Permanent repository and agent instructions, plus the canonical Work Loop
   v2 skill and executable core.
2. The exact current task state file.
3. The governing approved project plan or specification named by that state.
4. The latest validated handoff or authoritative current-state source named by
   the plan or task.
5. Decisions, constraints, blockers, accepted limitations, and explicitly
   deferred work that bear on the current task.
6. Existing technical evidence needed to establish what happened.

Stop expanding the read set once objective, state, current task, constraints,
and next action are established. Do not create a new plan when an approved plan
already exists.

Codex does not run git under Work Loop v2. If branch, status, recent-change, or
diff evidence is load-bearing and is not already durable, have Claude inspect
it and return technical evidence through the existing Work Loop interface.

### 4. Reconcile memory against evidence

Compare the compacted understanding with the sources. Explicitly correct every
material mismatch involving:

- objective or current task;
- completed versus incomplete work;
- approved scope or next action;
- operator decisions and constraints;
- deferred work;
- implementation status;
- blockers or unresolved issues.

Repository evidence outranks conversational memory. Discard a compacted
assumption that conflicts with evidence. If evidence is missing or
contradictory, label the uncertainty and resolve it through repository evidence
or Claude's live inspection; do not silently fill the gap.

### 5. Check for drift

Before directing Claude, verify that the intended next action:

- directly advances the approved objective and remains inside scope;
- does not add unnecessary architecture, governance, abstraction, ceremony,
  or permanent machinery;
- does not reopen settled decisions without new evidence;
- does not promote deferred work into the current task;
- does not confuse an implementation detail with the project objective;
- does not duplicate completed work;
- is consistent with Work Loop v2.

### 6. Reconstruct and resume

Internally establish:

- **Objective:** the outcome currently being pursued.
- **Current state:** what evidence shows is complete.
- **Current task:** the specific problem open now.
- **Next action:** the smallest justified next step.
- **Constraints:** decisions and boundaries that remain binding.
- **Evidence:** the exact sources supporting the reconstruction.
- **Open issues:** unresolved uncertainty or blockers.

Only after this reconstruction may Codex issue another instruction. Give Claude
only the context needed for the immediate task and continue through the
existing Work Loop state file. Do not create a parallel handoff, state record,
plan, or summary file.

## Output Contract

Report briefly in this shape:

```text
REORIENTED

- Objective:
- Current task:
- Verified state:
- Next action:
- Key constraints:
- Drift detected: Yes / No
- Evidence consulted:
```

Name material memory corrections or unresolved contradictions directly in the
relevant field. After the block, follow Work Loop v2's seam rule and end with
the explicit `Next:` instruction for the actor whose turn it actually is.

## Failure Behavior

- Missing exact task path or checkout binding: try the validated `.owner`
  fallback in Step 2, and stop and ask the operator if any of its checks fails;
  do not search for a likely task either way.
- A `.owner` declaration that is unreadable, holds more than one id, has no
  matching state file, or names a closed task: stop and report which check
  failed. Never repair or delete the declaration from here — this skill is
  read-only.
- Missing or contradictory authority: identify the precise conflict and obtain
  repository evidence or Claude inspection before continuing.
- Live unattended run: report its status and do not edit task state.
- False compacted premise: correct it openly and follow the durable evidence.
- No active Work Loop task: say so and route the user's request normally; do
  not manufacture continuity.

Prefer an explicit gap over a plausible inference. Challenge a stale or false
premise and prioritize accuracy over completeness.

## Known Pitfalls

- Treating the compacted summary as current state.
- Selecting a task by modification time or filename similarity.
- Re-running completed work because completion evidence was not re-read.
- Turning reorientation into a new planning or governance layer.
- Asking Claude to continue before the current turn and next action are
  verified.
- Running git directly instead of preserving the Work Loop role boundary.

## Validation Loop

Before reporting `REORIENTED`, confirm that every output field is supported by
an exact source, the task file belongs to the verified checkout, the intended
next action matches the current `turn:`, and no new file or state system was
created. If any check fails, use Failure Behavior instead of reporting success.

## Example

Input: `Use $reorient after the compaction.`

Expected behavior: verify `pwd`, reload Work Loop v2, read the preserved exact
task path and its governing sources, reconcile compacted memory, report the
seven fields, and end with the actor-correct `Next:` line.

## Runtime Recommendations

Keep this skill instruction-only and read-only. Use the current Codex session
model; do not declare a model default. The companion compaction hook may point
to preserved task identifiers, but it does not reconstruct state—this skill
performs that judgment from the authoritative sources.
