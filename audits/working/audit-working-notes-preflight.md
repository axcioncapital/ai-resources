# Pre-Flight Notes — token-audit 2026-05-25 (ai-resources)

## 0.1 Baseline session metrics

`/cost` and `/context`: not available in this execution environment as callable tools (the audit runs as a Skill invocation, not an interactive session). Will record again in Section 10 if surfaced later.

## 0.2 session-usage-analyzer telemetry

- Skill: `skills/session-usage-analyzer/SKILL.md` (Sonnet, post-session subagent)
- Output target: each consuming project's `logs/usage-log.md`
- `ai-resources/logs/usage-log.md`: 643 lines, most recent entries 2026-05-22 (3 sessions same day). Rich qualitative entries with token estimates per session — usable for Section 5 inline.

## 0.3 Read(pattern) deny-rule check

**Settings files found under AUDIT_ROOT:**
- `ai-resources/.claude/settings.json`
- `ai-resources/.claude/settings.local.json` (empty `{}`)
- `ai-resources/workflows/research-workflow/.claude/settings.json`

**Read(...) deny entries — ai-resources/.claude/settings.json:**
- `Read(archive/**)`
- `Read(logs/*-archive-*.md)`
- `Read(inbox/archive/**)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

**Read(...) deny entries — workflows/research-workflow/.claude/settings.json:**
- `Read(archive/**)`
- `Read(**/*.archive.*)`
- `Read(logs/*-archive-*.md)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

**Coverage analysis against the protocol's expected-coverage list:**

| Expected dir | Covered? | Notes |
|---|---|---|
| audits/ | NO | 75 files in audits/, including ~30+ historical audit reports. Active reports are read-relevant; the unread historical reports are not. |
| logs/ | PARTIAL | Only `logs/*-archive-*.md` denied. Active logs (usage-log, session-notes, friction-log) deliberately readable. |
| reports/ | NO | 9 files in reports/, mostly repo-health-report-YYYY-MM-DD.md historical versions. The "current" file is deliberately readable; prior versions are not. |
| inbox/ | PARTIAL | Only `inbox/archive/**` denied. Active intake briefs deliberately readable. |
| archive/ | YES | `Read(archive/**)` |
| output/ | n/a | No `output/` dir at ai-resources root |
| drafts/ | n/a | No `drafts/` dir at ai-resources root |
| **/deprecated/** | YES | Covered |
| **/old/** | YES | Covered |

**Verdict: MEDIUM** — 2 expected dirs fully uncovered (`audits/`, `reports/`); 2 partially covered (`logs/`, `inbox/`).

**Operator-intent caveat:** audits/, reports/, logs/, and inbox/ all hold active artifacts the operator deliberately wants Claude to read. The "expected-coverage" list in the protocol is generic and doesn't account for this repo's design (active artifacts live in those dirs). A more nuanced finding belongs in Section 6/7.

**Practical re-classification:** The PASS/MEDIUM/HIGH verdict on the protocol's literal list is MEDIUM. The substantive risk is narrower — only stale/archived content in audits/ and reports/ matters (audits/ contains ~30+ historical audit reports; reports/ contains 8+ versions of the repo-health-report). Section 6 will check whether stale content in those dirs is actually causing waste, and will recommend granular `Read()` deny patterns (e.g., `Read(audits/token-audit-2026-04-*.md)`) rather than blanket directory denies.
