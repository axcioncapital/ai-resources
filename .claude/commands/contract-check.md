---
description: Contract-conformance check — compares the current artifact against its original frozen contract (mandate, brief, spec, plan). Catches cumulative drift introduced across multiple rounds of QC fixes. Returns CONTRACT-ALIGNED / MINOR-DRIFT / MAJOR-DRIFT. Advisory only.
model: opus
---

Check whether an artifact still matches what was originally agreed at the start of work. `/contract-check` resolves the original contract, identifies the current artifact, then delegates an **independent** comparison to a fresh-context subagent. The subagent receives only the contract text and the artifact text — no QC history, no session conversation, no creation context. Advisory only — it modifies no files and does not correct course; it tells the operator whether a correction is needed.

`/contract-check` is the artifact-content drift complement to `/drift-check` (which watches session trajectory). Use it when:
- Two or more rounds of QC pass → resolve findings → re-QC have completed (the two-pass cap moment — see `ai-resources/docs/qc-independence.md` § QC → Triage Auto-Loop).
- A long-running session has produced cumulative local fixes and the operator wants to verify the result still matches the original brief.
- An artifact built across multiple sessions reaches a checkpoint.
- The operator suspects drift but `/drift-check` returns ALIGNED (because session trajectory looks fine, but the artifact itself has wandered).

Input: `$ARGUMENTS` — optional. Interpreted as:
- **If a valid file path** (exists on disk, or starts with `/` or `./` or matches `**/*.md` or `**/*.json` etc.) → use as the contract path. Read the file at that path as `CONTRACT`.
- **If non-empty free text that is not a valid path** → use the text verbatim as the contract (the operator pasted the brief inline).
- **If empty** → auto-detect the contract (Step 2).

---

### Step 1 — Path setup

1. Set `DATE` = today, `YYYY-MM-DD`.
2. Determine `REPO_ROOT` = `git -C "$(pwd)" rev-parse --show-toplevel`. If the cwd is not a git repo, set `REPO_ROOT` = cwd; auto-detect logic in Step 2 still searches the cwd for log files.
3. Note the cwd. If the cwd is a project subdirectory (e.g., `projects/{name}/`), the project's own briefs and specs may live here — auto-detect searches both cwd and `REPO_ROOT/logs/`.

---

### Step 2 — Resolve the original contract

4. **If `$ARGUMENTS` is non-empty, classify it:**

   - **Looks-like-a-path heuristic.** `$ARGUMENTS` is treated as a path if it satisfies any of:
     - Starts with `/` (absolute path)
     - Starts with `./` or `../` (explicit relative path)
     - Contains `/` and ends with a file extension (`.md`, `.json`, `.txt`, `.yaml`, `.yml`)
     - Is a single token (no spaces) under 200 characters
     - Resolves to an existing file when tested with `[ -f "$ARGUMENTS" ]` against the cwd or `REPO_ROOT`

   - **If looks-like-a-path:** test existence. If the file exists → read it; set `CONTRACT` = file contents; set `CONTRACT_SOURCE` = the path. Skip to Step 3.

     If the file does NOT exist → emit one warning line: `Note: '{$ARGUMENTS}' looks like a path but file not found. Treating as pasted contract text instead.` Then set `CONTRACT` = `$ARGUMENTS` verbatim; set `CONTRACT_SOURCE` = `(pasted inline — operator-supplied)`. Skip to Step 3.

   - **If not-looks-like-a-path (free text):** set `CONTRACT` = `$ARGUMENTS` verbatim; set `CONTRACT_SOURCE` = `(pasted inline — operator-supplied)`. Skip to Step 3.

5. **If `$ARGUMENTS` is empty, auto-detect in this order. Stop at the first source that resolves.**

   a. **Frozen contracts directory.** If `REPO_ROOT/logs/contracts/` exists, list `*.md` files in it sorted by mtime descending. If a file dated today (`YYYY-MM-DD-*.md` with today's date) exists, set `CONTRACT_SOURCE` = that path. If only older contracts exist, surface them as candidates (do not auto-pick — ask).

   b. **Session plan.** If `REPO_ROOT/logs/session-plan.md` exists AND was last modified today, set `CONTRACT_SOURCE` = `logs/session-plan.md`. The plan's `## Intent`, `## Findings / Items to Address`, and `## Execution Sequence` sections form the contract body.

   c. **Session-notes mandate block.** If `REPO_ROOT/logs/session-notes.md` exists, read the last (bottom-most) `## {DATE}` entry block. If it contains a `**Mandate:**` line, set `CONTRACT_SOURCE` = `logs/session-notes.md (mandate block from {DATE})`. The mandate line plus the `Out of scope`, `Files in scope`, `Stop if`, `Allowed inputs`, `Required outputs` bullets form the contract body.

   d. **Active project briefs.** If the cwd is under `projects/{name}/`, check that project's well-known brief locations:
      - `projects/{name}/output/{stage}/brief.md`
      - `projects/{name}/answer-spec.md`
      - `projects/{name}/research-plan.md`
      - `projects/{name}/intake.md`

      If exactly one exists and was modified within the past 7 days, set `CONTRACT_SOURCE` = that path. If multiple exist, list them and ask.

   e. **Workflow intake.** If the cwd is under `workflows/{name}/`, check `workflows/{name}/intake.md` and `workflows/{name}/brief.md`.

   f. **Inbox brief.** If a skill-creation or resource-request session is underway, check `ai-resources/inbox/*.md` for a brief whose name appears in the recent conversation context. (Conservative — only pick if the link is unambiguous.)

   g. **Nothing resolved.** Emit:
      ```
      /contract-check could not auto-detect the original contract.

      Pass one of these:
        /contract-check {path-to-contract-file}
        /contract-check {paste the original brief inline as free text}

      Or run /scope or /session-start first to record one.
      ```

6. **Surface what was picked, then proceed.** Per Decision-Point Posture (workspace `CLAUDE.md`), emit one notice line and continue without confirmation — matching `/drift-check`'s posture. The verdict will surface a wrong-source mismatch downstream; the operator can re-invoke with the corrected source then.

   > Contract source: `{CONTRACT_SOURCE}` (auto-detected). Re-invoke with `/contract-check {path-or-text}` if this is the wrong anchor.

   When `$ARGUMENTS` is non-empty (operator explicitly specified the contract), omit even this notice — the source is already named in the operator's invocation.

---

### Step 3 — Resolve the artifact under check

7. **Identify the artifact.** `$ARGUMENTS` is reserved for the contract in v1 (see Input section). The artifact is always resolved from session state, not from `$ARGUMENTS`. Future v2 may add a dual-argument grammar; until specified, do not parse `$ARGUMENTS` for an artifact path.

   Auto-detect:
   - Run `git -C {REPO_ROOT} status --short 2>/dev/null` to list uncommitted changes.
   - Run `git -C {REPO_ROOT} log --since="{DATE} 00:00:00" --name-only --pretty=format: 2>/dev/null | sort -u` to list files touched today.
   - Combine the two lists; deduplicate; exclude obvious infrastructure paths: `logs/*`, `audits/working/*`. Include `.claude/*` candidates — when the work IS on a command/agent file, those are the artifact; the multi-candidate prompt lets the operator pick.

   **Resolution rules:**
   - **Zero candidates** → ask the operator: `Which file should I check? Provide the path.` Wait for one response. Use it.
   - **Exactly one candidate** → use it. Emit: `Artifact: '{path}' (auto-detected from uncommitted/today's changes).`
   - **Multiple candidates** → list up to 5, numbered. Ask: `Which is the artifact? Reply with a number or a different path.` Wait. Use the selected. (Artifact identity has higher stakes than contract source, so this ask is retained; cf. Step 2 item 6 which is notice-only.)

8. **Read the artifact.** Set `ARTIFACT` = the file contents. Set `ARTIFACT_PATH` = the absolute path.

   If the artifact file is >800 lines, the subagent will receive only the first 800 lines plus a `[truncated]` marker — note this in the brief.

---

### Step 4 — Delegate the independent conformance comparison

9. Spawn one general-purpose subagent (fresh context) with this brief (verbatim structure):

   ```
   You are an independent contract-conformance reviewer for an in-progress work artifact. Judge whether the current state of the artifact still matches its original contract — the brief, mandate, plan, or spec that was agreed at the start of work, before any QC iterations modified the draft.

   You have NO view of the session's conversation, no view of the QC history, and no view of any intermediate drafts. Judge solely from the two texts below.

   ---

   ORIGINAL CONTRACT (the reference standard — read this in full):

   Source: {CONTRACT_SOURCE}

   {CONTRACT verbatim}

   ---

   CURRENT ARTIFACT (the thing to check):

   Path: {ARTIFACT_PATH}

   {ARTIFACT verbatim, or first 800 lines + [truncated] marker if longer}

   ---

   COMPARISON RUBRIC

   Read both texts. Identify what the contract committed to — explicit deliverables, scope boundaries, required fields, exit conditions, stated out-of-scope items, stop-if conditions, prohibited moves. Then judge whether the current artifact:

   1. Still delivers what the contract committed to (all required items present, in usable form).
   2. Has not added work the contract excluded (out-of-scope creep).
   3. Has not removed or hollowed out commitments the contract required.
   4. Has not contradicted a stated scope boundary or stop-if condition.
   5. Still matches the contract's intent — the soft fit, not just literal-match. A research extract may legitimately expand on the brief; a settings.json edit may not.

   Calibrate strictness by contract type:
   - **Hard contracts** (settings.json edit, hook script, skill spec, mandate with explicit deliverable counts, structural change with risk-check mitigations) → literal-match. Any added scope is MINOR-DRIFT; any removed commitment is MAJOR-DRIFT.
   - **Soft contracts** (research brief, advisory question, knowledge-file purpose statement, exploratory spec) → intent-match. Reasonable elaboration is ALIGNED. Drift only fires when the artifact answers a different question than the brief asked, or skips a required dimension the brief named.

   ---

   VERDICT (choose one):

   - CONTRACT-ALIGNED — the artifact still matches the contract on all load-bearing dimensions. No correction needed.
   - MINOR-DRIFT — small additions, scope expansions, or wording shifts that do not contradict the contract but were not explicitly committed to. Operator can absorb into scope or roll back.
   - MAJOR-DRIFT — the artifact has moved onto goals the contract excludes, has dropped or hollowed out a required commitment, contradicts a stop-if or out-of-scope clause, or answers a different question than the contract asked.

   Return AT MOST 25 lines. Write no file to disk — the verdict is short by construction.

   Line 1: VERDICT: CONTRACT-ALIGNED | MINOR-DRIFT | MAJOR-DRIFT
   Line 2: Contract type: hard | soft  (which rubric you applied, with one-clause reason)
   Lines 3-N: Divergences:
     - Bulleted. Each bullet names a specific contract clause (quote or paraphrase, with line ref where possible) and the specific artifact divergence (quote, section, or behavior).
     - If CONTRACT-ALIGNED, write "Divergences: none".
   Final 1-2 lines: Recommended correction:
     - For ALIGNED: "continue".
     - For MINOR-DRIFT: name the smallest rollback or scope-absorption step.
     - For MAJOR-DRIFT: name the contract clause to re-anchor on; recommend stop-and-reconcile with the operator before further edits.
   ```

   The conformance verdict is short by construction, so the subagent returns it directly with no working-notes file — the `ai-resources/CLAUDE.md` Subagent Contracts disk-notes rule targets many-file audits with long findings, not this focused comparison.

---

### Step 5 — Present the verdict

10. Display the subagent's verdict verbatim to the operator, prefixed with:

    ```
    Contract-conformance check — {DATE}
    Contract: {CONTRACT_SOURCE}
    Artifact: {ARTIFACT_PATH}
    ```

11. Append guidance by verdict:
    - `CONTRACT-ALIGNED` → "On contract. Continue."
    - `MINOR-DRIFT` → "Minor drift from contract — review the divergences; decide whether to absorb into scope (and re-state the contract) or roll back."
    - `MAJOR-DRIFT` → "Major drift from contract — stop. Re-anchor on the contract clause named, reconcile with the operator, then decide whether to roll back, re-scope, or continue with an updated contract."

12. `/contract-check` modifies no files and commits nothing. It is an advisory read-only check; the operator decides what to do with the verdict.

---

### Notes for future extension

- **Freeze-baseline at `/scope` time** (deferred). The cleanest contract source is one written explicitly at start-of-work to `logs/contracts/{date}-{slug}.md`. Adding a write step to `/scope` (and to `/session-start`, `/create-skill` Step 4, etc.) is a separate change that improves auto-detect reliability. Until that lands, auto-detect order in Step 2 falls back through session-plan, mandate-block, and project briefs.
- **Two-pass cap interaction.** When the two-pass cap fires (`ai-resources/docs/qc-independence.md` § QC → Triage Auto-Loop — "structural resolution required"), `/contract-check` is the right instrument to surface *what* structurally drifted. Future work may auto-invoke this command at the cap; today it is operator-triggered.
- **Per-project-type calibration.** The hard/soft contract distinction in Step 4 is the v1 calibration knob. If the verdicts come back consistently mis-calibrated for a project type, tune the rubric or add per-project-type instructions.
