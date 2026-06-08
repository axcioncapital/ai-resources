# Risk Check — 2026-06-08

## Change

Apply the W24 always-loaded CLAUDE.md audit fixes (audit: ai-resources/audits/claude-md-audit-2026-06-08-always-loaded.md). Proposed change: (1) collapse 3 HIGH cross-file duplications in ai-resources/CLAUDE.md to pointers into the canonical workspace CLAUDE.md — Commit Rules + Git Rules push clause → pointer (keep commit-msg format), Model Selection → pointer + one bright-line, delete the duplicated Session Boundaries block; (2) compress 4 MED over-long prose blocks — relocate workspace Model Tier rationale to a new ai-resources/docs/ model-policy doc (keep bright-line + pointer), compress workspace Working Principles structural-fix bullet, trim ai-resources What This Repo Contains directory glossary, drop push/commit triple-statement from ai-resources How I Work. Goal: ~620 tokens/turn saved with no rule meaning lost.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/claude-md-audit-2026-06-08-always-loaded.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/model-policy.md — not yet present

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A token-cost reduction that consolidates duplicated rules and is fully git-reversible, but it touches the two always-loaded layers that many commands reference *by name*, and it introduces a brand-new always-loaded `@`-pointer target (`model-policy.md`) — both create modest contract-preservation risk that one mitigation each reduces to Low.

## Consumer Inventory

The change targets section headers and prose in the two always-loaded CLAUDE.md files plus a new doc. Search terms: `Commit Rules`, `Git Rules`, `Model Selection`, `Session Boundaries`, `Model Tier`, `Commit behavior`, `Push behavior` (the headers/blocks being collapsed or relocated), and `model-policy.md` (the new contract). Greps run across `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/pipeline-review.md:220` | documents (`ai-resources/CLAUDE.md § Commit Rules` by name) | no |
| `ai-resources/.claude/commands/tweak.md:117` | documents (`ai-resources/CLAUDE.md § Git Rules` by name) | no |
| `ai-resources/.claude/commands/resolve-incident.md:237` | documents (workspace commit rules, generic) | no |
| `ai-resources/.claude/commands/log-defect.md:88` | documents (workspace commit rule "at session boundaries", generic) | no |
| `ai-resources/.claude/commands/new-project.md:165,406,474,476,491` | co-edits (emits `## Commit Rules` / `## Session Boundaries` / `## Model Selection` into *project* CLAUDE.md from `templates/` fragments) | no |
| `ai-resources/.claude/commands/prime.md:114` | parses (reads project CLAUDE.md `Model Selection` section) | no |
| `ai-resources/.claude/commands/session-plan.md:73` | documents (own `## Step 2 — Model selection` heading; unrelated) | no |
| `ai-resources/.claude/commands/placement.md:40,44` | documents (routes "model tier / commit behavior" to workspace CLAUDE.md) | no |
| `ai-resources/.claude/commands/deploy-workflow.md:168` | documents (workspace `CLAUDE.md § Model Tier` by name — **kept**, not collapsed) | no |
| `ai-resources/.claude/commands/friday-checkup.md:322,416` | documents (workspace `Commit behavior` / model-tier policy — **kept**) | no |
| `ai-resources/.claude/commands/permission-sweep.md:312` | documents (workspace `Commit behavior` — **kept**) | no |
| `../.claude/hooks/model-classifier.sh:6,46` | documents (workspace `Model Tier` rule + project `Model Selection` — **kept**) | no |
| `ai-resources/docs/model-policy.md` (not yet present) | imports-target (new pointer destination for relocated workspace Model Tier rationale) | n/a — new file, no consumers yet |

Total: 12 distinct consumers, 0 must-change. The new `model-policy.md` has no consumers yet; the contract it introduces is a single pointer line that the workspace `## Model Tier` block will add.

**Key inventory finding:** every consumer that references a *collapsed* ai-resources header (`pipeline-review.md` → § Commit Rules; `tweak.md` → § Git Rules) does so in prose that survives the change — the proposal *keeps* both headers (Commit Rules → pointer body, Git Rules → keeps commit-msg format + pointer), so the `§ <header>` references still resolve. No consumer parses these headers programmatically. The one `grep -q "^## Commit Rules"` / `"^## Session Boundaries"` loop (`new-project.md:480`) operates on the **project** `$CLAUDE_MD` being scaffolded from `templates/` fragments — it never reads `ai-resources/CLAUDE.md`, so collapsing the ai-resources blocks does not affect it.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Net effect is a *reduction* in always-loaded cost — the explicit goal is ~620 tokens/turn saved (audit Executive Summary, line 15: "Projected token savings if all HIGH+MEDIUM applied: ~620 tokens/turn").
- The one cost-adding element is the new `ai-resources/docs/model-policy.md` — but it is a `docs/` pointer target, loaded only when the relocated rationale is needed, not every turn (audit line 122: "leaving an always-loaded bright-line + pointer"). Pay-as-used, not always-loaded.
- Caveat (`not yet present`): `model-policy.md` does not exist on disk; its cost profile is judged from the described intent (relocate rationale prose out of the always-loaded layer into a referenced doc). If the implementer instead `@import`s it into the always-loaded `## Model Tier` block, that would flip this to Medium — the mitigation below pins it as a plain pointer.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json / settings.local.json changes. No `allow`/`ask`/`deny` entries touched. CHANGE_DESCRIPTION is confined to two CLAUDE.md files plus one new docs file.
- Creating `ai-resources/docs/model-policy.md` is a Write within an already-established directory (`docs/` hosts process documentation per ai-resources/CLAUDE.md line 12) — within existing patterns, no new capability.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory: **12 consumers found, 0 must-change.** The change touches two *always-loaded* files (workspace + ai-resources CLAUDE.md), which is shared infrastructure read on every turn of every session — that breadth is why this is Medium rather than Low even though no consumer must change.
- The contract being preserved is the set of section-header names that prose pointers resolve against (`§ Commit Rules`, `§ Git Rules`). The change KEEPS these headers, so the references in `pipeline-review.md:220` and `tweak.md:117` stay valid. Verified: collapsing the *body* to a pointer while keeping the *header* is backwards-compatible for name-based references.
- No backwards-incompatible contract change found. The `new-project.md` scaffold loop (`grep -q "^## Commit Rules"`) reads project CLAUDE.md from `templates/` fragments, not ai-resources/CLAUDE.md — confirmed by reading `new-project.md:460-487` (operates on `$CLAUDE_MD`, the new project file).
- One inventory item the description did not name but should be checked at apply-time: `tweak.md:117` cites `ai-resources/CLAUDE.md § Git Rules` and the change trims Git Rules to "commit-msg format + push-clause pointer." If the push-clause text `tweak.md` relies on is moved behind the pointer, `tweak.md`'s reader still resolves the header but lands on a pointer rather than the full rule — acceptable (pointer chains to workspace canonical) but worth a glance.

### Dimension 4: Reversibility
**Risk:** Low

- All edits are to tracked files (`CLAUDE.md` ×2) plus one new tracked file (`model-policy.md`). `git revert` restores both CLAUDE.md files fully and removes the new doc — single working tree, no propagation beyond git.
- No data/log mutation (not an append to session-notes / innovation-registry / improvement-log). No settings cache, no hook/cron/symlink added that could fire between landing and revert.
- No external write. Per workspace push-gating rules, commits stay local until an operator-confirmed wrap push — so even the push is reversible until that gate.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Implicit dependency on an established convention: prose pointers across the repo reference these blocks **by header name** rather than by a stable ID. The change relies on the header strings staying byte-identical (`## Commit Rules`, `## Git Rules`, `## Model Selection`). The inventory confirms the change keeps them — but the coupling is real and undocumented (no block declares "this header is a named pointer target; do not rename"). Evidence: `pipeline-review.md:220` `§ Commit Rules`, `tweak.md:117` `§ Git Rules`.
- New contract introduced: the relocated workspace Model Tier rationale lives in `model-policy.md`, reachable only via a pointer the `## Model Tier` block must add. If the pointer text and the filename drift apart (e.g., doc named `model-policy.md` but pointer says `model-tier.md`), the rationale becomes unreachable. The contract is documentable at the change site (the pointer line itself) — keeping it Medium, not High.
- No silent auto-firing and no functional overlap with an existing mechanism (the change removes overlap — it collapses triple-stated push/commit rules, audit lines 103-108).
- `not yet present` note: `model-policy.md`'s coupling is judged from intent; the pointer-target contract does not exist on disk yet.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).
- **DR-5 (CLAUDE.md holds cross-session rules only; every-turn content earns its place)** — the change actively *serves* this principle: it removes prose that fails the every-turn test and pushes rationale into `docs/`. Aligned.
- **OP-12 (closure before detection)** — this is closure, not new detection: it applies findings from an existing audit and closes them. Counts *for* the change, not against.
- **DR-1 / DR-3 (placement)** — the new doc lands in `ai-resources/docs/`, the canonical home for process documentation (ai-resources/CLAUDE.md line 12). Correct tier and home.
- **GAP-3 / DR-5 exception (intentional cross-level CLAUDE.md duplication is a recognized exception)** — the audit's own rationale (line 87) argues the duplication's stated justification ("projects opened without parent context") is invalid *for the always-loaded ai-resources layer specifically*, because it loads alongside the workspace file via `--add-dir`. The change does not silently revise the GAP-3 exception; it narrows it on a specific, evidenced basis (always-loaded-alongside). No principle is violated and none is silently revised, so no OP-11 loud-revision obligation is triggered. Aligned.
- No speculative abstraction (OP-9 / AP-7 / DR-7): the new doc is a relocation target for content that exists today, not a hook for an absent consumer.

## Mitigations

- **Dimension 3 (Blast Radius):** Before committing, grep the repo once more for the exact header strings being kept (`grep -rn "§ Commit Rules\|§ Git Rules"`) and confirm the collapsed-to-pointer bodies still let those name-based references resolve to a meaningful rule (the pointer chains to the workspace canonical block). Specifically eyeball `tweak.md:117` (`§ Git Rules`) and `pipeline-review.md:220` (`§ Commit Rules`) after the edit to confirm the pointer they land on carries the behavior they assume.
- **Dimension 5 (Hidden Coupling):** Keep the three collapsed header strings byte-identical (`## Commit Rules`, `## Git Rules`, `## Model Selection`) — do not rename while collapsing. And when relocating the Model Tier rationale, make the workspace `## Model Tier` pointer cite the exact new filename (`ai-resources/docs/model-policy.md`) so the pointer-and-file contract is self-documenting at the change site; verify the file exists at that path before committing.
- **Dimension 1 (precautionary, not a High):** Add the relocated rationale as a plain `docs/` pointer (`Full rationale: ai-resources/docs/model-policy.md`), not an `@import` in the always-loaded `## Model Tier` block — an `@import` would re-add the per-turn cost the change is removing.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: audit file line references (15, 87, 103-108, 122), CLAUDE.md content reads, grep counts across `ai-resources/` and the workspace root for all seven header/block terms plus `model-policy.md` (no filename collision found — `find` returned nothing), a direct read of `new-project.md:460-487` to confirm the scaffold loop targets project (not ai-resources) CLAUDE.md, and principle IDs cited from `principles-base.md` (DR-5, OP-12, DR-1/DR-3, GAP-3, OP-9/AP-7/DR-7). No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

The `/consult` command could not be invoked programmatically (Skill-tool `disable-model-invocation`); the equivalent `system-owner` agent was invoked directly. The agent **DECLINED** the advisory: its REQUIRED grounding files are missing on disk — `projects/axcion-ai-system-owner/references/{persona,grounding,toolkit-relationship}.md` and the entire `references/` tree are absent (only `output/` exists). Per the agent's decline-when-ungrounded rule, it refused to issue a grounded concurrence rather than fabricate the authority basis. Second opinion therefore **unavailable**; per `/risk-check` Step 17d this does NOT change the verdict and does NOT block — PROCEED-WITH-CAUTION stands as the gate result.

**Signal surfaced (outside the grounded advisory):** the agent flagged that MED finding #4 (relocate the workspace Model Tier *rationale* out of always-loaded context) collides with a standing operator preference. The workspace Model Tier block self-describes as "non-negotiable; audit recommendations that suggest adding a 'canonical model baseline' must be rejected," and the operator has a recorded standing preference that the model-defaults prohibition stay fully visible every turn. This is a genuine input-conflict (audit recommendation vs. operator standing preference) and was surfaced to the operator for adjudication before applying finding #4. The 3 HIGH dedups and the other 3 MED compressions are uncontested.

**Follow-up (separate from this change):** the missing `system-owner` grounding tree is an infrastructure gap worth logging — the agent is currently non-functional for any consult.
