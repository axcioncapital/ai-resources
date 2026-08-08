---
task: work-loop-v2-phase1a-full-descendant-termination
turn: operator
---

## Objective and scope

Close Phase 1 item 1a as it is currently written: every controlled stop of the dispatcher must
terminate and verify the actor's full descendant tree, including a descendant that calls `setsid`,
double-forks, closes every inherited descriptor and `exec`s another program. A stop must not signal
an unrelated process, and it must never claim success when termination or verification is incomplete.

The task closes only after the guarantee is implemented and supported by fail-capable simulated
regression evidence plus effective live Darwin evidence for the process boundary the harness cannot
establish. Phase 1f and every Phase 2 action remain outside this task; Phase 2 stays forbidden.

## Lane and unit

Standard. Implementation mode. Unit 1 — establish and implement the smallest evidence-backed actor
ownership boundary that can retain and terminate a fully detached descendant.

Named reason for the loop: this is a safety-critical dispatcher change whose scope must remain
bounded, whose result needs independent assessment, and whose central claim cannot be established by
the simulated harness alone.

Plan justification: the current implementation plan keeps 1a open because the fully detached daemon
survives, and it forbids Phase 2 until 1a and 1f close. The accepted supervision discovery found no
mechanism within the present authority and identified a dedicated actor OS identity as the smallest
authority-change route that preserves the literal guarantee. This unit addresses that nearest unmet
1a condition and holds 1f back.

Codex framing decision: the operator's instruction to resolve Phase 1a is read literally, so this
unit preserves full-descendant termination rather than replacing it with reachable-tree termination
plus containment. The discovery's containment option is excluded because it changes the guarantee,
does not stop CPU or memory consumption, and would not close 1a as the plan currently states. This
framing does not authorize host mutation: creating or deleting macOS accounts, changing sudo policy,
or altering root-managed launchd or system configuration remains operator-owned.

## Brief

This is the remaining termination gap that blocks an unattended pilot. The current dispatcher
truthfully clears everything reachable through its process-group, ancestry and private-descriptor
handles, but the accepted live Darwin evidence shows that a conventional fully detached daemon still
outlives the stop. This unit must replace that residual with a true ownership boundary, without
weakening the deadline, stop semantics or existing guards.

### Governing sources and dispositions

- **Current operator objective:** resolve Phase 1a as currently written and prepare this unit through
  Work Loop v2. It governs the outcome; it does not grant unspoken authority to mutate macOS system
  state.
- **Governing implementation plan:**
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, especially the implementation-status
  block, Phase 1 § 1a, the Phase 2 prohibition and Sequencing. Treat its final sentence that “no
  questions remain open for the operator” as superseded for 1a by the later accepted discovery below;
  the same plan's § 1a already says creation-time supervision needs new authority.
- **Authoritative current state:**
  `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md`. Its accepted result is that no
  present-authority mechanism terminates the fully detached shape. It names a dedicated actor OS
  user/UID as the smallest guarantee-preserving authority change and records why containment is only
  a scope-change alternative.
- **Accepted predecessor result:**
  `logs/work-loop/work-loop-v2-escaped-descendant-termination.md`. Commit `7aaae68` and the recorded
  368/0 suite are the current reachable-tree baseline, not proof of full-tree termination.
- **Effective process evidence:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/probe-escaped-descendants-2026-08-07.md`
  and `runs/probe-interruption-2026-08-07.md`. They establish the surviving daemon shape, the
  bystander risk of working-directory discovery, and the four controlled stop paths that must keep
  one teardown contract.
- **Repository objects to change:**
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `dispatch.test.sh` and `README.md`.
  Inspect their current versions rather than inheriting line numbers or mechanism descriptions from
  this brief.
- **Workflow contract:** `.agents/skills/work-loop-v2/SKILL.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. Verify premises first, keep scope and
  success criteria explicit, and require evidence that can fail.

### Required outcome

1. Select the exact supervision and privilege mechanism only after inspecting the live repository,
   the accepted discovery and the host capabilities available to the dispatcher. The allowed
   direction is an exclusive actor ownership boundary established at creation, with a dedicated
   actor identity/UID as the discovery-backed candidate. This brief does not prescribe a CLI shape,
   helper layout, command sequence or privilege implementation.
2. Before product edits, establish that the selected boundary can both launch the actual actor and
   let the dispatcher terminate and verify every process owned by that run after the actor performs
   the full detach. It must not confuse the operator's processes, another dispatcher or a bystander
   with the actor's descendants.
3. If the boundary is not configured or cannot be verified, fail closed before launching an actor.
   Never fall back silently to the current three-handle reach while advertising Phase 1a as closed.
   Never use the operator's ordinary UID as the kill boundary.
4. Apply one termination contract across every controlled stop path the dispatcher currently uses:
   `SIGTERM`, `SIGINT`, per-actor timeout (`21`) and global deadline (`29`). Preserve the existing
   distinction between interruption, actor timeout and budget exhaustion.
5. TERM first, KILL after the existing grace policy when needed, then verify the full ownership
   boundary is empty before releasing the task lock or printing success. A known survivor or an
   inability to inspect must remain explicit and must pin the lock rather than admit a second
   dispatcher.
6. Preserve the global deadline as a real whole-run bound. Re-derive and disclose its worst-case
   overrun if the selected supervisor changes teardown latency; do not silently widen the bound.
7. Preserve all interruption and retry rules: a stopped or timed-out actor is never retried; one
   retry remains limited to a failed actor that provably changed nothing; partial effects still stop
   for inspection.
8. Preserve existing exit codes, exact-task locking, state validation, allowlist checks, committed-
   path checks, Git hazard guards, `--status` three-state honesty, contained `--unattended` policy,
   attended and courier behavior, and the dispatcher’s single-task/single-checkout boundary unless
   the evidence proves a narrow change is necessary. Report any required contract change instead of
   applying it quietly.
9. Keep the current reachable-tree protections unless the new ownership boundary makes one
   demonstrably redundant and removing it has its own fail-capable evidence. Do not trade a proven
   safety layer for an assumed supervisor.
10. Update the plan and operator-facing README only to match behavior actually implemented and
    proved. Remove the 1a blocker or the Phase 2 prohibition only after effective live evidence has
    established full-descendant termination. Do not begin or simulate Phase 2.

### Check before acting

1. Confirm the plan still states that 1a requires the actor's full descendant tree and that Phase 2
   is forbidden while 1a remains open.
2. Confirm the two predecessor state files are closed at `turn: operator`, and reproduce their
   present conclusion by inspecting the cited evidence: the fully detached daemon survives while an
   unrelated bystander must survive too.
3. Confirm the dispatcher still routes all four controlled stop paths through the current teardown,
   and identify every launch path that the new ownership boundary would have to cover, including
   Codex, Claude, contained unattended hops and the simulated test seam.
4. Confirm the shipping harness baseline and record its exact pass/fail total and exit status before
   edits. Separate any pre-existing failure from a regression.
5. Confirm no overlapping uncommitted change exists in any allowed product or evidence path. Hand
   back rather than overwrite concurrent work.
6. Confirm, with read-only inspection first, whether a suitable dedicated actor identity and the
   necessary non-interactive launch/termination authority already exist on this host. Do not create
   them. If they do not exist, or if checking them requires operator authorization, stop at
   `turn: operator` with the smallest exact host action and the risk it introduces.
7. Confirm the chosen boundary works for the real binaries and authentication/configuration they
   need without reopening home access, credentials, network, push or other authority settled by 1d.
   If those requirements conflict, hand back the conflict rather than weakening either safety rule.

### Required evidence

Evidence must be able to fail and must keep simulated controller evidence separate from effective OS
evidence.

- Build the failing case first from the existing fully detached shape: double fork, `setsid`, close
  every inherited descriptor, then `exec` a SIP-protected system binary. Against the pre-change
  dispatcher it must remain alive after the stop; against the implemented boundary it must be gone.
- Exercise that shape separately through `SIGTERM`, `SIGINT`, actor timeout `21` and deadline `29`.
  Each case must assert the pre-stop escape is real, the expected exit code is unchanged, the actor
  and fully detached descendant are gone, and the lock ordering is correct.
- Add a negative control proving an unrelated process survives. The control must be outside the
  selected actor ownership boundary while sharing any broad property that could cause overreach,
  such as the checkout, working directory or public hop log.
- Add a fail-closed case for every material supervisor precondition: boundary absent, identity wrong,
  launch authority unavailable, termination authority unavailable and verification unavailable.
  Each must prove no actor was launched and no success claim was printed.
- Preserve or replace the existing degraded-discovery and pinned-lock cases with equal or stronger
  coverage. A change that makes the old 27h “survivor expected” assertion obsolete must invert it,
  not delete the escape shape.
- Prove the mechanism covers the real actor launch path rather than only a hand-built stand-in.
  The effective Darwin check must invoke `dispatch.sh` itself, create a fully detached descendant
  from the launched actor boundary, stop the dispatcher, observe the descendant gone from the OS,
  observe the unrelated control alive, and self-clean on success or failure. If the real model
  refuses to create the fixture, use the narrowest non-model live actor path that still exercises
  the product's actual supervisor and label exactly what it does and does not prove.
- Run the full simulated suite last and report totals and exit status. Show a matched pre-change
  witness for the change-specific assertions, not only a green final suite.
- Re-read the changed source, README, plan and evidence files from the filesystem. Verify every
  public claim matches the effective result, including deadline cost and whether Phase 1a may now be
  called complete.

### Scope and stop conditions

Allowed repository paths:

- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.test.sh`
- `plans/work-loop-v2-v0.2/handoff-automation-spike/README.md`
- the minimum necessary new or updated Phase 1a probe script, raw capture and dated evidence record
  under `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/`
- `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`
- `.agents/skills/work-loop-v2/SKILL.md` only if the proven operator launch contract changes
- this state file

Excluded: creating or deleting a macOS user; modifying sudoers, launchd configuration, managed
settings or other host policy; weakening 1a to containment; changing the settled unattended
authority profile; Phase 1f; every Phase 2 launch or action; push, merge, deployment, installation,
production graduation, parallel operation, and unrelated cleanup or documentation.

Stop and hand back if a premise is false; the dedicated ownership boundary is not available or
cannot be made exclusive; the actual actors cannot run inside it; termination needs host authority
the operator has not granted; the mechanism risks signalling bystanders; a full-tree result cannot
be verified; correct work needs an excluded path or host mutation; the deadline, exit codes, retry
prohibitions or lock invariant cannot be preserved; evidence cannot expose the old survivor; an
allowed path has overlapping work; or any consequential decision about scope, authority or risk
remains.

Unit completion: Claude commits only allowed repository paths by explicit pathspec, reports every
premise disposition and all fail-capable evidence in `## Latest result`, states whether effective
live proof closed 1a or which exact task exit condition remains, sets `turn: codex`, and stops for
independent assessment. Do not push.

## Latest result

Inspected (2026-08-08):

- Claim (1): HOLDS — read `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`; § 1a's
  second-round note states the objective "says the actor's *full descendant tree*" and withdraws the
  earlier narrowing, and the implementation-status block's "Phase 2 blockers" table lists exactly two
  entries — 1a and 1f — with Phase 2 recorded `BLOCKED`.
- Claim (2): HOLDS — `logs/work-loop/work-loop-v2-escaped-descendant-termination.md` and
  `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` both open `turn: operator`. Their
  conclusion reproduced from the cited evidence, not inherited: in
  `runs/probe-escaped-descendants-2026-08-07.md`, `DETACHED DAEMON : ALIVE` after the dispatcher
  exited, `unrelated tail -f : ALIVE`, handle 6's verdict "REACHES THE BYSTANDER — unusable as a kill
  list", and the public hop log held by `[60347] <- a bystander, and NOT a descendant`.
- Claim (3): HOLDS — searched `dispatch.sh` for `terminate_actor_tree` / `report_teardown`: exactly
  two call sites, `on_signal()` (918/922, with `trap` registrations at 938–940 covering `INT` and
  `TERM`) and `run_bounded()` (1478/1482, which carries the per-actor timeout `21` and the deadline
  `29`). Line numbers re-read from the current file, not inherited. Launch paths the new boundary
  would have to cover, from `launch_actor()` (1554–1644): the simulated `--actor-cmd` seam via
  `bash -c` (1563); live `codex exec --sandbox workspace-write` (1573); live attended `claude` (1637);
  live `claude` narrowed by `--claude-deny` (1633); and the contained `--unattended` hop using the
  generated profile (1624). All five funnel through `run_bounded`.
- Claim (4): NOT REACHED — the brief specifies the harness baseline "before edits". Claim (6) failed,
  so no edit occurs and no baseline was taken. Recorded as not run rather than assumed; the last
  recorded figure remains 368 pass / 0 fail at `7aaae68`, from the predecessor state file, and was
  deliberately not re-measured here.
- Claim (5): HOLDS — `git status --short` over every allowed path returns no modification to
  `dispatch.sh`, `dispatch.test.sh`, `README.md`, `unattended-operation-plan-v0.2.md` or
  `.agents/skills/work-loop-v2/SKILL.md`. Two untracked files under `runs/`
  (`20260807T115343-project-progression-candidate-review-correction.log`,
  `20260807T201627-work-loop-v2-proportionality-continuity-implementation.log`) are dispatcher run
  logs belonging to other tasks, not Phase 1a probe artifacts; untouched. This state file is untracked,
  as expected for a task Codex has just opened.
- Claim (6): FALSE — searched the local directory node with `dscl . -list /Users UniqueID` filtered to
  uid ≥ 500: exactly two accounts exist, `patrik.lindeberg` (501) and `com.malwarebytes.mbam.nobody`
  (1000, a vendor-managed service account). **No dedicated actor identity exists on this host.** `id`
  confirms the dispatcher runs as uid 501 — the operator's ordinary UID, which required outcome 3
  forbids as the kill boundary. The non-interactive launch and termination authority could not be
  inspected either: the read-only `sudo -n -l` check was refused at the tool-permission layer in this
  session, which is exactly check (6)'s "checking them requires operator authorization" condition. It
  was not retried by another route.
- Claim (7): NOT REACHED — it asks whether the selected boundary can run the real binaries with their
  authentication without reopening authority settled by 1d. There is no boundary to test. The
  requirement it protects is carried into the risk statement below rather than discarded.

Result: the unit did not begin. Its central premise — that an exclusive actor ownership boundary is
available within the stated authority — is false on this host, and every route to making it true is
inside the brief's own excluded list (creating a macOS user, modifying sudoers or host policy). No
product file was changed; `dispatch.sh`, `dispatch.test.sh`, `README.md`, the plan and `SKILL.md` are
byte-identical to `HEAD`. Phase 1a stays open, and Phase 2 stays forbidden.

Evidence that could have read differently: had any third account existed, or had the sudo check
returned a usable non-interactive rule, claim (6) would have held and this unit would have proceeded
to the baseline and the implementation. The account enumeration is the failing case — it returns the
operator's own uid and one vendor service account, and nothing else.

## Blocker

**Claim (6) is false. The ownership boundary this unit is built on does not exist, and creating it is
excluded by the brief's own scope.**

The brief's allowed direction is an exclusive actor ownership boundary established at creation, with a
dedicated actor identity/UID as the candidate. This host has one real account — the operator's, uid
501 — which required outcome 3 explicitly forbids using as the kill boundary. The only remaining
account is a vendor service account that is not the dispatcher's to appropriate. Creating an account,
and granting the non-interactive `sudo -u` launch and `pkill -U` termination rights it would need, are
both host-policy mutations the brief excludes and that core § 7 sends to the operator as hard to
reverse.

This is the outcome the brief's verify-first framing anticipated, not a surprise: the accepted
discovery already recorded the dedicated OS user as an **authority change**, deliberately never probed.

## Next action

**Operator decision. No product change was made and none may be made until this is settled.**

The smallest exact host action that would let this unit proceed as written — stated so it can be
judged, not as a recommendation, and deliberately not performed:

1. Create one dedicated, non-admin local account for the actor, with no interactive login and no GUI
   login.
2. Grant uid 501 exactly two non-interactive privileges against that account and nothing else: launch
   a process as it, and terminate processes owned by it.

The risks that action introduces, which are the operator's to accept or refuse:

- **It is host-policy mutation, not repository work**, and it is hard to reverse cleanly. Account and
  privilege-policy state is not carried in this repository or in Git.
- **A rule permitting "run a process as the actor" is a privilege-escalation surface.** Anything on
  this machine that can invoke it can execute arbitrary code under that identity. A rule permitting
  "terminate that identity's processes" is a smaller but real denial surface.
- **It collides with the authority settled by 1d, and that collision is unresolved.** The actor needs
  the checkout, plus Claude and Codex authentication and configuration, which live under the
  operator's home directory. A second uid can only reach them by loosening home permissions or by
  duplicating credentials. The first widens exactly what 1d's profile was built to deny; the second
  creates a second copy of live credentials. Check (7) exists to catch this, and it cannot be resolved
  without the operator.
- **A second user's processes may meet different macOS privacy prompts (TCC)**, which an unattended run
  cannot answer.

If the operator refuses the authority change, the alternative is not another attempt at this unit:
it is the scope-change option the discovery already recorded — restate 1a as reachable-tree
termination plus containment — and that is a change to the guarantee, so it is equally the operator's
call. Codex framed this unit around the literal guarantee specifically to avoid making that choice on
the operator's behalf.

`turn: operator` rather than `turn: codex` is what this brief's own completion condition directs for a
false verify-first premise, and it matches core § 7 — the required action is hard to reverse and needs
authority the operator has not granted.
