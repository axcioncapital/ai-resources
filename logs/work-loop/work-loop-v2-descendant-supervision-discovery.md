---
task: work-loop-v2-descendant-supervision-discovery
status: closed
turn: operator
---

## Outcome

No mechanism available within the present authority can truthfully terminate every fully detached
descendant of the actor — one that does `setsid`, double fork, descriptor closure and `exec`.
Disposition: **OPERATOR DECISION REQUIRED**.

This closes the architecture **discovery** only. It does **not** close Phase 1a: 1a remains open and
Phase 2 remains forbidden. No implementation occurred; Phase 1f and every Phase 2 action stayed
outside this task throughout.

## Decisions that matter

**The operator decision is unresolved and is handed back, not made here.** Neither option was
selected, begun or probed:

- **Smallest authority change** — a dedicated actor OS user, giving `pkill -U` as a true ownership
  boundary and preserving 1a's guarantee as literally written. It creates an account, so it is the
  operator's call; deliberately never probed.
- **Smallest scope change (conditional)** — restate 1a as *terminate every reachable descendant*
  (built and proved at `7aaae68`, 368 pass / 0 fail) *plus contain every descendant from creation*,
  using the already-shipped `--unattended` Seatbelt containment (item 1d). Conditional on a later
  effective test of the real `dispatch.sh --unattended` path, and on explicit acceptance of the
  limitations recorded below.

Adopting containment changes what 1a guarantees, which core § 6 rule 4 sends to the operator rather
than to a bounded fix. That is why the discovery ends in a decision rather than a recommendation.

**Deferral recorded at closure.** If an authority change is ever accepted, the audit-session (ASID)
path deserves a second look beside the dedicated OS user — inheritance through the escape and
immutability without privilege are the properties a supervisor wants. Not pursued now because it
needs root for **both** creation and enumeration, which makes the dedicated user strictly cheaper for
the same guarantee.

## Evidence

Accepted evidence behind the disposition, all measured on this host (macOS 26.5.2, `Darwin 25.5.0`,
`arm64`, SIP enabled, uid 501):

- Darwin `ptrace(2)` has **no fork-following request** — no equivalent of Linux
  `PTRACE_O_TRACEFORK`/`TRACECLONE`/`TRACEVFORK` exists in `man 2 ptrace` or `sys/ptrace.h`, so a
  tracer cannot follow the double fork it would have to follow.
- **No cgroup-equivalent runtime is installed** — docker, podman, nerdctl, containerd, lima, colima,
  orbstack, systemd-run, multipass and Apple's `container` CLI are all absent; Darwin has no
  `/sys/fs/cgroup`.
- **launchd failed the effective detached-descendant probe** — after `launchctl remove`, the job was
  gone and the detached daemon was still alive (pid 69072, ppid 1).
- The remaining ownership boundaries **require new authority** — root for dtrace, ktrace, coalitions
  and audit sessions; a new account for a dedicated uid. `kqueue NOTE_TRACK` returns `ENOTSUP`.
- The **dispatcher-generated Seatbelt profile carried network denial through the full detach** in a
  direct `claude -p … --settings <generated-profile>` test, with both controls: the unsandboxed
  detached control reached the network, the sandboxed detached child was blocked.

Commits, each verified with `git diff-tree --no-commit-id --name-only -r <commit>` to have touched
exactly this one state file and no other: `d1759f6` (discovery), `8c15cef` (correction round),
`4ebfe80` (permitted final fix). This closing record is the current commit.

## Accepted limitations

1. **The Seatbelt result did not exercise `dispatch.sh --unattended`.** It tested the profile
   `write_unattended_profile` generates, via a direct `claude -p` invocation. Actual dispatcher
   integration against a detached descendant is **unverified** — no dispatcher run log or exit code
   exists. The scope-change option is conditional on that test.
2. **The profile confines no filesystem writes.** It denies reads under `~/` and denies the network;
   it sets no write restriction, and an out-of-checkout write to `/private/tmp` succeeded under it.
   Containment here means no network and no home-tree reads — not filesystem confinement.
3. **Containment is not a time bound.** A contained escapee still consumes CPU and memory
   indefinitely. Any "walk away" claim needs a separate statement about resource exhaustion.
4. **Containment covers only hops that actually run contained.** A hop run without `--unattended`,
   and anything spawned before the sandbox applies, sits outside it.
