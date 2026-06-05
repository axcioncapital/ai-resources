# Friday Act Plan — 2026-06-05 — settings-permissions

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 2

## Items

### 1. [high] Fix `ai-resources/.claude/settings.local.json` — add `defaultMode` (or remove the shadowing permissions block) so `bypassPermissions` is restored; widen its allow list
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (permission-prompt surface)
- **W2.4 auto-draft:** no

CRITICAL finding. The file's `permissions` block has no `defaultMode`, so it shadows the parent's `bypassPermissions` and causes permission prompts in every ai-resources session — directly defeating the zero-prompt working mode. The same file's allow list also has only 5 narrow Bash entries (no bare Edit/Write/Bash). Fix: either add `defaultMode: bypassPermissions` to the local file, or remove the local `permissions` block entirely so the parent setting governs. Confirm against `docs/permission-template.md` canonical shapes before editing.

### 2. [high] Add `Read(...)` deny rules at workspace root + extend ai-resources/research-pe deny coverage to stale audit/log/report/working dirs
- **Source:** checkup
- **Risk-check required:** yes — change class: settings.json (harness-config — operator-gated per Autonomy Rule 8)
- **W2.4 auto-draft:** no

Workspace root has ZERO `Read()` deny rules; ai-resources and research-pe are partial. `.gitignore` blocks commit but NOT read, leaving stale audit/log/report/working content exposed to accidental exploration reads. Highest-leverage token lever (literature cites 40–70% per-request context reduction). Add `Read()` deny rules for stale audit/log/report/working directories at workspace root and extend the partial coverage in ai-resources + research-pe.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
