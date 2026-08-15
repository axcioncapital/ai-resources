---
task: work-loop-v2-intake-router
turn: operator
---

## Outcome

**Retired by the operator on 2026-08-15 to permit the Work Loop v2 durable-state migration.** The
task did not reach its own exit condition and is not recorded as achieved.

The objective was that Codex receive an ordinary-language request, select exactly one route from the
approved Axcíon command set and the installed Matt Pocock skills without the operator recalling skill
names, and — where Work Loop v2 owns the request — classify the active mode as Discovery,
Implementation or Adoption inside `## Lane and unit`. The task's stated exit condition required both
the router and the mode contract implemented **and** representative ordinary-language cases able to
expose a wrong route. The router and the mode contract were built and independently assessed; the
representative natural-language routing proof was never run. The task is retired at that point, with
one bounded structural repair still awaiting its closure check.

## Decisions that matter

**Accepted work, assessed and preserved:**

- **Unit 2 accepted.** The ordinary-language router selects one owner from the approved 50-entry
  index, preserves Direct Work and Continue, and hands Claude-only routes to Claude. Codex reran the
  full harness independently: 222 passed, 2 failed, exit 1, with all 39 `ridx` assertions passing.
- **Unit 3's mode contract accepted after one bounded correction round.** Both frozen findings were
  reproduced by inspection before either was corrected, then corrected with nothing else touched.
  Finding 1: a harness assertion claimed mode classification was deferred while the skill already
  classified it after admission — the assertion was green and its claim false. Finding 2: a mode
  fixture named as its qualifying reason the exact reason core § 2 excludes ("small but asserted by
  the harness"), so it was not a valid Standard unit.
- **`/grill-me` disambiguation confirmed factual.** Axcíon `/grill-me` delegates to the Axcíon-owned
  `skills/grill-me/SKILL.md`; it is not a wrapper over the Matt Pocock `grill-me`.

**Superseded by this retirement:** the record's open `Next action` was a final tightly-bounded fix.
The Unit 3 correction had accidentally removed the `## Latest result` heading and the end of the
Brief's completion sentence, leaving the result embedded inside `## Brief`; Codex restored that
state-file boundary and asked Claude to verify exactly one each of the five active headings and hand
back for the final-fix closure check. That verification and closure check **never ran**. The operator's
2026-08-15 decision supersedes the disposition, not the work: nothing here claims the repair was
confirmed.

**Sequencing decision recorded by Codex and never revisited:** the fresh natural-language routing
proof was deliberately held outside Unit 3 because mode semantics had to exist before representative
operation could be assessed. It was Codex's sequencing call, not an added operator requirement, and
it is the reason the exit condition stands unmet.

## Evidence

Durable evidence already present in this record, carried forward unchanged:

- Full acceptance harness after the Unit 3 correction: **275 passed, 2 failed, exit 1** — up from
  271/2, with the two failures the same pre-existing `unexpected_worklog_files` pair. Codex's
  independent Unit 2 rerun was 222 passed, 2 failed, exit 1.
- **Finding 1's fail-capability demonstration**, run against the corrected skill and two mutants: the
  old predicate passes on all three — the corrected skill, mutant A (mode classification reverted to
  the Unit-2 deferral) and mutant B (Classify-the-mode moved before the admission step) — while the
  two replacement assertions, which read the routing steps positionally, fail on both mutants. The
  defect was shown, not asserted.
- **Finding 2's demonstration:** the admission-honesty check is green on the corrected fixture and
  reports `RED — defeats its own admission` on a copy with the original wording reinstated. It reads
  the named reason only, so it fails on the contradiction rather than on fixture identity.
- Git history of this file in `ai-resources` holds each round's before/after evidence.

## Accepted limitations

1. **The task exit condition is unmet.** Representative ordinary-language cases capable of exposing a
   wrong route were never run, so the router's real-use behaviour is unproven. The mode contract and
   the router exist and are assessed; routing quality under ordinary language is not established.
2. **One bounded structural repair is unverified.** Codex's restoration of the `## Latest result`
   heading and the Brief's completion sentence never received the Claude verification or the
   final-fix closure check the record requested.
3. **Two pre-existing `unexpected_worklog_files` harness failures remain**, unrepaired and
   unallowlisted. They were explicitly outside this task's scope and are preserved, not resolved.
4. **Open deferral, recorded and not implemented:** Finding 1 is an instance of a class, not a
   one-off. At least two further assertions have the same looseness — `ridx  /leverage-idea is named
   as excluded, with its router-within-router reason` conjoins a real check with `grep -qi 'router'`,
   a word appearing throughout the file, and `mode  Implementation does not demand ceremonial tests`
   is a disjunction where a conjunction was meant. A sweep for harness predicates that can pass for an
   unrelated reason is a bounded unit of its own and remains undone.
