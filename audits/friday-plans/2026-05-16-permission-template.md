# Friday Act Plan — 2026-05-16 — permission-template

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 3

## Items

### 1. [med] G1: Graduate SessionStart upward-walk pattern to permission-template.md
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, G1)
- **Risk-check required:** yes — change class: settings.json/hooks (doc edit to permission-template.md is class-free; the follow-on step updating existing projects' hardcoded SessionStart hook paths touches per-project settings.json or hook files, which are in-class)
- **W2.4 auto-draft:** no
- **Detail:** Two projects (nordic-pe-macro-landscape-H1-2026 and repo-documentation) independently evolved the same SessionStart bash one-liner that walks parent directories to locate `ai-resources/.claude/hooks/auto-sync-shared.sh` regardless of project nesting depth. Add this as the canonical SessionStart hook wiring form in `ai-resources/docs/permission-template.md` (under the hook wiring reference section). Also update any existing projects that use hardcoded paths in their SessionStart hooks to use the portable upward-walk idiom. The canonical form:
  ```bash
  d="$CLAUDE_PROJECT_DIR"; while [ "$d" != '/' ]; do d=$(dirname "$d"); [ -f "$d/ai-resources/.claude/hooks/auto-sync-shared.sh" ] && { source ...; exit; }; done
  ```

### 2. [low] G2: Graduate Read-deny pattern for archive/deprecated content to permission-template.md
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, G2)
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** Add the following deny-pattern block to `ai-resources/docs/permission-template.md` as a recommended addition for any project with an archive or deprecated content structure:
  ```json
  "deny": [
    "Read(archive/**)", "Read(**/*.archive.*)",
    "Read(**/deprecated/**)", "Read(**/old/**)"
  ]
  ```
  Insert in the permissions reference section with a brief note: suppresses permission prompts on stale content directories; apply when project has an archive/ or deprecated/ structure.

### 3. [low] G5: Document Five-hook PostToolUse[Write] wiring taxonomy in permission-template.md
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, G5)
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** nordic-pe-macro-landscape-H1-2026 wires five hooks on every Write event: auto-commit, log-write-activity, detect-innovation, auto-qc-nudge, check-claim-ids. The hook scripts already exist in ai-resources; the *fan-out wiring pattern* (chained PostToolUse[Write] hooks) is what's novel. Add to `ai-resources/docs/permission-template.md` as a reference wiring section showing the pattern. **Important:** exclude the auto-commit hook from the documented taxonomy — it conflicts with workspace Commit Rules (LE3 in the innovation sweep). Document the exclusion inline with a note: "auto-commit hook kept project-local due to workspace Commit Rules policy tension."

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- No risk-check required for any item — all are documentation edits to permission-template.md.
- For item 1, after updating permission-template.md, scan existing project settings.json files for hardcoded auto-sync-shared.sh paths and update them to the portable form in the same session.
- Run `/wrap-session` when all items in this plan are done.
