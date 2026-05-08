# AI Journal

Log things to fix, implement, or investigate as you work in the repo.
Format is freeform — be as messy as you like. `/friday-journal` will
clarify entries on Friday.

---

<!-- Active entries below this line. Add one per line or short paragraph. -->

Permission prompts — root cause is the deny list in ai-resources/.claude/settings.json (8 entries: Bash rm/sudo/git push + 5 Read denies on archive/deprecated/old paths). Per memory rule "never add to deny list, bypass mode is the floor", this list should not exist. Deny rules override bypassPermissions and trigger prompts on matching paths. Fix: remove the entire "deny": [...] array from ai-resources/.claude/settings.json (lines 10–19). Falls under "Permission changes" in audit-discipline.md § Risk-check change classes — needs /risk-check before applying. Logged 2026-05-08.

## Archive

<!-- Processed entries get appended here by /friday-journal as
     `## Archive — YYYY-MM-DD` blocks. Archive is one-way (active
     section is cleared on operator confirmation); recovery path is
     `git log` / `git checkout` of this file. -->
