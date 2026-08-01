---
task: foreign-staging-target-repo
turn: codex
---

## Objective and approved scope
Make the foreign-staging tripwire judge a gated command against the Git repository the command will
actually affect, while preserving a hard block when that target cannot be resolved safely. Complete
the live canonical hook, permanent executable regression coverage, the maintained-copy disposition,
the operator-facing contract, and closure of the recorded defect.

Approved boundary names the canonical hook, focused coverage under `logs/scripts/`,
`docs/commit-discipline.md`, `logs/improvement-log.md`, `.codex/hooks/check-foreign-staging.sh`, and
the sector-intelligence project fork. **Widened by operator decision, 2026-08-01, to include
`logs/next-up.md`** — for the single purpose of ticking the promoted item `8c600934fdd0` once
`logs/improvement-log.md` marks the nested-target defect resolved. No other edit to that file is in
scope. Stated out loud rather than absorbed silently, per core § 6 rule 4.

## Current lane and unit
Standard. Named reason for the loop: this pilot task spans a globally wired guard, cross-session
handoff, fail-capable regression evidence, and divergent copies whose authority differs.

Unit 3 — closure — is unblocked and awaits its brief from Codex. The scope decision it was pending is
answered in the boundary above: the queue-item tick is in scope.

## Latest material result
Unit 1 accepted after one correction and one final tightly-bounded fix. The canonical hook separates
session and target scopes, safely resolves quoted literal leading `cd`, fails closed for unresolvable
wide-add targets, and supports session state rooted in a plain project subdirectory. Claude recorded
15/15 green with defect-specific falsification and no regression.

Unit 2 accepted. `.codex/` is parked unchanged under the existing operator decision: ignored,
unmaintained, and unregistered. The sector-intelligence fork is synchronized to canonical behavior
with exactly its two authorized additions, `qc-log.md` and `research-quality-log.md`; the live diff
contains only their comment and entries. Both hooks recorded 15/15 green, syntax checks passed, and
the comparison was falsified against removal of either exemption and an unrelated executable change.
The sector hook was committed separately as `563e3fe`. Corrected measurement at assessment: the
current canonical and sector files are 838 and 846 lines; Unit 2's recorded 797-line canonical count
was wrong, but the materially-behind premise and the port result are unchanged.

Unit 2's assessment was independently re-verified against the live repository on 2026-08-01 at
operator request: canonical 838 lines and sector 846; `diff` between the two executables returns
exactly the two authorized `EXEMPT_BASENAMES` entries and their seven-line comment and nothing else;
`.codex/` remains gitignored (`.gitignore:63`) with no `check-foreign-staging` registration in
`.codex/hooks.json` and its hook file untouched since 2026-07-14; sector commit `563e3fe` touches
that one file only. The harness reports 15/15 green against the canonical hook and 15/15 via
`HOOK_OVERRIDE` against the sector fork. It is fail-capable, and now measured: against a no-op stub
hook it reports 4 passed / 11 failed, so 11 of the 15 assertions carry real signal and 4 are
allow-shaped cases that a dead guard also satisfies. That is the quantified form of FP-9 and it
belongs in the closing record rather than in prose.

Decisions to carry into closure: ambiguous-target fail-closed remains limited to wide adds; the
`.codex` experiment remains parked; the sector fork remains canonical plus its two local exemptions.

Deferrals to carry into closure:

1. A plain-subdirectory project's own `proj/logs/.session-marker-*` may read as foreign because the
   byproduct exempt-list still compares target-repo-relative paths. Newly noticed at Unit 1's final
   closure check; separate comparison site requiring its own behavior decision and evidence.
2. A combined `git add <explicit-path> && git commit` reaches PreToolUse before the add, so the commit
   arm sees an empty index and does not evaluate the file. Pre-existing and still consistent with the
   original threat model of a foreign session already populating the index, but materially narrower
   than the hook header and the repository's single-step commit convention imply. Newly noticed in
   Unit 2; separate coverage decision, not folded into this task.

## Next action
Codex: open Unit 3's brief — closure. The scope question is answered: approved, `logs/next-up.md` is
in boundary for the single tick of `8c600934fdd0`. The surface left unclosed is the operator-facing
contract in `docs/commit-discipline.md`, the defect record in `logs/improvement-log.md`, and that
tick. The two deferrals above are recorded for scoping and are not in this unit unless the brief
names them in.
