---
mission_id: work-loop-v2-mvp
mission_name: Build the Work Loop v2 MVP per the approved Proposal v0.4
status: active
started: 2026-08-01
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create`. Frozen at creation like a /contract-check contract:
  the Goal / In-Out scope / Definition of done sections are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` are
  meant to change over the mission's life, both edited via `/mission` — never hand-edited
  from inside a working session, and never written to by /session-start.

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: work-loop-v2-mvp` mandate bullet.
-->

## Goal

A working Work Loop v2 MVP exists in this repo — a Claude Code command, a Codex-side resource, and one shared executable core — that carries a real work unit from a Codex-written brief through Claude execution to Codex closure, using a task-state file in the repository as the only transport. It has been piloted on at least two genuine CRM / Email OS work units, has a written disclosed-limitations list, and the v1 Work Loop has been retired.

**Governing documents** — authority order is stated in [`plans/work-loop-v2-mvp/README.md`](../../plans/work-loop-v2-mvp/README.md):

1. **AUTHORITATIVE** — [`plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md`](../../plans/work-loop-v2-mvp/work-loop-v2-mvp-proposal-v0.4.md)
2. **Execution guide** — [`plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md`](../../plans/work-loop-v2-mvp/pocock-lifecycle-work-loop-mvp-v0.4.md)
3. **Binding on artifact form** — [`plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md`](../../plans/work-loop-v2-mvp/skill-writing-standard-work-loop-v0.2.md)
4. **Destination reference ONLY, never requirements** — [`plans/work-loop-v2-mvp/the-work-loop-explained-complete-system-v0.2.md`](../../plans/work-loop-v2-mvp/the-work-loop-explained-complete-system-v0.2.md)

## In scope / Out of scope

- **In:** the Direct Work bypass and the Standard lane only; one Claude Code command; one Codex-side resource; one executable core they both link to; one task-state file as the single transport interface; one fresh-context candidate review under frozen findings; a pilot on real CRM / Email OS work; retirement of Work Loop v1.
- **Out:** everything Proposal § 7 defers. Specifically — the Consequential lane and its machinery; worktree isolation; a separate Independent-Reviewer-Codex role; any automation (hooks, triggering, session creation, context monitoring); any enforcement mechanism for single-writer ownership. Also out: editing or "aligning" Work Loop v1 before the pilot-start retirement decision, and using either v1 or the emerging v2 to govern this build (Proposal § 6, "No self-hosting").

## Validation contract

> Written now, at mission creation — before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, an independent review) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete. These are Proposal § 4 verbatim in substance; each must be **demonstrated, not claimed**:

- [ ] Codex is given an objective, writes a bounded brief into a task-state file, and commits it — the operator transports nothing by hand.
- [ ] Claude, invoked through the Work Loop command, reads the state file and verifies the brief's premises against the live repository.
- [ ] Given a deliberately false load-bearing premise, Claude refuses with a written report instead of building on it.
- [ ] Claude executes the bounded unit and writes its result and evidence into the state file.
- [ ] Codex reads the result and either closes, requests exactly one bounded correction, or escalates a genuine decision to the operator.
- [ ] Both sessions are closed and fresh ones continue the task correctly from the state file and Git alone, with no conversational memory.
- [ ] A small reversible fix stays Direct Work — no state file, no brief, no ceremony.
- [ ] At least two real CRM / Email OS units have completed through the loop and the operator judged the outcomes useful.
- [ ] A written disclosed-limitations list exists for the accepted candidate.
- [ ] The v1 retirement decision was made at pilot start and has been executed — one authoritative Work Loop remains in the repo.

**Non-negotiables** — boundaries no session may cross, even if locally convenient:

- Do not build anything justified only by the Complete System document (doc 4). It is destination reference, never requirements.
- Do not reopen a Proposal § 3 settled decision without new evidence that materially changes it. Planning is closed.
- Do not run a second broad review after a correction. Frozen findings A/B/C; closure checks A/B/C plus blocking regressions only.
- Do not use `/work-loop` (v1) or the emerging v2 to govern any part of this build.
- Do not add a review layer, gate, or governance step beyond the one fresh-context candidate review.
- Every acceptance behaviour is demonstrated against a constructed failing case before it counts as done.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):

- Producing more planning or specification documents instead of evidence. The Proposal says the next session produces evidence, not documents.
- Any work on the Consequential lane, worktrees, automation, hooks, or an independent-reviewer mechanism.
- Editing files outside `plans/work-loop-v2-mvp/`, the new v2 artifacts, and the task-state file — in particular, edits to v1's `docs/work-loop.md`, `docs/work-loop-spec.md`, `.claude/commands/work-loop.md`, or `.agents/skills/work-loop/SKILL.md`.
- A review or correction round discovering a new finding list rather than closing the frozen one.
- An artifact growing longer in its final revision pass (skill-writing standard § 10).
- Process text on a completed unit exceeding its implementation and evidence.

## Open threads

- [x] Step 0 — install the project: commit the four governing documents, the authority README, and this mission
- [ ] Step 1 — investigate Codex-side resource packaging in the real Codex app; commit a short cited findings note
- [ ] Step 2 — transport-seam prototype (throwaway); keep only the conclusions note and the minimal viable schema
- [ ] Step 3 — write the executable core; operator reads and approves it
- [ ] Step 4 — write the slice plan with acceptance behaviours
- [ ] Step 5 — implement Slice 1 (core round trip), fresh session, red-green
- [ ] Step 5 — implement Slice 2 (continuity and correction), fresh session, red-green
- [ ] Step 5 — implement Slice 3 (admission discipline), fresh session, red-green
- [ ] Step 6 — one fresh-context candidate review, frozen by exact commit; one correction pass; accept with limitations list
- [ ] Step 7 — v1 retirement decision (hard boundary at pilot start)
- [ ] Step 7 — pilot two or three real CRM / Email OS units, one with a mid-task session handoff
- [ ] Step 8 — fix demonstrated blockers, run the regression set, post-pilot assessment, execute v1 retirement, stop
