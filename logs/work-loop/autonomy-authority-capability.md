---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 23 — complete T3's two citation-only reconciliations in the Work Loop skill and Claude command.

Named reason for the loop: the approved plan sequences consumer reconciliation after T2, and these two public instruction surfaces must point to the newly canonical core § 8 without creating competing copies of its rule.

## Brief
T2 is accepted at implementation commit `17e03c3dc0e3e2b4f6db5d4a8ee052d84749a71b`, resulting core blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`. Its accepted rule is now available for consumers to cite. This unit implements only T3; T3a's semantic gate correction and T4–T9 remain outside it.

**Governing authority:** the re-frozen implementation plan at blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`, § 3.3 and T3; the canonical core at blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`, especially § 8. The plan requires citation-shaped changes only at the skill's existing authority hierarchy and the Claude command's Context Engineering framing note.

Required outcome: add a direct citation to canonical core § 8 at exactly these two existing semantic anchors, without adding or restating any autonomy-rule content:

1. `.agents/skills/work-loop-v2/SKILL.md` — the authority-hierarchy paragraph beginning `Classify each material claim cluster…` under `Keep authority semantic, content-bound, and explicit` (currently line 429).
2. `.claude/commands/work-loop-v2.md` — the Context Engineering framing note beginning `Context Engineering is live on the Codex side…` (currently line 126).

Scope: those two files and this state-file handback only. Each target receives citation content only. Excluded: the skill's `What you never do` hard-to-reverse bullet reserved for T3a; every other skill/command paragraph; the core; plan; proposal; autonomy rules; session plan; tests; routing index; and T4–T9. Preserve unrelated `logs/friction-log.md` changes and do not commit them.

Claims to check before editing:

1. The core is committed at blob `fb0ba8b…` and contains `## 8. The governing autonomy rule` once.
2. The two anchors above exist at their stated files and neither anchor currently cites `core § 8`.
3. The skill's separate categorical `Decide anything hard to reverse` bullet still exists and is not part of T3.

Required evidence:

- For each anchor independently, show the targeted `core § 8` citation check fails before and passes after.
- Show a focused diff proving each edit is citation-only: no duplicated or paraphrased proposal § 1 rule, no semantic authority change, and no change outside the two anchors.
- Show the skill's `Decide anything hard to reverse` bullet and every other `What you never do` bullet are byte-unchanged; T3a must remain visibly unimplemented.
- Confirm the canonical core remains blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136` and no excluded target changed.
- Run `work-loop-v2-slice-1.test.sh` as regression evidence. Compare against Unit 22's known local baseline of 307 passed / 1 failed: no new failure is allowed, and the sole existing `ridx` live-installation mismatch must remain demonstrably independent of these edits if still present.

Completion condition: both anchors cite core § 8, both diffs are citation-only, regression evidence adds no failure, and only the two target files plus this state handback are committed. Record the commit and evidence in `## Latest result`, set `turn: codex`, and stop without beginning T3a.

Stop conditions: stop and hand back if either anchor is absent or already materially different, a semantic rewrite is needed, a citation would duplicate the rule, T3a's bullet must change, another file becomes necessary, or any required evidence adds a regression.

## Latest result
Inspected (2026-08-15):
- Claim (1): HOLDS — `git rev-parse HEAD:plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and `git hash-object` on the worktree copy both return `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`; `grep -c '^## 8\. The governing autonomy rule$'` on that file returns `1`.
- Claim (2): HOLDS — `grep -n '^Classify each material claim cluster'` on `.agents/skills/work-loop-v2/SKILL.md` matched at line 429, and `grep -n '^Context Engineering is live on the Codex side'` on `.claude/commands/work-loop-v2.md` matched at line 126; searched both whole files for `core § 8` and for the bare pattern `§ 8` — no match in either.
- Claim (3): HOLDS — `grep -n 'Decide anything hard to reverse'` on the skill matched once, at line 508, inside the `## What you never do` list (block read at lines 500–511); the brief excludes that bullet from T3 and reserves it for T3a.

Result: T3 implemented as two citation-only edits, one sentence appended per anchor and nothing else. Skill line 429 now ends `The governing autonomy rule over this classification is core § 8; read it there rather than restating it here.` Command line 126 now ends `The governing autonomy rule over that consumption is core § 8; read it there rather than restating it here.` Neither sentence carries any autonomy-rule content; each is a pointer plus an explicit do-not-restate instruction, so no second copy of the § 8 rule exists. T3a is untouched and visibly unimplemented.

Evidence:
- Targeted citation check, per anchor, `grep -q 'core § 8'` — before: FAIL on the skill and FAIL on the command (both files held no `§ 8` string at all); after: PASS on both, exactly 1 occurrence each. The check is fail-capable: it failed on both files minutes before the edit.
- Focused diff — `git diff -U0` over the two targets returns exactly two changed lines, one per file, each an append to the existing paragraph's final sentence. No proposal § 1 text is duplicated or paraphrased, no hierarchy term or ordering changed, no line outside the two anchors moved.
- Negative check on T3a — `sed -n '500,511p'` over the skill's `What you never do` block hashes `4149866d60996c14d109908b67061d95ed2fb3b76aad4370457e1f38a6a7b91c` before and after, so line 508 and every sibling bullet are byte-unchanged.
- Excluded targets — core blob is still `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`; `git status --porcelain` shows only the two targets, this state file, and the pre-existing unrelated `logs/friction-log.md` change, which is not staged.
- Regression — `work-loop-v2-slice-1.test.sh`: 307 passed / 1 failed, matching Unit 22's baseline exactly. No new failure. The sole failure is the same known deferral, `ridx  the marked set matches the live installations, not just the brief`; it compares the routing index against local installations, and neither edited paragraph is in the routing index, which `git status` confirms unchanged.

## Blocker
None.

## Next action
Codex: assess Unit 23 — whether both anchors now cite core § 8 without introducing a competing statement of the rule, whether each diff is genuinely citation-only, whether the T3a bullet is confirmed byte-unchanged, and whether the regression evidence adds no failure. Then decide close, continue to T3a, correct once, or stop.
