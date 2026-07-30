BRIEF
UNIT: 2026-07-30-prime-session-entry-ownership-frame
STREAM: 2026-07-30-prime-session-entry-ownership
PHASE: frame
REPO: ai-resources
BASE: 4f397f7
NEXT: Claude — run Frame, then open Shape

**Capability:** prime-runtime-delegation

**Claude-authored brief**, transcribed from the operator's written direction of 2026-07-30. No
independent framing — a recorded weakness of the unit. The direction itself is an operator decision and
is **not in scope for re-argument**.

**Same capability, new stream.** `prime-runtime-delegation` is at `status: revise`, which means more
work is expected on it. The predecessor stream `2026-07-29-prime-minimum-responsibility` closed
2026-07-30 with its Shape plan falsified and its slice list spent, so its stream could not be continued;
the capability continues here.

Need: `/prime` at 411–413 lines is an **interim result, not an accepted endpoint**. The predecessor
delivered a real reduction (635 → 413) that **does not execute** anywhere except `ai-resources`, and it
moved the session-entry owner one third of the way — marker only, leaving header and mtime in the
prompt. This stream corrects the seam, completes the move, and continues the lean-down to ≤300.

## Settled by operator decision — verify, do not re-litigate

**Target.** ≤300 lines, frozen. Not renegotiated, not replaced by the ≤430 waypoint. Mission
`lean-prime-2026-07` stays `active`.

**Architecture.** `/prime` orients → shows the menu → interprets the selection → establishes session
entry → dispatches → stops. Six responsibilities:

1. Call synchronisation and state collectors.
2. Judge and display up to six tasks.
3. Interpret the operator's response.
4. Call one session-entry owner.
5. Dispatch `{mode, task, mission}` to `/session-start`.
6. Stop.

**Remove.** Remaining `/risk-check` machinery and `STRUCTURAL_RISK` handling · remaining `/qc-pass` or
legacy QC machinery · model-alignment reporting · **multi-item auto mode** (`auto 1,3`, deduplication,
combined-mandate machinery — `auto` and `auto N` retained) · decisions/telemetry prefetch performed for
a future `/wrap-session` · urgent-log triage over `friction-log.md` and `improvement-log.md`, with
important work promoted into an authoritative task source instead.

**Move out.** Git synchronisation and autostash classification → one tested executing owner returning a
short status · marker, header and mtime writes → **one complete atomic session-entry owner** · concurrent-
session detection → consume the existing hook/owner result rather than rescanning · mechanical collection
of repository history, missions, scratchpads and plan state → one executing collector, with judgement
over its result allowed to remain in `/prime` · planning, direct-route behaviour, approval tokens and
execution → `/session-start` and `/session-plan` · everything after successful dispatch.

**Retain but compress.** Git reconciliation of previous next steps · project position and the short task
menu · wrong-repository mission protection · plan-mode protection · the distinction between numbered
selection, free-text intent and single-item `auto`.

**Prohibited postures.** Do not re-propose removed machinery. Do not ask for each removal to be approved
again. Do not treat "behaviour preserving" as requiring preservation of a feature the operator has
retired. Where a removal has a **concrete, evidenced** technical blocker, surface it and design the
smallest replacement that preserves the required **outcome** — never the existing machinery.

**Multi-item auto mode is a reversal.** It was retained at the 2026-07-29 handoff on usage evidence
(~10 real `auto 1,3` runs in `logs/session-notes*.md`). That evidence is **not** a counter-argument to a
retirement decision and is not to be raised again.

Premises to verify in this unit:
- Each removal target still exists at HEAD, at the line ranges last measured — `STRUCTURAL_RISK`
  (`:399`, `:407`), legacy QC (`:131`), model alignment (`:198–202`), multi-item auto (`:373`), log-trio
  prefetch (`:61–62`), urgent-log triage (`:172–194`). Re-derive live; do not carry these numbers.
- The session-entry seam is as the Prove unit measured it: `prime-marker.sh` owns marker allocation
  only, Step 8k states it does not touch `session-notes.md`, and `prime.md` still references
  `session-notes.md` 17 times.
- 31 of the 32 roots carrying the `prime-marker.sh` call lack the script; `ai-resources` is the only one
  that does not.
- `docs/session-marker.md:339` still cites the removed `/prime` Step 8c.2.
- No consumer holds a non-canonical copy of `prime.md` that a fix would miss (the two 33-line variants
  and the `ai-resources-work-loop` worktree copy are known and excluded).

Falsified if: the six-responsibility architecture cannot be reached without breaking a retained route;
any removal has an evidenced blocker with no smaller outcome-preserving replacement; or the ≤300 target
is unreachable **after** every listed removal and move-out has landed — which is a measurement to report
at Prove, never a reason to renegotiate the target here.

**Scope of THIS unit:** Frame only — need, ownership, seam and scope. **No edit to `prime.md`, to any
script, or to any consumer.** Shape owns the plan and its falsification criteria; G1 gates the slice list.

Gates: challenged route — G1 (scope and package, end of Shape) · G2 (release, end of Prove) · G3
(lifecycle, at Land). Exactly three. `/risk-check`, `/qc-pass` and subagent review are **retired**, not
declined. Codex is the sole independent reviewer, through `/work-loop`.

**Not inheritable from the predecessor.** The thirteen `unassessed` criteria cannot be carried: every
dispatch criterion must be re-run from a real project-consumer root against the then-current package,
and F-DUP needs its eight duplication declarations enumerated explicitly before it can be measured at
all. **Nothing is presented as complete unless `prime.md` is ≤300 and the retained numbered, free-text
and single-item-auto routes pass from a project consumer.**
