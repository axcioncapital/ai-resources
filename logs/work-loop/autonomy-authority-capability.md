---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the frozen `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, whose governing direction is the content-bound approved autonomy/authority/capability proposal.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; do not create parallel state or review systems.

## Lane and unit
Standard. Implementation mode. Unit 8 — implement T1's executable-core authority-status paragraph only.

Named reason for the loop: this cross-cutting governance implementation must survive session boundaries, and T1 changes the executable core's authority status across every Work Loop consumer.

## Brief
T1's premise verification and seven-dimension risk-aware review passed: the change is real, reversible, permission-neutral, and bounded to one prose paragraph whose consumers bind by path rather than content. This unit implements only that reviewed authority-status change; the operator must still approve the exact resulting commit before the core becomes canonical or T2 may begin.

Governing authority:

- Frozen plan: freeze commit `fe2c62fddf8124caf44836b8237e44e06041db6f`, plan blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d`; T1 contract at §3.1 and §4 T1.
- Approved proposal: commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; §14 item 1.
- Verified current target: `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:9-10` contains the sole live `the Proposal wins` subordination paragraph; proposal v0.4 exists; `pre-authorized capabilities` is absent.

Required outcome: replace only the existing authority paragraph with this exact reviewed text:

```
**Authority.** This file is the Work Loop's own statement of how the loop runs. It was built from
`work-loop-v2-mvp-proposal-v0.4.md`, which is recorded here as historical rationale for the design
rather than a live overriding authority. The operator's content-bound approval of the identifiable
commit carrying this revision is what makes this file canonical.
```

This wording incorporates the risk-review refinement: it states the approval condition without claiming that approval has already happened or embedding a sentence that would become false immediately afterward.

Scope: the executable core's current authority paragraph and this state-file handback only. Preserve the line-3 `Status: draft for operator approval` header, all amendment notes, every numbered section, the §1 absence, and every consumer byte-for-byte. Do not edit the frozen plan's dynamic inventory counts; their changed grep totals are non-load-bearing drift caused by repository growth, while the reviewed consumer classification remains unchanged. Do not edit the proposal, skill, command, autonomy rules, session plan, carrier, dispatcher, or tests.

Required evidence:

1. Before/after: `the Proposal wins` changes from one match to zero; `pre-authorized capabilities` remains zero.
2. The exact replacement paragraph matches the text above, and a zero-context diff shows one hunk confined to the former authority paragraph.
3. `logs/scripts/work-loop-v2-core-resolver.test.sh` remains `4 passed, 0 failed`.
4. `logs/scripts/work-loop-v2-slice-1.test.sh` remains `308 passed, 0 failed`.
5. The core's line-3 draft-status header is byte-identical and no target path beyond the core changed.
6. Report the implementation commit and resulting core blob so the operator can make the content-bound T1 approval decision.

Completion condition: implement the one-paragraph change, run the fail-capable checks, set `turn: codex`, commit only the executable core plus state-file handback, and stop. Do not declare the core canonical, begin T2, or edit any adjacent surface.

Stop conditions: stop if the current paragraph differs from the verified premise, the change requires touching the draft-status header or another file, either suite fails, §1 text appears, or the diff exceeds the authority paragraph. Challenge a false premise rather than improvising.

## Latest result
Inspected (2026-08-14): all five premises held by inspection before editing — current authority paragraph at `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:9-10` matched the verified text exactly; `the Proposal wins` = 1 match, `pre-authorized capabilities` = 0 matches; line-3 header read `**Version:** v0.1 (MVP). **Status:** draft for operator approval.`; proposal v0.4 present (18436 bytes); working tree for the core file was clean; frozen-plan blob and approved-proposal blob both matched their bound hashes.

Result: implemented T1 — replaced only the `:9-10` authority paragraph with the exact reviewed text. No other line, section, or file touched.

Evidence:

1. Before/after markers — `grep -c "the Proposal wins"`: 1 → **0**. `grep -c "pre-authorized capabilities"`: 0 → **0** (unchanged, as required — this unit adds no §1 text).
2. Diff confined to the former authority paragraph: `git diff -U0` shows exactly one hunk, `@@ -9,2 +9,4 @@`, replacing the two-line subordination paragraph with the four-line reviewed text. No other hunk exists in the file.
3. `bash logs/scripts/work-loop-v2-core-resolver.test.sh` → **4 passed, 0 failed** (unchanged from Unit 7's baseline).
4. `bash logs/scripts/work-loop-v2-slice-1.test.sh` → **308 passed, 0 failed** (unchanged from Unit 7's baseline).
5. Line-3 draft-status header: `sed -n '3p'` → `**Version:** v0.1 (MVP). **Status:** draft for operator approval.`, byte-identical to before. `git status --porcelain` shows only the executable core plus this state file changed by this unit (the pre-existing unrelated `logs/friction-log.md` modification predates this unit and is untouched by it).
6. Implementation commit: `5fef08fff11a1009b30d925f49d68844fc4e2f03`. Resulting core blob: `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`.

**Operator content-bound approval received (2026-08-14).** The operator told Claude directly, in-session, "approved," in response to being shown the implementation commit and blob above. Plan §4 T1's exit condition ("the operator approves this exact revised commit") and proposal §14 item 1 ("obtain operator approval of that revision at an identifiable commit — that approval is what makes the core canonical") are both satisfied by commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`. The core is now canonical. T2 (plan §3.2, §4 T2) may begin once Codex writes its brief; T2's own precondition — "operator approval of § 3.1's commit exists and is identifiable" — is met by this record.

## Blocker
None.

## Next action
Codex: T1 is approved at commit `5fef08fff11a1009b30d925f49d68844fc4e2f03` — the core is canonical. Write T2's brief (plan §3.2, §4 T2: insert the §1 governing autonomy clause verbatim into the now-canonical core) and hand it to Claude, or reassess if new evidence changes that judgment.
