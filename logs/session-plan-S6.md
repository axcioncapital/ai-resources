# Session Plan — 2026-05-29

## Intent

Bundle and execute as many open Friday-checkup items (friday-checkup-2026-05-29) as fit responsibly in one session — include as much as can reasonably ship under one mandate. Done when: every open item carries a per-item disposition (execute-this-session / defer-with-reason / scope-alternative), prioritized and waved by risk class, ready for operator review.

## Model

opus — match (active: `claude-opus-4-7[1m]`). Planning is deciding work (synthesis + triage + scope alternatives); execution waves include both deciding (CLAUDE.md edits, /risk-check synthesis) and doing (settings.json edits, log seeding). Opus is right for both phases of this session.

## Source Material

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-checkup-2026-05-29.md` — top-level checkup report (8 prioritized findings, per-scope summary, tactical follow-ups)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-journal-2026-05-29.md` — journal-derived items (4 entries)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-29-general.md` — 10 items (so-derived + journal)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-29-log-sweep.md` — 3 items (all shipped today: `a54681a`, `df12f0c`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-29-permissions-settings.md` — 7 items (3 shipped: `49bd826`, `c40256e`, `80e9ccf`; 4 open)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-29-project-triages.md` — 3 items (1 shipped sub-fix: `17de7ca`; 2 dispatched but sub-fixes pending)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-29-repo-documentation.md` — 6 items (all open)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/friday-plans/2026-05-29-session-qc-pipeline.md` — 4 items (2 shipped: `9f91b2f`/`3f6937b`, `1d1092f`; 2 open)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` — risk-check change classes
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` — canonical permission template

## Findings / Items to Address

All items below are OPEN as of 2026-05-29 commit log (cross-checked against today's 50+ commits). Per-item disposition tags: **[EXECUTE]** this session; **[DEFER]** with reason; **[SCOPE-ALT]** in min/recommended/max alternatives.

### Wave 1 — Mechanical, no /risk-check (quick wins, low blast radius)

1. **[EXECUTE] general #6 [med]** — Create `logs/improvement-log.md` in `projects/obsidian-pe-kb/logs/` and `projects/project-planning/logs/`. Seed each with the canonical header. (Source: general.md item 6; no /risk-check.)
2. **[EXECUTE] repo-documentation #3 [low]** — Paste 7 net-new entries since 2026-05-22 into `projects/repo-documentation/vault/components/*.md` (1 command `pipeline-review`, 4 canonical agents, 2 projects). (Source: repo-documentation.md item 3; no /risk-check.)
3. **[EXECUTE] repo-documentation #4 [low]** — Decide handling for the 212-entry carry-forward set pending since 2026-05-22. Disposition is a decision-line append to project decisions log; not the paste itself. (Source: repo-documentation.md item 4; no /risk-check.)
4. **[EXECUTE] repo-documentation #5 [low]** — Decide deprecation-row policy (prose body vs §4.1 schema addition). Decision-line append; affects three vault components but the policy decision is one-line. (Source: repo-documentation.md item 5; no /risk-check.)
5. **[EXECUTE] general #7 [med] — meta-scheduling item** — Schedule one dedicated session for `/wrap-session` leaner refactor + `permission-sweep-auditor` follow-ups. Resolution here is a calendar/log entry, not the actual refactor work. (Source: general.md item 7.)
6. **[EXECUTE] general #5 [med] — investigation only** — Investigate sub-subagent dispatch limitation in `/pm` (Task tool not available agent-to-agent). Land notes file at `audits/working/2026-05-29-pm-sub-subagent-investigation.md`. Mark as `pending` in `decisions.md`, not `applied`. (Source: general.md item 5; no /risk-check.)

### Wave 2 — Settings.json edits (/risk-check required per item, but low blast radius each)

7. **[EXECUTE] permissions-settings #2 [high]** — Add `Bash(rm *)` to allow list in `projects/nordic-pe-macro-landscape-H1-2026/.claude/settings.json` (Rule 6). Plan-time + end-time /risk-check.
8. **[EXECUTE] permissions-settings #3 [high]** — Remove stale `/Users/danielniklander/...` absolute path from `projects/interpersonal-communication/.claude/settings.json` `additionalDirectories` (Rule 9). Plan-time + end-time /risk-check.
9. **[EXECUTE] permissions-settings #4 [high]** — Remove `"model": "sonnet"` from `~/.claude/settings.json` (violates Model Tier rule). Plan-time + end-time /risk-check. (User-level edit — surfaces outside ai-resources repo; non-committable from this session, but the edit itself can be made.)
10. **[EXECUTE] permissions-settings #7 [med]** — Address 1 MEDIUM permission-sweep finding from `audits/permission-sweep-2026-05-29.md`. Plan-time + end-time /risk-check. (Read the report first to identify which finding; may bundle with #2/#3 if same project scope.)

### Wave 3 — Shared reference doc + cross-command edits (/risk-check no per plan classification)

11. **[EXECUTE] general #3 [med]** — Extract change-shape classifier to a shared reference doc; update `/consult` and `/pm` (project-manager) to reference it. DR-7 trigger met (two confirmed consumers). New reference doc + edits to two existing commands. /risk-check classified as NO per plan, but I'll surface a plan-time /risk-check anyway because the cross-command edit touches automation with shared-state effects (change-shape classification is a contract between commands).

### Wave 4 — CLAUDE.md / cross-cutting policy edits (/risk-check required, deciding work)

12. **[EXECUTE recommended; SCOPE-ALT max] session-qc-pipeline #2 [high]** — Auto-apply `/qc-pass` fixes when verdict is REVISE AND every finding is wording-level / mechanical AND no DISAGREE annotation. Define the "wording-level / mechanical" finding class explicitly; update `/resolve` (or QC → Triage auto-loop) to skip the prompt and log the auto-apply event in `decisions.md`. Update workspace CLAUDE.md § QC → Triage Auto-Loop pointer (and `docs/qc-independence.md` § QC → Triage Auto-Loop) to encode the new auto-apply rule. Plan-time + end-time /risk-check (CLAUDE.md cross-cutting).
13. **[EXECUTE recommended; SCOPE-ALT max] session-qc-pipeline #4 [med]** — Strengthen `/graduate-resource` Step 4 generalization + Step 5 verification. Add brief subagent pass that grep-scans for project names, hardcoded paths, domain-specific terminology drawn from source `CLAUDE.md`. Add "fail and revise" loop. Run against 2–3 recently-graduated resources to confirm gap is real first. Update `docs/ai-resource-creation.md` § graduation rules. Plan-time + end-time /risk-check (workspace CLAUDE.md pointer + linked doc cross-cutting).

### Wave 5 — New skill / new command paths (structural, /risk-check required) — DEFER candidates

14. **[DEFER — dedicated session] general #4 [med]** — Extract Q1–Q8 placement logic into `skills/placement-classification/SKILL.md`. Two confirmed consumers. Structural change (new skill path) + needs careful per-question authoring + needs verification against existing `/placement` behavior. **Reason to defer:** Context budget; structural skill-creation deserves its own session with `/create-skill` invocation chain.
15. **[DEFER — dedicated session] general #8 [med]** — Build new `/clean-folder` workspace-level command (plan-only output). New command path + needs `/placement` advisory + needs careful spec authoring. **Reason to defer:** Same as #14 — structural command-creation deserves a dedicated session.
16. **[DEFER — dedicated session] general #10 [med]** — Run `/improve-skill friday-act` to make Step 3 + Step 3.5 (SO-derived + journal-derived disposition loops) auto-triage by default. `/improve-skill` is a heavy pipeline; runs its own internal /risk-check. **Reason to defer:** Operator's explicit directive ("next time triage the follows AUTOMATICALLY for me!!") is high-value, but the `/improve-skill` chain is long enough to warrant a dedicated session.
   - **IMPLEMENTED 2026-05-29 (S8).** Direct-edit path used instead of `/improve-skill` — pipeline targets SKILL.md only (Step 1 reads SKILL.md for methodology, Step 6 tier-alignment gate requires `model: + effort:` frontmatter which commands lack). Inline `/risk-check` returned GO (all Low). Edit adds sub-step 13a (auto-triage default HIGH→f, MED→f, LOW→d per `logs/decisions.md` Item 10) + revised 14 (Enter accepts, paste overrides with existing `^[fds]+$` validation) + `triage_source` field on FIX_NOW_ITEMS + Step 5 subtotal line. Risk-check report: `audits/risk-checks/2026-05-29-modify-friday-act-step-3-tactical-follow-ups-loop-and-step.md`. Session plan: `logs/session-plan-S8.md`. QC verdict: GO.

### Wave 6 — Sub-fix dispatches (open-ended, sequenced after main wave) — DEFER candidates

17. **[DEFER — dedicated session] project-triages #1 [med]** — Dispatch fixes for 5 ai-development-lab improvement-log entries. Themes: ambiguous-referent self-check, concurrent-session staging detection, mid-session staleness, friction-log Write Activity capture gap, pipeline write-deny rationale doc. **Reason to defer:** Each sub-fix is its own design+/risk-check cycle; bundling all 5 + the other waves exceeds one-session budget.
18. **[DEFER — dedicated session] project-triages #2 [med]** — Dispatch fixes for 3 axcion-brand-book improvement-log entries. Themes: `/draft-module` heredoc routing, brand-strategist subagent contract, per-module allow-override CLAUDE.md pointer. **Reason to defer:** Cross-project work; each fix has its own context envelope.

### Wave 7 — repo-documentation deeper work (DEFER candidates)

19. **[DEFER — dedicated session] repo-documentation #1 [med]** — Fix 3 W2.1 doc-scanner coverage gaps (walk skill-internal subagents; walk `.claude/references/*.md`; review project-local basename collisions). **Reason to defer:** Scanner-code edit + verification against live scan output; deserves dedicated repo-documentation session.
20. **[DEFER — dedicated session] repo-documentation #2 [med]** — Re-author `vault/components/projects.md` against §4.4 schema (1 ERROR + 1 paired WARN — 7 entries × 4 fields missing, 7 × 6 unexpected). **Reason to defer:** Multi-entry schema-conformance rewrite + paired `/kb-integrity` re-run; bundled with #19 in a single repo-documentation session.
21. **[DEFER — gated downstream of #20] repo-documentation #6 [low]** — Re-run `/kb-integrity` from `vault/` after #20 lands. Naturally follows #20.

### Wave 8 — DR-8 gate (explicit operator GO required, NOT auto-executable)

22. **[DEFER — operator GO required] general #1 [high]** — Approve + build concurrent-session detection hook (improvement-log #3, 3 confirmed leaks). DR-8 gate is waiting for explicit operator GO. **Cannot be silently absorbed into auto-execution.** Surface as a separate yes/no question at session end if other work converges.

### Wave 9 — Cleanup (last, after all other commits)

23. **[EXECUTE — last] general #9 [low]** — Run `/cleanup-worktree` against ai-resources working tree once all other commits land. Confirms clean state before next session.

## Execution Sequence

Sequencing rationale: ship mechanical/zero-risk work first to free context for the higher-cost CLAUDE.md edits later. Each Wave ends with a one-line between-wave summary (visibility only, not a gate per workspace `Between-gate summaries` rule).

1. **Wave 1 — items 1–6** — Mechanical wins, no /risk-check. Verification: each item commits in its own commit per workspace `Commit Rules`. Between-wave summary at end.
2. **Wave 2 — items 7–10** — Settings.json edits. Per-item plan-time /risk-check (single batched cluster — all four are settings.json with same risk profile). Per-item end-time /risk-check before commit. Verification: each settings.json change validates against `docs/permission-template.md` canonical shape. Item 9 (user-level `~/.claude/settings.json`) is a non-repo edit — commit-able from this session: no.
3. **Wave 3 — item 11** — Shared reference doc extraction. Plan-time /risk-check (cross-command contract). Verification: new doc exists, both consumer commands reference it, no behavior drift in either. Single commit covering all three files.
4. **Wave 4 — items 12, 13** — CLAUDE.md cross-cutting edits. Per-item plan-time /risk-check (mandatory). Item 13 sub-step: run grep against 2–3 recently-graduated resources first to confirm the gap is real before adding the subagent pass. Per-item end-time /risk-check + `/qc-pass` before commit.
5. **Wave 9 — item 23** — `/cleanup-worktree` after all commits land.
6. **DR-8 surface — item 22** — Surface DR-8 gate as a separate yes/no question at session end. Do not silently absorb.
7. **Defer write-up** — Items 14–21 land in next session's mandate with the deferred reason inline. Append a `### Deferred This Session` block to S6 wrap.

Per-step verification:
- Wave 1: each item's commit lands; improvement-log seeded files exist; vault component pastes append cleanly (no diff conflict with concurrent work).
- Wave 2: `/risk-check` GO before each commit; settings.json files parse as valid JSON; no permission prompts on subsequent harness ops.
- Wave 3: ref doc exists; consumer commands re-load via Read-after-Edit (or run a one-shot test invocation); no command regression.
- Wave 4: `/risk-check` GO + `/qc-pass` GO; CLAUDE.md edits don't break load (token cost stays under audit budget per token-audit-mechanical R1).

## Scope Alternatives

- **Min scope:** Waves 1 + 2 (12 sub-items, all mechanical or settings.json). Net: ~4 commits, ~30k tokens. Worst-case context-pressure exit.
- **Recommended scope:** Waves 1 + 2 + 3 + 4 (14 sub-items, settings + ref-doc + 2 CLAUDE.md edits). Net: ~7 commits, ~70–90k tokens. Operator's "include as much as you can" maps here — bundles the high-leverage CLAUDE.md edits without overflowing into structural skill/command creation.
- **Max scope:** Recommended + Wave 5 items 14 or 15 or 16 (one of three, not all three — the structural items each warrant their own session). Net: ~9 commits, ~120–150k tokens. Only attempt if Wave 4 lands cleanly and context budget supports continuation.

Selected: **Recommended scope** as the operator-aligned default. Max-scope continuation gated on Wave 4 completion + ≥40% context budget remaining.

## Autonomy Posture

**Gated** — at named decision points only; no per-step confirmation otherwise.

**Stop points:**
- **After plan write** (this turn) — present plan for operator review per operator's explicit ask ("create a session plan"). The operator confirms the scope alternative (min / recommended / max) and any item-level adjustments before execution begins.
- **Per /risk-check verdict** — RECONSIDER or NO-GO from any /risk-check (Wave 2 items 7–10, Wave 3 item 11, Wave 4 items 12–13). RECONSIDER triggers an inline mitigation discussion; NO-GO drops the item and continues.
- **Per /qc-pass DISAGREE on substantive items** — Wave 4 only (CLAUDE.md edits). Decision-Point Posture says auto-apply recommended default; DISAGREE means operator pause is warranted.
- **DR-8 gate surface** — at session end, before /wrap-session: surface item 22 (concurrent-session detection hook) as a yes/no question. Operator GO triggers a follow-on dedicated session; otherwise re-deferred.

## Risk

Run `/risk-check` after the plan is approved (plan-time gate). Run it again before commit (end-time gate).

Per-item /risk-check map (in execution order):
- **Wave 1 (items 1–6):** no /risk-check (additive logs + investigation + decision lines + meta-scheduling).
- **Wave 2 (items 7–10):** plan-time + end-time per item. Items 7+8+10 may share a single plan-time /risk-check if scope groups (same project + same change class). Item 9 separately (user-level settings).
- **Wave 3 (item 11):** plan-time + end-time. Cross-command contract change is automation-with-shared-state-effects per `docs/audit-discipline.md` tripwire.
- **Wave 4 (items 12, 13):** mandatory per item. CLAUDE.md cross-cutting. Items 12 and 13 do NOT share a /risk-check — different sections (QC pipeline vs. AI Resource Creation), different risk profiles.
- **Wave 5 (items 14–16):** /risk-check by item — DEFERRED, but spec'd here so the next session's plan can carry them forward.
- **Wave 8 (item 22):** DR-8 gate itself is the operator-GO mechanism; no additional /risk-check needed at GO time (the gate IS the risk-check).
- **Wave 9 (item 23):** no /risk-check (`/cleanup-worktree` is read-only triage).
