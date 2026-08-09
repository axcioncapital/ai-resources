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

Standard. Discovery mode. Unit 8 — one final tightly-bounded fix after the frozen correction closure
check. The fix is limited to the surviving Finding 1 overclaim and the duplicated paragraph introduced
by the correction; it does not reopen the unit or authorize new research.

Named reason for the loop: literal Phase 1a still needs a Darwin supervision mechanism. Unit 7's
correction is accepted: ASID has useful granularity but is unusable under current authority, and its
root-bearing form remains unassessed. Persona is the one explicitly recorded process attribute that
has not been dispositioned. Examining it is therefore the smallest justified next unit; no operator
authority decision is ripe until this remaining candidate is understood.

Plan justification: the governing unattended-operation plan still blocks Phase 2 on literal 1a and
1f. A false positive would signal an unrelated OS process; a false negative would leave the escaped
daemon alive. This unit is read-only discovery. It may inspect the host, repository, local primary
interfaces and official Apple primary source, and may change only this state file. It may not signal,
elevate, create or change a persona, compile or run a probe, mutate the live account, implement a
mechanism or enter Stages D/E, Phase 1f or Phase 2.

### Unit 8 brief — executed

Codex's brief for this unit, moved here verbatim from `## Next action` when the unit completed, so
that field states the single next thing. The Unit 7 brief that previously stood here is committed at
`ac9ed42`/`c49e1f4` and was removed from this file as prior-unit history (core § 4, current truth not
a diary). The brief itself is not altered; the result is in `## Latest result` below.

Claude: execute Unit 8 as one bounded read-only discovery unit. Determine whether Darwin process
persona (`prsna`) can be a truthful per-run termination and verification boundary for literal Phase
1a. Return evidence and a verdict only. Do not create or change a persona, launch a fixture, signal a
process, request authority or prescribe an implementation.

**Governing sources and dispositions:** `## Objective and scope` and the current unattended-operation
plan govern. Unit 7's corrected result and Codex closure above are accepted: ASID is unusable under
current authority, its root-bearing form is unresolved, and the mechanism space is not exhausted.
Unit 6 governs the already-rejected real-GID route. The accepted escaped-descendant probe and current
`dispatch.sh`/`dispatch.test.sh` are verify-first repository claims. Deferral 8's observations about
`ps -axo prsna=` and `SYS_persona` are leads, not facts to inherit without checking.

**Named unknown:** does Darwin persona supply a unique, inherited, non-sheddable, externally readable
and race-safe run boundary that reaches a descendant after `setsid`, double fork, descriptor closure
and `exec`, while excluding uid-502 macOS services, uid-501 bystanders and concurrent runs?

**Claims to check:**

1. Inspect the complete relevant local manuals, SDK headers, exported symbols and available binaries
   for `prsna`, persona syscalls and persona-aware process creation. Establish what the displayed
   value means, whether it is a process attribute or a reporting proxy, its valid range and lifecycle,
   and which supported or private interfaces create, assign, query or change it. A symbol, syscall
   number or `ps` keyword alone is not effective availability.
2. Establish inheritance and mutability across `fork`, `posix_spawn`, `exec`, `setsid`, double fork,
   orphaning and a setuid-root exec. Identify the exact privilege, entitlement or membership rules
   for assigning or changing a persona. Determine whether an unprivileged descendant can shed the
   run's value, adopt another value or cause a child to do so. Bound helper inspection to paths that
   can affect persona; do not inventory unrelated privileged behavior.
3. Establish how an external unprivileged supervisor can enumerate or query arbitrary processes by
   persona and then signal and verify only matches. Look for a persona-scoped kernel selector or
   signal primitive before considering list-then-signal. If only PID enumeration exists, account for
   PID reuse, exit/change races, unreadable processes and fail-closed verification. Do not treat a
   readable `ps` column as proof that safe termination exists.
4. Test the boundary logically against the accepted escape and bystanders: the fully detached actor
   daemon after `exec`; uid-502 PPID-1 macOS services present before or launched during the run;
   uid-501 processes; two concurrent dispatcher runs in different checkouts; two runs in one
   checkout; value collision or reuse; supervisor/query failure; and a descendant attempting to
   shed or forge the value.
5. Distinguish a value that is empty on this host today from one reserved uniquely by design. State
   what authority would allocate it, whether allocation is atomic and collision-safe, and whether
   the actor or unrelated software can select the same value. Distinguish attended probe authority
   from unattended dispatcher authority; D4 remains unsolved and unauthorized.
6. Map any surviving candidate across every actor launch and controlled stop path in `dispatch.sh`,
   preserving the global deadline, interruption semantics, retry prohibition, lock pinning and
   cleanup, exit-code honesty, attended behavior and the no-bystander rule. This is a logical mapping,
   not an implementation design.
7. Return one verdict: **candidate ready for a separately authorized live probe**, naming every
   falsification condition and exact temporary authority; **candidate rejected**, naming the exact
   conflict with literal 1a; or **operator authority required**, only if the read-only evidence proves
   no further conclusion is possible without a privilege-bearing check. Do not turn an unresolved
   read-only question into an operator decision.

**Evidence:** list every manual, header, exported symbol, binary, repository file, official Apple
source file and read-only command used. Inspect local primary surfaces first. If exact semantics are
absent locally, Apple-published source may be used, but name the source version and its gap from the
running kernel. Separate observation from inference. Include a false-positive, false-negative and
race table covering claim 4; state every inspection failure; and show how each possible verdict could
have gone the other way. The evidence must be capable of rejecting persona, not just explaining it.

**Scope and stops:** this state file only. No Git inspection by Codex is needed; Claude may make the
single state-file commit required by the Work Loop. No `sudo`, signal, `launchctl` mutation, account
action, login, authentication, installation, C5, rollback, process/fixture launch, persona
creation/change, compilation, product edit, test run or new repository artifact. Do not inspect
credential contents. Preserve the live account and the accepted runbook/C5 fixture byte-for-byte.
Stages D/E, Phase 1f and every Phase 2 action remain forbidden. Stop and hand back if a premise fails,
the named unknown requires host mutation, or the required evidence cannot be produced read-only.

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

### Final tightly-bounded fix (2026-08-09) — both items applied, state file only

Result: the two items the menu froze are done. No new factual claim, no research, no host action, no
implementation, and no file other than this one was touched. The corrected verdict is unchanged.

```
Inspected (2026-08-09):
- Premise (1) "three later statements still assert without the current-authority boundary": HOLDS —
  searched this state file's `## Latest result` for the three propositions; found them carried at four
  locations, not three. (A) "no process can be put into a run-specific persona in the first place"
  under claim (3); (A again) "which claim 2 shows it cannot" opening § False positive, false negative
  and race; (B) "cannot be satisfied" under claim (4); (C) "none that the operator can obtain" under
  claim (5). All four were narrowed, because item 1 says "everywhere in the Unit 8 result".
- Premise (2) "the `Deferral 8's lead was half wrong` paragraph appears twice in succession": HOLDS —
  searched this state file for `Deferral 8's lead was half wrong`; found two consecutive paragraphs at
  the then-lines 355-361 and 363-369, separated only by a blank line.
```

Evidence — before and after, quoted:

- (A) claim (3), before: "**None of this is reached**, because claim 2's entitlement gate means no
  process can be put into a run-specific persona in the first place." After: "**None of this is
  reached under current authority**, because claim 2's entitlement gate means nothing the dispatcher
  currently runs can put a process into a run-specific persona: the gate is an entitlement check, and
  neither root nor attended `sudo -u` substitutes for it. Whether a supported operator-accessible
  signing or provisioning path could confer that entitlement is unresolved."
- (A) § False positive…, before: "Every 'correct' below is conditional on a run-specific persona
  existing, which claim 2 shows it cannot." After: "…which claim 2 shows cannot happen under current
  authority: nothing the dispatcher currently runs carries the entitlement, and neither root nor
  attended `sudo -u` substitutes for it, while whether the entitlement is obtainable at all is
  unresolved."
- (B) claim (4), before: "Every cell that says 'correct' is conditional on a premise that claim 2 shows
  cannot be satisfied." After: "…cannot be satisfied under current authority: nothing the dispatcher
  currently runs carries the entitlement, and neither root nor attended `sudo -u` substitutes for it.
  Whether the entitlement is obtainable through any supported operator-accessible signing or
  provisioning path is unresolved."
- (C) claim (5), before: "**Claim (5): the run-specific value cannot be reserved…** Allocation
  authority is `kpersona_alloc`, entitlement-only, so the answer to 'what authority would allocate it'
  is: none that the operator can obtain." After: "**Claim (5): under current authority the run-specific
  value cannot be reserved…** … is: none available under current authority — nothing the dispatcher
  currently runs carries the entitlement, and neither root nor attended `sudo -u` substitutes for it.
  Whether the operator could obtain that entitlement through a supported signing or provisioning path
  is unresolved." The claim label was narrowed with the body so the label does not assert what the body
  now denies; leaving it would have been a fresh inconsistency introduced by this fix.
- Verification that the unbounded forms are gone: searched this file for `cannot be satisfied`,
  `none that the operator can obtain`, `which claim 2 shows it cannot` and `run-specific persona in the
  first place`. **Outside this final-fix record**, exactly one match survives — the bounded
  `cannot be satisfied under current authority` under claim (4). The other three patterns return no
  match outside this record. Every remaining hit is a before-quotation inside the four bullets above,
  which the brief's own evidence requirement asked for; a search that ignores that distinction will
  count this record's quotations as if they were the statements themselves.
- Item 2, the duplicate: searched this file for the paragraph-opening form
  `**Deferral 8's lead was half wrong,`. **Exactly one match.** The duplicate paragraph is gone. The
  phrase also appears four times as a backtick-quoted reference inside this final-fix record; none of
  those opens a paragraph. The surviving paragraph preserves all four
  supported facts: `kpersona_pidinfo` returns `EPERM` to a non-root caller for any pid but its own;
  `/bin/ps` is `-rwsr-xr-x root wheel`, a shipped setuid-root helper that does the query with root
  privilege on the caller's behalf; the correction round's bounded entitlement scan also found that
  `/bin/ps` carries `com.apple.private.persona-mgmt`; and the practical `ps` query path therefore
  exists for an unprivileged supervisor.
- Nothing else changed: `git diff` on this file covers exactly those four narrowings, the merged
  paragraph, and one line rewrap inside claim (5) forced by the narrowing. No other file appears in the
  diff.

**This fix could have failed and would have shown it.** Each of the four searched patterns returns a
match outside this record if a narrowing was missed — and the first run of the check did exactly that,
which is how the claim (4) line was confirmed bounded rather than assumed. The paragraph-opening search
returns two matches if the merge had not removed the duplicate. Both checks were run after the edits,
not before.

**Candidate deferral, recorded and not done.** Two places still call the outcome "the rejection" — the
sentence introducing the case table, and the table's own row (k), which ends "This is the rejection."
The verdict "candidate rejected" was withdrawn at the correction round, so that wording is a leftover.
It is not among the two frozen items, so it was not touched. Whether to correct it is Codex's call.

### Unit 8 result (corrected, and now narrowed by the final fix)

**Unit 8 (Discovery, CORRECTED at the correction round) — Darwin persona is unusable under current
authority, and whether the entitlement it needs is obtainable is UNRESOLVED.** Read-only throughout.
No `sudo`, no signal, no `launchctl` mutation, no account action, no login, no authentication, no
installation, no C5, no rollback, no process or fixture launch, no persona created or changed, nothing
compiled, nothing signed, nothing executed under test, no product edit, no test run, and no repository
file other than this one. No credential contents were read. The live account was preserved untouched.
The correction added two read-only sources: `codesign -d --entitlements` metadata for 1,788 local
executables, and Apple's published XNU test entitlements.

**The verdict "candidate rejected" is WITHDRAWN and replaced.** The corrected verdict is:

- **Proved, and unchanged.** Nothing can be placed into a persona without the entitlement
  `com.apple.private.persona-mgmt`. Both doors carry the same check — `kpersona_alloc_syscall()`
  (creating one) and `spawn_validate_persona()` (spawning into an existing one) — and **neither has a
  superuser alternative**, while `GET`/`INFO`/`FIND` in the same file are gated `root || entitlement`.
  Root does not satisfy an entitlement check.
- **Proved, and unchanged.** Nothing the dispatcher runs carries that entitlement, so **under current
  authority persona cannot be used**, exactly as ASID could not.
- **UNRESOLVED — and previously overclaimed.** Whether the operator could obtain
  `com.apple.private.persona-mgmt` through a supported signing or provisioning path is **not
  established**. The earlier claim that the entitlement "can only be granted by Apple", that no
  operator-signable binary could carry it, and that disabling signature enforcement was the only
  theoretical route, rested on no inspection of macOS restricted-entitlement authorization,
  provisioning profiles, local or development signing, or AMFI's treatment of this key. **All of it is
  withdrawn.** Settling it would need a signed test binary actually run, which this correction forbids.

**Why the distinction is material rather than pedantic.** If the entitlement is unobtainable, persona
is dead. If it is obtainable by some supported path, persona becomes the **strongest candidate in this
task** — creation and spawn-into both become possible, and the properties in claim 2 make it a better
boundary than anything else examined. The verdict therefore turns on a question this unit did not
answer, and it is named as open rather than closed by assertion.

**Deferral 8's lead was half wrong, and the correction matters.** It recorded persona as "readable for
arbitrary processes without privilege — the property ASID lacks". The syscall is **not** unprivileged:
`kpersona_pidinfo` returns `EPERM` to a non-root caller for any pid but its own. The column is readable
only because **`/bin/ps` is setuid root** (`-rwsr-xr-x root wheel`, measured) and does the query with
root privilege on the caller's behalf — and, as the correction round's bounded entitlement scan found,
`/bin/ps` **also carries the persona-mgmt entitlement itself**. The practical conclusion survives — an
unprivileged supervisor *can* obtain the value by shelling out to `ps` — but the reason is a shipped
privileged helper, not an open syscall, and the brief was right to call the lead a lead.

Evidence: `sys/persona.h` and `bsd/kern/sys_persona.c`, `bsd/kern/kern_persona.c`, `bsd/kern/kern_exec.c`,
`bsd/kern/kern_fork.c` and `bsd/kern/syscalls.master` from Apple's published XNU; the active SDK's
`sys/syscall.h`, `sys/proc.h`, `sys/sysctl.h`, `spawn.h` and `libSystem.tbd`; `nm -u /bin/ps`;
`ls -l /bin/ps`; `ps -axo pid=,uid=,prsna=,comm=`; `man 1 ps`; the full `pgrep`/`pkill` usage; and
`dispatch.sh`. Each is quoted below. Each of the three possible verdicts is shown against what would
have had to be true for it, at the end.

### The correction round — findings 1 and 2

Both reproduced by inspection before either was corrected.

- **Finding 1: REPRODUCES.** The result said "Entitlements are granted by Apple in a binary's code
  signature … the operator cannot grant `com.apple.private.persona-mgmt` to `dispatch.sh`, to
  `claude`, or to `codex`", called disabling signature enforcement "the one theoretical route", and
  concluded "rejected for every authority in the operator's gift". The evidence list behind those
  sentences contains **no** inspection of restricted-entitlement authorization, provisioning profiles,
  local or development signing, or AMFI's handling of this key. The kernel gate was proved; the
  obtainability claim was assumed on the strength of the `com.apple.private.*` prefix.
- **Correction 1 — the obtainability claim is withdrawn and the verdict is narrowed**, in the replaced
  opening above. What the correction *did* establish, bounded and read-only:
  - **Apple's own XNU tests declare this key by ordinary means.** `tests/persona.entitlements` is a
    plain plist whose entire content is `com.apple.private.persona-mgmt` → `<true/>`, and
    `tests/Makefile` line 2053 applies it with `persona: CODE_SIGN_ENTITLEMENTS =
    persona.entitlements`. A second file, `tests/persona_adoption.entitlements`, adds
    `com.apple.private.persona.modify` and `com.apple.private.xpc.persona-manager`. **Disposition:**
    this shows the key is requested through the same `CODE_SIGN_ENTITLEMENTS` mechanism any developer
    uses — it does **not** show whether AMFI honours it on a SIP-enabled release Mac for a
    non-Apple signing identity. It cuts against the withdrawn claim without settling the question.
  - **On this host, only Apple platform binaries carry it** — five of 1,788 scanned, listed under
    claim 2 below. No third-party or operator-signed binary carries it. That is a real signal and is
    **not** proof of denial.
  - **What was not obtainable read-only.** Apple's developer documentation on restricted entitlements
    could not be retrieved as primary text this round; the one fetch attempted returned no page
    content, and a summariser's recollection is not evidence and was not used. No local list of
    AMFI-restricted keys was found. The decisive test — sign a binary with the key and see whether it
    runs — is exactly the compile/sign/execute probe this correction forbids.
  - Therefore the second branch the finding permits is taken: **narrow the verdict, leave obtainability
    unresolved.**
- **Finding 2: REPRODUCES, and the first binary checked disproved the claim.** The result asserted "no
  runtime interface by which a process can shed or switch it", "no persona-changing helper exists to
  exec" (table row (e)), and called the boundary "unsheddable" in the verdict, claim 2 and deferral 3.
  The brief had explicitly required a bounded helper inspection; **no entitlement or import inventory
  was run**. The absence of an in-place syscall proves only that the *current executable* cannot leave
  its persona — and `exec` replaces the executable together with its entitlements, so the claim never
  covered the case it needed to.
- **Correction 2 — the inventory the brief asked for, and every unsheddability claim narrowed to it.**
  Scanned with `codesign -d --entitlements -`: **1,788 executable files** across `/bin`, `/sbin`,
  `/usr/bin`, `/usr/sbin` and `/usr/libexec`. **Five carry `com.apple.private.persona-mgmt`**, and
  their persona API imports (`nm -u`) are measured, not assumed:

  | Binary | Mode | Persona API imported | What that permits |
  |---|---|---|---|
  | `/bin/ps` | `-rwsr-xr-x root wheel` | `_kpersona_pidinfo` | read a pid's persona; **no** create, no spawn |
  | `/sbin/launchd` | `-rwxr-xr-x root wheel` | `_posix_spawnattr_set_persona_np`, `…_uid_np`, `…_gid_np` | spawn into a persona — but it is PID 1, reached through its XPC interface, not by exec |
  | `/usr/bin/umtool` | `-rwxr-xr-x root wheel` | `_kpersona_find_by_type`, `_kpersona_getpath`, `_kpersona_info` | read only; **no** create, no spawn |
  | `/usr/libexec/keybagd` | `-rwxr-xr-x root wheel` | *(none)* | entitled but imports no persona API |
  | `/usr/libexec/usermanagerd` | `-rwxr-xr-x root wheel` | `_kpersona_alloc`, `_kpersona_palloc`, `_kpersona_dealloc`, `_kpersona_info`, `_kpersona_pidinfo` | **creates and destroys personas** — a system daemon, reached through its service interface |

  **What this establishes:** exec'ing an entitled binary runs *that binary's own code*, so an actor
  descendant gains nothing from `ps` or `umtool`, which only read. **What it does not establish:**
  whether `usermanagerd` or `launchd` can be *induced*, through their service interfaces, to place a
  caller-chosen process into a persona. That would need interface analysis well beyond a read-only
  inspection and was not attempted. **The bound is stated rather than glossed:** five directories,
  1,788 files. `/System/Library`, framework bundles, XPC services and `/Applications` were **not**
  scanned, so this is not a whole-host claim and no whole-host absence is asserted.
- **Does the verdict still follow without the unsheddability claim? Yes — because it never rested on
  it.** The blocking fact is that the dispatcher cannot *establish* the boundary: it can neither create
  a persona nor spawn into one, both entitlement-gated. Sheddability would matter only for a boundary
  that exists. If persona turned out to be sheddable through some induced daemon path, that would make
  it a **worse** candidate, not a viable one. So finding 2 removes a supporting property and a piece of
  the "best intrinsic properties" framing; it does not disturb the corrected verdict.

### Inspection record — the brief's verify-first premises

```
Inspected (2026-08-09):
- Premise (1) "deferral 8's `ps -axo prsna=` observation": HOLDS AS A MEASUREMENT, FAILS AS AN
  INFERENCE. Re-measured: 612 processes report `-`, seven report `1004`, one reports `99`. All eight
  are uid 501 and all eight are `.appex` app extensions (iCloudDriveFileProvider, csimporter,
  WeatherIntents, MobileTimerIntents, PAH_Extension, Notes SpotlightIndexExtension,
  QLPreviewGenerationExtension, WhatsApp ServiceExtension). The "without privilege" half is corrected
  in the result above.
- Premise (2) "`SYS_persona` in `sys/syscall.h`": HOLDS — searched the shipped header; line 534,
  `#define SYS_persona 494`. Corroborated in `bsd/kern/syscalls.master` line 774, which also shows it
  is compiled only `#if CONFIG_PERSONAS` and is declared `NO_SYSCALL_STUB`.
- Premise (3) "Unit 7's corrected result governs; the mechanism space is not exhausted": HOLDS as the
  accepted disposition, and this unit does not reopen ASID.
- Premise (4) "the escaped-descendant probe and current dispatcher are verify-first": HOLDS.
  `dispatch.sh` is 100,490 bytes with `actor_tree_census()` at line 684, `TERM_GRACE_SECS=5` at 795 and
  `KILL_SETTLE_SECS=2` at 796; `dispatch.test.sh` is 128,701 bytes; the probe
  `runs/probes/escaped-descendants-2026-08-07.sh` is 16,789 bytes. Searched both dispatcher files for
  `persona|prsna`: **zero matches**, so nothing in the product presupposes this unit's answer. Nothing
  was edited.
```

### The record — claims 1 to 7

- **Claim (1): `prsna` is a real process attribute, not a reporting proxy, and its entire interface is
  private.** `man 1 ps` line 305 lists the keyword as `prsna → persona`. `ps` obtains the value by
  calling the persona syscall: `nm -u /bin/ps` imports `_kpersona_pidinfo` (alongside `_proc_pidinfo`
  and `_sysctl`), and the binary's only persona-related strings are `prsna` and `PRSNA`. The kernel
  side is `SYS_persona 494`, nine operations defined in `bsd/sys/persona.h` lines 81-89:
  `PERSONA_OP_ALLOC`, `PALLOC`, `DEALLOC`, `GET`, `INFO`, `PIDINFO`, `FIND`, `GETPATH`,
  `FIND_BY_TYPE`. **Effective availability, checked rather than assumed from the symbol:** the SDK
  ships **no** `sys/persona.h` (`ls` → No such file or directory), and `spawn.h` contains no persona
  attribute; the nine `_kpersona_*` entry points and the four `_posix_spawnattr_set_persona_*_np`
  entry points are nonetheless exported by `libSystem.tbd`, so the route **links without a public
  header** — the same shape Unit 7 found for ASID. Lifecycle and type: `persona_type_t` is
  `PERSONA_INVALID 0, GUEST 1, MANAGED 2, PRIV 3, SYSTEM 4, SYSTEM_PROXY 6`, and
  `persona_is_adoption_allowed()` returns true only for `PERSONA_SYSTEM` and `PERSONA_SYSTEM_PROXY`.
  The observed population — every persona-carrying process on this host is an app extension — matches
  what the facility is for: it is the identity mechanism behind app extensions and containerised
  system services, not a general-purpose process grouping.
- **Claim (2): inheritance is exactly what a supervision boundary wants, and mutability is exactly
  what it wants too — this is persona's strong half.**
  - **Inherited across `fork`.** `bsd/kern/kern_fork.c` lines 1189-1197: `child_proc->p_persona =
    NULL; if (parent_proc->p_persona) { struct persona *persona = proc_persona_get(parent_proc); …
    error = persona_proc_adopt(child_proc, persona, NULL); }`. The child joins the parent's persona.
  - **Unaffected by `exec`, `setsid`, the double fork and orphaning.** The persona is held on the proc
    as `p->p_persona`, and none of those paths touches it. In XNU the only kernel-side removal is
    `persona_proc_drop()`, reached from the **exit** path (`kern_fork.c` line 811) — that is, when the
    process dies, which is precisely the event a stop wants to observe.
  - **CORRECTED — no *in-place* interface exists, which is narrower than "unsheddable".** The nine
    syscall operations contain **no operation that adopts, drops or changes the calling process's
    persona**. Adoption happens only at `posix_spawn` time, via `_posix_spawn_persona_info` →
    `spawn_validate_persona()` → `spawn_persona_adopt()` (`kern_exec.c` 3967-4046, 4534, 4977). So the
    **currently running executable** cannot leave its persona. **What that does not cover, and what was
    wrongly claimed:** `exec` replaces the executable *and its entitlements*, so an executable carrying
    `com.apple.private.persona-mgmt` could use the spawn path to put a descendant in another persona.
    The bounded inventory in the correction round finds five such binaries on this host; two of them
    (`launchd`, `usermanagerd`) touch creation or spawn, and whether either can be induced to do it for
    a caller was **not** established. So the honest form is: no in-place shed exists, and the
    exec-an-entitled-helper route is **unresolved within a bounded search**. The earlier flat
    comparison to Unit 6's `newgrp` — that "the shed would need an operation that does not exist" —
    is withdrawn.
  - **The privilege rules, quoted.** `kpersona_alloc_syscall`: `if
    (!IOCurrentTaskHasEntitlement(PERSONA_MGMT_ENTITLEMENT)) { return EPERM; }`. Same first line in
    `kpersona_dealloc_syscall`. `spawn_validate_persona()`, `kern_exec.c` line 3973: `if
    (!IOCurrentTaskHasEntitlement( PERSONA_MGMT_ENTITLEMENT)) {` — so **spawning into an existing
    persona is gated identically to creating one**. `PERSONA_MGMT_ENTITLEMENT` is defined at
    `bsd/sys/persona.h` line 91 as `"com.apple.private.persona-mgmt"`. **Note the asymmetry, because
    it is the whole verdict:** the *read* operations `GET`, `INFO` and `FIND` are gated
    `if (!kauth_cred_issuser(kauth_cred_get()) && !IOCurrentTaskHasEntitlement(...)) return EPERM;` —
    root **or** entitlement. `ALLOC`, `DEALLOC` and the spawn attribute are gated on the entitlement
    **alone, with no superuser alternative**.
- **Claim (3): an unprivileged supervisor can query, cannot select, and cannot signal by persona.**
  - **Query — possible, through a setuid-root helper.** `kpersona_pidinfo_syscall` is gated
    `if (!kauth_cred_issuser(kauth_cred_get()) && (pid != proc_getpid(current_proc()))) { return
    EPERM; }` — root for any pid but your own. That the column nevertheless works for an unprivileged
    caller is explained, not assumed: `/bin/ps` is `-rwsr-xr-x root wheel`, it imports `_getuid` but
    **no** `_setuid`/`_seteuid`/`_setgid`/`_setegid`, and it returned personas for eight pids none of
    which was the `ps` process itself. So `ps` performs the privileged read on the caller's behalf.
  - **Selection — no kernel-side primitive exists.** Searched in full: the `pgrep`/`pkill` usage
    carries exactly `-F -G -P -U -g -t -u`, no persona selector; `sys/sysctl.h` lines 432-439 give the
    complete `KERN_PROC_*` set (`ALL, PID, PGRP, SESSION, TTY, UID, RUID, LCID`) with no persona
    selector.
  - **Signal — none by persona.** Any design would therefore be `ps -axo pid=,prsna=`, filter, then
    `kill` per pid. Following Unit 7's correction, that is **not** by itself a disqualifier: `pkill -U`
    is the same list-then-signal shape, and it is the shape already contemplated. What it does mean is
    that PID reuse, exits between listing and signalling, and unreadable processes have to be handled
    by the design, and a failed or partial `ps` must produce `CENSUS_UNKNOWN` rather than "empty".
    **None of this is reached under current authority**, because claim 2's entitlement gate means
    nothing the dispatcher currently runs can put a process into a run-specific persona: the gate is an
    entitlement check, and neither root nor attended `sudo -u` substitutes for it. Whether a supported
    operator-accessible signing or provisioning path could confer that entitlement is unresolved.
- **Claim (4): the boundary logic is set out in the table below.** Its short form: had a run-specific
  persona existed, it would have excluded every bystander class correctly and reached the fully
  detached daemon — the first candidate in this task for which that is true on the evidence. Every
  cell that says "correct" is conditional on a premise that claim 2 shows cannot be satisfied under
  current authority: nothing the dispatcher currently runs carries the entitlement, and neither root
  nor attended `sudo -u` substitutes for it. Whether the entitlement is obtainable through any
  supported operator-accessible signing or provisioning path is unresolved.
- **Claim (5): under current authority the run-specific value cannot be reserved, and reusing an
  existing one is over-broad.**
  Allocation authority is `kpersona_alloc`, entitlement-only, so the answer to "what authority would
  allocate it" is: none available under current authority — nothing the dispatcher currently runs
  carries the entitlement, and neither root nor attended `sudo -u` substitutes for it. Whether the
  operator could obtain that entitlement through a supported signing or provisioning path is
  unresolved. Uniqueness and atomicity are therefore moot and are not claimed either way — the kernel
  does assign ids from its own table when
  `persona_id == PERSONA_ID_NONE`, but this unit did not establish collision behaviour and does not
  need to. **Reuse is separately fatal:** the two live values on this host are `1004`, shared by seven
  unrelated app extensions, and `99`, held by one — signalling either would kill unrelated Apple
  software, which is exactly the harm `## Objective and scope` forbids. And reuse is gated anyway,
  since `spawn_validate_persona()` requires the same entitlement. **Probe versus production authority
  is unchanged and is not the issue here:** operator-attended `sudo -u` exists and D4 remains unsolved
  and unauthorized, but no amount of either supplies an entitlement.
- **Claim (6): the logical mapping onto `dispatch.sh`, recorded and not reached.** A persona handle
  would have been the *cheapest* of any candidate to wire: `ps -axo pid=,prsna=` is a shell one-liner,
  where ASID would have needed a compiled helper against a private API. It would fit
  `actor_tree_census()`'s existing three-valued contract (found / none / `CENSUS_UNKNOWN`, returned
  through globals), add one `ps` call per pass without disturbing `TERM_GRACE_SECS=5` or
  `KILL_SETTLE_SECS=2`, need a fourth global published and cleared so the signal path can reach it,
  and widen `report_teardown()`'s scoped sentence, which `dispatch.test.sh` case 27h fails on so that
  the change would have to be deliberate. Retained as a description of where a future boundary must
  fit. Neither dispatcher file mentions persona today (searched; zero matches), so nothing regresses.
- **Claim (7): CORRECTED — persona is unusable under current authority, and its obtainability question
  is named rather than closed.** "Candidate rejected" is withdrawn. Not "ready for a probe" either: no
  probe is runnable today, because nothing the dispatcher runs carries the entitlement and no root
  grant supplies one. And **not "operator authority required"** — that verdict would assert the open
  question can only be settled by a privilege-bearing check, which this unit has not shown. The
  accurate statement is that one bounded, read-only question remains and was not answered here:
  whether `com.apple.private.persona-mgmt` can be authorized through any supported signing or
  provisioning path available to the operator. Until that is settled, persona is neither viable nor
  rejected. Whether it is worth a further unit is Codex's call.

### False positive, false negative and race, by case

Every "correct" below is conditional on a run-specific persona existing, which claim 2 shows cannot
happen under current authority: nothing the dispatcher currently runs carries the entitlement, and
neither root nor attended `sudo -u` substitutes for it, while whether the entitlement is obtainable at
all is unresolved. The table is what the boundary *would* have done, and it is the reason the rejection
is narrow and specific rather than dismissive.

| Case | Real GID (Unit 6, rejected) | ASID (Unit 7, unusable) | Persona (this unit) |
|---|---|---|---|
| (a) uid-502 service present at baseline | correct exclusion | correct exclusion | **correct exclusion** — launchd starts it with no persona (`-`) |
| (b) uid-502 service launched during the run | correct exclusion | correct exclusion | **correct exclusion** — same reason; nothing inherits a persona it was not spawned into |
| (c) uid-501 bystander | correct exclusion | correct exclusion | **correct exclusion** — unless it is an app extension, which carries `1004`/`99`, not a run value |
| (d) fully detached daemon: `setsid`, double fork, descriptors closed, `exec` | reached, then **shed via `newgrp`** | reached | reached; **no in-place shed exists** — no syscall operation leaves a persona |
| (e) descendant execs an entitled helper | **FALSE NEGATIVE — decisive** (`newgrp`) | correctly excluded (`login`/`su` authenticate) | **UNRESOLVED** — five entitled binaries found in the five scanned directories; `ps`/`umtool` only read, but whether `launchd` or `usermanagerd` can be induced to spawn into a persona for a caller was not established |
| (f) two concurrent runs, different checkouts | not applicable | not applicable | **correct separation** — if each run could allocate its own value |
| (g) two concurrent runs, one checkout | not applicable | not applicable | **correct separation** — same condition |
| (h) value collision or reuse of a live system value | not applicable | not applicable | **FALSE POSITIVE** — reusing `1004` would signal seven unrelated app extensions |
| (i) supervisor cannot read a process | must be `CENSUS_UNKNOWN` | always fails (no unprivileged read) | must be `CENSUS_UNKNOWN`; `ps` failing partially must not read as "empty" |
| (j) PID reuse between listing and signalling | present, as for `pkill -U` | present | present — same list-then-signal window, not a discriminator |
| (k) the supervisor tries to create the run boundary | permitted | **needs root** | **NOT POSSIBLE — needs `com.apple.private.persona-mgmt`; root does not satisfy it.** This is the rejection. |

### Inspection failures, stated rather than read as absence

- **`ps` reporting `-` cannot be distinguished from `ps` failing to read.** Every non-empty value
  observed belongs to a uid-501 process. Whether a root-owned process shows `-` because it has no
  persona or because the read failed was not established, and could not be without running a probe.
  For a fail-closed design this is the first thing that would need settling; it is moot under the
  verdict.
- **Nothing was executed to observe persona behaviour.** No persona was created, no process was
  spawned into one, and no shed was attempted. Inheritance, non-sheddability and the entitlement gates
  are read from Apple's source, not measured on this machine.
- **Source version gap, stated as the brief requires.** All XNU quotations are from tag
  `xnu-12377.121.6`, the newest published release. This host runs `xnu-12377.121.10~1` (`uname -v`) —
  the same 12377.121 series, differing at the patch level; Apple has not published `.121.10`. As in
  Unit 7, `main` and the tag were both fetched for the audit files and were byte-identical, but the
  persona files were taken from the tag directly and no second copy was diffed against them.
- **`CONFIG_PERSONAS` is a build option** (`syscalls.master` line 773). It is plainly enabled here,
  since live processes carry personas, but the syscall's availability was inferred from that
  observation rather than from a build manifest.
- **No local manual page documents any persona interface.** `man 1 ps` names the keyword and nothing
  else; there is no `man 2 persona` and no `kpersona` manual on this host.

### How each verdict could have gone the other way

- **"Candidate ready for a probe" would have required the entitlement gate to have a superuser
  alternative.** It very nearly does elsewhere in the same file: `GET`, `INFO` and `FIND` are written
  `!issuser && !entitlement`, and had `ALLOC` and `spawn_validate_persona` been written the same way,
  persona would have been the strongest candidate in this task — inherited, no in-place shed, externally
  readable, cheap to wire — and the unit would have ended by naming what a root-bearing probe must
  falsify. Both are entitlement-only. That single missing `||` is the whole difference.
- **"Candidate rejected" would have held had the entitlement been shown unobtainable.** It was not
  shown. The correction round found the opposite kind of evidence pointing both ways: only Apple
  platform binaries carry the key among the 1,788 scanned, which suggests denial; but Apple's own XNU
  tests request it through the ordinary `CODE_SIGN_ENTITLEMENTS` mechanism, which is what any developer
  uses. Neither settles it, and the deciding test is forbidden here.
- **"Operator authority required" would have required this to be a privilege question.** It is not.
  The open question is whether a *signing or provisioning path* exists, which is answerable read-only
  by someone with the right primary documentation — so escalating it to the operator now would turn an
  unresolved read-only question into a decision, which the brief forbids.
- **The whole unit would have collapsed had `ps -axo prsna=` proved unprivileged at the syscall
  level**, since that was deferral 8's premise. It went the other way: `kpersona_pidinfo` is
  root-gated, and `/bin/ps` is both setuid root and entitled.

### Deferrals — carried forward and newly recorded

None is implemented. Items 1-7 are carried from Units 4 and 6. Item 8 is **partly discharged**. Items
9-10 are carried from Unit 7. Item 11 was recorded by the unit; items 12 and 13 by the correction
round, which is why they are recorded rather than worked.

1. **The plist count is inconsistent.** Unit 5's result said `/System/Library/LaunchAgents` held 465
   plists; a later bounded count returned 456. It affects no mechanism verdict. Correct it only if a
   later unit needs that inventory.
2. **This state file is long and grows every unit**, against core § 4's "current truth, not a diary".
   This unit replaced the previous result rather than appending and removed the Unit 7 brief as
   prior-unit history; the accepted artifacts are untouched. Further reduction is an assessment
   decision.
3. **No audit exists of the host's privileged helpers that can change a process's own credentials.**
   Partly discharged in Unit 7 for audit credentials. **The persona claim here is corrected:** the
   earlier wording — "no helper can change a persona because no interface to change one exists at all"
   — is withdrawn. The correction round's bounded inventory found five entitled binaries, two of which
   touch persona creation or spawn. The general question remains open for every credential class, and
   is now known to need an *entitlement* inventory and not only a setuid one.
4. **The uid-502 census fell 9 → 5 → 3 with no signal.** Re-measured this unit at 15:33 EEST and
   **still 3**, same services, same 10:11:27 start times. Recorded because it was measured; not pursued.
5. **Codex has no actor-owned bootstrap.** Every Codex command still runs
   `/Applications/ChatGPT.app/Contents/Resources/codex` — a dependency on the operator's application
   bundle. Acceptable for a temporary Stage C probe, not as steady state. D/E territory.
6. **Every actor command in the runbook goes through the operator's `sudo`.** A real dispatcher cannot
   use the operator's sudo credential, so the run-as route for production is still unsolved. It is the
   D4 narrow-privilege question, which is unauthorized.
7. **C3b and C4b spend a little of the actor's own quota.** The only checks in the runbook with an
   external cost. Worth the operator knowing before they run it; not a defect.
8. **PARTLY DISCHARGED — persona's mechanics are established; its obtainability is not.** This unit
   settles inheritance, in-place mutability, query and signalling, and proves the entitlement gate.
   What remains open, after the correction round withdrew the claim that it was closed, is whether
   `com.apple.private.persona-mgmt` is obtainable through a supported operator-accessible signing or
   provisioning path. Persona is therefore no longer an *unexamined* attribute, but it is not a closed
   one either.
9. **The `/dev/auditsessions` lifecycle stream was not evaluated as a *verification* aid.**
   `AUE_SESSION_END` means "all the processes in the session have exited", which is what a truthful
   teardown wants — but it needs `AU_SDEVF_ALLSESSIONS`, marked "(Requires privilege.)" in the header,
   and it verifies rather than terminates. Recorded in case a future root-bearing design revisits it.
10. **Nothing in this task pins where a primary-source claim about kernel behaviour may come from.**
    Recorded in Unit 7; this unit read Apple's published source over the network a second time, again
    because the brief directed it, and again the copies live outside the repository in session scratch.
    The recurrence is worth noting: it is now the normal way this task establishes kernel semantics,
    with no stated rule. Still a workflow question, not a Phase 1a mechanism question.
11. **`/bin/ps` is being relied on as a privileged read path, and nothing records that.** The persona
    column works only because a setuid-root system binary performs a root-gated syscall for an
    unprivileged caller. Any future boundary that reads a privileged attribute by shelling out to `ps`
    inherits a dependency on that binary keeping its setuid bit and its behaviour — the same class of
    shipped-helper dependency that killed the real-GID route in Unit 6, pointing the other way. Not
    pursued: no such boundary currently exists.
12. **Whether `com.apple.private.persona-mgmt` is obtainable is the open question this unit leaves.**
    Named here so it is not lost: settling it needs macOS restricted-entitlement authorization,
    provisioning-profile support and AMFI's treatment of this exact key, from primary documentation —
    and, to be conclusive, a signed binary actually run, which every scope so far forbids. Not worked:
    the correction scope is frozen to findings 1 and 2, and this is the residue one of them leaves.
13. **Two entitled system daemons were not analysed for an induced-spawn path.** `usermanagerd`
    imports `_kpersona_alloc`/`_palloc`/`_dealloc` and `launchd` imports the persona spawn attributes.
    Whether either can be driven, through its service interface, to place a caller-chosen process into
    a persona is unknown. It matters for the escape question rather than for the verdict, and interface
    analysis is far outside a read-only bounded inspection. Recorded, not started.

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

**Every candidate named so far has been examined, and none is usable under current authority.** That
is a statement about the search to date, not a proof that the space is empty. The closed supervision
discovery excluded process group, ancestry-at-stop, environment tag, working directory,
`kqueue NOTE_TRACK`, launchd job removal, Darwin `ptrace`, containers and coalitions. Unit 5 excluded
the pattern-free UID signal as over-broad. Unit 6 excluded the real GID as sheddable through
setuid-root `newgrp`. Unit 7 found the audit session unusable under current authority, with its
root-bearing form unassessed. Unit 8 finds persona unusable under current authority — nothing the
dispatcher runs carries `com.apple.private.persona-mgmt`, and root does not supply it.

**Two mechanism questions are open, and neither is closed by assertion.** Unit 7 left ASID's
root-bearing form unassessed. Unit 8's correction leaves persona's entitlement **obtainability**
unresolved: whether any supported operator-accessible signing or provisioning path can authorize
`com.apple.private.persona-mgmt` was not established, and the evidence found this round points both
ways — only Apple platform binaries carry the key among the 1,788 scanned, yet Apple's own XNU tests
request it through the ordinary `CODE_SIGN_ENTITLEMENTS` mechanism. If it is obtainable, persona
becomes the strongest candidate in this task; if it is not, persona is dead. That question is
read-only and was not answered here.

**One escape question is open too.** Whether an actor descendant could exec an entitled helper to
leave or change its persona is unresolved within a bounded search: five entitled binaries exist in the
five directories scanned, `ps` and `umtool` only read, and `launchd` and `usermanagerd` were not
analysed for an induced-spawn path. This bears on how good persona would be if it were usable at all;
it does not affect the current-authority finding.

**The dispatcher's current reach is unchanged and is the honest fallback position.** The
inherited-descriptor handle in `dispatch.sh` reaches further than any candidate examined, and
`dispatch.test.sh` case 27h pins the surviving hole: a descendant that closes every inherited
descriptor still survives it. That hole is exactly literal 1a's escaped shape.

**What comes next is not asserted here.** Whether to spend a unit on persona's obtainability, on
ASID's root-bearing form, or on neither, is Codex's assessment; anything that turns out to need new
authority is the operator's decision. **Restating what literal 1a guarantees is not among the
options** — `## Objective and scope` records that the operator preserved that guarantee on 2026-08-08.

**Attended probe authority and unattended production authority remain distinct.** Operator-attended
`sudo -u` does not give the dispatcher production authority; D4 stays unauthorized and outside this
unit. Neither authority supplies a code-signing entitlement, which is why persona's remaining question
is about signing paths rather than about privilege.

**The account stays untouched.** Re-measured at the Unit 8 close, 2026-08-09 15:33 EEST, and unchanged
from the two Unit 7 readings: `id -u wlactor-airesources` → 502, `dseditgroup -o checkmember … admin`
→ "is NOT a member of admin", and the uid-502 census is still the same three PPID-1 services — 82525
`distnoted`, 82526 `mdbulkimport`, 82530 `lsd` — all `rgid 20`, all carrying their original 10:11:27
start time. It remains a password-bearing login account with `/bin/zsh`, the operator's home is
`drwxr-xr-x+`, and actor reach into the operator home is unresolved before D. No process emergency
requires a signal. Rollback R1 has not been reachable at any observation, so removal needs a separately
verified procedure. Nothing may signal, delete, log into or authenticate uid 502 in the meantime. C5 as
written stays unrunnable, and C1 and every later Stage C step stay stopped.

## Next action

Codex: run the closure check on the final tightly-bounded fix, and on nothing else. The two questions
are the only ones in scope — are the two frozen items resolved, and did the fix break anything?

1. **Item 1 — the narrowing.** Every location in the Unit 8 result that asserted the three propositions
   is now bounded to current authority. There were four locations carrying the three propositions, not
   three; all four were narrowed, on the reading that "everywhere in the Unit 8 result" governs. The
   before/after text and the search patterns are quoted in `## Latest result`.
2. **Item 2 — the duplicate paragraph.** One paragraph remains, carrying all four supported facts. The
   phrase's other occurrences in the file are backtick-quoted references inside the final-fix record,
   not duplicate result paragraphs.

One item is recorded as a candidate deferral and was **not** done: two places still call the outcome
"the rejection" — the sentence introducing the case table, and row (k) of that table — although the
"candidate rejected" verdict was withdrawn. It falls outside the two frozen items. Whether to correct
it is Codex's call at this closure check.

Nothing else changed. No new factual claim, no research, no implementation, no host action, and no file
other than this state file. The corrected verdict is unchanged, and entitlement obtainability was not
answered.

All safety and scope constraints remain unchanged. Do not signal any process; do not delete, log into,
authenticate, or otherwise mutate `wlactor-airesources` (uid 502); do not launch Claude, the dispatcher,
C5 or rollback; do not run a probe; and do not enter Stages D/E, Phase 1f or any Phase 2 action.
