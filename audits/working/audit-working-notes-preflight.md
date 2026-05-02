# Pre-Flight Working Notes — 2026-05-02

## 0.1 — Baseline session metrics

`/cost` and `/context`: not invokable from within agent execution context (interactive slash commands only, no programmatic equivalent in tool surface). Recorded as "not available in this execution environment."

## 0.2 — Session telemetry

- `session-usage-analyzer` skill found at: `ai-resources/skills/session-usage-analyzer/SKILL.md`
- Historical data: `ai-resources/logs/usage-log.md` (376 lines, entries through 2026-05-01)
- Other telemetry locations (out-of-scope but noted): per-project `usage-log.md` under `projects/buy-side-service-plan/`, `projects/project-planning/`, `projects/obsidian-pe-kb/`, `projects/repo-documentation/`.

In-scope log file count: 1. Triggers Section 5 inline execution.

## 0.3 — Read(pattern) deny-rule check

**Settings files in scope:**
1. `ai-resources/.claude/settings.json`
2. `ai-resources/.claude/settings.local.json` (no permissions block — only sets model)
3. `ai-resources/workflows/research-workflow/.claude/settings.json` (deploy-time template, applies to deployed projects)

**Read(...) deny rules in `ai-resources/.claude/settings.json`:**
- `Read(archive/**)`
- `Read(logs/*-archive-*.md)`
- `Read(inbox/archive/**)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

**Read(...) deny rules in `workflows/research-workflow/.claude/settings.json` (template):**
- `Read(archive/**)`, `Read(**/*.archive.*)`, `Read(logs/*-archive-*.md)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.

**Expected-coverage list:** `audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/`, `drafts/`, deprecated/old.

**Currently covered:** `archive/`, `**/deprecated/**`, `**/old/**`, `inbox/archive/**`, `logs/*-archive-*.md`.

**Missing expected coverage (with intent qualifier):**
- `audits/` — INTENTIONAL CARVE-OUT (2026-05-01 decisions log: "Read(audits/**) deferred — would break /friday-act, /risk-check, /token-audit; right fix is Read(audits/working/**) only").
- `reports/` — INTENTIONAL CARVE-OUT (same reason).
- `output/` — no carve-out documented; not present in ai-resources scope (project-level only).
- `drafts/` — no carve-out documented; not present.
- `logs/` — only archive variant covered; live `usage-log.md`, `decisions.md`, `session-notes.md` are intentionally readable.
- `inbox/` — only `inbox/archive/**` covered; live briefs intentionally readable.

**Verdict: MEDIUM** — Read(...) deny rules exist but coverage missing for >2 expected directories. The bulk of the gap is intentional. The forward-pointer fix is *narrower* coverage (e.g., `Read(audits/working/**)`) rather than blanket directory denies.
