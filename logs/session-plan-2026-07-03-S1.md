# Session Plan — 2026-07-03 (S1)

## Intent

Hand the 18-item tactical backlog from the 2026-07-03 quarterly `/friday-checkup` to `/friday-act` and work through its fix waves — starting with the 4 CRITICAL live permission-prompt gaps and the systemic project-CLAUDE.md template duplication finding. This is a fix session (Session 2 of the Friday cadence), following directly from a diagnosis-only checkup that applied no fixes.

## Model

Recommended: opus (matches active session model `claude-opus-4-8[1m]` — this is a judgment-heavy triage-and-fix session touching permissions, CLAUDE.md content, and possibly commands/hooks, not mechanical work).

## Source Material

- `audits/friday-checkup-2026-07-03.md` — the consolidated quarterly checkup report (18-item backlog, priority-ranked)
- `logs/improvement-log.md` (+workspace/project copies) — the 11 findings the checkup logged this cycle
- `audits/repo-health-ai-resources-2026-07-03.md`, `audits/token-audit-2026-07-03-ai-resources.md` — supporting detail behind several backlog items
- `audits/claude-md-audit-2026-07-03-project-*.md` (6 files) — the CLAUDE.md systemic-duplication finding
- `logs/session-notes.md` (2026-07-03 checkup entry, Next Steps) — the carryover mandate for this session

## Findings / Items to Address

- **4 CRITICAL live permission-prompt gaps** — flagged in the checkup's permission-sweep dry-run (43 files scanned, 5 critical / 11 high total; only 4 of the criticals are this session's floor). Highest priority: these directly cause avoidable operator interruptions every session.
- **Broken workspace-root git remote** — noted in the checkup outcome as a material finding; needs diagnosis (is it misconfigured, deleted, or a permissions issue) before a fix can be scoped.
- **Systemic project-CLAUDE.md template duplication** — root-cause finding from the 6-project claude-md audit: a shared template pattern is being copy-duplicated per project rather than referenced, causing drift risk. Likely the single highest-leverage fix in the batch (touches 6+ projects).
- **11 High findings** from the permission-sweep dry-run, below the 4-critical floor but worth a wave if time/context allows.
- **Remaining ~13 items** (of the 18) not yet triaged in this plan — `/friday-act` will read the checkup report directly and build its own wave plan; this session plan does not pre-empt that triage.

## Execution Sequence

1. Invoke `/friday-act`. It will ask which projects are active and which fix waves to run this session — these are the command's own load-bearing operator gates, not something this plan pre-decides.
2. Prioritize: (a) the 4 critical permission-prompt fixes, (b) the broken workspace-root remote, (c) the CLAUDE.md template-duplication fix, in that order, before any lower-priority wave.
3. Let `/friday-act` run its own per-wave `/risk-check` gates — do not bypass or pre-empt them from this outer session.
4. After each wave, commit directly per workspace commit rules (no pre-commit checks, no permission asks) — stage only files `/friday-act` actually touched.
5. At natural stopping points (context pressure, or all critical+high items closed), stop and hand remaining items back to the backlog rather than rushing a low-value wave.

## Scope Alternatives

- **Narrow (floor):** only the 4 CRITICAL permission-prompt fixes. Lowest risk, fastest, but leaves the higher-leverage CLAUDE.md template fix and the broken remote untouched.
- **Recommended (this plan):** critical fixes + broken remote + CLAUDE.md template fix, then opportunistically pick up High-severity items if context allows. Balances leverage against session length.
- **Full sweep:** all 18 items in one session. Rejected as scope — the checkup report itself flagged several items as multi-session or dedicated-session work (e.g., the deferred token-audit workspace run, 6-project `/coach`), and cramming them here risks the same credit-exhaustion pattern the checkup already hit once today.

## Autonomy Posture

Gated. This session touches structural surfaces (permissions, CLAUDE.md content, possibly hooks/commands) — `/friday-act`'s own per-wave `/risk-check` is the enforcement mechanism, run inside the command rather than as a duplicate outer pass.

## Risk

Structural-change classes are in play (permission-sweep fixes, CLAUDE.md edits, possible command/hook edits) — each `/friday-act` wave is expected to trigger its own `/risk-check` per `docs/audit-discipline.md`. No outer `/risk-check` was run at this plan's approval gate; the operator was told this explicitly and approved (`go`) with that understanding. Known adjacent hazard: the working tree already carries unrelated uncommitted files (`reconcile-*` command/agent, an in-progress instruction audit, a CLAUDE.md duplication/contradiction risk-check report, an edited `innovation-registry.md`) — none of these are `/friday-act`'s to touch; commits this session must stage only files `/friday-act` itself modified, by explicit path, not a blanket `git add`.
