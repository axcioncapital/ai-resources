---
task: work-loop-v2-proportionality-continuity-implementation
turn: codex
---

## Objective and scope

Implement the accepted Work Loop v2 proportionality-and-continuity plan as separately assessed,
independently committable slices. The task exit condition is that the accepted plan's S1–S7 changes
are implemented in their governed dependency order with their proof cases, or a verified blocker is
handed back rather than worked around.

The current unit is **S4a only**: implement the accepted plan's checkout binding, isolation policy
and fresh-task handoff in the Work Loop v2 skill, and run the Local-checkout portion of the S4 proof.
The real-worktree P-4 proof is deliberately held outside this unit because the operator's governing
handoff says to work in the saved Local checkout only and not create or switch to a worktree.

Excluded are P-4 execution or a simulated substitute for it; S5–S7; changes to S1–S3; changes to
the executable core, Claude command, harness, fixtures, dispatcher, hooks, AGENTS.md or any other
task file; installation or propagation; creation of or switching to a worktree; branches, pushes
and unrelated cleanup.

## Lane and unit

Standard. Implementation mode. Unit 4a — accepted plan slice S4's runtime instruction change and
Local-only P-8 proof.

Named reason for the loop: the unit changes the continuity and checkout-safety instructions used at
future handoffs, and its fresh-task behavior must be assessed independently before project
orientation work begins.

Codex framing decision: S4 is split at its proof boundary because the accepted P-4 construction
requires a real worktree while the operator expressly prohibited creating or switching to one in
this checkout. This unit makes the ready, independently committable instruction change and does not
claim P-4. The unresolved proof remains visible rather than being replaced with a simulation.

## Brief

**Required outcome.** Implement plan § 4.7 in `.agents/skills/work-loop-v2/SKILL.md`, at § *The
seam*, as one compact operational addition:

1. The state file's location binds the task to its checkout. Before creating a new state file,
   Codex verifies the working directory it is actually in and that it is the checkout the work
   belongs to. Both actors verify at every handoff. A mismatch stops and goes to the operator; the
   task file is never copied to another checkout as a repair. Add no state field.
2. State the accepted isolation table exactly at the decision point for a new task or run:
   different repositories use their own local checkouts with no worktree; ordinary one-repository,
   one-writer work uses Local; concurrent writers in one repository use deliberate isolation
   through a worktree or branch; unattended work uses isolation on a branch off a clean tree; a
   genuinely large implementation uses isolation. The table is the complete policy—add no decision
   procedure.
3. A new Codex task starts only when the thread ended or must end: a fresh session, lost-thread
   compaction or deliberate handoff. Ordinary Claude↔Codex state turns stay in the existing task.
   Prefer a genuinely fresh task over a transcript-preserving fork. Select Local or Worktree
   explicitly under the isolation policy and verify the working directory as the first action.
4. The first substantive action in a fresh task reads, in order: the named state file, governing
   plan, applicable approved workflow, then authoritative current state; the same preparation pass
   re-establishes CE-9's seven recovery items.
5. Preserve the accepted existing-worktree fallback: open that existing worktree directory as a
   Local checkout, verify the working directory first, never ask a fresh task to create another
   worktree to attach to it, and do not treat Codex-managed disposable worktrees as continuity.

Keep ownership clean: the skill points to core-owned mechanics instead of restating them. Do not
alter the courier, unattended-operation, verification-ownership or proportionality behavior while
placing the new text.

**Governing sources.** In order: this state file; accepted plan § 4.7 and proof case P-8 in
`plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md`;
`.agents/skills/work-loop-v2/SKILL.md`; executable core §§ 3–7; the operator's saved-Local-checkout
constraint carried in this brief; repository current state. The accepted plan governs the S4
content. The operator's later, more specific checkout constraint governs what may be executed in
this unit.

**Allowed paths.**

- `.agents/skills/work-loop-v2/SKILL.md`
- `logs/work-loop/work-loop-v2-proportionality-continuity-implementation.md`

Nothing else may be changed or committed. A concurrent task,
`project-progression-candidate-review-correction`, nominally names the skill in its older scope but
its current `## Next action` confines it to reducing only its own state file. The
escaped-descendant task expressly excludes Work Loop skill and rule changes. Re-read the skill
immediately before editing and stop on any actual overlapping change rather than merging it
silently.

**Verification questions.**

1. Does § *The seam* contain all three accepted § 4.7 parts without a new state field or a second
   decision procedure?
2. Is the task file bound to its checkout, with actual-cwd verification before creation and every
   handoff, mismatch-as-stop, and an explicit no-copy rule?
3. Does the isolation table preserve all five accepted situations and defaults without making a
   worktree the ordinary default?
4. Does fresh-task guidance distinguish the three genuine start conditions from routine state-file
   turns, prefer fresh over fork, require the four durable-source classes in order, recover all
   seven CE-9 items in the same preparation pass, and preserve the existing-worktree fallback?
5. Does P-8 distinguish durable-source recovery from a memory-only control and show that cwd was
   verified before any source read?
6. Did the change avoid S1–S3 restatement or mutation and avoid every excluded target?

**Required evidence.**

- Inspect and report the exact checkout, state identity/turn, target freshness and current
  concurrent ownership before editing.
- For the instruction prose, quote the relevant old text and the new compact text, plus one line
  explaining why no automated test can decide whether English continuity instructions are correct.
- Run P-8 from this saved Local checkout with genuinely fresh `codex exec` processes: give the
  treated task only a one-line continuation request, require the resulting brief to carry a material
  fact available only in the named durable sources, and record that `pwd` was the first command
  before any read. Run the memory-only control without opening those durable sources and state the
  material difference. Report the commands/observations and the headless/single-observation limit.
- Do **not** execute P-4, create or switch to a worktree, use a second checkout, or substitute a
  fake directory test. Record P-4 as unexecuted under the operator constraint so Codex can route the
  remaining proof honestly.
- Report changed paths and any pre-existing unrelated failures separately. Do not repair them.

**Completion condition.** The § 4.7 instruction change is complete inside the two allowed paths,
P-8 provides a fail-capable durable-source-versus-memory control from the saved Local checkout,
P-4 is truthfully recorded as unexecuted, and the result is committed by Claude with `turn: codex`.

**Stop conditions.** Stop without editing if the working directory is not exactly
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`, the state identity/turn is wrong,
the skill changed under another writer, or an actual target collision exists. Stop and hand back
rather than create/switch to a worktree, copy a task state between checkouts, broaden the allowed
paths, weaken the accepted § 4.7 content, or claim P-4 from simulated evidence.

## Latest result

Inspected (2026-08-07) — the four premises the brief requires before editing:

- **Checkout: HOLDS** — `pwd -P` returned exactly
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. The saved Local checkout, no
  worktree created or entered at any point in this unit.
- **State identity and turn: HOLDS** — `task:` matches the filename, `turn:` was `claude`, active
  headings are core § 4's five plus `## Brief`, one file for the task.
- **Target freshness: HOLDS** — `git status --porcelain` on `.agents/skills/work-loop-v2/SKILL.md`
  was empty; the file stood at `520f98e` (S3), blob `1e482cfc`. It had not moved under another
  writer since I last committed it.
- **Concurrent ownership: HOLDS** — three tasks sit at `turn: claude`. This one;
  `project-progression-candidate-review-correction`, whose close verdict confines it to its own state
  file; and `work-loop-v2-escaped-descendant-termination`, which is actively editing `dispatch.sh`
  and `dispatch.test.sh` in the tree and whose scope excludes "Work Loop core, skill or rule
  changes". `work-loop-v2-intake-router` and `work-loop-v2-production-readiness-policy` are at
  `turn: codex`. **No other writer owns the skill.** No dispatcher run is in flight.

Result: plan § 4.7 is implemented in `.agents/skills/work-loop-v2/SKILL.md` § *The seam*, as one new
subsection. 29 insertions, 0 deletions. Nothing else changed.

**Old text — what was there.** § *The seam* ended at: "**The folder is core § 4's, not a choice.**
Create `logs/work-loop/` if it does not exist. There is no fallback path — if you cannot write there,
say so and stop." The section said nothing about which checkout a task belongs to, nothing about
isolation, and nothing about when a new Codex task starts. Verified by the eight-phrase presence
check returning MISSING for all eight before the edit.

**New text — `### The checkout a task lives in, and starting a new one`**, inserted between that
paragraph and § *Courier mode*. Its five parts, in the accepted plan's own terms:

> "**The task file's location is the binding.** The checkout holding `logs/work-loop/{task-id}.md` is
> the checkout that task lives in. Nothing records this in the file — a state field would be a second
> copy, free to drift from the path it duplicates. … **Verify before you create** … confirm the
> working directory you are *actually* in — not the one you meant to be in* … **Both actors verify at
> every handoff** … **A mismatch stops and goes to the operator** (core § 7). **Never copy the task
> file to another checkout as a repair.** That produces two files claiming one task's truth …
>
> **Isolation — the whole policy** … {the five-row table, verbatim from § 4.7b} … A worktree is a
> cost, not a default. The table is the policy — do not build a decision procedure on top of it.
>
> **When a new Codex task starts at all.** Only where the thread has ended or must end … **Ordinary
> Claude ↔ Codex turns carried by the state file do not open a new task** … **Prefer a genuinely
> fresh task over a transcript-preserving fork** … **Choose Local or Worktree explicitly** … **Verify
> the working directory as the first action** … **Then read the durable sources, in this order:** the
> state file …; the governing plan; the applicable approved workflow; authoritative current state.
> Re-establish the seven fresh-thread recovery items inside that same preparation pass — § *Mark what
> must be verified* owns them — never as a stage of its own.
>
> **The existing-worktree fallback.** … open that directory as a **Local** checkout … Do **not** use
> 'create a worktree' on a fresh task expecting it to attach to the existing one … Codex-managed
> worktrees are disposable and are not a continuity surface."

**Why there is no automated test for this.** These are English continuity instructions for another
model. No check can decide whether "verify the working directory you are actually in" is correctly
worded; it can only confirm the sentence exists, which is a grep for words this brief supplied. The
behavioural proof is P-8 below, and P-4 — which is the proof for the checkout-binding half — is
deliberately unexecuted.

**The verification questions, answered against the committed file.**

1. All three § 4.7 parts are present — checkout binding, isolation, fresh-task handoff — and were
   absent before. No new state field: `grep -cE '^(checkout|worktree|isolation)[[:space:]]*:'`
   returns **0**. No decision procedure was added beside the table.
2. Yes — binding by file location, actual-cwd verification before creation and at every handoff,
   mismatch-stops-to-operator, and the explicit no-copy rule.
3. All five situations and their defaults are preserved verbatim, and Local remains the default for
   ordinary one-writer work. A worktree is named a cost.
4. Yes — the three genuine start conditions are distinguished from routine state-file turns, fresh is
   preferred over fork, the four durable-source classes are ordered, the seven recovery items are
   recovered in the same pass **by pointer** to the section that owns them rather than a second copy,
   and the fallback is preserved.
5. See P-8 — with one part not met, reported below rather than smoothed over.
6. S1–S3 are intact and unrestated. Verified by fixed-string presence: the S1 activation description,
   the S1 routing-step-3 core read, the S3 verification division and the S3 negative sentence are all
   **INTACT**. The harness is unchanged at **292 passed, 3 failed** — the same three as before this
   unit.

**P-8 — fresh-task recovery, with its memory-only control.** Two genuinely fresh `codex exec`
processes from this saved Local checkout, read-only sandbox, same one-line continuation request
("Continue this project."). The control adds only: answer from this conversation alone, do not open
any file.

| | Commands run | What it produced |
|---|---|---|
| **Treated** | 13 | A full S4a execution brief naming the current slice, the five-row isolation table, the CE-9 recovery order, and the operator's do-not-create-a-worktree constraint |
| **Control** | **0** | Refused: "I can't produce a reliable continuation brief from this conversation alone: it contains repository rules, but no project objective, current state, completed work, or proposed next unit. Inventing those would risk sending the project in the wrong direction." |

**The material difference is the whole point of the control.** The treated run named S3 as accepted
and S4a as the open unit, and carried the operator's worktree constraint — facts present only in this
state file and the governing plan, and absent from the request. The control could name none of them
and said so. The two briefs are not indistinguishable, so the case proved something.

**The part of P-8 that was not met, stated plainly.** The brief requires recording that `pwd` was the
first command before any read. It was not. The treated run's first three commands were reads of
`SKILL.md` itself — the skill body loading, which happens before the model has read the instruction
that governs it — and the fourth was `pwd rg --files …`, which puts `pwd` first inside a command that
also lists files. So on the fairest reading the first action *after* the instruction was in context
did begin with `pwd`; on the strict reading of "before anything is read", it did not. Both readings
are given because the observation genuinely supports each, and it is Codex's to judge.

**Limits on P-8:** one observation per arm, headless `codex exec` rather than the Codex app, and the
treated run wrote nothing because the sandbox is read-only — so the binding rule that matters most,
*verify before you create the state file*, was never exercised. Reading files is harmless; creating a
task file in the wrong checkout is not, and that path has no evidence in this unit.

**P-4 is unexecuted, and is not simulated.** The accepted construction needs a real second checkout
with `logs/work-loop/{task}.md` present in A while Codex operates in B. The operator's governing
constraint is to stay in this saved Local checkout and neither create nor switch to a worktree, so
the case cannot be built here. No worktree was created, no second checkout was used, no state file
was copied, and no directory was faked to stand in for one. **The checkout-binding half of § 4.7
therefore ships with its instruction written and its proof outstanding** — that is the truthful
position, and routing the remaining proof is Codex's move.

**Changed paths:** `.agents/skills/work-loop-v2/SKILL.md` and this state file. Nothing else was
touched or staged. `dispatch.sh`, `dispatch.test.sh` and their run log are dirty in the tree from the
concurrent escaped-descendant task; `logs/friction-log.md` is written by a `PostToolUse` hook. None
is mine and none is staged.

**Pre-existing failures, reported and not repaired.** The same three as before this unit: two `3.1a`
closed-set reds, and `ridx  the skill stays under its 340-line ceiling`. S4a adds 29 lines, taking
the skill to **423** — the gap is now 83 lines. The verdict was already red and does not change, but
this is the third consecutive unit to widen it, which strengthens rather than weakens the case for
the deferral below.

**Deferrals carried forward, none implemented.**

1. An ordinary unnamed request still activates **Work Loop v1**. Outside this plan's targets.
2. The `ridx` 340-line ceiling. Now exceeded by 83 lines. It needs its own decision — re-base the
   guard or trim the skill — and it is not S4a's to make.

## Blocker

P-4's real-worktree proof cannot run under the operator's current saved-Local-only constraint. It
does not block the S4a instruction change or Local-only P-8 proof, but it remains required before S4
can be fully closed.

## Next action

Codex: assess S4a. Three judgments are yours. First, whether the § 4.7 instruction change is complete
as written, given that its behavioural proof is split. Second, how to route the outstanding P-4: it
needs a real second checkout, which the operator's current constraint forbids here, so it is either
an operator decision to lift that constraint, a later unit, or an accepted limitation on S4. Third,
whether P-8's `pwd`-first observation counts as met — the first action after the instruction was in
context did begin with `pwd`, but it was bundled with a file listing, and the three commands before
it were the skill body loading. Then close, continue to S5, or correct once.
