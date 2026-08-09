# Work Loop v2 — unattended operation, v0.2

**Supersedes `unattended-operation-plan-v0.1.md`, which is retained. Written 2026-08-06.**
Author: Claude. Revised after independent Codex review of v0.1.

> ## Implementation status — 2026-08-07
>
> | Item | State |
> |---|---|
> | **Phase 0** — attended launcher proof (0a nested launch, 0b detached checklist, 0c multi-hop) | **COMPLETE** — run by Codex, `runs/phase0-attended-launcher-proof-2026-08-07.md`. Nested launch works, but only *outside* the ordinary command sandbox. Direct detachment fails: a `nohup … &` launch from a Codex command is reaped before the dispatcher starts. **This selects the approved launch shape rather than blocking anything** — § 0b already named the supervised shell session as the fallback, and Phase 0 proved it. 0c was **an attended five-hop live run with no operator transport during the run**, closing correctly at `turn: operator` |
> | **1a** stoppable run | **NARROWED, NOT CLOSED — still blocking (2026-08-07, second round).** The reachable escape surface is much smaller and the stop's claims are now honest, but **full-descendant termination was not achieved and 1a is not complete.** *What was built:* teardown terminates the union of three handles — the actor's process group, a recursive ancestry walk, and the holders of a **private per-hop marker descriptor** — and **verifies** the result before releasing the lock or exiting, on every controlled stop path (`SIGTERM`, `SIGINT`, per-actor timeout `21`, deadline `29`). A sweep that cannot see reports `teardown UNVERIFIED` instead of success, and a stop that cannot account for the tree **pins the lock** so no second dispatcher is admitted (exit `17`; `--status` explains). Each way discovery can break is separately proved: a failing `ps -ax`, a runtime-failing `pgrep`, a runtime-failing `lsof`, `lsof` absent, a missing marker, and an actor sharing the dispatcher's process group (cases 27j, 27m–27q). A survivor the sweep can see but cannot clear is proved too (27L). *What still escapes:* a conventional detached daemon — double fork, `setsid`, then `closerange`, holding **no** inherited descriptors — survives the stop, observed alive after exit (`runs/probe-escaped-descendants-2026-08-07.md` Part B). *Why it was not fixed:* six handles were measured on this host, and the **only** one that reaches such a daemon is its inherited working directory, which also lists unrelated processes sitting in the same directory — measured, pid 60190 in Part A. A handle broad enough to catch the daemon is broad enough to kill the operator's shell, which is the defect that removed the public-hop-log handle in the first place. Closing 1a needs a supervisory mechanism that tracks descendants at creation time (cgroup-equivalent, launchd job, ptrace-class supervisor) — a new subsystem and a new authority, and an operator decision rather than a bounded fix. Simulated suite **368/0** (matched red pairs **317/8** against `5680a44` for the correction, **355/13** against `5dd1d60` for the final fix). **Disclosed cost:** worst-case teardown ~6s → ~13s, deadline overrun bound ~6s → ~9s (`DEADLINE_CEILING` 11 → 14) |
> | **1b** true deadline | **done.** `--deadline`, clamps the actor timeout before every launch and every retry. Exit `29`. Tests: cases 28–28d |
> | **1c** committed-path check | **done.** Exit `30`. Tests: cases 29–29c |
> | **1d** unattended authority | **COMPLETE — built, measured live, NOT blocking.** Policy settled by the operator (`runs/probe-contained-authority-2026-08-07.md`); integration shipped as `dispatch.sh --unattended`, delivered by CLI `--settings` on every Claude hop because `strictAllowlist` has no effect from a repository settings file. Fails closed, exit `31`, on a non-Darwin host, an unresolvable binary, claude < 2.1.219 or an unreadable version string; refuses to combine with `--actor-cmd`; `--claude-deny` composes and is additive. Simulated suite **284/0 as the suite stood at 1d's close** (matched red pair **216/24**, that test file against the pre-1d dispatcher at `22fedf8`); the suite is **368/0** since the 1a teardown work added its cases. **Effective policy measured from inside a child the dispatcher launched** (`runs/probe-unattended-integration-2026-08-07.md`, **21/0**): network refused, write outside the checkout refused, home read refused, `git push` denied before execution, sentinel cloud credential scrubbed from the subprocess, and a repository-declared `SessionStart` hook that never fired — measured by its absent marker file, not reported by the model. **The tool roster and MCP absence are measurements too, as of the 2026-08-07 correction:** unattended hops capture `--output-format stream-json`, so the hop's own `system/init` event states what the runtime resolved — observed `tools: Bash, Skill` and `mcp_servers: []` despite the checkout declaring an MCP server, with a control run on the same host reading 27 tools and a loaded server once the flags are removed. Codex's assessment had correctly found both scored as passes while they were still the child's own prose. **One named exception inside the denied home tree:** `denyRead: ["~/"]` also blocked `~/.gitconfig`, which Git reads every invocation, so the child's Git exited 128 before touching the repository; check 6b established the repository was reachable and config discovery was the only obstacle. The zero-read alternative (`GIT_CONFIG_GLOBAL=/dev/null`) was rejected on evidence — the identity lives only in the global config here, so that child could not commit, and core § 4 has Claude commit every hop. Operator decision 2026-08-07: allow the minimum Git configuration paths, broaden home no further. `allowRead` carries `~/.gitconfig` and nothing else; `~/.config/git/config` proved unnecessary. Guarded at both ends — live: `~/.gitconfig` readable **and** `~/.config` still refused; simulated: no widening form in `allowRead`, the broad `denyRead` still present, exactly three entries. Residual, measured: `~/.gitconfig` names credential helpers, and the child obtained **no** token (`gh` credentials stay under the denied `~/.config/gh/`) — **if a real secret is ever put in `~/.gitconfig`, this exception stops being safe.** The old `--claude-deny` plumbing is still *not* this profile; it is the narrowing flag that composes with it |
> | **1e** no sleep | **done — observed in the supervised Phase 0 proof under `caffeinate -i`.** The 0c run held the machine awake across five hops and 301 seconds of actor time without dying mid-hop. Also documented in the worked invocation, spike `README.md` |
> | **1f** branch isolation | **UNPROVEN — still blocking.** Documented only (branch + clean tree + the worktree blocker, spike `README.md` § Safety boundaries). No run has demonstrated a clean branch/isolation boundary in practice. Written down is not proven |
> | **1g** read-only status | **COMPLETE — independently accepted, NOT blocking.** `--status` answers in **three** states: `IN FLIGHT` (pid visibly alive), `STALE LOCK` (pid **positively** absent — `kill -0` said *no such process*) and `UNKNOWN — CANNOT INSPECT` (permission denied, unreadable or invalid pid, or any ambiguous failure). `UNKNOWN` says the lock may belong to a live dispatcher, still reports pid/lock/state/log, and **never** recommends removing the lock. Read-only and exit-`0` contracts unchanged. A valid lock pid must match `[1-9][0-9]*`; empty, non-numeric, zero and zero-prefixed values (`0`, `00`, `007`) report `UNKNOWN` and emit no `IN FLIGHT`, `STALE LOCK`, `kill -TERM` or `rm -rf`. Tests: 30d (forced `EPERM`), 30f (unreadable, non-numeric and invalid-numeric pids, plus `1`/`10` pinned valid), **30e positive control** (a genuinely absent pid must still read `STALE LOCK`) — red-to-green `162/9 → 171/0` against `c8b2172`, then `186/12 → 198/0` against `e1ebb2f`. **Independently accepted by Codex against the CORRECTED build (2026-08-07):** all three live status states passed — sandbox-hidden live PID → `UNKNOWN`, the same PID outside the sandbox → `IN FLIGHT`, terminated PID → `STALE LOCK` — the invalid-PID checks passed, and the suite passed **198/0**. The temporary review lock and process were removed; no repository files were changed by the check. Nothing outstanding |
> | **Phase 2** — walk-away pilot | **BLOCKED**, correctly. Phase 0 is no longer among the blockers; 1d and 1g are complete and cleared. **Two remain — see the list below the table.** Neither is a decision; both are unfinished or unproven work |
> | **Phase 3** — documentation (3a–3h) | **done.** `SKILL.md` § Courier mode, § The seam and § Unattended runs (which carries the `--unattended` guidance) stand, as does spike `README.md`. **3c and 3d were re-opened by 1d and are now rewritten against the built profile** (2026-08-07 correction) — 3c lists what the sandbox and permission layer actually refuse, 3d lists what they still do not cover, with settings-scope merging named as the one residual that stays open. Neither was ever a Phase 2 blocker |
> | Core § 4 decision | **recorded** in `logs/decisions.md`, 2026-08-07 |
>
> Suite: **368 pass, 0 fail** — all simulated (149 at `c8b2172`, plus 22 for the 1g three-state fix,
> 27 for the pid-validation correction that followed it, 75 for the 1d contained-profile integration,
> 11 for the 1d correction of 2026-08-07, and 84 for the three 1a teardown rounds). **Two live shapes have now happened.** Phase 0c — **an attended five-hop live run with
> no operator transport during the run**: three commits, closed at `turn: operator`, the operator
> present at a supervised terminal, and **without** the contained profile. And the 1d integration
> probe — **an attended single-hop live run WITH the contained profile**, in which the Work Loop's own
> mode rule caught a defect in the fixture brief and handed back correctly, using no built-in file
> tools. **The Phase 2 walk-away pilot has never happened**, and the two blockers below stand between
> here and it.
>
> ### Phase 2 blockers — both remaining, neither of them a decision
>
> | # | Blocker | Why it blocks a walk-away run |
> |---|---|---|
> | 1 | **A fully detached descendant survives the stop** (1a) | Narrowed, not closed. `setsid`, a new process group, a double fork and SIP-protected binaries are now all reached, but a descendant that also drops every inherited descriptor is invisible to every usable handle. It outlives the run, unsupervised and unbounded, while the operator believes everything halted |
> | 2 | **Branch/isolation unproven** (1f) | Documented, never demonstrated. The claim that `main` is protected has not been exercised |
>
> Blocker 1 is still the one that would hurt most unattended. **It is smaller than it was** — before
> this work a single `setsid` escaped, which is one line in a shell; now an escape has to be a
> deliberate daemonisation. It is not gone, and the second round's measurement says why it cannot be
> closed inside this spike: the only handle that reaches the surviving shape (inherited working
> directory) also reaches unrelated processes, so using it would reintroduce bystander kills. See
> `runs/probe-escaped-descendants-2026-08-07.md` § *The deciding measurement*.
>
> **Cleared 2026-08-07: the contained profile (1d).** It was blocker 1 of the previous three. Built as
> `dispatch.sh --unattended`, covered by the simulated suite (**284/0** at the time, **368/0** since
> the 1a teardown work; matched red pair **216/24**),
> and — the part that actually cleared it — **measured from inside a child the dispatcher launched**
> (`runs/probe-unattended-integration-2026-08-07.md`, **21/0**). Recorded as closed rather than
> deleted, because the run that cleared it also found the defect that nearly did not clear it: the
> ratified profile blocked Git, and finding that needed a live child rather than a harness. The
> operator settled it the same day with a one-file exception, guarded at both ends.
>
> **Cleared 2026-08-07: the `--status` false `STALE LOCK` (1g).** It was blocker 2 of the previous
> four. Fixed, harness-proven (cases 30d/30e/30f) and **independently accepted by Codex against the
> corrected build**: all three live status states passed, the invalid-PID checks passed, and the suite
> passed 198/0. It is recorded here as closed rather than deleted, because it is the one blocker that
> was found by a live run rather than by the harness — the reason Phase 0 exists.
>
> **Not a blocker: the failed detached launch.** § 0b already specified a supervised shell session as
> the fallback if detachment failed, and Phase 0 proved that fallback works. Detachment failure
> **selects the approved launch shape** — supervised terminal under `caffeinate -i` — rather than
> standing in the way of Phase 2. It does bound what "walk away" can mean: the operator starts the
> run from a terminal that stays open, then leaves.
>
> **~~One finding changes the plan's own text.~~ WITHDRAWN 2026-08-07 — the finding was wrong, and
> § 1d's original "no push, no network" stands as first written.** The withdrawn text said the
> network half "does not exist by this mechanism" and that containment "needs an OS-level sandbox,
> not a permission rule." The second clause was right; the inference was not. Claude Code 2.1.220
> *ships* an OS-level sandbox — macOS Seatbelt over Bash and all its children, with a strict network
> allowlist (`strictAllowlist`, v2.1.219+). Codex demonstrated `curl` refused under an empty
> allowlist; Claude independently confirmed the version, the flags and the documented behaviour.
> The error was searching `--help` for a flag and reading its absence as the capability's absence —
> the mechanism lives in sandbox *settings*, which `--help` does not list. Corrected record:
> `runs/probe-contained-authority-2026-08-07.md`. The `WebFetch`/`WebSearch` deny rules genuinely
> are insufficient alone — that negative result stands and is why the contained profile exists.
>
> **The operator has settled 1d on the contained profile:** shell and Work Loop skill only; strict
> empty Bash network allowlist; no MCP, web, hooks, connectors, remote control, subagents, built-in
> file tools, or push; credential scrubbing; no unsandboxed-command escape. Two conditions carry
> with it, both silent-failure paths and both stated in the corrected record: `strictAllowlist` has
> **no effect** from a repo-level settings file, so the profile must arrive by CLI `--settings` on
> every hop; and array keys such as `allowRead` merge across all scopes, so the containment observed
> on one machine is not automatically what another checkout gets. The live test must therefore assert
> the *effective* policy from inside the child, not that the profile was passed.
>
> ### Review round — 2026-08-07, operator-supplied review of the above
>
> Verdict was **not approved**, Phase 2 not to begin. Five findings; four accepted and fixed, one
> disputed on the facts.
>
> | # | Finding | Disposition |
> |---|---|---|
> | 1 | Phase 0 gate skipped | **Disputed in part.** Phase 0 genuinely has not run and Phase 2 stays blocked — that conclusion stands and was already this plan's own status. But it was a *disclosed* deviation, not a skip: 0a/0c need the operator at the keyboard with Codex, and 1a/1b/1c/1g are dispatcher-internal — none changes shape with the launch path. The plan's own 0b item 4 makes the *stop* question depend on 1a, not the reverse. **— SUPERSEDED 2026-08-07: Phase 0 has since run (Codex). The reviewer's underlying point was better than this reply allowed: Phase 0 found two defects in items called "dispatcher-internal" here — the `--status` false `STALE LOCK` (1g) is *only* visible under a real sandboxed launch, and the detached shape's failure changes what launch paths exist at all. "None changes shape with the launch path" was wrong.** |
> | 2 | `--claude-deny` had no end-to-end test | **Accepted.** Cases 31 / 31b added: a fake `claude` binary records the argv the dispatcher builds, asserting the flag reaches the child (metacharacters intact, repeatable) and that its absence changes nothing. |
> | 3 | "Whole process tree" overstated | **Accepted — the sharpest finding.** It is a process-*group* kill. Wording corrected in `dispatch.sh`, the probe record and `README.md`; case 27b now asserts the real boundary (a `setsid`'d descendant survives, and the case fails if that silently changes). |
> | 4 | Deadline clock start, grace period, loose test | **Accepted, all three.** `RUN_START` moved to the script's first statement; the worst-case overrun is now stated as `1s poll + 5s TERM→KILL grace + reaping ≈ 6s` instead of "the poll interval"; case 28's bound tightened from `< 20s` to `<= 11s` derived from that arithmetic. Case 28b was also rewritten — it was asserting a timing-dependent hop count and could land on the wrong branch. |
> | 5 | Probe records not reproducible | **Accepted.** The interruption record claimed a verbatim script and showed pseudocode. Real scripts and raw captures now live in `runs/probes/`, including a genuine **before/after** capture produced by running the probe against the pre-fix dispatcher retrieved from git (`2dd2112`). |
>
> Nothing in this round changes what is proven: controller logic only. Live transport, detached
> survival, sleep prevention, isolation and the permission flag under a real model remain unproven,
> and Phase 0 is still the gate.

**Evidence convention, used throughout.** Every load-bearing claim is marked **OBSERVED** (a command
was run, or a file re-read at a cited line) or **INFERRED** (derived by reasoning). v0.1 carried two
INFERRED claims dressed as OBSERVED and both were false — see *What changed from v0.1*. An INFERRED
claim may not authorise a fix; it authorises a check.

---

## The goal

> The operator describes one task in Codex, invokes one command, leaves for roughly 40 minutes, and
> returns to either finished work or one decision that is genuinely theirs — having carried nothing
> by hand in between.

---

## Established facts

**1. Basic transport works. Unattended reliability is unproven.** `dispatch.sh` without `--carry-one`
alternates Codex and Claude until `turn: operator`. **OBSERVED** — the two 2026-08-05 live runs:

- `runs/20260805T154555-spike-live-transport.log` — three hops, reached `turn: operator` cleanly.
  This is the longest clean run on record.
- `runs/20260805T152939-spike-live-transport.log` — three hops, then **failed at hop 4**:
  `STOP [20] actor 'claude' exited 143 after 100s`. 143 is 128+15 — the Claude child was killed by an
  external `SIGTERM`. A dispatcher timeout would have surfaced as 124, so the signal came from
  somewhere else. **What sent it was never established, and that is directly relevant to a run
  nobody is watching.**

**2. A task spans many units, and the loop already chains them.** **OBSERVED** — `SKILL.md:289`:
*"When the accepted unit leaves the task's named exit condition unmet, continue rather than close"*,
with mechanics in core § 3 *Continuing*. Codex writes the next unit's brief, sets `turn: claude`, and
the loop carries on. **No supervisor is involved in filling 40 minutes within one task.**

**3. Context is not the limiting factor.** **OBSERVED** — `dispatch.sh:409-432`: each hop is a fresh
`claude -p` / `codex exec` process. Nothing accumulates; `logs/work-loop/{task-id}.md` is the entire
shared memory. The run is bounded by time, hops, and the first real decision.

**4. Permission prompts should not fire inside this checkout.** **OBSERVED** —
`.claude/settings.json:30` declares `defaultMode: bypassPermissions`; the 2026-08-06 hop ran headless
and committed (`9fb59b1` → `c2036d5`). The problem is not that Claude will be blocked. The problem is
how much it is allowed to do — see 1d.

**5. The allowlist does not see committed changes.** **OBSERVED** — `foreign_worktree()` reads
`git status --porcelain` (`dispatch.sh:265-276`). Claude commits each hop, so its work leaves a clean
tree and passes the guard. Only stray *uncommitted* files trip it.

**6. The parallel-operation prerequisites do not gate this plan's serial path. They gated worktrees,
and that gate is now cleared for contained runs only.** **OBSERVED** — the production-readiness
policy task closed on 2026-08-09 (`logs/work-loop/work-loop-v2-production-readiness-policy.md`, now
its closing record — cite it by section, not by line, since the active brief it once carried is gone).
Two of its findings changed this plan's inputs:

- **The headless session-identity prerequisite is built.** `dispatch.sh` now allocates a marker and
  writes a concrete `- Files in scope:` bullet before hop 1, so `check-foreign-staging.sh` reads the
  run's own footprint instead of a stranger's via the shared-marker fallback.
- **The ambient `friction-log.md` writer is no longer a blocker for *contained* runs, and the hook
  fix that would have cleared it was dropped.** `--unattended` launches the Claude child with
  `"disableAllHooks": true`, so the writer cannot fire inside a contained hop and there is no
  co-edit to conflict over. The planned hook edit (that task's U2) was therefore dropped rather than
  built — do not wait for it, it is not coming.

**What is still blocked:** an *attended* parallel session in a worktree. Its hooks are live, so it
appends to the tracked `friction-log.md` exactly as before and two such sessions still land in
conflict. The clearance is a property of containment, not of the worktree. See 1f.

---

## Scope

**In scope:** one task, one checkout, serial, unattended, bounded by a hard clock.

**Out of scope:** a supervisor that selects a *new task* after the current one closes (see *Deferred*);
parallel or multi-worktree operation; any change to core § 7 — `turn: operator` stays terminal.

**Does core § 4 permit this?** Yes, and no amendment is needed. **OBSERVED** — core § 4 at
`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:194-215` forbids a courier from changing
state-file content, choosing which actor moves, passing `turn: operator`, or standing in as evidence.
Loop mode does none of these: it launches whoever `turn:` already names and stops dead at
`turn: operator` (`dispatch.sh:474-502`). The clause's own test — *does removing the courier change
any decision?* — is passed. Record as a decision in `logs/decisions.md` rather than amending the core.

---

## Phase 0 — Attended launcher proof

**No code changes. Nothing here can run unattended, so nothing here needs the Phase 1 safety work.**

This phase exists because three unknowns, if resolved the wrong way, would make the Phase 1 safety
work land on the wrong shape. It is cheap, it is safe, and it happens at the keyboard.

**0a. Can a dispatcher run be launched from inside a Codex task?**
The operator wants to launch from Codex chat, which means `codex exec` nested inside a Codex session.
**Never tested.** The 2026-08-05 proofs were not launched that way.

**0b. Detached-process survival — the full checklist** *(from Codex review #7, expanding v0.1's 1a)*.
"Detached" was asserted in v0.1 without definition. Establish each:

1. what keeps the dispatcher alive after the launching Codex turn ends;
2. whether the nested `codex exec` runs reliably at all;
3. how its process id and log paths are discovered afterwards;
4. how the operator stops it (depends on 1a of Phase 1);
5. how the originating Codex task learns the run finished;
6. whether Claude and Codex authentication tolerate concurrent parent and child use.

If detached survival fails, the fallback is a supervised shell session — **not** an SDK or App Server
integration, which is a large build for a problem not yet shown to need it.

**0c. Attended multi-hop run, with `continue` exercised.**
Loop mode, `--max-hops 6`, operator present, carrying nothing. Ctrl-C works here because the terminal
signals the whole foreground process group, so this is safe without the Phase 1a fix.

**Measure and write down:**

- how long one unit actually takes end to end;
- whether Codex's `continue` chains to a second unit inside the same task without intervention;
- what stopped the run, at which hop, and whether the stop was correct.

**Why the measurement matters:** it decides whether the supervisor is ever worth building, and it
converts the 40-minute target from a guess into a hop count.

---

## Phase 1 — Safety prerequisites

**All of these land before any walk-away run.** *This is a change from v0.1, which scheduled the
walk-away first. Codex review #1 is right: a run you cannot stop is not an experiment, it is an
incident waiting for a name.*

### 1a. Make the run stoppable

> **Promoted INFERRED → OBSERVED, 2026-08-07, and it was worse than predicted.**
> `runs/probe-interruption-2026-08-07.md` ran the probe this section demanded. All three predictions
> below held, plus the two things the section could not settle:
> **actor descendants survived** (a grandchild outlived the sweep, because `pkill -P` reaches one
> generation only), and the lock was **released**, so a second dispatcher was admitted at exit `0`
> while the first was still running. The signal did not stop the run — it *unlocked* it.
> Fixed: the actor now runs in its own process group (`set -m`) and the handler terminates the group,
> releases the lock once, and exits `28`.
>
> **NARROWED, NOT CLOSED — 2026-08-07, second round. Still a Phase 2 blocker.**
>
> *A first round of this work claimed completion and was rejected on independent assessment.* The
> claim rested on narrowing the dispatcher's **success sentence** to the handles it had implemented.
> That is not the same as narrowing the **objective**, which says the actor's *full descendant tree*.
> A conventional detached daemon is still a descendant. This note records the corrected result; the
> earlier "PARTIAL → COMPLETE" wording is withdrawn, not amended.
>
> *The state before any of this work:* the fix reached the actor's process **group**, not its tree.
> An earlier draft called it a "whole process tree" kill; that overstated it and was caught in review,
> after which case 27b asserted the real boundary deliberately — a descendant that calls `setsid` left
> the group and **survived** the stop. Phase 0 § 0b item 4 had observed the group kill working live
> (`terminating actor process group 79425`, exit `28`), which confirmed the mechanism and not the reach.
>
> *What the two rounds did build.* Teardown terminates the **union of three handles** — the process
> group, a recursive ancestry walk from the actor, and the holders of a **private per-hop marker
> descriptor** — and then **verifies** the result before releasing the lock or exiting, on every
> controlled stop path: both signal traps (asserted separately rather than assumed to share routing),
> the per-actor timeout, and deadline expiry. Three further properties came out of the second round:
> a sweep that could not run says `teardown UNVERIFIED` rather than printing success; a stop that
> leaves survivors or cannot account for the tree **pins the lock**, refusing a second dispatcher with
> exit `17` and explaining itself through `--status`; and the marker is private, so an operator's
> `tail -f` on the hop log is no longer mistaken for a descendant and killed.
>
> *The final tightly-bounded fix (2026-08-08) closed two evidence gaps, and writing the tests found
> two more defects.* The survivor branch and the degraded-discovery branches were implemented but
> barely exercised, so each was given a fail-capable case. Two of the six discovery routes — a
> failing `ps -ax` and a missing marker — turned out to be already correct, and their cases are
> regression protection rather than red-to-green proof. The other four were not:
>
> - a **runtime-failing** `pgrep` (as opposed to an absent one) was read as "the actor has no
>   children"; `pgrep`'s exit code separates *no matches* (1) from *pgrep failed* (≥2) and the
>   difference was being discarded;
> - a **runtime-failing** `lsof` was read as "nobody holds the marker"; `lsof -t` exits 1 for both, so
>   only its stderr distinguishes them, and stderr was going to `/dev/null`;
> - the **process-group collision guard could not fire at all.** It compared the caller's argument —
>   the actor's *pid* — against the dispatcher's *pgid*. Those are different kinds of number and can
>   only match by coincidence, so the guard was dead code in exactly the situation it was written for
>   (`set -m` failing and the actor joining the dispatcher's group). It now asks what group the actor
>   is actually in;
> - **`--status` told the operator a pinned lock was safe to remove while its survivor was alive.**
>   Its re-check used a bare `kill -0`, which fails both when a process is gone and when it is alive
>   but not ours to signal — and a survivor left behind by a stopped actor is quite likely to be the
>   second. It now uses the same three-valued `pid_state()` the lock's own check uses, and reports an
>   uninspectable pid as *treat as running*.
>
> All four are the same mistake in different places: **an inability to look, recorded as a look that
> found nothing.** That is the mistake this whole item is about, which is why the coverage was worth
> the cost.
>
> *Why it is still not closed.* Six handles were measured on this host
> (`runs/probe-escaped-descendants-2026-08-07.md`):
>
> - the process group misses any `setsid` descendant;
> - the ancestry walk misses a double-forked orphan, whose PPID link the kernel destroys at the
>   intermediate's exit — before any stop happens, so no walk taken at stop time can recover it;
> - an **environment tag was rejected on measurement**: `ps -E` cannot read the environment of a
>   SIP-protected platform binary (`/bin/sleep` and `/bin/bash` both refuse), which is exactly what an
>   escaped shell job usually is;
> - **kqueue `NOTE_TRACK` was rejected on availability** — `ENOTSUP` on this host. It would have been
>   the clean answer had it existed here;
> - the **public hop log** descriptor was rejected on measurement in the second round: it reaches the
>   three escaping shapes, but an operator watching the run holds the same file, and the first round
>   killed exactly that process;
> - the **inherited working directory** is the only handle that reaches a fully detached daemon — and
>   it also lists unrelated processes that merely sit in the same directory, measured directly.
>
> **So the two requirements are in opposition on this host.** A handle broad enough to catch the
> daemon is broad enough to kill the operator's shell. That is a measured limit, not a shortage of
> effort, and it is why this unit stops here rather than improvising something broader.
>
> **What would close it** is a supervisory mechanism that tracks descendants as they are *created*
> rather than discovering them at stop time — a per-run cgroup-equivalent, a launchd job, or a
> ptrace-class supervisor. Each is a new subsystem and a new authority. Choosing one is an operator
> decision, outside this spike's bounds.
>
> **The residual, stated exactly.** A descendant that double-forks, leaves the session **and** drops
> every inherited descriptor survives the stop — observed alive after the dispatcher exited (probe
> Part B). Case 27h builds that shape, asserts it survives, and fails if the dispatcher's success
> wording is ever widened to cover it. The residual is narrower than what it replaces: before this
> work one line of `setsid` escaped; now an escape must be a deliberate daemonisation. Narrower is
> not closed.
>
> **Disclosed cost, not hidden.** Worst-case teardown latency ~6s → ~13s, and the whole-run deadline's
> honest overrun bound ~6s → ~9s. Case 28's `DEADLINE_CEILING` moves 11 → 14 for that reason. This
> plan forbids relaxing the hard clock silently; this is the disclosure.

**Evidence status: INFERRED** *(as written 2026-08-06; superseded by the note above)*. Derived from
`dispatch.sh:190` (`trap 'release_lock' EXIT INT TERM`)
and bash trap semantics: a handler that does not call `exit` returns control to where the script was
interrupted. The consequence would be that `SIGTERM`:

- releases the lock, then lets the dispatcher **carry on running**;
- never signals the actor, which keeps working;
- and, with the lock now free, permits a *second* dispatcher on the same checkout and task — the
  exact collision the lock exists to prevent.

Ctrl-C in an interactive terminal likely escapes this, because the terminal signals the whole
foreground group. A detached run does not.

> **First task is confirmation, not repair.** Run the probe (long simulated actor via `--actor-cmd`,
> `SIGTERM` the dispatcher, observe dispatcher, actor and descendants). An attempt to run it during
> the 2026-08-06 investigation was denied at the permission prompt. **Establish separately whether
> actor descendants survive** — neither the analysis above nor Codex's probe settles that.

*Fix, minimum shape:* the trap sets a shutdown flag so the loop cannot launch another actor;
terminates the actor's process tree (reuse the TERM-then-KILL sweep already at `dispatch.sh:355-379`
rather than writing a second one); waits for reaping; releases the lock once; exits non-zero with an
`interrupted` message naming task, hop and state-file path. **An interrupted actor is never retried**
— interruption may have landed after an unobserved partial effect. Two or three test cases.

### 1b. A deadline that is actually a deadline

*Codex review #2 — a correct catch against v0.1, which only refused to **start** an actor past the
deadline. An actor starting at minute 39 with a 900s timeout runs to minute 54, and
`--max-hops 12 --timeout 900` has a three-hour upper bound.*

Before every launch:

```
effective actor timeout = min(--timeout, remaining time to deadline)
```

When the global clock expires, terminate the current actor through the same path as 1a and record a
named `budget exhausted` outcome. **Budget exhaustion is not completion** and must never be reported
as one — the state file and Git are untouched by the stop, so the next run resumes from them.

A deadline kill leaves the same partial-effect risk as an interruption. Treat it identically:
inspection required, never an automatic retry.

### 1c. Check what Claude committed, not just what it left uncommitted

*Codex review #3 — v0.1 found this gap (fact 5) and then accepted it. Fair criticism.*

After every Claude hop, compare `before_head..after_head` (`git diff --name-only`) and stop the run if
any committed path falls outside the allowlist. Detection, not prevention — the commit has happened;
the value is stopping rather than compounding.

**Honest cost, which the review does not mention:** this only works if `--allow-path` describes what
the *unit* may legitimately touch. That makes the allowlist a per-task input Codex must derive when it
writes the brief, and a wrong allowlist produces false stops. This is real work, not a free flag.

### 1d. Unattended authority — **operator decision, not a designed answer**

*Codex review #4, its strongest point.* Unattended for 40 minutes, Claude currently holds
`bypassPermissions`, `Bash(*)`, web access and broad file editing, against a deny list of `rm -rf *`
and `sudo *`. A branch protects the `main` ref. It protects nothing else: not the network, not paths
outside the checkout, not credentials. `git push` is held only by a CLAUDE.md rule — a model-side
rule, which is weaker than usual precisely when nobody is watching.

**Two reasons this plan does not simply specify a profile:**

1. **It contradicts a standing operator decision** — bypass mode plus model-side rules, no deny-list
   expansion. That decision was made for attended sessions; unattended is a materially different
   case, which is a reason to revisit it and not a reason to override it quietly. **Surfaced, not
   resolved** (workspace `CLAUDE.md` § Design Judgment Principles).
2. **The mechanism is unverified.** How a headless child is given a *different* policy from the
   operator's interactive sessions has not been checked. Specifying a profile before knowing whether
   one can be scoped to that child would repeat exactly the failure that produced this revision.

*Sequence:* verify the mechanism → put the narrow option to the operator (no push, no network) rather
than a broad denylist → implement only what they choose. **This *was* a blocking item for the
walk-away run in Phase 2, and the only one in this plan the operator had to personally settle —
settled, built and measured on 2026-08-07; see immediately below.**

> **SETTLED AND BUILT 2026-08-07 — all three steps of that sequence are complete.**
>
> *Mechanism (reason 2) — resolved.* A headless child can be given a policy scoped to itself, and it
> is enforced by the OS rather than by the model. Proven in
> `runs/probe-contained-authority-2026-08-07.md`; independently confirmed against the official
> sandboxing documentation and the installed 2.1.220 binary.
>
> *Standing decision (reason 1) — revisited and changed, deliberately, by the operator.* The
> attended posture is untouched: bypass plus model-side rules, no deny-list expansion, exactly as
> before. The unattended child is now a separate case with its own contained profile. This is the
> revisit that reason 1 called for, not a quiet override — and it holds only for unattended runs.
>
> *The operator's chosen profile:* shell and Work Loop skill only; strict empty Bash network
> allowlist; no MCP, web, hooks, connectors, remote control, subagents, built-in file tools, or push;
> credential scrubbing; no unsandboxed-command escape.
>
> *Implementation (the third step) — done.* `dispatch.sh --unattended` applies the profile on every
> Claude hop, delivered by CLI `--settings` because `strictAllowlist` has no effect from a repository
> settings file. It logs the requested restrictions and the delivery scope, fails closed with exit
> `31` on a non-Darwin host, an unresolvable binary, claude below `2.1.219` or an unreadable version
> string, and refuses to combine with `--actor-cmd`. Attended and courier launches are unchanged and
> asserted so (case 32j). The pre-existing `--claude-deny` flag is *not* this profile — it is a
> permission-layer denial, and the probe that motivated it proved a deny rule alone leaves `curl`
> reachable; it now composes on top of `--unattended` and can only narrow further.
>
> *And it was tested end to end, from inside the child.* `runs/probes/unattended-effective-policy.sh`
> launches a real Claude child **through the dispatcher** and asserts the effective policy from within
> it — recorded in `runs/probe-unattended-integration-2026-08-07.md`. Two claims that were once the
> child's own prose, the tool roster and MCP absence, are now read from the product's `system/init`
> event in the hop capture, with a control run on the same host showing the same fields reading 27
> tools and a loaded MCP server when the flags are absent.
>
> **One exception, and the residual risk.** `denyRead: ["~/"]` also blocks `~/.gitconfig`, which Git
> reads on every invocation, so the child's Git exited 128 before touching the repository. Operator
> decision, 2026-08-07: allow the minimum Git configuration paths, broaden home no further. `allowRead`
> carries `~/.gitconfig` and nothing else. That file names credential helpers; the child obtained no
> token, and **if a real secret is ever placed there the exception stops being safe.** Separately,
> array settings keys merge across scopes, so another scope on the host can widen the profile — closing
> that needs managed settings, which is outside any dispatcher's reach.

### 1e. Stop the machine going to sleep

*Codex review #9 — missed entirely by v0.1, and a hard blocker: if the Mac sleeps, the run dies.*
Wrap the launch in `caffeinate -i` (or the equivalent Codex "prevent sleep while running" option if
launching from a Codex task). One line, and without it the 40-minute premise fails on its own.

### 1f. Isolation: a branch for the pilot, a worktree once it is unblocked

*Codex review #5 — its technical criticism is accepted and v0.1's "a branch is 90% of a worktree" is
**withdrawn**.* A branch shares the working directory and index with the operator's session, carries
uncommitted changes across, and switches the checkout they have open.

**A worktree was not free when this plan was written** (fact 6): the ambient `friction-log.md` hook
writes a tracked file, which the production-readiness policy marked as a guaranteed landing conflict.

**That condition changed on 2026-08-09, and not the way this plan expected.** The block is cleared
for a **contained** run — `--unattended` disables the child's hooks, so the ambient writer never
fires and there is no co-edit. It is *not* cleared by the hook fix this section was waiting for:
that fix was dropped as unnecessary once containment made it moot. An **attended** worktree session
is still exposed, because its hooks are live.

**Resolution — and it follows the review's own acceptance condition.** Codex allows a branch-only
pilot in *"a clean checkout that no other process or person will touch."* Walking away satisfies that
by definition. So:

- **Pilot:** a branch, `work-loop/<task-id>`, from a clean tree, documented as a **temporary
  limitation** with the reason. Nobody opens the checkout while the run is live. Unchanged — the
  pilot never depended on the worktree question.
- **Standing use:** a dedicated worktree, **for contained (`--unattended`) runs only**. The gate this
  line used to name — "after the `friction-log.md` fix" — is retired, not satisfied. Still not this
  session: the clearance is documented but no dispatched run has ever launched live, so the first
  worktree use is a separately authorized step, and the operator creates the worktree
  (`docs/parallel-sessions-playbook.md` § 4 step 3, dispatched entry path).

### 1g. A read-only way to look without touching

*Codex review #8.* A `--status` mode that reads the lock and the state file and writes nothing:
is a run in flight, which task, which hop, current `turn:`, where the logs are.

This does double duty. It answers *"is it still going?"* on return, and it gives the skill rule
(*once you have launched a run, the state file is not yours until it exits*) something to check
instead of something to remember. The lock stops a second dispatcher (`dispatch.sh:177-192`, exit 17);
it does not stop the parent Codex task from editing the file by hand.

> **~~BUILT BUT NOT TRUSTWORTHY~~ — FIXED AND INDEPENDENTLY ACCEPTED, 2026-08-07. Not blocking.**
> Phase 0 § 0b item 3 ran `--status` against a genuinely live dispatcher (pid 79266) from inside the
> ordinary Codex command sandbox. It answered **`STALE LOCK`**. The cause: `kill -0` was refused by
> sandbox policy, and the check treated a refusal as "the process does not exist."
>
> This inverted the instrument's purpose. `--status` exists so the operator can ask *"is it still
> going?"* without touching anything — and it answered "no, it's dead" about a run that was very much
> alive. Worse, it was the *sandboxed* call that lied, which is the call the originating Codex task
> would naturally make. Acting on that answer means hand-editing a state file mid-hop, the exact
> corruption path the skill's rule exists to prevent.
>
> **What was built.** `--status` now distinguishes three states, not two:
>
> | State | Established by | Operator instruction |
> |---|---|---|
> | `IN FLIGHT` | `kill -0` succeeded — the pid is visible and signallable | Leave the state file alone; `kill -TERM` to stop |
> | `STALE LOCK` | `kill -0` said **no such process** — positive proof of absence | Clear the lock (`rm -rf`, printed) |
> | `UNKNOWN — CANNOT INSPECT` | Anything else: `EPERM`, no pid file, non-numeric pid, unrecognised error | **Nothing destructive.** Assume the run may be live; re-check from a permitted context |
>
> Only a message that *positively* says "no such process" may conclude absence. The bias is
> deliberate and one-directional: a false `UNKNOWN` costs one more look, a false `STALE LOCK` costs a
> live run. `UNKNOWN` prints its own evidence on a `why:` line, still reports pid, lock path, state
> file and latest run log, and **never** recommends removing the lock. `--status` stays read-only and
> still exits `0` in all three states — so the `run:` line is the answer, never the exit code.
>
> **Coverage.** Cases 30–30c passed and did not catch this, because they run where PID inspection is
> permitted — a reminder that the suite is simulated. Three cases now close that gap: **30d** forces a
> real `EPERM` (lock pid `1` — launchd is always alive and always refused to a non-root caller, so the
> denial is genuine rather than mocked), **30f** covers the unreadable and non-numeric pid, and
> **30e is the positive control** — a reaped pid must *still* report `STALE LOCK`, which is what stops
> a lazy "answer UNKNOWN to everything" fix from passing. Red-to-green against `c8b2172`:
> `pass=162 fail=9 → pass=171 fail=0`, with 30e green on **both** sides.
>
> **A second defect, found in review of the fix itself (2026-08-07).** The first cut validated the
> lock pid as *numeric*, which is not the same test as *valid*. `0` and `00` are numeric, and pid `0`
> means **every process in the caller's own process group** — so `kill -0 0` succeeds, and a lock
> holding `0` reported `IN FLIGHT — dispatcher pid 0` with the instruction `kill -TERM 0`. Following
> it would have signalled the operator's own shell. A zero-*prefixed* value is the quiet form of the
> same bug: `007` reaches `kill(2)` as pid 7, so a true verdict about an unrelated process was
> printed as a verdict about this lock. A valid pid now must match `[1-9][0-9]*`; everything else is
> a corrupt lock, reported `UNKNOWN` with no `IN FLIGHT`, `STALE LOCK`, `kill -TERM` or `rm -rf` in
> the output. Case 30f pins `0`, `00`, `007` and `0000000`, and pins `1` and `10` as valid so the
> rule cannot widen. Red-to-green `186/12 → 198/0` against `e1ebb2f`.
>
> ### 1g — independent acceptance, against the corrected build (Codex, 2026-08-07)
>
> **1g is COMPLETE and NOT blocking.** The check was run by the party that found the original defect,
> against the dispatcher **as corrected** — three-state fix plus PID validation — not against an
> earlier build:
>
> | Checked | Result |
> |---|---|
> | Live dispatcher PID hidden by sandbox policy | `UNKNOWN — CANNOT INSPECT` |
> | The **same** live PID inspected from outside the sandbox | `IN FLIGHT` |
> | Terminated PID | `STALE LOCK` |
> | Invalid-PID checks (`0`, `00`, zero-prefixed, non-numeric, empty) | passed |
> | Full dispatcher suite | **198 pass, 0 fail** |
>
> All three live status states passed. The temporary review lock and process were removed, and **no
> repository files were changed** by the check.
>
> This closes the item end to end: the defect was found live, fixed, covered by a matched pair plus a
> positive control, corrected once more under review, and then re-verified live by an independent
> party. Nothing about 1g is outstanding.
>
> Two things worth keeping from how it went. First, **the harness could not have found this** — cases
> 30–30c passed throughout, because they run where PID inspection is permitted. It took a real
> sandboxed launch, which is the argument for Phase 0 existing at all. Second, **the first fix
> introduced a second defect** (`0` and `00` are numeric but not valid pids, and `kill -0 0` targets
> the caller's own process group), which review caught before it ever ran live. A fix for a
> safety-instrument defect is itself a safety-instrument change.

---

## Phase 2 — The bounded walk-away pilot

Only after every Phase 1 item lands, with 1d settled by the operator.

> **DO NOT RUN — 2026-08-07.** 1d and 1g are complete and cleared, but Phase 1 has *not* landed.
> **Two blockers stand** (full list in the status block at the top of this document): a fully
> detached descendant still survives the stop (1a — narrowed, not closed), and branch isolation is
> unproven (1f). The preconditions below are the *target*, not the current state, and Phase 2 stays
> forbidden until both close — it has never run.
>
> The launch shape is **not** among the blockers: Phase 0 settled it as a supervised terminal under
> `caffeinate -i`, which is § 0b's own stated fallback.

- one task, one isolated location (1f — **unproven**, documented only), on a branch off a clean tree;
- a hard ~40-minute deadline (1b), hop limit as a secondary bound;
- no push, no merge, no deployment, no external side effects;
- sleep prevented (1e), stop control proven (1a — **NOT met.** Teardown reaches the process group,
  the ancestry walk and the holders of a private per-hop descriptor, and verifies that before the
  lock is released — but a fully detached daemon survives, and the one handle that would reach it
  also reaches unrelated processes. Case 27h pins the surviving shape),
  status readable (1g — **met.** Three states, harness-proven and independently live-accepted by
  Codex: hidden live PID → `UNKNOWN`, same PID unsandboxed → `IN FLIGHT`, terminated → `STALE LOCK`);
- an end-state notification — the Codex task-completion notification if it serves, rather than a
  custom observer process.

**Record, in `runs/`, as a dated live-run record:** what stopped it and at which hop; how many units
the task advanced through; how long each unit took; whether any Phase 1 guard fired, and whether it
fired correctly.

---

## Phase 3 — Documentation

**3a. `SKILL.md` § Courier mode — two approved shapes.** *Attended carry* (`--carry-one`) for when the
operator is watching; *unattended run* (loop mode) for when they are leaving. Rule 2 at `SKILL.md:56`
(*"the loop does not run on without you"*) is false as a general statement and becomes a property of
the attended shape only. The Next-line rule at `SKILL.md:21` gains a carve-out: while a run is in
flight, the Next line names the run and where its evidence will be.

**3b. Three outcomes, never blurred:** finished, operator decision required, and stopped by a
guard/failure/budget. `budget exhausted` is not completion.

**3c. What stays forbidden unattended.** *Rewritten 2026-08-07 against the built profile — the
pre-sandbox version of this item is superseded, not deferred.* Under `--unattended` these are
refused by the OS sandbox or the permission layer, not by a model-side rule: any network connection
outside the empty strict allowlist; any write outside the checkout; any read under `~/` except the
single file `~/.gitconfig`; `git push`; MCP servers; hooks; connectors, remote control and
subagents; every built-in file tool (the child has `Bash` and `Skill` and nothing else); credentials
inheriting into subprocesses; and the `dangerouslyDisableSandbox` escape. Below claude `2.1.219`, or
on a host where the sandbox cannot be established, the run **refuses to start** (exit `31`) rather
than proceeding with weaker containment it does not advertise. Written where it is read before
launching: spike `README.md` § *The honest risk envelope*, and `SKILL.md` § *Unattended runs*.

**3d. The honest risk envelope.** *Rewritten 2026-08-07.* The allowlist catches stray uncommitted
files and 1c adds committed paths — **both detect rather than prevent**, and that is unchanged. What
changed is that a layer which genuinely *prevents* now sits underneath them, listed in 3c. What that
layer still does **not** cover, and what a reader must not infer from it:

- **The Claude process itself runs outside the Bash sandbox**, so the model connection continues.
  Containment applies to what Claude *runs*, not to Claude.
- **The profile can be silently widened from another settings scope** (`allowRead` and other array
  keys merge across scopes; `strictAllowlist` is ignored entirely from a repo settings file — which
  is why the dispatcher delivers it by CLI `--settings`). Locking this needs managed settings, which
  is outside the dispatcher's reach. **This remains open.**
- **`~/.gitconfig` is a deliberate exception** inside the denied home tree, and it names credential
  helpers. The child obtained no token from it, measured rather than reasoned — but if a real secret
  is ever put in that file, the exception stops being safe.
- **Effective policy was measured once, on one host.** `runs/probe-unattended-integration-2026-08-07.md`,
  21/0, attended and fixture-scoped. That is a safety check, not a reliability claim.
- **The rest of the envelope is unchanged and still load-bearing:** one task, one branch off a clean
  tree, local commits, a hard deadline, push gated — and a stop that reaches a process *group*, not
  a tree.

**3e. Correct the context model.** Fresh process per hop, state file is the memory, not
context-bounded.

**3f. Do not mix the shapes.** A chat Codex carrying hops while a loop run is in flight is two
instances of one actor. 1g makes this checkable.

**3g. What Codex says on the operator's return — one rule, not a report format.** Report from the
state file and the run log, and **separate repository facts from model claims**: *"the dispatcher
observed exit 0"* and *"Claude reports the tests passed"* are different statements, and neither means
Codex accepted the evidence.

**3h. `README.md` + exit-code table** for the new interrupted and budget-exhausted exits, plus the
walk-away invocation as a worked example.

---

## Deferred

**The supervisor — now a much smaller gap than v0.1 claimed.** Fact 2: a task already spans many units
and Codex chains them itself. A supervisor is only needed to choose an entirely **new task** once the
current one closes. Whether that is worth building is decided by Phase 0c's measurement, not by
argument: if one task fills 40 minutes, it buys nothing.

**`--expect-turn` — probably dead.** It guarded the repeating-courier shape, which unattended loop
mode makes unnecessary, and the lock already refuses a second dispatcher. Build only if Phase 0
concludes the repeating courier is worth keeping.

**Rejected for now, with reasons recorded in v0.1's triage section:** ten derived operational states;
a structured JSON outcome event plus observer process; the full budget envelope (checkpoint margins,
cost ceilings, deadline-aware actor prompting); the eight-element return report specification; a
second state directory; a durable execution ledger; a VS Code extension. v0.1's triage table stands —
do not re-litigate these without new evidence.

**Graduating the spike out of `plans/…/handoff-automation-spike/`.** `README.md:3` still calls it
*"Throwaway spike. Not production, not installed anywhere."* If this becomes normal working practice
that has to change — after Phase 2, not before.

---

## Sequencing

```
Phase 0  attended proof    →  0a nested launch · 0b detached checklist · 0c multi-hop + continue
                              MEASURE: unit duration, does continue chain, what stops it
                              (no code changes · safe at the keyboard · Ctrl-C works)
Phase 1  safety            →  1a stoppable (confirm→fix) · 1b true deadline · 1c committed paths
                              1d authority [OPERATOR] · 1e no sleep · 1f branch · 1g status
Phase 2  walk-away pilot   →  one task · hard clock · isolated · notified · recorded
Phase 3  document          →  3a-3h skill + README
Deferred                   →  supervisor (decided by 0c) · worktree (contained runs only,
                              cleared 2026-08-09 by --unattended, not by a hook fix) · the rest
```

**Phase 0 gates Phase 1; Phase 1 gates Phase 2; 1d gates Phase 2 absolutely.**

---

## What changed from v0.1

Driven by independent Codex review, 2026-08-06. Eight findings adopted outright, two adopted with
changes, one point of sequencing disagreed.

**Two factual errors in v0.1, both verified before correcting:**

- *"Four real hops end to end with no operator transport."* **False.** That run failed at hop 4 with
  `exit 143` — an external `SIGTERM`. The longest clean run is three hops. The claim came from a
  directory listing of per-hop `.out` files rather than the log's last line.
- *"Loop mode carries one task; the supervisor gap is large."* **Overstated.** `SKILL.md:289` —
  Codex continues to the next unit within the same task. The supervisor is only needed across tasks.

**Adopted outright:** safety before the walk-away run (#1); a real deadline that clamps the actor
timeout (#2); committed-path checking (#3); the detached-launch checklist (#7); read-only status (#8);
sleep prevention (#9, missed entirely by v0.1); the two corrections above (#6, #10).

**Adopted with changes:**

- **#4 unattended authority** — the concern is adopted as a blocking item; the *prescription* is not.
  It contradicts a standing operator decision and its mechanism is unverified, so it is surfaced for
  the operator with a verification task attached rather than designed here.
- **#5 branch versus worktree** — the technical criticism is accepted and *"90% of a worktree"* is
  withdrawn; but the worktree path is blocked on the `friction-log.md` writer, and the review's own
  acceptance condition for a branch-only pilot is met by walking away. Branch now, worktree later.
  *(This records the 2026-08-06 review as it stood. The worktree block was cleared on 2026-08-09 for
  contained runs — see fact 6 and 1f. The branch-first decision for the pilot is unaffected.)*

**Disagreed:** the review's order puts six safety items before any proof. Phase 0 keeps the *attended*
proof first — it is free, it is safe at the keyboard, and if nested launching fails it changes the
shape the safety work has to fit. Safety before the *walk-away* run: agreed. Safety before *any* run:
no.

---

## Open questions for the operator

1. ~~**Unattended authority (1d).**~~ **ANSWERED 2026-08-07.** The operator revisited narrowly, as
   recommended: no push, no tool-side network, for unattended runs only. The attended posture is
   unchanged. The mechanism was verified first (§ 1d, and
   `runs/probe-contained-authority-2026-08-07.md`). No longer an open question — and **no longer a
   blocker at all.** The profile was built as `dispatch.sh --unattended` and its effective policy
   measured from inside a child the dispatcher launched (`runs/probe-unattended-integration-2026-08-07.md`,
   21/0). 1d is complete. **Updated 2026-08-07 (second round):** the Phase 2 blockers are **1a**
   (a fully detached descendant still survives the stop — narrowed, not closed) and **1f**
   (branch/worktree isolation unproven). An earlier revision of this line said 1a was complete; that
   was withdrawn when the completion claim was rejected on assessment.
2. ~~**Launch path (0a).**~~ **ANSWERED 2026-08-07 by Phase 0.** Nested children *do* work from inside
   a Codex task, but only outside the ordinary command sandbox — inside it, the child fails before
   initializing (`Operation not permitted`, and Claude reports `Not logged in`). **Direct detachment
   fails**: the background process is reaped before the dispatcher starts, leaving an empty console,
   no lock and no run log. **The accepted and proven launch shape is the supervised terminal session
   under `caffeinate -i`** — § 0b's own stated fallback, exercised end-to-end by the 0c run. So yes:
   launching one command yourself is acceptable, and it is now the only shape with evidence behind
   it. Nothing here blocks Phase 2.
3. ~~**Review.**~~ **ANSWERED — independent review has happened.** v0.2 was reviewed, returning a
   not-approved verdict with five findings; four were accepted and fixed and one was disputed on the
   facts (see *Review round* in the status block). Codex has since independently corrected the 1d
   network finding and produced the Phase 0 evidence. Review is no longer a pending question — though
   note the review round's own row 1 has since been superseded, because Phase 0 showed part of my
   reply to it was wrong.

**No questions remain open for the operator.** What is left is unbuilt and unproven work — the two
Phase 2 blockers — not decisions.
