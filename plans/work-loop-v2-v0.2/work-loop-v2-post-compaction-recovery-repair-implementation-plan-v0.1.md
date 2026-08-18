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
- in `logs/scripts/work-loop-v2-slice-1.test.sh`: the 13 `pack` assertions whose phrases now belong to
  `unit-framing.md`, retargeted from `$SKILL_F` to `$UNITFR_F`, plus the `LIVE_TASK_F` pointer — 14
  retargets in all. **Corrected 2026-08-17 from a bound of the `LIVE_TASK_F` pointer alone**, which
  could not hold together with the approved one-owner placement and green-suite conditions: moving the
  packaging rules to their post-split owner necessarily moves the assertions that read them. Only the
  file variable changes; no assertion is deleted, skipped, loosened, renamed or otherwise rewritten.

**Required work, as approved:**

1. Restore the `pack` and `race` content lost by merge `00855ec6`, sourced from `16de1622` (+28 skill,
   +53 command) and the full 19-line block at `8a61a496`. Place each rule with its **post-split
   owner** — the packaging and sizing material belongs in `references/unit-framing.md`, the
   reconciliation material in the main skill's seam. This is a merge with judgment, not a revert.
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

**Status: ACCEPTED 2026-08-17**, against the unchanged approved condition. Codex first assessed this
unit on 2026-08-17 and did **not** accept it: the completion evidence requires a **green Slice 1
suite**, and the suite then exited 1 with 44 failures. An earlier revision of this record reframed
the bar as "no regression against that baseline"; that redefined an approved acceptance condition
without operator approval and was removed. The approved condition stands unchanged and was met by
Unit 0, which resolved all 44 failures and returned the suite to exit 0 while preserving every
structural guard this section measures. The structural evidence below is unchanged and was always
valid; what was missing was the green suite, and it is no longer missing.

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
  (hand-off reconciliation, **6** checks). Of the 35 `pack` checks, **13 read the skill and 22 read
  `.claude/commands/work-loop-v2.md`** — corrected 2026-08-17 from a recorded 21/14 split, by counting
  the assertions in the `pack` block: both runtime artifacts lost their half in the same merge, the
  command shedding 27 lines. `## Ending the hop` and every packaging line are absent from it today.
- **3 are a stale pointer, not lost content** — the `mode` live-task checks read `LIVE_TASK_F` at
  `work-loop-v2-slice-1.test.sh:1387`, which names `logs/work-loop/work-loop-v2-durable-state-system.md`.
  That task has since **closed**, so its record is reduced to the four closing headings and carries no
  `## Lane and unit` for the checks to read. The test's own comment at that line predicts exactly this
  and prescribes the fix: repoint the single line at the next open Standard record. Routine
  maintenance, not restoration.

The lost content was implemented and green — commit `8a61a496` records "harness 345/0 to 358/0
green" — and was then **lost by merge `00855ec6`** ("Merge branch
'session/2026-08-14-durable-state'"). **Corrected 2026-08-17 from a recorded loss commit of
`9b1c19d3`**: a content probe across both parents of each candidate shows the rules present at
`4ba2ff0e` and absent at `00855ec6`, while *both* parents of `9b1c19d3` (`04be4f6a`, `9cf6b56b`)
already lack them — so `9b1c19d3` cannot be where they were dropped. At `00855ec6` the skill went
from 591 lines to 603 (the other parent added unrelated content while shedding these rules) and the
command from 349 to 322. Both source commits are ancestors of HEAD; their text is not. Recoverable
text: the skill's packaging material (`16de1622` +28) plus the **full 19-line operator-shorthand and
reconciliation block as it stood at `8a61a496`** — not only that commit's 13 added lines, because
two of the six `race` checks read the pre-existing shorthand half of the same block — and 53 lines
into the command (`16de1622`). Restoration is **not** a clean revert — the skill has been split
since, so the packaging material's owner is now `references/unit-framing.md` rather than the main
body.

This was outside Unit 1's file scope and was not repaired there. The operator authorized a bounded
prerequisite unit for it on 2026-08-17 — see § 4 Unit 0.

### Unit 0 — restored behavior red / green

**Status: ACCEPTED 2026-08-17.** Committed at `072438b3`.

**Red, against the unchanged target files:** `work-loop-v2-slice-1.test.sh` exit 1 — 352 passed, 44
failed, split 35 `pack` / 6 `race` / 3 `mode`, matching the baseline recorded at the hand-back.

**Green, after the restoration:** exit 0 — 396 passed, 0 failed. Every one of the 44 resolved with no
assertion deleted, skipped, loosened, renamed or rewritten; the 14 authorized retargets change only
which file a predicate reads.

**Where each restored rule now lives** — one owner apiece, and the harness's own one-owner guards stay
green against it:

- **Packaging and sizing** (13 `pack` checks) → `.agents/skills/work-loop-v2/references/unit-framing.md`
  § *Size the unit against the clock*, +26 lines: the two split triggers, the primary-edit-begins-after
  rule, the four packaging lines and their mode scoping.
- **Hand-off reconciliation** (6 `race` checks) → `.agents/skills/work-loop-v2/SKILL.md` § *The seam*,
  +19 lines: the full operator-shorthand and reconciliation block.
- **Claude-side packaging check and hop termination** (22 `pack` checks) →
  `.claude/commands/work-loop-v2.md`, +52 lines: § *The brief's packaging lines* under § *The unit's
  mode*, and § *Ending the hop*.
- **Stale live-task pointer** (3 `mode` checks) → `LIVE_TASK_F` repointed at this task's own active
  Standard record. Maintenance, as § 8 predicted, not restoration.

**Unit 1's structural contract preserved:** main skill 223 lines / 4,802 words — under both the
500-line and 5,000-word limits. Direct-reference, read-condition, one-owner, no-chain,
table-of-contents, semantic-volume and resolver-parity guards all green.

**Affected regressions, all exit 0:** `work-loop-v2-core-resolver` (5/0), `work-loop-state`,
`work-loop-owner`, `work-loop-session-preflight` (60/0), `work-loop-capability` (81/0),
`work-loop-v2-tracer-7` (120/0). The capability drift check still reports `READY` with every copied
component byte-identical to canonical.

### Unit 2 — recovery boundary and deterministic regression

Implemented 2026-08-17 in checkout `ai-resources-work-loop-fix-17-8`, branch
`session/2026-08-17-work-loop-fix-17-8`. The recovery assertions extend Tracer 7's existing
compaction/Reorient scenario (S8); no second harness was created.

**Status: ACCEPTED 2026-08-17** at commit `e0b1944b`, against the unchanged approved condition.

**Red, against the unchanged pre-edit skills.** The focused assertions were written first and run
against `$realign` and `$reorient` as they stood: `work-loop-v2-tracer-7.test.sh` exit 1 —
**148 passed / 14 failed**. The 14 were the whole instruction contract: both branch-order checks and
both of their wrong-order controls, the four `$realign` recovery-branch clauses, and the six
`$reorient` cascade clauses. Everything else in the file, including all five new route controls, was
green before the edit — those controls exercise the existing helpers, so they prove the harness
rather than the repair.

**Green, after the edit.** Exit 0 — **162 passed / 0 failed**. All 14 resolved; the previously green
148 stayed green.

**Why the order checks can fail.** Each is a line-position predicate, not a phrase search, and each
is paired with a **wrong-order fixture**: the identical file with the two anchor lines exchanged, so
both phrases are present and only the sequence is wrong. The same predicate must reject it, and does.
This is the actual defect — `$realign` read Work Loop authority at line 31 and tested uncertain
identity at line 39 — rather than a proxy for it.

**Why the clause checks can fail.** Each is paired with the pre-edit artifact at HEAD, in which the
clause is genuinely absent. A clause green in both states would prove nothing and is reported as a
failure by the same helper.

**The five named Unit 2 controls, executed.** In a checkout carrying **three open task files** with
exactly one declared, the recovery route returns `s8-real-task` and never names either decoy; it
recovers the durable fact hidden in the task (`NA-s8-real-task`) and the one in the plan section the
task names (`DURABLE-FACT-S8`) together with the plan's authority header, while the section the task
does **not** name (`DECOY-FACT-S8`) never comes back — that is the targeted-read property, not a
whole-plan slurp. That checkout carries **no compaction hook at all**, so the recovery is the
explicit-`$reorient` control. A `BLOCKED_OPERATOR` task stops at `STOP:5` naming its classification,
and a record the validator refuses stops at `STOP:4` — the validator, not one check later. Both exit
non-zero rather than resuming.

**No task state changes during recovery.** The state file is byte-identical across the recovery pass
(SHA-256 before and after), with a control proving the comparison notices a real write.

**Preserved and asserted as preserved:** `$realign`'s four-verdict output contract, its
actor-correct `Next:` line and its healthy-context authority load; `$reorient`'s seven `REORIENTED`
fields, its seam `Next:` rule and its read-only posture.

**Affected regressions, all exit 0:** Tracer 7 162/0, Tracer 6 74/0, Slice 1 396/0, core-resolver
5/0, state 100/0, owner 133/0, lease 136/0, capability 81/0, session-preflight 60/0.

### Unit 3 — state rollover red / green

Implemented 2026-08-17 in checkout `ai-resources-work-loop-fix-17-8`, branch
`session/2026-08-17-work-loop-fix-17-8`.

**Status: ACCEPTED 2026-08-17** at commit `fe61527c`, against the unchanged approved condition. The
Tracer 7 intermittent recorded below was real and is preserved as recorded; it was a pre-existing race
in Tracer 7, not a defect in this unit, and it was repaired separately as the Unit 4 prerequisite
below.

The rollover control was added to `work-loop-v2-slice-1.test.sh`,
the existing surface that already carries the state-file field contract and the section-scoped
`latest_of` reader; no second harness was created, and no fixture was retained under `logs/work-loop/`.

**The failing control, and what it rejects.** Four disposable valid active states were built in a
temp dir with `DISTINCTIVE-OLD-RESULT` as the preceding accepted-result marker and
`DISTINCTIVE-NEW-RESULT` as the current unit's:

| Control | Shape | Assertion |
|---|---|---|
| `clean` | the preceding result replaced | **PASS** |
| `append` | the incident shape — both results standing in `## Latest result` | **FAIL** (rejected) |
| `parked` | the preceding result moved to a `## Previous results` block | **FAIL** (rejected) |
| `stale` | the result never rewritten; only `## Objective and scope` names the new marker | **FAIL** (rejected) |

The assertion is scoped to the `## Latest result` **body**, and `stale` is the control that proves
the scoping is load-bearing rather than decorative: a whole-file grep for `DISTINCTIVE-NEW-RESULT`
returns **1 hit and would pass**, while the section-scoped read returns **0 and correctly fails**.
Governing text may legitimately name either marker, so a whole-file grep is invalid in both
directions.

**Why the protection had to be behavioural.** The validator cannot see this defect, and that is
recorded as an executed control rather than asserted: the incident-shaped `append` record classifies
**`ACTIVE_CODEX`** — byte-for-byte the same classification the `clean` record gets. Its frontmatter,
heading set and field count are all correct; only one field's body is wrong, which is not a lifecycle
question. `parked` is the one mutant the validator does catch (`STOP [16] unsupported top-level
heading '## Previous results'`), so the rollover assertion's heading check is a second, independent
catch on that shape rather than the only one.

**No command correction was made, and the evidence is why.** Plan § 3.4 permits a command-side
correction only where the failing case requires one. `.claude/commands/work-loop-v2.md` Step 5 already
carries the instruction verbatim — "The state file is current truth, not a diary (core § 4): replace
the previous result rather than appending to it." — and this unit's real hand-back replaced the
preceding result under that unchanged instruction. The instruction is therefore sufficient, and the
smallest change supported by the evidence is none. Two contract checks now hold it in place, both
scoped to Step 5 and both proved fail-capable against a mutant command with the instruction line
removed: PASS on the actual command, FAIL on the mutant. An unscoped grep would not discriminate the
instruction being moved out of Step 5.

**The real transition.** This unit's own Claude hand-back is the required normal Work Loop transition.
Before, `## Latest result` carried the Unit 2 acceptance plus one `DISTINCTIVE-OLD-RESULT` marker
(section-scoped count: OLD 1, NEW 0; whole-file: OLD 1, NEW 0). After, the section carries only the
Unit 3 result and `DISTINCTIVE-NEW-RESULT` (section-scoped: OLD 0, NEW 1), with `DISTINCTIVE-OLD-RESULT`
absent from the whole state file. Validator: `ACTIVE_CODEX`, exit 0. Headings unchanged at the six
active ones — no second or historical result block was added, and the brief, blocker and next action
remain valid.

**Focused suite:** `work-loop-v2-slice-1.test.sh` exit 0 — **405 passed / 0 failed**, up from 396/0 at
Unit 2, the nine added checks being the four controls, the scoping discriminator, the validator-blindness
control, the no-fixture-retained control and the two Step 5 contract checks.

**Affected regressions:** Slice 1 405/0 exit 0; state, owner and capability exit 0. Tracer 7 exit 0 at
163/0 on five of seven runs, and 162/1 on two.

**The Tracer 7 intermittent, recorded rather than absorbed.** The single failing check is S9's "the
partial effect is visible on disk during the hop". It is a pre-existing race in Tracer 7's own
sandbox, not an effect of this unit: the sentinel appends its marker file
(`work-loop-v2-tracer-7.test.sh:276`) before writing `partial-effect.txt` (line 293), while the
scenario releases from `wait_for_file "$S9MARK" 45` on the marker alone and tests for the partial
effect on the next line. Under load the assertion can run between the two writes. Every file this
unit changed is outside S9, which executes against a temporary sandbox checkout. **Deferred**, with
the reason: Tracer 7 is Unit 2's accepted evidence surface, and this unit's framing holds the
dispatcher, courier and their harness outside scope, so re-synchronising S9 to wait on the partial
effect rather than the marker is an unbriefed edit to an accepted unit and belongs in its own unit.

### Unit 4 prerequisite (Unit 4a) — deterministic Tracer 7 S9 synchronization

Implemented 2026-08-17 in checkout `ai-resources-work-loop-fix-17-8`, branch
`session/2026-08-17-work-loop-fix-17-8`. Execution packaging inside approved Unit 4, not a sixth plan
unit: it changes no objective, scope, exclusion, acceptance condition or unit order. It exists because
Unit 4's live proof cannot be read against an intermittently red regression.

**Status: ACCEPTED 2026-08-17** at commit `7b130cd1`, against the unchanged approved condition.

**The race, quoted from the surface.** `make_sentinel` appends the launch marker at
`work-loop-v2-tracer-7.test.sh:276`, *before* it reads its action file, resolves the repo path and
dispatches into the `partial:*` branch, which writes `partial-effect.txt` at line 293. S9 released on
`wait_for_file "$S9MARK" 45` and read `[ -f .../partial-effect.txt ]` three lines later, so the
assertion could run inside the window those command substitutions occupy. The ordering is production
behaviour and was left unchanged; only the release condition was wrong.

**Red, deterministically.** A control reproduced the seam with the harness's own `wait_for_file` and
`alive` copied verbatim, widening the marker-to-effect interval from those substitutions to a
controlled 3s and giving each run an isolated directory and a reaped actor. The current
marker-based gate failed **3 of 3 runs**; the corrected gate passed **3 of 3**. An earlier revision of
the control shared one directory between runs, and a previous run's still-sleeping actor rewrote the
effect — it reported 1 red of 3, which is luck, not ordering. That is why the isolation is part of the
control rather than incidental to it.

**Green, after the edit.** Full suite exit 0 — **163 passed / 0 failed**, with all thirteen S9
assertions retained and all nine scenarios PASS. The count is identical to the pre-fix green runs, so
no assertion was added, weakened or removed. The exact sequence that had reproduced the flake
(`work-loop-owner.test.sh` immediately followed by Tracer 7, which produced 162/1) now returns 163/0
on both of two consecutive runs.

**The gate is still falsifiable.** The wait is a synchronization gate, not the assertion: `[ -f ]`
still decides. A control in which the actor launches but *never* writes the partial effect leaves the
corrected gate **FAIL** with the carrier still live, so a genuine regression is caught rather than
waited out. The 8s bound sits inside the actor's 9s post-write hold, which is what keeps "during the
hop" the thing being asserted rather than "eventually".

**Scope held.** The sentinel's action ordering, the attended carrier, the dispatcher, every other
scenario, and all Work Loop skills, commands, core, hooks, validators and owner helpers are unchanged.
No fixture was retained; the control lived outside the repository and was removed.

### Unit 4 preparation (Unit 4b) — the representative case, prepared and unrun

**Status: ACCEPTED 2026-08-18** at disposable fixture commit `d99e7eda`. Execution packaging inside
approved Unit 4: it builds the case and does **not** run it, so Unit 4 itself stays pending below and
its required live proof and independent review are untouched. Codex accepted the self-reported read
trace with its recorded completeness limit because § 4 defines the byte count as a diagnostic proxy;
correct reconstruction and the permitted-source set remain the pass/fail conditions.

**The case.** Disposable linked worktree at
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-wl2-unit4-case`, branch
`disposable/wl2-unit4-case-2026-08-17`, based at `7b130cd1`, fixture committed at `d99e7eda`. Exact
preserved task `u4-live-case` (`logs/work-loop/u4-live-case.md`), classifying `ACTIVE_CLAUDE`, among
77 task files of which 16 are active. Plausible decoy `u4-context-refill-audit`, itself a valid
`ACTIVE_CODEX` record so it survives inspection. Governing plan
`plans/work-loop-v2-v0.2/u4-live-case-governing-plan.md`, 682 lines / 79,995 bytes, whose named
`## 7. Rollover acceptance` (359 bytes, **0.4%** of the file) carries `DURABLE-FACT-U4-ROLLOVER`, and
whose unreferenced `## 12. Deprecated transport notes` carries `DECOY-FACT-U4-TRANSPORT`. The
task-only fact is `NA-U4-EXACT-TASK-FACT`; the standing accepted-result marker is `U4-OLD-RESULT`, so
the follow-on hand-back exercises Unit 3's rollover assertions.

**Red/green, with the same script both times.** The preflight is red **12 passed / 25 failed** against
a clean disposable checkout at the same base commit, and green **42 / 0** against the prepared case.
An earlier red (15/22) is not cited as the pair: it ran an older revision of the preflight, and a
red and a green from two different scripts are not a red/green.

**Two false greens were found in the preflight itself and fixed.** The ownership check passed on the
empty checkout, because the helper returns `PROCEED` with reason *"free to claim"* when nothing is
declared — it now requires the verdict **and** the reason naming this checkout as declaring the task.
And the fact-uniqueness greps matched the preflight's own text, since it names every marker; the
preflight now lives in `.unit4-preflight/`, outside the case's read surface, and both greps exclude it.

**Negative controls.** Presence greps are paired with rejected wrong fixtures: a plan section stripped
of its fact, an owner declaration naming another task, a prompt bound to the decoy path, and an
enabled `compact` registration.

**The hook control.** `.codex/hooks.json` in the disposable checkout has its `SessionStart` /
`compact` registration removed, so the operator prompt is the only recovery trigger the case supplies.
Every hook command in that file is an absolute path into canonical `ai-resources`, so the removal is a
registration change on the disposable branch and reaches no other checkout.

**The read-measurement convention, and its evidenced limit.** The session self-reports
`READ <path> <bytes returned>` per read, with batching and suppression forbidden. Every reported line
is checkable against the frozen case; the trace **cannot prove completeness**, because an unreported
read leaves no mark in it. That gap was investigated, not assumed: filesystem access time was tested
as a machinery-free way to close it and does not work on this volume — `atime` updates only on the
first read after a write, not on a re-read or a cached read, and touching the files first to re-arm it
leaves the following read undetected. A sweep on that basis would **under**-report, the flattering
direction, so it was written, disproved and deleted rather than shipped with a caveat. Anything that
would close the gap properly is excluded by § 3 and by this plan's exclusions — and § 4 Unit 4 does
not require it, calling the number a *repository-read budget proxy* and *diagnostic evidence, not a
universal product limit*, with pass/fail resting on correct state reconstruction and the
permitted-source set.

**Not run, and asserted as not run.** No model was invoked in the case. The task still reads
`turn: claude`, the preceding accepted-result marker still stands, and no live-run artifact exists.

**Cleanup ownership — one item needs the operator.** A second, throwaway worktree at
`ai-resources-wl2-unit4-cleanctl` was created solely to produce the red run and is no longer needed.
`git worktree remove` refused it: the liveness guard saw the untracked preflight copy inside it as
uncommitted work and recent writes, and liveness is the operator's fact. It was left in place rather
than overridden. Both it and the case checkout are removed at Unit 4's close.

### Unit 4 — live post-compaction case

**Attempt 1 — incomplete transport, 2026-08-18.** At the operator's request, the canonical prompt was
run in a context-isolated Codex subagent with no inherited conversation turns. The subagent's runtime
skill catalog did not expose `$realign`, although the repository carries `.agents/skills/realign/`,
so it fell back directly to `$reorient`. This attempt therefore cannot establish trace item 1 and is
not accepted as the representative live proof.

The `$reorient` portion supplied useful evidence: it selected `u4-live-case`, classified it
`ACTIVE_CLAUDE`, rejected the misleading task/lifecycle/turn summary, read the lean Work Loop skill
and core once each, avoided routing/courier/unit-framing references, read only 1,465 bytes from the
79,995-byte governing plan, and returned the actor-correct Claude `Next:`. Its trace total was
**85,026 bytes across 8 reads**, 41.3% of the 205,922-byte incident refill. The first response omitted
the two marker strings, but a no-read postmortem confirmed that it had encountered and retained both
`NA-U4-EXACT-TASK-FACT` and `DURABLE-FACT-U4-ROLLOVER`; it identified their omission as a reporting
judgment error. No Claude hand-back or rollover followed this incomplete attempt.

**Attempt 2 — semantic live-recovery trace accepted, 2026-08-18.** The operator requested another
context-isolated subagent. Because collaboration subagents inherit the parent runtime catalog, this
run used an explicit transport override to load the repository's complete
`.agents/skills/realign/SKILL.md`; the override tests the skill boundary but does **not** establish
automatic catalog discovery. `$realign` detected degraded context before Work Loop governance,
delegated to `$reorient`, ended without a realignment verdict, and changed no repository state.

`$reorient` selected the exact `u4-live-case`, rejected the summary's decoy identity and false
lifecycle/turn, recovered `NA-U4-EXACT-TASK-FACT` from the task and
`DURABLE-FACT-U4-ROLLOVER` from named plan § 7, and never encountered
`DECOY-FACT-U4-TRANSPORT`. The two authoritative markers were compressed out of the first rendered
summary; a no-read postmortem from retained context established both and identified that omission as
a reporting judgment error. The trace read each required source once, opened no courier, routing,
routing-index or unit-framing reference, read 830 bytes of the 79,995-byte plan without widening, and
returned the actor-correct Claude `Next:`.

**Budget:** 7 reads / **94,966 bytes**, 46.1% of the 205,922-byte incident refill (110,956 bytes,
53.9%, lower). This passes as the plan's diagnostic proxy because reconstruction and the permitted
source set passed; it is not evidence that an unreported read is impossible.

The semantic recovery portion is accepted. Automatic runtime discovery of `$realign` remains outside
what a collaboration subagent can prove and is covered only by repository deployment/regression
evidence.

**Unit 4 is complete.** The three items left pending above are discharged at revision `092a1715`,
which carries the real Claude hand-back and its committed classification: at that exact revision
`logs/work-loop/u4-live-case.md` contains `U4-OLD-RESULT` **0** times, carries exactly **one**
`## Latest result` heading, is `status: active` / `turn: codex`, and the validator prints
`ACTIVE_CODEX` at exit 0. That is the rollover assertion — the old result was replaced, not retained.
Only that rollover behaviour is accepted from `092a1715`; its byte-ceiling verdict is non-governing
(Finding 6 above).

### Independent review

**FAIL — correction required, 2026-08-18.** The required two-axis review ran against
`d72cf199...4510cb0a` after the disposable case branch had already been fast-forwarded into canonical
`main`.

**Spec — four material blockers.** Commit `a0f4f6ec` makes the complete Work Loop skill and executable
core conditional during `$reorient`, contradicting §§ 1 and 4. The fixture plan used to authorize
that redesign claims approval at nonexistent object `aa11bb22` and cannot override this content-bound
plan. The case converts diagnostic read volume into a 5,541-byte pass ceiling, contrary to § 1 outcome
5 and § 4's diagnostic-only budget rule. The accepted `$realign` trace predates the semantic change;
the post-change proof invokes `$reorient` directly and omits the two reads this plan requires, while
Tracer 7 checks only that relevant phrases remain present rather than that those reads stay mandatory.

**Standards — two material findings.** The capability checker still returns READY when
`core-resolution.md` is removed, although § 5 requires the new reference siblings to be part of full
capability presence. `routing-and-admission.md` directs readers to sibling references, violating the
one-level/no-reference-chain rule; the guard misses the defect because it recognizes Markdown links
but not backticked sibling paths.

**Cleanup finding.** The synthetic fixture plan, decoy state, audit and root operator prompt remain in
canonical paths despite the case's cleanup contract. Full reviewer notes are in
`audits/working/u4-case-spec-review.md` and `audits/working/u4-case-standards-review.md`.

Canonical `main` was fast-forwarded from `0d5641b8` to `4510cb0a` before this review completed. No
finding is resolved, Unit 4 is not accepted, and § 9 is unmet. The task is blocked for the operator's
choice between restoring the local pre-merge pointer and continuing corrected Unit 4 from the bound
implementation checkout, or retaining the merge and authorizing a separate correction.

### Correction round — the six frozen findings

**Implemented 2026-08-18 at commit `63c02624`** in checkout `ai-resources-work-loop-fix-17-8`, branch
`session/2026-08-17-work-loop-fix-17-8`, after the operator restored canonical `main` to its
pre-merge pointer `0d5641b8`. This is the one bounded correction core § 3 permits, frozen to the
findings the failed review named. It resolves them on this feature branch and imports nothing from
the disposable case: `4510cb0a` and `a0f4f6ec` stay unmerged, and no fixture file was copied across.

**Finding 1 — capability presence did not cover the direct references. RESOLVED.**
`work-loop-capability.sh` gains a sixth component, `work-loop-references`: the Work Loop skill body
plus every `references/*.md` file that body links directly. The set is **derived from the skill's own
links**, not listed in the script, so a reference added to the contract is covered the day it is
added. The derivation's own fail-open is closed first — an absent or unreadable skill body, and a
body that links nothing, are both reported rather than resolving to an empty set.
*Red:* with `core-resolution.md` removed, the pre-correction checker printed
`verdict: READY … all five Work Loop v2 components are present` and exited 0.
*Green:* the same removal now prints
`missing: work-loop-references — .agents/skills/work-loop-v2/references/core-resolution.md is absent
or unreadable`, exit 3; the untouched checkout is `READY` on all six against canonical
`ai-resources`. `work-loop-capability.test.sh` exits 0 with **94 passed, 0 failed**, and gains cases
A4b (a reference removed), A4c (the body removed), A4d (a body linking nothing), A4e (attribution —
one reference gone does not implicate the other) and an A9 drift case naming `work-loop-references`.

**Finding 2 — a backticked sibling loading chain, invisible to the guard. RESOLVED.**
`routing-and-admission.md` carried three sibling `references/…` paths presented as things to go and
read. All three are removed; the semantic routing steps are unchanged and the main skill remains the
one owner of the direct links and their read conditions. The Slice 1 `chain_hits` guard now
recognises the backticked shape as well as the Markdown-link shape.
*Red:* against the pre-edit file the old guard returned no hits (green) while the new guard returns
`` `references/routing-index.md` ``, `` `references/core-resolution.md` ``,
`` `references/routing-index.md` ``.
*Green:* all five live references return no hits under the new guard.
A bare ownership citation — `(§ Size the unit against the clock, in `references/unit-framing.md`)` in
`courier-operation.md` — is deliberately **not** flagged, and a CONTROL case asserts that: the chain
is created by the instruction to load, not by a path appearing in prose, and a guard that could not
tell them apart would demand edits it cannot justify. `work-loop-v2-slice-1.test.sh` exits 0 with
**407 passed, 0 failed**.

**Finding 3 — Tracer 7 S8 could not see the conditional reversal. RESOLVED.**
S8's clause checks test phrase presence, and disposable commit `a0f4f6ec` kept every phrase while
reversing the contract. Two properties now separate the approved contract from that reversal, and
neither edits the contract:

- **No conditional gate** stands between Step 3's heading and the first mandatory read. The span
  stops at the skill read on purpose — "you read a reference only when its stated condition is met"
  sits immediately below and is a legitimate conditional about references.
- **The resolved core is read complete**, not merely resolved. `a0f4f6ec` kept the resolver and
  replaced the read of what it prints.

*Red:* run against `a0f4f6ec`'s `reorient/SKILL.md`, all seven present S8 clause and order checks
returned green; the new pair returns `mandatory set / conditional / Read anything below only when`
for the first and `ABSENT` for the second. *Green:* the live file returns no gate words and carries
the complete-core read. Each is paired with a wrong fixture **built from the live file** — a trigger
line inserted above the skill read, and the complete-core clause deleted — so the control does not
depend on the disposable branch surviving its scheduled removal. `work-loop-v2-tracer-7.test.sh`
exits 0 with **167 passed, 0 failed**, all nine scenarios PASS.

**Finding 4 — fixture authority and the byte ceiling stay out. CONFIRMED ABSENT.**
`git cat-file -t aa11bb22` returns `Not a valid object name`, so the fixture plan's claimed
content-bound approval anchors to no commit and governs nothing. Bounded to this feature branch's
**tracked** tree: `git ls-files` matches no `u4-live-case`, `u4-live-case-governing-plan` or
`unit4-operator-prompt` path; `git grep` finds neither of `a0f4f6ec`'s distinctive strings
("The mandatory set is two reads and no more", "Read anything below only when one of these holds")
anywhere. The only tracked occurrence of 5,541 across `.agents`, `logs/scripts`, `.claude`, `.codex`
and `plans` is this section's own review prose recording the rejected number; it is not a gate, and
repository-read volume remains diagnostic under § 4.

**Finding 5 — the accepted semantic trace stays tied to the semantics it exercised. RECORDED.**
The trace accepted above is Attempt 2, which exercised the **unconditional** contract: the complete
lean Work Loop skill and the complete core once each, targeted plan sections, no courier, routing,
routing-index or unit-framing reference. The later disposable semantic rewrite invoked `$reorient`
directly under the reversed contract and is **rejected**, not treated as a post-change proof. Nothing
from it is imported here.

**Finding 6 — only the rollover portion of `092a1715` is accepted. VERIFIED, BOUNDED.**
Checked at that exact revision: the commit exists; `logs/work-loop/u4-live-case.md` contains
`U4-OLD-RESULT` **0** times; it carries exactly **one** `## Latest result` heading; its frontmatter is
`status: active` / `turn: codex`; and the validator, run against that revision materialised into a
scratch checkout, prints `ACTIVE_CODEX` at exit 0. That is the rollover behaviour and all this
commit is accepted for. Its byte-ceiling verdict is **non-governing and not imported**.

**Deferred at this correction, not done here** (core § 3 — newly noticed work is a deferral, never a
second correction round):

- `.claude/commands/work-loop-v2.md` Step 0 prose still says Work Loop needs "five separate things";
  `/sync-workflow`'s remediation still enumerates the five original component names. Both are
  count-only staleness in files outside this correction's implementation boundary. Neither changes
  behaviour: the checker names the missing file and its path, and the references travel the same
  manifest-symlink route as the Reorient skill, which that remediation already covers.
- `courier-operation.md` names a sibling path as an ownership citation. The guard's CONTROL case
  fixes that as permitted rather than overlooked; whether references should cite siblings by path at
  all is a contract question, not this correction's.

The two deferrals above are non-behavioral and remain open at close. Everything else the brief
deferred — the final complete Work Loop regression matrix, the correction closure check, the
task-close verdict, and the authorized worktree removal — is discharged in Unit 4d below.

### Unit 4d — final regression matrix and cleanup

**Accepted at `55214371`, 2026-08-18.** A discovery unit: it changed no implementation, plan,
worktree, branch or Git topology, and returned the final matrix plus a read-only cleanup inventory.

**The complete Work Loop matrix, one run each at corrected HEAD `63c02624`, sequential:**

| Suite | Exit | Result |
|---|---|---|
| `work-loop-capability.test.sh` | 0 | 94 passed, 0 failed |
| `work-loop-lease.test.sh` | 0 | 136 passed, 0 failed |
| `work-loop-owner.test.sh` | 0 | 133 passed, 0 failed |
| `work-loop-session-preflight.test.sh` | 0 | 60 passed, 0 failed |
| `work-loop-state.test.sh` | 0 | 100 passed, 0 failed |
| `work-loop-v2-core-resolver.test.sh` | 0 | 5 passed, 0 failed |
| `work-loop-v2-slice-1.test.sh` | 0 | 407 passed, 0 failed |
| `work-loop-v2-tracer-6.test.sh` | 0 | 74 passed, 0 failed |
| `work-loop-v2-tracer-7.test.sh` | 0 | 167 passed, 0 failed |

Nine suites, **1,176 passed, 0 failed**, every exit 0, no rerun. Every count was parsed from the
suite's own summary line; none was missing or unparseable. `ls logs/scripts/work-loop*.test.sh`
returns exactly these nine and no tenth, so the matrix is not widened. `grep` for a `FAIL` line
across all nine captured outputs returns none, and `git status --porcelain` after the run listed
only the task-state file, so no suite left residue.

**Cleanup — executed 2026-08-18 under explicit operator authorization.** The operator confirmed both
named worktrees idle and authorized removing them together with their two divergent untracked
`.unit4-preflight/preflight.sh` scripts (9,868 and 9,065 bytes; `cmp` reports them different, and
neither is tracked on any branch). The repository's `check-destructive-liveness.sh` guard had
previously refused the removal because it cannot establish whether a session occupies a checkout —
a fact core § 7 reserves to the operator. Both removals then ran under the documented
`AXCION_LIVENESS_OVERRIDE=1` audited override, in the exact guarded `git worktree remove --force`
form, scoped to these two paths only:

- `…/ai-resources-wl2-unit4-case` — was `4510cb0a` on `disposable/wl2-unit4-case-2026-08-17`
- `…/ai-resources-wl2-unit4-cleanctl` — was detached `7b130cd1`, a commit on this feature branch

Preconditions were reconfirmed immediately before each removal and held exactly: both worktrees at
their recorded HEADs, neither carrying a `logs/work-loop/.owner` declaration, and `.unit4-preflight/`
the only untracked path in each.

**The disposable branch is preserved, deliberately.** `disposable/wl2-unit4-case-2026-08-17` remains
at `4510cb0a`, and `092a1715`, `a0f4f6ec` and `d99e7eda` all remain reachable objects — `092a1715` is
the live rollover evidence pointer above. Deleting that branch is a separate act, was never
authorized, and was not performed. No broad prune, no marker deletion, no branch deletion, no reset.
Canonical `main` is untouched at `0d5641b8`.

## 9. Completion condition

This plan is implemented when Units 0–4 are complete, every focused and existing regression is green,
the independent review has no unresolved material finding, and the representative live case proves
correct recovery plus current-result rollover without the incident's unnecessary read set.

Implementation success is not “the files are smaller.” It is: the same Work Loop contract remains
available at the moment each rule is needed, recovery reads only the authority required for the current
move, skill boundaries remain intact, and the next real hand-off preserves current truth rather than
history.

**Satisfied — 2026-08-18.** Units 0–4 are complete and accepted (§ 8, with Unit 4 discharged at
`092a1715` and the correction at `63c02624`). Every focused and existing regression is green: the
complete nine-suite matrix returns **1,176 passed, 0 failed** at corrected HEAD `63c02624` (Unit 4d).
The independent review's six frozen findings each carry a disposition and no unresolved material
finding remains. The representative live case (Attempt 2) proves correct recovery — `$realign`
detecting degraded context and delegating to `$reorient`, the exact task selected against a
misleading summary, both authoritative markers recovered, no courier/routing/routing-index/
unit-framing reference opened, 830 bytes of the 79,995-byte plan read without widening — plus
current-result rollover at `092a1715`, and does so well inside the incident's read set.

Two accepted limitations stand: automatic runtime discovery of `$realign` was not proved by the
collaboration-subagent trace and rests on repository deployment and regression evidence instead; and
read-volume figures are self-reported, so they cannot independently prove no read was omitted. Two
non-behavioral deferrals remain open (§ 8, correction round): the "five components" count staleness
in `.claude/commands/work-loop-v2.md` Step 0 and `/sync-workflow`, and whether references should
cite sibling paths at all.
