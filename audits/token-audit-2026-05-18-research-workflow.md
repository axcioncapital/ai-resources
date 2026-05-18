# Token Audit — Research Workflow — 2026-05-18
Source audit: `token-audit-2026-05-18.md`
AUDIT_ROOT: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
Workflow scope: `workflows/research-workflow/`
Previous comparable: `token-audit-2026-05-02-ai-resources.md` (research workflow section)

---

## Workflow Token Efficiency

**Scope:** Multi-stage pipeline — `/run-preparation`, `/run-execution`, `/run-analysis`, `/run-synthesis`, `/run-report` (plus per-chapter produce commands)

**Key structural finding:** The research workflow has the highest token load of any workflow in the repo — not from command file size, but from data-handling patterns that pass content (not paths) through the main session.

**Top findings (18 total — 6 HIGH, 9 MEDIUM, 3 LOW):**

| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
| 1 | `/run-report` Step 4.0 loads 6 large input categories (chapter drafts, scarcity register, section directives, cluster memos, research extracts, editorial recommendations) into main session, then passes content to downstream subagents | HIGH | Content passed in memory rather than by path; subagents could read files directly | Refactor Step 4.0 to pass file paths to subagents, not file content; let subagents read directly (as `/produce-prose-draft` already does) |
| 2 | `/run-report` Step 4.2a per-chapter writer subagents return "chapter draft content" to main session — plausibly >200 lines, ~20 such calls per section | HIGH | Subagent return contract violation; chapter drafts are large text blocks | Per-chapter writers should write draft to disk and return path only (same pattern as `/produce-prose-draft`) |
| 3 | `/run-execution` Step 2.3 reads ALL raw research reports into main session before delegating to per-session extract subagents | HIGH | Large delegable read; main session bears the full load of all raw reports | Delegate raw report reads to extract subagents directly; pass file paths only |
| 4 | `/run-analysis` Step 1 reads all refined cluster memos into main session | HIGH | Delegable batch read in main context | Pass paths to analysis subagents; they read what they need |
| 5 | `/run-execution` Step 2.1b QC redundantly reads all prompts + specs + plan in main session | HIGH | Reads that are available to subagents already | Consolidate QC reads into a subagent or skip the redundant pass |
| 6 | `/run-report` Step 4.1b re-reads all 6 categories from Step 4.0 | HIGH (boundary) | Double-load of same content within the same command invocation | Cache Step 4.0 reads; do not re-read |
| 7 | `/run-cluster` has 0 `/compact` instructions despite iterating over multiple clusters | MEDIUM | Context accumulates across cluster iterations with no reset | Add `/compact` after each cluster or batch |
| 8 | `/run-report` has only 3 compacts for 13 delegate calls | MEDIUM | Insufficient compaction for a 13-subagent orchestration pass | Add compact breakpoints every 3–4 delegate calls |
| 9–18 | Additional MEDIUMs: repeated re-reads of cluster memos/extracts across stages; refinement multiplier 8–12 per section; command file verbosity | MEDIUM/LOW | See full working notes | |

PASS: `/produce-prose-draft` implements the best token pattern in the repo — absolute-path subagent reads, output-to-disk, ≤20-line return caps. This pattern should be adopted across all `/run-*` commands.

Full working notes: `audits/working/audit-working-notes-workflow-research-workflow.md`

---

## Workflow Reference Skill Copies

`workflows/research-workflow/reference/skills/` holds copies of `knowledge-file-producer` and `report-compliance-qc` with no YAML frontmatter (0% frontmatter compliance). These are intentional reference copies for the deployed workflow but are missing `model:` and `effort:` fields. Should either be documented explicitly as reference-only or have frontmatter restored.

---

## Optimization Recommendations

### HIGH Priority

**H5 — Refactor `/run-report` and `/run-execution` to pass file paths, not content** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | `/run-report` Step 4.0 loads 6 large input categories into main session and passes content to subagents; Step 4.2a per-chapter subagents return full drafts to main |
| Evidence | Workflow findings #1, #2 above; `/produce-prose-draft` already implements the correct pattern |
| Waste mechanism | Main session acts as a content relay — loads large batches only to forward them to subagents that could read directly |
| Estimated savings | HIGH — each research section run may save 10,000–50,000 tokens |
| Implementation | Refactor Steps 4.0/4.2a: pass absolute file paths to subagents; subagents read directly per `/produce-prose-draft` pattern; per-chapter writers write draft to disk + return path |
| Risk | MEDIUM — path-passing requires subagents to have reliable absolute paths (already established in `/produce-prose-draft`) |
| Dependencies | None — model for correct implementation already exists |
| Category | Structural change |

**H6 — Refactor `/run-execution` to delegate raw report reads** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | `/run-execution` Step 2.3 reads ALL raw research reports into main session before delegating |
| Evidence | Workflow finding #3 above |
| Waste mechanism | All raw reports loaded in main context when subagents could read only the ones they need |
| Estimated savings | HIGH — raw report batch can be 5,000–20,000+ tokens |
| Implementation | Delegate report reads to extract subagents directly; pass file paths only from main |
| Risk | MEDIUM |
| Dependencies | H5 (same pattern change) |
| Category | Structural change |

### MEDIUM Priority

**M4 (research-workflow portion) — Add `/compact` breakpoints to `/run-cluster` and `/run-report`** *(Structural change)*

| Field | Content |
|-------|---------|
| Issue | `/run-cluster` has 0 `/compact` instructions; `/run-report` has only 3 compacts for 13 delegate calls |
| Evidence | Workflow findings #7, #8 above |
| Waste mechanism | Context accumulates across cluster iterations and delegate calls with no reset |
| Estimated savings | MEDIUM — prevents runaway context accumulation in long research sessions |
| Implementation | Add `/compact` after each `/run-cluster` iteration; add compact breakpoints every 3–4 delegate calls in `/run-report` |
| Risk | LOW |
| Dependencies | None |
| Category | Structural change |

### LOW Priority

**L4 — Restore frontmatter to workflow reference skill copies**

`workflows/research-workflow/reference/skills/` — add `name:` and `description:` frontmatter to `knowledge-file-producer` and `report-compliance-qc` copies, or add a comment marking them as reference-only.

### Safeguard Proposal

**Path-passing protocol** — Document as a standing instruction in `workflows/research-workflow/CLAUDE.md`: "Subagents receive file paths, not content. Content loading in main session is prohibited." Reference `/produce-prose-draft` as the canonical implementation. This prevents regression as new `/run-*` stages are added.

---

## Implications for Opus 4.7 Upgrade

- H5/H6 (path-passing refactor) should be implemented before upgrading research sessions to Opus 4.7 — the content-passing pattern costs proportionally more on Opus.
- Refinement multiplier of 8–12 subagent sessions per section (finding #9–18) compounds on Opus 4.7 — any reduction here has outsized cost impact at that tier.

---

## Assumptions and Gaps

- **No execution telemetry:** All estimates are structural inferences from command file inspection, not observed session data. Actual token costs per research section run are unknown. A single instrumented research session would produce far more accurate estimates.
- **Subagent return sizes estimated, not measured:** The per-chapter writer claim (>200 lines returned) is inferred from the command design. The pattern is confirmed by code inspection but not by a live session measurement.
- **Token estimation caveat:** All estimates use word count × 1.3. Findings near a threshold boundary (±15%) are lower-confidence (specifically: `/run-report` Step 4.1b re-reads, classified HIGH boundary).
