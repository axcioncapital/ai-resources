# Risk Check — 2026-06-12

## Change

Add one bullet to the "Standard tactical items" list in Step 6 of the canonical /friday-checkup command (ai-resources/.claude/commands/friday-checkup.md): an archaeology-baseline staleness check that reads the _Generated: date from projects/repo-documentation/output/phase-1/inventory/components.md (mtime fallback), and when older than 28 days appends one advisory [ARCHAEOLOGY-STALE] tactical follow-up line to the checkup report. Read-only check, no writes, no new files, no reordering of existing steps; skip-silently when the inventory file is absent. Consumers affected: /friday-act parses the Tactical follow-ups section.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/inventory/components.md — exists

## Verdict

GO

**Summary:** A read-only, skip-silently date-check bullet that clones an established same-list pattern (Friction-log dormancy), emits a follow-up line already conformant to the one consumer's parse contract, and reverts cleanly with a single-symlink-propagated edit — low across all six dimensions.

## Consumer Inventory

Search terms: `friday-checkup`, `friday-act`, `ARCHAEOLOGY-STALE`, `Tactical follow-ups`, `components.md` / inventory path, `/archaeology`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/friday-act.md | parses | no |
| ai-resources/CLAUDE.md (§ Maintenance Cadence) | documents | no |
| projects/repo-documentation/CLAUDE.md (§ Project Layout — /archaeology) | documents | no |
| projects/repo-documentation/.claude/commands/archaeology.md | documents (the refresh action the line names) | no |
| 18 project/workspace/harness `.claude/commands/friday-checkup.md` copies | imports (symlinks → canonical) | no |
| projects/repo-documentation/output/phase-1/inventory/components.md | co-edits (read target; supplies `_Generated:` date) | no |

Total: 6 distinct consumer classes (23 physical files incl. 18 symlinks + 5 named files), 0 must-change.

- `/friday-act` is the only behavioral consumer (it parses the section the new line lands in). It does not require modification — see Dimension 3.
- All 18 non-canonical `friday-checkup.md` files are symlinks to the single canonical real file (verified: `readlink` resolves each to `ai-resources/.claude/commands/friday-checkup.md`; only one `REAL FILE` found). The edit propagates automatically; symlinks cannot drift.
- `components.md` is the read target, not a co-edited file in the mutation sense — the change reads its `_Generated:` line (`_Generated: 2026-06-12 (M1.1 re-run)`, components.md:2) and never writes it.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change is pay-as-used, not always-loaded: it adds prose to a slash-command body (`/friday-checkup`), which loads only when the command is invoked — weekly at most, per the cadence in ai-resources/CLAUDE.md:44. It does not touch any always-loaded CLAUDE.md, adds no hook, no `@import`, no subagent brief, no skill.
- The added work at runtime is a single file read + date diff — comparable to the adjacent "Friction-log dormancy" item (friday-checkup.md:315), which already reads a file and computes days-elapsed. Marginal token/runtime cost is one bullet of instructions plus one short file read.
- Existence-gated, not subagent-spawning: the design context confirms it runs inline (like the §M anchor check, friday-checkup.md:276-284), no Agent-tool spawn, so no per-invocation subagent cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission changes. The check is read-only (Read against a `.md` file under `projects/`, plus a Bash `date`/mtime diff). No `allow`/`ask`/`deny` entries are added, narrowed, or removed; no new tool family, no Write path, no external API, no cross-repo write.
- The read target and the date computation are both already-established patterns the command performs elsewhere (Step 0 date math friday-checkup.md:21; Friction-log file read friday-checkup.md:315), so no new tool-invocation pattern is introduced.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: one — the canonical `ai-resources/.claude/commands/friday-checkup.md`. All 18 other `friday-checkup.md` paths are symlinks to it (verified), so the edit propagates with zero additional touches.
- Consumer Inventory: 6 consumer classes, **0 must-change**. The only behavioral consumer is `/friday-act` (the `parses` row).
- Contract conformance (the load-bearing check): `/friday-act` parses the `## Tactical follow-ups` section as `[ ] {item} — risk: {low | med | high}` bullets (friday-act.md:111). The proposed line — `[ARCHAEOLOGY-STALE] Inventory baseline last generated {date} (... ) ... — risk: low` — is emitted as a tactical follow-up item carrying `— risk: low`, identical in shape to the existing `[FRICTION-DORMANT] ... — risk: low` (friday-checkup.md:315) and `[STALE] ... — risk: med` (friday-checkup.md:310) items that `/friday-act` already consumes. The bracket-tag prefix (`[ARCHAEOLOGY-STALE]`) sits inside the `{item}` slot, exactly as `[FRICTION-DORMANT]`/`[STALE]`/`[PARKED]`/`[SESSION-ISSUE]`/`[DEFECT-RECURRENCE]` already do — so it is a backwards-compatible addition within the existing contract, not a contract change.
- No section heading is renamed; Step 7's "Section presence by tier" data contract (friday-checkup.md:387-392, referenced by friday-act.md:106) is untouched. No new section, no reordering of steps (per CHANGE_DESCRIPTION: "no reordering of existing steps").
- No unanticipated consumer surfaced: the inventory found no consumer of the `[ARCHAEOLOGY-STALE]` token other than the in-session mandate/notes files (session-plan / session-notes / context-pack under repo-documentation) — those are session artifacts, not behavioral consumers.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to a tracked file (`friday-checkup.md` is git-tracked; only inventory *content* and vault are gitignored). `git revert` of the commit fully restores prior state within the working tree — no sibling files or directories created (CHANGE_DESCRIPTION: "no new files").
- No data/log mutation: the change is read-only at runtime and appends only to the *generated* checkup report (`audits/friday-checkup-{TODAY}.md`), which is a fresh per-run artifact — reverting the command does not require cleaning a prior report, and any already-generated report is a dated snapshot the operator discards normally.
- No settings.json change, no push beyond local repo, no automation (hook/cron/symlink) added that could fire between landing and revert.

### Dimension 5: Hidden Coupling
**Risk:** Low

- One implicit dependency, on an established repo convention: the check reads the `_Generated:` line of `components.md`. That line exists and is well-formed (`_Generated: 2026-06-12 (M1.1 re-run)`, components.md:2), and the design specifies a precedence (in-file `_Generated:` first, mtime fallback) — so the dependency is named at the change site and has a graceful fallback if the line is absent or unparseable. Skip-silently-if-file-absent (CHANGE_DESCRIPTION) removes the missing-file failure mode.
- The new contract (the `[ARCHAEOLOGY-STALE]` line shape) is documented at the change site — it lands in Step 6 next to the other tagged items, all of which are self-documenting in the same list. `/friday-act`'s generic `[ ] ... — risk: ...` parser consumes it without needing to know the tag.
- No silent auto-firing in an unexpected context: the check runs only inside `/friday-checkup`, which is operator-invoked. No functional overlap — no existing item checks archaeology-baseline freshness, so two systems will not contend for the same concern. (The §H W2.1 doc-scanner checks *component-registry drift in the vault*, friday-checkup.md:196-204, a different signal than *baseline-file age*.)
- Minor note (does not raise the level): the design states the item is existence-gated (inventory file present), NOT scope-selection-gated — so it can fire even when `project repo-documentation` is not a selected scope, unlike §H/§L which are scope-gated. The cited precedent (§M anchor check, run unconditionally because cheap) supports this. The only consequence is the item may surface in a checkup whose selected scopes do not include repo-documentation; this is intended advisory behavior, not hidden coupling, and the follow-up line names the project path (`Run /archaeology in projects/repo-documentation`) so the operator has full context.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read successfully (projects/strategic-os/ai-strategy/principles-base.md). The relevant checks:
- **OP-12 (closure before detection):** This is *new detection* (a staleness flag) — but it ships behind a working closure channel, not ahead of one. The follow-up line routes to an existing, working closure path: `/friday-act` triages tactical items (friday-act.md:118 Step 3 loop), and `/archaeology` (projects/repo-documentation/.claude/commands/archaeology.md, exists) is the named refresh action that closes the finding. Detection + closure both exist. Aligned, not in tension.
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** No generalization, no "hooks for later." The change is a single concrete check for a single existing consumer (the operator reviewing the checkup). It adds no contract for an absent consumer — the `[ARCHAEOLOGY-STALE]` line is consumed by the already-present `/friday-act` parser. Not a speculative-abstraction signal.
- **OP-5 (advisory vs enforcement):** Stays advisory — emits a follow-up line and stops (CHANGE_DESCRIPTION: "advisory ... no writes"). No move toward auto-refresh / enforcement. Aligned.
- **OP-10 (system boundary):** Wholly inside Claude Code; no cross-tool reach. Not touched.
- **DR-1 / DR-3 (placement):** The edit lands in the canonical command in `ai-resources/` (DR-1 canonical tier), editing an existing file in its established home — no new tier or home decision. Aligned.
- **DR-8:** This change is in a `/risk-check`-gated class (modifies a shared cross-cutting command), which is exactly why this review runs — the gate is being honored, not bypassed.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: friday-checkup.md line references (Step 6 tactical-item list 294-318, Friction-log dormancy 315, §M anchor check 276-284, Step 7 contract 387-392); friday-act.md parse contract (line 111, schema-contract callout 106); components.md `_Generated:` line (line 2); verified symlink topology (`readlink` on all 19 `friday-checkup.md` paths, one REAL FILE); principles-base.md OP/DR/AP IDs cited verbatim; verbatim quotes from CHANGE_DESCRIPTION and the supplied design context. No training-data fallback was used.
