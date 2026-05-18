# Pre-Flight Working Notes — Token Audit 2026-05-18

## 0.1 — Session Metrics
`/cost` and `/context` not available in this execution environment.

## 0.2 — Session-Usage-Analyzer Data
Skill found at: `skills/session-usage-analyzer/SKILL.md`
Historical output: `logs/usage-log.md` (422 lines, entries through 2026-05-16).
In-scope log file count: 1. Triggers Section 5 inline execution (not workspace-scope threshold).

## 0.3 — Read(pattern) Deny-Rule Coverage

### Settings files in scope:
1. `ai-resources/.claude/settings.json` (primary ai-resources config)
2. `ai-resources/.claude/settings.local.json` (one-off allow entries; no deny section)

### Read() deny entries in ai-resources settings.json:
- `Read(archive/**)`
- `Read(logs/*-archive-*.md)`
- `Read(inbox/archive/**)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

### Expected-coverage comparison:
| Expected dir | Covered? | Note |
|---|---|---|
| `audits/` | NO | Intentional carve-out per 2026-05-01 decision: "right fix is Read(audits/working/**) only" — partially addressed by noting `audits/` needs sub-dir coverage |
| `audits/working/` | NO | The specific fix recommended in 2026-05-01 decisions — still not implemented |
| `logs/` | PARTIAL | Only archived log files (`*-archive-*.md`) covered; live logs (usage-log.md, decisions.md, session-notes.md) intentionally readable |
| `reports/` | NO | Intentional carve-out (same reason as audits/) |
| `inbox/` | PARTIAL | Only `inbox/archive/**` covered; active inbox intentionally readable |
| `archive/` | YES | `Read(archive/**)` |
| `output/` | N/A | Not present in ai-resources scope |
| `drafts/` | N/A | Not present |
| `deprecated` dirs | YES | `Read(**/deprecated/**)` |
| `old` dirs | YES | `Read(**/old/**)` |

### Verdict: MEDIUM
Rules exist but coverage missing for >2 expected directories. Key actionable gap:
- `Read(audits/working/**)` — recommended since 2026-05-01, not yet implemented. Working directory contains 90+ files from prior audit runs (per-workflow notes, per-audit summaries, coaching reports, diff files). These load as stale context if Claude Code explores the audits/ directory.
- `Read(reports/**)` — reports directory coverage absent.

Full `audits/**` or `reports/**` deny would break active audit workflows that read reports. The targeted fix is `Read(audits/working/**)` only.
