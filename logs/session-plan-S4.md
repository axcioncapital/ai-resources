# Session Plan — 2026-05-29 S4

## Intent

Close the two literal-pattern brittleness bugs that surfaced today (TOCTOU wrap-session false-positive at 14:20 + /open-items cross-match miss), plus codify the SO process observation as a Friday-triage candidate and verify the QC-fixed backup-script regex. All same-command logic edits in the no-/risk-check class. Fresh-context advantage from today's TOCTOU Phase 2+3 atomic landing.

## Model

Recommended: `claude-opus-4-7[1m]` (current). Decision-rich edits to canonical command bodies + matcher contract design — Opus tier. Match.

## Source Material

- `logs/friction-log.md` 2026-05-28 14:20 entry — wrap-session false-positive friction, deferred 2026-05-28 pending Phase 2 landing (now satisfied by commit `9f91b2f`)
- `logs/improvement-log.md` 2026-05-29 entry — /open-items cross-match too literal (logged by /resolve-repo-problem MANUAL mode this session)
- `audits/working/2026-05-29-resolve-open-items-cross-match-too-literal.md` — full triage notes, recommends Option B (tolerance match)
- `logs/maintenance-observations.md` — SO process observation: pre-spec grep checklist for renamed paths
- `logs/decisions.md` 2026-05-29 entries — TOCTOU Phase 2+3 Option A atomic, asymmetric writer/reader marker discipline
- `docs/session-marker.md` — canonical marker contract (Phase 2+3 atomic landing)
- `docs/audit-discipline.md` — risk-class enumeration (confirms all 4 items in no-/risk-check class)

## Findings / Items to Address

**Item 1 — wrap-session.md Step 3.5 foreign-session guard.** Current `FOREIGN = ADDED_HEADERS - PRIME_RAN` with `PRIME_RAN=1` is a binary subtractor that false-positives on auto-mode chained tasks. Replace with marker-aware counter: read THIS session's marker from `logs/.session-marker`, grep `## YYYY-MM-DD — Session ${MARKER}` count in `session-notes.md`, subtract that count. Phase 2+3 atomic landing today makes marker-scoped attribution exact.

**Item 2 — open-items.md Step 1 friction-log T1 cross-match.** Current two-literal-pattern contract requires strict `friction-log <HH:MM>` adjacency, missing prose phrasings like "Friction-log entry 2026-05-28 10:05." Replace with four-condition tolerance match per audits/working triage Option B: (1) HH:MM present in improvement-log entry body, (2) friction's YYYY-MM-DD present in body OR `Verified:` within ±1 day, (3) `friction-log` (case-insensitive) appears within same sentence/bullet as HH:MM (arbitrary intervening words), (4) `Status: applied` + non-empty `Verified:`.

**Item 3 — improvement-log SO observation entry.** Promote the maintenance-observations.md SO observation ("pre-spec grep checklist for renamed paths") to a `logged (pending)` improvement-log entry. Currently the observation lives only in maintenance-observations.md with lower retrieval visibility. Appending to improvement-log surfaces it in `/friday-checkup` Step 6.

**Item 4 — backup-session-plan.sh regex smoke-test.** Last session's QC REVISE broadened the regex from `(-[a-zA-Z0-9]+)?` to `(-[a-zA-Z0-9]+){0,2}` to cover `session-plan-S1-pass2.md` shapes. Verification was by inspection only. Run the script in a tmp dir against synthetic inputs: `session-plan-S1.md`, `session-plan-S1-pass2.md`, `session-plan-pass3.md`. Confirm zero silent-skip cases.

## Execution Sequence

1. Implement Item 1 (`wrap-session.md` Step 3.5 marker-aware counter)
2. `/qc-pass` on Item 1
3. Commit Item 1 (separate commit for clean rollback boundary)
4. Implement Item 2 (`open-items.md` Step 1 tolerance match)
5. `/qc-pass` on Item 2
6. Commit Item 2 (separate commit)
7. Implement Item 3 (append improvement-log entry for SO observation)
8. Commit Item 3 (can bundle with Item 2 commit if both touch logs/.md only, but separate keeps history clean)
9. Run Item 4 smoke-test in `/tmp` against synthetic filenames; record result in session-notes
10. Prompt operator to `/wrap-session`. Push gate handles 3 ai-resources commits + 1 workspace-root carryover commit `9fb19f4`.

## Scope Alternatives

- **Minimum:** Item 1 only. Closes the most recently surfaced friction. ~30 min. Defers Items 2–4 to next session.
- **Recommended (this plan):** All 4 items. ~75–90 min. Same risk class, same fresh-context advantage, thematically coherent.
- **Expanded:** Add FL-1+FL-6. **Rejected** per the 2026-05-29 deferred-stack ordering decision — would force a /risk-check gate into a no-/risk-check session and re-create the AP-8 context-contamination pattern.

## Autonomy Posture

Full autonomy. All 4 items are same-command logic edits or read-only verification, in the no-/risk-check class per `audit-discipline.md`. Decision-Point Posture applies for per-edit choices. `/qc-pass` is the gate between edit and commit for Items 1 and 2. Item 3 is a log append (no QC required). Item 4 is a smoke-test (no edit, result recorded in session-notes).

## Risk

- **No `/risk-check` gate** for any item:
  - Item 1: single-command logic edit, no shared-state reorder despite operating on shared-state read (the read pattern itself is unchanged; only the subtractor logic shifts from binary to count).
  - Item 2: matcher contract edit inside one command, no downstream consumers.
  - Item 3: log append.
  - Item 4: read-only verification.
- **`/qc-pass` after each substantive edit** covers correctness verification on Items 1 and 2.
- **Per-item commit** prevents one bad fix from blocking the others.
- **Cumulative-drift risk:** Low. Two surgical fixes + one log append + one verification. `/contract-check` is optional unless QC rounds compound (>1 round per item).
- **Push gate:** 3–4 commits accumulated by wrap (1 workspace-root carryover + 2–3 from this session). Single `/wrap-session` confirmation prompt per workspace rule.
