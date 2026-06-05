# Risk Check — 2026-06-05

## Change

Stage 4 session-harness date-qualify rename: prime.md (Steps 8a/8b/8c write sites), session-plan.md (Step 0 existence check + Step 7 write target), session-marker.md (filename table + tracking policy glob), contract-check.md (plan source resolution), drift-check.md (plan path references). Change: session-plan filename pattern changes from `logs/session-plan-${MARKER}.md` to `logs/session-plan-${TODAY}-${MARKER}.md` at all writer sites; read-only consumers (contract-check, drift-check) updated to use glob `logs/session-plan-*${MARKER}.md` for backward compatibility with old bare-marker files.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A backwards-compatible filename-convention change across 5 already-aligned writer/reader files; low intrinsic risk, but the blast radius extends to several un-updated doc-reference and consumer sites that still show the bare-marker form, which must be reconciled or the contract registry will drift.

## Consumer Inventory

Search terms: basenames `prime.md`, `session-plan.md`, `session-marker.md`, `contract-check.md`, `drift-check.md`; contract markers `session-plan-${MARKER}`, `session-plan-${TODAY}-${MARKER}`, `session-plan-*.md` (glob), `session-plan-*${MARKER}.md` (glob), `session-plan-{marker}`. Grep run across `ai-resources/` and the workspace root one level up. Archive/data/log files (session-notes, scratchpads, prior risk-checks, audit reports) excluded — they record history, not the live contract.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` | invokes (writes plan path at 8a.3.c / 8b.3.c / 8c.8; operator-facing strings at 8a.3.d) | yes — writer site (already shows `${TODAY}-${MARKER}` in read) |
| `ai-resources/.claude/commands/session-plan.md` | invokes (Step 0 existence check, Step 7 write target) | yes — writer site (already shows `${TODAY}-${MARKER}` in read) |
| `ai-resources/docs/session-marker.md` | documents (filename table line 112–113, tracking-policy glob line 119, contract registry) | yes — canonical contract doc (already shows date-qualified form) |
| `ai-resources/.claude/commands/contract-check.md` | parses (Step 2b plan source via glob `logs/session-plan-*${MARKER}.md`) | yes — reader (already shows the back-compat glob, line 52) |
| `ai-resources/.claude/commands/drift-check.md` | parses (Step 1/Step 6 plan locate via glob `logs/session-plan-*${MARKER}.md`) | yes — reader (already shows the back-compat glob, lines 18, 28) |
| `ai-resources/.claude/commands/open-items.md` | parses (glob `logs/session-plan-*.md`, lines 41, 83) | no — bare `-*` glob already matches date-qualified names; display string at line 68 shows `{marker}` (cosmetic) |
| `ai-resources/.claude/commands/decide.md` | parses (glob `logs/session-plan-*.md`, line 29) | no — bare `-*` glob already matches |
| `ai-resources/.claude/agents/fix-repo-issues-scanner.md` | parses (glob `logs/session-plan-*.md`, lines 40, 84, 93, 195) | no — bare `-*` glob already matches |
| `ai-resources/.claude/hooks/backup-session-plan.sh` (+ project copies) | parses (regex `logs/session-plan(-[a-zA-Z0-9]+){0,2}\.md$`, line 20) | yes (verify) — date-qualified name has TWO `-segment` groups (`-YYYY-MM-DD` counts via hyphen splits); regex `{0,2}` may not match `session-plan-2026-06-05-S1.md` |
| `ai-resources/docs/repo-architecture.md` | documents (file table lines 221–222 show `session-plan-{marker}.md`) | yes (doc consistency) — bare-marker form, not date-qualified |
| `ai-resources/docs/compaction-protocol.md` | documents (line 21 `logs/session-plan-${MARKER}.md`) | yes (doc consistency) — bare-marker form |
| `ai-resources/docs/weekly-cadence.md` | documents (line 78 `logs/session-plan-{marker}.md`) | yes (doc consistency) — bare-marker form |
| `ai-resources/.claude/commands/new-project.md` | documents (line 544 `logs/session-plan-{marker}.md`) | yes (doc consistency) — scaffolding reference |
| `ai-resources/docs/heavy-read-discipline.md` | documents (narrative reference per session-marker.md registry) | verify — registry lists it; no live grep hit on the pattern |

Total: 14 distinct consumers; 7 must-change (5 referenced writer/reader files already aligned + 2 that need verification/update: `backup-session-plan.sh` regex and the 4 doc-consistency sites grouped). For the proposed contract, the 5 referenced files already carry the date-qualified form on disk — the change appears partly or fully landed in those files; the residual must-change set is the consumers NOT in the referenced list (the hook regex and the doc-reference sites).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. The 5 referenced files are commands and a doc loaded on demand, not per-turn. `prime.md` frontmatter is `model: sonnet` (line 2); `session-plan.md` is `model: opus` (line 1) — invoked per session, not per turn.
- No new hook registered, no `@import` added, no subagent brief expanded. The change is a string-pattern rename inside existing command bodies — net token delta is ~0 (a date segment added to a filename literal).
- No skill trigger keywords affected.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edit, no `allow`/`ask`/`deny` change. `contract-check.md` `allowed-tools` line (`Bash(git *), Read, Task`, line 5) is unchanged by a filename-pattern rename.
- The writers already write under `logs/` — no new write path is introduced; `logs/session-plan-2026-06-05-S1.md` is the same directory as `logs/session-plan-S1.md`.
- No cross-repo or external capability introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory: 14 consumers, 7 must-change. The 5 referenced files already carry the date-qualified form on disk (verified by Read: prime.md lines 210/212, session-plan.md lines 7/17/162, session-marker.md lines 112/119, contract-check.md line 52, drift-check.md lines 18/28) — so the core writer/reader contract is internally consistent.
- **Contract change is backwards-compatible by design.** The read-only globs (`open-items.md` line 41, `decide.md` line 29, `fix-repo-issues-scanner.md` line 40) use bare `logs/session-plan-*.md`, which matches BOTH `session-plan-S1.md` and `session-plan-2026-06-05-S1.md`. The reader globs in contract-check/drift-check use `logs/session-plan-*${MARKER}.md`, which also matches both forms (verified lines). No reader breaks on the new names; old bare-marker files (`logs/session-plan-S2.md`, `-S7.md` present on disk) remain readable.
- **Blast-radius finding not fully anticipated by the description:** the description names 5 files, but the contract registry in `session-marker.md` (lines 142–153) lists doc-reference sites that still carry the bare-marker form and were NOT in the referenced set: `repo-architecture.md` lines 221–222 (`session-plan-{marker}.md`), `compaction-protocol.md` line 21, `weekly-cadence.md` line 78, `new-project.md` line 544. These are narrative/scaffolding references, not runtime parsers — no behavior breaks — but `session-marker.md` line 153 mandates "If you rename ... change the file-naming scheme, update each of these too." Leaving them stale is documented drift against the registry's own rule.
- **One runtime consumer needs verification:** `backup-session-plan.sh` line 20 regex `(^|/)logs/session-plan(-[a-zA-Z0-9]+){0,2}\.md$`. A date-qualified name `session-plan-2026-06-05-S1.md` splits into segments `-2026`, `-06`, `-05`, `-S1` if the regex treats hyphen-delimited groups — `{0,2}` caps at two `-segment` groups and would NOT match four. This is a project-local PreToolUse Write hook; if it silently fails to match, plan backups stop for date-qualified plans (silent, since the hook `exit 0`s on non-match). This is the highest-stakes item in the blast radius.

### Dimension 4: Reversibility
**Risk:** Medium

- The command/doc edits are single-file text edits that `git revert` restores cleanly.
- **Data residue:** running `/session-plan` after the change creates new on-disk files named `logs/session-plan-${TODAY}-${MARKER}.md`. These are git-tracked (`session-marker.md` line 119: "tracked in git ... Not gitignored"). A `git revert` of the command edits does NOT remove plan files created by post-revert runs of the command — same residue pattern documented in the prior atomic-phase-2-3 risk-check (`audits/risk-checks/2026-05-29-...-atomic-phase-2-3.md` line 63: "must manually `rm logs/session-plan-S*.md`"). Rollback here requires one extra cleanup step: `rm logs/session-plan-YYYY-MM-DD-S*.md` for any new-form files written before revert.
- No push beyond git, no external write, no automation that fires between landing and revert (the change adds no hook).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Glob-shape coupling (silent).** Every read-only consumer silently depends on `session-plan-*` prefix-glob semantics continuing to match the new date-qualified names. This holds for `*.md` and `*${MARKER}.md` globs (the date sits between `session-plan-` and `-${MARKER}`, so both bracket the inserted segment). The coupling is real but the contract IS documented at the change site (`session-marker.md` § File naming table + tracking policy line 119 explicitly names both forms). Per the rubric this is "one new contract documented at the change site" — Medium, not High.
- **Hook-regex coupling (silent, undocumented at the rename site).** `backup-session-plan.sh` parses the plan filename with a hand-rolled regex whose `{0,2}` segment cap is an implicit assumption that the filename has at most two hyphen-suffix groups. The date-qualify rename violates that assumption and the rename description does not mention the hook. The hook is listed in `session-marker.md` line 149 as "Behavior already marker-aware via regex" — that line asserts compatibility the date-qualified form may break. This is the one genuinely hidden, undocumented coupling.
- No functional overlap with a second mechanism; no silent auto-firing in a new context.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read successfully (`projects/strategic-os/ai-strategy/principles-base.md`).
- **OP-12 (closure before detection):** the change closes a recurring real defect, not new detection. `audits/friday-checkup-2026-06-05.md` line 29 records "`session-plan-S{n}.md` filename omits the date → cross-day marker reuse collides (seen 3×)". Fixing a 3×-observed collision is consolidation/closure — counts FOR the change.
- **DR-7 / AP-7 / OP-9 (no speculative abstraction):** the change is specific to a confirmed, repeatedly-observed failure; it adds no hook or generalization for an absent consumer. The back-compat glob serves existing bare-marker files already on disk (`logs/session-plan-S2.md`, `-S7.md`), a present consumer — not a speculative one. Aligned.
- **OP-5 (advisory vs enforcement):** no advisory→enforcement upgrade; contract-check/drift-check remain advisory.
- **DR-3 (placement):** files stay in their canonical homes; no tier move.
- **OP-11:** no principle is being revised; nothing to announce.

## Mitigations

- **Dimension 3 / Dimension 5 (hook regex — highest stakes):** Before landing, test `backup-session-plan.sh` line 20 regex against a date-qualified name. Run `echo "logs/session-plan-2026-06-05-S1.md" | grep -qE '(^|/)logs/session-plan(-[a-zA-Z0-9]+){0,2}\.md$' && echo MATCH || echo NOMATCH`. If NOMATCH, widen the cap (e.g. `{0,4}` or anchor on `-S[0-9]`) in the canonical hook and the project copies (`projects/research-pe-regime-shift-advisory-gap/.claude/hooks/backup-session-plan.sh` and any other project copies surfaced by grep), then update the hook header comment and `session-marker.md` line 149.
- **Dimension 3 (doc-consistency drift):** Update the four bare-marker doc-reference sites to the date-qualified form (or to a form-agnostic phrasing): `repo-architecture.md` lines 221–222, `compaction-protocol.md` line 21, `weekly-cadence.md` line 78, `new-project.md` line 544 — and the `open-items.md` line 68 display string. `session-marker.md` line 153 already mandates this on any rename; satisfying it keeps the contract registry self-consistent.
- **Dimension 4 (reversibility):** Record the rollback recipe in the commit message: `git revert <hash>; rm -f logs/session-plan-20*-S*.md` (new-form files only — leave bare-marker files intact). One extra cleanup step beyond the revert.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from the 5 referenced files and the grep'd consumer set, verbatim quotes (`session-marker.md` lines 119/149/153, `backup-session-plan.sh` line 20 regex, `friday-checkup-2026-06-05.md` line 29), and principle IDs from `principles-base.md` (OP-12, DR-7/AP-7/OP-9, OP-5, DR-3, OP-11). No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Q1 — Concur with PROCEED-WITH-CAUTION?** Partially. The label holds *only if mitigation 1 (hook regex fix) is treated as blocking, not advisory*. The matcher caps at `(-[a-zA-Z0-9]+){0,2}`. The new name `session-plan-2026-06-05-S3.md` has **four** segments after `session-plan`. This is not "may not match" — it is a **deterministic NOMATCH**. Left unwidened, the hook silently stops backing up every date-qualified plan. That is a silent failure of a recovery mechanism — a direct OP-3 violation. If mitigation 1 is optional in execution, the correct verdict is RECONSIDER-until-fixed.

**Q2 — Is "apply mitigations then proceed" right?** Yes, with one correction: the mitigations are not equal-weight. The fix is also bigger than the verdict implies — the date adds 3 segments + marker + optional `pass2`, so the cap must go to `{0,5}`+, not a `+1` bump. Sequence: (1, blocking) Fix regex to `{0,5}+`, rewrite hook header comment, update `session-marker.md` line 149 — validate by running the shell; (2, blocking, same window) Land the 5 writer/reader edits; (3, non-blocking) Reconcile the 4 doc sites + `open-items.md`.

**Q3 — Risks the review missed:**
- **Canonical-writer / project-local-hook split.** The writer changes are in canonical commands that auto-sync to every project; the backup hook is project-local. Any other project with a copy of the hook inherits the same silent NOMATCH. Bounded next step: grep all projects' hook dirs for backup-session-plan variants before declaring blast radius bounded. [CITATION NEEDED — not scanned in this consultation.]
- **Hook header comment is itself a two-end contract** (documents the old "one/two segment" rationale). Rewrite it in the same edit or the next maintainer re-narrows the cap.
- Minor: confirm `contract-check`/`drift-check` glob handles multi-hit (`S3` vs `S3-pass2`) correctly.

**Position:** The right answer is to treat the regex fix as a blocking prerequisite (to `{0,5}+`, execution-tested), land writer/reader edits in the same window, then reconcile docs. With that sequencing PROCEED-WITH-CAUTION holds. Without it, the change ships a silently-disabled backup hook (OP-3 violation).
