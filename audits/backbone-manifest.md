# Critical Resources — Operational Backbone Manifest
_Generated: 2026-06-02 · New (introduced on/after 2026-05-03, 30d) tagged [new] · pool: 70 commands, 33 agents, 17 hooks, 78 skills, 7 config-docs_

> ⚠ Tier-1 source risk-topology.md last_updated 2026-04-30 · 9 resource(s) postdate it — Tier-1 completeness not guaranteed for: session-start, build-context, handoff, monday-prep, placement (commands); context-discovery, system-owner (agents); detect-concurrent-session.sh (hook); handoff (skill)

> ⚠ Scan coverage: 25 of 70 commands were ref-scanned. Ten commands (audit-claude-md, permission-sweep, log-sweep, resolve-improvement-log, cleanup-worktree, innovation-sweep, friday-journal, friday-so, systems-review, open-items) appear in fan-out chains of multiple Tier-1 commands but were not ref-scanned; they likely qualify as Tier-2 backbone. Excluded command count may be ~35, not 45.

---

## Commands
### Tier 1 — Critical
- [/wrap-session](.claude/commands/wrap-session.md) — refs: 35 · fan-out: 11 · since 2026-04-06 · why: refs=35 ≥ 8; pipeline hub drives coach, improve, usage-analysis, innovation-sweep, log-sweep, resolve-improvement-log, risk-check, session-start, prime, handoff, contract-check; lifecycle (session end) [computed-fresh]
- [/friday-checkup](.claude/commands/friday-checkup.md) — refs: 29 · fan-out: 13 · since 2026-04-22 · why: §1 Critical named; pipeline hub drives audit-repo, coach, friday-act, improve, log-sweep, repo-dd, resolve-improvement-log, risk-check, token-audit, wrap-session + 3 others
- [/qc-pass](.claude/commands/qc-pass.md) — refs: 26 · fan-out: 1 · since 2026-04-06 · why: §2 reverse-map named; refs=26 ≥ 8; drives qc-reviewer (Tier-1 agent); quality gate across 3+ projects
- [/new-project](.claude/commands/new-project.md) — refs: 27 · fan-out: 12 · since 2026-04-01 · why: §2 reverse-map named; pipeline hub drives pipeline-stage-3a–5, session-guide-generator, repo-dd, risk-check, prime, wrap-session
- [/prime](.claude/commands/prime.md) — refs: 25 · fan-out: 10 · since 2026-04-06 · why: refs=25 ≥ 8; lifecycle (session start); fan-out drives session-plan, session-start, qc-pass, risk-check, wrap-session + 5 others [computed-fresh]
- [/friday-act](.claude/commands/friday-act.md) — refs: 23 · fan-out: 9 · since 2026-04-25 · why: §2 reverse-map named; pipeline hub drives cleanup-worktree, friday-journal, friday-so, qc-pass, resolve-improvement-log, risk-check, systems-review, wrap-session
- [/risk-check](.claude/commands/risk-check.md) — refs: 23 · fan-out: — · since 2026-04-24 · why: refs=23 ≥ 8; required change gate cited in CLAUDE.md, audit-discipline.md, and 15+ commands [computed-fresh]
- [/audit-repo](.claude/commands/audit-repo.md) — refs: 21 · fan-out: — · since 2026-04-06 · why: refs=21 ≥ 8 [computed-fresh]
- [/create-skill](.claude/commands/create-skill.md) — refs: 20 · fan-out: — · since 2026-02-20 · why: refs=20 ≥ 8; canonical pipeline for all skill creation [computed-fresh]
- [/repo-dd](.claude/commands/repo-dd.md) — refs: 18 · fan-out: 10 · since 2026-04-06 · why: refs=18 ≥ 8; drives repo-dd-auditor, dd-extract-agent, dd-log-sweep-agent + 7 others [computed-fresh]
- [/session-plan](.claude/commands/session-plan.md) — refs: 18 · fan-out: — · since 2026-04-30 · why: refs=18 ≥ 8; lifecycle (session start) [computed-fresh]
- [/improve](.claude/commands/improve.md) — refs: 17 · fan-out: — · since 2026-04-06 · why: refs=17 ≥ 8; lifecycle (session end) [computed-fresh]
- [/improve-skill](.claude/commands/improve-skill.md) — refs: 16 · fan-out: — · since 2026-02-20 · why: refs=16 ≥ 8; canonical pipeline for all skill improvement [computed-fresh]
- [/session-start](.claude/commands/session-start.md) — refs: 16 · fan-out: 9 · since 2026-05-05 · why: refs=16 ≥ 8; lifecycle (Phase 3 harness start); fan-out drives build-context, context-discovery, prime, wrap-session + 5 others [computed-fresh] [new]
- [/usage-analysis](.claude/commands/usage-analysis.md) — refs: 13 · fan-out: — · since 2026-04-06 · why: refs=13 ≥ 8; lifecycle (session end); telemetry baseline for token-audit R14 [computed-fresh]
- [/triage](.claude/commands/triage.md) — refs: 11 · fan-out: — · since 2026-04-06 · why: refs=11 ≥ 8; QC→Triage auto-loop member [computed-fresh]
- [/token-audit](.claude/commands/token-audit.md) — refs: 11 · fan-out: 3 · since 2026-04-18 · why: refs=11 ≥ 8; drives token-audit-auditor and token-audit-auditor-mechanical [computed-fresh]
- [/coach](.claude/commands/coach.md) — refs: 10 · fan-out: — · since 2026-04-06 · why: refs=10 ≥ 8; lifecycle (session end) [computed-fresh]

### Tier 2 — High
- [/resolve](.claude/commands/resolve.md) — refs: 7 · fan-out: — · since 2026-04-29 · why: refs=7 ≥ 4; post-QC triage translation step [computed-fresh]
- [/placement](.claude/commands/placement.md) — refs: 6 · fan-out: — · since 2026-05-28 · why: refs=6 ≥ 4; structural placement gate before any new file [computed-fresh] [new]
- [/session-guide](.claude/commands/session-guide.md) — refs: 6 · fan-out: — · since 2026-04-03 · why: refs=6 ≥ 4 [computed-fresh]
- [/refinement-pass](.claude/commands/refinement-pass.md) — refs: 5 · fan-out: — · since 2026-04-06 · why: refs=5 ≥ 4 [computed-fresh]
- [/handoff](.claude/commands/handoff.md) — refs: 5 · fan-out: — · since 2026-05-22 · why: refs=5 ≥ 4; session-state preservation [computed-fresh] [new]
- [/build-context](.claude/commands/build-context.md) — refs: 4 · fan-out: — · since 2026-05-29 · why: refs=4 ≥ 4; fan-out coupling — primary invoker of context-discovery (Tier-1 agent) [computed-fresh] [fanout] [new]
- [/monday-prep](.claude/commands/monday-prep.md) — refs: 4 · fan-out: — · since 2026-05-05 · why: refs=4 ≥ 4; week-start orientation ritual [computed-fresh] [new]

---

## Agents
### Tier 1 — Critical
- [system-owner](.claude/agents/system-owner.md) — refs: 22 · since 2026-05-05 · why: refs=22 ≥ 4 (TIER1_AGENT); cross-cutting architectural persona referenced across audit, advisory, and review commands [computed-fresh] [new]
- [qc-reviewer](.claude/agents/qc-reviewer.md) — refs: 11 · since 2026-04-06 · why: §1 High named; §2 reverse-map named; refs=11 ≥ 4; drives every /qc-pass invocation
- [triage-reviewer](.claude/agents/triage-reviewer.md) — refs: 9 · since 2026-04-06 · why: §1 High named; §2 reverse-map named; refs=9 ≥ 4; auto-spawned on every QC findings batch
- [session-guide-generator](.claude/agents/session-guide-generator.md) — refs: 8 · since 2026-04-03 · why: refs=8 ≥ 4; dispatched by /session-guide and /new-project Stage 6 [computed-fresh]
- [improvement-analyst](.claude/agents/improvement-analyst.md) — refs: 5 · since 2026-04-06 · why: refs=5 ≥ 4; dispatched by /improve at every session end [computed-fresh]
- [context-discovery](.claude/agents/context-discovery.md) — refs: 5 · since 2026-05-29 · why: refs=5 ≥ 4; dispatched by /build-context and /session-start; context-pack generation engine [computed-fresh] [new]
- [repo-dd-auditor](.claude/agents/repo-dd-auditor.md) — refs: 5 · since 2026-04-06 · why: refs=5 ≥ 4; primary executor of /repo-dd factual audit [computed-fresh]
- [token-audit-auditor](.claude/agents/token-audit-auditor.md) — refs: 5 · since 2026-04-18 · why: refs=5 ≥ 4; judgment tier of /token-audit [computed-fresh]
- [pipeline-stage-3a](.claude/agents/pipeline-stage-3a.md) — refs: 4 · since 2026-04-01 · why: refs=4 ≥ 4; /new-project Stage 3a repo-inventory [computed-fresh]

### Tier 2 — High
- [pipeline-stage-3c](.claude/agents/pipeline-stage-3c.md) — refs: 3 · since 2026-04-01 · why: refs=3 ≥ 2 (DENSITY_FLOOR_AGENT); /new-project Stage 3c implementation-spec [computed-fresh]
- [token-audit-auditor-mechanical](.claude/agents/token-audit-auditor-mechanical.md) — refs: 3 · since — · why: refs=3 ≥ 2; mechanical measurement tier of /token-audit [computed-fresh]
- [pipeline-stage-3b](.claude/agents/pipeline-stage-3b.md) — refs: 2 · since 2026-04-01 · why: refs=2 ≥ 2; /new-project Stage 3b architecture design [computed-fresh]
- [pipeline-stage-4](.claude/agents/pipeline-stage-4.md) — refs: 2 · since 2026-04-01 · why: refs=2 ≥ 2; /new-project Stage 4 implementation execution [computed-fresh]
- [pipeline-stage-5](.claude/agents/pipeline-stage-5.md) — refs: 2 · since 2026-04-01 · why: refs=2 ≥ 2; /new-project Stage 5 verification [computed-fresh]

---

## Hooks
### Tier 1 — Critical
- [auto-sync-shared.sh](.claude/hooks/auto-sync-shared.sh) — refs: 6 · event: SessionStart · since 2026-04-07 · why: §1 Critical + §2 named; distributes commands/agents to ALL project sessions — failure = system-wide resource loss

### Tier 2 — High
- [friday-checkup-reminder.sh](.claude/hooks/friday-checkup-reminder.sh) — refs: 4 · event: SessionStart · since 2026-04-22 · why: wired settings.json (SessionStart); nudges Friday cadence at every session start [computed-fresh]
- [friction-log-auto.sh](.claude/hooks/friction-log-auto.sh) — refs: 4 · event: PreToolUse (Skill) · since 2026-04-27 · why: wired settings.json (PreToolUse); fires on every Skill invocation [computed-fresh]
- [log-write-activity.sh](.claude/hooks/log-write-activity.sh) — refs: — · event: PostToolUse (Write|Edit) · since 2026-04-27 · why: wired settings.json (PostToolUse); write-telemetry backbone; fires on every file write [computed-fresh]
- [auto-qc-nudge.sh](.claude/hooks/auto-qc-nudge.sh) — refs: 2 · event: PostToolUse (Write|Edit) · since 2026-04-29 · why: wired settings.json (PostToolUse); QC-gate enforcement on significant artifact writes [computed-fresh]
- [detect-concurrent-session.sh](.claude/hooks/detect-concurrent-session.sh) — refs: 3 · event: SessionStart · since 2026-06-01 · why: wired settings.json (SessionStart); concurrent-session safety guard [computed-fresh] [new]
- [check-stop-reminders.sh](.claude/hooks/check-stop-reminders.sh) — refs: 1 · event: Stop · since 2026-04-18 · why: wired settings.json (Stop); session-end reminder system [computed-fresh]
- [coach-reminder.sh](.claude/hooks/coach-reminder.sh) — refs: — · event: Stop · since 2026-04-27 · why: wired settings.json (Stop); fires at every session end [computed-fresh]
- [improve-reminder.sh](.claude/hooks/improve-reminder.sh) — refs: — · event: Stop · since 2026-04-27 · why: wired settings.json (Stop); fires at every session end [computed-fresh]
- [auto-resolve-nudge.sh](.claude/hooks/auto-resolve-nudge.sh) — refs: — · event: Stop · since 2026-04-29 · why: wired settings.json (Stop); QC-findings resolution nudge [computed-fresh]
- [check-heavy-tool.sh](.claude/hooks/check-heavy-tool.sh) — refs: 1 · event: PreToolUse (Read|Grep|Bash) · since 2026-04-18 · why: wired settings.json (PreToolUse); fires on virtually every tool call [computed-fresh]

---

## Skills
### Tier 1 — Critical
- [ai-resource-builder](skills/ai-resource-builder/SKILL.md) — refs: 6 · fan-out: — · since 2026-04-05 · why: refs=6 ≥ 5 (TIER1_SKILL); canonical methodology for /create-skill and /improve-skill — both read this SKILL.md at invocation [computed-fresh]
- [handoff](skills/handoff/SKILL.md) — refs: 5 · fan-out: — · since 2026-05-22 · why: refs=5 ≥ 5 (TIER1_SKILL); session-state preservation methodology [computed-fresh] [new]

### Tier 2 — High
- [repo-health-analyzer](skills/repo-health-analyzer/SKILL.md) — refs: 2 · fan-out: — · since 2026-04-01 · why: refs=2 ≥ 2 (DENSITY_FLOOR_SKILL) [computed-fresh]
- [session-usage-analyzer](skills/session-usage-analyzer/SKILL.md) — refs: 2 · fan-out: — · since 2026-03-30 · why: refs=2 ≥ 2; telemetry baseline methodology for token-audit R14 [computed-fresh]

---

## Config & Docs
### Tier 1 — Critical
- [CLAUDE.md (workspace)](../CLAUDE.md) — refs: — · since 2026-04-17 · why: §1 Critical + §2 named; loads every session; governs autonomy rules, QC loop, pause triggers across all 7+ projects
- [CLAUDE.md (ai-resources)](CLAUDE.md) — refs: — · since 2026-02-18 · why: §1 Critical named; loads with every --add-dir session; governs resource creation, skill library conventions
- [settings.json (workspace)](../.claude/settings.json) — refs: — · since 2026-04-17 · why: §1 Critical named; controls permissions for all workspace sessions — misconfiguration = sessions non-functional

### Tier 2 — High
- [settings.json (ai-resources)](.claude/settings.json) — refs: — · since 2026-04-06 · why: curated set; wires all 10 Tier-2 hooks + auto-sync-shared.sh; governs ai-resources session behavior [computed-fresh]
- [principles.md](../projects/repo-documentation/vault/principles/principles.md) — refs: — · since — · why: §1 High named; W2.2 accountability scans target its `### OP-N —` anchors — rename breaks them silently
- [audit-discipline.md](docs/audit-discipline.md) — refs: — · since 2026-04-20 · why: §1 High named; governs /risk-check behavior and DR-8/DR-9 change gates
- [documentation-structure.md](../projects/repo-documentation/references/documentation-structure.md) — refs: — · since 2026-04-25 · why: §1 High named; W2.1 parser schema for component registries [computed-fresh]

---

## Excluded from backbone
- 144 resources did not meet the inclusion filter (45 commands, 19 agents, 6 hooks, 74 skills, 0 config-docs). (Run `/list-critical-resources full` to list them.)
- Note: ~10 unscanned commands (audit-claude-md, permission-sweep, log-sweep, resolve-improvement-log, cleanup-worktree, innovation-sweep, friday-journal, friday-so, systems-review, open-items) appear in fan-out chains of Tier-1 commands and likely qualify as Tier-2 backbone — excluded only because ref counts were not gathered. Actual excluded command count is likely closer to 35.

---

61 backbone resources across 5 types — 33 Tier-1, 28 Tier-2, 9 new.
