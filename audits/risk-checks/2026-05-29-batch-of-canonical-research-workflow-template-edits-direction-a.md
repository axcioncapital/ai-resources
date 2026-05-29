# Risk Check — 2026-05-29

## Change

Batch of canonical research-workflow template edits (Direction A templatification finish), 4 items: (2) parameterize hardcoded parts/part-2-service & parts/part-3-strategy paths in canonical .claude/commands/produce-architecture.md + remove stray .bak; (3) change intake-reports.md frontmatter model tier from opus to sonnet (process-following command); (4) possibly graduate a 2-line generic "operator presentation rule" into canonical .claude/commands/review-chapter.md; (5a) add produce-jargon-gloss + run-sufficiency to commands.local in .claude/shared-manifest.json; (5b) possibly refresh 4 drifted template-local shared-command copies (note, qc-pass, refinement-pass, update-claude-md) to match canonical ai-resources/.claude/commands versions. All edits are to the canonical research-workflow template in ai-resources. No project pipeline files change. No hooks, no permissions, no always-loaded CLAUDE.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/produce-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/intake-reports.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/review-chapter.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/shared-manifest.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/note.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-pass.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/update-claude-md.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Edits are confined to a deploy-time template (not always-loaded, no permissions, no hooks), but two items carry latent contract hazards — item 3 introduces a frontmatter/body tier contradiction, and item 5b silently demotes two template copies from opus to sonnet — so the batch needs paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- None of the edited files is always-loaded. The target is the canonical research-workflow **template** under `ai-resources/workflows/research-workflow/.claude/`, deployed to new projects via `/deploy-workflow` placeholder substitution — confirmed by `shared-manifest.json` line 2 `_doc` ("Declares which .claude/ files are shared … The auto-sync hook reads this manifest").
- No hook registration, no `@import`, no CLAUDE.md edit — the CHANGE_DESCRIPTION states "No hooks, no permissions, no always-loaded CLAUDE.md," consistent with the file set (all are slash-command `.md` files + one manifest JSON, all pay-as-invoked).
- Item 3 (intake-reports opus→sonnet) and item 5b (refreshing qc-pass/refinement-pass to canonical `model: sonnet`) **reduce** per-invocation cost where applied — directional savings, not a cost add.
- Item 2 path parameterization adds no runtime cost; it replaces two literal path strings with placeholders resolved at deploy time.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched. CHANGE_DESCRIPTION: "No … permissions." No `settings.json` / `settings.local.json` in the file set.
- No new tool family, Bash pattern, Write path, or external/MCP capability introduced. All edits are content edits to command-definition markdown and one manifest JSON.

### Dimension 3: Blast Radius
**Risk:** Medium

- **Enumeration — produce-architecture.md (item 2):** No canonical copy exists. `ls ai-resources/.claude/commands/produce-architecture.md` → "No such file or directory"; the command lives only at the template path and as `produce-architecture.md.bak` (diff `produce-architecture.md` vs `.bak` → IDENTICAL). So item 2 touches a single self-contained template file; the `.bak` is a redundant duplicate of the live file and safe to remove. **0 external callers.**
- **Enumeration — shared-manifest.json (item 5a):** The manifest's `commands.local` list (lines 4-28) is consumed by two readers: `auto-sync-shared.sh` (line 50, `jq -r '.commands.local[]?'`) and `deploy-workflow.md` (lines 49-52). `produce-jargon-gloss` exists **only** in the template (`find ai-resources -name produce-jargon-gloss.md` → template path only; not in `ai-resources/.claude/commands/`) — so listing it under `commands.local` is correct (it is template-owned, must not be symlinked to a nonexistent canonical source). The already-deployed nordic-pe project manifest already lists `produce-jargon-gloss` at `commands.local` line 64 — the template manifest is currently the lagging copy, so this edit closes an existing template/deployed-project gap.
- **`run-sufficiency` (item 5a) is redundant:** it is already in the hook's baked-in `EXCLUDE_COMMANDS` (`auto-sync-shared.sh` line 46: `EXCLUDE_COMMANDS="new-project deploy-workflow run-sufficiency pipeline-review"`) and has no canonical copy (`ls … run-sufficiency.md` → not found in canonical). Adding it to `commands.local` is harmless but a no-op for the hook; document it as belt-and-suspenders, not a functional requirement.
- **Enumeration — item 5b drift refresh:** all 4 template copies are regular files (not symlinks) and differ from canonical (`diff` confirmed substantive deltas in note, qc-pass, refinement-pass; update-claude-md differs only by a trailing blank line). Refreshing them changes only template-local content; deployed projects symlink the canonical `ai-resources/.claude/commands/` versions for these four (manifest `commands.shared` lines 30-40 list note, qc-pass, refinement-pass, update-claude-md as **shared**), so live projects already run canonical — the template copies are reference-only and 0 live callers depend on the stale template text.
- **Contract note (review-chapter, item 4):** `review-chapter.md` lines 70 and the Step-3 log block (lines 60-68) define an operator-presentation contract already. Adding a generic 2-line presentation rule is backwards-compatible (additive), but "possibly" + "2-line generic rule" leaves the exact text unspecified — see Dimension 5.
- Net: no live caller requires modification; the only cross-file contract (the manifest) is being brought *into* alignment, not broken. Medium because the manifest is shared infrastructure read by two consumers and the batch spans 5 files of three different kinds.

### Dimension 4: Reversibility
**Risk:** Low

- All five edits are in-tree file content/JSON edits plus one file deletion (`.bak`). A `git revert` restores prior content fully, including re-creating the deleted `.bak` (it is tracked or will be staged as a deletion — revert reinstates it).
- No log/registry mutation, no external write, no push implied by the change itself (the workspace push gate still applies separately). No hook/cron/symlink is created that could fire between landing and revert — the manifest edit changes data the SessionStart hook *reads*, but the hook never overwrites `commands.local` entries (line 88 `[ -e "$target" ] || [ -L "$target" ] && continue`), so no irreversible symlink churn results.
- One caveat (keeps it from being trivially Low-Low): if item 5a lands and a new project is deployed before a revert, that project's copied manifest carries the added entries forward — but that is a *correct* propagation (the entries belong there), so it does not constitute stale-state debt.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Item 3 introduces a frontmatter/body contradiction.** `intake-reports.md` frontmatter is `model: opus` (line 2). The command **body** asserts the opposite three times: line 10 "This command MUST run on Opus. Raw reports must be written verbatim … Lower-capability models (Haiku, Sonnet) have been observed to summarize instead of copying full content. If delegating any part of this command to a sub-agent, use `model: \"opus\"`." Changing the frontmatter tier to `sonnet` while leaving this body text creates a self-contradicting command: the tier says Sonnet, the prose says Sonnet is known to corrupt the core function (verbatim copying). This is a silent coupling between the frontmatter key and the body's verbatim-fidelity rationale that the change site (frontmatter only) does not surface. The "process-following command" justification in CHANGE_DESCRIPTION conflicts with the file's own documented reason for the opus pin.
- **Item 5b silently demotes two commands' tier.** Template `qc-pass.md` and `refinement-pass.md` are `model: opus` (template line 2 each); canonical is `model: sonnet` (diff: `< model: opus` / `> model: sonnet`). "Refresh to match canonical" therefore changes the tier opus→sonnet as a side effect of a "drift refresh," not as a deliberate tier decision. The CHANGE_DESCRIPTION frames 5b as cosmetic alignment but it carries a tiering decision the operator may not have intended to bundle. Workspace CLAUDE.md (Model Tier) makes per-command frontmatter "the only permitted mechanism for declaring a tier" — so this is a load-bearing field, not whitespace.
- **Item 4 contract is undocumented at the change site.** "Possibly graduate a 2-line generic operator presentation rule" names neither the exact text nor where in `review-chapter.md` it lands. `review-chapter.md` already carries presentation rules (line 70; Step-3 log block lines 60-68). An unspecified generic rule risks functional overlap with the existing per-verdict presentation logic — two presentation contracts in one command. Marked partially **INCOMPLETE** for this item (the "possibly" + unspecified text means the exact coupling cannot be verified from inputs).
- Low-coupling items for contrast: item 2 (path parameterization) is self-contained — the placeholders are resolved by `/deploy-workflow` substitution, a documented mechanism; item 5a manifest edit aligns with an already-established convention (the deployed nordic-pe manifest already lists the entry).

## Mitigations

- **Dimension 5 / Item 3 (High):** Do NOT change `intake-reports.md` frontmatter to `sonnet` in isolation. Either (a) keep `model: opus` and drop item 3 from the batch, OR (b) if the operator genuinely wants Sonnet, edit the body in the **same commit** — remove/rewrite the line-10 "MUST run on Opus / Sonnet summarizes instead of copying" rationale and the "use `model: \"opus\"`" sub-agent instruction — and add a one-line note explaining why the verbatim-fidelity concern no longer requires Opus. Frontmatter and body must not contradict.
- **Dimension 5 / Item 5b (High):** Before refreshing `qc-pass.md` and `refinement-pass.md`, confirm the opus→sonnet tier change is intended. If yes, call it out explicitly in the commit message as a deliberate tier demotion (not "drift refresh"). If the template copies should stay opus, refresh only the body deltas and preserve `model: opus` — but note this then *intentionally* diverges from canonical tier, which the next drift scan will re-flag; prefer matching canonical and accepting Sonnet, or open a separate decision on canonical's tier.
- **Dimension 5 / Item 4 (High):** Specify the exact 2-line rule text and its insertion point before landing, and verify it does not duplicate the existing presentation logic at `review-chapter.md` line 70 / Step-3 block. If it would overlap, fold it into the existing rule rather than adding a second one. If the rule text is still undecided, defer item 4 to a follow-up rather than landing it underspecified.
- **Dimension 3 (Medium):** When editing `commands.local`, drop `run-sufficiency` or annotate it as redundant — it is already in the hook's baked-in `EXCLUDE_COMMANDS` (auto-sync-shared.sh line 46) and has no canonical source, so it is a no-op for sync behavior. Keep `produce-jargon-gloss` (it correctly declares a template-only command).

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, diff output, grep/ls/find results, verbatim quotes from the referenced files and CHANGE_DESCRIPTION). Item 4's exact coupling is flagged INCOMPLETE within Dimension 5 because the rule text is unspecified in the inputs. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory). Obtained via the `system-owner` subagent because `/consult` is disabled for model invocation in this session. Invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Net position.** PROCEED-WITH-CAUTION is correct; concurs with verdict and dimension scores. Per-item:

- **Item 2 (parameterize paths + remove .bak) — CONCUR.** Core templatification win, no tier hazard. Confirm the `.bak` is the canonical template's stray, NOT a deliberate project archive (project keeps `produce-{prose-draft,formatting}-v1-template.md.bak` intentionally).
- **Item 3 (intake tier) — DISSENT on original, CONCUR with re-read.** If body says MUST run on Opus, canonical opus is right and the project's sonnet copy is the bug. Drop item 3 from the canonical batch; fix the project copy to opus in a separate scoped edit. Caveat: confirm the project copy is not a symlink first. `[CITATION NEEDED]` — verify the "MUST run on Opus" body line before acting.
- **Item 4 (presentation rule) — CONCUR with deferral.** DR-7: "generic" ≠ "a second consumer requires it." Overlap risk with existing review-chapter presentation logic is real. Defer; if kept, specify exact 2 lines + insertion point + own QC.
- **Item 5a — CONCUR.** Keep `produce-jargon-gloss`. `run-sufficiency`: if it has no canonical source and is in the hook EXCLUDE list, the manifest line is documentation noise — drop or annotate. `[CITATION NEEDED]` — verify the no-op claim.
- **Item 5b — CONCUR, demotion is a blocking sub-check.** "Refresh" silently demotes `qc-pass`/`refinement-pass` opus→sonnet. QC is judgment (QS-5); demoting the QC-loop commands degrades the quality tier. SPLIT: refresh `note` + `update-claude-md` freely; HOLD `qc-pass` + `refinement-pass` until the canonical-vs-template tier direction is confirmed end-to-end (DR-9) and the demotion is labeled explicitly in the commit. Read both ends before refreshing.

**Missed risks named by SO:**
1. **Model-tier prohibition rule cuts in our favor.** Workspace rule prohibits model defaults in settings.json / "default model" CLAUDE.md assertions — NOT per-command frontmatter `model:` (which is the only *permitted* tier mechanism). Items 3/5b operate in the sanctioned mechanism.
2. **DR-4 is DEPRECATED (2026-04-29).** The "every component must declare model: in frontmatter" rule was removed. Do NOT justify any edit as "DR-4 compliance" or "every command must declare a tier." The only live test is QS-5 (does the tier match the judgment load).
3. **Reversibility is asymmetric.** A wrong path-param (item 2) is trivially revertible; a silent tier demotion (5b) that ships downstream and quietly degrades QC for weeks is the expensive-to-detect failure. The reversibility risk concentrates in 5b.

Three `[CITATION NEEDED]` flags are the verification gates before action: (a) intake-reports "MUST run on Opus" body line; (b) project intake-reports symlink check; (c) run-sufficiency no-op claim + 5b tier direction end-to-end. SO read the grounding base, not the template files. Advisory only; the /risk-check verdict governs.
