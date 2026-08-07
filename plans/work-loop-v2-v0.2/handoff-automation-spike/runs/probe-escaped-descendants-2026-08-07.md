# Probe — escaped descendants: which handle reaches one, and does the stop clear the tree? (Phase 1a)

**Date:** 2026-08-07 · **Host:** Darwin 25.5.0 arm64, macOS 26.5.2 (25F84) · **Mode:** simulated
transport (`--actor-cmd`), real OS processes

**Script:** `runs/probes/escaped-descendants-2026-08-07.sh` ·
**Raw capture:** `runs/probes/escaped-descendants-2026-08-07.raw.txt`

**Revised 2026-08-07, second round.** The first round measured four handles against three escape
shapes and reported Phase 1a as complete. Independent assessment rejected that: narrowing the
dispatcher's *success sentence* does not narrow the *objective*, and a conventional detached daemon
is still a descendant the objective covers. This revision adds the fourth shape, the two handles the
first round never measured, and the over-reach test that decides whether the remaining gap can be
closed at all. **Its conclusion is the opposite of the first round's: 1a stays open.**

Run against `unattended-operation-plan-v0.2.md` § 1a, which recorded stop control as **partial**.

**Label honestly:** the actor is supplied through `--actor-cmd`, so this is **simulated transport**.
Every process it observes is a real Darwin process, so it *is* real OS evidence. Those are different
claims and this record does not merge them.

---

## Part A — the mechanism, measured

Four descendant shapes were started under one process-group leader whose stdout and stderr were
redirected to a file, and which also held a **private per-hop marker file on fd 9**, exactly as
`run_bounded` now opens one:

| shape | pid | ppid | pgid | note |
|---|---|---|---|---|
| in-group child | 60080 | 60077 | 60077 | ordinary `&` job |
| setsid, still parented | 60081 | 60077 | **60081** | own session and group; ancestry intact |
| double-fork orphan | 60087 | **1** | 60084 | re-parented by the kernel, then `exec`'d into `/bin/sleep` |
| **detached daemon** | 60086 | **1** | 60085 | double fork, `setsid`, then **`closerange(0, 1024)`** and `exec`'d into `/bin/sleep` — holds **no** descriptors (`lsof -p 60086 -d 0-1024` → empty) |

Six candidate handles were measured against them:

| handle | in-group | setsid | orphan | **daemon** |
|---|---|---|---|---|
| 1 process group (`kill -- -PGID`) | reaches | **MISSES** | **MISSES** | **MISSES** |
| 2 recursive PPID walk | reaches | reaches | **MISSES** | **MISSES** |
| 3 environment tag (`ps -E`) | **MISSES** | reaches | **MISSES** | **MISSES** |
| 4 inherited fd on the **public hop log** | reaches | reaches | reaches | **MISSES** |
| 5 inherited fd on the **private marker** | reaches | reaches | reaches | **MISSES** |
| 6 inherited **cwd** (`lsof -d cwd`) | reaches | reaches | reaches | **reaches** |

Raw sets:

```
group=[60077 60080 60082 60083]  ancestry=[60080 60081]  envtag=[60081 60148]
hoplog=[60077 60080 60081 60087] marker=[60077 60080 60081 60087]
cwd=[60077 60080 60081 60086 60087]
```

### Why each row reads the way it does

- **`setsid(2)` creates a new session *and* a new process group**, so handle 1 cannot see it. It does
  **not** change PPID, so handle 2 still can.
- **A double fork destroys the ancestry link in the kernel**, before any stop happens: the
  intermediate exits, the grandchild is re-parented to pid 1, and no walk taken at stop time can
  recover it. Handle 2 is structurally blind here — not slow, blind.
- **Handle 3 cannot read the environment of a SIP-protected platform binary.** Measured in the same
  run: `/bin/sleep` **env NOT readable**, `/bin/bash` **env NOT readable**, a user-installed
  `python3` **env READABLE**. An environment tag is therefore blind to exactly the binaries an
  escaped shell job most often is. It also matches argv text, which invents a false-positive class
  the other handles do not have. **Rejected on measurement, not on taste.**
- **kqueue `NOTE_TRACK`** — the BSD fork-following filter, and the clean answer had it existed here —
  returns **`[Errno 45] Operation not supported`** on this host. **Rejected on availability.**
- **Handles 4 and 5 have identical reach.** They differ in *over-reach*, not coverage — see below.

### Handle 5 replaced handle 4, and the difference is not cosmetic

Both reach the same three shapes. But the hop log is a **public** file: an operator may `tail -f` it
while a run is in flight, and that is the ordinary way to watch a hop. Holding it is therefore not
evidence of descent from the actor, and a teardown that signals its holders kills bystanders. That
was observed, not predicted — see Part B, and `dispatch.test.sh` case 27i.

The **private marker** `${out%.out}.tree` is opened on fd 9 immediately before the actor is
backgrounded and closed in the dispatcher immediately after, so it is inherited by the whole actor
tree and by nothing else. Nothing but a descendant has a reason to hold it. Same reach, no bystanders.

### The deciding measurement: can handle 6 be used?

Handle 6 is the **only** handle that reaches the detached daemon. So the whole of Phase 1a turns on
whether it can be used as a kill list. It was measured rather than argued: an unrelated process was
parked in the same working directory, holding nothing of the actor's.

```
unrelated bystander pid   = 60190 (never touched the actor, the hop log or the marker)
handle 6 now returns        [60077 60080 60081 60086 60087 60190]
VERDICT: handle 6 REACHES THE BYSTANDER — unusable as a kill list.
         and it still reaches the daemon, so the over-reach is not incidental.
```

**This is the finding that closes the question.** A working directory is shared by anything that
happens to be in it — the operator's own shell, an editor, a build. The one handle broad enough to
catch a fully-detached daemon is broad enough to kill the operator's shell, which is exactly the
defect that removed handle 4. The two requirements are in direct opposition on this host, and no
choice among the six satisfies both.

That is a stronger and more useful statement than "it is impossible". It says *why*: detachment is
the deliberate removal of every link the kernel offers, and the only link a daemon cannot drop —
its working directory — is not exclusive to it.

### The mechanism this unit implemented

The union of handles **1, 2 and 5**. Handle 5 is the load-bearing one and costs almost nothing: one
empty file and one descriptor per hop, no helper process, no tracking during the hop, no new
authority.

---

## Part B — the effect, observed as process state

The real dispatcher was launched with an actor that spawns **three** escape shapes — the setsid one
**ignoring `SIGTERM`** so the `SIGKILL` half of the escalation is exercised rather than described,
plus the detached daemon. An unrelated `tail -f` was started on the hop log, as an operator watching
a run would. Only the dispatcher was signalled.

```
=== BEFORE the stop ===
dispatcher=60225 actor=60317 setsid=60319 orphan=60327 daemon=60326
unrelated operator tail -f on the hop log = 60347
60317 60225 60317 sleep 300            <- actor, own group
60319 60317 60319 …/python3            <- setsid escapee, own group, ignores SIGTERM
60326     1 60325 sleep 300            <- detached daemon, ppid 1, no descriptors
60327     1 60324 sleep 300            <- double-fork orphan, ppid 1, SIP binary
actor=ALIVE setsid=ALIVE orphan=ALIVE daemon=ALIVE  lock present: yes

=== sending SIGTERM to the dispatcher (60225), and to nothing else ===
  +3s   dispatcher=ALIVE actor=GONE setsid=ALIVE orphan=GONE daemon=ALIVE  lock: held
  +8s   dispatcher=ALIVE actor=GONE setsid=GONE  orphan=GONE daemon=ALIVE  lock: held
  +13s  dispatcher=GONE  actor=GONE setsid=GONE  orphan=GONE daemon=ALIVE  lock: released

  dispatcher exit code : 28
  DETACHED DAEMON      : ALIVE   <- 1a is NOT closed while this is ALIVE
  unrelated tail -f    : ALIVE   <- the first round killed this; it must not
  pids holding the PRIVATE marker: []
  pids holding the PUBLIC hop log: [60347]   <- a bystander, and NOT a descendant
```

Three results, and they are separate:

1. **The three reachable escapes are cleared, and the ordering holds.** At +3s the TERM-resistant
   escapee is still alive and the lock is **still held**; the dispatcher does not exit and does not
   release the lock until every descendant it can see is gone. That ordering is what § 1a asked for,
   and it is observed rather than argued.
2. **The detached daemon survives.** It is alive after the dispatcher has exited and reported. This
   is the objective's own fourth escape shape, so **the objective is not met**.
3. **The bystander survives.** The private marker is held by nobody after teardown; the public hop
   log is held by the operator's `tail -f`, and the dispatcher correctly does not treat that as a
   descendant. Under the first round's handle 4 this process was killed.

What the dispatcher *said*:

```
STOP [28] interrupted by SIGTERM during hop 1 (actor 'claude') — task escape-probe
  terminating actor descendant tree (pgid 60317)
  teardown verified: no descendant reachable by group, ancestry or inherited descriptor is still running
```

That sentence is **literally true and deliberately scoped** — it names the three handles that were
consulted and claims nothing beyond them. It is not, however, the same thing as the objective, and
this record does not let the two be read as one. The daemon at pid 60326 was running when it was
printed.

---

## The conclusion: 1a stays open

**What was achieved.** The reachable escape surface is genuinely and measurably narrower. Before this
work, a single `setsid` — one line in a shell — survived the stop. Now `setsid`, a new process group,
a double fork, re-parenting to pid 1 and SIP-protected binaries are all covered, the result is
verified before the lock is released, an unverifiable sweep says so instead of claiming success, and
a stop that cannot account for the tree pins the lock rather than admitting a second dispatcher.

**What was not achieved.** Full-descendant termination, which is what § 1a asks for. A conventional
detached daemon survives, and the measurement above shows the remaining handle cannot be used without
reintroducing bystander kills.

**Therefore Phase 1a remains a blocker, and Phase 2 remains forbidden with two blockers (1a and 1f),
not one.** Closing 1a properly needs authority this spike does not have — a supervisory mechanism
that tracks descendants as they are created rather than discovering them at stop time (a per-run
cgroup-equivalent, a launchd job, or a ptrace-class supervisor). Each is a new subsystem and a new
authority, and choosing one is an operator decision, not a bounded fix inside this unit.

`dispatch.test.sh` **case 27h** pins the surviving shape: it builds the daemon, asserts it survives,
and fails if the dispatcher's success wording is ever widened to cover it.

## Cost, disclosed

Worst-case teardown latency grew from about 6s to about 13s, because the escalation now adds a
`SIGKILL` settle window and a verification census the group-only sweep never ran. The whole-run
deadline's honest overrun bound therefore moves from ~6s to ~9s
(`1s poll + TERM_GRACE_SECS 5 + KILL_SETTLE_SECS 2 + census`). Both numbers are stated in
`dispatch.sh` at `effective_timeout` and asserted by `dispatch.test.sh` case 28
(`DEADLINE_CEILING` 11 → 14). The plan forbids relaxing the hard clock silently; this is the
disclosure, not a quiet widening.

## Reproducing

```bash
bash plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probes/escaped-descendants-2026-08-07.sh
```

Self-cleaning: every process it starts is killed on the way out, including on failure. A probe for
escaped descendants that leaked one would be self-refuting. Verified in this run — Part A reports
`in-group=GONE setsid=GONE orphan=GONE daemon=GONE`, and Part B's daemon and bystander are killed
before exit.
