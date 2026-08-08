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

Result: the discovery ran and returns **OPERATOR DECISION REQUIRED**. No mechanism available within
the present authority terminates a fully detached descendant. One mechanism — already in service —
**contains** it, and adopting that is a change to 1a's guarantee, which core § 6 rule 4 sends to the
operator rather than to a bounded fix.

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
| **kqueue `NOTE_TRACK`** | `EVFILT_PROC` present | none | n/a | n/a | **`ENOTSUP`** |
| **dtrace** | `/usr/sbin/dtrace` | **root, and SIP disabled** | n/a | n/a | rejected on authority |
| **ktrace** | `/usr/bin/ktrace` | **root** | n/a | n/a | rejected on authority |
| **Dedicated OS user** | n/a | **create an account** — forbidden by this brief | yes; uid is inherited and unchangeable unprivileged | yes (`pkill -U`) | **authority change** |
| **Seatbelt sandbox** | `/usr/bin/sandbox-exec`, and already shipped as `--unattended` (1d) | **none** | **yes — but it contains, it does not terminate** | yes, structurally — it signals nothing | **scope change** |

### Evidence

All probes ran outside the repository, without root, and are self-cleaning. Scripts:
`probe-sandbox.sh`, `probe-others.sh`, `daemonize.py`, run under the session scratch directory.
**No repository file except this one was changed** — verified by `git status --short`.

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

**ptrace-class supervision is dead on this host, re-measured rather than inherited:**

```
kqueue EVFILT_PROC/NOTE_TRACK = rc -1 errno 45 (Operation not supported)
dtrace   -> "system integrity protection is on" / "DTrace requires additional privileges"
ktrace   -> "ktrace must be run as root when tracing the current system"
taskinfo -> "must be run as root, running as uid:501 euid:501"
```

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

### Residual risks

1. **The containment measurement used `sandbox-exec` with my own profile, not Claude Code's
   sandbox.** The `--unattended` profile (`write_unattended_profile`, `dispatch.sh` line 1128) is
   applied through Claude Code's `sandbox.enabled` settings, and whether *that* implementation
   inherits the same way through a detached descendant is **unverified**. This is the falsifiable
   test any adoption would have to pass first.
2. **Containment is not a time bound.** A contained escapee still consumes CPU and memory
   indefinitely. "Walk away" would need a separate statement about resource exhaustion.
3. **Containment covers only hops that actually run contained.** A hop run without `--unattended`,
   or anything spawned before the sandbox applies, is outside it. Phase 2 would have to require it.
4. **The escapee may still be able to write inside the checkout.** The 1d profile constrains reads
   explicitly; its write policy was not measured here. A contained escapee that can still edit the
   repository is a different risk from one that cannot, and it is unmeasured either way.

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
on host support (`NOTE_TRACK` `ENOTSUP`), or on authority (root for dtrace, ktrace, coalitions and
audit sessions; an account for a dedicated uid). The one mechanism that follows the escape contains
rather than terminates, so using it changes what 1a guarantees.

## Next action

Codex: assess this discovery and decide which of the two named changes to put to the operator. Do not
read the evidence as permission to implement either.

- **Smallest scope change (recommended).** Restate 1a as *terminate every reachable descendant* —
  built and proved at `7aaae68`, 368/0 — *plus contain every descendant from creation* so an escapee
  cannot act outside the run's authority. No new subsystem and no new authority: the containment
  primitive is `--unattended`, already shipped as 1d. Its falsifiable entry test is residual risk 1 —
  a live `--unattended` hop that spawns a detached daemon, which must be observed **alive and still
  denied both the network and writes outside the checkout**, with an unsandboxed control that is
  observed doing both.
- **Smallest authority change.** A dedicated OS user for the actor, giving `pkill -U` as a true
  ownership boundary and preserving 1a's guarantee as literally written. This creates an account, so
  it is the operator's decision and was deliberately not probed.

Phase 1f and every Phase 2 action remain untouched and forbidden.
