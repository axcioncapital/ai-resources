---
mission_id: lean-prime-2026-07
mission_name: Reduce /prime to orientation and dispatch — a ≤300-line command
status: active            # active | paused | completed
started: 2026-07-29
---

<!--
  MISSION CONTRACT — a multi-session goal that individual sessions serve.
  Scaffolded by `/mission create`. Frozen at creation like a /contract-check contract:
  the Goal / In-Out scope / Definition of done sections are the north star and should
  not drift session-to-session. Only `status` (frontmatter) and `## Open threads` are
  meant to change over the mission's life, both edited via `/mission` — never hand-edited
  from inside a working session, and never written to by /session-start.

  "Sessions served" is NOT stored here — `/mission read` renders it live by scanning
  logs/session-notes.md for the `Mission: lean-prime-2026-07` mandate bullet.
-->

## Goal

Canonical `ai-resources/.claude/commands/prime.md` is **≤300 lines** and does only orientation and dispatch: every responsibility it currently duplicates from `/session-start`, `/session-plan`, `/open-items`, `/project-next-steps`, `/mission` or the concurrency hooks is delegated to that owner, and every block of historical rationale is moved to a reference doc that is read on demand rather than always loaded — with the short orientation menu, number and free-text selection, required `/session-start` synchronisation and safe dispatch all intact and observably unchanged.

Baseline at mission start, measured 2026-07-29: **830 lines**, of which auto mode (`8c`) is 236 and marker allocation (`8k`) is 147 — 46.1% of the file in two blocks. Evidence: `logs/loop/2026-07-29-prime-minimum-responsibility-frame.evidence.md`.

## In scope / Out of scope

- **In:** canonical `prime.md` (28 symlinked consumers auto-propagate — verified by `stat -L -f %i`, 29 paths share the canonical inode); the delegation seams into `/session-start`, `/session-plan`, `/open-items`, `/project-next-steps`, `/mission`, `detect-concurrent-session.sh` and `/concurrent-session-check`; relocation of rationale into reference docs such as `docs/session-marker.md`; and the extracted allocator script, authored **only** via `/develop-ai-resource` qualification.
- **Out:** any change to observable behaviour — marker grammar, allocation semantics, the `## {date} — Session {MARKER}` header, plan and run-manifest filenames, task routing, or the brief's rendered shape. Also out: the two genuinely distinct 33-line `prime.md` variants (`workflows/research-workflow`, `axcion-sector-intelligence`); rewriting `/session-start` or `/session-plan`'s own logic beyond the seam needed to receive delegated work; and absorbing any `/prime` prose into workspace or project `CLAUDE.md` or into `@.claude/references/harness-rules.md`.

## Validation contract

> Written now, at mission creation — before any implementation session. Defines "done" and "on-mission" independently of how the work gets done, so a fresh-context check (`/drift-check`, `/contract-check`, `/qc-pass`) can judge against it rather than against a session's own account of itself.

**Acceptance assertions** — concrete statements that must ALL be true when the mission is complete:
- [ ] `wc -l` on canonical `prime.md` returns **≤300**, re-derived live at close, not carried from a plan.
- [ ] A grep for the duplication declarations (`Mirrors /session-start`, `matches /session-start`, `identical to /session-start`, `matches /session-plan`, `using /session-plan`, `keep the two in sync`) returns **zero** hits, with a positive control proving the same grep fires on the pre-change file — currently 8 hits.
- [ ] All four unloseable properties demonstrated **by execution**, not by reading the diff: the orientation menu renders; a bare number dispatches; free text dispatches; and `/session-start` finds the marker-bearing header it hard-requires.
- [ ] `logs/scripts/prime-allocator.test.sh` (or its named successor) passes against the **running** implementation rather than a copied subject — baseline 19 passed / 0 failed, re-run at close.
- [ ] No prose moved into an always-loaded surface — verified by grep for `@`-imports across workspace and project `CLAUDE.md`, plus a diff showing neither grew.
- [ ] Any new durable script was qualified through `/develop-ai-resource`, with the resulting record path cited in the closing session's notes.
- [ ] Marker grammar, allocation semantics and session-artifact filenames are observably unchanged, demonstrated by a real `/prime` dispatch producing a correctly-named marker, header, plan file and run manifest.

**Non-negotiables** — boundaries no session may cross, even if locally convenient:
- The scope conflict at `.claude/commands/work-loop.md:247` ("Never edits `/prime`") versus `docs/work-loop.md` § Execution boundary must be resolved by an **explicit operator decision recorded in `logs/decisions.md`** before any unit edits `prime.md`. It survived two Codex review rounds unnoticed on the closed allocator stream; it may not be settled by silence a third time.
- **Behaviour-preserving.** A smaller `/prime` that behaves differently fails this mission. Size is the target; behaviour is the constraint, and the constraint outranks the target.
- No thread closes by assertion. Each closes on an execution-verified check or a recorded decline reason.
- No self-QC-and-commit on an architectural change (workspace `CLAUDE.md` § QC Independence Rule). If independent QC is unreachable, the change is commit-blocked and deferred, not waived.

**Off-mission signals** — what drift looks like for THIS mission (feeds `/drift-check`):
- Editing files outside `prime.md`, its delegation targets' seams, and the reference docs receiving relocated rationale.
- The line count falling because prose was moved into an always-loaded prompt rather than delegated or removed — the cut looks achieved and the token cost is unchanged or worse.
- A Build slice landing without the falsification check its Shape plan declared for it.
- Reopening the allocator-only framing. It was declined at G1 on 2026-07-29 and shown arithmetically insufficient (830 → ~695); reviving it as the whole answer is drift, though extracting the allocator remains valid as **one** slice.
- Reimplementing `/session-start` or `/session-plan` logic inside `/prime` under a new name instead of calling the owner.

## Open threads

- [ ] Resolve the scope conflict: decide whether `/work-loop` may edit `/prime` (`work-loop.md:247` forbids it; `docs/work-loop.md` § Execution boundary permits it and `:260` contemplates it). Record the decision in `logs/decisions.md` before any Build unit runs.
- [ ] Shape unit of stream `2026-07-29-prime-minimum-responsibility`: write the immutable plan with a per-step line budget and an explicit falsification criterion for each slice; Codex pre-implementation review; stop at G1.
- [ ] Qualify the extracted allocator script through `/develop-ai-resource` as a component hand-off — the stream stays open and the unit closes on its ordinary outcome, not `routed-out`.
- [ ] Build slice: delegate auto mode (`8c`, 236 lines) to `/session-start` + `/session-plan` via the existing `{gate:post-plan}` token chain, retaining only item resolution, the done-condition check, the cross-repo mission guard and the single approval gate.
- [ ] Build slice: delegate marker allocation (`8k`, 147 lines — 88 of them comment-only) to the qualified script, relocating its anti-regression rationale to `docs/session-marker.md`.
- [ ] Build slice: consolidate the marker → header → mtime sequence currently written three times across `8a`, `8b` and `8c` into one shared sub-step.
- [ ] Build slice: slim steps 0, 1a, 1c, 1d and 3 by citing their owners instead of restating them — **retaining `/prime` Step 1a's git cross-check**, which `docs/backlog-reconciliation.md:65` names as the reconcile-at-read primitive's reference implementation.
- [ ] Remove the stale prose at `prime.md:281`, which cites `/new-project` step 11a (deleted 2026-07-27) and calls the wrong branch "normal".
- [ ] Prove unit: measure the result against every falsification criterion the Shape plan declared; Codex post-implementation review; stop at G2.
- [ ] Land unit: adopt, hold or reject; stop at G3; close this mission only when the validation contract above is satisfied, not when the checkboxes run out.
