# Risk Check — 2026-05-08

## Change

Session B edits: three shared-infrastructure command file changes — (1) friday-checkup.md: lower STALE detection threshold from >28 to >21 days + add friction-log dormancy check to tactical items; (2) friday-act.md: insert Step 1.7 improvement-log soft-cap check (advisory, asks y/n if >7 active entries); (3) resolve-improvement-log.md: add WARM_PENDING informational tier (>21 days, no prompt) alongside existing STALE_PENDING (>42 days, unchanged).

Context (background; not part of CHANGE_DESCRIPTION):
- All three are existing slash commands in ai-resources/.claude/commands/.
- The edits are end-time (already applied to working tree); risk-check is the pre-commit gate.
- friday-checkup STALE detection at >28 days → >21 days is a one-token threshold change.
- friday-act Step 1.7 is a NEW step inserted between existing Step 1.5 and Step 2.
- resolve-improvement-log WARM_PENDING is a new informational tier; existing STALE_PENDING (>42 days, per-item disposition prompt r/e/c/k) is unchanged.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-improvement-log.md — exists

## Verdict

GO

**Summary:** Three small, self-contained slash-command edits — a threshold tweak, a new advisory tactical item, an inserted advisory soft-cap prompt, and a new informational age tier — all confined to existing commands with no external dependents and clean git-revert reversibility.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the three files are auto-loaded; slash commands are pay-as-used and only spent when the operator invokes `/friday-checkup`, `/friday-act`, or `/resolve-improvement-log` (verified by inspection of frontmatter — `model: sonnet` only, no auto-load directive).
- No SessionStart / Stop / PreToolUse / UserPromptSubmit hook is added or modified by this change set (`git diff --stat HEAD` shows only the three command files; no `.claude/hooks/*.sh` touched).
- No `@import` chain is introduced; no entry in workspace or repo CLAUDE.md is added.
- Per-invocation cost delta is small: friday-checkup gains one tactical-bullet check (~5 lines added at line 299); friday-act gains a ~15-line Step 1.7 (early-exit if file absent); resolve-improvement-log gains a ~10-line WARM_PENDING display block. Each fires at most once per invocation of its parent command, which run on weekly+ cadences.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json`, `allow`, `ask`, or `deny` rule is touched. `git diff --stat HEAD` confirms the change set is exactly the three command markdown files.
- No new tool family is invoked: friday-checkup already reads `logs/friction-log.md` shape via existing similar checks; friday-act already does Read on `improvement-log.md`; resolve-improvement-log already operates on the same file. All three new code paths reuse Read/Edit on paths the commands already touched.
- No scope-escalation (no project→user move; no cross-repo write).

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 3 (verified by `git diff --stat HEAD`).
- Cross-references checked via grep across ai-resources for `friday-checkup` / `friday-act` / `resolve-improvement-log`:
  - Hook reference: `.claude/hooks/friday-checkup-reminder.sh` — references the command name only, not internal step structure. Unaffected.
  - Agent reference: `.claude/agents/findings-extractor.md` — delegated by `/friday-checkup` Step 7.16. The change is in Step 6 (tactical follow-ups). Unaffected.
  - Agent reference: `.claude/agents/improvement-analyst.md`, `.claude/agents/log-sweep-auditor.md` — both reference `/resolve-improvement-log` as the canonical archiver, not internal step structure. Unaffected.
  - Command reference: `.claude/commands/friday-journal.md` — schema contract with `/friday-act` is at Step 3.5 sub-step 16f (the `## Items` / `[risk] {text}` regex). The new Step 1.7 is upstream of Step 3.5 and does not alter the regex or the items section. Unaffected.
  - Command reference: `.claude/commands/monday-prep.md` line 149 — references `/resolve-improvement-log` invocation conditions only. Unaffected.
- No contract change. The friday-checkup → friday-act schema contract (section headings `## Tactical follow-ups`, `## Policy-level observations`, `## Architectural retrospective`) is unchanged. The friction-log-dormancy bullet is added inside `## Tactical follow-ups`, conforming to the existing item shape `[ ] {item} — risk: {low|med|high}`. Verified by reading friday-checkup.md lines 282–302 and friday-act.md lines 99–101.
- The friday-act Step 1.7 prompt asks `(y/n)` and stops on `n`; this is consistent with the command's existing prompt style (Step 0 of friday-checkup uses the same shape). No new prompt vocabulary.

### Dimension 4: Reversibility
**Risk:** Low

- All three changes are pure markdown edits in tracked files; `git revert` of the eventual commit would fully restore prior content with no orphan files.
- No log mutations are introduced by this change set itself (the changes describe behavior of commands the operator runs; they do not run the commands here).
- No external state propagation (no push, no Notion, no API write).
- No automation introduced — the new step in friday-act is an inline operator prompt, not a hook.

### Dimension 5: Hidden Coupling
**Risk:** Low

- friday-checkup STALE threshold (>28 → >21) coupled with resolve-improvement-log WARM_PENDING (>21 days, ≤42): the two thresholds now align. Both surface the same population of entries (>21 days, status `logged (pending)` or related). This is intentional alignment, not silent overlap — friday-checkup emits a `[STALE]` tactical follow-up at >21 days and resolve-improvement-log emits a WARM informational notice at >21 days. Different commands, same age boundary, complementary surfacing (one in the weekly checkup tactical list, one when archiving). Operator is informed at both touchpoints; no double-disposition (resolve-improvement-log's WARM tier explicitly says "no per-item prompt").
- friday-act Step 1.7 reads `{AI_RESOURCES}/logs/improvement-log.md` and counts entries whose `**Status:**` line contains `logged` or `pending`. The pattern matches the convention codified in friday-checkup line 298 ("Status: logged (pending)") and resolve-improvement-log step 3 ("Status is 'logged'/'proposed'/'pending'"). Same convention reused, not a new one.
- The friday-act `(y/n)` soft-cap prompt is advisory: `n` halts the session and redirects the operator to `/resolve-improvement-log`. This is a new control-flow branch but it is documented at the change site (Step 1.7 body) and self-contained within friday-act — no other command depends on it.
- No silent auto-firing in unexpected contexts: all three changes execute only when their parent command is operator-invoked.
- No undocumented contract between commands. The "active set" definition (entries with Status `logged` or `pending`) used in friday-act Step 1.7 is documented at the change site.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `git diff --stat HEAD` for file-touch enumeration; line-anchored reads of friday-checkup.md (lines 282–302), friday-act.md (lines 73–88, 99–101), resolve-improvement-log.md (lines 18–36); grep across ai-resources for `friday-checkup` / `friday-act` / `resolve-improvement-log` to enumerate dependents (hooks, agents, sibling commands); and inspection of `docs/audit-discipline.md` to confirm the change classes apply (new-command structural change, but only as command-content edits — no new command file, no new symlink, no permission edit, no hook edit). No training-data fallback was used.
