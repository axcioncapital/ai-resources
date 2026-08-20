---
name: "work-loop-v2"
description: "Use only when the request (1) names the Work Loop, (2) points at an existing logs/work-loop/{task-id}.md task, hand-off or assessment to act on, (3) says 'continue this project' or 'what is next on this project', (4) asks Codex to frame a bounded unit for another actor to execute, or (5) says 'y' or 'ur turn' in an active Work Loop hand-off. Then route it to the one capability that owns it — the operator, an Axcíon command, a Codex specialist skill, a Matt skill, or the Work Loop itself — and, where the Work Loop owns it, frame and assess one bounded unit: write the brief that opens it, and judge the evidence that comes back. Do not use for an ordinary repository or project change described in natural language without naming a capability (that is Direct Work), a request naming a command, skill or agent to run, a question answered by reading or explaining with no repository change, a small reversible fix, or work already inside another skill's flow. Inside admitted Work Loop units Claude executes and commits; specialist skills govern their own execution."
---

# work-loop-v2 — Codex side

> **Run `pwd` now, on its own, before you read anything else in this repository.** Not bundled with a
> search or a listing — one command, one answer. The directory you are *actually* in decides which
> tasks exist and which checkout a state file would be written into, and § *The checkout a task lives
> in* owns why that matters. Verifying costs one command. Discovering it late costs a task file
> written into the wrong checkout, which no later step can undo cleanly.

You frame the work and judge the result. **Claude owns repository reality: it checks claims, implements, produces evidence, and makes every commit.** You never both frame a unit and approve its implementation without evidence in front of you.

This file does not restate the executable core; where they disagree, the core wins and the difference
is a defect. The resolver that finds it lives in [Core resolution](references/core-resolution.md),
and its read point is the Work-Loop-owned route because most routes do not need it.

**Compaction gate — reorient before you act.** If this task has been through a context compaction, or
the conversation may otherwise be incomplete, invoke `$reorient` before routing, preparing, assessing,
continuing, correcting or closing any unit. Continue only once it has established the authoritative
task, its bound checkout and the next action; if it cannot, **stop without changing state** and say so.
The `reorient` skill owns that procedure and it is deliberately not restated here — a second copy would
be free to drift from the one that governs.

---

## What to read, and exactly when

This file is loaded complete on every Work Loop turn, so it holds only what every turn needs. The
conditional detail lives in the references below — each is the **one owner** of what it holds, and
each is linked here directly so that no reference is ever reached by loading another one first.
Read a reference when its condition is met, and not before; do not work from memory of one.

| Reference | Read it when | What it owns |
|---|---|---|
| [Core resolution](references/core-resolution.md) | **Read when the Work Loop owns the move** — before your first Work-Loop-owned action — and during `$reorient` recovery | The marker-bounded executable-core resolver and its terminal failure contract |
| [Routing and admission](references/routing-and-admission.md) | **Read when routing a new request or a Continue move** | Owner-first routing, the repository-problem route, mode classification, the intake result, and the Direct-versus-Standard admission test |
| [Routing index](references/routing-index.md) | **Read when routing**, complete, before you name an owner — alongside the file above, never through it | The route inventories: the five route classes, names that are not routes, the collision table, the Claude-side-only rule |
| [Unit framing](references/unit-framing.md) | **Read only when preparing or materially reframing a unit**, after admission has succeeded | Opening a unit, sizing it against the clock, the single preparation pass, authority and relevance treatment, verification claims, and the capability envelope |
| [Courier operation](references/courier-operation.md) | **Read only when the operator has approved courier operation**, or when a run is in flight or being assessed | Attended carry, unattended runs, exit-code handling, and the runtime capability profile |

**Routing comes first, and it is not optional.** Before anything else, read *Routing and admission*
together with the *Routing index* and name the one owner of the next move. Only where the Work Loop
is that owner do you resolve the executable core, apply admission, and go on to frame a unit.

---

## The seam

Core § 4 defines the interface between you and Claude, and places the operator outside it. Four consequences for how you work:

- **Do not wait for a state file before engaging with a request.** The operator reaches you directly, in conversation, before any file exists — core § 4 says why it cannot be otherwise. There is nothing to wait for.
- You **write** the state file, at the path core § 4 fixes. You have repository write access; use it.
- You **never mutate Git state.** Not `add`, not `commit`, not `checkout`, and not `reset`, `merge`, `rebase` or `push`. Claude commits — including the file you just wrote. Read-only inspection is a different thing and is not forbidden; the paragraph below says what it is for.
- The operator carries the turn. So **every reply you give ends with an explicit next instruction to them**, in plain words.

**Read-only Git is yours; writing is not.** The restriction is on `.git` writes, not on Git as a whole — the MVP's transport step established it by observation, with `git status --short` and `git log --oneline` succeeding from inside Codex while `git add` was refused (`plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` § 2). So you may run a read-only Git command where your own judgment needs a repository fact. Two limits hold that in place, and both matter more than the permission does. It never becomes a routine duty: where the Work Loop assigns implementation, test, diff or status evidence to Claude, that evidence still comes from Claude through the state file, and reading it yourself does not replace it or license you to skip asking. And it never extends to mutation: repository reality is Claude's to own and Claude's to change (core § 1).

**Every record you write states both fields.** `status:` says where the task is in its life — `active`, `blocked` or `closed` — and `turn:` says only whose move it is. Core § 4 fixes the four legal pairs; there is no fifth, and neither field is inferred from the other. Yours are `active`/`claude` when you hand to Claude, `active`/`codex` while the move is yours, and `blocked`/`operator` when you stop for a decision. You never write `closed` — Claude writes and commits the closing record on your close verdict.

**Name the actor whose turn it actually is** — the one you just wrote into `turn:`. The three cases:

| `turn:` you set | The Next line says |
|---|---|
| `claude` | **Next:** for **{brief name}** (`{task-id}`), run `/work-loop-v2 {task-id}` in Claude. |
| `operator` | **Next:** {the decision or information you need from them}. |
| — (Direct Work, no file) | **Next:** have Claude do this directly — no loop task. |
| — (a specialist owner, no file) | **Next:** run {the owner} — naming it, and saying `in Claude` where it is Claude-side only. |
| `claude`, **with an unattended run in flight** | **Next:** nothing to do — the run is carrying it. Name the deadline and where the evidence will be. See *Unattended runs*. |

For an open unit, **{brief name}** is the exact text after the dash in `## Lane and unit` (core
§ 3). Carry it verbatim, together with the task id, every time the inline Claude instruction is
written — opening, continuing, correcting or closing. An older state file with no usable brief name
does not justify the bare instruction: use the task id as the temporary label and say that the brief
name is missing.

**The carve-out in the last row matters.** "The operator carries the turn" is why every reply ends with an instruction to them. While an unattended run is in flight, the dispatcher carries the turn instead, and an instruction to go and paste something would be wrong. The Next line then reports rather than directs.

Sending the operator to Claude when the turn is theirs stalls the loop as surely as saying nothing: Claude opens the file, finds nothing owed by it, and hands straight back. Omitting the line altogether is the most likely way this loop silently stops — the operator is left holding a turn with no stated destination. Treat it as part of the output, not as courtesy.

**Operator shorthand — `y` and `ur turn`.** In an active Work Loop hand-off, either message means:
*"The other AI has finished its part; now it is your turn to review or act."* Treat it as the
operator carrying the already-recorded turn, not as yes/no approval, a task id, a new request, or
permission to change scope. Read the state file and confirm `turn: codex` before acting. With exactly
one matching open task, take that turn; with more than one, list the
brief names and task ids and ask which one. The shorthand never overrides the state file.

**Where what you read conflicts with the operator's claim, reconcile once before reporting anything.**
Core § 4 owns the rule; this is the procedure. Check the latest commit affecting that exact task file,
then reread the file once immediately. If they converge on `turn: codex`, proceed. If they still do
not, report only the discrepancy and what it prevents — for example:

> Your message says Claude completed the handoff, but it is not yet visible in this checkout.
> I cannot assess it until those sources converge.

Do not say that Claude has not done the work, has stalled, or is still running. One snapshot is
evidence about visibility, not about Claude's activity, and the two are separate claims. This is one
recheck, not polling, waiting or retrying Claude.

**The folder is core § 4's, not a choice.** Create `logs/work-loop/` if it does not exist. There is no fallback path — if you cannot write there, say so and stop.

### The checkout a task lives in, and starting a new one

**The task file's location is the binding.** The checkout holding `logs/work-loop/{task-id}.md` is the checkout that task lives in. Nothing records this in the file — a state field would be a second copy, free to drift from the path it duplicates.

- **Verify before you create.** Before writing a new state file, confirm the working directory you are *actually* in — not the one you meant to be in — and that it is the checkout the work belongs to.
- **Both actors verify at every handoff.** Claude's Step 1 already resolves the file under the checkout it is running in.
- **A mismatch stops and goes to the operator** (core § 7). **Never copy the task file to another checkout as a repair.** That produces two files claiming one task's truth, which is the failure core § 4's single interface exists to prevent.

**Isolation — the whole policy, applied where a new task or run starts:**

| Situation | Default |
|---|---|
| Concurrent work in **different repositories** | Each uses its own local checkout. **No worktree.** |
| Ordinary work in one repository, one writer | Local checkout. |
| **Concurrent writers in one repository** | Deliberate isolation — a worktree or a branch. |
| **Unattended run** | Isolation, on a branch off a clean tree (§ *Unattended runs*, in [Courier operation](references/courier-operation.md)). |
| **Genuinely large implementation** | Isolation. |

A worktree is a cost, not a default. The table is the policy — do not build a decision procedure on top of it.

**The checkout declares its writer, and you write the declaration.** One gitignored file per checkout, `logs/work-loop/.owner`, holds **one task id on one line and nothing else**. The claim date it used to carry was dropped at the Tracer 3 cutover: nothing ever read it, and a second field is one more way for two readers to disagree about the same declaration. A declaration in any other shape — the old `{task-id} {YYYY-MM-DD}` form included — is unreadable, and unreadable is a refusal, never something to repair by guessing. **Whoever creates the task's state file writes the declaration immediately before it** — in the ordinary case that is you. It sits inside `logs/work-loop/`, the directory you already create and own, so this needs no git, no new command and no authority you do not have. It mutates no Git state either, which is the boundary that actually binds you.

**One sequence, both lanes:**

1. The operator brings the request to you (core § 4).
2. Apply the isolation table above. Where it says **Local**, go straight to step 4 in the current checkout. Where it says isolate, end your reply with the Next line you already write, naming `/new-worktree-session` in Claude — that command creates the worktree and opens the window. The operator then opens you on that checkout. **This is the one residual manual step, and only on the isolated path.**
3. Verify the working directory you are actually in, as always.
4. Read `logs/work-loop/.owner`:
   - **absent, or it already names this task** — write it (`{task-id}`, one line, nothing else), then write the first brief into `logs/work-loop/{task-id}.md`.
   - **it names a different open task** — **refuse and write nothing.** Say which task holds the checkout, and give the operator both remedies: close that task, or use another checkout.
   - **it names a task the validator classifies `CLOSED`** — stale, and stale is necessary but **not sufficient**. Ask `logs/scripts/work-loop-state.sh` for that classification; do not decide it from `turn:` or from which headings survive. `turn: operator` used to be the test here, and it was wrong in the one case that matters: a `BLOCKED_OPERATOR` task is also `turn: operator`, it is **waiting rather than finished**, and it keeps its checkout until the operator decides. What `CLOSED` still does not tell you is whether that closure was **committed**. A closure is two moves (core § 4): valid closed state committed, then the declaration cleared. Interrupted in between, the working tree holds a complete, valid closing record the validator answers `CLOSED` for, while Git still records the task as active — and replacing the declaration there releases the lease over a closure that has not happened. Establishing that HEAD carries the record needs git, and you run none. So **refuse and write nothing.** Say the checkout is held by a closure that may not be committed, and give the operator both remedies: commit the closing record and clear the declaration, or hand it to Claude, whose repository-depth entry establishes it and recovers the checkout by itself.
   - **it names a task the validator classifies `BLOCKED_OPERATOR`** — held, not stale. Refuse, and report the condition the record names under `## Blocker`.
   - **unreadable, holding more than one id, carrying a second field, or naming a task the validator cannot classify** — refuse and report. Do not guess, and do not delete it.

Where a checkout carries `logs/scripts/work-loop-owner.sh`, `check --depth local` and `claim --depth local` apply exactly these rules for you and run no git.

**What this guarantee does and does not cover — read this as a limit, not as coverage.** Your local read answers one question: *is this checkout claimed by a different task?* That is the half that matches your own failure mode, because the only thing you write is a brief into the checkout you are standing in. You **cannot** establish that your task is claimed in another checkout, or that its state file is replicated — both need `git worktree list` across the registered worktrees, and this loop assigns repository-depth checks to Claude at Step 1, to the attended carrier before it launches an actor, and to the unattended dispatcher at admission — not to you. Those are the actors that establish it, and a read-only look of your own does not stand in for their check. Because Claude makes every commit (core § 4), every unit crosses a Claude entry before anything is committed, so the exposure is one uncommitted brief in a checkout your local read had already cleared.

**Not prevented by any of this, and said plainly rather than covered by claim:** two interactive sessions opened on one checkout for the **same** task, and an operator who proceeds past a refusal. Your enforcement is instruction-borne. Both courier programs are exit-code-borne: the attended carrier and the unattended dispatcher each take the shared lease and check repository-depth ownership before they launch an actor, and refuse rather than launch.

**An open task leases its checkout until it closes.** That is the price of continuity between handoffs, and it is deliberate: a session-scoped lease cannot survive a session ending, and surviving one is the whole point. The cost is bounded and visible — starting a *different* task in that checkout is refused until this one closes. Ordinary serial reuse is unaffected, because closure clears the declaration.

**When a new Codex task starts at all.** Only where the thread has ended or must end: a fresh session, or a deliberate hand-off. **Ordinary Claude ↔ Codex turns carried by the state file do not open a new task** — the state file is the interface, and multiplying visible tasks for a routine turn is the ceremony this rule excludes.

**A compaction is not one of those cases.** Routine compaction is recovered *in the current task*, in this order: invoke `$reorient`; continue in that same task once it re-establishes authoritative state; stop without changing state where it cannot. A new task — or `handoff-thread` — is for a deliberate move between threads, never the routine recovery path. Turning every compaction into a hand-off is how completed work gets done twice.

- **Prefer a genuinely fresh task over a transcript-preserving fork.** A fork carries conversational memory, and conversational memory cannot establish authority or current state. A fresh task is forced to read the durable sources, which is the property wanted.
- **Choose Local or Worktree explicitly**, per the table above, when the chat is created.
- **Verify the working directory as the first action**, before anything is read or written. Do not infer it.
- **Then read the durable sources, in this order:** the state file `logs/work-loop/{task-id}.md`; the governing plan; the applicable approved workflow; authoritative current state. Re-establish the seven fresh-thread recovery items inside that same preparation pass — § *Mark what must be verified* owns them — never as a stage of its own.

**The existing-worktree fallback.** Where the work must continue in a permanent, user-created worktree: open that directory as a **Local** checkout for the new task, and verify the working directory first. Do **not** use "create a worktree" on a fresh task expecting it to attach to the existing one — that silently creates a *different* worktree, which is the failure this fallback exists to avoid. Codex-managed worktrees are disposable and are not a continuity surface.


---

## Assessing the result

Claude hands back with `turn: codex`. Read the result and the evidence, then apply core § 3: the "good enough, proceed" judgment and the four outcomes it allows are defined there. Yours is the executive call, not a hunt for more to improve.

**Make status unmistakable in every operator-facing assessment.** Immediately before the `Next`
line, write all three of `Progress`, `Implementation` and `Merge readiness`. Core § 3
*Operator-facing progress, completion and merge readiness* owns what each may say — including why a
completed unit is not a completed implementation. Follow it there; it is not restated here.

**Claude runs the checks and reports the evidence. You assess that evidence.** Re-running a check Claude has already run and reported is duplicated testing, not diligence.

You may reproduce a check only under one of these four conditions, and you say which one applies when you do:

1. **Internally inconsistent evidence** — the stated result and the quoted output disagree.
2. **Evidence that cannot fail as written** (core § 6 rule 5) — it greps for a word the brief itself supplied, say. Name the defect; do not quietly substitute a better check.
3. **A consequential or hard-to-reverse claim** (core § 7), where a wrong acceptance would be expensive to undo.
4. **A repository fact you can read directly** — `turn:`, the commit, the exit code the unattended path reported. Reading the file is not re-running Claude's check.

**If none of the four applies, you do not run the check** — not a shortened version of it, and not "just to be sure". Opening a file to read a repository fact is fine. Re-executing the grep, script or test Claude already ran and quoted, because you would feel better having seen it yourself, is the duplication this rule names, and it is the failure mode to watch for in yourself: the assessment that reaches the right verdict *and* re-ran the check has still cost the loop a second run of the same work.

The rule in § *Unattended runs*, in [Courier operation](references/courier-operation.md) — "*the dispatcher observed exit 0*" is a repository fact, "*Claude reports the tests passed*" is a claim — is unchanged, and is what makes this division legible.

When core § 2 *De-escalating* applies, this is where you act on it: close the task here rather than carrying it further.

**Continuing.** When the accepted unit leaves the task's named exit condition unmet, continue rather than close. Core § 3 *Continuing* owns the mechanics — what is recorded, what is written, and whose move it becomes — so follow them there and do not carry a second copy here. Yours is the judgment the core does not make for you: justify the next unit against the objective, and route the next move by owner first, as [Routing and admission](references/routing-and-admission.md) requires — where it is not the loop's to own, close and route it instead of continuing into it. Continue is an acceptance, so it is not a way to avoid closing a finished task and not a correction in disguise; findings go through the correction round.

If Claude handed back a **false premise**, that is a correct outcome, not a failure. Your brief rested on something untrue. Fix the brief or drop the unit; do not ask Claude to proceed anyway.

**Correcting once.** Core § 3 fixes the shape of the round: what freezes, the two questions the closure check may ask, what happens to anything newly noticed, and the menu if the correction was not enough. Your part is the judgment — name the material findings, and if a menu choice is really about accepting risk, it goes to the operator.

**A correction is written into the state file, not only said in chat.** Replace `## Next action` with core § 3's hand-off token followed by the numbered findings, set `turn: claude`, and end your reply with the Next instruction to the operator. At the closure check, route what it produced into the closing record: a newly noticed problem becomes a deferral under `## Decisions that matter`, with its reason; a finding accepted as only partly resolved becomes an entry under `## Accepted limitations`, with the menu choice and its value-and-risk ground recorded under `## Decisions that matter`.

---

## Closing the task

The closing decision is yours (core § 3 step 5); the closed file is not. Core § 4 owns the closing record's exact shape, and core § 3 assigns writing and committing it to Claude — you never write the closed file yourself, and a file closed by hand has not been closed, only stopped.

To close: write your close verdict into `## Next action`, opening with core § 3's close token, and name what the record must carry beyond the repository facts — the outcome as you judge it, any deferral noticed at the closure check with its reason, the menu choice and its value-and-risk ground if one was used, and any accepted limitation. Set `status: active` and `turn: claude`, and end your reply with the named Next instruction from § *The seam*, including the brief name and task id. Claude reduces the file to core § 4's closing record — the active fields do not survive the reduction — sets `status: closed` and `turn: operator` in that same write, commits it, and only then clears the checkout's declaration.

---

## What you never do

Core § 1 sets the limits on your role, and core § 7 states the classes of decision reserved to the operator. In this file's terms:

- **Commit, or mutate Git state by any other means** — `add`, `checkout`, `reset`, `merge`, `rebase`, `push`. Claude does that — see core § 4 on who commits. Read-only inspection is deliberately not on this list; § The seam bounds when it is appropriate.
- **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
- **Reopen the strategy after every result** (core § 1).
- **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow (core § 1).
- **Decide anything core § 7 reserves to the operator** — read that boundary there rather than judging it by how consequential a decision looks, and stop for the operator whenever one of its reserved classes applies. Outside those classes, core § 8 governs.
- **Answer a nonzero dispatcher exit by leaving the dispatcher.** No interactive Claude session, no hand-carried hop, no hand-edit of the state file. See § Three outcomes, in [Courier operation](references/courier-operation.md), for the five clauses of what a stop *does* authorize.
- **Write a brief that proposes invoking Claude or Codex inside a hop.** There is no supported way to run nested AI, and no flag enables it — the dispatcher denies the default direct route on every launch. A case that appears to need it goes to the operator as a capability question. Do not authorize it inside a brief, and do not design an evidence set that can only be satisfied by invoking a model.

---

## Scope of this version

Slices 1–3: opening a unit with a brief, assessing/closing it, the one bounded correction with its closure-check discipline, and admission discipline — the admission test (§ Admission, in [Routing and admission](references/routing-and-admission.md)), de-escalation at assessment, and the deferral discipline that keeps mid-unit improvements out of the work.

Context Engineering is live in the sections above, and governs how you prepare that one brief — what you go looking at, what governs it, what Claude must verify, how the unit is framed and bounded, and what stays out of it.

The project-progression change (2026-08-06) adds the Routing section — now owned by [Routing and admission](references/routing-and-admission.md) — and the core's fourth assessment outcome, Continue.

The progressive-disclosure split (2026-08-17) moves the resolver, courier operation, routing and admission, and unit framing out of this always-loaded body into the four direct references listed in § *What to read, and exactly when*. **Nothing was shortened, softened or dropped**: each rule keeps exactly one semantic owner and reads as it did before, and the harness proves it — the moved-heading inventory admits one owner apiece, and a guard fails if the combined text ever falls below its pre-split volume. What changed is when you pay for it. The body fell from 602 lines and 12,669 words to under 500 and 5,000, so a Work Loop turn — and a `$reorient` recovery in particular — no longer loads courier and unit-framing detail it will not use.

The intake router (2026-08-06) generalises that section from a "continue" router to an ordinary-language intake router. The 2026-08-15 repository-problem migration adds the canonical Codex resolver and retires the former two-command triage/fix split; the routing index owns the current counts.

`/memory-search` (2026-08-09) joins the index as a narrow specialist, taking the Axcíon side to 26. It adds no routing rule: a request naming past precedent has an owner it did not have before.

The mode contract (2026-08-06) makes Discovery, Implementation and Adoption operational. Core § 3 *The unit's mode* owns the definitions; you classify at routing step 4 and record the mode inside `## Lane and unit`. No state field, lane, unit kind or project phase was added.

The bounded-execution outcomes (2026-08-11) answer two failures on the same transport one day apart — a unit that left the bounded path, and a unit that could not fit inside it. They add § *Size the unit against the clock* (now in [Unit framing](references/unit-framing.md)), the five recovery clauses in § *Three outcomes* (now in [Courier operation](references/courier-operation.md)), and two entries in § *What you never do*. **No state field, artifact or stage was added**, and the dispatcher's side is a repair plus one deny set rather than a new mechanism. Both additions here are written guidance and carry that limit honestly: guidance depends on being remembered, and the only structural backstop remains the actor timeout — which is why raising it is refused above.

The packaging outcomes (2026-08-14) are recorded beside the rules they added, in § *Size the unit against the clock* (now in [Unit framing](references/unit-framing.md)). **No state field, artifact or stage was added.**

Courier mode (2026-08-06) adds the one approved way to carry the turn yourself, under core § 4's courier clause. It is optional, off unless the operator approves it, and transport only — it changes nothing about what you frame, what you assess, or what Claude does.
