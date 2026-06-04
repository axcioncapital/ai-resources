---
description: Weekly System-Owner-grounded design review of 1+ critical command pipelines (innovations, leanness, brokenness, currency-check) + a workspace systems-review every cycle — operator-invoked; no auto-fix, no commit
model: sonnet
disable-model-invocation: true
argument-hint: "[pipeline-path]"
---

# /pipeline-review — Weekly Pipeline Design Review

Run a deep System-Owner-grounded design review of 1 or more critical command pipelines per cycle. Operator-invoked weekly. Reads a registry, presents a ranked shortlist, the operator picks 1 or more, the `pipeline-review-auditor` subagent produces a memo per pipeline, the registry is bumped, and the memos are written to disk. No auto-fix. No commit.

Every cycle that reviews ≥1 pipeline also produces a workspace-scope **systems-review** (Step 5B) — a macro systems-dynamics diagnosis delegated to the Opus `system-owner` agent (Function E), the same engine `/systems-review` uses. This pairs the per-pipeline *micro* review with a workspace-level *macro* view in one cycle. Bundled per operator decision 2026-06-05.

No hard upper limit on per-cycle picks — the `[HEAVY]` chat marker at Step 5 announces the spawn count, and an extra advisory line fires above 3 to make the cost visible. The original 3-pick cap was relaxed on 2026-05-29 after the registry grew from 17 to 47 entries; operator throughput on the "Recommended next session" outputs is the real constraint, not the auditor cost.

Subsumed `/audit-critical-resources` on 2026-05-29 — its drift-detection currency-check (against pinned Anthropic doc URLs) was folded into the pipeline-review-auditor's Brokenness section. This command now answers both *what could be better?* and *what is broken?* for the critical-resource population.

Input: `$ARGUMENTS` (optional) — a pipeline path. If provided, skip the shortlist step and review that pipeline directly. Empty input runs the shortlist flow.

---

## Registry contract (do not silently drift)

Contract lives at `ai-resources/audits/pipeline-review-registry.md § Registry contract` — do not paraphrase here. Drift-guard: registry and memo writes are audit-trail-grade (not cleanly `git revert`-able; the bumped row preserves history only via git log). Per the `/risk-check` plan-time review of this command (Dimension 5: Hidden coupling, Medium): this pointer exists so the contract does not silently drift on later runs.

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

The `>10` threshold matches `/friday-checkup` Step 0 — one missed weekly cycle plus slack. Documented here so future tightening to 7 has to be a deliberate decision, not a drive-by edit. The `[CADENCE-LATE]` marker is itself the `/risk-check` Dimension-5 mitigation for this step.

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

17a. Parse `REGISTRY_PATH` into a list of rows. For each row, extract: `pipeline_path`, `type`, `tier`, `last_reviewed`, `friction_flag`.
17b. **Tier-eligibility filter.** Compute `QUARTERLY_ACTIVE` = true if today is the first Friday of January, April, July, or October; else false. Python: `from datetime import date; t = date.today(); is_first_friday = (t.weekday() == 4 and t.day <= 7); QUARTERLY_ACTIVE = is_first_friday and t.month in (1, 4, 7, 10)`. If `QUARTERLY_ACTIVE` is true, the eligible pool includes rows where `tier in ('weekly', 'quarterly')`. Otherwise the eligible pool is rows where `tier == 'weekly'` only. Quarterly rows on non-trigger dates are dropped from the shortlist (operator can still pick a quarterly pipeline by path via Step 3 override). On a quarterly-active date, emit one line to the operator: `[QUARTERLY-CYCLE] Quarterly tier is eligible this cycle (first Friday of {Jan|Apr|Jul|Oct}).`
17c. **Registry-drift check.** For each row in the eligible pool, resolve `pipeline_path` against `AI_RESOURCES` (relative paths) and `test -f` the result. If the file is missing, emit one line to the operator: `[REGISTRY-DRIFT] {pipeline_path} (row dropped — file does not resolve; rename, move, or stale registry entry)`. Drop the row from the working set. Do NOT abort the cycle. After all rows are checked, if any rows were dropped, also print: `Resolve drift before next cycle — edit {REGISTRY_PATH} to update or remove the stale entries.` Catches pipeline rename and tier-promotion failure modes — without this, the auditor would hard-fail at its first read and the next cycle would re-surface the same broken row.
18. Sort surviving rows by these keys in order:
    a. `friction_flag = Y` first (Y before N).
    b. `last_reviewed` ascending — `never` sorts as the oldest (treat as date `0000-00-00` for comparison).
    c. `pipeline_path` alphabetically — the cold-start tiebreak.
19. Take the top 10 rows as the shortlist. (Operator can still reach rows 11+ via path override in Step 21.)
20. Print the shortlist to the operator:

    ```
    /pipeline-review — {DATE}

    Shortlist (top 10, oldest first; friction-flagged promoted):

      1. {pipeline_path}  [{type}/{tier}]  last-reviewed: {last_reviewed}  friction: {Y|N}
      2. ...
      ...
      10. ...

    {If every row is `never`, append:}
    Cold start — all rows are `never`. Tiebreak applied: alphabetical by pipeline path.

    Pick 1 or more by number (e.g., `1` or `1,3,5,7`), OR type a pipeline path not in the shortlist to override.
    No upper limit on count — `[HEAVY]` fires at spawn time; above 3 picks an extra advisory line names the parallel-token cost.
    Empty reply aborts.
    ```

21. Wait for operator reply. Parse:
    - Comma-separated numbers in `1..10` → pick those rows from the shortlist.
    - A path-shaped token → resolve as in Step 3 (override allowed; bypasses tier filter — operator can pick a quarterly row on a non-trigger date). Validate existence; abort on bad path.
    - Empty reply → exit cleanly with `(aborted — no pipelines picked)`.
    - No upper cap on pick count. Cost is surfaced at Step 23, not gated here.
22. Set `PICKED_PIPELINES` = the resolved list of absolute pipeline paths.

---

### Step 5: Per-Pipeline Review

23. Emit `[HEAVY]` to chat with one line: `spawning {N} pipeline-review-auditor subagents + 1 system-owner (Opus, Function E ~30k) for the bundled workspace systems-review, in parallel ({N} pipelines picked)`. If `N > 3`, emit one additional advisory line: `[HEAVY-WIDE] N={N} exceeds the original 3-pick design baseline — each subagent runs ~85–110k opus tokens; total fan-out ≈ {N × 100}k tokens (plus the ~30k system-owner systems-review). No gate — proceeding.`
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

### Step 5B: Workspace Systems Review (bundled, every cycle)

This step runs whenever `PICKED_PIPELINES` is non-empty — i.e., every cycle that actually reviews ≥1 pipeline, including the `$ARGUMENTS` single-pipeline override. If the cycle aborted earlier (Step 2 defer, Step 4 empty reply), this step never runs. It produces one workspace-scope systems-review via the same `system-owner` Function E engine `/systems-review` uses, independent of the per-pipeline auditors.

27a. Set `SYS_SCOPE = "Full AI infrastructure"` and `SYS_SCOPE_SLUG = "full-ai-infrastructure"`.

27b. Set `SYS_REF = {WORKSPACE}/projects/axcion-ai-system-owner/vault/research/systems-thinking-for-claude-code.md`. Verify it exists (`test -f`). **If missing, do NOT abort the cycle** — emit one advisory line and skip to Step 6:

    ```
    [SYSTEMS-REVIEW-SKIPPED] systems-thinking reference not found at {SYS_REF} — bundled systems-review skipped this cycle (pipeline memos unaffected). Restore the vault reference to re-enable.
    ```

    (Standalone `/systems-review` halts on this condition; the bundled step graceful-degrades instead, so a missing vault never blocks the pipeline-review cycle.)

27c. Set `SYS_OUTPUT = {WORKSPACE}/projects/axcion-ai-system-owner/output/systems-reviews/systems-review-{DATE}-{SYS_SCOPE_SLUG}.md`. Ensure its parent exists: `mkdir -p "{WORKSPACE}/projects/axcion-ai-system-owner/output/systems-reviews"`.

27d. Spawn the `system-owner` subagent via the `Task` tool with this verbatim Function E brief (identical to `/systems-review` Step 3 except for the injected `SYS_SCOPE` / `SYS_OUTPUT` / `SYS_REF` values):

    ---

    **Function E — Systems review**

    **Scope:** {SYS_SCOPE}

    **Output path:** {SYS_OUTPUT}

    **Systems-thinking reference:** `{SYS_REF}`

    Apply your standard Phase 1–5 procedure. This is a Function E invocation. Follow the Function E read map in `references/grounding.md` § 2 and the Function E output shape in your Phase 5 instructions. Write the full report to the output path using your `Write` tool, then echo the "Binding Constraint" and "Leverage Point Assessment" sections to chat.

    ---

    **Parallelism:** this `system-owner` Task call is independent of the per-pipeline tracking in Step 5. For wall-clock efficiency it MAY be issued in the same message as the Step 5 auditor spawns (single message, multiple tool calls) rather than strictly after them — the numbering here is logical, not a sequencing requirement. Track its result separately as: succeeded (report written + sections echoed), skipped (Step 27b), or failed.

27e. If the `system-owner` agent errors or returns no echoed sections, re-invoke it once with the same brief. If it still fails, record the systems-review as **failed** and continue — do NOT block the registry bump (Step 6) or the operator brief (Step 7). The systems-review runs fresh every cycle, so a failed run simply re-runs next cycle; nothing is registry-tracked for it.

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

    Systems review (workspace, every cycle):
      {On success:}
      → {SYS_OUTPUT}

      Binding Constraint:
      {echoed "Binding Constraint" section from the system-owner agent}

      Leverage Point Assessment:
      {echoed "Leverage Point Assessment" section from the system-owner agent}

      {On skip (Step 27b):}  Skipped — systems-thinking reference missing (see [SYSTEMS-REVIEW-SKIPPED] above). Restore the vault reference to re-enable.
      {On fail (Step 27e):}  Failed after one retry — runs fresh next cycle (nothing registry-tracked).

    Registry: {REGISTRY_PATH}
    ```

31. Do NOT commit. Operator commits at session wrap. Per `ai-resources/CLAUDE.md` § Commit Rules: stage and commit when work is complete; do not run pre-commit checks.

---

### Notes

- **System Owner pushback acknowledged in the plan.** This command was approved over the System Owner's recommendation to fold it into `/friday-checkup` as a new tier. The `[CADENCE-LATE]` marker is the mitigation. Advisory trigger (operator-discretionary; no enforcement path): if `[CADENCE-LATE]` fires more than twice per quarter, revisit the fold-into-checkup decision.
- **Bundled systems-review (Step 5B), every cycle — operator decision 2026-06-05.** Each cycle that reviews ≥1 pipeline also runs one workspace-scope `system-owner` Function E systems-review (the same engine as `/systems-review`). Cost accepted: one Opus Function E (~30k grounding tokens before output) per cycle, on top of the per-pipeline auditors. Graceful-skip on a missing vault reference (`[SYSTEMS-REVIEW-SKIPPED]`) — the pipeline-review cycle never aborts on it. Note: `[CADENCE-LATE]` recovery runs trigger the systems-review each time too; this is accepted under the "every cycle" decision. Standalone `/systems-review` is unchanged and still independently invocable at any scope; the registry row for `systems-review.md` (a *design-review target*) is unrelated to this *runtime* bundling.
