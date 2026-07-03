# Section 4 Summary — research-workflow

Executed 2026-07-03 | Protocol v1.3 | Scope: workflows/research-workflow/ | Telemetry: NONE (all estimates = structural inferences)

**Total findings: 11** — HIGH 4, MEDIUM 5, LOW 2

**Top 3 (severity-labelled):**
1. HIGH — run-report St4.2a: `evidence-to-report-writer` returns FULL chapter draft content to main (>200L est.); sibling run-synthesis St2 writes to disk + returns only a path/summary for the same artifact class.
2. HIGH — `execution-agent` (wired via /verify-chapter St4) returns the full GPT-5/Perplexity response VERBATIM to main (>200L est.) AND writes it to disk — the return duplicates the disk write.
3. HIGH — large delegable OPERAND reads relayed through main: run-report St4.0 (six categories) + St4.1b re-read; run-analysis St1 (all memos); run-synthesis St1; run-execution St2.3 (all raw reports); produce-architecture Ph2+Ph3 (drafts double-read).

Other HIGH: H4 — large reference docs (quality-standards 260L, source-class-hierarchy 106L(boundary), known-limits 105L(boundary)) content-passed ×N in run-cluster St2.2 / run-execution St2.1+2.3, where the workflow's own carve-out permits path-passing (run-report/produce-* already do).
Key MEDIUMs: run-cluster (0 /compact) and run-sufficiency (0 /compact across 5 phases); refinement multiplier >3 + ~7–8 sessions/section BY-DESIGN; skill-content-into-main pervasive; qc-gate Read-only forces all verdicts through main.
Note: H3/H4 apply the protocol's literal "delegable→HIGH" rule; the isolation-rule rationale is the mechanism, not a severity reducer — flagged for Section 10.
PASS: strong disk-write discipline; produce-prose-draft/produce-formatting are capped-summary exemplars.

Full evidence in /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-working-notes-workflow-research-workflow.md. Main session should read the full notes only if a specific finding needs deeper review.
