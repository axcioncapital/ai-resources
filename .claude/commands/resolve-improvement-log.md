---
model: sonnet
---

Archive resolved entries from `ai-resources/logs/improvement-log.md` so stale items stop re-entering context on every log read.

**Confirmation is load-bearing.** The `[y/n/select]` prompt at step 4 is required and must not be stripped by future autonomy optimizations — removing entries from an operator-facing log is a destructive edit to durable content.

## Instructions

1. **Read `ai-resources/logs/improvement-log.md`.** If the file doesn't exist, tell the operator: "No improvement log at `ai-resources/logs/improvement-log.md`. Nothing to do." Stop.

2. **Parse entries.** Entries are header-bounded `### ` blocks. Each block runs from one `### ` line up to (but not including) the next `### ` line or end-of-file.

   **Malformed-entry handling:** Content preceding the first `### ` header, or orphaned content between blocks that does not belong to a preceding block, is left untouched. Do not error, discard, or attempt to re-anchor. If orphaned content exists, count the lines and mention it in the final summary ("Skipped N orphaned lines, no header").

3. **Classify each entry:**
   - **Resolved (tier 1 — strict)** — the entry contains both a line starting `**Status:** applied` AND a line starting `**Verified:**`.
   - **Resolved (tier 2 — convention)** — the entry's `**Status:**` line contains `resolved` or `RESOLVED` followed by a `YYYY-MM-DD` date (the log's de facto completion convention — most done entries use `Status: ... RESOLVED 2026-06-05 ...` or similar instead of the strict applied+Verified pair; see the 2026-06-12 S8 friction entry that motivated this tier). A `resolved` token *inside the proposal prose* does NOT qualify — only on the `**Status:**` line itself.
   - **Pending** — anything else (missing Status, Status is "logged"/"proposed"/"pending"/"deferred"/"parked", or "applied" without a Verified line).

   Both Resolved tiers are archived identically. In the step-4 presentation, tag each entry `[strict]` or `[convention]` so the operator can spot-check tier-2 classifications cheaply.

   *Schema-sync note (updated 2026-07-03):* the improvement-log.md preamble (L9) now documents both tiers — the lockstep preamble edit deferred in S9 was applied 2026-06-12 S11, so the two ends are converged. Keep this command and the preamble in lockstep on any future classification-rule change.

3b. **Two-tier age detection.** Compute age for each Pending entry: extract the date from the `### YYYY-MM-DD —` header line (or use the most recent `**Review-cycle:**` date if present — deferral resets the clock), then `python3 -c "from datetime import date; print((date.today() - date.fromisoformat('ENTRY_DATE')).days)"`. Skip entries with no parseable date; count them as Pending only.

   **WARM_PENDING (> 21 days) — informational, no per-item prompt.** From the Pending set, collect entries whose age > 21 days and ≤ 42 days. If non-empty, display:
   ```
   {N} warm-pending entries (>21 days — aging):
     1. {date} — {title} — {age} days
     2. …
   Consider reviewing these in the next /friday-act cycle.
   ```
   No disposition prompt. Continue automatically.

   **STALE_PENDING (> 42 days) — per-item disposition required.** From the Pending set, flag entries whose age > 42 days (configurable by operator instruction at invocation). Call this set `STALE_PENDING`.

   - Entries with a `**Review-cycle:**` line are still flagged if the header date is > 42 days — include the Review-cycle value in the display so the operator sees the prior disposition.

   If both `WARM_PENDING` and `STALE_PENDING` are empty, proceed silently to step 4.

   If non-empty, display:
   ```
   {N} stale-pending entries (>42 days without resolution):
     1. {date} — {title} — {age} days{  ·  last review: {Review-cycle value} if present}
     2. …

   Disposition each (one letter per item, in order):
     (r)eview-cycle — update Review-cycle field with new text (prompts for text)
     (e)scalate     — mark active; sets Status: pending (escalated YYYY-MM-DD)
     (c)lose        — mark closed; sets Status: closed YYYY-MM-DD (stays in active log)
     (k)eep         — no change
   ```

   Wait for the operator's per-item disposition string (characters `{r,e,c,k}`). Re-prompt on mismatch.

   Apply dispositions via `Edit` against the active improvement-log before proceeding to step 4:
   - `r` → prompt `New Review-cycle text for "{title}" (e.g., "reviewed 2026-04-25, defer to Q3"):` and set/update the `**Review-cycle:**` line in the entry. **Concrete-trigger enforcement (park-as-graveyard guard):** the `Review-cycle:` reset is the canonical park mechanism (see `improvement-log.md` schema + workspace `CLAUDE.md` § Working Principles), and a park with no real trigger never drains. The text MUST name a concrete deferral target — a calendar date (`YYYY-MM-DD`), a quarter (`Q1`–`Q4`, optionally with a year), a month name, or a named event/condition (e.g., `after /new-project ships`, `when the class recurs`). If the deferral target is vague — bare `later`, `someday`, `eventually`, `TBD`, `when I get to it`, or no target at all — reject it and re-prompt once: `Deferral target must be concrete (a date, quarter, or named event) so the park can drain — re-enter:`. On a second vague reply, fall back to `k` (keep, no change) for that item rather than writing an undrainable park.
   - `e` → set `**Status:** pending (escalated {TODAY})`.
   - `c` → set `**Status:** closed {TODAY}`.
   - `k` → no edit.

3c. **No Active Friction Detection.** From the Pending set — after applying any Step 3b dispositions (entries marked closed or escalated this turn are excluded) — scan each remaining entry body for "no active friction" signals. An entry qualifies if it contains ANY of the following (case-insensitive exact-substring match):
- The field `**Deferred reason:**`
- Any of these phrases: `"not urgent"`, `"future dedicated session"`, `"future session"`, `"graduate-candidate"`, `"graduate candidate"`, `"no active blocking"`

Call this set `NO_ACTIVE_FRICTION`.

**Parked-alive exclusion (park-as-graveyard guard).** From `NO_ACTIVE_FRICTION`, remove any entry that carries a `**Review-cycle:**` deferral line. A `Review-cycle:` deferral is the canonical *park* signal (see `improvement-log.md` schema): the item is intentionally parked **alive** — it must stay in the active log so the `/friday-checkup` stale-scan and monthly park-drain can re-surface it for action or re-park. Archiving it would bury it in the deny-read archive, which is exactly the graveyard this convention prevents. So a parked item is never auto-offered for archival here, even if its body also contains a no-active-friction phrase (e.g. a `Review-cycle:` text that mentions "future session"). To retire a parked item for good, the operator closes it first via the Step 3b `c` disposition (`Status: closed`), which removes the park; a closed item with no `Review-cycle:` line is then eligible for this archive offer on a later run.

If `NO_ACTIVE_FRICTION` is empty after this exclusion, skip silently and continue to Step 4.

If non-empty, display:
```
{N} entries have no active friction (intentionally parked):
  1. {date} — {title}
     Signal: "{matched phrase or field name}"
  2. …

Archive these? They will move to improvement-log-archive.md. [y/n/select]
```

Wait for the operator's reply. Accept the same shapes as Step 6 (`y`, `n`, `select`). On `select`, re-display the numbered list and accept numbers. On confirmation, archive using the Step 7 procedure (append verbatim to improvement-log-archive.md, remove from active log). On `n`, no changes. Then continue to Step 4.

4. **Present resolved entries.** If zero resolved entries exist, tell the operator "No resolved entries to archive. Active log has N pending entries." and stop.

   Otherwise, show a numbered list: date and one-line title only, one entry per line. Then ask exactly:

   > Move these N resolved entries to `improvement-log-archive.md`? **[y/n/select]**
   >
   > - `y` — archive all N
   > - `n` — no changes
   > - `select` — I'll list them again; reply with numbers to archive (e.g., "1 3 5")

5. **Wait for the operator's reply.** Do not proceed without explicit input.

6. **Execute based on reply:**

   **On `y`:** Archive all resolved entries (step 7).

   **On `n`:** Report "No changes." Stop.

   **On `select`:** Re-display the numbered list. Ask: "Which to archive? Reply with numbers (e.g., `1 3 5`), or `all` / `none`." Parse the reply. Archive only the selected subset (step 7).

7. **Archive procedure:**

   **Append-only — do NOT read the archive.** `ai-resources/.claude/settings.json` denies `Read(logs/*archive*.md)` (line 32), which matches `improvement-log-archive.md`. Any "read archive → merge → sort → rewrite" path is blocked by that deny and silently breaks the moment an earlier-dated entry needs archiving. This procedure therefore appends only, and never reads the archive file. The active log's outgoing order IS the canonical chronological order (entries accumulate oldest→newest top-to-bottom), so archive-time append order preserves chronology without a re-sort. **Do not "optimize" this back to a read-merge-sort path — it will hit the deny rule.**

   a. **Create the archive if missing — without reading it.** Run via Bash (a test-then-create guard; never `Read`/`Write` against the archive path, since both would trip the deny or its Read-before-Write requirement):
      ```bash
      test -f ai-resources/logs/improvement-log-archive.md || printf '# Improvement Log — Archive\n\n' > ai-resources/logs/improvement-log-archive.md
      ```

   b. **Append** each selected entry verbatim (full content, preserving all markdown) to the **end** of the archive file, in the order the entries appear in the active log (oldest first, i.e. top-to-bottom). Use a Bash heredoc append (`cat >> ai-resources/logs/improvement-log-archive.md <<'EOF' … EOF`) — the entry text is already in context from the Step 1 read of the active log, so no archive read is needed. Do NOT merge, sort, or rewrite the archive; append-to-end only.

   c. **Remove** the selected entries from active `improvement-log.md`. Use `Edit` with the exact entry text (from start of `### ` line through the line before the next `### ` or EOF). Verify by reading the modified file — the removed entries must no longer appear and no formatting fragments should remain.

   d. **Do not commit.** Staging and commit happen at the operator's next `/wrap-session`. This preserves commit-boundary discipline.

8. **Summarize:**
   ```
   Moved N entries to improvement-log-archive.md.
   Active improvement-log: M pending entries remaining.
   No-active-friction archived: {A} entries. [Omit line if NO_ACTIVE_FRICTION was empty or operator declined.]
   Stale-pending surfaced: {S} entries ({D} dispositioned, {K} kept as-is). [Omit line if STALE_PENDING was empty.]
   [If orphaned content: Skipped K orphaned lines (no `### ` header) — left in place.]
   ```

$ARGUMENTS
