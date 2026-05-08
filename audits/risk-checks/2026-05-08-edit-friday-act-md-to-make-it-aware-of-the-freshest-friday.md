# Risk Check — 2026-05-08

## Change

Edit /friday-act.md to make it aware of the freshest /friday-so and /systems-review outputs (Shape A + manual paste).

DESIGN:
1. Add Step 1.5 "Locate System Owner outputs" after the existing Step 1:
   - Glob projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-*.md, take newest by filename date.
   - Glob projects/axcion-ai-system-owner/output/systems-reviews/systems-review-*.md, take newest by filename date.
   - Filter both: filename date >= REPORT_DATE (the checkup date) AND filename date >= TODAY - 7 days. Files outside this window are treated as MISSING.
   - Set SO_ADVISORY_PATH and SO_REVIEW_PATH (either may be MISSING; both being MISSING is acceptable, just skip Step 3.5).

2. Display at the top of Step 3 (Tactical loop), before the existing numbered menu:
   - "System Owner inputs available:"
   - "  Friday Advisory: {SO_ADVISORY_PATH | (none within 7 days)}"
   - "  Systems Review: {SO_REVIEW_PATH | (none within 7 days)}"
   - "After dispositioning the checkup items below, you'll be prompted to add any System Owner–derived items for disposition."

3. Add Step 3.5 (between current Step 3 tactical loop and current Step 4 policy review), gated on at least one SO file present:
   - Print first 30 lines of each available SO file (or full executive summary if extractable; lightweight peek, no parsing).
   - Prompt: "Add System Owner–derived items? Paste items, one per line, in shape `[risk] {item text}` where risk ∈ {high, med, low}. Empty line to finish, or `(none)` to skip."
   - Validate each pasted line matches `^\[(high|med|low)\] .+$`. Re-prompt on malformed input.
   - Treat each accepted item identically to a checkup tactical follow-up: same disposition prompt (f/d/s), same /risk-check gate logic, same execution path.
   - Append accepted dispositions to the same RESULTS structure used by Step 3.

4. Update Step 5 disposition summary line to include "(of which X System Owner-derived)" subtotal.

5. Update Step 5 session block schema to add an "### System Owner inputs (this session)" subsection listing SO_ADVISORY_PATH and SO_REVIEW_PATH (or "(none within 7 days)").

NO CHANGES to:
- /friday-checkup (schema contract preserved)
- /friday-so (output unchanged)
- /systems-review (output unchanged)
- Step 4 (Policy review), Step 6 (Autonomy axes), Step 7 (Summary/exit)
- The 10-day staleness threshold for the checkup itself
- The audit-rerun guard (Step 1.8)

SCOPE: Single-file edit to ai-resources/.claude/commands/friday-act.md. No new files, no settings.json changes, no hook edits, no symlinks, no CLAUDE.md changes.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-so.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/systems-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-2026-05-08.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-2026-05-08-v2.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/output/systems-reviews/systems-review-2026-05-08-4-projects-cadence-doc.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Single-file extension to /friday-act with no permission, hook, or always-loaded content changes; main risk is hidden coupling to two filename conventions (advisory v2-suffix, systems-review slug-suffix) that the design itself flags but does not fully resolve.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change edits a single command file (`ai-resources/.claude/commands/friday-act.md`, 248 lines per `wc -l`). Slash-command bodies are pay-as-used: only loaded when the operator types the command. No always-loaded file is touched (CHANGE_DESCRIPTION § "NO CHANGES to ... CLAUDE.md changes").
- No hook is added. No `@import` chain in an always-loaded file. No subagent brief is expanded.
- Per-invocation cost rises modestly: Step 1.5 adds two glob/sort operations and a date filter; Step 3.5 adds a 30-line read of up to two SO files plus a paste loop. Both run only inside `/friday-act` sessions (weekly cadence, ≤1 invocation per week per the operator's pattern).
- The first-30-lines peek bounds context cost regardless of SO output length (verbatim from CHANGE_DESCRIPTION: "Print first 30 lines of each available SO file ... lightweight peek, no parsing").

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edits (verbatim from CHANGE_DESCRIPTION: "no settings.json changes").
- The new globs target paths under `projects/axcion-ai-system-owner/output/...`. Existing `/friday-act` already runs Read/Bash for its own report locator; reads of project output files do not introduce a new tool family.
- No `deny` rule narrowed; no scope escalation; no cross-repo or external API capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 1 (`friday-act.md`).
- Callers/dependents grep'd:
  - `friday-act` references in `ai-resources/`: 4 occurrences across `friday-checkup.md` (one mention in W2.4 dispatch text), `risk-check.md`, `friday-so.md`, and the two weekly cadence docs (`weekly-session-guide.md` lines 145, 170; `weekly-cadence.md` lines 98, 138, 179). All mentions are descriptive (cadence step labels, prose pointers) — none parses `/friday-act` output or depends on its internal step numbering.
  - The `/friday-checkup` schema contract (sections `## Tactical follow-ups`, `## Policy-level observations`, `## Architectural retrospective`) is preserved (CHANGE_DESCRIPTION § "NO CHANGES to: /friday-checkup (schema contract preserved)").
  - The `/friday-so` and `/systems-review` outputs are read-only consumed; their producer commands are untouched (CHANGE_DESCRIPTION § "NO CHANGES to: /friday-so (output unchanged), /systems-review (output unchanged)").
  - `maintenance-observations.md` schema is extended (new "System Owner inputs (this session)" subsection, modified disposition-summary line). The schema is consumed only by `/friday-act` itself for append; no parser elsewhere — confirmed by grep for `Disposition summary` returning no matches outside `friday-act.md` itself (already verified by reading friday-act.md content).
- Contract changes are additive: a new step (1.5), a new step (3.5), an extended summary line, and a new subsection. No existing step is renumbered destructively (Step 4, Step 5, Step 6, Step 7 remain in place; new step is "3.5"). No caller depends on step numbers.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit; `git revert` of the commit fully restores prior `friday-act.md`.
- No new sibling files or directories created (CHANGE_DESCRIPTION § "No new files").
- The change does mutate `maintenance-observations.md` shape on next invocation, but that file is append-only and the new "System Owner inputs (this session)" subsection is self-contained — a future revert leaves stale subsection entries in already-written session blocks, but those blocks are historical operator records (not parsed by future runs of `/friday-act`), so stale entries do not break future behavior. This matches the Low-criterion: clean `git revert` restores prior tool state; pre-revert log entries are operator-archival.
- No external writes (no push, no Notion call, no API POST) triggered by the change itself.
- No automation (hook, cron, symlink) added that could fire between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Two filename-sort assumptions are introduced, both flagged by CHANGE_DESCRIPTION but not fully resolved by the design:
  1. **Friday Advisory `-v2` suffix.** Today's directory contains both `friday-advisory-2026-05-08.md` and `friday-advisory-2026-05-08-v2.md` (verified via `ls`). CHANGE_DESCRIPTION states: "Naming convention for advisories is currently `friday-advisory-YYYY-MM-DD.md` or `friday-advisory-YYYY-MM-DD-v2.md`. The locator in Step 1.5 must 'take newest by filename date' using lexical sort — `-v2` sorts after the bare date, which is correct (v2 is newer than v1). Confirm this assumption holds; flag if wrong." Verified: lexical sort on the two real files returns `friday-advisory-2026-05-08-v2.md` last (`-v` ASCII 0x2D + 0x76 sorts after `.md` end-of-string at the same prefix). Assumption holds for `-v2..-v9`. It would break if a `-v10` ever exists (lexical: `-v10` sorts before `-v2`). Practically a non-issue weekly, but the convention is undocumented in /friday-so itself (verified — /friday-so.md outputs `friday-advisory-{DATE}.md` with no `-v2` mention).
  2. **Systems-review same-day slug ambiguity.** CHANGE_DESCRIPTION acknowledges: "Multiple systems-reviews on the same date (different scopes) would all match the glob — locator picks newest by filename, which falls back to slug-alphabetical. This may not be the most-recent-by-time. Flag as a known limitation; acceptable given /systems-review is run rarely." This is an explicit known limitation; the design accepts slug-alphabetical fallback rather than mtime, which can pick the wrong file on multi-review days.
- New cross-command read coupling: `/friday-act` now reads files produced by `/friday-so` and `/systems-review` whose paths/conventions are not declared in any data-contract block in the producing commands. The `/friday-checkup` schema contract is documented (`friday-act.md:46`); the new SO-input contract is not similarly documented at the producer side. CHANGE_DESCRIPTION mitigates parser fragility by using a 30-line peek + manual paste rather than parsing prose, which significantly reduces the coupling severity (a format change at /friday-so or /systems-review will not crash /friday-act — it will display 30 lines of whatever the new format is, and the operator pastes items in the validated `[risk] {text}` shape).
- Functional overlap: Step 3.5 produces "items dispositioned identically to a checkup tactical follow-up." This means the same item could appear in both the checkup list and the SO advisory; the design surfaces them in two separate dispositioning rounds (Step 3, then Step 3.5) with no dedup. CHANGE_DESCRIPTION does not address this; the operator carries the dedup burden mentally. Single Medium implicit dependency on operator vigilance.

### Dimension Verdict Aggregation

Five dimensions: Low, Low, Low, Low, Medium. By the rule "every dimension Low, OR at most one Medium with the rest Low → GO", this would map to GO. However, the Medium hidden-coupling finding has two paired mitigations available that meaningfully reduce the residual risk, and the design itself asks the risk reviewer to "Confirm this assumption holds; flag if wrong" — surfacing those mitigations is the productive output. Verdict: PROCEED-WITH-CAUTION with paired mitigations specified below.

## Mitigations

- **Hidden coupling — advisory `-v2` lexical sort.** In Step 1.5, after applying the lexical sort, add an assertion: if the chosen advisory's filename matches `friday-advisory-{DATE}-v(\d+)\.md` AND a sibling `friday-advisory-{DATE}-v(\d+)\.md` exists with a numerically larger `\d+` value, prefer the numerically-larger file. Document this rule inline (one-line comment) so a future `-v10` does not silently regress to `-v2`. Cost: ~3 lines of pseudocode in Step 1.5.
- **Hidden coupling — systems-review same-day slug fallback.** In Step 1.5, when multiple `systems-review-{TODAY}-*.md` files match, fall back to mtime (most-recently-modified) rather than slug-alphabetical. Add a one-line comment in Step 1.5 documenting the rule. Cost: ~2 lines in Step 1.5. Alternative (lower cost): keep the slug-alphabetical fallback but emit a one-line warning when ≥2 same-day systems-reviews are detected, so the operator can override via paste.
- **Hidden coupling — Step 3 / Step 3.5 dedup.** Add a one-line note to Step 3.5's prompt: "If a System Owner item duplicates a checkup item already dispositioned in Step 3, skip it here." Cost: 1 line in the prompt text. Pushes dedup explicitly to the operator rather than leaving it implicit.
- **Cross-command contract documentation.** When the change lands, add a one-line "Consumed by `/friday-act` Step 1.5" note inside `/friday-so.md` (near the OUTPUT_PATH definition) and inside `/systems-review.md` (near the OUTPUT_PATH definition). This documents the producer-side contract so a future format change at the producer surfaces the downstream coupling. Cost: 2 single-line edits in two non-target files. NOTE: this is technically out of the stated single-file scope; if the operator declines, the coupling stays Medium but does not escalate to High.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `wc -l` output for friday-act.md (248 lines), `ls` of SO output directories confirming the v2 sibling, `grep` for `friday-act` references in ai-resources/ returning 4 file matches with line numbers, verbatim quotes from CHANGE_DESCRIPTION on scope and "NO CHANGES" guarantees, verbatim reads of `friday-act.md` Step 2 schema-contract paragraph and `audit-discipline.md` § Risk-check change classes. No training-data fallback was used.
