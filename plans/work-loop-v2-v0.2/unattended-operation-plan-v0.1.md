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

**1. Loop mode already does this, and is live-proven.** `dispatch.sh` without `--carry-one`
alternates Codex and Claude until `turn: operator`. The 2026-08-05 run carried four real hops
(codex → claude → codex → claude) end to end with no operator transport:
`runs/20260805T152939-spike-live-transport.log`. No new transport machinery is needed.

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

**Exit condition for Phase 1:** a written record naming what stopped the run, at which hop, and
whether the stop was correct.

---

## Phase 2 — The two guards

Small, and both are consequences of the loop being able to repeat.

**2a. `--expect-turn ACTOR` (new flag, new exit code 27).**
This run may launch `ACTOR` and nothing else; if `turn:` names the other actor, exit 27 without
launching. Requires `--carry-one` — in loop mode the turn alternates by design, so the guard would
end a healthy run on a failure code.

*Why:* `SKILL.md:55` tells Codex to confirm `turn:` is `claude` before running the courier command.
That is a disposition with no check behind it. If a repeating courier misreads the file while
`turn: codex`, `dispatch.sh:409-418` launches a **second, headless Codex** — two instances of the same
actor writing one state file. Core § 4 forbids a courier from choosing which actor moves; this makes
that a check rather than a trust. Add `dispatch.test.sh` case 27, both halves (guard fires on the
wrong turn; guard is silent on the right one).

**2b. No hand-editing while a run is in flight.**
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

**3e. `README.md` + exit-code table** for `--expect-turn` / 27, and the walk-away invocation as a
worked example.

---

## Phase 4 — Optional hardening

Only if Phase 1 shows a need. Listed so they are not silently forgotten.

- **`--deadline SECONDS`** — total wall-clock budget for the run. `--max-hops × --timeout` is an upper
  bound but a very loose one (12 × 900 = 3 hours), and "I am away for 40 minutes" maps to a clock, not
  a hop count.
- **End-of-run summary line** in the run log — final `turn:`, hop count, stop reason, in one place, so
  the returning operator reads one line instead of reconstructing the run.
- **Raising the `--max-hops` default** from 4. Prefer documenting the walk-away invocation over
  changing the default; the current default is safe and a default is silent.

---

## Deferred — the supervisor

**Recommendation: do not build it in the implementation session.**

Loop mode carries one task. When that task closes, the run ends — even with 25 minutes left. Filling
the whole window across several units needs something that picks what to work on next.

That is not transport, so core § 4 does not license it, and it is exactly the kind of component that
`/develop-ai-resource` exists to qualify — including the outcome *no build*. Reopen it once Phase 1
shows how long a single unit actually runs unattended. If the answer is "40 minutes on one unit," the
supervisor buys nothing.

*Loose end:* an untracked file `logs/work-loop/work-loop-v2-supervisor-ideas-assessment.md` existed at
the start of the 2026-08-06 session and is no longer on disk. It was never committed. If it held
supervisor thinking, it is gone. Worth one look in the Codex hop output before re-deriving anything.

---

## Sequencing

```
Phase 1  prove       →  1a launch path · 1b attended · 1c walk-away  (no code changes)
Phase 2  guard       →  2a --expect-turn + test 27 · 2b in-flight rule
Phase 3  document    →  3a-3e skill + README
Phase 4  harden      →  only what Phase 1 justifies
Deferred supervisor  →  qualify separately, or not at all
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
