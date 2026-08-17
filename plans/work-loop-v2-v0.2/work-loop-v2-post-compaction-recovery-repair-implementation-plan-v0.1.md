# Work Loop v2 — post-compaction recovery repair implementation plan, v0.1

**Date:** 2026-08-17  
**Status:** APPROVED, as amended 2026-08-17. The operator authorized the exact plan content
committed as `d72cf199` on 2026-08-17. The approval is bound to that identifiable content, not to
this filename: a material change to the objective, scope, exclusions, settled decisions, sequence,
acceptance conditions or authority relationships returns this plan to draft and requires
reapproval.

**Amendment 1 (2026-08-17, operator-approved).** § 4 gains **Unit 0**, a bounded prerequisite
sequenced before Unit 2, restoring Work Loop behavior lost by merge `9b1c19d3` and returning
`work-loop-v2-slice-1.test.sh` to green. Raised by Codex at the Unit 1 assessment and approved by the
operator the same day. Units 1–4 keep their numbering, scope and acceptance conditions unchanged; in
particular **Unit 1's completion evidence still requires a green Slice 1 suite**, and no acceptance
condition in this plan was relaxed by the amendment.  
**Addresses:** Immediate context refill after compaction, including `$realign` crossing into recovery, oversized always-loaded Work Loop instructions, over-reading governing material, and accepted-result history surviving in active state.  
**Primary evidence:** [`audits/2026-08-17-post-compaction-recovery-fix-qc.md`](../../audits/2026-08-17-post-compaction-recovery-fix-qc.md) and the operator-supplied incident report.  
**Execution posture:** Four bounded implementation units, followed by one independent review and one representative live proof. No new specification, ticket system, state field, hook, dispatcher policy, or test framework.

---

## 1. Operating outcome

After a Work Loop conversation is compacted, Codex must recover the authoritative task, checkout,
state and next action without immediately refilling the context window with material that is not
needed for recovery. If `$realign` is invoked in that condition, it must hand recovery to
`$reorient` before starting a governance judgment and end the realignment pass cleanly.

The repair is complete only when all of these are true:

1. The selected Work Loop skill remains fully readable as required by the Codex skill contract, but
   its always-loaded body is below this repository's progressive-disclosure limits.
2. Recovery reads the complete lean Work Loop skill and executable core, the exact task, and only
   the relevant governing material needed to establish the next move.
3. `$realign` and `$reorient` retain separate jobs: recovery establishes state; realignment judges a
   live course only after state is sound.
4. Active task state contains the latest material result, not a verbatim history of accepted units.
5. A representative post-compaction case proves correct recovery and continuation, while recording
   repository-read volume as diagnostic evidence rather than treating file size as correctness.

## 2. Verified baseline

Verified in this checkout on 2026-08-17:

| Surface | Current state | Consequence |
|---|---:|---|
| `.agents/skills/work-loop-v2/SKILL.md` | 602 lines, 12,669 words, 79,166 bytes | Exceeds the repository's `<500 lines` and `<5,000 words` skill-body guidance; every full read is expensive |
| Work Loop executable core | 604 lines, 5,759 words, 34,543 bytes | Canonical semantic authority; large, but not the first split target |
| `$reorient` skill | 242 lines, 1,755 words, 11,410 bytes | Already requires the complete Work Loop skill and core, then a minimum authoritative read set |
| `$realign` skill | 203 lines, 1,445 words, 9,543 bytes | Loads Work Loop authority before it branches on uncertain task identity |
| Active-state doctrine | Command and core already say “current truth, not a diary” and require replacement of the previous result | The incident is an execution failure, not an absent-rule failure |
| Routing catalogue | Already lives in `references/routing-index.md` | Progressive disclosure is an established pattern in this skill |
| Deployment | `auto-sync-shared.sh` symlinks whole skill directories | New reference siblings travel with the skill directory; no new deployment mechanism is needed |

The 2026-08-14 decision deliberately deferred splitting `work-loop-v2/SKILL.md` until a dedicated
session. Its trigger was the next body-line change, with severity raised if a session attributed a
missed instruction to the file's length. This incident satisfies that second trigger. The temporary
exception is therefore exhausted; this repair must perform the split rather than extend it.

## 3. Settled design

### 3.1 Progressive disclosure, not partial skill reads

Do not teach `$reorient` to read an excerpt of `work-loop-v2/SKILL.md`. A selected skill's
`SKILL.md` is loaded completely; conditional detail belongs in directly linked references. The
repair therefore moves existing material without weakening or summarising its semantics.

The main Work Loop skill keeps the material needed on every Work Loop turn:

- frontmatter and activation boundary;
- role split and compaction gate;
- the seam, checkout binding, ownership and fresh-thread rules;
- assessment, continuation, correction and closing behavior;
- “What you never do”; and
- a compact routing table that names each reference and the exact condition for reading it.

Move these sections, preserving one semantic owner for every rule:

| New direct reference | Material it owns | Read condition stated in the main skill |
|---|---|---|
| `references/core-resolution.md` | The complete marker-bounded executable-core resolver and its terminal failure contract | Read when Work Loop owns the move, and during `$reorient` recovery |
| `references/courier-operation.md` | Attended carry, unattended operation, exit-code handling and runtime capability profile | Read only when the operator has approved courier operation or a run is in flight / being assessed |
| `references/routing-and-admission.md` | Owner-first routing, repository-problem route, mode classification, intake result and Direct-versus-Standard admission | Read when routing a new request or a Continue move |
| `references/unit-framing.md` | Opening a unit, sizing, context preparation, authority/relevance treatment, verification claims and capability selection | Read only after Work Loop admission, when preparing or materially reframing a unit |

The main skill must directly link every reference it may require. For routing it must directly link
both `routing-and-admission.md` and the existing `routing-index.md`; a reference must not create a
reference-to-reference loading chain. Any reference over 100 lines gets a short table of contents.

Target after the move: the main `SKILL.md` is below 500 lines and below 5,000 words without deleting
load-bearing behavior. The current section measurements indicate approximately 280–300 lines and
4,200 words are achievable. These repository architecture limits are structural acceptance checks;
they are not a license to trim semantics to hit a number.

Do not split the executable core in this repair. It is the canonical cross-actor contract, and
splitting it would introduce a separate authority and parity problem. The first-order context saving
comes from making the selected Work Loop skill genuinely progressive.

### 3.2 `$reorient` owns recovery

Keep `$reorient` read-only and preserve its existing output contract. Change its read cascade so the
sequence is explicit and testable:

1. `pwd` alone.
2. Resolve the exact task through the preserved path or the strictly validated `.owner` fallback.
3. Read the complete lean Work Loop `SKILL.md`.
4. Read `references/core-resolution.md`, run its resolver, and read the complete printed core.
5. Read the exact task state.
6. Read the governing plan's authority/header and the exact sections the task names.
7. Widen within that plan only if those sections cannot establish a load-bearing constraint or next
   action; record why widening was necessary.
8. Read only directly named current-state, decision or evidence sources still needed to resolve a
   material uncertainty.
9. Stop when objective, current state, current task, constraints and actor-correct next action are
   established.

Do not read the routing index for an already-established task. Do not batch several large files into
one read that can be truncated. Full plan reads remain allowed when genuinely necessary; they are not
the default and are never forbidden by an arbitrary byte limit.

A non-skill source already read completely in the same uncompacted context may be reused when it is
unchanged. This exception never permits skipping the complete load required when a skill is selected,
and never treats a compacted summary as an authority cache.

### 3.3 `$realign` must not absorb recovery

Move the compaction / uncertain-binding branch ahead of Work Loop authority loading in `$realign`:

- If the invocation or context indicates compaction, context degradation, or uncertain task / checkout
  identity, invoke `$reorient` immediately.
- Emit no `ALIGNED`, `REALIGNED`, `OPERATOR DECISION NEEDED`, or `STOPPED` realignment verdict.
- Do not edit task state and do not reconstruct the decision at risk.
- End the realignment pass after `$reorient` reports or fails.

“End the pass” does not close the Work Loop task or force a new thread. Once recovery has established
the actor-correct next action, the same Work Loop task continues. A later realignment is performed
only if a live proposed move still needs that separate judgment.

When context and binding are already sound, `$realign` retains its existing narrow behavior and loads
the Work Loop authority before judging the proposed move. No hook, automatic trigger, persistent
finding store, or new verdict is added.

### 3.4 State rollover must be proved behaviorally

Do not duplicate the existing “current truth, not a diary” prose. Before changing the Claude command,
construct a representative transition whose `## Latest result` contains a distinctive accepted-result
marker from the preceding unit and whose current brief asks for a different result.

Run the old behavior first. The check fails if the old marker remains after the new hand-back. Then
make the smallest command-side correction that produces reliable replacement behavior. The exact
mechanism is implementation-owned and must be justified by the failing case; likely candidates include
making the write operation replace the section body rather than patch below its existing content.

Do not add a semantic state parser, another state field, or a global size validator unless the
failing-first evidence proves the existing write contract cannot be made reliable without one. Such a
finding expands the approved design and stops for an operator decision.

The planned 12 KB warning / 16 KB refusal remains outside this repair. It is provisional Change set B
for automatic dispatcher launches, not a universal validity condition for state or recovery.

## 4. Implementation units

Each unit has one dominant deliverable and is committed separately by the implementation owner.

### Unit 0 — Restore the lost Work Loop behavior (operator-authorized amendment, 2026-08-17)

**Authorization.** Added by operator decision on 2026-08-17, on Codex's proposal at the Unit 1
assessment. It is a material amendment: it inserts a unit and changes the sequence. Units 1–4 are
otherwise unchanged and keep their numbering. **This entry records the authorization and its
boundary. Codex writes the unit's brief into the state file** (core § 3 step 3); the required work
below is Codex's own proposal as the operator approved it, not a substitute for that brief.

**Dominant deliverable:** The packaging, hop-termination and hand-off-reconciliation rules are back
in service under their post-split owners, and `work-loop-v2-slice-1.test.sh` is green.

**Why it precedes Unit 2:** Unit 2 edits `$realign` and `$reorient`, both of which load the Work Loop
skill that is missing these rules. Building the recovery boundary on a knowingly incomplete contract
risks attributing the next failure to the wrong cause.

**Files in scope:**

- `.agents/skills/work-loop-v2/SKILL.md` and `.agents/skills/work-loop-v2/references/unit-framing.md`
- `.claude/commands/work-loop-v2.md`
- the `LIVE_TASK_F` pointer in `logs/scripts/work-loop-v2-slice-1.test.sh`

**Required work, as approved:**

1. Restore the `pack` and `race` content lost by merge `9b1c19d3`, sourced from `16de1622` (+28 skill,
   +53 command) and `8a61a496` (+13 skill). Place each rule with its **post-split owner** — the
   packaging and sizing material belongs in `references/unit-framing.md`, the reconciliation material
   in the main skill's seam. This is a merge with judgment, not a revert.
2. Repoint `LIVE_TASK_F` at the next open Standard record. **Correction to the approving proposal,
   carried on repository evidence:** the 3 `mode` failures are *not* lost behavior. They read a
   pointer at a task that has since closed, and the test's own comment at that line prescribes this
   fix. Codex should confirm this reading when it writes the brief.
3. Re-run the Unit 1 structural and resolver suites to confirm the restoration did not disturb the
   split's one-owner property.

**Completion evidence:** A failing-first observation for each restored rule against the current
artifacts; `work-loop-v2-slice-1.test.sh` green (exit 0); resolver suite green; and a statement of
where each restored rule now lives, so one-owner is preserved rather than assumed.

**Then:** Unit 1 returns to Codex for assessment against its own unchanged completion evidence.

### Unit 1 — Split the Work Loop skill without semantic loss

**Dominant deliverable:** A lean, fully loaded main Work Loop skill whose conditional detail has one
owner in direct references.

**Files in scope:**

- `.agents/skills/work-loop-v2/SKILL.md`
- the four new references named in § 3.1
- `logs/scripts/work-loop-v2-core-resolver.test.sh`
- the Work Loop structural/routing assertions in `logs/scripts/work-loop-v2-slice-1.test.sh`

**Required work:**

1. Add failing structural assertions before moving content:
   - main skill below 500 lines and 5,000 words;
   - all four direct references linked from the main skill with their read conditions;
   - every moved section has exactly one owner;
   - no new reference links to another reference as its loading route;
   - references over 100 lines contain a table of contents.
2. Move, do not copy, the four conditional sections.
3. Update the resolver parity test so the marked resolver in the Claude command is compared with
   `references/core-resolution.md`, not with the main skill.
4. Retarget Slice 1 assertions to the file that now owns each rule. Keep frontmatter and universal
   behavior assertions on the main skill.
5. Run the resolver and Slice 1 suites. No existing behavioral assertion may be deleted merely because
   its source moved.

**Completion evidence:** Red structural run before the split; green resolver parity; green Slice 1
suite; final line/word counts; a one-owner inventory for the moved headings.

### Unit 2 — Repair the recovery / realignment boundary

**Dominant deliverable:** `$realign` delegates degraded-context recovery before judgment, and
`$reorient` follows the bounded read cascade in § 3.2.

**Files in scope:**

- `.agents/skills/reorient/SKILL.md`
- `.agents/skills/realign/SKILL.md`
- recovery assertions in `logs/scripts/work-loop-v2-tracer-7.test.sh`

**Required work:**

1. Add failing checks for the branch order and “no realignment verdict / no state edit” outcome.
2. Implement the `$realign` early recovery branch and pass-ending rule.
3. Update `$reorient` to name the new resolver reference and the task-first, targeted-plan cascade.
4. Extend Tracer 7's existing compaction/Reorient scenario rather than creating another harness:
   - exact preserved task among multiple open task files;
   - a misleading compacted summary;
   - hidden durable facts in the task and named plan section;
   - a control in which the compaction hook is absent, proving explicit `$reorient` still works;
   - a validator refusal / blocked-task control that must stop rather than resume.
5. Preserve the current `REORIENTED` output shape and actor-correct `Next:` contract.

**Completion evidence:** The new checks fail on the pre-change skills and pass after the edit; existing
Tracer 7 scenarios remain green; no task state changes during the `$realign` recovery branch.

### Unit 3 — Make active-state rollover reliable

**Dominant deliverable:** A completed unit replaces the preceding accepted result in active state.

**Files in scope:**

- `.claude/commands/work-loop-v2.md`, only if the failing case requires a command correction
- the smallest existing test surface that can host the rollover fixture
- this plan's § 8 evidence record

**Required work:**

1. Build a disposable valid active state with `DISTINCTIVE-OLD-RESULT` in `## Latest result` and a new
   brief whose successful result must contain `DISTINCTIVE-NEW-RESULT`.
2. Demonstrate that the assertion detects the incident shape before the repair or against a controlled
   mutant copy; it must not be a grep for words supplied by the final artifact alone.
3. Apply the smallest behavior-producing correction supported by the red case.
4. Run one normal Claude Work Loop hand-back.
5. Assert after the hand-back:
   - state validation exits 0;
   - `turn: codex` and `status: active`;
   - the new marker exists;
   - the old accepted-result marker is absent;
   - the current brief, blocker and next action remain valid; and
   - no historical result block was added elsewhere.

**Completion evidence:** Failing control, passing real transition, validator output and the exact
before/after state excerpts needed to show replacement. Do not retain disposable fixture state in
`logs/work-loop/` after proof.

### Unit 4 — Representative post-compaction proof and independent review

**Dominant deliverable:** Evidence that the repaired system recovers correctly under the incident's
operating shape without the former immediate context refill.

Run one operator-assisted case from a disposable checkout or task. Do not launch a nested model from
a shell test. The case must contain:

- more than one task file, with one exact preserved path and checkout binding;
- a misleading compacted summary;
- at least two distinctive facts available only from the authoritative task and its named plan section;
- an invocation beginning with `$realign` under degraded context;
- no working compaction hook in the control path;
- a governing plan large enough that a full read would be visibly unnecessary;
- a routing index present but irrelevant; and
- a valid next action that can continue through one state rollover.

The trace must establish:

1. `$realign` hands to `$reorient` before loading Work Loop governance material and returns no verdict.
2. `$reorient` selects only the exact durable task and reconstructs both hidden facts.
3. The full lean Work Loop skill and full executable core are read once each.
4. The resolver reference is read; courier, routing, routing-index and unit-framing references are not
   read unless the recovered next action genuinely requires one of them.
5. The plan read stops at the named relevant sections unless a stated uncertainty requires widening.
6. No tool read is truncated and no required source is reopened without a stated reason.
7. The returned `Next:` matches the authoritative turn.
8. The subsequent real hand-back passes the Unit 3 rollover assertions.

Record the repository files opened and the bytes returned as a **repository-read budget proxy**. Compare
it with the incident's 205,922-byte refill. This is diagnostic evidence, not a universal product limit:
correct state reconstruction and the permitted-source set are the pass/fail conditions. A lower byte
count cannot excuse a missed fact, and a justified wider read is reported rather than failed merely for
crossing a number.

After the live case, run one independent `code-review` against the pre-implementation commit. Review
both axes:

- **Standards:** progressive-disclosure limits, direct references, one owner, no reference chain,
  deployment behavior and test quality.
- **Spec:** the five operating outcomes in § 1 and every negative control in § 6.

Resolve material findings once. Do not add a second general review round.

## 5. Test and deployment updates

| Surface | Required update |
|---|---|
| `work-loop-v2-core-resolver.test.sh` | Compare the Claude command's marked block with `references/core-resolution.md`; retain all existing trust-boundary fixtures |
| `work-loop-v2-slice-1.test.sh` | Point each assertion at its new semantic owner and add structural progressive-disclosure guards; do not weaken existing routing or unit-contract checks |
| `work-loop-v2-tracer-7.test.sh` | Extend the existing compaction/Reorient scenario with the deterministic controls from Unit 2 |
| `auto-sync-shared.sh` | No design change expected; verify that a project skill-directory symlink exposes all four new references |
| Work Loop capability check | No expansion by default. The directory symlink already transports references; change the checker only if a failing deployment fixture proves an incomplete referenced skill can be reported READY |

The complete existing Work Loop suites run after the focused green checks. A historical line-number
mention in an archived plan does not need rewriting; live code, tests, current instructions and active
documentation do.

## 6. Negative controls

The implementation is not accepted unless these nearest wrong behaviors fail visibly:

| Wrong behavior | Required observation |
|---|---|
| Main skill remains over either architecture limit | Structural test fails |
| A moved rule exists in the main skill and a reference | One-owner test fails |
| A reference is reachable only through another reference | Direct-link test fails |
| Resolver drifts between Claude command and Codex authority | Resolver parity fails |
| `$realign` emits a governance verdict after delegating recovery | Recovery-boundary check fails |
| `$realign` or `$reorient` edits state while only recovering | Before/after state identity fails |
| Recovery chooses a newer or similarly named task instead of the exact task | Multiple-task scenario fails |
| Missing hook prevents explicit `$reorient` from recovering | No-hook control fails |
| Routing index is read for an established task with a known next action | Live trace fails |
| Full plan is read although named sections establish every needed fact | Live trace fails unless widening is justified |
| Previous accepted result survives beside the new result | Rollover assertion fails |
| A large but semantically current result is rejected only for its byte count | Test fails; no universal state-size gate is permitted |

## 7. Scope boundaries and stop conditions

### In scope

- progressive-disclosure restructuring of the Codex Work Loop skill;
- the `$realign` → `$reorient` recovery boundary;
- targeted authoritative reads during reorientation;
- reliable replacement of active `## Latest result` content;
- focused deterministic regressions, one representative live proof and one independent review.

### Explicitly out of scope

- splitting or shortening the executable core;
- adding model defaults;
- changing Work Loop roles, state headings, lifecycle, turns, admission, courier permissions or
  dispatcher exit codes;
- implementing the provisional 12/16 KB automatic-launch policy;
- universal task-state size validation;
- a new hook, parser, state field, registry, cache, summary file or recovery daemon;
- rewriting historical plans solely because line numbers moved; and
- broader Work Loop optimization not exercised by the incident.

Stop for the operator if implementation evidence indicates that success requires any excluded item,
changes the canonical core's semantics, removes a load-bearing rule, or creates a consequential new
architecture choice. A false premise in this plan is a valid result: report it with evidence and
reframe rather than building through it.

## 8. Evidence record to complete during implementation

Keep the evidence here so the repair does not create a second report artifact.

### Unit 1 — structural red / green

Implemented 2026-08-17 in checkout `ai-resources-work-loop-fix-17-8`, branch
`session/2026-08-17-work-loop-fix-17-8`.

**Status: NOT ACCEPTED.** Codex assessed this unit on 2026-08-17 and did not accept it. This
section's completion evidence requires a **green Slice 1 suite**, and the suite exits 1 with 44
failures. An earlier revision of this record reframed the bar as "no regression against that
baseline"; that redefined an approved acceptance condition without operator approval and has been
removed. The approved condition stands unchanged. The evidence below is recorded as measured, not as
a claim that the unit is complete.

**Pre-existing baseline, established before any edit.** `work-loop-v2-slice-1.test.sh` was **not**
green on entry: **315 passed / 44 failed**. The 44 are unrelated to this unit — see *Pre-existing
defect* below.

**Red before the move.** The 37 new `split` assertions were added first and run against the actual
pre-split file: **30 failed** (`322 passed / 74 failed`). The seven that passed did so vacuously —
the chain checks over files that did not yet exist, plus the negative fixture and the semantic-volume
guard. Failing set included both architecture limits (602 lines, 12,669 words), all four
reference-exists and direct-link checks, all four read-condition checks, all eleven one-owner checks
and the resolver-marker check.

**Green after the move.**

| Suite | Command | Exit | Result |
|---|---|---:|---|
| Resolver parity | `bash logs/scripts/work-loop-v2-core-resolver.test.sh` | 0 | 5 passed, 0 failed |
| Slice 1 | `bash logs/scripts/work-loop-v2-slice-1.test.sh` | 1 | **352 passed, 44 failed** |
| State validator | `bash logs/scripts/work-loop-state.test.sh` | 0 | green |
| Session preflight | `bash logs/scripts/work-loop-session-preflight.test.sh` | 0 | green |
| Tracer 7 | `bash logs/scripts/work-loop-v2-tracer-7.test.sh` | 0 | green |
| Deployment capability | `work-loop-capability.sh check --canonical …` | 0 | `verdict: READY` |

Slice 1 exits 1 solely on the 44 pre-existing failures. A set-difference of the failing test names
before and after the change is **empty**: no assertion that was green went red, and 37 new ones went
green (315 → 352).

**Final counts.** Main skill **204 lines / 4,575 words**, from 602 / 12,669 — under both the
`<500`-line and `<5,000`-word limits. References: `core-resolution.md` 119, `courier-operation.md`
109, `routing-and-admission.md` 90, `unit-framing.md` 157. Combined text across the main skill and
all references is 14,626 words against a 12,669-word pre-split body, so nothing was trimmed to reach
the numbers.

**One-owner inventory — 18 moved headings, one owner each.**

| Heading | Owner |
|---|---|
| `### Resolve the executable core` | `core-resolution.md` |
| `## Courier mode`, `### Unattended runs` | `courier-operation.md` |
| `## Routing a request`, `### Repository problems`, `### Classifying the mode`, `### What an intake result contains`, `### The routing index`, `## Admission` | `routing-and-admission.md` |
| `## Opening a unit and writing the brief`, `### Size the unit against the clock`, `### Prepare once`, `### Keep authority semantic`, `### Mark what must be verified`, `### Justify the unit against the plan`, `### Select on relevance`, `### The capability envelope`, `### Keep every duty inside the four` | `unit-framing.md` |

**Fail-capability, proved against wrong fixtures rather than asserted.** Each mutation was applied,
observed red, and reverted:

| Mutation | Observed |
|---|---|
| `### Classifying the mode` copied back into the main skill | `FAIL split one owner: classifying the mode` |
| Resolver marker pair left behind in the main skill | `FAIL check 5` (resolver suite) and `FAIL split the resolver marker pair moved whole` |
| `unit-framing.md` link removed from the main skill | `FAIL split main skill directly links unit-framing.md` + its read-condition check |
| `unit-framing.md` truncated to 40 lines | `FAIL split no semantic loss` |
| Reference containing a link to another reference | `PASS split NEGATIVE: the chain check rejects…` (the check detects it) |
| Long reference with its contents list stripped | `PASS split NEGATIVE: the contents check rejects…` |

After reverting every mutation the suite returned to 352 / 44.

**Retargeting, not weakening.** No behavioral assertion was deleted or loosened. 37 assertions moved
to the file that now owns their rule (`admission_res`, `routing_res`, `result_block`, `route_step`,
`ex_block`, the eight `ce9` orientation checks, the sizing check, and the courier-mode
disambiguation). Four negative sets were **widened** to cover the new references, so the split could
not open a hole in them: no `## Mode` heading, no `mode:` frontmatter key, no verbatim copy of the
core's mode definition, and no invented "adoption unit". The `ce9` stated-once check now counts
across all five files rather than one. Resolver parity check 4 was retargeted from the main skill to
`references/core-resolution.md`, and a new check 5 asserts the main skill keeps no second copy —
parity between two files says nothing about a third.

**Deployment — no change required, confirmed by precedent.** `auto-sync-shared.sh:571-589` symlinks
each shared skill as a whole **directory**. `references/routing-index.md` was added on 2026-08-13
(`a22b54b7`), after the project links existed, and is readable through the pre-existing
`projects/axcion-content-programme/.agents/skills/work-loop-v2` link today with no deployment change.
The four new siblings travel by the same mechanism.

**Pre-existing defect found while establishing the baseline — not introduced here, not fixed here.**
The 44 failures have **two unrelated causes**, and the distinction sizes the repair:

- **41 are lost content** — `pack` (unit packaging and hop termination, **35** checks) and `race`
  (hand-off reconciliation, **6** checks). Of the 35 `pack` checks, **21 read the skill and 14 read
  `.claude/commands/work-loop-v2.md`**: both runtime artifacts lost their half in the same merge, the
  command shedding 53 lines. `## Ending the hop` and every packaging line are absent from it today.
- **3 are a stale pointer, not lost content** — the `mode` live-task checks read `LIVE_TASK_F` at
  `work-loop-v2-slice-1.test.sh:1387`, which names `logs/work-loop/work-loop-v2-durable-state-system.md`.
  That task has since **closed**, so its record is reduced to the four closing headings and carries no
  `## Lane and unit` for the checks to read. The test's own comment at that line predicts exactly this
  and prescribes the fix: repoint the single line at the next open Standard record. Routine
  maintenance, not restoration.

The lost content was implemented and green — commit `8a61a496` records "harness 345/0 to 358/0
green" — and was then **lost by merge `9b1c19d3`** ("Merge branch
'session/2026-08-14-concurrency-fix-2' into session/2026-08-14-durable-state"), which dropped
`.agents/skills/work-loop-v2/SKILL.md` from 592 to 532 lines. Both source commits are ancestors of
HEAD; their text is not. Verified by content probe across `16de1622`, `8a61a496`, `9b1c19d3` and
HEAD. Recoverable text: 41 lines into the skill (`16de1622` +28, `8a61a496` +13) and 53 into the
command (`16de1622`). Restoration is **not** a clean revert — the skill has been split since, so the
packaging material's owner is now `references/unit-framing.md` rather than the main body.

This was outside Unit 1's file scope and was not repaired there. The operator authorized a bounded
prerequisite unit for it on 2026-08-17 — see § 4 Unit 0.

### Unit 0 — restored behavior red / green

Pending.

### Unit 2 — recovery boundary and deterministic regression

Pending.

### Unit 3 — state rollover red / green

Pending.

### Unit 4 — live post-compaction case

Pending. Record:

- checkout and disposable task id;
- exact preserved path;
- hidden facts recovered;
- sources opened, read count and bytes returned;
- whether any read widened and why;
- final recovery output and actor-correct `Next:`;
- rollover assertion output; and
- comparison with the 205,922-byte incident baseline.

### Independent review

Pending.

## 9. Completion condition

This plan is implemented when Units 0–4 are complete, every focused and existing regression is green,
the independent review has no unresolved material finding, and the representative live case proves
correct recovery plus current-result rollover without the incident's unnecessary read set.

Implementation success is not “the files are smaller.” It is: the same Work Loop contract remains
available at the moment each rule is needed, recovery reads only the authority required for the current
move, skill boundaries remain intact, and the next real hand-off preserves current truth rather than
history.
