---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow, with unnecessary ceremony removed. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state.

## Lane and unit
Standard. Implementation mode. Unit 29 — apply the exact risk-reviewed T4 citation candidate to `docs/autonomy-rules.md`.

Named reason for the loop: T4 changes a cross-cutting authority surface, and the exact reviewed citation must land without narrowing or rewording either protected trigger.

## Brief
The exact T4 candidate recorded in this state file at commit `0b62ab4c` received a fresh independent risk-aware review: **PASS / CORRECT**, no material findings, may be applied byte-for-byte to baseline blob `ed42ba9d063cd272cb11b9fcad0821df9554d6ec`. The review affirmed all seven risk dimensions, citation path and placement, consumer safety, clause preservation, and ordered branch dependency. This unit applies that sentence and nothing else.

**Exact implementation contract:** reconstruct the fenced **NOT APPLIED** T4 candidate from commit `0b62ab4c`. It adds one 210-byte sentence inside trigger 9 after `…left unresolved.` and before `No command fires automatically…`. Do not redraft, shorten, relocate, or change the citation path.

Scope: `docs/autonomy-rules.md` and this state-file handback only. Excluded: plan, core, skill, command, proposal, session plan, tests, routing index, research report, and T5–T9. Preserve unrelated `logs/friction-log.md` changes and do not commit them.

Claims to check before editing:

1. The live and `HEAD` autonomy-rules file are blob `ed42ba9d063cd272cb11b9fcad0821df9554d6ec`; trigger 9 has no core § 8 citation.
2. Commit `0b62ab4c` contains the complete exact one-sentence candidate and verified premise/risk packet; fresh review verdict is PASS with no findings.
3. Core § 8 remains canonical at core blob `fb0ba8b6…`, and the candidate citation path resolves to it in this workspace convention.

Required evidence:

- Prove the applied file is byte-identical to an independent reconstruction of the exact candidate; show the diff changes exactly one trigger-9 line; report resulting file blob and implementation commit.
- Show `core § 8` is absent before and present after; confirm none of core § 8's governing-rule prose was copied.
- Prove trigger 8 is byte-identical before/after. Strip the inserted sentence exactly once from the applied trigger-9 line and prove the remainder is byte-identical to the original, so every prior clause and order is preserved.
- Confirm no other line or target changed.
- Run `work-loop-v2-slice-1.test.sh` as regression evidence and compare with the known 307 passed / 1 failed local baseline; no new failure is allowed. State plainly if the suite does not bind to this citation.

Completion condition: `docs/autonomy-rules.md` matches the reviewed candidate exactly, all evidence passes without new regression, only that file plus this state handback are committed, `turn: codex`, and Claude stops without beginning T5.

Stop conditions: stop if any baseline differs, the candidate cannot be reconstructed/applied exactly, any trigger clause changes beyond the inserted sentence, another file is needed, or the regression suite adds a failure.

## Latest result

Inspected (2026-08-15):
- Claim (1): HOLDS — `git hash-object docs/autonomy-rules.md` and `git rev-parse HEAD:docs/autonomy-rules.md` both return `ed42ba9d063cd272cb11b9fcad0821df9554d6ec`, so live and `HEAD` agree on the baseline. Searched that file for `core § 8|core §8|§ 8` — no match, so trigger 9 carried no core § 8 citation before this unit.
- Claim (2): PARTLY REPOSITORY-CHECKABLE, and what is checkable HOLDS — `git show 0b62ab4c:logs/work-loop/autonomy-authority-capability.md` contains the complete fenced **NOT APPLIED** T4 candidate, its premise packet and its seven-dimension risk packet; the candidate's single added trigger-9 line was extracted from it programmatically (exactly 1 line matching `^\+9\. \*\*Structural change classes\*\*`). The other half — "fresh review verdict is PASS with no findings" — is Codex's own recorded assessment carried in this brief; it is not a repository artifact and no repository surface can confirm or contradict it. Recorded as an assertion relied on, not as an inspected fact. Nothing found contradicts it.
- Claim (3): HOLDS, with the branch condition Codex already ruled on — `git hash-object plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returns `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`; searched that file for `^## 8\.` → exactly 1 match, line 517, `## 8. The governing autonomy rule`. The citation path resolves under the workspace convention: `<workspace>/ai-resources/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` exists. That canonical checkout is on `main` at blob `45e82bca…`, where `grep -c '^## 8\.'` returns 0 — so the citation's target section arrives there only when this branch merges. This is JC-4 from Unit 28, which the brief records the risk-aware review as having affirmed under "ordered branch dependency". Reported, not re-litigated.

Result: the exact T4 citation candidate is applied. `docs/autonomy-rules.md` moved from blob `ed42ba9d063cd272cb11b9fcad0821df9554d6ec` to blob `cd74f214b8a0f3606388788bc01ab57b072f9303` — the same result blob the Unit 28 packet recorded for the candidate. One sentence, 210 bytes, now sits inside trigger 9 after "…left unresolved." and before "No command fires automatically…". Nothing else in the repository changed. T5 was not begun.

Evidence:

- **Byte-identical to an independent reconstruction.** The applied line was rebuilt from the *original* line 19 plus the sentence — a single anchored insertion at `left unresolved. `, with the anchor asserted unique — not by copying the candidate line out of `0b62ab4c`. The rebuilt line was then compared for string equality against the candidate line extracted from that commit: equal. Because the two were derived independently, agreement is evidence rather than a tautology. Resulting file blob `cd74f214b8a0f3606388788bc01ab57b072f9303` matches the packet's recorded value exactly; a one-character divergence anywhere would change the hash.
- **Exactly one line changed.** `git diff -U0 docs/autonomy-rules.md | grep -c '^[+-][^+-]'` → 2 (one `-`, one `+`). Line count 51 before and 51 after.
- **Citation absent before, present after.** `git show HEAD:docs/autonomy-rules.md | grep -c 'core § 8'` → 0 (exit 1, no match). `grep -c 'core § 8' docs/autonomy-rules.md` → 1. The check keys on the exact string the change introduces, so an unapplied or reworded citation fails it.
- **No core § 8 prose copied.** Searched the applied file with `grep -qF` for all eight phrases from core § 8 — "Within the approved solution envelope", "resolve what evidence can resolve", "exercise professional technical judgment", "pre-authorized capabilities", "Consequence increases containment", "does not by itself transfer the decision", "Escalate only when continuing requires", "bypass the control system" — all eight absent. The file points at the rule; it does not restate it.
- **Trigger 8 byte-identical.** `sed -n '18p' docs/autonomy-rules.md | md5 -q` → `f00a0086858fc295d7454082b71d3669` both before and after, unchanged from the value recorded in Unit 28.
- **Trigger 9 clause preservation, by strip-back.** The inserted sentence occurs exactly once in the applied line (asserted). Removing it once and comparing the remainder to the original line with Python whole-string equality returns `True`; character length 880 → 1090, delta 210, exactly the inserted sentence plus its separating space. This is fail-capable because equality is over the entire line: deleting a clause, narrowing one, reordering two, or altering a single character anywhere else in trigger 9 makes the remainder differ and the assertion raises before any write. The script asserts before writing, so a failure would leave the file untouched.
- **Nothing else moved.** `git status --porcelain` shows `docs/autonomy-rules.md`, this state file, and the pre-existing untouched `logs/friction-log.md`. No plan, core, skill, command, proposal, session-plan, test, routing-index or research-report file changed.
- **Regression: no new failure.** `bash logs/scripts/work-loop-v2-slice-1.test.sh` → **307 passed / 1 failed**, identical to the known local baseline. The single failure is the pre-existing `FAIL ridx the marked set matches the live installations, not just the brief`, unrelated to this change. **Stated plainly: this suite does not bind to the T4 citation** — `grep -c autonomy-rules logs/scripts/work-loop-v2-slice-1.test.sh` → 0, so it is breakage evidence only, not evidence that T4 landed. The strip-back, blob and citation checks above are what carry that.

Deferral carried forward, still not done: `logs/friction-log.md` holds uncommitted insertions that predate Unit 28 and are unrelated to T4. This unit preserved them and did not stage, edit or commit that file, exactly as the brief required. Deciding their disposition remains outside this unit's scope.

## Blocker
None.

## Next action
Codex: assess Unit 29. T4 is applied — `docs/autonomy-rules.md` is now blob `cd74f214b8a0f3606388788bc01ab57b072f9303`, one trigger-9 line changed, trigger 8 and every other trigger-9 clause proven byte-identical, no new regression. Note two things when deciding: claim (2)'s review-verdict half was Codex's own assertion and could not be checked against the repository, and the JC-4 branch condition still stands — the cited core § 8 exists on this branch only, not yet in the canonical `ai-resources` checkout on `main`. Decide close, continue to T5, or correct once. T5 was not begun.
