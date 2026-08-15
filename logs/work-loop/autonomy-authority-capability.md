---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 22 — apply the accepted T2 candidate exactly to the canonical executable core and prove the resulting authority contract.

Named reason for the loop: T2 changes the canonical authority contract, must preserve an exact reviewed candidate across the implementation seam, and requires independent assessment before downstream tracers may begin.

## Brief
Unit 21 passed its bounded closure check: all three frozen findings are resolved and the correction broke nothing. The explanatory second sentences in the capability and control-system bullets are accepted because they make the approved non-waivability and separate operator route explicit; their minor style difference is not a reason to alter the reviewed candidate. T2 may now land exactly as reviewed and corrected, while T3 and every later tracer remain outside this unit.

**Governing authority:** the operator-approved proposal at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; the re-frozen implementation plan at blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`, especially § 3.2 and T2; and the complete corrected candidate plus closure evidence recorded in this state file at commit `0ebf148dd479ea1e19ffe63c194cb93fc1bfd81d`. The candidate is the exact implementation contract for this unit; do not redraft or improve it.

Required outcome: reconstruct the corrected candidate from commit `0ebf148d…`, verify it is the complete four-hunk one-file replacement diff against core blob `82f119cd63c379b24f0bef8aab029ae04c165203`, apply it byte-for-byte to `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`, run the bounded T2 evidence and repository regression suites, and commit the core plus this state-file handback.

Scope: the executable-core file and this state file only. Excluded: the plan, proposal, Work Loop skill, Claude command, autonomy rules, session plan, consumers, carrier, dispatcher, tests, research report, and all downstream tracers. Preserve the unrelated existing modification to `logs/friction-log.md`; do not stage or commit it.

Claims to check before editing:

1. The live core and `HEAD` core are both blob `82f119cd63c379b24f0bef8aab029ae04c165203`; the plan is blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`.
2. Commit `0ebf148d…` contains the complete corrected candidate under `### The corrected candidate diff — NOT APPLIED`, with four hunks and one target file, and its closure verdict resolves all three frozen findings without breakage.
3. Before application, the clause-presence check fails, all eight normalized logical strings match, the core has exactly headings 1–7, and T1/T1a's fixed text matches the candidate baseline.

Required evidence:

- Prove the applied core is byte-identical to the reconstructed corrected candidate; report the resulting core blob and implementation commit.
- Show the implementation diff is exactly the candidate's four hunks and touches no other target.
- Show the approved § 1 blockquote is byte-identical, 588 bytes including its line terminator, occurs once under appended `## 8.`, and `pre-authorized capabilities` changes from absent before to present after.
- Run the eight normalized-string matrix: all eight match before; after, the seven removed strings are absent and the retained disclosure string remains.
- Show exactly eight numbered headings, with §§ 1–7 titles/order unchanged; show T1's authority paragraph and T1a's status text unchanged.
- Reconfirm by reviewer-readable mapping that every proposal § 6 operator-reserved and mandatory-stop/handback class remains represented, including the corrected routes: missing grant/envelope expansion to operator; authorized-but-unenforceable capability to mandatory Codex handback; control-system bypass/weakening/self-expansion to mandatory Codex handback; only operator-owned settled decisions transfer; `inventing operator intent` remains separate.
- Run the full `work-loop-v2-core-resolver.test.sh` and `work-loop-v2-slice-1.test.sh` suites against the applied core and report their pass/fail totals. These are regression evidence, not substitutes for the semantic checks above.

Completion condition: the core matches the accepted candidate exactly; every required check passes; commit only the core and this state-file handback; record the commit, resulting core blob, exact diff/evidence summary and any deferral in `## Latest result`; set `turn: codex`; stop without beginning T3.

Stop conditions: stop and hand back without improvising if a baseline identity differs, the recorded candidate cannot be reconstructed exactly, application would differ from it, a required check fails, any proposal § 6 protection is missing, another target becomes necessary, or the plan/proposal/candidate conflict.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — `git hash-object` on `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` and `git rev-parse HEAD:<same path>` both returned `82f119cd63c379b24f0bef8aab029ae04c165203`, so live and `HEAD` agree. Searched the index and the working tree for blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`; it resolves to `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, identical in index and worktree.
- Claim (2): HOLDS — `git show 0ebf148d:logs/work-loop/autonomy-authority-capability.md` carries `### The corrected candidate diff — NOT APPLIED` at line 49. The fenced diff extracted from it is 107 lines with exactly four hunk headers (`-23,7 +23,9`, `-56,8 +58,9`, `-446,8 +449,10`, `-457,21 +462,61`) and one target file in both the `---` and `+++` headers. Hunk 4 ends at old line 477, the pre-change core's exact length, so the diff spans to end of file. Its `### Closure questions` answer both closure questions: all three frozen findings resolved, nothing broken.
- Claim (3): HOLDS — against the pre-change core: `grep -c 'pre-authorized capabilities'` returned **0** (clause-presence check fails, as required); all **eight** normalized logical strings matched (flattened with `tr '\n' ' ' | tr -s ' '`, substring test, so no regex could pass on a partial match); `grep -n '^## [0-9]'` returned exactly **seven** headings, 1–7; and `diff` of lines 1–12 between the pre-change core and the reconstructed candidate is **empty**, so T1a's status line (line 3) and T1's `**Authority.**` paragraph (lines 9–12) are byte-identical to the candidate baseline.

Result: the corrected candidate was reconstructed from commit `0ebf148d…` and applied byte-for-byte to the canonical executable core. The core is now blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136` (522 lines, was 477). Every required semantic check passes. The resolver suite is green; the slice-1 suite returns **307 passed, 1 failed**, and that one failure is proved below to be pre-existing local-installation drift that never reads the core. No file outside the core and this state file was changed.

**(1) Byte-identity, proved through two independent tools.** The diff was extracted programmatically from the commit, never retyped. An independent reconstruction was built with `patch -p1` in the session scratchpad from the pre-change core; the repository application used `git apply`. `git apply --check` passed first, and `git apply` fuzzes nothing — every context line had to match exactly. `diff` and `cmp` between the scratchpad reconstruction and the applied repository core are both **empty**: byte-identical. Both hash to `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`. Line count 522 matches Unit 21's stated 522.

**(2) The implementation diff is exactly the candidate's four hunks, one target.** `git diff` on the core, with only `diff --git`/`index` lines removed, differs from the recorded candidate diff **only** in git's decorative text after each `@@ … @@`; the four hunk ranges and every content line are identical. Stripping that decoration, `diff` between the two is **empty**. `git status --porcelain` lists three files: the core, this state file, and `logs/friction-log.md` — the last is the unrelated pre-existing hook-appended modification the brief requires preserved, and it is not staged or committed here. No plan, proposal, skill, command, consumer, carrier, dispatcher, test or research file appears.

**(3) The § 1 blockquote.** Taken from the approved proposal blob, not retyped: `git cat-file blob 39c67196… | sed -n '15p'` diffed against the clause line as it now sits in the core is **empty** — byte-identical. **588 bytes including the line terminator**, matching § 3.2's stated size on both sides. It occurs **exactly once** (`grep -c '^> \*\*Within the approved solution envelope'` → 1), at core line 519, directly under the appended `## 8. The governing autonomy rule` at line 517. `grep -c 'pre-authorized capabilities'`: **0 before, 1 after**.

**(4) The eight normalized logical strings.** Both files flattened identically; substring test, not regex.

| # | String | Kind | BEFORE | AFTER |
|---|---|---|---|---|
| d-i | `and any decision that is hard to reverse` | removed | MATCH | **no match** |
| d-ii | `Genuinely consequential work stops and goes to the operator instead` | removed | MATCH | **no match** |
| d-iii | `The change would be hard to reverse.` | removed | MATCH | **no match** |
| d-iv | `Anything else that is genuinely consequential.` | removed | MATCH | **no match** |
| d-v | `is the answer for consequential situations` | removed | MATCH | **no match** |
| g-1 | `a change to scope goes to the operator` | removed | MATCH | **no match** |
| g-2 | `Scope and success criteria do not change quietly` | **retained** | MATCH | **MATCH** |
| h | `Proceeding would need a settled decision to be reopened.` | removed | MATCH | **no match** |

Eight of eight match before — which is what proves the run reads real text and can fail. After: the seven removed strings are absent, the retained disclosure string remains. Seven plus one, the exact total § 3.2 *Matching discipline* requires.

**(5) Headings and fixed points.** `grep -n '^## [0-9]'` returns exactly **eight**, 1–8 in order (16, 42, 67, 254, 419, 441, 461, 517). `diff` between the pre-change core's seven heading lines and the applied core's first seven is **empty** — §§ 1–7 titles and order byte-identical, nothing renumbered or retitled. `diff` of lines 1–12 before against after is **empty**, so T1a's reconciled status line and T1's `**Authority.**` paragraph are unchanged.

**(6) Proposal § 6 coverage — reviewer-readable mapping against the applied core.** All **nine** operator-reserved classes map to operator bullets in list order: intended outcome or priority → L488; material scope expansion or exclusion removal → L489; product or business behaviour not determined by existing authority → L490; operating model / architecture / cost-risk / governance → L491–492; undelegated material residual risk → L493–495; capability-envelope expansion → L496; production deployment / communication / credential use / destructive shared-state action absent separate delegation → L498–499; tied or conflicting operator intentions → L500–501; material change to the policy governing agent authority → L502.

All **seven** mandatory stop/handback classes are represented: unsupported load-bearing premise → L473–474 (Codex); materially invalid plan beyond the envelope → L477 (Codex); required verification unproducible → L476 (Codex); needed capability **not granted** → L496 (operator) and **cannot be enforced safely** → L478–480 (Codex, stated non-waivable — "the operator cannot waive it: what is missing is containment, not permission"); inventing operator intent → L508 (operator, its own bullet); control-system bypass/weakening/self-expansion → L481–483 (Codex, operator reachable only through the separate authority-policy class at L502); materially tied governing sources → L500–501 (operator). Proposal § 6's single "not granted **or** cannot be enforced safely" line is the one class deliberately split across the two lists — that split **is** finding 1's correction, and both halves are present. Nothing from the pre-change core was dropped: the out-of-scope bullet (L475), the unproducible-evidence bullet (L476) and the stale-state-file bullet (L509–510) survive; the risk-acceptance and settled-decision triggers survive reworded; only the two categorical bullets are removed, which is T2's purpose.

**(6a) The mapping is fail-capable, not asserted.** Each § 7 sub-block was flattened *separately*, so a clause existing somewhere in the file cannot pass a check about **where it is routed**. Every positive check returns no on the pre-change core and yes on the applied core; both negatives stay no on both.

| Check | BEFORE | AFTER | Required |
|---|---|---|---|
| F1a — Codex block carries the unenforceable-capability clause | no | **yes** | yes |
| F1b — operator block carries the enforcement half | no | **no** | no |
| F1c — operator block carries the not-granted half | no | **yes** | yes |
| F2a — Codex block carries `bypass, weaken, or self-expand the control system` | no | **yes** | yes |
| F2b — operator block carries the bypass clause | no | **no** | no |
| F3a — `Continuing would require inventing operator intent.` is its own whole bullet | no | **yes** | yes |
| F3b — operator block qualifies the settled decision as **operator-owned** | no | **yes** | yes |
| F3c — operator block exempts a delegated implementation or technical decision | no | **yes** | yes |

**(7) Regression suites against the applied core.** `work-loop-v2-core-resolver.test.sh`: **4 passed, 0 failed**. `work-loop-v2-slice-1.test.sh`: **307 passed, 1 failed**.

The single failure is `ridx  the marked set matches the live installations, not just the brief` (test script L1128–1129). It is **not a T2 regression**, and the proof is by input independence: that assertion's only two inputs are (a) `.agents/skills/work-loop-v2/references/routing-index.md`, which `git status --porcelain` shows **unmodified at HEAD** by this unit, and (b) the operator's home directories `~/.claude/skills/` and `~/.codex/skills/`, which are outside the repository entirely. The whole `ridx` block (L1119–1134) contains **no reference** to `CORE_F` or the core path, so editing the core cannot change its outcome. The actual cause is local-installation drift: the router index marks **12** skills `[Claude-side only]`, but `diagnosing-bugs` is now installed under **both** `~/.claude/skills/diagnosing-bugs` and `~/.codex/skills/diagnosing-bugs`, so the live set is **11**. The sibling assertion that compares the doc against the brief's constant of 12 still passes — doc and brief agree; the machine has moved. Every one of the 307 passing assertions includes all core-reading ones.

**Deferrals — recorded, not implemented.**

- **New, from this unit:** the slice-1 `ridx` live-installation failure above. Fixing it means either unmarking `diagnosing-bugs` in the router index or removing it from `~/.codex/skills/` — the first is a repository file this unit's scope excludes, the second is the operator's local installation. Neither is T2 work, and neither was touched.
- **Carried forward from Unit 21, unchanged and non-blocking:** the two explanatory second sentences in the § 7 capability and control-system bullets, which Codex accepted at the Unit 21 closure check and which landed verbatim; the worktree proposal still one status-line hunk off the approved blob (line 15 identical, so the clause binds to approved content either way); the future normalized-count harness note; the proportionality/continuity-plan follow-on; the stale row in the unapproved resource-capability development plan; the plan's § 14 item-6 wording inconsistency. None blocks T2 or its assessment.

## Blocker
None.

## Next action
Codex: assess Unit 22. The core is applied at blob `fb0ba8b6bddbf27dac971ec1c2458c6e5be32136`, byte-identical to the accepted candidate, and every T2 semantic check passes. Two things need a ruling: whether the pre-existing slice-1 `ridx` live-installation failure is accepted as outside T2 (evidence for its independence is in item 7), and whether T2 is complete enough to open T3. T3 was not begun and the candidate was not altered.
