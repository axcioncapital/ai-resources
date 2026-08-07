---
task: work-loop-v2-proportionality-continuity-plan
turn: codex
---

## Objective and scope

Produce one implementation-ready plan at
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`
for correcting Work Loop v2's excessive ceremony, over-broad Codex activation, checkout/worktree
handoff failures, concurrent-session conflicts, compaction drift, fresh-Codex-task continuity, and
project-pipeline orientation.

The plan must identify the smallest coherent changes and proof needed. It must not implement those
changes. Scope is limited to creating the plan and updating this task-state file. Existing source
files, hooks, commands, skills, tests, logs, and in-flight changes are read-only for this unit.

## Lane and unit

Standard. Implementation mode. Unit 1 — write the implementation-ready plan.

Named reason for the loop: the change coordinates several deployed Work Loop resources, will be
implemented in a later session, and needs Codex assessment of the plan before it becomes execution
authority.

## Brief

The deployed core already promises Direct Work, non-ceremonial testing, and a good-enough quality
bar, but the current entrypoint and transport behavior can defeat those promises. The operator has
settled the target: do only what is necessary for a useful 85–90% result, keep ordinary work local,
and make continuity durable across actors and sessions. This unit advances that target by producing
the implementation blueprint only; no Work Loop source changes belong in it.

### Governing operator decisions

Current operator decisions from 2026-08-07 govern this unit:

- Do only the tasks needed to make the current thing work. Aim for an 85–90% useful result; absolute
  perfection is not required.
- Skip unnecessary ceremony and duplicated testing across Codex and Claude.
- Separate worktrees are normally justified only for a big implementation. Concurrent work in
  different projects must be supported without forcing worktrees; same-repository collision risk,
  unattended work, and genuinely large work may still justify isolation.
- Work Loop v2 must not load automatically for unrelated ordinary work.
- After compaction, Codex must recover from durable authoritative context rather than drift from a
  lossy summary.
- Each Codex-side handoff that starts a new Codex task must prepare a clean handoff. The new task must
  read the implementation plan and other named durable sources rather than rely on inherited memory.
  Routine Claude ↔ Codex turns already carried by the task-state file must not multiply visible tasks
  merely for ceremony.
- Project orientation must determine the owning project, approved outcome and current priority,
  authoritative current-state source, governing specialist workflow, active phase, completed phases
  and accepted decisions, blockers and operator gates, work ready now, and work that is premature or
  unauthorized. The operator-facing result is short:
  `Current position → governing workflow and phase → what is ready → what is blocked → recommended
  next unit → why it matters.`

### Required outcome

Write an implementation plan that:

1. States the verified root causes and distinguishes defects in executable behavior from already-lean
   intent in the core.
2. Gives the exact files and sections to amend, with one owner for each behavior and no duplicated
   rules.
3. Narrows Codex skill activation. The plan must define positive triggers and explicit non-triggers,
   and must avoid loading the executable core before Work Loop ownership actually requires it where
   the harness permits that sequencing.
4. Makes proportionality enforceable: minimum necessary work, the 85–90% target, no adjacent
   improvements, evidence scaled to consequence, and no perfection pass.
5. Assigns implementation verification once: Claude runs the relevant checks and reports evidence;
   Codex normally assesses that evidence without rerunning routine checks. Specify the narrow
   conditions that justify Codex reproduction.
6. Removes mandatory red/green or regression ceremony where no meaningful failing witness exists,
   especially for prose and documentation, while retaining evidence that could expose failure.
7. Adds the requested short project-pipeline orientation at continuation, fresh-task,
   post-compaction, and material-context-change boundaries without adding an artifact, stage,
   checklist, or second project-state system. Reuse existing orientation logic where appropriate and
   preserve the boundary with `/project-next-steps`.
8. Selects and binds the execution checkout before the task file or actor handoff is created. Both
   Codex and Claude must receive and verify the exact checkout and task path. A mismatch stops; the
   task file is never copied to another checkout as a repair.
9. Defines concurrency behavior for several simultaneous Work Loops: different repositories remain
   isolated and may use their local checkouts; concurrent writers in one repository receive
   deliberate isolation. Locks, run IDs, run evidence, hooks, and other runtime state must not collide
   across repositories or sessions.
10. Uses current supported Codex compaction hooks to re-inject a concise durable-source reorientation
    instruction after manual or automatic compaction. The plan must preserve the exact active task
    path, checkout, governing plan, workflow/phase, and next action without creating a scratchpad or
    second state system.
11. Defines a clean new-Codex-task handoff. Prefer a genuinely fresh task over a transcript-preserving
    fork, explicitly select local versus worktree according to the policy above, verify the expected
    working directory, and make the first action read the named plan/state/workflow sources. Where a
    fresh app task cannot target an existing worktree exactly, name a supported fallback rather than
    silently creating a different worktree.
12. Includes ordered implementation slices, dependencies on current in-flight Work Loop work,
    migration/rollout considerations, hook trust implications, and proof cases that can actually fail.
13. Ends with an implementation handoff that a fresh Claude session can execute without reconstructing
    decisions from this conversation.

### Claims Claude must verify before planning

Treat each as a repository or product claim to check, not as fact:

1. In `.agents/skills/work-loop-v2/SKILL.md`, search the frontmatter description for
   `Use whenever work is described without naming the capability to use`, and inspect the opening
   instruction that requires the executable core before the first move.
2. In `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, inspect §2, the Implementation
   mode rules, the good-enough judgment, and safety rule 5. Establish precisely where it already says
   Direct Work is the default, ceremonial tests are unnecessary, pilot quality is enough, and a
   failing case is mandatory.
3. In `.claude/commands/work-loop-v2.md`, inspect the inspection-record contract and Implementation
   evidence requirements. Establish which verification work is mandatory on every run today.
4. In `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`, inspect CE-9 and CE-15; in the Codex
   skill inspect the fresh-thread and `continue this project` behavior. Establish what durable
   orientation and single-handoff behavior already exist before proposing additions.
5. In `.claude/commands/project-next-steps.md`, inspect the token-lean current-position/readiness
   cascade and its ownership boundary. Determine what can be reused without merging the two
   capabilities.
6. In `.codex/hooks.json` and `.codex/config.toml`, search for
   `PreCompact|PostCompact|compact|SessionStart`. Establish the current project hook coverage.
   Verify current official OpenAI Codex documentation for compaction hook events, their matcher/input
   semantics, post-compaction context injection, skill implicit activation, fresh tasks/forks, and
   local/worktree behavior before making any mechanism normative.
7. In `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, inspect checkout/task
   validation, the lock key, default log directory, run-ID construction, and actor working-directory
   launch. Establish what is already checkout-scoped and what can still collide or become invisible
   across projects, worktrees, or concurrent runs.
8. Inspect the existing Work Loop state files and current working tree before selecting amendment
   targets. There are pre-existing and potentially concurrent edits in this checkout; do not overwrite,
   reformat, stage, or commit any path outside this unit's plan and state file.

If a claim is false, do not force the proposed mechanism through. Record the evidence in this file,
set `turn: codex`, and hand back so the plan can be reframed.

### Constraints and non-adoptions

- Prefer amendments to existing owners over new resources.
- Add no new command, risk registry, alignment gate, QC stage, state field, session diary, context
  pack, handoff document, workflow state machine, or maintained project-phase copy.
- Relevant failure modes should enter existing constraints, evidence, and stop conditions only when
  material; do not create a mandatory `Activated failure modes` field.
- Plan/state/brief remain the semantic continuity system. Operational run evidence may exist but must
  not become competing task truth.
- Do not prescribe broad test suites. Specify the smallest proof that distinguishes success from
  failure for each change.
- Do not edit or implement the target resources in this unit.
- Do not disturb existing uncommitted or concurrently produced work. Stage and commit only the new
  plan and this exact task-state file by explicit path.

### Evidence required

- Before: confirm the target implementation-plan path does not already contain an implementation
  plan for this objective.
- After: the plan exists at the exact target path and contains a requirement-to-owner map, exact
  amendment targets, ordered slices, non-adoptions, risks/dependencies, and realistic failing proof
  cases for false activation, duplicate verification, prose-test ceremony, wrong-checkout handoff,
  cross-project concurrency, same-repository concurrency, post-compaction recovery, fresh-task
  recovery, and project orientation.
- Demonstrate by targeted reads/searches that every governing operator decision above is represented
  and that the plan implements none of the target changes.
- State explicitly why no automated regression test is meaningful for this planning-only artifact;
  the fail-capable check is the requirement/evidence matrix and the absence of source edits.
- Commit only the plan and this task-state file, then record the commit and evidence here.

### Completion condition

The new plan is specific enough for a fresh Claude implementation session to execute without design
guessing, remains proportionate to the demonstrated failures, and leaves all implementation for the
next Work Loop task. This file records the result and evidence, names any limitation or blocker, and
ends at `turn: codex`.

### Stop if

- A governing source or current in-flight change materially conflicts with an operator decision above.
- The target plan or task path is claimed by another live session.
- A required mechanism is unsupported by current official Codex behavior.
- Producing an implementation-ready plan would require editing target source files or resolving a
  consequential product/authority decision on the operator's behalf.
- Existing concurrent edits make the relevant current state impossible to establish without risking
  overwrite.

## Latest result

Inspected (2026-08-07):

- Claim (1): HOLDS — read `.agents/skills/work-loop-v2/SKILL.md`; the frontmatter `description` (line 3)
  ends "Use whenever work is described without naming the capability to use, including 'continue this
  project'." The opening instruction (line 10) reads "Read
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` **before your first move in any task**",
  and the skill's own first move is Routing step 1 (line 119), whose outcome is usually another owner.
- Claim (2): HOLDS — read `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. § 2 line 40:
  "**Direct Work is the default.**" § 3 lines 130–131: "**Implementation does not demand ceremonial
  tests.** Where a change has no meaningful regression check, say so and say why…". § 3 lines 142–146
  (*The "good enough, proceed" judgment*): "The quality bar is pilot quality with limitations written
  down, not completeness." § 6 rule 5, lines 430–431: "**Evidence must be able to fail.** … Build the
  failing case first, then show it passing." The core's intent is already lean; no 85–90% target and no
  minimum-necessary-work statement is present anywhere in it — searched the whole file for `85`, `90`,
  `minimum`, `perfection`; no match.
- Claim (3): HOLDS — read `.claude/commands/work-loop-v2.md`. Line 50 binds the inspection record to the
  acceptance harness (`logs/scripts/work-loop-v2-slice-1.test.sh`, present, 84804 bytes, executable), and
  Step 2 requires a line for **every** claim on **every** run, including claims that hold. Line 89 states
  Implementation evidence as "the failing case, the implemented result, and the regression protection",
  with the no-meaningful-check relief in the same sentence. Searched the file for `prose`, `documentation`,
  `docs` — no match, so the relief clause names no standard case.
- Claim (4): HOLDS — read `plans/work-loop-v2-v0.2/context-engineering-spec-v0.1.md`. CE-9 at line 663
  with its *fresh-session recovery* clause at lines 671–681 (seven recovered items; conversational memory
  may locate a source but never establishes authority) and its memory-only-control evidence design at
  lines 695–700. CE-15 at line 811 (one execution handoff artifact, two audiences; "the test is
  duplication, not mention"). Both are already carried into `SKILL.md` — fresh-thread recovery at line
  307, "Continue this project" at line 135, one-brief-two-audiences at line 291. Searched `SKILL.md` for
  `working directory`, `cwd`, `worktree` outside § Unattended runs — no fresh-task handoff shape is
  specified.
- Claim (5): HOLDS — read `.claude/commands/project-next-steps.md`. Step 2 (lines 46–86) is the token-lean
  cascade: plan spine → current position (authoritative completion signal first, stop when confident) →
  supporting context read lightly → git ground-truth check. Lines 64–68 record that `/prime` Step 1c
  already reuses this cascade with one deliberate inversion. Step 4 (lines 129–132) fixes the ownership
  boundary: the A–D report prints inline and the command writes nothing anywhere.
- Claim (6): HOLDS, with the repository side and the product side settling opposite ways.
  *Repository:* searched `.codex/hooks.json` and `.codex/config.toml` for `PreCompact|PostCompact|compact|
  SessionStart` — the only match is `SessionStart` at `.codex/hooks.json:51`, one unmatched hook
  (`friday-checkup-reminder.sh`). No compaction hook exists; `.codex/config.toml` registers no hooks at all
  (it holds only `[shell_environment_policy]`, including `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = "80"`, which is
  a Claude env var and not a Codex hook).
  *Product, verified against current official Codex documentation (`learn.chatgpt.com/docs/hooks`, the
  current destination of `developers.openai.com/codex/hooks`):* `PreCompact` and `PostCompact` are
  supported hook events; hooks are discovered from `<repo>/.codex/hooks.json` — the sidecar this repo
  already uses; `matcher` filters the trigger (`manual`/`auto`) for the compaction events and the source
  (`startup`/`resume`/`clear`/`compact`) for `SessionStart`; hooks receive `session_id`,
  `transcript_path`, `cwd`, `hook_event_name`, `model`, `permission_mode` on stdin; and
  `hookSpecificOutput.additionalContext` injects developer context back to the model, with
  `additionalContextLimit` defaulting to ~2,500 tokens. Skill activation is implicit and driven by the
  frontmatter `description`, with only names and descriptions loaded at startup under a ~2%-of-context
  budget (`learn.chatgpt.com/docs/build-skills`). Local checkout / Worktree / Handoff are documented
  (`learn.chatgpt.com/docs/environments/git-worktrees`), a new chat picks Local or Worktree explicitly, and
  the docs do **not** describe pointing a new non-forked chat at an existing worktree directory;
  `openai/codex` issue #21432 (closed) records "Fork into new worktree" leaving the thread's terminal in
  the original checkout. **No stop condition fires** — every mechanism this plan makes normative is
  supported.
- Claim (7): HOLDS — read `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh` (1366 lines).
  Already checkout-scoped: `--checkout` canonicalised and git-verified (lines 317–320); state file
  resolved only under `$CHECKOUT/logs/work-loop` with a realpath containment check (lines 322–329); lock
  key `sha256(checkout|task)` truncated to 16 chars under `$TMPDIR` (lines 419–420); actors launched inside
  the checkout — `-C "$CHECKOUT"` for Codex (line 1050), `cd "$CHECKOUT"` for Claude (line 1072). Still
  collidable or invisible: `LOG_DIR` defaults to `$SPIKE_DIR/runs` where `SPIKE_DIR` is the script's own
  directory (lines 179, 607, mirrored at 590), so driving checkout B with checkout A's copy writes B's
  evidence into A; and `RUN_ID="$(date '+%Y%m%dT%H%M%S')-$TASK"` (line 619) carries no checkout
  discriminator, so two checkouts running one task-id into a shared log directory in the same second
  overwrite each other's `.log`, `.hopN.<actor>.out` and `.unattended-settings.json`.
- Claim (8): HOLDS — and it moved during the unit, which is the finding. At the unit's start
  `git status --porcelain` showed 5 modified and 4 untracked paths, including 246/309/71 changed lines in
  `dispatch.sh`, `dispatch.test.sh` and the spike `README.md` belonging to the open
  `work-loop-v2-contained-unattended-profile` task. Re-run after the plan was drafted: another session had
  committed that work (`9c66f26`, `0259275`), those paths are now clean, and that task's state file is
  tracked at `turn: operator` but **not closed** — its active fields survive and `## Next action` holds a
  three-option operator decision, two options of which change `dispatch.sh` again. No path outside this
  unit was written, staged or reformatted.

Result: the implementation plan exists at
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md` (v0.1,
~700 lines). It states nine verified root causes separating executable defect from already-lean core
intent (§ 2), maps each of the brief's requirements to exactly one owner (§ 3), gives anchor-text-level
amendment targets for six files plus one new hook script (§ 4), orders eight slices with their dependency
on the still-open unattended task (§ 5), gives ten fail-capable proof cases with the controls that make
three of them mean anything (§ 6), lists twelve non-adoptions with grounds (§ 7), covers risk, rollout,
migration and hook trust (§ 8), and ends with a self-contained implementation handoff (§ 9). Two findings
changed the plan from what the brief anticipated: the brief's "removes mandatory red/green ceremony" is
scoped in § 4.5 to *evidence of a change* and explicitly **not** to Step 2's inspection record, which stays
mandatory on every run; and the § 5 dependency was corrected mid-unit after the concurrent commit.

Evidence:

- *Before:* `ls plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`
  → "No such file or directory". `grep -rln "proportionality" plans/` returned two unrelated files
  (`the-work-loop-explained-complete-system-v0.2.md`, `project-progression-protocol-original-proposal.md`),
  neither an implementation plan for this objective.
- *After:* the file exists at that exact path. Each of the seven governing operator decisions appears as
  `OD-1`…`OD-7` in § 1's discharge table and is cited again at the section that discharges it (`grep -c`
  per decision: 3, 6, 4, 4, 4, 6, 6 — every one ≥ 2, so none is listed and then dropped). Ten proof cases
  are present (`grep -nE "^\*\*P-[0-9a]+ —"` → P-1, P-2, P-2a, P-3, P-4, P-5, P-6, P-7, P-8, P-9), covering
  every scenario the brief named: false activation, duplicate verification, prose-test ceremony,
  wrong-checkout handoff, cross-project concurrency, same-repository concurrency, post-compaction recovery,
  fresh-task recovery, and project orientation.
- *The plan implements none of the target changes* — the fail-capable half. `git status --porcelain` and
  `git diff --stat` over every file the plan names as an amendment target return **empty**:
  `.agents/skills/work-loop-v2/SKILL.md`, `.claude/commands/work-loop-v2.md`,
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, `.codex/hooks.json`,
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`. The new hook script the plan specifies
  does not exist: `ls .codex/hooks/work-loop-reorient.sh` → "No such file or directory". This check reads
  differently the moment any slice is executed, which is what makes it evidence rather than assertion.
- *Why no automated regression test is meaningful here.* The artifact is a planning document; no automated
  check could distinguish a good plan from a bad one, and a grep for a term the brief supplied would pass
  whatever was written — the failure mode the core's § 6 rule 5 names. The fail-capable checks are the two
  above: the requirement-to-owner and decision-to-section coverage counts, and the empty diff across every
  named target. Both would read differently had the unit implemented instead of planned.
- *Commit:* `b155316` — two files, 1167 insertions, no deletions: this state file and the plan. No other path staged.

## Blocker

None.

## Next action

Codex: assess the plan at
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md` against the
brief's thirteen required outcomes and the completion condition — is it specific enough for a fresh Claude
session to execute without design guessing, and proportionate to the demonstrated failures?

Three points need your judgment rather than acceptance:

1. **§ 4.5 narrows the brief's requirement 6.** The brief asked to remove mandatory red/green ceremony;
   the plan removes it for *evidence of a change* and explicitly keeps Step 2's inspection record mandatory
   on every run, on the ground that it is bound by the acceptance harness and is what separates inspection
   from assumption. Confirm or correct that reading.
2. **§ 4.9 adds a new hook script** (`.codex/hooks/work-loop-reorient.sh`). The plan argues it is not one
   of the artifact kinds the constraints forbid and that no existing owner could be amended instead.
   Confirm it clears the "prefer amendments to existing owners" constraint.
3. **S7 is gated on another open task.** `work-loop-v2-contained-unattended-profile` is at `turn: operator`
   with a pending three-option decision, two options of which change `dispatch.sh`. The plan sequences the
   dispatcher slice behind that task's closing record. Confirm the sequencing, and note that the operator
   decision is the real gate.

One deferral, recorded and not done: `.codex/config.toml` sets `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE = "80"` —
a Claude environment variable living in the Codex config directory. It was noticed while inspecting claim
(6) and is outside this unit's scope, which is limited to producing the plan.
