---
model: opus
---

# /friday-journal — Process the AI journal into an implementation report

Read the operator's freeform AI journal, run a clarification pass on messy entries, and produce a structured implementation report that `/friday-act` auto-loads alongside Friday Advisory and Systems Review. Closes the gap between informal weekly note-taking and structured Friday execution.

Run between `/friday-so` and `/friday-act` on the Friday cadence (slot F3.5; see `ai-resources/docs/weekly-cadence.md`). Not for: ad-hoc note-taking (`/note`), Friday audit (`/friday-checkup`), strategic advisory (`/friday-so`), execution (`/friday-act`).

**Model-tier rationale.** Every step is judgment work — interpreting messy free-text entries, deciding which need clarification vs. are already clear, weighing repo context to assign priority and recommend an approach, and producing the per-item directive that `/friday-act` will execute. Opts in to Opus per the project's per-project tier rule (default Sonnet, Opus for "deciding" work).

Input: `$ARGUMENTS` (optional) — explicit path to a journal file. If omitted, defaults to `ai-resources/logs/ai-journal.md`.

---

### Step 1: Load Journal

1. Set `AI_RESOURCES` = absolute path to the `ai-resources/` directory.
2. Set `TODAY` = today's date in `YYYY-MM-DD`.
3. Set `JOURNAL_SOURCE` = `$ARGUMENTS` if non-empty, else `{AI_RESOURCES}/logs/ai-journal.md`.
4. Read `JOURNAL_SOURCE`. If the file does not exist, abort with:
   ```
   Journal file not found: {JOURNAL_SOURCE}
   Create it (empty template available in /friday-journal docs) and re-run.
   ```
5. Parse the active section: everything between the line `<!-- Active entries below this line. Add one per line or short paragraph. -->` and the `## Archive` header. If the active section contains only whitespace and comments, abort gracefully:
   ```
   No active journal entries. Add notes to {JOURNAL_SOURCE} and re-run.
   ```
6. Capture the active entries verbatim (preserving the operator's exact text — needed for Step 6 archive and the report's Source-entry field). **Splitting rule:** treat blank-line-separated blocks as entry boundaries. A contiguous run of non-blank lines (one line or many) is exactly **one entry**, regardless of internal newlines. Markdown bullets (`- `, `* `, `1. `) within a block belong to the same entry. A blank line ends an entry; the next non-blank line starts the next entry. This makes the parse deterministic.

---

### Step 2: Ambiguity Analysis

7. For each active entry, identify what is unclear:
   - **Target.** Which file, component, or area of the repo it refers to. If the entry says "fix the audit thing," ask which audit.
   - **Outcome.** What the desired end state is — bug fix, new feature, policy change, cleanup, refactor, doc update.
   - **Priority signal.** Whether this is urgent, nice-to-have, or somewhere in between. The operator may have written `URGENT` or `nice-to-have` inline; if not, infer cautiously and flag if uncertain.
   - **Constraints / context.** Anything implied but not stated — a deadline, a related project, a dependency on a pending decision.

8. Skip entries that are already fully clear. Do not ask for the sake of asking — terse but unambiguous entries (e.g., "rename `foo` → `bar` in `commands/baz.md`") need no clarification.

---

### Step 3: Batch Clarification

9. Present all questions in a single numbered list, grouped by entry. Use this shape:
   ```
   The following entries need clarification before I can structure them.

   Entry 1: "{verbatim entry text}"
     Q1.1: {clarifying question}
     Q1.2: {clarifying question}

   Entry 2: "{verbatim entry text}"
     Q2.1: {clarifying question}

   ...

   (Entries N, N+1, ... were already clear — no questions.)

   Reply with answers in the same numbering. You can mark any question
   "skip" to keep the entry but proceed without that detail.
   ```
10. Wait for the operator's reply. Do not proceed until answered. If the operator's reply is incomplete, prompt for the missing items by number — do not re-ask everything.

---

### Step 4: Grounding Pass

11. Read the following for context (used to assign realistic priority, file paths, and effort):
    - `ai-resources/CLAUDE.md`
    - Workspace `CLAUDE.md` (the parent repo's root CLAUDE.md)
    - Freshest `{AI_RESOURCES}/audits/friday-checkup-*.md` — full read (matches `/friday-so` depth; not header-only).
    - For any project explicitly named in the active entries: that project's `CLAUDE.md`.

12. The grounding pass is read-only. Do not re-run audits. If the most recent checkup report is missing or older than 10 days, note this in the Step 5 Summary but do not abort — the report is still useful, just less calibrated.

---

### Step 5: Generate Implementation Report

13. Write the report to `{AI_RESOURCES}/audits/friday-journal-{TODAY}.md`. **Same-day collision handling:** if a file at that path already exists from an earlier run today, prompt the operator:
    ```
    A friday-journal report for {TODAY} already exists at:
      {existing path}

    Overwrite it (the new report supersedes the previous one), or abort? (o/a)
    ```
    On `o`: overwrite the existing file. On `a`: abort without writing — the previous report stands. (No `-v2` suffix scheme: `/friday-act` Step 1.5's lex-sort tiebreaker would pick the wrong file because `-` sorts before `.` in `-v2.md` vs `.md`. Single canonical file per day avoids the ambiguity.)

14. Report shape — exact structure (the `## Items` block is the data contract with `/friday-act`):

    ```markdown
    ---
    report_date: {TODAY}
    type: friday-journal
    source: ai-resources/logs/ai-journal.md
    entry_count: N
    items_generated: N
    ---

    # /friday-journal report — {TODAY}

    ## Summary

    [2–3 sentences: this week's themes, any blocking items, calibration notes
    if the checkup report was stale or missing.]

    ## Items

    [high] {one-sentence directive — what /friday-act should execute}
    [high] {one-sentence directive}
    [med]  {one-sentence directive}
    [low]  {one-sentence directive}

    ## Item context

    ### {first directive, repeated as heading}
    - **Files:** {paths if known, or "TBD"}
    - **Effort:** low | medium | high
    - **Recommended approach:** {longer concrete next step}
    - **Source entry:** {original journal text, verbatim}

    ### {second directive, repeated as heading}
    ...
    ```

    > **Schema contract.** The lines under `## Items` are produced by this command for `/friday-act` Step 3.5 to consume directly. Each line MUST match the regex `^\[(high|med|low)\] .+$` — same regex `/friday-act` 16c uses for paste-validated SO-derived items. Do not change the prefix syntax in either command without updating both ends — see `.claude/commands/friday-act.md` Step 3.5 (sub-step 16f, journal-extraction logic).

15. Item rules:
    - One item per resolved entry. If clarification revealed two distinct fixes in one entry, split into two items.
    - Each `## Items` line ends with a single sentence (one verb, concrete object). Long context goes in `## Item context` only.
    - Sort high → med → low. Within a tier, preserve operator's original entry order.
    - The directive text in `## Items` and the heading in `## Item context` MUST be identical (the regex match is what couples the two halves of the report).

---

### Step 5.4: Mechanical Pre-Check (deterministic)

15a. Run three deterministic checks on the freshly-written report. On any failure, print the failure with line number + specific mismatch and abort. Operator fixes the producer logic and re-runs.

  - **Schema regex.** Every line in the `## Items` section must match `^\[(high|med|low)\] .+$`. Use `awk '/^## Items$/,/^## Item context$/' {REPORT_PATH} | grep -nvE '^(## |$|\[(high|med|low)\] )'` — empty result = pass.

  - **Heading match (set-equality, both directions).** Every `## Items` line's text (after the `[tier] ` prefix) must appear verbatim as a `### ` heading under `## Item context`, AND every `### ` heading under `## Item context` must appear as an Items line. Both directions must hold — a lone heading without an Items entry is also a bug. Mismatch = bug in Step 5 Items↔Item-context coupling.

  - **Frontmatter consistency.** `items_generated` equals the count of `## Items` lines. (Both `entry_count` and `items_generated` are present in frontmatter for traceability, but no inequality is enforced — drops + merges can make either side larger than the other depending on the run.)

  Aborts here are bugs in /friday-journal Step 5, not operator concerns. Surface them clearly so the producer logic gets fixed.

---

### Step 5.5: Output Validation Gate (auto-/qc-pass with journal-scoped inputs)

15b. Spawn the `qc-reviewer` subagent with the following handoff. The agent runs its standard 6-dimension rubric (Request Match, Scope Creep, Risky Assumptions, Things That Could Break, Simpler Alternative, Sibling Redundancy) — the focus areas below are scope/context input that steers what the agent looks for within those dimensions, not a replacement rubric.

  - **Artifact:** `{REPORT_PATH}` — /friday-journal report for {TODAY}.
  - **Original operator request:** "Run /friday-journal on the AI journal."
  - **Scope / artifact purpose:** "Provide /friday-act with a structured, regex-parseable list of implementation directives derived from the operator's AI journal entries. Each directive must be concrete enough for /friday-act to disposition (act / defer / drop) and execute, with priority-tiered ordering (high → med → low)."
  - **Focus areas (journal-specific — steers evaluation within the standard 6 dimensions):**
    1. **Internal contradictions** — items that conflict with each other, or Summary claims that don't match the Items list (e.g., "X dropped" in Summary while X still appears as an item).
    2. **Currency drift** — items that conflict with current canonical state. Required reference reads: workspace `CLAUDE.md`, `ai-resources/CLAUDE.md`, latest `audits/friday-checkup-*.md`, recent entries in `logs/decisions.md`. Flag items proposing changes that are already in place.
    3. **Already-done check** — items proposing to build commands or fix issues that already exist. Use Glob (`ai-resources/.claude/commands/{NAME}.md`) and Grep to verify existence before flagging. No Bash available — do not use `ls`.
    4. **Vagueness** — items with `Files: TBD`, "where applicable" hedges, or investigate-only directives at [high] tier.
    5. **Risk-class flagging** — items that match `audit-discipline.md` "Risk-check change classes" (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands, new symlinks, shared-state automation). Flag these for /risk-check in /friday-act.
  - **Output contract:** Full findings to `{AI_RESOURCES}/audits/working/journal-qc-{TODAY}.md`. Return ≤30-line summary to main session, including the working-notes path on the last line.
  - **Verdict shape:** `GO | REVISE | FLAG FOR EXTERNAL QC` (qc-reviewer's standard verdict schema).

15c. **Present the summary to the operator verbatim.** Do not filter or paraphrase. The verdict line drives the next step.

15d. **On GO:** print `Validation passed — proceeding to archive.` and continue to Step 6.

15e. **On REVISE or FLAG FOR EXTERNAL QC:** run a per-finding disposition loop. For each finding in the summary, prompt:
  ```
  Finding {N}: {finding text}
  Disposition: (k)eep / (d)rop / (r)evise / (f)lag-for-risk-check?
  ```
  - `k` (keep) — operator overrides the finding. No change to report. Log the override in the working-notes file (append "Operator override: {reason if given}").
  - `d` (drop) — remove the corresponding item from `## Items` AND its block from `## Item context`. Decrement `items_generated` in frontmatter.
  - `r` (revise) — prompt: "Enter replacement directive (must satisfy `^\[(high|med|low)\] .+$`, e.g. `[med] Wire auto-/triage as default after /qc-pass results`)." Update both the `## Items` line and the matching `### ` heading in `## Item context` to keep the schema contract intact.
  - `f` (flag-for-risk-check) — item stays, but its `## Item context` block gains a final bullet: `- **Risk-check required:** Yes (matches {class} per audit-discipline.md). /friday-act must run /risk-check before landing this fix.`

15f. After all findings dispositioned, re-run Step 5.4 (mechanical check) on the modified report to verify no schema breakage from the dispositions. On failure, abort and surface the mismatch — operator needs to manually correct.

15g. Print: `Validation complete. {N} findings dispositioned ({K} kept, {D} dropped, {R} revised, {F} flagged for /risk-check). Final item count: {items_generated}.`

---

### Step 6: Confirm-then-archive

16. Show the operator a diff preview of what will move:
    ```
    About to archive these entries to `## Archive — {TODAY}`:

      [original entry text 1]
      [original entry text 2]
      ...

    Active section will be cleared. Proceed? (y/n)
    ```

17. On `y`:
    - Locate the umbrella `## Archive` header in `JOURNAL_SOURCE` (the fixed header from the journal template). Append the new block **under** that umbrella header, structured as a nested sub-section:
      ```
      ## Archive

      <!-- existing comment if present -->

      ## Archive — {TODAY}

      [original entry text 1]

      [original entry text 2]

      ...
      ```
      Concretely: write the `## Archive — {TODAY}` block at the end of the file, after any existing `## Archive — *` sub-sections. (If a `## Archive — {TODAY}` block already exists from a prior same-day run, append entries to it rather than creating a duplicate dated header.)
    - Clear the active section: replace everything between the marker comment and the umbrella `## Archive` header with a single blank line under the marker. Leave the marker line itself in place.
    - Confirm to operator: `Archived {N} entries; active section cleared.`

18. On `n`:
    - Skip archive. Leave `JOURNAL_SOURCE` untouched.
    - Confirm: `Journal not modified. Active entries remain for next run.`

---

### Step 7: Exit Summary

19. Print to operator:
    ```
    /friday-journal complete.

    Report:          {AI_RESOURCES}/audits/friday-journal-{TODAY}.md
    Items generated: {N} (high: {H}, med: {M}, low: {L})
    Validation:      {GO | REVISE | FLAG FOR EXTERNAL QC} — {findings count} findings ({K} kept, {D} dropped, {R} revised, {F} flagged for /risk-check)
    Working notes:   {AI_RESOURCES}/audits/working/journal-qc-{TODAY}.md
    Journal:         {archived | unchanged}

    Next: /friday-act will auto-load this report alongside the checkup.
    ```

20. **Do NOT commit.** The operator stages and commits manually (or it folds into the `/friday-act` session's natural commit boundary). Both the journal mutation (if archived) and the new report file are session-output worth preserving in git.

---

### Notes

- **One-way archive.** Step 6 is destructive on the active section of `JOURNAL_SOURCE`. The git working tree is the recovery path: if the operator regrets archiving, `git diff {JOURNAL_SOURCE}` shows the change and `git checkout {JOURNAL_SOURCE}` restores. The confirm-then-clear gate (Step 6) exists to make the destructive step explicit; do not auto-archive without operator `y`.
- **Schema contract with `/friday-act`.** The `## Items` block is the integration seam. Lines must satisfy `^\[(high|med|low)\] .+$`. `/friday-act` Step 3.5 reads this section directly — no paste-prompt for journal-derived items. If you change the producer-side line shape, update `/friday-act` Step 3.5 (sub-step 16f) in the same change set. Schema-contract callout is mirrored there.
- **Skipped-Friday handling.** This command does not enforce a staleness threshold on the journal itself — entries can be days or weeks old. The 7-day filter applies at the consumer side (`/friday-act` Step 1.5 only loads journal reports ≤ 7 days old) so that a report generated this Friday is what gets executed this Friday.
- **No audit re-run.** Step 4 is read-only grounding. If the checkup report is missing or stale, surface it in the Summary; do not invoke `/friday-checkup` from inside this command.
- **No SO-derived overlap.** Items in this report are journal-derived only. SO-derived items (advisory, systems-review) flow through `/friday-act` Step 3.5's existing paste-prompt path. The two sources are kept independent so subtotals (`SO_COUNT`, `JOURNAL_COUNT`) are accurate.
- **Output validation gate (Step 5.5).** Auto-runs after Step 5 writes the report. Reuses `qc-reviewer` (no new agent) — agent runs its standard 6-dimension rubric; journal-specific focus areas (contradictions, currency drift, already-done, vagueness, risk-class) are passed as scope context that steers *what* the agent looks for within those dimensions. Per-finding disposition (k/d/r/f) preserves schema integrity: drop = remove both Items line + Item context block; revise = update both halves in lockstep, regex constraint surfaced to operator. Mechanical pre-check (Step 5.4) catches schema breakage before paying for the subagent. The gate cannot be skipped from inside the command — operator can disposition all findings as `k` (keep) to override, but the loop runs.
- **Risk-class flag downstream contract.** Items dispositioned `f` (flag-for-/risk-check) get a `**Risk-check required:**` bullet in their Item context block. /friday-act must read this bullet during disposition and run /risk-check before landing the fix. /friday-act change required separately (out of scope for this implementation; tracked as a follow-up).
