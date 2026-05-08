---
model: sonnet
---

# /friday-act — Session 2 of the Friday cadence (operator-driven fixes)

Consume the freshest `/friday-checkup` report and drive structured fixes. Tier-differentiated decision shape: weekly = tactical fixes; monthly = + policy-level review; quarterly = + architectural retrospective. Inline `/risk-check` gate on fixes that fall in any required class. Captures repo-health observations and next-week autonomy-axis posture targets at exit.

This command is Session 2 of the Friday cadence. It does not re-run audits — `/friday-checkup` is Session 1. If audit logic is needed, this command refuses and redirects.

Input: `$ARGUMENTS` (optional) — explicit path to a `friday-checkup-YYYY-MM-DD.md` report. If omitted, locate the freshest report under `ai-resources/audits/`.

---

### Step 1: Locate and Validate Report

1. Set `AI_RESOURCES` = absolute path to the `ai-resources/` directory.
2. Set `TODAY` = today's date in `YYYY-MM-DD`.
3. If `$ARGUMENTS` is non-empty, treat it as `REPORT_PATH` (resolve relative paths against `AI_RESOURCES`). Otherwise locate the freshest report:
   ```bash
   ls -1 "{AI_RESOURCES}/audits/friday-checkup-"*.md 2>/dev/null | sort | tail -1
   ```
4. If no report exists, abort:
   ```
   No /friday-checkup report found under ai-resources/audits/.
   Run /friday-checkup first (Session 1 of the Friday cadence).
   ```
5. Parse `REPORT_DATE` from the filename (the `YYYY-MM-DD` between `friday-checkup-` and `.md`).
6. Compute days elapsed: `DAYS = (TODAY - REPORT_DATE)` in days.
7. If `DAYS > 10`, abort with:
   ```
   Most recent /friday-checkup report is {DAYS} days old (threshold: 10).
   Run /friday-checkup to refresh, then re-invoke /friday-act.
   ```
   (10-day threshold matches the `friday-checkup-reminder.sh` hook and `/friday-checkup` Step 0 recovery rule.)

8. **Audit-rerun guard.** If the operator's `$ARGUMENTS` resembles audit-trigger language (contains `audit`, `re-run`, `rescan`, `sweep`, `checkup`), refuse:
   ```
   /friday-act does not re-run audits. Run /friday-checkup for fresh evidence.
   ```

---

### Step 1.5: Locate System Owner Outputs

Locate the freshest System Owner outputs from this week's cadence. These are supplementary inputs alongside the checkup report. Either or both may be `MISSING`; that is acceptable — Step 3.5 self-skips when neither is present, and Step 2's tier-detection is unaffected.

**Friday Advisory locator** — directory `projects/axcion-ai-system-owner/output/friday-advisories/`:

- Glob `friday-advisory-*.md`.
- For each match, parse `(date, version)` from the filename: `date` = `YYYY-MM-DD` immediately after `friday-advisory-`; `version` = integer N from a `-vN` suffix before `.md` (default `1` when no suffix). Treat the suffix as an integer, not a string — lexical sort would otherwise place `-v10` before `-v2`.
- Sort descending by `(date, version)`. Take the first.
- Apply filters: filename `date >= REPORT_DATE` AND filename `date >= TODAY - 7 days`. If filtered out, treat as `MISSING`.
- Set `SO_ADVISORY_PATH` to the resolved absolute path or the literal string `MISSING`.

**Systems Review locator** — directory `projects/axcion-ai-system-owner/output/systems-reviews/`:

- Glob `systems-review-*.md`.
- Parse `date` from each filename (the `YYYY-MM-DD` immediately after `systems-review-`).
- Sort descending by `date`. When multiple matches share the same date (different scope slugs), fall back to file mtime — slug-alphabetical alone can pick the wrong same-day file.
- Take the first. Apply the same filters as above.
- Set `SO_REVIEW_PATH` to the resolved absolute path or the literal string `MISSING`.

**Journal Report locator** — directory `ai-resources/audits/`:

- Glob `friday-journal-*.md`.
- Parse `date` from each filename (the `YYYY-MM-DD` immediately after `friday-journal-`).
- Sort descending by `date`. Take the first.
- Apply filters: filename `date >= REPORT_DATE` AND filename `date >= TODAY - 7 days`. If filtered out, treat as `MISSING`.
- Set `JOURNAL_PATH` to the resolved absolute path or the literal string `MISSING`.

If `SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, AND `JOURNAL_PATH` are all `MISSING`, continue to Step 2 silently — `/friday-act` does not depend on supplementary inputs to function. Otherwise carry the resolved paths forward to Step 3 (display) and Step 3.5 (disposition prompt).

---

### Step 2: Parse Report and Detect Tier

> **Schema contract:** the section headings parsed below are produced by `/friday-checkup` Step 7's "Section presence by tier" data contract. Do not rename them in either command without updating both ends — see `.claude/commands/friday-checkup.md` Step 7 (data-contract paragraph after the report template).

9. Read `REPORT_PATH` in full.
10. Extract `TIER` from the `## Tier` line (`weekly`, `monthly`, or `quarterly`). If absent or malformed, abort with `Cannot parse tier from {REPORT_PATH}.`
11. Parse three sections by exact heading match:
    - `## Tactical follow-ups` → list of `[ ] {item} — risk: {low | med | high}` bullets. Always present.
    - `## Policy-level observations` → list of bullets. Present iff `TIER ∈ {monthly, quarterly}`. May contain "(none flagged this cycle)".
    - `## Architectural retrospective` → free-form section. Present iff `TIER = quarterly`.
12. If a tier-required section is missing, abort with `{section_name} missing from {REPORT_PATH}; report shape does not match /friday-checkup contract.` (Schema mismatch is a structural error, not an operator-recoverable one.)

---

### Step 3: Tactical Follow-ups Loop

13. Display System Owner inputs (when at least one resolved in Step 1.5), then the tactical list ordered by risk descending (high → med → low):
    ```
    System Owner inputs available (this Friday):
      Friday Advisory: {SO_ADVISORY_PATH | (none within 7 days)}
      Systems Review:  {SO_REVIEW_PATH | (none within 7 days)}
      Journal Report:  {JOURNAL_PATH | (none within 7 days)}
    After dispositioning the checkup items below, you'll be prompted to add any
    System Owner-derived items and journal-derived items for disposition (Step 3.5).

    Tactical follow-ups from {REPORT_DATE} ({TIER} tier):
      1. [high] {item}
      2. [med]  {item}
      3. [low]  {item}
      ...

    Per-item disposition (one letter per item, in order):
      (f)ix-now    — execute this fix in this session
      (d)efer      — log to logs/maintenance-observations.md as deferred
      (s)kip       — drop without logging
    ```
    If `SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, AND `JOURNAL_PATH` are all `MISSING`, omit the "System Owner inputs available" block entirely (do not print a stub).
14. Wait for the operator's per-item disposition string. Validate length matches item count and characters are in `{f,d,s}`. Re-prompt on mismatch.
15. For each item dispositioned `f`:
    a. Determine whether the fix touches a `/risk-check` change class (per `ai-resources/docs/audit-discipline.md` § Risk-check change classes). Trigger the gate if the item description names any of: hook file (`.sh`), `settings.json`, workspace `CLAUDE.md`, project `CLAUDE.md`, a new command/skill path, a new symlink, or auto-write/cross-repo automation.
    b. If gated, prompt the operator inline:
       ```
       Item {N} touches a /risk-check change class ({class}).
       Run /risk-check before executing? (y/n/skip)
         y    — run /risk-check inline (verdict gates execution)
         n    — proceed without /risk-check (operator override; logged in observations)
         skip — skip this item, treat as deferred
       ```
    c. On `y`, invoke `/risk-check` via the Skill tool with `$ARGUMENTS` describing the proposed fix (item text + any file paths inferable from the report). Honor the verdict:
       - `GO` → proceed to execute.
       - `PROCEED-WITH-CAUTION` → proceed only after applying the paired mitigations from the risk-check report; record the applied mitigations in the per-item execution log.
       - `RECONSIDER` → do NOT execute; log as deferred with the recommended-redesign one-liner.
    d. On `n`, append a one-line note to the session block in Step 5: `- Item {N} executed without /risk-check (operator override): {item text}`.
    e. On `skip`, treat as deferred (same as initial `d` disposition).
    f. Execute the approved fix per standard autonomy rules (workspace `CLAUDE.md` Autonomy Rules apply). For multi-step fixes, work them in sequence; do not batch unrelated fixes into one diff.
    g. **W2.4 follow-up dispatch (additional sub-disposition).** After executing or before executing step 15f, if the current tactical follow-up's source label starts with `repo-documentation:w2-4-improvements` and the operator's disposition is `f` (fix), offer one more sub-disposition:
       ```
       This follow-up is from W2.4 (improvement analysis). How should it be implemented?
         (a) auto-draft — spawn system-developer-agent to draft a proposal
         (b) manual    — operator implements without agent assistance
       ```
       - On `auto-draft`:
         1. Read the improvement entry text from `projects/repo-documentation/output/phase-2/w2-4-improvements-{LATEST}.md` (locate by finding the relevant finding section).
         2. Derive a slug: lowercase, kebab-case, ≤8 words from the finding's title.
         3. Spawn `system-developer-agent` via Agent tool with brief: "Improvement entry below. Project CLAUDE.md path: `projects/repo-documentation/CLAUDE.md`. Slug: `{slug}`. Today: `{TODAY}`. Draft a propose-only implementation. Forbidden: deletions of files in ai-resources/skills/, ai-resources/.claude/, any CLAUDE.md, any harness/, any output/phase-1/. Improvement entry: ```{entry text}```"
         4. After completion, locate the produced proposal at `projects/repo-documentation/output/phase-2/w2-4-proposals/{TODAY}-{slug}.md`. Display the proposal path. State: "Operator must review the proposal before applying any diff. /friday-act stops here for this finding; manual diff application is the next step."
         5. Record disposition in `RESULTS` as `auto-drafted: {proposal_path}`.
         6. If the proposal contains `## Proposal Rejected — Forbidden Action`, surface the rejection to the operator and recommend revising the improvement entry. Do not retry.
       - On `manual`: proceed with step 15f normally (operator implements without agent assistance).

16. Items dispositioned `d` are accumulated for Step 5 logging.

▸ After the tactical loop, run `/compact` if context is heavy (many fix-now items executed).

---

### Step 3.5: System Owner-derived and Journal Additions

> **Schema contract.** Sub-step 16f below extracts items from the `## Items` section of the `/friday-journal` report. Each line MUST match the regex `^\[(high|med|low)\] .+$` — the same regex 16c uses for paste-validated SO-derived items. The producer side is `.claude/commands/friday-journal.md` Step 5 (report-shape spec). Do not change the prefix syntax in either command without updating both ends.

Skip this step if `SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, AND `JOURNAL_PATH` are all `MISSING`. Otherwise:

16a. For each available SO file, print the first 30 lines (lightweight peek, no parsing — headers, executive summary, and binding-constraint sections typically fit in this window). Display the source path as a header before each peek.

16b. Prompt the operator:
```
System Owner inputs may suggest items not in the checkup tactical list. Skip
items that duplicate Step 3 checkup items already dispositioned — the SO
advisory often references the same finding the checkup raised; disposition once,
not twice.

Add System Owner-derived items? Paste one per line in shape:
  [risk] {item text}
where risk ∈ {high, med, low}. Empty line to finish, or `(none)` to skip.
```

16c. Validate each pasted line against `^\[(high|med|low)\] .+$`. Re-prompt on malformed input. Capture accepted items as a parallel list to the Step 3 tactical follow-ups (preserve `risk` and `text`).

16d. For each accepted SO-derived item, run the same disposition loop as Step 3 (items 14–15 logic), with two notes:
- The same `/risk-check` change-class gate (item 15a–c) applies — SO-derived items can touch hooks, settings, CLAUDE.md, etc., the same as checkup-derived items.
- The W2.4 sub-disposition (item 15g) does NOT apply — SO-derived items have no `repo-documentation:w2-4-improvements` source label.

16e. Append accepted SO-derived dispositions into the same `RESULTS` structure used by Step 3, tagged with `source: so-derived` so Step 5 can subtotal them and the deferred-items list can label them.

16f. **Journal-derived items.** If `JOURNAL_PATH` is not `MISSING`:

- Read `JOURNAL_PATH`. Locate the `## Items` section header (the section between `## Items` and the next `## ` heading).
- Extract every line in that section matching `^\[(high|med|low)\] .+$`. Discard blank lines and any non-matching content (the report includes operator-readable detail under `## Item context` that the parser ignores by design).
- Treat the extracted lines as a parallel list to the SO-derived items — same shape (`[risk] {text}`), same regex, **no paste-prompt** (they were validated by `/friday-journal` at write time).
- Display the count and the items to the operator before disposition:
  ```
  Journal-derived items (from {JOURNAL_PATH}):
    1. [high] {text}
    2. [med]  {text}
    ...

  Per-item disposition (one letter per item, in order; same f/d/s vocabulary):
  ```
- Feed them into the same disposition loop as items 14–15. The `/risk-check` change-class gate (15a–c) applies. The W2.4 sub-disposition (15g) does NOT apply (journal items have no `repo-documentation:w2-4-improvements` source label).
- Tag accepted dispositions in `RESULTS` with `source: journal-derived` so Step 5 subtotals them separately.

▸ After the SO-derived and journal-derived loops, run `/compact` if context is heavy (compounding cost from Steps 3, 3.5 SO, and 3.5 journal combined).

---

### Step 4: Policy-level Review (monthly + quarterly only)

17. Skip this step if `TIER = weekly`.
18. Display the parsed `## Policy-level observations` list:
    ```
    Policy-level observations ({TIER} tier):
      1. {observation} — {source}
      2. {observation} — {source}
      ...

    For each observation, decide:
      (r)ule-change  — warrants a CLAUDE.md or audit-discipline.md edit; log proposed edit text
      (n)o-change    — observation noted, no rule change this cycle
      (d)efer        — re-evaluate next cycle
    ```
19. Wait for per-observation disposition. For each `r`:
    - Prompt: `Proposed rule edit for "{observation}" (one or two lines):`
    - Capture the operator's text. **Do NOT auto-edit CLAUDE.md or audit-discipline.md.** Rule edits are structural and must go through their own plan + `/risk-check` cycle in a follow-up session. Log the proposal to the session block in Step 5 under a `Policy proposals` subsection.
    - Defer execution. Step 5 closeout reminds the operator to schedule a follow-up session for the rule edits.
20. For `n` and `d` dispositions: log under `Policy review` in the session block, no further action.

---

### Step 5: Maintenance Observations Closeout

21. Open (or create) `{AI_RESOURCES}/logs/maintenance-observations.md`. If creating, seed with the header per the schema in that file's intro block (see file). Append a new session block:
    ```
    ## {TODAY} — Friday Act ({TIER} tier, source: friday-checkup-{REPORT_DATE}.md)

    ### System Owner inputs (this session)
    - Friday Advisory: {SO_ADVISORY_PATH | (none within 7 days)}
    - Systems Review:  {SO_REVIEW_PATH | (none within 7 days)}

    ### Journal Report (this session)
    - Journal Report: {JOURNAL_PATH | (none within 7 days)}

    ### Disposition summary
    - Tactical: {F} fix-now, {D} defer, {S} skip (of {TOTAL} items; of which {SO_COUNT} System Owner-derived, {JOURNAL_COUNT} journal-derived)
    - Policy review: {R} rule-change proposed, {N} no-change, {D} defer (monthly+ only; omit for weekly)
    - Architectural retrospective: {captured | skipped} (quarterly only; omit otherwise)

    ### Deferred items (from this session)
    - {tactical or policy item text} — {risk if tactical}, {source: checkup | so-derived | policy}

    ### Policy proposals (monthly+; omit if none)
    - For "{observation}": {operator's proposed rule edit}

    ### Architectural retrospective notes (quarterly only; omit otherwise)
    {operator's free-form response to substrate questions}

    ### Operator observations
    {free-form text — see prompt below}
    ```

22. Prompt the operator for free-form observations:
    ```
    Maintenance observations — what did you notice about repo health, friction, or coupling
    that the findings didn't surface? (free text; "(none)" to skip):
    ```
    Capture verbatim. If the response is `(none)` or empty, write `(none)` in the `Operator observations` section.

23. If `TIER = quarterly`, also prompt for the substrate-question response:
    ```
    Architectural retrospective — respond to the substrate questions in the report:
      - What's the repo drifting toward?
      - What's accumulating without a forcing function to remove it?
      - Which boundary felt fuzziest this quarter?

    (free text; one paragraph or one bullet per question is fine):
    ```
    Capture verbatim into the `Architectural retrospective notes` subsection.

---

### Step 6: Autonomy-axis Target-setting

24. Display the seven axes with default `hold` and a single combined prompt:
    ```
    Autonomy-axis posture targets for the week ahead (default: hold).
    Reply with seven characters in axis order (h=hold, t=tighten, l=loosen),
    or `hhhhhhh` to accept all defaults:

      Axis 1: Guardrails
      Axis 2: Optimization
      Axis 3: Autonomy
      Axis 4: Capability
      Axis 5: Reliability
      Axis 6: Observability
      Axis 7: Operator load

    Posture string (7 chars, e.g., `hhthhhh`):
    ```
25. Validate the response: exactly seven characters, each in `{h,t,l}`. Re-prompt on mismatch.
26. For each axis whose posture ≠ `h`, prompt for a one-line rationale:
    ```
    Rationale for {axis_name} → {tighten|loosen} (one line):
    ```
27. Append the axis block to the same session block in `maintenance-observations.md`:
    ```
    ### Autonomy-axis posture targets (week ahead)
    - Guardrails: {hold | tighten | loosen}{ — rationale if not hold}
    - Optimization: {hold | tighten | loosen}{ — rationale if not hold}
    - Autonomy: {hold | tighten | loosen}{ — rationale if not hold}
    - Capability: {hold | tighten | loosen}{ — rationale if not hold}
    - Reliability: {hold | tighten | loosen}{ — rationale if not hold}
    - Observability: {hold | tighten | loosen}{ — rationale if not hold}
    - Operator load: {hold | tighten | loosen}{ — rationale if not hold}
    ```

---

### Step 7: Summary and Exit

28. Print to operator:
    ```
    /friday-act complete.

    Source report: {REPORT_PATH}
    Tier: {TIER}
    Tactical: {F} fix-now executed, {D} defer, {S} skip (of {TOTAL})
    {Policy review summary if monthly+}
    {Architectural retrospective summary if quarterly}
    Axis targets: {count of non-hold axes}/7 changed

    Session block appended to: ai-resources/logs/maintenance-observations.md

    {If any policy proposals were captured:}
    Policy proposals captured — schedule a follow-up session to draft + /risk-check the rule edits.

    Suggested next: /wrap-session
    ```

29. **Do NOT commit.** Fixes executed in Step 3 follow standard commit-directly rules (each fix's commit happens at execution time per workspace `Commit behavior`). The `maintenance-observations.md` append lands unstaged; the operator stages and commits it manually at session wrap (or invokes `/cleanup-worktree` if it accumulates).

---

### Notes

- **Session 1/2 boundary.** This command refuses audit-rerun language (Step 1.8). Use `/friday-checkup` for evidence, `/friday-act` for action.
- **System Owner inputs (Steps 1.5 + 3.5).** `/friday-act` reads the freshest `/friday-so` advisory and `/systems-review` report (filtered to ≥ checkup date and ≤ 7 days old) as supplementary inputs. The SO outputs are prose; `/friday-act` does not parse their content — it displays the first 30 lines and lets the operator paste any actionable items as `[risk] {text}` for the same disposition loop as checkup items. If both SO files are missing, Step 3.5 self-skips. Producer-side commands (`/friday-so`, `/systems-review`) are not modified — coupling is one-way (consumer reads producer outputs).
- **Journal Report (Steps 1.5 + 3 + 3.5 + 5).** `/friday-act` reads the freshest `/friday-journal` report (filtered to ≥ checkup date and ≤ 7 days old) as a third supplementary input. Unlike the SO outputs (prose), the journal report's `## Items` section is pre-structured to the same `[risk] {text}` shape as Step 3.5's regex — sub-step 16f extracts those lines directly and feeds them into the disposition loop with no paste-prompt. The producer-side schema-contract callout lives in `.claude/commands/friday-journal.md` Step 5; do not change the prefix syntax in either command without updating both ends. Coupling is one-way (consumer reads producer).
- **7-day vs. 10-day filter rationale.** Supplementary inputs (Friday Advisory, Systems Review, Journal Report) all use a **7-day** filename-date filter — these are session-window-scoped artifacts produced for a specific Friday and stale beyond that week. The checkup report itself uses a **10-day** abort threshold (Step 1.7) because it pairs with the `friday-checkup-reminder.sh` hook's recovery-Friday window; a 10-day grace allows skipped-Friday recovery without re-running the audit. The two thresholds are intentionally distinct: 7-day = "fresh for this Friday's session"; 10-day = "fresh enough to still be the basis for action."
- **Inline `/risk-check`.** Operator-confirmed (Step 3.b prompt), then dispatched via the Skill tool. This matches `risk-check.md`'s "operator-typed, or inline-prompted by other commands (e.g., `/friday-act`)." Auto-firing without consent is not permitted.
- **No auto-edit of CLAUDE.md or audit-discipline.md.** Policy proposals (Step 4) capture intent; the rule edits themselves go through their own plan + `/risk-check` cycle.
- **Coaching-log untouched.** The seven autonomy axes are forward-looking weekly posture targets; coaching-log's five session-pattern dimensions are backward-looking session ratings. Different orientation, kept separate (per workspace decision 2026-04-24).
- **Failure handling.** If a sub-fix in Step 3 errors mid-execution, surface the error, log the item as `failed (error: {summary})` in the deferred-items section, and continue with the next item. Do not abort the whole run.
- **Skipped-Friday recovery.** If `DAYS > 10` (Step 1.7), the command refuses. Recovery flow: run `/friday-checkup` first; that command's Step 0 will offer recovery-Friday vs. fold-into-next-Friday options; then re-invoke `/friday-act` against the fresh report.
