# Work Loop v2 — unattended operation

**Plan for the next session. Nothing here has been implemented.**
Written 2026-08-06 from an investigate-only session. Author: Claude. Not yet reviewed.

---

## The goal, in the operator's words

> "I would just open codex, write what I want and then invoke the command and codex will open the
> chat window and begin the work by itself. I step out for 40 minutes from the computer. I expect
> claude and codex to work together as long as the context window allows."

Restated as an exit condition: **the operator frames one unit, launches one command, leaves for
~40 minutes, and returns to either a closed unit or a single question that is genuinely theirs** —
having carried nothing by hand in between.

---

## What the investigation established

Five findings, each verified against the files rather than recalled. They set the scope below.

**1. Loop mode exists and the basic transport works. It is NOT proven for unattended reliability.**
`dispatch.sh` without `--carry-one` alternates Codex and Claude until `turn: operator`. What the
2026-08-05 evidence actually shows, re-read line by line:

- `runs/20260805T152939-spike-live-transport.log` — carried three hops, then **failed at hop 4**:
  `STOP [20] actor 'claude' exited 143 after 100s`. Exit 143 is 128+15, i.e. the Claude child was
  killed by `SIGTERM` from outside the dispatcher (a dispatcher timeout would have surfaced as 124).
  What sent that signal was never established.
- `runs/20260805T154555-spike-live-transport.log` — reached `turn: operator` cleanly at hop 3.

> **Correction.** Revisions v0.1 and its first two updates described this as *"four real hops end to
> end with no operator transport."* That is wrong: the four-hop run **ended in a failure**. The
> correct claim is that alternation works and the longest clean run was three hops to an operator
> handoff. The error was mine — asserted from a directory listing of per-hop `.out` files rather than
> from reading the run log's last line. Caught by Codex review, 2026-08-06.

No new transport machinery is needed. Unattended *reliability* remains unproven, and an unexplained
external `SIGTERM` killing an actor mid-run is directly relevant to a walk-away run.

**2. The stop the operator hit was a skill rule, not a script defect.** The 2026-08-06 run
(`runs/20260806T223538-work-loop-v2-intake-router.log`) carried its hop correctly, passed every gate,
and exited 0. It stopped because Codex invoked `--carry-one`, which `.agents/skills/work-loop-v2/SKILL.md:56`
requires: *"Run the command once … the loop does not run on without you."* Combined with `SKILL.md:21`
(*"every reply you give ends with an explicit next instruction to them"*), Codex is instructed to hand
back to the operator after every hop — including when the next turn is a Claude turn Codex itself
just created.

**3. Context is not the limiting factor.** Every hop is a fresh process (`claude -p`, `codex exec` —
`dispatch.sh:409-432`). Nothing accumulates across hops; `logs/work-loop/{task-id}.md` is the entire
shared memory. The run is bounded by hop count, wall-clock, and the first genuine decision — not by
any context window. The operator's mental model should be corrected in the skill text, because it
changes what limits are worth building.

**4. Permission prompts should not bite inside this checkout.** `.claude/settings.json:30` declares
`defaultMode: bypassPermissions` and the child inherits it. The one measured live denial
(`runs/live-permission-denial-2026-08-05.md:17-24`) was staged deliberately in a sandbox *outside*
this repository carrying its own `deny` rule. This remains an assumption to re-verify under a real
unattended run, not a settled fact.

**5. The allowlist does not bound what Claude may change.** `foreign_worktree()` reads
`git status --porcelain` (`dispatch.sh:265-276`). Claude commits its work each hop, so the tree is
clean and its committed changes are invisible to that guard; only stray *uncommitted* files trip it.
This is correct behaviour — Claude is supposed to do real work — but it means the real containment
for an unattended run is: one task, one checkout, local commits only (push stays gated), and the hop
limit. That envelope is currently written down nowhere.

---

## Scope

**In scope:** making a single-task unattended run a documented, guarded, proven operating mode.

**Out of scope, deliberately:**

- **A supervisor that picks the next unit when one closes.** This is what would fill a full 40
  minutes across several tasks. It is a different kind of component — choosing what to work on is
  **judgment, not transport**, so core § 4's courier clause does not cover it and it needs its own
  qualification. See *Deferred* below.
- **Graduating the spike out of `plans/…/handoff-automation-spike/`.** `README.md:3` still calls it
  *"Throwaway spike. Not production, not installed anywhere."* If unattended operation becomes the
  operator's normal way of working, that has to change — but after the proof, not before it.
- **Any change to core § 7.** `turn: operator` stays terminal for all automation. Nothing in this
  plan weakens it.

---

## Does core § 4 permit this?

Yes, and no amendment is needed — but the reasoning should be recorded, because a multi-hop courier
*looks* like a bigger thing than the one-hop courier the clause was written beside.

Core § 4 (`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:194-215`) forbids a courier
from changing state-file content, choosing which actor moves next, continuing past `turn: operator`,
or standing in as evidence. Loop mode does none of these: it reads `turn:` and launches whoever the
file already names, it stops dead at `turn: operator` (`dispatch.sh:474-502`), and its exit code is
explicitly not authoritative over the file.

The clause's own test — *"whether removing the courier changes any decision"* — is passed. Removing
it means the operator pastes the same turns by hand and the same decisions get made.

**Action:** record this as a decision in `logs/decisions.md` rather than amending the core.

---

## Phase 1 — Prove it before changing anything

**Rationale for going first:** this repo's most-logged failure family is a plan asserting facts from
reading rather than execution (`logs/friction-log.md`, the wrap-collector entry). Everything below
Phase 1 is designed against a model of how an unattended run behaves. One real run replaces that
model with evidence, and may well delete some of Phase 2.

**1a. Resolve the launch-path unknown — this is the one genuine unknown.**
The operator wants to launch from a Codex chat. That means `codex exec` running *inside* a Codex
session. **This has never been tested.** The 2026-08-05 proof was not launched that way. Establish
which of these works:

| Launcher | Nested? | Note |
|---|---|---|
| Codex chat runs `dispatch.sh` | yes — `codex exec` inside Codex | what the operator asked for; unproven |
| Operator runs it from a VS Code terminal | no | certain to work; costs one manual step |
| Claude runs `dispatch.sh` | `claude -p` inside Claude | also nested, also unproven |

If nesting fails, the fallback is the operator launching one command — still a single action before
walking away, which satisfies the goal. Do not design around nesting until it is known to work.

**1b. Attended dry run.** Current task, loop mode, `--max-hops 4`, operator present but carrying
nothing. Purpose is to watch what actually stops it.

**1c. The real walk-away run.** `--max-hops 12` (measured: the Claude hop on 2026-08-06 took 400s, so
a Claude+Codex pair is roughly 10 minutes; 40 minutes ≈ 8 hops, and 12 leaves headroom). Detached, so
the launching session is not blocked for 40 minutes. Operator leaves. Evidence written to `runs/` as
a dated live-run record, in the style of `runs/live-carry-one-2026-08-06.md`.

**1d. Launch on a branch, not on `main`.** `git checkout -b work-loop/<task-id>` before launching.
Claude commits every hop, so an unattended run puts several commits somewhere; a branch keeps `main`
clean and makes the whole run droppable with one command. This is the cheap 90% of the isolated-worktree
proposal (see the triage section) and costs one line in the launch habit rather than a subsystem.

**Phase 1 acceptance** (borrowed from the recommendations doc, Addition 2 — the useful part):
one command starts the run with no manual prompt copying; Claude → Codex → Claude → Codex completes
without operator transport; a `turn: operator` stop produces zero subsequent actor launches.

**Exit condition for Phase 1:** a written record naming what stopped the run, at which hop, and
whether the stop was correct.

---

## Phase 2 — The guards

Four items, in value order. 2a is the highest-value change in this whole plan. 2b bounds the run the
way the operator actually thinks about it. 2c is conditional and may never be built. 2d is a rule,
not code.

**2a. Make the run stoppable. `SIGINT`/`SIGTERM` must actually stop it.**

The trap is `trap 'release_lock' EXIT INT TERM` (`dispatch.sh:190`). A bash trap handler that does
not call `exit` returns control to where the script was interrupted. So on `SIGTERM` the dispatcher:

- releases its lock, then **carries on running**;
- never signals the actor, which keeps working;
- and, because the lock is now free, allows a *second* dispatcher to start on the same checkout and
  task — two dispatchers driving one state file, which is the exact failure the lock exists to prevent.

Ctrl-C in an interactive terminal probably escapes this, because the terminal signals the whole
foreground process group and the actor dies with it. A **detached** run — which is what walking away
requires — does not: `kill` reaches the dispatcher alone.

> **Evidence status: INFERRED, not OBSERVED.** Derived from reading `dispatch.sh:190` and bash trap
> semantics. The recommendations doc reports a live probe (dispatcher still alive 2s after `SIGTERM`),
> and an attempt to reproduce that probe in this session was denied at the permission prompt. **The
> implementation session must confirm by execution before fixing, and must separately establish
> whether actor descendants survive** — neither this analysis nor the doc's probe settles that.

*Minimum fix, not the doc's full version:* the trap sets a shutdown flag so the loop cannot launch
another actor, terminates the actor's process tree (`run_bounded` already has the TERM-then-KILL
sweep at `dispatch.sh:355-379` — reuse it rather than write a second one), waits, releases the lock
once, and exits non-zero with an `interrupted` message naming the task, hop and state-file path. An
interrupted actor is **never** retried — interruption may have landed after an unobserved partial
effect. Two or three test cases, not the doc's nine.

**2b. `--deadline SECONDS` — a wall-clock budget for the whole run.**
The operator's unit of planning is time (*"I step out for 40 minutes"*), and the current bound is
hops. `--max-hops 12 --timeout 900` is an upper bound of **three hours**, which is not a bound in any
useful sense for someone expecting to be back in forty minutes.

Behaviour, kept minimal: refuse to launch another actor once the deadline has passed, and exit with a
named `budget exhausted` reason that is **not** confused with completion. Do not implement the
recommendations doc's checkpoint margin, cost ceiling, or deadline-aware actor prompting — the first
two are machinery and the third changes the actor prompt, which is protocol, for a convenience. A
run that hits the deadline stops in a resumable state; the state file and Git are untouched by the
stop, so the next run continues from them.

**2c. `--expect-turn ACTOR` — conditional, and probably not needed.**
*Demoted from Phase 2a on review.* This flag guards the **repeating-courier** shape: Codex running
one-hop carries back to back. If the answer to the operator's goal is unattended loop mode, that
shape never gets built and the flag guards a hazard that cannot occur. The residual two-Codex
collision — a chat Codex carrying a hop while a loop run is in flight — is already refused by the
lock (`dispatch.sh:177-192`, exit 17: one dispatcher per checkout+task).

**Build this only if Phase 1 concludes that the repeating courier is a shape worth keeping.** If it
is: this run may launch `ACTOR` and nothing else; if `turn:` names the other actor, exit 27 without
launching; requires `--carry-one`, since in loop mode the turn alternates by design. It would turn
`SKILL.md:55` (*confirm `turn:` is `claude`*) from a disposition into a check. Add `dispatch.test.sh`
case 27, both halves.

**2d. No hand-editing while a run is in flight.**
The lock (`dispatch.sh:177-192`, exit 17) stops a second *dispatcher* on the same checkout+task. It
does **not** stop the chat Codex from writing the state file directly while a loop run is mid-hop —
and Codex writes that file by hand, never through the dispatcher. For an unattended run this is a
real corruption path.

Fix as a skill rule first (*"once you have launched a run, the state file is not yours until it
exits"*). A visible in-checkout marker would be stronger, but it conflicts with the dispatcher's
stated design property of creating *"no queue and no shadow state"* (`README.md:9-11`). **Flagging
this tension rather than resolving it — it is an operator decision, not mine.**

---

## Phase 3 — Say that this mode exists

The protocol currently documents one approved courier shape. It needs two, and the operator needs to
know which to use when.

**3a. `SKILL.md` § Courier mode — rewrite.** Two approved shapes:

- **Attended carry** (`--carry-one`) — Codex stays in the conversation, carries one hop, assesses,
  reports. Use when the operator is at the machine and wants to watch.
- **Unattended run** (loop mode) — Codex frames the unit, launches, and gets out of the way. Use when
  the operator is leaving.

Rule 2 at `SKILL.md:56` (*"the loop does not run on without you"*) becomes false as a general
statement and must be rewritten as a property of the attended shape only. The Next-line rule at
`SKILL.md:21` needs a carve-out: when a run is in flight, the Next line names the run and where its
evidence will be, not an instruction to go and paste something.

**3b. State the risk envelope honestly.** Finding 5 above, written where the operator will read it
before walking away: the allowlist catches stray uncommitted files, not committed work. Real
containment is one task, one checkout, local commits, hop limit, push gated.

**3c. Correct the context model.** One line: hops are fresh processes, the state file is the memory,
the run is not context-bounded.

**3d. Do not mix the shapes.** A chat Codex running courier hops *and* a loop running headless Codex
turns is two instances of one actor. State it plainly.

**3e. `README.md` + exit-code table** for `--expect-turn` / 27 and the interrupted exit from 2a, plus
the walk-away invocation as a worked example.

**3f. What Codex says when the operator gets back — one rule, not a report format.** On return,
Codex reports from the state file and the run log, and **separates repository facts from model
claims**: *"the dispatcher observed exit 0"* and *"Claude reports the tests passed"* are different
statements, and neither means Codex accepted the evidence. This is the whole of Addition 10 that is
worth having; the doc's eight-element report specification is not needed when Codex is reading two
files it already knows how to read.

---

## Phase 4 — Optional hardening

Only if Phase 1 shows a need. Listed so they are not silently forgotten.
*(`--deadline` was here; promoted to 2b on review — it is worth more to this operator than the flag
it replaced.)*

- **End-of-run summary line** in the run log — final `turn:`, hop count, stop reason, in one place, so
  the returning operator reads one line instead of reconstructing the run.
- **Raising the `--max-hops` default** from 4. Prefer documenting the walk-away invocation over
  changing the default; the current default is safe and a default is silent.

---

## Deferred — the supervisor

**Recommendation: do not build it in the implementation session. But be honest about what that costs.**

**Correction to this section, 2026-08-06 (Codex review).** An earlier revision said this plan
delivers *"one unit, unattended"* and treated the gap to *"40 minutes of work"* as large. That
understated what the loop already does. **A task spans many units, and Codex opens the next one
itself:** `SKILL.md:289` — *"When the accepted unit leaves the task's named exit condition unmet,
continue rather than close"* — with the mechanics in core § 3 *Continuing*. Codex writes the next
unit's brief and sets `turn: claude`, and the loop carries straight on. No supervisor is involved.

So the correct statement of the gap is narrower: **a supervisor is only needed to choose an entirely
new task once the current task's exit condition is met.** Within one task, the 40 minutes can already
fill themselves.

Loop mode carries one task. When that *task* closes — not each unit — the run ends.

The principled objection stands — picking the next unit is judgment, not transport, so core § 4 does
not license it, and it is exactly what `/develop-ai-resource` exists to qualify, including the
outcome *no build*. But the principle is not the reason to wait. **The reason to wait is that Phase 1
measures the gap.** If one unit runs 40 minutes unattended, the supervisor buys nothing. If it runs
15, the supervisor becomes the main item and this plan's ordering is wrong. That is one measurement
away, not one argument away.

*Loose end:* an untracked file `logs/work-loop/work-loop-v2-supervisor-ideas-assessment.md` existed at
the start of the 2026-08-06 session and is no longer on disk. It was never committed. If it held
supervisor thinking, it is gone. Worth one look in the Codex hop output before re-deriving anything.

---

## Triage of `dispatcher-context-material-recommendations-2026-08-06.md`

Reviewed against one operator constraint, stated verbatim: *"I don't want to make the system too
complex with too much governance and safeguards. I also don't want to run the risk of overbuilding
and overengineering."*

Net result: **one real new build item** (safe interruption), **one launch habit** (branch), **two
documentation lines**. Everything else is already true, or deferred.

| # | Recommendation | Verdict | Why |
|---|---|---|---|
| 1 | One-command intake and launch from Codex | **Adopt, thin** | The valuable half is *"and then launch"*. Framing the brief, deriving the task id and recording boundaries is what Codex already does under the skill. Already Phase 3a; the doc's preflight/worktree/cost-ceiling launcher is not adopted. |
| 2 | Unattended Claude ↔ Codex cycling | **Already exists** | Loop mode, live-proven 2026-08-05. The doc's own inventory says so. Its acceptance list is useful and is now Phase 1 acceptance. |
| 3 | Total run budgets | **Adopt the clock only** | A plain wall-clock `--deadline` is now Phase 2b — *promoted on review*, because the operator plans in time and the current bound is a 3-hour hop ceiling. Drop the checkpoint margin, the cost ceiling (no reliable telemetry) and telling the actor its own deadline — that last one changes the actor prompt, which is protocol, for a convenience. |
| 4 | Automatic checkpoints | **Already true** | Every handback *is* a checkpoint: state file plus Claude's commit, validated structurally by exits 22 and 25. The only new part is deadline-aware handback, which depends on adopting the part of 3 that was dropped. |
| 5 | Fresh-session continuity | **Already true** | This is the architecture, not an addition. The doc agrees, and its own advice on context rollover is *don't, until telemetry or observed failures justify it*. Agreed. |
| 6 | Isolated worktree | **Substitute** | Real value (unattended commits stay off `main`) at real cost (worktree lifecycle, the parallel-sessions gates, the friction-log co-edit). A branch buys ~90% of it for one command. Phase 1d. Revisit only for parallel runs. |
| 7 | Ten derived operational states | **No** | Ten labels for one serial process. The doc's own test — *"removing the display changes no decision"* — is the argument against building it now. Revisit if several loops ever run at once. |
| 8 | Safe interruption and recovery | **Adopt — top priority** | Directly serves walk-away: you must be able to stop a run you left behind. Scoped to the minimum in Phase 2a: shutdown flag, kill the tree, exit non-zero, 2–3 tests — not 8 required behaviours and 9 acceptance tests. |
| 9 | Structured JSON outcome + notification observer | **No, keep the cheap part** | A JSON event tells nobody anything until something consumes it, and the observer is a second process to maintain. The run log's closing lines already say what happened in English. Phase 4 already has a one-line final summary; a two-line desktop notification at run end is optional if wanted. |
| 10 | Final return report | **Adopt as one rule** | Phase 3f. The fact-versus-claim distinction is the valuable part and costs one sentence. The eight-element report specification is not needed — Codex reads two files it already knows. |

**The doc's *"Ideas that should not be added"* section is well-judged and adopted wholesale.** It
rejects a second state directory, a SQLite ledger, automatic evidence judgment, autonomous worktree
landing/teardown, a VS Code extension, a second workflow state machine, and hidden session resume.
That section is the reason this document is worth reading rather than merely long.

### One disagreement on order

The doc's recommended order hardens the dispatcher (its steps 2–4) *before* proving unattended
cycling (its step 5). **This plan proves first, deliberately.**

Loop mode already works; nothing in Phases 2–4 is needed to run it once. Hardening first means
designing three guards against a model of how an unattended run behaves, when one real run would
replace that model with evidence — and this repo's most-logged failure family is exactly a plan whose
load-bearing claims came from reading rather than execution (`logs/friction-log.md`, wrap-collector
entry). The single exception is 2a, which is a defect rather than a design guess; if the operator
would rather be able to abort the first walk-away run, 2a can move ahead of Phase 1c at low cost.

### One scoping correction

The doc's *"Existing prerequisites that remain higher priority"* (headless session identity, the
ambient `friction-log.md` writer) reads as a blocker on everything here. It is not, for this use case.
Both are scoped to **parallel** operation:
`logs/work-loop/work-loop-v2-production-readiness-policy.md:374` states *"U1 and U2 are both
prerequisites to any real parallel run"*, and its blocked steps concern worktrees and a maximum
fan-out of 2.

This plan is single-task, single-checkout, serial. That path is already proven: the 2026-08-06 hop
ran headless in the main checkout and committed successfully (`9fb59b1` → `c2036d5`). The
prerequisites gate Addition 6's worktrees, which this plan does not adopt.

---

## Sequencing

```
Phase 1  prove       →  1a launch path · 1b attended · 1c walk-away · 1d branch  (no code changes)
                        MEASURE: how long does one unit actually run unattended?
Phase 2  guard       →  2a stoppable run (confirm, then fix) · 2b --deadline
                        2c --expect-turn (conditional, may be dropped) · 2d in-flight rule
Phase 3  document    →  3a-3f skill + README
Phase 4  harden      →  only what Phase 1 justifies (summary line, optional notification)
Deferred supervisor  →  decided by Phase 1's measurement, not by argument
```

Phase 1 gates the rest. If the walk-away run reveals something none of this anticipates, Phases 2–4
get rewritten against the evidence rather than defended.

---

## Open questions for the operator

1. **Launch path.** If nesting `codex exec` inside a Codex chat does not work, is launching one
   command yourself from VS Code acceptable? (It is still one action before you leave.)
2. **In-flight protection (2b).** Skill rule only, or a visible marker file that breaks the
   dispatcher's no-shadow-state property?
3. **Hop budget.** Is 12 the right ceiling for a 40-minute absence, or would you rather set a
   wall-clock deadline (Phase 4) and let hops fall where they fall?
4. **Review.** This plan authorises execution, and this repo's own record says execution-authorising
   plans carry unverified claims. Should Codex review it before the implementation session starts?
5. **Order.** Phase 2a (making the run stoppable) is a defect fix, not a design guess. Do you want it
   *before* the first walk-away run so you can abort it, or are you content to let the first proof run
   to its hop limit unabortable?
6. **Notification.** Optional two-line desktop notification when a run ends — worth it, or noise?

---

## Revision note

**Second revision (2026-08-06), after the operator challenged the restraint.** Re-ran every rejection
against one test — *what breaks during a 40-minute unattended run if this is absent?* The rejections
of Additions 4, 5, 6, 7, 9 and the heavy halves of 1, 3 and 10 all survived: nothing breaks. Three
changes made:

- `--deadline` **promoted** from optional Phase 4 to Phase 2b. The operator plans in wall-clock and
  the existing bound is a 3-hour hop ceiling. It is worth more than the flag it overtook.
- `--expect-turn` **demoted** to conditional Phase 2c. It guards the repeating-courier shape, which
  unattended loop mode makes unnecessary, and the lock already refuses a second dispatcher. It was
  ranked on novelty rather than on value.
- The supervisor deferral now states plainly that it is the one restraint that may fail the goal
  rather than protect it, and that Phase 1's measurement decides it.

**v0.1 → first revision (2026-08-06):** triaged against
`dispatcher-context-material-recommendations-2026-08-06.md`. Adopted: safe interruption (new Phase
2a, promoted to top priority), a branch instead of a worktree (1d), Phase 1 acceptance criteria, and
the fact-versus-claim reporting rule (3f). Rejected for now: derived operational states, the JSON
outcome event and observer, isolated worktrees, the full budget envelope, and the specified return
report. Recorded one disagreement on order and one scoping correction.
