# Risk Check — 2026-05-25

## Change

R7 from token-audit-2026-05-25-ai-resources.md §9.2 — create new subagent `fading-gate-scanner` and wire it into `/friday-checkup` Step 6 fading-gate detection. Plan-time gate.

**New file:** `ai-resources/.claude/agents/fading-gate-scanner.md` (~50–80 lines, modeled on `findings-extractor.md` / `token-audit-auditor-mechanical.md` shape — Subagent Contracts ≤30-line summary cap, full notes to disk if any).

**Subagent contract:**
- Inputs: `TODAY` date, list of `(scope_slug, scope_path)` pairs (the `is_project=true` scopes), absolute path to `ai-resources/logs/gate-calibration.md`.
- Reads each `{scope_path}/logs/coaching-data.md` if present (up to 9 files). Parses session entries (header pattern `### YYYY-MM-DD — {title}`, gate line `**Gates:** N (X changed) — {gate-name}:{outcome}, ...`).
- Filters to entries dated within last 30 days from `TODAY`. For each `(scope_slug, gate_name)`, tallies `total` + `confirmed` (outcome exactly `confirmed`).
- For pairs where `total ≥ 8` AND `confirmed/total ≥ 0.90`, applies the suppression check against `gate-calibration.md` (header pattern `^## \d{4}-\d{2}-\d{2} — {scope_slug}/{gate_name}$`, U+2014 em dash, case-sensitive; reads `Review-cycle:` line — `permanent` or future date suppresses; passed date re-flags).
- Returns a ≤30-line summary listing each surviving fading-gate finding in the same `[FADING-GATE]` follow-up format friday-checkup currently emits inline (so the main session can include verbatim in its Tactical follow-ups list).
- Output-to-disk: if findings count > 20 or any finding requires expanded context, write full notes to `audits/working/fading-gate-scan-{DATE}.md` and return path + count in the summary; otherwise inline-return only.

**Edit to existing file:** `ai-resources/.claude/commands/friday-checkup.md` line 300 — replace the inline 400+ word fading-gate paragraph with a delegation instruction. Logic moves into the subagent body; main-session paragraph shrinks to ~3 lines.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/fading-gate-scanner.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/findings-extractor.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor-mechanical.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/gate-calibration.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/fading-gate-scan-{DATE}.md — not yet present (dynamic, conditional write)

## Verdict

GO

**Summary:** Self-contained subagent extraction following an established pattern (findings-extractor) within a single command's body; no permission, hook, or always-loaded surface touched; clean git revert.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Subagent is pay-as-used, not always-loaded. Spawned only by `/friday-checkup` Step 6, gated by `TIER ∈ {monthly, quarterly}` AND `is_project=true` scopes selected (evidence: friday-checkup.md:300 "Fading-gate detection (monthly + quarterly only). Skip entirely if TIER=weekly").
- No `.claude/hooks/` change, no SessionStart/PreToolUse hook registered, no `@import` to always-loaded CLAUDE.md.
- Replaces ~400-word inline paragraph (friday-checkup.md:300) with ~3 lines of delegation instruction — net main-session token reduction.
- Estimated audit savings: 3,000–8,000 tokens per monthly-tier session (per CHANGE_DESCRIPTION; consistent with reference: `coaching-data.md` is ~490 lines × up to 9 scopes = ~4,400 lines avoided in main context).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `permissions.allow`, `permissions.ask`, or `permissions.deny` changes in `.claude/settings.json` or `.claude/settings.local.json`.
- Subagent uses Read tool only (parsing markdown files); conditional Write to `audits/working/` is within already-established pattern (audits/working/ exists, 20+ existing working-notes files verified via `ls audits/working/`).
- No new tool family, no scope escalation, no cross-repo or external API capability introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 2 (one new agent file, one edit to friday-checkup.md line 300).
- Callers of friday-checkup.md (grep `friday-checkup` in `*.md`): 21 hits, all are historical report artifacts under `audits/` referencing past runs — no other command, skill, or agent invokes `/friday-checkup` programmatically.
- Callers of `coaching-data.md` (grep): 10 hits — only friday-checkup.md (line 300) and the file itself; no other agent or command reads it. Refactor does not change which files are read, only who reads them.
- No contract change for downstream `/friday-act`: the change preserves the `[FADING-GATE] ...` follow-up line format verbatim (per change description: "in the same `[FADING-GATE]` follow-up format friday-checkup currently emits inline"). `/friday-act` parses Tactical follow-ups section headers, not internal line provenance.
- No external token reference to `fading-gate-scanner` exists (grep `fading-gate-scanner` returned 0 hits) — clean greenfield name.
- Sibling pattern already established: `findings-extractor` (36 lines, haiku, delegated by friday-checkup Step 7.16), `log-sweep-auditor` (183 lines), `permission-sweep-auditor` (10473 bytes) — fading-gate-scanner fits the same architectural slot.

### Dimension 4: Reversibility
**Risk:** Low

- New file (fading-gate-scanner.md): `git revert` removes cleanly; no sibling files outside the agent definition.
- Edit to friday-checkup.md line 300: standard single-line-block replacement; `git revert` restores the original paragraph.
- Conditional write to `audits/working/fading-gate-scan-{DATE}.md` only fires if findings count > 20 — `audits/working/` is already a transient working area (20+ historical files there are not committed to discipline; pattern established). Stale files there carry no semantic weight.
- `gate-calibration.md` is read-only from this change's perspective — no log mutation, no state propagation.
- No `settings.json` change, no hook registration, no operator muscle-memory change (the slash-command invocation surface `/friday-checkup` is unchanged).

### Dimension 5: Hidden Coupling
**Risk:** Low

- The data contract the subagent must honor (`### YYYY-MM-DD — {title}` header, `**Gates:** N (X changed) — {gate-name}:{outcome}, ...` line, U+2014 em dash in gate-calibration.md headers) is documented at the change site: friday-checkup.md:300 currently spells out the exact regex, the U+2014 em dash requirement, the `Review-cycle:` suppression semantics, and the parenthetical-stripping rule. Moving these into the subagent body preserves the contract verbatim per the change description; no implicit dependency is introduced.
- No silent auto-firing: subagent runs only when its caller spawns it inside Step 6, behind the existing tier+scope filter.
- No overlap with existing mechanisms — `findings-extractor` reads sub-report files for the Prioritized findings section (Step 7.16), a different concern; `log-sweep-auditor` operates on log-archive concerns. No two subagents will both try to handle fading-gate detection.
- Suppression contract (`gate-calibration.md` headers, U+2014, prepend-ordered) is already a documented convention in `gate-calibration.md:18-22` ("The separator between date and scope/gate in the header is U+2014 EM DASH (—), not hyphen-minus or en-dash. Hand-edited entries using the wrong character will silently fail suppression matching."). The subagent inherits this same convention — no new fragility introduced.
- Cumulative-session context (R10, R3+R4+R6, R9 deferred) noted in CHANGE_DESCRIPTION: no concurrent edits to friday-checkup.md or `.claude/agents/` from those changes. No collision with Sonnet 200k Task 2 (qc-reviewer.md is a different file).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file paths and line numbers cited (friday-checkup.md:300, gate-calibration.md:18-22), grep counts reported (21 friday-checkup references, 10 coaching-data references, 0 fading-gate-scanner references), reference-agent sizes measured (findings-extractor.md 36 lines, token-audit-auditor-mechanical.md 83 lines, log-sweep-auditor.md 183 lines), audits/working/ existence verified by `ls`, settings.json files enumerated to confirm no permission surface impact. No training-data fallback was used on fetch/read failures.
