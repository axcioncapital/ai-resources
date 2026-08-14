---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Discovery mode. Unit 13 — verify T1a's premises and prepare the isolated risk-aware review payload without editing the executable core.

Named reason for the loop: the canonical core is shared authority infrastructure, so the frozen plan requires a risk-aware independent review before its status reconciliation is implemented.

## Brief
Unit 12 is accepted: the corrected implementation plan is re-frozen and T1a is now the required next tracer. Before implementation, this unit establishes the repository facts and exact proposed three-surface wording that the mandatory risk-aware Codex review must judge; it changes no target file.

Governing authority:

- Re-frozen implementation plan at status-record commit `e45a581f89291ff45ec263d35d9b38e65117b3e2`, plan blob `7b254fcbaeda669ecb8a300e72d9bb5203619505`; T1a is specified by § 3.1a and the Execution Plan's T1a entry.
- T1 implementation commit `5fef08fff11a1009b30d925f49d68844fc4e2f03` and approval-record commit `9a0fdb41fa27ae7ac813504a5145a59d465b93b7`.
- `docs/qc-independence.md` § Risk-aware review: verify the review premises before dispatch and provide the seven dimensions—usage cost, permissions surface, blast radius, reversibility, hidden coupling, principle alignment, and problem reality.

Required outcome: return one self-contained review payload containing (1) verified primitive evidence for every T1a premise, cited line, count, and script; (2) the exact proposed replacement wording for the core status header and both dated amendment notes; (3) a zero-context predicted diff showing only those three allowed surfaces; (4) an explicit consumer inventory for anything that parses, quotes, or semantically relies on the current header or note wording; and (5) factual inputs for all seven risk dimensions. Do not perform the review verdict and do not implement the patch—the fresh Codex review follows this handback.

Claims to verify against the repository:

1. The current core is still the T1-approved baseline, and T1's content-bound approval is identifiable; report the current core blob and the evidence tying it to T1/its approval record.
2. The only stale live-status text targeted by T1a is the line-3 status plus the two dated notes currently identified by their text and section, not by remembered line numbers alone. Quote the exact current text and stable enclosing headings.
3. T1's authority paragraph remains exactly the approved text and is outside the proposed patch.
4. No governing-autonomy clause has landed: on the whole core, `! grep -q "pre-authorized capabilities"` must succeed.
5. The core-resolver suite named by T1a exists and passes in the current baseline; run the exact cited script and report its command, exit code, and summary.
6. Search tracked live sources for exact or semantic dependencies on `draft for operator approval` and both notes' present-tense header claim. Inventory any consumer that parses, quotes, tests, or makes an authority decision from them; distinguish live consumers from historical evidence. Bound and report the searched paths and patterns so a zero-result claim can fail.

The proposed wording must state only that the whole core is canonical under T1's approval, preserve both notes' original dates and historical truth, and say their limitation was superseded when T1 made the core canonical. It must not add or paraphrase the proposal §1 autonomy rule, change the T1 authority paragraph, revise any other operator gate, or touch headings/section numbering.

Required risk payload, dimension by dimension: identify the concrete exposure, evidence, and available safeguard for usage cost; permissions surface; blast radius on other components; reversibility; hidden coupling; principle alignment; and problem reality. Also state any unresolved premise, consumer, or wording choice that would require revision or an operator decision rather than reviewer inference.

Required fail-capable evidence: preserve the baseline outputs for the status-string match, the two note matches, the absence of `pre-authorized capabilities`, and the resolver test; provide a predicted diff whose path and hunks would expose any fourth edit; and give exclusion proofs for the T1 authority paragraph and all content outside the three allowed surfaces. A proposed check that could pass after an extra edit is insufficient.

Scope: read-only investigation plus this state-file handback. No edit to the executable core, plan, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or research report. Temporary material outside tracked repository state is permitted only if needed to render the predicted diff and must not become a project artifact. Codex's framing holds T2 and all later tracers outside this unit because T1a gates them.

Completion condition: return the complete premise-verified review payload, set `turn: codex`, commit only this state-file handback, and stop. This is a Discovery unit: do not implement T1a.

Stop conditions: hand back a false premise if the approved baseline, targeted surfaces, consumer inventory, or cited test differs materially from the frozen plan. Stop for the operator only if repository evidence reveals a real authority/scope/risk decision; otherwise expose uncertainty for the reviewer rather than improvising.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — `git hash-object` on the worktree core and `git rev-parse HEAD:plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` both return blob `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`; `git rev-parse 5fef08ff…:<core>` and `git rev-parse 9a0fdb41…:<core>` return the same blob; `git log --oneline 5fef08ff..HEAD -- <core>` returns no commits. `git show 9a0fdb41…` contains the operator's content-bound approval paragraph naming implementation commit `5fef08fff11a1009b30d925f49d68844fc4e2f03` and blob `30c62c41…`. The current core is byte-identical to the T1-approved baseline and the approval is identifiable by both commit and blob.
- Claim (2): HOLDS — `grep -n "draft for operator approval" <core>` returns exactly three lines: 3, 166, 286. `grep -n "deliberately unchanged" <core>` returns exactly 166 and 286. `grep -n "Status:" <core>` returns only line 3. The three surfaces, quoted and located by stable heading rather than by line number alone, are in payload section A. No fourth stale live-status surface exists in the core.
- Claim (3): HOLDS — `sed -n '9,12p' <core>` returns the four-line authority paragraph byte-identical to the text added by `git show 5fef08ff… -- <core>`; the predicted diff's exclusion proof (b-i) confirms lines 9–12 are unchanged by the proposed patch.
- Claim (4): HOLDS — `! grep -q "pre-authorized capabilities" <core>` succeeds; `grep -c` returns 0. No governing-autonomy clause has landed.
- Claim (5): HOLDS — `bash logs/scripts/work-loop-v2-core-resolver.test.sh` → exit 0, `4 passed, 0 failed` (checks 1–4: linked-worktree resolution, canonical-checkout resolution, unrelated-repo rejection, deployed resolver blocks byte-identical). The script exists at that path and is executable.
- Claim (6): HOLDS — searched all 1810 tracked files with `git grep -F` for `draft for operator approval` (12 files), `deliberately unchanged` (5), `Do not read this amendment` (2), `header still reads` (7), `approved on its own` (5); searched `logs/scripts`, `.claude`, `.agents` for `work-loop-v2-executable-core`, `Status:** draft` and `Status.*draft for operator`. Full inventory with the live/historical split is in payload section C. No runtime artifact and no test parses, quotes or asserts on the header (the `.claude`/`.agents`/`logs/scripts` pattern search returned zero, and the four files that name the core reference it only as a path constant or, in `work-loop-v2-slice-1.test.sh:266–274`, for the § 3 hand-off token).

Result: Unit 13's read-only verification is complete. Every T1a premise holds against the current repository; nothing was implemented and no target file was edited. The self-contained risk-review payload for the mandatory risk-aware Codex review follows.

Evidence: the six checks above, each naming its command and its returned value; the predicted diff in section B rendered from a scratchpad copy (never a tracked file) and put through the frozen plan's own exclusion proofs (a), (b-i), (b-ii), (c) and (d), each reported with the value that would have exposed a fourth edit. `git status --porcelain` shows only this state file plus the pre-existing, unrelated `logs/friction-log.md` modification, which predates this unit and is untouched by it.

### A. Proposed wording — the three allowed surfaces, exact

**A1 — status header (core line 3, under the document title `# The Work Loop — executable core`).**

Current: `**Version:** v0.1 (MVP). **Status:** draft for operator approval.`

Proposed: ``**Version:** v0.1 (MVP). **Status:** canonical — content-bound operator approval at commit `5fef08ff` (2026-08-14).``

115 characters. The file's longest existing line is 317, so the width is in family. No other line in the core depends on line 3's text.

**A2 — first dated note (core lines 165–167; enclosing heading `### The "good enough, proceed" judgment` at line 144, inside `## 3. The unit cycle` at line 64).**

Current:

```
> *Added 2026-08-07. This clause was approved on its own; the document's header still reads
> **draft for operator approval** and that is deliberately unchanged. Do not read this amendment as
> approval of the rest of the file.*
```

Proposed:

```
> *Added 2026-08-07. This clause was approved on its own, and the rest of the file was not
> approved with it at that time. That limitation was superseded on 2026-08-14, when the
> operator's content-bound approval of commit `5fef08ff` made the whole file canonical.*
```

**A3 — second dated note (core lines 285–287; enclosing heading `### An approved courier may carry the turn` at line 262, inside `## 4. The task-state file` at line 251).** Identical to A2 except the preserved original date `2026-08-06`.

Both notes stay three lines, so the core's line count and every downstream line number are unchanged (477 lines before and after). Both keep their original date and both keep the historical claim that the clause was approved on its own and did not then approve the rest of the file — corrected from a present-tense assertion about the header to a dated statement that the limitation applied then and was superseded by T1. Nothing here adds or paraphrases proposal §1, touches the T1 authority paragraph, revises any other operator gate, or changes a heading or section number.

A third dated note exists at core line 411 (`Added 2026-08-01`, the "Who commits: Claude" note). It makes no draft-status claim, is not a T1a surface, and exclusion proof (b-ii) confirms it is untouched.

### B. Predicted diff — zero context beyond the three surfaces

```diff
--- plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
+++ plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
@@ -1,6 +1,6 @@
 # The Work Loop — executable core
 
-**Version:** v0.1 (MVP). **Status:** draft for operator approval.
+**Version:** v0.1 (MVP). **Status:** canonical — content-bound operator approval at commit `5fef08ff` (2026-08-14).
 
 **What this is.** The one document that says how the Work Loop runs. The Claude Code command and
 the Codex resource **link to this file** and never restate what is in it. One owner, no drift. The
@@ -162,9 +162,9 @@
 These four are owned here. The Codex skill and the Claude command cite this section; neither restates
 them.
 
-> *Added 2026-08-07. This clause was approved on its own; the document's header still reads
-> **draft for operator approval** and that is deliberately unchanged. Do not read this amendment as
-> approval of the rest of the file.*
+> *Added 2026-08-07. This clause was approved on its own, and the rest of the file was not
+> approved with it at that time. That limitation was superseded on 2026-08-14, when the
+> operator's content-bound approval of commit `5fef08ff` made the whole file canonical.*
 
 ### Continuing — accepting the unit and opening the next
 
@@ -282,9 +282,9 @@
 The operator carrying the turn themselves remains valid and is the default. A courier is an option
 they approve, not a stage the loop acquires.
 
-> *Added 2026-08-06. This clause was approved on its own; the document's header still reads
-> **draft for operator approval** and that is deliberately unchanged. Do not read this amendment as
-> approval of the rest of the file.*
+> *Added 2026-08-06. This clause was approved on its own, and the rest of the file was not
+> approved with it at that time. That limitation was superseded on 2026-08-14, when the
+> operator's content-bound approval of commit `5fef08ff` made the whole file canonical.*
 
 **A request that is refused admission opens no file** (§ 2). Direct Work leaves no state behind.
```

One file, three hunks, three surfaces. The frozen plan's fail-capable checks run against this predicted result:

- (a) `sed -n '3p'` piped to `grep -q "draft for operator approval"` — matches before, does not match after. Both values observed.
- (b-i) `diff <(sed -n '9,12p' before) <(sed -n '9,12p' after)` — identical. T1's authority paragraph is excluded.
- (b-ii) `diff <(sed -e '3d;165,167d;285,287d' before) <(sed -e '3d;165,167d;285,287d' after)` — empty. This is the exclusion proof that would expose a fourth edit anywhere in the file: a hunk outside the three surfaces makes it non-empty. It is not a check that could pass after an extra edit.
- (c) `grep -n "Added 2026-08-0"` on the result returns lines 165 (`2026-08-07`), 285 (`2026-08-06`) and 411 (`2026-08-01`, out of scope). Both original dates preserved; both historical claims preserved, not deleted.
- (d) `! grep -q "pre-authorized capabilities"` on the whole result — succeeds. No governing clause is introduced.
- (e) `work-loop-v2-core-resolver.test.sh` is green on the baseline now (exit 0, 4/4). Its only reference to the core is the path constant `SEMANTIC_REL` at line 31; it asserts nothing about the core's body. On that mechanism the change cannot break it — but this is the one item whose post-change value has not been observed, because running it against the edited file requires the edit, which this unit is forbidden to make. It must be re-run and reported at implementation time.

### C. Consumer inventory — what parses, quotes, tests or decides from the header and the two notes

Bounds: all 1810 tracked files in this checkout (`git grep`, patterns listed under Claim 6). Untracked files, other worktrees and Notion are outside these bounds and were not searched.

**Live consumers that would be left stale by T1a (T1a's scope boundary is the core file only, so it does not fix them):**

1. `plans/work-loop-v2-v0.2/work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md:363–365` and `:894` — status "implementation-ready; not yet executed." Its **Amendment discipline** rule and risk item **R-2** both instruct a future executor to append a dated note saying "the header is deliberately unchanged." After T1a that instruction is false and would reintroduce the exact stale claim T1a removes. This is the sharpest coupling found and the strongest single argument for a follow-on fix.
2. `plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md:121` — an "Authority status" table row asserting the core's header "Reads **draft for operator approval**." The document is explicitly `Status: Draft — not approved and not authorized for implementation`, so it governs nothing today, and the same table already carries an independently stale row ("Proposal v0.4 AUTHORITATIVE within MVP scope", contradicted by T1).
3. `plans/axcion-harness-v0.2/mvp-plan.md:398` and `:521` — names the core's draft-vs-deployed status mismatch as an open item to resolve. T1a satisfies it; the text then describes a closed item as open.

**Semantic authority consumer (rule-level, no quoted text):**

4. `.agents/skills/work-loop-v2/SKILL.md:429, :431` — "an unapproved draft stays a labelled proposal, and only a genuine explicit operator decision governs" and "A draft does not govern." No reference to the core's header, so nothing breaks. But it is the rule under which the current header actively argues against the core's own governing status — this is the concrete cost of leaving T1a undone, not a risk of doing it.

**Historical evidence, correctly left as-is (records of what was true at the time):**

5. `plans/work-loop-v2-v0.2/handoff-automation-investigation-2026-08-05.md:32`; `plans/work-loop-v2-v0.2/t2-governing-autonomy-clause-primary-source-findings-2026-08-14.md:91, :93` (the primary-source finding that specified T1a); `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md:217, :706` (T1a's own Starting evidence, which must keep describing the pre-change state); `logs/session-notes-archive-2026-08.md:2731`; `logs/missions/work-loop-v2-mvp.md:79, :90`; `logs/session-plan-2026-08-02-S6-6d7.md`, `logs/session-plan-2026-08-02-S9-d4a.md`; the four spike run/probe transcripts under `plans/work-loop-v2-v0.2/handoff-automation-spike/runs/`.

**No consumer at all:** no script, hook, test or runtime artifact parses or asserts on the header. Searching `logs/scripts`, `.claude` and `.agents` for `Status:** draft` and `Status.*draft for operator` returned zero matches. The four files naming the core (`SKILL.md:38`, `work-loop-v2.md:26`, `work-loop-v2-core-resolver.test.sh:31`, `work-loop-v2-slice-1.test.sh:266`) use it as a resolver path constant or, in the last case, to test the § 3 hand-off token — none reads line 3.

### D. Risk dimensions — factual inputs for the review

- **Usage cost.** One file, three hunks, six changed lines, no line-count change. Verification is five greps/diffs plus one 4-check script that runs in under a second. Negligible; no subagent, no fan-out.
- **Permissions surface.** No change. No settings file, hook, permission list, allowlist or `.git` configuration is touched. The edit is one tracked markdown file plus this state file.
- **Blast radius.** The core is the shared authority document for the whole Work Loop — both the Codex skill and the Claude command resolve and read it every invocation, so the file's reach is maximal. The reach of *this text* is not: no code path, test or runtime artifact reads line 3 or the two notes (section C, "No consumer at all"). Three prose documents quote the header (C1–C3); one is implementation-ready and would be left carrying a false instruction. Safeguard: fix C1 in a bounded follow-on, or record it as an accepted, named limitation with the reason.
- **Reversibility.** Full. One `git revert` of one commit restores blob `30c62c41…` exactly; the pre-change blob is already pinned in this file and in the T1 approval record. No migration, no external system, no state that survives the revert.
- **Hidden coupling.** One found, and it is not hidden after this search: C1's Amendment-discipline instruction. Two structural couplings checked and cleared — the notes keep three lines each so no line number anywhere shifts, and `work-loop-v2-slice-1.test.sh`'s core assertion targets § 3's hand-off token, not the header. The one unobserved value is (e) post-change, named in section B.
- **Principle alignment.** The change makes the core's stated status match a recorded operator decision; it removes a contradiction rather than creating a rule. It aligns with the core's own § 6 rule 4 (scope and success criteria do not change quietly) and with the skill's authority hierarchy at `SKILL.md:429–431`, under which the current header undercuts the very document the loop treats as its contract. It adds no autonomy policy, which is exactly what keeps T1a separate from T2.
- **Problem reality.** Real and evidenced, not inferred. The core says `Status: draft for operator approval` at line 3 while its own authority paragraph at lines 9–12 says content-bound approval of the identifiable commit is what makes it canonical, and commit `9a0fdb41…` records that approval and states "The core is now canonical." Those are contradictory current-status claims in one blob. The frozen plan gates T2 on resolving it (§ 3.1a, ordering constraints 1 and 1b) so that policy does not enter a self-contradictory canonical document.

### E. Unresolved for the reviewer or the operator

1. **Header wording is a choice, not a derivation.** A1 names commit `5fef08ff` and the date inside the status line. A shorter form (`canonical`, with provenance left to the authority paragraph) is equally faithful to § 3.1a's Outputs. The frozen plan does not specify the wording, so the reviewer picks — this is Codex's framing call, not a repository fact.
2. **Consumer C1 is a real decision, not an inference.** T1a's scope boundary forbids touching it. Whether it becomes a bounded follow-on or a named accepted limitation is Codex's call at the closure check, or the operator's if it is really about accepting risk.
3. **Check (e) has no post-change value yet** (section B). Its mechanism is verified; its result is not. It must be re-run at implementation.
4. Nothing found in this unit reopens a settled decision or reveals a hard-to-reverse consequence, so nothing here is escalated to the operator by Claude.

### F. Deferral noticed during this unit, not done

`plans/work-loop-v2-v0.2/resource-capability-development-plan-v0.1.md:121` carries a second stale authority row — "Proposal v0.4 AUTHORITATIVE within MVP scope" — already contradicted by T1's approved authority paragraph. It is unrelated to T1a's surfaces, sits in a document explicitly marked not approved and not authorized for implementation, and blocks nothing. Recorded, not fixed.

## Blocker

None.

## Next action

Codex: run the mandatory risk-aware review of T1a against the payload above — verdict on the section A wording, the section B predicted diff and its exclusion proofs, the section C consumer inventory, and the section D dimensions. Decide the two open items in section E: the header wording, and whether consumer C1 (`work-loop-v2-proportionality-continuity-implementation-plan-v0.1.md:363–365, :894`) becomes a bounded follow-on or a named accepted limitation. Claude implemented nothing and edited no target file; implementation of T1a starts only after this review returns.
