---
task: axcion-harness-v0-2-readiness-fixes
turn: codex
---

## Objective and scope

Bring the canonical attended Axcíon Harness v0.2 launcher to the supervised-readiness boundary the
operator approved on 2026-08-13, using bounded units that are independently implemented and assessed.

The task covers the still-current parts of the 2026-08-11 readiness assessment on the canonical
attended surface: checkout-wide single-writer enforcement, deterministic and honest post-hop outcome
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

Standard. Implementation mode. Unit 4 — add the narrowly authorised, per-run attended permission-mode
mechanism needed to resume a permission-interrupted Claude hop inside the canonical carrier.

Named reason for the loop: the readiness task spans independently assessable changes and live trials,
must survive multiple Claude/Codex turns, needs strict boundaries to avoid a broad launcher rewrite,
and requires assessment by Codex rather than acceptance by its implementer.

## Brief

Why this unit, why now: Units 1–3 are accepted, and the operator has now authorised the narrow
attended `acceptEdits` capability needed for the retained permission-interruption/resume trial. This
unit adds only that opt-in carrier mechanism; proving its effect in a live supervised trial remains a
separate later unit.

**Required outcome.** The canonical attended carrier must let an operator explicitly request either
`default` or `acceptEdits` for a Claude hop. `default` remains the default and existing invocation
behavior stays unchanged when no option is supplied. `acceptEdits` is opt-in for one invocation,
applies only to Claude, and its launch evidence must identify that operator-approved widening and the
effective allow-path set it is bounded by. Every other permission mode, especially
`bypassPermissions`, must fail closed before an actor launches. No settings file is changed.

**Governing authority and source disposition.**

- The operator's 2026-08-13 decision in this task governs: narrowly bounded attended `acceptEdits`
  and its supervised trial are authorised. The authorization does not cover unattended operation,
  `bypassPermissions`, external actions, automatic push/merge, or broader permission widening.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs roles, fail-capable evidence,
  handback, and commits.
- `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` § “The operator decision — attended
  acceptEdits” was non-governing background before this decision. Its narrow reversible boundary now
  accurately describes the authorised outcome: per-run opt-in, only `default` and `acceptEdits`,
  rejection of bypass, approval recorded with covered paths, no unattended combination, and no
  settings mutation. It does not settle implementation details beyond that outcome.
- The 2026-08-11 readiness assessment remains non-governing assessment material. Its permission
  interruption/resume trial justifies why the mechanism is needed, but this unit does not run it.

**Check against the repository before acting.**

1. In `carry-turn.sh`, verify the current parser refuses `--permission-mode`, the Claude argv
   hardcodes `default`, and no supported per-run permission-mode input already exists. Establish this
   from the parser, launch path, help and matching tests rather than assuming the earlier inspection
   is still current.
2. In `carry-turn.test.sh`, verify the fake-binary seam records the actual assembled Claude argv and
   can distinguish omitted input/default, explicit default, `acceptEdits`, invalid values, and
   actor-not-launched failures. Stop if it cannot produce fail-capable evidence without a live model.
3. Verify how the canonical launcher resolves default and operator-supplied allow paths, and identify
   the existing run-output seam that can record the effective set without adding a second evidence
   file or state source.
4. Verify the accepted Unit 3 correction commit
   `51b140a02a0031107960e78bd0b802fbc0363ecd` is present before changing the launcher. Stop on a false
   premise rather than rebuilding accepted work.

**Scope.** Change only:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this task state file

The option name and internal construction are Claude's decisions within those surfaces. Reuse the
existing argument parser, argv capture and run output. Add no settings file, approval ledger, token,
registry, wrapper, hook, daemon, unattended path, or second policy source.

**Codex framing decisions and held-back work.** This unit implements request transport and honest
evidence only. It does not prove that Claude Code honours `acceptEdits`, deliberately trigger a real
permission denial, resume a real task, run any adoption trial, alter deny rules, reconcile exit
taxonomy, or address the Codex actor's lack of an equivalent nested-actor policy. Those are held back
because the current unit has one dominant deliverable and live operating evidence must be assessed
separately.

**Required fail-capable evidence.** Exercise the canonical launcher with the fake actor and show:

1. pre-change, an explicit `acceptEdits` request is refused or cannot reach Claude argv;
2. omitted input and explicit `default` both launch Claude with exactly `--permission-mode default`;
3. explicit `acceptEdits` launches Claude with exactly `--permission-mode acceptEdits`, without
   changing the mandatory nested-actor denies or operator-added denies;
4. missing, unknown, differently cased and bypass-like values fail as `BAD_USAGE` before any actor
   launches or lock/run side effects begin;
5. operator-visible help and run output state that `acceptEdits` is an explicit one-invocation
   widening, name the effective allow-path set it covers, preserve the no-containment claim, and do
   not imply that path checking prevents writes;
6. Codex hops, unattended-boundary refusals, default invocations, task routing, output capture and
   post-hop classification retain their accepted behavior;
7. a mutation that hardcodes `default`, accepts an unauthorised value, or omits the approval/path
   evidence makes the relevant assertions fail; use the smallest mutant set that proves these
   distinctions rather than a broad matrix;
8. the full canonical suite, including Units 1–3, passes.

Report exact commands and exits, relevant argv/output, pre-change failure, mutation result, full-suite
result, changed paths and exact commit id. Use no live Claude or Codex model and do not begin the
permission-interruption trial.

**Completion condition.** Implement and commit the bounded attended permission-mode mechanism with
the evidence above; update this file with the current result, set `turn: codex`, and stop.

**Stop conditions.** Hand back if the fake-argv seam cannot prove the mechanism, if `acceptEdits` is
not accepted by the installed CLI parser, if truthful approval/path evidence requires a new state
system, or if the change needs anything outside scope. Stop for the operator if implementation would
enable unattended use, `bypassPermissions`, settings mutation, external action, automatic push/merge,
or permission widening beyond the decision recorded here. Challenge a false premise rather than
improvising.

## Latest result

Inspected (2026-08-13):

- Claim (1): HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.sh` and searched it for
  `--permission-mode` and for `PERMISSION_MODE|permission_mode|PERM_MODE`. The parser refused
  `--permission-mode` in `refuse_flag` (line 243, exit 10); the Claude launch hardcoded
  `--permission-mode default` (line 698); the help block asserted the mode "is not an option and
  there is no flag to turn it off" (line 42); `carry-turn.test.sh` section 7 asserted the refusal.
  The variable search returned no match, so no per-run permission-mode input existed.
- Claim (2): HOLDS — read the fake actor in `carry-turn.test.sh` (lines 92–161). It writes the joined
  argv to `$ARGV_LOG` and the same argv one-bracketed-argument-per-line to `$ARGV_LOG.args`,
  truncated per launch, and appends one byte per invocation to `$COUNT` (`invocations()`, line 227).
  Bracketed per-argument capture distinguishes a flag's value from an adjacent argument; the
  invocation counter distinguishes "refused before launch" from "launched and failed". Fail-capable
  without a live model.
- Claim (3): HOLDS — `ALLOW_PATHS` is seeded from repeatable `--allow-path` (line 263) and defaults
  to `^logs/work-loop/` and `^logs/harness-runs/` when none is supplied (lines 279–281). The
  existing run-output seam is `say`, which writes to stdout and to `$RUN_LOG` together; the launcher
  already prints `allow-path: ${ALLOW_PATHS[*]}` at line 996. No second evidence file or state source
  is needed.
- Claim (4): HOLDS — `git cat-file -t 51b140a02a0031107960e78bd0b802fbc0363ecd` returned `commit`;
  `git log --oneline -1` returned "fix: carry-turn.sh — mandatory nested-actor set carries both rule
  forms".

Result: the bounded per-run attended permission-mode mechanism is implemented and committed in
`e04a8f095e4dfdd058e707d4247cd9572208a907`. `--claude-permission-mode` accepts exactly `default` and
`acceptEdits`, case-sensitive; `default` is what an absent option gives and existing invocation
behaviour is unchanged. `acceptEdits` reaches the Claude hop only, for one invocation, and is stored
nowhere. Every other value fails as `BAD_USAGE` before the lock, the run log and any actor. The raw
`--permission-mode` flag stays refused and now names the authorised route. No settings file changed.

Evidence:

1. Pre-change refusal — ran `git show HEAD:…/carry-turn.sh` into a scratch copy against a scratch
   checkout. `--claude-permission-mode acceptEdits` → exit 10, `STOP [10] unknown argument:
   --claude-permission-mode`. `--permission-mode acceptEdits` → exit 10, "is refused: attended Claude
   hops are always launched with --permission-mode default and that is not adjustable".
   `grep -c acceptEdits` on that copy returned `0`. The request could not reach Claude argv.
2. Omitted input and explicit `default` — suite 5c(a) and 5c(b). The per-argument log carries exactly
   one `[--permission-mode]`, and the argument after it is `[default]`.
3. Explicit `acceptEdits` — suite 5c(c). The pair is `[--permission-mode] [acceptEdits]`, `[default]`
   is absent, exactly one `--permission-mode` reaches argv, and all four mandatory nested-actor rules
   plus the operator's `Bash(git push:*)` survive unchanged.
4. Unauthorised values — suite 5c(d). `bypassPermissions`, `BypassPermissions`, `bypass`, `auto`,
   `manual`, `dontAsk`, `plan`, `Default`, `DEFAULT`, `AcceptEdits`, `ACCEPTEDITS`, `accept-edits`
   and an empty value each exit 10 with `RESULT outcome=STOPPED code=10`; the invocation counter is
   `0` across all of them. A value-less flag exits 10 rather than spinning. The bypass family gets
   its own refusal wording.
5. Operator-visible honesty — suite 5c(e) on `--help` and 5c(f) on the run output. Both state the
   widening as operator-approved and one-invocation, say it is stored nowhere, refuse the bypass
   reading, print `effective allow-path set: ^logs/work-loop/`, and say that set is detection rather
   than prevention — the child never reads it, and an edit accepted outside it happens first and is
   reported afterwards. The no-containment claim is preserved verbatim.
6. Retained behaviour — the full canonical suite is `261/0`. That is the accepted `198` plus the
   `63` new 5c assertions, so no previously accepted assertion was removed or altered. Codex hops
   (5c(h)) carry no `--permission-mode` and no `acceptEdits`, and announce no widening.
7. Fail-capability proof — `carry-turn.test.sh --prove-failure` is `32/0` with every mutant hitting.
   The three new ones are the smallest set that separates the failure modes: M13 hardcodes `default`
   back into the launch line (the request parses, is silently dropped, and the argv assertion fails);
   M14 admits `bypassPermissions` into the allowlist (the `BAD_USAGE` assertion fails, control shows
   `plan` still refused); M15 removes the allow-path evidence line (the run-output assertion fails,
   control shows the widening still announced). M1 and M10 were re-aimed at the new launch line and
   both still hit.
8. Commands: `bash carry-turn.test.sh` → exit 0, `passed: 261 failed: 0`;
   `bash carry-turn.test.sh --prove-failure` → exit 0, `passed: 32 failed: 0`.

Changed paths: `scripts/axcion-harness-v0.2/carry-turn.sh`,
`scripts/axcion-harness-v0.2/carry-turn.test.sh`. No live Claude or Codex model was used and the
permission-interruption trial was not begun.

Deferred, noticed during this unit and not implemented:

- Every other value-taking option (`--checkout`, `--task`, `--timeout`, `--codex-bin`,
  `--claude-bin`, `--allow-path`, `--claude-deny`, `--log-dir`) spins forever when given as the last
  argument with no value: `shift 2` with one argument left shifts nothing, so the parse loop never
  advances. Verified by running `carry-turn.sh --checkout /tmp --task t --timeout` under an 8-second
  alarm, which returned `142` (SIGALRM) rather than a refusal. Only `--claude-permission-mode` is
  guarded, because a permission widening must not be reachable by writing the flag alone. Fixing the
  rest is a parser change touching every option and is not this unit's deliverable.
- Claude Code 2.1.220 accepts `--permission-mode default` (probed directly: exit 0) but does not list
  `default` among its documented choices — the parser's own error names `acceptEdits, auto,
  bypassPermissions, manual, dontAsk, plan`. Unit 1's accepted behaviour works today on an
  undocumented value that a future CLI release could drop.

Carried forward from earlier units: the live supervised trials and the lifecycle decision; the Codex
actor's lack of an equivalent nested-actor policy; remaining launcher exit taxonomy `23`, `29`,
`33`–`36`; the `jq` dependency for permission evidence; default allowlist review; hook-owned
`logs/friction-log.md` dirt; and cosmetic temporary-lock path formatting.

## Blocker

None.

## Next action

Codex: assess Unit 4 against its completion condition — the per-run attended permission-mode
mechanism, its fail-capable evidence, and whether the launch evidence is honest about what
`acceptEdits` does and what the allow-path set does not do. Decide close, continue, correct once, or
stop.
