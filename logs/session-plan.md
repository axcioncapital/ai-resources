# Session Plan — 2026-05-28

## Intent
Execute the 8-item fix plan at `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md`.

## Class
execution (judgment-heavy on items 7 + 8)

## Model
opus — match

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-28-1121.md` (the plan itself, with per-item Scope / Source / Fix / QC fields)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md` (canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md` (id-01 + id-11+ scope)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/innovation-registry.md` (id-05+ scope)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/improvement-log.md` (id-03, id-04, id-06)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/logs/friction-log.md` (id-02 `[FADING-GATE] verified` annotation)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json` (id-06)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md` (id-01 diff target)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md` (id-02 edit target + id-01 diff canonical)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md` (id-06 path a fit check)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/qc-independence.md` (`/qc-pass` reference for id-02 + id-06 path a)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (risk-check change-class reference for id-02 + id-06)

## Findings / Items to Address

1. **[ai-resources/id-01]** Broken symlink at `projects/obsidian-pe-kb/.claude/commands/resolve-improvements.md`. Determine if it should repoint to canonical `resolve-improvement-log.md` or be deleted; update innovation-registry row accordingly. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#ai-resources/id-01`.
2. **[ai-resources/id-11+12+13+14+15+18+19+20+21]** Innovation-registry status flip — 9 already-canonical rows: `triaged:graduate` → `graduated`. Spot-check each canonical path with `ls` before flipping. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#ai-resources/id-11`.
3. **[project-nordic-pe-macro/id-05+06+07+08+09+10]** Innovation-registry status flip — 6 rows in nordic project, `Graduated To` populated. Spot-check `Graduated To` is non-empty before flipping (id-03/id-04 are parked, must not flip). Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#project-nordic-pe-macro-landscape-H1-2026/id-05`.
4. **[project-brand-book/id-03]** Backfill `**Verified:** 2026-05-28` line in brand-book improvement-log entry "Backfill _appendix/rejected_directions.md...". Verify `output/_appendix/rejected_directions.md` actually contains the 9+10 rejections before adding the Verified line. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#project-axcion-brand-book/id-03`.
5. **[project-brand-book/id-04]** Brand-book git remote is broken (returns 404). Default to `git remote remove origin` (local-only); ask operator inline if a correct remote URL is available. Add new improvement-log entry capturing the choice. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#project-axcion-brand-book/id-04`.
6. **[project-nordic-pe-macro/id-01]** Verify 2026-05-22 HIGH `/session-plan` fix reached project-local copy. Diff `projects/nordic-pe-macro-landscape-H1-2026/.claude/commands/session-plan.md` vs canonical. If stale, swap; then add Verified line to the 2026-05-22 improvement-log entry. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#project-nordic-pe-macro-landscape-H1-2026/id-01`.
7. **[project-brand-book/id-02]** [QC] Add same-session short-circuit to `ai-resources/.claude/commands/session-plan.md` Step 0 MISMATCH branch — use a reliable own-session marker (candidate: `logs/.prime-mtime`) to bypass silent-pass2 auto-routing when intent strings differ but session is the same. Verify by replay. Flip friction-log entry to verified + new improvement-log entry. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#project-axcion-brand-book/id-02`.
8. **[project-brand-book/id-06]** [QC if path a] `settings.json` deny pattern blocks `/draft-module`. Default to path (a) — relax the specific deny pattern, cross-check against `docs/permission-template.md`. Fallback to path (b) — document workaround in CLAUDE.md — only if (a) risks breaking other guardrails. Status-flip the improvement-log entry. Source: `audits/fix-plans/fix-repo-issues-2026-05-28-1121.md#project-axcion-brand-book/id-06`.

## Execution Sequence

1. **Batch A — ai-resources log-hygiene + symlink (items 1-2) + nordic registry flip (item 3).** `cd` into ai-resources, apply id-01 (symlink) and id-11+ (9 registry flips with per-row `ls` spot-check). Then `cd` into nordic-pe-macro project, apply id-05+ (6 registry flips with `Graduated To` non-empty spot-check). Verify by reading the two modified registry files. Commit as one logical batch ("batch: innovation-registry status flips + symlink"). Verification: registry rows show `graduated` status; symlink resolved (either repointed or removed).
2. **Batch B — brand-book log-hygiene + git remote (items 4-5).** `cd` into brand-book. id-03: verify `output/_appendix/rejected_directions.md` content before adding Verified line. id-04: run `git remote -v`, default to `remote remove origin` (per `feedback_autonomy_during_execution` — proceed with default), append improvement-log entry. Commit ("batch: brand-book log-hygiene + remote cleanup"). Verification: improvement-log shows Verified line on id-03 entry; `git remote -v` returns empty; new improvement-log entry for id-04 with applied+Verified.
3. **Item 6 — nordic session-plan parity verify.** `cd` into nordic-pe-macro project. Diff project-local `session-plan.md` vs ai-resources canonical. If symlink — Verified line immediately. If divergent — swap to canonical (or repoint as symlink) then add Verified line. Commit ("update: nordic-pe-macro session-plan parity + verified line"). Verification: diff is empty; improvement-log shows Verified line.
4. **Item 7 — id-02 same-session short-circuit (QC-required).** Read `ai-resources/.claude/commands/session-plan.md` Step 0 in full. Identify the MISMATCH branch and the `logs/.prime-mtime` marker semantics in `/prime` Step 8a/8b/8c. Design the short-circuit: if `logs/.prime-mtime` exists AND correlates with the existing `session-plan.md` mtime (own-session correlation), route to the 3-option keep/overwrite/pass2 prompt instead of silent-auto-pass2. Apply edit. Run `/risk-check` (Tripwire applies — reorders against shared-state). Run `/qc-pass`. Verify by reasoning through four canonical scenarios: (a) same-session same-intent, (b) same-session different-intent, (c) different-session same-intent, (d) different-session different-intent. Flip friction-log entry + new improvement-log entry. Commit.
5. **Item 8 — id-06 settings.json deny (QC if path a).** Read brand-book `settings.json` deny list. Cross-reference improvement-log narrative for the blocking pattern. Read `/draft-module` write paths. Pick path (a) unless deny pattern is structurally protective. If path (a): edit settings.json minimally, cross-check `docs/permission-template.md`. Run `/risk-check` (permission change). Run `/qc-pass`. If path (b): one-paragraph note in brand-book CLAUDE.md, no `/qc-pass` needed. Status-flip the improvement-log entry. Commit.
6. **Wrap (no commit).** Confirm 5 commits landed (Batch A, Batch B, item 6, item 7, item 8 — or 4 if item 8 takes path b). Surface push gate: 22 unpushed before this session + this session's commits. Operator approval required before push (Autonomy Rule #2). Remind operator to run `/wrap-session`.

## Scope Alternatives

- **Min scope (items 1-6 only).** Skip the two QC-required edits (id-02, id-06). Defer to a follow-up session. Cost: ~30-50% of full plan; defers the highest-judgment items. Useful only if context is constrained mid-session.
- **Recommended (all 8 items).** As planned. Items 1-6 are mechanical and ship fast; items 7-8 are the load-bearing work and benefit from a fresh-context Opus session.
- **Max scope** is not applicable — the plan is fixed-scope by the /fix-repo-issues two-session contract. Adding items mid-session would violate the plan's own boundary.

## Autonomy Posture

**Full autonomy** with stop points reserved for genuinely important issues only (per workspace `feedback_autonomy_during_execution`: resolve operator-decision flags with recommended defaults; only pause for important issues).

**Stop points:**
- **id-02 step 5** — if no reliable own-session marker exists at all. `logs/.prime-mtime` is the documented candidate; if it does not exist or is unreliable, surface to operator before picking (a) define-one vs (b) document-limitation.
- **id-06 step 3** — if the deny pattern blocking `/draft-module` is structurally protecting something else (not just a stale entry), surface before applying path (a). Otherwise default to (a).
- **Registry spot-checks** — if any row's canonical path is wrong (id-11+ or id-05+), surface that row instead of flipping silently.
- **id-03 verification** — if `output/_appendix/rejected_directions.md` is missing or empty, do NOT add Verified line; surface to operator.

All other operator-decision flags resolve to their stated defaults (id-04 default = `remote remove origin`).

## Risk

**Run `/risk-check` after this plan is approved (plan-time gate). Run it again before commit on items 7 and 8 (end-time gate).**

Structural change classes involved:
- **Item 7 (id-02)** — Edits `ai-resources/.claude/commands/session-plan.md` Step 0, which reorders operations against shared-state (concurrent-session collision detection across multiple terminals/sessions). Step 6 Tripwire applies — the "existing-command refactor" framing does NOT exempt.
- **Item 8 path a (id-06)** — Edits a project's `.claude/settings.json` permission deny list. Permission change → structural class per `docs/audit-discipline.md`.

Items 1-6 are log-hygiene / single-file symlink / git-remote config — no structural change classes.

End-time `/risk-check` may be skipped per operator memory `feedback_end_time_risk_check_skip` if plan-time gate covered the concerns AND drift is bounded AND `/qc-pass` is clean — document the skip in the commit message if so.
