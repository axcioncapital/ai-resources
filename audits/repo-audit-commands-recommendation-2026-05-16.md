# `/audit-repo` vs `/repo-dd` — Role Recommendation

**Date:** 2026-05-16
**Source request:** `audits/friday-plans/2026-05-16-journal-improvements.md` item #5 — "Investigate /audit-repo vs /repo-dd overlap and produce written recommendation"
**Upstream:** `audits/friday-journal-2026-05-16.md` item 6

---

## TL;DR

**Recommendation: Keep both. Document the role split.**

The two commands look superficially similar (both walk a repo and produce a markdown report), but they have distinct agent architectures, distinct output shapes, and distinct operational purposes. The overlap is in surface area — what they read — not in function. Merging them would either (a) bloat `/audit-repo` with triage/fix/commit machinery it doesn't need, or (b) gut `/repo-dd`'s trend-comparison and operator-gated triage that gives it its value. Neither move is worth the churn.

The friction the operator surfaced in `friday-journal` item 6 isn't redundancy — it's the absence of a one-line guide telling the operator which command to reach for. The fix is documentation, not consolidation.

---

## Side-by-side comparison

| Dimension | `/audit-repo` | `/repo-dd` |
|---|---|---|
| Frontmatter model | `sonnet` | `opus` |
| Spec length | ~50 lines | ~320 lines |
| Lead subagent | `repo-health-analyzer` (+ 7 specialty sub-auditors: file-org, claude-md, skill, command, settings, practices, context-health) | `repo-dd-auditor` (single comprehensive questionnaire) + `dd-extract-agent` + `dd-log-sweep-agent` |
| Output location | `{cwd}/reports/repo-health-report.md` (in the audited project) | `{ai-resources}/audits/repo-due-diligence-YYYY-MM-DD[-{SCOPE_SLUG}].md` (always central) |
| Output shape | Scored health snapshot — Executive Summary + Scores table per dimension | Structured factual extract — questionnaire findings, no scoring |
| Tier system | None — one shot | Three tiers: standard / deep / full |
| Trend awareness | Stateless — no prior-audit reference | Compares against previous same-scope audit (Step 2.8) |
| Triage step | None | AUTO-FIX / OPERATOR / INFO (Step 4) |
| Fix-apply step | None | Applies approved fixes (Step 6) |
| Commits | No | Yes — commits audit + applied fixes |
| Scope mechanism | `cwd` is the audit target | Operator-selected: workspace, ai-resources, workflows, or specific project |
| Operator gates | None | Two-to-three: scope selection (Step 1), triage approval (Step 5), optional pipeline-testing gate (Step 13) |

---

## Where they truly overlap

Both walk a repo subtree. Both read CLAUDE.md, settings.json, command/agent files, skill files, logs. Both produce a markdown finding list. The intersection is real but shallow — it's the *evidence-gathering* layer.

Above that layer, the commands diverge sharply:

- `/audit-repo` synthesizes evidence into **per-dimension scores** (judgment about quality).
- `/repo-dd` extracts evidence into a **structured factual report** for downstream triage (no judgment — the audit is a fact-base; triage is the judgment step, and it's an operator gate).

This split is intentional and useful. Scored snapshots and triaged finding lists answer different operator questions:

- "How healthy is this repo right now?" → `/audit-repo`
- "What should we fix this week?" → `/repo-dd`

---

## Why the friction exists

`friday-journal-2026-05-16.md` item 6 records the operator's confusion: "the difference between /audit-repo and /repo-dd is unclear; when do I run which." The friction is real, but the cause is **missing meta-documentation**, not redundant tools.

Three contributing factors:

1. **Both commands use the word "audit" in casual reference**, but only `/audit-repo` is a health-score audit; `/repo-dd` is a due-diligence cycle that *includes* an audit step. The naming asymmetry hides the role split.
2. **`/friday-checkup` invokes `/audit-repo`** (the lightweight one) as its embedded health check — operators familiar with `/friday-checkup` may not realize `/repo-dd` exists or what it adds.
3. **No top-level doc** explains the two roles. Each command's frontmatter description is one line — neither cross-references the other.

---

## Recommendation: Keep both. Add a role-split doc and cross-references.

### What to do

1. **Add a "Repo Audit Commands" section to `ai-resources/CLAUDE.md`** (or to a new `docs/repo-audit-commands.md` if CLAUDE.md is becoming over-loaded). One paragraph each:
   - **`/audit-repo`** — periodic health snapshot. Run before starting work on a repo to see scored dimensions and surface obvious regressions. No triage, no fixes, no commit. Sonnet.
   - **`/repo-dd`** — due diligence cycle. Run when you want to *act* on findings: it audits, triages (AUTO-FIX / OPERATOR / INFO), applies approved fixes, and commits. Compares against the previous same-scope audit. Tiered (standard / deep / full). Opus.

2. **Update each command's frontmatter description** to cross-reference the other. Specifically:
   - `/audit-repo` description → "Run a full workspace health audit. For a triaged, action-oriented due-diligence cycle (with fix-apply), use `/repo-dd`."
   - `/repo-dd` description → "Run the full repo due diligence pipeline. For a lightweight scored snapshot without triage or fixes, use `/audit-repo`."

3. **Add a "When to use which" line to `/friday-checkup`**: the friday-checkup spec embeds `/audit-repo` calls; add a comment block above that step noting that `/repo-dd` is the alternative when the operator wants triage + fix in the same session.

### What NOT to do

- **Do not merge.** Merging would force every health check to go through the heavyweight `/repo-dd` machinery (operator gates, triage, commit), or would force every due-diligence cycle to live inside `/audit-repo`'s simpler shape (no trend comparison, no operator-gated fix-apply). Either direction loses something real.
- **Do not deprecate `/audit-repo`.** It serves the periodic-health-check use case that `/repo-dd` does not — and it's the embedded check in `/friday-checkup`. Deprecating it would mean rewriting `/friday-checkup` to handle the operator gates in `/repo-dd`, which is a larger surface than the doc fix recommended above.
- **Do not deprecate `/repo-dd`.** It serves the action-oriented due-diligence use case that `/audit-repo` does not. The trend-comparison and triage gates are not replicable in `/audit-repo` without rebuilding it.

---

## Migration plan

None required. This is a documentation change. Effort:

- ~10 lines added to `ai-resources/CLAUDE.md` (or new `docs/repo-audit-commands.md`)
- ~2 lines edited in each command's frontmatter description (2 files)
- ~3 lines added as a comment block in `/friday-checkup`

Estimated effort: <30 minutes. No risk-check class triggered (frontmatter description edits + new doc paragraph + comment block — none of these touch hooks, permissions, settings, or shared-state automation).

---

## Out of scope (noted for future)

- Whether `/audit-repo`'s 7-auditor architecture and `/repo-dd`'s questionnaire could share an evidence-gathering layer (deduplicating the file reads). This is an internal refactor question that doesn't change the operator-facing role split, and is significantly more work than the doc fix. Not recommended unless audit runtime becomes a constraint.
- Whether `/friday-checkup` should optionally call `/repo-dd standard` instead of `/audit-repo` for monthly/quarterly tiers (where action-oriented findings would be more useful than scored snapshots). Worth considering when the checkup spec is next revisited.
