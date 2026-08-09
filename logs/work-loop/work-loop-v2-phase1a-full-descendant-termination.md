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

**Unit 10 (Discovery, CORRECTED at the correction round) — VERDICT: root-bearing ASID paired with
audit-token termination is a candidate ready for a separately authorized live probe.** The correction
did not overturn the verdict; it fixed the mechanism the verdict rests on and the two claims that were
wrong. Read-only throughout, this round too: no `sudo`; no audit session created, joined, changed or
ended; no live audit-session stream opened; no process signalled, launched or terminated; nothing
compiled, signed, installed or executed as a probe; no account action, login or authentication; no
Keychain, credential or provisioning-profile contents read; the dispatcher, tests and every product
file unchanged; no repository file other than this one. The live account was not touched or re-measured.
Session scratch held Apple's published XNU source fetched over the network; nothing was vendored.

**What the correction changed, plainly.** The first result claimed the bystander race was closed by
"re-checking the ASID immediately before `kill()`." That was wrong, and Codex's finding 1 is correct: a
re-check and a `kill(pid)` are two separate syscalls, so a matched pid can exit and be reused in the
gap and the signal can land on an unrelated process. The fix is not a tighter re-check — it is a
different primitive. Darwin ships `proc_terminate_with_audittoken()` / `proc_signal_with_audittoken()`,
which signal a process identified by its `audit_token_t`. That token carries the pid **and the
pidversion** (and the ASID), and the kernel validates it exactly, so a reused pid whose pidversion
differs is **not** signalled. The window is removed by a kernel identity check, not treated as small.
The verdict survives because the mechanism it needed existed; the earlier write named the wrong signal
step. Finding 2's incomplete shed analysis is completed below.

### The correction round — findings 1 and 2

Both frozen findings were reproduced by inspection of the first result before either was corrected.

- **Finding 1: REPRODUCES.** The first result's FP/FN table row (d) read "no false positive — re-check
  ASID before kill; the reused pid carries a different ASID", and the narrative said the race "is
  closable here … a re-check-before-kill spares it." A re-check followed by `kill(pid)` is not atomic;
  the claim that it spares the bystander is false, exactly as the finding states. **Corrected below**
  by replacing `kill(pid)` with `proc_terminate_with_audittoken()`, whose identity binding is inside
  the signalling call.
- **Finding 2: REPRODUCES.** The first result proved only that an *unprivileged* process cannot call
  the membership-change interfaces, leaned on Unit 7's `login`/`su` setuid inventory for the rest, and
  labelled induced service work "out of scope" (table row i) without separating a service-owned
  non-descendant from an in-chain descendant that changes session. **Corrected below** by establishing
  the gate is superuser (not an entitlement), assessing the spawn-attribute and induced-spawn surfaces,
  and drawing the descendant/non-descendant line the finding required.

### Inspection record — the brief's load-bearing premises

```
Inspected (2026-08-09):
- Premise (Unit 9 accepted verdict — persona rejected): HOLDS — read this file's prior sections and
  the accepted record at git `444bdf2`. Persona is a hard restricted entitlement in none of AMFI's
  three exception tables; not reopened, not relied on.
- Premise (Unit 7 accepted conclusion at its stated bound): HOLDS — re-established from durable history
  at git `c49e1f4`: `setaudit_addr(2)` gated by `suser()`, `auditon(A_GETPINFO_ADDR)` falling to
  `default: suser()`, `audit_session_port()` gated by `PRIV_AUDIT_SESSION_PORT`, no unprivileged
  enumerate-by-session selector.
- Premise (running kernel and the audit-session subsystem are present): HOLDS — `uname -v` =
  `xnu-12377.121.10~1/RELEASE_ARM64_T8142`; `bsm/audit_session.h`, `bsm/audit.h`, `mach/message.h`,
  `sys/proc_info.h`, `libproc.h`, `bsm/libbsm.h`, `security/audit/audit_ioctl.h` all present; audit
  syscalls present; `/dev/auditsessions` present (`crw-r--r-- root wheel`).
- Premise (the audit trail is not configured — bounds SESSION_END verification): HOLDS — no
  `audit_control`; `pgrep -lf auditd` exits 1. Falsification condition 6 below.
```

### The mechanism, from Apple's published XNU source and the shipped SDK

XNU quotes are from `apple-oss-distributions/xnu` tag `xnu-12377.121.6` — the nearest published tag in
the running `12377.121` series (`.10` is unpublished; stated, not papered over). The audit-session
allocator, procount and `AUE_SESSION_END` code were cross-checked at `xnu-11417.101.15` and are
unchanged. Header facts are from the active SDK on this host.

**1. A per-run ASID is kernel-assigned, unique among live sessions, collision-safe.** `audit_session_new()`
handles `AU_ASSIGN_ASID` with a retry loop — `audit_session_nextid()` walks
`[ASSIGNED_ASID_MIN, ASSIGNED_ASID_MAX]` under the session rwlock and wraps; `audit_session_find()`
skips any value a live session already holds. `ASSIGNED_ASID_MIN = PID_MAX + 1`,
`ASSIGNED_ASID_MAX = 0xFFFFFFFF - 1` (`audit_private.h`), so assigned ASIDs begin at 100000 and never
overlap the pid space — matching the live `asid = 100016`/`100046` Unit 7 observed. Two runs each asking
`AU_ASSIGN_ASID` receive distinct ASIDs whether or not they share a checkout or account — the property
UID (Unit 5) and real GID (Unit 6) lacked.

**2. The ASID rides the process credential, so it survives the whole escape and cannot be shed by an
unprivileged descendant.** `forkproc()` runs `AUDIT_SESSION_PROCNEW(child_proc)` unconditionally;
`audit_session_procnew()` increments `se_procnt` from `cred->cr_audit.as_aia_p`. `fork` copies the
credential, `execve` preserves it, `setsid` moves only the BSD session/pgrp. The only calls that change
a process's audit session are `setaudit_addr(2)` and `audit_session_join(2)`, and both are superuser-
gated (finding 2). So the escaped daemon still carries the run ASID after setsid + double fork +
`closerange` + exec.

**3. Verification is kernel-authoritative.** `audit_dec_procount()` fires `AUE_SESSION_END` when the
last member exits (`if (old_val == 1) audit_session_event(AUE_SESSION_END, …)`); `audit_session_procexit()`
decrements on every exit. `se_procnt` is the kernel's own live-process count across fork, exec and
orphaning, and the SDK header (`bsm/audit_session.h`, `au_sdev_read_aia`) documents `AUE_SESSION_END`
as "all the processes in the session have exited," delivered from `/dev/auditsessions` under the
privileged `AU_SDEVF_ALLSESSIONS` flag.

**4. The signal is atomic on process identity — this is the correction's core.** `proc_terminate_with_audittoken()`
and `proc_signal_with_audittoken()` (`libproc.h`) act on an `audit_token_t`, which is
`struct { unsigned int val[8]; }` (`mach/message.h`) carrying pid, ASID and pidversion — read with
`audit_token_to_pid()`, `audit_token_to_asid()`, `audit_token_to_pidversion()` (`bsm/libbsm.h`). In
XNU, `proc_signal_with_audittoken` → `proc_ident_for_audit_token` → `proc_find_audit_token(token)`
(returns `ESRCH` if no live process matches) → `proc_ident_with_policy(p, IDENT_VALIDATION_PROC_EXACT)`
→ `proc_find_ident`, and the delivery permission is ordinary `cansignal_nomac(current_proc(), …)` — so
**root may call it, no entitlement is required**, and the exact-identity policy means a **reused pid
with a different pidversion is not signalled**. This binds identity *through* the signalling call, which
`kill(pid)` cannot. It is a BSD signal, so SIP does not shield the escaped platform binary from being
terminated by root (SIP restricts task *control* ports and code injection, not signalling).

### Inheritance and mutability

| Transition | Effect on the run ASID | Source |
|---|---|---|
| `fork` / `posix_spawn` | inherited; child increments `se_procnt` | `forkproc()` → `AUDIT_SESSION_PROCNEW`; cred copy |
| `execve` (incl. a setuid-root binary) | preserved — exec does not change the audit session | Unit 7; cred preserved across exec |
| `setsid`, double fork, orphaning to PPID 1 | unchanged — only BSD session/pgrp move; `se_procnt` still counts the orphan | `setsid(2)`; procount is per-cred |
| `closerange` / descriptor close | unchanged — the ASID is in the credential, not a descriptor | credential model |
| unprivileged descendant → `setaudit_addr` / `audit_session_join(other)` | **blocked** — `suser()` / `priv_check_cred(PRIV_AUDIT_SESSION_PORT)` | Unit 7; `kern_priv.c` |
| descendant execs a setuid-root or entitled helper to shed it | **blocked** — the gate is superuser, and only root-running `login`/`su` touch the session, both authenticating | finding 2 below |
| `posix_spawnattr_setauditsessionport_np` (spawn child into a session) | **no shed** — needs a session *port*; a port to any session but the caller's own is superuser-gated | `spawn.h`; `audit_session_port()` gate |

### Finding 2 — the shed analysis, completed and bounded

The membership-change gate is **superuser, not an entitlement.** `setaudit_addr(2)` runs `suser()`
(Unit 7). `audit_session_join(other)` and `audit_session_port(other)` run
`priv_check_cred(cred, PRIV_AUDIT_SESSION_PORT, 0)`, and `priv_check_cred()` (`bsd/kern/kern_priv.c`,
quoted this round) grants **only** to `kauth_cred_getuid(cred) == 0` or, under `CONFIG_MACF`, a
`mac_priv_grant(cred, priv)` policy — there is no `IOTaskHasEntitlement` path in the check. Searched
surfaces for a non-root grant: `priv_check_cred` itself and the audit-session privilege usage; **no MAC
policy granting an audit-session privilege to an unprivileged or merely-entitled process was found**,
and that absence is bounded to those surfaces (I did not, read-only, enumerate every registered MAC
policy). Consequence: an **entitled-but-unprivileged** helper cannot change a session — the barrier is
privilege, not a capability an actor descendant could carry.

The two induced routes Codex asked me to separate, separated:

- **(a) A service-owned non-descendant.** An actor that induces a root service (`launchd`,
  `usermanagerd`) to run work gets a process that is a **child of the service, in the service's audit
  session** — not in the actor's process-descendant chain, and carrying neither the run ASID nor the
  actor as an ancestor. Terminating "the actor's full descendant tree" does not reach it, and **no
  per-run boundary does**; it is the general persistence shape every mechanism shares, out of scope for
  literal 1a. Recorded as an accepted limitation, not a defect.
- **(b) An in-chain descendant that changes session.** For a process that stays in the actor's
  descendant chain to end up in a different ASID, it must itself invoke `setaudit_addr`/`audit_session_join`
  **as root**. Exec preserves the session, so a setuid-root exec alone does not move it; the binary must
  call the interface. In Unit 7's complete setuid-root inventory of the standard directories, the only
  binaries that call these interfaces are `login` and `su`, both of which authenticate first. **No
  supported in-chain shed route was found**, bounded to that inventory plus the gate above.

So no actor-accessible route — unprivileged, entitled-but-unprivileged, setuid-root exec, spawn
attribute, or induced spawn producing an in-chain descendant — sheds or bypasses the run ASID for a
process that remains in the descendant tree. The one out-of-scope caveat is (a).

### Enumeration, signal and verification, under root — corrected

| Step | Primitive | Note |
|---|---|---|
| place the run in a fresh ASID | `setaudit_addr(ai_asid = AU_ASSIGN_ASID)` at launch, root | small root wrapper sets the session, then execs the actor |
| enumerate candidates + read ASID | `sysctl KERN_PROC_ALL` / `libproc` list, then per pid obtain the `audit_token` (carries ASID + pidversion) and filter `asid == run` | no kernel ASID→pidset selector; the token doubles as the ASID read |
| **signal (atomic on identity)** | `proc_terminate_with_audittoken(&token)`, root | pidversion-exact: a reused pid is **not** hit; replaces the false `kill(pid)` + re-check |
| verify all gone | `AUE_SESSION_END` for the run ASID from `/dev/auditsessions` (root, `AU_SDEVF_ALLSESSIONS`); else fail-closed polling | kernel count is authoritative; polling is the fallback |

**The one open efficacy dependency, stated exactly (partial resolution of finding 1's "works for the
escaped shape" clause).** The atomic terminate needs the target's `audit_token`. For a descendant the
supervisor did not spawn — the escaped daemon — the token must be obtained by enumeration. The token
carries pidversion, and obtaining it for an Apple-signed platform binary (post-`exec /bin/sleep`) most
plausibly goes through an **inspect/name** task port (`task_inspect_for_pid`/`task_name_for_pid` +
`task_info(TASK_AUDIT_TOKEN)`), which SIP does not restrict the way it restricts the **control** port —
but I could **not settle read-only** whether that acquisition succeeds against a hardened exec on this
host, and Darwin has no `pidfd` alternative. This is the decisive probe question. Crucially, it is an
**efficacy** question, not a safety one: if a token cannot be obtained, the descendant is **not
signalled and the stop reports incomplete** (fail-closed), never a bystander hit and never a false
success. So the objective's two absolutes hold regardless of how this resolves.

### False positive, false negative and race, by case — corrected

| Case | Outcome |
|---|---|
| (a) account launchd agent present at baseline | correct exclusion — in the account login-context session, not the run ASID |
| (b) account launchd agent launched *during* the run | **correct exclusion** — launchd starts it in the account session; the exact false positive that killed the UID boundary (Unit 5, 7→9) |
| (c) escaped daemon: setsid + double fork + closerange + exec | **reached** — ASID rode the credential; token-terminate can signal a platform binary, subject to token acquisition |
| (d) a run member exits, its pid reused by an unrelated process | **no false positive — CORRECTED** — the terminate carries the member's pidversion; the reused pid's pidversion differs, so `proc_find_audit_token` returns `ESRCH` and the bystander is not signalled |
| (e) descendant execs a setuid-root/entitled helper | correctly excluded from shedding — gate is superuser; only `login`/`su` touch the session, both authenticate |
| (f) two concurrent runs, same or different checkout/account | each gets a distinct kernel-assigned ASID; each supervisor signals only its own tokens |
| (g) member forks a new child between census and signal | caught next iteration — the child carries the ASID and increments `se_procnt`; loop until `AUE_SESSION_END` / empty census |
| (h) a query or token acquisition fails | **fail-closed** — do not signal, report incomplete; never claim success |
| (i) actor induces a *system service* to run work in the service's session | **out of scope, stated limitation** — a service-owned non-descendant, reached by no per-run boundary (finding 2 case a) |

### Authority — attended probe vs unattended production (claim 6)

- **Minimum temporary authority for a separately authorized, attended probe:** root, via operator-
  attended `sudo`, to — (i) launch a throwaway actor through a wrapper calling
  `setaudit_addr(AU_ASSIGN_ASID)` then execing the escape fixture; (ii) enumerate and obtain each
  member's `audit_token` and read its ASID; (iii) terminate with `proc_terminate_with_audittoken`;
  (iv) optionally open `/dev/auditsessions` (`AU_SDEVF_ALLSESSIONS`) for `AUE_SESSION_END`. No account
  mutation, no persistent config, no dispatcher edit, nothing retained. Attended probe authority — not
  production authority.
- **Minimum production authority for an unattended dispatcher:** the same two root capabilities
  (set-session-at-launch and per-pid token/terminate), held or reached through a narrowly-scoped
  setuid-root helper, at **every** launch and stop — a standing root capability in the stop path, i.e.
  the D4 question. D/E are unauthorized; this unit neither requests nor designs it.

### Verdict and its falsification conditions

**Candidate ready for a separately authorized live probe.** The safety half of literal 1a is
established read-only: no bystander is signalled (pidversion-atomic terminate), no false success is
possible (fail-closed on any query or acquisition failure), and no actor-accessible route sheds the
run ASID for an in-chain descendant. Not rejected: the race Codex flagged is removed by a kernel
mechanism, not by a probability argument. The probe must confirm the **efficacy** half, and **any** of
these failing rejects the candidate:

1. The launch wrapper places the actor in a fresh unique ASID, and the fully escaped daemon reports it
   under a root token read.
2. The escaped platform-binary descendant's `audit_token` (with pidversion) is obtainable by root
   without the SIP-restricted control port, and `proc_terminate_with_audittoken` then terminates it.
3. An unprivileged actor descendant cannot change or shed its ASID (both calls return the superuser
   error).
4. Root enumeration + audit-token terminate reaches every run member and no uid-501/uid-502 bystander,
   with a reused pid provably spared by pidversion mismatch.
5. Two concurrent runs receive distinct ASIDs and each supervisor terminates only its own.
6. `AUE_SESSION_END` for the run ASID is delivered on this auditd-unconfigured host — or fail-closed
   polling census is confirmed as the verification fallback.

### How the verdict could have gone the other way

- Had the audit token not carried a pidversion, or `proc_*_with_audittoken` not validated it exactly,
  there would be no atomic identity-bound signal and finding 1 would force **rejected**. The token
  carries it (`audit_token_to_pidversion`) and `IDENT_VALIDATION_PROC_EXACT` enforces it.
- Had `priv_check_cred` carried an entitlement grant for the audit-session privilege, an entitled actor
  helper could shed the ASID and it would be **rejected**. It grants only to uid 0 or a MAC policy, and
  no such policy was found.
- Had `exec` or `se_procnt` behaved differently (session reset on exec; count not covering orphans),
  selection or verification would break → **rejected**. Neither does.
- Had token acquisition for the escaped shape been *provably impossible* read-only, the terminate could
  never reach the escaped daemon and it would be **rejected**; instead it is unresolved read-only and
  fails closed, which is a probe question, not a safety defect.

### Inspection failures and version gaps, stated rather than read as absence

- **Source, not runtime.** Kernel behaviour is read from published XNU `xnu-12377.121.6` (cross-checked
  `xnu-11417.101.15`), not the exact running `xnu-12377.121.10`, which Apple has not published. No
  audit-session or signal call was executed here.
- **Token acquisition for a hardened exec is unsettled read-only.** Whether `task_inspect_for_pid` /
  `task_name_for_pid` + `task_info(TASK_AUDIT_TOKEN)` yields an arbitrary platform binary's token to
  root was not confirmed from source in this round; the `task_for_pid` control-port restriction file
  did not return its body on fetch. This is falsification condition 2, and it fails closed.
- **SESSION_END delivery on this host is unconfirmed** (auditd not configured). Falsification
  condition 6, with the polling fallback named.
- **The MAC-policy grant surface was not exhaustively enumerated.** The superuser-only conclusion for
  the audit-session privilege is bounded to `priv_check_cred` plus the absence of a known grant.
- **No manual pages exist for any audit interface on this host** (Unit 7); privilege and lifecycle
  statements rest on shipped headers and Apple's published source.

### Carried forward — current truth (core § 4)

- **Unit 9 accepted, persona rejected** (git `444bdf2`): `com.apple.private.persona-mgmt` is a hard
  restricted entitlement, in none of AMFI's three exception tables. Not reopened.
- **Deferral 14 stands, uncorrected:** two sentences in retained Unit 8 material called the withdrawn
  outcome "the rejection." Preserved; Codex's call.
- **The dispatcher's current reach is unchanged and remains the honest fallback:** `dispatch.test.sh`
  case 27h still pins the surviving hole. Root-bearing ASID with audit-token terminate is the first
  candidate that would close it, subject to the probe.
- **The live account is untouched** and was not re-measured: the Unit 8 close measurement stands
  (uid 502, non-admin).

## Blocker

**A candidate now passes literal 1a's safety half read-only, for the first time, but only under
root-bearing authority the task has not been granted, and its efficacy on the escaped shape is
unproven.** Root-bearing ASID paired with `proc_terminate_with_audittoken` reaches the escaped daemon
in principle, excludes the account's own launchd agents, gives concurrent runs distinct boundaries,
signals no bystander (pidversion-atomic), and fails closed. It is **not proven**: the decisive open
question is whether the escaped platform binary's `audit_token` is obtainable by root without the
SIP-restricted control port so the atomic terminate can actually reach it, plus whether
`AUE_SESSION_END` delivers on this auditd-unconfigured host. Both are probe questions; both fail closed.
Nothing is requested here — sizing the probe authority and deciding the next move is Codex's assessment
and the operator's decision.

**The candidate space is effectively down to this one mechanism.** Process group, ancestry-at-stop,
environment tag, working directory, `kqueue NOTE_TRACK`, launchd job removal, Darwin `ptrace`,
containers and coalitions were excluded by the closed supervision discovery; UID (Unit 5) and real GID
(Unit 6) shed or over-broad; persona rejected (Units 8–9). Root-bearing ASID with audit-token terminate
is the surviving named candidate and the first to pass the read-only safety bar.

**Authority boundaries are unchanged.** Attended probe authority (`sudo -u`, and attended root for the
probe) is distinct from unattended production authority; D4 and Stages D/E stay unauthorized. Persona
stays closed and must not be reopened.

**The dispatcher's current reach remains the honest fallback**, unchanged, with `dispatch.test.sh`
case 27h pinning the surviving hole.

**The live account stays untouched** and was not touched or re-measured this unit. The Unit 8 close
measurement stands (uid 502, non-admin). Nothing may signal, delete, log into or authenticate uid 502.

## Next action

Codex: closure check on the two frozen findings only. Finding 1 (the bystander race) — resolved by
replacing `kill(pid)` + re-check with `proc_terminate_with_audittoken`, whose pidversion-exact
validation is quoted from XNU and the SDK; the false "re-check spares it" claim is withdrawn and FP/FN
row (d) corrected. This is a branch-(a) resolution (an atomic identity-binding signal is cited and
assessed), **partial** on the "works for the escaped shape" clause: the terminate is bystander-safe and
can signal a platform binary, but the token-acquisition step for a non-spawned hardened exec is
unresolved read-only and is carried as falsification condition 2, failing closed. Finding 2 (privileged
shed routes) — resolved: the change gate is superuser not entitlement (`priv_check_cred` quoted), the
spawn-attribute and induced-spawn surfaces are assessed, and the service-owned non-descendant is
separated from an in-chain session change, with no supported shed route found. Confirm both findings are
resolved and that the correction broke nothing, then close or use the menu. Persona stays closed;
Deferral 14 remains open; literal Phase 1a and the live account's untouched status are preserved.
