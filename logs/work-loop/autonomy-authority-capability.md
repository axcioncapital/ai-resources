---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through a repository-grounded implementation plan that remains faithful to current authority and live behavior.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 10 — one bounded correction to the research-driven draft-plan amendment before fresh review.

Named reason for the loop: the amended plan must enter fresh review without a known false tracer mapping.

## Brief
The research-driven amendment materially satisfies required outcome items 1–8 and remains draft/unfrozen. One pre-existing false tracer reference was surfaced by Claude's own handback and confirmed by direct inspection; correct it now so the fresh reviewer receives a premise-verified artifact.

Exact amended artifact identity:

- Amendment commit: `d7dc9ea1e2e314d23c79c1949502b8b18ad27ef6`.
- Amended plan blob: `a824df52259e9da24b3a2a0ac42b07de85f57ec7`.
- Research report blob: `16d5203bcfcdb3f6ddd19a1e4baf36612650efa6`.

Scope: the single false tracer reference in the implementation plan plus this state-file handback. Do not alter any other plan wording, the research report, proposal, core, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or target surface. Do not begin the fresh review, re-freeze, or implement anything.

Required evidence: show the exact before/after sentence, prove the stale `being reconciled at T3` phrase is gone, prove the corrected workspace-`CLAUDE.md` row names T4, and confirm the rest of the amended plan blob differs only by that bounded replacement. Report the correction commit and resulting plan blob.

Completion condition: correct the one frozen finding, set `turn: codex`, commit only the plan plus state-file handback, and stop.

Stop conditions: stop if T4 does not in fact own `docs/autonomy-rules.md`, if any other plan content must change, or if a target implementation edit appears necessary.

## Latest result

Frozen finding reproduced before correcting it: baseline plan blob `a824df52259e9da24b3a2a0ac42b07de85f57ec7` confirmed current; `grep -n 'being reconciled at T3'` on the plan matched the Workspace `CLAUDE.md` row (line 167); `docs/autonomy-rules.md` is independently confirmed as `T4`'s own target (`### T4 — Reconcile \`docs/autonomy-rules.md\` wording`), and the same file's own line 139 already said "the file being reconciled at T4" — the plan was internally contradicting itself, one line naming T4 correctly and the other naming T3.

Result: finding 1 corrected, fully — the one bounded replacement, no other content touched. Plan blob: `a824df52259e9da24b3a2a0ac42b07de85f57ec7` → `d5b351d008ee581cfe496eef65fe7f2231415f66`.

Before: `found only a pointer to \`ai-resources/docs/autonomy-rules.md\` (being reconciled at T3) and no conflicting statement`
After: `found only a pointer to \`ai-resources/docs/autonomy-rules.md\` (being reconciled at T4) and no conflicting statement`

Evidence:

- `git diff` on the plan: exactly `1 file changed, 1 insertion(+), 1 deletion(-)`, the single line above — confirmed by reading the diff, not assumed from the line count.
- `grep -n 'being reconciled at T3'` on the amended plan: no match (was one match, at line 167, before).
- `grep -n 'being reconciled at T4'` on the amended plan: two matches — the pre-existing correct line 139 and the now-corrected line 167, consistent with each other for the first time.
- `git status --porcelain` on `plans/`, `docs/`, `.claude/`, `.agents/`, `scripts/` restricted to files other than this one plan: empty — no other content, no target implementation surface, and not the research report, was touched.
- Regression, unaffected as expected: `work-loop-v2-core-resolver.test.sh` — `4 passed, 0 failed`. `work-loop-v2-slice-1.test.sh` — `passed: 308  failed: 0`.

No newly noticed finding arose during this correction; there is nothing to record as a deferral.

## Blocker
None.

## Next action
Codex: run the closure check on this one frozen finding — is it resolved, and did the correction break anything else in the amended plan. If closed, the amended plan (blob `d5b351d008ee581cfe496eef65fe7f2231415f66`) still requires its own fresh, isolated bounded implementation-plan review and the operator's explicit content-bound re-freeze before any status-reconciliation, T2, T3a, or later target-implementation unit may begin — this correction does not substitute for that review.
