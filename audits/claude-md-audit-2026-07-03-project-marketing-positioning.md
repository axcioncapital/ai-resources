# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (project-weighted)
**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — 231 lines, ~3,600 tokens (rough; audited separately)
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/CLAUDE.md` — 161 lines, ~2,700 tokens

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. No NOTES_PATH/measurements file was supplied — all counts are this auditor's estimates. Findings within ±15% of a threshold are tagged `(boundary)`.

**Audit weighting (per launch instructions):** The workspace CLAUDE.md loads in this project's sessions via ancestor-walk and is covered by a separate committed workspace audit. Findings are weighted toward the PROJECT file and cross-file redundancy. Workspace blocks appear in the inventory and verdict table for completeness but are marked "audited separately" unless they are the canonical home for a project duplication.

## Executive Summary

- Total findings: HIGH: 3 / MEDIUM: 8 / LOW: 3
- Projected token savings if all HIGH+MEDIUM applied: **~1,100 tokens/turn** (~33,000 tokens/session at 30 turns; ~55,000 at 50 turns). HIGH-only savings ≈ ~540 tokens/turn.
- **Net verdict:** The project file carries roughly 750 tokens (~28%) of canonical-workspace-rule restatement and pipeline/stage methodology that the workspace's own "CLAUDE.md Scoping" section says must be a short pointer, not a verbatim copy. Three blocks (Input File Handling, Commit Rules, Session Boundaries) are near-verbatim duplicates of rules that already load via ancestor-walk; a second cluster (Organizing Framework, Checkpoints, Autonomy gates) duplicates the frozen project-plan. No contradictions found. The project-specific voice/positioning rules are sound and should be kept.

## Per-File Inventory

### Project CLAUDE.md (`projects/marketing-positioning/CLAUDE.md`)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Project Is | 124 | orientation | no |
| Organizing Framework | 294 | workflow/pipeline methodology | no (cites project-plan) |
| Channel-Copy Ownership Boundary | 101 | bright-line (project seam) | no |
| AI-as-Substrate Rule | 74 | bright-line (positioning) | no |
| Voice-Authoring Discipline | 195 | bright-line + spec ref (§4.5) | cites logs/decisions.md |
| Embedded Consultant | 111 | discretionary + file ref | points to `_consultants/embedded-consultant.md` |
| Reference-Input Map | 96 | spec ref | points to `reference/source-map.md` |
| Method-Notes Byproduct | 91 | discretionary (byproduct cap) | points to `reference/method-notes.md` |
| Autonomy Posture & Decision Gates | 181 | bright-line (gate list) | no |
| Checkpoints | 164 | workflow/stage methodology | cites project-plan §8 |
| Cross-Project Deferred Writes | 192 | bright-line (safety) | cross-project paths |
| Model Selection | 107 | rule + pointer | pointer to workspace Model Tier |
| Directory Layout | 104 | structure description | no |
| Input File Handling | 423 | canonical rule (restated) | claims to mirror workspace |
| Commit Rules | 163 | canonical rule (restated) | claims to mirror workspace |
| Compaction | 191 | mixed (project + generic) | no |
| Session Boundaries | 14 | canonical rule (verbatim dup) | pointer to `docs/session-boundaries.md` |

### Workspace CLAUDE.md (rough; audited separately)

| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | 40 | orientation | no |
| Projects | 90 | orientation | no |
| Axcíon's Tool Ecosystem | 72 | orientation | no |
| Cross-Model Rules | 52 | rule + pointer | doc |
| Skill Library | 72 | bright-line | no |
| AI Resource Creation | 65 | rule + pointer | doc |
| Placement Discipline | 234 | rule | log |
| Design Judgment Principles | 59 | rule + pointer | doc |
| QC Independence Rule | 169 | rule + pointer | doc |
| Contract-Conformance Check | 182 | rule | no |
| Blind-Spot Scan Gate | 195 | rule | no |
| Assumptions Gate | 91 | rule | no |
| Completion Standard | 72 | rule | no |
| Requirements-Doc Default | 169 | rule | no |
| Working Principles | 338 | rule cluster + pointers | docs |
| Chat Communication Style | 117 | rule | no |
| File Write Discipline | 33 | rule + pointer | doc |
| Autonomy Rules | 195 | bright-line list + pointer | doc |
| Decision-Point Posture | 156 | bright-line | no |
| QC → Triage Auto-Loop | 20 | pointer | doc |
| Session Guardrails | 143 | rule + pointer | doc |
| Plan Mode Discipline | 59 | rule + pointer | doc |
| CLAUDE.md Scoping | 72 | meta-rule | no |
| Model Tier | 208 | bright-line | doc |
| Model Escalation | 143 | rule + pointer | doc |
| Adaptive Thinking Override | 39 | rule | no |
| File verification and git commits (+H3s) | 338 | bright-line cluster | doc |
| Delivery | 33 | rule | no |
| Agent Harness | 59 | rule | `@.claude/references/harness-rules.md` |

## Tier 1 — Token Cost

**[HIGH] Input File Handling · project · ~423 tokens (15.7% of file — boundary).**
Largest block in the file. Six detailed sub-bullets (Default-to-Read, do-not-materialize, do-not-co-locate, outputs-are-different, save-verbatim, exception-copying) plus a mirror-justification paragraph. Applies only on turns that ingest operator-supplied input files — well under 25% of turns for a voice/messaging authoring project whose typical turn is synthesis or drafting. The full methodology already exists lazy-loaded at `ai-resources/docs/file-write-discipline.md` (the workspace keeps only a 33-token pointer to it). This is a prose expansion of a doc that is meant to load on demand. Cost lens confirms the Tier 2/Tier 5 verdict.

**[MEDIUM] Organizing Framework · project · ~294 tokens (10.9% of file).**
Orientation/sequencing context (four-part sequence, dependency rationale, method anchors). Relevant at planning and checkpoint boundaries, not on every drafting turn (<50%). Contains a within-block near-verbatim repeat: line 9 ("messaging (A) must be written in an established voice, but per-channel voice examples (B Layer 2) cannot be written until real messaging exists") is restated almost word-for-word in the line-20 Rationale ("Messaging must be written in an established voice; per-channel voice examples cannot be written until the messaging exists"). The sequence is also documented in the frozen `pipeline/` project-plan (see Tier 5). Compressible to a short orientation + pointer.

## Tier 2 — Redundancy

**[HIGH] Commit Rules · project ↔ workspace "Commit behavior"/"Push behavior" ↔ ai-resources/CLAUDE.md "Commit Rules" — triple duplication.**
Project quote: *"Commit directly. Do not ask for permission... Do NOT push after committing. Pushes are batched until session end and gated by a single operator confirmation at /wrap-session."* Workspace `## File verification and git commits → Commit behavior`: *"Commit directly. Do not ask for permission, do not run pre-commit checks..."* plus `Push behavior` with the identical gated-push semantics. The same rule also lives in ai-resources/CLAUDE.md `## Commit Rules`. The project block itself states it "mirrors the canonical Commit behavior and Push behavior sections in the workspace-level CLAUDE.md." Three copies of one rule = triple context cost and divergence risk. The workspace is the canonical home.

**[HIGH] Session Boundaries · project ↔ workspace "Working Principles → Session boundaries" — verbatim duplication.**
Project (line 161): *"Prefer /clear over dirty context when switching tasks. Full rule: ai-resources/docs/session-boundaries.md."* Workspace (line 98): *"Session boundaries. Prefer /clear over dirty context when switching tasks. Full rule: ai-resources/docs/session-boundaries.md."* Identical rule and identical pointer, with no project-specific content. This is not even a differentiated pointer — it is the same pointer repeated.

**[HIGH] Input File Handling · project ↔ workspace "File Write Discipline" (+ canonical doc).**
Workspace keeps a 33-token pointer: *"Input files are read-only references — use Read, never Write/Edit against them. Full write-discipline rules: ai-resources/docs/file-write-discipline.md."* The project block restates the full 423-token methodology instead of pointing. This directly violates the workspace's own `CLAUDE.md Scoping` rule ("Canonical workspace rules. Short pointer is acceptable; verbatim duplication is not"). See also Tier 4 — the block's mirror-claim is inaccurate.

**Rationale defect common to the three HIGH duplications:** All three blocks justify duplication with *"projects are sometimes opened without the parent workspace context loaded."* Per the launch instructions and the external guidance, workspace-root CLAUDE.md loads via ancestor-walk from any cwd inside the workspace tree (the guidance notes this is the normal load path; only `--add-dir` roots such as ai-resources skip auto-load). `projects/marketing-positioning/` is inside the workspace tree, so the parent CLAUDE.md is an ancestor and loads normally. The stated rationale does not hold for this project, so the duplication buys context cost and divergence risk with no offsetting safety.

**[MEDIUM] Model Selection · project ↔ workspace "Model Tier" — partial restatement.**
The project's second sentence restates the prohibition verbatim in substance (*"Do not declare a 'model' field in any .claude/settings.json... and do not state a default model in this CLAUDE.md"*) while already carrying the pointer *"(see workspace CLAUDE.md § Model Tier)."* The recommended-posture paragraph is explicitly sanctioned by the workspace ("Project-level CLAUDE.md may include a Model Selection section describing the project's recommended posture"), so keep that; the prohibition restatement is the redundant half.

**[MEDIUM] Compaction · project ↔ workspace/global compaction guidance — partial restatement.**
The "Post-compact resumption — trust the summary" paragraph (line 157) restates a canonical/global rule that also lives in `ai-resources/docs/compaction-protocol.md` (pointed to by workspace Working Principles) and in the user's persistent memory. The project-specific preserve list (pipeline/stage identifier, active working directory, pending operator gate) is legitimate and project-specific; the generic resumption paragraph is the redundant part.

**[MEDIUM] Within-file — Checkpoints ↔ Autonomy Posture & Decision Gates (decision-gate restatement).**
Autonomy Posture enumerates the tier-C gates (W2.3 wedge, W2.5 spearhead) and the soft free-model-elevation gate. Checkpoints restates them: *"are the W2.3 and W2.5 operator decisions made? (2) Soft gate: surface the deferred free-model elevation decision."* One canonical location should own the gate list; the other should reference it.

**[MEDIUM] Within-file — Voice-Authoring Discipline ↔ Checkpoints (§4.5 check restatement).**
Voice-Authoring Discipline (line 49): *"The §4.5-floor-contradiction check rides inside a /qc-pass scope line at Checkpoint A."* Checkpoints (line 95): *"The §4.5-floor-contradiction check runs here as a /qc-pass scope line."* Same rule stated twice.

**[MEDIUM] Within-file — Directory Layout repeats facts owned by other blocks.**
Directory Layout re-asserts *"embedded-consultant.md (the persona; loaded at the top of every work unit)"* (owned by Embedded Consultant) and *"method-notes.md (capped byproduct)"* (owned by Method-Notes Byproduct). Minor within-file echo.

## Tier 3 — Contradictions

**None found.** The project's tier-C operator-decision gates and its "surface the question for Patrik/Daniel" instructions coexist cleanly with the workspace Decision-Point Posture ("pick and proceed"): the workspace posture governs implementation/approach choices, while the project reserves a small, explicitly enumerated set of strategic brand decisions for the operator — a pattern the workspace Autonomy Rules and Assumptions Gate already accommodate. The Cross-Project Deferred Writes "must never fire silently" rule is consistent with the tier-C gating. No commit-behavior, autonomy, or scope contradictions detected within the project file or across the two files.

## Tier 4 — Staleness

**[MEDIUM] Input File Handling — inaccurate cross-reference.**
Line 138 states the block *"mirrors the canonical Input File Handling section in the workspace-level CLAUDE.md."* The workspace file has **no section named "Input File Handling"** — the corresponding section is `## File Write Discipline`, and it is a 33-token pointer, not a full-methodology section. A maintainer following this claim would look for a workspace section that does not exist and would wrongly assume the two are kept in sync at equal length. Reference should be corrected to point at `## File Write Discipline` / the doc.

**[LOW] What This Project Is — forward-reference maintenance note.**
*"superseding the (non-existent) corporate-identity/tone-of-voice.md slot"* embeds a point-in-time status ("(non-existent)") that will silently go stale the moment that slot is created (which W4.3 in this very file schedules). Status parentheticals in always-loaded prose are a known staleness vector; the fact is better carried as an HTML comment (free, per guidance) or dropped.

## Tier 5 — Misplacement

Per workspace `## CLAUDE.md Scoping`: project CLAUDE.md is for *"cross-session project-specific rules only — content that applies to every turn... and cannot live elsewhere,"* and explicitly must NOT hold workflow methodology (→ reference docs) or verbatim canonical workspace rules (→ short pointer).

**[HIGH] Input File Handling · ~423 tokens (>300).**
Canonical workspace rule restated at full length. Belongs as a short pointer to `ai-resources/docs/file-write-discipline.md`. Move target: replace with a ~30-token pointer. (Source: external guidance — "Pointer-not-restatement" and "Methodology in the always-loaded file"; matches workspace's own Scoping rule.)

**[MEDIUM] Commit Rules · ~163 tokens.**
Canonical workspace rule restated. Move target: short pointer to workspace `## File verification and git commits`. (Source: external guidance — "Verbatim duplication across files/layers.")

**[MEDIUM] Session Boundaries · ~14 tokens.**
Non-project-specific workspace rule. Move target: delete (loads via ancestor-walk).

**[MEDIUM] Checkpoints · ~164 tokens — workflow/stage methodology.**
Stage-gate criteria explicitly tagged *"(project-plan §8)"* — i.e., this restates a section of the frozen `pipeline/` project-plan. Per Scoping, stage/checkpoint methodology belongs in the workflow's reference docs, not the always-loaded file, and applies only at three specific stage boundaries (<25% of turns). Move target: `projects/marketing-positioning/reference/stage-instructions.md` (or rely on the frozen `pipeline/` project-plan) with a short standing pointer in CLAUDE.md.

**[MEDIUM] Organizing Framework · ~294 tokens — pipeline methodology.**
Four-part sequence + dependency rationale + method anchors is orientation for the frozen pipeline, not an every-turn rule. Move target: `reference/` or the frozen `pipeline/` project-plan; keep a 2–3 line orientation in CLAUDE.md. (Also flagged Tier 1.)

**[MEDIUM] Method-Notes Byproduct · ~91 tokens — applies <25% of turns.**
A byproduct-capture discipline relevant only on turns that write method notes. Move target: header of `reference/method-notes.md` + a one-line pointer. (Source: external guidance — "Skills/path-scoped rules for sometimes-relevant workflows.")

**[MEDIUM] Cross-Project Deferred Writes · ~192 tokens — execution-time, <25% of turns.**
Content fires only at W3.1 and W4.3 (execution time), so by the lazy-load guideline it is a reference-doc candidate. However the block's own rationale — naming the two actions in the always-loaded file so they are "never silently omitted or silently executed" — is a legitimate safety argument, and one action is a declared "breaking violation" if mishandled. Verdict: **Trim** (compress the prose ~30%) rather than full Move; retain the two named actions as a standing safety guard. Flagged so the operator can weigh lazy-load savings vs. the anti-omission guarantee.

**[MEDIUM] Directory Layout · ~104 tokens — partly inferable structure description.**
External guidance flags repo-structure descriptions as content Claude can infer from the tree. The non-obvious lines are worth keeping (`reference/` loaded on-demand not @imported; `pipeline/` frozen, not modified during authoring); the rest is inferable or duplicated (see Tier 2). Move target: Trim to the non-obvious lines.

## Tier 6 — Clarity

**[LOW] Method-Notes Byproduct — unquantified cap.**
*"Cap (hard): keep it minimal — grounding hygiene only... If it starts expanding, move the content..."* "Minimal" and "starts expanding" state a preference without a bright-line threshold (e.g., a word or line ceiling). A hard cap that fires reliably needs a number; as written it is advisory prose doing a threshold's job.

**[LOW] AI-as-Substrate Rule — soft trigger, self-resolving.**
*"When unsure whether a difference should be foregrounded, default to keeping AI as substrate and surface the question."* "When unsure" is an unspecified condition, but the stated default (keep as substrate + surface) resolves the ambiguity in practice. Minor; keep-as-is is acceptable.

**[LOW] "(non-existent)" status parenthetical** — see Tier 4 LOW; also reads as a clarity wrinkle (a rule that references a slot it says does not exist).

## Per-Block Verdict Table

### Project CLAUDE.md

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Project Is | project | 124 | Keep | Project-specific orientation; concise. Drop the "(non-existent)" parenthetical (Tier 4). | — | priors |
| Organizing Framework | project | 294 | Trim/Move | Pipeline methodology duplicating frozen project-plan; within-block repeat (line 9 ≈ line 20); <50% turns. | `reference/` or `pipeline/` project-plan + short pointer | guidance: methodology-in-always-loaded |
| Channel-Copy Ownership Boundary | project | 101 | Keep | Load-bearing project seam rule (A=content, B=voice); concise. | — | priors |
| AI-as-Substrate Rule | project | 74 | Keep | Core positioning bright-line; every-turn relevant to messaging. | — | priors |
| Voice-Authoring Discipline | project | 195 | Trim | Keep flag-gaps/never-invent + escalation; drop §4.5-check restatement duplicated in Checkpoints. | — | priors |
| Embedded Consultant | project | 111 | Keep | Loaded every work-unit; project-specific lens. Minor trimmable prose. | — | priors |
| Reference-Input Map | project | 96 | Trim | Keep source-map authority + two labeled placeholders; drop the "read-only... never copied" clause dup'd from Input File Handling. | — | priors |
| Method-Notes Byproduct | project | 91 | Move | Applies <25% of turns; byproduct-capture discipline. | `reference/method-notes.md` header + pointer | guidance: sometimes-relevant → on-demand |
| Autonomy Posture & Decision Gates | project | 181 | Keep/Trim | Standing operating-mode rule (tier-B/C); dedup the gate list against Checkpoints (own it here). | — | priors |
| Checkpoints | project | 164 | Move | Stage-gate methodology tagged "(project-plan §8)"; <25% turns. | `reference/stage-instructions.md` or `pipeline/` + pointer | guidance: methodology-in-always-loaded; workspace Scoping |
| Cross-Project Deferred Writes | project | 192 | Trim | Compress prose; retain two named actions as anti-silent-omission safety guard. | — (retain, compress) | priors |
| Model Selection | project | 107 | Trim | Keep recommended posture (workspace-sanctioned) + pointer; drop the prohibition restatement. | — | guidance: verbatim duplication |
| Directory Layout | project | 104 | Trim | Keep non-obvious lines; drop inferable/duplicated structure facts. | — | guidance: don't duplicate inferable structure |
| Input File Handling | project | 423 | Move | Full canonical rule restated (>300 tok); duplicates lazy-loaded doc; inaccurate mirror-claim. | pointer → `ai-resources/docs/file-write-discipline.md` | guidance: pointer-not-restatement; workspace Scoping |
| Commit Rules | project | 163 | Move | Triple-duplicated canonical rule; ancestor-walk defeats the stated rationale. | pointer → workspace `File verification and git commits` | guidance: verbatim duplication |
| Compaction | project | 191 | Trim | Keep project-specific preserve list; replace generic "trust the summary" para with pointer. | pointer → `ai-resources/docs/compaction-protocol.md` | guidance: verbatim duplication |
| Session Boundaries | project | 14 | Delete | Verbatim non-project workspace rule; loads via ancestor-walk. | delete | guidance: verbatim duplication; workspace Scoping |

### Workspace CLAUDE.md (audited separately — listed for completeness)

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | 40 | Keep | Audited separately. | — | n/a |
| Projects | workspace | 90 | Keep | Audited separately. | — | n/a |
| Axcíon's Tool Ecosystem | workspace | 72 | Keep | Audited separately. | — | n/a |
| Cross-Model Rules | workspace | 52 | Keep | Audited separately. | — | n/a |
| Skill Library | workspace | 72 | Keep | Audited separately. | — | n/a |
| AI Resource Creation | workspace | 65 | Keep | Audited separately. | — | n/a |
| Placement Discipline | workspace | 234 | Keep | Audited separately. | — | n/a |
| Design Judgment Principles | workspace | 59 | Keep | Audited separately. | — | n/a |
| QC Independence Rule | workspace | 169 | Keep | Audited separately. | — | n/a |
| Contract-Conformance Check | workspace | 182 | Keep | Audited separately. | — | n/a |
| Blind-Spot Scan Gate | workspace | 195 | Keep | Audited separately. | — | n/a |
| Assumptions Gate | workspace | 91 | Keep | Audited separately. | — | n/a |
| Completion Standard | workspace | 72 | Keep | Audited separately. | — | n/a |
| Requirements-Doc Default | workspace | 169 | Keep | Audited separately. | — | n/a |
| Working Principles | workspace | 338 | Keep (canonical) | Canonical home for project Session Boundaries dup + Compaction pointer. | — | n/a |
| Chat Communication Style | workspace | 117 | Keep | Audited separately. | — | n/a |
| File Write Discipline | workspace | 33 | Keep (canonical) | Canonical home for project Input File Handling. | — | n/a |
| Autonomy Rules | workspace | 195 | Keep | Audited separately. | — | n/a |
| Decision-Point Posture | workspace | 156 | Keep | Audited separately; no conflict with project tier-C gates. | — | n/a |
| QC → Triage Auto-Loop | workspace | 20 | Keep | Audited separately. | — | n/a |
| Session Guardrails | workspace | 143 | Keep | Audited separately. | — | n/a |
| Plan Mode Discipline | workspace | 59 | Keep | Audited separately. | — | n/a |
| CLAUDE.md Scoping | workspace | 72 | Keep | Meta-rule that drives most project Tier 5 findings. | — | n/a |
| Model Tier | workspace | 208 | Keep (canonical) | Canonical home for project Model Selection prohibition. | — | n/a |
| Model Escalation | workspace | 143 | Keep | Audited separately. | — | n/a |
| Adaptive Thinking Override | workspace | 39 | Keep | Audited separately. | — | n/a |
| File verification and git commits (+H3s) | workspace | 338 | Keep (canonical) | Canonical home for project Commit Rules. | — | n/a |
| Delivery | workspace | 33 | Keep | Audited separately. | — | n/a |
| Agent Harness | workspace | 59 | Keep | Audited separately. | — | n/a |

## Estimated Savings

Consolidated per-block (each block counted once at its best verdict):

| Block | Now | After | Saved |
|---|---|---|---|
| Input File Handling | 423 | ~30 (pointer) | ~393 |
| Organizing Framework | 294 | ~120 | ~170 |
| Commit Rules | 163 | ~30 (pointer) | ~133 |
| Checkpoints | 164 | ~60 | ~100 |
| Compaction | 191 | ~90 | ~100 |
| Cross-Project Deferred Writes | 192 | ~130 | ~60 |
| Directory Layout | 104 | ~55 | ~50 |
| Method-Notes Byproduct | 91 | ~40 | ~50 |
| Model Selection | 107 | ~60 | ~45 |
| Session Boundaries | 14 | 0 (delete) | ~14 |
| **Total** | | | **~1,115** |

- Per turn: ~1,100 tokens (HIGH-only ≈ ~540)
- Per 30-turn session: ~33,000 tokens
- Per 50-turn session: ~55,000 tokens
- Breakdown by tier (primary attribution, no double-count): Tier 1 token cost ~563 (Input File Handling, Organizing Framework); Tier 2 redundancy ~292 (Commit Rules, Compaction, Model Selection, Session Boundaries); Tier 5 misplacement ~260 (Checkpoints, Directory Layout, Method-Notes, Cross-Project Deferred Writes). Tiers 3/4/6 are correctness/clarity — negligible token yield.

Note on the savings model: CLAUDE.md occupies the always-loaded budget for the life of the session, so per-turn figures follow the agent-spec convention (N tokens × turns) rather than implying the file is re-sent each turn.

## External Guidance Cited

- **Pointer-not-restatement / methodology in the always-loaded file** — External Guidance Synthesis 2026-07-03, "Identified best practices" and "Identified anti-patterns"; drives Tier 5 verdicts on Input File Handling, Commit Rules, Organizing Framework, Checkpoints, Method-Notes. (Official docs: code.claude.com/docs/en/memory; HumanLayer blog.)
- **Verbatim duplication across files/layers** — Synthesis "Identified anti-patterns" (Severity MEDIUM–HIGH; "if two rules contradict, Claude may pick one arbitrarily"); drives Tier 2 HIGH duplication findings.
- **Ancestor-walk / `--add-dir` load behavior** — Synthesis "Notes specific to long-context models"; used to rebut the three duplicated blocks' "opened without parent workspace context" rationale.
- **Don't duplicate what the model can infer** — Synthesis "Identified anti-patterns"; drives Directory Layout Trim.
- **Deletion test + <200-line target** — Synthesis "Identified best practices"; frames the net verdict (project file's ~28% restated/pipeline content fails "would removing this cause a mistake?").
- **HTML comments are free** — Synthesis "Identified best practices"; offered as the zero-cost home for the "(non-existent)" status note (Tier 4 LOW).
