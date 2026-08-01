# Step 6 — candidate review record

**Status: IN PROGRESS. Blocked on one operator decision (finding C, § 6 below).**
Do not tick the mission's Step 6 thread until that decision is made and acted on.

**Written:** 2026-08-01, session S9-6ba. **Resumes:** next session.

This record is self-contained on purpose. It assumes the reader has no memory of the session that
produced it and has not read the review brief or the findings file.

---

## 1. What Step 6 is

Step 6 is the **one serious candidate review** of the finished Work Loop v2 MVP, run exactly once on
the complete candidate as a single object. Its protocol (`pocock-lifecycle-work-loop-mvp-v0.4.md`
§ Step 6) is strict, and three parts of it constrain what next session may do:

1. The candidate is **frozen by exact commit**. Approval attaches to reviewed bytes, never to a name.
2. Material findings are named A, B, C and the **correction scope freezes there**. Claude corrects
   exactly those in **one pass**.
3. The closure check verifies A, B, C plus blocking regressions **only**. It does not restart a broad
   review. D, E, F do not get discovered. Newly noticed non-blocking things become deferrals.

The mission's non-negotiables reinforce this: *"Do not run a second broad review after a
correction"* and *"Do not add a review layer, gate, or governance step beyond the one fresh-context
candidate review."*

**Done when:** the candidate is accepted and the limitations list is written.

## 2. The candidate, and which bytes were reviewed

**Reviewed at commit `cc443e1`.** The reviewer verified these blob hashes before starting:

| File | Blob hash reviewed |
|---|---|
| `.claude/commands/work-loop-v2.md` | `af411f203ada638fa9d4d459a1043ea87e0837aa` |
| `.agents/skills/work-loop-v2/SKILL.md` | `e6650fc7512b1d3036c576b063dc7450fd10aed1` |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` | `baf753b1b87e147bbb43a021fb17d821e35d5ac9` |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | `06b5b17377a1ef5c2db9d72bad49801356d7da68` |

**The candidate has since moved.** Corrections for findings A and B landed at `edd0d97`, and the
finding C correction at `fc6c07c`. `cc443e1` is the *reviewed* commit and is not the accepted one.

### ✅ ACCEPTED CANDIDATE — commit `fc6c07c`

Accepted 2026-08-01, session S10-7e5, after the closure check cleared on live evidence
(`step-6-live-verification.md`). **Approval attaches to these bytes, never to a name:**

| File | Lines | Blob hash accepted |
|---|---|---|
| `.claude/commands/work-loop-v2.md` | 113 | `82ff6ebb79ccd63b28407298118ac964eef3dba1` |
| `.agents/skills/work-loop-v2/SKILL.md` | 116 | `7eb64cb851756d81ad9dd1041a1ee7e93dc06918` |
| `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` | 293 | `4790ede0ff1d4939e7320bc800e0fb8b351fbb06` |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | 673 | `19ede0ec380658eba516492d131747b1889ca70a` |

Verify with `git hash-object <path>`. If any differs, a new candidate exists and this acceptance does
not cover it. Acceptance state: harness **149 passed, 0 failed, exit 0**; three findings corrected;
two live invocations of the corrected prompts passed.

**Who reviewed.** Codex, fresh context, briefed by `step-6-review-brief.md`. Claude authored all four
candidate files and was therefore ineligible (`qc-process-v0.1.md` rule 2: the author does not grade
its own work). The review did **not** run through `$work-loop-v2` — running the candidate review
through the candidate would be self-hosting, forbidden by Proposal § 6.

## 3. Verdict and findings, as returned

Full text: `step-6-review-findings.md`.

> **Accept with corrections** — the frozen candidate is close to pilot quality and its harness passes
> 142/142, but the three material findings below must be corrected before acceptance.

**A — The operator↔Codex routing contract is internally inconsistent at both task entry and
hand-off.** Core § 4 and `SKILL.md:16` said the state file is the only interface between Codex,
Claude *and the operator*, while `SKILL.md:44` requires Codex to question the operator before that
file exists. `SKILL.md:20-24` required every reply to send the operator to Claude regardless of the
`turn:` just written. *Consequence: new work cannot enter reliably, and operator-owned decisions can
be routed to the wrong actor, silently stopping or bypassing the protocol.* Dimension 1.

**B — The harness does not actually test that the two-file Direct Work request created no state
file.** The assertion only checked that no filename under `logs/work-loop/` contained the word
`direct`. *Consequence: behaviour 3.1(a) can regress to opening loop state for Direct Work while the
full harness stays green.* Dimension 1.

**C — Both runtime artifacts restate executable-core policy instead of linking it.** Each says it
does not restate the core, then repeats universal rules for admission, state-file shape, evidence,
false premises, correction, closure and role limits (`work-loop-v2.md:19-110`; `SKILL.md:14-106`).
*Consequence: the core is no longer the single policy owner, models pay the attention cost three
times, and future corrections can leave conflicting executable instructions in place.* Dimension 2.

## 4. Corrections completed — A and B

Committed at **`edd0d97`**. Harness **136 → 143 assertions, exit 0**.

**A — corrected.** Three edits:
- `work-loop-v2-executable-core-v0.1.md` § 4 now says the state file is the only interface **between
  Codex and Claude**, and states that the operator sits outside it. The circularity is named
  explicitly: the file is created *by* admitting a request, so it cannot also be how the request
  arrives. A refused request opens no file.
- `SKILL.md` seam section matches, and tells Codex not to wait for a state file before engaging with
  a request.
- The hardcoded `**Next:** run /work-loop-v2 in Claude` is replaced by a three-case table keyed on
  the `turn:` actually written — `claude`, `operator`, or Direct Work with no file at all.

**B — corrected, and the defect was confirmed by execution before the fix.** Planting an arbitrary
state file at `logs/work-loop/arbitrary-state.md` left all 142 assertions green, proving the reviewer
right. The predicate is now a **closed known-file set**: any state file the build did not deliberately
create fails the check. Falsifiability re-proven — with the file re-planted, 2 assertions go red
(141 pass / 2 fail); with it removed, 143 pass.

## 5. Also completed this session (not findings)

- **Behaviour 3.1(b) closed on live evidence.** Previously the weakest evidence in the build — it
  rested on artifact text plus an absent file. Codex was given the request and refused admission
  **unprompted**, naming "this feels significant" as "explicitly not a qualifying reason under the
  executable core", writing no brief, no lane and no unit, setting `turn: operator`, and routing the
  request back. Commit `6e3afa1`. The Slice 3 evidence record is updated.
- **The bare-invocation deferral, open since Slice 2, closed.** Codex resolved the open task from the
  state file alone, given only a repository path and a file path.
- **The 3.1(b) harness assertion was replaced.** It proved the behaviour by *file absence*, which
  became meaningless once the request itself had to be carried by a state file. Seven substance
  assertions replace it, read from history rather than the working tree; six were proven to go red
  against a task that *was* opened with a brief.
- **A new issue was written up:** `issue-codex-request-intake.md` — Codex could not see a
  chat-pasted request at all. Second occurrence of that class.

## 6. FINDING C — SETTLED: option 1, correct in full

**Settled 2026-08-01 (session S10-7e5) by independent verdict, not by Claude.** The operator directed
that Codex adjudicate C and stated they would not decide before an independent verdict existed. Brief:
`step-6-finding-c-adjudication-brief.md`. Verdict: `step-6-finding-c-verdict.md`.

**Codex chose option 1 — correct C fully — against Claude's recommendation of option 2.** Its grounds,
in short: the duplicated policy is executable instruction inside the two prompts that run the loop,
not documentation debt; correcting finding A removed the observed contradiction but not the mechanism
that produced it; and option 2's reopening trigger would make the pilot wait for a known
source-of-truth violation to cause harm before honouring a binding standard. On the second conflict
it ruled the remaining restatement **inconsistent application, not a judged trade-off**: Slice 3's
asymmetric assignment of *actions* by actor was sound, but it did not license restating the *rule*
each actor applies.

**Codex also corrected Claude's measurement, and it was right.** Claude reported ten positive wording
locks; the true surface is **11 positive policy-wording locks, or 14 including three section-presence
form locks**. Claude's grep filter missed line 213 because that assertion routes through the
`step1_of` helper. Re-verified by explicit line read before any edit. The correction Claude
recommended against was therefore *more* expensive than Claude had measured — and the measurement
error ran in Claude's own favour, which is the reason the brief asked for it to be re-derived.

**What was corrected.** The rule now lives in one place and the artifacts link to it:

| File | Change | Lines |
|---|---|---|
| `.claude/commands/work-loop-v2.md` | Restated policy replaced by links to the owning core sections; Claude-side mechanics, output contracts and stop behaviours retained | 114 → 113 |
| `.agents/skills/work-loop-v2/SKILL.md` | Same, Codex side; finding A's intake fix, Next-routing table, path rule and no-git boundary all preserved | 120 → 116 |
| `work-loop-v2-executable-core-v0.1.md` | Names the shared hand-off token `Correct once — frozen findings:` once, as its owner (§ 3) | 282 → 293 |
| `logs/scripts/work-loop-v2-slice-1.test.sh` | 14 positive wording/form locks rewritten as link, interface and mechanic checks | 620 → 673 |

Both runtime artifacts got **shorter**, satisfying the writing standard's final-pass rule. The core
edit is the single one Codex authorised: without it, removing the token from both artifacts would
have left an orphaned interface.

**Falsifiability — every rewritten assertion proven able to fail.** Codex required that the harness
not be made green by deletion. Three proof runs, artifacts restored from a checksummed copy after
each:

| Proof run | Result |
|---|---|
| New harness vs. **pre-correction** artifacts | **8 red** — the restatement and token-duplication checks |
| Core links and retained mechanics stripped | **8 red** — the link and mechanic checks |
| Targeted removal of the read-only rejection mechanic | **1 red** |

17 of 17 new or rewritten assertions are failing-capable. Harness after correction: **149 passed, 0
failed, exit 0** (was 143).

**One thing this correction did *not* settle** — Codex's own deferral, recorded and not done: the
writing standard's tension between "never restate the core" and its requirement that stop conditions
name their on-stop behaviour. The practical boundary used here is link the trigger, keep the
actor-specific mechanics. The standard was **not** edited during Step 6.

---

*The record below is the decision as it stood before the verdict, kept because it is what Codex was
asked to adjudicate.*

### Why it is not a simple fix

**Six harness assertions test for exactly the restatement C wants removed** — for example
`admission_cmd | grep -qi 'feels significant'` asserts that the *command* spells the rule out.
Correcting C therefore rewrites all three runtime files at once, at the freeze, with only a narrow
closure check permitted afterward. Locations: `work-loop-v2-slice-1.test.sh` lines 367, 369, 371,
377, 449, 459.

Scale: roughly 15–20 lines of the command's 114, and 25–30 of the skill's ~121. It touches nearly
every section of both.

### The three options

**1. Correct C fully.** Strip restated policy from both runtime artifacts; rewrite the six
assertions to test the *link* and the behaviour rather than the restated words. Meets the reviewer's
stated bar. Largest change at the worst moment, with the least review left to catch a mistake.

**2. Bounded correction.** The harm C names is *"the duplicated policy has already drifted into
finding A's contradictory interface and next-turn rules"* — and that drift **is** finding A, now
fixed. Record the remainder of C as a disclosed limitation with a concrete reopening trigger: **a
pilot unit in which a restated rule in either artifact contradicts the core, or in which a model
follows the artifact's copy instead of the core.** The standard itself says the pilot "remains the
only evaluation that finally counts."

**3. Accept C entirely as a disclosed limitation.** Cheapest and weakest; no reopening trigger.

### Claude's recommendation, and the reason to distrust it

**Recommended: option 2.** The demonstrated harm is fixed; the remainder is prospective; the pilot is
the natural place to find out which restatements actually cause drift.

**Stated plainly for whoever picks this up: Claude wrote the artifacts and is recommending not
rewriting them.** The reviewer rated C material and said all three findings must be corrected before
acceptance. Option 2 overrules an independent reviewer's explicit bar, and the convenient answer and
the recommended answer are the same answer. That is the condition under which the author's judgment
is least trustworthy, which is why the decision was escalated rather than taken.

This escalation is protocol-correct, not hesitation: `pocock-lifecycle` § Step 6 point 5 provides a
menu — accept a disclosed limitation, permit one final tightly bounded fix, revert, reframe, or stop
— and says **"genuine risk-acceptance choices escalate to the operator."**

## 7. The reviewer's judgment on the six known limitations

The reviewer was given these rather than left to rediscover them, and ruled on each:

| # | Limitation | Verdict |
|---|---|---|
| 1 | Codex cannot see a chat-pasted request | **Material — finding A** |
| 2 | Codex's Next instruction contradicted the turn it set | **Material — finding A** |
| 3 | Folder creation from an absent `logs/work-loop/` untested | Acceptable disclosed limitation |
| 4 | Most opening briefs were hand-written fixtures | Acceptable disclosed limitation |
| 5 | Slice 2 menu task's first pass / assessment are fixture material | Acceptable disclosed limitation |
| 6 | Claude command and harness had no independent review | Acceptable at freeze — **discharged by this review** |

Items 1 and 2 are now corrected. Items 3, 4, 5 carry into the accepted candidate's limitations list.

## 8. Deferrals recorded by the reviewer

- Exercise folder creation in an isolated checkout where `logs/work-loop/` is genuinely absent,
  before relying on that path outside this repository.
- Let the real-work pilot replace fixture confidence with operational evidence. **Do not add another
  pre-pilot review layer.**
- Revisit bare Codex task discovery only if manual task identification becomes observed pilot
  friction. *(Partly overtaken: bare discovery was demonstrated working this session.)*

## 8.5. DISCLOSED LIMITATIONS — what the pilot carries

Step 6's exit condition. Each is recorded, not hidden; the reviewer judged each an acceptable
disclosed limitation for a pilot-quality candidate rather than a material finding.

1. **Folder creation from a genuinely absent `logs/work-loop/` is untested.** The folder existed
   throughout all three slices, so the case was unconstructible. It bites only on a fresh checkout.
2. **Most opening briefs were hand-written fixtures.** Codex genuinely opening a unit was
   demonstrated in Slice 1 and again in the Step 6 admission run; Slices 2 and 3 used fixtures.
3. **Slice 2's menu task's first pass and assessment block are fixture material.** Its correction
   hand-back and closure are real.
4. **The writing standard's internal tension is unresolved** — "never restate the core" versus its
   requirement that stop conditions name their on-stop behaviour. The accepted practical boundary:
   link the shared trigger and rule; keep only actor-specific on-stop mechanics. The standard was
   deliberately **not** edited during Step 6. *Reopening trigger: pilot use shows the boundary is
   unclear or causes drift.*
5. **Core § 6 rule 2 and core § 7 contradict each other for the file-identity case.** Rule 2 says
   report and change nothing; § 7's operator-stop procedure says write the question into the state
   file, set `turn: operator`, and commit. Both cannot hold. Found by a fresh reader during live
   verification, recorded as a deferral under closure-check discipline, and confirmed **pre-existing**
   rather than correction-caused. The command resolves it toward changing nothing. *Reopening
   trigger: a pilot unit where the ambiguity produces a wrong action, or the first time the core is
   revised for any reason.*
6. **Behavioural evidence is largely historical.** Most harness assertions read outcomes from git
   history rather than re-running the prompts. Two live invocations were added at closure precisely
   because of this, but they cover two behaviours, not twelve. *Reopening trigger: the pilot is the
   real test; a behaviour that fails there should be suspected of never having been re-verified after
   a prompt change.*

Items 1–3 were carried by the reviewer from § 7. Items 4–6 were added by the finding C correction and
its closure check.

## 9. State of Step 6 — complete

**Done (session S10-7e5, 2026-08-01):**

1. ✅ **Finding C settled** — option 1, by Codex's independent verdict. § 6.
2. ✅ **The correction made** — all three runtime files plus the single authorised core edit. § 6.
3. ✅ **Regression instrument green** — 149 assertions, exit 0, every rewritten assertion proven able
   to fail first.
4. ✅ **A and B verified intact** — finding A's six markers all present in the skill (direct operator
   intake, the three-case Next table, the `logs/work-loop/` rule, the no-git boundary); finding B's
   closed-set state-file check untouched in the harness.

5. ✅ **Closure check run** — by Codex, scoped to core § 3's two questions
   (`step-6-closure-check-brief.md`). It returned **not resolved yet**: A, B and C were structurally
   resolved and the harness green, but the harness's behavioural assertions read outcomes produced by
   the *pre-correction* prompts from git history, so they could not show that a model reading the
   *corrected* prompts still behaves correctly. A fair objection, and one Claude had missed.
6. ✅ **Live verification** — Codex chose core § 3's "one final tightly bounded fix" and spent it on
   verification rather than on code. All three checks passed and **no code change was needed**:
   Claude-side foreign-state rejection (fresh-context, independently verified), Codex-side
   non-qualifying admission (verified on disk), harness 149/0. Record:
   `step-6-live-verification.md`.
7. ✅ **Accepted candidate recorded** — commit `fc6c07c` and its four blob hashes, § 2.
8. ✅ **Disclosed-limitations list written** — § 8.5, six items, each with a reopening trigger.
9. ✅ **Mission Step 6 thread ticked** with evidence.

**Step 6 is complete.** The thread was held unticked until the closure cleared on evidence; ticking
it earlier would have closed Step 6 by assertion, the failure mode this mission has already recorded
once.

Then Step 7 begins with the v1 retirement decision, which is a hard boundary at pilot start and does
not slip past it.

## 10. Session record

Commits this session, oldest first:

| Commit | What |
|---|---|
| `0501d65` | Admission request opened on disk for Codex (3.1b live test) |
| `6e3afa1` | Issue report — a new request has no way to reach Codex; Codex's live refusal |
| `07afcc4` | Harness — 3.1b tests the refusal's substance, not file absence (136 → 142) |
| `cc443e1` | Slice 3 evidence — 3.1b closed on live refusal. **Reviewed commit** |
| `e3fa4bc` | Step 6 review brief |
| `28eded1` | Brief fix — harness line count |
| `4c77ced` | Brief fix — review must not run through the Work Loop (self-hosting) |
| `8995db9` | Review findings, frozen at A/B/C |
| `edd0d97` | **Findings A and B corrected** (142 → 143) |

**One process note worth carrying forward.** The session's declared file footprint listed the
executable core as a read-only input. Finding A made it an edit target, and `check-foreign-staging.sh`
blocked the commit until the mandate was widened. The guard worked; the mandate was corrected and the
widening disclosed rather than overridden. Two unrelated dirty files (`logs/friction-log.md`,
`logs/next-up.md`) were correctly kept out of every commit — they predate this session.
