# Friday Act Plan — 2026-06-05 — claude-md-template

**Source report:** friday-checkup-2026-06-05.md (monthly tier)
**Journal report:** (none)
**Generated:** 2026-06-05
**Items:** 3

## Items

### 1. [high] Correct the stale push-rule in `marketing-positioning` + `research-pe` project CLAUDE.md (and re-issue from a corrected `/new-project` template)
- **Source:** checkup
- **Risk-check required:** yes — change class: project CLAUDE.md
- **W2.4 auto-draft:** no

Both `marketing-positioning` and `research-pe` project CLAUDE.md files still say "pushing is a manual operator step" (the pre-2026-05-29 inverted rule), contradicting the current gated-batch push rule. This corrupts wrap-session push behavior. Replace the stale Commit/Push rules with the current canonical gated-batched push text. Pairs with item 2 (the template root cause).

### 2. [high] Fix the `/new-project` CLAUDE.md template: drop the verbatim `Input File Handling` block (→ pointer), fix the stale workspace-section anchor, de-dup `Commit Rules`
- **Source:** checkup
- **Risk-check required:** yes — change class: project CLAUDE.md template (shapes every future project CLAUDE.md; SO advisory flagged as risk-check gate)
- **W2.4 auto-draft:** no

Systemic root cause of per-project bloat: every project inherits a verbatim `Input File Handling` block (dup + stale anchor citing a renamed workspace section) and a duplicated `Commit Rules` block. Fixing the template once stops the recurrence across all future projects and recovers ~6,400+ tokens/turn in aggregate across the 8 existing files. Edit the template fragment under `templates/`, not the consuming command (per `templates/README.md` consumer contract).

### 3. [med] De-version the `claude-opus-4-7` pins in nordic-pe + project-planning Model Selection to tier "Opus"
- **Source:** checkup
- **Risk-check required:** yes — change class: project CLAUDE.md
- **W2.4 auto-draft:** no

`nordic-pe` and `project-planning` Model Selection sections pin `claude-opus-4-7` (now 4.8). De-version to tier ("Opus") rather than point-version, so the pin is self-maintaining as models advance. Consider applying the same de-versioning in the `/new-project` template (ties to item 2) to make it self-maintaining for future projects.

## Execution notes
- Commit each fix separately (workspace commit-behavior rules).
- For any item marked "Risk-check required: yes", run `/risk-check` before executing that item.
- For any item marked "W2.4 auto-draft: yes", decide auto-draft vs. manual at execution time per the W2.4 sub-disposition in the `/friday-act` Step 3 W2.4 instructions.
- Run `/wrap-session` when all items in this plan are done.
