---
task: foreign-staging-target-repo
turn: codex
---

## Objective and approved scope
Close the repaired foreign-staging target-repository defect honestly: make the operator-facing
contract match the live hook, mark the originating defect resolved, and retire its promoted queue
item.

Scope: `docs/commit-discipline.md`; the 2026-07-19 nested-target entry in
`logs/improvement-log.md`; and only the checkbox for promoted item `8c600934fdd0` in
`logs/next-up.md`. The operator added that single tick to the boundary on 2026-08-01. No hook,
harness, settings, other improvement entry, or other queue item may change.

## Current lane and unit
Standard. Named reason for the loop: this pilot task crossed sessions and repositories, repaired a
globally wired guard, and requires an independent closure judgment against executable evidence.

Unit 3 — closure documentation and recorded-defect retirement.

## Brief
Why: the implementation and maintained-copy work are accepted, but the durable contract still
describes repository/footprint resolution too loosely and overstates the commit arm's practical
coverage. The originating improvement entry and its promoted queue item still read open. Closing the
task without reconciling those surfaces would make finished work look unfinished and leave operators
with an inaccurate safety model.

Check these premises before editing:

1. `docs/commit-discipline.md`'s Foreign-staging tripwire section still lacks the accepted split
   between **session scope** (marker, mandate, footprint) and **target scope** (candidate discovery),
   the single-leading-literal-`cd` behavior, and the wide-add fail-closed boundary.
2. The same section says the hook acts "before a gated git verb runs" but does not disclose that a
   combined `git add <explicit-path> && git commit` reaches PreToolUse before the add and therefore
   gives the commit arm only the index that existed before the command.
3. The 2026-07-19 nested-target improvement entry remains `logged (pending)`, while the live
   canonical harness records 15/15 green and Unit 2 established the copy dispositions.
4. `logs/next-up.md` contains exactly one unchecked item with id `8c600934fdd0`; no other occurrence
   of that id or duplicate queue row exists on that named surface.

If any premise is false or ambiguous, record what was inspected and found, set `turn: codex`, commit
the state-file update, and stop.

Required changes:

- In `docs/commit-discipline.md`, update only the Foreign-staging tripwire section so it accurately
  states:
  1. the command's resolved target repository supplies staged candidates, while the active
     session/project supplies marker, mandate, and footprint;
  2. candidate and footprint paths are compared in one absolute coordinate system;
  3. payload cwd is pre-command cwd; one leading literal `cd <path> &&` is resolved, including safely
     quoted literal paths, while an unresolvable target on a working-tree-wide add exits 2;
  4. that ambiguity block is intentionally limited to wide adds; a gated commit with an
     unresolvable `cd` falls back to base cwd;
  5. the commit arm sees the pre-command index, so a combined explicit add-and-commit does not make
     the just-added path visible to that arm. Its original threat model — a foreign session already
     populated the shared index — remains covered.
- Name both accepted deferrals as **known limitations, not repaired behavior** in that same section:
  1. a plain-subdirectory project's own `proj/logs/.session-marker-*` may not match the existing
     repo-root-relative byproduct exemption;
  2. whether to widen coverage for combined explicit-add-and-commit commands remains a separate
     decision. Do not prescribe a fix.
- Mark only the 2026-07-19 nested-target improvement entry resolved on 2026-08-01. Preserve its
  historical observations, the two RECONSIDER gate outcomes, and the rejected soft-warn proposal;
  append a concise resolution record that names the canonical 15/15 harness, session/target scope
  separation, quoted-literal and fail-closed coverage, `.codex` parked, sector fork synchronized with
  two exemptions, and the two deferrals.
- Change only item `8c600934fdd0` from `[ ]` to `[x]` in `logs/next-up.md`.

Evidence required:

- Re-run the canonical harness: 15/15 green, exit 0. This is the executable backing for the contract;
  do not substitute prose inspection.
- Show a scoped diff proving only the three authorized files changed and only the one named checkbox
  changed in `logs/next-up.md`; the check must fail if any second checkbox or queue text changes.
- Mechanically verify the originating improvement entry now has a resolved status and the exact queue
  id appears once and is checked. Run whitespace/syntax checks appropriate to Markdown.
- In the hand-back, map each new contract statement to the live hook branch or harness case that
  supports it. If a statement has no support, remove it or stop; do not turn inference into contract.

Stop if documentation accuracy would require another hook change, if resolving the entry would erase
its gate history, if either deferral cannot be described without choosing a remedy, or if the
one-checkbox-only boundary cannot be proven.

## Latest material result

Inspected (2026-08-01):
- Claim (1): HOLDS — searched `docs/commit-discipline.md:39-64` for `target repo|target scope|session
  scope|leading cd|payload cwd|fail.closed|absolute coordinate`; zero matches.
- Claim (2): HOLDS — `docs/commit-discipline.md:44` carries the phrase "Before a gated git verb runs";
  searched the same 39–64 range for `pre-command|index that existed|before the add|combined`; zero
  matches.
- Claim (3): HOLDS — `logs/improvement-log.md:1550` read `- **Status:** logged (pending)`; both
  RECONSIDER outcomes present, § SECOND GATE OUTCOME at `:1578`, original soft-warn proposal at
  `:1574`.
- Claim (4): HOLDS — `grep -c '8c600934fdd0' logs/next-up.md` = 1, at `:20`, unchecked; no duplicate
  row on that surface.

Result: the three authorized closure edits are made and nothing else. `docs/commit-discipline.md`
§ Foreign-staging tripwire now states the target/session scope split, the single absolute coordinate
system, the leading-`cd` resolution rules including safely quoted literals, the wide-add-only
fail-closed boundary, and the commit arm's pre-command-index bound; both deferrals are recorded there
as **known limitations, not repaired behaviour**, with no remedy prescribed.
`logs/improvement-log.md:1550` is `RESOLVED 2026-08-01` with a § RESOLUTION record appended and the
full gate history preserved. `logs/next-up.md:20` is the only checkbox changed.

Evidence:
- Canonical harness `bash logs/scripts/check-foreign-staging.test.sh` → **15/15 green, exit 0**
  (unchanged by this unit; no hook or harness file was touched).
- Boundary proof (`scoped-diff-check.sh`, run this session) → **PASS**: only the authorized files
  differ from HEAD, `logs/next-up.md` shows added=1/removed=1, the changed row is the
  `8c600934fdd0` row, and the flip is `- [ ]` → `- [x]`. **Falsified**: with a second checkbox
  deliberately flipped it reports FAIL on three separate assertions. It also verifies the four
  preservation properties on the improvement entry (resolved status, both gate outcomes, the second
  gate section, the rejected soft-warn proposal labelled as still rejected).
- `logs/friction-log.md` also differs from HEAD. It is the Write-Activity hook's own append-only
  byproduct, and the exclusion is **earned, not asserted**: the check verifies 0 non-timestamp
  additions and 0 removals before excluding it, and judges it as unauthorized otherwise.

Contract statement → live support (each mapped, per the brief; nothing carried on inference):
1. Target scope supplies candidates / session scope supplies marker, mandate, footprint →
   `check-foreign-staging.sh:304`, `:308-326`, `:368`; harness `C1_nested_cwd_uses_nested_dirt`,
   `C9_session_scope_infootprint_allows`, `C10_session_scope_outfootprint_blocks`.
2. One absolute coordinate system → `:772-782`; harness `C13_subproject_infootprint_allows`,
   `C14_subproject_outfootprint_blocks`.
3. Payload cwd is pre-command; one leading literal `cd` resolved, quoted literals included;
   unresolvable wide add exits 2 → `:236-241`, `:243-281`, `:288-302`; harness
   `C7_payload_cwd_beats_process_cwd`, `C8_absent_payload_cwd_falls_back`,
   `C11_quoted_cd_resolves_target`, `C12_variable_cd_fails_closed`, `C3_cd_compound_matches_nested`,
   `C4_subshell_fails_closed`.
4. Ambiguity block limited to wide adds; a gated commit with an unresolvable `cd` falls back to base
   cwd → `:288` (the `and is_add_wide` conjunct) and its `:283-287` rationale. **No dedicated harness
   case exists for the commit-fallback direction** — stated rather than implied.
5. Commit arm sees the pre-command index → `:690`, `:699-700`; **no harness case**, so it was
   re-proved by execution this session on an isolated two-file fixture repo: the same foreign file
   returns exit 0 through `git add F && git commit` and exit 2 when pre-staged.

Noticed mid-unit, recorded and NOT implemented (deferrals, per core § 5):
- The boundary check's first draft used `^-[^-]` to count removed diff lines. A markdown checkbox row
  is itself `- [ ] …`, so its diff line reads `-- [ ] …` and the pattern matched nothing — the check
  reported "0 removed" on exactly the rows it exists to police, which is the reassuring answer. Same
  failure class as the 2026-07-19 GNU-idiom entry at `logs/improvement-log.md:1549`. Caught because
  the count disagreed with the visible diff. No repo artifact carries this bug; it is recorded as a
  pattern, not a fix.
- **Disclosure:** the falsification run mutates the live `logs/next-up.md`, and its first execution
  left a second checkbox (`890b40e5ea5c`, `:6`) flipped to `[x]`. It was restored by hand and the
  boundary check re-run clean afterwards — the PASS above is post-restore. Flagged because a
  falsification harness that dirties the file it audits is a hazard worth a decision, not something to
  leave silent.

Prior units, unchanged: Unit 1 accepted — canonical target/session resolution repaired and falsified,
15/15 green after one correction and one final bounded fix. Unit 2 accepted — `.codex` parked
unchanged; sector fork synchronized to canonical with exactly `qc-log.md` and
`research-quality-log.md`; canonical and sector both 15/15 green. Sector commit: `563e3fe`.

Decisions for closure: ambiguous-target fail-closed remains wide-add-only; `.codex` stays parked;
sector remains canonical plus its two local exemptions.

Deferrals for closure, documentation only in this unit: subdirectory-project byproduct exemption
coordinates; combined explicit-add-and-commit coverage. Neither may be implemented here.

## Next action
Codex: assess Unit 3 and, if accepted, write the final closing record — this state file is left
unreduced, as instructed.

Four things are put to the assessment explicitly rather than buried in the result:

1. Contract statements 4 and 5 rest on a live hook branch plus, for 5, a one-off execution probe —
   **neither has a permanent harness case**. Judge whether documenting them at that support level is
   acceptable at closure, or whether either needs a case before the task closes.
2. The falsification harness dirties the live `logs/next-up.md` and did leave a stray flip that had to
   be restored by hand. Judge whether that is acceptable as a throwaway check or needs a decision.
3. The `docs/commit-discipline.md` known-limitations block deliberately prescribes no remedy for
   either deferral, per the brief's stop condition. Confirm that reads as intended.
4. The `.codex` fork stays parked at 464 lines against 838 canonical. The § RESOLUTION record now
   states that divergence as deliberate. Confirm that is the disposition you want on the record.
