---
task: axcion-harness-v0-2-readiness-fixes
turn: codex
---

## Objective and scope

Bring the canonical attended Axcíon Harness v0.2 launcher to the supervised-readiness boundary the
operator approved on 2026-08-13, using bounded units that are independently implemented and assessed.

The task covers checkout-wide single-writer enforcement, deterministic and honest post-hop outcome
classification, default prevention of nested AI expansion, narrowly authorised attended edit
authority, and proportionate supervised adoption evidence. It excludes unattended operation,
`bypassPermissions`, external actions, automatic push or merge, strategic routing, portfolio
scheduling, a dispatcher rewrite, and permission widening beyond the per-run attended `acceptEdits`
authority the operator approved on 2026-08-13.

The named task exit condition is: every retained supervised-readiness requirement has either been
implemented and accepted with fail-capable evidence, or explicitly disposed of from current
repository evidence; the required live supervised trials have produced an explicit adopt, revise,
continue-trial, or stop decision; and no result claims unattended readiness.

## Lane and unit

Standard. Implementation mode. Unit 6 — add honest per-hop actor and nested-actor observation to the
canonical attended carrier before live trials begin.

Named reason for the loop: the readiness task spans independently assessable changes and live trials,
must survive multiple Claude/Codex turns, needs strict boundaries to avoid a broad launcher rewrite,
and requires assessment by Codex rather than acceptance by its implementer.

## Brief

Unit 5 established that the retained trial contract requires actor and nested-actor counts, while the
canonical carrier currently records neither an observed nested count nor evidence that can substitute
for it. This prerequisite must land before live trials because the observation is per-hop; adding it
afterward would require repeating every trial. It directly advances Priority 5 without authorising
nested AI or broadening the attended-only scope.

**Required outcome.** The canonical attended carrier records a stable, machine-readable observation
of actor count and nested Claude/Codex actor count for every live hop, both in the existing run log and
the terminal `RESULT` evidence. The evidence must describe exactly what was observed and must not
claim stronger containment than the observation supports.

**Governing sources and disposition.** The operator-approved task scope governs the attended-only
boundary. `plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`
Priority 3 and Priority 5 are non-governing assessment material whose retained evidence requirement
is being implemented here. The executable Work Loop core and current `work-loop-v2` skill govern
roles, state and stopping. Unit 5's accepted discovery is verified repository evidence for the gap
and its limits, not authority for a specific implementation mechanism.

**Check against the repository before acting.** Verify in
`scripts/axcion-harness-v0.2/carry-turn.sh` and its tests that: (1) one live invocation launches one
top-level actor; (2) the carrier tracks an actor process-group identity but does not currently census
or report Claude/Codex processes within that observation boundary; (3) the current `RESULT` evidence
has no actor-count or nested-actor-count field; and (4) existing process termination, timeout,
classification and dry-run behavior can remain intact. For each absence, report the bounded searched
surface and pattern. If a premise is false in a way that changes the evidence contract, stop and hand
back rather than improvising.

**Scope.** Change only the canonical attended carrier and its directly corresponding test file under
`scripts/axcion-harness-v0.2/`, plus this task state file. Choose the smallest reliable observation
mechanism after inspecting the live process model. Preserve existing result fields and add stable
machine-readable count evidence rather than creating another evidence artifact or state system.

**Semantic constraint.** The recorded value must be labelled and documented as an observation within
the carrier's actual process boundary. A zero may mean only that no nested Claude/Codex process was
observed there during the carrier's observation window. Requested deny argv, a successful hop, or the
absence of a denial must never be treated as proof of observed zero. If reliable observation during
the hop cannot be implemented proportionately on the supported host surface, stop with evidence.

**Excluded.** Do not run a live model or carrier trial; invoke Claude or Codex as a child; authorise
nested actors; change the mandatory deny set, permission modes, allowlist policy, exit taxonomy,
Work Loop skill, current-position intake behavior, dispatcher spike, or unattended path; create trial
tasks, worktrees or evidence templates; or reopen Units 1–5 and their deferrals.

**Required evidence.** First demonstrate a failing test or fixture showing the current carrier lacks
the required count evidence. Then show fail-capable coverage for at least: one top-level actor with no
observed nested actor; an observed nested Claude or Codex process producing a nonzero nested count;
the stable run-log and `RESULT` fields; and no regression to existing live/dry-run classification,
timeout/termination, permission evidence or result parsing. Use simulated local processes in tests,
not real model launches. Report exact commands and outcomes, the implementation commit, and any
observation blind spot that remains.

**Completion condition.** Implement the smallest honest observation, run the focused regression
suite plus the canonical carrier suite, update this state file with repository-grounded evidence,
commit all in-scope changes, set `turn: codex`, and stop.

**Stop conditions.** Hand back if the verified process model makes the proposed evidence misleading,
if reliable observation requires a new supervisor or cross-platform subsystem, if meaningful tests
would require a real model launch, or if the change cannot remain inside the two canonical carrier
files. Stop for the operator if the only route requires nested-AI authority, unattended operation,
broader permissions, destructive action, or acceptance of a material readiness risk. Challenge a
false premise rather than expanding scope.

## Latest result

Inspected (2026-08-13):

- Claim (1) — one live invocation launches one top-level actor: HOLDS. Read
  `scripts/axcion-harness-v0.2/carry-turn.sh`; `launch_actor` is called once, at the end of the
  carry (one call site, grep `launch_actor\|run_bounded`), and `run_bounded` backgrounds exactly one
  command (`"$@" >>"$out" 2>&1 &`). Each actor branch calls `run_bounded` once and returns.
- Claim (2) — the carrier tracks an actor process-group identity but does not census or report
  Claude/Codex processes inside it: HOLDS. `set -m` plus `ACTOR_PGID="$pid"` records the identity
  (7 `ACTOR_PGID` references, all termination or signal handling). Searched `carry-turn.sh` for
  `pgrep|ps -|\bps \b|census|nested_count|actor_count|actors=|nested=`; the only matches were the
  `pgid` parameter of `terminate_actor_group` and a comment. No process census existed.
- Claim (3) — the `RESULT` evidence has no actor-count or nested-actor-count field: HOLDS. The single
  `result_line` printf carried nine fields: `outcome code task mode actor turn_before turn_after
  denials partial`. `actor=` names which actor ran, not how many. Searched
  `carry-turn.test.sh` for `actors=|nested=|nested_actor|actor_count|pgrep|census`; no match, so the
  suite asserted nothing about counts either.
- Claim (4) — existing termination, timeout, classification and dry-run behaviour can remain intact:
  HOLDS. The census needed only two added calls inside `run_bounded`'s existing poll loop and two
  appended `RESULT` fields; `classify_hop`, `terminate_actor_group`, the timeout path and the
  dry-run path are unchanged. Confirmed by the suite: 268 pre-existing assertions passed before the
  change and all 268 still pass after it.

Result: the canonical attended carrier now observes and reports, for every live hop, how many
top-level actors it launched and how many processes named `claude` or `codex` were seen inside the
actor's process group. Both counts appear on the terminal `RESULT` line (`actors=<n>
nested=<n|unobserved|n/a>`) and in the run log's evidence block. The observation is labelled as an
observation: `nested=0` states that nothing was seen by that rule, in that group, during that
window, and the run log says in words that this is "not proof that none existed". A census that
could not run reports `unobserved`, never `0` — the same three-state honesty the permission evidence
already uses. Nothing here prevents nesting; the mandatory `--disallowedTools` set is unchanged and
is a separate claim.

The mechanism is `ps -o pid=,pgid=,comm= -g <actor pgid>`, sampled once at launch and once per
second while the actor runs, counting entries whose `comm` basename is `claude` or `codex` and whose
pid is not the actor's. A sample counts only if it saw the top-level actor, so an unreadable group
cannot become an observed zero. Maximum observed count is reported.

Process model verified live on this host on 2026-08-13, before choosing the mechanism: `set -m`
gives the actor its own process group (actor pid 32912 = pgid 32912, distinct from the script's
32899) and a background grandchild inherits it; `ps -g` returns exactly that group; `ps -o comm=`
reports the path a process was invoked by, not the resolved symlink target, so both real installs
are recognised (PATH `claude` resolves through a symlink to a version-numbered file; the VS Code
build is `.../native-binary/claude`; the default `--codex-bin` ends in `codex`); and of the 26
`claude`/`codex` processes then running, none had a `claude` or `codex` parent, so a same-named
worker fork is not a known false-positive source here.

Evidence:

- Failing case first. Section 16 was written against the unmodified carrier and run:
  `./carry-turn.test.sh` → `passed: 268 failed: 17`, every failure in section 16 ("missing
  'actors=1 nested=0'", "missing 'actors=1 nested=2'", "missing 'nested=unobserved'").
- After the implementation: `./carry-turn.test.sh` → `passed: 285 failed: 0`. 268 + 17 = 285, so the
  pre-existing suite is intact and no assertion was traded away.
- Coverage added, all with simulated local processes and no model launch: one top-level actor with
  no observed nested actor (`actors=1 nested=0`, plus the wording that refuses to read the zero as
  containment); processes genuinely named `claude` and `codex` running inside the actor's process
  group (`actors=1 nested=2`, both named in the evidence block); the same on a Codex hop; an actor
  that execs into a process named `claude` not counting itself; a host whose `ps` fails reporting
  `nested=unobserved` and "NO OBSERVATION"; and the no-launch paths (dry run, refused permission
  mode) reporting `actors=0 nested=n/a`. The run log is asserted separately from the terminal output.
- Fail-capability proof: `./carry-turn.test.sh --prove-failure` → `passed: 40 failed: 0`, with three
  new mutants. M16 removes both census calls, M17 removes the top-level-actor exclusion, M18 reports
  an unrun census as `0`. Each makes its assertions fail, and each carries a control assertion
  showing the hop still launched — so the failures are caused by the removed invariant, not by an
  aborted launcher.
- Implementation commit: recorded below by this handback's own commit.

Observation blind spot that remains, found while testing rather than assumed: a nested actor started
through a wrapper or interpreter is invisible to this rule. A `#!/bin/bash` script named `claude`
reports `comm` as `/bin/bash`, so it is not counted. The first version of test 16.4 was passing for
exactly that reason and was rewritten to `exec` into a genuinely named process. Also outside the
rule: a renamed or copied binary; a process that starts and exits between two ~1s samples; a process
that leaves the group via `setsid` or a daemonising launcher; and anything after the hop ends. All
are listed in the carrier's own header.

Prior units: Unit 5 accepted after its single frozen correction — the minimum is 13 carrier
invocations across five trial tasks, Priority 5's nine-field contract is intact, and
authoritative-current-position refusal is disposed as out of scope and unmet, which prevents this
task from claiming the assessment's compound "Ready for supervised semi-agentic use" label. The
operator remains the launcher for canonical trials. No current live evidence counts after Units 1–4.
Live trials, dedicated checkout authorization and the adoption decision remain ahead.

Accepted implementation commits: Unit 1 `e2ac00d96cbc0a65c9883517a505a4250debf8c4`; Unit 2 correction
`bb0af1b298668a917fe9e39b61a0278fba363d3b`; Unit 3 implementation
`53dc76c13b91ed5df4a2c12b590066e8e80754e6` and correction
`51b140a02a0031107960e78bd0b802fbc0363ecd`; Unit 4
`e04a8f095e4dfdd058e707d4247cd9572208a907`.

Deferred: older-option missing-value parser loops; undocumented CLI `default`; no equivalent nested
deny on the Codex actor path; exit-taxonomy divergence; `jq` permission-evidence dependency; default
allowlist review; hook-owned `logs/friction-log.md` dirt; cosmetic temporary-lock formatting; Work
Loop courier/taxonomy divergence; and the realistic trial budget exceeding 13 if corrections occur.

New deferrals noticed during Unit 6, recorded and not done:

- Wrapper- and interpreter-launched nested actors are not observed. Closing that would mean matching
  the whole argv rather than the executable name, which trades a blind spot for false positives and
  needs its own design decision. Out of this unit's "smallest honest observation" scope.
- The `RESULT` line now carries eleven fields. If it grows further, a documented field order or a
  parsing helper would be worth having; two fields did not justify one now.

## Blocker

None.

## Next action

Codex: assess Unit 6 — whether the observation mechanism is honest about what it can and cannot see,
whether the fail-capable evidence supports the two new fields, and whether the recorded blind spots
are acceptable before live trials begin.
