---
task: axcion-harness-v0-2-readiness-fixes
turn: codex
---

## Objective and scope

Bring the canonical attended Axcíon Harness v0.2 launcher to the supervised-readiness boundary the
operator approved on 2026-08-13, using bounded units that are independently implemented and assessed.

The task covers the still-current parts of the 2026-08-11 readiness assessment on the canonical
attended surface: checkout-wide single-writer enforcement, deterministic and honest post-hop outcome
classification, default prevention of nested AI expansion, and proportionate supervised adoption
evidence. It excludes unattended operation, external actions, automatic push or merge, strategic
routing, portfolio scheduling, a dispatcher rewrite, and permission widening such as `acceptEdits`
unless the operator separately authorises it.

The named task exit condition is: every retained supervised-readiness requirement has either been
implemented and accepted with fail-capable evidence, or explicitly disposed of from current
repository evidence; the required live supervised trials have produced an explicit adopt, revise,
continue-trial, or stop decision; and no result claims unattended readiness.

## Lane and unit

Standard. Implementation mode. Unit 3 — prevent the canonical attended carrier's Claude child from
using the default direct shell routes to launch nested Claude or Codex work.

Named reason for the loop: the full readiness task spans several independently assessable changes
and live trials, must survive multiple Claude/Codex turns, needs strict boundaries to avoid a broad
launcher rewrite, and requires assessment by Codex rather than acceptance by its implementer.

## Brief

Why this unit, why now: Units 1 and 2 are accepted, so the canonical carrier now enforces one writer
and classifies a stopped hop honestly. The next retained release blocker is the incident-proven path
by which one attended Claude hop can expand into nested Claude or Codex processes.

**Required outcome.** Every canonical attended Claude launch must request denial of the ordinary
direct Bash routes for starting `claude` or `codex`, whether or not the operator supplies additional
`--claude-deny` rules. The mandatory rules must have no override, operator rules must append rather
than replace them, and `--permission-mode default` must remain unchanged. Operator-visible text must
describe this honestly as requested permission policy that blocks the default direct route, not as
OS containment or proof that evasion is impossible.

**Governing authority and source disposition.**

- The operator's 2026-08-13 decision governs this task's canonical attended scope and authorises the
  retained nested-expansion outcome as the next bounded readiness unit.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs roles, fail-capable evidence,
  handback, and commits.
- `plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`
  is non-governing assessment material. Priority 3 establishes the risk and the zero-by-default
  outcome, but its count-and-deadline proposal is not authorised here.
- `plans/work-loop-v2-v0.2/bounded-execution-fix-plan-v0.1.md` is non-governing background. Its
  leading `--disallowedTools` candidate, rejection of an override, and requested-policy-versus-
  containment distinction may inform the design but do not replace live inspection.
- The old spike dispatcher and its tests are historical comparison only. Do not copy them or use
  their green suite as acceptance evidence for the canonical launcher.

**Check against the repository before acting.**

1. In both in-scope canonical files, verify the exact argv produced for a Claude hop with no
   `--claude-deny` and with one or more operator rules. Establish whether the plain path currently
   omits `--disallowedTools` and whether the narrowed path currently carries only operator input.
2. Verify that the existing fake-binary seam records the real argv assembled by the canonical
   launcher and can distinguish absence, mandatory defaults, and additive operator rules. If it
   cannot fail on those distinctions, stop rather than substituting a text grep.
3. Check the installed Claude CLI's accepted `--disallowedTools` argument shape using existing
   help/version evidence or a non-model parser probe only. Do not launch a real model or nested AI.
4. Inspect the canonical Codex launch path only far enough to state whether an equivalent native,
   already-used deny mechanism exists. This unit does not authorise wrappers, PATH interception,
   hooks, sandbox redesign, or other new machinery. If the approved outcome cannot honestly be met
   without such a mechanism, hand back that precise gap rather than widening the unit.
5. Verify Unit 2's correction commit `bb0af1b298668a917fe9e39b61a0278fba363d3b` is present before
   changing the launcher. Stop on a false premise rather than rebuilding prior units.

**Scope.** Change only:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this task state file

The implementation mechanism is Claude's decision within those surfaces. Reuse the existing Claude
permission-narrowing path if inspection supports it. Add no flag, override, registry, wrapper,
process supervisor, hook, settings file, or second policy source.

**Codex framing decisions and held-back work.** This unit covers the known attended Claude-child
expansion path and both ordinary direct targets, `claude` and `codex`. It excludes live nested-model
attempts, arbitrary shell-evasion claims, containment, authorised nesting, invocation budgets,
correction budgets, permission-mode widening, classifier/taxonomy reconciliation, adoption trials,
and unattended behavior. The broader exit-taxonomy concern noticed during Unit 2's correction is
deferred because correction protocol forbids reopening Unit 2 and it does not block this unit.

**Required fail-capable evidence.** Exercise the canonical launcher path and show:

1. pre-change, a normal attended Claude argv lacks the mandatory nested-actor deny set;
2. post-change, both the no-extra-deny and operator-extra-deny shapes carry rules covering direct
   Bash invocation of both `claude` and `codex`;
3. operator `--claude-deny` values append verbatim and cannot displace the mandatory set;
4. `--permission-mode default`, task routing, output capture, and a normal committed handback retain
   their existing behavior;
5. help/run output says the rules are requested policy rather than containment and exposes no
   override;
6. a mutation that removes or bypasses the mandatory set makes the relevant assertions fail;
7. Unit 1 lock cases, Unit 2 classifier cases, and the full canonical suite still pass.

Report exact commands, exit statuses, relevant argv/output, the pre-change failure, mutation result,
full-suite result, changed paths, and exact commit id. No live Claude/Codex invocation and no old
spike test result count as evidence for this unit.

**Completion condition.** Implement and commit the bounded default nested-actor policy on the
canonical attended Claude launch path, with the evidence above; update this file with the current
result, set `turn: codex`, and stop. Do not begin adoption trials or adjacent cleanup.

**Stop conditions.** Hand back without implementation if the canonical fake-argv seam cannot prove
the policy, if installed Claude does not support the required deny shape, if a load-bearing Codex
actor gap makes the required outcome misleading, or if the change requires anything outside scope.
Stop for the operator if it requires permission widening, an override for nested work, containment,
or a change to the attended-only boundary.

## Latest result

Inspected (2026-08-13):

- Claim (1): HOLDS — read `scripts/axcion-harness-v0.2/carry-turn.sh` `launch_actor`, pre-change
  lines 631–640. Two branches. The `${#CLAUDE_DENY[@]} -gt 0` branch passed
  `--disallowedTools "${CLAUDE_DENY[@]}"` — operator input only, nothing else. The `else` branch
  passed no `--disallowedTools` at all. Confirmed against real argv, not by reading: the fake-actor
  seam recorded `[-p] [/work-loop-v2 task-an] [--output-format] [json] [--permission-mode]
  [default]` for a plain hop and `... [--disallowedTools] [Bash(git push:*)] [WebFetch]` for an
  operator-deny hop.
- Claim (2): HOLDS — read `carry-turn.test.sh` lines 6–11, 92–104 and 278–294. The suite passes the
  fake binary through the ordinary `--claude-bin` option, so the launcher assembles and executes its
  real argv; the fake records it. It distinguishes absence, mandatory defaults and additive operator
  rules. One weakness, fixed inside this unit's scope rather than handed back: the recorder used
  `"$*"`, which joins with spaces and so cannot tell `--disallowedTools 'A B'` from
  `--disallowedTools A B`. It now also writes one bracketed argument per line, and every new
  assertion reads that file.
- Claim (3): HOLDS — `claude --version` reports `2.1.220 (Claude Code)`. `claude --help` line 64
  reads `--disallowedTools, --disallowed-tools <tools...>` / "Comma or space-separated list of tool
  names to deny (e.g. \"Bash(git *) Edit\")" — variadic, multi-value. Parser probe, no model
  launched: `claude --disallowedTools 'Bash(claude:*)' 'Bash(codex:*)' --bogus-flag-xyz </dev/null`
  printed only `error: unknown option '--bogus-flag-xyz'`. Control: the same command without the
  deny arguments printed the identical single error, so the parser does report unknown options in
  this mode and its silence about the two-value deny list is meaningful. (`--version` was rejected as
  a probe — it short-circuits before validation and accepted a bogus flag too.)
- Claim (4): HOLDS, and the finding is a gap, not a blocker — searched the canonical Codex launch
  path (`carry-turn.sh` lines 610–619) and `codex exec --help` (`codex-cli 0.147.0-alpha.6.5`) for a
  per-command or per-tool deny mechanism. None exists: the options are sandbox modes
  (`read-only | workspace-write | danger-full-access`), config overrides, feature toggles and
  approval routing. The canonical path already uses `--sandbox workspace-write`, which is a
  filesystem policy and not a launch-deny list. This does not make the required outcome misleading,
  because that outcome is scoped to the Claude launch path — so no wrapper, PATH interception or
  hook was added. The launcher's help block now states the gap in words rather than leaving the
  policy to read as if it covered both actors.
- Claim (5): HOLDS — `git log --oneline -1 bb0af1b298668a917fe9e39b61a0278fba363d3b` returned
  `bb0af1b fix: carry-turn.sh — permission dead end is exit 37, not 27`.

Result: Unit 3 implemented and committed as `53dc76c13b91ed5df4a2c12b590066e8e80754e6`. Every
canonical attended Claude launch now requests `--disallowedTools 'Bash(claude:*)' 'Bash(codex:*)'`.
The mandatory set is a fixed array that is not derived from caller input, the two launch branches
collapse into one line so no path can omit the flag, operator `--claude-deny` values append after
the mandatory rules in one list, and there is no flag that drops or replaces them.
`--permission-mode default` is unchanged. Changed paths: `scripts/axcion-harness-v0.2/carry-turn.sh`,
`scripts/axcion-harness-v0.2/carry-turn.test.sh`.

Evidence:

1. Pre-change failure. The final test file was run against a byte-exact copy of the pre-change
   launcher (`sha256 ec50f1fa16e4de0cf3e256207c57bf93aed35ae1645ecbea46e6b651c772e397`):
   `passed: 171   failed: 18`. The 18 are exactly the new claims — `plain launch requests
   --disallowedTools at all`, `denies direct Bash launch of claude`, `denies direct Bash launch of
   codex`, `operator rules do not displace the claude rule`, the codex twin, `mandatory rules
   precede the operator's`, the eight help-text assertions and the four run-output assertions.
2. Post-change argv, no `--claude-deny`. `[--disallowedTools] [Bash(claude:*)] [Bash(codex:*)]`,
   with `--permission-mode default` still present.
3. Post-change argv, two operator rules. Recorded in order:
   `[--disallowedTools] [Bash(claude:*)] [Bash(codex:*)] [Bash(git push:*)] [WebFetch]` — asserted as
   an exact string, with `grep -cFx '[--disallowedTools]'` returning `1`, so the operator's rules
   append verbatim into one list and cannot displace the mandatory pair.
4. Unchanged behaviour. `--permission-mode default` asserted on both shapes; task routing, output
   capture, transition validation and the committed handback covered by the existing sections, all
   green. A Codex hop's argv still carries no `--disallowedTools` and no `Bash(claude:*)`.
5. Honest text. `carry-turn.sh --help` (exit 0) prints `REQUESTED PERMISSION RULES`, `They block the
   DEFAULT DIRECT ROUTE`, `They are not OS containment, not a sandbox, not a process limit, and NOT
   proof that nesting is impossible`, `with or without --claude-deny, there is no flag to turn it
   off`, and `The Codex actor path carries NO equivalent`. A live run prints `nested-actor policy:
   requesting Bash(claude:*) Bash(codex:*) on every Claude hop — mandatory, no override;
   --claude-deny appends after it.` and `it is not containment and not proof that nesting is
   impossible.` No override flag exists — asserted by absence checks over the launcher source.
6. Mutation. `--prove-failure` reports `passed: 18   failed: 0`. M10 drops `--disallowedTools` from
   the launch line: all three rule assertions correctly fail. M11 seeds `deny_all` empty so operator
   rules become the whole list: both displacement assertions correctly fail. Each mutant carries a
   control assertion proving the hop still launched — the first M10 attempt emptied the mandatory
   array instead, which aborts the launcher under `set -u` on bash 3.2, and its assertions "failed"
   for the wrong reason. That mutant was replaced.
7. Regression. Full canonical suite `passed: 189   failed: 0` (baseline before this unit: `157/0`).
   Unit 1 lock sections (12, 12b) and Unit 2 classifier section (15) together: 65 ok, 0 FAIL.

Commands: `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` (exit 0),
`bash scripts/axcion-harness-v0.2/carry-turn.test.sh --prove-failure` (exit 0),
`bash scripts/axcion-harness-v0.2/carry-turn.sh --help` (exit 0). No live Claude or Codex model was
invoked; the only real-binary calls were `--version`, `--help` and the argument-parser probe above.

Known limit, stated rather than tested around: what is proven here is the argv. Whether the child
honours a requested rule is Claude Code's behaviour, and proving it would need a live nested-model
attempt, which this unit excludes.

Deferred, noticed during this unit and not implemented: the Codex actor path has no equivalent
nested-actor policy, and closing it would need a mechanism this unit does not authorise (wrapper,
PATH interception, hook, or sandbox redesign). Deferrals carried forward: reconcile the remaining
canonical launcher exit numbers with the wider Work Loop taxonomy (`23`, `29`, `33`–`36`); the `jq`
dependency for permission evidence; the default allowlist review; hook-owned `logs/friction-log.md`
dirt; cosmetic temporary-lock path formatting.

## Blocker

None.

## Next action

Codex: assess Unit 3 against its completion condition — the mandatory nested-actor deny set on every
canonical attended Claude launch, additive operator rules, no override, unchanged
`--permission-mode default`, honest operator-visible text, and fail-capable evidence including the
pre-change failure, both mutants and the full suite. Then close, continue, correct once, or stop.
