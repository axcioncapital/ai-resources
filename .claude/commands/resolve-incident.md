---
description: Classify, fix, verify, and log a mid-session fault or repo incident end-to-end. Single-pass; no subagents. Produces a resumable per-incident record. Use /resolve-repo-problem for triage-only investigations where no fix is applied.
model: opus
---

Resolve a mid-session fault or repo incident: classify the risk, apply the smallest safe durable fix, verify it observably, and write a standardized resumable incident record. **This command implements the change.** For investigation-only (three-option plan, no fix), use `/resolve-repo-problem` instead.

Input: `$ARGUMENTS` — free-text description of the fault, broken state, or inconsistency. Must be non-empty.

Examples:
- `/resolve-incident "resolve-repo-problem.md Step 4 links to a non-existent file — clean up the dead reference"`
- `/resolve-incident "coaching-data.md has a malformed ## Session header that breaks parsing"`
- `/resolve-incident "prime.md Step 1 reads the wrong field — fix the scratchpad detection logic"`

---

## Hard rules (read before starting — do not override)

1. **No edit without a diagnosis.** Step 3 must produce a root-cause block with ≥1 file:line citation before Step 6 may run. A plausible guess is not a diagnosis.
2. **No protected-zone edit without a passing gate.** If Step 2 identifies a protected zone, `/risk-check` must run and return GO or PROCEED-WITH-CAUTION (with mitigations applied) before Step 6 proceeds. A RECONSIDER verdict stops the fix — write the record with `status: escalated` and stop.
3. **Bounded implementation.** Step 6 may only touch the files stated in Step 4. Opportunistic edits outside that set are not allowed. If implementation reveals the plan was wrong, stop, update Steps 3–4, and re-enter Step 6 once.
4. **Verification receipt is mandatory.** Step 7 requires all four fields to be non-blank. Do not proceed to Step 8 with any blank field.
5. **No commit.** This command implements the fix but does not commit. Committing is operator-discretionary. See Step 9.
6. **Status is mandatory.** Every incident record carries one of: `diagnosing` / `implementing` / `verifying` / `resolved` / `escalated` / `deferred`. This is how an interrupted session resumes from the record rather than from chat context.

---

## Step 1 — Input validation and path setup

1. If `$ARGUMENTS` is empty, abort:
   ```
   /resolve-incident requires a fault description.
   Example: /resolve-incident "prime.md Step 1 reads the wrong field — fix the scratchpad detection logic"
   Use /resolve-repo-problem for triage-only investigations (no fix applied).
   ```

2. Set `ISSUE` = `$ARGUMENTS` verbatim.

3. Set `DATE` = today in `YYYY-MM-DD`.

4. Set `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel` (fall back to cwd if not a git repo).

5. Set `AI_RESOURCES` = absolute path to `ai-resources/` under `REPO_ROOT`. Confirm it exists; abort if not found.

6. Compute `SLUG` from `ISSUE`:
   - Lowercase.
   - Replace runs of non-alphanumeric characters with a single `-`.
   - Strip leading and trailing `-`.
   - Truncate to 60 characters; if truncation falls mid-word, trim back to the nearest preceding `-`.
   - If the result is empty, fall back to `incident-{HHMMSS}` (current time).

7. Set `INCIDENT_PATH` = `{AI_RESOURCES}/audits/incidents/{DATE}-{SLUG}.md`. Create the `audits/incidents/` directory if it does not exist (`mkdir -p`). If `INCIDENT_PATH` already exists, append `-2`, `-3`, … until unique.

8. Set `TEMPLATE_PATH` = `{AI_RESOURCES}/templates/incident-log-template.md`. If it does not exist, abort with an error — the template is required to proceed.

---

## Step 2 — Classification

Classify the fault before any investigation. The goal is to decide the required process, not to diagnose the cause.

9. Read `{AI_RESOURCES}/docs/protected-zones.md`.

10. Read the relevant section of `{AI_RESOURCES}/docs/audit-discipline.md` under the `## Risk-check change classes` heading to confirm the current class list. (Use this heading as the content anchor — do not rely on line numbers, which drift on reformatting.)

11. For the fix area described in `ISSUE`, decide:

    **`PROTECTED?`** — Does the proposed fix touch any path listed in `docs/protected-zones.md`? Yes / No. If yes, name the matching zone(s).

    **`RISK?`** — Low / Medium / High / Critical:
    - **Critical:** deletion, migration, permission broadening, cross-project refactor.
    - **High:** hooks (`.claude/hooks/*.sh`), permission settings (`settings.json`), cross-cutting `CLAUDE.md` edits, new commands or skills, new symlinks, automation with shared-state effects.
    - **Medium:** edits to existing shared commands, agents, or workflow docs; project logic changes.
    - **Low:** local project doc edits, isolated small bug fixes, cosmetic corrections.

12. **Gate check:**
    - If `RISK = Critical` → stop. Write the incident record with `status: escalated`, note that Critical-risk changes require explicit operator approval (Autonomy Rule #4 / #9), and output the gate result to chat. Do not proceed.
    - If `RISK = High` OR `PROTECTED = yes` → invoke `/risk-check $ISSUE` via Skill tool. Capture the verdict.
      - `GO` → proceed.
      - `PROCEED-WITH-CAUTION` → note the required mitigations; proceed only if all mitigations can be applied in this session.
      - `RECONSIDER` → write the incident record with `status: escalated` (see Step 8 for the write). Output to chat: the risk-check verdict + what was found. Stop — do not proceed to Step 3.

    > **Verbatim-shape contract — `/risk-check` verdict tokens.** The three token literals above (`GO`, `PROCEED-WITH-CAUTION`, `RECONSIDER`) are the canonical values defined in `audit-discipline.md § Verdict semantics`. If that section ever renames a token, this step must be updated in the same commit. Do not parse partial matches or add synonyms.
    - If `RISK ≤ Medium` AND `PROTECTED = no` → proceed directly to Step 3. Set `RISK_CHECK_VERDICT = N/A`.

---

## Step 3 — Diagnosis

**Hard rule from the top of this file: no edit may proceed in Step 6 unless the diagnosis block below exists with ≥1 file:line citation.**

13. Read the files implicated by `ISSUE`: the command/agent/hook/doc named in the fault description, plus the relevant section of the nearest `CLAUDE.md`.

14. Read the tail of `{AI_RESOURCES}/logs/friction-log.md` (last 30 lines) and `{AI_RESOURCES}/logs/decisions.md` (last 15 lines) for context — a past decision may explain the current state.

15. Produce the diagnosis block:
    - **Root cause:** 1–3 sentences. Distinguish the symptom (what broke or is wrong) from the cause (why it is wrong). If the evidence does not support a single root cause, list candidate causes and label them as such rather than forcing one.
    - **Evidence:** ≥1 file:line citation. Quote the specific line or block that proves the cause. "I checked the file" is not evidence.
    - **Alternative causes considered:** list each plausible alternative and explain why the evidence rules it out. For Low-risk incidents, one sentence is enough. For Medium+ risk, this must be substantive.

---

## Step 4 — Resolution strategy

16. State the smallest safe durable fix in one paragraph:
    - Which files change (exact paths).
    - What changes in each (line range or section).
    - What behavior changes.
    - What does NOT change (scope boundary).

17. List files that will NOT be changed even though they touch the same area, with a one-line reason for each exclusion.

18. **High-risk second opinion.** If `RISK ≥ High`:
    a. **Pre-invoke gate:** `/consult` Step 0 requires a prior Read before its read-first gate will pass. Read the single most relevant file the question turns on (the command body, agent spec, or hook that the fix modifies). You likely already read this in Step 3 — if so, this is already satisfied.
    b. Invoke `/consult` (Function B — pre-change advisory) via Skill tool with a brief that includes: the fault description, the proposed fix, the `/risk-check` verdict (if run), and the question: "Is this the smallest safe durable fix, or does this approach create downstream risks I haven't named?"

    > **Verbatim-shape contract — `/consult` Function B selector.** "Function B" is the advisory function defined in `projects/repo-documentation/vault/references/grounding.md § 2`. It is invoked by passing `Function: B — Pre-change advisory` in the system-owner agent brief. If `/consult` or `grounding.md` is ever reorganized and Function B is renamed, this step and the contract comment must be updated in the same commit.

    c. Record the system-owner second opinion verbatim in the incident record (Classification section, `/consult second opinion` field). The second opinion is advisory — it does not override the risk-check verdict.

---

## Step 5 — Pre-edit record setup

19. Read `TEMPLATE_PATH` (`templates/incident-log-template.md`).

20. Fill in all fields that can be determined before the edit:
    - Frontmatter: `incident-id`, `status: implementing`, `severity`, `risk`, `protected-zone-touched`.
    - Intake, Classification (with risk-check and consult verdicts if applicable), Diagnosis, and Resolution sections.
    - Verification receipt: leave all four fields with placeholder text — they will be filled in Step 7.
    - Pattern-tracking fields: fill as accurately as possible; "unsure" is acceptable.

21. Hold the filled record in working memory. **Do NOT write it to `INCIDENT_PATH` or append to `logs/incident-log.md` yet** — write only after verification in Step 7 is complete.

---

## Step 6 — Implementation

22. Apply the change. The files touched must match exactly what Step 4 named. No additional files.

23. If, during implementation, it becomes clear the Step 4 plan was wrong (a required change is outside the stated scope, or the stated fix does not address the root cause):
    - Stop immediately.
    - Update the Diagnosis (Step 3) and Resolution strategy (Step 4) in the working record.
    - Re-enter Step 6 once with the revised plan.
    - If the revised plan still fails or expands scope significantly, write the incident record with `status: deferred` and stop. Report the diagnosis and the reason the fix could not be completed cleanly.

24. Update `status` in the working record to `verifying` once all planned changes are applied.

---

## Step 7 — Verification

25. Fill the four-field verification receipt in the working record:

    - **What was tested:** Name the specific behavior checked. At minimum: (a) confirm the file now reads as intended (quote the changed line); (b) if the fix is logic-bearing (a command body, agent behavior, hook), describe what behavior was observed. Be specific — "the broken behavior no longer occurs" is not enough.
    - **What passed:** Observable evidence — file content after edit (quote it), grep output, command output. Not "I checked." Not "it looks correct."
    - **What was NOT tested + why:** Be explicit about gaps. Acceptable reasons: "not in scope — the fix is doc-only"; "would require a full session run — deferred to follow-up smoke test"; "the affected command is autosynced and testing requires a project session."
    - **Residual risk + rollback path:**
      - Residual risk: 1–2 sentences on what could still go wrong and under what conditions.
      - Rollback path: 1 concrete action — e.g., `git revert {commit-hash}` (if committed), or `git checkout HEAD -- path/to/file` (if not yet committed).

26. **Hard rule:** Do NOT proceed to Step 8 if any of the four fields is blank or contains only a placeholder. If you cannot complete a field, write the incident record with `status: deferred` and state the gap in the Residual risk field.

27. Update `status` in the working record to `resolved`.

---

## Step 8 — Logging

Three writes, in this order:

**8a. Full record → `INCIDENT_PATH`.**

28. Write the complete filled incident record to `INCIDENT_PATH` (`audits/incidents/{DATE}-{SLUG}.md`). This is a new file, not an edit to an existing log.

**8b. One-line index entry → `logs/incident-log.md`.**

29. Append one entry at the bottom of `{AI_RESOURCES}/logs/incident-log.md` using the schema block in that file:

    ```
    ### {DATE} — {short title from ISSUE, ≤60 chars}

    - **Status:** {resolved | escalated | deferred}
    - **Risk:** {Low | Medium | High | Critical}
    - **Protected zone touched:** {yes | no}
    - **Affected component:** {value from pattern-tracking fields}
    - **Failure category:** {value from pattern-tracking fields}
    - **Root cause:** {root cause, 1 sentence}
    - **Follow-up:** {none | improvement-log entry "{DATE} — {title}"}
    - **Record:** `audits/incidents/{DATE}-{SLUG}.md`
    ```

**8c. Structural follow-up → `logs/improvement-log.md` (conditional).**

30. This step fires only when the incident exposes a structural weakness that a local fix alone cannot prevent from recurring — for example: a shared command has a weak contract; a governance doc is missing; a pattern has recurred twice. For one-off incidents or local-only fixes, skip this step.

31. If fired: append a `logged (pending)` entry to `{AI_RESOURCES}/logs/improvement-log.md` using the existing improvement-log schema (see the `### Improvement-log entry schema` block in `resolve-repo-problem.md` for the exact shape — use this heading as the content anchor, not a line number). The `Proposal` field should describe the structural fix in 2–4 sentences naming target files. The `Notes` field should cite `INCIDENT_PATH`. The `Category` field should be `incident-followup`. **Operator-approved write-coupling to the Friday cadence (same pattern as `/resolve-repo-problem`; coupling approved 2026-05-28).** Do not auto-promote — the Friday cadence triages it.

    > **Verbatim-shape contract — improvement-log append schema.** The field names used here (`Status`, `Category`, `Source`, `Friction source`, `Proposal`, `Target files`, `Notes`) are a two-end contract with `/friday-act` and `/resolve-improvement-log`. If the improvement-log schema block in `resolve-repo-problem.md` changes field names, this step and the contract comment must be updated in the same commit.

---

## Step 9 — Report to operator

32. Emit ≤8 lines to chat:

    ```
    Incident resolved — {DATE}
    Root cause: {1 sentence}
    Risk: {Low/Medium/High}   Protected zone touched: {Yes/No}
    Files changed: {list, one per line if >1}
    Verification: {1-line summary of what was confirmed}
    Follow-up (if any): {improvement-log entry title, or "none"}
    Full record: audits/incidents/{DATE}-{SLUG}.md
    ```

    If the incident was **escalated** (RECONSIDER verdict or Critical risk):
    ```
    Incident escalated — {DATE}
    Reason: {1 sentence — risk-check verdict or Critical-class change}
    Diagnosis: {1 sentence}
    No changes made.
    Record: audits/incidents/{DATE}-{SLUG}.md
    Next action: {what the operator needs to decide or run}
    ```

    If the incident was **deferred** (fix could not be completed cleanly):
    ```
    Incident deferred — {DATE}
    Reason: {1 sentence}
    Diagnosis: {1 sentence}
    Partial changes (if any): {list or "none"}
    Record: audits/incidents/{DATE}-{SLUG}.md
    Next action: {what would need to happen to close it}
    ```

33. **No commit.** The fix is applied but not committed. Committing is operator-discretionary. After the operator confirms the fix looks good, remind them to commit per workspace commit rules. Do NOT push — pushes are batched and gated to the `/wrap-session` confirmation prompt (workspace `CLAUDE.md` § Push behavior).

---

## Escalated-record fast path (Steps 2 and 6 abort cases)

When the command stops early (RECONSIDER verdict, Critical risk, Step 6 plan failure), still write a partial incident record:

- Fill all fields up to the point where the command stopped.
- Set `status: escalated` (risk gate) or `status: deferred` (implementation failure).
- Fill the Follow-up field with the next action the operator needs to take.
- Write to `INCIDENT_PATH` and append to `logs/incident-log.md`.
- Do NOT append to `improvement-log.md` in an escalation — the operator decides next steps.
