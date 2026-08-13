REVIEW-1 — transcribed verbatim, Codex, 2026-07-30
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
OBJECT REVIEWED: logs/loop/2026-07-30-prime-session-entry-ownership-shape.plan.md (v1), at 6cf5f4f

This round has two parts. **Part A** is the REVIEW block returned against plan-v1. **Part B** is Codex's
assessment of Claude's proposed adjudication, returned before plan-v2 was written; it belongs to this
round because it judges the disposition of Part A's findings, not a new object. Both are transcribed
verbatim and are immutable. Claude's dispositions live in `…plan-v2.md` § 8, never in this file.

---

## Part A — the REVIEW block

```
UNIT: 2026-07-30-prime-session-entry-ownership-shape
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: shape
REPO: ai-resources
BASE: 6cf5f4f
NEXT: Claude — adjudicate the material findings, revise the plan, then return to G1

REVIEW

Verdict: REVISE BEFORE G1. The ≤300 target is credible, but this plan does not yet guarantee the
settled six-responsibility architecture. Six material findings require dispositions.

## Premise dimension

Independently observed at 6cf5f4f:
- `.claude/commands/prime.md` is 411 lines and unchanged from 8c573af.
- `prime-marker.sh` reads `session-notes.md` but writes neither it nor `.prime-mtime`.
- The negative write-site result has a valid positive control in `prime.md`.
- The dangling `8c.2` citation exists.
- No load-bearing premise was rejected.

Problem reality is mixed, not merely hypothetical. The core locator failure was observed in a real
consumer: `logs/improvement-log.md:2211-2219` records the axcion-systems-builder `/prime` failure and
the manual absolute-path workaround. The claim that 31 further roots fail is a deterministic
filesystem inference from the census, not 31 observed executions. State those two evidence levels
separately.

## Material findings

M1 — S6 is treated as optional even though it is required architecture.

Object inspected: the plan at §0:30-31, S6:108-113, §2:117-130, and current
`prime.md:316-411`.

The plan calls S6 “slack only”, says it can be dropped, gives it no replacement text, and omits
`session-start.md` and `session-plan.md` from the touched surfaces. But S6 contains required outcomes:
planning, direct-route behavior, approval tokens and execution leave `/prime`, and `/prime` stops
immediately after dispatching `{mode, task, mission}`. S1-S5 could therefore reach 237 lines while
leaving the rejected post-dispatch responsibilities intact.

Required correction: make S6 mandatory; enumerate exactly what is deleted, what existing owner already
covers, and any owner changes needed. Add a falsifier that fails if any `/prime` instruction remains
after successful dispatch or if any retained route fails to transfer `{mode, task, mission}` correctly.

M2 — S3 migrates today’s backlog but breaks the future finding-to-task loop.

Object inspected: plan S3:70-90 and §7’s final limitation; current producer contracts in
`session-feedback-collector.md:126-142`, `improve.md:49-60`, `leverage-idea.md:205-220`,
`resolve-incident.md:191-199`, `resolve-repo-problem.md:127-141`, and both wrap commands.

The plan itself admits that future promotion “depends on writers using `next-up.md`, which this plan
does not enforce.” A one-time copy of current HIGH items is therefore insufficient. The listed
producers currently rely on severity plus `/prime` Step 3 as the ongoing reachability mechanism.
Rewording their citations without naming a new executing promotion owner leaves every later important
finding stranded in the logs.

Required correction: S3 must name and implement the continuing promotion seam before deleting Step 3.
An item judged important enough to become work must reach the authoritative `next-up.md` source through
a named owner. Extend F-BACKLOG with a post-change test using a newly created qualifying finding; testing
only the pre-change backlog migration cannot prove the loop remains live.

M3 — S5 cannot consume the SessionStart result through the interface described.

Object inspected: plan S5:98-106 and drafted `STATE` contract at §6.2; live
`.claude/hooks/detect-concurrent-session.sh:71-80,138-205`.

The hook emits a transient JSON `systemMessage` and persists no result. A later shell collector cannot
read that message. Therefore `prime-collect.sh` cannot emit the promised `LIVE_FOREIGN` result unless it
rescans—the exact behavior the operator retired—or a new interface is added.

Smallest correction: consume the already-present SessionStart message directly in `/prime`’s judgement
layer, or identify a real existing result channel the collector can read. Do not invent a second
liveness scan. Add a falsifier that distinguishes hook-result consumption from rescan.

M4 — The removal and citation inventories are not closed.

Objects inspected: plan §6.2, §4 and §2; current `prime.md:61-67,235`;
`session-plan.md:99`; `docs/session-marker.md:61,67,228-229,322,339`.

- The drafted collector explicitly returns `TELEMETRY_GAP`, while the existing Step 6 telemetry warning
  is carried in the claimed 32-line retained region. Decisions/telemetry prefetch is therefore not
  actually removed.
- C2 records one citation to the retired Step 4 model check, but no slice or touched-file row owns that
  edit. `session-plan.md:99` is a live example.
- The six `8k` citations cannot all be mechanically changed to `8h`: several describe allocator
  ownership and should cite `prime-session-entry.sh` or the canonical protocol, while others describe
  the complete sequence.
- Renaming the qualified script also leaves the live capability record’s `prime-marker.sh` references
  unaccounted for.

Required correction: assign every retired responsibility and citation to a slice and repoint each
citation to the true new owner, not merely to the nearest surviving number.

M5 — The proposed test package does not prove the new session-entry owner.

Objects inspected: plan S1:39-57, F-ENTRY/F-ORDER/F-TRIPWIRE:222-233, and
`logs/scripts/prime-allocator.test.sh`.

The 19-test suite proves allocator behavior. Repointing it at a larger script does not make its existing
assertions cover header append, `WORK_DESC`, mtime ordering, repeat invocation, or partial failure.
F-ENTRY covers only the successful final state. F-ORDER is not a valid order oracle: a marker-bearing
header can still result from reordered operations, and filesystem mtimes can be equal at one-second
resolution.

Required correction: retain the allocator suite and add session-entry-specific tests, including fresh
header, same-marker reinvocation, exact work description, mtime after append, and injected failure after
each earlier effect. Define the required failure/cleanup state so “atomic session-entry owner” is
testable rather than rhetorical.

M6 — Two stream-level falsifiers cannot support the verdict claimed.

Object inspected: plan F-RULES:217-220 and F-DUP:241-270.

F-RULES has no defined way to extract “every executable rule” from mixed Markdown prose. Invocations
and assignments omit guards, ordering rules and branch semantics, so its positive control proves only
that its extractor notices one chosen deletion—not that it can inventory the rule population.

The 12-row register is useful and enumerable, but F-DUP checks only whether cited owner sections still
exist. That proves referential integrity, not that duplicated behavior was removed or preserved at the
new owner.

Required correction: replace F-RULES with an explicit retained-behavior register bound to named route
observations, and give every D-row an expected fate plus a concrete owner/behavior check.

## Answers to the five questions

Q1 — Budget: the arithmetic is internally correct for the literal drafted blocks:
411 − 174 = 237. I re-counted the carried regions and replacements. However, 237 is not yet an honest
functional ceiling because required text/interfaces are missing: `CWD_REPO` is still consumed by
mission/menu logic but absent from the drafted collector output, the hook-result seam is undefined,
and mandatory S6 has no drafted retained dispatch block. The 63-line slack makes ≤300 likely, but the
ceiling is not proved until those additions are counted. No listed subtraction is inherently blocked.

Q2 — C2: preserving retained identifiers and leaving gaps is the right decision. Renumbering creates
a much larger silent-failure surface. The defect is in execution of that decision: the 16-site update
set is not fully assigned, and retired `8k` references need semantic repointing to the script/protocol,
not blanket substitution to `8h`.

Q3 — Backlog replacement: no. “Promote current entries, then delete” preserves today’s queue only.
It does not preserve the continuing loop. A named future promotion owner plus a new-finding test is
required.

Q4 — Falsifiability:
- F-ENTRY is falsifiable for happy-path final state, but not for atomicity or failure recovery.
- F-LOCATOR is falsifiable if bound to a named real consumer and an exact pre/post invocation. The core
  defect already has one real consumer incident.
- F-ORDER is not falsifiable as written.
- F-RULES has the same practical defect as the predecessor’s unassessed criteria.
- The 12-row register is runnable for dead citations, but its current check does not test duplication.
- F-DUP therefore has claim-to-measurement mismatch even though the rows are enumerated.

Q5 — Order: S1 first is correct, and sequencing the novel collector late is sensible. Keep the broad
order, with two hard conditions:
1. S3 may delete Step 3 only after the continuing promotion owner is established.
2. S5 may begin only after the hook-result interface is real.
S6 may remain last, but it must be mandatory and fully specified—not “slack only.”

## Seven-dimension risk assessment

1. Usage cost: likely favorable; scripts leave the model-read prompt. Bound collector output and runtime.
2. Permissions: the quoted absolute path is plausible; prove it from a consumer whose path contains spaces.
3. Blast radius: understated because producer contracts, `session-plan.md`, and the capability record are omitted.
4. Reversibility: slice commits are sound; tag migrated S3 items sufficiently to identify/revert them.
5. Hidden coupling: the transient hook message and the five-discipline collector are the largest risks.
6. Principle alignment: deterministic scripts fit the architecture only if judgement remains in `/prime`
   and each bounded-read/output contract is explicit and tested.
7. Problem reality: one real consumer failure is observed; the remaining 31-root extent is inferred.
```

---

## Part B — Codex's assessment of the proposed adjudication

Returned after Claude stated its dispositions in chat and before plan-v2 existed. Judges the disposition
of Part A's findings; sets the conditions under which G1 approval would follow.

```
Yes—mostly. Claude has understood the review and is proposing a genuine correction, not defending the original plan. I agree with accepting REVISE and producing plan-v2.
What Claude gets right:
S6 becomes mandatory while receiving zero budget credit. That cleanly separates “required architecture” from “line-count arithmetic.”
The collector drops its impossible LIVE_FOREIGN output. Current Claude Code documentation supports consuming hook output from the model’s context, so keeping that judgment in /prime is technically plausible. It should still be demonstrated in a real session. Claude Code hooks reference
The omitted telemetry and citation work will be explicitly assigned.
Replacing the vague “every rule” check with a bounded route-and-guard register is more useful and proportionate.
Reducing the failure-testing proposal is reasonable. A complete artificial failure matrix would probably be excessive.
I have two important reservations.
First, the single /wrap-session promotion owner is a good simplification only if it demonstrably covers the whole future loop. Plan-v2 must specify:
which repository’s next-up.md receives the item;
that promotion happens after all findings have been finalized;
how duplicates are avoided;
what happens to important findings written during a session that never reaches /wrap-session.
If those points remain unanswered, M2 is not actually fixed—it has merely moved.
Second, Claude cannot describe the session-entry operation as “atomic” while accepting undefined partial states. One injected-failure test may be enough, but the plan must define what happens after failure and prove that rerunning /prime recovers safely. Otherwise it should call this a “single complete owner,” not an atomic operation.
One small correction: moving promotion into /wrap-session should not increase /prime’s line count. Likewise, most S6 work should delete lines from /prime. Claude should count the /prime budget separately from additions to its new owners.
So my judgment is:
Agree with Claude’s adjudication and revision direction: yes.
Approve the existing plan at G1: no.
Approve plan-v2 if it resolves the wrap-promotion coverage, retry safety, mandatory S6 transfer, and recounts /prime separately: likely yes.
```
