---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 26 — record the corrected-plan re-freeze and return the exact two-surface T3a candidate for its required review.

Named reason for the loop: the approval record and candidate are one authorization package—the approved contract must be durably identified, and the exact prose it governs must be reviewable before any skill edit.

## Brief
The operator explicitly approved corrected plan content at commit `ff1827b4`, blob `6cda14629bd3e26be3810443e260d466555967d7`, on 2026-08-15, and directed us to combine the status record with candidate drafting to finish promptly. Record the re-freeze in the plan's two live status regions, then return an exact **NOT APPLIED** candidate for the two T3a skill surfaces. Do not edit the skill.

**Governing authority:** the operator's content-bound approval above; the approved proposal at blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`, §§ 4 and 6; the canonical core at blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`, §§ 7–8; and corrected plan blob `6cda14629bd3e26be3810443e260d466555967d7`, § 3.3a and T3a. The prior one-bullet candidate is superseded and remains unapplied.

Required outcome:

1. Update only the plan's opening status record and final `## Plan-readiness statement` to record the content-bound re-freeze at `ff1827b4` / `6cda1462…`, the completed review/correction/closure sequence, accurate implemented T1–T3 state, unimplemented T3a state, and the remaining exact-candidate risk-aware-review gate. State that the status record implements nothing.
2. Draft a complete one-file unified diff, labelled **NOT APPLIED**, for exactly two existing lines in `.agents/skills/work-loop-v2/SKILL.md`: the `What you never do` introduction currently saying core § 7 reserves hard-to-reverse decisions, and the bullet currently beginning `Decide anything hard to reverse`.
3. Both replacements must cite core § 7 as the canonical boundary, state no independent operator trigger keyed to consequence, danger, expense, irreversibility, or difficulty of reversal, and copy no proposal § 6/core § 7 class list. The bullet must preserve Codex's duty to stop when a § 7 operator-reserved class applies. A citation-shaped core § 8 pointer is permitted but must not restate its rule.

Scope: edit only the plan's two status regions and this state-file handback. The candidate exists only in this state file or session scratch. Do not edit or commit the skill, core, command, proposal, autonomy rules, session plan, tests, routing index, research report, or later tracers. Preserve unrelated `logs/friction-log.md` changes.

Claims to check:

1. The plan at `HEAD` is approved blob `6cda1462…`, still draft in both status regions.
2. The skill is unchanged at blob `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`; both old categorical strings occur exactly once in the named section.
3. The corrected plan requires an exact two-surface candidate and one fresh risk-aware review before implementation.

Required evidence:

- For the plan, show a zero-context diff confined to the two status regions; prove the plan body outside them is byte-unchanged from `6cda1462…`; confirm both records agree on identity, history, implementation state, and remaining gate; report the resulting plan blob and status-record commit.
- For the candidate, return the complete diff labelled **NOT APPLIED** and prove it applies cleanly to skill blob `965583db…` without changing the repository skill.
- Show each old categorical string matches before and not in the candidate; show `core § 7` in each replacement. Treat that grep as necessary, not sufficient: record a separate reviewer-readable judgment for each surface that it states no independent consequence-based trigger under any wording.
- Confirm neither replacement enumerates or paraphrases the authority-class list; every sibling bullet and skill lines 465–475 are byte-identical before/candidate; no other skill line changes.
- Confirm every implementation target remains unchanged and identify any genuine judgment call for the fresh risk-aware review.

Completion condition: the plan re-freeze is recorded, the exact two-surface candidate and evidence are in `## Latest result`, only the plan plus this state handback are committed, `turn: codex`, and the skill remains unchanged. Stop without reviewing or implementing the candidate.

Stop conditions: stop if the approved identity differs, the status update requires substantive plan change, either skill surface differs, the two-surface candidate requires another line/file, a replacement introduces a freestanding categorical trigger or class-list copy, or sources conflict.

## Latest result
Inspected (2026-08-15):

- **Claim (1): HOLDS** — `git ls-tree -r HEAD -- <plan>` returns blob `6cda14629bd3e26be3810443e260d466555967d7`, and `git status --porcelain` listed the plan as unmodified before this unit, so the working tree matched the approved blob. Read both status regions in that blob: the Status block opened "**Draft — returned to draft on 2026-08-15 by the T3a two-surface scope amendment**" (plan line 3) and § Plan-readiness statement opened "This artifact is **a draft**." (plan line 1545). Both were draft; no third status record exists (`grep -n '^## \|^# '` returns 6 headings, one of them § Plan-readiness statement).
- **Claim (2): HOLDS** — `git hash-object .agents/skills/work-loop-v2/SKILL.md` returns `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`, equal to `git rev-parse HEAD:` on the same path. Searched the whole file for both categorical strings: `grep -n 'core § 7 reserves hard-to-reverse decisions for the operator'` returns exactly one line, 502; `grep -n 'Decide anything hard to reverse'` returns exactly one line, 508. Both sit inside `## What you never do` (heading at line 500, list at 504–510). The only other `hard-to-reverse` occurrences are line 431 (plan-approval materiality prose) and line 473 (the four-condition proportional re-check), neither of which is a T3a surface.
- **Claim (3): HOLDS** — read § 3.3a (plan lines 739–841) and tracer T3a (1200–1214) in blob `6cda1462…`. § 3.3a *Scope boundary* reads "exactly the introductory sentence currently at line 502 and the bullet currently at line 508"; its *Failure behavior* states "**A diff that corrects only one of the two surfaces fails this specification**"; its *Review row* requires "one risk-aware Codex review before implementation, of the **exact two-surface candidate**" and records that "The Unit 24 review saw only the one-bullet candidate and does not discharge this requirement for a candidate it has not read."

Result: the re-freeze is recorded in the plan's two status regions, and the exact two-surface T3a candidate is drafted and **NOT APPLIED**. The status update touched only those two regions; the repository skill, core, command, autonomy rules, session plan, tests and proposal are byte-unchanged. The resulting plan blob is reported below; the status-record commit is the single commit carrying this hand-back, which is the only commit this unit makes and the only one touching the plan since `ff1827b4` — a repository fact Codex reads from Git rather than from a hash this file cannot contain about itself.

**Part 1 — the status-only re-freeze.**

- **Diff is confined to the two status regions.** `git diff -U0 HEAD -- <plan>` returns ten hunks and no others: `@@ -3,3`, `@@ -10,32`, `@@ -96`, `@@ -104` (all inside the opening status block, which ends at the `---` on old line 175) and `@@ -1545,2`, `@@ -1548,2`, `@@ -1552`, `@@ -1555,19`, `@@ -1624,2`, `@@ -1632,4` (all inside § Plan-readiness statement, which begins at old line 1543). No hunk falls between 176 and 1542.
- **The plan body outside the two regions is byte-unchanged, proved fail-capably.** Extracted `## 1. Fixed Point` through the line before `## Plan-readiness statement` from `git show HEAD:<plan>` and from the edited file: 1366 lines each, SHA-256 `e1711f479a2713db5ddf82637847a5c3c26031aa30c48f30f9705f2614644c78` on both, `diff -q` empty. Control: the same extracted body with one stray line rewritten to `STRAY CONTROL EDIT` is reported as differing, so the check detects an out-of-region change rather than passing by construction.
- **No structural change.** Heading count is 35 before and 35 after, and `diff` of the two heading lists is empty — no section added, renamed, renumbered or removed.
- **Both records agree on identity, history, implementation state and the remaining gate.** Each of `ff1827b4fcf30597d1e448bbce49f43a6001b85f`, `6cda14629bd3e26be3810443e260d466555967d7`, `d6d0e436f78638bae1867b637c6dba91a2b8c104` and `8f66a2ac4f36adbc6fbd24750307d668f35cd182` occurs exactly **twice** in the file — once per region. Both regions state the same six completed gates in the same order (operator direction at `733a17fd` → draft amendment at `d6d0e436`/`8f66a2ac…` → fresh isolated bounded review, verdict **CORRECT**, two material frozen findings → one bounded correction at `ff1827b4`/`6cda1462…` with the risky-assumption-5 deferral → Codex closure check **PASS**, no second broad review → operator content-bound approval). Both state T1, T1a, T2 and T3 implemented and the only implemented tracers, T3a the nearest unmet tracer with no skill edit existing, T4–T9 unimplemented. Both state the one remaining gate as a fresh risk-aware review of the **exact two-surface candidate**, and both keep § Plan-readiness statement as the matching record with no third status record.
- **The status record implements nothing, stated in both regions.** Status block: "**This status record announces that approval and implements nothing.** It edits only this Status block and § Plan-readiness statement… it applies no candidate, and it authorizes no skill edit." § Plan-readiness statement: "**This readiness record itself edits, corrects and applies nothing**…".
- **Resulting plan blob: `e12970a96325aee50b54be0bd81edc20ef5d9484`.**

**Part 2 — T3a two-surface candidate, NOT APPLIED.**

```diff
--- a/.agents/skills/work-loop-v2/SKILL.md
+++ b/.agents/skills/work-loop-v2/SKILL.md
@@ -499,12 +499,12 @@
 
 ## What you never do
 
-Core § 1 sets the limits on your role and core § 7 reserves hard-to-reverse decisions for the operator. In this file's terms:
+Core § 1 sets the limits on your role, and core § 7 states the classes of decision reserved to the operator. In this file's terms:
 
 - **Commit, or mutate Git state by any other means** — `add`, `checkout`, `reset`, `merge`, `rebase`, `push`. Claude does that — see core § 4 on who commits. Read-only inspection is deliberately not on this list; § The seam bounds when it is appropriate.
 - **Silently repair a bad brief on Claude's behalf**, or ask Claude to build past a premise it found false.
 - **Reopen the strategy after every result** (core § 1).
 - **Add a second review or a second state system** over a unit running under a specialist Axcíon workflow (core § 1).
-- **Decide anything hard to reverse** — that is the operator's, via core § 7.
+- **Decide anything core § 7 reserves to the operator** — read that boundary there rather than judging it by how consequential a decision looks, and stop for the operator whenever one of its reserved classes applies. Outside those classes, core § 8 governs.
 - **Answer a nonzero dispatcher exit by leaving the dispatcher.** No interactive Claude session, no hand-carried hop, no hand-edit of the state file. See § Three outcomes for the five clauses of what a stop *does* authorize.
 - **Write a brief that proposes invoking Claude or Codex inside a hop.** There is no supported way to run nested AI, and no flag enables it — the dispatcher denies the default direct route on every launch. A case that appears to need it goes to the operator as a capability question. Do not authorize it inside a brief, and do not design an evidence set that can only be satisfied by invoking a model.
```

The line-508 replacement is the Unit 24 candidate bullet **verbatim** — § 3.3a records that the Unit 24 review found that bullet sound, with its core § 8 pointer and its length both explicitly non-blocking, and that this amendment "expands the surface, not the required prose". Only the line-502 surface is new prose.

**Part 2 evidence — applies cleanly, and the repository skill is unchanged.**

`git apply --check` on the patch against the live worktree returned 0 and wrote nothing. The patch was then applied to a scratch copy only (`scratchpad/sim/.agents/skills/work-loop-v2/SKILL.md`); every check below compares the live file against that scratch copy. After both operations `git hash-object` on the repository skill still returns `965583dbc0e58626436b1deb5a5cbf885ebc6bf3`, and `git status --porcelain` lists only `logs/friction-log.md` (pre-existing, unrelated, not committed here), this state file and the plan.

- **(a) exact-phrase regression guards, one per surface.** `core § 7 reserves hard-to-reverse decisions for the operator` — live `1`, candidate `0`. `Decide anything hard to reverse` — live `1`, candidate `0`. Each matches exactly once on the pre-edit file, so a candidate that left either string would fail.
- **(b) structural citation proof, per surface.** `sed -n '502p' | grep -c 'core § 7'` on the candidate returns `1`; the same on line 508 returns `1`. Fail-capable and independent of (a): the control string `- **Decide anything irreversible** — see core § 7 for the classes.` passes this grep (`1`) while failing (a)'s intent, which is exactly why the grep is necessary and not sufficient.
- **(b) judgment, recorded separately per surface** — the reviewer-readable half § 3.3a requires:
  - **Line 502.** (i) It names core § 7 as the place the boundary is stated — "core § 7 states the classes of decision reserved to the operator" — and names no class itself. (ii) It states **no independent consequence-based operator trigger under any wording**: the sentence contains no reference to consequence, danger, expense, irreversibility or difficulty of reversal at all, so there is no synonym trigger to smuggle one back in. It stays a framing sentence introducing the list ("In this file's terms:"), not a rule of its own.
  - **Line 508.** (i) It cites core § 7 twice over — the bullet's subject is "anything core § 7 reserves to the operator", and the reader is told to "read that boundary there". (ii) Its only mention of consequence is a **negation** — "rather than judging it by how consequential a decision looks" — which forbids a consequence test instead of creating one. The retained duty, "stop for the operator whenever one of its reserved classes applies", is a reference to core § 7's classes rather than a rule the skill can drift from, so Codex's operator-stop duty is preserved without the bullet standing alone. The trailing "Outside those classes, core § 8 governs" is a citation-shaped pointer: it names core § 8 and restates none of its rule.
- **(c) no class list copied, checked on both replacements.** Read both replacements against proposal § 6 (lines 215–224, "Operator-reserved decisions", nine items) and its mandatory stop-or-handback conditions. Neither replacement names any of them, verbatim or paraphrased. Line 502 carries one pointer and no enumeration; line 508 carries one pointer, one negation of the old trigger, one duty sentence and one core § 8 pointer. The phrase "its reserved classes" is a reference to the list, not a copy of it.
- **(d) nothing else moved.** Whole-file `diff | grep -c '^[<>]'` returns `4` — two removed lines, two added — and line totals are 530 before and 530 after, so exactly two lines changed. Sibling bullets 504, 505, 506, 507, 509 and 510 each report IDENTICAL under line-by-line string comparison. `diff` of lines 465–475 between live and candidate is empty, so line 473's proportional re-check condition is untouched. No third skill surface is reached.
- **(e) regression check: none claimed, and why.** This unit changes prose in one plan and this state file; it touches no executable or instruction target, so `work-loop-v2-slice-1.test.sh` could not distinguish success from failure here. Its measured baseline — 307 passing with the single pre-existing `ridx` local-installation failure — is unchanged and belongs to the implementation unit that applies the candidate, not to this one.
- **Every implementation target remains unchanged.** Working-tree blob equals `HEAD:` blob for all seven: skill `965583db…`, core `fb0ba8b6…`, Claude command `61ac65cf…`, `docs/autonomy-rules.md` `ed42ba9d…`, `.claude/commands/session-plan.md` `b83205a6…`, `logs/scripts/work-loop-v2-slice-1.test.sh` `02286299…`, proposal `e2a50c5e…`.

**Part 3 — genuine judgment calls for the fresh risk-aware review, surfaced and not resolved here.**

1. **Line 502 drops the words "hard-to-reverse" without replacing them with any trigger at all.** The old sentence told the reader *what* core § 7 reserves; the replacement tells them *that* core § 7 states the reserved classes and sends them there. That is deliberate — any characterisation would risk becoming a second categorical rule — but it makes the introduction slightly less informative than the line it replaces. The reviewer should decide whether the framing sentence should carry more, and if so, what it can say without acquiring a trigger.
2. **The core § 8 pointer sits on the bullet only, not on the introduction.** § 3.3a permits it on either surface and requires it on neither. Placing it once keeps the introduction purely framing and avoids a second copy; a reviewer could reasonably ask for it on the introduction instead, or for it to be cut entirely — the Unit 24 review recorded it non-blocking on the bullet.
3. **Line 502's replacement changes the sentence's punctuation** (adding a comma before "and") so the two clauses read as one framing statement rather than two rules. Cosmetic, disclosed so the reviewer weighs it rather than discovering it in the diff.
4. **Neither replacement was reviewed by the Unit 24 review**, which read only the one-bullet candidate. This is the first candidate covering both surfaces, so its § 3.3a check-(b) judgment above is asserted by the implementer and has not yet been independently affirmed — that affirmation is the gate this hand-back opens.

Nothing newly noticed during this unit was implemented. The plan's § Repository Delta risky-assumption-5 wording remains the deferral recorded at Unit 25, unchanged.

## Blocker
None for this unit. T3a implementation remains blocked until the exact two-surface candidate above passes its own fresh risk-aware Codex review.

## Next action
Codex: assess this combined unit. The plan is re-frozen at the operator-approved content and the candidate is returned unapplied. Then arrange the one fresh, isolated risk-aware review of the **exact two-surface candidate** in Part 2 — including the per-surface § 3.3a check-(b) judgment asserted above and the four judgment calls in Part 3 — before any skill edit is authorized. The repository skill stays at blob `965583dbc0e58626436b1deb5a5cbf885ebc6bf3` until that review passes.
