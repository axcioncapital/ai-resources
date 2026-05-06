---
description: System Owner Monthly Review — macro view of the Axcíon Claude Code system through a systems-thinking lens. Reads patterns across the past month's advisories and produces a strategic monthly review. Run during monthly-tier /friday-checkup sessions, after /friday-so.
model: opus
---

Produce a Monthly System Review using the System Owner agent.

## Step 1 — Locate and validate checkup report

Set `DATE` = today's date (`YYYY-MM-DD`).

Glob `ai-resources/audits/friday-checkup-*.md`. Sort descending by filename, take the newest. If none found, abort: "No /friday-checkup report found under ai-resources/audits/. Run /friday-checkup first."

Read the report. Extract the tier from the `**Tier:**` line. If tier is `weekly`, abort: "Monthly System Review requires a monthly or quarterly tier checkup. Today's checkup was weekly — run /so-monthly on a monthly or quarterly Friday."

## Step 2 — Locate recent Friday advisories

Glob `projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-*.md`. Sort descending by filename date. Take the 4 most recent. Read all of them. Note the count found (may be fewer than 4 early in the project's life).

## Step 3 — Extract deferred items from maintenance observations

Read `ai-resources/logs/maintenance-observations.md`.

Scan for session-block headers matching the pattern `## YYYY-MM-DD — Friday Act (...)`. Sort descending by date. Take the 4 most recent blocks. From each block, extract the `### Deferred items` subsection. Compile the deferred items across all 4 blocks, labelled by session date.

## Step 4 — Set output path

```
OUTPUT_PATH = projects/axcion-ai-system-owner/output/monthly-reviews/so-monthly-{DATE}.md
```

## Step 5 — Delegate to system-owner agent

Pass the following brief to the `system-owner` agent:

```
function: monthly-review

Month under review: {YYYY-MM}

Checkup report (tier: {TIER}):
---
{full contents of checkup report}
---

Recent Friday Advisories ({N} found, newest first):
---
{contents of each advisory, separated by "---"}
---

Deferred items from last 4 Friday Act sessions:
---
{extracted deferred items per session block, labelled by date}
---

Output path: {OUTPUT_PATH}
```

The agent reads its references and vault docs per grounding.md Function F read map, then writes the Monthly System Review to OUTPUT_PATH.

## Step 6 — Echo to chat

After the agent completes:
1. Print the output file path.
2. Read the written file and echo the full `## System Health Summary` section to chat.
