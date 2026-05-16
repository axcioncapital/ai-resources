# Risk Check — 2026-05-14

## Change

End-time gate: session 2026-05-14 structural changes.

1. .claude/commands/kb-synthesize.md — added Step 0 concurrency check (git status before proceeding); SHA-256 guard in Steps 5b-c (capture hash before archive cp; abort on mismatch); prompt_version corrected v2.0→v2.2.

2. .claude/commands/kb-review.md — Step 5 skip condition (bypass operator gate when all routing_confidence:high and no ambiguity flags; --auto flag); new Step 7 registry-check prompt before filing; Steps renumbered 7→14; index.json field list extended with memo_relevance + memo_angle.

3. CLAUDE.md (project-level) — Operator Gates section updated to document /kb-review skip condition; Operational Notes: recovery command for concurrent-session abort scenario added.

4. macro-kb/_meta/templates/atomic-entry-template.md — complete revision: 7 required fields (added memo_relevance, memo_angle), 5 recommended (added pointer_source, falsifiability), new body sections (Operator Note, Business Relevance stub, Nordic Relevance stub), section order changed.

5. macro-kb/_meta/prompts/synthesis-prompt.md — v2.1→v2.2: inserted §7 Strategic Implications + §8 Nordic Mid-Market Translation between §6 and former §7; Source Log→§9, Source-Mix Disclosure→§10; section count 8→10.

6. macro-kb/_meta/templates/synthesis-template.md — two new H2 sections matching prompt additions.

7. ai-resources/skills/intake-processor/SKILL.md — Stage A: Operator Note elicitation rule, Business Relevance/Nordic Relevance as stubs, section order. Stage B: memo_relevance, memo_angle, pointer_source, falsifiability field assignment rules. Batch manifest schema updated.

Key questions: (1) Does the kb-review skip condition remove a hard rule from CLAUDE.md project-level (Operator Gates §2) in a way that bypasses the design intent? (2) Does the memo_angle enum change break any downstream commands that read entry frontmatter (kb-query, kb-synthesize, kb-cross-theme)?

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/commands/kb-synthesize.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/commands/kb-review.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/macro-kb/_meta/templates/atomic-entry-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/macro-kb/_meta/prompts/synthesis-prompt.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/macro-kb/_meta/templates/synthesis-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/intake-processor/SKILL.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change set is internally consistent within the seven landed files and the design intent is preserved, but two downstream consumers (`/kb-reindex`, `/kb-audit`) were not updated to match the extended frontmatter schema, and the `--auto` skip condition narrows but does not fully preserve Operator Gate §2 as originally framed.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Project CLAUDE.md grew by ~3 short lines (Operator Gates §2 skip clause + Operational Notes concurrent-session-recovery bullet). Lines 48 and 70 of `projects/global-macro-analysis/CLAUDE.md`. Net addition ~80 tokens to always-loaded project context — under the Medium threshold (~150).
- No new hooks, `@import` chains, subagent briefs, or auto-loading skills introduced. The intake-processor SKILL.md is loaded only on `/kb-ingest` invocation (pay-as-used).
- prompt_version bump and synthesis prompt expansion (8 → 10 sections, ~60 lines added to synthesis-prompt.md) is a per-invocation cost paid only when `/kb-synthesize` runs — not always-loaded.

### Dimension 2: Permissions Surface
**Risk:** Low

- No changes to `.claude/settings.json`, `.claude/settings.local.json`, or any permission file referenced in the change description.
- `openssl dgst` and `git status --short` in `/kb-synthesize` Step 0 / 5b-c are Bash invocations. Repo conventionally allows read-only Bash patterns for `/kb-*` commands; both commands are non-destructive read-only shell calls within an already-established pattern.
- `--auto` flag on `/kb-review` is an argument-handling change, not a permission-surface change. No new tool family enabled.

### Dimension 3: Blast Radius
**Risk:** Medium

Direct file touches: 7 files (per the change description). Downstream consumer enumeration (Grep across `projects/global-macro-analysis/.claude/commands/kb-*.md` and `ai-resources/skills/intake-processor/`):

- **`memo_relevance` / `memo_angle` references**: kb-review.md line 35 (index.json field list — UPDATED), intake-processor SKILL.md lines 85-86, 112-113 (field assignment + manifest schema — UPDATED), atomic-entry-template.md lines 8-9, 68-69 (UPDATED), phase-1-2-session-guide.md lines 150-151 (doc reference; no code path).
- **`pointer_source` / `falsifiability` references**: synthesis-prompt.md line 156, atomic-entry-template.md lines 15, 17, 73-74, intake-processor SKILL.md line 87, index.json (live data, ~18 existing entries already carry `pointer_source: true`), pointer-source-ingestion.md (~7 references) — all internally consistent with the new template.
- **`Business Relevance` / `Nordic Relevance` / `Operator Note` body sections**: only referenced in atomic-entry-template.md and intake-processor SKILL.md — consistent.

**Gap 1 (Medium-severity contract drift):** `/kb-reindex` (`projects/global-macro-analysis/.claude/commands/kb-reindex.md` lines 20-31) enumerates the index.json fields it writes — `path, theme, cross_themes, date, source, source_type, source_mode, ingest_mode, confidence, bootstrap, title`. It does NOT include `memo_relevance` or `memo_angle`. After this change, `/kb-review` writes those fields on filing (line 35), but a subsequent `/kb-reindex` will silently strip them. This is a real round-trip data-loss bug for new entries that go through reindex.

**Gap 2 (Medium-severity contract drift):** `/kb-audit` (`projects/global-macro-analysis/.claude/commands/kb-audit.md` lines 16-20) enumerates required frontmatter fields as `theme, date, source, source_type, source_mode, ingest_mode, confidence`. The new template promotes the required set to 7 fields including `memo_relevance` and `memo_angle`. Audit will not flag entries missing the new required fields — schema drift goes undetected.

- `/kb-query` and `/kb-cross-theme` read index.json + synthesis files generically — they do not enumerate specific frontmatter fields, so the enum expansion of `memo_angle` does not break their parsing paths. (Verified: grep returned zero hits in those two files for `memo_angle`, `memo_relevance`, `pointer_source`, `falsifiability`.)
- Synthesis prompt section renumbering (Source Log §7→§9, Source-Mix §8→§10) is backwards-incompatible if any downstream tool keys off section ordinals — none found in commands (`grep "§7\|§8\|§9\|§10"` returns no hits in command files). Existing synthesis files in `_history/` were produced under v2.1 and remain valid as historical archives.

### Dimension 4: Reversibility
**Risk:** Low

- All seven changes are single-file edits. `git revert` of the landing commit fully restores the prior contracts (template, prompt, command specs, SKILL.md, CLAUDE.md).
- No append-only log mutations triggered by this change itself (changelog.md and index.json mutations occur only when `/kb-review` runs; the structural change does not pre-populate either).
- Index.json is rebuildable via `/kb-reindex` from frontmatter, so even if entries were filed under the new schema and then revert occurred, structural recovery is mechanical.
- One caveat: any atomic entry filed AFTER this change lands but BEFORE a revert would carry the new required fields (`memo_relevance`, `memo_angle`) and the new body sections. Reverting the template alone does not delete those fields from already-filed entries — they remain in the entry files. This is acceptable (entries are append-only by hard rule §3) but worth naming.
- No external writes (no `git push`, no Notion writes, no API calls).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Coupling 1 (named):** `prompt_version: "v2.2"` in `/kb-synthesize` Step 11 (line 36) must match the synthesis prompt file's first-line declaration `# Synthesis Regeneration Prompt (v2.2)` (synthesis-prompt.md line 1) and the synthesis-template.md frontmatter example (line 13). All three are consistent — checked. Future bumps must update all three in lock-step; this is a triple-touch contract not documented at any single site.
- **Coupling 2 (named, mitigation present):** `/kb-synthesize` Step 5b-c SHA-256 guard couples to the synthesis file's hash being stable between Step 5a read and Step 5d copy. The mechanism is documented inline in the step and is self-recovering (the abort message names the git recovery command). The recovery command is also duplicated in CLAUDE.md Operational Notes (line 70) — a deliberate redundancy, not silent coupling.
- **Coupling 3 (undocumented contract):** `/kb-review` Step 8c (line 35) appends `memo_relevance` and `memo_angle` to index.json entries. `/kb-reindex` Step 5 (kb-reindex.md lines 20-31) rebuilds index.json from frontmatter but does NOT enumerate those fields. The two commands disagree on the index.json schema — this is an undocumented contract conflict introduced by the change.
- **Coupling 4 (intent vs. mechanism mismatch on Operator Gate §2):** The hard rule (project CLAUDE.md line 50): "These gates ensure Patrik remains in the judgment loop for all data entering the knowledge base." The skip condition (line 48) bypasses Step 5 entirely when routing confidence is high. Whether this preserves the design intent depends on framing: the gate purpose is operator judgment on routing (where to file). When the system is fully confident in routing, the gate adds no judgment value, so auto-filing is defensible. BUT — registry-check (new Step 7) and filing-plan correction (Step 6) happen AFTER Step 5; the skip path proceeds directly to Step 6 per kb-review.md line 28 ("Proceed to Step 6"), so corrections and registry stubs are still gated. This means the skip narrows but does not eliminate the operator-in-loop guarantee. The CLAUDE.md text (lines 48 + 50) makes this nuance unclear — the rule still reads "two commands pause" but one of them now conditionally does not.
- **Coupling 5 (silent fall-through):** `--auto` flag on `/kb-review` (line 27) pre-approves filing regardless of confidence. If a future low-confidence batch is filed with `--auto` by mistake (typo, scripted invocation, copy-paste from prior session), the gate is fully bypassed. No safeguard documented (e.g., warning when `--auto` is passed alongside low-confidence entries).

### Key questions (operator-asked)

**Q1: Does the kb-review skip condition remove a hard rule from CLAUDE.md project-level (Operator Gates §2) in a way that bypasses the design intent?**

Partial. The skip condition preserves the design intent when routing confidence is high uniformly (the gate's analytic purpose — operator judgment on routing — has no work to do). It does NOT preserve the intent when `--auto` is invoked with any non-high-confidence entry, because `--auto` overrides regardless of confidence (kb-review.md line 27, first OR branch). Recommend tightening the `--auto` semantics OR documenting the bypass explicitly in CLAUDE.md so future audits do not flag this as drift.

**Q2: Does the memo_angle enum change break any downstream commands that read entry frontmatter (kb-query, kb-synthesize, kb-cross-theme)?**

No direct break — none of those three commands enumerate or filter on `memo_angle` (grep verified). But two indirect breaks exist: `/kb-reindex` drops `memo_angle` and `memo_relevance` on rebuild (kb-reindex.md does not list them), and `/kb-audit` does not validate them as required fields. These are not "downstream commands that read frontmatter" in the query sense, but they ARE downstream commands that handle the schema, and both have drifted from the new contract.

## Mitigations

- **Blast radius / Hidden coupling 3 (Medium): Update `/kb-reindex` field list before next `/kb-reindex` run.** Edit `projects/global-macro-analysis/.claude/commands/kb-reindex.md` Step 5 to add `memo_relevance`, `memo_angle`, `pointer_source`, `falsifiability` to the enumerated field list. Otherwise the next reindex silently strips those fields from index.json.
- **Blast radius (Medium): Update `/kb-audit` required-fields check before next `/kb-audit` run.** Edit `projects/global-macro-analysis/.claude/commands/kb-audit.md` Step 1 to extend the required set from 7 to 9 fields (`memo_relevance`, `memo_angle` added). Otherwise audit will not detect entries missing the new required fields.
- **Hidden coupling 4 (Medium): Clarify Operator Gates §2 wording.** Edit `projects/global-macro-analysis/CLAUDE.md` line 45 from "Two commands pause for operator review before proceeding" to "Two commands gate on operator review; one may auto-skip when confidence is uniformly high." Prevents the rule text from reading as contradicted by the skip clause directly below.
- **Hidden coupling 5 (Medium, optional): Add `--auto` + low-confidence warning.** Edit `projects/global-macro-analysis/.claude/commands/kb-review.md` Step 5 first bullet: when `--auto` is passed AND any entry has non-high routing_confidence or any ambiguity flag, emit a one-line warning ("`--auto` bypassed the gate on N low-confidence entries") before proceeding. Preserves auditability without re-introducing the pause.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references from the seven referenced files, plus grep counts across `projects/global-macro-analysis/.claude/commands/` and `ai-resources/skills/intake-processor/`). No training-data fallback was used.
