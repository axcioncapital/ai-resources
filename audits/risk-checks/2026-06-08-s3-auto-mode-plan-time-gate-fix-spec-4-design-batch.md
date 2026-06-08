# Risk Check — 2026-06-08

## Change

S3 auto-mode plan-time gate for fix-spec §4 design batch + claim-permission.md decision. Two structural surfaces: (1) Item 2 — a live edit to the canonical-chassis reference/quality-standards.md permission wiring: either instantiate reference/claim-permission.md (currently non-existent; only claim-permission.template.md exists) and move per-claim-type threshold tables out of the chassis into it, OR remove the 5 dangling claim-permission.md pointers (lines 6/116/133/137/141) and reconcile chassis wording. The chassis § headers + four permission-class names + verb lists are canonical-immutable (require /risk-check re-fire to reorder/rephrase); the per-claim-type threshold tables are project-tunable. Live enforcers (claim-permission-gate, cluster-memo-refiner Check 9) read quality-standards.md, NOT claim-permission.md (line 137 states it is 'unconsumed'). (2) Item 1 — three DESIGN NOTES only (no implementation this session) for #17(+#15) risk-tiering keystone, #5(+#1-lite) paywall fast lane, #4 Tier-A counter-search; written under audits/, each separately /risk-check'd as it completes. Plan at logs/session-plan-2026-06-08-S3.md. Assess the two structural surfaces; design notes are documents describing proposed changes, not live edits.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/claim-permission.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/claim-permission.template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-workflow-v2-fix-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/session-plan-2026-06-08-S3.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The one live mutation (Item 2, a project-local edit to `quality-standards.md` permission wiring) is reversible and touches a documentation pointer-graph the live enforcers do not read — but the two candidate directions carry materially different blast radii, and the "instantiate-and-rewire" direction is a speculative-abstraction risk for a consumer that does not exist, so the change should proceed only with the direction constrained to the pointer-removal path (or a deliberately-recorded exception).

## Consumer Inventory

Search terms: `claim-permission.md`, `claim-permission.template.md`, `quality-standards.md`, `## Claim-Permission Classes`, `## Source-Diversity Matrix`, the four class-name tokens (`SUPPORTED` / `PROXY-SUPPORTED` / `ILLUSTRATIVE-ONLY` / `NOT-SUPPORTED`). The load-bearing target is the project-local `reference/quality-standards.md` and the `claim-permission.md` pointer graph it carries. The three design notes (Item 1) are documents under `audits/` describing future changes — scored as low-mutation documentation, not live edits.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/.../reference/quality-standards.md` (lines 6/116/133/137/141) | co-edits (the live mutation target — holds the 5 `claim-permission.md` pointers) | yes (the change IS this edit) |
| `ai-resources/skills/claim-permission-gate/SKILL.md:17-18,49-50,57,145-148,158` | parses (reads `## Claim-Permission Classes` + `## Source-Diversity Matrix` headings and the four class names from `quality-standards.md`, project-level — explicitly NOT `claim-permission.md`) | no, IF canonical-immutable headings/class-names/verb-lists are preserved |
| `ai-resources/skills/cluster-memo-refiner/SKILL.md:197,222,228,234` (Check 8/9) | parses (reads `§ Claim-Permission Classes`, `§ Source-Diversity Matrix`, `§ Country Coverage Table`, `§ Blocking-Gate` from `quality-standards.md`) | no, IF canonical-immutable structure preserved |
| `projects/.../reference/claim-permission.template.md` (lines 3,5,8-10) | documents (template that names `claim-permission.md` as the project copy + names refiner Check 9 / writer / Pass-3 emitter as *intended* consumers of the threshold tables) | no for pointer-removal; co-edits for instantiate-and-rewire (template framing would need reconciling) |
| `projects/.../audits/2026-06-08-workflow-v2-fix-spec.md:69-70` | documents (records the S1/S2 PM ruling: "Do NOT instantiate `claim-permission.md`"; enforcers read `quality-standards.md`) | no — but any direction must stay consistent with this recorded ruling |
| `projects/.../logs/decisions.md:259-267` | documents (the PM split-#23 decision; alt (b) "instantiate + rewire enforcers" was explicitly rejected as out of scope) | no — direction must not contradict this without a loud revision |
| `ai-resources/logs/improvement-log.md:329-355` | documents (the standing-open `claim-permission.md` architecture item; this change resolves it) | no — to be updated with the decision per the plan |
| `projects/.../logs/decisions.md` (new entry) | documents (plan requires logging the Item-2 decision here) | yes — log entry required by `session-plan-2026-06-08-S3.md:36` |
| `ai-resources/workflows/research-workflow/reference/quality-standards.md:6,116,133` | co-edits ONLY if the change is promoted to canonical (carries the same `claim-permission.md` pointers) | no — out of scope; this change is project-local (Option-A precedent, S2) |
| `ai-resources/workflows/research-workflow/reference/claim-permission.template.md:35` | co-edits ONLY if canonical promotion (the `(canonical)` rule text) | no — out of scope |

Total: 10 consumers, 2 must-change (the `quality-standards.md` edit itself + the required `decisions.md` log entry). For the `not yet present` target `claim-permission.md`: the file has **zero current consumers** — no live component reads it. Its `template.md` names three *intended* consumers (refiner Check 9, `evidence-to-report-writer`, Pass-3 emitter), but the deployed versions of all three read `quality-standards.md` instead (verified: `claim-permission-gate/SKILL.md:17-18,49-50`; `cluster-memo-refiner/SKILL.md:222,228`). The inventory of the *contract* `claim-permission.md` would introduce is therefore empty of live readers — this is the central finding for Dimension 6.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The live edit is to a project-local `reference/quality-standards.md` that is *not* always-loaded — its own header states "When to read this file. When running QC checks, applying fixes to prose, or handling evidence gaps. Not needed for every turn." (`quality-standards.md:9`). No per-turn or per-session token cost added.
- Pointer-removal direction *reduces* file content (removes 5 pointer references + reconciles wording) — net-negative or neutral token delta.
- Instantiate-and-rewire direction adds a new ~71-line `claim-permission.md` file (`claim-permission.template.md` is 72 lines), but it is read on-demand by Pass-3 consumers only, not always-loaded — pay-as-used.
- The three design notes (Item 1) are `audits/` documents, read only when their implementation is taken up — no ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No change to any `settings.json` / `settings.local.json`, no `allow`/`ask`/`deny` entry, no new tool family, no Bash/Write/external-API pattern. The change edits markdown reference content only.
- No scope escalation (project → user) and no cross-repo write: the live mutation is confined to the project-local `reference/` directory (`session-plan-2026-06-08-S3.md:45` confirms autonomy posture is gated at the project-chassis level, not a settings change).

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Step 1.5 inventory: **10 consumers, 2 must-change.** The two live enforcers (`claim-permission-gate`, `cluster-memo-refiner` Check 9) are `parses`-type consumers of `quality-standards.md` — they read the section headings and the four class-name tokens as exact-string contracts (`claim-permission-gate/SKILL.md:148` "These are the only valid class names").
- **The two candidate directions have different blast radii — assessed both:**
  - **Pointer-removal** (remove 5 dangling `claim-permission.md` pointers at lines 6/116/133/137/141, reconcile wording): touches the canonical-immutable region only at the *pointer-text* level, not the class names / verb lists / § headings. If the edit leaves `## Claim-Permission Classes`, `## Source-Diversity Matrix`, the four class names, and the verb lists byte-identical, **zero enforcer breakage** — the parsers do not key on the `claim-permission.md` pointer strings. Lower blast radius. Backwards-compatible with both enforcers.
  - **Instantiate-and-rewire** (build `claim-permission.md`, move the per-claim-type threshold tables out of the chassis into it): to have any effect, this requires *also* rewiring `claim-permission-gate` and `cluster-memo-refiner` Check 9 to read the new file — `decisions.md:265` records that exact path ("Instantiate claim-permission.md AND rewire the enforcers to read it") was **rejected** as "far heavier canonical change … out of scope." Moving the threshold tables without rewiring the enforcers leaves them reading a chassis that no longer contains the tables — a contract break. Higher blast radius; not backwards-compatible without the enforcer edits.
- The canonical workflow copies (`ai-resources/workflows/research-workflow/reference/quality-standards.md:6,116,133`) carry the same pointers but are **out of scope** — this change is project-local (Option-A precedent set S2, `decisions.md:261`). If a future editor mistakes this for a canonical edit, that is a separate `/risk-check` (the 4-file template-promotion path is logged separately at `improvement-log.md:352-355`).
- Inventory gap vs `CHANGE_DESCRIPTION`: the description names the 5 pointer lines but does not name the `decisions.md` new-entry requirement (`session-plan-2026-06-08-S3.md:36`) as a must-change consumer — surfaced here.

### Dimension 4: Reversibility
**Risk:** Low

- Pointer-removal direction: single-file project-local edit to `quality-standards.md` — clean `git revert` fully restores prior state. The plan also writes a `decisions.md` + `improvement-log.md` entry; those are append-only log mutations, but they *describe* the decision rather than encode load-bearing state, so a revert that leaves them is cosmetically stale, not functionally broken (Medium-leaning, but the dominant artifact reverts cleanly → Low).
- Instantiate-and-rewire direction: creates a sibling file (`claim-permission.md`) that `git revert` of the `quality-standards.md` edit would not remove, plus enforcer edits in two canonical skills — multi-step rollback. But this direction is recommended *against* below, so the reversibility floor for the recommended path is Low.
- No state propagates beyond git this session: no push (batched/gated per workspace CLAUDE.md), no external write, no automation/hook/cron/symlink added.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The live enforcers' dependency on `quality-standards.md` is an **exact-string contract**: `claim-permission-gate/SKILL.md:49-50` parses `## Claim-Permission Classes` and `## Source-Diversity Matrix` by heading; `:148` treats the four parsed class names as "the only valid class names." Any reconcile-wording edit that incidentally renames a heading, reorders the four classes, or alters a verb list silently breaks the parse. This coupling is *documented* at the change site (`quality-standards.md:7,116` declare the canonical-immutable set and the `/risk-check`-re-fire requirement) — which keeps it at Medium, not High.
- The `claim-permission.template.md:8-10` names three "Consumed by" components (refiner Check 9, `evidence-to-report-writer`, Pass-3 emitter) that **do not actually read** `claim-permission.md` — a latent documentation-vs-reality coupling. The pointer-removal direction *closes* this gap (removes the dangling references); the instantiate direction would *partially honor* a contract no live component reads. Pointer-removal is the coupling-reducing direction.
- The fix-spec already recorded (`2026-06-08-workflow-v2-fix-spec.md:70`) "Do NOT instantiate `claim-permission.md`" — any direction other than pointer-removal couples this change to re-opening a settled PM ruling, which `session-plan-2026-06-08-S3.md:11` explicitly flags "do not re-litigate."

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active). Checks applied: DR-7/OP-9/AP-7 (speculative abstraction), OP-12 (closure before detection), DR-1/DR-3 (placement), OP-11/OP-3 (loud revision).

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — the load-bearing finding.** The "instantiate-and-rewire" direction builds `claim-permission.md` infrastructure for consumers that **do not yet exist**: the Step 1.5 inventory found the contract `claim-permission.md` would introduce has **zero live readers** (the three "intended consumers" all read `quality-standards.md` instead — verified `claim-permission-gate/SKILL.md:17-18`; `cluster-memo-refiner/SKILL.md:228`). DR-7 ("generalize only on a second confirmed consumer") and AP-7 ("hooks for later before a consumer exists") both flag this direction. `decisions.md:265` already rejected it as out-of-scope. The pointer-removal direction is DR-7-aligned (it removes the speculative pointer, does not build the speculative file). **Because the change as described keeps both directions open, the *instantiate* branch is a live speculative-abstraction risk — but the operator can avoid it by constraining direction, so this is tension (Medium), not an executed violation (High).**
- **OP-11 / OP-3 (loud revision) — escape hatch.** If the operator nonetheless chooses instantiate-and-rewire, that reverses the recorded S1/S2 PM ruling (`fix-spec:70`, `decisions.md:261,265`). That reversal is *permitted* but must be loud and recorded (the plan already routes a `decisions.md` + `improvement-log.md` entry, `session-plan-2026-06-08-S3.md:36`) — so the mechanism for a legitimate revision exists. The violation would only be silent drift; a recorded reversal is in-bounds.
- **DR-1 / DR-3 (placement) — aligned.** Both directions keep the edit in the project-local `reference/` tier (correct home for a project chassis); canonical promotion is consciously deferred (`decisions.md:261`, Option-A precedent). No tier or home error.
- **OP-12 (closure before detection) — aligned, and a point in the change's favor.** The pointer-removal direction *closes* a standing open finding (the dangling-pointer architecture gap, `improvement-log.md:329-335`) rather than adding new detection. Item 1's design notes add no detection machinery this session (design-only). No OP-12 concern.
- **Item 1 (three design notes) — aligned.** They are documents describing proposed changes, each carrying its own downstream `/risk-check` before implementation (`session-plan-2026-06-08-S3.md:31-33`) — this honors DR-8 (gated structural changes risk-checked at plan-time) and does not itself build anything.

## Mitigations

- **Dimension 3 (Blast Radius) + Dimension 6 (Principle Alignment):** Constrain Item 2 to the **pointer-removal direction** (remove the 5 dangling `claim-permission.md` pointers at `quality-standards.md` lines 6/116/133/137/141 and reconcile the surrounding wording so the chassis reads as the sole home of the threshold-table framing). This is the DR-7-aligned, lower-blast-radius, coupling-reducing path and stays consistent with the recorded S1/S2 PM ruling. If the operator instead chooses instantiate-and-rewire, treat it as a **loud, recorded reversal** of the prior ruling (OP-11): log the reversal rationale in both `decisions.md` and `ai-resources/logs/improvement-log.md` *before* editing, and scope-in the two enforcer rewires (`claim-permission-gate`, `cluster-memo-refiner` Check 9) so the moved threshold tables are actually read — do not move the tables without the rewire.
- **Dimension 5 (Hidden Coupling):** Before committing, diff the edited `quality-standards.md` to confirm the canonical-immutable set is byte-identical: the six § headings (esp. `## Claim-Permission Classes`, `## Source-Diversity Matrix`), the four class-name tokens, and the permitted-prose-verb lists. The two live enforcers parse these as exact strings (`claim-permission-gate/SKILL.md:49-50,148`); a wording reconcile that touches them silently breaks the gate.
- **Dimension 3 (scope guard):** Do not touch the canonical workflow copies (`ai-resources/workflows/research-workflow/reference/quality-standards.md` + `claim-permission.template.md`) — they carry the same pointers but the 4-file canonical promotion is a separately-logged, separately-`/risk-check`'d change (`improvement-log.md:352-355`).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and referenced files, and the Step 1.5 consumer inventory). The principles-base index was readable and cited by frozen ID (DR-7, OP-9, AP-7, OP-11, OP-3, OP-12, DR-1, DR-3, DR-8). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-risk-check-second-opinion-s3-fix-spec-4-claim-permis.md`._

**(a) Concur with PROCEED-WITH-CAUTION.** Item 2 lands in a project-local file that would normally be zero-risk (`risk-topology.md § 5`), but it carries a two-end string contract — enforcers parse the § headings, class names, and verb lists as exact strings. That is the canonical trigger to elevate a project-local edit to structural risk. PROCEED-WITH-CAUTION, not GO, is correct. The Item-1 design notes are inert and do not raise the verdict.

**(b) Pointer-removal is the right path — and the principled one, not just the lower-blast one.**
- Instantiate-and-rewire stands up `claim-permission.md` and migrates tables to serve a consumer that does not exist (line 137: "unconsumed"). Speculative abstraction, barred by `principles.md § DR-7` / `§ AP-7`.
- The S1 PM ruling already settled the home as `quality-standards.md`, and the live enforcers read it. The five pointers are drift, not design — removing them restores the ruled-on state (`OP-12`).
- Instantiate-and-rewire would silently reverse S1. Admissible only as a loud, recorded reversal (`OP-11`) with both enforcer rewires scoped in. On current grounding, no reason to take it.

**(c) Three risks the six-dimension review did not foreground:**
1. **Reconciliation prose is itself a contract hazard.** "Reconcile chassis wording" edits prose adjacent to enforcer-matched strings; an accidental edit inside a parsed span fails silently. Mitigation 2's diff should freeze the *entire parsed region*, not just the named tokens.
2. **Removing line 137 deletes the decision memory.** Line 137 records *why* the file is unconsumed. Preserve a one-line residue ("not instantiated; rule lives here per S1") — reversibility of the edit is not durability of the rationale.
3. **Item 1 → Item 2 latent coupling.** If any #17/#5 design note presupposes a `claim-permission.md` home, that silently re-litigates S1. Write the notes against the `quality-standards.md` home.

**Bottom line:** Concur. Take pointer-removal. Freeze the full enforcer-parsed region during reconciliation, and keep a one-line record of why the file stays uninstantiated.
