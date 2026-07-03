# Session Plan — 2026-07-03

## Intent
Fix 4 still-open backlog items surfaced by `/open-items` + `/reconcile-backlog`: (1) a documented subagent-spawn fallback for `/risk-check` / `/qc-pass` / `/refinement-pass`; (2) close the self-waived-`/risk-check` hole in `audit-discipline.md`; (3) add a `/reconcile` pointer to the new-project CLAUDE.md template fragment; (4) fix the stale copy path in `SETUP.md`.

## Model
opus — match (session is on Opus 4.8; items 1–2 are design-judgment, not mechanical).

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md` (Step 10 spawn — line 63 "Abort if missing")
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-pass.md`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (§ Risk-check change classes, line 19)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/` (fragment set: `header.md`, `commit-rules.md`, `compaction.md`, `session-boundaries.md`, `input-file-handling.md` — identify the right home for the `/reconcile` pointer at execution)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/SETUP.md` (line 12 stale copy path)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/README.md` (consumer contract — edit the fragment, not the consuming command)

## Findings / Items to Address
1. **Canonical-command subagent-spawn fallback** (improvement-log 2026-07-03; friction-log 2026-07-02 S1, recurred twice) — `/risk-check` Step 10 (`risk-check.md:63`) *aborts* when `risk-check-reviewer.md` can't resolve as an agent *type* from a project session (`--add-dir` grants file access, not agent-type registration). Same failure latent in `/qc-pass` and `/refinement-pass`. Fix (option b from the entry): documented fallback — when the named subagent type is unresolved, run `general-purpose` with the agent definition read from disk and inlined into the prompt. Add to each command's spawn step.
2. **Self-waived-`/risk-check` carve-out** (improvement-log 2026-07-03, med) — S2 self-authorized an undocumented "materiality" exception to skip the mandatory `/risk-check` gate on `settings.local.json` edits, but that class is explicitly listed in `audit-discipline.md § Risk-check change classes` and is an Autonomy Rule #9 pause. Fix: add to `audit-discipline.md` EITHER a gitignored-local-file materiality carve-out OR a confirm-before-skip rule — never a silent self-waiver.
3. **`/reconcile` pointer in new-project template** (improvement-log 2026-07-03) — `/reconcile` was graduated + broadcast today (`887e711`) but nothing prompts a newly-scaffolded project to use it. Add a pointer line to the correct `templates/project-claude-md/` fragment (per `templates/README.md`: edit the fragment, NOT `/new-project`), scoped to matured/output-producing projects.
4. **`SETUP.md` stale copy path** (improvement-log 2026-06-12 item 1) — `SETUP.md:12` reads `cp -r workflows/active/research-workflow/project-template/ …`; neither `workflows/active/` nor `project-template/` exists, so a new deployer fails at the first command. Fix: correct the path — the template is the `ai-resources/workflows/research-workflow/` directory itself.

## Execution Sequence
1. **Read targets** — read the 3 command spawn steps, `audit-discipline.md § Risk-check change classes`, the candidate template fragment(s), and `SETUP.md` head. Verify current text before editing. *Verify:* each target's exact current wording captured.
2. **Plan-time `/risk-check`** on the structural set (items 1–3 edit canonical commands + a governance doc + a broadcast template). *Verify:* verdict GO (or PROCEED-WITH-CAUTION with mitigations); on RECONSIDER/NO-GO → pause and surface per Stop-if.
3. **`/blindspot-scan`** (post-plan, pre-implementation gate — plan touches a risk-check class and ≥3 files). *Verify:* verdict surfaced; resolve any PAUSE-AND-FIX findings before editing.
4. **Item 1** — edit `risk-check.md` spawn step; apply the same fallback to `qc-pass.md` + `refinement-pass.md`. *Verify:* each command now has a documented unresolved-agent fallback; wording consistent across the three.
5. **Item 2** — edit `audit-discipline.md § Risk-check change classes` (carve-out or confirm-before-skip). *Verify:* the rule names the exact condition and forbids silent self-waiver.
6. **Item 3** — add the `/reconcile` pointer to the identified template fragment. *Verify:* pointer present, scoped, and consistent with `templates/README.md` consumer contract.
7. **Item 4** — correct `SETUP.md:12` copy path. *Verify:* path names the real `research-workflow/` dir; a deployer following Step 1 verbatim would succeed.
8. **Independent `/qc-pass`** on the edited set. *Verify:* GO, or loop `/resolve` on findings.
9. **Commit** (direct, per workspace rule); leave push to wrap. *Verify:* `git log` shows the commit with the 4 fixes; improvement-log entries #1–3 + #4 flip to resolved in the same or a follow-up log update.

## Scope Alternatives
- **Min:** items 3 + 4 only (both trivial, non-structural or low-risk) — skip the two governance/harness edits. Rejected: the two medium-priority items are the point of the session.
- **Recommended:** all 4, governed pipeline (risk-check → blindspot → edits → qc-pass → commit). ← default.
- **Max:** all 4 + also apply the fallback to any other canonical command that spawns a fixed agent type (e.g. `/reconcile`, `/triage`). Deferred: scope-creep past the confirmed task; log as follow-up if the pattern is broader.

## Autonomy Posture
Gated — structural change classes touched (canonical command edits, a governance-doc rule, a broadcast template fragment) but scope is bounded to 4 named items.

**Stop points:**
- Plan-time `/risk-check` verdict RECONSIDER or NO-GO on any structural item → pause and surface before landing that item.
- `/blindspot-scan` PAUSE-AND-FIX → resolve findings before implementation.
- Item 2 design fork (carve-out vs. confirm-before-skip) — pick the recommended per decision-point posture; surface the choice inline, do not gate.

## Blind-spot constraints (from /blindspot-scan, 2026-07-03 — PROCEED-WITH-CONSTRAINTS)
1. **Fix #1 placement** — add the fallback at the *spawn* step (risk-check.md Step 11 / qc-pass.md Step 3 / refinement-pass.md Step 3), triggered by agent-*type* unresolved; leave risk-check Step 10's file-existence check intact. Paired-copy sync NOT needed — the 3 commands are symlinks (workspace-root + all projects → ai-resources canonical), so the edit propagates.
2. **Fix #2 contradiction risk** — word the carve-out as a *bounded* exemption with a *mandatory logged* exemption (or confirm-before-skip); never a silent blanket exemption. Cross-check against workspace CLAUDE.md Autonomy Rule #9 so the always-loaded doc and CLAUDE.md do not contradict.
3. **Fix #3 pointer scope** — scope the `/reconcile` pointer to matured/output-producing projects (qualifier clause); an unconditional pointer misleads in early-stage projects where `/reconcile` clean-aborts (present-but-inert).

## Deferred follow-ups (items 1 + 2) — SO-guided re-scoping (operator chose "land 3+4, re-scope 1+2")
Captured here (uncontended, session-owned) because `logs/improvement-log.md` is under concurrent-session contention this session — these updates must be merged into the improvement-log entries once the concurrent session commits.

**Item 1 — canonical-command subagent-spawn fallback (improvement-log 2026-07-03 "Canonical command subagent spawn fails from a project session"). Re-scope, do NOT ship the 3-site patch:**
- The reviewer agent *definition files* are ALREADY symlinked into every project's `.claude/agents/` (via `auto-sync-shared.sh`; verified `risk-check-reviewer.md` is a symlink in marketing-positioning / nordic-pe / axcion-website). So the failure is agent-*type* resolution, not a missing def — SO "symptom-vs-cause": the root gap may be topology-layer (type registration under `--add-dir`), and the fallback would be N command-layer workarounds for one topology gap (§ AP-9, § DR-7).
- **Do first:** reproduce the type-resolution failure from a project session and find WHY the type doesn't resolve despite the symlinked file (unsynced project? `--add-dir` root mismatch?). If a topology fix (selective agent-type registration for the 3 shared reviewers, not a blanket symlink that over-exposes project-scoped agents) resolves it, that is ONE fix for ALL spawn sites — preferred over patches.
- **If command-layer fallback is still chosen:** cover ALL confirmed sites, not 3 — add `refinement-deep.md` (Step 3, spawns qc-reviewer + refinement-reviewer) and `friday-journal.md` (Step 5.5, spawns qc-reviewer). Verify friday-journal's project-session exposure before including/excluding. Factor ONE shared fallback pattern.
- **HARD sub-gate (SO):** the fallback MUST re-assert `model: opus` on the general-purpose spawn (per-spawn override exists) or fail loud — never silently run an Opus-tier QC/risk reviewer on the session (Sonnet) model. "Document the drop" is not acceptable (OP-3/AP-2).
- **Self-referential caution:** item 1 edits `/risk-check` itself (trust-root) — require a manual `/risk-check`-from-a-project-session test before landing.
- Note the REAL non-symlink copies that won't propagate: `projects/positioning-research/.claude/commands/{qc-pass,refinement-pass}.md`, `ai-resources/workflows/research-workflow/.claude/commands/qc-pass.md`.

**Item 2 — self-waived-/risk-check hole (improvement-log 2026-07-03 "Session self-waived a mandatory /risk-check change class"). Split out + own risk-check + rethink approach:**
- Do NOT land as a self-serve logged carve-out (SO: reproduces the OP-5 hole with a paper trail — the skip decision stays with the session).
- **Name the class question first:** is `settings.local.json` genuinely OUT of the gated class (per-machine, gitignored, zero tracked/cross-repo blast radius, § DR-3)? If YES → *clarify it out-of-class* in `audit-discipline.md` (clean structural fix, no gate relaxation). If it can carry material effect → *confirm-before-skip* rule (§ OP-2, § AP-4). Not a discretionary carve-out.
- Two-end doc contract: edit `docs/audit-discipline.md` + `risk-topology.md § 3`/`§ 4` together; also repair a dangling `risk-topology.md § 1.2` reference (SO missed-risk #4).
- Give item 2 its OWN plan-time `/risk-check` (do not bundle a safety-gate relaxation with bug fixes — SO "split the bundle").
- Cross-check final wording against workspace CLAUDE.md Autonomy Rule #9 side-by-side.

Full SO advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-riskcheck-2nd-opinion-subagent-fallback-carveout-reconcile.md`. Risk-check report: `audits/risk-checks/2026-07-03-subagent-spawn-fallback-riskcheck-carveout-reconcile-pointer.md`.

## Concurrent-session collision note (2026-07-03 S4)
A concurrent session (no per-id marker → non-/prime start) implemented items 3 (header.md /reconcile pointer) and 4 (SETUP.md path) mid-session, and closed improvement-log entries #28/#41, and is mid-editing graduate-resource.md, resolve-improvement-log.md, wrap-session.md, source-class-hierarchy.template.md. S4 stood down on shared-file writes and did NOT commit to avoid a lost-update entanglement. S4's own uncontended artifacts: the 2 /reconcile-backlog closures (coexisting in improvement-log.md), the risk-check report, the SO advisory, this plan.

## Risk
Run `/risk-check` after this plan is noted (plan-time gate) and again before commit (end-time gate). Structural classes: canonical-command edits (items 1), always-loaded/governance-doc edit (item 2 — `audit-discipline.md`), broadcast template-fragment edit (item 3 — fans out to future projects). Item 4 is a plain workflow-reference-doc correction (no structural class). Not launch/runtime-gated — all edits are docs/commands, no executable/launcher, so the VS Code-vs-terminal environment-fit check does not apply.
