# Maintenance Observations — Archive

## 2026-05-01 — Friday Act (monthly tier, source: friday-checkup-2026-05-01.md)

### Disposition summary
- Tactical: 3 fix-now, 7 defer, 4 skip (of 14 items)
- Policy review: 2 rule-change proposed, 2 no-change, 1 defer

### Deferred items (from this session)
- Resolve `{{WORKSPACE_ROOT}}` placeholder in workflows/research-workflow/.claude/settings.json — risk: med — RECONSIDER verdict per `audits/risk-checks/2026-05-01-resolve-the-workspace-root-placeholder-in-workflows-research.md`. Recommended redesign: do NOT edit the template; fix the auditor false positive instead (suppress Rule-8 unfilled-placeholder check for files under `workflows/*/.claude/`, or add a top-of-file template marker).
- Decide on H2 skill splits (answer-spec-generator + research-plan-creator + ai-resource-builder) — risk: med — Structural change; needs dedicated planning session, not a /friday-act fix.
- /cleanup-worktree — risk: med — Reclassified to deferred. Working tree mid-session contains in-flight risk-check report and observations file from this run; running /cleanup-worktree mid-flow conflicts with concurrent-session safety. Run after /friday-act commits.
- Add `Read(audits/**)` and `Read(reports/**)` to `ai-resources/.claude/settings.json` — risk: low — Token-audit M1 places these in deny-rule status section. Adding to deny would block /friday-act, /risk-check, /token-audit reading their own active reports. Auditor recommendation conflates archived-stale paths (correct deny target) with active-current paths (incorrect deny target). Right fix is more nuanced — likely `Read(audits/working/**)` only — and not a 1-line quick win.
- Decide on 2 orphaned skills (fund-triage-scanner, prose-refinement-writer) — risk: low — Operator denied the `git mv` to skills/deprecated/; needs explicit approval. Both confirmed orphaned (zero references outside their own SKILL.md).
- Sweep description quality on 11 trigger-gap + 7 exclusion-gap skills — risk: low — Time-consuming sweep; better as a dedicated mini-session.
- Delete orphan `usage/usage-log.md` (227 lines, pre-migration artifact) — risk: low — File-deletion outside session output scope; needs explicit operator approval per autonomy pause-trigger #3.

### Policy proposals

- **For "{{WORKSPACE_ROOT}} placeholder is a recurring finding":** Add a Rule-8 exception in `permission-sweep-auditor` and `repo-health-analyzer/SKILL.md` for files under `workflows/*/.claude/` (or files with a `// TEMPLATE` top-line marker) — treat as template-class and skip unfilled-placeholder flagging. Cross-reference: `audits/risk-checks/2026-05-01-resolve-the-workspace-root-placeholder-in-workflows-research.md` and `audits/permission-sweep-2026-04-27.md:35` backlog note.

- **For "{{WORKSPACE_ROOT}} placeholder is a recurring finding" (expanded):** Same rule-change should also extend to Rule 4 — recognize files with `defaultMode: bypassPermissions` as having intentionally-minimal allow lists, suppress "missing allow entries" CRITICAL flags. Cross-reference: operator memory `feedback_zero_permission_prompts.md`.

- **For "Project-level coaching reveals uniform pattern: structured logs under-capture decisions":** Add a Stop hook (or extend `coach-reminder.sh`) that scans for tactical decisions in the session (decision-keyword detection in user/assistant turns) and counts them against new entries in `decisions.md` — nudge if the ratio drops below ~0.3. Pairs with existing `improve-reminder.sh` and `coach-reminder.sh` pattern.

### Operator observations

Striking session pattern: 4 of 14 tactical follow-ups (items 2, 4, 6, 7) were auditor false positives — none required file changes. Recurring root cause: auditor logic does not model the operator's documented design choices (bypass-mode permission posture, template-class files in `workflows/*/.claude/`, multi-line description blocks in skill frontmatter). Current /friday-checkup signal-to-noise is degraded by this auditor blind spot. The right intervention is at the auditor rule level (the two policy proposals above), not per-finding triage.

The 2026-04-27 risk-check record was load-bearing in this session: without it, today's risk-check on item 2 would have taken the change-description's premise at face value and corrupted the deploy-time template. Prior risk-check reports as institutional memory are working as designed.

Items 8 and 10 (file move + file deletion) hit autonomy pause-trigger #3 even under /recommend autonomous posture — the boundary worked as designed. /recommend's guardrail clause ("All Autonomy Rules pause-triggers still apply") held.

### Autonomy-axis posture targets (week ahead)
- Guardrails: hold
- Optimization: hold
- Autonomy: hold
- Capability: hold
- Reliability: hold
- Observability: hold
- Operator load: hold



