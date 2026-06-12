---
model: sonnet
---

# /friday-act — Session 2 of the Friday cadence (operator-driven fixes)

Consume the freshest `/friday-checkup` report, disposition items, and produce plan files for follow-up implementation sessions. Tier-differentiated decision shape: weekly = tactical fixes; monthly = + policy-level review; quarterly = + architectural retrospective. `/risk-check` annotations are written into plan files; the gate runs at execution time. Captures repo-health observations and next-week autonomy-axis posture targets at exit.

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

**Project-internal logs locator** — depends on the `## Scopes audited` block in `REPORT_PATH`:

- Lightweight extract of `## Scopes audited` from `REPORT_PATH` (the full report is read in Step 2; this locator only needs the scope-list block). Each bullet starting with `- project ` names a scoped project (e.g., `- project nordic-pe-macro-landscape-H1-2026`). Strip the `- project ` prefix to get the project directory name.
- Set `WORKSPACE` = parent directory of `AI_RESOURCES`.
- For each scoped project name, resolve three optional paths under `{WORKSPACE}/projects/{name}/logs/`:
  - `improvement-log.md`
  - `session-notes.md`
  - `friction-log.md`
- Set `PROJECT_LOG_BUNDLES` to a list of `{project, improvement_path, session_notes_path, friction_log_path}` records. Include only paths that exist on disk; if a project has none of the three files, omit that project from the list entirely.
- If `## Scopes audited` is absent from `REPORT_PATH` or contains no `- project ` rows, set `PROJECT_LOG_BUNDLES` to the empty list.
- Project-internal logs for `ai-resources` are already covered by Step 1.7 (improvement-log health check) — do not duplicate that read here.

If `SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, and `JOURNAL_PATH` are all `MISSING` AND `PROJECT_LOG_BUNDLES` is empty, continue to Step 2 silently — `/friday-act` does not depend on supplementary inputs to function. Otherwise carry the resolved paths forward to Step 3 (display) and Step 3.5 (disposition prompt).

---

### Step 1.7: Improvement-log health check

Read `{AI_RESOURCES}/logs/improvement-log.md`. Count entries whose `**Status:**` line contains `logged` or `pending` (the active set). If the file does not exist, skip silently.

Soft cap — if active count > 7:
```
Improvement-log has {N} active entries (soft cap: 7).
Consider running /resolve-improvement-log before this session.
Continue? (y/n)
```
Wait for response. On `n`, stop and tell the operator to run `/resolve-improvement-log` first, then re-invoke `/friday-act`.

If active count ≤ 7, proceed silently.

---

### Step 2: Parse Report and Detect Tier

> **Schema contract:** the section headings parsed below are produced by `/friday-checkup` Step 7's "Section presence by tier" data contract. Do not rename them in either command without updating both ends — see `.claude/commands/friday-checkup.md` Step 7 (data-contract paragraph after the report template).

9. Read `REPORT_PATH` in full.
10. Extract `TIER` from the `## Tier` line (`weekly`, `monthly`, or `quarterly`). If absent or malformed, abort with `Cannot parse tier from {REPORT_PATH}.`
11. Parse three sections by exact heading match:
    - `## Tactical follow-ups` → list of `[ ] {item} — risk: {low | med | high}` bullets. Always present.
    - `## Policy-level observations` → list of bullets. Present iff `TIER ∈ {monthly, quarterly}`. May contain "(none flagged this cycle)".
    - `## Architectural retrospective` → free-form section. Present iff `TIER = quarterly`.

    Additionally parse one optional advisory section (absent in pre-2026-06-12 reports — skip silently if missing):
    - `## Weekly Session Value Review` → present on all tiers; consumed by Step 4.2. May contain the placeholder "(no session value audits this week)".
12. If a tier-required section is missing, abort with `{section_name} missing from {REPORT_PATH}; report shape does not match /friday-checkup contract.` (Schema mismatch is a structural error, not an operator-recoverable one.)

---

### Step 3: Tactical Follow-ups Loop

13. Display System Owner inputs (when at least one resolved in Step 1.5), then the tactical list ordered by risk descending (high → med → low):
    ```
    System Owner inputs available (this Friday):
      Friday Advisory: {SO_ADVISORY_PATH | (none within 7 days)}
      Systems Review:  {SO_REVIEW_PATH | (none within 7 days)}
      Journal Report:  {JOURNAL_PATH | (none within 7 days)}
      Project logs:    {len(PROJECT_LOG_BUNDLES)} scoped project(s){ — names list, or (none)}
    After dispositioning the checkup items below, you'll be prompted to add any
    System Owner-derived items, journal-derived items, and project-derived items for disposition (Step 3.5).

    Tactical follow-ups from {REPORT_DATE} ({TIER} tier):
      1. [high] {item}
      2. [med]  {item}
      3. [low]  {item}
      ...

    Per-item disposition (one letter per item, in order):
      (f)ix-now    — queue into a plan file (executed in a follow-up session)
      (d)efer      — log to logs/maintenance-observations.md as deferred
      (s)kip       — drop without logging
    ```
    If `SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, AND `JOURNAL_PATH` are all `MISSING`, omit the "System Owner inputs available" block entirely (do not print a stub).
13a. **Auto-triage default.** If the item count is 0, skip to sub-step 14 with no display and no prompt (do not print an empty `Auto-triage default:` block). Otherwise, compute the default disposition string by mapping each item's risk label in display order:

    - HIGH → `f` (fix-now)
    - MED  → `f` (fix-now)
    - LOW  → `d` (defer)

    **Named-consequence overlay (apply BEFORE the risk-label mapping above).** This is a mechanical check, not an ROI judgment: for each item, ask whether you can state a concrete consequence of leaving it unfixed — to the system's function, a downstream consumer, the operator's request, or a convention with real teeth (the `docs/materiality-bar.md` test). If the answer is **no** — the only thing you can say is "slightly cleaner / nicer / more consistent" with no named harm — the item defaults to `d` (defer/park) regardless of its risk label, routing it to the park rather than the fix queue. If the answer is **yes**, fall through to the HIGH/MED/LOW mapping above. The check is a boolean ("can you name a consequence?" yes/no), deliberately NOT a three-way WORTH-DOING/MARGINAL/NOT-WORTH-DOING verdict — a true ROI judgment is an `/implementation-triage` agent call, never an inline label here. The operator override still governs every item.

    These defaults reflect the operator's typical disposition pattern (`logs/decisions.md` Item 10 — Friday-act #10 default sketch). MED defaults to `f` because most MED items are actionable — override to `d`/`s` if duplicate or low-value. LOW defaults to `d` because most LOW items are tracked-but-not-blocking — override to `f` if decision-blocking or chain-blocking. The override path is what handles those "unless" cases; the auto-default is intentionally a base-rate guess.

    Display before waiting:
    ```
    Auto-triage default (HIGH→f, MED→f, LOW→d; no-named-consequence→d):
      {default_string}

    Per-item review:
      1. [high] {item}  →  f
      2. [med]  {item}  →  f
      3. [low]  {item}  →  d
      ...

    Press Enter to accept the default, or paste a corrected `{f,d,s}+` string
    matching the item count to override.
    ```
14. Wait for the operator's response. If sub-step 13a skipped (item count 0), this sub-step is a no-op — there is no prompt waiting and no default string to accept; continue to the next step.
    - **Empty response (Enter):** accept the default disposition string from 13a. Set `triage_source = auto-default` for every item in the batch.
    - **Non-empty response:** validate against `^[fds]+$` and that length matches item count. Re-prompt on mismatch. On valid override, set `triage_source = operator-override` for every item in the batch.
15. For each item dispositioned `f`:
    a. Check whether the fix touches a `/risk-check` change class (per `ai-resources/docs/audit-discipline.md` § Risk-check change classes — hook file (`.sh`), `settings.json`, workspace `CLAUDE.md`, project `CLAUDE.md`, a new command/skill path, a new symlink, or auto-write/cross-repo automation). If yes, record `risk_check_required: true`; otherwise `false`. Do not prompt the operator — the gate runs at execution time in the follow-up session.
    b. If the item's source label starts with `repo-documentation:w2-4-improvements`, record `w2_4_source: true`; otherwise `false`. No agent is spawned here — the auto-draft sub-disposition runs in the follow-up session when the operator executes the plan.
    c. Append the item to `FIX_NOW_ITEMS` with fields: `{source: checkup, risk, text, risk_check_required, w2_4_source, triage_source}`.

16. Items dispositioned `d` are accumulated for Step 5 logging.

---

### Step 3.5: System Owner-derived and Journal Additions

> **Schema contract.** Sub-step 16f below extracts items from the `## Items` section of the `/friday-journal` report. Each line MUST match the regex `^\[(high|med|low)\] .+$` — the same regex 16c uses for paste-validated SO-derived items. The producer side is `.claude/commands/friday-journal.md` Step 5 (report-shape spec). Do not change the prefix syntax in either command without updating both ends.

Skip this step if `SO_ADVISORY_PATH`, `SO_REVIEW_PATH`, AND `JOURNAL_PATH` are all `MISSING` AND `PROJECT_LOG_BUNDLES` is empty. Otherwise:

16a. Delegate supplementary-input reads to the `friday-act-16a-summarizer` subagent (Step 16a now delegates to friday-act-16a-summarizer). The subagent reads SO Advisory, Systems Review, and per-project logs per the section-target spec; writes full extraction to `audits/working/friday-act-step16a-{TODAY}.md`; returns a ≤30-line paste-ready summary.

Invoke the `friday-act-16a-summarizer` agent with:
- `TODAY` = today's date in `YYYY-MM-DD`
- `SO_ADVISORY_PATH` = `SO_ADVISORY_PATH` (path or `MISSING`)
- `SO_REVIEW_PATH` = `SO_REVIEW_PATH` (path or `MISSING`)
- `PROJECT_LOG_BUNDLES` = `PROJECT_LOG_BUNDLES`
- `WORKING_DIR` = absolute path to `ai-resources/audits/working/`

Display the returned summary to the operator. The full extraction is at the NOTES path in the last line of the summary.

The operator uses this summary to identify items not in the checkup tactical list (e.g., an SO recommendation that didn't surface as a finding, a recurring friction entry that suggests a new tactical item) and pastes them via the 16b prompt below.

16b. Prompt the operator:
```
System Owner inputs and project-internal logs may suggest items not in the
checkup tactical list. Skip items that duplicate Step 3 checkup items already
dispositioned — the SO advisory often references the same finding the checkup
raised; disposition once, not twice.

Add System Owner-derived and project-derived items? Paste one per line in shape:
  [risk] {item text}
where risk ∈ {high, med, low}. Empty line to finish, or `(none)` to skip.
```

16c. Validate each pasted line against `^\[(high|med|low)\] .+$`. Re-prompt on malformed input. Capture accepted items as a parallel list to the Step 3 tactical follow-ups (preserve `risk` and `text`).

16d. For each batch of accepted SO-derived items, run the same disposition loop as Step 3 (items 13a–15c logic — auto-triage default with operator override). For each `f` item: apply the risk-check-class check (15a) and W2.4 check (15b); append to `FIX_NOW_ITEMS` with `source: so-derived` and the resolved `triage_source` per 14.

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
- Feed them into the same disposition loop as items 13a–15c (auto-triage default with operator override). For each `f` item: apply the risk-check-class check (15a) and W2.4 check (15b); append to `FIX_NOW_ITEMS` with `source: journal-derived` and the resolved `triage_source` per 14.
- Tag accepted dispositions in `RESULTS` with `source: journal-derived` so Step 5 subtotals them separately.

---

### Step 3.6: Plan Generation

> Runs after all disposition loops (Steps 3, 3.5) are complete. Produces one or more plan files in `{AI_RESOURCES}/audits/friday-plans/`.

16g. If `FIX_NOW_ITEMS` is empty, print `No fix-now items — no plan files generated.` and skip to Step 4.

16h. Count `TOTAL_FIX = |FIX_NOW_ITEMS|`. Sort `FIX_NOW_ITEMS` by risk descending (high → med → low); within each risk tier, preserve source-stable order (checkup items first, then so-derived, then journal-derived, in the order they were accumulated).

16i. **Determine plan shape:**
- If `TOTAL_FIX ≤ 4`: one consolidated plan. Set `PLANS = [{slug: "consolidated", items: FIX_NOW_ITEMS}]`.
- If `TOTAL_FIX > 4`: group by area. For each item, derive an area slug using this precedence:
  1. Scan for the first explicit file path (absolute or relative; e.g., `ai-resources/.claude/commands/friday-act.md` → slug `friday-act`).
  2. If no file path, scan for the first slash-prefixed command name (e.g., `/friday-act` → slug `friday-act`, stripping the leading `/`).
  3. If neither, scan for the first directory name mentioned (e.g., `audits/` → slug `audits`).
  4. If none of the above, slug = `general`.
  - Take the last path component of whatever was matched, strip the extension if any, and kebab-case it.
  - Group items by slug. Items with slug `general` form a single group.
  - Set `PLANS = [{slug, items}, ...]`.

16j. Ensure `{AI_RESOURCES}/audits/friday-plans/` exists (`mkdir -p`). For each entry in `PLANS`, write a plan file to `{AI_RESOURCES}/audits/friday-plans/{TODAY}-{slug}.md` using this schema (ordinals reset to 1 per plan file):

```markdown
# Friday Act Plan — {TODAY} — {slug}

**Source report:** friday-checkup-{REPORT_DATE}.md ({TIER} tier)
**Journal report:** {JOURNAL_PATH | (none)}
**Generated:** {TODAY}
**Items:** {N}

## Items

### {ordinal}. [{risk}] {item text}
- **Source:** {checkup | so-derived | journal-derived}
- **Risk-check required:** {yes — change class: {class} | no}
- **W2.4 auto-draft:** {yes — decide (a) auto-draft or (b) manual at execution time | no}

(repeat for each item, ordered high → med → low within this plan)

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
```

16k. **Plan-file QC (automatic).** Before announcing the plans, QC the files written in 16j — plan files are substantive artifacts and fall under the workspace QC rule ("run `/qc-pass` after producing any substantive artifact or plan, before commit").
   - Invoke `/qc-pass`. The QC target is the set of `{TODAY}-{slug}.md` files written in 16j; the evaluation criteria are the Step 3.6 plan-file schema and the risk-check change-class list in `ai-resources/docs/audit-discipline.md` § Risk-check change classes. Flag in particular any incorrect `Risk-check required:` annotation — a change class asserted for a change not on the canonical list, or a real change class missed.
   - **GO / no findings:** proceed to 16l.
   - **Findings returned:** the QC → Triage auto-loop applies (`ai-resources/docs/qc-independence.md`). Apply the corrections to the affected plan file(s) in place. Editorial DISAGREE verdicts that cannot be self-resolved from the change-class list are surfaced to the operator per Autonomy Rule #4.
   - This QC reviews plan-file content only — it does not re-open the operator's `f/d/s` dispositions from Steps 3 and 3.5.
   - Carry the QC outcome (`GO` or `{N} finding(s) fixed`) to the 16l summary.

16l. Print to operator:
```
Plan(s) written ({TOTAL_FIX} fix-now items across {P} plan(s)):
  {ordinal}. {absolute_path}  — {N} items
  ...

Plan QC: {GO — no findings | {N} finding(s) found and corrected in place}

Open each plan in a follow-up session to execute. Implement all plans before next Friday.
```

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

### Step 4.2: Weekly Session Value Review (all tiers; optional section)

> Producer: `/friday-checkup` Step 6 item 14.5 → report section `## Weekly Session Value Review` (exact heading). Two-end contract — do not rename the heading in either command without updating both ends. Advisory consumption path: this step gives the roll-up's "stop/constrain/rule" findings a disposition, so they do not sit unactioned in the report.

20a. Skip this step silently if the report has no `## Weekly Session Value Review` section (pre-2026-06-12 report), or its body is "(no session value audits this week)".
20b. Collect the non-empty bullets from `### Session types to constrain or batch`, `### Session types to stop`, and `### One operating rule change` (ignore "(none)" / "none" placeholders). If all three are empty, skip with one chat line: "Session value review: no constrain/stop/rule candidates this week."
20c. Display the collected items:
    ```
    Session value review — triage candidates ({REPORT_DATE}):
      1. {item} — {constrain/batch | stop | rule-change}
      ...

    For each, decide:
      (a)dopt   — adopt the constraint / stop the session pattern; log the adopted line to the Step 5 session block
      (n)o-change — noted, no action this cycle
      (d)efer   — re-evaluate next cycle
    ```
20d. Wait for per-item disposition. For an adopted **rule-change** item, follow the same rule as Step 4's `r` disposition: capture proposed edit text, do NOT auto-edit CLAUDE.md or any command — log the proposal under the Step 5 `Policy proposals` subsection for a follow-up session with its own plan + `/risk-check`. Adopted constrain/stop items are operator working agreements — log them under `Session value review` in the Step 5 session block; no file edits from this step.

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
    - Tactical: {F} queued for plans, {D} defer, {S} skip (of {TOTAL} items; of which {SO_COUNT} System Owner-derived, {JOURNAL_COUNT} journal-derived)
    - Triage source: {AUTO_DEFAULT} auto-default, {OPERATOR_OVERRIDE} operator-override (of {TOTAL} items)
    - Policy review: {R} rule-change proposed, {N} no-change, {D} defer (monthly+ only; omit for weekly)
    - Architectural retrospective: {captured | skipped} (quarterly only; omit otherwise)

    ### Session value review (omit if Step 4.2 skipped or had no candidates)
    - {adopted constrain/stop working agreement, one line each — rule-change adoptions go under Policy proposals instead}

    ### Deferred items (from this session)
    - {tactical or policy item text} — {risk if tactical}, {source: checkup | so-derived | policy}

    ### Plans written (this session)
    - {path} — {N} items
    (omit if FIX_NOW_ITEMS was empty)

    ### Policy proposals (monthly+; omit if none)
    - For "{observation}": {operator's proposed rule edit}

    ### Architectural retrospective notes (quarterly only; omit otherwise)
    {operator's free-form response to substrate questions}

    ### Operator observations
    {free-form text — see prompt below}

    ### Autonomy & Reliability notes
    {free-form text — see prompt below}
    ```

22. Prompt the operator for free-form observations:
    ```
    Maintenance observations — what did you notice about repo health, friction, or coupling
    that the findings didn't surface? (free text; "(none)" to skip):
    ```
    Capture verbatim. If the response is `(none)` or empty, write `(none)` in the `Operator observations` section.

22b. Prompt the operator for autonomy & reliability notes (this is the standing weekly capture of how to make maintenance more self-running — note #7 of the maintenance-discipline plan):
    ```
    Autonomy & reliability — what blocked maintenance from running on its own this cycle, and
    what one structural change would make it more self-functioning next time? (free text;
    "(none)" to skip):
    ```
    Capture verbatim into the `Autonomy & Reliability notes` subsection. If the response is `(none)` or empty, write `(none)`. These notes accumulate across cycles as the raw signal for the closure-throughput / enforcement-automation work that moves the system toward autonomous maintenance — they are reviewed (not auto-actioned) at the monthly/quarterly tiers.

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
    Tactical: {F} queued into {P} plan(s), {D} defer, {S} skip (of {TOTAL})
    {Policy review summary if monthly+}
    {Architectural retrospective summary if quarterly}
    Axis targets: {count of non-hold axes}/7 changed

    Session block appended to: ai-resources/logs/maintenance-observations.md

    {If any policy proposals were captured:}
    Policy proposals captured — schedule a follow-up session to draft + /risk-check the rule edits.

    Suggested next: /wrap-session
    ```

29. **Plan files.** Plan files written in Step 3.6 are unstaged. Stage and commit them manually or via `/cleanup-worktree` at session wrap. Each plan file's downstream execution follows standard commit-directly rules (each fix's commit happens at execution time in the follow-up session). The `maintenance-observations.md` append lands unstaged; the operator stages and commits it manually at session wrap (or invokes `/cleanup-worktree` if it accumulates).

---

### Notes

- **Session 1/2 boundary.** This command refuses audit-rerun language (Step 1.8). Use `/friday-checkup` for evidence, `/friday-act` for action.
- **System Owner inputs (Steps 1.5 + 3.5).** `/friday-act` reads the freshest `/friday-so` advisory and `/systems-review` report (filtered to ≥ checkup date and ≤ 7 days old) as supplementary inputs. The SO outputs are prose; `/friday-act` does not parse their content — it displays the first 30 lines and lets the operator paste any actionable items as `[risk] {text}` for the same disposition loop as checkup items. If both SO files are missing, Step 3.5 self-skips. Producer-side commands (`/friday-so`, `/systems-review`) are not modified — coupling is one-way (consumer reads producer outputs).
- **Journal Report (Steps 1.5 + 3 + 3.5 + 5).** `/friday-act` reads the freshest `/friday-journal` report (filtered to ≥ checkup date and ≤ 7 days old) as a third supplementary input. Unlike the SO outputs (prose), the journal report's `## Items` section is pre-structured to the same `[risk] {text}` shape as Step 3.5's regex — sub-step 16f extracts those lines directly and feeds them into the disposition loop with no paste-prompt. The producer-side schema-contract callout lives in `.claude/commands/friday-journal.md` Step 5; do not change the prefix syntax in either command without updating both ends. Coupling is one-way (consumer reads producer).
- **Project-internal logs (Steps 1.5 + 16a).** `/friday-act` enumerates scoped projects from the checkup report's `## Scopes audited` block and reads each scoped project's `improvement-log.md` (active entries), `session-notes.md` (last 3 entries), and `friction-log.md` (last 5 entries, if present) at Step 16a. These reads surface project-internal context the checkup roll-up may have compressed — recurring friction, in-flight improvement work, recent decisions. Items derived from these reads feed into the same paste-prompt as SO-derived items (16b–16e) and are labeled `so-derived` in `RESULTS` for subtotal purposes (the source label distinguishes paste-input from journal-derived; project-derived items are paste-input mechanically).
- **Token cost of Step 16a (delegated to subagent).** Step 16a delegates all supplementary-input reads to the `friday-act-16a-summarizer` subagent, which writes full extraction to `audits/working/friday-act-step16a-{TODAY}.md` and returns a ≤30-line paste-ready summary. Main-session context cost is bounded by the summary cap rather than raw section volume (pre-delegation: ~500–1500 lines for a typical 2–3-project run). If running near context limits, the ≤30-line cap removes the need to split the disposition session. Step 3 and the checkup report itself are unaffected.
- **7-day vs. 10-day filter rationale.** Supplementary inputs (Friday Advisory, Systems Review, Journal Report) all use a **7-day** filename-date filter — these are session-window-scoped artifacts produced for a specific Friday and stale beyond that week. The checkup report itself uses a **10-day** abort threshold (Step 1.7) because it pairs with the `friday-checkup-reminder.sh` hook's recovery-Friday window; a 10-day grace allows skipped-Friday recovery without re-running the audit. The two thresholds are intentionally distinct: 7-day = "fresh for this Friday's session"; 10-day = "fresh enough to still be the basis for action."
- **`/risk-check` gate (Step 3.6).** The change-class check runs at plan-write time (Step 3.6) to annotate plan files — it does NOT prompt the operator or invoke `/risk-check` during `/friday-act`. The gate runs in the follow-up session, immediately before executing the flagged item.
- **Plan-file QC (Step 3.6, sub-step 16k).** After plan files are written, `/friday-act` runs an automatic `/qc-pass` on them before announcing them — plan files are substantive artifacts subject to the workspace QC rule. The failure mode this guards is an incorrect `Risk-check required:` annotation; added 2026-05-22 after a cycle shipped 4 wrong annotations caught only by later operator review. Findings are corrected in place via the QC → Triage auto-loop; the QC outcome is reported in the 16l summary.
- **No auto-edit of CLAUDE.md or audit-discipline.md.** Policy proposals (Step 4) capture intent; the rule edits themselves go through their own plan + `/risk-check` cycle.
- **Coaching-log untouched.** The seven autonomy axes are forward-looking weekly posture targets; coaching-log's five session-pattern dimensions are backward-looking session ratings. Different orientation, kept separate (per workspace decision 2026-04-24).
- **Skipped-Friday recovery.** If `DAYS > 10` (Step 1.7), the command refuses. Recovery flow: run `/friday-checkup` first; that command's Step 0 will offer recovery-Friday vs. fold-into-next-Friday options; then re-invoke `/friday-act` against the fresh report.
- **Plan branching (Step 3.6).** Fix-now items are written to plan files in `audits/friday-plans/`, never executed inline. Threshold: ≤ 4 items → one `{date}-consolidated.md`; > 4 → one `{date}-{area-slug}.md` per file/area group (items with no identifiable path target go into `{date}-general.md`). Plan files use a fixed schema (see Step 3.6). Each plan is implemented in its own follow-up session before the next Friday. W2.4 auto-draft sub-disposition is deferred to the execution session; the plan file annotates the item as W2.4-sourced.
