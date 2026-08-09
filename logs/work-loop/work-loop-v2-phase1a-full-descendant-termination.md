---
task: work-loop-v2-phase1a-full-descendant-termination
turn: codex
---

## Objective and scope

Close Phase 1 item 1a literally: every controlled dispatcher stop must terminate and verify the
actor's full descendant tree, including a descendant that calls `setsid`, double-forks, closes every
inherited descriptor and `exec`s another program. A stop must not signal an unrelated process and
must never claim success when termination or verification is incomplete.

The operator preserved this guarantee on 2026-08-08. The operator has now authorized **Stages B and
C only**: a temporary, non-admin actor account and the bounded feasibility checks for actor-owned
Claude/Codex authentication, UID-scoped termination and read-only Git access. Stages D and E are not
authorized: no operator-home permission or ACL change, `sudoers`, permanent launch wrapper,
dispatcher implementation or permanent production setup may occur.

The task closes only after the guarantee is implemented and supported by fail-capable simulated
regression evidence plus effective live Darwin evidence. Phase 1f and every Phase 2 action remain
outside this task; Phase 2 stays forbidden.

## Lane and unit

Standard. Discovery mode. Unit 10 — determine whether Unit 7's unresolved root-bearing ASID form can
truthfully provide literal Phase 1a's per-run termination and verification boundary. This unit is
read-only discovery; it does not create an audit session, elevate, signal or run a probe.

Named reason for the loop: literal Phase 1a still needs a Darwin supervision mechanism. Unit 9 is
accepted after its correction and final tightly-bounded fix: persona is rejected because its exact
entitlement is hard restricted with no supported operator-accessible path. The authoritative blocker
now names ASID's root-bearing form as the one remaining candidate, so assessing it is the smallest
justified next unit.

Plan justification: the governing unattended-operation plan still blocks Phase 2 on literal 1a and
1f. The candidate space is not proved empty, but persona is now closed and ASID's root-bearing form is
the only named mechanism question still open. This unit tests that candidate against the unchanged
full-descendant and no-bystander requirements before any operator authority decision is considered.

### Unit 10 brief — executed

Codex's brief for this unit, moved here verbatim from `## Next action` when the unit completed, so
that field states the single next thing. The Unit 9 brief that previously stood here is committed at
`0e2d652`/`91f1728`/`444bdf2` and was removed from this file as prior-unit history (core § 4, current
truth not a diary). The brief itself is not altered; the result is in `## Latest result` below.

Claude: execute Unit 10 as one bounded read-only discovery unit. Determine whether Darwin audit session
ID (ASID), when established and supervised with root-bearing authority, can be a truthful per-run
termination and verification boundary for literal Phase 1a. Return evidence and a verdict only. Do not
create, join, change or terminate an audit session; do not elevate, signal, compile or run a probe; and
do not prescribe an implementation.

Why this unit, why now, and plan alignment: Unit 9 is accepted and closes persona. The governing plan
still blocks Phase 2 on literal 1a, and the authoritative blocker names Unit 7's root-bearing ASID form
as the one remaining candidate. This unit resolves that candidate's semantics and exact authority
boundary before the operator is asked for any new authority.

**Governing sources and dispositions:** `## Objective and scope`, the current unattended-operation
plan and the accepted Unit 9 result govern. Unit 7's accepted conclusion governs only at its stated
bound: ASID has useful granularity, is unusable under current authority, and its root-bearing form is
unassessed. Re-establish any deeper Unit 7 premise from durable repository history or live primary
sources before relying on it. Persona is rejected and must not be reopened. Deferral 14 remains
recorded and outside this unit.

**Named unknown:** can a root-bearing supervisor allocate or establish one unique ASID per dispatcher
run, ensure every actor descendant retains it across `fork`, `exec`, `setsid`, double fork, descriptor
closure, orphaning and relevant credential changes, enumerate and signal only that ASID's processes,
and verify complete exit without touching unrelated processes or claiming success on an unreadable or
racy census?

**Claims to check:**

1. Inspect the complete relevant local manuals, SDK headers, exported symbols and Apple-published XNU
   or OpenBSM source for ASID allocation, assignment, inheritance, lookup, lifecycle and end events.
   Establish exactly what root changes compared with Unit 7's unprivileged result. A private symbol,
   root-readable field or `/dev/auditsessions` event alone is not a usable termination boundary.
2. Establish how a run-specific ASID would be created or selected, whether allocation is atomic and
   collision-safe, what prevents reuse of an ASID held by an unrelated process, and whether two
   concurrent runs can receive distinct values. Distinguish kernel allocation from a caller choosing
   a numeric value.
3. Establish inheritance and mutability across `fork`, `posix_spawn`, `exec`, `setsid`, double fork,
   orphaning and a setuid-root exec. Determine whether an unprivileged descendant, an entitled or
   setuid-root helper, or an induced system service can shed, change or cause a child to leave the ASID.
   Bound helper inspection to interfaces that can affect audit-session membership; do not inventory
   unrelated privileged behavior.
4. Establish how an external root-bearing supervisor can enumerate, signal and verify every process in
   one ASID. Look for a kernel-scoped selector or signal primitive before considering list-then-signal.
   If only PID enumeration exists, account for PID reuse, exits or ASID changes between list and signal,
   partial reads, unreadable processes and fail-closed verification. Evaluate whether
   `AUE_SESSION_END` or `/dev/auditsessions` proves all members exited and what privilege, stream setup
   and race conditions it carries.
5. Test the boundary logically against the accepted escaped daemon; uid-502 PPID-1 services present or
   launched during the run; uid-501 bystanders; two concurrent runs in different checkouts; two runs in
   one checkout; ASID collision or reuse; supervisor/query failure; and a descendant attempting to shed
   or forge the value. Include false-positive, false-negative and race outcomes.
6. Distinguish an attended root-bearing feasibility probe from unattended dispatcher authority. State
   the minimum temporary authority that a later probe would need and the minimum production authority
   a real dispatcher would need, without requesting, designing or implementing either. D4 and Stages
   D/E remain unauthorized.
7. Return exactly one verdict: **candidate ready for a separately authorized live probe**, naming the
   falsification conditions and exact temporary authority; **candidate rejected**, naming the exact
   conflict with literal 1a; or **operator authority required**, only if the read-only evidence proves
   that no further conclusion is possible without a privilege-bearing check. Do not turn an unfinished
   read-only search into an authority request.

**Evidence:** list every local primary surface, Apple source file, repository source and read-only
command used. Separate observation from inference, state source-version gaps and every inspection
failure, and bound all absence claims to named searched surfaces. Include an inheritance/mutability
table, an enumeration/signal/verification table, and a false-positive/false-negative/race table covering
claim 5. Show how each verdict could have gone the other way. The evidence must be capable of rejecting
root-bearing ASID, not just describing it.

**Scope and stops:** this state file only. Read-only inspection of repository sources, durable history,
local manuals, headers, exported symbols, kernel metadata and official Apple primary sources is allowed;
self-cleaning session scratch is allowed only where needed to read an existing compressed primary
artifact. No Git inspection by Codex is needed; Claude may make the single state-file commit required by
the Work Loop. Do not use `sudo`; do not create, join or change an audit session; do not open a live
audit-session stream; do not signal or launch any process or fixture; do not compile, sign, install or
execute a probe; do not delete, log into, authenticate, or otherwise mutate `wlactor-airesources`
(uid 502); do not inspect Keychain or credential contents; do not change the dispatcher, tests or any
product file; and do not enter Stages D/E, Phase 1f or any Phase 2 action. Stop and hand back if a
premise fails, the required evidence cannot be produced read-only, or answering would require a
forbidden host or account action.

**Unit completion:** replace `## Latest result` with the Unit 10 verdict and evidence needed for the
next progression decision, update `## Blocker` truthfully, set `turn: codex`, commit only this state
file, and stop. Preserve the accepted Unit 9 verdict, literal Phase 1a, Deferral 14 and the live
account's untouched status; do not create another artifact or push.

## Latest result

**Unit 10 (Discovery, after the correction round and the final tightly-bounded fix) — VERDICT REVISED:
root-bearing ASID is REJECTED as a self-sufficient literal Phase 1a boundary.** The final fix was scoped
to the two loose ends the correction left — audit-token acquisition for the escaped hardened shape, and
the `mac_priv_grant` path for `PRIV_AUDIT_SESSION_PORT`. Chasing the second down its exact primary
source surfaced a shed route both Unit 7 and my correction missed, and it is decisive. Read-only
throughout this fix too: no `sudo`; no audit session created, joined, changed or ended; no process
signalled, launched or terminated; nothing compiled or executed; no account action; no repository file
other than this one. The live account was not touched or re-measured.

**Why the verdict flips — the exact conflict with literal 1a.** `audit_session_join(2)` moves a process
into a session named by a Mach send-right it holds, and the kernel applies **no privilege check** to the
join itself (verbatim below). A send-right to a session is mintable **without privilege** by any process
already in that session via `audit_session_self()` ("No privilege is required to obtain a port for our
own session"). So an unprivileged actor descendant that obtains — over ordinary Mach IPC — a send-right
to **any** audit session other than the run session can **leave the run ASID with no privilege and no
authentication**. On join, the kernel decrements the run session's `se_procnt` and increments the other
session's. Two literal-1a guarantees break at once: the ASID-scoped terminate **misses** the escaped
descendant (incomplete termination), and the run session's `AUE_SESSION_END` / `se_procnt == 0` can fire
while that descendant still runs (**false success**). The ASID mechanism cannot close this itself — there
is no hook to deny a join — so it is not a self-securing boundary. This is not a probability window; it
is an unprivileged kernel primitive, and read-only evidence cannot exclude that an actor descendant can
reach a foreign session port, because realizability depends on the Mach-IPC environment, not on ASID.

### The final tightly-bounded fix — items 1 and 2

**Item 2 (the assigned `mac_priv_grant` check, and the shed route it uncovered).** The correction quoted
`priv_check_cred()` and noted it delegates to `mac_priv_grant()` under `CONFIG_MACF`. Completing that
path:

- `setaudit_addr(2)` — the call that would place a descendant in a **new** session — is gated by
  `suser()` **directly**, not through `priv_check_cred()`, so it has **no `mac_priv_grant` path at all**:
  no entitlement can grant it; it is strictly superuser. (Unit 7, re-confirmed.)
- `audit_session_port()` — a port to **another** session — is gated by
  `priv_check_cred(cred, PRIV_AUDIT_SESSION_PORT, 0)`, whose only non-root path is `mac_priv_grant()`.
  `mac_priv_grant()` dispatches to registered MAC policies' `mpo_priv_grant` hooks, which on macOS are
  implemented in the **closed** kexts AMFI and Sandbox, not in published XNU. I therefore **cannot read
  the grant table from primary source**, and I bound that as an inspection failure rather than asserting
  no grant exists.
- **But the grant question does not decide anything**, because the shed route does not need
  `audit_session_port()`. `audit_session_join_internal()` carries **no privilege check** and accepts a
  send-right the caller already holds; `audit_session_self()` mints an own-session send-right with **no
  privilege**. So an actor descendant sheds by *joining* a foreign session whose port a cooperating
  process in that session minted and passed over IPC — bypassing the privileged port-acquisition
  entirely. Verbatim (`xnu-12377.121.6`, `bsd/security/audit/audit_session.c`):

  ```c
  static int
  audit_session_join_internal(proc_t p, ipc_port_t port, au_asid_t *new_asid)
  {
      ... if ((new_aia_p = audit_session_porttoaia(port)) == NULL) { err = EINVAL; ... }
      audit_inc_procount(AU_SENTRY_PTR(new_aia_p));          /* new session +1 */
      proc_audit_session_lock(p);
      kauth_cred_proc_update(p, PROC_SETTOKEN_LAZY, ^bool (…, kauth_cred_t model) {
          old_aia_p = model->cr_audit.as_aia_p;
          if (old_aia_p->ai_asid == new_aia_p->ai_asid) { return false; }
          … kauth_cred_model_setauditinfo(model, &new_as); });
      proc_audit_session_unlock(p);
      audit_dec_procount(AU_SENTRY_PTR(old_aia_p));          /* run session -1  */
      *new_asid = new_aia_p->ai_asid; …
  }
  ```

  No `suser`, `kauth_cred_issuser`, `priv_check_cred` or MAC hook appears; `audit_session_join()` only
  copies in the send-right (`ipc_typed_port_copyin_send(… IKOT_AU_SESSIONPORT …)`) and calls this.
  **This is the supported in-chain shed route the final fix asked me to find, and it exists.**

**Item 1 (audit-token acquisition for the escaped hardened shape).** The atomic terminate needs only two
token fields — `proc_find_audit_token()` (`bsd/kern/kern_proc.c`, verbatim) uses `get_audit_token_pid()`
and compares the live `proc_pidversion(proc)` against `token.val[7]`, returning `PROC_NULL` (→ `ESRCH`)
on mismatch; it does **not** compare the whole token. So identity binding needs pid + pidversion. What I
**could not establish read-only** is a supported root-usable path to obtain those for an arbitrary
**non-spawned, hardened** descendant: `task_info(TASK_AUDIT_TOKEN)` needs a task port, and the source
defining `task_for_pid` / `task_name_for_pid` and their platform-binary gates **did not surface across
three fetch attempts** (stated as an inspection failure, not read as either answer); no `libproc`/
`proc_info` flavor exposing `p_idversion` was confirmed present in this SDK's `sys/proc_info.h`. So even
setting the shed aside, the terminate's efficacy against the escaped shape is **unestablished**, which
item 1 says must revise the verdict rather than call the mechanism probe-ready.

### Inspection record — the brief's load-bearing premises

```
Inspected (2026-08-09):
- Premise (Unit 9 accepted verdict — persona rejected): HOLDS — git `444bdf2`. Not reopened.
- Premise (Unit 7 accepted conclusion at its stated bound): HOLDS — git `c49e1f4`. NOTE: Unit 7's
  shed analysis ("no free shed of the audit session … login/su authenticate") is now shown INCOMPLETE
  — it did not consider unprivileged `audit_session_join` of a held foreign session port. Recorded as
  a finding of this fix, below.
- Premise (running kernel and audit-session subsystem present): HOLDS — `uname -v`
  `xnu-12377.121.10~1/RELEASE_ARM64_T8142`; audit-session headers and syscalls present;
  `/dev/auditsessions` present.
- Premise (audit trail not configured — bounds SESSION_END): HOLDS — no `audit_control`; auditd not
  running. Now secondary: the shed corrupts SESSION_END regardless of delivery.
```

### The mechanism facts that still stand (subordinate to the shed)

These were established read-only and remain true; they are simply not sufficient, given the shed:

- **Allocation is kernel-assigned, unique, collision-safe.** `audit_session_new()` retry loop over
  `[ASSIGNED_ASID_MIN=PID_MAX+1, ASSIGNED_ASID_MAX=0xFFFFFFFF-1]`, skipping live sessions. Two runs get
  distinct ASIDs — the granularity UID/GID lacked.
- **The ASID rides the credential through fork/exec/setsid/double-fork/closerange** (`forkproc()` →
  `AUDIT_SESSION_PROCNEW`; cred preserved across exec). An unprivileged descendant cannot *create or
  change* to a new session (`setaudit_addr` → `suser()`).
- **Verification would be kernel-authoritative *absent a shed*** — `audit_dec_procount` fires
  `AUE_SESSION_END` at the last member's exit. The shed defeats exactly this: a join decrements the
  count without an exit.
- **The signal can be made atomic on identity** — `proc_terminate_with_audittoken` +
  `proc_find_audit_token` (pidversion-exact), root-permitted (`cansignal`), no entitlement. This closes
  the pid-reuse race the correction fixed; it does not help against the shed, which removes the target
  from the session before the terminate is even scoped.

### Inheritance and mutability — corrected with the shed row

| Transition | Effect on the run ASID | Source |
|---|---|---|
| `fork` / `posix_spawn` / `execve` / `setsid` / double fork / `closerange` | ASID preserved; `se_procnt` counts the child | `forkproc()`; cred model |
| unprivileged descendant → `setaudit_addr` (new session) | **blocked** — `suser()`, no MAC-grant path | XNU |
| unprivileged descendant → `audit_session_port(other)` | **blocked** — `priv_check_cred(PRIV_AUDIT_SESSION_PORT)` | XNU |
| **unprivileged descendant → `audit_session_join(held foreign session port)`** | **SHED — leaves the run ASID; `se_procnt` decremented; no privilege, no auth** | `audit_session_join_internal`, verbatim above |
| source of the foreign port | `audit_session_self()` by any process in that session (no privilege), passed over Mach IPC | `audit_session_self` comment |
| descendant execs a setuid-root helper to shed | still blocked for `setaudit_addr`; the *join* route needs no setuid helper | above |

### False positive / false negative / race — corrected

| Case | Outcome |
|---|---|
| (a) account launchd agent at baseline / (b) launched during run | correct exclusion — in the account session, not the run ASID (ASID's one real advantage over UID) |
| (c) escaped daemon (setsid+double-fork+closerange+exec), no shed | reached in principle; but terminate efficacy on the hardened shape is **unestablished** (item 1) |
| (d) run member exits, pid reused | no false positive — pidversion-exact terminate spares it (correction, stands) |
| (e) **descendant joins a foreign session (`audit_session_join`)** | **FALSE NEGATIVE + FALSE SUCCESS** — escapes the ASID scope and drops the run session's `se_procnt`; unprivileged; the defeat |
| (f) two concurrent runs | distinct ASIDs — but each still exposed to (e) |
| (g) member forks then the child sheds before it is observed | not catchable — the observation primitive (`se_procnt`) is the one the shed corrupts |
| (h) query/acquisition fails | fail-closed (never false success from *this* path) |
| (i) induced service work in the service's session | out-of-scope non-descendant (unchanged) |

### Verdict — revised, with the exact conflict named

**Candidate rejected as a self-sufficient literal Phase 1a boundary.** Exact conflict: `audit_session_join`
is an unprivileged, unauthenticated in-chain shed that removes a descendant (and its future children)
from the run ASID and simultaneously falsifies the run session's completion signal, and the ASID
mechanism has no means to prevent it. Read-only primary evidence cannot exclude that an actor descendant
reaches a foreign session port, so the boundary cannot be certified against literal 1a's absolutes.
Independently, no supported root-usable path to the escaped hardened process's identity token was
established read-only, so even the termination step is unproven for the escaped shape.

**What is *not* claimed.** Not exhaustion: I do not claim no mechanism can ever work. The shed could in
principle be contained by *pairing* ASID with a separate, proven restriction that denies the actor any
foreign-session Mach port (e.g. a tightly sandboxed IPC environment) — but that is a different mechanism,
unassessed and unauthorized here, not this candidate standing alone. Not a UID-boundary defeat: the shed
moves audit-session membership, not uid, so the dispatcher's current UID-based reach is unaffected by it
(its own limitation is the separate `dispatch.test.sh` case 27h descriptor hole).

### How the verdict could have gone the other way

- Had `audit_session_join_internal` carried a `suser()`/`priv_check_cred` gate like `setaudit_addr` and
  `audit_session_port` do, the shed would need root and ASID would remain a candidate. It carries **none**
  (verbatim).
- Had a supported root path to a hardened process's token/pidversion been readable, item 1 would resolve
  and the terminate would be probe-ready for the escaped shape. The defining source did not surface.
- Had `mac_priv_grant` been the only non-root path to change sessions, the closed-kext gap would be the
  whole story; instead the unprivileged join route bypasses it, which is why the grant gap does not save
  the verdict either way.

### Inspection failures and version gaps

- **The `task_for_pid` / `task_name_for_pid` source did not surface** across three fetches of
  `bsd/vm/vm_unix.c`; the platform-binary task-port gate is therefore unread, and item 1's acquisition
  question is left explicitly open (fails closed), not answered.
- **`mac_priv_grant` policy tables are in closed kexts** (AMFI/Sandbox); the `PRIV_AUDIT_SESSION_PORT`
  grant set is not readable from published XNU. Bounded to that; and moot, per item 2.
- **Source, not runtime:** `xnu-12377.121.6` (cross-checked `xnu-11417.101.15`), not the running `.10`.
  No audit-session or signal call was executed.
- **The shed's realizability was not tested** (read-only; no IPC probe). Its *possibility* is proven from
  source; its *exploitability* in a given run environment is a live question that read-only cannot close
  — which is itself the reason to reject rather than certify.

### Carried forward — current truth (core § 4)

- **Unit 9 accepted, persona rejected** (git `444bdf2`). Not reopened.
- **Deferral 14 stands, uncorrected.** Codex's call.
- **New deferral (15): Unit 7's accepted shed analysis is incomplete** — it concluded "no free shed of
  the audit session" from the `login`/`su` inventory without considering unprivileged
  `audit_session_join` of a held foreign session port. Recorded, not acted on (outside this fix's two
  frozen items); relevant only as context for this rejection.
- **The dispatcher's current UID-based reach is unchanged and remains the honest fallback**, with
  `dispatch.test.sh` case 27h pinning its descriptor hole. Unaffected by the ASID shed.
- **The live account is untouched**; the Unit 8 close measurement stands (uid 502, non-admin).

## Blocker

**The last named supervision candidate is now rejected as self-sufficient, so no examined mechanism
truthfully closes literal Phase 1a on its own.** Root-bearing ASID solved the granularity and
false-positive problems that sank the UID and GID boundaries, but `audit_session_join` is an
unprivileged, unauthenticated in-chain shed the mechanism cannot prevent, and read-only evidence cannot
exclude an actor descendant reaching a foreign session port. Separately, a supported root path to the
escaped hardened process's identity token was not established read-only. Both are named above with
verbatim primary source.

**This is not a claim of exhaustion.** The candidate space is not proved empty. What is established is
that every *named* mechanism examined — process group, ancestry, environment tag, working directory,
`kqueue NOTE_TRACK`, launchd job removal, `ptrace`, containers, coalitions (closed discovery); UID
(Unit 5); real GID (Unit 6); persona (Units 8–9); and now root-bearing ASID (Unit 10) — fails literal
1a under the authority examined. A surviving path would have to be either a new mechanism, or ASID
*paired* with a separately-authorized, proven containment that denies the actor any foreign-session Mach
port — which is unassessed and unauthorized, not a live candidate.

**The dispatcher's current reach remains the honest fallback**, unchanged, with `dispatch.test.sh` case
27h pinning the surviving descriptor hole. The ASID shed does not touch it.

**Authority boundaries are unchanged.** D4 and Stages D/E stay unauthorized. Persona stays closed.

**The live account stays untouched** and was not re-measured. The Unit 8 close measurement stands
(uid 502, non-admin). Nothing may signal, delete, log into or authenticate uid 502.

## Next action

Codex: closure check on this final tightly-bounded fix, covering the two frozen items and nothing else.
Item 2 (mac_priv_grant / in-chain shed) — resolved by completing the grant path (`setaudit_addr` is
`suser`-only with no grant path; `audit_session_port`'s grant table is closed-kext and moot) and by
finding the decisive route it was pointing at: unprivileged `audit_session_join` of a held foreign
session port, quoted verbatim, which sheds an in-chain descendant and falsifies the completion signal.
Item 1 (token acquisition) — the acquisition path for the escaped hardened shape could not be
established read-only (defining source did not surface; stated as an inspection failure), so efficacy is
unproven. Consistent with the final-fix instruction, the verdict is revised to **candidate rejected as a
self-sufficient literal Phase 1a boundary**, with the exact conflict named. Confirm the two items are
resolved and that the revision broke nothing preserved, then close or take a menu option (accept as a
written limitation, revert to the prior candidate-ready framing, reframe the unit, or stop for the
operator on how to proceed now that the last named candidate is rejected). Persona stays closed;
Deferrals 14 and 15 remain open; literal Phase 1a and the live account's untouched status are preserved.
