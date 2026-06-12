# Risk Check — 2026-06-12

## Change

Extend /wrap-session Step 6.4 outcome-check subagent brief with a Session Value Audit (A–E session-type classification, 0–10 value score, maintenance-justification gate, opportunity-cost judgment, repeat/redesign/stop decision, optional rule candidate) — canonical ai-resources/.claude/commands/wrap-session.md plus identical port to the workspace-root non-symlink mirror /.claude/commands/wrap-session.md (PAIRED CONTRACT). New `### Session Value Audit — 80/20 Review` block in the session-note schema (after `### Outcome`, before `### Risky actions`). Add an all-tier inline `## Weekly Session Value Review` section to friday-checkup.md Step 6/7 (reads the week's audit blocks from each scope's logs/session-notes.md; no subagent), plus a small input-source addition in friday-act.md so non-empty constrain/stop/rule lines surface as triage candidates. No new agent, no new step, no new log file, no schema fields, no extra subagent launch; audit is strictly advisory (never blocks commit/push). SO advisory endorsed (consult-2026-06-12-session-value-audit-wrap-session.md). Plan: /Users/patrik.lindeberg/.claude/plans/investigate-this-idea-swirling-ripple.md

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists (workspace-root non-symlink mirror)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/.claude/plans/investigate-this-idea-swirling-ripple.md — exists (plan file, read for full design detail)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Brief-text edits to four prose commands with no permission/auto-firing change and full advisory posture, but the blast radius is wide (17 project symlinks auto-inherit the canonical wrap edit; a parsed heading is inserted into the `/friday-checkup` → `/friday-act` data contract; two non-symlink wrap copies must stay byte-aligned), so the parse-regression check and mirror-sync must be applied as paired mitigations before commit.

## Consumer Inventory

Search terms: basenames `wrap-session.md` / `friday-checkup.md` / `friday-act.md`; contract markers `### Session Value Audit — 80/20 Review` (new session-note heading), `## Weekly Session Value Review` (new friday-checkup report heading), `### Outcome` / `### Risky actions` (the existing block ordering the new block is inserted between), Step 6.4 outcome-check brief, the `/friday-checkup` → `/friday-act` section-heading parse contract.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/commands/wrap-session.md | co-edits (canonical target — Step 6.4 brief + Step 4 schema bullet) | yes |
| /.claude/commands/wrap-session.md (workspace-root, non-symlink mirror) | co-edits (PAIRED CONTRACT Step 4.4 + Step 2b schema list) | yes |
| ai-resources/.claude/commands/friday-checkup.md | co-edits (canonical target — new `## Weekly Session Value Review` roll-up + Step 7 section-presence contract line) | yes |
| ai-resources/.claude/commands/friday-act.md | co-edits (canonical target — input-source addition consuming the roll-up) | yes |
| ai-resources/.claude/agents/session-feedback-collector.md | parses (reads `### Risky actions` and other `### ` headings of today's session-note block by name — line 33, 44) | no (heading-addressable; tolerant of a new sibling block) |
| 17 project/harness/kb symlinks → canonical wrap-session.md (buy-side-service-plan, nordic-pe-screening-project, marketing-positioning, project-planning, strategic-os, research-pe-regime-shift, obsidian-pe-kb, repo-documentation, interpersonal-communication, axcion-ai-system-owner, ai-development-lab, global-macro-analysis, corporate-identity, axcion-brand-book, harness, pe-kb-vault, archive/nordic-pe-macro-landscape) | imports (symlink — auto-inherit canonical edit) | no (auto-propagate; no per-symlink edit) |
| ~36 project/harness/kb symlinks → canonical friday-checkup.md + friday-act.md | imports (symlink — auto-inherit canonical edit) | no (auto-propagate) |
| projects/positioning-research/.claude/commands/wrap-session.md (non-symlink, 33-line legacy copy, NO Step 6.4) | documents (a divergent wrap copy that does not carry Step 6.4 at all) | no (out of PAIRED CONTRACT scope — has no outcome check to extend) |
| ai-resources/workflows/research-workflow/.claude/commands/wrap-session.md (non-symlink, 33-line legacy copy, NO Step 6.4) | documents (divergent wrap copy without Step 6.4) | no (out of scope — no outcome check) |
| projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-session-value-audit-wrap-session.md | documents (SO advisory endorsing the change; names both new headings) | no |

Total: ~58 consumers (4 must-change canonical/mirror targets; ~53 symlinks auto-inheriting; 2 divergent legacy wrap copies out of scope; 1 advisory + 1 parser tolerant). 4 must-change. The two non-symlink legacy wrap copies (positioning-research, research-workflow) are a latent fork-drift footnote, not a target — they pre-date Step 6.4 and are not part of the canonical↔workspace-root PAIRED CONTRACT.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The edits are to four command `.md` files, each loaded only when its slash command runs — pay-as-used. No `@import`, no CLAUDE.md edit (verified: change description and plan §66 list "no coaching-data.md schema change, no extra preflight question").
- No new subagent launch. The Session Value Audit extends the *existing* Step 6.4 fresh-context subagent's inline brief; plan §7/§24 — "one subagent, one launch, no new step, no new agent file." The subagent's return cap rises from ≤20 to ≤30 lines (wrap-session.md Step 6.4 line 375 currently caps ≤20; plan §27) — a ~10-line / few-hundred-token marginal increase, and only when the operator opts into preflight bundle 2 and the session is non-trivial (gated, wrap-session.md line 364).
- The new `## Weekly Session Value Review` roll-up in friday-checkup.md adds cheap awk/grep reads of session-note blocks "no subagent" (plan §54) — runs once per Friday, not per session/turn.
- Net ongoing cost: a bounded per-wrap increment behind two existing gates (preflight + trivial-skip), plus a once-weekly grep. Well under the Medium threshold (no always-loaded tokens; no per-session/per-tool hook).

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json edit, no `allow`/`ask`/`deny` change, no new tool family. The subagent already has "explicit permission to inspect the actual changed files and today's git log" (wrap-session.md Step 6.4 line 373); the audit reuses that exact evidence channel (plan §38 — "the subagent already inspects changed files + today's git log … no duplicate evidence block").
- friday-checkup roll-up uses grep/awk over `logs/session-notes.md` paths already within the command's read scope (the command already reads session-notes for `/coach` volume counts, friday-checkup.md §C line 147).
- No cross-repo write, no external API, no MCP. No scope escalation.

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (Step 1.5): 4 must-change canonical/mirror targets, ~53 symlinks auto-inheriting the canonical edits. The symlink fan-out is benign (no per-symlink edit), but it means the canonical wrap edit goes live in all 17 wrap-consuming contexts and the friday edits in ~18 contexts the moment they land — there is no staged rollout.
- **Parsed-heading contract touched (the load-bearing risk).** `/friday-act` Step 2 (friday-act.md lines 110–114) parses `/friday-checkup` report sections by *exact heading match* — `## Tactical follow-ups`, `## Policy-level observations`, `## Architectural retrospective` — and aborts on a tier-required section mismatch (line 114: "Schema mismatch is a structural error"). The change inserts a new `## Weekly Session Value Review` heading into that report (plan §57, placed after `## Per-scope summary`, before `## Tactical follow-ups`). The `parses` row for friday-act.md is the must-verify edge: the SO advisory (consult line 22) explicitly re-flags this as "the exact failure mode risk-topology § 5 warns about" and requires a parse-regression check, not the placement assertion alone.
- **Paired-contract co-edit (lockstep risk).** The canonical wrap-session.md and the workspace-root non-symlink mirror must carry byte-identical audit-brief text (the files already declare PAIRED CONTRACT — canonical lines 43–48, 360–361, 389–392; mirror lines 22–28, 343–345, 371–373). A drift between the two copies is a silent divergence the existing MIRROR NOTE comments exist to prevent.
- **Session-note block parser is tolerant** (the one piece of good news in this dimension): `session-feedback-collector.md` reads `### Risky actions` by name (line 33) and explicitly handles a missing line gracefully (line 44 — "If the note has no `### Risky actions` line … treat it as None"). Inserting a new `### Session Value Audit — 80/20 Review` sibling block *before* `### Risky actions` is heading-addressable and does not reorder anything the collector positionally depends on. This consumer is `must-change? = no`.
- friday-act.md gains a new input source (plan §64) so the roll-up's constrain/stop/rule lines surface as triage candidates — a real edit to a second command, increasing the touched-command count to 4 distinct must-change files in two coupled subsystems (wrap + Friday cadence).
- Grounded count: 4 must-change, parsed-contract heading inserted, two coupled subsystems, ~53 auto-inheriting symlinks → exceeds the Medium ceiling (a contract change that is only *asserted* backwards-compatible, plus >5 dependent consumers). High.

### Dimension 4: Reversibility
**Risk:** Low

- All four edits are prose edits to version-controlled command files; `git revert` restores prior text fully. No new sibling file or directory is created (plan §66 — "no new log file, no new agent file"), so revert leaves no orphan.
- No data/log mutation is part of the change itself. The audit *writes* an `### Session Value Audit` block into `logs/session-notes.md` at each future wrap, but that is append-only session output, not part of this structural change — reverting the command stops future writes and leaves already-written blocks as inert prose (harmless, heading-addressable, ignored by the tolerant collector).
- The symlinks need no teardown — reverting the canonical file reverts every symlink view simultaneously.
- One latent cleanup beyond git: nothing. No settings cache, no external push, no automation that fires between land and revert. Clean single-tree revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **New cross-command contract, but documented at both ends.** The roll-up→friday-act consumption path (plan §64) creates a dependency: friday-checkup writes `## Weekly Session Value Review` with constrain/stop/rule lines, and friday-act reads them. This is a new contract — but the plan requires documenting the new section in friday-checkup Step 7's section-presence data contract (plan §63) and friday-act already has a documented schema-contract callout for cross-command heading parsing (friday-act.md line 106 — "Do not rename them in either command without updating both ends"). Contract documented at the change site → Medium, not High.
- **Implicit dependency on the heading-parse order being additive-safe.** The change *assumes* inserting a heading between `## Per-scope summary` and `## Tactical follow-ups` does not shadow or reorder the three headings friday-act parses verbatim. That assumption is the coupling — it is only safe if friday-act parses by exact-heading-match anywhere in the report (it does, per lines 110–114) rather than by positional sequence. The assumption holds on inspection but is silent until the parse-regression check confirms it; this is the implicit dependency that earns the Medium rather than Low.
- **No functional overlap / no silent auto-firing.** The audit does not duplicate `/usage-analysis` (token telemetry), `/coach` (cross-session patterns), or Step 6.5 (improvement filing) — the plan adds an explicit scope-boundary clause excluding all three (plan §40). It does not auto-fire any downstream command; the roll-up surfaces candidates for operator disposition, not auto-action. No second mechanism contends for the same concern.
- The two divergent 33-line legacy wrap copies (positioning-research, research-workflow) are a pre-existing fork, not coupling this change introduces — but they are a reminder that "wrap-session.md" is not a single source of truth across the repo; this change correctly scopes to the two Step-6.4-bearing copies only.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable; checks applied against frozen IDs.
- **OP-12 (closure before detection) — actively served, the strongest alignment signal.** The audit is a new detection capability (classifies session worth, flags low-yield patterns), and the change ships it *behind a working closure channel* — the SO advisory's condition 2 (consult line 30) and the plan's Change 3 §64 require the roll-up to feed `/friday-act` disposition, not just compose and ignore. A detection-without-closure design would count against the change under OP-12; this one closes the loop. Aligned.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — not triggered.** The new `## Weekly Session Value Review` contract has a confirmed consumer at landing (friday-act, wired in the same change) — it is not a "hook for Phase 2" with zero current consumers. The plan explicitly forbids generalization (§66 — "no scoring engine, no dashboard, no structured field index"). Aligned.
- **OP-5 (advisory vs enforcement) — preserved, not upgraded.** The audit is "strictly advisory (never blocks commit/push)" — restated as a hard constraint in the brief (plan §9 condition 3; SO consult). No advisory→enforcement drift; a SCORE never gates. Aligned.
- **OP-2 / AP-4 — no judgment automated that should stay gated, no rubber-stamp re-introduced.** The audit *grades* and surfaces; operator disposition stays at `/friday-act`. Aligned.
- **DR-1 / DR-3 (placement) — correct homes.** Edits land in canonical `ai-resources/.claude/commands/` (the canonical command tier), the workspace-root mirror is an already-sanctioned non-symlink tier copy, and the session-note block lives in the wrap-owned `logs/session-notes.md` (SO consult line 44 — "session-notes.md is /wrap-session-owned … append operations are a zero-risk zone"). No new tier, no misplacement. Aligned.
- No principle is revised, so OP-11/OP-3 loud-revision obligation does not arise. No Dimension-6 tension.

## Mitigations

- **Dimension 3 (Blast Radius) — parse-regression check before commit (SO condition 1, required).** Before committing the friday-checkup edit, read `/friday-act` Step 2's actual section-parse logic (friday-act.md lines 110–114) and confirm the inserted `## Weekly Session Value Review` heading neither shadows, reorders, nor is mistaken for any of the three verbatim-parsed headings (`## Tactical follow-ups`, `## Policy-level observations`, `## Architectural retrospective`). Verify by exact-heading-match semantics, not by the placement assertion alone (plan verification step 4; SO consult line 22). If the new heading collides with or precedes a tier-required section in a way the parser mishandles, relocate it (e.g., after `## All reports generated`) or gate it out of the parsed region before landing.
- **Dimension 3 (Blast Radius) — mirror byte-sync check before commit.** After editing both wrap-session copies, grep both canonical and workspace-root files for the new labeled brief lines (`TYPE:`, `VALUE:`, `SCORE:`, `GATE:`, `OPPORTUNITY:`, `DECISION:`, `LESSON:`, `RULE:`) and confirm the audit-brief text is identical across the two (plan verification step 3). Update both files' MIRROR NOTE comment blocks with the dated sync line so the PAIRED CONTRACT trail stays current. The 17 wrap symlinks inherit the canonical edit automatically and need no per-symlink action — confirm none of the two divergent non-symlink legacy copies (positioning-research, research-workflow) was edited, since neither carries Step 6.4.
- **Dimension 5 (Hidden Coupling) — document the new cross-command contract at both ends.** Add the `## Weekly Session Value Review` section to friday-checkup Step 7's "Section presence by tier" data contract with the explicit note that it is advisory and all-tier (plan §63), and confirm friday-act's consuming input-source addition names the producing heading, so the new two-end contract is self-describing the same way the existing tactical/policy/architectural headings are (friday-act.md line 106 pattern).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (wrap-session.md Step 6.4 lines 358–385, schema line 351–352; friday-act.md parse contract lines 106–114; friday-checkup.md Step 7 lines 388–393; session-feedback-collector.md lines 33, 44), symlink-topology grep (17 wrap + ~36 friday symlinks enumerated), contract-marker greps (`Session Value Audit`, `Weekly Session Value Review` — only consumer is the SO advisory + plan, confirming zero pre-existing parser), principles-base.md frozen-ID citations (OP-12, OP-9/AP-7/DR-7, OP-5, OP-2/AP-4, DR-1/DR-3), and verbatim quotes from CHANGE_DESCRIPTION and the plan file. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory). Verdict is PROCEED-WITH-CAUTION. A Function B advisory on this identical change set was produced minutes before this risk-check in the same session (`projects/axcion-ai-system-owner/output/consultations/consult-2026-06-12-session-value-audit-wrap-session.md`); it is reused verbatim below rather than re-invoking `/consult` — its condition 1 is the same `/friday-act` parse-contract concern this verdict's top mitigation names. Deliberate dedup, noted in chat._

**Routing position.** Correct as scoped. Three command-body edits, no relocation, no new file home (repo-architecture.md Q5/Q6). The canonical wrap-session edit auto-syncs to ~16 projects; the workspace-root mirror is the deliberate non-symlink exception; the friday-checkup roll-up writes into the existing Step 7 template. All three are `/risk-check` change classes (DR-8).

**Architectural read — proceed.** The consolidation move (extend the existing Step 6.4 subagent, no second judge) is the strongest part: principle-backed by OP-12 (closure before detection) and DR-7 — a separate worth-it detector with no closure channel would *add to* the binding constraint. The macro question ("was this session worth having, should it recur?") is genuinely unasked elsewhere — checked against the toolkit map: Step 6.4 grades mandate-completion, `/usage-analysis` = telemetry, `/coach` = cross-session patterns, `/improve` = friction, `/implementation-triage` = pre-work ROI. No overlap. Prose-only (no schema) is the right v1 call (AP-7). Keep it advisory (OP-5): the moment a SCORE gates commit it becomes enforcement automation needing its own pass.

**Downstream impact.** Uniform and benign. ~16 projects inherit the audit block at next session start (risk-topology § 2). The mirror must stay byte-identical — grep-both verification is the correct two-end-contract guard (risk-topology § 5). The all-tier friday-checkup roll-up must carry near-zero weekly cost (no subagent — satisfied).

**Position — proceed as scoped, with three conditions:**
1. Verify the `## Weekly Session Value Review` heading insertion against `/friday-act`'s actual parse logic before commit — do not rely on the placement assertion.
2. Confirm the roll-up has a consumption path at `/friday-act`; if review-only is intended, log that as deliberate.
3. Keep the audit strictly advisory (OP-5) — never let a SCORE block commit/push.

Endorsed. The SO concurs with proceeding; no disagreement with the PROCEED-WITH-CAUTION verdict.
