# Risk Check — 2026-07-05

## Change

PLAN-TIME gate. Structural change: integrate an "Apple × Blackstone" design-reference lens into the axcion-design-studio project. Changes (all project-internal, no workspace/ai-resources/cross-project blast radius): (1) CREATE new project doc dir + file `30_reference-lenses/apple-blackstone-lens.md` — a lean advisory lens (Apple=experience / Blackstone=perception framing + positive design ambitions + final-test questions) that POINTS TO existing doctrine (brand book, 00_mandate, 20_criteria) rather than restating it; explicitly subordinate to brand→mandate→criteria (NOT a new authority rung); dark-section/imagery calls defer to brand book; departures route back through critics. (2) EDIT `.claude/agents/layout-architect.md` — add lens as Step-1 input #8 with a one-line "apply as lens, cannot override brand/hazards" note. (3) EDIT `.claude/skills/visual-design-spec/SKILL.md` — add lens path to Step-1 creator-input list. (4) EDIT project `CLAUDE.md` — add lens pointer under § Section Design Sessions + § Pointers; add ONLY the missing per-direction fields (mobile transform + motion, since Step 0 already covers composition/rhythm/relationship-to-neighbours); update § Boundaries line 53 so "the only layer the Studio authors" includes the new 30_reference-lenses layer. Deliberately NOT touching the protected source-of-truth-hierarchy.md or positioning-hazards.md. Files are project-local real files (not symlinks). No permission/hook/settings changes. Operator has authorized the integration ("implement into the repo so it is part of the workflow").

## Referenced files

- `projects/axcion-design-studio/30_reference-lenses/apple-blackstone-lens.md` — not yet present
- `projects/axcion-design-studio/.claude/agents/layout-architect.md` — exists
- `projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md` — exists
- `projects/axcion-design-studio/CLAUDE.md` — exists
- `projects/axcion-design-studio/00_mandate/source-of-truth-hierarchy.md` — exists
- `projects/axcion-design-studio/20_criteria/positioning-hazards.md` — exists

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The lens is a well-scoped, advisory, project-internal addition, but it silently leaves two documented mirror copies (`.codex`, `.agents`) out of sync and leaves the protected authority-hierarchy doc unaware of the new `30_reference-lenses/` layer — both fixable, neither acknowledged in the change.

## Consumer Inventory

| Consumer (path, project-relative) | Reference type | Must-change? |
|---|---|---|
| `.codex/agents/layout-architect.toml` | mirrors `.claude/agents/layout-architect.md` (AGENTS.md: "change one, change the other") | **YES** — parity, per explicit doc contract |
| `.agents/skills/visual-design-spec/SKILL.md` | byte-identical mirror of `.claude/skills/visual-design-spec/SKILL.md` (`diff -q` → IDENTICAL) | **YES** — parity, to preserve mirror |
| `00_mandate/source-of-truth-hierarchy.md` (PROTECTED) | ranks the doctrine layers + protected-file list + read/write map; does not enumerate `30_reference-lenses/` | deferred (CP-1 gated; deliberately excluded) — coherence gap |
| `00_mandate/design-studio-mandate.md` | source of the §2 boundary that CLAUDE.md § Boundaries + layout-architect.md restate | maybe — reconcile "only layer the Studio authors" edit |
| `.claude/skills/visual-design-spec/references/vds-template.md` (+ `.agents` copy) | VDS Section-2 field set (composition/device/colour/energy); has no mobile/motion field | no — Section Design Session ≠ VDS; note field-set divergence |
| `AGENTS.md` | points Codex at CLAUDE.md; is the *source* of the mirror obligation | no (self-updating pointer) |
| `.claude/skills/README.md` | documents the chain + third-party-skill roles | no |
| `PRODUCT.md`, `pipeline/*.md`, `logs/*.md` (many) | narrate the chain/roles historically | no (documents) |

Total: 8 distinct consumer groups; **2 must-change** (both mirror copies, not enumerated in the change), 2 coherence-deferred.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium
- The lens file itself is **not** always-loaded — it is an on-demand creator input read once per design pass (pay-as-used) and referenced by-path in `layout-architect.md`/`SKILL.md` (pay-per-dispatch). Those additions are Low.
- The cost driver is the **project `CLAUDE.md` edits**, which land in an always-loaded file (`source-of-truth-hierarchy.md:29` — "`CLAUDE.md` | Always-loaded context"). Additions: a pointer under § Section Design Sessions, a pointer under § Pointers, two new per-direction fields (mobile transform + motion), and a § Boundaries line edit — estimated ~50–100 tokens net to always-loaded context, which lands in the Medium band (50–150 tokens always-loaded). At the low end of Medium.

### Dimension 2: Permissions Surface
**Risk:** Low
- Change description: "No permission/hook/settings changes." No allow/ask/deny edits, no new tool patterns, no capability escalation.
- Confirmed the edits are already within the existing allow set: `.claude/settings.json` allows `Edit(**/.claude/**)` and `Write(**/.claude/**)` (lines 19–20) and denies only `Edit/Write(../axcion-brand-book/**)` (lines 30–31). CLAUDE.md and `.claude/**` are convention-protected (CP-1 tier-C), not settings-denied — so the edits are technically permitted and change no permission surface.

### Dimension 3: Blast Radius
**Risk:** Medium
- Consuming the Step-1.5 inventory: 3 files edited by the change itself + **2 must-change mirror consumers not in the change** (`.codex/agents/layout-architect.toml`, `.agents/skills/visual-design-spec/SKILL.md`) = 5 touched surfaces, all additive/backwards-compatible.
- Falls in the Medium band (3–5 compatible callers). Not Low because there ARE must-change consumers; not High because the must-change is **parity-maintenance, not breakage** — if the mirrors are not updated nothing breaks, the Codex/`.agents` harness simply runs a lens-less creator (degraded parity). If the mirror contract is read strictly ("any caller must-change"), this tips toward High; the paired mitigation (apply the two mirror edits) holds it at Medium.
- Cross-project blast radius is genuinely zero, as the change states — the understatement is intra-project (the mirrors).

### Dimension 4: Reversibility
**Risk:** Medium
- The three edits (`layout-architect.md`, `SKILL.md`, `CLAUDE.md`) revert cleanly via git.
- The new file + new directory: `git revert` of the add removes the file but leaves the now-empty `30_reference-lenses/` directory on disk (git does not track empty dirs) — one extra manual `rmdir` cleanup step → Medium.
- Wrinkle: `.agents/` and `.codex/` were untracked (`??`) at session start; if the mirror edits are applied there, they are not covered by `git revert` and need manual cleanup too. Reinforces Medium.

### Dimension 5: Hidden Coupling
**Risk:** High
- **Mirror-sync contract (undocumented in the change):** `AGENTS.md` states the `.codex/agents/*.toml` role definitions "mirror `.claude/agents/*.md` — **change one, change the other**"; `diff -q` confirms `.agents/skills/visual-design-spec/SKILL.md` is byte-**IDENTICAL** to the edited SKILL.md; grep confirms neither mirror contains any lens content. The change edits the `.claude/` originals and silently omits both mirrors — an implicit dependency the change leaves out of sync.
- **Authority-hierarchy coupling:** the new `30_reference-lenses/` layer's "subordinate, not a new rung" status is asserted only in the lens file + CLAUDE.md. The actual authority-ranking document — `00_mandate/source-of-truth-hierarchy.md` § Authority Order + § Protected-File List + § Read/Write Map (PROTECTED, deliberately untouched) — will not enumerate the new layer. A future conflict-resolution read of the hierarchy doc will not find `30_reference-lenses/`, so its subordination is undocumented at the layer that actually governs authority.
- **Boundaries divergence:** the CLAUDE.md § Boundaries edit ("the only layer the Studio authors" → +30_reference-lenses) may diverge from `00_mandate/design-studio-mandate.md` §2, which `layout-architect.md` explicitly restates as the source of truth ("if the two ever diverge, the mandate wins"). Editing the restatement without the source risks a silent CLAUDE.md-vs-mandate disagreement on what the Studio authors.
- Three independent implicit dependencies → High.

### Dimension 6: Principle Alignment
**Risk:** Medium
- `principles-base.md` present at `projects/strategic-os/ai-strategy/principles-base.md`; principle IDs cited from it and from `ai-resources/docs/ai-resource-creation.md` rule #7 (which itself cites AP-7/DR-7/OP-12).
- **Aligned:** OP-5 (advisory-vs-enforcement) — the lens is explicitly advisory ("apply as lens, cannot override brand/hazards"), subordinate to brand→mandate→criteria, with departures routed back through critics. Correct posture, not a silent new gate.
- **Tension — AP-7/DR-7 / ai-resource-creation rule #7 (complexity budget / speculative abstraction):** rule #7's strict trigger is a *new always-loaded document* or *new mandatory gate*; the lens is neither (on-demand input, advisory), so it is not a hard violation. But its justification is "design ambition" (operator-authorized), not prong (a) net-simplification or prong (b) cited written failure evidence (a friction/defect log entry). A new doctrine directory in a leanness-prizing repo, justified by ambition rather than evidence, is the pattern rule #7 warns against ("for completeness / for a future phase") — mitigated here by explicit operator direction, but the evidence prong is unmet.
- **Tension — DR-1/DR-3 (placement):** workspace CLAUDE.md § Placement Discipline names "New top-level directory, or first file in a directory that doesn't yet exist" as an explicit `/placement` trigger. `30_reference-lenses/` is exactly that; the change does not mention a `/placement` pass. Advisory only, and the operator authorized the location, but the trigger fired unaddressed.
- **Tension — OP-11/OP-3 (loud-revision-never-silent-drift):** mixed. The CLAUDE.md § Boundaries edit *loudly* acknowledges the new layer (good), but the mirror omission and the un-updated protected hierarchy doc are *silent* drifts (bad).
- No clear unacknowledged violation (operator approval exists; advisory posture is aligned; boundaries edit is loud) → Medium, not High.

## Mitigations

Required before / alongside landing (one paired action per elevated dimension):

1. **(Dim 5 High — mirror sync)** Apply the same lens edits to the two mirror copies in the same change: `.codex/agents/layout-architect.toml` (per AGENTS.md "change one, change the other") and `.agents/skills/visual-design-spec/SKILL.md` (byte-identical mirror). Then re-run `diff -q .claude/skills/visual-design-spec/SKILL.md .agents/skills/visual-design-spec/SKILL.md` to confirm parity restored. If the mirrors are intentionally *not* to carry the lens, state that exception explicitly and note why AGENTS.md's rule does not apply.
2. **(Dim 5 High — authority-doc gap)** Do NOT silently rely on the lens+CLAUDE.md to assert subordination. Either (a) queue a CP-1 tier-C edit to `00_mandate/source-of-truth-hierarchy.md` to place `30_reference-lenses/` explicitly below `20_criteria/` in § Authority Order and add it to § Protected-File List + § Read/Write Map; or (b) if that edit is deferred, add one loud line in the lens file AND CLAUDE.md § Boundaries stating "the source-of-truth-hierarchy.md authority order still governs; 30_reference-lenses sits below 20_criteria and does not appear in that doc yet — CP-1 edit pending." Make the deferral visible, not silent.
3. **(Dim 5 High — boundaries divergence)** Confirm the CLAUDE.md § Boundaries "only layer the Studio authors" edit does not contradict `00_mandate/design-studio-mandate.md` §2; if §2 states the same boundary, either update it under the CP-1 gate or add the same "mandate is source of truth; resync pending" caveat the layout-architect inline copy already uses.
4. **(Dim 3 Medium)** Treat the mirror edits (mitigation 1) as part of the change's file set for revert purposes — record all edited paths in the commit so a revert is one operation.
5. **(Dim 6 Medium)** Run `/placement "new 30_reference-lenses doc directory in axcion-design-studio"` for the record (advisory, non-mutating) before creating the directory, since the new-top-level-dir trigger fired.

## Evidence-Grounding Note

- Mirror contract: `projects/axcion-design-studio/AGENTS.md` § Codex-native agents — "They mirror `.claude/agents/*.md` — change one, change the other."
- Byte-identical mirror: `diff -q .claude/skills/visual-design-spec/SKILL.md .agents/skills/visual-design-spec/SKILL.md` → IDENTICAL.
- Mirrors lack lens content: `grep -niE "apple|blackstone|lens" .codex/agents/layout-architect.toml` and `.agents/.../SKILL.md` → no matches.
- Always-loaded CLAUDE.md: `00_mandate/source-of-truth-hierarchy.md:29` — "`CLAUDE.md` | Always-loaded context".
- Protected files: `source-of-truth-hierarchy.md:22-30` § Protected-File List (CLAUDE.md, `.claude/**` = CP-1 tier-C); the doc's own header — "Status: PROTECTED. Edit only with explicit operator approval (CP-1 tier-C gate)."
- Permissions: `projects/axcion-design-studio/.claude/settings.json` — allow `Edit/Write(**/.claude/**)` (lines 19–20), deny only `../axcion-brand-book/**` (lines 30–31).
- Complexity budget: `ai-resources/docs/ai-resource-creation.md` rule #7 (a)/(b) prongs, citing AP-7/DR-7 and OP-12; `principles-base.md` present at `projects/strategic-os/ai-strategy/principles-base.md`.
- VDS field set: `.claude/skills/visual-design-spec/references/vds-template.md:32` — "Composition, visual device, colour mode, and intended energy" (no mobile/motion field), confirming the CLAUDE.md per-direction additions extend beyond the VDS template's Section-2 set.
- `30_reference-lenses/` confirmed not present on disk (`ls` → NOT PRESENT); evaluated from described intent per reviewer protocol.
