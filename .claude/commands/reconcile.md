---
model: opus
argument-hint: "[path-to-output-being-reconciled]"
allowed-tools: Bash(git *), Read, Task, Skill(contract-check)
---

Judge whether a project output fulfilled the project's mandate — not whether it reads well. `/reconcile` compiles the project's mandate rubric, decomposes the output, audits which project resources should have shaped it, checks for generic (substitutable) advice, classifies the failure into a specific root cause, and recommends fixes at the output/workflow/repo level — each routed into a channel that can actually close it. It does **not** rewrite the output. Run it after an output feels underwhelming, generic, or strategically thin, and you want to know *why* before touching the prose again.

`/reconcile` requires two operator-authored reference files in the project it runs in: `context/mandate-rubric.md` (what "good output" means for this project) and `context/resource-activation-map.md` (which project resources should shape which task types). Without both, the command aborts with instructions rather than judging against a generic standard (Step 2). A project that has not authored them cannot yet run `/reconcile` — see `ai-resources/docs/reconcile-report-template.md` and the two doc shapes it references. `/reconcile-backlog` is a different, unrelated command (status-log triage, not output reconciliation) — do not confuse the two.

Input: `$ARGUMENTS` — required. Path to the output being reconciled, relative to the project root or absolute.

Examples:
- `/reconcile output/strategic-brief-v2.md`
- `/reconcile output/section-4-analysis-v2.md`

---

### Step 1 — Input validation

1. If `$ARGUMENTS` is empty, abort with:
   ```
   /reconcile requires the path to the output being reconciled.
   Example: /reconcile output/strategic-brief-v2.md
   ```
2. Resolve `TARGET_OUTPUT_PATH` — if `$ARGUMENTS` is not absolute, resolve relative to the project root (Step 2). If the resolved file does not exist, abort with the literal path tried and stop — do not guess a nearby file.

### Step 2 — Path setup

3. Set `DATE` = today, `YYYY-MM-DD`.
4. Set `PROJECT_ROOT` = `$CLAUDE_PROJECT_DIR` if that variable is set; otherwise `git rev-parse --show-toplevel`. (Projects in this workspace are typically their own git sub-repo, so the git root resolves to the project; `$CLAUDE_PROJECT_DIR` is the robust primary source when a project is not its own repo.)
5. Set `MANDATE_RUBRIC_PATH` = `{PROJECT_ROOT}/context/mandate-rubric.md`. Set `RESOURCE_MAP_PATH` = `{PROJECT_ROOT}/context/resource-activation-map.md`.
6. If either is missing, abort with:
   ```
   /reconcile needs a mandate rubric and a resource-activation map for this project before it can judge anything.

   Missing: {list whichever of context/mandate-rubric.md, context/resource-activation-map.md is absent}

   These are operator-authored reference docs — /reconcile reads them, it does not generate them. See ai-resources/docs/reconcile-report-template.md for what each must contain.
   ```
7. Set `AI_RESOURCES` = absolute path to the nearest `ai-resources/` directory (walk upward from `PROJECT_ROOT`, same idiom as `ai-resources/.claude/hooks/auto-sync-shared.sh`).
8. Set `REPORT_DIR` = `{PROJECT_ROOT}/logs/reconcile-reports/`. Create if missing (`mkdir -p`).
9. Compute `SLUG` from `TARGET_OUTPUT_PATH`'s basename (lowercase, non-alphanumeric runs → single `-`, strip leading/trailing `-`). Set `REPORT_PATH` = `{REPORT_DIR}/{DATE}-{SLUG}.md`. If it already exists from an earlier invocation today, append `-2`, `-3`, etc.

### Step 3 — Opportunistic mandate cross-check via `/contract-check`

10. Invoke `/contract-check {MANDATE_RUBRIC_PATH}` via the Skill tool. `/contract-check` uses `mandate-rubric.md` as the contract but auto-detects its own artifact from today's git activity (`contract-check.md` § Step 3 — it has no argument grammar for targeting an arbitrary historical file). Its Step 5 output always echoes `Artifact: '{path}' (auto-detected from uncommitted/today's changes).` — parse that path. Two outcomes:
    - **The parsed path matches `TARGET_OUTPUT_PATH`** (the common case — reconciling something just produced this session): capture its verdict (CONTRACT-ALIGNED / MINOR-DRIFT / MAJOR-DRIFT) as `CONTRACT_CHECK_RESULT`.
    - **The parsed path differs, or `/contract-check` aborted (no today's changes) or errored:** set `CONTRACT_CHECK_RESULT` = `"unavailable — {reason}"`. This is expected and not a failure of `/reconcile` — proceed without it. `reconcile-reviewer`'s own mandate-compliance scoring (Step 4 below) does not depend on this cross-check; it is corroborating evidence only, never a hard dependency.

### Step 4 — Spawn `reconcile-reviewer` subagent

11. Verify the `reconcile-reviewer` agent is available (`{PROJECT_ROOT}/.claude/agents/reconcile-reviewer.md`, whether a real file or a symlink to the canonical `ai-resources` copy). Abort if missing.
12. Spawn one `reconcile-reviewer` subagent with these inputs:
    - `TARGET_OUTPUT_PATH`
    - `MANDATE_RUBRIC_PATH`
    - `RESOURCE_MAP_PATH`
    - `FORENSIC_SOURCES` — `{PROJECT_ROOT}/logs/session-notes.md`, `{PROJECT_ROOT}/logs/decisions.md`, plus instruction to check `git log` for `TARGET_OUTPUT_PATH`'s production window
    - `CONTRACT_CHECK_RESULT` — from Step 3
    - `REPORT_PATH`
    - `DATE`
13. Subagent returns a ≤30-line summary ending with `REPORT: {absolute path}` as its last line.
14. If the returned summary lacks the `REPORT:` last-line marker, re-invoke once with the same inputs. If the re-invocation also lacks it, abort with an error naming the malformed summary — do not proceed to Step 5.

### Step 5 — Structural validation

15. Read `REPORT_PATH` back and confirm: the line immediately under `## 1. Verdict` is exactly one of the seven full verdict labels — `Conditional Pass`, `Workflow Fault`, `Mandate Fault`, `Rerun Required`, `Fail`, `Misfire`, or `Pass` (match the multi-word labels first; `Pass` is a substring of `Conditional Pass` and must not double-count) — per `ai-resources/docs/reconcile-verdict-definitions.md`. Also confirm `## 7. Recommended Fixes` names a closure channel for every fix listed (no fix with an unnamed routing target).
16. On validation failure, re-invoke the subagent once with the specific violation named. If it still fails, abort — do not present a malformed report.

### Step 6 — Present summary to operator

17. Display in chat:
    - `Reconciliation — {DATE}`
    - `Target: {TARGET_OUTPUT_PATH}`
    - `Verdict: {verdict}` — `{one-line reason from the report}`
    - `Mandate compliance: {N dimensions — X Weak, Y Partial, Z Moderate/Strong}`
    - `Resource activation: {N checked, M with no evidence of use, K marked N/A}`
    - `Genericness: {Weak (generic) | Moderate (mixed) | Strong (not generic)}` — always relay the parenthetical; "Strong" alone reads backwards to a cold reader.
    - `Primary root cause: {from the summary}`
    - `Top fix: {from the summary, with its closure channel}`
    - `Disposition: {Accept as-is | Revise in place | Rerun under a corrected workflow | Escalate}`
    - `Full report: {REPORT_PATH}`
18. Append guidance by disposition:
    - `Accept as-is` → "No action needed — the output meets the bar."
    - `Revise in place` → "Route the output-level fix through /resolve."
    - `Rerun under a corrected workflow` → "The gap is upstream of this artifact — apply the workflow/repo-level fix before regenerating."
    - `Escalate` → "The mandate itself can't judge this — resolve the rubric gap with the operator before re-running /reconcile."

### Step 7 — No commit, no execution

19. `/reconcile` is a diagnostic gate. It does not rewrite the target output, does not apply any recommended fix, and does not commit the report. The operator (or a follow-up `/resolve` / `/resolve-repo-problem` / `improvement-log.md` entry, per the fix's named channel) decides the next action.
