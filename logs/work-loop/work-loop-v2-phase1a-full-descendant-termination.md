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

Standard. Discovery mode. Unit 7 — determine whether a Darwin audit session (ASID) can provide the
creation-time boundary that the exhausted process-attribute surface cannot.

Named reason for the loop: literal Phase 1a still needs a Darwin supervision mechanism, and a false
positive would signal unrelated OS processes while a false negative would leave an escaped daemon
alive. The last named candidate requires bounded discovery and independent assessment before any
operator authority, live probe or implementation is justified.

Plan justification: the governing unattended-operation plan still blocks Phase 2 on literal 1a and
1f. Unit 6's corrected result exhausts the non-root process-attribute surface. The closed supervision
discovery explicitly deferred audit sessions for a second look if the cheaper dedicated-UID route
failed; that route has now failed. Assessing this one named boundary is the smallest justified unit
that can advance 1a without changing host authority.

Codex framing decision: this remains discovery because ASID viability and its minimum authority are
unknown. This unit may inspect the host and repository read-only and change only this state file; it
may not signal, elevate, delete, authenticate, install, launch an actor fixture or implement
anything. Safe account removal is held outside this unit because no process emergency exists and
mechanism discovery is the nearest unmet Phase 1a condition.

### Unit 7 brief — executed

Codex's brief for this unit, moved here verbatim from `## Next action` when the unit completed, so
that field states the single next thing. The Unit 6 brief that previously stood here is committed at
`b00ee5f`/`69f47c7` and was removed from this file as prior-unit history (core § 4, current truth not
a diary). The brief itself is not altered; the result is in `## Latest result` below.

Unit 6 excludes every non-root process attribute inspected so far. Determine whether a distinct
Darwin audit session can identify the actor's full descendant tree after `setsid`, double fork,
descriptor closure and `exec`, without selecting the account's PPID-1 macOS services or any other
bystander. Return evidence and a verdict only; do not create an audit session, elevate, signal or
implement anything.

**Governing sources and dispositions:** literal 1a and the no-unrelated-process rule in
`## Objective and scope` govern. Unit 6's corrected result governs the exhausted process-attribute
surface. The closed `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` is accepted
evidence that ASID was deferred because it appeared to require root for both creation and
enumeration; treat inheritance, immutability and exact authority as verify-first claims, not settled
facts. The current dispatcher and escaped-descendant evidence are verify-first repository claims and
may be inspected but not changed.

**Named unknown:** can a per-run audit session form a truthful, race-safe supervision boundary on
this Darwin host, and if so what is the smallest exact authority needed to create, enumerate, signal
and verify it across every controlled stop path?

**Claims to check:**

1. Inspect the complete relevant local manuals, SDK headers and available binaries for Darwin audit
   identity and session APIs. Establish which attributes are inherited across `fork`, `exec`,
   `setsid` and double fork; which calls create or change them; and which privileges those calls
   require. An API symbol or header alone is not effective availability.
2. Establish how an external supervisor can enumerate or query **arbitrary** processes by audit
   session on this host, not merely read its own audit identity. Identify the exact selector/API,
   visibility failures, exit/error semantics and SIP or entitlement constraints. Bound every absence
   claim to the manuals, headers, binaries and process interfaces searched.
3. Test the boundary logically against the accepted escape and bystanders: the actor daemon after
   orphaning and `exec`; the account's pre-existing and later-launched macOS services; uid-501
   processes; PID reuse; an enumeration failure; and a descendant executing a setuid-root helper.
   Include the Unit 6 deferral by auditing only host helpers capable of changing audit credentials,
   not every setuid binary for unrelated behavior.
4. Establish whether selection and signalling can be made race-safe. A list of PIDs followed by a
   later signal is insufficient unless the design proves how PID reuse and a process changing audit
   identity cannot turn it into a bystander signal or false success. Verification must fail closed
   when any process cannot be inspected.
5. Map any surviving candidate across all actor launch and controlled stop paths in `dispatch.sh`,
   preserving the global deadline, interruption semantics, retry prohibition, lock pinning/cleanup,
   exit-code honesty and attended behavior. Distinguish operator-attended probe authority from
   unattended production authority.
6. Return one verdict: **candidate ready for a separately authorized live probe**, naming every
   falsification condition and the exact temporary authority; **candidate rejected**, naming the
   conflict; or **operator authority required**, only if repository and local primary evidence can
   establish viability no further without a privilege-bearing check. Do not prescribe an
   implementation or ask for authority merely to resolve a read-only question.

**Required evidence:** list the exact manuals, headers, binaries, repository files and read-only
commands inspected; separate observation from inference; give a false-positive/false-negative and
race table covering claim 3; show how the verdict could have gone the other way; and state every
inspection failure. Evidence must be capable of rejecting ASID, not just explaining it.

**Scope and stops:** this state file only. No `sudo`, root helper, signal, process launch, audit
session creation/change, `launchctl` mutation, account action, login, authentication, installation,
C5, rollback, product edit, test run or new repository artifact. Do not inspect credential contents.
Safe account removal stays outside this unit. Stages D/E, Phase 1f and every Phase 2 action remain
forbidden. Stop and hand back if a premise is false, the question requires host mutation, or the
required evidence cannot be produced read-only.

Unit completion: replace `## Latest result` with the ASID discovery verdict and evidence, update the
blocker truthfully, commit only this state file, set `turn: codex`, and stop. Preserve the live
account and literal Phase 1a.

### Accepted Unit 5 brief — reconstructed, NOT verbatim

**Corrected at finding 4.** The earlier "restored verbatim" label was false and is withdrawn. Codex's
original Unit 5 brief was destroyed by the truncation recorded in `## Latest result`, and it is not
recoverable from git because it was never committed. What follows is a **condensed reconstruction
from session context**, not the former text.

**Known differences from the original:** the five numbered "Claims to check" were compressed from
separate numbered items into a single paragraph, and claim 3's explicit list of local manuals
(`pkill`/`kill`/`launchctl`/account-management) was generalised to "local primary interfaces".

**Checked requirement by requirement against the original**, which Codex read before execution: the
named unknown, all five claims to check, the required-evidence tests, the full stop list and the
completion condition are each still represented. Codex is the authority on any difference — treat this
as a reconstruction to be verified, not as the record.

> The first authorized live run stopped exactly where its guard required: a fresh non-admin account
> immediately acquired persistent macOS per-user agents, so its UID was never an actor-only boundary.
> Before any login, signal or rollback, determine whether the dedicated-identity route remains viable
> on this Mac and what can safely happen to the account now; literal Phase 1a remains unchanged.
>
> **Governing sources and dispositions:** the operator's preservation of full-descendant termination
> and B/C-only authorization in `## Objective and scope` govern. The current operator census in
> `## Latest result` is authoritative live evidence. The accepted runbook's B4, C5 guard 2/guard 4,
> final census and R1 are settled procedure but rest on the now-false empty-boundary premise; treat
> them as the object under examination, not as permission to proceed. The unattended-operation plan's
> literal 1a and bystander prohibition govern the verdict. Work Loop core and skill govern this
> read-only discovery handback. Unit 4 remains accepted; do not reopen its transport.
>
> **Named unknown:** can one account per checkout still be an actor-only, verifiable termination
> boundary when macOS automatically runs PPID-1 agents under that same UID, or does this live fact
> reject the dedicated-UID route?
>
> **Claims to check:** (1) verify from the exact B4, C5 and R1 text that a non-empty baseline prevents
> the accepted probe, exact census and rollback from running, naming the lines or patterns that settle
> it; (2) inspect uid 502 read-only, with full-width commands and the applicable local launchd/process
> metadata, to identify each process's owner, launch domain/job where discoverable, persistence and
> relevant keep-alive/respawn semantics, stating every inspection failure rather than reading it as
> absence, and without signalling a process to test respawn; (3) establish from local primary
> interfaces whether a pattern-free UID signal would select these agents, whether they are outside the
> actor descendant tree, and whether their presence makes a truthful post-stop empty-UID verification
> impossible or merely requires a different evidence-backed boundary, without inferring signal reach
> from `pgrep` alone; (4) verify the live host facts that matter for safe disposition — uid 502,
> non-admin, no Claude/Codex authentication, owns a home — searching only the actor account/home and
> relevant metadata, not reading credential contents, determining what can and cannot be safely
> reversed without signalling these agents, and not prescribing an unverified deletion sequence;
> (5) compare only mechanisms already surfaced, invent no implementation, and return one verdict —
> **route viable**, **route rejected**, or **operator authority required** — stating safe account
> disposition separately from route viability where it needs an operator choice.
>
> **Required evidence:** the exact read-only commands/surfaces inspected and their relevant non-secret
> output; observed process/job facts distinguished from inference; how the verdict could have gone the
> other way; and all nine observed process families accounted for or explicitly marked unresolvable.
> A grep of this brief or a repeated `pgrep` count alone is not evidence.
>
> **Scope and stops:** this state file only. No `sudo`, `kill`, `pkill`, `launchctl kill`, `bootout`,
> account deletion, authentication, installation, C5, rollback, Git, dispatcher code or product test.
> No Stages D/E, no 1f, no Phase 2. Stop and hand back if resolving the unknown requires any host
> mutation or new operator authority.
>
> **Unit completion:** replace `## Latest result` with the discovery verdict and evidence needed for
> the next decision, update the blocker truthfully, commit only this state file, set `turn: codex`,
> and stop. Preserve the fact that the live account exists until an authorized disposition actually
> runs.

### Accepted Unit 3 brief (superseded by Unit 4 in `## Next action`)

The dedicated-identity route now turns on three facts that only a real account can settle. Before the
operator creates that account, convert the draft chat instructions into one complete runbook whose
guards make a wrong account, an occupied UID, an unlocked GUI session or an over-broad signal a
visible stop. This unit writes and validates that runbook; it does not execute it.

### Governing sources and dispositions

- **Current operator decision:** Stages B and C are authorized; D and E are not. This governs the
  host-action boundary and supersedes this file's former `turn: operator` decision request.
- **Governing plan:**
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, especially the status block, Phase 1
  item 1a, the two remaining Phase 2 blockers and the Phase 2 prohibition.
- **Accepted Unit 2 result:** the corrected dedicated-identity discovery committed by Claude at
  `cd88efa`, together with Codex's accepted closure check previously recorded in this file. Verify
  the live repository before relying on the commit or its content. The settled design is one
  non-admin actor identity per checkout, an eventual actor-UID lock, actor-owned Claude/Codex
  authentication and a later UID-scoped termination boundary. Unit 2 did not prove that boundary.
- **Existing detached-process fixture and evidence:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probes/escaped-descendants-2026-08-07.sh`,
  `runs/probe-escaped-descendants-2026-08-07.md`, and the matching cases in `dispatch.test.sh`.
  Reuse their already-proved escape shape where suitable; do not invent a weaker stand-in.
- **Current dispatcher and safety behavior:** `dispatch.sh`, `dispatch.test.sh`, spike `README.md`,
  the interruption record and Phase 0 evidence. They govern bystander protection, stop semantics,
  retry prohibition, lock behavior, exit-code honesty and the effective detached shape.
- **Workflow contract:** `.agents/skills/work-loop-v2/SKILL.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. This is a discovery unit: change
  nothing except this state file, return the evidence and hand back.
- **Non-governing draft:** Claude's chat procedure beginning with `sudo sysadminctl -addUser
  wlactor`. Treat it as candidate material to verify, not as an approved command sequence. In
  particular, it did not establish how a fresh actor invokes `claude install`, and it omitted C5.

### Required outcome

Return one ordered runbook that the operator can execute without inventing a command or safety step.
It must cover preflight, Stage B, every Stage C check, the full C5 fixture, pass/fail interpretation,
evidence to bring back, and rollback. Commands must be backed by local help/manual behavior or an
explicitly cited primary source, and every runtime-dependent premise must remain a visible operator
check rather than being promoted to fact.

The runbook must make these outcomes unambiguous:

1. **C3 fails:** stop immediately and safely remove the temporary boundary.
2. **C3 passes but C4, C5 or C6 fails:** stop, preserve the exact non-secret evidence, and offer a
   complete rollback; do not proceed to D.
3. **All Stage C checks pass:** stop with D and E still forbidden, report exactly what was proved,
   and state whether the temporary account remains or is rolled back pending a new operator decision.

Do not call the dedicated route viable merely because the commands are well formed. Only the later
operator run can supply the missing host evidence, and 1a remains open even if every C check passes.

### Claims to verify before writing the runbook

1. **Current state and scope.** Re-read the current state, plan and named evidence. Confirm that the
   operator authorized B/C only, that no Stage B/C host action is recorded as already executed, and
   that Phase 2 remains forbidden.
2. **Account preflight and rollback.** Inspect local `sysadminctl`, `dscl`, `id` and relevant manual
   behavior read-only. Establish a collision-safe account name for this checkout, a guard that
   refuses if the name, UID or home path already belongs to anything, how the password is entered
   without appearing in argv, history, the state file or captured evidence, how non-admin status is
   proved, and what account deletion does to the home. The rollback must never delete or repurpose a
   pre-existing account and must not use an unguarded recursive deletion.
3. **Claude bootstrap.** Verify the live install layout and a fresh login shell's executable search
   path. The current operator binary is under `/Users/patrik.lindeberg/.local/bin`; a new actor has no
   demonstrated `claude` command with which to run `claude install`. Select and justify a supported,
   one-time bootstrap that installs into the actor's own home without copying credentials or making
   the operator-home binary a steady-state dependency. Do not download or install anything now.
4. **Attended login versus the decisive non-GUI check.** Establish the exact supported Claude and
   Codex login/status commands and their non-secret success/failure output. The runbook must allow an
   attended actor login if required, then require a **full actor GUI logout**, not fast user
   switching, and positively check that no actor GUI session remains before C3. Resolve when hiding
   the account is safe; do not hide or disable the only login route before the attended setup that
   needs it.
5. **C5 target derivation and ordering.** Determine an ordering that makes the empty-UID premise
   truthful. Before any UID-wide signal, enumerate the actor UID and refuse to signal if any process
   exists other than the fixture's exact expected members and the signalling command's documented
   exclusions. Never treat an unexpected actor process as cleanup permission.
6. **C5 fixture.** Return the full executable fixture inline, or an exact safe invocation of an
   existing script if it already provides the required boundary. It must create an actor-owned fully
   detached daemon that performs `setsid`, double-forks, closes inherited descriptors and execs a
   normal system binary; create a uid-501 bystander; prove the target has the expected actor UID and
   escape properties before signalling; run the exact TERM/grace/KILL/empty-census sequence; prove
   the daemon is gone and the bystander remains alive; distinguish exit 0, 1 and `>=2`; and clean up
   every fixture process on every exit. It must refuse root, uid 501, an empty/malformed UID, a UID
   that no longer maps to the intended account, and any unbounded or unexpected target census.
7. **Read-only C6.** Verify the minimum Git configuration needed for the actor to read this checkout
   across the ownership boundary. C6 may prove traversal, repository recognition and
   `safe.directory`; it must not claim write or commit ability before D2. Avoid optional index writes
   where Git provides a supported read-only mode, and do not collect credential-helper output.
8. **Rollback and residue.** Pair every persistent Stage B/C change with a checked rollback. Include
   a final process census, authentication logout where supported, account deletion, account/home
   absence checks and treatment of a logout command that cannot reach a locked keychain. State what
   remains after a successful C run and what the operator must decide before anything else happens.

### Required evidence

Evidence must be capable of rejecting the proposed runbook.

- A command-support table citing the local help/manual or primary source for account creation and
  deletion, password handling, actor-owned Claude bootstrap, Claude/Codex login and status, GUI
  logout/session detection, `pkill -U`/`pgrep -U`, and read-only Git status behavior.
- A stage table with every command marked `[READ-ONLY]`, `[ADMIN]`, `[ATTENDED]`, `[SIGNAL]` or
  `[ROLLBACK]`, plus its pass result, fail result, stop point and captured evidence. Secret values and
  passwords must never be captured.
- The exact C5 shell content syntax-checked with `bash -n` using only a temporary, self-cleaning file.
  Also provide a static signal audit listing every `kill`, `pkill` or equivalent invocation and the
  guard that proves its target. Do not execute any UID-wide signal in this unit.
- A fail-capability matrix showing at least: existing-name collision; malformed, root, operator or
  mismatched UID; occupied actor UID; failed Claude bootstrap; incomplete GUI logout; locked
  keychain; failed Codex status; C5 daemon survivor; C5 bystander death; `pkill`/`pgrep` exit `>=2`;
  read-only Git failure; rollback failure. Each must lead to a visible stop, not continued setup.
- A concise operator evidence template containing only the outputs needed for Codex assessment after
  the real run. It must not ask for passwords, tokens, credential files, Keychain contents or browser
  data.

### Scope and stop conditions

Allowed repository path: this state file only.

Allowed work: read the named repository sources; inspect local binary paths, versions, `--help`,
manual pages and non-secret file/account metadata; consult official primary documentation only where
the local interface is insufficient; create and remove self-cleaning temporary material solely to
syntax-check the proposed C5 code.

Forbidden in this unit: `sudo`; account creation, deletion, hiding or repurposing; password prompts;
Claude/Codex installation, authentication or logout; Keychain or TCC mutation; any signal against a
real UID or process; ACL, mode, owner, operator-home, `sudoers`, wrapper, dispatcher, test or README
changes; any repository artifact besides this state file; Phase 1f; Phase 2; push, merge or deployment.

Stop and hand back rather than improvise if a safe bootstrap cannot be established; account rollback
semantics remain ambiguous; the C5 target cannot be bounded strongly enough to protect uid 501 and
pre-existing actor processes; complete evidence would require a secret; the runbook needs D/E
authority; a governing premise is false; or the required evidence cannot be produced without running
the authorized host actions prematurely.

Unit completion: Claude changes and commits only this state file, replaces `## Latest result` with
the verified runbook and evidence, leaves 1a open, sets `turn: codex`, and stops. Do not execute the
runbook, create another artifact or push.

## Latest result

**Unit 7 (Discovery, CORRECTED at the correction round) — the Darwin audit session is unusable under
current authority.** Read-only throughout. No `sudo`, no root helper, no signal, no process launched
under test, no audit session created or changed, no `launchctl` mutation, no account action, no login,
no authentication, no installation, no C5, no rollback, no fixture execution, no product edit, no test
run, and no repository file other than this one. No credential contents were read. Nothing was
compiled or executed. The live account was preserved untouched. The correction added one read-only
source: Apple's published XNU source, fetched over the network and quoted below.

**The verdict "candidate rejected" is WITHDRAWN and replaced.** The corrected verdict is the boundary
the evidence actually supports:

- **ASID is unusable under *current* authority.** Both ends the dispatcher would have to hold are
  superuser-gated in the kernel: creating a session (`setaudit_addr(2)`) and querying another
  process's session (`auditon(A_GETPINFO_ADDR)`). The dispatcher is uid 501 and unprivileged, so it
  can neither place a hop in a session nor read which session a process is in.
- **Making it usable needs new root-level creation and query authority** — which this unit does not
  request, does not size, and does not weigh against the alternatives. That is Codex's assessment and
  the operator's decision, not this unit's.
- **Even granted that authority, two questions stay unresolved:** selection-to-signal race safety
  (there is no ASID-scoped signal primitive, so any design is list-then-signal), and the
  implementation shape (this unit did not establish what a root-bearing design would have to be).

**What is withdrawn with it.** The claim that "the only path that would make ASID work is a
root-privileged bespoke C supervisor" is withdrawn: this unit found two shipped root-capable query
paths — `launchctl procinfo` and `auditon(A_GETPINFO_ADDR)` — and never established that a bespoke
supervisor is the only root-bearing design. The unqualified form of claim 2, that *no* external
supervisor can query arbitrary processes by session, is withdrawn and replaced by its true scope: no
**unprivileged** supervisor can.

Evidence: Apple's published XNU source for `setaudit_addr()`, `auditon()` and `audit_session_port()`;
`bsm/audit.h` and `bsm/audit_session.h` in the active SDK; `sys/syscall.h`, `sys/sysctl.h`,
`sys/proc_info.h`, `libproc.h`, `xpc/connection.h`; the setuid-root binary inventory and its symbol
imports; `launchctl print user/501` and `print gui/501`; `launchctl procinfo`; the full `ps -L`
keyword list; the full `pgrep`/`pkill` usage; and `/etc/security`. Each is quoted below. Three places
where the verdict could have gone the other way are listed at the end.

### The correction round — findings 1, 2 and 3

All three reproduced by inspection before any was corrected.

- **Finding 1: REPRODUCES.** The result said the two blocking facts "were measured directly rather
  than inferred", and the thing standing behind the creation half was: "A call that ships behind
  setuid root in both of its only callers is not an unprivileged call." That is an inference, and an
  invalid one — `login` and `su` need root for work that has nothing to do with audit sessions
  (`utmpx`, session setup, changing uid), so their mode says nothing about `setaudit_addr(2)`'s own
  permission rule. The same inference stood in table row (g) and in "how the verdict could have gone
  the other way" item 3.
- **Correction 1 — the inference is replaced by the kernel's own text.** Codex's three cited rules
  were reproduced against Apple's published XNU source and **all three are confirmed verbatim**:

  1. **`setaudit_addr(2)` requires superuser.** `bsd/security/audit/audit_syscalls.c`: after the
     MACF hook `mac_proc_check_setaudit(p, &aia)`, the call runs
     `error = suser(current_cached_proc_cred(p), &p->p_acflag); if (error) { return error; }` and only
     then reaches `error = audit_session_setaia(p, &aia);` — exactly the order Codex named.
  2. **`auditon(A_GETPINFO_ADDR)` requires superuser.** In the same file's "Check appropriate
     privilege" switch, the only commands with a lighter rule are `A_GETSINFO_ADDR` (comment: "A_GETSINFO
     doesn't require priviledge but only superuser gets to see the audit masks"), `A_GETSFLAGS`/`A_SETSFLAGS`,
     and `A_SETCTLMODE`/`A_SETEXPAFTER` (entitlement-gated). `A_GETPINFO_ADDR` carries **no** case there,
     so it falls to `default: error = suser(kauth_cred_get(), &p->p_acflag);`.
     **This is worth stating plainly because the first reading of the source got it wrong:** the
     `A_GETPINFO_ADDR` handler itself contains no privilege check, only `kauth_cred_proc_ref_for_pid()`
     and `ESRCH`, so reading the handler alone suggests it is unprivileged. The gate is 360 lines
     earlier, in the shared switch. Codex's rule is right and the handler-only reading was wrong.
  3. **`audit_session_port()` requires `PRIV_AUDIT_SESSION_PORT` for any session but the caller's
     own.** `bsd/security/audit/audit_session.c`, header comment: "EPERM Only the superuser can
     reference sessions other than the process's own." In the body, the own-session branch says "No
     privilege is required to obtain a port for our own session", and the else branch says "Only
     privileged processes may obtain a port for any existing session" and runs
     `err = priv_check_cred(cred, PRIV_AUDIT_SESSION_PORT, 0);`.

  **Applicability, stated rather than assumed.** This host runs `xnu-12377.121.10~1` (`uname -v`).
  The newest published tag is `xnu-12377.121.6` — the same 12377.121 series, differing at the patch
  level. Both files were fetched twice, once from `main` and once from that tag, and the two copies
  are **byte-identical** (`diff -q`, no output), so the quoted text is the released source of the
  nearest published build and not a development snapshot. It is not the source of the exact running
  kernel, because Apple has not published `.121.10`; that gap is stated, not papered over.
- **Finding 2: REPRODUCES.** The result's claim 2 heading read "no external supervisor on this host
  can enumerate or query arbitrary processes by audit session" without qualification, while the body of
  the same claim recorded `launchctl procinfo` refusing *because the caller is not root* and
  `auditon(A_GETPINFO_ADDR)` existing as a per-pid query. Those are root-capable query paths, so the
  unqualified heading contradicted its own evidence. Separately, "the only path that would make ASID
  work is a root-privileged bespoke C supervisor" asserted an exclusivity the unit never tested.
- **Correction 2 — the verdict is narrowed to what the evidence carries**, in the replaced opening
  above: unusable under current authority; usable only with new root-level creation and query
  authority; race safety and implementation shape still unresolved. No authority is requested, no
  mechanism is prescribed, and the value-and-risk tradeoff is left to the operator. Claim 2's heading
  and claim 6 are corrected below.
- **Finding 3: REPRODUCES.** `## Blocker` opened "Every named supervision mechanism is now excluded
  under current authority, and no candidate remains", and its very next paragraph said `prsna`
  (persona) "has never been dispositioned" and is "the only thing standing between the current record
  and a literal exhaustion claim". Both cannot govern. The same section then said "What is now open is
  a decision, not a discovery" and offered "a restatement of what 1a guarantees" as one of two
  remaining paths — which contradicts `## Objective and scope`: "The operator preserved this guarantee
  on 2026-08-08."
- **Correction 3 — the exhaustion claim and the decision framing are both withdrawn.** `## Blocker` is
  rewritten below: no mechanism found *so far* is usable under current authority, persona remains an
  unexamined candidate for a later bounded discovery unit, and the next move is not asserted to be an
  operator decision. Restating literal 1a is removed as an option, because the operator already
  decided it. **Persona was not investigated during this correction**, as the finding requires.

### Inspection record — the brief's verify-first premises

```
Inspected (2026-08-09):
- Premise (1) "the closed supervision discovery records ASID as needing root for both creation and
  enumeration": HOLDS as a citation, and the underlying facts now hold as measured rather than as
  recalled — read `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` lines 33-37 and
  52-53; re-measured this round, and both halves are confirmed below in claims 1 and 2.
- Premise (2) "Unit 6's corrected result governs the exhausted process-attribute surface": HOLDS
  WITH ONE QUALIFICATION. Searched the full `ps -L` keyword list on this host: `prsna` (persona) is
  present and Unit 6's claim 3 dispositioned `uid`/`ruid`, `pgid`, `sess`, `tty`/`tdev`/`tpgid`,
  `ppid`, `login` and `rgid` but not `prsna`. "No attribute on that surface survives" is therefore
  one item short. Recorded as a deferral, not pursued — persona is not an audit identity and sits
  outside this brief's claims 1 and 3.
- Premise (3) "the current dispatcher and escaped-descendant evidence are verify-first repository
  claims": HOLDS. `dispatch.sh` exists (100,490 bytes); `actor_tree_census()` at line 684 returns
  through the globals `CENSUS_PIDS`/`CENSUS_UNKNOWN` with the documented reason at lines 670-682;
  `TERM_GRACE_SECS=5` at line 795 and `KILL_SETTLE_SECS=2` at line 796; the measured handle table is
  at lines 519-532 and states "recursive PPID census … MISSES" for the double-fork orphan;
  `report_teardown()` at line 852 prints its scoped `teardown verified` sentence at line 858;
  `dispatch.test.sh` case 27h is at line 1043. Both probe artifacts exist:
  `runs/probes/escaped-descendants-2026-08-07.sh` and `runs/probe-escaped-descendants-2026-08-07.md`.
  Nothing was edited.
```

### The record — claims 1 to 6

- **Claim (1): audit sessions are real and inherited on this host, but every call that creates or
  changes one is privileged or private.** Observation, not inference: `launchctl print user/501`
  prints `gui asid = 100016` and a `security context = { uid = 501, asid = 100046 }`, and
  `launchctl print gui/501` prints `handle = 100016` with `security context = { uid = 501, asid =
  100016 }`. So ASIDs are live and distinct per login context, which is exactly the granularity the
  UID boundary lacked. The syscalls exist — `sys/syscall.h` lines 390-399 and 468-472:
  `SYS_audit 350`, `SYS_auditon 351`, `SYS_getaudit_addr 357`, `SYS_setaudit_addr 358`,
  `SYS_audit_session_self 428`, `SYS_audit_session_join 429`, `SYS_audit_session_port 432`.
  Inheritance follows the same rules Unit 6 established for credentials: `fork(2)`'s child is an
  exact copy outside an enumerated list that carries no credential, `execve(2)` preserves the process
  credential, and `setsid(2)` changes session and process group only — none of the three is an audit
  identity change, and the only calls that are one are `setaudit_addr(2)` and `audit_session_join(2)`.
  **Privilege — CORRECTED, and now from the kernel source rather than from binary modes.**
  `setaudit_addr(2)` runs `suser(current_cached_proc_cred(p), &p->p_acflag)` and returns that error
  before it reaches `audit_session_setaia()`, so **creating or changing a session requires superuser**
  (XNU, quoted in full in the correction round above). `AU_ASSIGN_ASID -1` in `bsm/audit.h` line 77 is
  the assign-me-a-new-session argument to that same gated call. The header facts still stand and are
  unchanged: `bsm/audit.h` declares `setaudit_addr()` at line 383 and `audit_session_self/join/port()`
  at lines 424-426 **inside `#ifdef __APPLE_API_PRIVATE`** — private API, not a supported public
  interface. The setuid-root callers are still a true observation and are still recorded — `nm -u
  /usr/bin/login` imports `_setaudit_addr`, `_getaudit_addr` and `_auditon`, `nm -u /usr/bin/su`
  imports `_setaudit_addr`, and `ls -l` shows `-r-sr-xr-x root wheel /usr/bin/login` and `-rwsr-xr-x
  root wheel /usr/bin/su` — but they are now **corroboration, not the evidence**. The inference "a call
  that ships behind setuid root in both of its only callers is not an unprivileged call" is
  **withdrawn**: either binary can need root for work unrelated to auditing, so its mode never
  established the syscall's permission rule. **An API symbol is not
  effective availability, and this is where that bites:** the symbols resolve in
  `MacOSX.sdk/usr/lib/libSystem.tbd` (`_audit_session_join`, `_audit_session_port`,
  `_audit_session_self`, `_auditon`, `_getaudit_addr`, `_setaudit_addr` all present), so the route
  *links* while remaining unusable to an unprivileged dispatcher.
- **Claim (2): CORRECTED — no *unprivileged* supervisor on this host can enumerate or query arbitrary
  processes by audit session.** The unqualified form of this heading is withdrawn: root-capable query
  paths do exist and are recorded in this same claim. What the evidence establishes is the scope of the
  gap, not its totality. The absence claim is bounded to five surfaces, each searched in full:
  1. `ps` — the complete `ps -L` keyword list contains no `asid`, no `auid` and no audit keyword at
     all (searched for `asid|auid|audit`, zero matches; the full list is reproduced in the inspection
     failures section's note below).
  2. `pgrep`/`pkill` — the complete usage is `[-F pidfile] [-G gid] [-P ppid] [-U uid] [-g pgrp]
     [-t tty] [-u euid]`. No session selector, and `man 1 pkill`'s option list confirms the same seven.
  3. `sysctl` — `sys/sysctl.h` lines 432-439 give the complete `KERN_PROC_*` selector set:
     `ALL`, `PID`, `PGRP`, `SESSION` (BSD session, not audit), `TTY`, `UID`, `RUID`, `LCID`. The one
     that sounds promising is not available: `sysctl kern.proc.lcid` returns "couldn't find format of
     oid … No such file or directory".
  4. `libproc` — searched `sys/proc_info.h` and `libproc.h` for `asid|audit`: `proc_bsdinfo` carries
     `pbi_uid`, `pbi_gid`, `pbi_ruid`, `pbi_rgid`, `pbi_svuid`, `pbi_svgid`, `pbi_pgid`, `pbi_ppid`
     and no audit field; `libproc.h`'s only audit references are `audit_token_t` helpers
     (`proc_pidpath_audittoken`, `proc_signal_with_audittoken`), which take a token you must already
     hold, not a session you can query.
  5. `launchctl` — `launchctl procinfo` is the one shipped tool that reports a process's ASID, and it
     answered `This subcommand requires root privileges: procinfo`. Measured, not inferred.

  **Root-capable query paths do exist, and the corrected claim says so.** Two of them: shipped
  `launchctl procinfo`, whose refusal above is a privilege refusal and not an absence of capability;
  and `auditon(A_GETPINFO_ADDR)` (`A_GETPINFO_ADDR 28`, `struct auditpinfo_addr { pid_t ap_pid; …;
  au_asid_t ap_asid; }`), which queries **one pid at a time** and is **itself superuser-gated** —
  XNU's "Check appropriate privilege" switch gives it no case of its own, so it falls to
  `default: error = suser(kauth_cred_get(), &p->p_acflag);` (quoted in the correction round above).
  `auditon` is also declared `__AUDIT_API_DEPRECATED`, which `bsm/audit.h` expands to
  `__API_DEPRECATED("audit is deprecated", macos(10.4, 11.0))` — deprecated five major versions ago in
  the header Apple ships today. **One audit query genuinely is unprivileged and still does not help:**
  `A_GETSINFO_ADDR` carries the comment "A_GETSINFO doesn't require priviledge but only superuser gets
  to see the audit masks", but it looks a *session* up by ASID and returns that session's own info — it
  does not enumerate the processes in it. Two further paths close nothing.
  `xpc_connection_get_asid()` (`xpc/connection.h` line 688) "Returns the
  audit session identifier of the remote peer … at the time the connection was made" — it reads a peer
  that voluntarily connected to you, so it is blind to a daemon that closed every descriptor and
  `exec`ed `/bin/sleep`. The `/dev/auditsessions` device is present (`crw-r--r-- root wheel`) and
  `bsm/audit_session.h` documents `au_sdev_open()`, but its all-sessions flag is
  `AU_SDEVF_ALLSESSIONS … /* Allow process to monitor all session. (Requires privilege.) */` — the
  header states the privilege requirement itself — and what it yields is session **lifecycle events**
  (`AUE_SESSION_START/UPDATE/END/CLOSE`), not a process list.
- **Claim (3): the boundary logic is sound and the helper audit comes out in ASID's favour — which is
  why the current-authority exclusion is about privilege, not shed-ability.** The Unit 6 deferral is discharged for
  audit credentials specifically, as the brief bounded it: the complete setuid-root inventory of
  `/usr/bin`, `/usr/sbin`, `/bin`, `/sbin` and `/usr/libexec` is sixteen binaries — `ps`, `at`, `atq`,
  `atrm`, `batch`, `crontab`, `login`, `newgrp`, `quota`, `su`, `sudo`, `top`, `authopen`,
  `security_authtrampoline`, `traceroute`, `traceroute6` — plus three setgid (`write`, `postdrop`,
  `postqueue`). Each was checked with `nm -u` for `_setaudit_addr|_setaudit|_setauid|
  _audit_session_self|_audit_session_join|_audit_session_port|_auditon|_getaudit_addr`. **Exactly two
  match: `login` and `su`.** Both authenticate before they act — `login` needs a password unless given
  `-f`, which itself requires root, and `su` needs the target account's password unless the caller is
  already root — and an actor descendant holds no password. So unlike `newgrp`, which handed Unit 6 a
  free shed of the real GID, there is **no free shed of the audit session** on this host. The
  remaining shed is `audit_session_join(port)`, which needs a send right to another session's port,
  obtained from `audit_session_port(asid, &port)` — private API whose privilege could not be settled
  read-only (recorded as an inspection failure below). **The verdict does not rest on it.**
- **Claim (4): race safety is not the discriminator, and saying it was would be wrong.** The design
  that ASID would need is: enumerate all pids, query each pid's ASID, signal the matches. That is a
  list-then-signal shape with a TOCTOU window in which a pid can exit and be reused. But `pkill -U` is
  **the same shape** — it is a userspace program that reads the process list and then calls `kill()`
  per pid — so this race does not distinguish ASID from the boundary the design already contemplates,
  and Unit 5 rejected `pkill -U` for over-breadth, not for a race. The honest statement is narrower and
  worse for ASID: the query step of that shape **does not exist** for an unprivileged supervisor
  (claim 2), so on this host the sequence cannot be attempted at all, race-safe or otherwise. What
  fails closed correctly is the consequence: with no way to read a process's ASID, every stop would
  set `CENSUS_UNKNOWN`, and `report_teardown()` would correctly refuse to print `teardown verified`
  forever. That is honest, and it is not a mechanism.
- **Claim (5): the `dispatch.sh` mapping stands as a description and supports no probe.** Read-only;
  nothing was edited. A fourth handle would fit `actor_tree_census()`'s existing three-valued contract
  (found / none / `CENSUS_UNKNOWN`, returned through globals for the reason given at lines 670-682),
  would need a fourth global published and cleared for the signal path to reach it, and would widen
  `report_teardown()`'s scoped sentence, which `dispatch.test.sh` case 27h (line 1043) fails on so that
  any such change is deliberate. None of that is reached. The larger structural fact is that every
  existing handle is a shell one-liner over `ps`, `pgrep` or `lsof`, and an ASID handle would be the
  first to require a **compiled C helper linking a private, deprecated API** — with `TERM_GRACE_SECS=5`
  and `KILL_SETTLE_SECS=2` unchanged but a new build dependency in the stop path. **Probe authority and
  production authority stay distinct**, exactly as Unit 6 corrected: operator-attended `sudo -u` exists
  today and is what the runbook's C1 and C6 rows use; an unattended dispatcher running as the actor is
  the unsolved D4 question, and D is not authorized. ASID needs root for creation, which is a *third*
  and larger authority than either.
- **Claim (6): CORRECTED — the verdict is that ASID is unusable under current authority, and that a
  root-bearing design is unassessed rather than excluded.** Not "ready for a probe": no probe runnable
  under current authority could change the two blocking facts, because both are kernel privilege rules
  read from Apple's published source — `setaudit_addr(2)` and `auditon(A_GETPINFO_ADDR)` each gated by
  `suser()`. Not "candidate rejected" as an unqualified verdict, which is withdrawn: what is excluded
  is the *current-authority* route, not the mechanism in every possible authority. Not "operator
  authority required" either — this unit does not request root, does not size what a root-bearing
  design would be, and does not weigh its value and risk against the alternatives; those are Codex's
  assessment and the operator's decision. **What is not rejected** is the dedicated account itself,
  exactly as in Units 5 and 6 — the identity was never exercised. The task's named unknown returns
  **open**.

### False positive, false negative and race, by case

Columns are the two shapes Unit 6 rejected, kept for comparison, plus this unit's candidate.

| Case | Baseline-aware UID census | Per-process recorded set | Per-run audit session (ASID) |
|---|---|---|---|
| (a) service present at baseline | correct exclusion | correct exclusion | correct exclusion — the agent is in the account's own session, not the run's |
| (b) service launched after baseline | **FALSE POSITIVE** — signals an OS service; observed 7 → 9 in ~4 min | correct exclusion | **correct exclusion, and this is ASID's one real advantage** — launchd starts it in the account session, not the run session |
| (c) a baseline pid exits and is reused by an actor descendant | **FALSE NEGATIVE** — the pid is in the baseline, so it is spared | not applicable | not applicable — selection is by attribute, not by pid |
| (c′) a recorded pid exits and is reused by an unrelated process | not applicable | **FALSE POSITIVE** unless owner *and* start time are re-checked | **FALSE POSITIVE possible** — the query-then-signal window is the same one `pkill -U` has, so this is not a discriminator |
| (d) descendant changes session, parent, group, descriptors and executable | reached | **FALSE NEGATIVE** — its pid was never observable | reached in principle — `execve(2)` preserves the credential and `setsid(2)` changes only the BSD session |
| (e) descendant execs a setuid-root helper | not applicable — `newgrp` does not change uid | not applicable — selection is by pid | **correctly excluded** — the only two helpers that touch audit credentials (`login`, `su`) both authenticate first |
| (f) the supervisor tries to read a process's ASID | not applicable | not applicable | **NOT POSSIBLE without root** — `launchctl procinfo` refuses as unprivileged, and `auditon(A_GETPINFO_ADDR)` falls to XNU's `default: suser(...)` gate; no `ps`/`pgrep`/`sysctl`/`libproc` selector exists at all. **Root-capable, unprivileged-impossible.** |
| (g) the supervisor tries to place the actor in a fresh session | not applicable | not applicable | **NOT POSSIBLE without root** — `setaudit_addr(2)` runs `suser(...)` and returns its error before reaching `audit_session_setaia()` |
| enumeration failure | must be `CENSUS_UNKNOWN`, never "empty" | must be `CENSUS_UNKNOWN` | would be `CENSUS_UNKNOWN` on **every** stop, since (f) always fails |

Rows (f) and (g) are the ones that decide it. Rows (b) and (e) are the ones that would have made ASID
the best candidate found so far, had (f) and (g) gone differently.

### Inspection failures, stated rather than read as absence

- **No manual page exists on this host for any audit interface.** `man -w` returned "No manual entry"
  for `auditon`, `getaudit_addr`, `setaudit_addr`, `audit_session_self`, `audit_session_join`,
  `au_open`, `audit_control` and `auditd`. Every privilege statement above therefore rests on shipped
  headers, binary symbol imports and file modes, not on documented contracts. That is weaker evidence
  than a manual and is marked as such.
- **RESOLVED at the correction round: the exact privilege of `auditon(A_GETPINFO_ADDR)` and of
  `audit_session_port()`.** The first result recorded these as unmeasurable read-only. They were not
  measured on this host — that would still need a compiled probe the brief forbids — but they were
  **read from Apple's published XNU source** for the nearest published release, quoted in the
  correction round above. `A_GETPINFO_ADDR` falls to `default: suser(...)`; `audit_session_port()`
  needs `PRIV_AUDIT_SESSION_PORT` for any session but the caller's own. The residual limitation is
  narrower and is stated rather than closed: this is *source* evidence for `xnu-12377.121.6`, not
  *runtime* evidence from `xnu-12377.121.10`, and no behaviour was observed on this machine.
- **The audit subsystem is not configured on this host, and its state was not changed to find out
  more.** `/etc/security` holds `audit_control.example` but **no** `audit_control`; `pgrep -lf auditd`
  exits 1 (not running); `launchctl print system/com.apple.auditd` returns "Could not find service".
  ASIDs plainly still work (claim 1's `launchctl` output proves it), so this is a durability signal
  rather than a blocker — but it means an ASID mechanism would depend on a subsystem this Mac does not
  otherwise run.
- **The `ps -L` keyword list is recorded here in full**, because claim 2's absence rests on it:
  `%cpu %mem acflag acflg args blocked comm command cpu cputime etime f flags gid group inblk inblock
  jobc ktrace ktracep lim login logname lstart majflt minflt msgrcv msgsnd ni nice nivcsw nsignals
  nsigs nswap nvcsw nwchan oublk oublock p_ru paddr pagein pcpu pending pgid pid pmem ppid pri prsna
  pstime putime re rgid rgroup rss ruid ruser sess sig sigmask sl start stat state stime svgid svuid
  tdev time tpgid tsess tsiz tt tty ucomm uid upr user usrpri utime vsize vsz wchan wq wqb wql wqr
  xstat`.
- **`launchctl print user/502` was not retried.** Unit 5's `Operation not permitted` stands, so the
  actor's launchd domain remains un-enumerated and its job sources unresolved.

### How the verdict could have gone the other way

Three places, all checked, all of which went against ASID:

1. **Had `ps` carried an `asid` keyword, or `pgrep`/`pkill` an ASID selector**, the query and the
   signal would both have been shell one-liners the dispatcher already knows how to run, and combined
   with row (b) and row (e) above ASID would have been the strongest candidate in the whole task. The
   full keyword list and the full usage string were read; neither carries one.
2. **Had `launchctl procinfo` worked unprivileged**, an unprivileged per-pid ASID query would have
   existed with no compiled helper at all, and the verdict would have been "candidate ready for an
   authorized live probe" with creation as the only open authority question. It answered "This
   subcommand requires root privileges".
3. **Had `setaudit_addr(2)` carried no `suser()` gate in the kernel source** — and the correction
   round is where this stopped being an inference from `login` and `su` being setuid root — the
   dispatcher could have placed each hop in its own session at launch under current authority, and the
   route would have survived to a probe on the enumeration question alone. The gate is there, in both
   the tagged and the `main` copy.

### Deferrals — carried forward and newly recorded

None is implemented. Items 1-4 are Unit 6's, carried unchanged. Items 5-7 are Unit 4's, carried from
the section removed with the prior result narrative (see the note at the end of this result). Items
8-9 were noticed during the unit and item 10 during the correction round; all three are recorded
rather than pursued, because they sit outside the brief's claims and outside the frozen findings.

1. **The plist count is inconsistent.** Unit 5's result said `/System/Library/LaunchAgents` held 465
   plists; a later bounded count returned 456. It affects no mechanism verdict. Correct it only if a
   later unit needs that inventory.
2. **This state file is long and grows every unit**, against core § 4's "current truth, not a diary".
   This unit replaced the previous result rather than appending and removed two prior-unit narrative
   blocks; the accepted artifacts are untouched. Further reduction is an assessment decision.
3. **No audit exists of the host's setuid-root helpers that can change a process's own credentials.**
   **Partly discharged this unit** for audit credentials specifically: all sixteen setuid-root and
   three setgid binaries in the standard directories were enumerated and symbol-checked, and only
   `login` and `su` touch audit credentials. The general question — every credential class, not just
   audit — remains open.
4. **The uid-502 census fell 9 → 5 → 3 with no signal.** Re-measured this unit and **stable at 3**,
   same three services and the same 10:11:27 start times. Recorded because it was measured; not
   pursued.
5. **Codex has no actor-owned bootstrap.** The Claude bootstrap installs into the actor's own home
   (C1a/C1b), but every Codex command still runs
   `/Applications/ChatGPT.app/Contents/Resources/codex` — a permanent dependency on the operator's
   application bundle. Acceptable for a temporary Stage C probe, not as steady state. D/E territory.
6. **Every actor command in the runbook goes through the operator's `sudo`.** A real dispatcher cannot
   use the operator's sudo credential, so the run-as route for production is still unsolved. It is the
   D4 narrow-privilege question, which is unauthorized.
7. **C3b and C4b spend a little of the actor's own quota.** The only checks in the runbook with an
   external cost. Worth the operator knowing before they run it; not a defect, and not a reason to
   weaken the check back to metadata.
8. **`prsna` (persona) remains a candidate unknown for a later bounded discovery unit.** It is in the
   `ps -L` keyword list and has never been dispositioned, which is why no exhaustion claim is made
   anywhere in this result or in `## Blocker`. What was already observed before this correction:
   `ps -axo prsna=` returns `-` for 547 processes, `99` for one and `1004` for seven, so it is readable
   for arbitrary processes without privilege — the property ASID lacks — while almost nothing carries
   one, `pgrep`/`pkill` have no persona selector, and `SYS_persona` appears in `sys/syscall.h`.
   **Not investigated during this correction round**, as finding 3 requires; nothing above was
   re-measured for it. Whether it becomes a unit is Codex's call.
9. **The `/dev/auditsessions` lifecycle stream was not evaluated as a *verification* aid.**
   `AUE_SESSION_END` means "all the processes in the session have exited", which is exactly the
   assertion a truthful teardown wants — but it needs `AU_SDEVF_ALLSESSIONS`, which the header itself
   marks "(Requires privilege.)", and it verifies rather than terminates. Recorded in case a future
   root-bearing design ever revisits it; it changes nothing under current authority.
10. **Newly noticed in the correction round, and not pursued: nothing in this task pins where a
    primary-source claim about kernel behaviour may come from.** This round read Apple's published XNU
    source over the network because the frozen finding directed it, and the fetched copies live outside
    the repository in session scratch, so the file quotes them rather than vendoring them. Whether
    external primary sources should be cited, cached or excluded is a workflow question for the loop,
    not a Phase 1a mechanism question, so it is recorded and left alone.

### Note on what this unit removed from the file

Following core § 4 and the brief's instruction to replace `## Latest result`, this unit removed the
Unit 6 result narrative and the Unit 4 correction-and-result narrative that stood inside this field.
Their deferrals are carried above, items 1-7, so none has disappeared. **The accepted artifacts below
are untouched** — the command-support table, the runbook, the C5 fixture, C5-T, the static signal
audit, the fail-capability matrix, the three outcomes, the rollback and the operator evidence
template. The removed narrative remains in git at the Unit 4 and Unit 6 commits, so Codex can restore
it at no cost if this reduction was the wrong call.

### Command-support table

| Purpose | Command | Support basis |
|---|---|---|
| create account | `sysadminctl -addUser … -password - -shell /bin/zsh` | local `sysadminctl` usage output, including its "Pass '-' … to request prompt" line |
| delete account | `sysadminctl -deleteUser <name> -keepHome` | local usage output; `-keepHome` is explicit so home handling is never the undocumented default |
| prove non-admin | `dseditgroup -o checkmember -m <name> admin` | run read-only against the operator; returns a yes/no sentence |
| resolve / reverse-resolve uid | `id -u <name>` / `id -un <uid>` | local, run in Unit 3 |
| account absence | `dscl . -read /Users/<name> RecordName` → `eDSRecordNotFound` | local, run in Unit 3 |
| Claude bootstrap | `<operator-claude> install` under the actor's HOME | `claude install [target]` in local `--help`; the operator's own install is per-user under `~/.local/bin` |
| Claude login / status | `claude auth login`, `claude auth status [--json|--text]` | local `claude auth --help`, read this round |
| Claude **effective** auth | `claude -p '<prompt>'` | local `claude --help`: `-p/--print` = "Print response and exit"; `--bare` documents that normal mode reads OAuth/keychain |
| Codex login / status | `codex login`, `codex login status` | local `codex login --help`, read this round |
| Codex **effective** auth | `codex exec --sandbox read-only --skip-git-repo-check -C /tmp '<prompt>'` | local `codex exec --help`, read this round |
| GUI session detection | `stat -f '%Su' /dev/console`, `who`, `pgrep -U <uid>` | all run read-only in Unit 3 |
| select / signal by uid | `pgrep -U <uid>`, `pkill -TERM\|-KILL -U <uid>` | `pkill.1` DESCRIPTION; pattern-free selector measured in Unit 2 via `-g` |
| read-only Git status | `git -c safe.directory=<path> --no-optional-locks -C <path> status --porcelain` | run read-only this round, exit 0 |

**One caution carried forward:** `pkill.1`'s SYNOPSIS prints `pattern ...` outside the optional
brackets while its own DESCRIPTION says "If any `pattern` operands are specified". The measurement in
Unit 2 settles it in favour of the DESCRIPTION. C5 is the check that confirms it for `-U`.

### The runbook

Account name for this checkout: **`wlactor-airesources`**, used literally in every command below.
Checkout: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`.

**Password handling, before anything else.** No command below contains a password literal.
`sudo` prompts for the administrator password itself and never places it in `argv`. Account creation
passes `-password -`, which the local usage output documents as the request-a-prompt form. Never paste
a password into a command, this file, or the evidence you bring back.

**If preflight finds a collision, stop.** Do not invent a second account name. A different name would
invalidate every check below and has not been preflighted. Report the collision and hand back.

| # | Command | Kind | Pass | Fail → stop |
|---|---|---|---|---|
| P1 | `id -u wlactor-airesources` | `[READ-ONLY]` | "no such user" | any uid printed → **STOP**, name collision, hand back |
| P2 | `ls -ld /Users/wlactor-airesources` | `[READ-ONLY]` | "No such file or directory" | path exists → **STOP**, do not reuse it |
| P3 | `dscl . -read /Users/wlactor-airesources RecordName` | `[READ-ONLY]` | `eDSRecordNotFound` | a record exists → **STOP** |
| P4 | `stat -f '%Su' /dev/console` | `[READ-ONLY]` | `patrik.lindeberg` | anything else → an unexpected GUI session owns the console |
| **B1** | `sudo sysadminctl -addUser wlactor-airesources -fullName "Work Loop Actor (ai-resources)" -shell /bin/zsh -password -` | `[ADMIN]` | prompts for the new account's password, then creates it | no prompt, or any error → stop; nothing else has changed |
| B2 | `id -u wlactor-airesources` | `[READ-ONLY]` | a uid ≥ 500 | non-numeric or < 500 → stop and roll back |
| B3 | `dseditgroup -o checkmember -m wlactor-airesources admin` | `[READ-ONLY]` | "no … is not a member" | "yes" → **stop and roll back**, the account is an admin |
| B4 | `pgrep -U $(id -u wlactor-airesources); echo $?` | `[READ-ONLY]` | exit `1` | exit `0` → the UID is occupied; exit ≥2 → cannot look, stop |
| **C1a** | `sudo -u wlactor-airesources -H /Users/patrik.lindeberg/.local/bin/claude install` | `[ATTENDED]` | completes | error → stop, roll back |
| C1b | `ls -l /Users/wlactor-airesources/.local/bin/claude` | `[READ-ONLY]` | exists | missing → the bootstrap did not install into the actor's home; stop |
| C1c | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth login` | `[ATTENDED]` | login completes | if it needs a browser it cannot reach, log into the actor's desktop session and do C1c/C2 there |
| C2 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex login` | `[ATTENDED]` | login completes | error → stop, roll back |
| **G** | **If you used the actor's desktop session: log fully out of it. Not fast user switching — log out.** | `[ATTENDED]` | — | — |
| G1 | `stat -f '%Su' /dev/console` | `[READ-ONLY]` | **not** the actor | actor owns the console → C3 would pass for the wrong reason; log out and repeat |
| G2 | `who` | `[READ-ONLY]` | no actor row | actor row present → same, log out |
| G3 | `pgrep -U $(id -u wlactor-airesources); echo $?` | `[READ-ONLY]` | exit `1` | exit `0` → a session survives; exit ≥2 → cannot look, stop |
| C3a | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth status --json` | `[READ-ONLY]` | JSON with `"loggedIn": true` | anything else → stop and roll back |
| **C3b** | `cd /tmp && sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude -p 'Reply with exactly one word: alive'` | `[READ-ONLY]` | the reply text `alive`, exit 0 | any auth/keychain error, empty output or non-zero exit → **STOP AND ROLL BACK.** This, not C3a, is the decisive check |
| C4a | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex login status` | `[READ-ONLY]` | `Logged in using ChatGPT` | anything else → stop, preserve output, offer rollback |
| **C4b** | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex exec --sandbox read-only --skip-git-repo-check -C /tmp 'Reply with exactly one word: alive'` | `[READ-ONLY]` | a completed run whose reply is `alive`, exit 0 | auth error or non-zero exit → stop, preserve output, offer rollback |
| **C5** | **the C5-T block below** — it materializes, verifies and runs the fixture; do not copy the fixture by hand | `[SIGNAL]` | `C5 exit status: 0`, with the fixture's own `C5 PASS` line above it | any `C5-T STOP` → nothing ran; any other exit status → stop, preserve output, offer rollback |
| C6a | `sudo -u wlactor-airesources -H git --no-optional-locks -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" status --porcelain; echo $?` | `[READ-ONLY]` | a **non-zero** exit naming "dubious ownership" — this is the expected refusal | exit 0 → the ownership boundary is not what the design assumes; record it and continue to C6b |
| C6b | `sudo -u wlactor-airesources -H git -c safe.directory="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" --no-optional-locks -C "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources" status --porcelain; echo $?` | `[READ-ONLY]` | exits 0 and prints a status | "dubious ownership" persists → `safe.directory` is not the fix; permission denied → traversal is blocked; either way stop |

**Why C3b and C4b exist.** C3a and C4a read stored metadata. `claude auth status` has no
verify-the-credential mode (`--help`: only `--json` and `--text`), and `codex login status` reads
`~/.codex/auth.json`. A credential can be recorded and still be unusable once the actor's GUI session
is gone — `claude --help` documents `--bare` as the mode where "OAuth and keychain are never read",
which is the local evidence that normal mode depends on a keychain read. C3b and C4b are round-trips:
they fail if the credential cannot be unlocked and used. **Do not pass `--bare`** to C3b; it would
bypass the exact credential path under test. Both run with cwd `/tmp` and no repository, C4b under
`--sandbox read-only`, so neither can touch the checkout. Both consume a small amount of the actor's
own quota; that is the cost of an effective check and it is stated rather than hidden.

**Why C6 no longer writes anything.** `git -c safe.directory=…` supplies the setting for one
invocation, and it was verified read-only this round (exit 0). Persisting it with `git config
--global`, and configuring a commit identity at all, belong to D2/D5 and are not authorized here.
C6's authorized claim is exactly: traversal, repository recognition, and that `safe.directory` is the
setting the boundary needs.

**The runbook ends at C6b.** There is no hide step and no retain step. D and E remain forbidden.

### C5 — the fixture, inline and syntax-checked

Run as the operator (uid 501), attended. It creates **three** actor-owned processes — matching Unit
2's accepted later check — plus one uid-501 bystander whose working directory is the checkout.
`bash -n` returned exit 0 on a temporary copy of exactly this content; the copy was removed and no
part of it was executed in this unit.

The two marker lines around the fence are the transport's boundary (see **C5-T** below). They are
markdown comments outside the fence, so the fixture's bytes are unchanged by them.

<!-- C5-FIXTURE-BEGIN -->
```bash
#!/bin/bash
# C5 — actor-UID termination boundary probe.
# RUN AS THE OPERATOR (uid 501), attended. Creates THREE actor-owned processes —
# an ordinary child, a setsid child, and a fully detached daemon — plus ONE
# uid-501 bystander whose cwd is the checkout. It proves the boundary before
# signalling it, then runs the exact TERM/grace/KILL/census sequence.
#
# The three-process fixture is Unit 2's accepted later check, not a reduction of it.
# It signals a UID only after five identity guards, one empty-boundary guard,
# per-process shape assertions and one exact-census guard have passed.
set -u

ACTOR_NAME="${1:?usage: c5.sh <actor-account-name> <checkout-path>}"
CHECKOUT="${2:?usage: c5.sh <actor-account-name> <checkout-path>}"
GRACE=3
LIFE=600

A=""; B=""; D=""; BYSTANDER=""
ACTOR_UID=""

say() { printf '%s\n' "$*"; }
refuse() { say "REFUSE: $*"; exit 2; }

# Kill one recorded actor pid, but ONLY if it still belongs to the actor.
# Guards against pid reuse handing us someone else's process.
kill_actor_pid() {
  local p="$1" owner
  [ -n "$p" ] || return 0
  owner="$(ps -o uid= -p "$p" 2>/dev/null | tr -d ' ')"
  [ "$owner" = "${ACTOR_UID:-x}" ] || return 0
  sudo -u "$ACTOR_NAME" /bin/kill -KILL "$p" 2>/dev/null
  return 0
}

cleanup() {
  [ -n "$BYSTANDER" ] && kill "$BYSTANDER" 2>/dev/null
  kill_actor_pid "$D"
  kill_actor_pid "$B"
  kill_actor_pid "$A"
  return 0
}
trap cleanup EXIT
trap 'say "INTERRUPTED — cleaning up, and this is NOT a pass"; exit 2' INT TERM

OP_UID="$(id -u)"
OP_PGID="$(ps -o pgid= -p $$ 2>/dev/null | tr -d ' ')"

# Refresh the sudo credential once, attended, so the launcher below cannot
# stall on a hidden password prompt.
sudo -v || refuse "sudo credential could not be refreshed"

# ---------------------------------------------------------------- guard 1: uid
ACTOR_UID="$(id -u "$ACTOR_NAME" 2>/dev/null)"
case "${ACTOR_UID:-}" in
  ''|*[!0-9]*) refuse "'$ACTOR_NAME' does not resolve to a numeric uid" ;;
esac
[ "$ACTOR_UID" -ne 0 ]         || refuse "target uid is root"
[ "$ACTOR_UID" -ne "$OP_UID" ] || refuse "target uid is the caller"
[ "$ACTOR_UID" -ge 500 ]       || refuse "uid $ACTOR_UID is a system uid"
BACK="$(id -un "$ACTOR_UID" 2>/dev/null)"
[ "${BACK:-}" = "$ACTOR_NAME" ] || refuse "uid $ACTOR_UID maps to '${BACK:-<none>}', not '$ACTOR_NAME'"
say "guard 1 OK: $ACTOR_NAME = uid $ACTOR_UID, not root, not caller, >= 500, maps back"

# ------------------------------------------------- guard 2: boundary is empty
PRE="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; PRE_RC=$?
case "$PRE_RC" in
  1) say "guard 2 OK: actor boundary is empty (pgrep exit 1)" ;;
  0) say "actor uid already has processes:"; say "$PRE"
     refuse "this probe never cleans up a boundary it did not create" ;;
  *) refuse "pgrep exit $PRE_RC — cannot prove the boundary is empty, so nothing is signalled" ;;
esac

# ------------------------------------------------------------------- fixture
# One launcher, run as the actor, spawns all three and exits. A and B send their
# descriptors to /dev/null so they do not hold this command substitution open;
# the daemon reports its pid and then closes every descriptor itself.
# The escape shape is reused verbatim from
# runs/probes/escaped-descendants-2026-08-07.sh lines 107-116.
PIDS="$(sudo -u "$ACTOR_NAME" -H /bin/bash -c '
set -u
/bin/sleep '"$LIFE"' >/dev/null 2>&1 </dev/null &
A=$!
/usr/bin/python3 -c "
import os
os.setsid()
os.execv(\"/bin/sleep\", [\"sleep\", \"'"$LIFE"'\"])
" >/dev/null 2>&1 </dev/null &
B=$!
D=$(/usr/bin/python3 -c "
import os, sys
if os.fork() > 0: os._exit(0)
os.setsid()
if os.fork() > 0: os._exit(0)
# the pid is written BEFORE the descriptors go, because writing it needs one
sys.stdout.write(str(os.getpid()) + \"\n\"); sys.stdout.flush()
os.closerange(0, 1024)
os.execv(\"/bin/sleep\", [\"sleep\", \"'"$LIFE"'\"])
" 2>/dev/null </dev/null)
printf "%s %s %s\n" "$A" "$B" "$D"
')"

set -- $PIDS
A="${1:-}"; B="${2:-}"; D="${3:-}"
for v in "$A" "$B" "$D"; do
  case "${v:-}" in ''|*[!0-9]*) refuse "fixture did not report three numeric pids: [$PIDS]" ;; esac
done

( cd "$CHECKOUT" && exec /bin/sleep "$LIFE" ) &
BYSTANDER=$!
sleep 1

# ------------------------------------- guard 3: the fixture is what we think
shape() { ps -o "$1=" -p "$2" 2>/dev/null | tr -d ' '; }

A_UID="$(shape uid "$A")";  A_PGID="$(shape pgid "$A")"
B_UID="$(shape uid "$B")";  B_PGID="$(shape pgid "$B")"
D_UID="$(shape uid "$D")";  D_PGID="$(shape pgid "$D")";  D_PPID="$(shape ppid "$D")"
say "operator  pgid=$OP_PGID uid=$OP_UID"
say "A ordinary  pid=$A uid=$A_UID pgid=$A_PGID"
say "B setsid    pid=$B uid=$B_UID pgid=$B_PGID"
say "D daemon    pid=$D uid=$D_UID pgid=$D_PGID ppid=$D_PPID"
say "bystander   pid=$BYSTANDER uid=$OP_UID cwd=<checkout>"

[ "$A_UID" = "$ACTOR_UID" ] || refuse "A uid $A_UID is not the actor uid"
[ "$B_UID" = "$ACTOR_UID" ] || refuse "B uid $B_UID is not the actor uid"
[ "$D_UID" = "$ACTOR_UID" ] || refuse "D uid $D_UID is not the actor uid"

# B took setsid, so it leads its own group. This is the measured shape
# (probe-escaped-descendants-2026-08-07.md: pid 60081, pgid 60081).
[ "$B_PGID" = "$B" ] || refuse "B pgid $B_PGID != $B — setsid did not take"

# D is the fully detached daemon. The measured shape is pid 60086 in pgid 60085:
# after setsid and the SECOND fork it inherits the intermediate child's group
# rather than leading one, so D_PGID == D is the WRONG assertion. What must hold
# is separation: D is outside the operator's group and outside the launcher's
# group, so neither `kill -- -PGID` handle can reach it, and its ancestry is gone.
[ "$D_PPID" = "1" ] || refuse "D ppid $D_PPID != 1 — the double fork did not orphan it"
case "${D_PGID:-}" in ''|*[!0-9]*) refuse "D pgid is not readable" ;; esac
[ "$D_PGID" != "$OP_PGID" ] || refuse "D shares the operator's process group $OP_PGID — it did not escape"
[ "$D_PGID" != "$A_PGID" ]  || refuse "D shares the launcher's process group $A_PGID — it did not escape"
if [ "$D_PGID" = "$D" ]; then
  say "note: D leads its own group ($D_PGID). The measured shape has it inheriting the"
  say "      intermediate child's group instead. Either satisfies the separation the test needs."
fi
say "guard 3a OK: D is orphaned (ppid 1) and its group $D_PGID is neither $OP_PGID nor $A_PGID"

# Descriptor assertion. Two lsof calls, because an empty result from ONE call
# cannot tell "holds no inherited descriptors" apart from "could not look".
SEEN="$(sudo -u "$ACTOR_NAME" /usr/sbin/lsof -p "$D" 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')"
case "${SEEN:-0}" in
  ''|0) refuse "lsof returned nothing at all for pid $D — descriptors cannot be inspected, so this is not a pass" ;;
esac
FDS="$(sudo -u "$ACTOR_NAME" /usr/sbin/lsof -p "$D" -a -d 0-1024 2>/dev/null | tail -n +2 | wc -l | tr -d ' ')"
case "${FDS:-}" in ''|*[!0-9]*) refuse "descriptor count for pid $D is not readable" ;; esac
[ "$FDS" -eq 0 ] || refuse "D still holds $FDS inherited descriptors (0-1024) — not the fully detached shape"
say "guard 3b OK: lsof sees $SEEN rows for D and 0 of them are inherited descriptors 0-1024"

# ------------------------------- guard 4: census matches the expected set EXACTLY
CENSUS="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; C_RC=$?
[ "$C_RC" -eq 0 ] || refuse "census exit $C_RC before signalling"
ACTUAL="$(printf '%s\n' $CENSUS | sort -n | tr '\n' ' ')"
EXPECT="$(printf '%s\n' "$A" "$B" "$D" | sort -n | tr '\n' ' ')"
[ "$ACTUAL" = "$EXPECT" ] || refuse "actor boundary holds [$ACTUAL]; expected exactly [$EXPECT]"
say "guard 4 OK: boundary holds exactly the three fixture processes [$EXPECT]"

# ------------------------------------------------ the sequence under test
say "--- TERM ---"
sudo -u "$ACTOR_NAME" /usr/bin/pkill -TERM -U "$ACTOR_UID"; T_RC=$?
say "pkill -TERM -U $ACTOR_UID exit=$T_RC   (0 signalled | 1 none | >=2 ERROR)"
[ "$T_RC" -ge 2 ] && { say "STOP: pkill error, boundary state unknown"; exit 2; }
sleep "$GRACE"

MID="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; M_RC=$?
say "after grace: pgrep exit=$M_RC survivors=[$(printf '%s' "$MID" | tr '\n' ' ')]"
if [ "$M_RC" -eq 0 ]; then
  say "--- KILL ---"
  sudo -u "$ACTOR_NAME" /usr/bin/pkill -KILL -U "$ACTOR_UID"; K_RC=$?
  say "pkill -KILL -U $ACTOR_UID exit=$K_RC"
  [ "$K_RC" -ge 2 ] && { say "STOP: pkill error, boundary state unknown"; exit 2; }
  sleep 1
elif [ "$M_RC" -ge 2 ]; then
  say "STOP: census error after TERM — cannot tell, so this is NOT a pass"; exit 2
fi

# -------------------------------------------------------------- the verdict
FINAL="$(pgrep -U "$ACTOR_UID" 2>/dev/null)"; F_RC=$?
say "--- RESULT ---"
say "final census exit=$F_RC   (1 = boundary empty | 0 = survivors | >=2 = could not look)"
ps -p "$A" >/dev/null 2>&1 && A_STATE=ALIVE || A_STATE=GONE
ps -p "$B" >/dev/null 2>&1 && B_STATE=ALIVE || B_STATE=GONE
ps -p "$D" >/dev/null 2>&1 && D_STATE=ALIVE || D_STATE=GONE
ps -p "$BYSTANDER" >/dev/null 2>&1 && Y_STATE=ALIVE || Y_STATE=GONE
say "A ordinary child : $A_STATE   (must be GONE)"
say "B setsid child   : $B_STATE   (must be GONE)"
say "D detached daemon: $D_STATE   (must be GONE)"
say "uid-501 bystander: $Y_STATE   (must be ALIVE)"

RC=1
if [ "$F_RC" -eq 1 ] \
   && [ "$A_STATE" = GONE ] && [ "$B_STATE" = GONE ] && [ "$D_STATE" = GONE ] \
   && [ "$Y_STATE" = ALIVE ]; then
  say "C5 PASS — the actor UID boundary terminated all three actor-owned processes,"
  say "          including a fully detached descendant, and did not overreach"
  RC=0
elif [ "$F_RC" -ge 2 ]; then
  say "C5 FAIL-CLOSED — the census could not run; an inability to look is not a clean boundary"
else
  say "C5 FAIL — A=$A_STATE B=$B_STATE D=$D_STATE bystander=$Y_STATE final-census-exit=$F_RC"
fi
exit "$RC"
```
<!-- C5-FIXTURE-END -->

**One property stated rather than hidden.** The launcher exits after spawning, so A and B are
re-parented to pid 1 alongside D. That makes the fixture *harder*, not weaker: no live parent links
any of the three to the caller, so a UID sweep is the only handle left. Their shapes are still
distinguished and asserted separately — A ordinary, B its own session/group leader, D fully detached.

### C5-T — how the operator actually runs C5

The fixture above is the accepted text, not a file. **C5-T is the only way it should be run.** Copy
this one block and paste it into a terminal at step C5. It reads the accepted bytes out of this state
file, proves they are the accepted bytes, runs the fixture once, and removes the script afterwards.
Nothing is written into the repository, and the operator never copies, edits or fills in the fixture.

Three design points, each forced by something measured rather than assumed:

- **The bytes come from this file, between the two marker lines around the fence.** The markers are
  markdown comments outside the fence, so the accepted fixture is unchanged by them. The block below
  mentions the markers in variable assignments; matching is **whole-line and fixed-string**, so those
  mentions can never be mistaken for the markers themselves.
- **The exit status is carried in a file, not through the pipeline.** `tee` keeps the run visible, but
  a pipeline's status is `tee`'s, and `$PIPESTATUS` is a bash array that zsh does not provide under
  that name — the operator's login shell is zsh. The status file works in both.
- **An exit code alone is not trusted.** Measured during this unit: a fixture stub interrupted
  mid-run exited 0 without ever printing a verdict, and an earlier draft of this block reported that
  as a pass. A `0` is now accepted only when the fixture's own `C5 PASS` line is present in the
  captured output.

```bash
# C5-T — materialize, verify and run the accepted C5 fixture. Run as the operator, attended.
# It reads the accepted bytes out of this state file, proves they are the accepted bytes,
# then runs the fixture once. No repository file is written and no fixture script survives.
set -u

STATE="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/work-loop/work-loop-v2-phase1a-full-descendant-termination.md"
ACTOR="wlactor-airesources"
CHECKOUT="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"
OPERATOR="patrik.lindeberg"
WANT_LINES=210
WANT_SHA="65b50d193054e6060fda6de866119d98898d8df04889e96b83802430b077a8f9"
BEGIN_MARK='<!-- C5-FIXTURE-BEGIN -->'
END_MARK='<!-- C5-FIXTURE-END -->'

TMPD=""
t_say()  { printf '%s\n' "$*"; }
t_stop() { printf 'C5-T STOP: %s\n' "$*"; exit 2; }

# One rule for removing a C5-T directory. It considers exactly one path and never
# expands a glob, so it cannot reach a second directory. Four conditions: the path
# is non-empty, it has the exact generated name shape, it is a real directory and
# not a symlink, and its parent resolves to the temp root itself. The recovery
# block further below repeats this rule verbatim for manual use.
t_rmdir() {
  t_d="$1"
  [ -n "$t_d" ] || { printf 'C5-T: refusing — no path given\n'; return 2; }
  case "$t_d" in
    */wl-c5.????????) ;;
    *) printf 'C5-T: refusing — [%s] is not a C5-T directory name\n' "$t_d"; return 2 ;;
  esac
  [ -d "$t_d" ] && [ ! -L "$t_d" ] || { printf 'C5-T: refusing — [%s] is not a directory\n' "$t_d"; return 2; }
  t_root="$(cd "${TMPDIR:-/tmp}" 2>/dev/null && pwd -P)" || { printf 'C5-T: refusing — cannot resolve the temp root\n'; return 2; }
  t_par="$(cd "$(dirname "$t_d")" 2>/dev/null && pwd -P)" || { printf 'C5-T: refusing — cannot resolve the parent of [%s]\n' "$t_d"; return 2; }
  [ "$t_par" = "$t_root" ] || { printf 'C5-T: refusing — [%s] resolves outside the temp root [%s]\n' "$t_d" "$t_root"; return 2; }
  rm -rf "$t_par/$(basename "$t_d")"
  return 0
}

t_clean() {
  [ -n "$TMPD" ] || return 0
  t_rmdir "$TMPD" || printf 'C5-T: the temporary directory was left in place — see the refusal above\n'
  return 0
}
trap t_clean EXIT
trap 't_say "C5-T INTERRUPTED — cleaning up; this is NOT a pass"; exit 2' INT TERM

# --- guard 1: the caller must be the operator, not root and not the actor
[ "$(id -u)" -ne 0 ] || t_stop "running as root; run this as the operator"
CALLER="$(id -un)"
[ "$CALLER" = "$OPERATOR" ] || t_stop "caller is '$CALLER', not the operator '$OPERATOR'"

# --- guard 2: the source of the bytes must be readable
[ -f "$STATE" ] && [ -r "$STATE" ] || t_stop "cannot read the state file at $STATE"

# --- guard 3: exactly one marker pair, in order.
# Whole-line fixed-string matching, so the lines of THIS block that mention the
# markers are never mistaken for the markers themselves.
NB="$(grep -c -x -F -- "$BEGIN_MARK" "$STATE")"
NE="$(grep -c -x -F -- "$END_MARK" "$STATE")"
[ "$NB" -eq 1 ] || t_stop "found $NB begin markers, expected exactly 1"
[ "$NE" -eq 1 ] || t_stop "found $NE end markers, expected exactly 1"
LB="$(grep -n -x -F -- "$BEGIN_MARK" "$STATE" | cut -d: -f1)"
LE="$(grep -n -x -F -- "$END_MARK" "$STATE" | cut -d: -f1)"
[ "$LB" -lt "$LE" ] || t_stop "end marker (line $LE) is not after the begin marker (line $LB)"

# --- guard 4: a private temporary location, never a fixed path
TMPD="$(mktemp -d "${TMPDIR:-/tmp}/wl-c5.XXXXXXXX")" || t_stop "could not create a temporary directory"
chmod 700 "$TMPD"
SCRIPT="$TMPD/c5.sh"
# Printed BEFORE the fixture launches. This exact path is the only thing the
# recovery block below will ever accept, so note it now.
t_say "C5-T: temporary directory: $TMPD"

# --- extract the fixture. buf[1] is the opening fence and buf[n] the closing one,
# so printing 2..n-1 yields the fixture and nothing else. No backtick matching is
# needed, and guard 5 catches any off-by-one before the fixture can run.
awk -v b="$BEGIN_MARK" -v e="$END_MARK" '
  $0 == e { inb = 0 }
  inb     { n++; buf[n] = $0 }
  $0 == b { inb = 1 }
  END     { for (i = 2; i < n; i++) print buf[i] }
' "$STATE" > "$SCRIPT" || t_stop "extraction failed"

# --- guard 5: integrity — the accepted bytes, nothing else
GOT_LINES="$(wc -l < "$SCRIPT" | tr -d ' ')"
[ "$GOT_LINES" = "$WANT_LINES" ] || t_stop "extracted $GOT_LINES lines, expected $WANT_LINES"
GOT_SHA="$(shasum -a 256 "$SCRIPT" | awk '{print $1}')"
[ "$GOT_SHA" = "$WANT_SHA" ] || t_stop "checksum mismatch; expected $WANT_SHA, got $GOT_SHA — the fixture in the state file is not the accepted one, so nothing is run"

# --- guard 6: syntax, before anything can signal
bash -n "$SCRIPT" || t_stop "bash -n failed on the extracted fixture"
t_say "C5-T OK: $GOT_LINES lines, sha256 $GOT_SHA, syntax clean"
t_say "C5-T: running the fixture as $CALLER against actor '$ACTOR'"

# --- run it once. The exit status is carried in a file, not through the pipeline,
# because a pipeline's status is the last command's and $PIPESTATUS is not portable
# between bash and zsh. tee keeps the run visible while it happens.
# The file is pre-seeded with "unfinished", so a run that never reaches the second
# command in the group cannot leave a stale or absent status behind.
OUT="$(mktemp "${TMPDIR:-/tmp}/wl-c5-output.XXXXXXXX")" || t_stop "could not create the output file"
echo unfinished > "$TMPD/rc"
{ bash "$SCRIPT" "$ACTOR" "$CHECKOUT"; echo $? > "$TMPD/rc"; } 2>&1 | tee "$OUT"
C5_RC="$(cat "$TMPD/rc" 2>/dev/null)"
case "${C5_RC:-}" in
  ''|*[!0-9]*) t_stop "the fixture did not record an exit status ('${C5_RC:-<none>}') — the run did not finish, so this is NOT a pass" ;;
esac

# An exit status alone is not enough. An interrupted run can end 0 without the
# fixture ever reaching its verdict, so a pass must also be corroborated by the
# fixture's own PASS line. Measured: a stub killed mid-run exited 0 and printed
# no verdict; without this check the transport reported that as a pass.
if [ "$C5_RC" -eq 0 ] && ! grep -q -F 'C5 PASS' "$OUT"; then
  t_stop "the fixture exited 0 but never printed its 'C5 PASS' verdict — the run was cut short, so this is NOT a pass"
fi
t_say "---"
t_say "C5 exit status: $C5_RC   (0 PASS | 1 FAIL | >=2 REFUSED or ERROR)"
t_say "stdout for the evidence template: $OUT"
t_say "the fixture script is removed on exit; the output file above is kept"
exit "$C5_RC"
```

**What C5-T writes, and what it removes.** It creates one private `mktemp -d` directory (mode 700,
never a fixed path) holding the extracted fixture and its status file, and one output file outside
that directory. The directory and the fixture script are removed on success, on failure and on a
handled interrupt. The **output file is deliberately kept** — it is the evidence the template asks
for, and it contains no secrets.

**One accepted limitation, and its exact recovery.** If the C5-T shell itself is `SIGKILL`ed, no trap
can run — `SIGKILL` cannot be trapped by anything — and the temporary directory survives. Measured:
the leftover holds only `c5.sh`, the same public bytes as this file, checksum `65b50d19…`, plus a
short status file. Nothing secret is in it.

**Recover it by exact path, never by wildcard.** C5-T prints `C5-T: temporary directory: …` before
the fixture launches; that line is the recovery target. Paste it into `LEFTOVER` below and run the
block. A wildcard would be wrong here: two C5-T runs can leave two directories side by side, and a
glob selects both — measured this round, `"${TMPDIR:-/tmp}"/wl-c5.*` expanded to **2** paths against
two plausible generated directories. This block expands no glob and considers exactly one path.

```bash
# C5-T-RECOVER — remove ONE leftover C5-T directory, by its exact path.
# Only needed after a SIGKILL. It refuses an empty, malformed, non-directory,
# symlinked or outside-the-temp-root target, and it never expands a wildcard.
# Set DRY=1 first to see what it would remove without removing anything.
LEFTOVER=''   # <- paste the exact path C5-T printed, between the quotes
DRY="${DRY:-0}"

r_rmdir() {
  r_d="$1"
  [ -n "$r_d" ] || { printf 'RECOVER: refusing — no path given\n'; return 2; }
  case "$r_d" in
    */wl-c5.????????) ;;
    *) printf 'RECOVER: refusing — [%s] is not a C5-T directory name\n' "$r_d"; return 2 ;;
  esac
  [ -d "$r_d" ] && [ ! -L "$r_d" ] || { printf 'RECOVER: refusing — [%s] is not a directory\n' "$r_d"; return 2; }
  r_root="$(cd "${TMPDIR:-/tmp}" 2>/dev/null && pwd -P)" || { printf 'RECOVER: refusing — cannot resolve the temp root\n'; return 2; }
  r_par="$(cd "$(dirname "$r_d")" 2>/dev/null && pwd -P)" || { printf 'RECOVER: refusing — cannot resolve the parent of [%s]\n' "$r_d"; return 2; }
  [ "$r_par" = "$r_root" ] || { printf 'RECOVER: refusing — [%s] resolves outside the temp root [%s]\n' "$r_d" "$r_root"; return 2; }
  r_target="$r_par/$(basename "$r_d")"
  if [ "$DRY" = "1" ]; then
    printf 'RECOVER (dry run): would remove exactly one directory: %s\n' "$r_target"
    return 0
  fi
  printf 'RECOVER: removing exactly one directory: %s\n' "$r_target"
  rm -rf "$r_target"
  [ -e "$r_target" ] && { printf 'RECOVER: %s is still present\n' "$r_target"; return 2; }
  printf 'RECOVER: removed\n'
  return 0
}

r_rmdir "$LEFTOVER"
```

The same four conditions govern C5-T's own automatic cleanup, so the automatic and manual paths
cannot disagree about what is removable. The automatic cleanup is unchanged in strength — its name
test is now stricter (`wl-c5.` plus exactly the eight characters `mktemp` generates, rather than six
or more) and it gained the containment check.

### Static signal audit

Every signalling call in the corrected fixture, and what bounds its target. There are four, and no
fifth: `grep -nE '\bkill\b|\bpkill\b'` over the exact content above returns nine lines, of which five
are comments or `say` strings and four are invocations.

| Site | Call | What proves the target is safe |
|---|---|---|
| `kill_actor_pid` | `sudo -u <actor> /bin/kill -KILL "$p"` | `$p` is a pid this script recorded, **and** `ps -o uid=` must still show it owned by `$ACTOR_UID` — the pid-reuse guard |
| `cleanup` | `kill "$BYSTANDER"` | `$BYSTANDER` is this script's own child, owned by uid 501, signalled by its own owner |
| TERM | `sudo -u <actor> pkill -TERM -U "$ACTOR_UID"` | guards 1–4: numeric uid, not root, not the caller, ≥ 500, reverse-maps to the intended name; the boundary was empty before the fixture; every fixture member's uid, shape and descriptors were asserted; and the census equals exactly `[A B D]` |
| KILL | `sudo -u <actor> pkill -KILL -U "$ACTOR_UID"` | the same guards; only reached when TERM left survivors **and** the census could be read |

Because both `pkill` calls run **as the actor**, `man 2 kill`'s EPERM rule makes signalling uid 501 or
root impossible regardless of what the guards did. The guards protect against the actor's *own*
unexpected processes; the kernel protects everyone else.

### Fail-capability matrix

Every row is a way this runbook can return "no". None of them continues setup.

| # | Failure | Detected by | Result |
|---|---|---|---|
| 1 | existing-name collision | P1–P3 | stop before B1; nothing created; **no second name is invented** |
| 2 | `-password -` does not prompt | B1 | stop; the account is not created blind |
| 3 | malformed / non-numeric uid | C5 guard 1 | refuse, exit 2 |
| 4 | uid is root | C5 guard 1 | refuse, exit 2 |
| 5 | uid is the operator | C5 guard 1 | refuse, exit 2 |
| 6 | uid no longer maps to the intended account | C5 guard 1 reverse-map | refuse, exit 2 |
| 7 | actor UID already occupied | B4 and C5 guard 2 | refuse; never treated as cleanup permission |
| 8 | account was created as an admin | B3 | stop and roll back |
| 9 | Claude bootstrap did not install into the actor's home | C1b | stop and roll back |
| 10 | incomplete GUI logout | G1, G2, G3 | stop; C3 would otherwise pass for the wrong reason |
| 11 | credential recorded but **not usable** without the GUI | **C3b** (C3a alone cannot see this) | **stop and roll back** — the decisive failure |
| 12 | Codex credential recorded but not usable | **C4b** | stop, preserve output, offer rollback |
| 13 | C5 daemon has not actually escaped (ppid ≠ 1, shares a group, still holds descriptors) | C5 guard 3a / 3b | refuse, exit 2 — the probe never signals a fixture it could not verify |
| 14 | C5 descriptors cannot be inspected at all | C5 guard 3b first `lsof` | refuse, exit 2 — inability to look is not a pass |
| 15 | C5 boundary holds anything other than exactly A, B, D | C5 guard 4 | refuse, exit 2 |
| 16 | any of the three actor processes survives | final census / `ps -p` | `C5 FAIL` |
| 17 | C5 bystander dies | `ps -p $BYSTANDER` | `C5 FAIL` — overreach |
| 18 | `pgrep`/`pkill` exit ≥ 2 | every census site | `C5 FAIL-CLOSED` |
| 19 | C5 interrupted mid-run | `INT`/`TERM` trap | cleans up and exits 2 — never resumes the signal sequence |
| 20 | the ownership boundary is not real | C6a exits 0 instead of refusing | recorded; the design assumption is wrong and Codex must know |
| 21 | read-only Git fails even with `safe.directory` | C6b | stop; traversal or the setting is wrong |
| 22 | rollback itself fails | R5, R7 | R7 reports exactly what remains; no clean-host claim |
| 23 | C5-T run as root, or by anyone but the operator | C5-T guard 1 | `C5-T STOP`, exit 2, before any file is created |
| 24 | the state file is missing or unreadable | C5-T guard 2 | `C5-T STOP`, exit 2 |
| 25 | fixture boundary marker missing or duplicated | C5-T guard 3 | `C5-T STOP`, exit 2 — nothing is extracted |
| 26 | the fixture in the state file has been altered by even one byte | C5-T guard 5 checksum | `C5-T STOP`, exit 2 — the altered fixture never runs |
| 27 | the extraction picks up the wrong lines | C5-T guard 5 line count **and** checksum | `C5-T STOP`, exit 2 |
| 28 | the extracted fixture will not parse | C5-T guard 6 `bash -n` | `C5-T STOP`, exit 2 — stops before the fixture can signal |
| 29 | the fixture is cut short and exits 0 without a verdict | C5-T `C5 PASS` corroboration | `C5-T STOP`, exit 2 — an exit code alone is never read as a pass |
| 30 | manual recovery aimed at an empty, malformed, non-directory, symlinked or outside-the-temp-root path | C5-T-RECOVER's four conditions | refusal printed, exit 2, nothing removed |
| 31 | manual recovery would reach a second C5-T directory | C5-T-RECOVER takes one exact path and expands no glob | impossible by construction; measured with two directories present |

### The three outcomes, unambiguously

**C3a or C3b fails.** Stop at once. Run rollback R1–R7. Nothing outside the actor's own account was
ever touched — no ACL, no `sudoers`, no change to the operator's home, and C6 wrote no Git config —
so a **complete** R1–R7 leaves the host as it was. A rollback that stops before R6 does not: the
account record is gone after R4, but `/Users/wlactor-airesources` survives with the actor's login
keychain and `~/.codex/auth.json` still in it. Report that residue explicitly rather than calling the
host clean. Report the exact C3 output, redacted per the template.

**C3 passes but C4, C5 or C6 fails.** Stop. Do **not** proceed to D. Preserve the exact non-secret
output of the failing check plus the checks that passed before it. Rollback R1–R7 is available and is
offered, not forced — the operator may prefer to keep the account to retry the failing check.

**All Stage C checks pass.** Stop with **D and E still forbidden**. What is proved is exactly: a
non-admin actor account can authenticate Claude and Codex on its own credentials **and use them with
no GUI session**, can read this checkout across the ownership boundary once `safe.directory` names it,
and its UID is a working termination boundary against three actor-owned processes including a fully
detached descendant, without touching a uid-501 bystander in the same checkout. What is **not**
proved: anything about writing or committing (needs D2/D5), the narrow privilege rule (D4), the
dispatcher integration (Unit 3+), or Phase 1a itself — **1a remains open even if every C check
passes.**

**The runbook makes no recommendation about the account's future.** It ends here, with one question
for the operator:

> Stage C is complete. Do you want the temporary account `wlactor-airesources` **retained as-is** —
> non-admin, no `sudoers` rule, no ACL, no write access to the checkout, not hidden — or **removed**
> via rollback R1–R7? Retaining it keeps the evidence-bearing artifact and avoids repeating Stages B
> and C. Removing it returns the host to its prior state. Either way, D and E stay forbidden until you
> authorize them separately.

Do not hide, disable, retain or delete the account before that answer.

### Rollback

Run in order. Every step names `wlactor-airesources` literally; none touches any other account.

| # | Command | Kind | Checked by |
|---|---|---|---|
| R1 | **the census block printed below this table** — do not retype it | `[READ-ONLY]` | it prints its own verdict. `R1 OK` → continue to R2. Any `R1 STOP` → stop and take the output to the operator. This rollback never invents a sweep, and the C5 fixture is not a cleanup tool |
| R2 | `sudo -u wlactor-airesources -H /Users/wlactor-airesources/.local/bin/claude auth logout` | `[ROLLBACK]` | may fail because the keychain is locked; that is expected — record the exact message and continue. **R4 does not clear it:** the login keychain lives in `~/Library/Keychains/` inside the actor's home, and `-keepHome` retains the home. Those files are removed by **R6**, not R4 |
| R3 | `sudo -u wlactor-airesources -H /Applications/ChatGPT.app/Contents/Resources/codex logout` | `[ROLLBACK]` | file-based, so it should succeed. **R4 does not remove `~/.codex`** — it is inside the retained home, so `~/.codex/auth.json` survives until **R6** |
| R4 | `sudo sysadminctl -deleteUser wlactor-airesources -keepHome` | `[ROLLBACK]` | `-keepHome` is passed explicitly because the **default** home behaviour is not documented locally (`man -w sysadminctl` → no manual entry). It removes the **directory-services record only**. Everything in `/Users/wlactor-airesources` survives it, credentials included; R6 is the step that removes them |
| R5 | `id -u wlactor-airesources` → "no such user"; `dscl . -read /Users/wlactor-airesources RecordName` → `eDSRecordNotFound` | `[READ-ONLY]` | both must hold. If either does not, **stop** and report; do not retry blind and do not run R6 |
| R6 | `H=/Users/wlactor-airesources; [ "$H" = /Users/wlactor-airesources ] && [ -d "$H" ] && [ ! -L "$H" ] && [ "$(dirname "$H")" = /Users ] && sudo /bin/rm -rf "$H"` | `[ADMIN]` | five guards, all literal: the path is exactly the actor home, it is a directory, it is not a symlink, its parent is `/Users`, and R5 already proved the account is gone. **This is the only step that removes the actor's login keychain and `~/.codex/auth.json`.** Run **only** after R5 passes |
| R7 | `ls -ld /Users/wlactor-airesources` → "No such file or directory"; `id -u wlactor-airesources` → "no such user" | `[READ-ONLY]` | if either still resolves, report exactly what remains. **Never claim a clean host on an unverified rollback** |

**If the rollback stops before R6, credentials remain on disk.** The account record is gone after R4,
but `/Users/wlactor-airesources` still holds the actor's login keychain and `~/.codex/auth.json`. That
is the residue to report — an unfinished rollback is not a clean host, and R7 is the only source of
the "host is clean" claim. **No rollback step deletes or repurposes a pre-existing account**, and no
step guesses: R5 proves the account removed is the one it meant to remove before R6 touches any file.

#### R1 — the census block

Copy this whole block. It is a block rather than a table cell because the pipelines it needs cannot
survive inside one: a `|` written in a table row has to be escaped, and a copied `\|` is read by Bash
as an ordinary argument, not a pipeline. It signals nothing, cleans nothing, and runs no command as
the actor.

```bash
# R1 — census the actor boundary before removing anything.
# READ-ONLY: it signals nothing, cleans nothing, and never runs a command as the actor.
R1_UID="$(id -u wlactor-airesources 2>/dev/null)"
case "${R1_UID:-}" in
  ''|*[!0-9]*)
    echo "R1: account wlactor-airesources does not exist — nothing to census. Go to R7."
    ;;
  *)
    R1_PIDS="$(pgrep -U "$R1_UID" 2>/dev/null)"
    R1_RC=$?
    case "$R1_RC" in
      1)
        echo "R1 OK: actor boundary is empty (pgrep exit 1) — continue to R2"
        ;;
      0)
        R1_LIST="$(printf '%s\n' "$R1_PIDS" | tr '\n' ',' | sed 's/,*$//')"
        echo "R1 STOP: uid $R1_UID still owns processes. This rollback never signals them."
        if [ -n "$R1_LIST" ]; then
          ps -o pid,uid,ppid,pgid,command -p "$R1_LIST"
        else
          echo "R1 STOP: pgrep exited 0 but returned no pids — treat the census as unreadable"
        fi
        echo "R1 STOP: take the list above to the operator. Do not run R2-R7 yet."
        ;;
      *)
        echo "R1 STOP: pgrep exit $R1_RC — the boundary cannot be read. Do not continue."
        ;;
    esac
    ;;
esac
```

`ps` is only ever reached with a non-empty comma-joined pid list, so the malformed `ps -p ""` call the
previous R1 could make cannot happen.

### Operator evidence template

Bring back only this. No passwords, tokens, credential files, Keychain contents or browser data.

```
B1  password prompt appeared    : <yes|no>
B2  uid                         : <number>
B3  admin membership            : <the yes/no sentence>
B4  pre-launch census exit      : <0|1|>=2>
C1b actor claude present        : <yes|no>
G1  console owner               : <name>
G3  actor process census exit   : <0|1|>=2>
C3a claude auth status          : loggedIn=<true|false>  authMethod=<value>  [REDACT email and orgId]
C3b claude -p round-trip        : <the one-word reply, or the exact error>   exit=<code>
C4a codex login status          : <the one-line output>
C4b codex exec round-trip       : <the one-word reply, or the exact error>   exit=<code>
C5  C5-T verification line        : lines=<n> sha256=<value> (must be 210 / 65b50d19…)
C5  C5 exit status                : <0|1|>=2>   and the path C5-T printed for the output file
C5  full stdout of the fixture (it contains no secrets) — copy it from that output file
C6a git status WITHOUT safe.directory : exit=<code>  first line: <text>
C6b git status WITH safe.directory    : exit=<code>  first line: <text or "clean">
Anything that stopped early     : which step, and its exact non-secret output
Rollback, if run                : R1's printed verdict; whether R6 ran; R7's residue result verbatim
                                  (if R6 did not run, say so — the keychain and ~/.codex are still there)
```

## Blocker

**No supervision mechanism examined so far is usable under current authority.** That is a statement
about what has been examined, not a claim that the space is empty — the prior claim that "no candidate
remains" is **withdrawn**. The closed supervision discovery excluded process group, ancestry-at-stop,
environment tag, working directory, `kqueue NOTE_TRACK`, launchd job removal, Darwin `ptrace`,
containers and coalitions. Unit 5 excluded the pattern-free UID signal as over-broad. Unit 6 excluded
the real GID as sheddable through setuid-root `newgrp`. Unit 7 finds the audit session unusable under
current authority: right granularity and no unprivileged shed, but `setaudit_addr(2)` and
`auditon(A_GETPINFO_ADDR)` are each `suser()`-gated in the kernel. The inherited-descriptor handle
already in `dispatch.sh` reaches further than any of these, and `dispatch.test.sh` case 27h pins the
surviving hole — a descendant that closes every inherited descriptor still survives it.

**At least one candidate is unexamined.** `prsna` (persona) sits in the `ps -L` keyword list, has
never been dispositioned, and is readable unprivileged — which no other surviving candidate is. It is
deferral 8 and a candidate unknown for a later bounded discovery unit. **No exhaustion claim is made
here**, and none should be read into the list above.

**What comes next is not asserted to be an operator decision.** ASID is unusable under current
authority; making it usable would need new root-level creation and query authority, whose size, shape
and worth this unit did not establish and does not request. Persona is unexamined. Which of those the
task pursues, and whether anything goes to the operator at all, is Codex's assessment. **Restating
what literal 1a guarantees is not among the options** — `## Objective and scope` records that the
operator preserved that guarantee on 2026-08-08, so it is settled, not open.

**Attended probe authority and unattended production authority remain distinct.** Operator-attended
`sudo -u` does not give the dispatcher production authority; D4 stays unauthorized and outside this
unit. A root-bearing ASID design would need a third and larger authority than either, and it is not
requested here.

**The account stays untouched.** Re-measured again at the correction close, 2026-08-09 15:21 EEST, and
identical to the 12:17 reading: `id -u wlactor-airesources` → 502,
`id -un 502` → the account, `dseditgroup -o checkmember … admin` → "is NOT a member of admin". The
uid-502 census is stable at three PPID-1 services — 82525 `distnoted`, 82526 `mdbulkimport`, 82530
`lsd` — all `rgid 20`, all still carrying their original 10:11:27 start time, and `pgrep -U 502` still
exits 0, so the boundary is still non-empty. It remains a password-bearing login account with
`/bin/zsh`, the operator's home is `drwxr-xr-x+`, and actor reach into the operator home is unresolved
before D. No process emergency requires a signal. Rollback R1 has not been reachable at any
observation, so removal needs a separately verified procedure. Nothing may signal, delete, log into or
authenticate uid 502 in the meantime. C5 as written stays unrunnable, and C1 and every later Stage C
step stay stopped.

## Next action

Codex: run the closure check on the three frozen findings only — are findings 1, 2 and 3 resolved, and
did the correction break something?

What the correction did, so the check has something falsifiable to test:

1. **Finding 1** — the setuid-root inference is withdrawn and demoted to corroboration. All three
   rules Codex cited were reproduced verbatim from Apple's published XNU source and are quoted in
   `### The correction round`: `setaudit_addr(2)`'s `suser()` before `audit_session_setaia()`,
   `A_GETPINFO_ADDR` falling to the privilege switch's `default: suser(...)`, and
   `audit_session_port()`'s `PRIV_AUDIT_SESSION_PORT` for any session but the caller's own.
   Applicability is stated, not assumed: `main` and tag `xnu-12377.121.6` are byte-identical, and this
   host runs `xnu-12377.121.10`, which Apple has not published. Every "measured directly" statement
   that rested on binary modes or imports is corrected.
2. **Finding 2** — "candidate rejected" and the bespoke-C-supervisor exclusivity are withdrawn. The
   verdict now reads: unusable under current authority; usable only with new root-level creation and
   query authority; race safety and implementation shape unresolved. Claim 2's heading is narrowed to
   *unprivileged* supervisors and now names the root-capable paths it previously contradicted. No
   authority is requested, no mechanism prescribed, no value-and-risk call made.
3. **Finding 3** — the exhaustion claim is gone from `## Blocker` and from the verdict, persona is
   recorded as an unexamined candidate for a later bounded discovery unit, the next move is no longer
   asserted to be an operator decision, and restating literal 1a is removed as an option because the
   operator settled it on 2026-08-08. Persona was not investigated in this round.

**Newly noticed, recorded as a deferral rather than worked:** deferral 10 — nothing in this task pins
where a primary-source claim about kernel behaviour may come from, and this round read Apple's
published source over the network because the frozen finding directed it. Recorded, not acted on.

**One thing the check should look at specifically.** The first reading of the XNU source got
`A_GETPINFO_ADDR` backwards — its handler contains no privilege check, and the gate sits 360 lines
earlier in a shared switch. The correction quotes the switch, but this is the place where an
independent look is most worth spending.

Preserved and verifiable: the file reduction, the runbook, C5-T, the rollback, the evidence template,
and the C5 fixture bytes — 210 lines, sha256 `65b50d193054e6060fda6de866119d98898d8df04889e96b83802430b077a8f9`,
markers intact. Host state unchanged, re-measured at the correction close and identical to the earlier
reading. Only this state file was changed and committed.
