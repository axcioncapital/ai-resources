# Risk Check — 2026-07-03

## Change

Add a Failure Mode Analysis schema to logs/friction-log.md and update .claude/agents/session-feedback-collector.md to produce it.

Full plan at /Users/patrik.lindeberg/.claude/plans/let-s-improve-friction-log-luminous-platypus.md.

Summary of the proposed change:
1. Insert a `## Schema` block into `ai-resources/logs/friction-log.md` (right after the `# Friction Log` H1, before the first existing `## Session` entry) defining an 8-category Failure-mode enum (Context/Mandate/Workflow/Authority/Validation/Autonomy/Safety/Traceability) plus a required Failure→Root cause→Prevention→Owner artifact chain for "substantive" entries (hand-authored narrative entries + wrap-collector entries). This is explicitly additive: it supplements (does not replace) the existing free-text "Friction type" tag already used ad hoc in entries, and it supplements (does not replace or restructure) the existing `Resolved:` / `[FADING-GATE] verified` closure stamps that 4 separate consumer files (`open-items.md`, `reconcile-backlog.md`, `fix-repo-issues-scanner.md`, `diagnostics-scanner.md`) hardcode-parse for open/closed status. Applies going-forward only — the ~40 existing entries in the file are NOT retrofitted.
2. Edit `.claude/agents/session-feedback-collector.md` in two places: (a) Phase 2 point 4 (the Friction dimension, currently at line 43) — add the requirement to assign one Failure-mode category from the new enum plus explicit Root cause/Prevention/Owner artifact, alongside (not replacing) the existing "classify the friction type: rule/command/hook/process/config" instruction; (b) the friction-log.md write-format template (currently lines 100-104) — extend the one-line bullet template to carry the four new labeled fields. Per a blind-spot-scan finding already surfaced this session: `session-feedback-collector.md` is a SINGLE shared agent definition already confirmed (via grep) writing "[wrap-collector]" entries into at least 8 project-level `logs/friction-log.md` files beyond the ai-resources one (axcion-ai-system-redesign, axcion-brand-book, axcion-copy-factory, nordic-pe-screening-project, marketing-positioning, project-planning, research-pe-regime-shift-advisory-gap, plus the workspace-root log) — none of which will carry the new Schema block. The plan's mitigation for this is to embed the full 8 one-line category definitions directly inline in the collector's own prompt (not just reference category names), so the taxonomy is self-contained wherever the collector fires, rather than only documented in ai-resources/logs/friction-log.md. This mirrors the existing precedent where logs/defect-log.md's fixed enum is duplicated into .claude/commands/log-defect.md.

Explicitly NOT in scope / NOT changing: `.claude/commands/friction-log.md` (operator one-liner command), `.claude/commands/note.md` (`friction:` prefix quick-capture), `.claude/hooks/friction-log-auto.sh` (auto tool-error hook), or any of the 4 files that parse open/closed status. No retroactive reformatting of existing friction-log.md entries.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/session-feedback-collector.md — exists
- /Users/patrik.lindeberg/.claude/plans/let-s-improve-friction-log-luminous-platypus.md — exists (plan file, not part of the shipped change)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A purely additive, well-placed schema formalization that serves AP-9 and OP-12 and breaks nothing (every parser verified compatible, must-change = 0), but carries a wide backwards-compatible blast radius across 14 code consumers + 9 write-target logs and two hidden-coupling seams (enum duplicated across schema-block + collector inline copy; a third classification axis layered onto the existing "Friction type" tag) that warrant explicit lockstep and relationship notes before landing.

## Consumer Inventory

Search terms: `friction-log`, `session-feedback-collector`, `session-feedback-dimensions`, plus the contract markers `## Schema`, `^## Session`, `### Friction Events`, `Resolved:`, `[FADING-GATE] verified`, `[wrap-collector]`, `Friction type:`. Grep run across `ai-resources` and the workspace root. Historical audit reports and `plans/` files that only *mention* the log are excluded (not functional consumers); the functional consumers of the changed contracts are:

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/open-items.md | parses (T1: `-` bullets under `### Friction Events`; `Resolved:` / `[FADING-GATE] verified` closure; `## Session — YYYY-MM-DD` date anchor) | no |
| ai-resources/.claude/agents/fix-repo-issues-scanner.md | parses (T1: same bullet + closure-stamp + `## Session` header parse) | no |
| ai-resources/.claude/agents/diagnostics-scanner.md | parses (`-` bullets under `### Friction Events`; `Resolved:` / `[FADING-GATE]` / `[STUB]` exclusions; `## Session` age parse) | no |
| ai-resources/.claude/commands/reconcile-backlog.md | parses (friction entry `Resolved:` field for closure evidence) | no |
| ai-resources/.claude/commands/improve.md (+ improvement-analyst agent) | parses/documents (reads `### Friction Events` entries semantically) | no |
| ai-resources/.claude/commands/friday-checkup.md | parses (dormancy: most-recent dated `## / ###` header; also drives /improve + /open-items over the log) | no |
| ai-resources/.claude/hooks/friction-log-auto.sh | co-edits (lightweight writer; appends session headers — plan-exempt) | no |
| ai-resources/.claude/hooks/log-write-activity.sh | co-edits (appends `#### Write Activity` events) | no |
| ai-resources/.claude/commands/friction-log.md | co-edits (operator one-liner writer — plan-exempt) | no |
| ai-resources/.claude/commands/note.md | co-edits (`friction:` prefix quick-capture — plan-exempt) | no |
| ai-resources/.claude/commands/wrap-session.md (Step 6.5) | invokes (launches session-feedback-collector, paths only) | no |
| workspace-root /.claude/commands/wrap-session.md (non-symlink copy) | invokes (independent copy launches the same shared agent) | no |
| ai-resources/.claude/agents/session-feedback-collector.md (self, Constraint E) | parses (count-proxy `grep -c '^## Session'`, line 81) | no |
| ai-resources/docs/session-feedback-dimensions.md | documents (binding rubric the collector reads first) | no |

**Total: 14 code consumers, 0 must-change.** Plus a behavioral blast radius of **9 write-target logs** (the shared collector writes `[wrap-collector]` entries into `ai-resources/logs/friction-log.md` + 8 project/workspace-root `logs/friction-log.md` files, per the change description's blind-spot finding). Those logs receive the new 4-field bullet format going forward but do NOT parse the schema — the new fields are additive to a bullet, so no parse break in any scope. No unanticipated consumer surfaced beyond the plan's own enumeration — a positive finding: the plan's consumer analysis was complete.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The schema block lands in `logs/friction-log.md`, which is NOT an always-loaded file — it is read on demand by `/improve`, `/friday-checkup` (weekly+), `/wrap-session` (conditional), and the backlog scanners. No per-turn token cost. Evidence: friction-log.md appears nowhere in workspace or ai-resources CLAUDE.md always-loaded content; consumers read it only when invoked (`friday-checkup.md:235`, `improve.md:9`).
- The collector's Phase 3 dedup is grep-first/read-narrow, not a full-Read (`session-feedback-collector.md:48-56`), so the added schema block at the top of the file does not enlarge the collector's per-invocation read.
- The collector brief (currently 131 lines) grows by the inline 8-category taxonomy + field requirements (~10-15 lines). This subagent is spawned **once per wrap**, gated behind an opt-in toggle and a trivial-session skip (`session-feedback-collector.md:3` "Invoked by /wrap-session Step 6.5") — pay-as-used, not per-turn or per-tool-call. A modest one-time-per-wrap expansion does not reach the Medium "oversized frequently-spawned brief" bar.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json changes of any layer. No new `allow`/`ask`/`deny` entries, no scope escalation.
- No new tool grant: the collector already carries `Edit` + `Bash` (append-only) in its frontmatter (`session-feedback-collector.md:5-11`); the write-format change reuses the existing append path. No new capability family introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 2 (`logs/friction-log.md`, `.claude/agents/session-feedback-collector.md`).
- Consumer inventory: **14 code consumers, 0 must-change**, plus 9 write-target logs. The count is >5, but every consumer is verified backwards-compatible — the driver of the Medium (not High) is that the change is provably additive with zero required modifications.
- Contract-preservation checks (each a place the change *could* have broken and does not):
  - The three backlog scanners key strictly on "top-level `-` bullets **under** `### Friction Events`" (`open-items.md:35`, `fix-repo-issues-scanner.md:34`, `diagnostics-scanner.md:59`). The `## Schema` block sits above the first `## Session` header with no `### Friction Events` heading, so it cannot be mis-parsed as an entry.
  - The collector's Constraint E count-proxy is `git show HEAD:logs/friction-log.md | grep -c '^## Session'` (`session-feedback-collector.md:81`). `## Schema` does not match `^## Session`, so the baseline entry count and the concurrent-rewrite abort guard are unaffected.
  - The 4 status parsers close entries on `Resolved:` (non-empty) or `[FADING-GATE] verified`. The new `**Owner artifact:**` field carries a file/command/rule value or `(none identified)` — it is NOT a `Resolved:` token, so it cannot trigger a false "closed" classification.
  - `friday-checkup.md:316` dormancy reads the *most-recent* dated header — a dateless schema block at the top does not shift it.
- Shared-infra reach: the edit is to a shared log format AND a single shared agent that fires across 9 logs (canonical + 8 project/workspace-root). That is a genuinely wide surface — the reason this is Medium rather than Low — but the contract change is backwards-compatible additive, so the width does not translate into required downstream edits.

### Dimension 4: Reversibility
**Risk:** Low

- Both edits are single-file additive edits; the schema insertion is at the top of the file (after line 1), all appends land at the bottom, so a `git revert` touches a non-overlapping region and restores prior state cleanly. The plan's own verification asserts insertion-only, zero-deletion diff (`plan:52`).
- Residue consideration: once the collector writes 4-field entries into the append-only logs, a later revert of the agent definition does NOT remove those already-written entries. However, they remain valid friction bullets — parsers ignore the extra labeled fields — so no cleanup step is required (benign residue, not a stale-state hazard). This keeps the dimension Low rather than Medium.
- No state propagates beyond git (no push, no external write, no automation firing). The write mechanism is unchanged (still append-only `Edit`/heredoc), so this change introduces no new reversibility hazard beyond what already exists.
- Caveat (not a downgrade): `logs/friction-log.md` is a documented concurrent-write target (see friction-log 2026-06-09 S3 shared-staging-index entanglement). Committing the top-of-file schema insertion while a concurrent session appends at the bottom is safe on the revert axis (disjoint regions) but should still use explicit-path staging, not a directory wildcard, per DR-10 and commit-discipline.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- New contract, documented at the change site (good): the 8-category enum + 4-field chain is defined in the `## Schema` block of the log it governs AND embedded inline in the collector prompt — the correct producer-and-canonical documentation pattern.
- Coupling seam 1 — enum duplicated in two homes. The 8-category taxonomy will live both in the schema block and inline in the collector prompt (the plan's deliberate self-containment mitigation, citing the defect-log/log-defect.md precedent — `log-defect.md` confirmed present). This creates an implicit lockstep-update requirement: change the enum in one place and the two drift. The plan cites the precedent but does not explicitly state the lockstep obligation — that is the undocumented part of the contract.
- Coupling seam 2 — classification-axis overlap. The new "Failure mode" enum (Context/Mandate/Workflow/Authority/Validation/Autonomy/Safety/Traceability) layers a third classification scheme onto entries that already carry the free-text "Friction type" tag (rule/command/hook/process/config, `session-feedback-collector.md:43`) and that AP-9 already classifies (context/judgment/instruction/model-limitation). Three overlapping axes on the same entry risks writer confusion about which tag answers what, unless the relationship is stated. The plan's "relationship to existing fields" note covers Friction type vs Failure mode but does not address AP-9's axis.
- Discoverability gap (minor): the 8 project-level friction-logs receive new-format collector entries but will not carry the schema block. The inline-taxonomy mitigation compensates for the *collector* writer; a *hand-authored* substantive entry in a project log would have no local schema reference (only ai-resources carries the block). Acceptable — most project friction is collector-written — but a known gap.
- Not High: the contract is documented at both producer ends, the count-proxy and status parsers are verified unaffected, and the axis overlap is a deliberate, justifiable distinction (which-component vs why-it-failed) rather than two systems fighting over one concern.

### Dimension 6: Principle Alignment
**Risk:** Low

- **AP-9 (failure correction without failure classification) — actively served.** The change is precisely the fix for AP-9: it requires classifying *why* a failure occurred (the 8-category enum) plus a causal chain (Root cause → Prevention → Owner artifact), rather than stopping at "this failed." The collector edit reinforces this at the machine-writer end.
- **OP-12 (closure before detection) — served.** The `Owner artifact` field names what *should* close the gap and is explicitly wired alongside (not replacing) the `Resolved:` / `[FADING-GATE] verified` stamps that state it *has* closed. The change strengthens the closure chain rather than adding orphan detection.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction) — not triggered.** This formalizes an existing practice (the ad hoc "Friction type" tag) for existing consumers (hand-authors + the collector already write substantive entries; 4 status parsers already consume the log). It is licensed by real current consumers, not built for an absent Phase-2 one. It mirrors the sibling logs' precedent — confirmed `logs/improvement-log.md:3` already carries a `## Schema` section, making friction-log the outlier the change corrects.
- **DR-1 / DR-3 (placement) — correct home.** The schema lives in the log file it governs (mirroring improvement-log); the collector change lives in the canonical agent definition. Right tier, right home.
- **OP-5 (advisory vs enforcement) — no upgrade.** The collector remains advisory ("Nothing you produce blocks a commit or push", `session-feedback-collector.md:131`); the schema is a documentation/format requirement, not an enforcement gate.
- **DR-5 (CLAUDE.md holds cross-session rules only) — untouched.** The schema goes in a log, not any always-loaded CLAUDE.md.
- Principles-base (`projects/strategic-os/ai-strategy/principles-base.md`) was read and used to ground these IDs.

## Mitigations

- **Dimension 3 (blast radius):** Make the plan's verification a hard pre-commit gate — confirm `git diff logs/friction-log.md` is insertion-only (zero deletions), confirm `grep -c '^## Schema' logs/friction-log.md` returns exactly 1, and confirm the schema block introduces no `## Session` or `### Friction Events` header (so the three scanners and the collector count-proxy stay untouched). Also eyeball the extended collector bullet template to confirm it emits no bare `Resolved:` token that the 4 status parsers would read as closure.
- **Dimension 5 (hidden coupling — duplication lockstep):** Add a one-line lockstep note at BOTH the schema block and the collector's inline taxonomy stating that the 8-category enum is duplicated and must be edited in both places together (make the defect-log/log-defect precedent's implicit obligation explicit here).
- **Dimension 5 (hidden coupling — axis overlap):** In the schema block's "relationship to existing fields" note, state plainly how "Failure mode" (why it failed) differs from the retained "Friction type" tag (which component) and from AP-9's classification, so a writer knows these are distinct, non-competing axes rather than three tags for the same job.

## Recommended redesign

- (Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (`open-items.md:35`, `fix-repo-issues-scanner.md:34`, `diagnostics-scanner.md:59`, `reconcile-backlog.md:53/91`, `friday-checkup.md:235/316`, `improve.md:9`, `session-feedback-collector.md:3/5-11/43/48-56/81/131`, `improvement-log.md:3`), grep counts across `ai-resources` and the workspace root, verified count-proxy and parser markers (`^## Session` vs `## Schema`; `-` bullets under `### Friction Events`), verbatim quotes from CHANGE_DESCRIPTION and the plan file, and principle IDs cited from `projects/strategic-os/ai-strategy/principles-base.md` (AP-9, OP-12, OP-9, DR-7, AP-7, DR-1, DR-3, OP-5, DR-5, DR-10). One accuracy note: the sibling-schema precedent was confirmed for `logs/improvement-log.md` (`## Schema` at line 3); `logs/defect-log.md` did not return a `^## Schema` match on grep, so the "both siblings" framing holds firmly for improvement-log and is unconfirmed for defect-log — this does not change any risk level. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-friction-log-failure-mode-schema-second-opinion.md

**Concur with PROCEED-WITH-CAUTION.** Additive, going-forward-only, easily reversible (D4 Low correct), aligned with `AP-9` (the Failure→Root cause→Prevention→Owner chain *is* AP-9's classify-first structure) and `OP-12` (chain ends in a closure channel). Correctly not GO (real coupling + auto-sync fan-out) and not RECONSIDER (no conflict, nothing irreversible). Verdict is binding per `DR-8` — we affirm and add two conditions.

**Routing correction:** edit surface is **2 canonical files** (`ai-resources/logs/friction-log.md` + the collector), not 9. `auto-sync-shared.sh` symlinks one collector into all projects, so the "9 write-target logs" are append *destinations*, not edit targets. Right-sizes the report's blast-radius framing; D3 Medium (the fan-out) is right.

**Mitigations:**
- (b) Correct — enum duplication is a `risk-topology § 5` two-end contract, precedented by W2.4 (`repo-state § 2` #10); passes `DR-7` (inline copy is required, not speculative). **Strengthen:** make the ai-resources block the single canonical source, label the collector's copy a synced operational copy.
- (c) Correct and necessary — three overlapping tags is the `OP-3` silent-ambiguity trap; the note is the `OP-6` move. But it documents only one end (see MISSED-1).
- (a) Intent sound, instrument likely over-sized. **[AMBIGUOUS]:** a one-time diff check is fine and already covered by `/qc-pass` + the `DR-8` end-time gate; a *permanent* pre-commit hook to guard a one-time additive insert is disproportionate (`AP-7`/`AP-10`) and itself a `DR-8` hook edit. Put the one durable check (no bare `Resolved:` token) inside the collector, not a repo-wide gate.

**Risks the review missed:**
1. **AP-9 taxonomy fork (most important):** the new 8-category enum differs from AP-9's canonical 4 failure-types in `principles.md`; (c) documents the friction-log end but not the principles.md end — silent drift `OP-11`/`OP-3` forbid. Log an OP-11 divergence to reconcile at the next principles update.
2. **No post-fan-out verification:** all mitigations are pre-commit; none verify one real `/wrap-session` output before it auto-syncs everywhere (`QS-3`/`QS-9`).
3. **"Substantive entry" undefined** — inconsistent collector application; define it observably (`OP-6`, materiality bar).

**Position:** land it as a 2-file ai-resources edit; keep (b)/(c), run (a) one-time not permanent, add MISSED-1 and MISSED-2 as CAUTION conditions before closing.
