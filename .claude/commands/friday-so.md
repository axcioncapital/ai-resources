---
description: System Owner Friday Advisory — reads the latest /friday-checkup report through a systems-thinking lens and produces a prioritized tactical advisory. Run between /friday-checkup and /friday-act.
model: opus
---

Produce a Friday Advisory using the System Owner agent.

## Step 1 — Locate checkup report

Set `DATE` = today's date (`YYYY-MM-DD`).

Glob `ai-resources/audits/friday-checkup-*.md`. Sort descending by filename, take the newest. If none found, abort: "No /friday-checkup report found under ai-resources/audits/. Run /friday-checkup first."

## Step 2 — Validate freshness

Parse the date from the report filename (`friday-checkup-YYYY-MM-DD.md`). If the report is >7 days old relative to today, emit a single-line warning: "⚠ Checkup report is {N} days old — advisory may not reflect current state." Continue; do not abort.

## Step 3 — Read the checkup report

Read the full contents of the report. Extract the tier from the `**Tier:**` line (weekly / monthly / quarterly).

## Step 4 — Locate architecture review (supplementary)

Glob `projects/axcion-ai-system-owner/output/architecture-reviews/architecture-review-*.md`. Take the newest file. If it exists and its filename date is within 7 days of today, mark as AVAILABLE and read it. Otherwise mark as MISSING.

## Step 5 — Set output path

```
OUTPUT_PATH = projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-{DATE}.md
```

## Step 6 — Delegate to system-owner agent

Pass the following brief to the `system-owner` agent:

```
function: friday-advisory

Checkup report (tier: {TIER}):
---
{full contents of checkup report}
---

Architecture review (supplementary):
---
{AVAILABLE: full contents | MISSING: "No architecture review found within 7 days."}
---

Output path: {OUTPUT_PATH}
```

The agent reads its references and vault docs per grounding.md Function F read map, then writes the Friday Advisory to OUTPUT_PATH.

## Step 7 — Echo to chat

After the agent completes:
1. Print the output file path.
2. Read the written file and echo the full `## Executive Summary` section to chat.
