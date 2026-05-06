---
description: Architecture review — synthesizes a prioritized architecture-health report from the most recent audit outputs (audit-repo, token-audit, optional analyze-workflow + repo-dd) in the Axcíon AI System Owner voice. Output written to projects/axcion-ai-system-owner/output/architecture-reviews/.
model: opus
---

Synthesize a prioritized architecture-health report from the most recent on-disk audit outputs. Delegates to the `system-owner` agent (Opus); the agent reads the audit outputs the command loads from disk plus the vault architectural reference base, and produces a structured report grouped by severity (Blocking / Important / Note) with named locations and recommended actions per finding.

Input: `$ARGUMENTS` — optional. If non-empty, treat as a list of workflow names to include `/analyze-workflow` outputs for. Example: `/architecture-review research-workflow`.

---

### Step 1 — Setup

1. Set `DATE` = today in `YYYY-MM-DD`.
2. Set `WORKSPACE_ROOT` = absolute path to the workspace root (the directory containing `ai-resources/`, `projects/`, etc.).
3. Set `AUDITS_DIR` = `{WORKSPACE_ROOT}/ai-resources/audits/`.
4. Set `OUTPUT_DIR` = `{WORKSPACE_ROOT}/projects/axcion-ai-system-owner/output/architecture-reviews/`.
5. Verify `AUDITS_DIR` exists. If not, abort with: "ai-resources/audits/ does not exist — no audit outputs to read. Run /audit-repo and /token-audit first."

---

### Step 2 — Locate latest audit outputs

For each of the four audit types, glob `AUDITS_DIR` for the most recent matching file:

| Audit | Glob pattern | Variable |
|---|---|---|
| `/audit-repo` | `repo-health-*.md` | `AUDIT_REPO_FILE` |
| `/token-audit` | `token-audit-*.md` | `TOKEN_AUDIT_FILE` |
| `/repo-dd` | `repo-dd-*.md` or `repo-due-diligence-*.md` | `REPO_DD_FILE` |
| `/analyze-workflow` (per workflow named in `$ARGUMENTS`) | `workflow-analysis-{name}-*.md` (per name) | `WORKFLOW_FILES[]` |

For each variable:
- If a matching file exists, set the variable to the path of the most recent file (by mtime or by date suffix in filename, whichever is the established workspace convention).
- If no matching file exists, set the variable to `MISSING`.
- If a matching file exists but its mtime is older than 7 days, set the variable to `STALE` and remember the actual path for the degraded-mode header.

`/analyze-workflow` is selective: only run the lookup if `$ARGUMENTS` named workflows. If `$ARGUMENTS` is empty, set `WORKFLOW_FILES[] = []`.

---

### Step 3 — Read the audit outputs that exist

For each variable in Step 2 that is NOT `MISSING`:
- Read the file via the `Read` tool.
- Capture its content for inclusion in the agent brief.
- Capture its timestamp (mtime or filename date) for the report header.

For each variable that is `MISSING` or `STALE`:
- Add an entry to `DEGRADED_MODE_NOTES`: e.g., "audit-repo: MISSING (no repo-health-report-*.md found in ai-resources/audits/)" or "token-audit: STALE — file dated 2026-04-15, more than 7 days old".

---

### Step 4 — Delegate to the `system-owner` agent for synthesis

Spawn the `system-owner` subagent via the `Task` tool with this brief (verbatim structure):

```
You are the Axcíon AI System Owner. Apply Function C (architecture review) per references/grounding.md.

Synthesis date: {DATE}

Audit outputs available:
{For each non-MISSING variable, include:}
- {audit-name}: {file path} (timestamp {timestamp})
  Content:
  ```
  {full file content}
  ```

Degraded-mode notes (audits not synthesized):
{For each MISSING/STALE entry in DEGRADED_MODE_NOTES, include the entry verbatim.}

Apply the procedure in your agent definition. Read the three references + systems-building-principles.md, apply the per-function read map for Function C (principles + system-doc + risk-topology by default; conditional reads per topic), and produce a structured report in System Owner voice.

Output structure (write to projects/axcion-ai-system-owner/output/architecture-reviews/architecture-review-{DATE}.md):
- Header: synthesis date, audit-output sources cited with timestamps, degraded-mode markers
- Executive Summary: 3–5 lines, highest-leverage findings
- Findings by Severity:
  - Blocking
  - Important
  - Note
  Each section either names specific findings (each with location + cited principle + recommended action) or explicitly states "No findings in this tier."
- Recommended Actions: operator-actionable list, ordered by severity.

After writing, return the Executive Summary section verbatim to the calling command (do not echo the full report — the file path is sufficient).
```

Wait for the agent's response.

---

### Step 5 — Output to operator

Echo the agent's response (Executive Summary) to the chat, prefaced by:

```
Architecture review for {DATE} written to:
{OUTPUT_DIR}/architecture-review-{DATE}.md

Executive Summary:
{agent's Executive Summary verbatim}
```

If `DEGRADED_MODE_NOTES` is non-empty, append a one-line warning:

```
[PARTIAL — degraded mode applied: {comma-separated MISSING/STALE audit names}]
```

---

### Notes for the executor

- Per locked Decision 4, this command writes its synthesized report to disk at `projects/axcion-ai-system-owner/output/architecture-reviews/`. Decision 6 in the architecture confirmed disk-write + chat-echo is the canonical v1 shape (not chat-only).
- Per Architecture Decision 4, this command does NOT invoke `/audit-repo`, `/token-audit`, `/analyze-workflow`, or `/repo-dd` as slash commands. It reads the most recent on-disk output from each. The operator runs the audits separately on whatever cadence they prefer.
- The 7-day staleness threshold is a v1 default. If smoke tests show 7 days is too tight or too loose, adjust here in v1.1.
- The output filename includes the date so multiple reviews can coexist. If the operator runs `/architecture-review` twice on the same day, the second run overwrites the first — operator decides whether that is desired or whether to add a counter suffix.
