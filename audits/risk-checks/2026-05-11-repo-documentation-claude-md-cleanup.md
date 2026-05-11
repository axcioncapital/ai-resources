# Risk Check — 2026-05-11

## Change

Proposed structural change: edit `projects/repo-documentation/CLAUDE.md` to apply HIGH+MEDIUM+1 LOW findings from `audits/working/audit-claude-md-repo-documentation-2026-05-11.md`. Specifically:

(1) HIGH (T1-A + T2-A + T4-A + T5-B, all on Input File Handling block, ~340 tokens) — Rename block "Input File Handling" → "File Write Discipline" to match the actual workspace section name (workspace has `## File Write Discipline`, not `## Input File Handling` — the current closing claim "mirrors the canonical Input File Handling section in the workspace-level CLAUDE.md" is broken). Collapse the 5-bullet ruleset + rationale paragraph + exception clause to one operative sentence + pointer to `ai-resources/docs/file-write-discipline.md`. Same /new-project template collision as Project 1 (mitigation option b: defer template update). Saves ~270 tokens.

(2) HIGH (T2-B) — Delete the verbatim-duplicate Commit Rules block (~125 tokens). Replace with one-line pointer: "Commit behavior: see workspace CLAUDE.md § File verification and git commits." Same pattern as Project 2.

(3) MEDIUM (T1-B + T4-B + T4-C + T5-A + T6-A, all on Project Layout block, ~430 tokens) — Trim. Drop phase-status narrative (line 7 — dated "Phase 1 complete (M1.5 approved 2026-04-29); Phase 2 in active execution... W2.1–W2.5 deploying"). Drop superseded D-1 citation (line 16 — "Decision D-1 superseded per system-doc.md §1.1"; keep active rule). Move Phase 2 cadence sub-bullet (line 15 — "Phase 2 subagents...fire from /friday-checkup at the monthly+ tier") to new file `references/phase-2-cadence.md` (~95 tokens). Keep stable directory map. Saves ~160 tokens.

(4) MEDIUM (T2-D) — Trim Compaction block. Project block duplicates `ai-resources/CLAUDE.md` § Compaction. Keep only the unique addition (`/clear + restart from scratchpad` sentence) + one-line pointer to `ai-resources/docs/compaction-protocol.md`. Saves ~75 tokens.

(5) LOW (T6-B) — Fix `..` double-period typo at end of Model Selection block (line 20: "where judgment is needed..").

Net effect: ~630 tokens saved per turn from always-loaded surface (file from ~830 → ~200 tokens, well inside the 300–600 practitioner target band). One new file created (`references/phase-2-cadence.md`). Two cross-file verbatim duplicates eliminated. One broken canonical-rule citation fixed. No skill, command, agent, hook, permission, settings, or workflow changes. No semantic changes to active rules.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/audit-claude-md-repo-documentation-2026-05-11.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/file-write-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/compaction-protocol.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/references/phase-2-cadence.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/references/documentation-structure.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Token-savings posture is sound and grounded in a clean audit, but two High dimensions (Reversibility and Hidden Coupling) require explicit paired mitigations — the change is a net-trim that touches a load-bearing always-loaded file, introduces a new reference file, and leaves the prior `/new-project` template emitting stale section names unless that drift is documented.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Net effect on always-loaded surface is *negative* token cost — file shrinks from ~830 to ~200 tokens per audit estimate (`audit-claude-md-repo-documentation-2026-05-11.md` line 13: `"Brings file from ~830 tokens to ~440 tokens"`; CHANGE_DESCRIPTION refines this to ~200 tokens once compaction and project-layout trims are also applied).
- No new hooks, skills, subagent briefs, or `@import` chains added. The new `references/phase-2-cadence.md` is a passive doc — not auto-loaded; only referenced from the trimmed Project Layout block.
- Project CLAUDE.md is always loaded for any session opened at `projects/repo-documentation/`, so token savings compound on every turn within that project's sessions.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` changes. No tool families added. No scope changes between settings layers.
- CHANGE_DESCRIPTION explicit closing claim: `"No skill, command, agent, hook, permission, settings, or workflow changes."` Verified by inspection — the diff is content-only to one CLAUDE.md and one new reference doc.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 2 (`projects/repo-documentation/CLAUDE.md` edit; `projects/repo-documentation/references/phase-2-cadence.md` creation). The references directory already exists (verified: `ls projects/repo-documentation/references/` shows `documentation-structure.md`).
- Grep for callers of the affected sections produced these dependent surfaces:
  - `projects/repo-documentation/pipeline-phase-1/test-results.md:18` asserts the exact section order: `"Project Layout → Model Selection → Input File Handling → Commit Rules → Compaction → Session Boundaries"`. Renaming `## Input File Handling` → `## File Write Discipline` and deleting `## Commit Rules` invalidates this assertion. Test-results doc is historical (Phase 1 complete) — informational only, not re-executed.
  - `projects/repo-documentation/pipeline-phase-1/implementation-spec.md:40, 740` lists the same canonical section names as the expected shape. Historical Phase 1 spec — not re-executed.
  - `projects/repo-documentation/pipeline-phase-1/architecture.md:68, 124` cites `"Input File Handling"` by name as a rule the architecture relies on. Historical — Phase 1 is closed per the same audit's noted Phase 1 status.
  - `projects/repo-documentation/pipeline-phase-2/architecture.md:90` line 16 explicitly plans the edit being executed: `"Add Phase 2 cadence pointer (one-line 'Phase 2 subagents fire from /friday-checkup; see output/phase-2/ for findings')"`. This change aligns with the architecture; not in conflict.
  - `projects/repo-documentation/pipeline-phase-2/implementation-spec.md:653–666` is the implementation-spec for adding the Phase 2 cadence bullet. After the move to `references/phase-2-cadence.md`, the spec's anchor target ("immediately before the 'Harness scope:' line") will no longer match the trimmed file. Historical spec — Phase 2 already deployed per `output/session-guide.md` ("Stage 5 Testing complete").
  - `projects/repo-documentation/output/phase-1/principles.md` (and its vault copy) cite `"project CLAUDE.md (Input File Handling)"` as a source. Reference-only citation; rule semantics survive the rename.
  - `projects/repo-documentation/vault/principles/principles.md:248` — same citation as above (vault is gitignored content per the project CLAUDE.md Layout).
  - `/new-project` canonical template emits the old section names (per CHANGE_DESCRIPTION: `"Same /new-project template collision as Project 1 (mitigation option b: defer template update)"`). Template drift is acknowledged in-change with an explicit defer-decision.
- Reference-count summary: ~7 documents reference the old section names. All 7 are either (a) historical Phase 1 / Phase 2 specs that are not re-executed, (b) provenance-only citations whose semantics survive the rename, or (c) the `/new-project` template — which is the only live caller, explicitly deferred.
- Contract change is backwards-compatible at the rule level (semantics preserved; pointer takes operator to the same canonical doc). Naming contract is not preserved.

### Dimension 4: Reversibility
**Risk:** High

- `git revert` reverts the CLAUDE.md edits cleanly within the same working tree.
- `git revert` does NOT remove the new `references/phase-2-cadence.md` file unless explicitly cleaned up afterward — revert is operating on a modify+create commit; the create-side is undone, but a fresh `git status` will show the file unless the revert commit explicitly includes the deletion. The audit recommends moving the cadence bullet *out* and the CHANGE_DESCRIPTION promises ~95 tokens of new content there; if revert leaves the file plus a now-orphan reference, a second cleanup commit is required.
- No state propagates beyond local git: no push, no Notion write, no external API, no hook auto-fires on this content.
- `/new-project` canonical template drift is created by this change (project CLAUDE.md no longer matches what the template emits). Revert of the project change does not unwind the template-drift narrative — operator memory + Project 1 / Project 2 prior application carry forward the "we trim mirrors" pattern. Reverting this one project to the old shape while Project 1 and Project 2 remain trimmed creates inconsistency, not restoration of state.
- Append-only logs not directly mutated by this change.

### Dimension 5: Hidden Coupling
**Risk:** High

- The "mirrors the canonical workspace section" framing is being replaced with explicit pointers (`ai-resources/docs/file-write-discipline.md`, `ai-resources/docs/compaction-protocol.md`). Both pointer targets exist and verbatim contain the expected operative rules (verified — `file-write-discipline.md` covers all four bullets the project block currently states; `compaction-protocol.md` lines 7–8 cover the pre-compact scratchpad and post-compact resumption rules). Coupling on these two pointers is explicit and documented.
- However: the new `references/phase-2-cadence.md` introduces an undocumented contract. The audit (line 60) names "workflow methodology" as the destination class, and the workspace CLAUDE.md `## CLAUDE.md Scoping` rule names `reference/stage-instructions.md` as the conventional shape. CHANGE_DESCRIPTION names `references/phase-2-cadence.md` instead. No prior file in the repo uses that exact name (grep confirms: zero existing references). The cadence file's contract with `/friday-checkup` (monthly+ tier invocation of W2.1/W2.2/W2.4) is not currently documented at the destination — it lives in `pipeline-phase-2/architecture.md` and `pipeline-phase-2/implementation-spec.md`, which are historical pipeline outputs not always-loaded.
- After the edit, the project CLAUDE.md no longer contains a self-identification as a "mirror." Operators who skim the file expecting Project 1 / Project 2 conventions ("there's always a Commit Rules section that mirrors workspace") will not find one and must trust the inherited workspace block. The implicit cross-project pattern ("every project CLAUDE.md has Commit Rules + Input File Handling sections") becomes broken here without operator-side documentation.
- `/new-project` template still emits the old shape. Until the template is updated, any new project will have the *opposite* shape (verbose mirrors) from `repo-documentation` (trimmed pointers). Two competing conventions will coexist silently — the "defer template update" decision in CHANGE_DESCRIPTION acknowledges this but does not name a documentation home for the deferred work.
- One MEDIUM-severity coupling on the new `phase-2-cadence.md` reference contract; one MEDIUM-severity coupling on the template-drift inconsistency. Combined effect is High because both are undocumented at their destination at the moment of the change.

## Mitigations

- **Reversibility — paired cleanup commit on revert.** If this change is later reverted, the revert commit must also delete `projects/repo-documentation/references/phase-2-cadence.md` in the same commit (not a follow-up). Document this in the commit message of the *applying* commit so the future-revert operator sees the cleanup requirement. Suggested commit-message line: `"Revert note: any future revert of this commit must also delete references/phase-2-cadence.md to fully restore prior state."`
- **Reversibility — record the template-drift defer.** Append a one-line entry to `projects/repo-documentation/logs/decisions.md` (or the equivalent decisions log) naming the deferred `/new-project` template update and pointing at the audit. This makes the deferred work discoverable if the operator later wants to either apply or revert it.
- **Hidden coupling — document the new cadence-file contract at its destination.** Open `references/phase-2-cadence.md` with a frontmatter or first-paragraph statement naming: (a) which subagents read it, (b) which command (`/friday-checkup`) invokes them, (c) which tier gate (monthly+) controls invocation. The contract must be self-contained inside the new file, not implied by the deleted CLAUDE.md prose.
- **Hidden coupling — name the template-drift defer in-change.** Add one bullet to the trimmed Project Layout block (or a top-of-file note) stating: `"Section shape differs intentionally from /new-project emitted template — template will be reconciled in a separate batch."` This makes the drift visible on every session load of this project until the template is reconciled, preventing silent confusion when an operator compares projects.

## Recommended redesign

(Section omitted — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file reads of the project CLAUDE.md (current shape), audit working notes (savings estimates and rationale), workspace CLAUDE.md (confirms `## File Write Discipline` is the correct workspace section name and `Input File Handling` is not present), `file-write-discipline.md` and `compaction-protocol.md` (confirms pointer targets carry the operative rules), and grep counts of dependent callers (7 documents reference the old section names; broken down by liveness in Dimension 3). The "not yet present" file `references/phase-2-cadence.md` was not read; its contribution to risk is inferred from CHANGE_DESCRIPTION's stated intent (~95 token cadence file with subagent + tier specification) and flagged as a contract-coupling risk in Dimension 5. No training-data fallback was used on fetch/read failures.
