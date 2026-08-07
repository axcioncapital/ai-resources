# Probe — does `SIGTERM` stop a dispatcher run? (Phase 1a confirmation)

**Date:** 2026-08-07 · **Dispatcher:** `dispatch.sh` as of `2dd2112` · **Mode:** simulated (`--actor-cmd`)

Run against `unattended-operation-plan-v0.2.md` § 1a, which marks its claim **INFERRED** and states:
*"First task is confirmation, not repair."* This is that confirmation. The probe script is
reproduced at the end so the run can be repeated.

---

## What was probed

A dispatcher was launched in simulated mode with an actor that spawns a **grandchild** and then
sleeps 600s. Once the actor was confirmed running, the dispatcher — and only the dispatcher — was
sent `SIGTERM`. Four things were then observed, including the one the plan explicitly recorded as
unsettled (*"establish separately whether actor descendants survive"*).

## Result — the defect is confirmed, and it is broader than inferred

| # | Observation | Predicted (v0.2 § 1a) | **OBSERVED** |
|---|---|---|---|
| 1 | Dispatcher after `SIGTERM` | keeps running | **ALIVE** at +3s and +8s |
| 2 | Actor after `SIGTERM` | keeps working | **ALIVE** at +3s and +8s |
| 3 | Actor *descendants* | *unsettled* | **ALIVE** — the grandchild survived |
| 4 | Lock | released, second dispatcher admitted | **released**; a second dispatcher started, **exit 0** |

Raw excerpt:

```
=== sending SIGTERM to the dispatcher (91055) ===

--- 3 seconds after SIGTERM ---
  dispatcher 91055   : ALIVE
  actor      91110   : ALIVE
  grandchild 91112   : ALIVE
  lock dir           : released

--- can a second dispatcher start on the same checkout+task? ---
  YES — exit 0. A second dispatcher was admitted while the first is ALIVE.

--- 8 seconds after SIGTERM ---
  dispatcher 91055   : ALIVE
  actor      91110   : ALIVE
  grandchild 91112   : ALIVE
```

**Mechanism, now confirmed rather than reasoned.** `trap 'release_lock' EXIT INT TERM`
(`dispatch.sh:190`) installs a handler that does not call `exit`. Bash returns control to the
interrupted point, so the handler's only lasting effect is to delete the lock directory — which
*removes* a safety property instead of stopping the run. The dispatcher then continues to the next
hop with no lock protecting the task.

**Observation 4 is the serious one.** The signal does not stop the run; it *unlocks* it. Two
dispatchers driving one state file is the exact collision the lock exists to prevent, and the way
to cause it is to try to stop the run.

---

## Second probe — can the actor's tree be reached at all?

Observation 3 means the existing sweep is not enough: `run_bounded` uses `pkill -P "$pid"`
(`dispatch.sh:366-369`), which reaches **direct children only**. A real Claude hop runs tool
subprocesses below that depth.

Tested separately on this machine (GNU bash 3.2.57, arm64-apple-darwin25): enabling job control
with `set -m` before backgrounding gives the actor its **own process group** (pgid == its own pid,
distinct from the dispatcher's), after which `kill -TERM -<pgid>` reaps every descendant that stayed
in that group.

```
child=91221  child_pgid=91221  self=91220 self_pgid=91215
group kill accepted
child gone
--- survivors ---
none
```

**Consequence for the fix:** terminate the actor's **process group**, not its direct children. The
plan's instruction to reuse the existing sweep rather than write a second one still holds — the
sweep itself is corrected in place and all three callers (timeout, deadline, interruption) use it.

> **Scope of the claim, corrected 2026-08-07 after review.** This is a **process-group** kill, not a
> "whole process tree" kill, and an earlier revision of this record called it the latter. A descendant
> that *leaves* the group survives it — anything calling `setsid(2)`, anything starting its own
> process group, anything re-parented by a double fork into another group. `dispatch.test.sh` case
> 27b now asserts that limit directly (a `setsid`'d descendant is expected to survive, and the case
> fails if that ever silently changes), so the boundary is measured rather than assumed. The group
> kill is sufficient for the actors in use here — `claude -p` and `codex exec` keep their children
> in-group — which is a fact about today's actors, not a general guarantee.

---

## Status of the claim

`unattended-operation-plan-v0.2.md` § 1a may be promoted from **INFERRED** to **OBSERVED**, with
two amendments: descendants survive (settled here), and the lock is released rather than merely
retained (worse than predicted). The fix is authorised.

---

## Reproducing this

**The probe script is a file in this repository, not a description of one.**

| Artifact | Path |
|---|---|
| Probe script | `runs/probes/probe-interruption-2026-08-07.sh` |
| Raw captured output, before **and** after the fix | `runs/probes/probe-interruption-2026-08-07.raw.txt` |

```bash
# against the current dispatcher
bash runs/probes/probe-interruption-2026-08-07.sh ./dispatch.sh

# against the pre-fix dispatcher, to reproduce the defect itself
git show 2dd2112:plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh > /tmp/prefix.sh
bash runs/probes/probe-interruption-2026-08-07.sh /tmp/prefix.sh
```

It creates its own throwaway git sandbox and touches no real checkout. The raw capture holds both
runs one after the other, which is where the table above comes from — the "before" half is a genuine
execution of the pre-fix dispatcher retrieved from git, not a recollection of one.

> **Correction, 2026-08-07.** An earlier revision of this section was headed *"Probe script — kept
> verbatim for repeatability"* and then showed **pseudocode**. That is the same failure family this
> plan exists to stop: an artifact asserting an evidentiary property it does not have. Caught in
> review. The script and the raw capture are now both on disk.
