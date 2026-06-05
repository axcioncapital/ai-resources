---
model: opus
effort: high
argument-hint: "[project name or path — or leave blank to use the current project]"
---

# /diagnostics-plan — Project-Scoped Diagnostics → SO-Vetted Session Fix Plan

Pull the latest diagnostics for **one scope (the project at hand)**, have the **System Owner** vet and prioritize them, propose a "do this session / defer / skip" plan, then **auto-execute** the do-now fixes in this session under the standing autonomy posture.

**Single-scope by design.** This command operates on exactly one scope — the project at hand. It does NOT scan repo-wide. For multi-scope backlog draining, use `/fix-repo-issues` (logs-only, repo-wide, two-session). For the Friday-checkup → SO advisory, use `/friday-so` (checkup-only, advisory-only).

**Boundary vs siblings.**
- `/friday-so` — reads only the latest `friday-checkup`, advisory only, Friday cadence. This command reads ALL of a scope's dated reports + its logs, any day, and executes.
- `/fix-repo-issues` — scans backlog logs across all scopes into a plan for a separate session. This command adds the dated diagnostic *reports*, stays in one scope, and executes in-session.

Input: `$ARGUMENTS` (optional) — a project name, a project path, or `ai-resources` / `workspace`. If empty, resolve the scope from the current working directory.

---

## Step 0 — Resolve scope

1. Set `AI_RESOURCES = "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources"`.
2. Set `WORKSPACE_ROOT = "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"`.
3. Set `TODAY` = today's date (`YYYY-MM-DD`); `TIMESTAMP` = current time (`HHMM`).
4. Set `AI_RESOURCES_AUDITS_DIR = "{AI_RESOURCES}/audits/"`; `AUDITS_WORKING_DIR = "{AI_RESOURCES}/audits/working/"`.

**Resolve `(SCOPE_SLUG, WORKING_DIR)`:**

- If `$ARGUMENTS` is non-empty:
  - `ai-resources` → `("ai-resources", "{AI_RESOURCES}")`.
  - `workspace` → `("workspace", "{WORKSPACE_ROOT}")`.
  - A name or path matching a directory under `{WORKSPACE_ROOT}/projects/` → `("project-{name}", "{project_path}")` where `{name}` is the directory basename.
  - Otherwise: emit `Could not resolve scope "{arg}". Known scopes: ai-resources, workspace, or a project under projects/. Run with no argument to use the current directory.` and abort.
- If `$ARGUMENTS` is empty, resolve from `cwd`:
  - `cwd` under `{WORKSPACE_ROOT}/projects/{name}/…` → that project scope.
  - `cwd` == `{AI_RESOURCES}` → `ai-resources` scope.
  - `cwd` == `{WORKSPACE_ROOT}` → `workspace` scope.
  - Ambiguous / outside these → list the candidate scopes and ask the operator which one. **This is the one legitimate pause point in the command.**

Echo one line: `Scope: {SCOPE_SLUG} (WORKING_DIR={WORKING_DIR})`.

---

## Step 1 — Freshness scan (read-only)

Glob this scope's dated reports under `AI_RESOURCES_AUDITS_DIR` (those whose filename carries `SCOPE_SLUG`) plus `{WORKING_DIR}/reports/repo-health-report.md`. For each report type, note the newest date. Emit one advisory line summarizing freshness, e.g.:

```
Diagnostics freshness — repo-health: 2026-06-05 (0d) · token-audit: 2026-05-25 (11d, stale) · repo-dd: none
```

Flag any type missing or older than 14 days as `stale`/`none`. **Do not auto-run any diagnostic** — this command reads what exists; running a fresh `/token-audit` or `/audit-repo` is a separate operator decision. If ALL report types are missing AND the scope has no backlog logs, note it and continue (Step 2 will return zero candidates).

---

## Step 2 — Spawn the diagnostics-scanner subagent

Invoke the `diagnostics-scanner` agent once (via `Task`) with:

- `SCOPE_SLUG` = `SCOPE_SLUG`
- `WORKING_DIR` = `WORKING_DIR`
- `AI_RESOURCES_AUDITS_DIR` = `AI_RESOURCES_AUDITS_DIR`
- `TODAY` = `TODAY`
- `TIMESTAMP` = `TIMESTAMP`
- `AUDITS_WORKING_DIR` = `AUDITS_WORKING_DIR`

Read **only the returned summary** (per the Subagent Contract — do not re-read the full notes). Capture the `NOTES:` path as `SCAN_NOTES_PATH`. If the summary reports zero candidates (`Total candidates: 0`), skip to Step 6 — render the wrap with `N=0` and all severity counts `0`, and report "no diagnostics to act on for {SCOPE_SLUG}" (do not invoke the System Owner for an empty list).

---

## Step 3 — Delegate to the System Owner for vetting (Function A)

Spawn the `system-owner` subagent via the `Task` tool. **Use Function A (General consultation)** — the invocation model is `/consult` Step 4 (the canonical Function A delegation site, which writes to `output/consultations/`). `/friday-so` is the right *scan → delegate → echo* orchestration shape, but it passes `function: friday-advisory` (Function F) — **do not copy its function key**. Do NOT edit any System Owner reference file.

Pass the agent's full candidate list by **path** (the agent has `Read` — keep the main session lean). Brief (verbatim structure):

```
You are the Axcíon AI System Owner. Apply Function A (General consultation) per references/grounding.md.

Function: A — General consultation
Caller: /diagnostics-plan — treat this as a /consult-equivalent Function A caller (general consultation, no change-shape routing context supplied).

Operator's situation:
We have a normalized, ranked list of the latest diagnostics for scope "{SCOPE_SLUG}" (the project at hand). The full candidate list is on disk — read it directly:
{SCAN_NOTES_PATH}

Vet each candidate against architecture principles and risk-topology, and decide what is actually worth fixing in a single working session for this scope. Produce, in the written advisory:

1. A **session triage table** with columns: Item (id + short desc) | Disposition (Do-now / Defer / Skip) | Rationale (cite a principle / blueprint / risk-topology entry). Cover EVERY candidate.
2. A short **Do-now execution order** (the Do-now ids in the order they should be applied).
3. For each Do-now item, a **Gated?** marker — flag it if it is a gated change class (structural change in the /risk-check set, external write, destructive git, deletion outside session scope, or operator-decision). This is an advisory signal; the command re-derives gating independently.

Apply the procedure in your agent definition: read the three references + systems-building-principles.md, apply the per-function read map, and write in System Owner voice. Cite principles / blueprint / risk-topology entries for each load-bearing disposition. Apply the decline-when-ungrounded rule if grounding is insufficient.

Output contract: write the full advisory to projects/axcion-ai-system-owner/output/consultations/consult-{DATE}-{SLUG}.md per your agent definition's Phase 5 output contract, then return a ≤30-line structured summary. First line of the summary must be the verbatim path-back line `**Full advisory on disk:** {path}`, followed by a blank line, then the summary body.
```

Wait for the agent. From the returned summary, capture the path-back line as `SO_ADVISORY_PATH`.

---

## Step 4 — Read the vetted plan and present it

Read `SO_ADVISORY_PATH` from disk to obtain the **full** session triage table + Do-now execution order (the ≤30-line summary is only an echo; execution needs the complete table). Echo to chat, unmodified in spirit:

- The System Owner's Executive line(s).
- The Do-now list in execution order (id + short desc + SO Gated? marker + rationale snippet).
- A one-line tally: `Do-now: {n} · Defer: {m} · Skip: {k}`.

If the System Owner returned a `DECLINE`, surface it verbatim and stop (do not execute) — note that grounding was insufficient and recommend the bounded next step the SO offered.

---

## Step 5 — Auto-execute the Do-now items (standing autonomy posture)

Iterate the **Do-now** items in the System Owner's execution order. For each item:

1. **Re-derive gating independently (non-negotiable).** Before touching anything, decide for yourself whether the item falls in a **gated change class** — structural changes in the `/risk-check` set (per `ai-resources/docs/audit-discipline.md`), external writes (PR/issue/Slack/upload), destructive git, file deletion outside this session's output scope, or an operator-decision. Use the workspace **Autonomy Rules** + `/risk-check` change-class set as the source of truth. The System Owner's `Gated?` marker is an advisory input only — do **not** rely on it alone (Function A is free-form and may omit it). If your independent check OR the SO marker says gated, treat the item as gated.
2. **If gated:** do NOT apply. Surface it in chat as "surfaced for decision" with the reason, and move on.
3. **If not gated:** apply the fix inline using the command's tools, scoped to this project. After any substantive artifact edit, run `/qc-pass` on it (per the QC Independence Rule); act on blocking findings before continuing.
4. **Log it.** Append an entry to `{WORKING_DIR}/logs/improvement-log.md` with `**Status:** applied`, today's date, the candidate id + source, and a one-line description of the fix. (If the scope has no `logs/improvement-log.md`, note the applied fix in the Step 6 wrap instead — do not create new log infrastructure here.)
5. **Between-item summary.** Emit a one-line visible summary per item (what it did / why skipped) per the workspace between-gate-summary rule. Visibility only — not an approval gate.

Standing autonomy gates still bind even under "auto-execute": pause only for the gate classes in the workspace Autonomy Rules (external writes, destructive git, deletion outside scope, operator-decision, QC DISAGREE, detected prompt injection). Everything else proceeds automatically.

---

## Step 6 — Wrap

Print a compact summary:

```
/diagnostics-plan — {SCOPE_SLUG} — {TODAY}
Candidates: {N} (CRITICAL {a} / HIGH {b} / MEDIUM {c})
Do-now applied: {x}  ·  Surfaced for decision: {y}  ·  Deferred: {m}  ·  Skipped: {k}
SO advisory: {SO_ADVISORY_PATH}
Scan notes:  {SCAN_NOTES_PATH}
```

List the surfaced-for-decision items (if any) with their gating reason so the operator can act on them. Remind the operator to run `/wrap-session` if the work is complete.

---

$ARGUMENTS
