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

**The candidate has since moved.** Corrections for findings A and B landed at **`edd0d97`**, so the
three files above other than the command now differ from what was reviewed. This is legitimate — it
is the one correction pass the protocol provides for — but it means **the candidate that gets
accepted is `edd0d97` or later, not `cc443e1`.** Whoever closes this must re-record the accepted
commit and its hashes. Do not write `cc443e1` into the acceptance.

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

## 6. THE OPEN DECISION — finding C

**This is the only thing blocking Step 6.** The operator deferred it on 2026-08-01 to be settled next
session.

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

## 9. What next session must do

1. **Settle finding C** — options in § 6. This is the blocking item.
2. **Act on the decision.** If option 1, make the correction; if 2 or 3, write the limitation (with
   its reopening trigger for option 2).
3. **Run the closure check.** A, B, C plus blocking regressions only. Do **not** restart a broad
   review — forbidden by the mission's non-negotiables. The harness (`bash
   logs/scripts/work-loop-v2-slice-1.test.sh` from the repo root) is the regression instrument;
   143 assertions, exit 0 expected.
4. **Re-record the accepted candidate** — its commit and the four blob hashes, per § 2. The reviewed
   commit `cc443e1` is *not* the accepted one.
5. **Write the disclosed-limitations list** into this file: items 3, 4 and 5 from § 7, plus whatever
   C's resolution adds.
6. **Tick the mission's Step 6 thread** with evidence, and commit.

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
