# Risk Check — 2026-06-08

## Change

Add a new "## Self-Check" section to the canonical skill ai-resources/skills/research-extract-creator/SKILL.md, via /improve-skill. The section is a producer-side pre-handoff validation checklist (candidate checks: source-faithfulness / no fabrication; claim-ID emission and format; coverage-verdict consistency across table↔Gaps↔Synthesis; extraction-metadata completeness; the #22 optional disconfirming-evidence field's no-flag handling). The change is ADDITIVE — a new section only, no edit to existing Inputs/Output/Extraction Logic/Failure Behavior/Scope Boundaries/Output Protocol sections. The skill is consumed by ≥4 research-workflow projects via reference/skills/* symlinks. Sibling pipeline skills (research-prompt-creator, execution-manifest-creator, evidence-to-report-writer) already carry a Self-Check section; this closes a Major gap flagged in the S5 /improve-skill Step-4 cold eval. Must avoid duplicating the independent downstream research-extract-verifier checks. Commit lands in ai-resources only (no project files change).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-extract-verifier/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/SKILL.md — exists

## Verdict

GO

**Summary:** An additive, advisory, producer-side Self-Check section in the canonical home, structurally identical to two confirmed sibling skills and consumed only via whole-file `Read` — no section-heading parser, no permission change, clean revert; all six dimensions Low.

## Consumer Inventory

Search terms: `research-extract-creator` (name token); `## Self-Check` / `Self-Check` (the section heading the change adds); the skill's section headings (`Inputs`, `Output`, `Extraction Logic`, `Failure Behavior`, `Scope Boundaries`, `Output Protocol`) as parse-marker candidates. Grep run across `ai-resources/` and the workspace root (`..`), excluding `audits/`, `logs/`, `reports/`, and `archive/` for the functional-consumer pass (those are historical/telemetry mentions, not runtime parsers).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/workflows/research-workflow/.claude/commands/run-execution.md | invokes (`Read` the whole SKILL.md and apply it — line 108) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-execution.md | invokes (project copy of run-execution) | no |
| projects/buy-side-service-plan/.claude/commands/run-execution.md | invokes (project copy of run-execution) | no |
| projects/research-pe-regime-shift-advisory-gap/reference/skills/research-extract-creator (symlink → ai-resources/skills/research-extract-creator) | imports (live symlink — the skill IS the target) | no |
| ai-resources/skills/research-extract-verifier/SKILL.md | documents (names the producer as Step 2.3; downstream verifier — independent checks) | no |
| ai-resources/skills/research-prompt-creator/SKILL.md | documents (names extract-creator as the consumer of its directive IDs / #22 field) | no |
| ai-resources/skills/execution-manifest-creator/SKILL.md | documents (names extract-creator as the downstream extraction step) | no |
| ai-resources/skills/cluster-memo-refiner/SKILL.md | documents (downstream consumer of extract tags/conflict-log; not a section-heading parser) | no |
| ai-resources/skills/claim-permission-gate/SKILL.md | documents (consumes extract tags) | no |
| ai-resources/skills/supplementary-evidence-merger/SKILL.md | documents (names extract-creator in pipeline) | no |
| ai-resources/skills/source-class-mapper/SKILL.md | documents (pipeline reference) | no |
| ai-resources/skills/knowledge-file-producer/SKILL.md | documents (pipeline reference) | no |
| ai-resources/skills/workflow-system-analyzer/SKILL.md | documents (analyzer references skill set) | no |
| ai-resources/skills/CATALOG.md | documents (registry entry) | no |

Total: 14 distinct consumers, 0 must-change.

**Key blast-radius fact established by the inventory:** no consumer parses this skill's *section structure*. The invocation contract (run-execution.md line 108: "Read the `research-extract-creator` skill … and apply it") loads the whole file; sections are read by the model, not matched by a heading parser. A grep for any consumer keying on this skill's section headings (`Extraction Logic`, `Output Protocol`, etc.) returned only the skills' *own* internal headings, not cross-skill parsers. Adding a `## Self-Check` heading therefore introduces no new parse target for any consumer.

**Symlink note (correcting the CHANGE_DESCRIPTION).** The description states "≥4 research-workflow projects" consume the skill via `reference/skills/*` symlinks. On disk *today* exactly one live symlink resolves to this skill: `projects/research-pe-regime-shift-advisory-gap/reference/skills/research-extract-creator`. Other historical consumers live under `archive/nordic-pe-macro-landscape-H1-2026/` (archived) and the workflow template under `workflows/research-workflow/`. The ≥4 figure is the *intended deployment fan-out of the workflow template*, not the current live-symlink count. This does not change the risk (additive, symlink resolves to the same file), but the live count is 1, not ≥4 — noted for accuracy.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The change adds content only to `skills/research-extract-creator/SKILL.md`, which is **not** an always-loaded file. It is loaded on demand by `run-execution.md` only when Step 2.3 of Stage 2 actually runs (evidence: run-execution.md line 108 reads the skill at that step, not at SessionStart). Cost is pay-as-used, not per-session or per-turn.
- No hook is registered, no `@import` chain is added, no always-loaded CLAUDE.md is touched. The skill's `description` frontmatter (the only part that loads broadly, for skill-trigger matching) is explicitly out of scope — the change is "a new section only" (CHANGE_DESCRIPTION).
- Marginal cost is the section's own token weight, paid once per extraction session. Sibling `research-prompt-creator`'s Self-Check is ~25 checklist lines (SKILL.md lines 221–246); a comparable section here is a one-time per-session read, not recurring background load.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. The change is "Commit lands in ai-resources only (no project files change)" and edits one SKILL.md (CHANGE_DESCRIPTION). No `allow`/`ask`/`deny` entry is added, removed, or narrowed.
- A Self-Check is an in-model verification checklist the skill runs before handoff — it introduces no new tool invocation pattern, no Bash command, no Write path, no external API, no cross-repo write. It reads the artifact the skill already produced and re-checks it.
- No scope escalation (project → user) and no new capability of any kind.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Step 1.5 inventory: **14 consumers, 0 must-change.** Every consumer either invokes the skill by whole-file `Read` (the three `run-execution.md` copies + the live symlink) or merely names it in prose/registry (the rest). None must be modified for the change to work.
- No contract change. The inventory's `parses` column is empty — no consumer depends on a marker, heading, schema, or output-shape that this change touches. The skill's *output contract* (claim IDs, evidence tags `IN-LENS`/`PROXY-DOWNGRADE`/`NO-EVIDENCE`, freshness classes, coverage verdicts, conflict-log entries) is unchanged; a Self-Check verifies conformance to that contract, it does not alter it.
- Additive-only: the change adds a section and edits none of `Inputs/Output/Extraction Logic/Failure Behavior/Scope Boundaries/Output Protocol` (CHANGE_DESCRIPTION). The one existing `Self-Check` string in the file is the inline note at line 172 ("not subject to any Self-Check") about the #22 disconfirming-evidence field — the new section must honor that carve-out (see Dimension 5), but no consumer is affected by the section's addition.
- No unanticipated consumer surfaced: the inventory found nothing the CHANGE_DESCRIPTION did not already anticipate (sibling skills, verifier, run-execution). The only correction is the symlink-count overstatement (1 live, not ≥4) — which *reduces* blast radius, not increases it.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file additive edit. `git revert` (or removing the section) fully restores prior state within the same working tree — no sibling files or directories are created. CHANGE_DESCRIPTION: "a new section only … Commit lands in ai-resources only."
- No data/log mutation that revert leaves stale: the change does not append to `innovation-registry.md`, `improvement-log.md`, or any append-only log as part of the structural edit (any session-note logging is separate clerical work, outside this change's revert surface).
- No state propagates beyond git: no push is part of the change (push is gated to wrap), no Notion/external write, no automation (hook/cron/symlink) is added that could fire between landing and revert. The existing symlink already points at the file; reverting the file content needs no symlink cleanup.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The Self-Check's checks re-state invariants already defined *in this same file*, so its contract is documented at the change site — the low-coupling case. Candidate checks map to existing rules: claim-ID format (lines 44–46), coverage-verdict consistency across table↔Gaps↔Synthesis (the "Label correction discipline" at lines 126–127 already names this exact tri-location invariant), extraction-metadata completeness, source-faithfulness/no-fabrication (Failure Behavior lines 176–181, Scope Boundaries line 185). The Self-Check enforces what the skill already promises; it does not invent a new contract callers must honor.
- **One coupling to honor, already self-documented:** the #22 optional disconfirming-evidence field carries an explicit carve-out — line 172: "It is not a coverage input, not a conflict input, and **not subject to any Self-Check**." CHANGE_DESCRIPTION correctly lists the #22 field's "no-flag handling" as a candidate check, i.e. the Self-Check must verify that absence is *not* flagged. As long as the new section checks "if the field is absent, the line is correctly omitted and no gap/flag/downgrade was raised" (rather than checking "the field is present"), it is consistent with line 172. This is an intra-file coupling the change author can see directly — Low, not a hidden one. (Flagged here so the /improve-skill draft and its /qc-pass honor the carve-out wording.)
- **No overlap with the downstream verifier.** CHANGE_DESCRIPTION requires avoiding duplication of `research-extract-verifier`. The verifier is *adversarial verification against the raw report* — Check 1 missed claims, Check 2 distortions, Check 3 strength signals, Checks 4–7 coverage/synthesis/stop-condition/source-surface (verifier SKILL.md lines 58–164), run at Step 2.4 with fresh context and the raw report in hand. The producer Self-Check is *internal-consistency-at-handoff* (does the extract I just wrote satisfy my own format/consistency rules) without re-reading the raw report adversarially. These are distinct concerns (self-consistency vs. independent against-source verification); the boundary is the same producer-vs-independent-QC split that QS-1 mandates. The two systems are not both trying to handle the same concern — no functional overlap.
- No silent auto-firing in an unexpected context: the Self-Check runs at the skill's own pre-handoff step (the sibling pattern — research-prompt-creator runs it at "Step 4: Run Self-Check," lines 203–205), within the session that invoked the skill. No cross-session side effect, no hook ordering.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present). Relevant IDs cited from it.

- **OP-12 (closure before detection) — served, not violated.** The change does not add a *new detection capability ahead of a closure channel*. It is producer-side closure: the skill validating its own output before handoff. It also closes a *known, recorded* gap — the S5 `/improve-skill` Step-4 cold eval flagged the missing Self-Check as **Major** (session-notes line 451; session-plan-S7 line 19). Closing a recorded Major gap and consolidating to the sibling pattern is the OP-12-favored direction.
- **DR-7 / AP-7 / OP-9 (generalize only on a second confirmed consumer; no speculative abstraction) — satisfied.** This is not speculative: two sibling skills already carry a Self-Check (`research-prompt-creator` lines 219–247; `execution-manifest-creator` lines 141–154), establishing the confirmed pattern. The new section adds *zero* new contract with zero consumers — it re-checks invariants that already exist and are already consumed. No "hook for Phase 2," no abstraction built for an absent consumer. AP-7 does not fire.
- **OP-5 (advisory vs. enforcement) — stays advisory.** The Self-Check advises-and-stops at the skill's own handoff (the sibling does: "verify every item … Fix any failures before presenting to the operator" — research-prompt-creator line 205). It does not grant new enforcement authority over downstream stages, and it does not auto-act beyond the skill's existing produce-then-self-verify loop. No silent enforcement upgrade.
- **DR-1 / DR-3 (placement / component home) — correct.** The edit lands in the canonical skill home (`ai-resources/skills/…/SKILL.md`), the fixed home for skill methodology per DR-3, and explicitly *not* in any project CLAUDE.md (which the workspace CLAUDE.md § CLAUDE.md Scoping forbids for skill methodology). Right tier, right home.
- **OP-10 (system boundary) — untouched.** The change is internal to a Claude-Code skill; it does not extend the system to govern GPT/Perplexity/NotebookLM behavior.
- No principle is revised, so OP-11/OP-3 (loud-revision) is not engaged — nothing to surface.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts from the Step 1.5 inventory, verbatim quotes from CHANGE_DESCRIPTION and the referenced SKILL.md files, and principle IDs read from `principles-base.md`). No training-data fallback was used on fetch/read failures.
