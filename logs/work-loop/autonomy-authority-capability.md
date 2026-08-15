---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 30 — reconcile `.claude/commands/session-plan.md` Step 5 with canonical core § 8.

Named reason for the loop: T5 is a required authority-language reconciliation in the approved plan and needs independent assessment after implementation, while preserving the command's existing posture behavior exactly.

## Brief
T4 is accepted: the reviewed citation landed exactly at commit `b5d79aa1a173de525165d7ae9572e5e3a32c5386`, with protected trigger text preserved and no new regression. T5 is now the nearest unmet tracer in the re-frozen plan. This unit adds the required Step 5 cross-reference without changing how `/session-plan` chooses or expresses an autonomy posture.

Governing authority: the re-frozen implementation plan at `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, especially § 3.3 and T5; canonical core § 8 at `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. The plan requires one bounded, citation-shaped sentence stating that session-level pause granularity is a planning classification and does not decide per-action authority, which core § 8 governs.

Scope: `.claude/commands/session-plan.md` Step 5 and this state-file handback only. Excluded by Codex framing because they are later tracers or already accepted: plan, proposal, core, Work Loop skill, Work Loop command, autonomy rules, tests, routing index, research report, capability-envelope work, T6–T9, and unrelated `logs/friction-log.md` changes.

Claims to check before editing:

1. Step 5 still contains exactly three postures — `Full autonomy`, `Gated`, and `Operator-in-the-loop` — with their current criteria and the `Name specific stop points (or state "None").` instruction, and contains no core § 8 citation.
2. Canonical core § 8 exists in this checkout at blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`; the workspace-style `ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` citation resolves after this branch is integrated, under the ordered branch dependency already accepted for T4.
3. A single sentence can be added inside Step 5 without changing any posture heading, criterion, stop-point instruction, or downstream output schema.

Required outcome: add one concise citation-shaped sentence inside Step 5 that records the plan's exact authority relationship. Do not copy or paraphrase the governing rule itself; cite core § 8. Placement and exact prose are Claude's technical judgment within that semantic contract.

Required evidence:

- Show the citation text is absent in the pre-edit file and present after, using a check that fails on the baseline.
- Prove the three posture headings, every criterion line under them, and the `Name specific stop points` instruction are byte-identical before and after; show the Step 5 diff and confirm only one sentence was added.
- Confirm Step 5's output schema and every line outside Step 5 are unchanged, and that no governing-rule prose from core § 8 was duplicated.
- Run `work-loop-v2-slice-1.test.sh` as regression evidence against the known **307 passed / 1 failed** local baseline. No new failure is allowed; the existing routing-index/live-installation failure remains deferred and must not be fixed in this unit. State plainly whether the suite binds to this citation.

Completion condition: T5's citation is present, all protected Step 5 content is proven unchanged, only `.claude/commands/session-plan.md` plus this state handback are committed, `turn: codex`, and Claude stops before T6.

Stop conditions: challenge and hand back if any claim is false, the required authority relationship cannot be stated in one citation-shaped sentence, protected Step 5 content would need to change, another target is required, or regression evidence adds a failure.

## Latest result

Inspected (2026-08-15):
- Claim (1): HOLDS — `.claude/commands/session-plan.md` was blob `b83205a6fe7dc604fead4a458e2ad86b4d7e64d5`, live and `HEAD` agreeing. Step 5 runs lines 132–155; inside it, counting lines that both begin `**` and contain `Use when:` returns exactly 3 — `**Full autonomy**` (136), `**Gated**` (141), `**Operator-in-the-loop**` (146) — each with its three criterion bullets, and `Name specific stop points (or state "None").` at 151, each string occurring exactly once in the Step 5 block (asserted). Searched the whole file for `core § 8|core §8|§ 8|executable-core` — no match, so Step 5 carried no core § 8 citation.
- Claim (2): HOLDS — `git hash-object plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returns `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`; `grep -c '^## 8\.'` on that file returns 1. The ordered branch dependency is unchanged from T4 and is restated, not re-litigated: § 8 and its citations complete together on this branch, and the canonical `ai-resources` checkout (on `main`, core blob `45e82bca…`, `grep -c '^## 8\.'` → 0) receives them together on integration.
- Claim (3): HOLDS — Step 5's own text ends at line 153 and the plan's output schema lives outside it at lines 208–212 (`## Autonomy Posture`, `{Full autonomy | Gated | Operator-in-the-loop}`, `**Stop points:**`, `{bulleted list or "None"}`), verified by index to sit after the `## Step 6` heading. A paragraph inserted between the stop-points instruction and the compaction-discipline line therefore touches no posture heading, no criterion, no stop-point instruction and no schema line. Confirmed by the strip-back proof below rather than by assertion alone.

Result: T5's citation is applied. `.claude/commands/session-plan.md` moved from blob `b83205a6fe7dc604fead4a458e2ad86b4d7e64d5` to `bfca768a1d2b4100ab714b88cd7d15f761359d77`. One sentence was added as its own paragraph inside Step 5, immediately after `Name specific stop points (or state "None").`:

> Posture is a planning classification: it sets where the session pauses, not what authority an individual action carries — the governing autonomy rule over that is core § 8 (`ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`); read it there rather than restating it here.

Two judgment calls inside the semantic contract, both surfaced rather than assumed. **Placement:** after the stop-points instruction, so the sentence qualifies the whole classification rather than any one posture; the alternative was before the three postures at line 134. **Path prefix:** `ai-resources/plans/…`, matching this file's own four existing citations (`ai-resources/docs/compaction-protocol.md`, `ai-resources/docs/audit-discipline.md`, `ai-resources/docs/qc-independence.md` ×2) and the ruling already applied at T4. T6 was not begun.

Evidence:

- **Citation absent before, present after.** `git show HEAD:.claude/commands/session-plan.md | grep -c 'core § 8'` → 0. `grep -c 'core § 8' .claude/commands/session-plan.md` → 1. The check keys on the exact string the change introduces, so an unapplied or reworded citation fails it.
- **Exactly one line added, none removed.** `git diff -U0 | grep -c '^+[^+]'` → 1; `grep -c '^-[^-]'` → 0. Total lines 272 → 274 (the sentence plus its blank separator). The full Step 5 diff is a single `+` hunk at line 152, shown against unchanged context on both sides.
- **All 13 protected Step 5 lines byte-identical, by strip-back.** Primitive: read the pre-edit file as a line list, build the post-edit list, then delete exactly the two inserted positions and compare the remainder to the pre-edit list with Python whole-list equality. Result `True`. This is fail-capable because equality is byte-for-byte over every line in order across the entire file: changing one character in a posture heading, dropping a criterion bullet, reordering two of them, or rewording the stop-points instruction all make the lists differ. The three posture headings were also counted independently (exactly 3 lines beginning `**` and containing `Use when:` inside Step 5) so that adding or removing a posture fails even if line count were preserved.
- **Output schema and everything outside Step 5 unchanged.** The five schema lines were compared positionally against a literal expectation and matched. Then `after[:step5] == before[:step5]` and `after[step6:] == before[step6:]` both returned `True` — every line before the Step 5 heading and every line from the Step 6 heading onward, including the schema, the emission lines at 239/251 and the review note at 270, is byte-identical.
- **Assert-before-write.** Every check above runs before the file is opened for writing, so a failed preservation check leaves the file untouched rather than needing a revert.
- **No core § 8 prose duplicated.** Searched the applied file with `grep -qF` for all eight phrases from core § 8 — "Within the approved solution envelope", "resolve what evidence can resolve", "exercise professional technical judgment", "pre-authorized capabilities", "Consequence increases containment", "does not by itself transfer the decision", "Escalate only when continuing requires", "bypass the control system" — all eight absent. The sentence points at the rule and states only the relationship the plan requires.
- **Regression: no new failure.** `bash logs/scripts/work-loop-v2-slice-1.test.sh` → **307 passed / 1 failed**, identical to the known local baseline. The single failure is the pre-existing `FAIL ridx the marked set matches the live installations, not just the brief`, which this unit did not touch and which remains deferred. **Stated plainly: this suite does not bind to the T5 citation** — `grep -c 'session-plan' logs/scripts/work-loop-v2-slice-1.test.sh` → 0, so it is breakage evidence only, not evidence that T5 landed. The strip-back, blob and citation checks above carry that.
- **Nothing else moved.** `git status --porcelain` shows `.claude/commands/session-plan.md`, this state file, and the pre-existing untouched `logs/friction-log.md`.

Deferral carried forward, still not done: `logs/friction-log.md` holds uncommitted insertions predating Unit 28, unrelated to T5. This unit preserved them and did not stage, edit or commit that file. The routing-index/live-installation suite failure likewise remains deferred, as the brief required.

## Blocker
None.

## Next action
Codex: assess Unit 30. T5 is applied — `.claude/commands/session-plan.md` is now blob `bfca768a1d2b4100ab714b88cd7d15f761359d77`, one sentence added inside Step 5, all three postures, their criteria, the stop-points instruction, the output schema and every line outside Step 5 proven byte-identical, no new regression. Two judgment calls are recorded above (placement after the stop-points instruction; `ai-resources/plans/…` path prefix) — rule on them if either is wrong. Decide close, continue to T6, or correct once. T6 was not begun.
