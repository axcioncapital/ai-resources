---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Implementation mode. Unit 21 — correct the reviewed, unapplied T2 core candidate against its three frozen findings.

Named reason for the loop: T2 changes the canonical authority contract and its exact candidate received a required risk-aware review; the frozen findings must close against the now re-approved plan before any core edit is permitted.

## Brief
Unit 20 passed. The corrected implementation plan was content-bound approved at commit `c99e6b415a911866518111d1944c0e61dc72fbf8`, blob `f80dc9d9dff8a6f13f66549f717d49a9db2efdfe`, and its status-only re-freeze landed at commit `94226ebcd36ea675be1c26751164aab22da1eb37`, resulting plan blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`. T2 remains unimplemented. This correction is the plan's remaining pre-implementation gate.

**Governing authority:** the operator-approved proposal at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; the re-frozen implementation plan above, especially § 3.2 and T2; and the three frozen findings from the fresh isolated risk-aware review of Unit 18's exact unapplied candidate. **Candidate baseline:** the complete candidate diff and evidence recorded in `logs/work-loop/autonomy-authority-capability.md` at commit `6ab0633f17935f0b845a77568d9007a0e844226b`; it was not applied. **Target baseline:** the core expected at blob `82f119cd63c379b24f0bef8aab029ae04c165203`.

Scope: correct the exact unapplied candidate and return its complete replacement unified diff plus bounded closure evidence in this state file. Do not edit the core, plan, proposal, any consumer, test, research report, or repository scratch file. Do not perform another broad candidate review. The candidate must remain one-file T2 work against the current core.

Claims to check before correction:

1. The re-frozen plan is blob `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`, and § 3.2/T2 carry the seven-surface, eight-string contract and the authoritative finding mapping.
2. The core is still blob `82f119cd63c379b24f0bef8aab029ae04c165203`; it has no § 8 clause and still contains the seven categorical-transfer strings plus the retained disclosure string exactly as the plan's before-state requires.
3. Commit `6ab0633f17935f0b845a77568d9007a0e844226b` contains the complete Unit 18 candidate diff marked **NOT APPLIED**, and that candidate was reviewed as one coherent T2 change.

Candidate invariants to preserve: the proposal § 1 blockquote is verbatim and 588 bytes including its line terminator; it occurs once under appended `## 8.`; headings §§ 1–7 retain their titles and order; the five consequence gates and § 6 scope transfer are reconciled while the no-quiet-change disclosure remains; every proposal § 6 operator-reserved and mandatory-stop/handback class remains represented; T1's authority paragraph and T1a's status text remain unchanged; only the core would change when this candidate is later applied.

Required evidence: return the complete corrected candidate unified diff, clearly labelled **NOT APPLIED**, against core blob `82f119cd…`. Show a before/old-candidate/corrected-candidate comparison for each frozen finding, then answer the closure questions: are all three findings resolved, and did the correction break anything? Re-run only bounded candidate checks needed to prove the preserved invariants, the eight normalized logical strings (before: all eight match; corrected candidate: seven removed strings absent and retained disclosure present), the exact 588-byte clause, eight headings with §§ 1–7 unchanged, proposal § 6 coverage, and no repository target change. Report any newly noticed issue as a deferral, not a fourth finding.

Completion condition: place the corrected exact candidate and closure evidence in `## Latest result`, set `turn: codex`, commit only this state-file handback, and stop. Do not apply the candidate or begin downstream tracers.

Stop conditions: stop if any baseline identity differs, the candidate cannot satisfy a frozen finding without leaving the approved T2 boundary, a proposal § 6 protection would be weakened or lost, another file becomes necessary, or the plan and proposal conflict. Challenge a false premise rather than improvising.

## Latest result

Inspected (2026-08-15):

- Claim (1): HOLDS — `git hash-object` on the plan returned `eebb9a49e94bd6859b17b98b66d8526b3a41dcb2`, matching the index entry. Read § 3.2 lines 466–470 ("**five** consequence gates, plus one scope rule, plus one settled-decision gate — **seven surfaces in total**"), lines 641–648 ("exactly **eight** normalized logical strings … seven removed plus one retained"), and the authoritative finding mapping at Outputs 2(i)/2(ii) (lines 507–521, routing corrections = findings 1 and 2) and Output 4 (lines 533–550, settled-decision surface = finding 3), with evidence items (h) and (i) at lines 614–628. T2's own row repeats the same mapping at lines 1044–1053.
- Claim (2): HOLDS — `git hash-object` on `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` returned `82f119cd63c379b24f0bef8aab029ae04c165203`, equal to its index entry. Searched the core for `^## [0-9]`; found exactly **seven** headings, so there is no § 8. Searched it for `pre-authorized capabilities`; **0** occurrences, so the governing clause is absent. All **eight** normalized logical strings match the pre-change core (BEFORE column below: eight of eight MATCH) — the seven categorical-transfer strings plus the retained disclosure string, exactly as the plan's before-state requires.
- Claim (3): HOLDS — `git show 6ab0633f…` carries the candidate under the heading `### The candidate diff — NOT APPLIED`, with the record stating the core "is unchanged at blob `82f119cd…`". The candidate was reconstructed from that record and is **byte-identical** to it (see *Reconstruction* below). It was reviewed as one coherent T2 change: the re-frozen plan records the review at T2 lines 1073–1077 — verdict **CORRECT**, one risk-aware review over the whole change, producing exactly these three findings.

Result: the exact Unit 18 candidate was reconstructed, corrected against the three frozen findings only, and is returned below as a complete replacement patch, **NOT APPLIED**. The repository core is still blob `82f119cd63c379b24f0bef8aab029ae04c165203`; no core, plan, proposal, consumer, test or research file was edited by this unit. All three findings are resolved and no bounded check regressed.

**Reconstruction (so the corrected diff is provably a correction, not a redraft).** The Unit 18 candidate core was rebuilt from the recorded diff, and `diff` between the recorded diff text at `6ab0633f…` and a freshly generated `diff -u core → reconstruction` is **empty** — 512 lines, matching Unit 18's own stated count. Every three-way comparison below therefore compares against the reviewed candidate itself, not a paraphrase of it.

### The corrected candidate diff — NOT APPLIED

Four hunks, one file. Against the current core (477 lines) the corrected candidate is 522 lines (the old candidate was 512).

```diff
--- a/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
+++ b/plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md
@@ -23,7 +23,9 @@
 **Claude** owns repository reality. It checks claims against the live repository, implements, tests,
 and produces evidence.
 
-**The operator** owns priorities, scope, and any decision that is hard to reverse.
+**The operator** owns intent and priorities, the approved solution envelope, and the decisions § 7
+reserves to them. Consequence alone does not move a decision to the operator; it raises containment,
+evidence and review (§ 8).
 
 Four limits on those roles:
 
@@ -56,8 +58,9 @@
 what was learned, close the task, and finish the work directly. Do not keep a task in the loop only
 because it started there.
 
-Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Genuinely
-consequential work stops and goes to the operator instead (§ 7).
+Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Consequential
+work runs in Standard with stronger containment, evidence and review; it goes to the operator only
+when § 7 reserves the decision to them.
 
 ---
 
@@ -446,8 +449,10 @@
    malformed, stale, or belongs to a different task, report it and change nothing.
 3. **An absence claim must say what was searched.** "There is no such field" is not a finding.
    "There is no such field — searched the model, the view and their tests" is.
-4. **Scope and success criteria do not change quietly.** A change to either is stated out loud, and
-   a change to scope goes to the operator.
+4. **Scope and success criteria do not change quietly.** A change to either is stated out loud, never
+   made silently. The decision is the operator's when the change is one they reserve — the intended
+   outcome or the priority, a material expansion of scope, or the removal of an exclusion (§ 7). A
+   change that is none of those is disclosed and proceeds.
 5. **Evidence must be able to fail.** If the check would pass whatever happened, it is not evidence.
    Build the failing case first, then show it passing.
 
@@ -457,21 +462,61 @@
 
 Stopping is a normal outcome. Each trigger below names who to stop for.
 
+**Consequence is not itself a trigger.** Higher consequence means stronger containment, stronger
+evidence and a proportional review — not that the decision moves to someone else (§ 8). A
+consequential change whose outcome, envelope and capabilities are already delegated stays with the
+agent and is done more carefully. What moves a decision is the class it falls in, and the classes are
+listed here.
+
 **Hand back to Codex** — write the finding into the state file, set `turn: codex`, commit, and stop:
 
-- A claim the brief rests on is false (rule 1).
+- A claim the brief rests on is false (rule 1), or a load-bearing premise is still unsupported after
+  bounded investigation.
 - The work would go outside the approved scope, or touch something the brief excluded.
 - The required evidence cannot be produced.
+- The approved plan is materially invalid, and repairing it would go outside the solution envelope.
+- A capability the work needs is already authorized, but the available technical means cannot enforce
+  it safely. That is a technical or infrastructure problem, and the operator cannot waive it: what is
+  missing is containment, not permission.
+- The action would bypass, weaken, or self-expand the control system. The operator is reached only
+  where the remedy would itself materially change the policy governing agent authority, and then
+  through that separate class below — never through this clause.
 
 **Stop for the operator** — write the question into the state file, set `turn: operator`, commit, and
 stop:
 
-- The change would be hard to reverse.
-- Proceeding would need a settled decision to be reopened.
+- The intended outcome or the priority would change.
+- Scope would expand materially, or an exclusion would be removed.
+- Product or business behaviour must be chosen and existing authority does not determine it.
+- The approved operating model, a material architecture commitment, the cost or risk profile, or the
+  governance model would change.
+- Material residual risk would be accepted that was not already delegated — including the case where
+  the correction was not enough and the choice among the options in § 3 is really about accepting
+  risk.
+- The authorized capability envelope would expand, or a capability the work needs has not been
+  granted.
+- Production deployment, public or customer communication, credential use, or destructive action on
+  shared state would be authorized, and no separate explicit delegation already covers it.
+- Operator intentions are genuinely tied or in conflict, or governing sources stay materially tied
+  after the authority hierarchy has been applied.
+- The policy governing agent authority would materially change.
+- An **operator-owned** settled decision would have to be reopened — one the operator settled
+  themselves, or one falling in a class this list reserves to them. A settled implementation or
+  technical decision delegated inside the approved solution envelope does **not** transfer merely
+  because it is settled: reopening it is disclosed, stays subject to every other trigger here, and
+  remains the agent's to make on the evidence.
+- Continuing would require inventing operator intent.
 - The state file is stale or belongs to another task, and it is not obvious which is correct
   (rule 2).
-- The correction was not enough, and the choice among the options in § 3 is really about accepting
-  risk.
-- Anything else that is genuinely consequential.
 
-In this version, "stop and bring this to the operator" is the answer for consequential situations.
+These classes are what stop the work. Everything outside them proceeds under § 8, with containment,
+evidence and review scaled to what is at stake.
+
+---
+
+## 8. The governing autonomy rule
+
+> **Within the approved solution envelope, resolve what evidence can resolve, exercise professional technical judgment, and use only pre-authorized capabilities. Consequence increases containment and verification; it does not by itself transfer the decision to the operator. Escalate only when continuing requires operator-owned intent, accepted risk, a material change outside the solution envelope, or expansion of the authorized capability envelope. Stop when a load-bearing premise or required verification cannot be established, or when continuing would bypass the control system.**
+
+This rule governs §§ 1–7 above wherever they touch autonomy: § 7 lists the classes that escalate it,
+and § 6 rule 4 states how it applies to a change of scope.
```

### The three frozen findings — before, old candidate, corrected candidate

Each check reads the § 7 sub-block it is about, flattened to one logical line, so a clause that merely exists somewhere in the file cannot pass a check about **where it is routed**. The three-column run is the fail-capable part: every check below **fails on the old candidate and passes on the corrected one**, so none of them could pass whatever the correction did.

| Check | BEFORE (core) | OLD candidate (Unit 18) | CORRECTED candidate |
|---|---|---|---|
| F1a — Codex block carries the unenforceable-capability clause | no | **no (fails)** | **yes** |
| F1b — operator block carries `cannot be enforced safely` | no | **yes (fails)** | **no** |
| F1c — operator block carries the not-granted half | no | **no (fails)** | **yes** |
| F2a — Codex block carries `bypass, weaken, or self-expand the control system` | no | **no (fails)** | **yes** |
| F2b — operator block carries the bypass clause | no | **yes (fails)** | **no** |
| F3a — `inventing operator intent` is its own whole bullet | no | **no (fails)** | **yes** |
| F3b — operator block qualifies the settled decision as operator-owned | no | **no (fails)** | **yes** |
| F3c — operator block exempts a delegated implementation or technical decision | no | **no (fails)** | **yes** |

**Finding 1 — capability routing.** Old candidate, one operator bullet: "The authorized capability envelope would expand, or the capability the work needs is not granted **or cannot be enforced safely**." That merges the two routes plan § 3.2 Output 2(i) separates. Corrected: the operator keeps "The authorized capability envelope would expand, or a capability the work needs **has not been granted**", and a new **Codex handback** bullet carries the other half — "already authorized, but the available technical means cannot enforce it safely … the operator cannot waive it: what is missing is containment, not permission." The non-waivability is stated in the clause, not left to the reader.

**Finding 2 — control-system routing.** Old candidate placed "The action would bypass, weaken, or self-expand the control system." under **Stop for the operator**. Corrected: it moves to **Hand back to Codex**, with the operator reachable "only where the remedy would itself materially change the policy governing agent authority, and then through that separate class below — never through this clause". Proposal § 6's authority-policy bullet remains its own operator class, so the operator route exists but is reached separately, as Output 2(ii) requires.

**Finding 3 — settled-decision boundary.** Old candidate merged both triggers into one bullet: "Proceeding would need a settled decision to be reopened, **or would require inventing operator intent**." Corrected: two bullets. The settled-decision bullet transfers only an **operator-owned** settled decision and states explicitly that a settled implementation or technical decision delegated inside the approved solution envelope "does **not** transfer merely because it is settled" — it is disclosed, stays subject to every other trigger, and remains the agent's on the evidence. `Continuing would require inventing operator intent.` stands as its own separately identifiable bullet. This satisfies (h-i), (h-ii) and (h-iii), and reverses Unit 18 judgment call 4.

### Bounded checks — invariants and the plan's evidence items

**(1) The eight normalized logical strings.** Both files flattened with `tr '\n' ' ' | tr -s ' '` and matched with a shell substring test, so no regex could pass on a partial match. Eight of eight match **before**, which is what proves the run reads real text and can fail.

| # | String | Kind | BEFORE | AFTER (corrected) |
|---|---|---|---|---|
| d-i | `and any decision that is hard to reverse` | removed | MATCH | **no match** |
| d-ii | `Genuinely consequential work stops and goes to the operator instead` | removed | MATCH | **no match** |
| d-iii | `The change would be hard to reverse.` | removed | MATCH | **no match** |
| d-iv | `Anything else that is genuinely consequential.` | removed | MATCH | **no match** |
| d-v | `is the answer for consequential situations` | removed | MATCH | **no match** |
| g-1 | `a change to scope goes to the operator` | removed | MATCH | **no match** |
| g-2 | `Scope and success criteria do not change quietly` | **retained** | MATCH | **MATCH** |
| h | `Proceeding would need a settled decision to be reopened.` | removed | MATCH | **no match** |

Seven removed, one retained, eight before-matches — the exact total § 3.2 *Matching discipline* requires. The five consequence gates, the scope surface and the settled-decision surface stay separately identified, so a partial reconciliation of any one shows as a single failing row.

Worth recording for the closure check: **(h) alone does not distinguish the old candidate from the corrected one** — the old candidate's merged bullet also broke that string, by appending ", or would require…" after "reopened". That is why finding 3 is proved by F3a–F3c above rather than by (h), and it matches the plan's own decision at § 3.2 lines 617–623 to pair (h) with a reviewer-read check instead of a second string.

**(2) The clause.** Taken from proposal line 15, not retyped. `diff` against `git cat-file blob 39c67196…` line 15 is **empty** — byte-identical to the approved blob. **588 bytes including the line terminator** (587 without), matching § 3.2's stated size. It occurs **exactly once** in the corrected candidate (`grep -c '^> \*\*Within the approved solution envelope'` → 1) and nowhere outside the core.

**(a) The clause-presence check goes from failing to passing.** `grep -c 'pre-authorized capabilities'`: **0 before, 1 after**.

**(3) Headings.** `grep -n '^## [0-9]'` on the corrected candidate returns exactly eight, 1–8 in order (16, 42, 67, 254, 419, 441, 461, 517). `diff` between the core's seven heading lines and the candidate's first seven is **empty** — titles and order byte-identical, nothing renumbered or retitled. The new title does not collide with the `## Mode` heading slice-1 asserts against.

**(b) Fixed points untouched, one file only.** `diff` of lines 1–12 before against after is **empty**, so T1a's reconciled header (line 3) and T1's `**Authority.**` paragraph (lines 9–12) are byte-identical. The diff touches one file: no consumer, skill, command, test or plan file is in it, so T3 keeps its citation-only scope and T3a stays limited to skill line 508.

**(e/i) Proposal § 6 coverage — reviewer-read, every class mapped.** All **nine** operator-reserved classes map to the nine operator bullets in list order (outcome/priority; material scope or exclusion; product or business behaviour; operating model/architecture/cost-risk/governance; undelegated material residual risk; capability-envelope expansion; production/communication/credential/destructive shared state; tied intentions or tied governing sources; authority-policy change). All **seven** mandatory stop/handback classes are represented: unsupported load-bearing premise, materially invalid plan, unproducible required verification, and the unenforceable-capability half under **Hand back to Codex**; the not-granted half and `inventing operator intent` under **Stop for the operator**; control-system bypass under **Hand back to Codex**; materially tied governing sources under **Stop for the operator**. Proposal § 6's single "not granted **or** cannot be enforced safely" line is the one class deliberately split across the two lists — that split **is** finding 1's correction, and both halves remain present. Nothing in the pre-change core was dropped: "The work would go outside the approved scope…", "The required evidence cannot be produced.", and the stale-state-file bullet survive verbatim; the risk-acceptance and settled-decision triggers survive in reworded form; only the two categorical bullets are removed, which is T2's purpose.

**(f) Regression protection.** `work-loop-v2-core-resolver.test.sh` passes against the unchanged repository core (**4 passed, 0 failed**). Because the candidate is not applied, the slice-1 suite could not run whole; its **nineteen core-reading assertions were extracted and evaluated directly against the corrected candidate — all nineteen PASS**, including the two the candidate came closest to breaking: `grep -q 'There is no third lane'` (the d-ii rewrite keeps that sentence verbatim) and `! grep -qE '^## Mode'` (the new § 8 title). Had the § 7 rewrite dropped either, the failure would surface here rather than after the core was edited.

**(7) No repository target changed.** `git hash-object` on the core still returns `82f119cd63c379b24f0bef8aab029ae04c165203`. `git status --porcelain` lists only this state file and the hook-appended `logs/friction-log.md`, which this unit does not commit. Both candidates and the diff live in the session scratchpad, outside the repository.

### Closure questions

- **Are all three frozen findings resolved?** Yes. Each is proved by a check that fails on the reviewed Unit 18 candidate and passes on the corrected one (F1a–F1c, F2a–F2b, F3a–F3c), and the reconstruction is byte-identical to the reviewed candidate, so those comparisons are against the reviewed text itself.
- **Did the correction break anything?** No. The eight-string matrix is unchanged in outcome (seven removed absent, one retained present), the clause is still byte-identical and occurs once, the eight headings and the byte-identical §§ 1–7 titles hold, T1/T1a fixed points are untouched, every proposal § 6 class is still represented, the resolver suite is green, and all nineteen slice-1 core assertions pass. The correction touched § 7's two lists only; hunks 1–3 are byte-identical to Unit 18's.

### Deferrals — recorded, not implemented, and not fourth findings

- **New, from this correction:** two § 7 bullets now carry an explanatory second sentence (the unenforceable-capability bullet and the control-system bullet), where the core's other bullets are single sentences. The explanation is what makes non-waivability and the routing exception readable rather than inferred, so it is proposed to stay — but it is a style departure for Codex to accept or trim at the closure check, not something to change unilaterally inside a frozen scope.
- **Unit 18 judgment calls, current status:** call 3 (capability routing) and call 4 (merged bullets) are now settled by findings 1 and 3. Calls 1 (§ 8's two navigation sentences) and 2 (§ 7's opening and closing paragraphs) were put to the review, drew no finding, and are carried unchanged.
- **Carried forward, unchanged and non-blocking:** the worktree proposal is still one status-line hunk off the approved blob (line 15 identical, so the candidate binds to approved content either way); the future normalized-count harness note; the proportionality/continuity-plan follow-on; the stale row in the unapproved resource-capability development plan; the plan's § 14 item-6 wording inconsistency. None blocks T2.

## Blocker
None. The core was not edited; T2 remains at its implementation gate until the bounded closure check passes.

## Next action
Codex: run the bounded closure check on the three frozen findings only — are findings 1, 2 and 3 resolved, and did the correction break anything? The evidence above answers both; nothing else re-opens the candidate. Then decide under § 3 *If the correction was not enough*: accept and open T2's implementation unit against this corrected candidate, or use the menu once. Rule on the one new deferral (the two explanatory bullet sentences) at the closure check rather than as a fourth finding.
