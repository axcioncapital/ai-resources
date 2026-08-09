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

**Unit 10 (Discovery) — VERDICT: root-bearing ASID is a candidate ready for a separately authorized
live probe.** Read-only throughout. No `sudo`; no audit session created, joined, changed or ended; no
live audit-session stream opened; no process signalled or launched; nothing compiled, signed, installed
or executed as a probe; no account action, login or authentication; no Keychain, credential or
provisioning-profile contents read; the dispatcher, tests and every product file unchanged; no
repository file other than this one. The live account was not touched or re-measured. Session scratch
held Apple's published XNU source fetched over the network; nothing was vendored into the repository.

**What Unit 10 resolves that Unit 7 left open.** Unit 7 established that both ends of an ASID mechanism
are superuser-gated and stopped there, recording the root-bearing form as *unassessed*. This unit
assesses it: **given** the two root capabilities Unit 7 named — place-a-session-at-launch and
query-a-pid's-session — the mechanism satisfies literal 1a's three requirements (terminate the full
descendant tree including the escaped daemon; signal no unrelated process; never claim success when
incomplete) more cleanly than any candidate examined so far, because a fresh per-run ASID is (a)
inherited across the entire escape by the process credential, (b) unforgeable and unsheddable by an
unprivileged descendant, and (c) backed by a kernel-maintained live-process count whose
`AUE_SESSION_END` event is a truthful "all members exited" signal. The open items are
runtime-confirmation questions, not logical defects, and they define the probe.

### Inspection record — the brief's load-bearing premises

```
Inspected (2026-08-09):
- Premise (Unit 9 accepted verdict — persona rejected): HOLDS — read this file's prior `## Latest
  result`/`## Blocker` and the accepted record at git `444bdf2`. Persona is a hard restricted
  entitlement in none of AMFI's three exception tables; not reopened, not relied on here.
- Premise (Unit 7 accepted conclusion at its stated bound — ASID has useful granularity, is unusable
  under current authority, root-bearing form unassessed): HOLDS — re-established from durable history
  at git `c49e1f4`, not from recall. That record confirms `setaudit_addr(2)` gated by `suser()`,
  `auditon(A_GETPINFO_ADDR)` falling to `default: suser()`, `audit_session_port()` gated by
  `PRIV_AUDIT_SESSION_PORT`, and no unprivileged enumerate-by-session selector.
- Premise (running kernel and the audit-session subsystem are present on this host): HOLDS — measured:
  `uname -v` = `xnu-12377.121.10~1/RELEASE_ARM64_T8142`; `bsm/audit_session.h`, `bsm/audit.h`,
  `bsm/audit_kevents.h`, `security/audit/audit_ioctl.h` all present in the active SDK; `SYS_setaudit_addr
  358`, `SYS_auditon 351`, `SYS_audit_session_join 429`, `SYS_audit_session_port 432` in
  `sys/syscall.h`; `/dev/auditsessions` present (`crw-r--r-- root wheel`).
- Premise (the audit *trail* is not configured on this host — bounds the SESSION_END verification
  claim): HOLDS — `/etc/security` has `audit_control.example` but no `audit_control`; `pgrep -lf
  auditd` exits 1. Session tracking is a distinct subsystem, but event *delivery* on this unconfigured
  host is not proven read-only and is probe falsification condition 6 below.
```

### The mechanism, from Apple's published XNU source

Fetched 2026-08-09 from `apple-oss-distributions/xnu` tag `xnu-12377.121.6` — the nearest published tag
in the running kernel's `12377.121` series (`.10` is not published; that gap is stated, not papered
over). The three functions below were also read at tag `xnu-11417.101.15` and are unchanged there, so
they are not a single-release artifact.

**1. A per-run ASID is kernel-assigned, unique among live sessions, and collision-safe by
construction.** `audit_session_new()` handles the `AU_ASSIGN_ASID` request with a retry loop:

```c
if (new_asid == AU_ASSIGN_ASID) {
    do {
        new_asid = (au_asid_t)audit_session_nextid();
        found_se = audit_session_find(new_asid);
        if (found_se != NULL) { audit_unref_session(found_se); }
        else { break; }
    } while (1);
}
```

`audit_session_nextid()` walks `[ASSIGNED_ASID_MIN, ASSIGNED_ASID_MAX]` under the session rwlock and
wraps; `audit_session_find()` is a hash-table lookup, and any value already held by a live session is
skipped. `ASSIGNED_ASID_MIN = PID_MAX + 1` and `ASSIGNED_ASID_MAX = 0xFFFFFFFF - 1` (`audit_private.h`),
so assigned ASIDs start at 100000 and never overlap the pid space — which matches the live values Unit 7
observed (`asid = 100016`, `100046`). **Consequence for concurrency:** two runs each asking for
`AU_ASSIGN_ASID` receive two distinct ASIDs whether or not they share a checkout or an actor account.
This is the property the UID boundary (Unit 5) and the real-GID boundary (Unit 6) both lacked — the same
account meant the same identity.

**2. The ASID rides the process credential, so it survives the entire escape and cannot be shed by an
unprivileged descendant.** Every new process created through `forkproc()` runs
`AUDIT_SESSION_PROCNEW(child_proc)` unconditionally, and `audit_session_procnew()` increments the
session's process count from `cred->cr_audit.as_aia_p`. `fork` copies the credential, `execve`
preserves it, `setsid` touches only the BSD session/pgrp. The only calls that change a process's audit
session are `setaudit_addr(2)` and `audit_session_join(2)`, both superuser-gated (Unit 7;
`audit_session_join_internal()` runs `priv_check_cred(cred, PRIV_AUDIT_SESSION_PORT, 0)` for any session
but the caller's own). So an actor descendant that setsids, double-forks, closes every descriptor and
execs `/bin/sleep` still carries the run ASID, and can neither leave it nor forge another. The
setuid-root exec case does not help it: `exec` preserves the audit session, and the only two setuid-root
binaries that touch it (`login`, `su`, from Unit 7's complete inventory) authenticate first.

**3. Verification is kernel-authoritative, not a census the supervisor must trust.**
`audit_dec_procount()` fires an event when the last member exits:

```c
old_val = OSAddAtomicLong(-1, &se->se_procnt);
if (old_val == 1) { audit_session_event(AUE_SESSION_END, &se->se_auinfo); }
```

`audit_session_procexit()` (on every process exit) decrements; `audit_session_procnew()` (from
`forkproc()` on every fork) increments. So `se_procnt` is the kernel's own count of live processes in
the session, maintained across fork, exec and orphaning, and `AUE_SESSION_END` means exactly what the
SDK header says: "all the processes in the session have exited." `bsm/audit_session.h`'s
`au_sdev_read_aia()` documents that event set (`AUE_SESSION_START/UPDATE/END/CLOSE`) delivered from
`/dev/auditsessions`, and `AU_SDEVF_ALLSESSIONS` "(Requires privilege.)" is the flag a root supervisor
would open it with.

### Inheritance and mutability

| Transition | Effect on the run ASID | Source |
|---|---|---|
| `fork` / `posix_spawn` | inherited; child increments `se_procnt` | `forkproc()` → `AUDIT_SESSION_PROCNEW`; cred copy |
| `execve` (incl. of a setuid-root binary) | preserved — exec does not change the audit session | Unit 7; cred preserved across exec |
| `setsid`, double fork, orphaning to PPID 1 | unchanged — only BSD session/pgrp move; `se_procnt` still counts the orphan | `setsid(2)`; procount is per-cred, not per-parent |
| `closerange` / descriptor close | unchanged — the ASID is in the credential, not a descriptor | credential model |
| unprivileged descendant tries `setaudit_addr` / `audit_session_join(other)` | **blocked** — `suser()` / `PRIV_AUDIT_SESSION_PORT` | Unit 7; `audit_session_join_internal()` |
| descendant execs a setuid-root helper to shed it | **blocked** — only `login`/`su` touch the session, both authenticate | Unit 7 inventory |

### Enumeration, signal and verification, under root

| Step | Primitive | Note |
|---|---|---|
| place the run in a fresh ASID | `setaudit_addr(ai_asid = AU_ASSIGN_ASID)` at launch, root | needs a small root wrapper that sets the session then execs the actor |
| read any pid's ASID | `auditon(A_GETPINFO_ADDR)` per pid, root; or `launchctl procinfo <pid>`, root | per-pid, not a set selector; both root-gated (Unit 7) |
| enumerate candidates | `sysctl KERN_PROC_ALL` / `libproc` list, then filter by queried ASID | no kernel ASID→pidset selector exists |
| signal | `kill()` per matched pid, re-checking that pid's ASID immediately before | no ASID-scoped signal primitive |
| verify all gone | `AUE_SESSION_END` for the run ASID from `/dev/auditsessions` (root, `AU_SDEVF_ALLSESSIONS`); or fail-closed polling census | kernel count is authoritative; polling is the fallback if the event does not deliver on this host |

There is still no ASID-scoped signal, so termination is list-then-signal — but the race that shape
carries is closable here in a way it is not for `pkill -U`: the run ASID is unique and unforgeable, so a
pid that exits and is reused by an unrelated process carries a *different* ASID, and a re-check-before-
kill spares it. Fail-closed holds throughout: root does not get `EPERM` querying a live pid (only `ESRCH`
for a dead one), so an unreadable census means retry, never "clean."

### False positive, false negative and race, by case (root-bearing ASID)

| Case | Outcome |
|---|---|
| (a) account launchd agent present at baseline | correct exclusion — it is in the account login-context session, not the run ASID |
| (b) account launchd agent launched *during* the run | **correct exclusion** — launchd starts it in the account session; this is the exact false positive that killed the UID boundary (Unit 5, observed 7→9) |
| (c) escaped daemon: setsid + double fork + closerange + exec | **reached** — the ASID rode the credential through all of it; root query finds it |
| (d) a run member exits, its pid reused by an unrelated process | no false positive — re-check ASID before kill; the reused pid carries a different ASID |
| (e) descendant execs a setuid-root helper | correctly excluded from shedding — only `login`/`su` touch the session, both authenticate |
| (f) two concurrent runs, same or different checkout/account | each gets a distinct kernel-assigned ASID; each supervisor signals only its own |
| (g) member forks a new child between census and signal | caught on the next iteration — the new child carries the ASID and increments `se_procnt`; loop until `AUE_SESSION_END` / empty census |
| (h) a query fails | fail-closed — retry; never claim success. Root removes the always-`CENSUS_UNKNOWN` problem the unprivileged case had (Unit 7 row f) |
| (i) an actor induces a *system service* to run work in the service's session | **out of scope, and a stated limitation** — that work is a child of the service, in the service's ASID, not an actor descendant; no per-run boundary catches it, and literal 1a is about the descendant tree |

### Authority — attended probe vs unattended production (claim 6)

- **Minimum temporary authority for a separately authorized, attended probe:** root, via operator-
  attended `sudo`, to do three things and nothing else — (i) launch a throwaway actor process through a
  small wrapper that calls `setaudit_addr(AU_ASSIGN_ASID)` then execs the escape fixture; (ii) read
  pids' ASIDs with `launchctl procinfo` or a tiny `auditon(A_GETPINFO_ADDR)` reader; (iii) optionally
  open `/dev/auditsessions` with `AU_SDEVF_ALLSESSIONS` to observe `AUE_SESSION_END`. No account
  mutation, no persistent config, no dispatcher edit, nothing retained. This is attended probe
  authority, the class Units 6–7 distinguished — not production authority.
- **Minimum production authority for an unattended dispatcher:** the dispatcher would have to hold, or
  call a narrowly-scoped setuid-root helper for, the same two root capabilities (set-session-at-launch
  and query-by-pid) at **every** launch and **every** stop — a standing root capability in the stop
  path. That is the D4 narrow-privilege question, and D/E are unauthorized. This unit neither requests
  nor designs it.

### Verdict and its falsification conditions

**Candidate ready for a separately authorized live probe.** Not rejected: no conflict with literal 1a
was found; the mechanism satisfies the escaped-daemon and no-bystander requirements that excluded every
prior candidate. Not "operator authority required" as a terminal: read-only evidence did reach a
conclusion — that a probe is the next step and exactly what it needs. The probe confirms or refutes, and
**any** of these failing rejects the candidate:

1. The launch wrapper places the actor in a fresh unique ASID, and the fully escaped daemon (setsid +
   double fork + closerange + exec) reports that same ASID under root `auditon(A_GETPINFO_ADDR)` /
   `launchctl procinfo`.
2. An unprivileged actor descendant cannot change or shed its ASID (both calls return the superuser
   error).
3. The account's own PPID-1 launchd agents carry the account session's ASID, not the run ASID.
4. Root enumeration + re-check-before-kill terminates every run member and no uid-501/uid-502
   bystander; a reused pid carrying a different ASID is spared.
5. Two concurrent runs receive distinct ASIDs and each supervisor signals only its own — tested
   same-checkout and different-checkout.
6. `AUE_SESSION_END` for the run ASID is delivered on this host with auditd unconfigured — or, if not,
   fail-closed polling census (loop until no pid carries the ASID; never succeed on a query error) is
   confirmed as the verification fallback.

### How the verdict could have gone the other way

- Had `exec` or a setuid transition reset the session, the escaped daemon would drop the ASID and the
  boundary would leak — it is not reset (cred preserved across exec; only `login`/`su` change the
  session, both authenticated). → **rejected**.
- Had `se_procnt` counted only session creators/joiners rather than every forked process,
  `AUE_SESSION_END` would fire while orphaned descendants still ran — a false "all gone."
  `forkproc()`'s unconditional `AUDIT_SESSION_PROCNEW` is what makes the count cover the orphan. →
  **rejected on the verification half**.
- Had `AU_ASSIGN_ASID` let a caller pick a fixed number, two runs could collide and cross-signal. The
  kernel assigns and skips live values instead. → collision would have forced **rejected**.
- Had root query of an arbitrary pid's ASID not existed (only own-session reads), there would be no
  enumeration primitive even with root, and the verdict would be **rejected**, not probe-ready.
  `auditon(A_GETPINFO_ADDR)` and `launchctl procinfo` are the root-capable per-pid queries Unit 7 found.

### Inspection failures and version gaps, stated rather than read as absence

- **Source, not runtime.** The kernel behaviour is read from published XNU `xnu-12377.121.6` (and
  cross-checked at `xnu-11417.101.15`), not from the exact running `xnu-12377.121.10`, which Apple has
  not published. No audit-session call was executed on this host; the whole verdict is a read-only
  mechanism assessment, which is why it ends at "ready for a probe," not "proven."
- **SESSION_END delivery on this host is unconfirmed.** The audit *trail* is not configured (no
  `audit_control`, auditd not running). Session tracking is a separate subsystem and ASIDs demonstrably
  work, but whether `/dev/auditsessions` actually delivers `AUE_SESSION_END` here was not tested
  read-only. It is falsification condition 6, with a fail-closed polling fallback named.
- **No manual pages exist for any audit interface on this host** (Unit 7). Every privilege and
  lifecycle statement rests on shipped headers and Apple's published source, not a documented contract.
- **`ASSIGNED_ASID_MIN`'s dependency `PID_MAX` was not separately quoted** from `sys/proc_internal.h`;
  its effect (assigned ASIDs begin at 100000) is corroborated by the live `asid = 100016`/`100046`
  values Unit 7 observed.
- **The induced-system-service shape (case i) was bounded, not exhausted.** Helpers that can change
  *audit-session* membership are the two authenticated ones; whether a system service can be induced to
  run actor work *in its own session* is a general persistence question no per-run boundary addresses,
  recorded as an accepted limitation rather than a defect.

### Carried forward — current truth (core § 4)

- **Unit 9 accepted, persona rejected** (git `444bdf2`): `com.apple.private.persona-mgmt` is a hard
  restricted entitlement, in none of AMFI's three exception tables, authorized only by an Apple-signed
  provisioning profile no third party can obtain. Not reopened.
- **Deferral 14 stands, uncorrected:** two sentences in the retained Unit 8 material called the
  withdrawn outcome "the rejection." Preserved so it is not lost; Codex's call.
- **The dispatcher's current reach is unchanged and remains the honest fallback:** `dispatch.test.sh`
  case 27h still pins the surviving hole — a descendant that closes every inherited descriptor survives
  the current census. Root-bearing ASID is the first candidate that would close it, subject to the probe.
- **The live account is untouched** and was not re-measured this unit: the last measurement stands from
  the Unit 8 close (uid 502, non-admin). No account action occurred.

## Blocker

**A viable supervision candidate now exists on paper for the first time, but only under root-bearing
authority the task has not been granted.** Root-bearing ASID passes every read-only test literal 1a
imposes — it reaches the escaped daemon, excludes the account's own launchd agents, gives concurrent
runs distinct boundaries, and carries a kernel-authoritative "all members exited" signal. It is **not
proven**: the verdict is "ready for a separately authorized live probe," and the probe needs temporary
attended root (set-session-at-launch, query-by-pid, optional session-event stream) plus confirmation of
the six falsification conditions in `## Latest result`. Nothing is requested here; sizing that authority
and deciding the probe is Codex's assessment and the operator's decision.

**The candidate space is now effectively down to this one mechanism.** Process group, ancestry-at-stop,
environment tag, working directory, `kqueue NOTE_TRACK`, launchd job removal, Darwin `ptrace`,
containers and coalitions were excluded by the closed supervision discovery; UID (Unit 5) and real GID
(Unit 6) shed or over-broad; persona rejected (Units 8–9). Root-bearing ASID is the surviving named
candidate and the first to pass the read-only bar.

**Authority boundaries are unchanged.** Attended probe authority (`sudo -u`, and now attended root for
the probe) is distinct from unattended production authority; D4 and Stages D/E stay unauthorized.
Persona stays closed and must not be reopened.

**The dispatcher's current reach remains the honest fallback**, unchanged, with `dispatch.test.sh` case
27h pinning the surviving hole.

**The live account stays untouched** and was not touched or re-measured this unit. The Unit 8 close
measurement stands (uid 502, non-admin). Nothing may signal, delete, log into or authenticate uid 502.

## Next action

Codex: assess Unit 10. The verdict is **root-bearing ASID is a candidate ready for a separately
authorized live probe**, with the six falsification conditions and the exact temporary probe authority
named in `## Latest result`. Decide close, continue, correct once, or stop — in particular whether the
next move is to size and bring to the operator the attended-root probe authority (an operator decision,
since it crosses into privilege the task has not been granted), to continue with a different unit, or to
accept the dispatcher's current reach as the honest fallback. Persona stays closed; Deferral 14 remains
open; literal Phase 1a and the live account's untouched status are preserved.
