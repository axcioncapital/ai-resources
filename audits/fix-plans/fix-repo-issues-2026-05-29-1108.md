# Fix plan — 2026-05-29 11:08

**Source command:** `/fix-repo-issues`
**Scopes scanned:** ai-resources, project ai-development-lab, project axcion-ai-system-owner (0 items), project nordic-pe-macro-landscape-H1-2026, project nordic-pe-screening-project
**Scanner notes (per scope):**
- ai-resources: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-ai-resources.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-ai-resources.md)
- project ai-development-lab: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-ai-development-lab.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-ai-development-lab.md)
- project axcion-ai-system-owner: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-axcion-ai-system-owner.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-axcion-ai-system-owner.md) *(0 items)*
- project nordic-pe-macro-landscape-H1-2026: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-nordic-pe-macro-landscape-H1-2026.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-nordic-pe-macro-landscape-H1-2026.md)
- project nordic-pe-screening-project: [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-nordic-pe-screening-project.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fix-repo-issues-2026-05-29-1108-project-nordic-pe-screening-project.md)

**Plans directory:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/
**Items:** 8

## How to execute

Open a fresh Claude Code session. Each item's `**Scope:**` field names the working directory it applies in — `cd` into that directory before applying its fix.

Instruct fresh-session Claude:

> Execute the fix plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/fix-plans/fix-repo-issues-2026-05-29-1108.md`.

Each item below is self-contained — apply in order, in the scope its `**Scope:**` field names. Commit per item or per logical batch (operator preference). For improvement-log status updates, read `ai-resources/.claude/commands/resolve-improvement-log.md` first to confirm the canonical `**Status:** applied YYYY-MM-DD` + `**Verified:**` schema before editing.

Do NOT execute fixes in the planning session that produced this file.

## Items

### [ai-resources/id-01] Resolve innovation-registry row — settings-pattern #UserPromptSubmit-decision-log
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md) line 102 (`triaged:graduate-stale`, 13 days old)
- **Fix:** Read the registry entry at line 102. Then verify in the canonical `ai-resources/.claude/settings.json` (and `~/.claude/settings.json` if relevant) whether the `UserPromptSubmit` decision-log pattern is in fact present and active. Two branches:
  - **If graduated already** → update the Status field to `graduated 2026-05-29` and add a one-line note pointing to the canonical settings file path where the pattern lives.
  - **If not yet graduated** → flip Status to `re-parked needs-/graduate-resource 2026-05-29` and stop. Do NOT run /graduate-resource inline — that is a separate pipeline session.
- **Post-fix log update:** `logs/innovation-registry.md` Status field updated per branch above.
- **QC needed:** no — log-hygiene-only edit.

### [ai-resources/id-02] Resolve innovation-registry row — settings-pattern #Stop-checkpoint-nag
- **Scope:** ai-resources — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/innovation-registry.md) line 103 (`triaged:graduate-stale`, 13 days old)
- **Fix:** Same shape as id-01 above, but for the `Stop` hook checkpoint-nag pattern. Read the row, verify presence in canonical settings, then flip Status to either `graduated 2026-05-29` or `re-parked needs-/graduate-resource 2026-05-29`.
- **Post-fix log update:** `logs/innovation-registry.md` Status field updated per branch above.
- **QC needed:** no — log-hygiene-only edit.

### [project-nordic-pe-macro-landscape-H1-2026/id-03] Smoke-test check-archive.sh CLAUDE_PROJECT_DIR fix
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md) line 193 — fix shipped 2026-05-29 commit `17de7ca`
- **Fix:** Smoke-test the shipped fix. From within the project working directory:
  ```bash
  CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh
  ```
  Verify it runs without the `CLAUDE_PROJECT_DIR unset` error that was the original friction. If the script succeeds, the fix is verified. If it fails for any other reason, capture the error and re-open the improvement-log entry as `Status: re-opened 2026-05-29` with the error captured.
- **Post-fix log update:** Flip the improvement-log entry at line 193 to `**Status:** applied 2026-05-29` + `**Verified:** 2026-05-29` per canonical schema (see `ai-resources/.claude/commands/resolve-improvement-log.md`).
- **QC needed:** no — verify-then-flip task.

### [project-nordic-pe-screening-project/id-04] Provision logs/scripts/check-archive.sh in nordic-pe-screening-project
- **Scope:** project nordic-pe-screening-project — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md) (2026-05-29 Session D Open Q)
- **Fix:** Verify the script is absent (`ls logs/scripts/check-archive.sh` returns no such file). Then:
  ```bash
  mkdir -p logs/scripts
  cp "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-archive.sh" logs/scripts/check-archive.sh
  chmod +x logs/scripts/check-archive.sh
  CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh
  ```
  Confirm the run succeeds (exit 0 with no error).
- **Post-fix log update:** none — this is a missing-script provisioning, not a tracked log entry. The next `/wrap-session` in this project will exercise the script naturally.
- **QC needed:** no — file-copy + smoke-test.

### [project-nordic-pe-screening-project/id-05] Commit untracked pipeline/children/w1/
- **Scope:** project nordic-pe-screening-project — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-screening-project/logs/session-notes.md) (2026-05-28+ carryforward Open Q — 6+ session carryover)
- **Fix:** Verify scope first:
  ```bash
  git status -u pipeline/children/w1/
  ```
  Confirm the untracked files are W1 child plan + context pack (and only these — no stray work, no in-progress drafts). If the diff looks clean and bounded to W1, stage and commit:
  ```bash
  git add pipeline/children/w1/
  git commit -m "pipeline: w1 — commit child plan + context pack"
  ```
  If the diff includes anything beyond W1 (e.g., stray edits to W2/W3 files, partial drafts, debug scratch), STOP and re-open the open question with the unexpected files listed.
- **Post-fix log update:** Add a one-line note to `logs/session-notes.md` Process Notes (under today's header if exists, else append a small note): `W1 child plan + context pack committed in {hash} — Open Q resolved.`
- **QC needed:** no — git operation with explicit scope check.

### [project-nordic-pe-macro-landscape-H1-2026/id-06] Verify /session-plan Step 0 MISMATCH fix actually suppressed firing
- **Scope:** project nordic-pe-macro-landscape-H1-2026 — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md) line 217 — verification gap, not a new defect
- **Fix:** Confirm the fix landed in the path this project executes:
  ```bash
  readlink .claude/commands/session-plan.md
  ```
  Either:
  - **If symlink resolves to canonical `ai-resources/.claude/commands/session-plan.md`** → `grep -n "signal-A\|signal-B\|MISMATCH" "$(readlink -f .claude/commands/session-plan.md)"` and confirm the Step 0 dual-signal check is present. If present → the fix DID land. Then the bug is that wrap-session boilerplate keeps re-emitting "no infrastructure fix landed" as stale text. Update the relevant `/wrap-session` boilerplate (see `ai-resources/.claude/commands/wrap-session.md`) to stop re-emitting that line when the fix has shipped.
  - **If the symlink is broken, or Step 0 dual-signal check is absent** → the fix did NOT land in this project's path. Re-open the improvement-log entry at line 217 as `**Status:** re-opened 2026-05-29` with a one-line note explaining why (broken symlink / missing logic).
- **Post-fix log update:** Either flip improvement-log line 217 to `**Status:** applied {date} **Verified:** 2026-05-29` (if the fix worked + boilerplate was the stale source) OR re-open per the branch above.
- **QC needed:** no — bounded investigation with two clear branches.

### [project-ai-development-lab/id-07] Provision logs/scripts/check-archive.sh in ai-development-lab
- **Scope:** project ai-development-lab — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/logs/improvement-log.md) line 60 (7-project rollout — this item is the ai-development-lab slice only; other 6 projects stay parked)
- **Fix:** Same shape as id-04 (nordic-pe-screening provisioning). From within the project working directory:
  ```bash
  ls logs/scripts/check-archive.sh 2>/dev/null && echo "already present, skip" || {
    mkdir -p logs/scripts
    cp "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-archive.sh" logs/scripts/check-archive.sh
    chmod +x logs/scripts/check-archive.sh
    CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh
  }
  ```
- **Post-fix log update:** Add a one-line update to `logs/improvement-log.md` line 60 entry noting `ai-development-lab provisioned 2026-05-29; remaining projects: {list}`. Keep the multi-project entry open (it tracks the full rollout).
- **QC needed:** no — file-copy + smoke-test.

### [project-nordic-pe-macro-landscape-H1-2026/id-08] Document settings.json _comment-key rejection and canonical fallback
- **Scope:** ai-resources *(applies cross-scope to ai-resources docs)* — path: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
- **Source:** [/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md](/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/nordic-pe-macro-landscape-H1-2026/logs/improvement-log.md) line 205 — full rule text already drafted in the proposal
- **Fix:** Two-file doc edit, no authoring needed (drafted text is paste-ready):
  1. **`ai-resources/docs/permission-template.md`** — append a `## Caveats` section (or extend if it already exists) with the paragraph drafted in the improvement-log line 205 proposal:
     > Claude Code's `settings.json` schema is strict — top-level `_*` comment keys are rejected at session load. Cross-reference notes belong in a sibling `.claude/PERMISSIONS-NOTES.md` external file, not inline. The FX-E2 cross-reference at `projects/nordic-pe-macro-landscape-H1-2026/.claude/PERMISSIONS-NOTES.md` is the reference shape.
  2. **`ai-resources/docs/audit-discipline.md`** — under `§ Risk-check change classes`, add a one-line cross-link: `Inline _comment keys in settings.json are rejected schema-side — see permission-template.md § Caveats for the canonical fallback.`
- **Post-fix log update:** Flip the improvement-log entry at line 205 to `**Status:** applied 2026-05-29 **Verified:** 2026-05-29`.
- **QC needed:** yes — `/qc-pass` after applying, since this touches a canonical reference doc consumed by risk-check reports.

## Parked items (not this plan)

- **[ai-resources/id-01, id-02, id-07, id-09]** four build briefs (Codex auditor 46d, workflow-diagnosis 10d, audit-workflow-pipeline 2d, /repo-review) — reason: `needs-/create-skill`
- **[ai-resources/id-03..id-08]** 5 innovation-registry pending-triage rows (3-day-old skills + commands + agents) — reason: `needs-/innovation-sweep`
- **[ai-resources/id-12]** archive-ordering open question if deny-rule lifted — reason: `decision-needed`
- **[ai-resources/id-13]** `/cleanup-worktree` deferral (today) — reason: `needs-dedicated-session` (carryover task #1 in /prime)
- **[ai-resources/id-14..id-20]** 7 innovation-registry loose-ends triaged 13d ago — reason: `decision-needed` (keep-local / graduate / retire per row)
- **[ai-resources/id-21]** TOCTOU mitigation Phases 2-4 — reason: `needs-dedicated-session` (carryover task #2)
- **[ai-resources/id-22..id-32]** 11 improvement-log watch items (most gated by triggers not yet fired) — reason: `trigger-not-fired` / `multi-file-refactor`
- **[project-ai-development-lab/id-01, id-02]** AMBIGUOUS-REFERENT and CONCURRENT-SESSION friction-log incidents — reason: `decision-needed`
- **[project-ai-development-lab/id-03..id-06]** 4 open questions (implementation-starter format, /develop-memo gap pick, word-cap doc conflict, Gap-2 trade-off) — reason: `decision-needed`
- **[project-ai-development-lab/id-07..id-12]** 6 improvement-log pending watch items (id-13 promoted to batch) — reason: `multi-file-refactor` / `decision-needed`
- **[project-ai-development-lab/id-08]** ambiguous-referent self-check rule (drafted text targets workspace `CLAUDE.md` pointer) — reason: `structural-class-needs-/risk-check` *(cross-cutting CLAUDE.md edit per `audit-discipline.md § Risk-check change classes`)*
- **[project-nordic-pe-macro-landscape-H1-2026/id-01]** Chapter 07 prose-pasting incident — reason: `decision-needed`
- **[project-nordic-pe-macro-landscape-H1-2026/id-03, id-04]** produce-prose-draft + produce-jargon-gloss `triaged:graduate` 10d — reason: `needs-/graduate-resource`
- **[project-nordic-pe-macro-landscape-H1-2026/id-05, id-06]** Open Qs WU4a parallel terminal + mandate alignment — reason: `decision-needed`
- **[project-nordic-pe-macro-landscape-H1-2026/id-07, id-09]** 2 improvement-log watch items (wrap-session header inflation, innovation-sweep cadence) — reason: `multi-file-refactor` / `needs-dedicated-session`
- **[project-nordic-pe-macro-landscape-H1-2026/id-11]** Innovation-sweep cross-repo write — reason: `confirm-step-before-fix` *(proposal hedges "may be by-design; confirm or codify" — bounce risk in batch execution)*
- **[project-nordic-pe-screening-project/id-01, id-02, id-03]** R3.4 rule wording / pipeline-vs-logs decisions canonicity / W2-W4 README scan — reason: `decision-needed`
- **[project-nordic-pe-screening-project/id-06]** GitHub remote not configured — reason: `operator-external-action`
- **[project-nordic-pe-screening-project/id-07]** R2.3 S1b prompt addendum — reason: `explicitly-deferred-by-operator`

## Skipped items

- (none — scanners already filtered FADING-GATE verified, STUB discarded, applied+Verified, parked-with-reason, and LOW-tagged entries; nothing remaining in the candidate set is dead)
