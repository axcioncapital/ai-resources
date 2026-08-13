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

Correction round on Unit 3. One frozen finding, reproduced then corrected. Correction commit
`51b140a02a0031107960e78bd0b802fbc0363ecd`, on top of the Unit 3 implementation
`53dc76c13b91ed5df4a2c12b590066e8e80754e6`.

**Finding 1 — RESOLVED.** Reproduced by inspection before any change:

- `claude --help` line 64 on `2.1.220`: `--disallowedTools, --disallowed-tools <tools...>` / "Comma
  or space-separated list of tool names to deny (e.g. \"Bash(git *) Edit\")". The CLI's own example
  is written in the space form.
- `grep -n -A5 '^CLAUDE_DENY_MANDATORY=(' scripts/axcion-harness-v0.2/carry-turn.sh` returned two
  entries, `'Bash(claude:*)'` and `'Bash(codex:*)'` — colon form only.
- Searched `plans/work-loop-v2-v0.2/handoff-automation-spike/` for the historical set:
  `dispatch.sh:345-350` defines `NESTED_ACTOR_DENY` with all four forms, and its comment gives the
  reason — "which one the installed build honours is not worth guessing at when listing both costs
  one array entry". `README.md:399` states the same four. Read for the finding only; no spike test
  result is used as acceptance evidence here.

The finding is correct as stated. Colon-only argv evidence proves two strings reach the command
line, not that the ordinary direct route is denied.

**The correction.** `CLAUDE_DENY_MANDATORY` now carries, in this order, `Bash(claude:*)`,
`Bash(claude *)`, `Bash(codex:*)`, `Bash(codex *)`. Requested on every canonical attended Claude
launch. Unchanged: no override flag, operator `--claude-deny` still appends after the mandatory set,
`--permission-mode default`, task routing, output capture, the attended-only boundary, and the
non-containment wording.

Evidence:

1. Post-correction argv, no `--claude-deny`: `[--disallowedTools] [Bash(claude:*)] [Bash(claude *)]
   [Bash(codex:*)] [Bash(codex *)]`, with `--permission-mode default` still present.
2. Post-correction argv, two operator rules, asserted as an exact ordered string:
   `[--disallowedTools] [Bash(claude:*)] [Bash(claude *)] [Bash(codex:*)] [Bash(codex *)]
   [Bash(git push:*)] [WebFetch]`. `grep -cFx '[--disallowedTools]'` returns `1`, so it remains one
   flag and one list, mandatory first.
3. New mutant M12 removes only the two space-form entries. Both space-form assertions correctly
   fail, and two control assertions show `[Bash(claude:*)]` and `[Bash(codex:*)]` still arrive. That
   control is the point of the mutant: it demonstrates the exact pre-correction state, in which a
   colon-only suite stayed green. M10 (flag dropped) and M11 (operator rules replace the mandatory
   set) now fail on all four rules. `--prove-failure` reports `passed: 26   failed: 0`.
4. Help and run output. `carry-turn.sh --help` (exit 0) lists all four rules and states why both
   forms are present: "which one an installed build honours is not established and listing only one
   would rest the policy on that guess". A live run prints `requesting Bash(claude:*) Bash(claude *)
   Bash(codex:*) Bash(codex *) on every Claude hop — mandatory, no override; --claude-deny appends
   after it.` The non-containment and no-override text is unchanged and still asserted.
5. Parser probe, no model launched:
   `claude --disallowedTools 'Bash(claude:*)' 'Bash(claude *)' 'Bash(codex:*)' 'Bash(codex *)'
   --bogus-flag-xyz </dev/null` printed only `error: unknown option '--bogus-flag-xyz'`. The control
   without the deny arguments printed the identical single error, so the parser does report unknown
   options in this mode and accepts all four rule strings, including the space forms.
6. Pre-change failure, re-measured with the corrected tests against a byte-exact copy of the
   pre-Unit-3 launcher: `passed: 172   failed: 26`.

**Did the correction break anything?** No. Full canonical suite `passed: 198   failed: 0`, up from
`189/0` before the correction and `157/0` before Unit 3. Unit 1 lock sections (12, 12b) and Unit 2
classifier section (15) together: 65 ok, 0 FAIL — the same counts as before the correction.

Commands: `bash scripts/axcion-harness-v0.2/carry-turn.test.sh` (exit 0),
`bash scripts/axcion-harness-v0.2/carry-turn.test.sh --prove-failure` (exit 0),
`bash scripts/axcion-harness-v0.2/carry-turn.sh --help` (exit 0). No live Claude or Codex model was
invoked; real-binary calls were `--version`, `--help` and the parser probe above.

Known limit, unchanged by this correction: what is proven is the argv. Whether the child honours a
requested rule is Claude Code's behaviour, and establishing that would need a live nested-model
attempt, which this unit excludes. Listing both forms removes the need to guess which form matches;
it does not turn the argv proof into an enforcement proof.

Nothing newly noticed entered this correction. Deferrals carried forward, unchanged: the Codex actor
path has no equivalent nested-actor policy and closing it would need a mechanism this unit does not
authorise; reconcile the remaining canonical launcher exit numbers with the wider Work Loop taxonomy
(`23`, `29`, `33`–`36`); the `jq` dependency for permission evidence; the default allowlist review;
hook-owned `logs/friction-log.md` dirt; cosmetic temporary-lock path formatting.

## Blocker

None.

## Next action

Codex: run the closure check on the frozen finding only — is finding 1 resolved, and did the
correction break anything. Then close, or use the menu in core § 3.
