# Risk Check — 2026-06-27

## Change

Change to ai-resources/.claude/commands/permission-sweep.md — align the command's Rule 8 presentation/remediation layer to the already-correct canonical Rule 8 in permission-template.md (the "settings grant belongs in settings.local.json, not tracked settings.json" decision). Two edits: (1) Line 111 plain-language phrasing table — replace the stale "Missing or stale additionalDirectories. ai-resources symlinks may not resolve." with phrasing matching canonical Rule 8 (grant absent from BOTH tracked + local → add to settings.local.json; a tracked settings.json still carrying it → relocate to settings.local.json). (2) Lines 211–216 apply-idiom — the current "Add additionalDirectories (rule 8)" jq writes the grant to $FILE, which for a Rule 8 finding is the TRACKED settings.json, re-introducing the machine-specific-path defect. Redesign so the add-grant idiom targets the sibling settings.local.json (computing LOCAL=dirname($FILE)/settings.local.json, seeding {} if absent, and setting the mandatory defaultMode: bypassPermissions per Layer D′ root-cause #1), plus add a "relocate out of tracked settings.json" idiom that dels additionalDirectories from the tracked file. The permission-sweep-auditor agent needs no change (it already reads the correct rulebook). This is the first of two residual-generator fixes closing the settings-path-portability mission root cause; /deploy-workflow is the second (separate risk-check). Reversible (command-doc edit, git-tracked). Blast radius: /permission-sweep remediation behavior + /friday-checkup weekly dry-run rotation that consumes its report. No permission grants are widened — the change makes remediation write to the gitignored local file instead of tracked config.

## Referenced files

- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/commands/permission-sweep.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists
- /Users/danielniklander/Axcion Claude Code/Axcion AI Repo/ai-resources/.claude/agents/permission-sweep-auditor.md — exists

## Verdict

GO

**Summary:** A low-risk consistency repair that brings one command's Rule 8 remediation idiom into line with the canonical rulebook it already cites — it narrows where remediation writes (gitignored local file vs. tracked config), widens no permission, and reverts cleanly as a single git-tracked command-doc edit.

## Consumer Inventory

Search terms: `permission-sweep` (command/agent basename + token), `additionalDirectories` (the contract value the change relocates), `Rule 8` (the rulebook entry), `settings.local.json` (the new write target). Grepped across `ai-resources/` and the workspace root; audit-report hits (`ai-resources/audits/**`) excluded as historical artifacts, not live consumers.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/permission-sweep-auditor.md | invokes (spawned by the command; reads the canonical rulebook directly) | no |
| ai-resources/docs/permission-template.md | parses (canonical Rule 8 + Layer D′; the source of truth the edit aligns *to*) | no |
| ai-resources/.claude/commands/friday-checkup.md | invokes (`/permission-sweep --dry-run` weekly rotation; reads the dated report) | no |
| ai-resources/.claude/agents/findings-extractor.md | documents (reads permission-sweep report paths for friday-checkup) | no |
| ai-resources/.claude/commands/new-project.md | co-edits (sibling residual-generator; already writes `additionalDirectories` to `settings.local.json` per lines 375–405 — the target end-state) | no |
| ai-resources/.claude/commands/deploy-workflow.md | co-edits (the second residual-generator; still writes to `$PROJECT_DIR/.claude/settings.json` per line 207–229 — flagged as the separate follow-up) | no (separate risk-check) |
| ai-resources/.claude/hooks/check-permission-sanity.sh | documents (SessionStart drift nudge referenced by the command's report) | no |
| ai-resources/CLAUDE.md | documents (always-loaded Permission Management section names the command) | no |
| ai-resources/docs/settings-local-recovery.md | documents (per-machine recovery snippet for the relocated grant) | no |
| ai-resources/docs/permission-template.md § Known pending-alignment (line 220) | parses (explicitly anticipates this exact fix as a tracked follow-up) | no |

Total: 10 consumers, 0 must-change. The change is the *resolution* of a pending-alignment item the rulebook already documents (permission-template.md line 220), and the one agent it spawns (`permission-sweep-auditor`) reads the canonical rulebook unchanged, so no consumer requires modification. `/deploy-workflow` is a sibling residual-generator carrying the same defect but is explicitly out of scope (its own risk-check).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The edit is confined to `permission-sweep.md` (a command body loaded only when `/permission-sweep` is invoked) — evidence: the change description names only `permission-sweep.md`; the always-loaded `ai-resources/CLAUDE.md` § Permission Management (line 50) and workspace `CLAUDE.md` are not in scope.
- No hook is registered or modified. The change is a doc/idiom edit; `check-permission-sanity.sh` (SessionStart) is referenced in the report template (line 303) but unchanged.
- The command is pay-as-used: invoked on demand or once weekly via `/friday-checkup --dry-run` (friday-checkup.md line 181). No per-turn or per-tool-call cost added.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask` entry is added and no `deny` rule is removed. The change description states verbatim: "No permission grants are widened — the change makes remediation write to the gitignored local file instead of tracked config."
- The change *narrows* the effective surface of the remediation output: the relocated `additionalDirectories` grant moves from git-tracked `settings.json` (shared across machines) to gitignored `settings.local.json` (per-machine), preventing a foreign-machine absolute path from being committed — the exact defect canonicalized at permission-template.md Layer D (line 185) and Layer D′ (line 194).
- The new idiom seeds `defaultMode: "bypassPermissions"` into `settings.local.json` when creating it (per Layer D′ mandatory assertion, line 210). This is required for correctness, not a widening: omitting it would *shadow* the parent's bypass (root cause #1, permission-template.md line 106) — the idiom asserts an already-canonical value into the local file, matching the shape the auditor's Rule 1 would otherwise flag.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct files touched: 1 (`permission-sweep.md`). Two localized edits — line 111 phrasing row, lines 211–216 apply-idiom (per change description).
- Consumer Inventory (Step 1.5): 10 consumers, **0 must-change**. No caller depends on the *internal* jq idiom or the plain-language phrasing string being changed — both are presentation/remediation internals of the command.
- No contract change. The command's external contract (its `$ARGUMENTS` flags, the dated report path `audits/permission-sweep-{DATE}.md`, the report section headings consumed by `friday-checkup` and `findings-extractor`) is untouched. The `parses` consumers (permission-template.md, findings-extractor.md) depend on the rulebook and the report shape, neither of which the change alters.
- `/friday-checkup` consumes the command only via `--dry-run` (friday-checkup.md lines 175–183), which exits at Step 6 of permission-sweep (lines 166–170) *before* Step 8's apply-idiom — so the lines-211–216 change cannot affect the weekly rotation's behavior at all. The line-111 phrasing change *does* surface in the dry-run report, but as corrected human-readable text consistent with the rulebook the auditor already applies — a strict improvement, not a break.
- No unanticipated consumer surfaced. The inventory's most material hit — permission-template.md line 220 "Known pending-alignment item" — explicitly anticipates this fix, confirming the change description's blast-radius claim rather than contradicting it.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file, git-tracked edit. `git revert` on the commit fully restores the prior `permission-sweep.md` — evidence: change description states "Reversible (command-doc edit, git-tracked)" and the only touched artifact is a versioned command body.
- No data/log mutation. The change edits command instructions, not append-only logs (`improvement-log.md`, `decisions.md`) or registries.
- No state propagates beyond git. The command itself does not auto-run; it requires explicit invocation behind an operator approval gate (Step 7, pause-trigger #8, permission-sweep.md line 9). Reverting the doc before the next invocation leaves zero residue. Any `settings.local.json` files the *new* idiom may already have written are gitignored per-machine artifacts the operator manages directly — and writing the grant to the local file is the canonically-correct end-state regardless, so even those are not "stale" residue requiring cleanup.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The new idiom's one implicit dependency — that a Rule 8 finding's `$FILE` is the *tracked* `settings.json`, so its sibling is `settings.local.json` — is an established, documented convention: the auditor assigns Layer D to tracked `settings.json` and Layer D′ to `settings.local.json` (permission-sweep-auditor.md lines 63–66), and the `dirname($FILE)/settings.local.json` derivation mirrors the sibling-file idiom already used canonically by `/new-project` (new-project.md line 384, `LOCAL="projects/{name}/.claude/settings.local.json"`).
- The change *reduces* a latent coupling rather than adding one: today the apply-idiom (permission-sweep.md lines 213–215) silently re-introduces the machine-specific path into tracked config — a hidden defect the rulebook (permission-template.md line 185) and the auditor's own Rule 8 (line 396) already treat as wrong. Aligning the idiom closes a contract mismatch between the command's *detect* layer (already correct) and its *apply* layer (currently stale).
- No new undocumented contract. The idiom asserts values (`additionalDirectories`, `defaultMode: bypassPermissions`) whose canonical home and shape are fully specified at permission-template.md Layer D′ (lines 190–212). The mandatory `defaultMode` seeding is documented at the change site by the change description's own rationale ("per Layer D′ root-cause #1").
- No functional overlap created. `/new-project` and `/deploy-workflow` write the *same-shaped* grant to local files at scaffold time; `/permission-sweep` writes it at remediation time. These are sequential lifecycle stages, not two systems contending for the same event.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, as-of 2026-06-01).

- **OP-12 (closure before detection):** the change adds *no new detection* — the auditor and Rule 8 are unchanged. It repairs an existing *remediation/closure* path so it stops re-introducing the defect it is meant to fix. This is closure-side work, which OP-12 counts *for* a candidate, not against it.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction):** no generalization, no "hooks for later." The fix is licensed by a *present, confirmed* defect (the apply-idiom writes to tracked config) and an explicitly recorded follow-up the rulebook already names (permission-template.md line 220). It does not build for an absent consumer — `/deploy-workflow` is correctly split into its own risk-check rather than pre-emptively generalized here.
- **DR-1 / DR-3 (placement):** the change keeps the resource in its canonical home (`ai-resources/.claude/commands/`) and moves the *grant* to its canonical tier (gitignored `settings.local.json`, Layer D′) — improving placement correctness, not violating it.
- **OP-5 (advisory vs enforcement):** unchanged. `/permission-sweep` remains advisory-with-approval — it still diagnoses, presents a plan, and waits for operator approval at Step 7 (permission-sweep.md line 9). No silent enforcement upgrade.
- **OP-11 / OP-3 (loud revision):** no principle is being revised; this is alignment *toward* an existing canonical decision (the 2026-06-03 settings-path-portability decision), not drift away from one.
- **DR-10 (no `/permission-sweep` during concurrent sessions):** a standing operational constraint on *running* the command, not on editing its body; the change neither touches nor relaxes it.

No principle is violated or strained.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to permission-sweep.md, permission-template.md, permission-sweep-auditor.md, friday-checkup.md, new-project.md; grep counts for the consumer inventory; principle IDs from principles-base.md; verbatim quotes from CHANGE_DESCRIPTION). No training-data fallback was used on fetch/read failures.
