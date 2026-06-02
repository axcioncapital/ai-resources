# Critical Resources — Operational Backbone Manifest
_Generated: 2026-06-01 · New = introduced on/after 2026-05-02 (cutoff: 30 days)_
> ⚠ Tier-1 source risk-topology.md last_updated 2026-04-30 · 6 command(s) postdate it — Tier-1 completeness not guaranteed for: /session-start, /consult, /log-sweep, /handoff, /drift-check, /decide

## Tier 1 — Critical (system-wide / multi-project blast radius)

### Established
- [/friday-checkup](.claude/commands/friday-checkup.md) — refs: 12 · since 2026-04-22 · why: orchestrates the entire maintenance cadence (risk-topology § 1 Critical)
- [/qc-pass](.claude/commands/qc-pass.md) — refs: 11 · since 2026-04-06 · why: quality gate in every QC loop; 3-project reach (risk-topology § 2; system-doc § 4.5 session-quality loop)
- [/friday-act](.claude/commands/friday-act.md) — refs: 9 · since 2026-04-25 · why: closes the weekly-health loop (risk-topology § 2; system-doc § 4.5)
- [/new-project](.claude/commands/new-project.md) — refs: 5 · since 2026-04-01 · why: orchestrates project creation across 3 projects (risk-topology § 2 reverse map)

### New
None.

## Tier 2 — High (session-spine / invoke-density)

### Established
- [/wrap-session](.claude/commands/wrap-session.md) — refs: 17 · since 2026-04-06 · why: session-end spine; one-way flow + `.prime-mtime` contract (system-doc § 4.5; risk-topology § 1 High)
- [/risk-check](.claude/commands/risk-check.md) — refs: 13 · since 2026-04-24 · why: structural-change gate (system-doc § 4.5 architectural-change loop)
- [/friction-log](.claude/commands/friction-log.md) — refs: 12 · since 2026-04-06 · why: session-improvement loop entry (system-doc § 4.5)
- [/prime](.claude/commands/prime.md) — refs: 9 · since 2026-04-06 · why: session-start spine; `.prime-mtime` writer (risk-topology § 1 High)
- [/create-skill](.claude/commands/create-skill.md) — refs: 8 · since 2026-02-20 · why: skill-creation pipeline hub (invoke-density) `[computed-fresh]`
- [/resolve-improvement-log](.claude/commands/resolve-improvement-log.md) — refs: 7 · since 2026-04-30 · why: invoke-density 7 `[computed-fresh]`
- [/session-plan](.claude/commands/session-plan.md) — refs: 6 · since 2026-04-30 · why: session planning (session-rituals lifecycle)
- [/usage-analysis](.claude/commands/usage-analysis.md) — refs: 5 · since 2026-04-06 · why: session-end telemetry (session-rituals lifecycle)
- [/improve](.claude/commands/improve.md) — refs: 5 · since 2026-04-06 · why: session-improvement loop (system-doc § 4.5)
- [/improve-skill](.claude/commands/improve-skill.md) — refs: 5 · since 2026-02-20 · why: invoke-density 5 `[computed-fresh]`
- [/repo-dd](.claude/commands/repo-dd.md) — refs: 4 · since 2026-04-06 · why: repo-health audit loop (system-doc § 4.5)
- [/graduate-resource](.claude/commands/graduate-resource.md) — refs: 4 · since 2026-04-06 · why: invoke-density 4 `[computed-fresh]`
- [/deploy-workflow](.claude/commands/deploy-workflow.md) — refs: 4 · since 2026-04-03 · why: invoke-density 4 `[computed-fresh]`
- [/coach](.claude/commands/coach.md) — refs: 3 · since 2026-04-06 · why: cross-session collaboration review (session-rituals lifecycle)

### New
- [/session-start](.claude/commands/session-start.md) — refs: 8 · since 2026-05-05 · why: mandate capture; `.prime-mtime` reader (risk-topology § 1 High)
- [/handoff](.claude/commands/handoff.md) — refs: 5 · since 2026-05-22 · why: session continuity (invoke-density) `[computed-fresh]`
- [/log-sweep](.claude/commands/log-sweep.md) — refs: 5 · since 2026-05-08 · why: invoke-density 5 `[computed-fresh]`
- [/decide](.claude/commands/decide.md) — refs: 4 · since 2026-05-27 · why: invoke-density 4 `[computed-fresh]`
- [/drift-check](.claude/commands/drift-check.md) — refs: 4 · since 2026-05-22 · why: invoke-density 4 `[computed-fresh]`
- [/consult](.claude/commands/consult.md) — refs: 4 · since 2026-05-05 · why: invoke-density 4 `[computed-fresh]`

## Excluded from backbone
- 45 commands did not meet the inclusion filter. (Run `/list-critical-resources full` to list them.)

---
4 Critical + 20 High backbone resources — 6 new, 18 established.
