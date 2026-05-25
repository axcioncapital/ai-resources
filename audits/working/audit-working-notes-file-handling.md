# Section 6: File Handling Patterns — Full Notes

**Audit date:** 2026-05-25  
**Scope:** ai-resources/  
**Auditor:** token-audit-auditor (Section 6 executor)

---

## 6.1 Large Files Scan

### Command executed

```bash
find . -not -path "./.git/*" -not -path "*/node_modules/*" \( -name "*.md" -o -name "*.json" -o -name "*.txt" -o -name "*.csv" -o -name "*.yaml" -o -name "*.yml" \) | while read f; do echo "$(wc -w < "$f") $(wc -l < "$f") $f"; done | sort -rn -k1,1 | head -25
```

Merged and deduplicated top 20+ largest files by word count and line count.

### Consolidated large-file table

| File | Words | Lines | Should Claude read? | Parent dir covered by Read() deny? | Finding |
|------|-------|-------|---------------------|--------------------------------------|---------|
| ./logs/session-notes-archive-2026-04.md | 42293 | 3370 | NO (archive) | PARTIAL | Archive file should be denied; currently matched by `Read(logs/*-archive-*.md)` — COMPLIANT |
| ./logs/session-notes-archive-2026-05.md | 24926 | 2216 | NO (archive) | PARTIAL | Archive file should be denied; currently matched by `Read(logs/*-archive-*.md)` — COMPLIANT |
| ./logs/decisions-archive-2026-04.md | 13375 | 752 | NO (archive) | PARTIAL | Archive file should be denied; currently matched by `Read(logs/*-archive-*.md)` — COMPLIANT |
| ./logs/decisions-archive-2026-05.md | 11222 | 712 | NO (archive) | PARTIAL | Archive file should be denied; currently matched by `Read(logs/*-archive-*.md)` — COMPLIANT |
| ./audits/token-audit-2026-04-18-ai-resources.md | 10381 | 647 | NO (historical, >1 month old) | NO | Historical audit report from 2026-04-18 sitting unprotected in audits/. Risk: Claude Code may read this in future sessions during glob/grep exploration. Recommend deny rule: `Read(audits/token-audit-202604-*.md)` or similar date-stamped pattern. |
| ./logs/usage-log.md | 9372 | 643 | YES (active, current session log) | NO | Active session telemetry — deliberately readable by design. No deny rule needed. |
| ./audits/repo-due-diligence-2026-05-08-ai-resources.md | 8353 | 935 | NO (historical, >2 weeks old, non-current) | NO | Historical repo-dd report. Risk: reads in future sessions waste context. Recommend deny rule for historical variants. |
| ./audits/repo-due-diligence-2026-05-08-project-repo-documentation.md | 7999 | 907 | NO (historical) | NO | Historical repo-dd report. Same risk. |
| ./audits/token-audit-2026-04-18-project-buy-side-service-plan.md | 7324 | 511 | NO (historical, project-specific from Apr) | NO | Historical project-scoped token-audit. Risk: unnecessary read in future ai-resources sessions. Recommend granular deny pattern. |
| ./audits/repo-due-diligence-2026-04-12.md | 6883 | 824 | NO (historical, >1 month old) | NO | Historical repo-dd from Apr. Risk: unnecessary reads. |
| ./.claude/commands/new-project.md | 6883 | 698 | YES (active command) | NO | Active command file — deliberately readable. No deny rule needed. |
| ./audits/token-audit-2026-05-18.md | 6880 | 606 | MAYBE (1 week old, could be reference) | NO | Recent but not current (current is 2026-05-25). Operator may want to reference but not load on every session. Recommend granular deny (e.g., `Read(audits/token-audit-2026-05-*.md)` to exclude last 3 days' reports from automatic exploration). |
| ./logs/session-notes.md | 6867 | 583 | YES (active, current session notes) | NO | Active session notes — deliberately readable. No deny rule needed. |
| ./audits/repo-due-diligence-2026-05-08-project-global-macro-analysis.md | 6756 | 782 | NO (historical, project-scoped) | NO | Historical, project-scoped repo-dd. Risk: unnecessary reads in ai-resources sessions. |
| ./audits/repo-due-diligence-2026-05-05-project-global-macro-analysis.md | 6518 | 737 | NO (historical, >2 weeks old) | NO | Historical repo-dd. Risk: unnecessary reads. |
| ./logs/usage-log-archive.md | 6472 | 435 | NO (archive) | NO | Archive file NOT covered by any deny rule. Risk: may be read during glob/grep. Recommend: `Read(logs/*archive*.md)` or `Read(logs/usage-log-archive.md)`. |
| ./audits/token-audit-2026-05-02-ai-resources.md | 6460 | 504 | NO (historical, >2 weeks old) | NO | Historical token-audit. Risk: unnecessary reads. |
| ./audits/repo-due-diligence-2026-05-12-project-nordic-pe-macro-landscape-H1-2026.md | 6330 | 673 | NO (historical, >1 week old, project-scoped) | NO | Historical, project-scoped repo-dd. Risk: unnecessary reads in ai-resources sessions. |
| ./audits/repo-due-diligence-2026-04-11.md | 6326 | 857 | NO (historical, >1 month old) | NO | Historical repo-dd from Apr. Risk: unnecessary reads. |
| ./skills/ai-prose-decontamination/SKILL.md | 6087 | 411 | YES (active skill) | NO | Active skill — deliberately readable. No deny rule needed. |

---

## 6.2 Read(pattern) Deny-Rule Status — Re-use from 0.3

From preflight notes:

**Verdict: MEDIUM** — 2 expected dirs fully uncovered (`audits/`, `reports/`); 2 partially covered (`logs/`, `inbox/`).

**Currently covered:**
- `Read(archive/**)`
- `Read(logs/*-archive-*.md)`
- `Read(inbox/archive/**)`
- `Read(**/deprecated/**)`
- `Read(**/old/**)`

**Expected but missing:**
- `audits/` — fully uncovered
- `reports/` — fully uncovered

**Partial coverage:**
- `logs/` — only `*-archive-*.md` pattern; active logs (usage-log.md, session-notes.md, etc.) deliberately readable
- `inbox/` — only `archive/**` pattern; active briefs deliberately readable

---

## 6.3 Assessment of Unignored Large Files

### Summary of findings

**Archive files with compliant deny rules (no action needed):**
- `./logs/session-notes-archive-*.md` (42293, 24926 words) — matched by `Read(logs/*-archive-*.md)` ✓
- `./logs/decisions-archive-*.md` (13375, 11222 words) — matched by `Read(logs/*-archive-*.md)` ✓

**Archive files NOT covered by deny rules (risk: unprotected):**
- `./logs/usage-log-archive.md` (6472 words) — NO matching deny rule. Should be denied but isn't. Risk: Claude Code may read during glob/grep exploration. **Finding: MEDIUM**

**Historical audit reports NOT covered by deny rules (risk: unprotected):**

The `audits/` directory contains 75+ files, including ~30 historical token-audit and repo-due-diligence reports (from Apr–May 2026). Example files from the top-20 large-file list:

- `./audits/token-audit-2026-04-18-ai-resources.md` (10381 words, 647 lines) — historical, 1+ month old
- `./audits/repo-due-diligence-2026-05-08-ai-resources.md` (8353 words, 935 lines) — historical, >2 weeks old
- `./audits/repo-due-diligence-2026-05-08-project-repo-documentation.md` (7999 words, 907 lines) — historical
- `./audits/token-audit-2026-04-18-project-buy-side-service-plan.md` (7324 words, 511 lines) — historical, project-scoped
- `./audits/repo-due-diligence-2026-04-12.md` (6883 words, 824 lines) — historical, 1+ month old
- `./audits/token-audit-2026-05-18.md` (6880 words, 606 lines) — recent (1 week old, but not "current")
- `./audits/repo-due-diligence-2026-05-08-project-global-macro-analysis.md` (6756 words, 782 lines) — historical
- `./audits/repo-due-diligence-2026-05-05-project-global-macro-analysis.md` (6518 words, 737 lines) — historical
- `./audits/token-audit-2026-05-02-ai-resources.md` (6460 words, 504 lines) — historical, >2 weeks old
- `./audits/repo-due-diligence-2026-05-12-project-nordic-pe-macro-landscape-H1-2026.md` (6330 words, 673 lines) — historical
- `./audits/repo-due-diligence-2026-04-11.md` (6326 words, 857 lines) — historical, 1+ month old

**Risk mechanism:** None of these are covered by a deny rule. During a session, if Claude Code runs `find . -name "*.md"` or `grep -r` to search across the repo, it may discover and read these files, wasting context on non-current historical reports. Operator may want to reference them explicitly ("read the April token-audit report"), but they shouldn't be automatically discovered.

**Finding: MEDIUM** — ~15–20 large historical audit reports in `audits/` are unprotected.

**Note on operator intent (from preflight caveat):** The preflight notes clarified that audits/, reports/, logs/, and inbox/ all hold artifacts the operator deliberately wants Claude to read when invoked explicitly. The issue is not "these shouldn't be readable" but rather "automatic exploration should not load these if they're stale."

**Practical recommendation:** Implement granular, date-stamped deny patterns rather than blanket directory denies:
- `Read(audits/token-audit-202604-*.md)` — deny historical token-audits from April
- `Read(audits/token-audit-202605-*.md)` — deny early-May token-audits
- `Read(audits/repo-due-diligence-202604-*.md)` — deny April repo-dd reports
- `Read(audits/repo-due-diligence-202605-0[1-2]-*.md)` — deny early-May repo-dd reports
- `Read(logs/usage-log-archive.md)` — explicitly deny the usage-log archive file

This approach protects historical content from automatic discovery while preserving operator ability to read them explicitly by name.

---

## 6.4 Workspace Hygiene — Deprecated/Temporary Files

Checked for files with markers: `draft`, `tmp`, `old`, `deprecated`, `archive`, dated variants (e.g., `v1`, `2024-`), or files in `archive/`, `deprecated/`, `old/` folders.

**Conclusion:** Workspace hygiene is reasonable. Archive files are present but either covered by deny rules or flagged as findings above. No orphaned `draft/`, `tmp/`, or `deprecated/` directories cluttering the root.

---

## 6.5 Classification of Findings

### MEDIUM severity findings

**Finding 1: Missing deny coverage for `audits/` directory**
- Evidence: 75 files in audits/, including ~30 historical audit reports (token-audit-*, repo-due-diligence-*)
- Top examples: token-audit-2026-04-18-ai-resources.md (10381 words), repo-due-diligence-2026-05-08-* (7999–8353 words each)
- No `Read(audits/...)` deny rules in settings.json
- Recommendation: Add granular, date-stamped deny patterns for historical content

**Finding 2: Missing deny coverage for `reports/` directory**
- Evidence: reports/ contains 9 files, mostly repo-health-report-YYYY-MM-DD.md historical versions
- No `Read(reports/...)` deny rules in settings.json
- Recommendation: Add date-stamped deny rules for historical variants

**Finding 3: Incomplete deny coverage for `logs/` — usage-log-archive.md not denied**
- Evidence: Currently only `Read(logs/*-archive-*.md)` is denied
- `logs/usage-log-archive.md` (6472 words) is NOT covered by the pattern
- Recommendation: Expand logs deny rule to catch all archive variants

---

## 6.6 Summary Table

| # | Finding | Severity | File/pattern | Tokens affected |
|---|---------|----------|--------------|-----------------|
| 1 | audits/ directory not covered by deny rules | MEDIUM | ~30 historical audit reports (10–90 KB each) | 5K–12K tokens/session if 1–2 large reports read |
| 2 | reports/ directory not covered by deny rules | MEDIUM | ~8 historical report files (40–70 KB each) | 5K–10K tokens/session if 1 report read |
| 3 | logs/usage-log-archive.md not denied | MEDIUM | 6472 words, 435 lines (8.4K tokens) | 8K tokens wasted if read during exploration |

---

## Protocol Gaps

None identified. The protocol's steps were clear and executable.

---

## Confidence Ratings

- **File scan accuracy:** HIGH — bash commands executed, top 20 files measured directly
- **Classification of "Should Claude read?":** HIGH — decision rules straightforward
- **Deny-rule coverage assessment:** HIGH — cross-referenced against actual settings.json
- **Estimated token impact:** MEDIUM — assumes accidental reads during glob/grep, actual occurrence unknown
