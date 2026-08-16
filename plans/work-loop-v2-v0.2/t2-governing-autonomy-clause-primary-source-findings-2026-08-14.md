# T2 governing-autonomy clause: primary-source findings

**Date:** 2026-08-14  
**Decision:** How to add the approved governing autonomy clause to the now-canonical Work Loop executable core without corrupting section references or leaving contradictory authority/status claims.  
**Verdict on the supplied recommendation:** **REVISE.** Appending the clause as core §8 and never renumbering §§1–7 are confirmed. A separate status-reconciliation unit before T2 is also the safest treatment. But “amend three false §1 references” is not a complete amendment, and clause insertion alone would leave the canonical core in direct conflict with the approved rule. The frozen plan must also make T2 a coherent rule-adoption change and correct its citation-only premise for the Codex skill.

## Scope and source identities

This report uses primary repository/history sources only. It lives beside the governing proposal and implementation plan because this repository keeps related investigation, defect, and decision reports in `plans/work-loop-v2-v0.2/`; no dedicated general research-note directory exists in this checkout.

Verified object identities:

- Approved proposal: commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, whose proposal path resolves to blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`. (`git rev-parse d8a89e0f:plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md`.)
- Frozen implementation plan: freeze commit `fe2c62fddf8124caf44836b8237e44e06041db6f`, whose plan path resolves to blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d`. The working-tree plan still hashes to that blob. (`git rev-parse fe2c62fd:<plan-path>`; `git hash-object <plan-path>`.)
- T1 implementation: commit `5fef08fff11a1009b30d925f49d68844fc4e2f03`, whose core path resolves to blob `30c62c418d3bd29b6c4a17841c90886f7be5ffe8`. The working-tree core still hashes to that blob. (`git rev-parse 5fef08ff:<core-path>`; `git hash-object <core-path>`.)
- T1 approval record: commit `9a0fdb41fa27ae7ac813504a5145a59d465b93b7`. Its state-file record says the operator gave direct content-bound approval of implementation commit `5fef08ff…`, that “The core is now canonical,” and that T2's canonicity precondition is met. ([approval record, commit `9a0fdb41`, state file lines 51–71](../../logs/work-loop/autonomy-authority-capability.md); the quoted approval record is visible in that commit even though the live state has since advanced.)

Other governing sources inspected: current [Codex skill](../../.agents/skills/work-loop-v2/SKILL.md), current [Claude command](../../.claude/commands/work-loop-v2.md), [QC independence](../../docs/qc-independence.md), relevant owner/carrier/dispatcher code and tests, and the operator-provided **Axcíon Standard Implementation Workflow** at `/Users/patrik.lindeberg/.codex/attachments/18e3181b-5534-4b7c-9fc2-fb520c455b97/pasted-text.txt`.

## 1. Proposal §14 item 2 names the source clause, not the destination section number

Proposal §1 introduces one quoted governing rule and says it “should become part of the canonical executable core after that core's formal authority status is resolved.” It does not prescribe a destination heading number. Proposal §14 item 1 then makes the core canonical; item 2 says: “Add the governing autonomy clause **from §1** to the now-canonical core.” Grammatically and structurally, “from §1” identifies the clause's source in the proposal. It does not say “make it core §1.” ([proposal blob `39c671…`, lines 11–17 and 481–487](work-loop-v2-autonomy-authority-capability-proposal-v0.1.md).)

**Answer:** item 2 requires the approved clause from proposal §1 to enter the canonical core. It does **not** require the destination to be core §1.

The requirement that the destination be “a new numbered section” comes from the frozen plan, not the proposal. The plan's Repository Delta places it at “same file, §1 (new),” while §3.2 and T2 require “a new numbered section” but do not otherwise prove that existing headings may be renumbered. ([plan blob `d1a616…`, lines 122–128, 229–246, 475–490](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)

## 2. Current topology and the actual renumbering blast radius

### Current heading topology

The approved T1 core has exactly seven real numbered top-level sections, in this order:

1. `## 1. Who does what`
2. `## 2. When to use the loop`
3. `## 3. The unit cycle`
4. `## 4. The task-state file`
5. `## 5. Words we use`
6. `## 6. Safety rules`
7. `## 7. When to stop and ask`

([core blob `30c62…`, lines 16, 40, 64, 251, 416, 438, and 456](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md).) A naive `rg '^## '` overcounts because §4 contains fenced Markdown examples with `## Outcome`, `## Brief`, and similar sample headings; those are example data, not document topology. ([core lines 346–395](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md).)

### Re-derived reference counts

The following counts are deliberately scoped and reproducible:

- The core contains 26 bounded `§ 1`–`§ 7` tokens. One is an explicit reference to another document—`step-2-transport-seam-conclusions.md §2` at core line 407—leaving **25 internal core self-references** that would require semantic renumbering if a new §1 were inserted. Core line 266's reference-document §24 is excluded by the digit boundary. ([core lines 60–473](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md).)
- A defined 15-file live/operational set contains **198 explicit current-core section references** matching `(?:core|executable core)…§[1-7]`: the Codex skill and routing index; Claude command; `qc-independence.md`; current owner helper and its test plus the deployed research-workflow copy; slice-1 test; MVP README; dispatcher source, test, QC helper and README; carrier source and test. The largest concentrations are the Codex skill (52), slice-1 test (43), Claude command (32), dispatcher (21), and carrier (19). This is an exact count for explicit `core §N`-shaped references, not a claim that no implicit prose dependency exists. (Primary surfaces: [skill](../../.agents/skills/work-loop-v2/SKILL.md), [command](../../.claude/commands/work-loop-v2.md), [slice test](../../logs/scripts/work-loop-v2-slice-1.test.sh), [dispatcher](handoff-automation-spike/dispatch.sh), [carrier](../../scripts/axcion-harness-v0.2/carry-turn.sh).)
- Across the entire tracked repository, the same explicit pattern yields **670 occurrences across 107 files**. After the 15-file operational bucket, **472 occurrences across 92 files** remain in the non-runtime corpus: plans (including the active frozen plan), logs, archives, prior evidence, and reports. Those files are not one homogeneous rewrite target. The active plan must be amended; historical evidence should retain the section numbering that was true when it was written rather than be silently rewritten.

The counting primitives were `git grep -l` to enumerate tracked candidate files, then `rg --pcre2 -o -i '(core|executable core)[^\n§]{0,30}§ ?[1-7](?![0-9])'` per file; the internal-core count used `rg --pcre2 -o '§ ?[1-7](?![0-9])'` followed by inspection of the two external-document citations.

The current deterministic baselines remain green: [core resolver test](../../logs/scripts/work-loop-v2-core-resolver.test.sh) reported **4 passed, 0 failed**, and [slice-1 test](../../logs/scripts/work-loop-v2-slice-1.test.sh) reported **308 passed, 0 failed**. These results establish no present resolver/runtime regression; they do not prove that renumbering is safe, because the existing suite does not exhaustively validate all section-number citations. The frozen plan makes the same distinction between regression evidence and proof of new citation behavior. ([plan lines 146–160 and 270–279](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)

### Placement consequences

| Placement | Existing core headings | Existing live references | Authority/plan consequence |
|---|---|---|---|
| Insert as new core §1 | Current §§1–7 become §§2–8 | At least 25 internal and 198 explicit operational references must be changed correctly; archives retain old meanings | Largest blast radius; creates avoidable reference corruption risk; no proposal requirement supports it |
| Append as core §8 | Current §§1–7 remain stable | Zero existing section-number references need renumbering | Requires the active plan's future citations to name core §8, and requires current contradictory core language to be reconciled |
| Unnumbered preface or §0 | Current §§1–7 remain stable | Zero renumbering | Less conventional and contradicts the frozen plan's explicit “new numbered section” contract without providing an advantage over §8 |

**Safest placement:** append `## 8. Governing autonomy rule`. It satisfies the proposal and the plan's numbered-section intent while preserving every existing section identity.

## 3. Frozen-plan statements that must change

Two categories must be kept distinct: proposal-source references such as “the §1 clause” remain true, while references that mean the destination inside the core must become §8.

### Placement-dependent corrections

The minimum amendment must correct all of these statement clusters, not merely three textual hits:

1. **Repository Delta placement/topology.** Plan line 127 says “same file, §1 (new)” and implies no §1 section exists. The core already has §1, *Who does what*. Replace this with: current core has §§1–7, lacks the governing clause, and T2 appends it as §8. ([plan lines 122–128](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md); [core lines 16–27](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md).)
2. **T1 historical starting-evidence wording.** Plan T1 line 459 says “no §1 section exists.” What did not exist was the proposal-§1 governing clause; core §1 did exist. Preserve T1 as completed history but correct the false topology claim to “no governing-autonomy clause exists.” ([plan lines 455–470](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)
3. **§3.2 and T2 destination contract.** Specify “append as core §8, preserving §§1–7 and their references,” and change T2's “core has no §1 section” starting evidence to “core has §§1–7 and no governing-autonomy clause.” Keep “proposal §1 clause” wherever it clearly identifies the approved source text. ([plan lines 229–246 and 475–490](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)
4. **Downstream core citations.** Every destination reference in §3.3 and T3–T5 that says the canonical core's §1 governs, or instructs a consumer to cite §1, must cite core §8. This includes the specification at lines 250–278, T3 at 494–505, T4 at 509–518, T5 at 525–544, and the ordering statement at 736–740. References explicitly saying “proposal §1” remain unchanged. ([plan cited ranges](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)

### Newly disproved implementation premises

Placement repair alone is insufficient:

5. **T2's claimed coherent result is currently impossible under its clause-only scope.** The approved proposal says consequence is not an automatic operator gate and only missing intent, accepted risk, a material solution-envelope change, or capability-envelope expansion transfers the decision. ([proposal lines 107–129 and 509–521](work-loop-v2-autonomy-authority-capability-proposal-v0.1.md).) The canonical core currently says “Genuinely consequential work stops and goes to the operator” (lines 59–60), includes “Anything else that is genuinely consequential” as an operator stop (line 475), and concludes that operator handoff is the answer “for consequential situations” (line 477). Core lines 26 and 469 also use categorical hard-to-reverse language broader than the proposal's more specific operator-reserved boundaries and must be deliberately narrowed or justified. ([core lines 20–27, 40–61, and 456–477](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md).) Therefore plan §3.2's guaranteed behavior (“one copy of the rule” with no competing statement) and T2's clause-only intended change are inadequate. T2 must establish a coherent rule in the core, not merely paste one contradictory paragraph into it. ([plan lines 235–246 and 477–490](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)
6. **Citation-only T3 is disproved for the Codex skill.** The live skill still says “Decide anything hard to reverse — that is the operator's, via core §7.” That is a categorical authority transfer, not a missing citation. ([skill line 508](../../.agents/skills/work-loop-v2/SKILL.md).) Skill line 473's “consequential or hard-to-reverse claim” is a proportional re-check trigger and is not by itself an operator gate; it need not be treated as the same defect. ([skill lines 465–475](../../.agents/skills/work-loop-v2/SKILL.md).) The plan already anticipates this case: if a real semantic conflict is found, T3's scope grows and “should be re-split rather than absorbed silently.” ([plan lines 190–193](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).) Amend the Repository Delta's “no semantic change needed” claim and T3's citation-only/no-semantic-change contract accordingly. ([plan lines 128 and 492–507](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)
7. **A status-reconciliation unit is missing.** No frozen tracer owns the status/header defect described below. Add a bounded unit before T2 rather than hiding it inside T2.

This is the minimum content correction set. Dynamic inventory totals such as the old “60 tracked hits” are not themselves placement authority; if retained, they should be dated or regenerated, but changing them is not a prerequisite to choosing §8. ([plan lines 89–113](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).)

## 4. Core approval status and the two amendment notes

The current header says `Status: draft for operator approval`. The same canonical blob's authority paragraph says operator content-bound approval of the identifiable T1 commit is what makes the file canonical, and approval record commit `9a0fdb41…` says that approval occurred and “The core is now canonical.” These are contradictory current-status claims. ([core lines 1–12](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md); approval record commit `9a0fdb41`, state-file lines 51–71.)

The notes at core lines 165–167 and 285–287 are subtler. Their dated historical claim—each amendment was approved on its own at the time and did not then approve the rest of the file—remains true. But their present-tense rationale that the header “still reads draft for operator approval” and is “deliberately unchanged” is now stale and reinforces the false current status. They should be preserved as provenance but rewritten to say that the limitation applied when the amendment landed and was superseded when T1 made the whole core canonical. ([core lines 144–167 and 262–287](../work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md).)

Treatment options:

- **Separate bounded unit before T2 — recommended.** It has one behavior: reconcile the canonical artifact's status and historical amendment notes to the already-recorded T1 approval. It does not change autonomy policy. The executable core is a shared authority surface, so it still takes the proposal-required risk-aware review before implementation. ([proposal lines 521–522](work-loop-v2-autonomy-authority-capability-proposal-v0.1.md); [QC rule lines 9–27 and 33–40](../../docs/qc-independence.md).)
- **Inside T2 — reject.** T2's behavior is adopting the governing autonomy rule. Combining status provenance with new policy makes two independently verifiable behaviors one change and violates the frozen unit's scope/evidence contract. The Standard Implementation Workflow requires one meaningful behavior, the smallest coherent change, an explicit scope boundary, and independent assessment of that bounded implementation. (Operator-provided workflow §§4–5 and 8.)
- **Leave temporarily — not safest.** Higher authority lets agents recognize the approval record over the stale header, but the canonical document would continue making contradictory claims about its own authority while receiving another governing rule. The Work Loop's live skill says verified evidence that falsifies a plan/source premise must be surfaced rather than silently used, and only one current plan/source should be treated as authoritative. ([skill lines 429–433](../../.agents/skills/work-loop-v2/SKILL.md).)

## 5. Approval needed for amendment and re-freeze

**Yes.** Agents may draft the correction and obtain a fresh bounded review without asking permission first, because repository evidence has disproved plan premises. They may not treat the amended content as the implementation basis until the operator explicitly approves/re-freezes the identifiable new content.

The current plan says its freeze is what makes it the implementation basis, binds every substantive section to an exact commit/blob, and says a later substantive change “is a re-freeze, not an edit.” It was frozen on an operator decision. ([plan lines 3–12](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).) Its readiness statement also says a plan grants no target-edit authority until reviewed and frozen. ([plan lines 750–755](work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md).) The Standard Implementation Workflow independently requires a fresh bounded plan review, then a freeze, before one-behavior execution. (Operator-provided workflow §§6–8.) Reusing the old freeze for materially different placement, unit ordering, and scope would let the agents widen their own implementation basis—the exact authority failure the proposal forbids. ([proposal lines 79–103 and 215–235](work-loop-v2-autonomy-authority-capability-proposal-v0.1.md).)

### Smallest safe sequence

1. Stop before the current T2 brief; treat this report as evidence that the frozen plan has false premises.
2. Amend only the governing plan: preserve proposal §1 as the source name; designate appended core §8; correct every core-destination citation; add a pre-T2 status-reconciliation tracer; expand revised T2 to remove/narrow the conflicting core consequentiality gates as part of one coherent rule-adoption behavior; and re-split/rewrite T3 so the Codex skill's categorical hard-to-reverse rule is corrected rather than merely cited.
3. Give that amended plan one fresh, isolated bounded implementation-plan review against the approved proposal and repository evidence.
4. Obtain explicit operator content-bound approval of the reviewed plan commit/blob and record the re-freeze. No core, consumer, or test edit occurs before this point.
5. Execute the separate core-status reconciliation unit with one risk-aware Codex review, deterministic text/diff evidence, Claude implementation/commit, and Codex assessment.
6. Execute revised T2: append the approved proposal §1 clause verbatim as core §8 **and** reconcile the existing core statements that make consequence or hard-to-reverse character alone an operator gate. Preserve existing section numbers. Review it risk-aware as one coherent high-consequence core change.
7. Continue with the amended downstream reconciliation units, citing core §8 and keeping proposal §1 citations explicit.

## 6. Stress-test verdict

**REVISE.** The recommendation's architectural center is correct:

- **Confirmed:** append the clause as core §8.
- **Confirmed:** never renumber existing core §§1–7.
- **Confirmed:** reconcile the stale header and dated notes in a separate bounded core-status unit before T2.
- **Revised:** do not describe the plan repair as only “three false §1 references.” Correct every destination-reference cluster while retaining proposal-source §1 references.
- **Added:** revised T2 must leave one coherent canonical rule, which requires reconciling core lines 59–60, 475, and 477 and deliberately resolving the broader language at lines 26 and 469.
- **Added:** T3's citation-only premise is false for skill line 508 and must be re-split or substantively corrected as the frozen plan itself directs.
- **Required gate:** fresh review plus explicit operator content-bound re-freeze of the amended plan before any implementation resumes.

The supplied recommendation is therefore not rejected: its placement, non-renumbering, and status-unit decisions are the safest foundation. It is revised because, without the additional coherence and skill corrections, T2 would avoid reference corruption but still leave the approved canonical authority internally and operationally contradictory.
