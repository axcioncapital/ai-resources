# Maintenance Observations

Per-Friday-Act session block, append-only. Each block captures:

- **Disposition summary** — counts across tactical / policy / architectural retrospective.
- **Deferred items** — tactical or policy items the operator dispositioned away from execution.
- **Policy proposals** — proposed CLAUDE.md / audit-discipline.md edits captured by `/friday-act` Step 4 (monthly+); not auto-applied — schedule a follow-up session per proposal.
- **Architectural retrospective notes** — operator's free-form response to the substrate questions (quarterly only).
- **Operator observations** — free-form repo-health / friction / coupling observations the audits didn't surface.
- **Autonomy-axis posture targets (week ahead)** — seven axes (Guardrails / Optimization / Autonomy / Capability / Reliability / Observability / Operator load), default `hold`; only changed targets carry a one-line rationale.

Distinct from `coaching-log.md`: this file is forward-looking weekly posture + observations from the cadence; `coaching-log.md` is backward-looking session-pattern ratings.

Distinct from `friction-log.md`: friction-log is per-session events; this file is per-Friday-Act meta-observations about repo health.

Schema is whatever `/friday-act` writes — see `.claude/commands/friday-act.md` Step 5–6 for the canonical block shape. Do not hand-edit prior session blocks.

---

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



## 2026-05-08 — Friday Act (weekly tier, source: friday-checkup-2026-05-08.md)

### System Owner inputs (this session)
- Friday Advisory: projects/axcion-ai-system-owner/output/friday-advisories/friday-advisory-2026-05-08-v2.md
- Systems Review:  projects/axcion-ai-system-owner/output/systems-reviews/systems-review-2026-05-08-4-projects-cadence-doc.md

### Journal Report (this session)
- Journal Report: ai-resources/audits/friday-journal-2026-05-08.md

### Disposition summary
- Tactical: 11 queued for plans, 31 defer, 1 skip (of 43 items; of which 0 System Owner-derived, 31 journal-derived)

### Deferred items (from this session)
- Investigate 3 removed components from W2.1: resolve-improvements (likely renamed), CLAUDE.md (workflows), settings.local.json (workflows) — mark deprecated if intentional — risk: med, source: checkup
- Promote 3–5 structural decisions from session-notes to decisions.md in axcion-ai-system-owner — risk: low, source: checkup
- Paste 44 new component entries from W2.1 drift report into vault/components/ — run /kb-update per category — risk: low, source: checkup
- Review and resolve at least 1 improvement-log logged (pending) entry — risk: low, source: checkup
- Add hook capturing context-window utilization at compact-fire time (root-cause diagnosis of premature auto-compaction) — risk: high, source: journal-derived
- Add operator-prompted folder-scope question to /friday-so — risk: med, source: journal-derived
- Extend /friday-so to do its own targeted scan beyond reading the existing checkup report — risk: med, source: journal-derived
- /session-plan polish pass — autonomy-posture question, QC-pass directive clarity, explicit exit condition — risk: med, source: journal-derived
- Wire /implementation-triage reminder into /friday-act start — risk: med, source: journal-derived
- Build /autonomy-stop log command — timestamped halt-event log — risk: med, source: journal-derived
- Add session-logging heuristic to /wrap-session — log substantive sessions; skip trivial — risk: med, source: journal-derived
- Add bold visible reminder to /prime output that operator should invoke /session-plan — risk: med, source: journal-derived
- Build /autonomy mid-session command — hands Claude full autonomy at any point — risk: med, source: journal-derived
- Add hook intercepting long inline plans in chat — force them to a file before continuing — risk: med, source: journal-derived
- Add hook preventing diagnosis + execution in same session — force session split — risk: med, source: journal-derived
- Improve /audit-claude-md — clarifying-question pass + /qc-pass via systems-owner agent before finalizing — risk: med, source: journal-derived
- Investigate concurrent-Claude-Code-sessions risk on shared files; pick guardrail (file-lock, session-id stamp, or warn-only) — risk: med, source: journal-derived
- Build /gpt-qc command (or step in /create-skill) — runs project-plan through ChatGPT for QC/refinement — risk: med, source: journal-derived
- Build /explain command — explains next step or what Claude just did, in simple short English — risk: med, source: journal-derived
- Add hook detecting high-volume context reads (>5 KB modules / >50k tokens) — suggests session-splitting — risk: med, source: journal-derived
- Build /daily-journal command — daily cadence for capturing improvement/waste/redundancy observations — risk: med, source: journal-derived
- Add unresolved-items sub-step to /wrap-session — pending unknowns/clarifications/decisions before wrap — risk: med, source: journal-derived
- Document drift pattern observed in projects/buy-side-service-plan/ between v1 master and v2.x sub-docs — risk: med, source: journal-derived
- Investigate whether /architecture-review should be wired into /friday-so cadence routine — risk: low, source: journal-derived
- Document operator-pushes-manually convention in workspace CLAUDE.md — risk: low, source: journal-derived
- Document /risk-check actual use cases and trigger conditions in audit-discipline.md — risk: low, source: journal-derived
- Investigate context-engineering pattern for /session-plan — risk: low, source: journal-derived
- Document Skills fork-parameter and arguments-parameter mechanics in ai-resource-builder/SKILL.md — risk: low, source: journal-derived
- Document background-agent context-priming pattern (parallel research subagent feeding main session) — risk: low, source: journal-derived
- Investigate GAP-1 — 7 workspace-root commands outside ai-resources/.claude/commands/ — risk: low, source: journal-derived
- Add "are there decisions or actions to take before finishing?" prompt to /wrap-session — risk: low, source: journal-derived

### Plans written (this session)
- ai-resources/audits/friday-plans/2026-05-08-consult.md — 1 item
- ai-resources/audits/friday-plans/2026-05-08-settings.md — 5 items
- ai-resources/audits/friday-plans/2026-05-08-commands.md — 1 item
- ai-resources/audits/friday-plans/2026-05-08-risk-topology.md — 1 item
- ai-resources/audits/friday-plans/2026-05-08-cleanup-worktree.md — 1 item
- ai-resources/audits/friday-plans/2026-05-08-qc-pass.md — 2 items

### Operator observations
(none)

### Autonomy-axis posture targets (week ahead)
- Guardrails: hold
- Optimization: hold
- Autonomy: loosen — operator trusts Claude to make decisions on its own; operator input rarely brings more value
- Capability: hold
- Reliability: hold
- Observability: hold
- Operator load: hold

### Revision (post-/friction-log) — 2026-05-08

Initial /friday-act disposition was grounded in 30-line peeks of SO advisory + systems review (per /friday-act spec Step 16a). Operator caught this and requested full reads. Full reads surfaced 8 items missed/disagreed in the initial disposition:

**New fix-now (added to plans this revision):**
- Add /architecture-review to /friday-checkup monthly tier — risk: med, source: so-derived (SO Rec 4)
- Restate cadence goal at top of operator-maintenance-cadence.md — risk: med, source: so-derived (Systems Review LP 3)
- Add trend-aggregation pre-step before /friday-checkup (read last 4 friday-advisories) — risk: med, source: so-derived (Systems Review LP 6)

**Settings plan item 5 reframed:** {{WORKSPACE_ROOT}} placeholder now surfaces operator (a)/(b) decision per SO Rec 2 (was: auto-pick "replace with absolute path").

**Deferred (added this revision):**
- SO Rec 3 bundling — Bundle W2.1 registry-catchup into one session (44 W2.1 entries + innovation-sweep schema + 3 deprecated markings + 4 wiki-links + 5 short-name conversions). Disagrees with my initial triage which parked 3 of these. Operator deferred per "essentials only" framing — risk: med, source: so-derived
- SO Rec 5 — Workspace-wide under-capture mechanism (CLAUDE.md template clause OR /wrap-session nudge). Pattern confirmed across 4 projects. Different surface than checkup item 9 (project-specific) — risk: med, source: so-derived
- Systems Review LP 6 (Loop 2) — Add F0 sub-step reading project-internal session-notes + friction-log for each active project. Systems review explicitly defers to subsequent session — risk: med, source: so-derived
- Systems Review Trap 1 (watch only) — Cadence becoming "complete the steps" not "produce decisions." Surface for monitoring; not action this cycle — risk: low, source: so-derived

### Plans written (revision)
- ai-resources/audits/friday-plans/2026-05-08-cadence.md — 3 items (NEW)

### Final tally (post-revision)
- Tactical: 14 queued for plans (across 7 plan files), 35 defer, 1 skip (of 47 items considered after full SO/systems-review read)
- Plan files: 7 (added cadence.md to the original 6)

### Revision (post-improvement-log read) — 2026-05-08

Operator caught a second under-read: I had not opened the actual improvement-log.md files (only relied on checkup summary). Three improvement-logs reviewed (ai-resources, global-macro-analysis, buy-side-service-plan).

**Findings:**
- 2026-04-28 ai-resources IL entry "permission-sweep-auditor: classify template sources" IS the upstream fix for the {{WORKSPACE_ROOT}} 3-cycle recurrence flagged by SO Rec 2. Added as settings plan item 6 (coupled with item 5 as symptom + upstream pair).
- 2026-05-08 global-macro-analysis IL entry "concurrent-session detection hook" is the same item as journal J16 (already deferred). Cross-project signal exists; cadence currently does not aggregate.
- 2026-04-25 ai-resources IL entry "/wrap-session leaner" (5 specific edits, ~30 min) is concrete but NOT essential per "defer non-essentials" directive. Logged as next-week candidate; not pulled into this Friday's plans.
- buy-side-service-plan IL entries are project-specific; no cross-cutting actionables.

**Fix-now added (revision 2):**
- Settings plan item 6 — Update permission-sweep-auditor to classify template-class files. Coupled with item 5.

### Final tally (post-revision 2)
- Tactical: 15 queued for plans (across 7 plan files), 35 defer, 1 skip
- Plan files: 7 (settings.md now has 6 items; cadence.md has 3 items)

---

## 2026-05-16 — Friday Act (weekly tier, source: friday-checkup-2026-05-16.md)

### System Owner inputs (this session)
- Friday Advisory: (none within 7 days — most recent: friday-advisory-2026-05-08.md)
- Systems Review:  (none within 7 days — most recent: systems-review-2026-05-08-full-ai-infrastructure.md)

### Journal Report (this session)
- Journal Report: ai-resources/audits/friday-journal-2026-05-16.md
- Innovation Sweep: ai-resources/audits/innovation-sweep-2026-05-16.md (operator-requested supplementary input)

### Disposition summary
- Tactical (checkup): 13 fix-now, 4 defer, 0 skip (of 17 items)
- Innovation-sweep: 7 fix-now, 7 defer, 0 skip (of 14 items — 6 graduate candidates + 8 loose ends)
- Journal-derived: 8 fix-now, 7 defer, 0 skip (of 15 items)
- **Grand total: 28 fix-now, 18 defer, 0 skip (of 46 items considered)**
- Note: SO advisory and systems review both outside 7-day filter; no SO-derived items this session.

### Deferred items (from this session)

**From checkup:**
- Add trigger/exclusion language to 14 ai-resources skills (/improve-skill pass) — risk: low, source: checkup
- Content extraction for answer-spec-generator (487 lines) and research-plan-creator (466 lines) — risk: low, source: checkup
- Resolve 2 orphaned skills (fund-triage-scanner, prose-refinement-writer) — risk: low, source: checkup
- Backfill coaching-data.md in project-planning (lags by 3 sessions) — risk: low, source: checkup

**From innovation sweep:**
- G3: Graduate UserPromptSubmit decision-logging hook — risk: med, source: innovation-sweep — needs own /risk-check + design session before wiring
- G4: Graduate Stop hook checkpoint-not-written nag — risk: med, source: innovation-sweep — same; new hook, needs own session
- LE1: today-drill.md rotation mechanic (interpersonal-comm) — graduate pattern or keep local — risk: low, source: innovation-sweep
- LE2: CLAUDE.md §Autonomy Rules (nordic-pe) — graduate to workspace or keep local — risk: med, source: innovation-sweep — overlap with existing workspace Autonomy Rules section needs careful comparison
- LE3: Auto-commit-on-Write hook (nordic-pe) — keep local; policy conflict with workspace Commit Rules unresolved — risk: high, source: innovation-sweep
- LE6+LE8: friction-log-trigger.sh + PostToolUse wiring (repo-documentation) — not fully assessed; defer to dedicated graduation session — risk: med, source: innovation-sweep
- LE7: CLAUDE.md §Compaction scratchpad pattern (repo-documentation) — defer to compaction-protocol review — risk: low, source: innovation-sweep

**From journal:**
- Add default QC subagent to research-plan-creator skill — risk: med, source: journal-derived
- Add /repo-dd step comparing CLAUDE.md + file structure to ai-resources — risk: med, source: journal-derived
- Add auto-QC of /friday-act execution plan (systems agent) — risk: med, source: journal-derived (improvement would affect current command; circular in this session)
- Add refinement pass to /friday-journal enriching with repo-documentation context — risk: med, source: journal-derived
- Wire /resolve-improvement-log into /friday-act execution flow — risk: med, source: journal-derived (structural wiring; needs /risk-check)
- Audit /systems-review scope and confirm it surfaces systems-thinking improvements — risk: low, source: journal-derived
- Investigate coaching logs + /friday-checkup wiring (verify already linked) — risk: low, source: journal-derived

### Plans written (this session)
- ai-resources/audits/friday-plans/2026-05-16-nordic-pe-macro.md — 4 items
- ai-resources/audits/friday-plans/2026-05-16-permission-sweep.md — 3 items
- ai-resources/audits/friday-plans/2026-05-16-ai-resources-maintenance.md — 6 items
- ai-resources/audits/friday-plans/2026-05-16-permission-template.md — 3 items
- ai-resources/audits/friday-plans/2026-05-16-innovation.md — 4 items
- ai-resources/audits/friday-plans/2026-05-16-journal-improvements.md — 5 items
- ai-resources/audits/friday-plans/2026-05-16-friday-journal.md — 3 items

### Operator observations
(none)

### Autonomy-axis posture targets (week ahead)
- Guardrails: hold
- Optimization: hold
- Autonomy: hold
- Capability: hold
- Reliability: hold
- Observability: hold
- Operator load: hold
