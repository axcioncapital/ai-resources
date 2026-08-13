---
capability: { kebab-case-slug, ≤50 chars, derived from the outcome }
name: { one-line human-readable name }
route: solo | reviewed | challenged
phase: frame            # frame | shape | build | prove | land
status: in-development  # ACTIVE: in-development | continue-trial | revise | paused
                        # TERMINAL: adopted | keep-local | closed | retired | rejected
owner_project: { project-name }
stream: { stream-id — {date-of-first-unit}-{slug}[-{n}] }
active_unit: none       # the open unit's id, or `none` between units
reopen_trigger:         # REQUIRED when status is `paused` — a date, a quarter or a named event. Omit otherwise.
opened: { YYYY-MM-DD }
updated: { YYYY-MM-DD }
---

<!--
  CAPABILITY RECORD — one operating capability, from need to lifecycle decision.

  ** RETIRED LEGACY (2026-08-11) — THIS TEMPLATE HAS NO LIVE WRITER. **
  Its only writer was `/work-loop` (v1), deleted 2026-08-06; the v1 Codex controller
  skill was retired 2026-08-11 under Axcíon Harness v0.2 Phase 0. WORK LOOP V2 DOES
  NOT WRITE CAPABILITY RECORDS and has no equivalent artifact — do not scaffold one
  from a v2 unit, and do not treat this shape as a v2 contract.

  It is kept because `/develop-ai-resource` Step 1.0 still READS a capability record
  when a brief claims upstream qualification (`**Capability:**` + `**Settled
  upstream:**`), and needs this shape to verify that claim. No component emits such a
  brief today, so that check exists to reject unproven claims rather than to service a
  live producer.

  Method and process lived in `skills/capability-development/SKILL.md` and
  `docs/work-loop.md`. Both survive as inert v1 method documents with no live
  executor and unresolved ownership; neither is a live instruction.

  Everything below this banner is preserved v1 material, unchanged.

  Opened by Frame as soon as the route is reviewed or challenged, NOT as a wrap-up
  artifact. Solo units write no record at all.

  `phase`, `active_unit`, `updated` and `## Current phase and next action` are written
  after every slice and at every phase boundary — that hot-path write is what makes a
  session that dies mid-Build resumable.

  A record is NEVER deleted to tidy up. A rejected capability keeps its record with
  `status: rejected` — that is the evidence the question was asked and answered.

  STATUS IS A SET, NOT A FLAG. Anything discovering capabilities matches the whole
  ACTIVE set — `in-development`, `continue-trial`, `revise`, `paused` — never
  `in-development` alone. Three of those four mean "more work is expected", so a
  consumer filtering on one status makes the other three invisible. Reaching a
  TERMINAL status is the only way to leave the active set.

  `paused` without a `reopen_trigger:` is MALFORMED — report it, never auto-repair it.
  A park with no trigger never drains.
-->

# { Name }

## Operating outcome

{ One sentence — the result, not the system. If the need named a system, restate it as the outcome and say so. }

## Verified need

### Confirmed facts
- { fact — with the path that shows it }

### Reasonable inferences
- { inference — with its basis, stated as inference }

### Unknowns
- { unknown — with what would close it }

## Route

{ Dated, append-only. One entry per call: date · route · the trigger that fired · escalation or de-escalation. The frontmatter `route:` always shows the CURRENT route. }

- { YYYY-MM-DD } · { route } · { trigger that fired, or "no reviewed or challenged trigger fires" }

## Ownership and seams

- **Owner:** { project } — established by { file:line, the clause that grants it }
- **Dependencies:** { never co-owners }
- **External systems:** { name each, with direction of flow }
- **Official record per data class:** { data class → the system that holds it }

## Public interface

Input · Output · Owning capability · External dependencies · Observable failure states · Side effects · How behaviour is tested.

## Approved scope and exclusions

- **Will be built:** { … }
- **Will not be built:** { the boundary that stops adjacent-improvement creep }

## Implementation package

Verified need · intended outcome · users · public interface · observable behaviours · ownership and dependencies · smallest useful version · exclusions · verification · adoption condition · retirement condition.

{ Reviewed: eleven short fields. Challenged: durable, versioned and operator-approved. It states outcome, boundaries, behaviour, evidence and exclusions — never functions, files or abstractions. }

## Vertical slices

- [ ] S1 — { one complete behaviour, useful end to end — never a technical layer }
- [ ] S2 — { … }

## Units

{ Append-only. One row per unit of this capability's stream. }

| Unit | Phase / slice | Route | Commits | Outcome |
|---|---|---|---|---|
| { unit-id } | { phase or S{n} } | { route } | { SHAs } | { close \| rejected-premise \| route-unavailable \| routed-out } |

## Verification evidence

| Claim | Evidence type | Result | Where |
|---|---|---|---|
| { claim } | { runtime \| diff \| representative test \| source } | { observed \| unassessed \| blocked } | { path or command } |

{ A claim that was not tested is `unassessed`, never `passed`. }

## Independent review

{ Round · date · subject · findings · the disposition of each finding — accept and fix, accept and
defer with a concrete trigger, or reject with cited evidence. Briefs and reviews live in
`logs/loop/` for the life of the stream and are deleted at stream close; this section is what makes
a lost review regenerable afterwards. }

## Decisions

### D1 — { YYYY-MM-DD } — { title }

**Status:** active
**Decision.** { … }
**Rationale.** { … }
**Alternatives.** { … }

{ Append-only. Superseding sets the earlier entry's Status to `superseded by D{n} ({date})` and adds the new entry below. Nothing is deleted. }

## Current phase and next action

Phase: { phase }. Next: { one concrete action }.

## Real-use result

{ What happened when it was actually used. Recorded even when negative. Technical completion is not project completion. }

## Lifecycle status

{ status } — decided { YYYY-MM-DD } by { operator | Claude }. Retirement condition: { … }.

## Pointers

{ Plans, specs, review reports, closing commit SHAs — by path, never copied in. }
