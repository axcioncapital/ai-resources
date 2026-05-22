# Risk Check — 2026-05-20

## Change

Session changes: (1) new command `.claude/commands/review-pipeline-run.md` — reads 6 pipeline stage artifacts and all pipeline reference docs, writes a review report to output/reviews/; (2) modified `.claude/commands/analyze-transcript.md` — added Step 7.5 (Gate 1.5 scope-decision gate that scans analysis-system-owner.md for trigger phrases, surfaces A/B/C choice to operator, halts on choice (c), appends Gate 1.5 Resolution block to analysis-system-owner.md); added conditional fit rubric tier to Recommendation rubric; added Gate 1.5 resume condition to Step 2 resume detection; (3) modified `pipeline/ref-memo-template.md` — updated Recommendation rubric with conditional fit tier and Gate 1.5 annotation; (4) added `pipeline/ref-ai-engineering-lenses.md` — new reference doc read by ai-engineer agent before Technical Merit Assessment; (5) minor CLAUDE.md edit — added ref-ai-engineering-lenses.md to reference docs list.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/review-pipeline-run.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/.claude/commands/analyze-transcript.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-memo-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/pipeline/ref-ai-engineering-lenses.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/ai-development-lab/CLAUDE.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A coherent, internally-consistent pipeline upgrade with no permission or usage-cost concern, but it ships a new project-local command that is missing from the sync manifest and adds a contract change (Gate 1.5 trigger-phrase + resume marker) spanning four files — both need named mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `review-pipeline-run.md` is a pay-as-used command — invoked manually with a run-dir argument, not auto-loaded. No SessionStart/Stop/PreToolUse hook is registered by this change (`.claude/settings.json` `hooks` block is unchanged; the two existing SessionStart hooks are pre-existing).
- `analyze-transcript.md` Step 7.5 adds one extra file scan (`analysis-system-owner.md`) per run inside an already-running pipeline — cost is per-run, not per-session, and is dwarfed by the two system-owner Task dispatches the pipeline already pays (Step 6a ≈16–20K, Step 7 ≈27K+ grounding, per analyze-transcript lines 116 and 187).
- `ref-ai-engineering-lenses.md` (276 lines) is read by the `ai-engineer` agent once per run, before the Technical Merit Assessment (`ai-engineer.md` lines 55–60). It loads inside the agent's isolated context, not the main session, and only when the pipeline reaches Step 6b — pay-as-used, not always-loaded.
- The CLAUDE.md edit adds one bullet to the "Reference docs" list — under ~20 tokens to a project CLAUDE.md that is loaded per turn in this project's sessions. Negligible.

### Dimension 2: Permissions Surface
**Risk:** Low

- `.claude/settings.json` is not in the change set. No `allow`, `ask`, or `deny` entry is added, removed, or widened.
- All new file writes target already-authorized paths: `review-pipeline-run.md` writes to `output/reviews/` (not denied; `deny` list covers only `transcripts/**` and `pipeline/**` edits per settings.json lines 16–18). The Gate 1.5 resolution block appends to `analysis-system-owner.md` under `output/memos/` — also unrestricted.
- `analyze-transcript.md` Step 7.5 step 4 appends to a file under `output/` — within the existing `Write` allow and outside the `Edit(./pipeline/**)` deny. Note: the append is to a run-directory artifact, not a `pipeline/` reference file, so it does not collide with the `pipeline/` edit guard.
- No new Bash command family, external API, MCP server, or cross-repo write is introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Enumeration (grep across `projects/ai-development-lab/`):
  - `Gate 1.5` — 6 files reference it: `pipeline/ref-memo-template.md`, `.claude/commands/analyze-transcript.md`, `logs/coaching-data.md`, `logs/usage-log.md`, `logs/decisions.md`, `logs/session-notes.md`. The two non-log files are both in this change set and are mutually consistent (analyze-transcript Step 8 rubric lines 258–262 ↔ ref-memo-template rubric lines 29–31 — both name the in-boundary / out-of-boundary / conditional tiers identically). The four log hits are historical records, not live callers.
  - `ref-ai-engineering-lenses` — referenced by `.claude/agents/ai-engineer.md` (lines 56, 78–79) and `CLAUDE.md`. The agent already names the seven lenses (ai-engineer.md lines 80–86) and they match the reference doc's seven section headings exactly (Eval design, Context management, Retrieval (RAG), Agent architecture, Prompt design, Tool-use pattern, Harness engineering). No drift between the checklist and the new doc.
  - `review-pipeline-run` — the command file itself plus log/review files; 0 live callers depend on it (it is a leaf, invoked manually).
- Contract change: Step 7.5 introduces a new contract — the `## Gate 1.5 Resolution` block in `analysis-system-owner.md`. Two consumers depend on it: (a) `analyze-transcript.md` Step 2 resume detection (line 38) and the Step 7.5 resume-addition (line 235); (b) `review-pipeline-run.md` Stage 5 reads `analysis-system-owner.md` and Stage 2 / Step 4 evaluate Gate calibration — but `review-pipeline-run.md`'s Stage 5 checklist (lines 131–138) and workflow-quality "Gate calibration" item (line 182) reference only Gate 1 and Gate 2, NOT Gate 1.5. The reviewer command will not flag a missing or malformed Gate 1.5 block. This is a backwards-incomplete contract: the producing command writes the new block, but the sibling review command was not updated to know about it.
- The Recommendation-rubric change is backwards-compatible: it adds a conditional-fit tier and Gate 1.5 annotations to an existing four-branch rubric without removing or reordering existing branches.
- Shared infra: no hook, log schema, or always-loaded file contract is altered. `logs/pipeline-log.md` row format (analyze-transcript Step 10) is unchanged.

### Dimension 4: Reversibility
**Risk:** Medium

- `analyze-transcript.md`, `ref-memo-template.md`, and `CLAUDE.md` edits are single-file modifications that `git revert` restores fully.
- `review-pipeline-run.md` and `ref-ai-engineering-lenses.md` are new files; `git revert` of the commit removes them cleanly provided they are committed in the same commit as the edits. If committed separately or left untracked, revert leaves siblings behind — a one-step manual cleanup.
- Append-only state propagation: once `analyze-transcript` runs with Step 7.5 active, any future pipeline run writes a `## Gate 1.5 Resolution` block into that run's `analysis-system-owner.md` under `output/memos/`. Reverting the command after such a run does not remove already-written resolution blocks from completed run directories — those artifacts carry forward. This is contained (run artifacts are durable-by-design per CLAUDE.md "Memo discipline"), but it means revert does not fully restore prior state for runs executed between landing and revert.
- Resume-detection coupling: the Step 2 resume rule (line 38) keys on the presence of the `## Gate 1.5 Resolution` marker. A run started under the new command and then a revert to the old command would leave a run whose `analysis-system-owner.md` carries a marker the reverted command does not recognize — the old resume logic would not match it and could mis-route a resume. One extra manual step (finish or discard in-flight runs before reverting) is required.
- No state is pushed beyond the local repo (no `git push`, no external API write) by this change.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Trigger-phrase contract (Step 7.5, analyze-transcript lines 196–203): Gate 1.5 fires by scanning `analysis-system-owner.md` for literal phrases — "before any build", "requires explicit operator decision", "Reading A"/"Reading B", `OP-10`. This silently couples the gate to the *prose wording* of the `system-owner` agent's output. `system-owner` is symlinked from ai-resources and consumed as-is (project CLAUDE.md "Out of scope" + "Agent scope boundary"). If a future ai-resources update rephrases system-owner's conditional-fit language (e.g., "needs operator sign-off" instead of "requires explicit operator decision"), Gate 1.5 silently stops firing and the pipeline compiles a memo on an unconfirmed scope decision. The contract is documented at the change site (Step 7.5 lists the phrases) but the dependency on system-owner's exact wording is not surfaced to the symlinked agent's owner, and analyze-transcript cannot edit it.
- Functional-overlap / documentation gap: `review-pipeline-run.md` and `analyze-transcript.md` Step 7.5 both reason about scope-decision gating, but the reviewer's Gate-calibration checks (Stage 5 lines 131–138; workflow-quality item line 182) enumerate only Gate 1 and Gate 2. The new Gate 1.5 contract is not documented in the reviewer command, so the two siblings now disagree on how many gates exist — a reviewer running against a post-change run will not assess whether Gate 1.5 was correctly applied.
- The `ref-ai-engineering-lenses.md` ↔ `ai-engineer.md` coupling is explicitly documented on both sides: the reference doc's Maintenance note (lines 270–276) states the lens list "must stay identical" to the agent checklist, and the agent points to the doc (lines 56, 78–79). This coupling is named, not hidden — Low for this sub-item; it does not raise the dimension.
- Resume-marker coupling (Step 2 line 38 ↔ Step 7.5 line 235): two locations in the same file both encode the `## Gate 1.5 Resolution` resume rule. They are consistent today but are a duplicated contract — a future edit to one must be mirrored to the other. Documented at the change site; one implicit maintenance dependency.

## Mitigations

- **Blast Radius / Hidden Coupling (paired):** Update `review-pipeline-run.md` before landing — add Gate 1.5 to Stage 5's checklist and to the Step 4 "Gate calibration" workflow-quality item, so the reviewer command can evaluate whether Gate 1.5 fired correctly and whether the `## Gate 1.5 Resolution` block is well-formed. This closes the sibling-disagreement gap and makes the new gate contract checkable.
- **Hidden Coupling (trigger-phrase fragility):** Add a one-line note at analyze-transcript Step 7.5 stating the trigger-phrase list mirrors `system-owner`'s current conditional-fit vocabulary and must be re-verified when the symlinked `system-owner` agent changes — mirroring the existing "re-verify when consult.md changes" discipline already used for `ref-step6a-brief.md` / `ref-step7-brief.md` in the project CLAUDE.md reference-docs list. This converts a silent wording dependency into a documented re-verification touchpoint.
- **Blast Radius (manifest gap):** Add `review-pipeline-run` to `.claude/shared-manifest.json` under `commands.local`. It is a new project-local command and is currently absent from the manifest; while the auto-sync hook will not overwrite an existing local file, listing it in `commands.local` makes its project-owned status explicit and prevents a future same-named canonical command from being symlinked over an unprotected slot.
- **Reversibility:** Commit all five changes (two new files + three edits) in a single commit so `git revert` removes the new files and restores the edits atomically; before any later revert, finish or discard any in-flight pipeline runs whose `analysis-system-owner.md` already carries a `## Gate 1.5 Resolution` marker, so the reverted resume logic does not mis-route them.

## Recommended redesign

- Not applicable — verdict is PROCEED-WITH-CAUTION.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts across `projects/ai-development-lab/`, verbatim quotes from the referenced files and `.claude/settings.json` / `shared-manifest.json` / `auto-sync-shared.sh`). No training-data fallback was used on fetch/read failures.
