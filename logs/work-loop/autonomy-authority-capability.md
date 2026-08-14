---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 14 — implement T1a's reviewed three-surface executable-core status reconciliation.

Named reason for the loop: the canonical core is shared authority infrastructure; the change has maximal document reach and must land exactly as risk-reviewed, with fail-capable exclusion evidence.

## Brief
Unit 13 established every T1a premise, and one fresh isolated risk-aware Codex review returned READY with exact wording and implementation conditions. Implement only the reviewed status reconciliation so the core's live status agrees with T1's already-recorded operator approval; do not add the governing autonomy rule or begin T2.

Governing authority:

- Re-frozen implementation plan at status-record commit `e45a581f89291ff45ec263d35d9b38e65117b3e2`, plan blob `7b254fcbaeda669ecb8a300e72d9bb5203619505`; § 3.1a and the Execution Plan's T1a entry govern.
- T1 content commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`, core blob `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`, and approval-record commit `9a0fdb41fa27ae7ac813504a5145a59d465b93b7`.
- Fresh isolated risk-aware review verdict READY on 2026-08-14, bound to Unit 13's exact three-hunk payload and the wording below.

Required outcome: change only these three surfaces in `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`:

1. Header, exact replacement:
   ``**Version:** v0.1 (MVP). **Status:** canonical — content at commit `5fef08ff` approved by the operator on 2026-08-14.``
2. The dated note under `### The "good enough, proceed" judgment`, exact replacement preserving its original date:

   ```markdown
   > *Added 2026-08-07. This clause was approved on its own, and the rest of the file was not
   > approved with it at that time. That limitation was superseded on 2026-08-14, when the
   > operator's content-bound approval of commit `5fef08ff` made the whole file canonical.*
   ```

3. The dated note under `### An approved courier may carry the turn`, identical wording except its original date remains `2026-08-06`.

Preserve the notes' three-line shapes, all headings and section numbers, T1's authority paragraph, and every byte outside those three surfaces. Introduce no autonomy-policy language and make no semantic change beyond status/provenance reconciliation.

Starting evidence: Unit 13 verified the current core is blob `30c62c41...`, byte-identical to T1; `draft for operator approval` appears only at the header and the two targeted notes; `pre-authorized capabilities` appears zero times; and the resolver suite passes 4/4. Recheck the current baseline before editing and stop on any mismatch rather than applying the reviewed patch to a different artifact.

Required implementation evidence:

1. Failing case and result: show the status-line draft string matches before and not after.
2. Exact diff: show one file and exactly the reviewed three hunks, with the reviewed wording; any fourth hunk fails the unit.
3. Exclusion proof: T1's authority paragraph is byte-identical, and a whole-file comparison excluding only the header and the two three-line note blocks is empty.
4. Semantic note readback: quote both resulting notes and confirm each preserves its original approval date, states the clause-only historical approval, and states T1 superseded that limitation. Date grep alone is insufficient.
5. Scope guard: `! grep -q "pre-authorized capabilities"` succeeds on the whole result.
6. Regression: run `bash logs/scripts/work-loop-v2-core-resolver.test.sh`; report command, exit code, and summary after the edit.
7. Report the implementation commit and resulting core blob.

Scope: the executable core's three named surfaces plus this state-file handback only. Do not edit the plan, consumer C1, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or research report. The reviewer found C1's stale future instruction is real but non-blocking; it is held outside T1a because changing it here would violate the frozen one-file tracer.

Adjacent work held back: before `plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md` executes its S2/amendment-discipline work, a bounded follow-on must remove or reconcile its instruction to append a note saying the core header is deliberately unchanged. This is a concrete deferred gate, not an accepted standing limitation and not part of Unit 14.

Completion condition: implement the exact reviewed three-surface patch, produce all evidence above, commit only the core plus state-file handback, set `turn: codex`, and stop. Do not begin T2 or the C1 follow-on.

Stop conditions: stop if the core is not the verified T1 blob, the exact wording cannot fit the three allowed surfaces, any fourth edit is required, a check fails, or implementation would touch an excluded file. Challenge a false premise rather than improvising.

## Latest result
Inspected (2026-08-14):
- Claim (1) — plan re-frozen at status-record commit `e45a581f`, plan blob `7b254fcb`: HOLDS — ran `git ls-tree -r e45a581f | grep 7b254fcb`; blob `7b254fcb` is `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, and `git hash-object` on the working copy returns the same blob, so the live plan is the frozen one. Read § 3.1a and the T1a Execution Plan entry; both specify exactly this three-surface reconciliation, its fail-capable evidence and its high-consequence review row.
- Claim (2) — T1 content commit `5fef08ff`, approval-record commit `9a0fdb41`: HOLDS — `git log -1` on each returns `implement: … T1 — executable core no longer subordinate to proposal v0.4` (2026-08-14) and `record: … T1 — operator content-bound approval received` (2026-08-14).
- Claim (3) — the current core is blob `30c62c41`, byte-identical to T1: HOLDS — `git hash-object plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returns `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`; `git cat-file blob 5fef08ff:<core> | diff - <core>` is empty.
- Claim (4) — `draft for operator approval` appears only at the header and the two targeted notes: HOLDS — searched the whole core with `grep -n 'draft for operator approval'`; exactly three hits, at lines 3, 166 and 286, all inside the three allowed surfaces.
- Claim (5) — `pre-authorized capabilities` appears zero times: HOLDS — searched the whole core with `grep -c 'pre-authorized capabilities'`; count 0.
- Claim (6) — the resolver suite passes 4/4: HOLDS — ran `bash logs/scripts/work-loop-v2-core-resolver.test.sh` before editing; `4 passed, 0 failed`, exit 0.
- Claim (7) — the three target surfaces exist in the shapes the patch assumes: HOLDS — `sed -n '9,12p;165,167p;285,287p'` shows T1's authority paragraph at lines 9–12 and each dated note as a three-line blockquote at 165–167 (2026-08-07) and 285–287 (2026-08-06), matching § 3.1a's stated line ranges.

Result: T1a is implemented. The executable core's three named surfaces now state the file's actual status — header reconciled to canonical per the operator's content-bound approval of commit `5fef08ff`, and both dated notes rewritten to preserve their original approval dates and their clause-only historical limitation while recording that T1 superseded it. No autonomy-policy content was added and no other file was touched.

Evidence:
1. Failing case and result — `sed -n '3p' <core> | grep -q 'draft for operator approval'` matched before the edit and does not match after.
2. Exact diff — `git diff --numstat` reports one file, `7 7`; `git diff -U0 | grep -c '^@@'` reports exactly 3 hunks, at lines 1–6, 162–170 and 282–290, each carrying the reviewed wording verbatim. No fourth hunk.
3. Exclusion proof — `diff` of lines 9–12 before/after is empty, so T1's authority paragraph is byte-identical; `diff` of the whole file before/after with line 3 and lines 165–167, 285–287 deleted from both sides is empty; line count is 477 before and after. The check is fail-capable: rerun against a copy with line 400 replaced, the same comparison reports the injected difference.
4. Semantic note readback — the 2026-08-07 note reads "Added 2026-08-07. This clause was approved on its own, and the rest of the file was not approved with it at that time. That limitation was superseded on 2026-08-14, when the operator's content-bound approval of commit `5fef08ff` made the whole file canonical." The 2026-08-06 note is identical except for its date. Each keeps its original date, states the clause-only approval as a historical fact, and states T1 superseded that limitation.
5. Scope guard — `! grep -q "pre-authorized capabilities" <core>` succeeds on the whole result.
6. Regression — `bash logs/scripts/work-loop-v2-core-resolver.test.sh` after the edit: `4 passed, 0 failed`, exit 0.
7. Implementation commit: see this handback's commit. Resulting core blob: `82f119cd63c379b24f0bef8aab029ae04c165203` (`git hash-object`).

Deferrals carried forward, neither implemented nor widened here: the proportionality/continuity plan's future amendment instruction to append a note saying the core header is deliberately unchanged is now factually stale and must be removed or reconciled before that plan's S2/amendment-discipline work executes; C1's stale future instruction remains real but non-blocking and outside the frozen one-file tracer; the stale authority row in the unapproved resource-capability development plan remains deferred.

## Blocker
None.

## Next action
Codex: assess Unit 14 — confirm the three reviewed hunks landed with the exact reviewed wording, that the exclusion evidence bounds the change to the header and the two notes, and that no autonomy-policy content entered the core. Then decide whether T1a closes and T2 may open.
