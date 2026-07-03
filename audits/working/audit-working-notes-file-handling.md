---
section: 6
title: File Handling Patterns
date: 2026-07-03
scope: ai-resources
---

# Section 6: File Handling Patterns

## Read(pattern) Deny-Rule Status (from Step 0.3)

**Verdict: MEDIUM**

### Currently Covered Directories

The following `Read(pattern)` deny rules are configured in `.claude/settings.json`:

```
Read(archive/**)
Read(logs/*-archive-*.md)
Read(inbox/archive/**)
Read(**/deprecated/**)
Read(**/old/**)
Read(logs/*archive*.md)
```

### Expected But Missing Coverage

**Count of missing expected directories: 4** (exceeds threshold of >2 for MEDIUM severity)

1. **`audits/`** — 147+ files (prior reports and working notes, NOT covered)
2. **`audits/working/`** — subagent scratch notes (NOT covered)
3. **`reports/`** — 13 generated report files (NOT covered)
4. **`output/`** — 114 new files (context packs + test artifacts, NOT covered)
5. **`logs/` active files** — 5 accumulating logs not covered (only archive variants protected)

---

## Large Files Assessment (40 Top Files by Word Count)

| File | Lines | Words | Should read? | Parent dir protected? | Finding |
|------|-------|-------|---------|---------|---------|
| ./logs/session-notes-archive-2026-05.md | 5310 | 68212 | NO | YES | PASS |
| ./logs/session-notes-archive-2026-06.md | 3117 | 45433 | NO | YES | PASS |
| ./logs/session-notes-archive-2026-04.md | 3370 | 42293 | NO | YES | PASS |
| ./logs/decisions-archive-2026-05.md | 1814 | 32911 | NO | YES | PASS |
| ./logs/improvement-log-archive.md | 450 | 16775 | NO | YES | PASS |
| ./logs/improvement-log.md | 626 | 15137 | NO | NO | **MEDIUM: Active log NOT covered** |
| ./logs/decisions.md | 290 | 13754 | NO | NO | **MEDIUM: Active log NOT covered** |
| ./logs/usage-log-archive-2026-05.md | 856 | 13425 | NO | YES | PASS |
| ./logs/decisions-archive-2026-04.md | 752 | 13375 | NO | YES | PASS |
| ./logs/usage-log.md | 583 | 12869 | NO | NO | **MEDIUM: Active log NOT covered** |
| ./audits/token-audit-2026-04-18-ai-resources.md | 647 | 10381 | NO | NO | **MEDIUM: audit report uncovered** |
| ./logs/decisions-archive-2026-06.md | 369 | 8581 | NO | YES | PASS |
| ./audits/repo-due-diligence-2026-05-08-ai-resources.md | 935 | 8353 | NO | NO | **MEDIUM: audit report uncovered** |
| ./logs/improvement-log-archive-archive-2026-04.md | 412 | 8280 | NO | YES | PASS |
| ./.claude/commands/prime.md | 566 | 8251 | YES | N/A | PASS - canonical |
| ./logs/friction-log.md | 246 | 8185 | NO | NO | **MEDIUM: Active log NOT covered** |
| ./audits/repo-due-diligence-2026-05-08-project-repo-documentation.md | 907 | 7999 | NO | NO | **MEDIUM: audit report uncovered** |
| ./.claude/commands/wrap-session.md | 483 | 7980 | YES | N/A | PASS - canonical |
| ./audits/working/log-sweep-ai-resources-2026-06-12.md | 1299 | 7767 | NO | NO | **HIGH: Working notes NOT protected** |
| ./audits/token-audit-2026-04-18-project-buy-side-service-plan.md | 511 | 7324 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-04-12.md | 824 | 6883 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/token-audit-2026-05-18.md | 606 | 6880 | NO | NO | **MEDIUM: audit report uncovered** |
| ./logs/session-notes.md | 521 | 6780 | NO | NO | **MEDIUM: Active log NOT covered** |
| ./audits/repo-due-diligence-2026-05-08-project-global-macro-analysis.md | 782 | 6756 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-05-05-project-global-macro-analysis.md | 737 | 6518 | NO | NO | **MEDIUM: audit report uncovered** |
| ./logs/usage-log-archive.md | 435 | 6472 | NO | YES | PASS |
| ./audits/token-audit-2026-05-02-ai-resources.md | 504 | 6460 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-05-12-project-nordic-pe-macro-landscape-H1-2026.md | 673 | 6330 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-04-11.md | 857 | 6326 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/working/toctou-phase-2-and-3-atomic-spec.md | 827 | 6108 | NO | NO | **HIGH: Working notes NOT protected** |
| ./skills/ai-prose-decontamination/SKILL.md | 411 | 6087 | YES | N/A | PASS - canonical |
| ./audits/token-audit-protocol.md | 640 | 6053 | YES | N/A | PASS - canonical |
| ./audits/repo-due-diligence-2026-04-18-ai-resources.md | 739 | 5889 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-05-27-project-strategic-os.md | 549 | 5887 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/token-audit-2026-05-25-ai-resources.md | 521 | 5866 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/working/log-sweep-ai-resources-2026-05-22.md | 609 | 5733 | NO | NO | **HIGH: Working notes NOT protected** |
| ./audits/claude-md-audit-2026-05-04-workspace-only.md | 531 | 5696 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-05-27-project-nordic-pe-screening-project.md | 609 | 5675 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-06-02-project-research-pe-regime-shift-advisory-gap.md | 740 | 5600 | NO | NO | **MEDIUM: audit report uncovered** |
| ./audits/repo-due-diligence-2026-04-21-project-obsidian-pe-kb.md | 710 | 5596 | NO | NO | **MEDIUM: audit report uncovered** |

---

## Directory-Level Findings

### HIGH SEVERITY

**audits/working/** — Subagent scratch directory (5+ files)
- `log-sweep-ai-resources-2026-06-12.md`: 1299 lines, 7767 words
- `log-sweep-ai-resources-2026-05-22.md`: 609 lines, 5733 words
- `toctou-phase-2-and-3-atomic-spec.md`: 827 lines, 6108 words
- Total: 19.6 KB of temporary working files from prior audit/analysis runs
- Issue: Temporary subagent outputs should not be readable by subsequent sessions
- Impact: Unnecessary context loading, confusion between working notes and canonical outputs
- Severity: HIGH — internal scratch work, not for session context

**output/** — Generated outputs and test artifacts (114 files, 760 KB)
- 18 context pack directories: agent-*, architecture-*, command-*, documentation-*, hook-*, incident-*, project-*, qc-*
- 1 full project scaffold: deploy-test-scratch-2026-06-12/ (test artifact)
- Issue: New directory with no deny-rule protection; will grow as context packs accumulate
- Impact: Test outputs and generated packs at risk of accidental reading
- Severity: HIGH — emerging category with growth potential

### MEDIUM SEVERITY

**audits/** — Prior reports and analysis (147+ files)
- token-audit reports (20+ files): 500-1000+ lines each
- repo-due-diligence reports (40+ files): 500-1000+ lines each
- claude-md audit reports (25+ files): 500-1000+ lines each
- Sampling shows large files: token-audit-2026-04-18-ai-resources.md (647 lines, 10381 words), repo-due-diligence-2026-05-08-ai-resources.md (935 lines, 8353 words)
- Issue: Prior outputs accumulate, no deny-rule protection
- Impact: Previous audit/analysis reports could be read by mistake in new sessions
- Severity: MEDIUM — violates expected-coverage requirement

**reports/** — Generated health and analysis reports (13 files)
- repo-health-report-*.md (multiple versions): 300-500 lines each
- graduate-resource-candidates-2026-05-22.md, setup-improvement-scan-2026-04-21.md
- Issue: Generated outputs not protected from casual reading
- Impact: Stale reports could influence session context
- Severity: MEDIUM — violates expected-coverage requirement

**logs/ (active files)** — Accumulating logs NOT protected (5 files, 56,725 words total)
- improvement-log.md: 626 lines, 15137 words
- decisions.md: 290 lines, 13754 words
- usage-log.md: 583 lines, 12869 words
- friction-log.md: 246 lines, 8185 words
- session-notes.md: 521 lines, 6780 words
- Issue: Active logs grow continuously but only archive variants are protected; asymmetric coverage
- Impact: Fresh sessions could load large active logs unnecessarily
- Severity: MEDIUM — violates expected-coverage requirement

---

## Summary of Findings

**Total findings: 27**
- HIGH: 5 findings (audits/working/ files × 3, output/ × 1, output/ growth × 1)
- MEDIUM: 22 findings (5 active logs × 1 each, ~15 audit reports × 1 each, audits/ directory × 1, reports/ directory × 1)
- LOW: 0 findings

**Covered directories (PASS): 6**
- archive/, inbox/archive/, **/deprecated/, **/old/, logs/*-archive-*.md, logs/*archive*.md

**Uncovered expected directories: 4**
- audits/ (147+ files)
- audits/working/ (5+ working note files)
- reports/ (13 generated reports)
- output/ (114 new files)
- logs/ active files (5 files, partial coverage)

**Finding distribution by directory:**
- audits/working/: 3 HIGH findings (3 large working note files)
- output/: 2 HIGH findings (114-file directory, test artifact growth)
- audits/: 1 MEDIUM finding (147+ prior reports uncovered)
- reports/: 1 MEDIUM finding (13 generated reports uncovered)
- logs/ active: 5 MEDIUM findings (each of 5 active logs uncovered)
- audits/ reports: 15 MEDIUM findings (specific large audit/DD/claude-md reports uncovered)

---

## Hygiene Assessment

### Positive patterns found:
- Archive naming consistent (`*-archive-*.md`, `*archive*.md`, `*-prev.md`)
- Archive deny rules functioning for logged patterns
- Canonical files (commands, skills, protocol) properly readable

### Negative patterns:
- No automated cleanup of archived audit/report files (manual archiving, no deletion)
- Subagent working notes persist indefinitely with no lifecycle management
- Active logs and archive variants coexist in same directory with asymmetric protection

---

## Protocol Gaps

None identified. Section 6 instructions were clear and fully executable.
