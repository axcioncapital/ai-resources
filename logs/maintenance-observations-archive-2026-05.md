# Maintenance Observations — Archive 2026-05

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
