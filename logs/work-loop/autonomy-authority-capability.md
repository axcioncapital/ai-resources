---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 27 — apply the exact risk-reviewed T3a two-surface candidate to the Work Loop skill.

Named reason for the loop: T3a changes Codex's operator-escalation instruction, and its exact reviewed prose must cross the implementation seam without drift before later tracers proceed.

## Brief
The corrected plan is re-frozen at status-record commit `db9ff2e9`, resulting plan blob `e12970a96325aee50b54be0bd81edc20ef5d9484`, over operator-approved substantive identity `ff1827b4` / `6cda14629bd3e26be3810443e260d466555967d7`. The exact two-surface T3a candidate recorded in that state handback received a fresh independent risk-aware review: **PASS**, no material findings, may be applied byte-for-byte. This unit applies it and nothing else.

**Exact implementation contract:** reconstruct the **NOT APPLIED** Part 2 candidate from `logs/work-loop/autonomy-authority-capability.md` at commit `db9ff2e9`. It changes only the `What you never do` introduction at skill line 502 and the operator-stop bullet at line 508. Do not redraft, shorten, improve, or relocate either replacement.

Scope: `.agents/skills/work-loop-v2/SKILL.md` and this state-file handback only. Excluded: plan, core, command, proposal, autonomy rules, session plan, tests, routing index, research report, and T4–T9. Preserve unrelated `logs/friction-log.md` changes and do not commit them.

Claims to check before editing:

1. The live and `HEAD` skill are blob `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`; both old categorical strings occur exactly once.
2. Commit `db9ff2e9` contains the complete exact two-surface candidate, and the fresh review verdict is PASS with no findings.
3. The plan is re-frozen at blob `e12970a9…` and requires byte-for-byte application of the reviewed candidate before T3a counts as implemented.

Required evidence:

- Prove the applied skill is byte-identical to a reconstruction of the exact candidate from commit `db9ff2e9`; show the implementation diff contains only those two replacements; report resulting skill blob and implementation commit.
- Show each old categorical string matches before and not after; show each replacement cites `core § 7`.
- Reconfirm per surface that no independent consequence/danger/expense/irreversibility trigger exists and no authority-class list was copied; confirm the bullet preserves Codex's stop duty and its core § 8 pointer remains citation-only.
- Show every sibling `What you never do` bullet and skill lines 465–475 are byte-unchanged; no third skill surface changes.
- Run `work-loop-v2-slice-1.test.sh`. Compare with the measured 307 passed / 1 failed baseline: no new failure is allowed, and the sole known `ridx` local-installation failure must remain the same if present.
- Confirm the plan remains blob `e12970a9…`, the core remains blob `fb0ba8b6…`, and no excluded target changed.

Completion condition: the skill matches the reviewed candidate exactly, required evidence passes with no new regression, only the skill plus this state handback are committed, `turn: codex`, and Claude stops without beginning T4.

Stop conditions: stop if any baseline differs, the candidate cannot be reconstructed or applied exactly, a required check fails, the suite adds a failure, another file becomes necessary, or any replacement would differ from the reviewed prose.

## Latest result
Inspected (2026-08-15), before editing:

- **Claim (1): HOLDS** — `git hash-object .agents/skills/work-loop-v2/SKILL.md` and `git rev-parse HEAD:` on the same path both return `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`, so live and `HEAD` were the same blob. Searched the whole file: `grep -n 'core § 7 reserves hard-to-reverse decisions for the operator'` returned exactly one line, 502; `grep -n 'Decide anything hard to reverse'` returned exactly one line, 508.
- **Claim (2): HOLDS in the half the repository can settle; the review verdict is carried, not verified.** `git show db9ff2e9:logs/work-loop/autonomy-authority-capability.md` contains one fenced `diff` block, 17 lines, covering both surfaces in one hunk — the complete two-surface candidate. Extracting it and `diff`-ing against the patch drafted at Unit 26 reports them identical, and `git apply --check` on the extracted patch returned 0. The **PASS, no findings** verdict is an external review result recorded by Codex in this brief and in the superseded `## Latest result`; it leaves no repository artifact, so this unit carries it as stated rather than claiming to have confirmed it. Nothing in the unit rests on more than that.
- **Claim (3): HOLDS** — `git hash-object` on the plan returns `e12970a96325aee50b54be0bd81edc20ef5d9484`, equal to `git rev-parse HEAD:` on it. Read its two status regions: both open on **Re-frozen for implementation — 2026-08-15** over approved substantive identity `ff1827b4…` / `6cda1462…`, and both state the single remaining gate as one fresh risk-aware review of the **exact two-surface candidate** before any skill edit. § 3.3a *Failure behavior* states that a diff correcting only one of the two surfaces fails the specification, and that a diff reaching any third skill surface fails it in the opposite direction.

Result: **T3a is implemented.** The reviewed two-surface candidate was reconstructed from commit `db9ff2e9` and applied byte-for-byte to `.agents/skills/work-loop-v2/SKILL.md`. Nothing was redrafted, shortened or relocated. The skill now stands at blob `b21cf35002b7f6ac90b7189258a2af0240a6e662`; the implementation commit is the single commit carrying this hand-back, and it is the only commit this unit makes.

**The applied change, in full — two lines, one section.**

```diff
@@ -502 +502 @@
-Core § 1 sets the limits on your role and core § 7 reserves hard-to-reverse decisions for the operator. In this file's terms:
+Core § 1 sets the limits on your role, and core § 7 states the classes of decision reserved to the operator. In this file's terms:
@@ -508 +508 @@
-- **Decide anything hard to reverse** — that is the operator's, via core § 7.
+- **Decide anything core § 7 reserves to the operator** — read that boundary there rather than judging it by how consequential a decision looks, and stop for the operator whenever one of its reserved classes applies. Outside those classes, core § 8 governs.
```

Evidence:

- **Byte-identical to a reconstruction of the reviewed candidate, proved independently of the applying step.** The fenced candidate was extracted from `git show db9ff2e9:<state file>` into a patch, then applied to a *separate* copy of `git show HEAD:<skill>` in the scratchpad. `diff -q` between that independent reconstruction and the edited repository file is empty. The two paths — the applied file and the reconstruction — never touched each other, so agreement is a real comparison and not a restatement of one operation.
- **The implementation diff contains only the two replacements.** `git diff -U0 -- <skill>` returns exactly two hunks, `@@ -502 +502 @@` and `@@ -508 +508 @@`, and nothing else. Line totals are 530 before and 530 after; whole-file `diff | grep -c '^[<>]'` returns `4` — two removed, two added.
- **(a) old categorical strings, before and after.** `core § 7 reserves hard-to-reverse decisions for the operator` — before `1`, after `0`. `Decide anything hard to reverse` — before `1`, after `0`. Each matched exactly once on the pre-edit file, so an edit that missed either surface would still show.
- **(b) each replacement cites `core § 7`.** `sed -n '502p' | grep -c 'core § 7'` returns `1`; the same on line 508 returns `1`.
- **(b) semantic reconfirmation, per surface — no independent consequence trigger.** Scanned both applied lines for the whole trigger family (`hard to reverse`, `hard-to-reverse`, `irreversib`, `consequential`, `consequence`, `dangerous`, `expensive`, `major`, `significant`). **Line 502: zero hits of any of them** — the framing sentence now names core § 7 as the place the reserved classes are stated and carries no trigger of its own, in any wording. **Line 508: one hit, `consequential`, and it is a negation** — "read that boundary there **rather than** judging it by how consequential a decision looks" — which forbids a consequence test rather than creating one. Reported as a hit rather than filtered out, so the reviewer sees the word and can judge its direction instead of trusting a clean count.
- **The bullet preserves Codex's stop duty, and the core § 8 pointer stays citation-only.** The duty survives verbatim as "stop for the operator whenever one of its reserved classes applies" — a reference to core § 7's classes, not a rule the skill restates. The trailing "Outside those classes, core § 8 governs" names core § 8 and reproduces no part of its text; core § 8's rule appears nowhere in the skill.
- **(c) no authority-class list copied.** Both applied lines were scanned against proposal § 6's nine operator-reserved decisions (intended outcome, priority, scope expansion, exclusion removal, product/business behaviour, operating model / architecture / cost / risk profile / governance, residual risk, capability envelope, production deployment / credential use / destructive shared-state action, tied or conflicting intentions). **Zero hits on either line.** Neither replacement enumerates or paraphrases the list it points at.
- **(d) nothing else moved.** Sibling `What you never do` bullets 504, 505, 506, 507, 509 and 510 each report IDENTICAL under line-by-line comparison against `git show HEAD:<skill>`. Lines 465–475 are byte-identical, so line 473's proportional re-check condition is untouched. No third skill surface changed.
- **Regression suite: no new failure.** `bash logs/scripts/work-loop-v2-slice-1.test.sh` measured **307 passed / 1 failed** immediately before the edit and **307 passed / 1 failed** immediately after, with the identical sole failure `FAIL  ridx  the marked set matches the live installations, not just the brief` — the known local-installation deferral, unchanged in both runs. **Reported as a regression check only, and it is a weak one here by construction:** `grep -c 'hard to reverse\|hard-to-reverse'` over the suite returns `0`, so no test binds to either surface's prose and the suite could not have distinguished this semantic fix from its absence. It shows the edit broke nothing; it is not evidence the fix exists. That is the evidence (a)–(d) carry.
- **No excluded target changed.** Working-tree blob equals `HEAD:` blob for all seven: plan `e12970a9…`, core `fb0ba8b6…`, Claude command `61ac65cf…`, `docs/autonomy-rules.md` `ed42ba9d…`, `.claude/commands/session-plan.md` `b83205a6…`, `logs/scripts/work-loop-v2-slice-1.test.sh` `02286299…`, proposal `e2a50c5e…`. `git status --porcelain` lists only the skill, this state file and the pre-existing unrelated `logs/friction-log.md`, which is not staged.

Nothing was noticed mid-unit that needed deferring. The plan's § Repository Delta risky-assumption-5 wording remains the deferral recorded at Unit 25, unchanged.

## Blocker
None.

## Next action
Codex: assess this unit. T3a is implemented and the skill stands at blob `b21cf35002b7f6ac90b7189258a2af0240a6e662`; the plan's status regions still describe T3a as the nearest unmet tracer, so recording it as landed is a status question for the next unit, not something this one changed. T4 has not been begun.
