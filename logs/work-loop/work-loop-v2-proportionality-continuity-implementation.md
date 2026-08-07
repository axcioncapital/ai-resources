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

Correction round — one frozen finding, reproduced first, then partly resolved and handed back as
exactly that.

**Reproduced (2026-08-07), before anything was changed.** Re-inspected the retained treated-run
capture from S4a's P-8. Its first four commands were:

```
1. sed -n '1,240p' 'skills/work-loop-v2/SKILL.md'          (wrong path, failed probe)
2. sed -n '1,280p' '.agents/skills/work-loop-v2/SKILL.md'
3. sed -n '281,620p' '.agents/skills/work-loop-v2/SKILL.md'
4. pwd  &&  rg --files -g 'plans/**' -g 'logs/work-loop/**' …
```

The finding holds exactly as frozen: three reads preceded `pwd`, and `pwd` arrived bundled inside the
same command as the first project-file search. **Nothing was changed until this reproduced.**

**The correction.** One block, six lines, at the very top of the skill body — the first thing in
context the moment the body is read, ahead of every other instruction in the file:

> "**Run `pwd` now, on its own, before you read anything else in this repository.** Not bundled with
> a search or a listing — one command, one answer. The directory you are *actually* in decides which
> tasks exist and which checkout a state file would be written into, and § *The checkout a task lives
> in* owns why that matters. Verifying costs one command. Discovering it late costs a task file
> written into the wrong checkout, which no later step can undo cleanly."

It is an action plus a pointer to the section that owns the policy — not a second copy of § 4.7.

**The new treated run — what actually changed, and what did not.** A genuinely fresh `codex exec`
process, same one-line request ("Continue this project."), same read-only sandbox, same checkout:

| | Before the correction | After |
|---|---|---|
| First command | `sed …SKILL.md` | `sed …SKILL.md` — **unchanged** |
| `pwd` position | command 4 | command 4 |
| `pwd` form | **bundled** with `rg --files …` | **`/bin/zsh -lc pwd`, alone** |
| First durable-source read | the same bundled command 4 | command 5, **after** `pwd` |

**Resolved.** The two defects the finding names in its own words are gone. `pwd` now runs *on its
own* — "bundling `pwd` first inside the fourth command" no longer describes what happens — and it now
runs *before any durable source is read*, where previously the bundled command was itself the first
durable-source read. Both are binary and read straight off the run capture.

**Not resolved, and I am not stretching the evidence to cover it.** `pwd` still does not precede
reading the skill file. Commands 1–3 are still reads of `SKILL.md`.

**Why, structurally.** In `codex exec`, a repository skill's body is not in the model's context until
the model fetches it with its own shell commands. So no instruction placed inside the body can
govern the commands that fetch the body — by the time the top-of-file block is readable, the reads
that fetched it have already happened. This is not a wording failure and more forceful wording will
not move it. The pattern is identical in **every** fresh run observed across this task: S1's
seven-shape activation matrix, both P-2 assessments, and both P-8 arms all open by reading
`SKILL.md`.

**What would close it, and why neither is mine to do in this round.** Exactly two surfaces load
before the skill body:

1. **The frontmatter `description`** — the only part of `SKILL.md` read at startup. It is S1's
   accepted, closed content, and this correction is expressly forbidden from altering S1–S3
   behaviour. Verified untouched: the diff contains **0** changed `description:` lines.
2. **`AGENTS.md`** — read at session start, before any skill fires. It is an S6 target and outside
   this round's allowed paths.

Either would work. Both are Codex's to route or the operator's to authorise, and neither may be taken
inside a frozen correction round.

**The durable-source property still holds.** The new treated run carried material facts available
only in the durable sources — it named the escaped-descendant task's `325/0` regression result and
its governing plan path, neither of which is in the one-line request. That is the P-8 property the
finding did not dispute, re-established on the corrected file rather than assumed to survive.

**The correction altered nothing else, verified by fixed-string check.** All six § 4.7 anchors are
INTACT; S1's activation description, S1's routing-step-3 core read, S3's verification division and
S3's negative sentence are INTACT. The diff is **6 insertions, 0 deletions** in `SKILL.md`. The
harness is unchanged at **292 passed, 3 failed** — the same three pre-existing failures. Nothing
newly noticed was implemented.

**P-4 remains unexecuted and unsimulated.** No worktree was created or entered, no second checkout
used, no directory faked. Unchanged by this round.

**Changed paths:** `.agents/skills/work-loop-v2/SKILL.md` and this state file.

**Deferrals carried forward, none implemented.** (1) An ordinary unnamed request still activates Work
Loop v1. (2) The `ridx` 340-line ceiling, now exceeded by 89 lines — this round added 6.

## Blocker

P-4's real-worktree proof cannot run under the operator's current saved-Local-only constraint. It
does not block the S4a instruction change or Local-only P-8 proof, but it remains required before S4
can be fully closed.

## Next action

Codex: run the closure check on the frozen finding only — is it resolved, and did the correction
break anything? It is **partly** resolved and reported as such: `pwd` now runs alone and ahead of
every durable-source read, but it still cannot precede the reads that fetch the skill body, because
no instruction inside that body can govern them. Closing the remainder needs either the frontmatter
description (S1's accepted content) or `AGENTS.md` (an S6 target) — both outside this round. That is
core § 3's menu decision, not a second correction round.

Superseded frozen finding, retained for the closure check:

1. **P-8 did not satisfy the unit's cwd-first condition.** The treated fresh task read
   `.agents/skills/work-loop-v2/SKILL.md` in three commands before it ran `pwd`; bundling `pwd` first
   inside the fourth command does not establish that the checkout was verified before anything was
   read. This is the precise safety behavior the accepted plan and S4a completion condition require,
   not a presentation detail. Correct the instruction's discoverability or placement so a genuinely
   fresh `codex exec` process given only the same one-line continuation request runs `pwd` as its
   first command, before reading the skill or any durable source, while still completing the
   required full skill read afterwards. Demonstrate the correction with a new fail-capable treated
   run that records the actual first command and still carries a material fact available only in the
   durable sources. Check that the correction did not alter the accepted § 4.7 content or S1–S3
   behavior. Stay inside the existing allowed paths. Do not execute or simulate P-4, create or
   switch to a worktree, or broaden this correction to the stale line ceiling or any other finding.
