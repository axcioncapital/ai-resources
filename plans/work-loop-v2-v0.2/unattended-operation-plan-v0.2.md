# Work Loop v2 — unattended operation, v0.2

**Supersedes `unattended-operation-plan-v0.1.md`, which is retained. Written 2026-08-06.**
Author: Claude. Revised after independent Codex review of v0.1.

> ## Implementation status — 2026-08-07
>
> | Item | State |
> |---|---|
> | **Phase 0** — attended launcher proof (0a nested launch, 0b detached checklist, 0c multi-hop) | **not started** — needs the operator at the keyboard with Codex; cannot be done by Claude alone |
> | **1a** stoppable run | **done.** Defect confirmed by execution first (`runs/probe-interruption-2026-08-07.md`), then fixed. Exit `28`. Tests: case 27 |
> | **1b** true deadline | **done.** `--deadline`, clamps the actor timeout before every launch and every retry. Exit `29`. Tests: cases 28–28d |
> | **1c** committed-path check | **done.** Exit `30`. Tests: cases 29–29c |
> | **1d** unattended authority | **mechanism verified** (`runs/probe-unattended-authority-2026-08-07.md`); `--claude-deny` plumbing added, **default off**. *The policy decision itself is still open and still the operator's* |
> | **1e** no sleep | **done as documentation** — `caffeinate -i` in the worked invocation, spike `README.md` |
> | **1f** branch isolation | **done as documentation** — branch + clean tree + the worktree blocker, spike `README.md` § Safety boundaries |
> | **1g** read-only status | **done.** `--status`. Tests: cases 30–30c |
> | **Phase 2** — walk-away pilot | **blocked**, correctly: Phase 0 has not run and 1d is unsettled |
> | **Phase 3** — documentation (3a–3h) | **done.** `SKILL.md` § Courier mode + § The seam; spike `README.md` |
> | Core § 4 decision | **recorded** in `logs/decisions.md`, 2026-08-07 |
>
> Suite: **149 pass, 0 fail** — all simulated. **No live unattended run has happened.**
>
> **One finding changes the plan's own text.** § 1d proposes offering the operator *"no push, no
> network"*. The push half works. **The network half does not exist by this mechanism** — denying
> `WebFetch`/`WebSearch` sends the child to `curl` via Bash, observed twice. Network containment
> needs an OS-level sandbox, not a permission rule. § 1d's option should be read as *"no push"*
> alone, with the network exposure stated in the risk envelope rather than designed around.
>
> ### Review round — 2026-08-07, operator-supplied review of the above
>
> Verdict was **not approved**, Phase 2 not to begin. Five findings; four accepted and fixed, one
> disputed on the facts.
>
> | # | Finding | Disposition |
> |---|---|---|
> | 1 | Phase 0 gate skipped | **Disputed in part.** Phase 0 genuinely has not run and Phase 2 stays blocked — that conclusion stands and was already this plan's own status. But it was a *disclosed* deviation, not a skip: 0a/0c need the operator at the keyboard with Codex, and 1a/1b/1c/1g are dispatcher-internal — none changes shape with the launch path. The plan's own 0b item 4 makes the *stop* question depend on 1a, not the reverse. |
> | 2 | `--claude-deny` had no end-to-end test | **Accepted.** Cases 31 / 31b added: a fake `claude` binary records the argv the dispatcher builds, asserting the flag reaches the child (metacharacters intact, repeatable) and that its absence changes nothing. |
> | 3 | "Whole process tree" overstated | **Accepted — the sharpest finding.** It is a process-*group* kill. Wording corrected in `dispatch.sh`, the probe record and `README.md`; case 27b now asserts the real boundary (a `setsid`'d descendant survives, and the case fails if that silently changes). |
> | 4 | Deadline clock start, grace period, loose test | **Accepted, all three.** `RUN_START` moved to the script's first statement; the worst-case overrun is now stated as `1s poll + 5s TERM→KILL grace + reaping ≈ 6s` instead of "the poll interval"; case 28's bound tightened from `< 20s` to `<= 11s` derived from that arithmetic. Case 28b was also rewritten — it was asserting a timing-dependent hop count and could land on the wrong branch. |
> | 5 | Probe records not reproducible | **Accepted.** The interruption record claimed a verbatim script and showed pseudocode. Real scripts and raw captures now live in `runs/probes/`, including a genuine **before/after** capture produced by running the probe against the pre-fix dispatcher retrieved from git (`2dd2112`). |
>
> Nothing in this round changes what is proven: controller logic only. Live transport, detached
> survival, sleep prevention, isolation and the permission flag under a real model remain unproven,
> and Phase 0 is still the gate.

**Evidence convention, used throughout.** Every load-bearing claim is marked **OBSERVED** (a command
was run, or a file re-read at a cited line) or **INFERRED** (derived by reasoning). v0.1 carried two
INFERRED claims dressed as OBSERVED and both were false — see *What changed from v0.1*. An INFERRED
claim may not authorise a fix; it authorises a check.

---

## The goal

> The operator describes one task in Codex, invokes one command, leaves for roughly 40 minutes, and
> returns to either finished work or one decision that is genuinely theirs — having carried nothing
> by hand in between.

---

## Established facts

**1. Basic transport works. Unattended reliability is unproven.** `dispatch.sh` without `--carry-one`
alternates Codex and Claude until `turn: operator`. **OBSERVED** — the two 2026-08-05 live runs:

- `runs/20260805T154555-spike-live-transport.log` — three hops, reached `turn: operator` cleanly.
  This is the longest clean run on record.
- `runs/20260805T152939-spike-live-transport.log` — three hops, then **failed at hop 4**:
  `STOP [20] actor 'claude' exited 143 after 100s`. 143 is 128+15 — the Claude child was killed by an
  external `SIGTERM`. A dispatcher timeout would have surfaced as 124, so the signal came from
  somewhere else. **What sent it was never established, and that is directly relevant to a run
  nobody is watching.**

**2. A task spans many units, and the loop already chains them.** **OBSERVED** — `SKILL.md:289`:
*"When the accepted unit leaves the task's named exit condition unmet, continue rather than close"*,
with mechanics in core § 3 *Continuing*. Codex writes the next unit's brief, sets `turn: claude`, and
the loop carries on. **No supervisor is involved in filling 40 minutes within one task.**

**3. Context is not the limiting factor.** **OBSERVED** — `dispatch.sh:409-432`: each hop is a fresh
`claude -p` / `codex exec` process. Nothing accumulates; `logs/work-loop/{task-id}.md` is the entire
shared memory. The run is bounded by time, hops, and the first real decision.

**4. Permission prompts should not fire inside this checkout.** **OBSERVED** —
`.claude/settings.json:30` declares `defaultMode: bypassPermissions`; the 2026-08-06 hop ran headless
and committed (`9fb59b1` → `c2036d5`). The problem is not that Claude will be blocked. The problem is
how much it is allowed to do — see 1d.

**5. The allowlist does not see committed changes.** **OBSERVED** — `foreign_worktree()` reads
`git status --porcelain` (`dispatch.sh:265-276`). Claude commits each hop, so its work leaves a clean
tree and passes the guard. Only stray *uncommitted* files trip it.

**6. The parallel-operation prerequisites do not gate this plan's serial path — but they do gate
worktrees.** **OBSERVED** — `logs/work-loop/work-loop-v2-production-readiness-policy.md:374`:
*"U1 and U2 are both prerequisites to any real parallel run"*; its step 6 (ambient `friction-log.md`
writer under worktrees) is marked **blocked** at line 252. See 1f.

---

## Scope

**In scope:** one task, one checkout, serial, unattended, bounded by a hard clock.

**Out of scope:** a supervisor that selects a *new task* after the current one closes (see *Deferred*);
parallel or multi-worktree operation; any change to core § 7 — `turn: operator` stays terminal.

**Does core § 4 permit this?** Yes, and no amendment is needed. **OBSERVED** — core § 4 at
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:194-215` forbids a courier from changing
state-file content, choosing which actor moves, passing `turn: operator`, or standing in as evidence.
Loop mode does none of these: it launches whoever `turn:` already names and stops dead at
`turn: operator` (`dispatch.sh:474-502`). The clause's own test — *does removing the courier change
any decision?* — is passed. Record as a decision in `logs/decisions.md` rather than amending the core.

---

## Phase 0 — Attended launcher proof

**No code changes. Nothing here can run unattended, so nothing here needs the Phase 1 safety work.**

This phase exists because three unknowns, if resolved the wrong way, would make the Phase 1 safety
work land on the wrong shape. It is cheap, it is safe, and it happens at the keyboard.

**0a. Can a dispatcher run be launched from inside a Codex task?**
The operator wants to launch from Codex chat, which means `codex exec` nested inside a Codex session.
**Never tested.** The 2026-08-05 proofs were not launched that way.

**0b. Detached-process survival — the full checklist** *(from Codex review #7, expanding v0.1's 1a)*.
"Detached" was asserted in v0.1 without definition. Establish each:

1. what keeps the dispatcher alive after the launching Codex turn ends;
2. whether the nested `codex exec` runs reliably at all;
3. how its process id and log paths are discovered afterwards;
4. how the operator stops it (depends on 1a of Phase 1);
5. how the originating Codex task learns the run finished;
6. whether Claude and Codex authentication tolerate concurrent parent and child use.

If detached survival fails, the fallback is a supervised shell session — **not** an SDK or App Server
integration, which is a large build for a problem not yet shown to need it.

**0c. Attended multi-hop run, with `continue` exercised.**
Loop mode, `--max-hops 6`, operator present, carrying nothing. Ctrl-C works here because the terminal
signals the whole foreground process group, so this is safe without the Phase 1a fix.

**Measure and write down:**

- how long one unit actually takes end to end;
- whether Codex's `continue` chains to a second unit inside the same task without intervention;
- what stopped the run, at which hop, and whether the stop was correct.

**Why the measurement matters:** it decides whether the supervisor is ever worth building, and it
converts the 40-minute target from a guess into a hop count.

---

## Phase 1 — Safety prerequisites

**All of these land before any walk-away run.** *This is a change from v0.1, which scheduled the
walk-away first. Codex review #1 is right: a run you cannot stop is not an experiment, it is an
incident waiting for a name.*

### 1a. Make the run stoppable

> **Promoted INFERRED → OBSERVED, 2026-08-07, and it was worse than predicted.**
> `runs/probe-interruption-2026-08-07.md` ran the probe this section demanded. All three predictions
> below held, plus the two things the section could not settle:
> **actor descendants survived** (a grandchild outlived the sweep, because `pkill -P` reaches one
> generation only), and the lock was **released**, so a second dispatcher was admitted at exit `0`
> while the first was still running. The signal did not stop the run — it *unlocked* it.
> Fixed: the actor now runs in its own process group (`set -m`) and the handler terminates the group,
> releases the lock once, and exits `28`.

**Evidence status: INFERRED** *(as written 2026-08-06; superseded by the note above)*. Derived from
`dispatch.sh:190` (`trap 'release_lock' EXIT INT TERM`)
and bash trap semantics: a handler that does not call `exit` returns control to where the script was
interrupted. The consequence would be that `SIGTERM`:

- releases the lock, then lets the dispatcher **carry on running**;
- never signals the actor, which keeps working;
- and, with the lock now free, permits a *second* dispatcher on the same checkout and task — the
  exact collision the lock exists to prevent.

Ctrl-C in an interactive terminal likely escapes this, because the terminal signals the whole
foreground group. A detached run does not.

> **First task is confirmation, not repair.** Run the probe (long simulated actor via `--actor-cmd`,
> `SIGTERM` the dispatcher, observe dispatcher, actor and descendants). An attempt to run it during
> the 2026-08-06 investigation was denied at the permission prompt. **Establish separately whether
> actor descendants survive** — neither the analysis above nor Codex's probe settles that.

*Fix, minimum shape:* the trap sets a shutdown flag so the loop cannot launch another actor;
terminates the actor's process tree (reuse the TERM-then-KILL sweep already at `dispatch.sh:355-379`
rather than writing a second one); waits for reaping; releases the lock once; exits non-zero with an
`interrupted` message naming task, hop and state-file path. **An interrupted actor is never retried**
— interruption may have landed after an unobserved partial effect. Two or three test cases.

### 1b. A deadline that is actually a deadline

*Codex review #2 — a correct catch against v0.1, which only refused to **start** an actor past the
deadline. An actor starting at minute 39 with a 900s timeout runs to minute 54, and
`--max-hops 12 --timeout 900` has a three-hour upper bound.*

Before every launch:

```
effective actor timeout = min(--timeout, remaining time to deadline)
```

When the global clock expires, terminate the current actor through the same path as 1a and record a
named `budget exhausted` outcome. **Budget exhaustion is not completion** and must never be reported
as one — the state file and Git are untouched by the stop, so the next run resumes from them.

A deadline kill leaves the same partial-effect risk as an interruption. Treat it identically:
inspection required, never an automatic retry.

### 1c. Check what Claude committed, not just what it left uncommitted

*Codex review #3 — v0.1 found this gap (fact 5) and then accepted it. Fair criticism.*

After every Claude hop, compare `before_head..after_head` (`git diff --name-only`) and stop the run if
any committed path falls outside the allowlist. Detection, not prevention — the commit has happened;
the value is stopping rather than compounding.

**Honest cost, which the review does not mention:** this only works if `--allow-path` describes what
the *unit* may legitimately touch. That makes the allowlist a per-task input Codex must derive when it
writes the brief, and a wrong allowlist produces false stops. This is real work, not a free flag.

### 1d. Unattended authority — **operator decision, not a designed answer**

*Codex review #4, its strongest point.* Unattended for 40 minutes, Claude currently holds
`bypassPermissions`, `Bash(*)`, web access and broad file editing, against a deny list of `rm -rf *`
and `sudo *`. A branch protects the `main` ref. It protects nothing else: not the network, not paths
outside the checkout, not credentials. `git push` is held only by a CLAUDE.md rule — a model-side
rule, which is weaker than usual precisely when nobody is watching.

**Two reasons this plan does not simply specify a profile:**

1. **It contradicts a standing operator decision** — bypass mode plus model-side rules, no deny-list
   expansion. That decision was made for attended sessions; unattended is a materially different
   case, which is a reason to revisit it and not a reason to override it quietly. **Surfaced, not
   resolved** (workspace `CLAUDE.md` § Design Judgment Principles).
2. **The mechanism is unverified.** How a headless child is given a *different* policy from the
   operator's interactive sessions has not been checked. Specifying a profile before knowing whether
   one can be scoped to that child would repeat exactly the failure that produced this revision.

*Sequence:* verify the mechanism → put the narrow option to the operator (no push, no network) rather
than a broad denylist → implement only what they choose. **This is a blocking item for the walk-away
run in Phase 2, and the only one in this plan the operator must personally settle.**

### 1e. Stop the machine going to sleep

*Codex review #9 — missed entirely by v0.1, and a hard blocker: if the Mac sleeps, the run dies.*
Wrap the launch in `caffeinate -i` (or the equivalent Codex "prevent sleep while running" option if
launching from a Codex task). One line, and without it the 40-minute premise fails on its own.

### 1f. Isolation: a branch for the pilot, a worktree once it is unblocked

*Codex review #5 — its technical criticism is accepted and v0.1's "a branch is 90% of a worktree" is
**withdrawn**.* A branch shares the working directory and index with the operator's session, carries
uncommitted changes across, and switches the checkout they have open.

**But a worktree is not currently free** (fact 6): the ambient `friction-log.md` hook writes a tracked
file, which the production-readiness policy marks **blocked** at line 252 as a guaranteed landing
conflict.

**Resolution — and it follows the review's own acceptance condition.** Codex allows a branch-only
pilot in *"a clean checkout that no other process or person will touch."* Walking away satisfies that
by definition. So:

- **Pilot:** a branch, `work-loop/<task-id>`, from a clean tree, documented as a **temporary
  limitation** with the reason. Nobody opens the checkout while the run is live.
- **Standing use:** a dedicated worktree, gated behind the `friction-log.md` fix. Not this session.

### 1g. A read-only way to look without touching

*Codex review #8.* A `--status` mode that reads the lock and the state file and writes nothing:
is a run in flight, which task, which hop, current `turn:`, where the logs are.

This does double duty. It answers *"is it still going?"* on return, and it gives the skill rule
(*once you have launched a run, the state file is not yours until it exits*) something to check
instead of something to remember. The lock stops a second dispatcher (`dispatch.sh:177-192`, exit 17);
it does not stop the parent Codex task from editing the file by hand.

---

## Phase 2 — The bounded walk-away pilot

Only after every Phase 1 item lands, with 1d settled by the operator.

- one task, one isolated location (1f), on a branch off a clean tree;
- a hard ~40-minute deadline (1b), hop limit as a secondary bound;
- no push, no merge, no deployment, no external side effects;
- sleep prevented (1e), stop control proven (1a), status readable (1g);
- an end-state notification — the Codex task-completion notification if it serves, rather than a
  custom observer process.

**Record, in `runs/`, as a dated live-run record:** what stopped it and at which hop; how many units
the task advanced through; how long each unit took; whether any Phase 1 guard fired, and whether it
fired correctly.

---

## Phase 3 — Documentation

**3a. `SKILL.md` § Courier mode — two approved shapes.** *Attended carry* (`--carry-one`) for when the
operator is watching; *unattended run* (loop mode) for when they are leaving. Rule 2 at `SKILL.md:56`
(*"the loop does not run on without you"*) is false as a general statement and becomes a property of
the attended shape only. The Next-line rule at `SKILL.md:21` gains a carve-out: while a run is in
flight, the Next line names the run and where its evidence will be.

**3b. Three outcomes, never blurred:** finished, operator decision required, and stopped by a
guard/failure/budget. `budget exhausted` is not completion.

**3c. What stays forbidden unattended** — the outcome of 1d, written where it will be read before
launching.

**3d. The honest risk envelope.** The allowlist catches stray uncommitted files; 1c adds committed
paths; neither prevents, both detect. Real containment is: one task, one branch, local commits, hard
deadline, push gated.

**3e. Correct the context model.** Fresh process per hop, state file is the memory, not
context-bounded.

**3f. Do not mix the shapes.** A chat Codex carrying hops while a loop run is in flight is two
instances of one actor. 1g makes this checkable.

**3g. What Codex says on the operator's return — one rule, not a report format.** Report from the
state file and the run log, and **separate repository facts from model claims**: *"the dispatcher
observed exit 0"* and *"Claude reports the tests passed"* are different statements, and neither means
Codex accepted the evidence.

**3h. `README.md` + exit-code table** for the new interrupted and budget-exhausted exits, plus the
walk-away invocation as a worked example.

---

## Deferred

**The supervisor — now a much smaller gap than v0.1 claimed.** Fact 2: a task already spans many units
and Codex chains them itself. A supervisor is only needed to choose an entirely **new task** once the
current one closes. Whether that is worth building is decided by Phase 0c's measurement, not by
argument: if one task fills 40 minutes, it buys nothing.

**`--expect-turn` — probably dead.** It guarded the repeating-courier shape, which unattended loop
mode makes unnecessary, and the lock already refuses a second dispatcher. Build only if Phase 0
concludes the repeating courier is worth keeping.

**Rejected for now, with reasons recorded in v0.1's triage section:** ten derived operational states;
a structured JSON outcome event plus observer process; the full budget envelope (checkpoint margins,
cost ceilings, deadline-aware actor prompting); the eight-element return report specification; a
second state directory; a durable execution ledger; a VS Code extension. v0.1's triage table stands —
do not re-litigate these without new evidence.

**Graduating the spike out of `plans/…/handoff-automation-spike/`.** `README.md:3` still calls it
*"Throwaway spike. Not production, not installed anywhere."* If this becomes normal working practice
that has to change — after Phase 2, not before.

---

## Sequencing

```
Phase 0  attended proof    →  0a nested launch · 0b detached checklist · 0c multi-hop + continue
                              MEASURE: unit duration, does continue chain, what stops it
                              (no code changes · safe at the keyboard · Ctrl-C works)
Phase 1  safety            →  1a stoppable (confirm→fix) · 1b true deadline · 1c committed paths
                              1d authority [OPERATOR] · 1e no sleep · 1f branch · 1g status
Phase 2  walk-away pilot   →  one task · hard clock · isolated · notified · recorded
Phase 3  document          →  3a-3h skill + README
Deferred                   →  supervisor (decided by 0c) · worktree (after friction-log) · the rest
```

**Phase 0 gates Phase 1; Phase 1 gates Phase 2; 1d gates Phase 2 absolutely.**

---

## What changed from v0.1

Driven by independent Codex review, 2026-08-06. Eight findings adopted outright, two adopted with
changes, one point of sequencing disagreed.

**Two factual errors in v0.1, both verified before correcting:**

- *"Four real hops end to end with no operator transport."* **False.** That run failed at hop 4 with
  `exit 143` — an external `SIGTERM`. The longest clean run is three hops. The claim came from a
  directory listing of per-hop `.out` files rather than the log's last line.
- *"Loop mode carries one task; the supervisor gap is large."* **Overstated.** `SKILL.md:289` —
  Codex continues to the next unit within the same task. The supervisor is only needed across tasks.

**Adopted outright:** safety before the walk-away run (#1); a real deadline that clamps the actor
timeout (#2); committed-path checking (#3); the detached-launch checklist (#7); read-only status (#8);
sleep prevention (#9, missed entirely by v0.1); the two corrections above (#6, #10).

**Adopted with changes:**

- **#4 unattended authority** — the concern is adopted as a blocking item; the *prescription* is not.
  It contradicts a standing operator decision and its mechanism is unverified, so it is surfaced for
  the operator with a verification task attached rather than designed here.
- **#5 branch versus worktree** — the technical criticism is accepted and *"90% of a worktree"* is
  withdrawn; but the worktree path is blocked on the `friction-log.md` writer, and the review's own
  acceptance condition for a branch-only pilot is met by walking away. Branch now, worktree later.

**Disagreed:** the review's order puts six safety items before any proof. Phase 0 keeps the *attended*
proof first — it is free, it is safe at the keyboard, and if nested launching fails it changes the
shape the safety work has to fit. Safety before the *walk-away* run: agreed. Safety before *any* run:
no.

---

## Open questions for the operator

1. **Unattended authority (1d).** Revisit bypass-plus-model-side-rules for unattended runs only, or
   keep the standing decision and accept the exposure? This blocks Phase 2. *(Recommendation: revisit,
   narrowly — no push, no network — once the mechanism is verified.)*
2. **Launch path (0a).** If nesting `codex exec` inside a Codex task fails, is launching one command
   yourself from VS Code acceptable? It is still one action before you leave.
3. **Review.** This plan authorises execution. v0.1 carried two false load-bearing claims that a
   review caught. Should Codex review v0.2 before implementation begins?
