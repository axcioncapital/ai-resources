---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Discovery mode. Unit 24 — produce the exact unapplied T3a one-bullet candidate for its required risk-aware review.

Named reason for the loop: T3a changes Codex's own operator-escalation instruction, so the approved plan requires an exact candidate and one risk-aware Codex review before implementation.

## Brief
Unit 23 is accepted at commit `7e347de4db5396c1707e6b181c3884ac12dbdfd1`: both citation-only T3 anchors now point to core § 8, T3a remained byte-unchanged, and no regression was added. T3a is now the nearest unmet tracer. This unit prepares its exact review object only; it does not edit the skill.

**Governing authority:** the re-frozen implementation plan at blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`, § 3.3a and T3a; the reconciled canonical core at blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`, especially § 7; and proposal §§ 4 and 6. The plan requires the categorical `hard to reverse` instruction to be replaced by a citation to core § 7, without restating § 7's class list in the skill.

Required outcome: draft and return a complete unified diff, clearly labelled **NOT APPLIED**, for exactly the one `What you never do` bullet in `.agents/skills/work-loop-v2/SKILL.md` that currently begins `Decide anything hard to reverse`. The candidate must preserve Codex's operator-stop duty by deferring to the reconciled core § 7 boundary, remove the freestanding categorical trigger, introduce no differently worded consequence/irreversibility trigger, and avoid copying proposal § 6 or core § 7's class list.

Scope: inspect the canonical core § 7, proposal §§ 4 and 6, the plan's § 3.3a/T3a contract, and the skill's `What you never do` list; write only this state-file handback. Do not edit the skill or any other target. T4 and later tracers are excluded.

Claims to check:

1. The skill at commit `7e347de4…` contains exactly one bullet beginning `Decide anything hard to reverse`, and the other `What you never do` bullets match the T3a starting contract.
2. Canonical core § 7 now lists the actual operator-reserved and mandatory handback boundaries and is blob `fb0ba8b…`.
3. The plan's T3a review row requires one risk-aware Codex review before implementation; none has yet reviewed an exact T3a candidate.

Required evidence:

- Return the complete one-file unified diff labelled **NOT APPLIED**, with exactly one bullet changed.
- Show the bare string `Decide anything hard to reverse` matches before and not in the candidate; show `core § 7` matches in the replacement bullet.
- Read the replacement against proposal § 6 and confirm it does not enumerate or paraphrase the operator-reserved and mandatory-stop class list, and does not introduce another freestanding categorical synonym.
- Show every sibling `What you never do` bullet is byte-identical before/candidate and that skill lines 465–475's proportional re-check conditions are unchanged.
- Confirm the repository skill, core and all other targets remain unchanged; the candidate exists only in the state handback or session scratch.
- Identify any genuine judgment call for the risk-aware review rather than resolving it by widening the candidate.

Completion condition: record the exact unapplied candidate and fail-capable evidence in `## Latest result`, set `turn: codex`, commit only this state-file handback, and stop. Do not implement T3a.

Stop conditions: stop if the current bullet or core boundary differs from the plan's premise, preserving the duty requires enumerating the class list, more than one skill bullet must change, another file becomes necessary, or the sources conflict.

## Latest result
Inspected (2026-08-15):
- Claim (1): HOLDS — `grep -n 'Decide anything hard to reverse'` on `.agents/skills/work-loop-v2/SKILL.md` returns exactly one match, line 508, in the working tree and in `git show 7e347de4:.agents/skills/work-loop-v2/SKILL.md`; `git diff 7e347de4 -- .agents/skills/work-loop-v2/SKILL.md` is empty, so working tree and that commit are the same blob `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`. Read block 500–511: the `What you never do` list holds seven bullets, and the six siblings are exactly the six the plan's § 3.3a Guaranteed-behavior clause names — Git mutation (504), silently repairing a bad brief (505), reopening strategy after every result (506), a second review/state system (507), answering a nonzero dispatcher exit by leaving it (509), and authorizing nested-actor invocation inside a brief (510). Starting contract matched.
- Claim (2): HOLDS — `git hash-object plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returns `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`. Read core § 7 (lines 461–513): it carries the "Consequence is not itself a trigger" paragraph, a six-item **Hand back to Codex** list, and a thirteen-item **Stop for the operator** list — the actual reserved and mandatory-handback boundaries, not a categorical consequence rule.
- Claim (3): HOLDS — `git hash-object` on the implementation plan returns `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`; its T3a Review row (plan line 1132–1133) and § 3.3a Review row (plan line 749–750) both read "high-consequence … one risk-aware Codex review before implementation". Searched the full commit history for a returned T3a candidate: `git log --all --oneline --grep='T3a'` returns only `ccf134b8` (Unit 11, corrected T3a's *evidence contract*) and `9a0053a0` (Unit 16, a T2 amendment); `git log --oneline -30` shows no unit handing back a T3a candidate. No risk-aware review has yet seen an exact T3a candidate.

Result: the exact T3a candidate is drafted and **NOT APPLIED**. It replaces exactly one bullet — skill line 508 — and nothing else. The repository is byte-unchanged at every target; the candidate exists only below and in session scratch.

**T3a candidate — NOT APPLIED**

```diff
--- a/.agents/skills/work-loop-v2/SKILL.md
+++ b/.agents/skills/work-loop-v2/SKILL.md
@@ -505,7 +505,7 @@
 - **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
 - **Reopen the strategy after every result** (core § 1).
 - **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow (core § 1).
-- **Decide anything hard to reverse** — that is the operator's, via core § 7.
+- **Decide anything core § 7 reserves to the operator** — read that boundary there rather than judging it by how consequential a decision looks, and stop for the operator whenever one of its reserved classes applies. Outside those classes, core § 8 governs.
 - **Answer a nonzero dispatcher exit by leaving the dispatcher.** No interactive Claude session, no hand-carried hop, no hand-edit of the state file. See § Three outcomes for the five clauses of what a stop *does* authorize.
 - **Write a brief that proposes invoking Claude or Codex inside a hop.** There is no supported way to run nested AI, and no flag enables it — the dispatcher denies the default direct route on every launch. A case that appears to need it goes to the operator as a capability question. Do not authorize it inside a brief, and do not design an evidence set that can only be satisfied by invoking a model.
 
```

Evidence:
- **Applies as written, unapplied.** `git apply --check` on the patch against the live worktree returned 0 ("APPLIES CLEANLY") and modified nothing. The patch was then applied to a scratch copy only (`scratchpad/sim/.agents/skills/work-loop-v2/SKILL.md`); every check below compares the live file against that scratch copy.
- **(a) exact-phrase regression guard.** `grep -c 'Decide anything hard to reverse'` — live file: `1`; scratch copy: `0`. Fail-capable: it returns 1 on the current file, so a candidate that left the phrase would fail it.
- **(b) structural citation proof.** `sed -n '508p' <scratch> | grep -c 'core § 7'` returns `1`. Fail-capable and independent of (a): a control string — a differently-worded freestanding bullet, `- **Decide anything irreversible** — that is the operator.` — passes (a) and returns `0` on this same check.
- **(c) no class list copied.** Read the replacement bullet against proposal § 6 (lines 215–235). Proposal § 6 lists nine operator-reserved decisions and seven mandatory stop-or-handback conditions; the candidate names **none** of the sixteen, verbatim or paraphrased. It carries one pointer (`core § 7`), one negation of the old trigger, one duty sentence, and one pointer to core § 8. No freestanding categorical synonym is introduced: the only trigger the bullet states is "one of its reserved classes", which is a reference, not a rule the skill can drift from.
- **(d) siblings byte-identical.** Line-by-line string comparison of lines 504, 505, 506, 507, 509, 510 between live file and scratch copy — all six report IDENTICAL. Whole-file `diff | grep -c '^[<>]'` returns `2` (one removed line, one added line), and line totals are 530 before and 530 after, so exactly one bullet changed.
- **Lines 465–475 unchanged.** `diff` of that range between live file and scratch copy is empty. Line 473's proportional re-check condition ("A consequential or hard-to-reverse claim (core § 7)") is untouched, as § 3.3a's Guaranteed-behavior clause requires.
- **Repository unchanged.** `git status --porcelain` reports only `logs/friction-log.md` (pre-existing, unrelated, not committed here) and this state file. `git hash-object` on the skill returns `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`, equal to `git rev-parse HEAD:.agents/skills/work-loop-v2/SKILL.md`; the core is still `fb0ba8b…` and the plan still `eebb9a49…`.
- **No regression check was run**, and none is claimed: this unit changes no executable or instruction target, so `work-loop-v2-slice-1.test.sh` could not distinguish success from failure here. Plan check (e) belongs to the implementation unit that applies the candidate.

Judgment calls for the risk-aware review — surfaced, not resolved by widening:

1. **Skill line 502 keeps the categorical framing.** The `What you never do` intro reads "Core § 1 sets the limits on your role and core § 7 reserves hard-to-reverse decisions for the operator." That is the same unqualified transfer-on-consequence claim T3a removes one line below it. Plan lines 338, 586 and 1381 bound T3a to line 508 and nothing else, so the candidate leaves 502 alone. The consequence is that after T3a lands the section's intro and its bullet disagree. The reviewer should decide whether that is accepted as a written limitation, given a new tracer, or handled some other way — this unit does not decide it.
2. **The bullet's second sentence, "Outside those classes, core § 8 governs," is an addition.** Checks (a) and (b) are satisfied by the first sentence alone. The pointer is a citation, not a restatement, and it is what keeps a reader from inferring that removing the categorical trigger left consequence unhandled — but it is more than the minimum the plan compels, so it is a legitimate thing for the reviewer to cut.
3. **Bullet length.** The replacement is longer than the line it replaces, because a citation plus the retained duty needs more words than a categorical rule. Siblings at 509 and 510 are longer still, so the list's style absorbs it; noted so the reviewer weighs it rather than discovering it.

## Blocker
None.

## Next action
Codex: run the required risk-aware review of the exact unapplied T3a candidate above against the plan's § 3.3a Outputs, Guaranteed behavior and Failure behavior, and decide the three surfaced judgment calls — line 502's surviving categorical framing, the candidate's core § 8 pointer, and bullet length. Then either accept the candidate for a byte-for-byte implementation unit, or return frozen findings for one correction.
