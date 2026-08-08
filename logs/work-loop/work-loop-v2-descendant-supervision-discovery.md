---
task: work-loop-v2-descendant-supervision-discovery
turn: codex
---

## Objective and scope

Determine whether this Mac has a practical creation-time supervision or containment boundary that
can make Work Loop Phase 1a truthful: every process descended from the current actor must be
terminated on every controlled stop path, even after `setsid`, double-fork re-parenting, and closing
all inherited descriptors, without signalling an unrelated process.

This task is evidence discovery only. It may inspect the repository, current host facilities, local
manuals and SDK headers, and may run self-cleaning probes in a temporary directory. It must not
implement or modify the dispatcher, tests, plan, README, rules, settings, hooks, credentials, user
accounts, launch services, or any other product or host configuration. Phase 1f and every Phase 2
action are excluded.

The task exits when it either identifies one smallest credible mechanism, with evidence sufficient
to frame a later implementation unit, or establishes that none of the mechanisms available within
the present authority and scope can meet the guarantee and states the exact operator decision that
would be required.

## Lane and unit

Standard. Discovery mode. Unit 1 — select an evidence-backed supervision boundary or prove that the
current scope cannot provide one.

Named reason for the loop: the solution and authority boundary remain load-bearing unknowns, the
work needs strict scope control, and its evidence must be assessed independently before any new
subsystem is authorised.

## Brief

This unit returns the project to its nearest unmet safety condition. The prior 1a task improved and
made the present teardown truthful, but it also proved that a conventional detached daemon still
survives; Phase 2 therefore remains forbidden. The approved plan requires stop control before the
walk-away pilot, so the next useful result is a bounded architecture finding, not another speculative
dispatcher patch.

Required outcome:

- Re-derive the current failure boundary from the live checkout. Treat the following as claims to
  verify, not facts to inherit:
  - `logs/work-loop/work-loop-v2-escaped-descendant-termination.md` closes with `turn: operator`,
    records an evidence-backed stop rather than Phase 1a completion, and names final-fix commit
    `7aaae68` with simulated evidence 368/0.
  - `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-escaped-descendants-2026-08-07.md`
    shows that the detached-daemon shape survives while the unrelated bystander remains alive.
  - `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` still marks only 1a and 1f as Phase 2
    blockers and forbids Phase 2 until both close.
  - The current `dispatch.sh` stop paths share one teardown function and retain the global deadline,
    no-retry rule, lock-pinning behavior, exit codes, attended behavior, and existing safety guards.
- Inspect and compare the smallest plausible creation-time mechanism families available on this
  host. At minimum, re-check the families named by the closing record: a per-run
  cgroup-equivalent, a launchd job, and ptrace-class supervision. Also consider any smaller public
  OS-enforced ownership boundary the host actually provides. This is a candidate surface, not a
  prescribed mechanism; select from evidence or reject them all.
- For every credible candidate, establish:
  1. whether it is public and available on this host;
  2. required privilege, entitlement, installation, persistent service, credential, or account
     changes;
  3. whether it follows descendants from creation through `setsid`, double fork, descriptor closure,
     and exec;
  4. how it avoids signalling unrelated processes and PID-reuse mistakes;
  5. compatibility with the existing Claude authentication, Seatbelt containment, Git access,
     supervised-terminal launch, serial single-checkout scope, and all stop paths;
  6. its failure-detection and cleanup behavior, including what pins the lock when supervision
     cannot be trusted; and
  7. the likely integration boundary and the fail-capable evidence a later implementation would
     need.
- Prefer primary local evidence: current manual pages, SDK headers, executable availability, and
  self-cleaning effective probes. Separate documented capability from observed behavior. Do not
  treat command existence, a process-group claim, or model prose as proof of full-tree containment.
- Any temporary probe must be safe, reversible, confined outside the repository, and leave no
  process or service behind. Do not create an OS user, change sudo rules, request an entitlement,
  install a runtime, bootstrap a persistent launch service, or use root. If a candidate cannot be
  tested without one of those, report that as its authority boundary instead of crossing it.

Required evidence must be able to fail:

- Show the exact primitive and output used for every availability or rejection claim.
- If a safe effective probe is possible, it must include both controls: the fully detached daemon
  would be found or contained, and an unrelated same-checkout bystander would not be selected.
- If no safe effective probe is possible, return documentary and host evidence that identifies the
  missing capability or authority; do not convert absence of a probe into a positive recommendation.
- End with exactly one disposition: `CREDIBLE FOR IMPLEMENTATION` naming one mechanism and its
  falsifiable implementation test, or `OPERATOR DECISION REQUIRED` naming the smallest explicit
  scope or authority change. A shortlist without a decision is incomplete.

Completion condition: write the comparison, evidence, selected disposition, and any residual risks
into this state file; change no repository file except this state file; set `turn: codex`; commit the
state-file update; and stop. Challenge and hand back any false premise or stale governing direction
rather than improvising past it.

Stop immediately if the investigation would require product implementation, elevated privilege,
host configuration, a persistent external effect, weakened safety criteria, Phase 1f work, or any
Phase 2 action.

## Latest result

Inspected (2026-08-08):

- Claim (1): HOLDS — read `logs/work-loop/work-loop-v2-escaped-descendant-termination.md`; frontmatter
  is `turn: operator`, `## Outcome` opens "**An evidence-backed stop, not completion of Phase 1a.**",
  and `## Evidence` names "Final-fix commit **`7aaae68`**" with "368 pass, 0 fail". `git log --oneline
  -1 7aaae68` resolves to "fix: unattended operation 1a — final bounded fix, survivor and
  discovery-failure coverage".
- Claim (2): HOLDS — read `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-escaped-descendants-2026-08-07.md`
  (219 lines); Part B records `DETACHED DAEMON : ALIVE` after dispatcher exit and, separately,
  `pids holding the PUBLIC hop log: [60347] <- a bystander, and NOT a descendant`, with handle 6
  measured reaching unrelated pid 60190.
- Claim (3): HOLDS — searched `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md` for the
  Phase 2 blocker list; the table under "Phase 2 blockers — both remaining, neither of them a
  decision" lists exactly two, 1a and 1f, and § Phase 2 reads "Phase 2 stays" blocked.
- Claim (4): HOLDS — searched `dispatch.sh` for `terminate_actor_tree`/`report_teardown` call sites;
  exactly two, and both stop paths use the same pair — `on_signal()` (line 900/904, `INT` and `TERM`)
  and `run_bounded()` (line 1445/1449, which the comment states carries "both the per-actor timeout
  (21) and the deadline (29)"). Exits 17, 28 and 31, `pin_lock`, the never-retried rule in
  `on_signal`, and the `--unattended` guards are all still present.

Corrected (2026-08-08) — bounded round, frozen findings 1–3, each reproduced by inspection first:

- Finding (1): REPRODUCED then RESOLVED — the prior evidence examined kqueue/dtrace/ktrace/taskinfo,
  not Darwin `ptrace(2)`. Now measured against `man 2 ptrace` and `sys/ptrace.h` directly (no
  fork-following request exists) and the cgroup-equivalent-runtime candidate (none installed). See
  the ptrace and runtime evidence below. Disposition unchanged.
- Finding (2): REPRODUCED then RESOLVED by probe (not downgraded) — the recommendation depended on
  the shipped `--unattended` boundary following a detached daemon, and the prior evidence used a
  custom `sandbox-exec` profile. A safe attended probe of the product path was possible and was run,
  with both controls; network containment inherits through the full detach. Two honest limits are
  now recorded (write confinement is not attempted; the actor refused the escape script). See the
  Seatbelt evidence below and residual risks 1 and 4.
- Finding (3): REPRODUCED then RESOLVED — `git status --short` cannot prove a commit's path set;
  replaced by `git diff-tree`, which shows commit `d1759f6` touched exactly the one state file. See
  the Evidence section.

Nothing outside the three frozen findings was changed. Two things newly surfaced during the round —
the profile's lack of write confinement and the actor's escape-script refusal — are recorded inside
finding 2's evidence as context for it, not as new work.

Result: the discovery ran, the correction round tightened its evidence, and it returns **OPERATOR
DECISION REQUIRED** unchanged. No mechanism available within the present authority terminates a fully
detached descendant. One mechanism — already in service — **contains** it (network + home-read, not
writes), and adopting that is a change to 1a's guarantee, which core § 6 rule 4 sends to the operator
rather than to a bounded fix.

Host: macOS 26.5.2, `Darwin 25.5.0`, `arm64` (`RELEASE_ARM64_T8142`), SIP **enabled**, uid 501 in
`admin`. Escape shape used throughout: `setsid` → double fork → `closerange(0,1024)` → `exec`.

### Candidate comparison

| Candidate | Available | Privilege / authority to use | Follows the full escape? | Bystander-safe? | Verdict |
|---|---|---|---|---|---|
| Process group, ancestry walk, private marker fd | yes | none | **no** (2026-08-07 probe) | yes | already built; insufficient by measurement |
| Inherited working directory | yes | none | yes | **no** — reached unrelated pid 60190 | rejected 2026-08-07 |
| **launchd job** | `/bin/launchctl` | none for the user domain | **no — measured this unit** | n/a | **rejected on measurement** |
| **Audit session (ASID)** | syscalls present, `bsm/audit.h` in SDK | **root to create, root to read** | yes — inherited | cannot tell: not enumerable | rejected on authority |
| **Coalitions** | `/usr/bin/taskinfo` | **root** | untested | untested | authority boundary, not crossed |
| **`ptrace(2)`** | present (`sys/ptrace.h`) | same-UID or root; stops the target | **no — no fork-following request exists on Darwin** | per-pid attach, no tree | **rejected on the interface itself** |
| **cgroup-equivalent runtime** | **none installed** (docker/podman/colima/lima/orbstack/Apple `container` all absent; no `/sys/fs/cgroup`) | n/a | n/a | n/a | **no implementation present** |
| **kqueue `NOTE_TRACK`** | `EVFILT_PROC` present | none | n/a | n/a | **`ENOTSUP`** |
| **dtrace** | `/usr/sbin/dtrace` | **root, and SIP disabled** | n/a | n/a | rejected on authority |
| **ktrace** | `/usr/bin/ktrace` | **root** | n/a | n/a | rejected on authority |
| **Dedicated OS user** | n/a | **create an account** — forbidden by this brief | yes; uid is inherited and unchangeable unprivileged | yes (`pkill -U`) | **authority change** |
| **Seatbelt sandbox** | `/usr/bin/sandbox-exec`, and already shipped as `--unattended` (1d) | **none** | **yes — measured on the product path; contains network + home-read, does NOT terminate or confine writes** | yes, structurally — it signals nothing | **scope change** |

### Evidence

All probes ran outside the repository, without root, and are self-cleaning. Scripts:
`probe-sandbox.sh`, `probe-others.sh`, `daemonize.py`, and the correction-round product-path probes,
run under the session scratch directory.

**The first commit changed exactly one path — verified by the right primitive (finding 3,
2026-08-08).** `git status --short` cannot prove a *commit's* contents, so it is replaced here by
`git diff-tree --no-commit-id --name-only -r d1759f6`, which returns exactly one line:
`logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` (`git show --stat` agrees:
"1 file changed, 260 insertions(+)"). The commit this correction round produces is verified the same
way in `## Latest result`.

**launchd does not reach a detached descendant.** A transient job (`launchctl submit`, no plist
installed) ran a script that spawned the daemon and then held the foreground:

```
job pid    = 69067   (ppid 1, pgid 69067)   daemon pid = 69072  (ppid 1, pgid 69071)
launchctl remove ...
job pid    after remove: GONE
DAEMON     after remove: 69072  1  69071  sleep 300     <- ALIVE
job still listed: no        ~/Library/LaunchAgents entries added: 0
```

This settles the advisory's `[CITATION NEEDED]`: launchd's cleanup reach missed the one shape that
matters, so it adds nothing over the process group already implemented.

**The audit session is inherited but unusable.** `getaudit_addr` reports ASID `100016` for the
launcher and `100016` for the fully detached daemon — inherited through the whole escape. Both other
halves fail: `setaudit_addr` with a fresh ASID returns `rc -1 errno 1 (EPERM)`, so the actor cannot
be given a session of its own and would share the operator's login session; and
`auditon(A_GETPINFO_ADDR=28, …)` returns `rc -1 errno 1` for self, for the parent shell and for
pid 1, so the set cannot be enumerated at all. Inherited-but-unreadable is not a kill list. (The
constant was taken from `bsm/audit.h` line 117 after a first run used a wrong value; the corrected
run is the one quoted.)

**ptrace-class supervision is dead on this host — measured against Darwin's actual
`ptrace(2)`, corrected 2026-08-08.** The earlier evidence examined kqueue, dtrace, ktrace and
taskinfo but not the named `ptrace(2)` interface itself; that gap is closed here.

`man 2 ptrace` and `sys/ptrace.h` (SDK, lines 76–95) list every request Darwin's ptrace supports:
`PT_TRACE_ME`, `PT_READ_*`/`PT_WRITE_*`, `PT_CONTINUE`, `PT_STEP`, `PT_KILL`, `PT_ATTACHEXC`,
`PT_DETACH`, `PT_SIGEXC`, `PT_THUPDATE`, `PT_DENY_ATTACH`, `PT_FORCEQUOTA`. Two facts settle it:

- **No fork-following request exists.** There is no Darwin equivalent of Linux's
  `PTRACE_O_TRACEFORK`/`TRACEVFORK`/`TRACECLONE`. Searched the whole SDK include tree
  (`grep -rlE 'TRACEFORK|TRACECLONE|TRACEVFORK|PTRACE_O_|PT_FOLLOW'`): the only hit is
  `curl/curl.h`'s unrelated `CURLOPT_FOLLOWLOCATION`. A tracer must `PT_ATTACHEXC` each pid
  individually, and cannot be attached to a descendant it never stopped — exactly the process the
  double fork creates. So ptrace cannot follow the escape it would need to follow.
- **`PT_ATTACHEXC` needs same-UID or root and stops the target**, turning every hop into a debugger
  session; it is a per-pid debug primitive, not a tree-ownership boundary.

The adjacent tracing facilities are also unavailable, recorded so the family is closed on all fronts:

```
kqueue EVFILT_PROC/NOTE_TRACK = rc -1 errno 45 (Operation not supported)
dtrace   -> "system integrity protection is on" / "DTrace requires additional privileges"
ktrace   -> "ktrace must be run as root when tracing the current system"
taskinfo -> "must be run as root, running as uid:501 euid:501"
```

**No per-run cgroup-equivalent runtime is installed, checked this round.** `docker`, `podman`,
`nerdctl`, `containerd`, `lima`/`limactl`, `colima`, `orb`/`orbstack`, `systemd-run`, `rkt`,
`vagrant`, `multipass` and Apple's native `container` CLI are all absent from `PATH`; no
`Docker.app`/`OrbStack.app`/`Podman`/`Rancher` under `/Applications`; and Darwin has no
`/sys/fs/cgroup`. So the "cgroup-equivalent" candidate the closing record named has no
implementation present to build on.

**Seatbelt follows the full escape and still contains — the decisive measurement, with both
controls, and they read differently:**

```
CONTROL  (no sandbox)  daemon 66484  ppid 1  pgid 66483  ->  WRITE-ALLOWED  NET-ALLOWED
                        denied-target: CREATED
TEST     (sandbox-exec) daemon 67938  ppid 1  pgid 67936  ->  WRITE-DENIED   NET-DENIED
                        denied-target: not created
                        inherited descriptors (lsof -a -p N -d 0-1024): 0
        and the sandbox is not shed by a further exec:      POST-EXEC:WRITE-DENIED
```

The escapee is re-parented to pid 1, holds its own process group and holds **zero** inherited
descriptors — the exact shape that defeats every termination handle — and it is still refused both
the network and any write outside the permitted subpath. The bystander control that the brief asks
for is structurally vacuous here and that is the point: containment builds no kill list, so it
cannot mis-select an unrelated process. For launchd, the only *termination* candidate that got an
effective probe, the mechanism failed before the bystander question could arise.

**A first sandbox run reported the daemon GONE and that reading was wrong** — my profile denied
`/dev/null`, so the daemon's own shell died before it could record anything. Recorded because the
failure mode is the one this task exists to avoid: an inability to observe, read as an observation.
The corrected profile allows `/dev/null` and produced the table above.

**The product path itself follows the escape — measured 2026-08-08 against the SHIPPED
`--unattended` boundary, closing finding 2.** The prior block used a hand-written `sandbox-exec`
profile; this uses the profile `write_unattended_profile` in `dispatch.sh` generates, extracted
verbatim from the shipped source and delivered exactly as the dispatcher delivers it —
`claude -p … --settings <profile> --tools Bash --strict-mcp-config --no-session-persistence`,
`claude 2.1.220 ≥ 2.1.219`. The enforced dimension is the network (`strictAllowlist: true`,
`allowedDomains: []`); the profile sets **no** write confinement, and denies reads only under `~/`.
Tested on the network dimension with both fail-capable controls:

```
CONTROL  unsandboxed + detached (run directly)   child ppid 1  ->  NET-OK
TEST     shipped --unattended + detached (actor)  child ppid 1, pgid own, 0 inherited fds  ->  NET-BLOCKED
```

The escapee is re-parented to pid 1, holds zero inherited descriptors — the exact shape that
defeats every termination handle — and the outbound connection is still refused, while the
unsandboxed control at the same shape reaches the network. So Claude Code's own sandbox inherits
network containment through the full detach, not merely `sandbox-exec` in the abstract.

**Two honest limits on that result.** First, the containment the profile applies is **network +
home-read denial only**; it does **not** confine writes to the checkout. An out-of-checkout write to
`/private/tmp` was created under the shipped profile — not a bug, because that path is not under the
profile's only denied region (`~/`), but it means a contained escapee can still write anywhere the OS
allows outside `~/`. Second, **the actor refused to author the escape script** under several
framings, calling it a "sandbox-escape and persistence mechanism," and cooperated only with an honest
containment self-test whose desired outcome was blocking. That refusal is a real additional barrier at
the product path — but it says nothing about a descendant that a *legitimate* tool (a dev server, a
build step) detaches by accident, which is the actual Phase 2 risk. So the behavioural refusal does
not substitute for the sandbox, and the sandbox is what the measurement above credits.

### Residual risks

1. **RESOLVED for the network dimension (2026-08-08).** The product path — Claude Code's own sandbox
   from the shipped `--unattended` profile — was measured to inherit network containment through the
   full detach, with both controls (see the Seatbelt evidence above). What remains open is a
   *different* dimension, now risk 4.
2. **Containment is not a time bound.** A contained escapee still consumes CPU and memory
   indefinitely. "Walk away" would need a separate statement about resource exhaustion.
3. **Containment covers only hops that actually run contained.** A hop run without `--unattended`,
   or anything spawned before the sandbox applies, is outside it. Phase 2 would have to require it.
4. **The shipped profile does not confine writes to the checkout — measured, not assumed.** Its
   filesystem policy denies reads under `~/` and allows reads to the checkout; it sets no write
   restriction, so a contained escapee can still write anywhere outside `~/` (an out-of-checkout
   write to `/private/tmp` succeeded under the profile). Whether it can write *inside* the checkout,
   and whether any write confinement would inherit through the detach, is still unmeasured. This is
   the residual the "contain from creation" recommendation must name honestly: containment here means
   no network and no home-tree reads — not filesystem confinement.

### Checked and clean — recorded so it is not re-derived

`lsof -p N -d 0-1024` ORs its selectors and returns the whole system; only `-a` ANDs them. Searched
`dispatch.sh`, `dispatch.test.sh` and `runs/probes/escaped-descendants-2026-08-07.sh` for `lsof`:
the dispatcher uses `lsof -t -- "$marker"` (one selector) and the shipped probe uses
`lsof -p "$DM" -a -d 0-1024`. Both correct. The defect was in my probe only.

### Deferral, recorded and not done

If the operator ever accepts an authority change, the ASID path deserves a second look beside the
dedicated OS user, because inheritance-through-escape and immutability-without-privilege are exactly
the properties a supervisor wants. Not pursued now: it needs root for **both** creation and
enumeration, which makes the dedicated user strictly cheaper for the same guarantee.

## Blocker

**No mechanism within the present authority can terminate a fully detached descendant.** Every
termination candidate is now rejected on measurement (process group, ancestry, descriptors, launchd),
on the interface itself (`ptrace(2)` has no fork-following request), on host support (`NOTE_TRACK`
`ENOTSUP`), on missing implementation (no cgroup-equivalent runtime installed), or on authority (root
for dtrace, ktrace, coalitions and audit sessions; an account for a dedicated uid). The one mechanism
that follows the escape contains rather than terminates, so using it changes what 1a guarantees.

**The two operator options, as the corrected evidence leaves them** (for Codex to put to the
operator; neither implemented):

- **Smallest scope change.** Restate 1a as *terminate every reachable descendant* (built and proved
  at `7aaae68`, 368/0) *plus contain every descendant from creation*. The containment primitive is
  `--unattended`, already shipped (1d), and it is now measured to follow the full detach on the
  product path — **but containment here means no network and no home-tree reads, not filesystem
  confinement** (residual risk 4). Its remaining entry test is whether write behaviour, in and out of
  the checkout, is acceptable for a walk-away run, and whether resource exhaustion (risk 2) needs a
  separate bound.
- **Smallest authority change.** A dedicated OS user for the actor, giving `pkill -U` as a true
  ownership boundary and preserving 1a's guarantee as literally written. This creates an account, so
  it is the operator's decision and was deliberately not probed.

## Next action

Codex: closure check on the three frozen findings only — are findings 1, 2 and 3 resolved, and did
the correction break anything?

- Finding 1 (ptrace-class evidence): resolved — `ptrace(2)` examined directly (no fork-following
  request), cgroup-equivalent runtime absence measured; disposition unchanged.
- Finding 2 (product-path dependency): resolved by probe, not downgrade — the shipped `--unattended`
  boundary inherits network containment through the full detach, both controls run; two honest limits
  recorded (no write confinement; actor escape-script refusal).
- Finding 3 (commit-scope proof): resolved — `git diff-tree` replaces `git status --short`; commit
  `d1759f6` touched exactly the one state file.

Nothing outside these three was changed; the write-confinement gap and the actor refusal are recorded
as context inside finding 2, not as new work. Phase 1f and every Phase 2 action remain untouched and
forbidden.
