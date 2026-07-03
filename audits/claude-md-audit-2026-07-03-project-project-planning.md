# CLAUDE.md Audit — 2026-07-03

**Scope:** workspace + project (project = `project-planning`). Findings weighted toward the PROJECT file and cross-file redundancy per the invocation; the workspace file's own internal findings are covered by a separate committed workspace audit and are NOT re-adjudicated here (workspace blocks appear in the verdict table marked accordingly).

**Files audited:**
- Workspace: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — ~230 lines, ~3,500 tokens (context only; loaded in project sessions via ancestor-walk)
- Project: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/project-planning/CLAUDE.md` — 108 lines, ~2,370 tokens

**Token-estimation caveat:** Counts are word × 1.3, ±30% drift vs. real tokenizer. No NOTES_PATH/measurements file was supplied, so all counts are auditor estimates. Findings within ±15% of a threshold are tagged `(boundary)`.

**Key structural fact (drives the redundancy tier):** the invocation confirms the workspace CLAUDE.md loads in every project-planning session via ancestor-walk. So the project file's three "repeated here because projects are sometimes opened without the parent workspace context loaded" defensive-duplication blocks (Commit Rules, Input File Handling, and — implicitly — Session Boundaries) duplicate content that is *already loaded on the same turn*. The defensive justification does not hold for this project's session topology, which converts those restatements from safety copies into pure always-loaded redundancy.

## Executive Summary

- Total findings: HIGH: 4 / MEDIUM: 4 / LOW: 2
- Projected token savings if all HIGH+MEDIUM applied: ~900 tokens/turn (~27,000 tokens/session at 30 turns; ~45,000 at 50 turns — CLAUDE.md is always-loaded, so savings recur every turn)
- Net verdict: The project file is within the 200-line size target but is heavily padded with (a) two blocks of intake-selection *workflow methodology* that belong in reference docs and (b) three defensive restatements of canonical workspace/doc rules that ancestor-walk already loads — trimming these to pointers roughly halves the file with zero loss of enforceable rule content.

## Per-File Inventory

### Workspace CLAUDE.md (context only — separate audit owns its internal findings)
| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| What This Workspace Is For | ~30 | orientation | no |
| Projects | ~70 | orientation | no |
| Axcíon's Tool Ecosystem | ~70 | orientation | no |
| Cross-Model Rules | ~40 | pointer + rule | doc |
| Skill Library | ~70 | bright-line | no |
| AI Resource Creation | ~70 | bright-line + pointer | doc |
| Placement Discipline | ~230 | rule + triggers | no |
| Design Judgment Principles | ~60 | rule + pointer | doc |
| QC Independence Rule | ~180 | rule + pointer | doc |
| Contract-Conformance Check | ~180 | rule + triggers | no |
| Blind-Spot Scan Gate | ~200 | rule | no |
| Assumptions Gate | ~80 | rule | no |
| Completion Standard | ~80 | rule | no |
| Requirements-Doc Default | ~170 | rule | no |
| Working Principles | ~360 | rules (bulleted) | doc |
| Chat Communication Style | ~150 | rule | no |
| File Write Discipline | ~40 | pointer | doc |
| Autonomy Rules | ~210 | bright-line list | doc |
| Decision-Point Posture | ~180 | rule | no |
| QC → Triage Auto-Loop | ~30 | pointer | doc |
| Session Guardrails | ~180 | rule | doc |
| Plan Mode Discipline | ~60 | pointer + rule | doc |
| CLAUDE.md Scoping | ~110 | rule | no |
| Model Tier | ~230 | bright-line | doc |
| Model Escalation | ~150 | rule | doc |
| Adaptive Thinking Override | ~40 | rule | no |
| File verification and git commits (+4 H3) | ~380 | bright-line | doc |
| Delivery | ~30 | rule | no |
| Agent Harness | ~60 | rule | @-ref |

### Project CLAUDE.md (`project-planning`)
| Block | ~Tokens | Type | @-refs |
|---|---|---|---|
| Purpose | ~65 | orientation | no |
| How It Works | ~650 | workflow methodology | no (names commands/docs) |
| Commands | ~260 | reference table | no |
| Output Convention | ~65 | convention | no |
| Reference Documents | ~52 | pointer list | no |
| Skill References | ~58 | pointer list | no |
| Versioning | ~52 | rule | no |
| Relationship to /new-project | ~72 | orientation | no |
| Model Selection | ~143 | posture + pointer | no |
| Commit Rules | ~260 | rule (mirrored) + symlink caveat | no |
| Input File Handling | ~500 | rule (mirrored doc) | no |
| Compaction | ~170 | rule + resumption prose | no |
| Session Boundaries | ~20 | pointer (duplicate) | doc |

## Tier 1 — Token Cost

**F1 [HIGH] — How It Works · project · ~650 tokens = ~27% of file.** The block is a numbered orientation list (lines 9–13) plus two ~180–200-word prose paragraphs (lines 15, 17) that are a decision tree for choosing among `/context-builder`, `/requirements-pack`, and `/scope-project`. The two prose paragraphs are a long explanatory argument, not a per-turn rule, and the intake choice is made once per new planning project (Stage 1) — it applies to well under 25% of turns while consuming the single largest slice of the file. Meets the HIGH bar on two counts: >15% of file tokens with <25%-turn applicability, and "long prose argument that could compress." (See also Tier 5 — this is misplaced methodology.)

**F2 [HIGH] — Input File Handling · project · ~500 tokens = ~21% of file.** Six-bullet expansion (co-location, materialize-chat, operator-pasted save-verbatim, legitimate-copying exception) that the block itself says "mirrors the canonical Input File Handling section in the workspace-level CLAUDE.md." The canonical content lives in `ai-resources/docs/file-write-discipline.md` (the workspace's `File Write Discipline` block is a one-line pointer to it). This block duplicates lazy-loadable reference content into the always-loaded layer — the exact HIGH trigger "duplicates content available in a lazy-loaded reference/skill file." The core enforceable rule ("default to `Read` on inputs; never Write/Edit an input") is one sentence; the remaining ~440 tokens are elaboration that need not always-load.

**F3 [MEDIUM] — Commit Rules · project · ~260 tokens = ~11%.** Restates the workspace commit + push behavior in full prose where a pointer would serve. The one genuinely project-specific, non-obvious element is the "Staging through the `output` symlink" caveat (`git add` refuses symlink-traversing pathspecs) — that earns its place. The surrounding commit/push prose is verbose restatement (see Tier 2 F5).

## Tier 2 — Redundancy

**F4 [HIGH] — Session Boundaries (project) ↔ Working Principles § Session boundaries (workspace).** Verbatim cross-file duplicate. Project line 108: "Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`." Workspace line 98: "**Session boundaries.** Prefer `/clear` over dirty context when switching tasks. Full rule: `ai-resources/docs/session-boundaries.md`." Identical pointer, both loaded on the same turn via ancestor-walk. HIGH (spans files). Passes the deletion test — removing the project copy causes no behavior change.

**F5 [HIGH] — Commit Rules (project) ↔ File verification and git commits § Commit behavior + Push behavior (workspace).** The project block is an explicit self-declared mirror ("This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`"). Same substance: commit directly, no permission ask, no pre/post git checks, push batched-and-gated to wrap, remind `/wrap-session`, never commit secrets. Given ancestor-walk always loads the workspace canonical on the same turn, this is duplicated always-loaded weight and a divergence-drift hazard (if the workspace push rule changes, this copy silently goes stale → Tier 3 contradiction risk). HIGH. Keep only the symlink-staging caveat.

**F6 [HIGH] — Input File Handling (project) ↔ File Write Discipline (workspace) + `file-write-discipline.md`.** Same rule family stated in three places: the workspace pointer, the canonical doc, and this 500-token project restatement. HIGH (spans files/layers). Consolidate to the pointer already sanctioned by the workspace `CLAUDE.md Scoping` rule.

**F7 [MEDIUM] — Model Selection (project) prohibition sentence ↔ Model Tier (workspace).** Project line 68 restates the "do not declare a `model` field / do not state a default model" prohibition *and* points to the workspace rule for the rationale. The restatement is redundant with the canonical (and non-negotiable) workspace Model Tier block; the pointer alone suffices. The *recommended-posture* paragraph (line 70) is explicitly permitted by workspace Model Tier and should stay. MEDIUM. Verdict Trim (keep posture, drop prohibition restatement).

**F8 [MEDIUM] — Compaction (project) "Post-compact resumption — trust the summary" (lines 104) ↔ workspace Working Principles § Compaction protocol + auto-memory "Trust the compaction summary."** The trust-the-summary / don't-re-derive-via-git-log guidance is canonical elsewhere (workspace compaction-protocol pointer and the persisted memory note). The *project-specific* preservation list (pipeline/stage identifier, unread subagent-output paths, pending operator gate) is genuinely local and worth keeping. MEDIUM. Verdict Trim the resumption paragraph to a pointer; keep the preservation list.

**F9 [MEDIUM] — Versioning (project) ↔ Working Principles § versioning bullet (workspace).** Partial cross-file duplicate. Workspace line 96: "create a new version file rather than overwriting — `v2.md` alongside `v1.md`." Project lines 58–59 restate the same no-overwrite rule; the only project-specific addition is "the latest version that passes QC is the approved version." MEDIUM (substance partly equivalent, spans files). Verdict Trim to the QC-approval semantics.

**LOW (within-file note) — Commands table ↔ How It Works numbered list (project).** The Commands table (lines 21–32) and the How It Works sequence (lines 9–13) both enumerate the pipeline commands. Overlap is light and the two serve different purposes (lookup vs. sequence), so not a formal MEDIUM — noted for the operator. Covered in LOW-2 below.

## Tier 3 — Contradictions

None found. The project file is directionally consistent with the workspace on autonomy, commit/push, model policy, and compaction. The only *latent* contradiction risk is drift: F5/F6/F7/F9 are restatements that would silently contradict the canonical if the workspace/doc changes and the copy is not updated. That is a redundancy-driven hazard (already filed under Tier 2), not a present contradiction.

## Tier 4 — Staleness

**F10 [MEDIUM] — Input File Handling stale cross-reference (project, lines 93).** The block asserts it "mirrors the canonical **Input File Handling** section in the workspace-level `CLAUDE.md`." The workspace `CLAUDE.md` has no section by that name — the corresponding block is titled **File Write Discipline** (a one-line pointer to `ai-resources/docs/file-write-discipline.md`), and the substantive canonical content is the doc, not a workspace section. The pointer names a target that does not exist as described, so a maintainer following it lands nowhere. Stale/broken cross-reference. MEDIUM (folded into the F6 consolidation — fixing F6 removes this).

**Multi-front-door intake staleness check (per invocation) — no staleness found.** `/context-builder`, `/requirements-pack`, and `/scope-project` are all described as active, with `/scope-project` canonical in `ai-resources/` and `/create-requirements-doc` consistently marked *(planned)* in both the project and workspace files. No superseded phase, no dead artifact reference, no orphaned "complete/superseded" marker. The intake section's problem is bloat/misplacement (F1/Tier 5), not staleness.

## Tier 5 — Misplacement

**F11 [HIGH] — How It Works intake-selection paragraphs (project, lines 15 + 17, ~380 of the block's 650 tokens) → belongs in a reference doc.** Per workspace `CLAUDE.md Scoping`: "Workflow methodology. Belongs in the workflow's reference docs (e.g., `reference/stage-instructions.md`)." These two paragraphs are exactly that — a methodology for *which intake front door to choose* and *how each classifies requirements*. They apply only at Stage-1 intake selection (<25% of turns) and exceed 300 tokens → HIGH. Proposed target: a project `pipeline/ref-intake-selection.md` (sibling to the existing `pipeline/ref-*.md` docs), or fold into `ai-resources/skills/project-scoping/SKILL.md` for the complex-lane portion. Retain a 2–3-line pointer in `How It Works`.

**F12 [HIGH] — Input File Handling detail (project) → `ai-resources/docs/file-write-discipline.md`.** Same block as F2/F6/F10. The detailed bullets are input-handling methodology whose canonical home already exists as a lazy-loadable doc. >300 tokens → HIGH. Proposed target: consolidate into the existing doc; replace the block with the sanctioned pointer form (matches the workspace's own `File Write Discipline` pattern).

## Tier 6 — Clarity

**LOW-1 [LOW] — "Simple vs complex builds" threshold (project, line 17).** The trigger for choosing the complex `/scope-project` lane is stated as "unclear document architecture, meaningful technical/governance assumptions, or real MVP-boundary risk." "Meaningful" and "real" are unquantified modifiers — the boundary between light lane and heavy lane rests on operator judgment with no bright-line. Low impact (the block also says `/scope-project` self-scales and can recommend the light lane and stop, which softens the miss), and no evidence of drift. If this block is moved per F11, tighten the threshold in the destination doc rather than the always-loaded layer.

**LOW-2 [LOW] — Commands / How It Works overlap (project).** Light navigational redundancy between the numbered sequence and the command table; not load-bearing. Operator may keep both for readability or collapse the numbered list into a one-line pointer to the table.

## Per-Block Verdict Table

| Block | File | ~Tokens | Verdict | Rationale | Move Target | Source |
|---|---|---|---|---|---|---|
| What This Workspace Is For | workspace | 30 | Keep | Orientation; separate workspace audit owns internal findings | — | separate audit |
| Projects | workspace | 70 | Keep | Orientation; not re-adjudicated | — | separate audit |
| Axcíon's Tool Ecosystem | workspace | 70 | Keep | Not re-adjudicated | — | separate audit |
| Cross-Model Rules | workspace | 40 | Keep | Pointer form already correct | — | separate audit |
| Skill Library | workspace | 70 | Keep | Not re-adjudicated | — | separate audit |
| AI Resource Creation | workspace | 70 | Keep | Not re-adjudicated | — | separate audit |
| Placement Discipline | workspace | 230 | Keep | Not re-adjudicated | — | separate audit |
| Design Judgment Principles | workspace | 60 | Keep | Not re-adjudicated | — | separate audit |
| QC Independence Rule | workspace | 180 | Keep | Not re-adjudicated | — | separate audit |
| Contract-Conformance Check | workspace | 180 | Keep | Not re-adjudicated | — | separate audit |
| Blind-Spot Scan Gate | workspace | 200 | Keep | Not re-adjudicated | — | separate audit |
| Assumptions Gate | workspace | 80 | Keep | Not re-adjudicated | — | separate audit |
| Completion Standard | workspace | 80 | Keep | Not re-adjudicated | — | separate audit |
| Requirements-Doc Default | workspace | 170 | Keep | Not re-adjudicated | — | separate audit |
| Working Principles | workspace | 360 | Keep (canonical) | Canonical home for versioning + session-boundaries + compaction bullets the project duplicates (F4/F8/F9) — keep; trim the project copies | — | separate audit |
| Chat Communication Style | workspace | 150 | Keep | Not re-adjudicated | — | separate audit |
| File Write Discipline | workspace | 40 | Keep (canonical) | Correct pointer form; project's Input File Handling should collapse to this shape | — | guidance: pointer-not-restatement |
| Autonomy Rules | workspace | 210 | Keep | Not re-adjudicated | — | separate audit |
| Decision-Point Posture | workspace | 180 | Keep | Not re-adjudicated | — | separate audit |
| QC → Triage Auto-Loop | workspace | 30 | Keep | Not re-adjudicated | — | separate audit |
| Session Guardrails | workspace | 180 | Keep | Not re-adjudicated | — | separate audit |
| Plan Mode Discipline | workspace | 60 | Keep | Not re-adjudicated | — | separate audit |
| CLAUDE.md Scoping | workspace | 110 | Keep (canonical) | The scoping rule the project's F11/F12/F6 misplacements violate | — | separate audit |
| Model Tier | workspace | 230 | Keep (canonical) | Canonical model-policy; project Model Selection prohibition restatement (F7) is the redundant copy | — | separate audit |
| Model Escalation | workspace | 150 | Keep | Not re-adjudicated | — | separate audit |
| Adaptive Thinking Override | workspace | 40 | Keep | Not re-adjudicated | — | separate audit |
| File verification and git commits (+H3) | workspace | 380 | Keep (canonical) | Canonical commit/push behavior; project Commit Rules (F5) is the redundant copy | — | separate audit |
| Delivery | workspace | 30 | Keep | Not re-adjudicated | — | separate audit |
| Agent Harness | workspace | 60 | Keep | Not re-adjudicated | — | separate audit |
| Purpose | project | 65 | Keep | Concise, project-specific orientation | — | priors |
| How It Works | project | 650 | Move/Trim | Numbered sequence stays; two intake-selection prose paragraphs are misplaced methodology (F1/F11) | `projects/project-planning/pipeline/ref-intake-selection.md` or `ai-resources/skills/project-scoping/SKILL.md` | guidance: methodology-in-always-loaded |
| Commands | project | 260 | Keep | Project-specific command map; every session uses it. Optionally collapse the How It Works numbered list into this (LOW-2) | — | priors |
| Output Convention | project | 65 | Keep | Project-specific artifact naming; applies broadly | — | priors |
| Reference Documents | project | 52 | Keep | Pointer list; correct form | — | priors |
| Skill References | project | 58 | Keep | Pointer list; correct form | — | priors |
| Versioning | project | 52 | Trim | Drop generic no-overwrite restatement (workspace-canonical, F9); keep "latest QC-passed = approved" | workspace Working Principles (canonical) | guidance: verbatim-duplication |
| Relationship to /new-project | project | 72 | Keep | Project-specific handoff context; not covered elsewhere | — | priors |
| Model Selection | project | 143 | Trim | Keep recommended-posture (explicitly permitted); drop prohibition restatement (F7) | workspace Model Tier (canonical) | guidance: verbatim-duplication |
| Commit Rules | project | 260 | Trim | Keep the `output`-symlink `git add` caveat (project-specific, non-obvious); reduce mirrored commit/push prose to a pointer (F5) | workspace File verification and git commits (canonical) | guidance: pointer-not-restatement |
| Input File Handling | project | 500 | Move/Trim | Collapse to a one-line pointer; detail belongs in the canonical doc (F2/F6/F10/F12); fix the broken "Input File Handling section" cross-reference | `ai-resources/docs/file-write-discipline.md` | guidance: methodology-in-always-loaded |
| Compaction | project | 170 | Trim | Keep project-specific preservation list; drop "trust the summary" resumption paragraph (F8) | workspace compaction-protocol pointer (canonical) | guidance: verbatim-duplication |
| Session Boundaries | project | 20 | Delete | Verbatim duplicate of workspace bullet, loaded same turn via ancestor-walk (F4); fails the deletion test | workspace Working Principles (canonical) | guidance: deletion-test |

## Estimated Savings

Savings are per-block (each block counted once; multi-tier findings do not double-count):

- How It Works (Move/Trim intake paragraphs to reference doc, keep sequence + pointer): ~−300 tokens/turn
- Input File Handling (collapse to pointer, keep core one-liner): ~−400 tokens/turn
- Commit Rules (pointer + keep symlink caveat): ~−150 tokens/turn
- Compaction (drop resumption paragraph): ~−50 tokens/turn
- Model Selection (drop prohibition restatement): ~−40 tokens/turn
- Session Boundaries (delete): ~−20 tokens/turn
- Versioning (trim to QC-approval semantics): ~−15 tokens/turn

**Per turn: ~900 tokens** (sum ≈ 975; rounded down for ±30% estimation drift → ~900). This is ~38% of the project file's ~2,370-token always-loaded weight, recovered on every turn with no loss of enforceable rule content (all trimmed material is either canonical elsewhere and ancestor-walk-loaded, or relocated to a lazy-loadable doc).

- Per 30-turn session: ~27,000 tokens
- Per 50-turn session: ~45,000 tokens

**Breakdown by tier (net, dedup'd across overlapping findings):**
- Tier 1 (token cost, F1–F3): the same blocks as Tier 2/5; ~700 tokens attributable to compression of How It Works + Input File Handling + Commit Rules prose.
- Tier 2 (redundancy, F4–F9): ~625 tokens where the driver is cross-file/layer duplication (Session Boundaries, Commit Rules, Input File Handling, Model Selection, Compaction, Versioning).
- Tier 5 (misplacement, F11–F12): overlaps Tier 1/2 blocks (How It Works, Input File Handling) — no additional standalone savings beyond the ~700 above; the value is relocation to lazy-load rather than deletion.
- Tiers 3, 4, 6: 0 direct token savings (F10 is fixed for free as part of F6; Tier 6 is clarity-only).

## External Guidance Cited

- [G1] **Pointer-not-restatement** — a short pointer to a canonical doc is the sanctioned way to keep detail out of the always-loaded layer (external-guidance synthesis, "Identified best practices"; matches this workspace's own `CLAUDE.md Scoping` rule). Drives F3/F5/F6/F12 (Commit Rules, Input File Handling).
- [G2] **Methodology in the always-loaded file** — multi-step procedures / sometimes-relevant workflows belong in skills or path-scoped rules, not CLAUDE.md (synthesis, "Identified anti-patterns"; Severity MEDIUM). Drives F1/F11 (How It Works intake methodology).
- [G3] **Verbatim duplication across files/layers** — same rule in workspace + project + doc → double context cost and divergence/contradiction risk (synthesis, "Identified anti-patterns"; Severity MEDIUM–HIGH; official: "if two rules contradict, Claude may pick one arbitrarily"). Drives F4/F5/F6/F7/F8/F9.
- [G4] **The deletion test (official)** — "Would removing this cause Claude to make a mistake?" If not, cut (synthesis, "Identified best practices"). Drives F4 (Session Boundaries Delete).
- [G5] **@-imports do not save context** — imported files are expanded and loaded at launch; imports aid organization, not token cost (synthesis, "Identified anti-patterns"). Supports the finding that pointing to a doc only saves tokens if the content is NOT `@`-inlined — the project's pointers use plain path references (not `@`-imports), so the projected savings hold.
- [G6] **`--add-dir` / ancestor-walk loading behavior** (synthesis, "Notes specific to long-context models") — confirms workspace-root CLAUDE.md loads via ancestor-walk in project sessions, underpinning the "defensive duplication is unnecessary for this project" basis of F4/F5/F6.
