---
model: sonnet
---

Archive resolved entries from `ai-resources/logs/improvement-log.md` so stale items stop re-entering context on every log read.

**Confirmation is load-bearing.** The `[y/n/select]` prompt at step 4 is required and must not be stripped by future autonomy optimizations — removing entries from an operator-facing log is a destructive edit to durable content.

## Instructions

1. **Read `ai-resources/logs/improvement-log.md`.** If the file doesn't exist, tell the operator: "No improvement log at `ai-resources/logs/improvement-log.md`. Nothing to do." Stop.

2. **Parse entries.** An entry begins at a **dated** heading at level 2 **or** 3 — regex `^#{2,3} \d{4}-\d{2}-\d{2}` — and runs up to (but not including) the next such heading or end-of-file.

   **Why both levels, and why `dated` is the discriminator.** The schema specifies `### YYYY-MM-DD — {title}`, but heading drift happens: on 2026-07-18 six live entries carried `## YYYY-MM-DD` instead. A `### `-only boundary does not skip those entries — it **silently merges them into the entry above**, which is far worse than missing them. Concretely: an *open* finding written with `##` became mechanically part of the preceding *resolved* entry, so archiving the resolved one would have carried the open finding into the deny-read archive with it. (Caught in external review the same day; the six headings were normalized to `###` at the same time, so today both ends agree — this rule is the guard against the next drift, not a workaround for the current one.) The date is what separates an entry heading from a structural one: `## Schema` at the top of the log must never be read as an entry boundary, and requiring `\d{4}-\d{2}-\d{2}` excludes it without a name blocklist.

   **Malformed-heading reporting.** While parsing, count entries whose heading is `## ` rather than `### `. If any exist, name them in the Step 8 summary (`{N} entries use a '##' heading — normalize to '###'`). Parse them correctly *and* report them: silently accepting drift is how the schema erodes.

   **Malformed-entry handling:** Content preceding the first dated heading — which includes the `## Schema` preamble, correctly, since it carries no date — or orphaned content between blocks that does not belong to a preceding block, is left untouched. Do not error, discard, or attempt to re-anchor. If orphaned content exists, count the lines and mention it in the final summary ("Skipped N orphaned lines, no header").

3. **Classify each entry:**
   - **Resolved (tier 1 — strict)** — the entry contains both a line starting `**Status:** applied` AND a line starting `**Verified:**`.
   - **Resolved (tier 2 — convention)** — the entry's `**Status:**` line contains `resolved` or `RESOLVED` followed by a `YYYY-MM-DD` date (the log's de facto completion convention — most done entries use `Status: ... RESOLVED 2026-06-05 ...` or similar instead of the strict applied+Verified pair; see the 2026-06-12 S8 friction entry that motivated this tier). A `resolved` token *inside the proposal prose* does NOT qualify — only on the `**Status:**` line itself.
   - **Resolved (tier 3 — applied-with-date)** — the `**Status:**` line's *value* **begins with** `applied` (after stripping leading `**`/whitespace) and carries a `YYYY-MM-DD` date within the next ~40 characters. Regex: `^applied\b.{0,40}?\d{4}-\d{2}-\d{2}` against the stripped value, case-insensitive. Matches the log's now-dominant shape, `- **Status:** **applied 2026-07-17 (S2-21e).** Fixed at the source — …`, which carries no separate `**Verified:**` line.

     **Why the anchor is `^` and not a substring search — this is the whole safety of the tier.** Requiring the value to *start* with `applied` is what excludes the two shapes that must never be archived, without needing a blocklist: `**partially applied 2026-07-14 (S4) — DELIBERATELY NOT …`, which starts with `partially`, and any prose mention of a fix having been applied elsewhere in the entry body (tier 3, like tier 2, reads only the `**Status:**` line). Verified against the live log on 2026-07-18: the rule caught 10 genuinely-finished entries and correctly rejected `partially applied …`, `DECLINED by operator …`, `CLOSED AS VOID …`, `closed — falsified …`, and `OPEN — …`. Do not "simplify" this to a substring match for `applied`.

     **`closed` / `void` are deliberately NOT a resolved tier.** Step 3b's `c` disposition sets `**Status:** closed {TODAY}` and specifies the entry *stays in the active log*. Archiving a `closed` entry would contradict the disposition this command itself writes. Leave them.
   - **Pending** — anything else (missing Status, Status is "logged"/"proposed"/"pending"/"deferred"/"parked"/"closed"/"void"/"declined", or `applied` that is qualified — e.g. `partially applied`).

   All three Resolved tiers are archived identically. In the step-4 presentation, tag each entry `[strict]`, `[convention]`, or `[applied-dated]` so the operator can spot-check the looser classifications cheaply.

   *(Tier 3 added 2026-07-18. Cause: tiers 1+2 saw only **6** of the log's finished entries because the dominant convention — `applied <date>` with no `Verified:` line — satisfied neither. The backlog read that as "29 resolved entries left unarchived" and blamed neglect; the real cause was that the drain could not see them, so the log grew while the tool reported nothing to do. This is why `/prime`'s Step 3 scan re-bloated to 234 lines. Fixing the classifier is the structural fix; hand-archiving would have left the next drain just as blind.)*

   *Schema-sync note (updated 2026-07-18):* the improvement-log.md preamble documents all **three** tiers, and its closing line lists the non-resolved statuses (`partially applied` / `closed` / `void` / `DECLINED`). Both ends were re-converged when tier 3 was added. Keep this command and the preamble in lockstep on any future classification-rule change.

3b. **Two-tier age detection.** ("Two-tier" here means the two *age* bands below — warm and stale. It is unrelated to the three *resolution* tiers in Step 3.) Compute age for each Pending entry: extract the date from its dated heading line, matching level 2 or 3 exactly as the Step 2 boundary rule does (`^#{2,3} \d{4}-\d{2}-\d{2}`) — or use the most recent `**Review-cycle:**` date if present, since deferral resets the clock, then `python3 -c "from datetime import date; print((date.today() - date.fromisoformat('ENTRY_DATE')).days)"`. Skip entries with no parseable date; count them as Pending only.

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
   [If orphaned content: Skipped K orphaned lines (no dated heading) — left in place.]
   [If any entry used a `##` heading: {N} entries use a '##' heading — normalize to '###'.]
   ```

$ARGUMENTS
