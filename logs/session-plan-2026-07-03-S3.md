# Session Plan — 2026-07-03

## Intent
Fix the whitespace-only tokenizer bug in `check-foreign-staging.sh` that false-blocks commits when a session's `- Files in scope:` mandate bullet uses the canonical semicolon-separated format.

## Model
opus (small blast-radius but this is a shared concurrent-session safety hook — precision over speed) — → /model opus (active session is on Sonnet)

## Source Material
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh` (the file to fix; single copy, no synced duplicates found workspace-wide)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md` (2026-07-02 S3 entry — the original false-block incident report)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` (2026-07-03 entry — "check-foreign-staging.sh whitespace-tokenizes the Files-in-scope bullet")
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md` (hook edits are a mandatory `/risk-check` change class)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` § Two-end contract registry (this hook is not currently listed there — worth confirming it doesn't need a registry entry)

## Findings / Items to Address
1. **Root cause confirmed by direct read.** `check-foreign-staging.sh:301` reads `for tok in re.split(r'[,\s]+', footprint_raw):` — the split pattern covers commas and whitespace only, not semicolons. A canonical mandate bullet like `- Files in scope: path1; path2; path3` (the format `/session-start` Step 3 and `/prime` Step 8c.7 both write) produces tokens `path1;`, `path2;`, `path3` — the first two carry a trailing semicolon that never string-matches a staged path, so the guard flags real, in-scope files as foreign. — source: `logs/improvement-log.md` "2026-07-03 — check-foreign-staging.sh whitespace-tokenizes..." entry, `logs/friction-log.md` 2026-07-02 S3 entry (11 of 12 staged files false-flagged in the real incident; only the list's last entry, with no trailing semicolon, matched).
2. **Minimal, contained fix.** Change the split regex from `r'[,\s]+'` to `r'[,;\s]+'` — semicolon becomes a delimiter alongside comma/whitespace, so `path1; path2` splits cleanly into `path1`, `path2` with no trailing punctuation. The existing per-token cleanup two lines below (`tok.strip().strip("\`").strip()`) already handles backticks and surrounding whitespace; no further change needed there. This does not touch the earlier `no_concrete_footprint` detection regex (a different check, unaffected by delimiter choice).
3. **Known pre-existing limitation, out of scope for this fix.** The friction-log entry also notes that free-form prose in the same bullet (e.g., a parenthetical explanation) gets word-split into junk tokens. Those junk tokens are harmless (they never match a real staged path, so they can't cause a false block or a false pass) — the improvement-log entry's proposed fix only asks for the semicolon-splitting + separator-stripping, not a full grammar for the bullet. Not fixing this here; noting it so it isn't mistaken for unfinished work.

## Execution Sequence
1. **Apply the one-line regex fix** at `check-foreign-staging.sh:301` (`r'[,\s]+'` → `r'[,;\s]+'`). *Verify: `grep -n "re.split" check-foreign-staging.sh` shows the updated pattern; no other line changed.*
2. **Manually exercise the parser** against a semicolon-separated footprint string (e.g., run the script's Python block standalone, or construct a small inline test with `footprint_raw = "path1; path2; path3"` and confirm the resulting token list is `["path1", "path2", "path3"]` with no trailing `;`). *Verify: printed token list matches expectation, no trailing separator on any token.*
3. **Regression-check the comma/whitespace-only case still works** (e.g., `footprint_raw = "path1 path2, path3"` → unchanged behavior). *Verify: token list is `["path1", "path2", "path3"]`, matching pre-fix behavior for this input shape.*
4. **Annotate `logs/friction-log.md`'s 2026-07-02 S3 entry** with a `[FADING-GATE] verified 2026-07-03` note pointing at the commit that lands this fix. *Verify: the entry carries the annotation; no other friction-log content touched.*
5. **Run `/risk-check`** (hook edit — mandatory change class). *Verify: verdict recorded; if non-GO, follow the System-Owner second-opinion step before proceeding, per this session's own earlier experience.*
6. **Commit**, staging only `check-foreign-staging.sh` and the friction-log annotation by explicit path — do not sweep S2's concurrent uncommitted work or the pre-existing `reconcile-*`/instruction-audit/`chat-skills` files. *Verify: `git status` post-commit shows S2's in-progress `session-notes.md` changes and the untracked pre-existing files untouched.*

## Scope Alternatives
Single scope — no alternatives. This is a one-line mechanical fix with a fixed, small verification sequence; there is no meaningful min/max split.

## Autonomy Posture
Gated

**Stop points:**
- After `/risk-check` — if verdict is RECONSIDER or PROCEED-WITH-CAUTION with a substantive objection (as happened on this session's prior attempt), surface the finding before committing rather than pushing through.

## Risk
Hook edit — mandatory `/risk-check` change class per `docs/audit-discipline.md`. Run `/risk-check` after this plan is approved (plan-time gate) and again before commit if the executed change diverges from this plan (end-time gate; per the two-gate firing model, a single gate suffices here since the fix is this small and unlikely to change shape mid-execution). No executable/launcher artifact is being built, so the VS Code launch-environment check does not apply. This hook is a *concurrent-session safety mechanism* — editing it while S2 is live means S2's next gated git verb will run against the new version; the fix only adds a delimiter (strictly more permissive matching for well-formed semicolon input, no behavior change for comma/whitespace input), so it should not introduce new false blocks for S2. No file overlap with S2's declared scope (git config, project settings.json/.local, `.claude/commands/prime.md`, new-project scaffold template, project/workspace CLAUDE.md).
