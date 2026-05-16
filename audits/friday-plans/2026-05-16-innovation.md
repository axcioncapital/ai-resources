# Friday Act Plan — 2026-05-16 — innovation

**Source report:** friday-checkup-2026-05-16.md (weekly tier)
**Journal report:** audits/friday-journal-2026-05-16.md
**Generated:** 2026-05-16
**Items:** 4

## Items

### 1. [low] G6: Graduate CLAUDE.md §Compaction "trust the summary" cost-test rule to compaction-protocol.md
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, G6)
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** `interpersonal-communication/CLAUDE.md` §Compaction (lines 26–35) contains a post-compact resumption rule not currently in `ai-resources/docs/compaction-protocol.md`: "trust the summary — run a cost-test before any verification call." Add this formulation to the canonical `compaction-protocol.md` in the post-compact resumption section. The rule is already in workspace memory (`feedback_trust_compaction_summary.md`) but not in the doc that skills reference. Source text from interpersonal-communication CLAUDE.md to preserve exact wording.

### 2. [low] LE4: Fix broken symlink obsidian-pe-kb/.claude/commands/resolve-improvements.md
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, LE4)
- **Risk-check required:** yes — change class: new symlink (if repointing) or deletion
- **W2.4 auto-draft:** no
- **Detail:** `projects/obsidian-pe-kb/.claude/commands/resolve-improvements.md` is a broken symlink pointing to a non-existent ai-resources target. Likely stale after the canonical command was renamed from `resolve-improvements` → `resolve-improvement-log`. Action: delete the broken symlink and create a new symlink pointing to `ai-resources/.claude/commands/resolve-improvement-log.md`. Run `/risk-check` before executing (new symlink change class).

### 3. [low] LE5: Remove model field from obsidian-pe-kb/.claude/settings.json
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, LE5)
- **Risk-check required:** yes — change class: settings.json
- **W2.4 auto-draft:** no
- **Detail:** `projects/obsidian-pe-kb/.claude/settings.json` contains a top-level `"model"` field. This violates the workspace memory rule `feedback_no_model_in_settings_json` (never add model field to settings.json; causes downstream issues). Remove the field. Before removing, read the current settings.json to confirm this is not an intentional override. Run `/risk-check` before editing.

### 4. [low] Update innovation-registry.md: append 22 new entries from innovation-sweep-2026-05-16
- **Source:** journal-derived (innovation-sweep-2026-05-16.md, Registry Updates Needed section)
- **Risk-check required:** no
- **W2.4 auto-draft:** no
- **Detail:** The innovation sweep identified 22 new items not previously in `ai-resources/logs/innovation-registry.md`: 7 graduate candidates (triaged:graduate), 7 loose ends (triaged:loose-end), and 8 keep-local/already-graduated items. Append all 22 entries in the pipe-delimited table format used by the registry. Source: the `## Registry Updates Needed` section of `ai-resources/audits/innovation-sweep-2026-05-16.md`. Note: the awk command in `/prime` Step 2 checks `Status` column for `detected` — the new entries use `triaged:*` status values and will not be counted as pending innovations after this update.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For items 2 and 3 (symlink + settings.json): run `/risk-check` before executing each.
- Item 4 (registry update) is a log-append only — no risk-check required.
- Run `/wrap-session` when all items in this plan are done.
