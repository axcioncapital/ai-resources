# Probe — escaped descendants: which handle reaches one, and does the stop clear the tree? (Phase 1a)

**Date:** 2026-08-07 · **Host:** Darwin 25.5.0 arm64, macOS 26.5.2 (25F84) · **Mode:** simulated
transport (`--actor-cmd`), real OS processes

**Script:** `runs/probes/escaped-descendants-2026-08-07.sh` ·
**Raw capture:** `runs/probes/escaped-descendants-2026-08-07.raw.txt`

Run against `unattended-operation-plan-v0.2.md` § 1a, which recorded stop control as **partial**: the
teardown reached the actor's process *group*, and a descendant that left the group survived it. This
probe settles the mechanism question that section left open — *which* handle can reach an escaped
descendant — and then measures whether the implemented stop actually clears the tree.

**Label honestly:** the actor is supplied through `--actor-cmd`, so this is **simulated transport**.
Every process it observes is a real Darwin process, so it *is* real OS evidence. Those are different
claims and this record does not merge them.

---

## Part A — the mechanism, measured

Three descendant shapes were started under one process-group leader whose stdout and stderr were
redirected to a file, exactly as `launch_actor` redirects a hop:

| shape | pid | ppid | pgid | note |
|---|---|---|---|---|
| in-group child | 47790 | 47787 | 47787 | ordinary `&` job |
| setsid, still parented | 47791 | 47787 | **47791** | own session and group; ancestry intact |
| double-fork orphan | 47794 | **1** | 47793 | re-parented by the kernel, then `exec`'d into `/bin/sleep` |

Four candidate handles were then measured against them:

| handle | in-group | setsid | orphan |
|---|---|---|---|
| 1 process group (`kill -- -PGID`) | reaches | **MISSES** | **MISSES** |
| 2 recursive PPID walk | reaches | reaches | **MISSES** |
| 3 environment tag (`ps -E`) | **MISSES** | reaches | **MISSES** |
| 4 inherited fd on the hop log (`lsof -t`) | reaches | reaches | **reaches** |

Raw sets: `group=[47787 47790 47792] ancestry=[47790 47791] envtag=[47791 …] fd=[47787 47790 47791 47794]`

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

### The mechanism this unit implemented

The union of handles **1, 2 and 4**. Handle 4 is the load-bearing one and costs nothing new:
`launch_actor` already runs every actor as `"$@" >>"$out" 2>&1`, so each descendant inherits fd 1 and
2 pointing at that hop's output file, and `lsof -t` lists the holders regardless of session, process
group, ancestry or code signing. No helper process, no tracking during the hop, no new authority.

---

## Part B — the effect, observed as process state

The real dispatcher was launched with an actor that spawns **both** escape shapes, with the setsid
one **ignoring `SIGTERM`** so the `SIGKILL` half of the escalation is exercised rather than described.
Only the dispatcher was signalled.

```
=== BEFORE the stop ===
dispatcher=47891 actor=47983 setsid-escapee=47985 orphan-escapee=47990
47983 47891 47983 sleep 300            <- actor, own group
47985 47983 47985 …/python3            <- setsid escapee, own group, ignores SIGTERM
47990     1 47989 sleep 300            <- double-fork orphan, ppid 1, SIP binary
actor=ALIVE setsid=ALIVE orphan=ALIVE  lock present: yes

=== sending SIGTERM to the dispatcher (47891), and to nothing else ===
  +3s   dispatcher=ALIVE actor=GONE setsid-escapee=ALIVE orphan-escapee=GONE  lock: held
  +8s   dispatcher=ALIVE actor=GONE setsid-escapee=GONE  orphan-escapee=GONE  lock: held
  +13s  dispatcher=GONE  actor=GONE setsid-escapee=GONE  orphan-escapee=GONE  lock: released

  dispatcher exit code : 28
  any pid still holding the hop output file: []
```

**The ordering is the result, not a detail.** At +3s the TERM-resistant escapee is still alive and the
lock is **still held**; the dispatcher does not exit and does not release the lock until every
descendant is gone. That is precisely what § 1a required — *the tree is no longer running before the
dispatcher releases its lock and exits* — and it is observed here rather than argued.

What the dispatcher *said*, for comparison with the state above:

```
STOP [28] interrupted by SIGTERM during hop 1 (actor 'claude') — task escape-probe
  terminating actor descendant tree (pgid 47983)
  teardown verified: no descendant reachable by group, ancestry or inherited descriptor is still running
```

The stop message is compared against the observed process state on purpose. Before this unit the
dispatcher said the equivalent thing while an escaped descendant was still running — the defect was
never that it signalled the wrong thing, it was that its report was stronger than its reach.

---

## The residual, stated

A descendant that **closes or redirects both inherited descriptors, AND has left the process group,
AND has been re-parented away** is invisible to all three implemented handles. A conventional daemon
does exactly this. It survives the stop.

This is why the teardown **verifies and reports** instead of asserting success, and why its success
line is scoped — *"no descendant reachable by group, ancestry or inherited descriptor"* — rather than
claiming the tree is gone. `dispatch.test.sh` **case 27h** pins both halves: it builds that exact
shape, asserts it survives, and fails if the success wording is ever widened.

The residual is narrower than what it replaces. Before this unit, *any* `setsid` — one line in a
shell — escaped the stop. Now an escape has to close its descriptors as well.

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
escaped descendants that leaked one would be self-refuting.
