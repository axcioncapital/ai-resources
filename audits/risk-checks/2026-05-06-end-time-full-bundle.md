# Risk Check — 2026-05-06

## Change

Six fixes executed on three files (end-time gate — all changes are live in the working tree, not yet committed):

Fix 1 — `projects/repo-documentation/.claude/agents/doc-scanner-agent.md`: Retargeted W2.1 from `output/phase-1/components/` baseline to `vault/components/` vault baseline. Changes: (a) frontmatter description updated; (b) intro sentence updated; (c) Phase 2 reads vault/components/ (12 files) instead of output/phase-1/components/ (11 files); (d) added precondition guard in Phase 2 — if vault/components/ has <8 .md files, abort with [BASELINE MISSING]; (e) Phase 3 harness-skip comment updated from stale "out of scope per project CLAUDE.md" to cite D-31/D-37; (f) Phase 5 entry shape expanded from 6-field to 12-field for standard categories (adds Triggers/Scope/Used By/Depends On/State Writes/Governed By with [EVIDENCE GAP] defaults) and 10-field for projects category with explicit selector; (g) Phase 6 operator paste instructions point to vault/components/{category}.md; (h) Rules section updated to describe vault as baseline and output/phase-2/ as write target; (i) "Skip harness" rule in Rules updated to cite D-31/D-37.

Fix 2 — `projects/repo-documentation/vault/.claude/commands/kb-integrity.md`: Added Check G (schema-conformance) after Check F. Check G parses field-row tables at §4.1 (12-field) and §4.4 (10-field) from documentation-structure.md — NOT prose. Standard categories validate against §4.1; projects.md validates against §4.4. Missing required field → error; unexpected field → warn; [EVIDENCE GAP] → info. Status-enum cross-category check included.

Fix 3 — `projects/repo-documentation/vault/.claude/commands/kb-integrity.md`: Check E draft-aging severity escalated from `info` to `warn` for status:draft notes older than 30 days. 30-day threshold unchanged. Projects-registry excluded (no `draft` in projects Status enum).

Fix 4 — `projects/repo-documentation/references/documentation-structure.md`: Added schema-change protocol note near top of file. Updated §7 W2.1 target reference from output/phase-1/components/ to vault/components/ (per D-36/D-37).

Fix 5 — `ai-resources/.claude/commands/friday-checkup.md`: Added [STALE] improvement-log detection rule in Step 6 tactical follow-ups. Matches entries with Status: logged (pending); computes age from ### YYYY-MM-DD — header; emits follow-up if >28 days. Includes inline data-contract comment (literal match, bold-marker tolerant, age basis = header date).

Fix 6 — `ai-resources/.claude/commands/friday-checkup.md`: (a) Step G (W2.1) moved from monthly to all tiers — "Skip if TIER=weekly" removed; (b) Step I (W2.3/kb-integrity) moved from monthly to all tiers — same removal; (c) Step 4 runtime estimate updated (+3 min W2.1, +2 min kb-integrity for weekly when repo-documentation selected); (d) W2.1 Added entry tactical follow-up paste destination updated from output/phase-1/components/ to vault/components/; (e) Step K Phase-1 sunset: subitems updating Phase-1 archive removed; subitem 4 updated to vault files only; note added at top stating Phase-1 frozen after D-38; (f) Step 2 auto-run checks display updated to show G+I at weekly tier.

Also updated gitignored vault content files (vault/projects/projects.md, vault/architecture/repo-state.md) to declare themselves canonical rather than referencing phase-1 as source of truth.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/agents/doc-scanner-agent.md` — exists (modified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/.claude/commands/kb-integrity.md` — exists (modified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/references/documentation-structure.md` — exists (modified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md` — exists (modified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/projects/projects.md` — exists, gitignored (modified)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/architecture/repo-state.md` — exists, gitignored (modified)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Bundle lands the paired plan-time mitigations from the two prior risk-checks (doc-scanner retarget + friday-checkup retiering) and applies the schema-conformance contract (Check G) consistently across agent / command / spec — but blast radius is wide (7+ active callers of friday-checkup, 6 propagation targets for the schema), and one Fix-6 sub-change (Step 2 display vs. friday-checkup section-headings parser) plus the gitignored-vault canonical-source declarations carry residual coupling that benefits from explicit verification.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- No always-loaded file (workspace CLAUDE.md, ai-resources/CLAUDE.md, project CLAUDE.md, vault CLAUDE.md) is touched. All edits live in pay-as-used files: a project-local agent (doc-scanner-agent.md, 222 lines), a vault-scoped command (kb-integrity.md, 101 lines), an on-demand reference (documentation-structure.md, 447 lines), and an orchestrator command body (friday-checkup.md, 395 lines). No new `@import`, no new hook, no broadly pattern-matching skill.
- Fix 6 (a)+(b) re-tier Steps G and I to weekly — verified at friday-checkup.md:184 ("all tiers") and :202 ("all tiers"). Per-weekly-Friday cost added: one Agent spawn (`doc-scanner-agent`) plus one Skill invocation (`/kb-integrity`) plus a small consolidator write. Step 4 runtime estimate (lines 108–109) declares `+3 min W2.1` and `+2 min kb-integrity` per weekly run when project repo-documentation is selected. Cost is recurring but bounded and gated by scope selection.
- Fix 5 [STALE] detector (lines 286 inline data-contract comment) adds a per-friday-run Read of `ai-resources/logs/improvement-log.md` (~120 lines today) plus a literal `Status:.*logged (pending)` grep + header-date arithmetic. Today's match-count = 5 entries (verified via `rg -c "logged \(pending\)" ai-resources/logs/improvement-log.md`); none exceed the 28-day threshold (oldest header within current run window). Modest, bounded read cost.
- Fix 2 Check G adds per-`/kb-integrity` Read of `references/documentation-structure.md` (447 lines) plus parsing of two field-row tables. Run cadence is now weekly (per Fix 6); the parse runs once per `/kb-integrity` invocation (not per entry). Bounded.
- Fix 3 severity escalation (info→warn for draft notes >30d) does not change run cost; it changes finding categorization only.
- Net: Medium — recurring per-weekly-friday cost added by Fix 6 (A+B); bounded per-run cost added by Fixes 2 and 5; no always-loaded growth.

### Dimension 2: Permissions Surface
**Risk:** Low

- The doc-scanner-agent `tools` frontmatter is unchanged — `Read, Glob, Grep, Write` (doc-scanner-agent.md lines 5–9). The new vault baseline read (`projects/repo-documentation/vault/components/*.md`) is project-local and covered by the existing Read permission.
- kb-integrity.md frontmatter declares only `model: sonnet` (no tool-frontmatter narrowing); Check G's new Read of `references/documentation-structure.md` is within the existing scope. No `allow`/`ask`/`deny` entries added or removed in any settings file.
- friday-checkup.md changes invocation frequency for already-allowed tools (Agent, Skill, Read, Write); no new tool families. No scope escalation across settings files.
- documentation-structure.md edit is a content edit only.

### Dimension 3: Blast Radius
**Risk:** High

Files touched directly: 4 tracked + 2 gitignored vault content = 6 total.

Dependent caller / consumer enumeration (grep across full Axcion AI Repo):

- **`doc-scanner-agent` callers (1 active):** `ai-resources/.claude/commands/friday-checkup.md` Step G (lines 184–193) — verified compatible with retarget; the orchestrator only checks the agent file exists and reads back the report path. No internal-Phase parsing.
- **Schema-shape consumers (3 propagation targets):** `vault/.claude/commands/kb-update.md` (Step 3 embeds component schema — verified file present at `projects/repo-documentation/vault/.claude/commands/kb-update.md`), `vault/.claude/commands/kb-integrity.md` Check G (NOW patched in Fix 2), `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` Phase 5 (NOW patched in Fix 1). The schema-change protocol note added in Fix 4 (documentation-structure.md line 7) explicitly enumerates these three. **Fix 4 names the propagation contract; Fixes 1+2 patch two of three; kb-update.md remains a propagation target that this bundle does NOT touch — it is implicitly load-bearing on `output/phase-1/components/` references that may now be stale.**
- **`friday-checkup` active callers / consumers (7):** `ai-resources/.claude/commands/friday-act.md` (Session 2 — line 46 declares "section headings parsed below are produced by `/friday-checkup` Step 7's 'Section presence by tier' data contract; do not rename them in either command without updating both ends" — Step 7 section headings are NOT renamed by Fix 6, so contract holds). `ai-resources/.claude/commands/so-monthly.md` line 12, `ai-resources/.claude/commands/monday-prep.md` lines 190–195, `ai-resources/.claude/hooks/friday-checkup-reminder.sh`, `ai-resources/.claude/agents/findings-extractor.md`, `ai-resources/.claude/agents/system-owner.md` line 111, paired `risk-check.md` workflow (operator-driven) — none require modification.
- **`documentation-structure.md` schema consumers (3):** doc-scanner-agent.md (NOW patched), kb-integrity.md (NOW patched), kb-update.md (NOT patched; per Fix 4's own propagation list). The §7 W2.1 target line was updated to vault/components/ — verified at line 441 ("Targets `vault/components/*.md` as baseline (per D-36/D-37, 2026-05-06 retarget)"). Older §1.3, §1.4, §4 still reference `output/phase-1/components/` as historical canonical layout — this is intentional (those sections describe Phase 1; §7 is the Phase 2 hook the agent reads) but creates two readings within the same file.
- **`kb-integrity` callers (1):** `friday-checkup.md` Step I (line 210 — invokes `/kb-integrity` from `vault/`). Re-tiered to weekly by Fix 6 (b). Compatible.
- **Gitignored vault content (2):** `vault/projects/projects.md` and `vault/architecture/repo-state.md` re-declare themselves canonical (verified at projects.md line 12 — "*This vault file is the canonical living version (per D-26/D-38, 2026-05-06)*"; repo-state.md line 12 — same form). This addresses the "two systems disagree on canonical source" concern raised in the prior friday-checkup risk-check (2026-05-06-friday-checkup-retiering-stale-detection-step-k-sunset.md Mitigation 1).
- **Friday-checkup Step 2 auto-run display (Fix 6 (f)):** verified at friday-checkup.md:62–63 — display now reads "Weekly:  /audit-repo, /improve, /coach (if ≥5 sessions), /permission-sweep --dry-run; W2.1 doc-scanner + /kb-integrity (if project repo-documentation selected)". This is operator-facing prose, not parsed by `/friday-act`. No data-contract impact.

Reference counts:
- `doc-scanner-agent` grep: 26 file hits (most historical audit reports; 1 active orchestrator).
- `kb-integrity` grep: 49 file hits (most documentation references; 1 active caller, 1 vault-CLAUDE.md description).
- `documentation-structure` grep: 31 file hits; 6 functional consumers (3 agents/commands embed/parse schema; 3 docs reference shape).
- `friday-checkup` grep: 49 file hits; 7 active callers (above the High threshold of >5 from the framework); 0 require modification under this bundle.

Verdict driver: friday-checkup's 7 active callers exceed the High threshold; documentation-structure.md has 3 active schema-propagation consumers of which one (kb-update.md) is named in Fix 4's protocol but not amended by this bundle. The contract changes are backwards-compatible (no rename, no tier-section schema change), but the surface is wide enough to warrant High.

### Dimension 4: Reversibility
**Risk:** Medium

- Tracked-file edits (4 files: doc-scanner-agent.md, kb-integrity.md, documentation-structure.md, friday-checkup.md) are clean `git revert` candidates. Single revert restores prior text in one step.
- Gitignored vault content edits (vault/projects/projects.md, vault/architecture/repo-state.md) are NOT covered by `git revert` because vault content is gitignored. If the bundle's tracked edits are reverted, the vault file headers would still claim "vault canonical (per D-26/D-38)" — a residual stale assertion the operator must manually edit back. This is the single multi-step rollback element.
- Sub-change Fix 6 (a)+(b) re-tiering: side effects on revert are bounded — dated reports already produced by weekly runs (`output/phase-2/w2-1-doc-scan-YYYY-MM-DD.md`, `w2-3-maintenance-YYYY-MM-DD.md`, vault `_integrity-report-YYYY-MM-DD.md`) remain on disk as historical artifacts; no destructive cleanup needed; operator can ignore. No external API writes, no automation registered.
- Sub-change Fix 6 (e) Phase-1 sunset removes Step K subitems that wrote to phase-1 files. If reverted, the steps return; phase-1 files at their last-written state remain readable. No data destroyed.
- Sub-change Fix 5 [STALE] detector executes only inside command body — reverting removes the rule entirely; any [STALE] follow-ups it emitted land in friday-checkup-{TODAY}.md (normal session artifact, not log mutation).
- Sub-change Fix 3 severity escalation produces different finding tiers in dated `_integrity-report-{TODAY}.md` files. If reverted, future reports change back; existing reports retain their warn-tier categorization. Cosmetic, not destructive.
- Operator muscle memory: weekly Fridays now include G+I; revert removes that. Small re-orientation cost.
- Net: Medium — tracked edits revert cleanly in one step; gitignored vault header inversions require one extra manual cleanup step; no external propagation.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Fix 4 schema-change protocol coverage gap.** documentation-structure.md line 7 (Fix 4) enumerates three propagation targets: kb-update.md Step 3, doc-scanner-agent.md Phase 5, kb-integrity.md Check G. Fixes 1 and 2 patch two of those; **kb-update.md is not amended in this bundle**. If kb-update.md Step 3 still embeds the old 6-field schema (or a different field selector), then `/kb-update` adds entries with the wrong shape and `/kb-integrity` Check G will flag them as schema violations. Verifying kb-update.md alignment is required before the schema-conformance check stops being a self-inflicted noise generator.
- **Fix 5 [STALE] detector contract is encoded only at the command body.** Verified at friday-checkup.md:286 — the inline data-contract comment ("match literal `Status:` followed by `logged (pending)`; whitespace-tolerant; allows bold markers; age basis is the `### YYYY-MM-DD —` header date"). The improvement-log.md schema header (lines 5–8) lists `logged | proposed | pending | applied YYYY-MM-DD` as separate values — i.e., the data side enumerates `pending` independently, but the detector matches only the compound `logged (pending)`. This narrowing is intentional (per the prior risk-check), but the data-source side does not declare which value the detector watches. If a future operator writes `Status: pending` (a valid schema value), the [STALE] timer silently does not start. Hidden contract — coupling is documented at the command site but not at the data site.
- **Fix 1 (h) Rules + Fix 1 (a) frontmatter description: vault as baseline now requires local vault state.** Per project CLAUDE.md ("Vault content is gitignored"), a fresh clone has empty `vault/components/`. The Fix 1 (d) precondition guard ("if count < 8, abort with [BASELINE MISSING]") protects against false-positive drift but introduces a new failure mode: the agent now refuses to scan unless local vault is present. Operator on a new machine must rebuild the vault before the weekly Friday cadence can run W2.1. This is named explicitly in the abort message ("vault may not be initialized"), so coupling is surfaced — but the coupling is new and operator-side.
- **Fix 6 (e) Step K source-of-truth inversion landed.** Verified: `vault/projects/projects.md` line 12 declares "*This vault file is the canonical living version (per D-26/D-38, 2026-05-06)*"; `vault/architecture/repo-state.md` line 12 same. Prior risk-check (2026-05-06-friday-checkup-retiering-...) Mitigation 1 is satisfied. No residual stale-canonical assertion in vault headers. Decision IDs verified in `projects/repo-documentation/logs/decisions.md` — D-37 (line 44), D-38 (line 45) are recorded with 2026-05-06 dates and matching content.
- **Fix 4 §7 partial-update.** documentation-structure.md §7 line 441 now says vault/components/ is the W2.1 target; older §1.3 (line 121) and §1.4 (line 147) still describe `output/phase-1/components/` as the layout (this is correct as historical Phase 1 documentation, but a future reader scanning §1 may not see §7's retarget if they read top-down). The schema-change protocol note at line 7 partially mitigates this by naming §4.1 / §4.4 as canonical for the schema, but does not cross-reference §7 vs §1.3 for the target-path question.
- **Fix 6 (f) Step 2 display is operator-facing only.** Step 2 auto-run display change (line 62–63) is descriptive prose, not parsed by `/friday-act` (which parses Step 7 section headings — unchanged). Confirmed Low-coupling.
- **Fix 2 Check G parser is "tables not prose" — explicit and named in the check body.** Verified at kb-integrity.md:40 — "Parse tables NOT surrounding prose — §4.4 prose contains stale framing; the table rows are canonical per D-29/D-34." Coupling is named at the change site.

## Mitigations

- **Mitigation for Dimension 3 (blast radius):** Before the next `/kb-update` invocation, audit `projects/repo-documentation/vault/.claude/commands/kb-update.md` Step 3 for schema alignment with the new 12-field standard / 10-field projects schema declared at documentation-structure.md §4.1 / §4.4. If kb-update.md still embeds a 6-field schema (or different field set), patch it under the same protocol Fix 4 declares — otherwise Check G will flag every `/kb-update`-produced entry as schema-violating.
- **Mitigation for Dimension 3 (blast radius):** After committing, run a single weekly `/friday-checkup` (or override `weekly`) end-to-end to verify Steps G and I execute on the weekly tier, the Step 4 runtime estimate matches reality (+3 min W2.1, +2 min /kb-integrity), the [STALE] detector emits zero entries today (expected — none of the 5 `Status: logged (pending)` entries exceed 28 days), and Check G reports cleanly against the post-vault component files.
- **Mitigation for Dimension 5 (hidden coupling, [STALE] data-contract):** Add a one-line declaration to `ai-resources/logs/improvement-log.md` schema section (around lines 5–8) stating: "Open-work-item status is `logged (pending)`; `/friday-checkup` Step 6 [STALE] detector watches this literal value and starts the 28-day timer from the `### YYYY-MM-DD —` header." This makes the silent narrowing visible to future operators editing the log.
- **Mitigation for Dimension 5 (hidden coupling, §1.3 vs §7 target reading):** Add a cross-reference at documentation-structure.md §1.3 (line ~121) noting "W2.1 target retargeted to `vault/components/` per §7 (D-36/D-37, 2026-05-06); the layout below describes the Phase 1 archive baseline." This prevents top-down readers from missing the retarget when they read §1.3 first.
- **Mitigation for Dimension 4 (reversibility, gitignored vault headers):** Document the vault-header rollback note alongside the commit message: "If reverting tracked Fix 6, also manually edit `vault/projects/projects.md` line 12 and `vault/architecture/repo-state.md` line 12 to restore the prior 'source of truth: phase-1' declarations — vault content is gitignored and not covered by `git revert`."

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file paths and line numbers from doc-scanner-agent.md lines 3, 12, 30–35, 65, 90–134, 217, 222; kb-integrity.md lines 35, 39–44; documentation-structure.md lines 7, 441; friday-checkup.md lines 62–63, 108–109, 184, 202, 251, 276, 286; vault/projects/projects.md line 12; vault/architecture/repo-state.md line 12; projects/repo-documentation/logs/decisions.md lines 44–45 confirming D-37 and D-38 are recorded), grep counts (`doc-scanner-agent`: 26 hits / 1 active caller; `kb-integrity`: 49 hits / 1 active caller; `documentation-structure`: 31 hits / 6 consumers; `friday-checkup`: 49 hits / 7 active callers; `Status: logged (pending)` in improvement-log.md: 5 entries), and prior risk-check reports (2026-05-06-doc-scanner-agent-vault-retarget.md, 2026-05-06-friday-checkup-retiering-...). No training-data fallback was used. All cited decision IDs (D-31, D-37, D-38, D-26, D-29, D-34, D-36) are either verified present in `projects/repo-documentation/logs/decisions.md` or referenced from prior risk-checks.
