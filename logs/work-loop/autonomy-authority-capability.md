---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the frozen `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md`, whose governing direction is the content-bound approved autonomy/authority/capability proposal.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; do not create parallel state or review systems.

## Lane and unit
Standard. Discovery mode. Unit 7 — T1 pre-implementation premise verification and risk-aware review payload.

Named reason for the loop: this cross-cutting governance implementation must survive session boundaries, and T1 changes the executable core's authority status across every Work Loop consumer.

## Brief
The implementation plan is frozen and T1 is now the first open tracer. T1 is high-consequence because it changes the shared executable core's authority status, so `docs/qc-independence.md` requires a risk-aware Codex review before implementation; this discovery unit prepares the verified payload for that review and makes no target edit.

Governing authority:

- Frozen implementation plan: freeze commit `fe2c62fddf8124caf44836b8237e44e06041db6f`, plan blob `d1a6162b8e92c9689f261b85607dfcdb89105c6d`; substantive content bound to commit `cab3b7a28195f427deaa0d5322e9686f9dc53814`, blob `1cbcbf4ed78bb73d16406dccfb748f4b022242f4`.
- T1 contract: plan §3.1 and §4 T1. It rewrites only the executable core's authority-status line, records proposal v0.4 as historical rationale rather than overriding authority, adds no §1 autonomy clause, and ends only after operator approval of the eventual exact implementation commit.
- Approved proposal: commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`, especially §14 item 1.
- Review rule: `docs/qc-independence.md`, including its premise-verification precondition and seven risk-aware dimensions.

Required outcome: produce a bounded, repository-grounded T1 review payload and hand back without editing the executable core or any other target surface.

Verify and report:

1. Open the current executable core and quote the exact authority-status text T1 would replace. Confirm whether the core still says the proposal wins, whether proposal v0.4 exists, and whether the core currently contains the distinguishing §1 phrase `pre-authorized capabilities`.
2. Re-derive the bounded live-consumer/dependency picture needed to assess blast radius. Separate consumers that resolve/read the core from historical or evidence-only references, and identify any live authority-bearing wording coupled to the current subordination line.
3. Run the existing core-resolver deterministic suite as the current baseline and report its exact result.
4. Propose the smallest exact replacement text for the authority-status paragraph. It must remove live subordination, retain proposal v0.4 only as historical rationale, make no claim that operator approval has already happened, add no §1 policy text, and avoid changing section numbering or any consumer.
5. Evaluate that exact proposed change across all seven risk dimensions: usage cost, permissions surface, blast radius, reversibility, hidden coupling, principle alignment, and problem reality. Name any operator decision or safety condition that remains before implementation.
6. Provide fail-capable implementation evidence for the later execution unit: the old `the Proposal wins` match must disappear, `pre-authorized capabilities` must remain absent, the resolver suite must stay green, and the diff must be confined to the authority-status paragraph.

Scope: read-only investigation plus this state-file handback. Do not edit the executable core, frozen plan, proposal, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or any target implementation surface. Do not create a separate review artifact.

Completion condition: return the verified premise payload, exact proposed replacement, seven-dimension risk evidence, and a clear recommendation—safe to implement as bounded, revise before implementation, or operator decision required—then set `turn: codex`, commit only the state-file handback, and stop.

Stop conditions: stop if the frozen plan identity is inconsistent, the current core no longer matches T1's premise, the replacement would require adding §1 or editing another surface, or a consequential risk cannot be bounded. Challenge a false premise rather than improvising.

## Latest result
Inspected (2026-08-14):

- Claim (1) frozen plan identity: HOLDS — `git cat-file -t fe2c62fd` = commit; `git rev-parse fe2c62fd:plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-implementation-plan-v0.1.md` = `d1a6162b8e92c9689f261b85607dfcdb89105c6d`; `git hash-object` on the working-tree file returns the same blob, so the frozen plan is unmodified. `git rev-parse cab3b7a2:<same path>` = `1cbcbf4ed78bb73d16406dccfb748f4b022242f4`, matching the bound substantive content.
- Claim (2) approved proposal identity: HOLDS, with a path correction — `git cat-file -t 39c67196` = blob; `git ls-tree -r d8a89e0f | grep 39c67196` resolves it to `plans/work-loop-v2-v0.2/work-loop-v2-autonomy-authority-capability-proposal-v0.1.md` (filename is `-v0.1`, not `-v0.4`; `-v0.4` is the unrelated Work Loop MVP proposal). `git diff d8a89e0f HEAD -- <that path>` = 1 line changed: the `**Status:**` line only, rewritten to record the 2026-08-14 content-bound approval. §14 and every substantive section are byte-identical to the approved blob.
- Claim (3) T1 contract: HOLDS — plan `:202-227` (§3.1) and `:455-473` (§4 T1) read in full. They specify the authority line only, no §1 clause, three fail-capable checks, and an exit condition at operator approval of the exact commit.
- Claim (4) core still matches T1's premise: HOLDS — see item 1 below.
- Claim (5) review rule: HOLDS — `docs/qc-independence.md:15` third row (one risk-aware Codex review before implementation), `:35` seven dimensions, `:37` premise-verification precondition, `:39` consumer inventory belongs in the payload.

Result: the T1 review payload below is prepared. No target surface was edited; `git diff` against the executable core, plan, proposal, skill, command, autonomy rules, session-plan, carrier, dispatcher and tests is empty.

### 1. The exact text T1 would replace

`plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md:9-10`, verbatim:

```
**Authority.** Built from the Proposal (`work-loop-v2-mvp-proposal-v0.4.md`), which stays
authoritative. Where this file and the Proposal disagree, the Proposal wins.
```

- The core still says the proposal wins: `grep -n "the Proposal wins"` → exactly one hit, `:10`.
- Proposal v0.4 exists: `plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`, 18436 bytes, tracked.
- `grep -n "pre-authorized capabilities"` on the core → **no match**. T2's distinguishing phrase is absent, as the split requires.
- The core's only other `Proposal` mention is `:402`, inside the "Who commits" note: "Operator decision, 2026-08-01, amending the Proposal's destination behaviour 1". That is a recorded amendment *of* the proposal by an operator decision — it already contradicts `:10`'s unconditional subordination. T1 removes the contradiction rather than creating one.

### 2. Bounded live-consumer / blast-radius picture (re-derived)

The plan's inventory counts are **understated and should be corrected before the review is briefed** (`qc-independence.md:37`). Re-running the plan's own primitives from this checkout's repo root:

| Plan's stated primitive | Plan's stated result | Re-derived result |
|---|---|---|
| `git grep -l "work-loop-v2-executable-core"` | 60 tracked hits | **87 files** (195 total matches) |
| `git grep -ln "work-loop-v2-mvp-proposal-v0.4\|Proposal wins"` | 21 tracked hits | **29 files** |

The counts moved; the classification did not. Splitting the 87 files by what they actually do with the core:

- **Live consumers that resolve the core by path (4).** `.claude/commands/work-loop-v2.md:26` and `.agents/skills/work-loop-v2/SKILL.md:38` (`wl2_semantic_rel=`), plus `logs/scripts/work-loop-v2-core-resolver.test.sh:31` (`SEMANTIC_REL=`) and `logs/scripts/work-loop-v2-slice-1.test.sh:266` (`CORE_F=`). All four bind the **relative path**, none binds file content, so a text-only edit inside the file cannot break resolution.
- **Live text assertions against the core (1 file, 4 checks).** `work-loop-v2-slice-1.test.sh:266-274` asserts only the § 3 hand-off token `Correct once — frozen findings:` and that neither runtime artifact duplicates it. It asserts nothing about `:9-10`. No test asserts the authority line or the `Status:` line — `git grep "draft for operator approval" -- logs/scripts/` → no match.
- **Live pointers, no authority claim (4).** `docs/work-loop-spec.md:11`, `docs/qc-independence.md:27`, `docs/ai-resource-development-playbook/RESOURCES.md:10,26`, `docs/emailos-mvp-learning/RESOURCES.md:10`. Each names the core as the v2 authority; none restates or depends on the subordination line.
- **Historical / evidence-only (the remaining ~78).** `logs/friction-log.md` (34 matches), session-notes and decisions archives, session plans, run JSON, spike transcripts, closed state files, prior plans. None is read at runtime.

**Live authority-bearing wording coupled to the subordination line — one, and it is not scheduled by any tracer.** Core `:3` reads `**Version:** v0.1 (MVP). **Status:** draft for operator approval.` Two amendment notes, `:163-165` and `:283-285`, each state that the header "still reads **draft for operator approval** and that is deliberately unchanged." T1's own exit condition — operator approval of the T1 commit — is precisely the event that makes `:3` stale, yet T1's scope boundary is "the authority line only" and no tracer T1–T9 touches `:3`. The plan and the proposal never mention that line (`grep "draft for operator approval"` on both → no match in the proposal; the plan's only `Status:` hit is its own `:3`). This is real hidden coupling, and it is item 5's principal finding.

**No live surface duplicates the subordination.** `git grep "Proposal wins\|stays authoritative\|the Proposal"` across the command, the skill, `docs/autonomy-rules.md`, `docs/qc-independence.md` and `docs/audit-discipline.md` → no match. Nothing outside the core needs a paired edit.

### 3. Current deterministic baseline

- `logs/scripts/work-loop-v2-core-resolver.test.sh` — **4 passed, 0 failed** (check 1 linked worktree, check 2 canonical checkout, check 3 unrelated repo rejected, check 4 deployed resolver blocks byte-identical).
- `logs/scripts/work-loop-v2-slice-1.test.sh` — **308 passed, 0 failed**. Run as the regression baseline for the four core-text assertions; the plan's §3.3 caution applies (this suite is regression evidence, never proof the new text exists).

Both match the counts the frozen plan records at `:153-154`; no drift since the freeze.

### 4. Smallest exact proposed replacement

Replace `:9-10` in full with:

```
**Authority.** This file is the Work Loop's own statement of how the loop runs. It was built from
`work-loop-v2-mvp-proposal-v0.4.md`, which is recorded here as historical rationale for the design
and is not a live overriding authority. This file becomes the canonical source on the operator's
approval of the commit carrying this revision; that approval has not happened yet.
```

Conformance against the brief's five constraints: live subordination removed (no "wins", no "stays authoritative"); v0.4 retained as historical rationale only; the last sentence states approval has **not** happened; no §1 policy text and no occurrence of `pre-authorized capabilities`; no heading, section number or consumer touched — the paragraph sits above `## 1. Who does what` and the edit is four lines for two.

### 5. Seven-dimension risk evaluation of that exact change

| Dimension | Evidence |
|---|---|
| **Usage cost** | Negligible. One paragraph in one file; the two suites that must re-run take seconds and are hermetic. |
| **Permissions surface** | None. No hook, settings file, permission entry, script or executable is touched. The core is prose read by a resolver that only checks the path. |
| **Blast radius** | Bounded to the 4 path-binding consumers plus the 4 slice-1 text assertions, all enumerated above. Path binding is unaffected by text; the assertions target § 3, not § 0. The ~78 historical references are not read at runtime. |
| **Reversibility** | Full. A single-paragraph edit in a tracked file; `git revert` restores it exactly. Nothing is deleted, moved or overwritten. |
| **Hidden coupling** | **One found, unscheduled.** Core `:3` `**Status:** draft for operator approval`, load-bearing for the `:163-165` and `:283-285` amendment notes. The proposed text is *consistent* with `:3` at commit time (both say approval is pending), so nothing breaks on landing — but the moment T1's exit condition is met, `:3` contradicts the approved authority paragraph and the two amendment notes become misleading. No tracer owns that follow-up. |
| **Principle alignment** | Aligned. Proposal §14 item 1 asks for exactly this and no more; plan §3.1's failure behavior forbids bundling §1, which the `pre-authorized capabilities` negative check enforces. The change also removes the pre-existing `:10` vs `:402` contradiction. |
| **Problem reality** | **Observed, not inferred.** The subordination line is present verbatim at `:10` and was read directly. The contradiction at `:402` was read directly. The `:3` coupling was read directly. The count discrepancy in §2 was reproduced by re-running the plan's own primitives. |

**Remaining before implementation — two items for the reviewer and the operator:**

1. **Operator decision (unavoidable, by design).** T1's exit condition is the operator approving the exact implementation commit. Proposal §14 item 1 makes that approval the thing that confers canonicity, so the tracer cannot self-close. Nothing here changes that.
2. **Scope question for the reviewer, not for the implementing unit.** The `:3` staleness above needs an owner. Three options: (a) leave `:3` alone and record the staleness as an accepted limitation carried to T2; (b) widen T1 by one line to make `:3` conditional on approval, which crosses T1's stated "authority line only" boundary; (c) schedule a follow-up tracer between T1's approval and T2. Recommendation is (a) — it keeps the frozen T1 boundary intact and the fix naturally belongs with T2, which already edits the file after approval. Choosing (b) reopens the frozen plan and should not be decided silently by the implementing unit.

**Safety condition.** None of this authorizes T2. `pre-authorized capabilities` must be absent from the core before and after T1; a match after means T2 leaked into T1.

### 6. Fail-capable implementation evidence for the later execution unit

Run from the repository root, with `CORE=plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`:

| # | Check | Before (measured now) | Required after |
|---|---|---|---|
| a | `grep -c "the Proposal wins" "$CORE"` | `1` | `0` — a no-op edit leaves it at 1 and fails |
| b | `grep -c "pre-authorized capabilities" "$CORE"` | `0` | `0` — a match means T2 leaked into T1; this is a scope violation, not a success |
| c | `bash logs/scripts/work-loop-v2-core-resolver.test.sh` | `4 passed, 0 failed` | identical — proves no consumer's embedded resolver drifted |
| d | `bash logs/scripts/work-loop-v2-slice-1.test.sh` | `308 passed, 0 failed` | identical — regression only, not proof of the new text |
| e | `git diff --stat HEAD -- "$CORE"` | (clean) | exactly `1 file changed`; `git diff -U0 HEAD -- "$CORE"` must show one hunk whose `@@` header starts inside `9,2`, confining the change to the authority paragraph |
| f | `git diff --name-only HEAD` | (clean) | `$CORE` and the state file only — no consumer, plan, proposal or test file appears |
| g | `sed -n '3p' "$CORE"` | `**Version:** v0.1 (MVP). **Status:** draft for operator approval.` | byte-identical, proving T1 did not silently widen into the `:3` coupling |

Check (a) fails a no-op, (b) fails a scope leak, (e) and (g) fail an over-wide edit, (c) and (d) fail a consumer break. Each can return the failing value, so none is ceremonial.

**Recommendation: safe to implement as bounded, with one operator decision outstanding.** The change is one paragraph, fully reversible, has no permissions or runtime effect, and its blast radius is four path-binding consumers that cannot be disturbed by text. The only substantive finding is the `:3` coupling, which does not break anything at commit time and is answerable by the recorded-limitation route (option a) without reopening the frozen plan. Correct the two inventory counts in the plan's §2 before briefing the reviewer, per `qc-independence.md:37`.

**Deferral noticed, not done:** the frozen plan's §2 inventory states 60 and 21 tracked hits where the same commands now return 87 and 29. Correcting the frozen plan is outside this unit's read-only scope and outside T1's "this file only" boundary, so it is recorded here rather than applied.

## Blocker
None.

## Next action
Codex: assess the T1 review payload above. Decide (i) whether the proposed `:9-10` replacement text is accepted as the bounded T1 change, (ii) which of the three `:3` coupling options is taken — recommendation is (a), record as an accepted limitation carried to T2 — and (iii) whether the plan's §2 inventory counts (60 → 87, 21 → 29) are corrected before the risk-aware review is briefed, given `qc-independence.md:37`. Then either brief the T1 implementation unit or hand the outstanding operator decision to the operator. T1 implementation has not begun and the core is unedited.
