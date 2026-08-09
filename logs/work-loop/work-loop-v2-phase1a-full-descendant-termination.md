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

Standard. Discovery mode. Unit 6 — determine whether the dedicated account can support a
run-specific process boundary that reaches fully detached actor descendants without signalling
macOS per-user services.

Named reason for the loop: literal Phase 1a still needs a Darwin supervision mechanism, and a false
positive would signal unrelated OS processes while a false negative would leave an escaped daemon
alive. The boundary therefore needs bounded discovery and independent assessment before any live
probe or implementation.

Plan justification: the governing unattended-operation plan still blocks Phase 2 on literal 1a and
1f. Unit 5 rejects pattern-free UID-wide signalling under the preserved bystander guarantee but does
not reject the dedicated account. Establishing whether that identity can support a narrower,
truthful boundary is the smallest unit that can advance 1a without signalling anything.

Codex framing decision: this remains discovery because the replacement boundary is unknown. This
unit may inspect the host and repository read-only and change only this state file; it may not signal,
delete, authenticate, install, launch an actor fixture or implement anything. Safe account removal
is held outside this unit because no process emergency exists and mechanism discovery is the nearest
unmet Phase 1a condition.

### Unit 6 brief — executed, awaiting assessment

Codex's brief for this unit, moved here verbatim from `## Next action` when the unit completed, so
that field states the single next thing. Not altered, and not marked accepted — assessment is Codex's.

Unit 5 rejected the pattern-free UID-wide signal without rejecting the dedicated account. Determine
whether macOS exposes a narrower, run-specific boundary that can still reach the accepted escaped
shape — `setsid`, double fork, descriptor closure and `exec` — while excluding the account's
PPID-1 per-user services. This unit returns evidence and a verdict; it does not implement or run the
eventual mechanism.

**Governing sources and dispositions:** literal 1a and its no-unrelated-process rule in
`## Objective and scope` govern. Unit 5's corrected result governs the live account facts and rejects
pattern-free `pkill -U`. The closed
`logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` governs the mechanisms already
rejected or authority-bound: process group, ancestry-at-stop, environment tag, public descriptor,
working directory, `kqueue NOTE_TRACK`, launchd job removal, Darwin `ptrace`, containers, audit
sessions and coalitions. Re-check a cited premise before relying on it, but do not repeat that broad
discovery without evidence that a premise changed. The current dispatcher, escaped-descendant probe
and interruption evidence are verify-first repository claims, not permission to modify them.

**Named unknown:** can the dedicated identity supply a fail-closed process boundary narrower than
its whole UID, using authority already available to the dispatcher, or is every such boundary either
incomplete against the fully detached descendant or over-broad against macOS services?

**Claims to check:**

1. Verify the current Unit 5 conclusion and live account shape read-only: pattern-free `pkill -U`
   reaches non-descendant services; the current membership may change naturally; nothing in the live
   record proves respawn or eventual emptiness.
2. Test the two narrower shapes already surfaced as hypotheses, not requirements: a baseline-aware
   UID census and a per-process stop against a recorded set. Establish whether each can distinguish
   the escaped daemon from (a) a service present at baseline, (b) a service launched after baseline,
   (c) a baseline PID that exits and is reused, and (d) an actor descendant that changes session,
   parent, group, descriptors and executable.
3. Inspect local Darwin process interfaces, manuals and headers for a non-root, creation-time or
   immutable process attribute that survives the accepted escape and can be queried at stop time.
   Expand only where it resolves that question. Do not call an interface available merely because a
   symbol exists; establish access, inheritance, race behaviour and host availability. Preserve the
   prior discovery's authority findings unless current primary evidence falsifies them.
4. Map the candidate boundary across every current actor launch and controlled stop path in
   `dispatch.sh`, without editing it. It must preserve the global deadline, interruption semantics,
   retry prohibition, lock pinning/cleanup, exit-code honesty and attended behaviour.
5. Return one verdict: **candidate ready for an authorized live probe**, naming what the probe must
   be able to falsify; **dedicated-account route rejected**, naming the exhaustive conflict with
   literal 1a; or **operator authority required**, naming the smallest new authority only if no
   current-authority candidate survives. Do not turn a speculative mechanism into an implementation
   brief.

**Required evidence:** list the exact files, manuals, headers and read-only commands inspected;
separate observation from inference; provide a false-positive/false-negative table covering the four
cases in claim 2 plus enumeration failure and PID reuse; and show how the verdict could have gone the
other way. An absence conclusion must name its bounded search surface. Evidence from a harmless
fixture may be proposed for a later authorized probe but must not be executed here.

**Scope and stops:** this state file only. No `sudo`, signal, `launchctl` mutation, account action,
login, authentication, installation, actor process launch, C5, rollback, product edit, test run or
new repository artifact. Do not inspect credential contents. Safe account removal remains held
outside this unit. Stages D/E, Phase 1f and every Phase 2 action remain forbidden. Stop and hand back
if the answer requires host mutation, new authority, or evidence that cannot be obtained read-only.

Unit completion: replace `## Latest result` with the discovery verdict and evidence, update the
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

**Unit 6 (CORRECTED at the correction round) — the run-GID boundary is sheddable without a password,
and the route cannot be repaired by choosing a different group.** Discovery, read-only throughout. No
`sudo`, no `kill`/`pkill`, no `launchctl` mutation, no account action, no login, no authentication, no
installation, no actor process launch, no C5, no rollback, no fixture execution, no product edit, no
test run, and no repository file other than this one. No credential contents were read. The live
account was preserved untouched.

**The verdict of "candidate ready for an authorized live probe" is WITHDRAWN.** The corrected verdict
is that the real-GID boundary **does not satisfy literal Phase 1a** and no probe is proposed. The two
frozen findings are resolved below, and the correction did not alter the accepted runbook, the C5
fixture (210 lines, sha256 `65b50d19…a8f9`, marker pair intact) or any other accepted artifact.

Result: the real-GID candidate is rejected, the authority claim behind it is withdrawn, and the
group-variant choice that was escalated to Codex and the operator is withdrawn rather than re-put.

Evidence: `newgrp(1)`'s own DESCRIPTION, `/usr/bin/newgrp`'s setuid-root mode, `id
wlactor-airesources`'s membership list, and the generated `--unattended` profile in `dispatch.sh`
lines 1202-1227 with its deny list at lines 211-217 — each read this round and each quoted below. The
evidence could have gone the other way in three named places, listed at the end.

### The correction round — findings 1 and 2

Both reproduced by inspection before either was corrected.

- **Finding 1: REPRODUCES, and it is decisive.** `man 1 newgrp` on this host, DESCRIPTION verbatim:
  "The newgrp utility creates a new shell execution environment with **modified real and effective
  group IDs**", and "The user **will be prompted for a password if they are not a member** of the
  specified group." `ls -l /usr/bin/newgrp` → `-r-sr-xr-x  1 root  wheel` — setuid root. `id
  wlactor-airesources` → `gid=20(staff) groups=20(staff),12(everyone),61(localaccounts),701(…),702(…),
  100(_lpoperator)`. The actor is therefore a member of every group named as a candidate, so
  `newgrp staff` from any descendant running as uid 502 changes the **real** GID with **no password
  and no operator action**. The stop would then miss it, and the run would report a clean halt while a
  descendant kept running — which is the exact defect literal 1a names.
- **Finding 1 is stronger than the group-choice framing survives.** The same DESCRIPTION continues:
  with no group operand, "the real, effective and supplementary group IDs are **restored to those from
  the current user's password database entry**." So bare `newgrp` returns to the account's directory
  primary group without naming a group at all. The only way to make a run GID unsheddable this way is
  to make it *be* the password-database primary group — and then the account's PPID-1 launchd agents
  inherit it too, which is the over-broad boundary Unit 5 already rejected. **The route is
  self-defeating, not merely unproven**, and picking a different group cannot repair it.
- **Nothing in scope prevents the escape**, which is the condition finding 1 attached to proposing any
  probe. Read this round: `write_unattended_profile` (`dispatch.sh` lines 1202-1227) emits network
  denial, `denyRead ["~/"]` with three named `allowRead` paths, and the flag block; the deny list
  `UNATTENDED_BASE_DENY` (lines 211-217) is exactly `Bash(git push:*)`, `Bash(git push *)`,
  `WebFetch`, `WebSearch`, `mcp__*`. **There is no execution restriction of any kind**, so nothing
  there stops `newgrp`. Two further limits are in the same code, not inferred: line 1281 states "codex
  hops are NOT covered by this profile", and the profile applies only when `--unattended` is passed at
  all, which matches accepted limitation 4 of the closed supervision discovery ("containment covers
  only hops that actually run contained"). Attended behaviour is therefore uncontained by
  construction.
- **Root cause of the error, stated plainly.** The result checked `setgid(2)` — "[EPERM] the process
  does not have appropriate privileges" — and read immutability off it. That covers a process changing
  its own real GID directly. It does **not** cover a **setuid-root helper on the host** doing it on the
  process's behalf, and `newgrp` is precisely that helper. Inheritance was established correctly;
  immutability was not established at all, and calling the escape a "determined escape" narrowed the
  preserved guarantee without authority. Withdrawn.
- **Finding 2: REPRODUCES.** `newgrp(1)` describes group IDs only; no uid change appears anywhere in
  its manual, so it cannot switch the dispatcher from uid 501 to uid 502. The result's phrases
  "**Current authority, no new grant**" and the brief's "using authority already available to the
  dispatcher" were answered as though operator-attended `sudo -u` counted as dispatcher authority. It
  does not. **Both phrases are withdrawn.** The two authorities are distinct and were conflated:
  - **Probe authority** — operator-attended `sudo -u wlactor-airesources`, which exists today and is
    what the runbook's C1 and C6 rows already use. It is attended by definition.
  - **Production authority** — an unattended dispatcher running as the actor. **Unsolved.** It is the
    accepted deferral recorded below ("every actor command in the runbook goes through the operator's
    `sudo`"), which assigns it to the D4 narrow-privilege question, and D is not authorized.
  So no part of the real-GID route was ever available to the unattended dispatcher under current
  authority, whichever group it used.
- **Correction 2 — the group-variant choice is withdrawn, not re-put.** Because finding 1 rejects the
  candidate, the choice between reusing an existing group and creating a dedicated one no longer
  advances 1a. It is not escalated to Codex or the operator, and the previous `## Blocker` framing of
  "a decision, not a discovery" is withdrawn with it.

### The record — claims 1 to 5, corrected

- **Claim (1): HOLDS — re-measured, and the account is unchanged apart from further natural decay.**
  At 2026-08-09 11:51 EEST: `id -u wlactor-airesources` → 502, `id -un 502` → the account,
  `dseditgroup -o checkmember … admin` → "is NOT a member of admin". `ps -o pid=,uid=,rgid=,lstart= -U
  502` now returns **three** processes — 82525 `distnoted`, 82526 `mdbulkimport`, 82530 `lsd` — all
  with `rgid 20` and all still carrying the original **10:11:27** start time, so nothing has restarted;
  `pkd` and `trustd --agent` exited on their own with no signal. This reproduces Codex's closure-check
  census exactly. `pgrep -U 502` still exits 0, so the boundary is still non-empty. Per the frozen
  scope, the decay is recorded and **not pursued**.
- **Claim (2): unchanged — both narrower shapes are rejected, and they fail in opposite directions.**
  A baseline-aware UID census discriminates by *when a process appeared*, not by *who started it*; the
  operator's live evidence recorded the uid-502 set **growing 7 → 9 within about four minutes**, so an
  OS service appearing after baseline would be signalled — the harm `## Objective and scope` forbids. A
  per-process recorded set can only hold pids the dispatcher observed, and the double fork destroys the
  ancestry link before any stop, which is why `dispatch.sh` lines 519-532 record "recursive PPID census
  … MISSES" for the double-fork orphan. Complete-and-over-broad versus bounded-and-incomplete.
- **Claim (3): CORRECTED — the real GID is inherited through the escape, but it is not immutable, so
  it is not a boundary.** The inheritance evidence stands and is unchanged: `execve(2)` — "the real
  user ID, real group ID and other group IDs of the new process image remain the same as the calling
  process image", with set-group-ID affecting only the effective GID; `fork(2)` — the child "is an
  exact copy" except for an enumerated list carrying no credential; `setsid(2)` — a new session and
  process group, no credential change; `pkill(1)`/`pgrep(1)` — "`-G gid` Restrict matches to processes
  with a real group ID in the comma-separated list gid"; `ps -L` lists `rgid` and `rgroup`. The measured
  facts also stand: all uid-502 agents carry `rgid 20`, and a host-wide `ps -axo rgid=` tally shows no
  process at gids 100, 61, 12, 701 or 702, with `dscl . -read /Groups/wlrun` → `eDSRecordNotFound`.
  **What is withdrawn is the conclusion drawn from them.** Inheritance makes the attribute *reach* the
  escaped daemon; it does not make the daemon *unable to drop it*. `newgrp(1)` drops it without a
  password, so the attribute fails the one property a termination boundary must have.
  **The absence conclusion is unchanged and now settles the whole surface.** Searched: the complete
  `ps -L` keyword list on this host, the complete `pgrep`/`pkill` selector list (`-F -G -P -U -g -t
  -u`), and the mechanisms enumerated by the closed
  `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md`. `uid`/`ruid` is over-broad;
  `pgid`, `sess`, `tty`/`tdev`/`tpgid` are destroyed by `setsid`; `ppid` by the double fork; `login`
  (the audit login name) reads `wlactor-airesources` for every agent, so it has UID granularity, and
  narrowing it needs `setauid(2)`, whose manual states "this system call requires an appropriate
  privilege". Re-checked and unchanged: `sys/event.h` line 356 — "NOTE_TRACK, NOTE_TRACKERR, and
  NOTE_CHILD are no longer supported as of 10.5"; `man 2 ptrace` lists twelve requests with no
  fork-following request; coalitions have no public SDK header under `sys/`. With `rgid` now rejected,
  **no attribute on that surface survives.**
- **Claim (4): the `dispatch.sh` mapping stands as a description and no longer supports a probe.**
  Read-only; nothing was edited. A fourth handle would fit `actor_tree_census()`'s existing
  three-valued contract (exit 0 / 1 / ≥2 → found / none / `CENSUS_UNKNOWN`, returned through globals
  for the reason at lines 670-682), would add one `pgrep` per pass to the census-cost term without
  changing `TERM_GRACE_SECS=5`, `KILL_SETTLE_SECS=2` or the ~9s bound documented at
  `effective_timeout()`, would need a fourth global published and cleared by `run_bounded()` for
  `on_signal()` to reach it, and would force `report_teardown()`'s scoped sentence to be widened —
  which `dispatch.test.sh` case 27h fails on, making any such change deliberate. **None of that is
  reached**: a handle that the target can shed would make `teardown verified` false, which is the
  claim 1a exists to protect. Retained as a description of where any future boundary must fit, not as
  a plan.
- **Claim (5): CORRECTED — the verdict is rejection of the real-GID mechanism.** Not "ready for a
  probe", and not "operator authority required": no new authority was found that would close the shed,
  and the self-defeating argument above shows a different group cannot. **What is not rejected is the
  dedicated account**, exactly as in Unit 5 — the identity was never exercised, and rejecting it would
  be a broader claim than the evidence supports. The named unknown returns **open**, now with one more
  mechanism excluded and its whole attribute surface exhausted.

### False positive and false negative, by case

| Case | Baseline-aware UID census | Per-process recorded set | Run-specific real GID |
|---|---|---|---|
| (a) service present at baseline | correct exclusion | correct exclusion | correct exclusion — rgid 20 ≠ run gid |
| (b) service launched after baseline | **FALSE POSITIVE** — signals an OS service; observed 7 → 9 in ~4 min | correct exclusion | correct exclusion (inference: launchd sets the account's primary group) |
| (c) a baseline pid exits and is reused by an actor descendant | **FALSE NEGATIVE** — the pid is in the baseline, so it is spared | not applicable | not applicable — selection is by attribute, not by pid |
| (c′) a recorded pid exits and is reused by an unrelated process | not applicable | **FALSE POSITIVE** unless owner *and* start time are re-checked | not applicable |
| (d) descendant changes session, parent, group, descriptors and executable | reached | **FALSE NEGATIVE** — its pid was never observable | reached — `execve(2)` preserves the real GID |
| **(e) descendant execs setuid-root `newgrp`** | not applicable — selection is by uid, which `newgrp` does not change | not applicable — selection is by pid | **FALSE NEGATIVE, and it is decisive** — no password, no operator action, and the stop then claims success |
| enumeration failure (`pgrep` exit ≥ 2) | must be `CENSUS_UNKNOWN`, never "empty" | must be `CENSUS_UNKNOWN` | must be `CENSUS_UNKNOWN` |

Row (e) is the row the previous six-item falsification list omitted. Pid reuse remains bounded but not
excluded — `kern.maxproc` 6000, `kern.maxprocperuid` 4000, and Darwin pids wrap — which is why (c) and
(c′) matter for the two pid-based shapes.

### Inspection failures, stated rather than read as absence

- `/etc/sudoers` is mode `-r--r-----  root:wheel` and returned **Permission denied**; `/etc/sudoers.d/`
  is empty. Whether the policy permits `sudo -g` is **unknown**, and after this correction nothing
  rests on it.
- No fixture was executed and no process was launched under any group, so the shed itself was not
  measured. It rests on `newgrp(1)`'s DESCRIPTION and the file's setuid-root mode as written. Measuring
  it would require launching an actor process, which the brief forbids.
- `launchctl print user/502` was not retried; Unit 5's `Operation not permitted` stands, so the live
  launchd domain remains un-enumerated and six job sources remain unresolved.

### How the corrected verdict could have gone the other way

Had `newgrp(1)` been absent from this host, or not setuid-root, or had it prompted for a password even
for a member, the shed would need privilege and the boundary would hold — all three were checked and
all three went the other way. Had the manual's no-operand form restored something other than the
password-database entry, a dedicated primary group could have been unsheddable without also being
inherited by the launchd agents, and the route would survive. And had the generated `--unattended`
profile carried any execution restriction, finding 1's own condition for proposing a probe could have
been met for contained hops; it carries none, and it does not cover Codex hops or uncontained runs at
all.

### Deferrals — carried forward and newly recorded

None is implemented. The first two are carried; the third was noticed during this correction and is
recorded rather than pursued, because the scope is frozen to the two findings.

1. **The plist count is inconsistent.** Unit 5's result said `/System/Library/LaunchAgents` held 465
   plists; a bounded count at the closure check returned 456. It affects no mechanism verdict. Correct
   it only if a later unit needs that inventory.
2. **This state file is 1,426 lines and grows every unit**, against core § 4's "current truth, not a
   diary". This correction replaced the previous result rather than appending, and kept the accepted
   artifacts, but the Unit 4 narrative sections below (`### The correction round — findings 1 and 2`
   at the runbook's end and `### Result and evidence`) are history. Dropping accepted evidence is an
   assessment decision, not this round's scope.
3. **No audit exists of the host's setuid-root helpers that can change a process's own credentials.**
   `newgrp` is one instance; the general question — which such helpers exist and what each can undo —
   is the general form of the error this correction fixed, and any future boundary proposal rests on
   it. Not started, because it is outside the frozen findings.
4. **The uid-502 census fell again, 5 → 3, with no signal**, all survivors keeping their original
   start time. Recorded because it was measured; explicitly not pursued, per the closure-check
   deferral in the frozen findings.

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

### The correction round — findings 1 and 2

Both reproduced by inspection before either was corrected.

- **Finding 1: REPRODUCES, and the danger is real.** The recovery instruction read
  `rm -rf "${TMPDIR:-/tmp}"/wl-c5.*`. Demonstrated without deleting anything: two plausible generated
  directories were created (`wl-c5.HXsVqNkO`, `wl-c5.EMPfDhEq`) and the glob was expanded into the
  positional parameters — **it selected 2 paths**, not one. A second, unrelated C5-T run's directory
  would have been destroyed by a recovery aimed at the first. Both scratch directories were then
  removed with `rmdir`; no `rm -rf` was used to show this.
- **Finding 2: REPRODUCES.** The audit table claimed "Six sites, no seventh" and listed six rows.
  `{ …; } 2>&1 | tee "$OUT"` writes the captured fixture output and was not one of them.

**Correction 1 — recovery is by exact path, never by wildcard.** C5-T now prints
`C5-T: temporary directory: <path>` immediately after creating it and **before the fixture launches**,
so the operator holds the exact recovery target in advance. A new **C5-T-RECOVER** block takes that
one path and removes it behind four conditions: non-empty, the exact `wl-c5.` + eight-character
generated name, a real directory that is not a symlink, and a parent that resolves — via `pwd -P`, so
symlinked temp roots cannot smuggle a path in — to the temp root itself. It expands no glob, and it
has a `DRY=1` mode. The same four conditions were factored into `t_rmdir` and are now used by C5-T's
own automatic cleanup, so the automatic and manual paths cannot disagree. The automatic cleanup is not
weakened: its name test went from `wl-c5.??????*` (six or more characters) to exactly the eight
`mktemp` generates, and it gained the containment check. Nothing here claims `SIGKILL` can be
trapped — it cannot, and the limitation is still recorded as a limitation.

**Correction 2 — the audit is now mechanical and complete.** The write/delete/privilege enumeration is
run by a stated `grep` over the exact C5-T block rather than by reading it. It returns 7 non-comment
lines carrying 8 write invocations, presented as 7 rows with the `$TMPD/rc` pair grouped explicitly.
`tee "$OUT"` is now named, with what constrains its destination and why its retained contents hold no
secret. The C5-T-RECOVER block is audited the same way and returns exactly one site.

### Result and evidence

Result: the runbook now says how the operator runs C5. **C5-T** is added directly after the fixture,
and the C5 row of the stage table points at it. It extracts the accepted fixture from this file
between two markdown-comment markers placed outside the fence, proves the extraction by line count
and sha256 against the accepted value, syntax-checks it, runs it once with the literal actor name and
checkout path, carries the fixture's real exit status back out, saves the non-secret stdout for the
evidence template, and removes the script on success, failure and handled interrupt. The operator
copies one block and fills in nothing. The accepted C5 fixture is unchanged — the markers sit outside
its fence — and the stage ordering, stop rules, rollback and D/E boundary are untouched. Seven rows
were added to the fail-capability matrix and the evidence template gained the C5-T verification line.

**Two defects were found by testing and fixed before this was written down**, which is the reason the
evidence below is worth reading rather than a formality:

1. The first draft used `mktemp "$TMPDIR/wl-c5-output.XXXXXXXX.txt"`. BSD `mktemp` only substitutes
   **trailing** X's, so it created a literally-named file — the fixed temporary path the brief
   forbids. Measured side by side: with the `.txt` suffix the name came back `wl-c5-output.XXXXXXXX.txt`;
   without it, `wl-demo.HM0ElCoH`. The suffix was dropped.
2. The first draft trusted the fixture's exit status alone. A stub interrupted mid-run exited 0
   without printing any verdict, and the transport reported **`C5 exit status: 0`** — a pass, after an
   interruption. The status file is now pre-seeded with `unfinished`, and an exit of 0 is accepted
   only when the fixture's own `C5 PASS` line is present in the captured output. Re-tested: the same
   interrupted stub now stops with exit 2.

Evidence — every item below was produced this unit, read-only, with the fixture never executed:

- **Extraction is exact.** Run against the live state file, C5-T extracted **210 lines** with sha256
  `65b50d19…a8f9` — equal to the accepted fixture's checksum taken from commit `3356c8c`. A wrong
  boundary or an off-by-one would change both numbers.
- **`bash -n` returns 0** on the transport itself and on the extracted fixture.
- **The marker design is load-bearing and was measured.** In the live file the markers appear
  **twice** each as substrings — once as the real marker, once inside C5-T's own variable assignment —
  but **exactly once** each as a whole line. C5-T matches whole-line and fixed-string (`grep -x -F`),
  which is why it finds one and not two. A naive substring match would fail here.
- **Every failure branch was exercised**, each with harmless stubs or a mutated scratch copy of this
  file; none ran the fixture, `sudo`, `pkill`, `kill`, an account command, authentication or Git:

  | branch | how it was provoked | transport exit | outcome |
  |---|---|---|---|
  | caller is root | stubbed `id -u` → 0 | 2 | `STOP: running as root` |
  | caller is not the operator | stubbed `id -un` | 2 | `STOP: caller is 'somebodyelse'` |
  | begin marker missing | marker line deleted from a scratch copy | 2 | `STOP: found 0 begin markers` |
  | begin marker duplicated | marker line doubled | 2 | `STOP: found 2 begin markers` |
  | one byte changed in C5 | `GRACE=3` → `GRACE=4` | 2 | `STOP: checksum mismatch`, both hashes printed |
  | extracted fixture will not parse | injected `fi`, checksum re-baselined so it reaches this guard | 2 | `STOP: bash -n failed` |
  | fixture returns 0 with a verdict | stub prints `C5 PASS` | **0** | reported as a pass |
  | fixture returns 1 | stub prints `C5 FAIL` | **1** | status survives |
  | fixture returns 2 | stub prints `REFUSE:` | **2** | status survives |
  | fixture cut short, exits 0, no verdict | stub interrupted mid-run | 2 | `STOP: never printed its 'C5 PASS' verdict` |
  | unexpected temp path | `TMPD=/etc` | 2 | refusal printed; `/etc` untouched |

- **Every recovery guard was exercised too**, with two real generated directories present at once so
  the one-target claim could fail. `DRY=1` was used for the selection demonstration, so nothing was
  deleted to prove it:

  | recovery input | result |
  |---|---|
  | directory A (dry run) | `would remove exactly one directory: …/wl-c5.ApTskvsi` |
  | directory B (dry run) | `would remove exactly one directory: …/wl-c5.uHlA1ihJ` — a **different** single path |
  | empty path | `refusing — no path given` |
  | malformed name (`…/not-a-c5-dir`) | `refusing — is not a C5-T directory name` |
  | correct name shape but **outside** the temp root | `refusing — resolves outside the temp root [/private/var/…/T]` |
  | symlink pointing at A | `refusing — is not a directory` |
  | path that does not exist | `refusing — is not a directory` |
  | the temp root itself | `refusing — is not a C5-T directory name` |
  | **A, for real** (`DRY=0`) | `RECOVER: removed` — and **B was still present afterwards**, which is the whole point |

- **Static audit of everything C5-T writes, deletes or elevates.** Enumerated mechanically, not by
  reading, so the completeness claim can fail. The enumeration run over the exact C5-T block was:

  ```
  grep -nE 'mktemp|chmod|(^|[^-[:alnum:]])rm[[:space:]]|tee[[:space:]]|[^0-9<>]>[[:space:]]*"|sudo|[^_[:alnum:]]kill[[:space:]]|pkill' <block> | grep -v '^[0-9]*: *#'
  ```

  It returns **7 non-comment lines**, and one of those lines carries **two** write invocations, so
  **8 invocations in 7 table rows** — the `$TMPD/rc` pair is grouped explicitly:

  | line | site | what it writes or removes | what constrains it |
  |---|---|---|---|
  | 67 | `mktemp -d …/wl-c5.XXXXXXXX` | creates the private directory | random trailing name, never a fixed path; failure stops the run |
  | 68 | `chmod 700 "$TMPD"` | tightens that directory | operates only on the just-created path |
  | 82 | `awk … > "$SCRIPT"` | writes the extracted fixture | destination is inside `$TMPD`; guards 3–5 bound the content before it can run |
  | 100 | `mktemp …/wl-c5-output.XXXXXXXX` | creates the output file | random trailing name; **deliberately kept** — see below |
  | 101, 102 | `echo … > "$TMPD/rc"` (**two invocations**: the `unfinished` pre-seed and the real status) | records the fixture's exit status | destination is inside `$TMPD` |
  | 102 | `… \| tee "$OUT"` | writes the fixture's captured stdout | destination is the `mktemp` file from line 100 and nothing else; this is the write the previous version of this audit missed |
  | 35 | `rm -rf "$t_par/$(basename "$t_d")"` | the only deletion | reached only through `t_rmdir`: non-empty path, exact `wl-c5.` + 8-character name, a real directory and not a symlink, and a parent that resolves to the temp root. No glob is expanded, so exactly one path is ever considered |

  **Why the retained output is non-secret.** `$OUT` holds only the fixture's own stdout. The fixture
  prints pids, uids, process-group ids, `pgrep`/`pkill` exit codes and its verdict lines. It reads no
  credential, runs no authentication command, and prints no password, token, keychain item or file
  content. The account name and checkout path it echoes are both already written in this file.

  There is **no** `sudo`, `kill`, `pkill` or other privilege-bearing call anywhere in C5-T — the same
  enumeration returns **0** matches for those three. The only privileged commands in the whole C5 step
  are the ones already inside the accepted fixture, which is unchanged.

- **The recovery block audits to one site.** The same enumeration over C5-T-RECOVER returns exactly
  **1** line: `rm -rf "$r_target"`, where `$r_target` is rebuilt from the resolved parent and base
  name only after the same four conditions pass. It creates and modifies nothing.
- **Cleanup was checked, not assumed.** After every passing and failing run above, `ls -d
  "${TMPDIR:-/tmp}"/wl-c5.*` returned no matches, and the output file was still present.

The evidence can fail. Each guard was provoked and each returned a stop; had the checksum guard been
wrong, the `GRACE=3 → 4` mutation would have run anyway; had the verdict corroboration been absent,
the interrupted stub would still report a pass, as it demonstrably did before the fix.

**One accepted limitation.** A `SIGKILL` against the C5-T shell leaves the temporary directory behind,
because `SIGKILL` cannot be trapped by any program. Measured: the leftover holds only the extracted
`c5.sh` — the same public bytes as this file — and a short status file. The runbook records this, and
its recovery is now the exact-path C5-T-RECOVER block, whose target C5-T prints before the fixture
launches. The wildcard that previously stood there is gone.

Nothing about the route itself is settled by this. C5-T only makes the authorized probe runnable.
**Phase 1a stays open, and stays open even if every Stage C check later passes.**

### Deferrals — recorded, not done

Three. The fourth — the C5 transport gap — **was this unit's work and is now closed** by C5-T. The
three below are unchanged and all sit outside Stages B and C.

1. **Codex has no actor-owned bootstrap.** The Claude bootstrap installs into the actor's own home
   (C1a/C1b), but every Codex command still runs `/Applications/ChatGPT.app/Contents/Resources/codex`
   — a permanent dependency on the operator's application bundle. Acceptable for a temporary Stage C
   probe, not acceptable as steady state. Changing the Codex install layout is D/E territory.
2. **Every actor command in the runbook goes through the operator's `sudo`.** A real dispatcher
   cannot use the operator's sudo credential, so the run-as route for production is still unsolved.
   It is the D4 narrow-privilege question, which is unauthorized.
3. **C3b and C4b spend a little of the actor's own quota.** They are the only checks in the runbook
   with an external cost. Worth the operator knowing before they run it; not a defect, and not a
   reason to weaken the check back to metadata.

## Blocker

**The stop mechanism is rejected and its attribute surface is now exhausted.** Pattern-free `pkill -U`
signals PPID-1 macOS per-user services outside the actor's descendant tree (Unit 5). The real-GID
boundary that Unit 6 proposed is sheddable by any descendant via setuid-root `newgrp`, with no
password and no operator action, and bare `newgrp` restores the account's password-database group — so
no choice of group repairs it. Across the searched surface — the `ps -L` keyword list, the
`pgrep`/`pkill` selector list, and the mechanisms in the closed supervision discovery — **no process
attribute survives the accepted escape and resists being dropped.** C5 as written stays unrunnable,
and C1 and every later Stage C step stay stopped.

**The previous "decision, not a discovery" framing is withdrawn.** The group-variant choice does not
advance 1a and is not put to Codex or the operator. Nothing is to be created, granted or probed.

**Two authorities remain distinct, and conflating them was the second finding.** Operator-attended
`sudo -u` is probe authority and exists today; an unattended dispatcher running as the actor is
production authority, is unsolved, and sits in the D4 narrow-privilege deferral, which is
unauthorized. Neither was available to the unattended dispatcher for the rejected route.

**The account stays untouched.** It is non-admin, has no observed tool credential and no GUI session,
but it is a password-bearing login account with `/bin/zsh`, and the operator's home is `drwxr-xr-x+`,
so actor reach into the operator home remains unresolved before D. No process emergency requires a
signal. Rollback R1 has not been reachable at any observation, so removal needs a separately verified
procedure. Nothing may signal, delete, log into or authenticate uid 502 in the meantime. The uid-502
census has fallen 9 -> 5 -> 3 with no signal and no restart; recorded, not pursued.

## Next action

Codex runs the closure check on the two frozen findings only:

1. **Are findings 1 and 2 resolved?** Finding 1: the `newgrp(1)` manual text, the setuid-root mode and
   the actor's membership are reproduced by inspection; the verdict is withdrawn and replaced by
   rejection; the `--unattended` profile was read and carries no execution restriction, so finding 1's
   condition for proposing a probe is not met and no probe is proposed; and row (e) is added to the
   false-positive/false-negative table. Finding 2: "current-authority variant" and "using authority
   already available to the dispatcher" are withdrawn, probe authority and production authority are
   separated, and the group-variant choice is withdrawn rather than escalated.
2. **Did the correction break anything?** The correction touched only `## Latest result`, `## Blocker`
   and this field. The accepted C5 fixture is unchanged — 210 lines, sha256
   `65b50d193054e6060fda6de866119d98898d8df04889e96b83802430b077a8f9`, one marker pair — and the
   command-support table, runbook, C5-T, signal audit, fail-capability matrix, outcomes, rollback and
   evidence template are untouched. The file still carries exactly the five state fields.

Anything newly noticed at this check is a deferral, not a second correction round. Four deferrals are
already recorded at the end of `## Latest result`; the third — that no audit exists of the host's
setuid-root credential-changing helpers — is the general form of the error finding 1 caught, and is
the one most likely to matter to whatever boundary is considered next.

Literal Phase 1a remains open. Stages D and E, Phase 1f and every Phase 2 action remain forbidden, and
the live account remains preserved.
