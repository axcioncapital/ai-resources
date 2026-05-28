---
model: sonnet
---

# /pipeline-review — Weekly Pipeline Design Review

Run a deep System-Owner-grounded design review of 1–3 critical command pipelines per cycle. Operator-invoked weekly. Reads a registry, presents a ranked shortlist, the operator picks 1–3, the `pipeline-review-auditor` subagent produces a memo per pipeline, the registry is bumped, and the memos are written to disk. No auto-fix. No commit.

Subsumed `/audit-critical-resources` on 2026-05-29 — its drift-detection currency-check (against pinned Anthropic doc URLs) was folded into the pipeline-review-auditor's Brokenness section. This command now answers both *what could be better?* and *what is broken?* for the critical-resource population.

Input: `$ARGUMENTS` (optional) — a pipeline path. If provided, skip the shortlist step and review that pipeline directly. Empty input runs the shortlist flow.

---

## Registry contract (do not silently drift)

The registry at `ai-resources/audits/pipeline-review-registry.md` is the source of truth. Its shape is fixed:

- **5 columns:** `Pipeline` (path) · `Type` (command / skill) · `Last reviewed` (`YYYY-MM-DD` or `never`) · `Last memo` (`YYYY-MM-DD` or `—`) · `Friction flag` (Y / N).
- **`Last memo` is date-keyed, not path-keyed.** Resolve to a path with the convention `audits/pipeline-reviews/{pipeline-slug}-{YYYY-MM-DD}.md`.
- **Tiebreak:** rows sharing a `Last reviewed` value (including cold start where all are `never`) sort alphabetically by `Pipeline` column. Friction-flagged rows are promoted to the top regardless of date and tiebreak alphabetically among themselves.
- **Writes are audit-trail-grade.** Registry and memo writes are not cleanly `git revert`-able. The bumped row preserves history only via git log.

Per the `/risk-check` plan-time review of this command (Dimension 5: Hidden coupling, Medium): this block exists so the contract does not silently drift on later runs. Do not delete it.

---

### Step 1: Path Setup

1. Set `WORKSPACE` = Axcíon AI workspace root (parent of `ai-resources/`).
2. Set `AI_RESOURCES` = `{WORKSPACE}/ai-resources/`.
3. Set `REGISTRY_PATH` = `{AI_RESOURCES}/audits/pipeline-review-registry.md`.
4. Set `MEMO_DIR` = `{AI_RESOURCES}/audits/pipeline-reviews/`. Create if missing: `mkdir -p "{MEMO_DIR}"`.
5. Set `FRICTION_LOG_PATH` = `{AI_RESOURCES}/logs/friction-log.md`.
6. Set `USAGE_LOG_PATH` = `{AI_RESOURCES}/logs/usage-log.md` (may be absent — the auditor handles missing).
7. Set `DATE` = today in `YYYY-MM-DD`.
8. Verify `REGISTRY_PATH` exists. Abort with a loud error if missing.
9. Verify `{AI_RESOURCES}/.claude/agents/pipeline-review-auditor.md` exists. Abort if missing.

---

### Step 2: Skipped-Cycle Recovery (>10 days)

10. Read `REGISTRY_PATH`. Extract every `Last reviewed` value from the table. Discard `never` entries. If any dated entries exist, compute `MAX_DATE` = the most recent one.
11. If no dated entries exist (cold start — every row is `never`), set `DAYS_ELAPSED = 999` and treat as overdue.
12. Otherwise compute `DAYS_ELAPSED` with Python: `from datetime import date; print((date.today() - date.fromisoformat('{MAX_DATE}')).days)`.
13. If `DAYS_ELAPSED > 10`, print a loud top-line marker:

    ```
    [CADENCE-LATE] Last /pipeline-review was {DAYS_ELAPSED} days ago ({MAX_DATE}).
    Weekly cadence target is 7 days. Run as recovery, or defer with `d`.
    ```

    Wait for `y` (proceed as recovery), `d` (defer — exit with note), or any other input (abort cleanly).
14. If `DAYS_ELAPSED ≤ 10`, do not emit the marker. Continue silently.

The `>10` threshold matches `/friday-checkup` Step 0 — one missed weekly cycle plus slack. Documented here so future tightening to 7 has to be a deliberate decision, not a drive-by edit.

The `[CADENCE-LATE]` top-line marker is a required mitigation from the `/risk-check` plan-time review of this command (Dimension 5: Hidden coupling, Medium).

---

### Step 3: Argument Bypass

15. If `$ARGUMENTS` is non-empty:
    - Resolve the argument as a pipeline path (relative to `AI_RESOURCES`, expand `~`, accept absolute).
    - Verify the path exists. If not, abort with an error.
    - Set `PICKED_PIPELINES = [argument-path]` (single-pipeline override).
    - Skip to Step 5.
16. Otherwise, proceed to Step 4 (shortlist).

---

### Step 4: Shortlist Build

17. Parse `REGISTRY_PATH` into a list of rows. For each row, extract: `pipeline_path`, `type`, `last_reviewed`, `friction_flag`.
17.5. **Registry-drift check.** For each parsed row, resolve `pipeline_path` against `AI_RESOURCES` (relative paths) and `test -f` the result. If the file is missing, emit one line to the operator: `[REGISTRY-DRIFT] {pipeline_path} (row dropped — file does not resolve; rename, move, or stale registry entry)`. Drop the row from the working set. Do NOT abort the cycle. After all rows are checked, if any rows were dropped, also print: `Resolve drift before next cycle — edit {REGISTRY_PATH} to update or remove the stale entries.` Catches pipeline rename and tier-promotion failure modes — without this, the auditor would hard-fail at its first read and the next cycle would re-surface the same broken row.
18. Sort surviving rows by these keys in order:
    a. `friction_flag = Y` first (Y before N).
    b. `last_reviewed` ascending — `never` sorts as the oldest (treat as date `0000-00-00` for comparison).
    c. `pipeline_path` alphabetically — the cold-start tiebreak.
19. Take the top 5 rows as the shortlist.
20. Print the shortlist to the operator:

    ```
    /pipeline-review — {DATE}

    Shortlist (top 5, oldest first; friction-flagged promoted):

      1. {pipeline_path}  [{type}]  last-reviewed: {last_reviewed}  friction: {Y|N}
      2. ...
      ...
      5. ...

    {If every row is `never`, append:}
    Cold start — all rows are `never`. Tiebreak applied: alphabetical by pipeline path.

    Pick 1–3 by number (e.g., `1` or `1,3,5`), OR type a pipeline path not in the shortlist to override.
    Empty reply aborts.
    ```

21. Wait for operator reply. Parse:
    - Comma-separated numbers in `1..5` → pick those rows from the shortlist.
    - A path-shaped token → resolve as in Step 3 (override allowed). Validate existence; abort on bad path.
    - Empty reply → exit cleanly with `(aborted — no pipelines picked)`.
    - Reject more than 3 picks: `(rejected — limit is 3 pipelines per cycle. Trim and re-submit.)` and re-prompt once.
22. Set `PICKED_PIPELINES` = the resolved list of absolute pipeline paths.

---

### Step 5: Per-Pipeline Review

23. Emit `[HEAVY]` to chat with one line: `spawning {N} pipeline-review-auditor subagents in parallel ({N} pipelines picked)`.
24. For each pipeline in `PICKED_PIPELINES`, compute:
    - `PIPELINE_TYPE` = `skill` if path matches `**/skills/*/SKILL.md`; else `command`.
    - `PIPELINE_SLUG` per type:
      - `command` (`**/.claude/commands/{name}.md`) → `{name}`.
      - `skill` (`**/skills/{name}/SKILL.md`) → `{name}`.
    - `MEMO_PATH` = `{MEMO_DIR}/{PIPELINE_SLUG}-{DATE}.md`.
25. Spawn one `pipeline-review-auditor` subagent per picked pipeline, in parallel (single message, multiple Agent tool calls). Pass each subagent:
    - `PIPELINE_PATH` — absolute
    - `PIPELINE_TYPE`
    - `PIPELINE_SLUG`
    - `REGISTRY_PATH` — absolute
    - `FRICTION_LOG_PATH`
    - `USAGE_LOG_PATH`
    - `MEMO_PATH`
    - `DATE`
    - `WORKSPACE`
26. Collect each subagent's ≤30-line summary. Parse the last line of each summary for the `MEMO: <absolute-path>` marker. Track per-pipeline: succeeded (marker present) vs. failed (marker absent or subagent errored).
27. For each subagent missing the marker, re-invoke that one subagent once with the same inputs. If the re-invocation still fails, record the pipeline as failed; do NOT bump its registry row.

---

### Step 6: Registry Bump (batched, after all subagents return)

28. Read `REGISTRY_PATH` fresh. For each succeeded pipeline:
    - Update its row: set `Last reviewed = {DATE}`, `Last memo = {DATE}`, `Friction flag = N`.
29. Write the updated registry back in one pass — not per-pipeline. Failed pipelines leave their rows untouched so the next cycle re-surfaces them.

This batched-write rule is a required mitigation from the `/risk-check` plan-time review of this command. Per-pipeline writes would leave the registry in a partial-update state if a subagent fails mid-batch.

---

### Step 7: Operator Brief

30. Display in chat:

    ```
    /pipeline-review complete — {DATE}

    Reviewed: {N picked, M succeeded, K failed}

    Memos:
      - {pipeline-name-1} → {MEMO_PATH-1}  [innovations: X | leanness: Y | brokenness: Z | cross: C]
      - {pipeline-name-2} → ...
      ...

    Failed (if any):
      - {pipeline-name} → re-surfaces in next cycle's shortlist

    Recommended next sessions:
      - {pipeline-name-1}: {auditor's "Recommended next session" line}
      - ...

    Registry: {REGISTRY_PATH}
    ```

31. Do NOT commit. Operator commits at session wrap. Per `ai-resources/CLAUDE.md` § Commit Rules: stage and commit when work is complete; do not run pre-commit checks.

---

### Notes

- **Audit-trail-grade writes.** Registry and memo writes leave a record that is not cleanly `git revert`-able. Manual undo requires editing the row back to its prior date — git history is the only complete record. This is intentional; the cadence's value depends on knowing when each pipeline was last given attention.
- **No subagent orchestration beyond the per-pipeline fan-out.** Each subagent runs end-to-end on its single pipeline; the main session only sequences spawning and registry-bump.
- **Failure handling.** If a subagent errors mid-run, its pipeline's registry row stays unchanged. The brief surfaces the failure; the next cycle re-surfaces the pipeline at the top of the shortlist.
- **System Owner pushback acknowledged in the plan.** This command was approved over the System Owner's recommendation to fold it into `/friday-checkup` as a new tier. The `[CADENCE-LATE]` marker is the mitigation. If skipped more than twice per quarter, revisit fold-into-checkup.
