---
task: autonomy-authority-capability
turn: codex
---

## Objective and scope
Implement and verify the approved autonomy/authority/capability proposal through the research-corrected implementation plan.

The operator wants implementation to proceed under the compact Axcíon Standard Implementation Workflow. `/implementation-triage` remains explicitly excluded. The existing Work Loop is the sole runtime state; the research report is evidence, not parallel runtime state.

## Lane and unit
Standard. Discovery mode. Unit 15 — verify T2's premises and prepare the exact coherent core-diff payload for its risk-aware review.

Named reason for the loop: T2 changes the Work Loop's canonical autonomy and operator-boundary semantics across a shared authority document, so the frozen plan requires one premise-verified risk-aware review before implementation.

## Brief
T1a is accepted and T2 is now unblocked. Before any T2 edit, this unit must derive and verify one exact proposed core diff that appends the approved governing rule as § 8 and reconciles all five categorical gates while preserving every genuine operator-reserved and mandatory-stop class; implementation follows only after a fresh isolated Codex review accepts that payload.

Governing authority:

- Re-frozen implementation plan at status-record commit `e45a581f89291ff45ec263d35d9b38e65117b3e2`, plan blob `7b254fcbaeda669ecb8a300e72d9bb5203619505`; § 3.2 and the Execution Plan's T2 entry govern this unit as one coherent resulting core blob.
- Approved proposal content at commit `d8a89e0f7d4444bc1d3cabb963a6f49cdfc1ce67`, blob `39c67196dcec35a1be8f4fcf8ea3ef6a50cfde0b`; proposal § 1 supplies the verbatim rule, § 4 rejects consequence as an automatic operator gate, and § 6 supplies the complete protected class set.
- T1a implementation commit `6d530039657b8b6ee1a49c8ab3d2f25173140e4c`, resulting core blob `82f119cd63c379b24f0bef8aab029ae04c165203`.
- `docs/qc-independence.md` § Risk-aware review governs premise verification and the seven dimensions.

Required outcome: return one self-contained review payload containing the exact proposed core text and predicted diff for both inseparable halves of T2: (1) append proposal § 1 verbatim as new `## 8. The governing autonomy rule` after existing § 7 without renumbering, retitling, or reordering §§ 1–7; and (2) replace all five identified categorical consequence/hard-to-reverse gates so consequence scales containment and evidence rather than automatically transferring the decision, while every proposal § 6 operator-reserved and mandatory-stop/handback class remains explicitly represented in reconciled core § 7. Do not implement or decide the review verdict.

Claims to verify against the repository:

1. The current core is exactly T1a blob `82f119cd63c379b24f0bef8aab029ae04c165203`, with its canonical header and T1 authority paragraph intact, and T1/T1a commits identifiable.
2. Extract proposal § 1 from the approved commit/blob, not from memory; report its exact text, byte length and digest, and prove the working proposal copy is semantically identical or report any difference. The predicted § 8 body must be byte-for-byte that extracted clause.
3. Extract proposal § 4 and both complete proposal § 6 class lists from the approved content. Enumerate every operator-reserved-decision class and every mandatory-stop/handback class without combining away a distinct protection.
4. Locate and quote all five current bare gate strings in the live core by stable heading and exact text: `and any decision that is hard to reverse`; `Genuinely consequential work stops and goes to the operator instead`; `The change would be hard to reverse.`; `Anything else that is genuinely consequential.`; and `is the answer for consequential situations`. Confirm whether any sixth semantically equivalent categorical gate exists in the whole core; bound the patterns used.
5. Confirm the live core has exactly seven numbered headings in order, no `## 8.`, no `pre-authorized capabilities`, and no heading/title collision with the proposed title.
6. Run every cited baseline script and report command, exit code and summary: `bash logs/scripts/work-loop-v2-core-resolver.test.sh` and `bash logs/scripts/work-loop-v2-slice-1.test.sh`.
7. Inventory tracked live consumers that quote, parse, cite, or semantically rely on core §§ 1, 2, 7, the five gate strings, the section count/titles, or the proposed § 8 destination. Distinguish live consumers from frozen-plan/history evidence and state the searched paths/patterns/counts. The inventory belongs in this payload, not in the reviewer.

Exact proposed-diff requirements:

- Draft the literal replacement prose for every changed current clause and the complete appended § 8. Attribute any implementation wording choice that the proposal/plan does not literally settle.
- Provide a proposal-§6 coverage matrix mapping each protected class one-to-one to the exact proposed core § 7 clause(s). A keyword hit is not coverage; explain why the meaning remains.
- Show the predicted zero-context diff, its exact hunk count, and an exclusion proof that the T1 authority paragraph, T1a header/notes, headings §§ 1–7, and every byte outside the enumerated replacements plus appended § 8 are unchanged.
- Prove the proposed core contains exactly one copy of proposal § 1, at § 8; exactly eight numbered headings 1–8; and none of the five bare gate strings.
- Identify any wording ambiguity, missing protected class, consumer conflict, or scope consequence that requires revision or an operator decision rather than reviewer inference.

Required risk payload: for each of usage cost, permissions surface, blast radius on other components, reversibility, hidden coupling, principle alignment, and problem reality, state the concrete exposure, primitive evidence, and available safeguard. The blast-radius and hidden-coupling analysis must use the consumer inventory and must distinguish changed policy semantics from unchanged transport/capability enforcement.

Required fail-capable evidence design for implementation:

1. `pre-authorized capabilities` absent before and present after, with the approved § 1 body verified verbatim and exactly once.
2. T1 authority paragraph and T1a status header/dated notes byte-identical before and after.
3. Exactly eight numbered headings in order; §§ 1–7 titles byte-identical; § 8 title unique.
4. Five independent post-edit absence checks, one for each bare categorical string.
5. Human/reviewer semantic confirmation of the complete proposal-§6 coverage matrix against the resulting core § 7.
6. Whole-file exclusion proof allowing only the enumerated replacements and appended § 8; it must fail under an injected unrelated edit.
7. Both resolver and slice-1 suites green after implementation.

Scope: read-only repository investigation, temporary untracked scratch material only if needed to render the predicted diff, and this state-file handback. Do not edit the core, proposal, plan, skill, command, autonomy rules, session plan, carrier, dispatcher, tests, or any consumer. T3, T3a, T4 and later tracers remain outside this unit because they depend on the final T2 core text.

Completion condition: return the full premise-verified exact-diff and risk-review payload, set `turn: codex`, commit only this state-file handback, and stop. This is Discovery mode; do not implement T2.

Stop conditions: hand back a false premise if the approved proposal extraction, current core baseline, five-gate inventory, complete § 6 coverage, consumer inventory, or cited tests differ materially from the frozen plan. Stop for the operator only if the evidence exposes a real authority, scope, or accepted-risk decision; otherwise expose the unresolved choice for the fresh reviewer.

## Latest result

Inspected (2026-08-14):

- Claim (1): HOLDS — `git hash-object` and `git rev-parse HEAD:` on `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` both return `82f119cd63c379b24f0bef8aab029ae04c165203`; `git status --porcelain` on that path returns nothing (clean, 24802 bytes, 477 lines). `git log -- <core>` identifies T1 = `5fef08fff11a1009b30d925f49d68844fc4e2f03` and T1a = `6d530039657b8b6ee1a49c8ab3d2f25173140e4c`; `git rev-parse 6d530039:<core>` = the same blob. Canonical header (line 3) and T1 authority paragraph (lines 9–12) present and intact.
- Claim (2): HOLDS — `git cat-file blob 39c67196…` extracted from commit `d8a89e0f…` at `plans/work-loop-v2-v0.2/…-proposal-v0.1.md` (35402 bytes, 534 lines). Proposal § 1 = lines 11–28; content 13–26, 1869 bytes, sha256 `fa60275375569bed934c9f7d3d2e2d048d244229294cdff9017e2f2f547ee6da`. The governing-rule clause is line 15 alone, 588 bytes, sha256 `51552195d73e42e0ef15b13904ad8d0d5cbb52d0447df5812a202727da182b80`, and is the only place `pre-authorized capabilities` occurs. `diff -u` of the approved blob against the working copy returns exactly one hunk, on the `**Status:**` line (line 3); §§ 1–16 are byte-identical. So the working copy is a safe extraction source for § 1. **See open question A** — the brief says "append proposal § 1 verbatim" while plan § 3.2/T2 say "the proposal §1 **clause** verbatim"; these are not the same bytes.
- Claim (3): HOLDS — proposal § 4 (lines 107–132) and both § 6 lists (§ 6 at lines 181–238) extracted from the approved blob. § 4 states consequentiality "should not be treated as an autonomous authority level or an automatic operator gate". § 6 carries **9** operator-reserved-decision classes and **7** mandatory-stop/handback classes, enumerated one-to-one in the coverage matrix below; none combined.
- Claim (4): HOLDS, with one mechanical qualification. All five gates located: L26 `and any decision that is hard to reverse`; **L59–60** `Genuinely consequential work stops and goes to the operator instead` — this one **spans a newline** after `Genuinely`, exactly as the frozen plan's own "lines 59–60" reference implies, so a literal single-line grep finds 0 matches; L469 `The change would be hard to reverse.`; L475 `Anything else that is genuinely consequential.`; L477 `is the answer for consequential situations`. **No sixth categorical consequence gate exists.** Bounded by `grep -n -iE 'consequen|hard to reverse|irreversib'` (7 hits: the five gates plus L157–158, which is the already-proposal-aligned "evidence is scaled to consequence" clause) and a full `grep -n -i 'operator'` enumeration (21 hits, all read). Two near-misses examined and excluded: L246 (correction menu → operator "about accepting risk") is an accepted-risk gate the proposal **retains**; L450 (§ 6 rule 4, "a change to scope goes to the operator") is a scope gate, not a consequence gate — **see open question C**.
- Claim (5): HOLDS — `grep -nE '^## [0-9]+\.'` returns exactly 7 headings, numbered 1–7 in order (16, 40, 64, 251, 416, 438, 456). `grep -n '^## 8\.'` → no match. `grep -n -iE 'pre.?authoriz|pre.?authoris'` → no match. `grep -n -i 'governing autonomy'` → no match, so the proposed title does not collide. (Note for the evidence design: a bare `^## ` count returns 26, because the closing-record template and the example state file carry `##` headings inside fenced blocks. The numbered-heading pattern is the one that discriminates.)
- Claim (6): HOLDS — `bash logs/scripts/work-loop-v2-core-resolver.test.sh` → exit 0, **4 passed, 0 failed**. `bash logs/scripts/work-loop-v2-slice-1.test.sh` → exit 0, **308 passed, 0 failed**.
- Claim (7): HOLDS — inventory below. Searched all tracked files with `git grep` on `core §|core section|executable-core-v0\.1\.md` (**143 files**), plus `hard to reverse`, `genuinely consequential`, `consequential work stops`, `pre.?authoriz`, `^## [0-9]+\.` and `CORE_F`. **8 live consumers, 135 history/evidence.**

---

## T2 REVIEW PAYLOAD — read-only; nothing in the repository was changed

Rendered in scratch only (`…/scratchpad/u15/`), never in the repo. Base = live core blob `82f119cd…`.

### 1. Exact proposed core text — 9 zero-context hunks in one file

```diff
@@ -26 +26 @@
-**The operator** owns priorities, scope, and any decision that is hard to reverse.
+**The operator** owns priorities, scope, and the decisions § 7 reserves to them.
@@ -59,2 +59,3 @@
-Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Genuinely
-consequential work stops and goes to the operator instead (§ 7).
+Two lanes exist in this version: **Direct** and **Standard**. There is no third lane. Higher
+consequence does not open one: inside the approved envelope it raises containment, evidence and
+review (§ 3), and the work stops for the operator only on a trigger § 7 names.
@@ -458 +459,3 @@
-Stopping is a normal outcome. Each trigger below names who to stop for.
+Stopping is a normal outcome. Each trigger below names who to stop for. Consequence is not itself a
+trigger: inside the approved envelope, higher consequence raises containment, evidence and review
+(§ 3, § 8). What stops the work is a named trigger below.
@@ -462,0 +466 @@
+- A load-bearing premise is still unsupported after bounded investigation.
@@ -463,0 +468 @@
+- The approved plan is materially invalid, and repairing it would go outside the solution envelope.
@@ -464,0 +470 @@
+- A required load-bearing verification cannot be produced.
@@ -469 +475,15 @@
-- The change would be hard to reverse.
+- The intended outcome or the priority would change.
+- The scope would expand materially, or an exclusion would be removed.
+- A product or business behaviour must be chosen that existing authority does not determine.
+- The approved operating model, a material architecture commitment, the cost or risk profile, or the
+  governance model would change.
+- Material residual risk would have to be accepted that is not already delegated.
+- The workspace or plan capability envelope would have to expand.
+- The capability the work needs is not granted, or cannot be enforced safely.
+- Production deployment, public or customer communication, credential use, or destructive action on
+  shared state would be authorised, and no separate explicit delegation already covers it.
+- Operator intentions are genuinely tied or in conflict.
+- Governing sources remain materially tied after the authority hierarchy has been applied.
+- The policy governing agent authority would change materially.
+- Continuing would require inventing operator intent.
+- Continuing would bypass, weaken, or self-expand the control system.
@@ -475 +494,0 @@
-- Anything else that is genuinely consequential.
@@ -477 +496,7 @@
-In this version, "stop and bring this to the operator" is the answer for consequential situations.
+In this version, "stop and bring this to the operator" is the answer when a trigger above is met.
+
+---
+
+## 8. The governing autonomy rule
+
+> **Within the approved solution envelope, resolve what evidence can resolve, exercise professional technical judgment, and use only pre-authorized capabilities. Consequence increases containment and verification; it does not by itself transfer the decision to the operator. Escalate only when continuing requires operator-owned intent, accepted risk, a material change outside the solution envelope, or expansion of the authorized capability envelope. Stop when a load-bearing premise or required verification cannot be established, or when continuing would bypass the control system.**
```

Resulting file: 502 lines, 26973 bytes. The three unchanged operator triggers (settled decision reopened; stale/foreign state file; correction-not-enough/accepting risk) survive verbatim at new lines 490, 491–492, 493–494; the `**Stop for the operator** — … set \`turn: operator\`, commit, and stop:` sentence at old 466–468 is untouched, which is what `carry-turn.sh` relies on.

### 2. Wording choices this unit made — attributed, not settled by the proposal or the plan

1. **§ 8 title `The governing autonomy rule`.** Plan § 3.2 permits "an equivalent title"; taken from proposal § 1's own phrase "one governing autonomy rule".
2. **§ 8 body = the blockquote clause only** (proposal line 15), not all of § 1. **This is open question A — the single largest choice in this payload, and Codex or the operator should settle it, not infer it.**
3. **Destination split for the 7 mandatory-stop classes.** Proposal § 6 groups them as "stop **or** handback" without assigning either. This draft sends (a) unsupported premise, (b) materially invalid plan, (c) unproducible verification to **Codex**, and (d) ungranted/unenforceable capability, (e) inventing intent, (f) bypassing the control system, (g) materially tied governing sources to the **operator**.
4. **Line 26 pointer wording** — `the decisions § 7 reserves to them`, chosen so § 1 names the owner without restating the list.
5. **Hunk 2 wording** is constrained: `There is no third lane` must stay intact on its line (live test lock — see inventory).
6. **The § 7 preamble sentence** naming consequence as not-itself-a-trigger is new prose, not in the proposal.

### 3. Proposal § 6 coverage matrix — one-to-one, by proposed line

**Operator-reserved decisions (9/9).**

| # | Proposal § 6 class | Proposed core § 7 | Why the meaning survives |
|---|---|---|---|
| 1 | changing the intended outcome or priority | L475 | both objects kept; "would change" replaces "changing" |
| 2 | material scope expansion or exclusion removal | L476 | both halves kept, materiality kept on the expansion half |
| 3 | product/business behavior not determined by existing authority | L477 | "existing authority does not determine" is the same test, active voice |
| 4 | operating model, material architecture commitment, cost/risk profile, governance model | L478–479 | all four objects enumerated, none merged |
| 5 | accepting material residual risk not already delegated | L480 | both qualifiers ("material", "not already delegated") kept |
| 6 | expanding the workspace or plan capability envelope | L481 | both envelopes named |
| 7 | production deployment / public or customer communication / credential use / destructive shared-state action, unless separate explicit delegation | L483–484 | all four acts plus the delegation carve-out |
| 8 | resolving genuinely tied or conflicting operator intentions | L485 | kept **separate** from class (g) below, which is about sources, not intentions |
| 9 | approving a material change to the policy governing agent authority | L487 | materiality kept |

**Mandatory stop or handback (7/7).**

| # | Proposal § 6 class | Proposed core § 7 | Why the meaning survives |
|---|---|---|---|
| a | load-bearing premise unsupported after bounded investigation | L466 (Codex) | kept **separate** from L465's narrower "a claim the brief rests on is false" so neither absorbs the other |
| b | approved plan materially invalid, repair exceeds the solution envelope | L468 (Codex) | both conditions kept conjunctive |
| c | required load-bearing verification cannot be produced | L470 (Codex) | kept **separate** from L469's existing broader "required evidence cannot be produced" |
| d | needed capability not granted or cannot be enforced safely | L482 (operator) | both failure modes kept; distinct from class 6's envelope *expansion* |
| e | continuing would require inventing operator intent | L488 (operator) | verbatim-equivalent |
| f | action would bypass, weaken, or self-expand the control system | L489 (operator) | all three verbs kept |
| g | governing sources materially tied after applying the authority hierarchy | L486 (operator) | verbatim-equivalent; distinct from class 8 |

No keyword-only matches were counted as coverage; every row above is a whole-clause mapping.

### 4. Fail-capable evidence — run against BEFORE (live core) and AFTER (predicted core)

| Check | Before | After | Verdict |
|---|---|---|---|
| E1 `pre-authorized capabilities` count | 0 | 1 | PASS |
| E1 § 1 clause present byte-identical, exactly once (`grep -Fxc`) | 0 | 1 | PASS |
| E2 header L3, T1 authority L9–12, T1a notes L165–167 / L285–287 sha256 | — | identical | PASS ×4 |
| E3 numbered headings `^## [0-9]+\.` | 7 | 8, in order 1–8 | PASS |
| E3 headings 1–7 title text byte-identical | — | identical | PASS |
| E3 `^## 8\. The governing autonomy rule$` unique | 0 | 1 | PASS |
| E4 d-i … d-v, five bare gates checked individually (flattened) | 1 each | 0 each | PASS ×5 |
| E6 whole-file exclusion proof: exactly the 9 enumerated hunks | — | exact match | PASS |
| E7 resolver suite / slice-1 suite on the live tree | 4/0 · 308/0 | — | PASS |

**The exclusion proof is proven able to fail:** injecting one unrelated edit at line 100 of the predicted core makes the hunk list 10 with an extra `@@ -99 +100 @@`, and E6 reports FAIL.

**Defect in the plan's own evidence design (open question D).** Plan § 3.2 (d-ii) and T2 (d) specify a literal verbatim check for `Genuinely consequential work stops and goes to the operator instead`. Run literally, that grep returns **0 on the live core before any edit**, so "must not match after" passes no matter what T2 does — it cannot fail, which core § 6 rule 5 forbids. Proven: unflattened `grep -c` = 0, flattened `tr '\n' ' ' | grep -c` = 1. The fix is mechanical — flatten the file before matching, as `logs/scripts/work-loop-v2-slice-1.test.sh` already does for the same reason (`core_flat()` at L568, `flat_of()` at L1300) — but it changes a check the frozen plan states literally, so it is Codex's call, not an implementation detail.

### 5. Live-consumer inventory — 8 live, 135 history

Method: `git grep` over all tracked files. Patterns: `core §|core section|executable-core-v0\.1\.md` (143 files), then `hard to reverse`, `genuinely consequential`, `consequential work stops`, `pre.?authoriz`, `^## [0-9]+\.`, `CORE_F`.

**Live consumers (8).**

| Consumer | What it relies on | Effect of this diff |
|---|---|---|
| `logs/scripts/work-loop-v2-slice-1.test.sh` | **12 assertions read the core file** (`CORE_F`, L266–1314) | All 12 re-run **PASS** against the predicted text. Two are hard locks on hunk 2's line: `There is no third lane` (L1278) and, flattened, `feels significant` (L568–570). Also locked and unaffected: 5 state-file fields, no `^## Mode`, no `^mode:`, `Correct once — frozen findings:`, `^### Continuing`, `\| \*\*Continue\*\*`, `\| \*\*Mode\*\*`, the Lane-and-unit row naming mode, the NOCOPY mode sentence, `discovery unit` present / `adoption unit` absent. |
| `logs/scripts/work-loop-v2-core-resolver.test.sh` | path and byte-identity of the resolver **blocks**, not core content | unaffected; green |
| `.claude/commands/work-loop-v2.md` | cites core § 1, § 2, § 6 r2, § 7 by number | unaffected — no renumbering; T3 owns its wording |
| `.agents/skills/work-loop-v2/SKILL.md` | **L508** "Decide anything hard to reverse — that is the operator's, via core § 7" and **L473** "a consequential or hard-to-reverse claim (core § 7)" | **these go stale the moment T2 lands** — by design; frozen plan **T3a** owns exactly this. Sequencing to confirm, not a T2 defect. L168/L330/L383–384/L502/L506–507 unaffected. |
| `.agents/skills/work-loop-v2/references/routing-index.md` | core § 1 (no second state system) | unaffected |
| `scripts/axcion-harness-v0.2/carry-turn.sh` (+ `.test.sh`) | core § 4 shape; core § 7's `turn: operator` **terminality** and the `## Blocker`/`## Next action` question shape | unaffected — the `**Stop for the operator** — … set \`turn: operator\`` sentence and both headings are outside every hunk |
| `docs/qc-independence.md` L25–27 | core § 2's narrow admission and Direct-Work default | unaffected — hunk 2 changes only the consequence sentence; `Direct Work is the default` (L42) and the admission rule are untouched |
| `logs/scripts/work-loop-owner.sh` + `workflows/research-workflow/logs/scripts/work-loop-owner.sh` | no core content | unaffected |

**History / evidence, not consumers (135):** `plans/` 68 · `logs/work-loop/` 23 (state files and fixtures) · `logs/session-plan-*` 17 · `docs/` playbook and run-card pages 6 + `docs/work-loop-spec.md` (retired v1) · `logs/runs/` 5 · `audits/` 4 · `logs/decisions*` 3 · `logs/session-notes*` 2 · `logs/friction-log.md`, `logs/improvement-log.md`, `logs/missions/work-loop-v2-mvp.md`.

### 6. Risk payload — seven dimensions

| Dimension | Concrete exposure | Primitive evidence | Available safeguard |
|---|---|---|---|
| **Usage cost** | one file, one commit; the cost is the review itself, not the edit | 9 hunks, 24802 → 26973 bytes, no other file | payload is pre-rendered; implementation is mechanical replay |
| **Permissions surface** | none | no settings, hook, capability grant, script or `.git` behaviour in any hunk; scope boundary "this file only" | exclusion proof fails on any out-of-hunk byte |
| **Blast radius** | 8 live consumers; 1 (`SKILL.md` L473/L508) is intentionally invalidated | 12 core-reading test assertions re-run PASS; carry-turn's § 7 reliance is on `turn:` terminality, which is outside every hunk | T3a already scheduled for the SKILL.md gate; re-run both suites post-edit |
| **Reversibility** | fully reversible | single file, single commit, no migration, no state, no consumer edit | `git revert` restores blob `82f119cd…` exactly |
| **Hidden coupling** | two found, both mechanical, both handled | (i) `There is no third lane` shares line 59 with gate 2 → hunk 2 must preserve it byte-for-byte; (ii) gate 2 spans a newline → any literal gate grep must flatten first | both encoded in the predicted text and in the E4/lock checks above |
| **Principle alignment** | the core stops stating two contradictory rules; one knowing divergence remains | live core asserts consequence-transfers-decision at 5 sites vs approved proposal § 4 "not … an automatic operator gate" | the divergence is **open question B**, to be accepted explicitly rather than absorbed |
| **Problem reality** | real, not speculative | the five gate strings exist at L26, L59–60, L469, L475, L477 in the canonical, operator-approved core | — |

This analysis separates **changed policy semantics** (who decides, and when work stops) from **unchanged transport and capability enforcement**: `carry-turn.sh`, `work-loop-owner.sh` and the resolver govern how turns move, who commits and which checkout owns a task, and **no hunk touches any behaviour they read**.

### 7. Open questions for the reviewer — not decided here

- **A — what exactly is "verbatim"?** This unit's brief says "append proposal § 1 verbatim"; frozen plan § 3.2 and T2 both say "the proposal §1 **clause** verbatim". They differ by 1281 bytes. This draft carries the **blockquote rule only**, because plan evidence (a) keys on `pre-authorized capabilities` (which lives only in the blockquote) and the § 8 title matches proposal § 1's own words. Appending all of § 1 instead would put three proposal-voice statements into the canonical core: "Work Loop v2 **should adopt** one governing autonomy rule", "This rule **should become part of** the canonical executable core after that core's formal authority status is resolved" — which would have the core say the rule is not yet part of itself — and a release-posture paragraph on the attended carrier that T2's scope boundary does not cover. **Codex or the operator settles this; the reviewer should not infer it.**
- **B — the catch-all is removed.** Deleting `Anything else that is genuinely consequential.` makes § 7's operator list **closed**. A novel situation not on the list no longer routes to the operator by default. Proposal § 6 is presented as the *concrete* authority boundary, so this is the intended direction, but it is a real reduction in the safety net and should be accepted knowingly, not as a side effect.
- **C — core § 6 rule 4 is now in tension with § 7.** L450 says, unqualified, "a change to scope goes to the operator", while the reconciled § 7 reserves *material* scope expansion (proposal § 6 class 2). This is a scope gate, not one of the five consequence gates, and it is not in the frozen plan's enumerated replacement list. **Not touched here.** Recommend a deferral or a new tracer rather than widening T2.
- **D — the plan's d-ii check cannot fail as written** (§ 4 above). Needs a flattening correction to the frozen plan's verification text, which is Codex's call.
- **E — deferrals carried forward, unchanged and non-blocking:** the proportionality/continuity plan's stale future-amendment instruction (gated before that plan's S2/amendment-discipline execution); the stale row in the unapproved resource-capability development plan; the autonomy plan's known §14 item-6 wording inconsistency.

## Blocker
None.

## Next action
Codex: run the fresh isolated risk-aware review of the T2 payload above — both halves as one coherent core blob. Settle open questions A (clause scope), B (accepting the closed operator list), C (route § 6 rule 4 to a deferral or a new tracer) and D (correct the frozen plan's unfailable d-ii check) before authorising implementation. Confirm T3a still owns the `SKILL.md` L473/L508 staleness. Then either return the accepted payload for implementation or hand back findings.
