---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 25 correction — resolve the two frozen findings from the fresh bounded review of the T3a plan amendment.

Named reason for the loop: the draft amendment is substantively sound but cannot proceed to operator approval while its evidence overclaims what a citation grep proves and its internal-consistency text misstates the newly authorized second surface.

## Brief
The operator-authorized T3a plan amendment landed in draft at commit `d6d0e436`, resulting plan blob `8f66a2ac4f36adbc6fbd24750307d668f35cd182`. A fresh independent bounded review returned **CORRECT** with exactly two material findings. The review otherwise confirmed the draft status and gates, two-surface authority semantics, historical truth, factual T2/T3 currency correction, fixed ordering, post-approval fresh-review sequence, and absence of wider tracer or Fixed Point changes.

Correction scope: the implementation plan and this state-file handback only. Change only the exact plan clauses necessary to resolve findings 1 and 2 below. No skill or other implementation target; no new plan redesign; no unrelated wording cleanup; no second broad review. Preserve the accepted implementation-state currency correction.

Required evidence: show a focused before/after diff for each frozen finding; answer only whether both findings are resolved and whether the correction broke anything; prove all plan content outside those correction clauses is byte-unchanged from blob `8f66a2ac…`; confirm every implementation target remains unchanged; report the correction commit and resulting plan blob. Any newly noticed issue is a deferral, not a third finding.

Completion condition: correct both findings, record bounded closure evidence in `## Latest result`, commit only the plan plus this state handback, set `turn: codex`, and stop. Do not seek operator approval, draft the candidate, or edit the skill.

## Latest result
Reproduced (2026-08-15), before correcting — each frozen finding checked by inspection against blob `8f66a2ac…`:

- **Finding 1: REPRODUCES.** Read § 3.3a check (b) (plan lines 809–813) and T3a Verification (b) (1218–1219). Both called the `core § 7` grep "the proof each surface defers to the reconciled boundary rather than standing alone" / "structural proof neither stands alone". That is an overclaim: a replacement of the form `- **Decide anything irreversible** — see core § 7 for the classes.` carries the citation and a freestanding categorical trigger at once, so it matches `grep -q "core § 7"` and passes (b) as written while reintroducing exactly the defect T3a removes. Nothing else in the evidence contract closed that gap — (a) is an exact-phrase guard on the two old strings, (c) is the class-list check, (d) is a byte-comparison of untouched text.
- **Finding 2: REPRODUCES.** `grep -n` located two live statements. Plan line 1487: "This amendment schedules no *additional* skill edit: it corrects the boundary of the one T3a already owned". Plan line 1512: "This amendment adds no new implementation surface: line 502 sits in the same file and the same section T3a already owned." Both sat in the internal-consistency and count text, 25 and 12 lines after the same section established line 502 as T3a's newly added second surface. As written they contradict that: the amendment does add one surface.

Result: both frozen findings are resolved. The correction landed at commit `ff1827b4`, resulting plan blob `6cda14629bd3e26be3810443e260d466555967d7` (+31 / −13 against `8f66a2ac…`). Nothing else in the plan changed, and no implementation target was touched.

**Finding 1 — before/after, both sites.**

*§ 3.3a check (b) — before:* "**(b) structural deferral proof, one per surface.** The replacement bullet must match `grep -q "core § 7"`; the replacement introductory sentence must likewise name core § 7 as the place the boundary is stated. This is the proof each surface defers to the reconciled boundary rather than standing alone…"

*§ 3.3a check (b) — after:* the heading now reads "**(b) structural deferral proof, one per surface — necessary, and not sufficient on its own.**" The grep requirement is unchanged, followed by: "That grep proves only that the citation is **present**: a replacement can cite core § 7 and still add a freestanding categorical trigger beside the citation ("Decide anything irreversible — see core § 7 for the classes"), which passes the grep while reintroducing the defect this tracer exists to remove. **The grep is therefore paired with a judgment the exact-candidate risk-aware review must make and record, separately for each surface:** that the line-502 introduction, and the line-508 bullet, each (i) cites the canonical core § 7 boundary as the place the reserved classes are stated, and (ii) states **no independent consequence-based operator trigger of its own** — no rule keyed to how consequential, dangerous, expensive or hard to reverse a decision is, under any wording. A surface that fails either half fails (b) even where the grep matches… This does not relax (c): the no-class-list-copy requirement stands unchanged, and neither replacement may enumerate the classes it points at."

*T3a Verification (b) — before:* "…structural proof neither stands alone; a differently-worded but still freestanding categorical rule passes (a) and fails (b)".

*T3a Verification (b) — after:* "…which is **necessary but not sufficient**, because a replacement can carry the citation and a freestanding categorical trigger at once and still pass the grep; the exact-candidate risk-aware review must therefore affirm and record, **separately for the line-502 introduction and the line-508 bullet**, that each cites the canonical core § 7 boundary and states no independent consequence-based operator trigger of its own, under any wording; a differently-worded but still freestanding categorical rule passes (a) and fails (b)".

**Finding 2 — before/after, both sites.**

*Internal-consistency, plan line 1487 — before:* "This amendment schedules no *additional* skill edit: it corrects the boundary of the one T3a already owned, and it authorizes no edit at all until its own two gates pass."

*— after:* "**This amendment adds exactly one operator-authorized surface — skill line 502 — inside the file and the section T3a already owned.** It adds no new file, no new tracer and no third surface, it schedules no separate skill edit for that surface (line 502 and line 508 are corrected as one change under the one tracer), and it authorizes no edit at all until its own two gates pass."

*Counts paragraph, plan line 1512 — before:* "This amendment adds no new implementation surface: line 502 sits in the same file and the same section T3a already owned."

*— after:* "**This amendment adds exactly one operator-authorized surface — line 502 — taking T3a from one surface to two.** That surface sits inside the file and the section T3a already owned, so the amendment adds no new file, no new tracer and no third surface; the count moved from one to two and no further."

Evidence:
- **Are both findings resolved? Yes, and the checks can fail.** Finding 1: `grep -n 'not sufficient'` returns exactly two lines, 809 (§ 3.3a) and 1227 (T3a) — one per site, and the phrase appeared nowhere in the plan before this correction. Finding 2: `grep -c` for each superseded string now returns **0** — `schedules no *additional* skill edit` → 0, `This amendment adds no new implementation` → 0 — and a newline-tolerant scan for `adds exactly one operator-authorized surface` returns exactly the two replacements, one at each site. Each check matched the defect before the correction and does not match after, so a correction that missed a site would still show.
- **The no-class-list-copy requirement is preserved.** § 3.3a check (c) and T3a Verification (c) are byte-unchanged — neither appears in the diff — and § 3.3a's new (b) text explicitly states it does not relax (c).
- **Did the correction break anything? No.** The diff against `8f66a2ac…` is **four** zero-context hunks and nothing else: `-809,5 +809,14` (§ 3.3a (b)), `-1218,2 +1227,7` (T3a (b)), `-1487,2 +1501,4` and `-1512,4 +1528,6` (the two finding-2 statements). Two hunks per finding, no hunk outside them.
- **Everything outside the corrected clauses is byte-unchanged, proved fail-capably.** `diff -u` between `git show HEAD~1:<plan>` and the corrected file yields **4** hunks; the same corrected file with one stray control edit in an untouched section (`### T8 — Autonomy scenario contracts` → `### T8 — STRAY CONTROL EDIT`) yields **5**. The check detects an out-of-region change, so 4 is a measurement rather than a tautology.
- **No structural change.** Heading count is **35 before and 35 after**, and `diff` of the two heading lists is empty — no tracer, section or sub-heading was added, renamed, renumbered or removed by this correction.
- **Every implementation target is unchanged.** Working-tree blob equals `HEAD:` blob for all seven: skill `965583db…`, core `fb0ba8b6…`, Claude command `61ac65cf…`, `docs/autonomy-rules.md` `ed42ba9d…`, `session-plan.md` `b83205a6…`, `logs/scripts/work-loop-v2-slice-1.test.sh` `02286299…`, proposal `e2a50c5e…`. The Unit 24 candidate remains unapplied.
- **No regression check is claimed.** This correction changes prose in one plan and no executable or instruction target, so the slice-1 suite could not distinguish success from failure here. Its measured baseline — 307 passing, one pre-existing `ridx` local-installation failure — is unchanged and is quoted in the plan only as the number T3a's own future check (e) binds to.
- **Accepted implementation-state currency correction preserved.** Its two records — the Status block note and the § Plan-readiness *Implementation state* paragraph — are outside all four hunks and byte-unchanged.

Newly noticed during this correction, recorded as a deferral and **not** implemented: § Repository Delta risky assumption 5 ends "No further skill surface is added, and no new tracer is created." Read in place, immediately after the sentence fixing T3a's scope at two named surfaces, it means "none beyond these two" and is true, so it is not a third finding. It would nonetheless read more plainly as "no surface beyond these two is added". Left unchanged because the correction scope is frozen at findings 1 and 2.

## Blocker
None. The two frozen findings are closed. The amended plan remains a draft and cannot receive content-bound operator approval until Codex's closure check on those findings passes.

## Next action
Codex: run the bounded closure check on the two frozen findings only — are findings 1 and 2 resolved, and did the correction break anything — against plan blob `6cda14629bd3e26be3810443e260d466555967d7` at commit `ff1827b4`. Anything newly noticed is a deferral, not a second correction round. No skill edit is authorized and the Unit 24 candidate stays unapplied.
