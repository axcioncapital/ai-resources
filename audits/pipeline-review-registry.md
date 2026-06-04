# Pipeline Review Registry

> **Purpose:** Tracks the critical resources reviewed by `/pipeline-review` and when each was last given the deep design treatment. Single source of truth for `/pipeline-review` after the deprecation of `/audit-critical-resources` and its `critical-resources-manifest.md` on 2026-05-29 (drift-detection currency-check was folded into the pipeline-review-auditor's Brokenness section). The registry covers multi-step orchestrator pipelines, closed-loop choke points, and simpler critical commands that lived in the deleted manifest.

## Registry contract

- **Columns (6, fixed):** `Pipeline` (path, relative to `ai-resources/`) · `Type` (command / skill) · `Tier` (weekly / quarterly) · `Last reviewed` (`YYYY-MM-DD` or `never`) · `Last memo` (`YYYY-MM-DD` resolving to `audits/pipeline-reviews/{pipeline-slug}-{YYYY-MM-DD}.md`, or `—`) · `Friction flag` (Y / N).
- **Two tiers, one auditor.** The `pipeline-review-auditor` body is unchanged across tiers. Weekly rows expect the full memo template; quarterly rows produce a lighter Innovations/Leanness section and a richer Brokenness (currency-check) section. The cadence-versus-cost mapping is the only difference.
- **Weekly tier** rotates on the normal `/pipeline-review` cadence (every Friday cycle). With ~30 weekly entries and a 1–3-pick/cycle cap, the average per-pipeline rotation is ~10–14 weeks (≈quarterly). This is the right frequency for "what could be better" questions on load-bearing critical infrastructure.
- **Quarterly tier** is only shortlisted on the first Friday of January, April, July, and October — mirrors `/friday-checkup`'s quarterly tier system. Outside those windows, quarterly rows are invisible to the shortlist build (operator can still override via `$ARGUMENTS`).
- **Date-key, not path-key.** The `Last memo` column carries a date that the consumer resolves to a path via the convention above — per System Owner's `risk-topology.md § 1` warning about brittle two-end contracts.
- **Tiebreak rule:** Within a tier, when two or more rows share the same `Last reviewed` value (including the cold-start case where all are `never`), sort by `Pipeline` column alphabetically. Friction-flagged rows are promoted to the top regardless of date, and tiebreak alphabetically among themselves.
- **Audit-trail-grade writes.** This file is updated by `/pipeline-review` once per cycle after subagents return. The bumped row preserves the prior `Last reviewed` only via git history — manual reverts are not clean.
- **`Friction flag` is operator-manual at v1.** When a friction-log entry names a pipeline tracked here, set its `Friction flag` to `Y` manually. The flag remains `Y` until the next `/pipeline-review` cycle reviews that pipeline (the command resets it to `N` on bump). Friday-cadence reminder: scan recent friction-log additions during `/friday-checkup` and set flags for any newly-named pipelines. Automating this via a friction-log hook is deferred — re-evaluate if manual-set proves to drift silently.

## Pipelines

| Pipeline | Type | Tier | Last reviewed | Last memo | Friction flag |
|---|---|---|---|---|---|
| `.claude/commands/architecture-review.md` | command | weekly | 2026-06-04 | 2026-06-04 | N |
| `.claude/commands/audit-claude-md.md` | command | weekly | never | — | N |
| `.claude/commands/audit-repo.md` | command | weekly | never | — | N |
| `.claude/commands/consult.md` | command | weekly | 2026-06-04 | 2026-06-04 | N |
| `.claude/commands/contract-check.md` | command | weekly | 2026-05-29 | 2026-05-29 | N |
| `.claude/commands/create-skill.md` | command | weekly | never | — | N |
| `.claude/commands/friday-act.md` | command | weekly | never | — | N |
| `.claude/commands/friday-checkup.md` | command | weekly | never | — | N |
| `.claude/commands/friday-journal.md` | command | weekly | never | — | N |
| `.claude/commands/friday-so.md` | command | weekly | 2026-06-04 | 2026-06-04 | N |
| `.claude/commands/improve-skill.md` | command | weekly | never | — | N |
| `.claude/commands/monday-prep.md` | command | weekly | never | — | N |
| `.claude/commands/new-project.md` | command | weekly | never | — | N |
| `.claude/commands/permission-sweep.md` | command | weekly | never | — | N |
| `.claude/commands/pipeline-review.md` | command | weekly | 2026-05-29 | 2026-05-29 | N |
| `.claude/commands/prime.md` | command | weekly | 2026-05-29 | 2026-05-29 | N |
| `.claude/commands/qc-pass.md` | command | weekly | 2026-06-04 | 2026-06-04 | N |
| `.claude/commands/recommend.md` | command | weekly | never | — | N |
| `.claude/commands/repo-dd.md` | command | weekly | never | — | N |
| `.claude/commands/resolve.md` | command | weekly | never | — | N |
| `.claude/commands/resolve-repo-problem.md` | command | weekly | never | — | N |
| `.claude/commands/risk-check.md` | command | weekly | never | — | N |
| `.claude/commands/session-plan.md` | command | weekly | never | — | N |
| `.claude/commands/session-start.md` | command | weekly | 2026-05-29 | 2026-05-29 | N |
| `.claude/commands/so-monthly.md` | command | weekly | 2026-06-04 | 2026-06-04 | N |
| `.claude/commands/token-audit.md` | command | weekly | never | — | N |
| `.claude/commands/triage.md` | command | weekly | never | — | N |
| `.claude/commands/wrap-session.md` | command | weekly | 2026-05-29 | 2026-05-29 | N |
| `skills/context-pack-builder/SKILL.md` | skill | weekly | never | — | N |
| `skills/implementation-project-planner/SKILL.md` | skill | weekly | never | — | N |
| `skills/implementation-spec-writer/SKILL.md` | skill | weekly | never | — | N |
| `.claude/commands/analyze-workflow.md` | command | quarterly | never | — | N |
| `.claude/commands/cleanup-worktree.md` | command | quarterly | never | — | N |
| `.claude/commands/deploy-kb.md` | command | quarterly | never | — | N |
| `.claude/commands/deploy-workflow.md` | command | quarterly | never | — | N |
| `.claude/commands/drift-check.md` | command | quarterly | never | — | N |
| `.claude/commands/fix-repo-issues.md` | command | quarterly | never | — | N |
| `.claude/commands/friction-log.md` | command | quarterly | 2026-05-29 | 2026-05-29 | N |
| `.claude/commands/graduate-resource.md` | command | quarterly | never | — | N |
| `.claude/commands/implementation-triage.md` | command | quarterly | never | — | N |
| `.claude/commands/migrate-skill.md` | command | quarterly | never | — | N |
| `.claude/commands/placement.md` | command | quarterly | never | — | N |
| `.claude/commands/resolve-improvement-log.md` | command | quarterly | never | — | N |
| `.claude/commands/resolve-incident.md` | command | quarterly | never | — | N |
| `.claude/commands/sync-workflow.md` | command | quarterly | never | — | N |
| `.claude/commands/systems-review.md` | command | quarterly | 2026-06-04 | 2026-06-04 | N |
| `.claude/commands/usage-analysis.md` | command | quarterly | never | — | N |

## Tier rationale

**Weekly (31 entries):** Friday cadence partners (7), QC loop (4), audit pipelines (4), orchestrators (7), creation pipeline (2), advisors (2), other critical (2 — includes `recommend` per operator decision), skills (3). All meet both halves of the selection criterion: load-bearing per `risk-topology.md § 1` OR closed-loop choke point per `system-doc.md § 4.5`, AND multi-step OR Anthropic-currency-dependent.

**Quarterly (16 entries):** Single-step utilities, slow-changing infrastructure, and rarely-invoked but high-cost-of-decay pipelines. Weekly review yields little per cycle; the auditor's Brokenness (currency-check) section does most of the per-row work.

**Selection criterion (made explicit):** A pipeline earns weekly tier when **both** of: (i) `risk-topology.md § 1` classifies it Critical/High OR it sits at a closed feedback loop's choke point (`system-doc.md § 4.5`), AND (ii) it is multi-step / orchestration-shaped OR Anthropic-currency-dependent. Single-step utilities that are critical but stable go to quarterly.

**Origin:** Tiered shape adopted from System Owner advisory `projects/axcion-ai-system-owner/output/advisories/2026-05-29-pipeline-review-registry-scope.md`. Operator overrides applied: `recommend` added to weekly (SO had recommended SKIP). The `friction-log` weekly-tier override was reverted to quarterly on 2026-05-29 after the cycle-2 pipeline-review memo confirmed the SO's original quarterly recommendation was right (the contract-risk that justifies weekly attention lives in the hook + sibling-command, not in the command body itself).
