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

---

## 2026-05-22 — Friday Act (weekly tier, source: friday-checkup-2026-05-22.md)

### System Owner inputs (this session)
- Friday Advisory: (none within 7 days)
- Systems Review: (none within 7 days)

### Journal Report (this session)
- Journal Report: audits/friday-journal-2026-05-22.md

### Disposition summary
- Tactical: 18 queued for plans, 3 defer, 1 skip (of 22 checkup items; of which 0 System Owner-derived, 0 journal-derived in this count)
- Journal-derived: 5 queued for plans, 0 defer, 0 skip (of 5 journal items)
- Total fix-now: 23 items across 8 plan files

### Deferred items (from this session)
- Rule 14 advisory: 7 project settings files carry Read(archive/**) deny with no archive/ in .gitignore — low, source: checkup
- obsidian-pe-kb, project-planning, ai-development-lab have no logs/improvement-log.md — low, source: checkup
- Run /kb-update to align vault with registry (depends on repo-documentation triage landing first) — low, source: checkup

### Skipped items (from this session)
- global-macro: optionally extract 2 inline PreToolUse hooks into versioned .claude/hooks/ script files — low, "optionally" in item text, no active harm

### Plans written (this session)
- audits/friday-plans/2026-05-22-permissions.md — 4 items (high×2, med×1, low×1)
- audits/friday-plans/2026-05-22-session-plan.md — 1 item (high×1)
- audits/friday-plans/2026-05-22-check-concurrent-session.md — 1 item (high×1, Autonomy Rule #8 gate)
- audits/friday-plans/2026-05-22-improvement-log.md — 3 items (med×3)
- audits/friday-plans/2026-05-22-log-sweep.md — 2 items (med×1, low×1)
- audits/friday-plans/2026-05-22-repo-documentation.md — 3 items (med×1, low×2)
- audits/friday-plans/2026-05-22-general.md — 4 items (med×2, low×2) + innovation sweep appendix
- audits/friday-plans/2026-05-22-journal-commands.md — 5 items (high×2, med×3)

### Innovation Sweep (this session)
- Verdicts: 0 graduate, 0 backport, 4 accept-fork, 4 keep-local, 5 already-graduated, 4 loose-end
- All recent canonical work (handoff, grill-me, jargon-gloss) already in ai-resources — no graduation needed
- 3 inbox briefs pending build-queue decision: workflow-diagnosis.md (strong candidate), repo-review-brief.md, codex-second-opinion-brief.md
- Full notes: audits/working/innovation-sweep-2026-05-22.md

### Operator observations
(none)

### Autonomy-axis posture targets (week ahead)
- Guardrails: tighten — bright-line-review gate has been a rubber-stamp for 4 consecutive coaching cycles; name the specific bright-line before each gate check this week; recalibrate or retire the gate via gate-calibration.md if it continues to add no signal
- Optimization: hold
- Autonomy: hold
- Capability: hold
- Reliability: tighten — concurrent-session collision has recurred 3× (once per week for 3 weeks); until the check-concurrent-session.sh hook lands (plan file: friday-plans/2026-05-22-check-concurrent-session.md), apply manual concurrent-session discipline before any KB write session
- Observability: hold
- Operator load: hold

---

## 2026-05-26 — Known debt: /drift-check pass2 awareness gap

**Context:** Wave C of 2026-05-26 friction-cleanup session enhanced `/session-plan` Step 0 to auto-write `logs/session-plan-pass2.md` when a concurrent-session collision is detected (intent mismatch with an existing recent plan file). Risk-check + system-owner second opinion both flagged that `/drift-check` reads `logs/session-plan.md`, not pass2.

**Effect:** When the auto-pass2 branch fires, the current session's mandate is captured in `session-plan-pass2.md`, but `/drift-check` continues to read `session-plan.md` (the prior session's plan) and uses it as the mandate baseline. Result: possible false ALIGNED verdicts in concurrent-session scenarios — the drift-check would compare actual work trajectory against the wrong plan.

**Tracked for future fix:** add a one-line check to `/drift-check` Step 3 — if `logs/session-plan-pass2.md` exists in the same repo and is newer than `logs/session-plan.md`, prefer pass2 as the mandate source. Alternative: prefer the plan whose `## Intent` line matches the current session's `**Mandate:**` line in session-notes.md.

**Why deferred:** A `/drift-check` edit would warrant its own `/risk-check` and would bloat the Wave C commit beyond its single-file scope. Per minimal-infra-subset preference, deferred as known debt. Pickup point: next session that touches `/drift-check` for any reason, OR if observed false-ALIGNED occurs in a concurrent-session scenario.

**Related v1 acknowledgment:** Wave C's auto-pass2 fix is a v1 — if pass2 frequency exceeds ~2 per week (observed via `/open-items` Tier 3 stale-session-plan count or git log on `session-plan-pass2.md` writes), the date+intent slug approach (friction-log 2026-05-25 14:10 fix direction (a)) becomes the correct evolution. Re-evaluate at next monthly `/friday-checkup`.

---

## 2026-05-26 — Forward-flagged: canonical-vs-project two-producer collision risk (Bundle 2b)

**Context:** Bundle 2b (source-pipeline remediation S-02, S-03, S-04, S-06, S-07, S-13, S-19) landed 2026-05-26. Identified by `/risk-check` end-time gate's system-owner second opinion (`ai-resources/audits/risk-checks/2026-05-26-end-time-gate-for-bundle-2b-execution.md` § Residual coupling).

**The collision:** The project's `cluster-memo-refiner` Check 9 emits per-cluster permission tables to `analysis/claim-permission/{section}/{section}-cluster-NN-permission-table.md`. The canonical `claim-permission-gate` sub-agent (Bundle 1, reached via `/run-sufficiency`) also writes to the same canonical path. As long as the project is **pinned to pre-Bundle-1 shape** (the "sync permanently removed from v6 plan" decision — see `projects/nordic-pe-macro-landscape-H1-2026/logs/decisions.md` 2026-05-26), only the project's `cluster-memo-refiner` Check 9 path fires for this project. No collision today.

**The future-state risk:** If the project is ever "un-pinned" (operator decides to re-sync to canonical, OR a future project deploys canonical Bundle 1 + Bundle 2b together), both producers would write to the same path. Outcomes: (a) one overwrites the other (silent producer collision); (b) divergent schemas if one's schema drifts from the other.

**Why deferred:** This is operator-pinning-discipline at present, not a system bug. Fixing it pre-emptively would require either:
- Path namespacing (`analysis/claim-permission/{section}/{producer}/...`) — invasive across multiple already-landed file-conventions rows and consumer paths.
- Producer-name field in the per-cluster table — schema change requiring re-emission.
- Mutual-exclusion logic in `/run-synthesis` Step 0 — additional fail-safe complexity (related to Tightening A's asymmetric blocking-semantics gap).

None of these are warranted for a today-non-existent collision.

**Surfacing at quarterly cadence:** This entry exists so the next quarterly `/friday-checkup` cycle sees the risk without re-discovering it from the buried end-time `/risk-check` report. If by then the project is still pinned and no other project has activated Bundle 1 + Bundle 2b together, defer again. If either condition has changed, the resolution path becomes operator-required.

**Pickup point:** Quarterly `/friday-checkup` (next quarterly window) OR before a `/sync-workflow` on this project OR before deploying Bundle 1 + Bundle 2b to a second project — whichever comes first.
