---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through a repository-grounded implementation plan that remains faithful to current authority and live behavior.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 10 — reopen and amend the implementation plan from the approved primary-source research.

Named reason for the loop: the frozen plan contains material false premises about core section placement and live authority semantics; correcting them must survive session boundaries and receive fresh review before target implementation resumes.

## Brief
The operator approved the research-backed revised direction on 2026-08-14. This unit updates the planning artifact only: return it to draft, incorporate the verified repository corrections, and prepare it for one fresh bounded plan review; do not re-freeze it or edit any target implementation surface.

Governing authority:

- Operator decision, 2026-08-14: reopen the plan as draft; preserve §8 placement and existing core numbering; add a separate status-reconciliation unit; revise T2 to reconcile contradictory core consequence gates as well as append the verbatim rule; revise/re-split T3 for the live Codex-skill gate; then require one fresh bounded review and explicit content-bound re-freeze before implementation resumes.
- Primary-source report: `plans/work-loop-v2-v0.2/t2-governing-autonomy-clause-primary-source-findings-2026-08-14.md`. Read it in full and use its cited primary sources; it is the evidence basis for this amendment.
- Current plan identity: freeze commit `fe2c62fddf8124caf44836b8237e44e06041db6f`, plan blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d`.
- Approved proposal: commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`.
- Canonical core after approved T1: implementation commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`, core blob `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`; approval record commit `9a0fdb41fa27ae7ac813504a5145a59d465b93b7`.

Required outcome:

1. Change the implementation plan's status from frozen to **Draft — material repository-evidence amendment pending fresh review and operator re-freeze**. Preserve the old freeze identity and accepted T8 limitation as historical decisions; state plainly that the amended plan grants no target implementation authority.
2. Correct the plan's destination semantics: proposal §1 is the clause source; the canonical core destination is new `## 8. The governing autonomy rule`; existing core §§1–7 are never renumbered.
3. Add a separate, bounded pre-T2 core-status reconciliation tracer covering the stale line-3 approval status and the two dated amendment notes identified by the research. Preserve the existing T1–T9 tracer identities; use the smallest unambiguous inserted identifier rather than renumbering them.
4. Revise T2 so its one coherent resulting core blob appends the verified verbatim §8 clause and reconciles every categorical consequence/hard-to-reverse gate the research proves conflicts with the approved rule. Keep T1's approved authority paragraph unchanged. Enumerate the exact current clauses, intended semantic change, boundaries, review tier, and fail-capable evidence; do not hide these changes under “citation.”
5. Revise or split T3 so the live Codex skill's substantive hard-to-reverse operator gate is reconciled semantically, not treated as citation-only. Apply the report's complete live-conflict inventory and distinguish any Claude-command text that is already compatible from text that genuinely requires change.
6. Correct every connected specification, repository-delta classification, ordering rule, tracer contract, citation target, traceability row, internal-consistency statement, and evidence check affected by items 2–5. Do not limit the amendment to the three initially noticed §1 strings.
7. Preserve all unrelated accepted plan content, including the operator-accepted T8 S4/S8 evidence limitation, T9 strict exit, item-11 measures, MVP deferrals, and T1's completed/approved identity.
8. Record the required next gate: one genuinely fresh bounded implementation-plan review, followed by explicit operator content-bound re-freeze, before any status reconciliation, T2, T3, or later target implementation begins.

Scope: the implementation plan, the research report, and this Work Loop state-file handback only. The report was produced by the operator-invoked research skill; preserve it as the cited evidence artifact and commit it without rewriting its conclusions. Do not edit the proposal, executable core, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or any target implementation surface. Do not implement, review, or freeze the amended plan in this unit.

Required evidence:

- Confirm the pre-amendment plan matches blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d`.
- Provide a bounded before/after map from each material research finding to the exact amended plan section/tracer.
- Show fail-capable searches proving the plan no longer assigns the governing rule to destination core §1, never authorizes renumbering §§1–7, includes the separate status unit before T2, and represents the core and skill semantic conflicts as real changes rather than citation-only work.
- Show the plan remains draft/unfrozen and preserves the accepted T8 limitation and unrelated traceability.
- Report the amendment commit and resulting plan blob; confirm only the plan, research report, and state-file handback were committed.

Completion condition: deliver the coherent draft amendment with evidence, set `turn: codex`, commit only the plan, research report, and state-file handback, and stop. Do not begin the fresh review or any target implementation.

Stop conditions: stop if the report conflicts with a governing approved source, the required amendment would change the proposal's approved outcome or capability envelope, the plan cannot remain internally coherent without reopening another operator decision, or any target implementation edit appears necessary. Challenge a false premise rather than improvising.

## Latest result

Inspected (2026-08-14):

- Pre-amendment plan identity: HOLDS — `git rev-parse fe2c62fddf8124caf44836b8237e44e06041db6f:<plan path>` = `d1a6162b8e92c9689f261b85607dfcdb89105c6d`, matching `git hash-object` on the plan before this unit's edits.
- Report exists at the cited path and its primary-source citations check out — verified by inspection, not trust: core heading topology (exactly `## 1.`–`## 7.`, no other numbered section), the 26-token/25-internal-self-reference count for `§ [1-7]` in the core (`rg --pcre2`), proposal §4/§15 item 1's "not an automatic operator gate" text, proposal §6's full operator-reserved-decision and mandatory-stop-or-handback lists, core lines 26/59–60/469/475/477's categorical "hard to reverse"/"consequential" text, and skill line 508's "Decide anything hard to reverse — that is the operator's, via core § 7" — every quotation the report and the brief rely on was opened and read at its cited location before use.
- Freeze-identity discrepancy (plan header `cab3b7a2…`/`1cbcbf4e…` vs. state-file `fe2c62fd…`/`d1a6162b…`): HOLDS, resolved — `git diff` between the two blobs touches only the Status preamble; `cab3b7a2` is a direct ancestor of `fe2c62fd`. Both identities are correct at different layers (substantive content vs. status announcement), not a contradiction.

Result: the plan is amended in place, from blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d` to blob `a824df52259e9da24b3a2a0ac42b07de85f57ec7`. It is **draft**, not re-frozen — no target-implementation authority exists yet. The primary-source report is committed as the cited evidence artifact, unmodified from its authored content.

**Before → after map, one row per required outcome item:**

1. **Status.** Before: "**Frozen for implementation**". After: "**Draft — material repository-evidence amendment pending fresh review and operator re-freeze**", with the prior freeze's two identities (`cab3b7a2…`/`1cbcbf4e…` substantive content, `fe2c62fd…`/`d1a6162b…` status announcement) preserved as superseded history, not live authority.
2. **Destination semantics.** Repository Delta row "Executable core, governing rule" now reads `same file, § 8 (new, appended)`, with the false "§1 (new)" premise named and corrected; ordering constraint 1a states the destination rule and the renumbering blast radius (≥25 internal self-references, ~198 explicit `core §N` references) that literal §1 placement would have caused.
3. **Status-reconciliation tracer.** New `T1a` (Execution Plan) and `§ 3.1a` (Implementation Specification) — full six/seven-field bounded unit contract — inserted between T1 and T2; T2's precondition now names T1a explicitly.
4. **T2 revised.** `§ 3.2` and the `T2` tracer both now specify two coherent outputs — clause append at `## 8.` and reconciliation of core lines 26, 59–60, 469, 475, 477 against proposal §4/§6/§15 item 1 — with the exact current clauses quoted, the target semantic change stated (operator-reserved-decision and mandatory-stop-or-handback classes named verbatim from proposal §6, not citation), boundaries (T1's paragraph and T1a's header byte-unchanged; no renumbering; no dropped operator-reserved class), unchanged high-consequence risk-aware review tier, and six fail-capable evidence items.
5. **T3 re-split.** `T3` narrowed to citation-only scope (skill line 429, command line 126); new `T3a` (Execution Plan) and `§ 3.3a` (Implementation Specification) carry the skill's line-508 semantic reconciliation, gated on T2, with its own high-consequence review row.
6. **Connected corrections.** Every `§1`-as-destination string in §3.2/§3.3/T2/T3/T4/T5, the ordering-constraint prose, the traceability table (rows for §14 items 2 and 3), and the internal-consistency check's tracer list and dependency statements now reads `§8`/`core §8`/names T1a and T3a explicitly. Repository Delta gained two new classified rows ("Executable core, categorical consequence/hard-to-reverse gate" — Modify, semantic; "Codex skill categorical hard-to-reverse gate" — Modify, semantic) so both conflicts are visible at inventory, not only inside a tracer.
7. **Preserved content.** T8's S4/S8 accepted limitation, the §14 item 6 deferral, T9's strict exit, item-11 measures, MVP deferrals (§14 items 13–15), and T1's completed/approved identity are all carried forward with only their framing sentence updated to say "unchanged by this amendment" — no substantive content altered (spot-verified: `grep -c` for each preserved clause's distinguishing text returns 1, matching pre-amendment).
8. **Next gate recorded.** Plan-readiness statement states the required sequence — one fresh isolated bounded review, then explicit operator content-bound re-freeze — before T1a, T2, T3a, or any later target-implementation unit may begin.

**Fail-capable evidence, run against the amended plan:**

- `grep -n 'same file, § 1 (new)'` → no match (was present pre-amendment; the false-premise string is gone).
- `grep -n 'never renumbered'` → 1 match (ordering constraint 1a); `grep -n 'not renumbered'` → 1 further match (§ 3.2 Outputs item 1's "not renumbered, retitled, or reordered") — the no-renumbering rule is stated in both places, in each place's own wording.
- `grep -n '^### T1a\|^### T2 '` → both present, in that file order.
- `grep -n 'Modify — semantic, not citation-only'` → 2 matches (the core row and the skill row in Repository Delta).
- `grep -n '^\*\*Status:\*\*'` → "Draft — material repository-evidence amendment pending fresh review and operator re-freeze".
- `grep -n 'Accepted limitation carried forward'` → present, T8's S4/S8 limitation unchanged.
- Regression: `work-loop-v2-core-resolver.test.sh` — `4 passed, 0 failed`. `work-loop-v2-slice-1.test.sh` — `passed: 308  failed: 0`. Both unaffected, since no target surface was touched.
- `git status --porcelain` on `plans/work-loop-v2-mvp/`, `.agents/skills/`, `.claude/commands/`, `docs/`, `scripts/` — empty; no target implementation surface changed.

**One deferral, noticed and not fixed (out of this unit's briefed scope — items 2–5 only):** Repository Delta's "Workspace `CLAUDE.md`" row (and its `## Autonomy Rules` boundary paragraph above the table) says the workspace pointer is "being reconciled at T3" — that tracer is actually `T4` (`docs/autonomy-rules.md`); `T3` is the skill/command tracer. This is a pre-existing plan defect, not caused or touched by items 2–5, and is left for the fresh plan review to fix rather than corrected here without its own review.

Research report (committed, unmodified from its authored content):
`plans/work-loop-v2-v0.2/t2-governing-autonomy-clause-primary-source-findings-2026-08-14.md`, blob `16d5203bcfcdb3f6ddd19a1e4baf36612650efa6`.

Amended plan blob: `a824df52259e9da24b3a2a0ac42b07de85f57ec7`.

No target implementation surface has changed since approved T1 commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`.

## Blocker
None.

## Next action
Codex: assess this amendment against the brief's required outcome and evidence. If accepted, the amended plan (blob `a824df52259e9da24b3a2a0ac42b07de85f57ec7`) still requires one fresh, isolated bounded implementation-plan review before it can be re-frozen — this handback is not that review and does not substitute for it. `logs/friction-log.md` carries a pre-existing, unrelated local modification from before this unit began; it was left uncommitted and untouched, by explicit pathspec, and is not part of this handback's evidence.
