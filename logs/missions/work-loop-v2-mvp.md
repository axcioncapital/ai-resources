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

- [ ] Codex is given an objective and writes a bounded brief into a task-state file; **Claude commits it** — the operator transports nothing by hand.
  - *Amended 2026-08-01 (operator decision, session S4-1bc). Original wording: "…writes a bounded brief into a task-state file, **and commits it**". The substance is unchanged — a bounded brief reaches the state file and is committed, with nothing carried by hand. Only who runs the commit changed. Basis: Codex was refused write access to `.git` in two independent sessions, with a positive control proving it is not a repository fault ([`step-2-transport-seam-conclusions.md`](../../plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md) § 2). This now matches the amended destination behaviour 1 recorded in [`plans/work-loop-v2-mvp/README.md`](../../plans/work-loop-v2-mvp/README.md) § "Decisions taken after v0.4". This is the only amendment made to this frozen contract; the freeze otherwise stands.*
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
- [x] Step 1 — investigate Codex-side resource packaging in the real Codex app; commit a short cited findings note — done 2026-08-01 S1-eb7, `plans/work-loop-v2-mvp/step-1-codex-packaging-findings.md` (`592176b`)
- [x] Step 2 — transport-seam prototype (throwaway); keep only the conclusions note and the minimal viable schema — done 2026-08-01 S2-af1, round trip run once end to end, `plans/work-loop-v2-mvp/step-2-transport-seam-conclusions.md` (`6596d16`), prototype discarded (`a8e175d` → removed)
- [x] Step 3 — write the executable core; operator reads and approves it — done 2026-08-01 S3-19b, `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md` (`6f169fb`), operator approved. Independent subagent QC: PASS WITH CORRECTIONS — 1 blocking + 4 bounded fixed under frozen findings (`cba9bd8`), 4 deferred. Operator settled the escalated open item — Claude commits the state file (`003fdac`). ⚠ That decision amends the Proposal's destination behaviour 1 and **contradicts acceptance assertion 1 below**, which still reads "Codex … commits it"
- [x] Step 4 — write the slice plan with acceptance behaviours — done 2026-08-01 S4-1bc, `plans/work-loop-v2-mvp/step-4-slice-plan.md` (`2ebc2f1`), 3 slices × 4 acceptance behaviours, each carrying a constructible failing case and a trace to a destination behaviour or core section. Slice 1's split point made concrete (Claude side first, with the reason). Two non-behaviour build obligations recorded for the Step 5 sessions (`.gitignore` re-include; explicit `$name` invocation). All 8 Phase 4 regression items reconciled — 6 map to a slice, 2 are built by nothing and that is correct. Operator glanced and approved. Acceptance assertion 1 amended the same session by operator decision
- [x] Step 5 — implement Slice 1 (core round trip), fresh session, red-green — done across two sessions per the plan's own split point: Claude side (1.2, 1.3) 2026-08-01 S5-646, Codex side (1.1, 1.4) 2026-08-01 S6-974. All four behaviours green against constructed failing cases. Evidence: `plans/work-loop-v2-mvp/step-5-slice-1-evidence.md`; harness `logs/scripts/work-loop-v2-slice-1.test.sh` 34/34 exit 0 (`9efa24e`, `383694b`, `6565138`, `8bcfb9a`, `1336966`, `cb71f18`, `d45c8f8`). The watched premise held — explicit `$name` invocation worked under Codex's over-cap description budget, for one observed invocation. ⚠ Two limitations recorded rather than smoothed over: **1.1 is green on routing, not folder creation** (the slice plan's "checkout where `logs/work-loop/` does not exist" case was unconstructible — the folder already existed), and the Claude-side command and harness are recorded **unassessed** — no independent review ran. **Operator decision 2026-08-01: no separate review is sized for Slice 1, and this is settled, not deferred.** Reasons: a second review layer beyond Step 6's one fresh-context candidate review is forbidden by this mission's own non-negotiables; Slice 2's behaviour 2.1 (a fresh session continuing from the state file and Git alone) exercises the Claude-side command harder than a reading review would; and the 34-assertion harness is the standing check. Do not re-raise this — `unassessed` here is a record, not a queued task
- [x] Step 5 — implement Slice 2 (continuity and correction), fresh session, red-green — done 2026-08-01 S7-3fc, all four behaviours green against constructed failing cases. 2.1 exercised by a genuinely fresh session (delivers the substitute exercise the Slice 1 no-review decision relied on); 2.2 shown red at two layers before the fix, and the file-identity field is now proven; 2.3 exercised through a real Codex assessment — two frozen findings, one bounded round, the newly noticed problem deferred at closure in Codex's own words; 2.4 through a real menu choice made once, on value and risk (accept as a written limitation). Harness extended 34 → 78 assertions, 78/78 exit 0 (`22e987d`). Evidence: `plans/work-loop-v2-mvp/step-5-slice-2-evidence.md` (`6fe2403`). ⚠ Limitations recorded rather than smoothed: Slice 2's opening briefs were hand-written fixtures (Codex opening was proven in Slice 1 and not re-exercised); the menu task's first pass and assessment block are fixture material — its correction hand-back and closure are real; folder creation from an absent `logs/work-loop/` remains untested; the menu closure needed one Codex re-run (the first run wrote nothing — caught by disk verification, which is the protocol working)
- [ ] Step 5 — implement Slice 3 (admission discipline), fresh session, red-green
- [ ] Step 6 — one fresh-context candidate review, frozen by exact commit; one correction pass; accept with limitations list
- [ ] Step 7 — v1 retirement decision (hard boundary at pilot start)
- [ ] Step 7 — pilot two or three real CRM / Email OS units, one with a mid-task session handoff
- [ ] Step 8 — fix demonstrated blockers, run the regression set, post-pilot assessment, execute v1 retirement, stop
