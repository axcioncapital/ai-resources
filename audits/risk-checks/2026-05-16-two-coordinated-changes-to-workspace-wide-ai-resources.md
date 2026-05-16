# Risk Check — 2026-05-16

## Change

Two coordinated changes to workspace-wide ai-resources commands:

1. `ai-resources/.claude/commands/session-start.md` — three sub-changes:
   - Removed explicit 5-field enumeration from Step 1 prompt (now just "State the session mandate.")
   - Added one-line omission note after Step 2 confirmation echo
   - Changed `files_in_scope` parsing/write logic: echo still shows inferred content for verification, but mandate line now writes `(inferred)` marker instead of inferred paths when operator didn't explicitly state files; flag tracks specified vs. inferred

2. `ai-resources/.claude/commands/wrap-session.md` — Step 6 expanded:
   - Added 6a: reads today's mandate block from session-notes.md (scans from today's date header to next header or EOF), classifies each sub-field as specified/inferred/omitted
   - Added `Mandate fields:` line to coaching-data template with three-way specified/inferred/omitted tracking; falls back to "none (no /session-start this session)" when no mandate block found

Purpose: make A2–A6 data collection sessions produce machine-readable mandate field coverage in coaching-data.md, consumable by an automated A7 analysis pipeline.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/coaching-data.md` — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is logically self-contained and reversible, but introduces a new implicit parsing contract between session-start (writer) and wrap-session (reader) that is undocumented at one end and silently fails if mandate text uses a different format — mitigations target the coupling and one Medium-tier finding.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `session-start.md` is invoked on-demand (operator types `/session-start`), not auto-loaded — neither edit adds token cost to always-loaded files. Verified via frontmatter (`model: sonnet`, no auto-load metadata) at `session-start.md:1-3`.
- `wrap-session.md` is similarly operator-invoked (per `docs/session-rituals.md:32` and frontmatter `model: sonnet`); the 6a addition adds ~10 lines and the new template field adds 1 line — only loaded when operator runs `/wrap-session`.
- No new hook registration, no new `@import`, no new always-loaded content. Pay-as-used.

### Dimension 2: Permissions Surface
**Risk:** Low

- Both edits are textual changes to existing slash-command markdown files. No tool families, allow/deny entries, or Bash patterns are added.
- The 6a scan reads `logs/session-notes.md`, which `wrap-session.md` already reads at Step 1 (line 23: `Read /logs/session-notes.md (last 5 lines only)`) — no new read scope, just an expanded window within an already-permitted file.
- No settings.json touched per the CHANGE_DESCRIPTION.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touches: 2 (`session-start.md`, `wrap-session.md`).
- Documentation describing `/session-start` mandate format that may now be stale: 4 files reference `session-start` in `ai-resources/`:
  - `.claude/commands/new-project.md`
  - `.claude/commands/prime.md`
  - `docs/operator-maintenance-cadence.md:47` — "State mandate in 2–5 sentences"
  - `docs/session-rituals.md:32-33` — "Mandate: state what you're doing in 2–5 sentences. Writes: `**Mandate:**` line to logs/session-notes.md"
  - `docs/weekly-session-guide.md:74,79,106,160` — includes an example mandate line.
- These docs describe Step 1 prompt phrasing at a high level ("state mandate in 2–5 sentences") rather than the literal 5-field enumeration removed from Step 1, so they remain compatible. No contract break for the documentation surface.
- The 6a parser introduces a new dependency: `wrap-session.md` Step 6a now requires the mandate block in `session-notes.md` to have the exact bullet labels `- Out of scope:`, `- Files in scope:`, `- Stop if:` (verified at `wrap-session.md:38`). This format is set by `session-start.md` Step 3 (lines 71-78). Two callers of the same contract, both edited in this change set — fully internal coupling, compatible.
- One caller modification (wrap-session 6a) is required to keep the change useful, but the change set includes it. No external caller breakage.
- Past mandate entries in `logs/session-notes.md` (verified existing entries 2026-05-16, e.g., the friday-checkup entry) predate the `(inferred)` convention. The 6a parser handles them correctly by design: any non-`(none stated)` / non-`(inferred)` value classifies as **specified**, so historical entries land as specified rather than failing. Backwards-compatible.

### Dimension 4: Reversibility
**Risk:** Medium

- `session-start.md` and `wrap-session.md` are single-file edits — `git revert` cleans both up fully.
- However, `logs/coaching-data.md` is an append-only log. Once `/wrap-session` writes a coaching entry with the new `Mandate fields:` line, a revert of the command does NOT remove the entry. Verified: `coaching-data.md` is append-only at lines 1-80 (entries by date, oldest at bottom — append shape).
- Stale entries in coaching-data.md remain after a revert. They are well-formed prose (the new line is valid markdown), so they don't break anything downstream — but the A7 analysis pipeline (per the stated purpose) may see a mix of "has Mandate fields" and "no Mandate fields" entries across the same era if the change is reverted mid-pilot.
- One extra cleanup step required: if reverted, the operator either accepts the mixed-format entries or manually scrubs the `Mandate fields:` lines from coaching-data.md. This is the Medium criterion (revert works but requires one extra cleanup).
- `logs/session-notes.md` mandate blocks written under the new `(inferred)` convention also persist after revert. Same shape: well-formed text, no breakage, just stylistic mixing.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New implicit parse contract between two commands.** Step 6a in `wrap-session.md` (line 38) parses the mandate block written by `session-start.md` Step 3 (lines 71-78). The parser depends on:
  - Bullet labels appearing exactly as `- Out of scope:`, `- Files in scope:`, `- Stop if:` (case + colon + spacing).
  - The block being delimited by `## YYYY-MM-DD` headers.
  - The marker tokens `(none stated)` and `(inferred)` being literal, exact strings.
  If any future edit to `session-start.md` changes a label (e.g., "Files:" → "Files in scope:" or vice versa, or "(none stated)" → "(unstated)"), 6a silently misclassifies. The contract is not documented in a shared reference doc — only at the two endpoints.
- **Free-text amendment loophole.** `session-start.md:67` says "unrecognised syntax is treated as free-text amendment to `work_scope`." If the operator's correction syntax produces a `files_in_scope` value containing the literal string `(inferred)` (unlikely but possible — e.g., a parenthetical note "(inferred from prior session)"), the 6a classifier would misread a specified value as inferred. Edge case, but the marker collision exists.
- **Header-scan boundary assumption.** 6a scans "from today's `## YYYY-MM-DD` header to the next `##` header (or EOF)". If a session has multiple `/session-start` runs in one day, today's block contains two `**Mandate:**` lines and 6a's behavior on the second is unspecified — likely picks the first only. Minor edge case for multi-mandate days.
- **Coaching-data.md consumer is implicit.** The CHANGE_DESCRIPTION names an A7 analysis pipeline as the consumer, but no consumer code/doc is in the change set or referenced. The new line is a contract written for a future reader. If the future A7 spec lands with different parse expectations (e.g., expects `mandate:` lowercase, or expects JSON-like syntax), this change has to be revisited.
- No silent auto-firing in unexpected contexts; both ends are operator-invoked commands.
- No functional overlap with existing mechanisms — verified: `mandate-parser` skill is explicitly scoped to Phase 5+ (`session-start.md:12`) and writes a different output (`harness/session/mandate.json`).

## Mitigations

- **Dimension 3 (Medium → Low):** No mitigation strictly required; flagged for awareness — when editing any of the four documentation files that reference `/session-start`, re-read `session-start.md` Step 1 prompt text to keep the high-level description aligned. No blocking action.
- **Dimension 4 (Medium → Medium, acknowledge):** Before landing, the operator should accept that coaching-data.md entries written under this change become permanent records of the new format. If a pilot rollback is anticipated, mark the first few entries explicitly (e.g., add a comment line `<!-- new mandate-fields format -->`) so a future cleanup can grep them out cleanly. Optional but reduces revert-cleanup cost.
- **Dimension 5 (Medium → Low):** Add a short "Mandate block parse contract" note to `session-start.md` Step 3 — one line stating "Wrap-session Step 6a depends on these exact bullet labels and the `(inferred)` / `(none stated)` markers; do not rename." This documents the contract at the write site so future editors see it before changing label text. Pair with a matching one-line back-reference in `wrap-session.md` Step 6a ("Format produced by `session-start.md` Step 3 — keep label strings in sync.").

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: line-numbered references to `session-start.md` (lines 1-3, 12, 41, 52, 67, 71-78, 80-82, 92), `wrap-session.md` (lines 23, 38, 49), `docs/session-rituals.md` (lines 32-33), `docs/operator-maintenance-cadence.md` (line 47), `docs/weekly-session-guide.md` (lines 74, 79, 106, 160), `logs/coaching-data.md` (append-only structure verified lines 1-80), and grep counts across `ai-resources/` for `session-start`, `Mandate:`, `coaching-data`, and `files_in_scope`. No training-data fallback was used.
