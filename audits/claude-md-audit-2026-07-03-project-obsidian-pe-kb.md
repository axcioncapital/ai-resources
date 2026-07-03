# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (project-weighted; workspace covered by a separate committed workspace audit)
**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 230 lines, ~4,060 tokens
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb/CLAUDE.md` — 61 lines, ~1,283 tokens

**Combined always-loaded weight in a project session:** ~5,340 tokens (workspace loads via ancestor-walk from the project root; see guidance note on `--add-dir` / ancestor-walk).

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. the real tokenizer. Findings within ±15% of a threshold are tagged `(boundary)`.

**Weighting note:** Per the launching instruction, workspace-internal findings are out of scope (a separate committed workspace audit owns them). Workspace blocks appear in the inventory and verdict table as `Keep — workspace-scope, audited separately`. Findings below concentrate on the **project file** and **cross-file redundancy**. Where a cross-file duplicate exists, the workspace side is treated as canonical and the fix is proposed on the project side.

---

## Executive Summary

- Total findings: **HIGH: 3 / MEDIUM: 3 / LOW: 1**
- Projected token savings if all HIGH+MEDIUM applied: **~700 tokens/turn** (~21,000 tokens/session at 30 turns; ~35,000 at 50 turns). This roughly halves the project file's always-loaded weight (1,283 → ~580 tokens).
- **Net verdict:** The project file carries three large blocks (`Input File Handling`, `Commit Rules`, `Session Boundaries`) that verbatim-duplicate canonical workspace rules and thereby violate the workspace's own `CLAUDE.md Scoping` rule ("Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not"). The stated justification for the duplication ("projects are sometimes opened without the parent workspace context loaded") does not hold under ancestor-walk loading. Convert the duplicated blocks to short pointers, keep only the genuinely project-specific clauses (vault-repo split, compaction preserve-list, recommended model posture).

---

## Per-File Inventory

### Project CLAUDE.md (`projects/obsidian-pe-kb/CLAUDE.md`)

| Block | ~Tokens | % of file | Type | @-refs |
|---|---|---|---|---|
| Project Layout | ~165 | 13% | Project-specific structure + gotcha | none (path links only) |
| How to Open This Project in Claude Code | ~98 | 8% | Project-specific onboarding | none |
| Model Selection | ~117 | 9% | Discretionary + prohibition restatement | pointer to workspace § Model Tier |
| Commit Rules | ~234 | 18% | Bright-line, mostly duplicated | pointer to workspace Commit behavior; `pe-kb-vault` path |
| Input File Handling | ~440 | 34% | Bright-line, duplicated detail | claims mirror of workspace section |
| Compaction | ~195 | 15% (boundary) | Mixed: project-specific + generic | none |
| Session Boundaries | ~26 | 2% | Pointer, verbatim duplicate | `ai-resources/docs/session-boundaries.md` |

### Workspace CLAUDE.md (`CLAUDE.md`) — inventory only (audited separately)

| Block | ~Tokens | Type |
|---|---|---|
| What This Workspace Is For | ~40 | Orientation |
| Projects | ~98 | Structure |
| Axcíon's Tool Ecosystem | ~91 | Reference |
| Cross-Model Rules | ~52 | Pointer + rule |
| Skill Library | ~85 | Bright-line |
| AI Resource Creation | ~72 | Bright-line + pointer |
| Placement Discipline | ~260 | Bright-line + triggers |
| Design Judgment Principles | ~72 | Principle + pointer |
| QC Independence Rule | ~182 | Bright-line + pointer |
| Contract-Conformance Check | ~234 | Trigger list |
| Blind-Spot Scan Gate | ~195 | Bright-line |
| Assumptions Gate | ~91 | Bright-line |
| Completion Standard | ~85 | Bright-line |
| Requirements-Doc Default | ~195 | Bright-line |
| Working Principles | ~430 | Mixed principles (incl. Session boundaries, Compaction pointers) |
| Chat Communication Style | ~143 | Discretionary |
| File Write Discipline | ~33 | Short pointer (canonical) |
| Autonomy Rules | ~234 | Bright-line list |
| Decision-Point Posture | ~182 | Bright-line |
| QC → Triage Auto-Loop | ~26 | Pointer |
| Session Guardrails | ~195 | Bright-line flags |
| Plan Mode Discipline | ~65 | Bright-line + pointer |
| CLAUDE.md Scoping | ~91 | Meta-rule (governs this audit) |
| Model Tier | ~234 | Bright-line (canonical) |
| Model Escalation | ~169 | Bright-line |
| Adaptive Thinking Override | ~45 | Env config |
| File verification and git commits (5 H3s) | ~364 | Bright-line (canonical commit/push) |
| Delivery | ~33 | Reference |
| Agent Harness | ~65 | Conditional load |

---

## Tier 1 — Token Cost

**[HIGH] Input File Handling — project file — ~440 tokens (34% of file).**
Largest block in the file by a wide margin, 2.3× the 15% HIGH threshold. Consists of a general principle plus six detailed sub-clauses (default-to-Read, do-not-materialize, do-not-co-locate, outputs-are-different, operator-pasted-verbatim, legitimate-copying exception). The general principle is already the workspace `File Write Discipline` block, which is deliberately a **short pointer** to `ai-resources/docs/file-write-discipline.md`. The detailed exception clauses (legitimate copying, operator-pasted verbatim save) apply to well under 25% of turns. Long prose that duplicates a lazy-loadable doc — the exact anti-pattern the deletion test targets. Compress to a pointer.

**[MEDIUM] Commit Rules — project file — ~234 tokens (18% of file).**
Over the 8% MEDIUM threshold and over 15%. Commit behavior applies at commit time (a minority of turns), and roughly 75% of the block restates the canonical workspace commit/push rules verbatim. Only the final "Important note for this project" paragraph (vault content lives in a separate repo; do not stage vault paths) is project-specific and load-bearing. Verbose restatement where a pointer plus the vault clause would serve.

**[MEDIUM] (boundary) Compaction — project file — ~195 tokens (15.2% of file).**
At the 15% line (boundary tag). The block splits into (a) a genuinely project-specific preserve-list (pipeline/stage id, subagent-output paths, pending operator gate) that is worth keeping, and (b) a generic "Post-compact resumption — trust the summary" paragraph (~80 tokens) that restates workspace guidance / auto-memory and the `compaction-protocol.md` doc. Compaction fires only in long sessions (<25% of turns). The generic paragraph is the trimmable part.

---

## Tier 2 — Redundancy

**[HIGH] Session Boundaries (project) ↔ Working Principles § Session boundaries (workspace) — cross-file, near-verbatim.**
Project block, in full: "Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`." Workspace bullet: "**Session boundaries.** Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`." Identical substance and identical pointer. The project version adds nothing project-specific. Because the workspace loads in every project-root session via ancestor-walk, this block is pure double-cost. Delete.

**[HIGH] Commit Rules (project) ↔ File verification and git commits § Commit behavior / Push behavior (workspace) + Commit Rules (ai-resources) — cross-file, triple duplication.**
Same substance across three always-or-often-loaded layers: "Commit directly. Do not ask for permission… do not run `git status`/`git diff`… After committing, do NOT push. Pushes are batched until session end and gated by a single operator confirmation at `/wrap-session`." The workspace `Push behavior` H3 is the canonical, most detailed statement (includes the exact confirmation prompt). The project restatement carries only one non-duplicated clause (the vault-repo staging note). Keep the vault clause; reduce the rest to a pointer.

**[HIGH] Input File Handling (project) ↔ File Write Discipline (workspace) — cross-file, canonical-vs-verbatim.**
Workspace keeps this as a 33-token pointer to `ai-resources/docs/file-write-discipline.md`; the project expands the same rule to ~440 tokens. This directly violates the workspace `CLAUDE.md Scoping` rule ("Short pointer is acceptable; verbatim duplication is not"). It is also the exact "verbatim duplication across files/layers" anti-pattern in the external guidance (MEDIUM–HIGH). Reduce to a pointer matching the workspace pattern.

**[MEDIUM] Model Selection (project) ↔ Model Tier (workspace) — cross-file, partial restatement.**
The project block both restates the prohibition ("Do not declare a `\"model\"` field in any `.claude/settings.json`… and do not state a default model in this CLAUDE.md") **and** points to it ("See workspace `CLAUDE.md` § Model Tier for the prohibition rationale"). The restatement is redundant with the pointer. Note: the workspace `Model Tier` block explicitly sanctions a project `Model Selection` section for *recommended posture* — so the second paragraph (Sonnet-for-ingestion / Opus-for-synthesis) is legitimate and should stay. Trim only the prohibition-restatement sentence, keeping the pointer + the posture recommendation.

**[MEDIUM] Compaction § "trust the summary" (project) ↔ Working Principles § Compaction protocol pointer + auto-memory (workspace) — cross-file, partial.**
The generic post-compact "trust the summary; do not re-derive via git log/show" paragraph duplicates workspace guidance and the `compaction-protocol.md` doc. The project-specific preserve-list is not duplicated and should stay.

---

## Tier 3 — Contradictions

**None found.** The duplicated blocks (commit, input handling, session boundaries, model) are substantively *consistent* with their workspace counterparts — the risk here is divergence-on-future-edit (the standard cost of duplication), not a present behavioral contradiction. No autonomy/commit/scope rule in the project file directs behavior that conflicts with another rule in either file.

---

## Tier 4 — Staleness

**[MEDIUM] Duplication justification rests on a false premise (appears twice — Commit Rules line 31, Input File Handling line 46).**
Both blocks justify their duplication with: "It is repeated here because projects are sometimes opened without the parent workspace context loaded." Per the external guidance, ancestor-walk from cwd loads the workspace-root CLAUDE.md normally, so opening at `projects/obsidian-pe-kb/` **does** load the workspace file. The only alternative entry point named in this file — opening at `knowledge-bases/pe-kb-vault/` — loads the *vault's own* CLAUDE.md, not this project file (and is itself a sibling under the workspace root, so it also ancestor-walks to the workspace). There is therefore no realistic load path where this project file loads but the workspace file does not. The premise that motivates the whole duplication is stale/incorrect.

**[MEDIUM] Input File Handling names a workspace section that does not exist.**
Line 46 claims to "mirror the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`." The workspace file has **no** `Input File Handling` section — the corresponding rule lives under `File Write Discipline`, which is a short pointer, not a full section. The mirror-claim is inaccurate and would mislead a future maintainer trying to reconcile the two.

---

## Tier 5 — Misplacement

**[HIGH] Input File Handling (~440 tokens, >300) → reduce to a pointer to `ai-resources/docs/file-write-discipline.md`.**
Rationale: workspace `CLAUDE.md Scoping` — canonical workspace rules get a short pointer in project CLAUDE.md, not verbatim detail. The full write-discipline rules already have a canonical home (the referenced doc) and a canonical pointer (workspace `File Write Discipline`). >300 tokens → HIGH per Tier 5. Guidance: pointer-not-restatement best practice.

**[MEDIUM] Commit Rules generic portion (~150 tokens of the block) → pointer to workspace § File verification and git commits.**
Keep the vault-repo staging clause in the project file (genuinely project-specific); move the generic commit/push restatement to a pointer. The canonical statement is the workspace `Push behavior` / `Commit behavior` H3s.

**[MEDIUM] Compaction generic paragraph (~80 tokens) → pointer to `ai-resources/docs/compaction-protocol.md`.**
Keep the project-specific preserve-list; the "trust the summary" mechanics belong in the canonical compaction doc / workspace layer.

**[covered under Tier 2] Session Boundaries → Delete** (adds nothing beyond the workspace bullet, which already carries the same pointer).

---

## Tier 6 — Clarity

**[LOW] How to Open This Project + Project Layout apply mainly at session open / orientation (<25% of turns) and restate some model-inferable structure.**
`How to Open` (~98 tokens) is onboarding context that matters at the first turn, not every turn; `Project Layout`'s directory list ([pipeline/], [logs/], [reports/]) is partly inferable from the repo tree (guidance: "duplicating what the model can infer"). Both contain one genuinely non-obvious gotcha worth keeping (the build-repo vs. vault-repo split; the two-entry-point loading behavior). No rewrite proposed — flagged only as a lower-value trim candidate if the operator wants to push the file leaner. No vague-modal-verb or missing-scope defects of note; the project file is written concretely.

---

## Per-Block Verdict Table

### Project CLAUDE.md

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| Project Layout | project | ~165 | Keep (Trim optional) | Project-specific vault/build-repo split is non-obvious and worth keeping; directory list partly inferable | — | guidance: infer-anti-pattern |
| How to Open This Project | project | ~98 | Keep | Non-obvious two-entry-point loading behavior; low-frequency but load-bearing at open | — | priors |
| Model Selection | project | ~117 | Trim | Drop the prohibition-restatement sentence (dup of workspace Model Tier); keep pointer + recommended posture (posture is sanctioned by Model Tier) | — | workspace § Model Tier; guidance: verbatim-dup |
| Commit Rules | project | ~234 | Trim | Reduce generic commit/push restatement to a pointer; keep the vault-repo staging clause | pointer → workspace § File verification and git commits | workspace § CLAUDE.md Scoping; guidance: verbatim-dup |
| Input File Handling | project | ~440 | Move | Verbatim expansion of a rule the workspace keeps as a pointer; >300 tokens; mirror-claim names a nonexistent section | `ai-resources/docs/file-write-discipline.md` (pointer) | workspace § CLAUDE.md Scoping; guidance: pointer-not-restatement |
| Compaction | project | ~195 | Trim | Keep project-specific preserve-list; move generic "trust the summary" para to a pointer | pointer → `ai-resources/docs/compaction-protocol.md` | guidance: pointer-not-restatement |
| Session Boundaries | project | ~26 | Delete | Near-verbatim duplicate of workspace Working Principles bullet, same pointer, nothing project-specific | — | workspace § CLAUDE.md Scoping; guidance: verbatim-dup |

### Workspace CLAUDE.md (audited separately — listed for completeness)

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | ~40 | Keep | Workspace-scope, audited separately | — | out of scope |
| Projects | workspace | ~98 | Keep | Workspace-scope, audited separately | — | out of scope |
| Axcíon's Tool Ecosystem | workspace | ~91 | Keep | Workspace-scope, audited separately | — | out of scope |
| Cross-Model Rules | workspace | ~52 | Keep | Workspace-scope, audited separately | — | out of scope |
| Skill Library | workspace | ~85 | Keep | Workspace-scope, audited separately | — | out of scope |
| AI Resource Creation | workspace | ~72 | Keep | Workspace-scope, audited separately | — | out of scope |
| Placement Discipline | workspace | ~260 | Keep | Workspace-scope, audited separately | — | out of scope |
| Design Judgment Principles | workspace | ~72 | Keep | Workspace-scope, audited separately | — | out of scope |
| QC Independence Rule | workspace | ~182 | Keep | Workspace-scope, audited separately | — | out of scope |
| Contract-Conformance Check | workspace | ~234 | Keep | Workspace-scope, audited separately | — | out of scope |
| Blind-Spot Scan Gate | workspace | ~195 | Keep | Workspace-scope, audited separately | — | out of scope |
| Assumptions Gate | workspace | ~91 | Keep | Workspace-scope, audited separately | — | out of scope |
| Completion Standard | workspace | ~85 | Keep | Workspace-scope, audited separately | — | out of scope |
| Requirements-Doc Default | workspace | ~195 | Keep | Workspace-scope, audited separately | — | out of scope |
| Working Principles | workspace | ~430 | Keep (canonical for cross-file dups) | Holds canonical Session-boundaries + Compaction pointers the project should defer to | — | out of scope |
| Chat Communication Style | workspace | ~143 | Keep | Workspace-scope, audited separately | — | out of scope |
| File Write Discipline | workspace | ~33 | Keep (canonical) | Canonical short pointer the project Input-File-Handling block should mirror | — | out of scope |
| Autonomy Rules | workspace | ~234 | Keep | Workspace-scope, audited separately | — | out of scope |
| Decision-Point Posture | workspace | ~182 | Keep | Workspace-scope, audited separately | — | out of scope |
| QC → Triage Auto-Loop | workspace | ~26 | Keep | Workspace-scope, audited separately | — | out of scope |
| Session Guardrails | workspace | ~195 | Keep | Workspace-scope, audited separately | — | out of scope |
| Plan Mode Discipline | workspace | ~65 | Keep | Workspace-scope, audited separately | — | out of scope |
| CLAUDE.md Scoping | workspace | ~91 | Keep (governs this audit) | Meta-rule the project fixes are cited against | — | out of scope |
| Model Tier | workspace | ~234 | Keep (canonical) | Canonical model prohibition + sanctions project posture section | — | out of scope |
| Model Escalation | workspace | ~169 | Keep | Workspace-scope, audited separately | — | out of scope |
| Adaptive Thinking Override | workspace | ~45 | Keep | Workspace-scope, audited separately | — | out of scope |
| File verification and git commits (5 H3s) | workspace | ~364 | Keep (canonical for commit/push) | Canonical commit/push rules the project Commit-Rules block should defer to | — | out of scope |
| Delivery | workspace | ~33 | Keep | Workspace-scope, audited separately | — | out of scope |
| Agent Harness | workspace | ~65 | Keep | Workspace-scope, audited separately | — | out of scope |

---

## Estimated Savings

Applying all HIGH+MEDIUM project findings (Move/Trim/Delete):

- **Input File Handling:** ~440 → ~30 (pointer). Save **~410**.
- **Commit Rules:** ~234 → ~85 (vault clause + pointer). Save **~150**.
- **Compaction:** ~195 → ~110 (preserve-list + pointer). Save **~85**.
- **Session Boundaries:** ~26 → 0 (delete). Save **~26**.
- **Model Selection:** ~117 → ~77 (drop prohibition restatement). Save **~40**.

- **Per turn:** ~**700 tokens** (project file 1,283 → ~580).
- **Per 30-turn session:** ~21,000 tokens.
- **Per 50-turn session:** ~35,000 tokens.

Breakdown by tier (net, de-duplicated across tiers so blocks are not double-counted):
- Tier 2 (cross-file redundancy) drives ~626 of the savings (Input File Handling, Commit Rules, Session Boundaries, Model Selection restatement).
- Tier 5 (misplacement / pointer conversion) and Tier 1 (size) are the same physical edits, not additive.
- Tier 4 (staleness) findings are correctness fixes with negligible standalone token impact (removing the two false-premise sentences ≈ ~50 tokens, already inside the Commit/Input savings above).

---

## External Guidance Cited

- **Verbatim duplication across files/layers** — anti-pattern, MEDIUM–HIGH; "double context cost" and divergence risk. Drives all three Tier 2 HIGH findings. (`audit-claude-md-external-guidance-2026-07-03.md`, Identified anti-patterns)
- **Pointer-not-restatement** — best practice; "short pointer to a canonical doc is the sanctioned way to keep detail out of the always-loaded layer (matches this workspace's own CLAUDE.md Scoping rule)." Drives Tier 5 Move/Trim verdicts. (same file, Identified best practices)
- **The deletion test (official)** — "Would removing this cause Claude to make a mistake?" Applied to Session Boundaries (no) and Input File Handling detail (no; covered by canonical pointer). (same file, Identified best practices)
- **Duplicating what the model can infer** — MEDIUM; structure descriptions waste always-loaded budget. Supports the Tier 6 LOW note on Project Layout. (same file, Identified anti-patterns)
- **Ancestor-walk loading / `--add-dir` note** — "ancestor-walk from cwd still loads workspace-root CLAUDE.md normally." Refutes the project file's "opened without parent workspace" duplication justification (Tier 4). (same file, Notes specific to long-context models)
- **Over-length / instruction crowding** — HIGH when materially over 200 lines. Not triggered for the 61-line project file standalone; noted only as context for the ~5,340-token combined always-loaded weight in a project session. (same file, Identified anti-patterns)
