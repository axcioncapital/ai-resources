---
mission_id: { kebab-case-id }
mission_name: { one-line human-readable name }
status: active            # active | paused | completed
started: { YYYY-MM-DD }
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create`. Frozen at creation like a /contract-check contract:
  the Goal / In-Out scope / Definition of done sections are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` are
  meant to change over the mission's life, both edited via `/mission` — never hand-edited
  from inside a working session, and never written to by /session-start.

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: {mission_id}` mandate bullet.
-->

## Goal

{ One sentence naming a concrete DELIVERABLE, not a vague activity. Bad: "improve the research workflow." Good: "the regime-shift project runs end-to-end on the shared research-workflow template, with the template updated to match." What is concretely true when this mission is done? }

## In scope / Out of scope

- **In:** { what this mission covers }
- **Out:** { what is explicitly NOT this mission — the boundary sessions must not cross }

## Validation contract

> Written now, at mission creation — before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, `/qc-pass`) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete:
- [ ] { assertion 1 — observable, checkable }
- [ ] { assertion 2 }

**Non-negotiables** — boundaries no session may cross, even if locally convenient:
- { e.g. "do not expand repo architecture unless the mission explicitly requires it" }

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):
- { e.g. "editing files outside the research-workflow template and the regime-shift project" }

## Open threads

- [ ] { the next concrete piece of work toward the goal }
- [ ] { … }
