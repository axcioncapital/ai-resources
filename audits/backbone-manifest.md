# Critical Resources — Operational Backbone Manifest
_Generated: 2026-07-02 · New (introduced on/after 2026-06-02, 30d) tagged [new] · pool: 84 commands, 40 agents, 18 hooks, 80 skills, 7 config-docs_
> ⚠ Tier-1 source risk-topology.md last_updated 2026-04-30 · 50 resource(s) postdate it — Tier-1 completeness not guaranteed for: commands: build-context, concurrent-session-check, consult, contract-check, decide, deploy-kb, drift-check, expert-check, fix-project-issues, fix-repo-issues, fix-symlinks, friday-journal, friday-so, grill-me, handoff, implementation-triage, log-sweep, mission, monday-prep, open-items, pipeline-review, placement, pm, promote-workflow, resolve-incident, resolve-repo-problem, scope-project, so-monthly, systems-review; agents: context-discovery, diagnostics-scanner, expert-check-reviewer, fading-gate-scanner, findings-extractor, fix-repo-issues-scanner, friday-act-16a-summarizer, log-sweep-auditor, pipeline-review-auditor, project-manager, scope-architecture-agent, scope-qc-evaluator, scope-synthesis-agent, session-feedback-collector, system-owner; hooks: backup-session-plan.sh, check-foreign-staging.sh, detect-concurrent-session.sh; skills: grill-me, handoff, project-scoping

## Commands
### Tier 1 — Critical
- [/wrap-session](.claude/commands/wrap-session.md) — refs: 44 · fan-out: 19 · since 2026-04-06 · why: session-end lifecycle ritual; highest fan-in in the corpus [computed-fresh]
- [/prime](.claude/commands/prime.md) — refs: 40 · fan-out: 15 · since 2026-04-06 · why: session-start lifecycle ritual; reference-scan 40 [computed-fresh]
- [/friction-log](.claude/commands/friction-log.md) — refs: 38 · fan-out: 1 · since 2026-04-06 · why: reference-scan 38 — feeds the improvement loop from every session [computed-fresh]
- [/friday-checkup](.claude/commands/friday-checkup.md) — refs: 37 · fan-out: 22 · since 2026-04-22 · why: risk-topology §1 Critical — orchestrates the entire Friday maintenance cadence
- [/qc-pass](.claude/commands/qc-pass.md) — refs: 35 · fan-out: 4 · since 2026-04-06 · why: risk-topology §2 reverse map — QC gate on every substantive artifact
- [/new-project](.claude/commands/new-project.md) — refs: 32 · fan-out: 16 · since 2026-04-01 · why: risk-topology §2 reverse map — project pipeline spine driving 5 pipeline-stage agents
- [/risk-check](.claude/commands/risk-check.md) — refs: 30 · fan-out: 5 · since 2026-04-24 · why: reference-scan 30 — structural-change gate cited across the corpus [computed-fresh]
- [/friday-act](.claude/commands/friday-act.md) — refs: 27 · fan-out: 12 · since 2026-04-25 · why: risk-topology §2 reverse map — Friday fix-session orchestrator
- [/audit-repo](.claude/commands/audit-repo.md) — refs: 22 · fan-out: 2 · since 2026-04-06 · why: reference-scan 22 — workspace health audit entry point [computed-fresh]
- [/session-start](.claude/commands/session-start.md) — refs: 21 · fan-out: 9 · since 2026-05-05 · why: Phase-3 lifecycle ritual; reference-scan 21 [computed-fresh]
- [/session-plan](.claude/commands/session-plan.md) — refs: 21 · fan-out: 8 · since 2026-04-30 · why: session-start lifecycle ritual; reference-scan 21 [computed-fresh]
- [/create-skill](.claude/commands/create-skill.md) — refs: 20 · fan-out: 2 · since 2026-02-20 · why: reference-scan 20 — canonical skill-creation pipeline [computed-fresh]
- [/repo-dd](.claude/commands/repo-dd.md) — refs: 19 · fan-out: 15 · since 2026-04-06 · why: reference-scan 19 — full due-diligence audit pipeline [computed-fresh]
- [/improve](.claude/commands/improve.md) — refs: 19 · fan-out: 2 · since 2026-04-06 · why: session-end lifecycle ritual; reference-scan 19 [computed-fresh]
- [/improve-skill](.claude/commands/improve-skill.md) — refs: 17 · fan-out: 1 · since 2026-02-20 · why: reference-scan 17 — canonical skill-improvement pipeline [computed-fresh]
- [/friday-so](.claude/commands/friday-so.md) — refs: 16 · fan-out: 3 · since 2026-05-06 · why: reference-scan 16 — SO advisory step of the Friday cadence [computed-fresh]
- [/graduate-resource](.claude/commands/graduate-resource.md) — refs: 16 · fan-out: 0 · since 2026-04-06 · why: reference-scan 16 — project-to-canonical promotion path [computed-fresh]
- [/consult](.claude/commands/consult.md) — refs: 14 · fan-out: 6 · since 2026-05-05 · why: reference-scan 14 — canonical System Owner consultation entry point [computed-fresh]
- [/usage-analysis](.claude/commands/usage-analysis.md) — refs: 14 · fan-out: 1 · since 2026-04-06 · why: session-end lifecycle ritual; reference-scan 14 [computed-fresh]
- [/permission-sweep](.claude/commands/permission-sweep.md) — refs: 13 · fan-out: 5 · since 2026-04-24 · why: reference-scan 13 — permission failure-mode diagnostics [computed-fresh]
- [/resolve-improvement-log](.claude/commands/resolve-improvement-log.md) — refs: 12 · fan-out: 4 · since 2026-04-30 · why: reference-scan 12 — improvement-log archival in the Friday loop [computed-fresh]
- [/token-audit](.claude/commands/token-audit.md) — refs: 12 · fan-out: 3 · since 2026-04-18 · why: reference-scan 12 — token-efficiency audit pipeline [computed-fresh]
- [/innovation-sweep](.claude/commands/innovation-sweep.md) — refs: 11 · fan-out: 3 · since 2026-04-27 · why: reference-scan 11 — project-end innovation triage [computed-fresh]
- [/coach](.claude/commands/coach.md) — refs: 11 · fan-out: 2 · since 2026-04-06 · why: session-end lifecycle ritual; reference-scan 11 [computed-fresh]
- [/triage](.claude/commands/triage.md) — refs: 11 · fan-out: 2 · since 2026-04-06 · why: reference-scan 11 — prioritization step of the QC auto-loop [computed-fresh]
- [/open-items](.claude/commands/open-items.md) — refs: 11 · fan-out: 1 · since 2026-05-11 · why: reference-scan 11 — backlog surfacing consumed by prime/session flows [computed-fresh]
- [/deploy-workflow](.claude/commands/deploy-workflow.md) — refs: 10 · fan-out: 4 · since 2026-04-03 · why: reference-scan 10 — workflow-template deployment path [computed-fresh]
- [/resolve](.claude/commands/resolve.md) — refs: 10 · fan-out: 3 · since 2026-04-29 · why: reference-scan 10 — QC-findings disposition step [computed-fresh]
- [/drift-check](.claude/commands/drift-check.md) — refs: 10 · fan-out: 2 · since 2026-05-22 · why: reference-scan 10 — mandate-vs-trajectory guardrail [computed-fresh]
- [/contract-check](.claude/commands/contract-check.md) — refs: 9 · fan-out: 4 · since 2026-05-27 · why: reference-scan 9 — cumulative-drift conformance gate [computed-fresh]
- [/implementation-triage](.claude/commands/implementation-triage.md) — refs: 9 · fan-out: 3 · since 2026-05-06 · why: reference-scan 9 — ROI worth-doing verdict cited by many pipelines [computed-fresh]
- [/log-sweep](.claude/commands/log-sweep.md) — refs: 9 · fan-out: 3 · since 2026-05-08 · why: reference-scan 9 — cross-project log archival [computed-fresh]
- [/analyze-workflow](.claude/commands/analyze-workflow.md) — refs: 9 · fan-out: 2 · since 2026-04-07 · why: reference-scan 9 — workflow infrastructure analysis [computed-fresh]
- [/handoff](.claude/commands/handoff.md) — refs: 9 · fan-out: 1 · since 2026-05-22 · why: reference-scan 9 — unified session-handoff mechanism [computed-fresh]
- [/scope](.claude/commands/scope.md) — refs: 9 · fan-out: 1 · since 2026-04-06 · why: reference-scan 9 — scope-summary primitive [computed-fresh]
- [/fix-repo-issues](.claude/commands/fix-repo-issues.md) — refs: 8 · fan-out: 14 · since 2026-05-27 · why: reference-scan 8 — backlog fix-plan composer [computed-fresh]
- [/systems-review](.claude/commands/systems-review.md) — refs: 8 · fan-out: 3 · since 2026-05-06 · why: reference-scan 8 — systems-thinking workspace review [computed-fresh]
- [/sync-workflow](.claude/commands/sync-workflow.md) — refs: 8 · fan-out: 2 · since 2026-04-06 · why: reference-scan 8 — deployed-vs-canonical drift check [computed-fresh]
- [/scope-project](.claude/commands/scope-project.md) — refs: 6 · fan-out: 4 · since 2026-07-01 · why: pipeline hub — drives 3 dedicated backbone scope-stage agents plus the project-scoping skill [computed-fresh] [new]
### Tier 2 — High
- [/friday-journal](.claude/commands/friday-journal.md) — refs: 7 · fan-out: 8 · since 2026-05-08 · why: reference-scan 7 — journal-processing step with internal QC spawn [computed-fresh]
- [/clarify](.claude/commands/clarify.md) — refs: 7 · fan-out: 6 · since 2026-04-06 · why: reference-scan 7 — pre-execution scope alignment [computed-fresh]
- [/cleanup-worktree](.claude/commands/cleanup-worktree.md) — refs: 7 · fan-out: 3 · since 2026-04-13 · why: reference-scan 7 — gated cleanup with QC/triage subagent contract [computed-fresh]
- [/so-monthly](.claude/commands/so-monthly.md) — refs: 7 · fan-out: 3 · since 2026-05-06 · why: reference-scan 7 — monthly SO review tier [computed-fresh]
- [/audit-claude-md](.claude/commands/audit-claude-md.md) — refs: 7 · fan-out: 2 · since 2026-04-20 · why: reference-scan 7 — always-loaded-file audit [computed-fresh]
- [/session-guide](.claude/commands/session-guide.md) — refs: 7 · fan-out: 2 · since 2026-04-03 · why: reference-scan 7 — progress-view generator [computed-fresh]
- [/migrate-skill](.claude/commands/migrate-skill.md) — refs: 7 · fan-out: 1 · since 2026-03-24 · why: reference-scan 7 — canonical Chat-to-Code skill migration [computed-fresh]
- [/refinement-pass](.claude/commands/refinement-pass.md) — refs: 7 · fan-out: 1 · since 2026-04-06 · why: reference-scan 7 — independent refinement review [computed-fresh]
- [/placement](.claude/commands/placement.md) — refs: 6 · fan-out: 8 · since 2026-05-28 · why: reference-scan 6 — placement-discipline routing advisor [computed-fresh]
- [/decide](.claude/commands/decide.md) — refs: 6 · fan-out: 7 · since 2026-05-27 · why: reference-scan 6 — operator-decision disposition [computed-fresh]
- [/deploy-kb](.claude/commands/deploy-kb.md) — refs: 6 · fan-out: 2 · since 2026-05-04 · why: reference-scan 6 — Obsidian KB deployment [computed-fresh]
- [/pipeline-review](.claude/commands/pipeline-review.md) — refs: 5 · fan-out: 6 · since 2026-05-29 · why: reference-scan 5 — audit-pipeline reviewer driving pipeline-review-auditor [computed-fresh]
- [/mission](.claude/commands/mission.md) — refs: 5 · fan-out: 5 · since 2026-06-09 · why: reference-scan 5 — multi-session mission contract lifecycle [computed-fresh] [new]
- [/resolve-repo-problem](.claude/commands/resolve-repo-problem.md) — refs: 5 · fan-out: 5 · since 2026-05-22 · why: reference-scan 5 — repo-fault triage entry [computed-fresh]
- [/fix-project-issues](.claude/commands/fix-project-issues.md) — refs: 5 · fan-out: 2 · since 2026-06-05 · why: reference-scan 5 — spawns diagnostics-scanner + SO vetting [computed-fresh] [new]
- [/note](.claude/commands/note.md) — refs: 5 · fan-out: 2 · since 2026-04-06 · why: reference-scan 5 — workflow-observation capture [computed-fresh]
- [/recommend](.claude/commands/recommend.md) — refs: 5 · fan-out: 2 · since 2026-04-21 · why: reference-scan 5 — proceed-on-judgment primitive [computed-fresh]
- [/build-context](.claude/commands/build-context.md) — refs: 5 · fan-out: 1 · since 2026-05-29 · why: reference-scan 5 — entry point to the context-discovery engine [computed-fresh]
- [/monday-prep](.claude/commands/monday-prep.md) — refs: 5 · fan-out: 1 · since 2026-05-05 · why: reference-scan 5 — weekly orientation cadence [computed-fresh]
- [/grill-me](.claude/commands/grill-me.md) — refs: 5 · fan-out: 0 · since 2026-05-22 · why: reference-scan 5 — pre-plan interrogation gate [computed-fresh]
- [/concurrent-session-check](.claude/commands/concurrent-session-check.md) — refs: 4 · fan-out: 8 · since 2026-06-05 · why: reference-scan 4 — concurrent-session safety check [computed-fresh] [new]
- [/resolve-incident](.claude/commands/resolve-incident.md) — refs: 4 · fan-out: 7 · since 2026-05-28 · why: reference-scan 4 — end-to-end incident fix path [computed-fresh]
- [/request-skill](.claude/commands/request-skill.md) — refs: 4 · fan-out: 2 · since 2026-04-06 · why: reference-scan 4 — skill-gap capture to inbox [computed-fresh]
- [/fix-symlinks](.claude/commands/fix-symlinks.md) — refs: 4 · fan-out: 1 · since 2026-05-16 · why: reference-scan 4 — symlink repair for project references [computed-fresh]
- [/pm](.claude/commands/pm.md) — refs: 3 · fan-out: 2 · since 2026-05-28 · why: primary invoker of the backbone project-manager agent [computed-fresh] [fanout]
- [/expert-check](.claude/commands/expert-check.md) — refs: 2 · fan-out: 1 · since 2026-06-04 · why: sole invoker of the backbone expert-check-reviewer agent [computed-fresh] [fanout] [new]
- [/promote-workflow](.claude/commands/promote-workflow.md) — refs: 0 · fan-out: 4 · since 2026-06-12 · why: fan-out 4 — multi-phase promotion pipeline running risk-check/QC/sync gates [computed-fresh] [new]
- [/refinement-deep](.claude/commands/refinement-deep.md) — refs: 0 · fan-out: 3 · since 2026-04-07 · why: fan-out 3 — spawns qc-reviewer, refinement-reviewer, triage-reviewer in one pass [computed-fresh]

## Agents
### Tier 1 — Critical
- [system-owner](.claude/agents/system-owner.md) — refs: 26 · since 2026-05-05 · why: reference-scan 26 — architectural-judgment agent behind /consult, /friday-so, /architecture-review [computed-fresh]
- [qc-reviewer](.claude/agents/qc-reviewer.md) — refs: 13 · since 2026-04-06 · why: risk-topology §1 High + §2 reverse map — used by every /qc-pass
- [triage-reviewer](.claude/agents/triage-reviewer.md) — refs: 11 · since 2026-04-06 · why: risk-topology §1 High + §2 reverse map — auto-spawned on every QC findings batch
- [session-guide-generator](.claude/agents/session-guide-generator.md) — refs: 9 · since 2026-04-03 · why: reference-scan 9 — progress-view generation for /session-guide and /new-project [computed-fresh]
- [claude-md-auditor](.claude/agents/claude-md-auditor.md) — refs: 8 · since 2026-04-20 · why: reference-scan 8 — CLAUDE.md audit machinery [computed-fresh]
- [context-discovery](.claude/agents/context-discovery.md) — refs: 7 · since 2026-05-29 · why: reference-scan 7 — context-pack engine behind /build-context [computed-fresh]
- [improvement-analyst](.claude/agents/improvement-analyst.md) — refs: 6 · since 2026-04-06 · why: reference-scan 6 — /improve session-friction analysis [computed-fresh]
- [refinement-reviewer](.claude/agents/refinement-reviewer.md) — refs: 6 · since 2026-04-06 · why: reference-scan 6 — /refinement-pass reviewer [computed-fresh]
- [repo-dd-auditor](.claude/agents/repo-dd-auditor.md) — refs: 5 · since 2026-04-06 · why: reference-scan 5 — /repo-dd factual auditor [computed-fresh]
- [token-audit-auditor](.claude/agents/token-audit-auditor.md) — refs: 5 · since 2026-04-18 · why: reference-scan 5 — /token-audit judgment section [computed-fresh]
- [log-sweep-auditor](.claude/agents/log-sweep-auditor.md) — refs: 4 · since 2026-05-08 · why: reference-scan 4 — /log-sweep analysis agent [computed-fresh]
- [pipeline-stage-3a](.claude/agents/pipeline-stage-3a.md) — refs: 4 · since 2026-04-01 · why: reference-scan 4 — /new-project repo-inventory stage [computed-fresh]
- [project-manager](.claude/agents/project-manager.md) — refs: 4 · since 2026-05-28 · why: reference-scan 4 — /pm constitution-doc advisory agent [computed-fresh]
- [scope-architecture-agent](.claude/agents/scope-architecture-agent.md) — refs: 4 · since 2026-07-01 · why: reference-scan 4 — /scope-project Stage-3 judgment gate [computed-fresh] [new]
- [scope-qc-evaluator](.claude/agents/scope-qc-evaluator.md) — refs: 4 · since 2026-07-01 · why: reference-scan 4 — /scope-project Stage-5 consolidated QC [computed-fresh] [new]
- [session-feedback-collector](.claude/agents/session-feedback-collector.md) — refs: 4 · since 2026-06-01 · why: reference-scan 4 — wrap-session feedback machinery [computed-fresh]
### Tier 2 — High
- [dd-log-sweep-agent](.claude/agents/dd-log-sweep-agent.md) — refs: 3 · since 2026-04-18 · why: reference-scan 3 — /repo-dd deep-tier log analysis [computed-fresh]
- [fix-repo-issues-scanner](.claude/agents/fix-repo-issues-scanner.md) — refs: 3 · since 2026-05-27 · why: reference-scan 3 — /fix-repo-issues diagnostics scan [computed-fresh]
- [permission-sweep-auditor](.claude/agents/permission-sweep-auditor.md) — refs: 3 · since 2026-04-24 · why: reference-scan 3 — /permission-sweep settings scan [computed-fresh]
- [pipeline-review-auditor](.claude/agents/pipeline-review-auditor.md) — refs: 3 · since 2026-05-29 · why: reference-scan 3 — /pipeline-review auditor [computed-fresh]
- [pipeline-stage-3c](.claude/agents/pipeline-stage-3c.md) — refs: 3 · since 2026-04-01 · why: reference-scan 3 — /new-project spec-writing stage [computed-fresh]
- [scope-synthesis-agent](.claude/agents/scope-synthesis-agent.md) — refs: 3 · since 2026-07-01 · why: reference-scan 3 — /scope-project Stage-2 consolidation [computed-fresh] [new]
- [token-audit-auditor-mechanical](.claude/agents/token-audit-auditor-mechanical.md) — refs: 3 · since 2026-04-18 · why: reference-scan 3 — /token-audit mechanical sections [computed-fresh]
- [workflow-analysis-agent](.claude/agents/workflow-analysis-agent.md) — refs: 3 · since 2026-04-07 · why: reference-scan 3 — /analyze-workflow Phase 1 [computed-fresh]
- [collaboration-coach](.claude/agents/collaboration-coach.md) — refs: 2 · since 2026-04-06 · why: reference-scan 2 — /coach analysis agent [computed-fresh]
- [dd-extract-agent](.claude/agents/dd-extract-agent.md) — refs: 2 · since 2026-04-18 · why: reference-scan 2 — /repo-dd triage extraction [computed-fresh]
- [diagnostics-scanner](.claude/agents/diagnostics-scanner.md) — refs: 2 · since 2026-06-05 · why: reference-scan 2 — /fix-project-issues scan stage [computed-fresh] [new]
- [expert-check-reviewer](.claude/agents/expert-check-reviewer.md) — refs: 2 · since 2026-06-04 · why: reference-scan 2 — /expert-check independent comparator [computed-fresh] [new]
- [fading-gate-scanner](.claude/agents/fading-gate-scanner.md) — refs: 2 · since 2026-05-25 · why: reference-scan 2 — Friday-cadence gate-decay scan [computed-fresh]
- [findings-extractor](.claude/agents/findings-extractor.md) — refs: 2 · since 2026-05-02 · why: reference-scan 2 — Friday-cadence findings extraction [computed-fresh]
- [friday-act-16a-summarizer](.claude/agents/friday-act-16a-summarizer.md) — refs: 2 · since 2026-05-25 · why: reference-scan 2 — /friday-act summarization step [computed-fresh]
- [innovation-triage-auditor](.claude/agents/innovation-triage-auditor.md) — refs: 2 · since 2026-04-27 · why: reference-scan 2 — /innovation-sweep classifier [computed-fresh]
- [pipeline-stage-3b](.claude/agents/pipeline-stage-3b.md) — refs: 2 · since 2026-04-01 · why: reference-scan 2 — /new-project architecture stage [computed-fresh]
- [pipeline-stage-4](.claude/agents/pipeline-stage-4.md) — refs: 2 · since 2026-04-01 · why: reference-scan 2 — /new-project implementation stage [computed-fresh]
- [pipeline-stage-5](.claude/agents/pipeline-stage-5.md) — refs: 2 · since 2026-04-01 · why: reference-scan 2 — /new-project verification stage [computed-fresh]
- [risk-check-reviewer](.claude/agents/risk-check-reviewer.md) — refs: 2 · since 2026-04-24 · why: reference-scan 2 — /risk-check six-dimension evaluator [computed-fresh]
- [workflow-critique-agent](.claude/agents/workflow-critique-agent.md) — refs: 2 · since 2026-04-07 · why: reference-scan 2 — /analyze-workflow Phase 2 [computed-fresh]

## Hooks
### Tier 1 — Critical
- [auto-sync-shared.sh](.claude/hooks/auto-sync-shared.sh) — refs: 7 · event: SessionStart · since 2026-04-07 · why: risk-topology §1 Critical + §2 — distributes shared commands/agents to all projects every session
### Tier 2 — High
- [pre-commit](.claude/hooks/pre-commit) — refs: 9 · event: — (git pre-commit) · since 2026-02-20 · why: reference-scan 9 — commit-time guard outside settings.json wiring [computed-fresh]
- [detect-concurrent-session.sh](.claude/hooks/detect-concurrent-session.sh) — refs: 7 · event: SessionStart · since 2026-06-01 · why: wired SessionStart (user settings) — concurrent-session detection [computed-fresh]
- [check-foreign-staging.sh](.claude/hooks/check-foreign-staging.sh) — refs: 5 · event: PreToolUse · since 2026-06-09 · why: wired PreToolUse (user settings) — hard-blocks commits over foreign staged state [computed-fresh] [new]
- [friction-log-auto.sh](.claude/hooks/friction-log-auto.sh) — refs: 5 · event: PreToolUse+PostToolUse · since 2026-04-27 · why: wired both tool events — automatic friction capture [computed-fresh]
- [friday-checkup-reminder.sh](.claude/hooks/friday-checkup-reminder.sh) — refs: 4 · event: SessionStart · since 2026-04-22 · why: wired SessionStart — Friday-cadence reminder [computed-fresh]
- [check-permission-sanity.sh](.claude/hooks/check-permission-sanity.sh) — refs: 3 · event: SessionStart · since 2026-04-24 · why: wired SessionStart across project settings [computed-fresh]
- [detect-innovation.sh](.claude/hooks/detect-innovation.sh) — refs: 3 · event: PostToolUse · since 2026-04-06 · why: wired PostToolUse — feeds innovation-registry loop [computed-fresh]
- [auto-qc-nudge.sh](.claude/hooks/auto-qc-nudge.sh) — refs: 2 · event: PostToolUse · since 2026-04-29 · why: wired PostToolUse — QC-loop nudge [computed-fresh]
- [check-heavy-tool.sh](.claude/hooks/check-heavy-tool.sh) — refs: 2 · event: PreToolUse · since 2026-04-18 · why: wired PreToolUse — [HEAVY] guardrail emission [computed-fresh]
- [check-template-drift.sh](.claude/hooks/check-template-drift.sh) — refs: 2 · event: SessionStart · since 2026-04-06 · why: wired SessionStart in deployed-project settings [computed-fresh]
- [log-write-activity.sh](.claude/hooks/log-write-activity.sh) — refs: 2 · event: PostToolUse · since 2026-04-27 · why: wired PostToolUse — write-activity logging [computed-fresh]
- [auto-resolve-nudge.sh](.claude/hooks/auto-resolve-nudge.sh) — refs: 1 · event: Stop · since 2026-04-29 · why: wired Stop — /resolve follow-up nudge [computed-fresh]
- [backup-session-plan.sh](.claude/hooks/backup-session-plan.sh) — refs: 1 · event: — · since 2026-05-28 · why: reference-scan 1 — live hook file, not currently wired in settings [computed-fresh]
- [check-skill-size.sh](.claude/hooks/check-skill-size.sh) — refs: 1 · event: — · since 2026-04-18 · why: reference-scan 1 — live hook file, not currently wired in settings [computed-fresh]
- [check-stop-reminders.sh](.claude/hooks/check-stop-reminders.sh) — refs: 1 · event: Stop · since 2026-04-18 · why: wired Stop — end-of-turn reminder checks [computed-fresh]
- [coach-reminder.sh](.claude/hooks/coach-reminder.sh) — refs: 1 · event: Stop · since 2026-04-27 · why: wired Stop — /coach cadence reminder [computed-fresh]
- [improve-reminder.sh](.claude/hooks/improve-reminder.sh) — refs: 1 · event: Stop · since 2026-04-27 · why: wired Stop — /improve cadence reminder [computed-fresh]

## Skills
### Tier 1 — Critical
- [handoff](skills/handoff/SKILL.md) — refs: 9 · fan-out: 6 · since 2026-05-22 · why: reference-scan 9 — session-handoff methodology behind /handoff [computed-fresh]
- [ai-resource-builder](skills/ai-resource-builder/SKILL.md) — refs: 8 · fan-out: 2 · since 2026-04-05 · why: reference-scan 8 — canonical methodology for /create-skill, /improve-skill, /migrate-skill [computed-fresh]
- [grill-me](skills/grill-me/SKILL.md) — refs: 5 · fan-out: 0 · since 2026-05-22 · why: reference-scan 5 — pre-plan interrogation methodology [computed-fresh]
- [project-scoping](skills/project-scoping/SKILL.md) — refs: 4 · fan-out: 3 · since 2026-07-01 · why: pipeline hub — methodology spine delegating to 3 backbone scope-stage agents [computed-fresh] [new]
### Tier 2 — High
- [session-guide-generator](skills/session-guide-generator/SKILL.md) — refs: 3 · fan-out: 3 · since 2026-04-03 · why: reference-scan 3 — progress-view methodology shared with the agent of the same name [computed-fresh]
- [context-pack-builder](skills/context-pack-builder/SKILL.md) — refs: 3 · fan-out: 0 · since 2026-02-20 · why: reference-scan 3 — context-pack assembly methodology [computed-fresh]
- [repo-health-analyzer](skills/repo-health-analyzer/SKILL.md) — refs: 2 · fan-out: 2 · since 2026-04-01 · why: reference-scan 2 — /audit-repo lead-agent methodology [computed-fresh]
- [session-usage-analyzer](skills/session-usage-analyzer/SKILL.md) — refs: 2 · fan-out: 1 · since 2026-03-30 · why: reference-scan 2 — /usage-analysis methodology [computed-fresh]

## Config & Docs
### Tier 1 — Critical
- [CLAUDE.md (workspace root)](../CLAUDE.md) — refs: 99 · since 2026-04-17 · why: risk-topology §1 Critical + §2 — loads every session; autonomy rules, pause triggers, QC loop
- [CLAUDE.md (ai-resources)](CLAUDE.md) — refs: 99 · since 2026-02-18 · why: risk-topology §1 Critical — loads with every --add-dir session; resource-creation rules
- [settings.json (workspace root)](../.claude/settings.json) — refs: 55 · since 2026-04-17 · why: risk-topology §1 Critical — controls permissions for all sessions
### Tier 2 — High
- [settings.json (ai-resources)](.claude/settings.json) — refs: 55 · since 2026-04-06 · why: curated load-bearing set — wires the every-session hook suite [computed-fresh]
- [audit-discipline.md](docs/audit-discipline.md) — refs: 20 · since 2026-04-20 · why: risk-topology §1 High — governs DR-8 /risk-check behavior
- [principles.md](../projects/repo-documentation/vault/principles/principles.md) — refs: 19 · since — (vault content, not git-tracked) · why: risk-topology §1 High — OP-N anchors targeted by accountability scans
- [documentation-structure.md](../projects/repo-documentation/references/documentation-structure.md) — refs: 1 · since 2026-05-08 · why: risk-topology §1 High — W2.1 parser schema

## Excluded from backbone
- 92 resources did not meet the inclusion filter (17 commands, 3 agents, 0 hooks, 72 skills). (Run `/list-critical-resources full` to list them.)

137 backbone resources across 5 types — 63 Tier-1, 74 Tier-2, 12 new.
