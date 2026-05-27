# Fix plan — 2026-05-27 13:16

**Source command:** `/fix-repo-issues`
**Scanner notes:** [audits/working/fix-repo-issues-2026-05-27-1316.md](../working/fix-repo-issues-2026-05-27-1316.md)
**Working directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
**Items:** 3

## How to execute

Open a fresh Claude Code session in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`. Reference this file by path and instruct Claude:

> Execute the fix plan at `audits/fix-plans/fix-repo-issues-2026-05-27-1316.md`.

Each item below is self-contained — apply in order. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:** YYYY-MM-DD` schema (resolve-improvement-log.md:18) before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [id-07] Orphan Mandate block at logs/session-notes.md bottom — back-fill or trim

- **Source:** [logs/session-notes.md:110](../../logs/session-notes.md#L110)
- **Fix:** Investigate the orphan Mandate block at session-notes.md line 110 (R1 wrap was skipped, leaving an unwrapped block). Preferred action: back-fill a minimal wrap entry that summarizes what that session produced (read the commit history around that date for context). Fallback: trim the orphan block if no load-bearing content can be recovered. Single-file edit to `logs/session-notes.md`.
- **Post-fix log update:** none (this fix IS a log-hygiene edit; no separate status flip required).
- **QC needed:** no — log-hygiene-only edit.

### [id-13] Add `**Verified:** 2026-05-27` line to concurrent-session wrap clobber entry

- **Source:** [logs/improvement-log.md:138](../../logs/improvement-log.md#L138)
- **Fix:** The entry at line 138 ("Concurrent-session wrap clobbers in-progress session's session-notes.md additions") already has `**Status:** applied 2026-05-27` (line 140) and a detailed Implementation note (line 145) covering commits `6b1b018` + `5157a5d`. Per `resolve-improvement-log.md:18`, "Resolved" requires both `**Status:** applied` AND `**Verified:**`. Only the Verified line is missing. Insert a new line directly after line 140 (the Status line):
  ```
  - **Verified:** 2026-05-27
  ```
  No other edits to this entry.
- **Post-fix log update:** none (the edit itself completes the schema).
- **QC needed:** no — substitution-shaped log-hygiene edit.

### [id-14] Add symlink-check-first diagnostic rule to docs/commit-discipline.md

- **Source:** [logs/improvement-log.md:148](../../logs/improvement-log.md#L148)
- **Fix:** Append a short "Foreign-files diagnostic shortcut" subsection to `docs/commit-discipline.md`. The rule: when `git status` flags many `?? .claude/commands/*.md` files under workspace-root, run `find .claude/commands -type l -newer /dev/null | wc -l` (or equivalent symlink check) BEFORE escalating to `/resolve-repo-problem` — most will be symlinks to ai-resources canonical bodies, not real new files. Keep it to 1–3 lines of prose + the one command. Read the proposal at `logs/improvement-log.md:155` for the exact wording the operator already proposed.
- **Post-fix log update:** Flip the improvement-log entry at line 148 from `**Status:** logged (pending)` to:
  ```
  - **Status:** applied 2026-05-27
  - **Verified:** 2026-05-27
  ```
  Add a one-line implementation note referencing the commit SHA of the `commit-discipline.md` edit.
- **QC needed:** no — short doc-edit, substitution-shaped. Light-touch self-check that the new subsection fits the file's existing structure.

## Parked items (not this plan)

- [id-01] Build `/repo-review` command — reason: needs-dedicated-session (full new command, inbox brief at `inbox/repo-review-brief.md`). 51 days stale — surface to operator at next planning moment.
- [id-02] Build `/codex-dd` command — reason: needs-dedicated-session (full new command, pilot-ready, inbox brief at `inbox/codex-second-opinion-brief.md`). 44 days stale.
- [id-03] Build workflow-diagnosis skill — reason: needs-dedicated-session (use `/create-skill` with `inbox/workflow-diagnosis.md`).
- [id-04] Scratchpad clock-skew breaks /prime Step 1b resume detection — reason: needs-dedicated-session (root-cause investigation required; not a one-line edit). Source: `logs/friction-log.md:49`.
- [id-05] Build `/audit-workflow` command — reason: needs-dedicated-session (new inbox brief at `inbox/audit-workflow-pipeline.md`, dropped today).
- [id-09] workflow-diagnosis / improvement-analyst boundary doc — reason: rides with id-03 `/create-skill` fulfillment.
- [id-10] Canonical scope-selection pattern doc — reason: decision-needed (parked until N=3 sibling encodings appear).
- [id-11] Operator-caught review-class gaps watch — reason: decision-needed (2 occurrences; no action until 3rd fires).
- [id-12] Shared rendering convention doc — reason: decision-needed (deferred per DR-7; trigger at 2nd consumer).

## Skipped items

- [id-06] `/session-plan` single-shared-file concurrent-session conflict — reason: already-resolved. `logs/friction-log.md:69` ends with `**[FADING-GATE] verified 2026-05-27:** Resolved by option (b) — commit 8ab5685`. Scanner missed the FADING-GATE annotation.
- [id-08] Concurrent friction-cleanup session collision observation at `logs/session-notes.md:204` — reason: already-resolved (rides with id-06 commit 8ab5685 — the underlying `/session-plan` collision risk that motivated the coordination note is gone). Non-actionable as a standalone item.

## Scanner working-notes path (traceability)

/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-27-1316.md
