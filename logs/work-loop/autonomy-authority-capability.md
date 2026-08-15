---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 20 — record the content-bound re-freeze of the corrected implementation plan.

Named reason for the loop: the plan governs a multi-unit authority change and must preserve an identifiable approved content boundary across sessions before T2 can proceed.

## Brief
The operator explicitly approved the exact reviewed-and-corrected implementation-plan content at commit `c99e6b415a911866518111d1944c0e61dc72fbf8`, plan blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`, on 2026-08-15. Record that re-freeze in the plan's two existing live status records so the artifact's stated authority matches the decision; change no substantive implementation contract. This is required now because T2 remains blocked until the approved plan identity is durably recorded.

**Governing authority:** the operator's current content-bound approval above; the approved proposal at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; and the corrected plan content identified above. The fresh isolated bounded plan review returned **CORRECT** at amendment commit `504814cf422a4a29acb80d9066714be22e5f7a31`, plan blob `4141d5cb966f744957d7d63794b3d8a9adbc3a9f`; its sole frozen finding was corrected at `c99e6b41…` / `f80dc9d9…`, and Codex's bounded closure check passed. No second broad review is required because the correction was attribution-label-only and not a redesign.

Required outcome: update only the plan's opening status/approval record and final `## Plan-readiness statement` so both state that the plan is re-frozen for implementation on the operator's 2026-08-15 approval of commit `c99e6b415a911866518111d1944c0e61dc72fbf8`, blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`. Preserve the amendment cause, prior identities as history, completed review/correction/closure sequence, T1/T1a implemented state, T2 unimplemented state, and the remaining T2 candidate-correction and bounded-closure gate. Make clear that this status record does not itself edit or apply the core candidate.

Scope: the implementation plan's two existing status regions and this state-file handback only. No core, proposal, skill, command, autonomy-rules, session-plan, carrier, dispatcher, test, research report, candidate scratch content, or other plan section. This status-only unit may not change T2 semantics, counts, evidence requirements, tracer order, boundaries, accepted limitations, or deferrals.

Claims to check before editing:

1. The plan at `HEAD` is blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`, originating at commit `c99e6b415a911866518111d1944c0e61dc72fbf8`.
2. Its opening status and final readiness record both still say draft pending the review and operator reapproval now completed.
3. The core remains blob `82f119cd63c379b24f0bef8aab029ae04c165203`; T2 remains unimplemented.

Required evidence:

1. Report the three premise checks above before editing.
2. Show a zero-context plan diff whose substantive changes are confined to the two status regions. Map every hunk to recording the approval; any implementation-contract change fails the unit.
3. Show both updated status records agree on the exact approved commit/blob, completed review/correction/closure history, T1/T1a implemented state, T2 unimplemented state, and remaining candidate-correction/closure gate.
4. Confirm the plan content outside those status regions is byte-unchanged from blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe` by a fail-capable comparison that excludes only the two authorized regions.
5. Confirm the core and every other implementation target are unchanged. Report the status-record commit and resulting plan blob.

Completion condition: record the re-freeze exactly within this boundary, set `turn: codex`, commit only the plan plus this state-file handback, and stop. Do not correct the candidate, edit the core, or begin T2 in this unit.

Stop conditions: stop if the approved plan identity differs, the status records cannot be reconciled without changing substantive plan content, another target file becomes necessary, or any T2 semantic or sequencing change appears. Challenge a false premise rather than improvising.

## Latest result
Inspected (2026-08-15):
- Claim (1): HOLDS — `git rev-parse HEAD:plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md` returned `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`; `HEAD` is `c99e6b415a911866518111d1944c0e61dc72fbf8`, and `git show --stat c99e6b41` lists that plan file as changed, with `c99e6b41^` holding the prior blob `4141d5cb966f744957d7d63794b3d8a9adbc3a9f` — so the blob originates at that commit.
- Claim (2): HOLDS — read both records before editing. The opening Status block said "**Draft**, 2026-08-15 … It becomes implementable again only on two gates … Neither has run." and `## Plan-readiness statement` said "This artifact is **draft** … **not** frozen and **not** implementable. **Two gates stand between this draft and implementation, in this order, and neither has run.**"
- Claim (3): HOLDS — `git rev-parse HEAD:plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and `git hash-object` on the working-tree core both returned `82f119cd63c379b24f0bef8aab029ae04c165203`, which is the blob the plan records as T1a's result; no T2 core edit exists. `git status --porcelain plans/` was empty before the edit.

Result: the plan's two live status records now record the content-bound re-freeze. Both state that the plan is **re-frozen for implementation**, 2026-08-15, on the operator's explicit content-bound approval of commit `c99e6b415a911866518111d1944c0e61dc72fbf8`, blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`; both carry the completed gate sequence (fresh isolated bounded review at commit `504814cf422a4a29acb80d9066714be22e5f7a31`, blob `4141d5cb966f744957d7d63794b3d8a9adbc3a9f`, verdict **CORRECT** with one frozen finding on the authoritative Unit 18 finding-number mapping; one bounded correction landing at the approved identity; Codex closure check **PASS**, attribution-label-only and not a redesign, so no second broad review under `docs/qc-independence.md`; then the operator's content-bound reapproval); both state T1 and T1a implemented as the only implemented tracers and **T2 remains unimplemented** with no core edit existing for it; and both state that the remaining T2 gate is correcting the already-reviewed candidate core edit to the amended contract and passing its bounded closure check on the Unit 18 candidate review's three frozen findings. Both records say in terms that this status record itself edits, corrects and applies nothing and authorizes no core edit on its own. Every superseded identity (`74c33a28`/`964068c6`, `ccf134b8`/`3fd5322f`, `fe2c62fd`/`d1a6162b`, `cab3b7a2`/`1cbcbf4e`), the seventh-surface amendment cause, the correction-history labelling, the accepted T8 S4/S8 limitation and the carried-forward §14 item-6 deferral are preserved unchanged.

Evidence:
- **Diff confined to the two status regions.** `git diff -U0` on the plan returns eight hunks, at old-file lines 3–12, 72–75, 104–105, 1399–1400, 1402, 1404–1407, 1440 and 1445–1447. The opening status region is lines 1–136 (the preamble, ending at the first `^---$` on line 137); `## Plan-readiness statement` begins at old line 1397. Every hunk falls inside one of the two. Hunk mapping, each to recording the approval: lines 3–12 → the Status line itself, restated from draft to re-frozen with the approved commit/blob, the completed gate sequence, and the "authorizes no core edit by itself" clause; 72–75 → the one sentence that said T2 "may not be opened at all" under the draft, now stating that both blocking gates landed and naming the remaining candidate-correction and bounded-closure gate; 104–105 → the clause calling the present amendment "unreviewed and unapproved", now pointing at the recorded approval identity; 1399–1407 → the readiness statement's draft declaration and its "neither has run" gate list, now the re-freeze declaration and the same completed gate sequence; 1440 → "Returning to draft does not undo T1 or T1a", widened so the re-freeze is also said to land nothing; 1445–1447 → "After this amendment is reviewed and content-bound reapproved" restated as "Now that this amendment is reviewed and content-bound reapproved", the remaining candidate gate otherwise verbatim. No hunk changes T2 semantics, counts, evidence requirements, tracer order, boundaries, accepted limitations or deferrals.
- **Everything outside the two regions is byte-unchanged.** The pre-edit file was snapshotted from blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe` (working tree clean for `plans/` at the time, SHA-256 `0bdb7f22665e3e7a05f2913ce7d659a56862f42eb0b973df462eb2d7a13a2407`). An `awk` extraction took, from each version, the span after the first `^---$` line up to but excluding `^## Plan-readiness statement$` — 1259 lines in both. `cmp` reports the two spans byte-identical; SHA-256 of each is `5cb9495d4b21b807c2e12dbe98753bdd95a3f8e6af3cb95b9bd6105932286152`. **Fail-capability proof:** mutating one line (line 400) of the extracted new span and re-running the same `cmp` reports a difference, so the comparison can fail.
- **No other target changed.** `git status --porcelain` after the edit lists only the plan and this state file, plus `logs/friction-log.md`, which was already modified before this unit began and is not staged or committed by it. The core is unchanged: `git hash-object` on `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returns `82f119cd63c379b24f0bef8aab029ae04c165203`, identical to `HEAD`. No skill, command, autonomy-rules, session-plan, carrier, dispatcher, test, research report or candidate scratch file was touched.
- Resulting plan blob after the status edit: `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2` (`git hash-object` on the working-tree plan, before commit). The status-record commit is the single commit carrying this handback — it stages only the plan and this state file, and its hash cannot be written into its own content; read it from `git log -1 --format=%H -- plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`. The approved content identity `f80dc9d9…` at `c99e6b41…` is unaffected by this status-only announcement.

## Blocker
None for this status-only unit. T2 remains blocked until the already-reviewed candidate core edit is corrected to the amended contract and passes its bounded closure check on the Unit 18 candidate review's three frozen findings.

## Next action
Codex: assess Unit 20 — confirm that the two status records record the content-bound re-freeze at commit `c99e6b415a911866518111d1944c0e61dc72fbf8` / blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`, that the diff is confined to the two status regions with no implementation-contract change, and that the byte-unchanged comparison holds; then decide whether to open the T2 candidate-correction unit.
