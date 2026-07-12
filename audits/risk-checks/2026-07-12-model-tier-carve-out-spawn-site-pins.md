# Risk Check — 2026-07-12

## Change

End-time risk-check on a change already committed and pushed this session (commit `7240de2`, workspace-root repo). Change: added a carve-out to workspace `CLAUDE.md` § Model Tier, permitting a `general-purpose` subagent spawn to have its tier pinned in command body prose (e.g. "pin `model: opus` on the spawn"), on the grounds that `general-purpose` carries no frontmatter of its own and would otherwise silently inherit the session model. The carve-out is one paragraph inserted after the existing frontmatter-only rule; the existing settings.json-default ban and its "non-negotiable" framing were left untouched. This ratifies a practice already live in 5 commands since 2026-07-03 (`/qc-pass`, `/refinement-pass`, `/refinement-deep`, `/risk-check`, `/friday-journal`) and extends it to 6 more this session (`drift-check`, `contract-check`, `resolve-repo-problem`, `create-skill`, `improve-skill`, `migrate-skill`) — 11 total commands now carry spawn-site tier pins. The decision to add the carve-out (rather than revert the 6 new pins, or leave the tension unresolved) was made via an operator AskUserQuestion, not a prior `/risk-check` — this is the first structured risk pass on it. Full rationale in `logs/decisions.md` 2026-07-12 (S4) and the commit message itself.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/drift-check.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/contract-check.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/resolve-repo-problem.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/create-skill.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/improve-skill.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/migrate-skill.md` — exists

## Verdict

RECONSIDER

**Summary:** The carve-out is a legitimate, loudly-recorded (OP-11) doctrine revision, but as landed it adds a >150-token block to an always-loaded cross-project file, asserts a repo-wide "must" that the commit's own verification did not check and that at least 6 more `general-purpose`-spawning commands do not meet, and leans on a decisions.md date-citation that the repo's own monthly archiving convention will eventually move — three independent High findings, which is a RECONSIDER regardless of any single mitigation.

## Consumer Inventory

Search terms used: `Model Tier` / `§ Model Tier` (section heading), `general-purpose` (the contract marker the carve-out governs), `pin \`model:` (the spawn-site-pin idiom the carve-out legitimizes), and the specific command names enumerated in the commit message and the carve-out paragraph. Grepped across `{AI_RESOURCES}` and the workspace root, excluding `.git`. The case-insensitive `"Model Tier"` grep also returned ~90 historical audit/log/archive files (dated `repo-health-*`, `claude-md-audit-*`, `risk-checks/*`, `decisions-archive-*`, etc.) that merely record a past reference to the section — these are inert historical records, not live consumers, and are omitted from the table below (their count is noted as a research artifact, not a blast-radius signal).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/CLAUDE.md` (§ Model Selection pointer, L24) | documents | no |
| `ai-resources/docs/audit-discipline.md` | documents | no |
| `ai-resources/docs/autonomy-rules.md` | documents | no |
| `ai-resources/docs/permission-template.md` | documents | no |
| `ai-resources/docs/settings-local-recovery.md` | documents | no |
| `ai-resources/docs/repo-architecture.md` | documents | no |
| `ai-resources/docs/agent-tier-table.md` | co-edits (adjacent tiering doctrine — named-agent frontmatter, reconciled same session, W3.2 M-A4) | no |
| `.claude/commands/new-project.md` (L158, L386) | documents (cites the untouched settings.json ban) | no |
| `.claude/commands/deploy-workflow.md` (L168) | documents (cites the untouched settings.json ban) | no |
| `.claude/commands/prime.md` (L173) | documents | no |
| `.claude/commands/session-plan.md` (L84) | documents | no |
| `.claude/commands/qc-pass.md`, `refinement-pass.md`, `refinement-deep.md`, `risk-check.md`, `friday-journal.md` (5 files — pins live since 2026-07-03, fallback-path pins only) | co-edits (practice the carve-out ratifies) | no |
| `.claude/commands/drift-check.md`, `contract-check.md`, `resolve-repo-problem.md`, `create-skill.md`, `improve-skill.md`, `migrate-skill.md` (6 files — pins added this session, primary-dispatch pins) | co-edits (practice the carve-out ratifies) | no |
| `.claude/commands/tweak.md` — spawns `general-purpose` (Step 3, edit-fix dispatch), no tier pin | parses (subject to the new "must" clause; not enumerated in the change) | **yes** |
| `.claude/commands/decide.md` — spawns `general-purpose` (Step 6, anti-narrowing/evidence-accuracy QC), no tier pin | parses | **yes** |
| `.claude/commands/leverage-idea.md` — spawns `general-purpose` (Step 4, investigation), no tier pin | parses | **yes** |
| `.claude/commands/graduate-resource.md` — spawns `general-purpose` (residue-scan judgment), no tier pin | parses | **yes** |
| `.claude/commands/promote-workflow.md` — invokes `graduate-resource`'s unpinned residue-scan subagent | parses | **yes** |
| `.claude/commands/wrap-session.md` — spawns `general-purpose` (Step 6, COMPLETION/EXECUTION grading + Session Value Audit), no tier pin | parses | **yes** |

Total: 23 consumers, 6 must-change. All 6 must-change rows are a gap the change introduced but did not name: the carve-out's own text states "a command that spawns `general-purpose` **must** state the tier at the spawn site" — an unconditional, repo-wide clause — but the commit's stated verification ("the prohibition, the non-negotiable clause and the settings.json ban all still present; 0 settings files declare a model default") did not check general-purpose-spawn compliance against that new "must," and 6 commands beyond the named 11 do not comply. This target is `exists` (an edit to an existing file), so all consumers listed have current dependents; none are "not yet present."

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- The added paragraph is 206 words / 1,412 characters (measured directly from `CLAUDE.md` between `**Carve-out —` and the following `Project-level` paragraph) — roughly 350 tokens at a standard ~4 chars/token English ratio, well past the ">150 tokens to always-loaded files" High threshold.
- It lands in workspace-root `CLAUDE.md`, which per the file's own opening line ("Root workspace for Axcíon AI projects... this file covers cross-project conventions") is loaded in every session across every project in the workspace — this is not a per-command or per-skill cost, it is a permanent per-session tax paid indefinitely going forward.
- The paragraph is denser than it needs to be for an always-loaded location: it embeds the full enumeration of all 11 command names and the `/risk-check` sonnet-exception cross-reference inline, content that could live in a linked doc (as the file already does for `agent-tier-table.md`, `qc-independence.md`, etc.) with a short pointer left in place.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries were added, removed, or widened in any `settings.json` layer — the diff (`git show 7240de2`) touches only `CLAUDE.md`, 2 lines inserted.
- The existing settings.json model-default ban ("Do not declare a `\"model\"` field in ANY `.claude/settings.json`/`.claude/settings.local.json`") is explicitly reaffirmed, not narrowed — the carve-out paragraph states "The ban above targets `settings.json` model *defaults*... a spawn-site pin overrides nothing."
- The change governs an internal doctrine convention (how to state a model tier in command prose) rather than a Claude Code tool-permission surface (Bash/Write/Read/MCP grants); it does not introduce a new capability class.

### Dimension 3: Blast Radius
**Risk:** High

- Per the Consumer Inventory: 23 consumers found, 6 must-change (`tweak.md`, `decide.md`, `leverage-idea.md`, `graduate-resource.md`, `promote-workflow.md`, `wrap-session.md`) — all six spawn a `general-purpose` subagent for judgment-bearing work (evidence-accuracy QC, investigation, residue-scan, session-outcome grading) without a tier pin, and are now bound by the carve-out's unconditional "must" clause without having been touched or even mentioned by this change.
- This is a contract change that is not fully backwards-compatible with the literal doctrine text: before the carve-out, there was no explicit repo-wide "must pin tier on every general-purpose spawn" rule to violate; after it, 6 commands are in textual non-compliance the moment the commit lands — a state a future `/audit-claude-md` or `instruction-audit` pass is likely to flag as a fresh defect, generating unplanned corrective work.
- The change touches shared infrastructure (an always-loaded, cross-project `CLAUDE.md` section) that every command, skill, and session in the workspace reads — the textbook "shared infra touched in a way that affects multiple workflows" High trigger.
- The Step 1.5 inventory surfaced this gap; `CHANGE_DESCRIPTION` frames the change as closing out "11 total commands" cleanly, which undercounts the actual population of `general-purpose` spawn sites the new rule now governs — a blast-radius finding not anticipated by the description.

### Dimension 4: Reversibility
**Risk:** Medium

- Structurally the edit is clean: a single 2-line insertion into one file, tracked in git. `git revert 7240de2` fully restores the prior paragraph boundary with no sibling files created.
- But the commit is already pushed — confirmed via `git log origin/main -1` matching `7240de2` — so a revert requires a second push to propagate, not just a local `git revert`.
- `logs/decisions.md` already carries a permanent, dated entry ("2026-07-12 (S4) — § Model Tier carve-out: ratify spawn-site tier pins rather than strip them") recording the ratification as settled. `decisions.md` is an append-only historical log (the repo already archives it monthly — `decisions-archive-2026-04/05/06.md`); a revert cannot remove that entry, only add a new one noting the reversal, which is the "one extra cleanup step" that keeps this at Medium rather than Low.
- No external system writes (Notion, GPT, Perplexity) are involved — the propagation risk is bounded to the two-repo git history plus the append-only decision log.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Undocumented new contract, silently under-enforced.** The carve-out states an unconditional rule ("a command that spawns `general-purpose` must state the tier at the spawn site") but provides no mechanism (lint, audit-claude-md check, pre-commit hook) that verifies compliance — the rule is aspirational text with no enforcement path, and the Consumer Inventory shows it is already unmet by 6 commands (`tweak.md`, `decide.md`, `leverage-idea.md`, `graduate-resource.md`, `promote-workflow.md`, `wrap-session.md`).
- **Fragile date-citation coupling.** The paragraph cites `ai-resources/logs/decisions.md 2026-07-05` (the `/risk-check` sonnet-exception) and depends on that entry remaining resolvable at that path. The repo already rotates `decisions.md` into monthly archives (`decisions-archive-2026-04.md`, `-05.md`, `-06.md` all exist) — when 2026-07 is eventually archived, this in-doctrine citation will point to a line that has moved, without any update mechanism tying the two together.
- **Two parallel tiering mechanisms, cross-referenced but not unified.** `docs/agent-tier-table.md` is "ground truth" for named-agent frontmatter tiers; the new carve-out is the parallel ground truth for `general-purpose` prose-pins. They don't conflict today, but a future editor updating one has no structural signal to check the other — an implicit dependency that exists only in prose ("Agent tiering rules: `ai-resources/docs/agent-tier-table.md`" pointer, L185) rather than a single reconciled source.

### Dimension 6: Principle Alignment
**Risk:** Medium

- Principles-base read from `projects/strategic-os/ai-strategy/principles-base.md` (present and readable).
- **OP-11 (loud revision, never silent drift) — satisfied, not violated.** The change is exactly the licensed case: a tension between doctrine and practice was surfaced, an explicit operator decision was recorded (`logs/decisions.md` 2026-07-12 S4, via AskUserQuestion, with alternatives considered and rejected), and the commit message states the rationale in full. This is the model case for OP-11, not a violation.
- **Tension named.** The revision's own factual predicate is broader than what was verified: the carve-out asserts a universal "must" (every `general-purpose` spawn must pin tier) but the commit's stated verification only checked the settings.json ban and the presence of the existing prohibition text — it did not check general-purpose-spawn compliance against the new "must" it was simultaneously creating. That gap (documented under Dimensions 3 and 5) is a **process-completeness tension**, not a principle violation in itself: OP-11 requires the revision be loud and recorded, which it is; it does not additionally require that the revision's factual claims be independently audited before landing. Scored Medium rather than Low because the paragraph's own text ("11 total commands") reads as a closed, verified count when the inventory shows it is not.
- **DR-1/DR-3 (placement)** — the addition is correctly placed: same section (`§ Model Tier`), same file tier (workspace-root `CLAUDE.md`, a genuinely cross-project rule), no placement violation.
- No OP-9/AP-7/DR-7 (speculative abstraction), OP-10 (system-boundary expansion), OP-12 (detection-without-closure), or OP-5 (advisory-to-enforcement) concerns apply — this is a doctrine-text clarification, not a new component, cross-tool coordination, detector, or enforcement mechanism.

## Recommended redesign

- **Shrink the always-loaded footprint.** Replace the 206-word inline paragraph in workspace `CLAUDE.md` § Model Tier with a 1–2 line pointer (matching the file's existing style for `qc-independence.md`, `agent-tier-table.md`, etc.) and move the full carve-out text — the rationale, the 11-command enumeration, and the risk-check sonnet-exception note — into a linked doc (e.g. `ai-resources/docs/agent-tier-table.md` or a new `ai-resources/docs/model-tier-carve-out.md`). This directly closes Dimension 1 without weakening the doctrine, since the underlying rule (frontmatter-only, plus the general-purpose carve-out) still holds — only its always-loaded surface area shrinks.
- **Close the compliance gap the change itself created before (or immediately after) it ships.** Run a repo-wide grep for every `general-purpose` spawn site (not just the 11 named), and either (a) add the same spawn-site tier pin to the 6 outstanding commands (`tweak.md`, `decide.md`, `leverage-idea.md`, `graduate-resource.md`, `promote-workflow.md`, `wrap-session.md`), or (b) rescope the carve-out's "must" clause to explicitly name only the audited 11 and mark the rest as a known, logged follow-up (`improvement-log.md`) rather than an implicit, silently-broken universal rule. Either path resolves Dimensions 3 and 5 without reverting the ratification itself.
- **Replace the raw date-citation with a stable anchor.** Point the `/risk-check` sonnet-exception reference at a decision ID or a permanently-retained index entry rather than a bare `logs/decisions.md 2026-07-05` line that the repo's existing monthly-archive convention will eventually move out from under the citation.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
