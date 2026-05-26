# Risk Check — 2026-05-25

## Change

End-time risk-check batched across all Phase 6 changes (WU1+WU2+WU3). WU1 committed `32621b1`: new `.claude/skills/failure-mode-detector/SKILL.md` (defect classifier, per-event + per-unit + closeout modes; sole writer of `harness/learning/hardening-registry.json`). WU2 committed `2050c85`: new `.claude/skills/prompt-hardener/SKILL.md` (pure-function hardener, no registry writes); edits to `.claude/skills/session-governor/SKILL.md` (Phase B step 12 STUB replaced with detector→hardener→re-invoke wiring; Phase D closeout extended with hardening-registry terminal transition; Marker Family Legend + Stub Marker Index updated); edit to `.claude/references/harness-rules.md` (prompt-hardener added to canonical load list). WU3 (not yet committed): edits to `.claude/skills/session-reporter/SKILL.md` (six-field→eight-field: added Field 7 verification statistics + Field 8 hardening log to Steps 2, 4, 5; added hardening registry as input; updated frontmatter description v1→v1.5); edits to `harness/prep/harness-roadmap.md` (Current State table: split Phases 6–8 row into Phase 6 ✅ + Phases 7–8 ⬜; Track B row B5–B6 marked done with commit SHAs; Current focus header updated). Plan-time risk-check returned PROCEED-WITH-CAUTION with 7 mitigations (M1–M7), all applied. System-owner concurred.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/failure-mode-detector/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/learning/hardening-registry.json` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/prompt-hardener/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/references/harness-rules.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-reporter/SKILL.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/harness/prep/harness-roadmap.md` — exists

## Verdict

GO

**Summary:** All five dimensions are Low or borderline-Medium with mitigations already applied at plan time (M1–M7); ongoing token cost is pay-as-used (skills loaded only inside harness sessions), permissions and write-ownership remain unchanged, blast radius is contained behind a single sequencing site (governor step 12 + Phase D), reversibility is clean for code while registry data is the only append-only mutation point (currently empty `[]`), and hidden coupling is documented inline at every contract boundary (M2 re-read flag, M6 separator, M7 re-invoke cap, single-writer discipline, naming dependency on `prompt-hardener`).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to always-loaded files (workspace CLAUDE.md, repo CLAUDE.md untouched). Verified by inspection of `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (175 lines) — no Phase 6 content; the only harness pointer is the existing "Agent Harness" section at line 172 referencing `@.claude/references/harness-rules.md` (on-demand load).
- No new hooks registered. Inspection of `.claude/settings.json` shows the existing four hook families (`SessionStart`, `PreCompact`, `PostCompact`, `SubagentStop`) — none modified by Phase 6.
- New skills are pay-as-used. `failure-mode-detector` (437 lines) and `prompt-hardener` (220 lines) are auto-loaded only inside harness sessions via the canonical load list at `.claude/references/harness-rules.md` lines 7–15, which itself is on-demand-loaded (per its own line 4: "Load this file before invoking any of …" and CLAUDE.md line 174: "Do not load it for unrelated work"). Outside harness sessions there is zero ongoing token cost.
- The harness-rules canonical load list grew by one entry (line 11: `prompt-hardener`), adding ~6 tokens to that on-demand file — trivial.
- Session-reporter grew from six-field to eight-field (frontmatter description v1→v1.5, Steps 2/4/5 extended); reporter is invoked once per session by governor Phase D. Per-session cost increment is small and amortized across the whole session.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to `.claude/settings.json` or `.claude/settings.local.json`. The change set is skills + a reference doc + a roadmap — none of which interact with the permission system.
- New skills declare no new tool requirements beyond the existing repo posture. `failure-mode-detector` uses `Read`, `Write`, `Edit`, `Bash` (cat/grep/jq) — all already in `allow` (`.claude/settings.json` lines 4–22). `prompt-hardener` is pure-function with zero filesystem/tool footprint (verified: prompt-hardener/SKILL.md lines 50–56: "No `Read`, `Write`, `Edit`, `Bash`, or `Agent` tool calls").
- No `deny` rule narrowed or removed (`.claude/settings.json` lines 28–34 unchanged).
- Recursion guard explicitly forbids new sub-agent capability: detector/SKILL.md lines 56–68 and hardener/SKILL.md lines 44–56 both ban `Agent` calls. Recursion-safe by skill-level contract.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grep enumeration of references to the Phase 6 components (`failure-mode-detector|prompt-hardener|hardening-registry`) returned 18 files across `.claude/`, `harness/schemas/`, `harness/prep/`, `harness/logs/`, `harness/reports/`, and `logs/`. The structural callers (not logs/reports) are: `.claude/skills/session-governor/SKILL.md` (caller), `.claude/skills/session-reporter/SKILL.md` (downstream reader of registry), `.claude/skills/mandate-parser/SKILL.md` (Phase A reader of `active_hardenings` summary), `.claude/references/harness-rules.md` (canonical load list), `harness/schemas/write-ownership.md` (line 11 declares detector sole writer), `harness/schemas/hardening-registry-schema.md` (entry shape), `harness/schemas/promotion-candidates-schema.md` (referenced), `harness/prep/harness-roadmap.md` (status table) — 8 structural touchpoints.
- All structural callers are either (a) edited in this change set (governor, reporter, harness-rules, harness-roadmap) or (b) pre-existing and compatible by contract (write-ownership.md line 11 already names "failure mode detector"; hardening-registry-schema.md describes the entry shape the new skill emits; mandate-parser reads `active_hardenings` which is a pre-existing Phase A field).
- Contract changes:
  - Session-reporter expanded six-field → eight-field (frontmatter description v1→v1.5; Steps 2/4/5 extended). This IS a contract change for downstream readers of `harness/reports/session-report-{session_id}.{md,json}`. Backwards-compatible: empty-state values are defined (reporter/SKILL.md lines 116, 124, 204–206 — `(none — no verification_result events in this session)`, empty arrays). Legacy six-field consumers reading by field name (Completed/Committed/Failed/Verified/Judgment calls/Improve next time) still find their fields intact; the two new fields appear after.
  - JSON companion shape extended with `verification_stats` and `hardening_log` objects (reporter/SKILL.md lines 185–199). Pure additive — existing consumers of `session_id`/`session_completed`/`units_committed` unaffected.
  - Governor step 12 STUB replaced with detector→hardener→re-invoke wiring (governor/SKILL.md lines 275–305). Internal control-flow change scoped to the governor's own state machine; no external caller depends on step 12's prior stub.
  - Phase D gained a new step 4 (hardening-registry terminal transition), renumbering Session Reporter trigger from step 4 to step 5 (governor/SKILL.md line 699: "renumbered after Phase 6 inserted step 4"). Reader of Phase D ordering must consult the file directly — no programmatic caller depends on the step number.
- Roadmap edit is documentary, not contract-bearing.

### Dimension 4: Reversibility
**Risk:** Medium

- Code-side reversibility is clean. WU1 (commit `32621b1`) and WU2 (commit `2050c85`) are atomic git commits — `git revert <sha>` restores prior state of the skill files and governor/reference edits. WU3 is still uncommitted (per the change description), so it lives in the working tree.
- Data-side has one append-only mutation point: `harness/learning/hardening-registry.json`. Inspection shows the file currently contains `[]` (1 line, the empty array). No entries written yet — full revert is a clean no-op for data state at this moment.
- If a future session writes a registry entry and the operator then reverts Phase 6 commits, the entry persists (M4-class concern from session-reporter/SKILL.md lines 286–289: "session-log.json is append-only; a `git revert` does not strip a `session_completed` row"). The same concern applies to `hardening-registry.json` — append-only mid-session writes survive a code revert. The closeout-mode back-fill (`commit_sha`, `session_status`, `effectiveness`) updates entries in place and is also non-trivially reversible.
- Rollback would require: (a) `git revert 32621b1 2050c85`, (b) discard WU3 working-tree edits to session-reporter and harness-roadmap, (c) IF the registry has been populated since: manually truncate `harness/learning/hardening-registry.json` back to `[]`. Today only step (a)+(b) are needed because the registry is empty; the Medium rating reflects the latent third-step cost once real sessions run.
- No state propagated beyond the local repo (no `git push`, no external API, no Notion write). No automation fires unprompted — the new skills are invoked only by the governor, which is invoked only by harness sessions.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Plan-time mitigations M1–M7 explicitly documented the seven implicit dependencies. Verified in the change site:
  - **M2 (re-read-registry flag contract)** — governor/SKILL.md lines 436–451 document the flag as in-memory, single-use, restricted to post-hardener path with explicit note: "If a future change moves Phase C inside the step-12 → step-6 path, the flag must be promoted to `current-state.json` to survive rehydration."
  - **M6 (closeout sequencing separator)** — governor/SKILL.md lines 655 and 677 contain HTML-comment separators between the learnings closeout (item 3) and the hardening-registry closeout (item 4), and between item 4 and the Session Reporter trigger (item 5). Comment text states the editorial-independence rationale.
  - **M7 (one-re-invoke-per-unit cap)** — governor/SKILL.md lines 292–299 document the cap with rationale: "the `Stop`-hook veto that would otherwise gate runaway sub-agent re-invocations is still a Phase 1 stub … bounding the loop in the governor prevents an unbounded harden cycle within a single unit."
- Single-writer discipline is contractually preserved and re-stated at every relevant site: write-ownership.md line 11 declares the detector sole writer of `hardening-registry.json`; detector/SKILL.md lines 410–414 reiterate; hardener/SKILL.md lines 184–188 explicitly disclaim writing; governor/SKILL.md lines 672–675 (Phase D item 4) reiterate ("the failure-mode-detector is the sole writer … the governor only sequences the call. No second writer is introduced").
- Naming dependency on the literal string `"prompt-hardener"` (detector/SKILL.md lines 264, 279–281) is documented inline as a known fragility: "If WU2 picks a different name during build, update this field's literal in the same commit." WU2 did register the skill at that exact name (prompt-hardener/SKILL.md line 2: `name: prompt-hardener`) — contract honored.
- `registry_entry_index` fragility (detector/SKILL.md lines 270–276) is documented inline: "if `capture-corrections` (Phase 8) or a future actor ever inserts entries (vs. updates in-place), the index can shift. Phase D closeout should locate entries by `(unit_id + timestamp)` if the array length changes between write and closeout." This is an explicit Phase 8 follow-up surface, not an undocumented coupling.
- `rule_matched` is a calibration field invented by Phase 6, not specified upstream (detector/SKILL.md lines 241–245) — explicitly flagged as Phase-6-internal with "downstream readers (session-reporter) must tolerate its absence in legacy events."
- The closeout-mode `effectiveness` derivation depends on a specific event-ordering convention: "the next `verification_result` event with `payload.source = 'skill'` after the `prompt_hardened` event for the same unit_id" (detector/SKILL.md lines 380–386). Convention is restated where it matters (reporter/SKILL.md line 121: "match by `unit_id` … written by the detector's `closeout` mode during Phase D before the reporter runs"). Phase D ordering is the only place where this contract is enforced (governor Phase D item 4 runs before item 5).
- No silent auto-firing in unexpected contexts — the new pipeline activates only on the step 12 second-occurrence path, which is itself gated by step 11 re-invoke failure (governor/SKILL.md lines 261–273).
- One latent overlap: harness-rules.md §Compaction preservation instructions (lines 80–84) names three files for rehydration ("mandate.json, current-state.json, hardening-registry.json"); governor's Phase C step 3 lists four files (governor/SKILL.md lines 596–599, with explicit note at lines 600–607 reconciling the three-vs-four discrepancy as a deliberate subset). This is a documented coupling, not a hidden one — addressed.

## Mitigations

Verdict is GO; no mitigations required beyond the M1–M7 set already applied at plan time and verified in the change sites above.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file path + line references, grep counts across 18 referenced files, verbatim quotes from CHANGE_DESCRIPTION, the seven referenced files, and the workspace CLAUDE.md). No training-data fallback was used. Two notes:

1. WU3 commit status is taken from CHANGE_DESCRIPTION ("WU3 (not yet committed)") — file-state evidence on disk shows WU3 edits already applied to session-reporter/SKILL.md (frontmatter at line 4 reads "Session Reporter v1.5"; eight-field shape present at lines 82–124) and to harness-roadmap.md (Phase 6 ✅ row present at line 31), confirming WU3 work is done in the working tree even if not yet committed. Reversibility rating accounts for this.
2. `hardening-registry.json` was read directly (1 line: `[]`) — empty-state confirmed.
