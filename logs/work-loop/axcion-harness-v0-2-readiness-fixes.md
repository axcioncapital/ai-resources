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

Standard. Implementation mode. Unit 2 — classify every unsuccessful canonical carrier hop from its
actual before/after repository delta and Claude permission evidence.

Named reason for the loop: the full readiness task spans several independently assessable changes
and live trials, must survive multiple Claude/Codex turns, needs strict boundaries to avoid a broad
launcher rewrite, and requires assessment by Codex rather than acceptance by its implementer.

## Brief

Why this unit, why now: Unit 1 is accepted, so one carrier writer now owns a checkout at a time. The
next retained release blocker is honest stopping: an operator must be able to tell whether Claude
was denied permission, whether allowed partial work exists, and whether Claude actually changed the
state file without reconstructing the hop from raw logs.

**Required outcome.** Replace post-hop heuristics on the canonical attended carrier with one
deterministic classification derived from the evidence already available or minimally captured for
the hop: state-file hash and dirty state before/after, HEAD before/after, allowed and disallowed
working-tree deltas, committed-path delta, actor exit/timeout status, resulting `turn:`, and Claude
`permission_denials` when present. Every unsuccessful hop must report the correct outcome, exact
partial allowed paths if any, and a recovery action consistent with Work Loop ownership.

**Governing authority and source disposition.**

- The operator's 2026-08-13 decision governs: use one Work Loop task, target the canonical attended
  launcher, and continue through bounded supervised-readiness units after Unit 1.
- `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` governs Work Loop roles, state,
  evidence, and handback semantics; Claude owns repository reality and every commit.
- `plans/axcion-harness-v0.2/mvp-plan.md` remains relevant but non-governing project direction
  because its header says proposed/no implementation authorised. Its attended-only boundary agrees
  with the current operator decision.
- `plans/work-loop-v2-v0.2/pre-launch-preparations/dispatcher-semi-agentic-readiness-fixes-2026-08-11.md`
  is non-governing assessment material. Its Priority 2 evidence shapes inform this unit, but its own
  header authorises no implementation.
- Unit 1's accepted result below is authoritative current task state. Claude identified its commit
  to the operator as `e2ac00d`; verify the exact repository identity at entry rather than treating
  conversation as repository evidence.

**Check against the repository before acting.**

1. Verify in `scripts/axcion-harness-v0.2/carry-turn.sh` whether `before_dirty` is captured but not
   used when the post-Claude dirty-state branch attributes an uncommitted state file to Claude. Use
   the existing test seam to demonstrate whether a state file dirty before launch and byte-identical
   afterwards can be misreported as newly edited by Claude. If this premise is false, hand back the
   evidence rather than preserving the proposed classifier shape.
2. Search all of `scripts/axcion-harness-v0.2/carry-turn.sh` and
   `scripts/axcion-harness-v0.2/carry-turn.test.sh` for parsing or classification of Claude
   `permission_denials`. If present, state its actual coverage; if absent, limit the absence finding
   to those two searched files.
3. Verify whether the carrier snapshots and reports allowed working-tree changes attributable to
   the launched hop, including on actor failure, timeout, permission denial, and invalid or absent
   handback paths. Distinguish pre-existing allowed dirt from changes made during the hop.
4. Inspect every recovery message in the canonical launcher that can follow a stopped Claude hop.
   Identify any branch that tells Codex, or ambiguously tells the current reader, to commit Claude's
   handback; core section 4 assigns every commit to Claude.
5. Confirm Unit 1's checkout-wide lock and its regression cases are present before modifying the
   classifier. Stop on a false premise or missing Unit 1 commit rather than rebuilding it here.

**Scope.** Change only:

- `scripts/axcion-harness-v0.2/carry-turn.sh`
- `scripts/axcion-harness-v0.2/carry-turn.test.sh`
- this task state file

The implementation mechanism is Claude's decision. Prefer one classifier or one ordered decision
surface over independent branches that can contradict each other. Reuse the carrier's existing
snapshots and actor capture where sufficient. Do not create a daemon, observer process, registry,
second evidence store, retry mechanism, or semantic state field.

**Codex framing decisions and held-back work.** Unit 2 includes dirty-state attribution,
permission-denial interpretation, partial allowed-effect reporting, and recovery wording because
they form one dominant deliverable: classify one hop honestly from one evidence set. It excludes
nested-agent controls, permission-mode widening including `acceptEdits`, lock changes, documentation
cleanup, live model trials, automatic retry or resume, and adoption decisions. Do not edit or copy
the old spike dispatcher; it may be inspected only for a factual comparison and is never acceptance
evidence for this unit.

**Required fail-capable evidence.** Exercise the canonical carrier path and show:

1. a state file dirty before launch and byte-identical afterwards is not reported as newly edited by
   Claude;
2. a Claude permission denial with no repository effect reports the denied tool and target and says
   the repository is unchanged;
3. a Claude permission denial after allowed partial edits reports the denial and lists exactly the
   attributable changed paths;
4. allowed partial effects without permission evidence are classified separately and listed on an
   actor failure, timeout, or invalid/no handback path represented by the existing fixture seam;
5. a disallowed working-tree or committed effect retains precedence as an unexpected-effect stop;
6. a valid committed Claude handback and a valid uncommitted Codex handoff retain their existing
   success semantics;
7. identical evidence maps to one stable outcome regardless of which legacy branch would previously
   have encountered it;
8. no recovery branch tells Codex to commit, discard, or otherwise repair Claude's partial handback;
9. Unit 1's lock cases and the full canonical launcher suite still pass.

Show at least one matched pre-change/post-change failure for the dirty-before/byte-identical incident
shape and one fail-capable permission-denial case. Report exact commands, exit statuses, relevant
output, outcome precedence, changed files, and the commit id. Evidence from the old spike's suite or
a grep for outcome labels does not substitute for exercising the canonical carrier path.

**Completion condition.** Implement and commit one bounded deterministic post-hop classifier on the
canonical attended launcher, with the evidence above; update this file with the current result, set
`turn: codex`, and stop. Do not begin the nested-agent or live-trial unit.

**Stop conditions.** Hand back to Codex without improvising if the dirty-state premise is false, if
Claude's installed output cannot expose permission denials through the existing capture, if the
evidence cannot distinguish pre-existing dirt from hop-attributable changes, or if the change needs
paths outside scope. Stop for the operator if it would require broader permission authority,
automatic repair of partial work, or a change to the attended-only release boundary.

## Latest result

Correction round on Unit 2. One frozen finding, reproduced by inspection before anything was changed:

Reproduced (2026-08-13):

- Finding (1): REPRODUCES — `.agents/skills/work-loop-v2/SKILL.md:277` lists the stop codes and names
  "a permission dead end (`37`)"; line 289 defines it: "**`37` is a capability question, not a
  transport failure.** A permission dead end means the child was refused something it needed."
  `logs/work-loop/work-loop-v2-bounded-execution-verification.md:13` records, in a closed task
  (`turn: operator`, core § 4 closing record), "The live exit taxonomy is consistent across every
  instruction surface — `37` for a permission denial, `35` for an unavailable ownership check."
  Searched both in-scope files for `\b37\b`: no match (grep exit 1), so `37` was unused in the
  canonical launcher and nothing collided. `27` was present at six sites — `carry-turn.sh:71` (header
  table) and `carry-turn.sh:834` (the verdict call), plus `carry-turn.test.sh` lines 570, 581, 622
  and 817.

  Unit 2 chose `27` by taking the next free number in this script's own exit table. That was the
  wrong authority: the number is the Work Loop taxonomy's to assign, not the launcher's to pick.

Result: all six sites now read `37`. The header entry moved into ascending order after `30` and
carries a note saying the number is the taxonomy's to choose and why a permission dead end must not
share a code with a transport failure — re-running or raising the timeout cannot clear it. Searched
both files for `\b27\b` afterwards: no match (grep exit 1). No classifier behaviour, precedence,
message text, evidence field or scope was touched, and neither the governing skill nor the accepted
verification record was edited.

Evidence:

1. **Targeted denial case.** A Claude hop with one recorded denial and no repository effect, run
   directly against the canonical launcher: `EXIT=37`; screen carries
   `permission:      1 DENIAL(S) recorded by Claude:`, `- Bash — git commit -m handback`,
   `classified: PERMISSION_DENIED (exit 37)`, and
   `RESULT outcome=STOPPED code=37 task=t1 mode=live actor=claude turn_before=claude
   turn_after=claude denials=1 partial=0`. The denial naming and the attribution fields are
   unchanged; only the code moved.
2. **Full canonical launcher suite.** `./scripts/axcion-harness-v0.2/carry-turn.test.sh` → exit 0,
   `passed: 157   failed: 0` — the same 157 as before the correction, so nothing broke.
3. **Fail-capability still holds.** `./scripts/axcion-harness-v0.2/carry-turn.test.sh
   --prove-failure` → exit 0, `passed: 11   failed: 0`. M9 now reads `wanted '37', got '22'`, so the
   renumbered assertion is still load-bearing rather than merely relabelled.

Correction commit: `bb0af1b298668a917fe9e39b61a0278fba363d3b` (`bb0af1b`) —
`fix: carry-turn.sh — permission dead end is exit 37, not 27`. Changed files:
`scripts/axcion-harness-v0.2/carry-turn.sh`, `scripts/axcion-harness-v0.2/carry-turn.test.sh`. This
state-file handback is a separate commit, as the frozen finding directed.

Noticed during the correction, recorded and NOT implemented — candidate deferrals, not a second
correction round:

- The same misalignment likely affects more than the one code that was frozen. `SKILL.md:277` also
  assigns `36` (Claude did not touch an already-uncommitted state file — "exactly the misreport `36`
  was split out of `25` to stop"), `23` (hop limit), `29` (budget), `33`/`34`/`35` (ownership). The
  canonical launcher uses none of them, and Unit 2's own record asserted that "codes 23 and 29 remain
  free" — which the taxonomy says they are not. Notably, `36` describes precisely the condition Unit 2
  corrected, so the launcher may now be reporting `22` where the taxonomy expects `36`. Not touched:
  the correction scope was frozen to the `27` → `37` change, and a wider taxonomy reconciliation is
  its own unit with its own evidence.
- Unit 2's carried-forward deferrals are unchanged: the `jq` dependency for reading permission
  evidence, the two-entry `--allow-path` default that bounds what "allowed partial work" means, the
  hook-owned dirty `logs/friction-log.md` interaction, and the cosmetic double slash in displayed
  temporary lock paths.

## Blocker

None.

## Next action

Codex: closure check on the frozen finding only — is finding 1 resolved, and did the correction break
anything? Correction commit `bb0af1b`; state-file handback is the commit carrying this record.
