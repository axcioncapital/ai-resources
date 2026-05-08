# Risk Check — `/log-sweep` command, `log-sweep-auditor` agent, `log-archiver.sh` script, `/friday-checkup` integration

**Date:** 2026-05-08
**Change class:** New command + new subagent + new helper script + update to shared command (`/friday-checkup`)
**Verdict:** PROCEED-WITH-CAUTION — 6 mitigations required before landing

---

## Change description

Three new files and two updated files:

- **New:** `ai-resources/.claude/commands/log-sweep.md` — orchestrator command (sonnet) that discovers log files across `ai-resources/` and `projects/*/`, asks operator to select scopes, dispatches per-scope auditor subagents, then applies header-based or whole-file archive operations.
- **New:** `ai-resources/.claude/agents/log-sweep-auditor.md` — mechanical haiku subagent; classifies each log file into one of 7 categories, writes full notes to `audits/working/`, returns ≤20-line summary.
- **New:** `ai-resources/logs/scripts/log-archiver.sh` — bash helper for categories `check-archive.sh` / `split-log.sh` cannot handle: `### `-header files (Cat B) and age-based whole-file moves for `audits/working/` (Cat D).
- **Updated:** `ai-resources/.claude/commands/friday-checkup.md` — adds `/log-sweep --dry-run` to the weekly rotation block and the runtime estimator.
- **Updated:** `ai-resources/.claude/commands/wrap-session.md` — adds idempotency note for same-day runs of `/wrap-session` + `/log-sweep`.

---

## Risk dimension scores

| Dimension | Score | Notes |
|-----------|-------|-------|
| Usage cost | LOW | Shared commands load on every session; three small files add minimal token overhead. `log-sweep.md` ~300 lines, auditor ~150 lines, archiver is a bash script (not loaded into context). |
| Permissions surface | LOW | Command reads files and calls existing scripts. No new permissions required beyond what bypass mode already grants. |
| Blast radius | **MEDIUM** | `log-archiver.sh` can move or truncate files across all `ai-resources/` and `projects/*/logs/` scopes. A mis-classified file or incorrect threshold match could archive content prematurely. Cat D whole-file moves are hard to detect if they affect a file the operator was actively using. |
| Reversibility | **MEDIUM** | Cat A/B rotations: content preserved verbatim in `*-archive-YYYY-MM.md` — recoverable with one shell command. Cat D whole-file moves: file is at `audits/working/archive/YYYY-MM/{basename}` — equally recoverable. Risk: operator may not notice a file was moved until it's been gc'd or the archive directory is unknown. Pre-apply manifest is the recovery map. |
| Hidden coupling | **MEDIUM** | `dd-log-sweep-agent` (existing) has a similar name. Operators or future contributors could confuse the two. `log-sweep-auditor` is new and distinct in purpose, but the naming collision is real. |

---

## PROCEED-WITH-CAUTION — required mitigations

All 6 mitigations below are **binding implementation requirements** and must be applied before or during landing:

### Mitigation 1 — Pre-apply manifest BEFORE any rotation

`log-sweep.md` step ordering must write `audits/working/log-sweep-manifest-{date}.md` **before** invoking `log-archiver.sh` or `split-log.sh`. The manifest captures `(source-file, lines-before, intended-action, target-archive-path)` for every file about to be touched. If apply aborts mid-run, the manifest is the operator's only complete recovery map.

After apply completes, the same manifest is updated with `lines-after` and per-entry pass/fail — but the pre-rotation BEFORE row must exist on disk before any rotation begins.

### Mitigation 2 — Cat D self-exclusion in log-archiver.sh

`log-archiver.sh --mode whole-file-by-mtime` discovery must include `log-sweep-*.md` and `log-sweep-manifest-*.md` in the exclusion list. Without this, a previous run's working notes or manifest could themselves be moved into the archive on a subsequent run, destroying the recovery record.

### Mitigation 3 — Cat B regex (resolved)

✅ **Resolved 2026-05-08 at plan time.** Empirical verification on all three Cat B files confirmed `awk '{print $2}'` correctly extracts the date from `### YYYY-MM-DD` headers (and variants with trailing text). No further verification needed at landing.

### Mitigation 4 — Name-collision cross-reference

The first paragraph of both agent files must include a one-line distinguisher:
- `log-sweep-auditor.md`: "Different from `dd-log-sweep-agent`, which is a read-only diagnostic log sweep for `/repo-dd`."
- `dd-log-sweep-agent.md` (existing): add distinguisher — "Different from `log-sweep-auditor`, which drives `/log-sweep` archival operations."

Without this, operators or Claude will confuse the two agents, especially since both involve log file scanning.

### Mitigation 5 — Idempotency contract documented

Both `log-sweep.md` and `wrap-session.md` must include a paragraph stating that `/wrap-session` and `/log-sweep` are safe to run on the same day in any order. Idempotency is enforced by `split-log.sh`'s "already at threshold" guard (lines 53-61) and the date-guard pattern (`check-archive.sh:42-48`) replicated in `log-archiver.sh`. Running both commands same-day will not cause double-archival.

### Mitigation 6 — Explicit staging note in final report

The final report at `audits/log-sweep-{date}.md` must end with:

> "Stage `audits/log-sweep-{date}.md` and `audits/working/log-sweep-*-{date}.md` and `audits/working/log-sweep-manifest-{date}.md` explicitly — `/wrap-session`'s enumerated stage list does not cover these paths."

Without this note, the operator may commit the log changes but leave the report and manifest unstaged.

---

## What was NOT flagged as a risk

- **Discovery scope** (`ai-resources/` + `projects/*/` only; excludes `workflows/*/`): confirmed by operator at plan time. Low risk of scope creep.
- **Automated mode** (no `apply N,M` gate after folder pick): confirmed by operator. No unexpected autonomy risk — the folder-selection step is the gate.
- **`check-archive.sh` and `split-log.sh` unchanged**: wrapping-not-modifying pattern preserves their stable `/wrap-session` contract. No regression risk.
- **Path discipline** (`python3 os.path.realpath`, not BSD-incompatible `readlink -f`): correct for macOS. No platform portability risk.

---

## WORKING_NOTES

None — this is a plan-time risk check. Full context in plan file at `/Users/patrik.lindeberg/.claude/plans/let-s-develop-some-sort-flickering-scroll.md`.
