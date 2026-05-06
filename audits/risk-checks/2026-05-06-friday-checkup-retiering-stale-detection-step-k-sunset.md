# Risk Check — 2026-05-06

## Change

Edit `ai-resources/.claude/commands/friday-checkup.md` (system-wide critical command, every Friday maintenance session). Three sub-changes bundled: (A) Move Steps G (W2.1 doc-scanner) and I (W2.3 + /kb-integrity) from monthly+ cadence to weekly cadence — remove "Skip entirely if TIER=weekly" gate from both steps; update Step 4 runtime estimate (+5 min weekly). Steps H, J, K remain monthly+. (B) Add [STALE] improvement-log detection rule in Step 6 tactical follow-ups: read ai-resources/logs/improvement-log.md; for each entry where the Status: line matches "logged (pending)", compute days since the entry's ### YYYY-MM-DD header date; if >28 days, emit follow-up "[STALE] Improvement entry {title} pending {N} days — risk: med". (C) Step K Phase-1 sunset: remove subitems that update output/phase-1/components/projects.md and output/phase-1/repo-state.md; update subitem that said "both files" to say vault files only; add one-line note at top of Step K stating Phase 1 components/ is a frozen archive after D-38 (2026-05-06). Also: update tactical follow-up shape at line 275 (W2.1 Added entry) to point paste destination at vault/components/ instead of output/phase-1/components/. Plan-time gate — Fixes 5+6 of v3 vault-maintenance fix plan.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/components/projects.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/output/phase-1/repo-state.md` — exists (will become read-only archive)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/projects/projects.md` — exists (gitignored vault content)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Bundled change touches a high-traffic Friday-cadence command with multiple downstream consumers (`/friday-act`, `/so-monthly`, `/monday-prep`, `friday-checkup-reminder.sh`, paired `doc-scanner-agent` retarget); contracts remain intact and revert is clean, but blast-radius and hidden-coupling pressure require explicit paired patches and post-landing verification.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The change does NOT touch always-loaded files (workspace CLAUDE.md, ai-resources/CLAUDE.md, repo-documentation CLAUDE.md). It edits a slash-command body that loads only when `/friday-checkup` is invoked. Pay-as-used cost.
- Sub-change (A) re-tiering: weekly cadence now executes Steps G (doc-scanner-agent spawn) and I (consolidator + `/kb-integrity` invocation) every weekly run. Per friday-checkup.md:189, the doc-scanner-agent spawn produces a drift report; per friday-checkup.md:204–214, Step I reads the §G drift report, optionally invokes `/kb-integrity` from `vault/`, and writes a consolidated summary. The change-description budget of "+5 min weekly" matches that work envelope (one Agent spawn + one Skill invocation + a small write). This is a per-session token cost on every weekly Friday run going forward — material but bounded.
- Sub-change (B) [STALE] detector adds an in-step Read of `ai-resources/logs/improvement-log.md` plus simple grep/parse of header dates. The log currently has 5 entries with `Status: logged (pending)` (grep count: 5 lines matching `Status:.*logged (pending)`); none currently exceed 28 days as of 2026-05-06 (oldest is 2026-04-22 = 14 days). Read cost is bounded by log size (~120 lines today). Modest per-run cost.
- Sub-change (C) Step K reduction is a net-decrease in usage cost at the monthly+ tier (two file edits removed; vault writes retained).
- Net: Medium — recurring per-weekly-run cost added by (A); bounded read cost added by (B); offset slightly by (C).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` entries added or removed.
- No new tool families invoked: Agent (doc-scanner-agent), Skill (`/kb-integrity`), Read, Write are all already exercised at the monthly+ tier — re-tiering does not introduce new tool patterns, only changes invocation frequency.
- No scope escalation between settings files.

### Dimension 3: Blast Radius
**Risk:** High

Files touched directly: 1 (`ai-resources/.claude/commands/friday-checkup.md`).

Dependent callers and references identified by grep across `ai-resources/`:

- `ai-resources/.claude/commands/friday-act.md` (Session 2 of the cadence): line 46 explicitly notes "section headings parsed below are produced by `/friday-checkup` Step 7's 'Section presence by tier' data contract. Do not rename them in either command without updating both ends." This change does NOT rename Step 7 section headings, so `/friday-act` is unaffected on the contract front. Tactical follow-up shape change at line 275 (paste destination → `vault/components/`) is consumed by `/friday-act` operator — operator-facing, not parse-bearing.
- `ai-resources/.claude/commands/so-monthly.md` line 12: globs `friday-checkup-*.md` and reads "patterns across the past month's advisories." Re-tiering Steps G and I to weekly means earlier weekly reports will now contain those step outputs in the per-scope summary; `/so-monthly` reads patterns, so wider availability is benign.
- `ai-resources/.claude/commands/monday-prep.md` line 190–195: locates the freshest `friday-checkup-*.md`. Same filename convention; benign.
- `ai-resources/.claude/hooks/friday-checkup-reminder.sh`: SessionStart hook; no contract dependency on internal step layout.
- `ai-resources/.claude/agents/findings-extractor.md`: reads sub-report files passed to it. The list of sub-report paths is composed by Step 5 — re-tiering changes which paths populate that list per tier, but the agent contract is unchanged.
- `ai-resources/.claude/agents/system-owner.md` line 111: reads friday-checkup output for Friday Advisory; consumes section-tier shape.
- **Paired risk-check 2026-05-06-doc-scanner-agent-vault-retarget.md** explicitly identifies `friday-checkup.md` line 275 as a "stale paste-destination guidance overlap": "Phase 6 will direct operators to paste into `vault/components/`. friday-checkup line 275 (the TODO generator) still says `output/phase-1/components/`." The current change-description includes the line-275 patch, which CLOSES that paired gap — good.
- `ai-resources/audits/working/audit-working-notes-workflow-friday-cadence.md` lines 84–85, 200: documents the existing Step 5K registry-edit pattern. Stale once Step K shrinks; no functional dependency, just a stale audit note.
- Internal Step 7 section schema: NOT changed. Step 4 runtime ceilings updated; Step 6 tactical-follow-up shape updated for line 275 (operator-facing, not machine-parsed).

Reference count:
- Direct grep of `friday-checkup` across `ai-resources/`: 30+ files (mostly historical audit reports — non-blocking).
- Active callers / hooks / agents that read or invoke: 7 (`friday-act.md`, `so-monthly.md`, `monday-prep.md`, `friday-checkup-reminder.sh`, `findings-extractor.md`, `system-owner.md`, `risk-check.md`).
- Active callers requiring modification: 0 (the line-275 patch handles the paired retarget; all other callers consume tier-level outputs unchanged).

Sub-change (C) sunset interaction: the existing Friday-checkup of 2026-05-01 wrote both `phase-1/components/projects.md` (last_updated: 2026-05-01) and `vault/projects/projects.md` (last_updated: 2026-05-01). The vault file declares its source of truth as `output/phase-1/components/projects.md` (vault file line 12: "*Source of truth: `output/phase-1/components/projects.md`*"). After (C), the vault becomes the only refresh target; the existing source-of-truth comment in the vault file (and in `vault/architecture/repo-state.md` if equivalent) will be inverted. NOT BLOCKING for the friday-checkup.md edit itself, but requires a follow-on touch on vault note headers to keep the source-of-truth declaration honest.

Verdict drivers: 7 active dependent callers (above the High threshold of >5), and one downstream content artifact (vault projects.md) carries a source-of-truth declaration that will be made stale by sub-change (C). The contract changes are backwards-compatible (no rename, no schema change), but the surface is wide enough to warrant High.

### Dimension 4: Reversibility
**Risk:** Low

- Edit is a single-file modification to a tracked text file. `git revert` of the commit fully restores the prior text in one step.
- No state pushed beyond local repo. No external API writes. No automation registered (no new hook, cron, or symlink).
- Sub-change (B) [STALE] detector executes only inside the command body — reverting the command removes the rule entirely; no persistent state written by the rule itself (any [STALE] follow-ups it emitted land in the friday-checkup-{TODAY}.md report, which is a normal session artifact).
- Sub-change (A) re-tiering: the only persistent side effect of running G/I weekly is the dated reports they produce (`output/phase-2/w2-1-doc-scan-YYYY-MM-DD.md`, `output/phase-2/w2-3-maintenance-YYYY-MM-DD.md`, vault `_integrity-report-YYYY-MM-DD.md`). Reverting the friday-checkup edit prevents future weekly invocations; existing dated reports remain on disk as a historical record. Operator can delete or ignore — not a revert blocker.
- Sub-change (C) sunset: removed Step K subitems for `output/phase-1/...` writes do not destroy existing files. Phase-1 files at their 2026-05-01 last_updated state become a frozen archive; reverting restores the steps that update them.
- Operator muscle memory: weekly runs newly include G/I. If reverted, operators expecting weekly W2.1 drift reports would notice their absence — small re-orientation cost, no data loss.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Sub-change (A) implicit dependencies: Step I (W2.3 consolidator) reads the §G drift report and conditionally invokes `/kb-integrity` against `vault/`. The conditional check at friday-checkup.md:207 is "check whether `projects/repo-documentation/vault/CLAUDE.md` exists." The vault is deployed (verified: vault/CLAUDE.md exists), so the conditional path is now active for weekly runs. The `/kb-integrity` command exists at `projects/repo-documentation/vault/.claude/commands/kb-integrity.md` (verified). Coupling is established and named in-step — Low for (A).
- Sub-change (B) implicit dependencies: the [STALE] detector silently relies on the improvement-log schema — specifically, the `Status:` line containing the literal string `logged (pending)` and entries being introduced by `### YYYY-MM-DD —` headers. Both conventions are documented in `ai-resources/logs/improvement-log.md` lines 5–8 ("Schema") and verified in the live file (5 matching entries today). However, if an operator ever uses `Status: pending` or `Status: logged` alone (the schema lists `logged | proposed | pending | applied YYYY-MM-DD` as separate values, but the live convention has settled on the compound `logged (pending)`), the detector silently misses them. The change-description hardcodes the literal `logged (pending)` — narrower than the schema. Operator should be aware of this narrowing, OR the detector should match `Status: logged` OR `Status: pending` OR `Status: logged (pending)`. **Documented coupling, but the contract is encoded in the command body, not in the improvement-log schema. New contract not declared at the data-source side — schema-section in improvement-log.md does not yet say "Status values are matched verbatim by /friday-checkup [STALE] detector." Medium-level hidden contract.**
- Sub-change (B) date arithmetic: relies on the `### YYYY-MM-DD —` header date as the entry's age proxy. If an operator edits an entry without changing its header date, the age-since-original-logging assumption holds. If an operator splits or merges entries, the date may not reflect activity. Acceptable convention but undocumented at the data side.
- Sub-change (C) source-of-truth inversion: vault files (`projects/repo-documentation/vault/projects/projects.md` line 12) currently declare "*Source of truth: `output/phase-1/components/projects.md`*". After (C), the friday-checkup will write only the vault copy, but the vault file's own header still claims phase-1 is canonical. **Two systems will disagree on which is canonical until the vault headers are updated.** This is a documented-but-stale-after-change coupling — Medium concern.
- Step K's added one-line note about Phase 1 being frozen after D-38 introduces a decision-anchor reference (D-38). Operator should ensure the decisions log captures that decision. Not visible in the change-description; potential ungrounded reference.

## Mitigations

- **Mitigation for Dimension 3 (blast radius):** Bundle a paired vault-content header update with this change — update `projects/repo-documentation/vault/projects/projects.md` line 12 ("Source of truth: ...") AND `vault/architecture/repo-state.md` equivalent line so the vault declares itself canonical. Without this, weekly Step K will write only the vault copy, but the vault file will still claim phase-1 is canonical — operator-confusing. Note: vault content is gitignored, so the header edit is local-only — but it must still be done to keep the vault honest.
- **Mitigation for Dimension 3 (blast radius):** Verify decision D-38 (2026-05-06, Phase 1 frozen archive) is logged in `projects/repo-documentation/logs/decisions.md` before or as part of this commit. The Step K one-line note references D-38; if the decisions log lacks the entry, the reference is ungrounded.
- **Mitigation for Dimension 3 (blast radius):** After landing, run a single weekly `/friday-checkup` (or override with `weekly` argument) to verify Steps G and I execute end-to-end on the weekly tier, the Step 4 runtime estimate matches reality, and the [STALE] detector emits zero entries today (expected — none of the 5 pending entries exceed 28 days).
- **Mitigation for Dimension 5 (hidden coupling):** Choose explicitly between (a) hardcoding `Status: logged (pending)` literal match in the [STALE] detector — operator-acceptable if the schema entry in `improvement-log.md` is updated to declare `logged (pending)` as the canonical "open work item" state — or (b) matching any of `Status: logged`, `Status: pending`, `Status: logged (pending)`, `Status: proposed` as triggering the staleness clock. Document the choice at the data-source side (improvement-log.md schema section, lines 5–8) so future operators editing the log understand the contract.
- **Mitigation for Dimension 5 (hidden coupling):** When updating Step 6, name the data contract explicitly in a one-line comment: "[STALE] detector matches `Status: logged (pending)` literal; entry-age computed from `### YYYY-MM-DD` header." This makes the silent coupling visible at the change site for future maintainers.
- **Mitigation for Dimension 1 (usage cost):** Optionally add a short "weekly tier may invoke /kb-integrity if vault is deployed" line under Step 4 runtime estimate so operators expect the +5 min and can override to manual `/friday-checkup monthly` when in a hurry.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). Specifically: friday-checkup.md lines 150, 163, 184, 194, 200–214, 245–261, 275 (current step content); friday-act.md line 46 (data contract); so-monthly.md line 12, monday-prep.md lines 190–195 (callers); paired risk-check 2026-05-06-doc-scanner-agent-vault-retarget.md lines 43, 62, 67 (overlap); improvement-log.md lines 5–15 (schema), 5 entries with `Status: logged (pending)`; vault projects.md line 12 (source-of-truth claim); vault/CLAUDE.md (vault deployed). No training-data fallback was used.
