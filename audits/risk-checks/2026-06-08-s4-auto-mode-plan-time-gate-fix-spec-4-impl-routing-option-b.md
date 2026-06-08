# Risk Check — 2026-06-08

## Change

S4 auto-mode plan-time gate — implement fix-spec §4 design notes (#17+#15 risk-tier keystone in reference/quality-standards.md + research-plan-creator/cluster-memo-refiner/claim-permission-gate routing + #15 template field; #5+#1-lite paywall fast-lane in execution-manifest-creator; #4 Tier-A counter-search routed through canonical Pass-3 Phase-B slot), make the Pass-3 Phase-B routing decision, and promote the cross-class triangulation rule to the canonical research-workflow template (Option B). Touches both the project-local reference files and canonical ai-resources skills + research-workflow/reference template files (live enforcers read these). Authoritative briefs: audits/2026-06-08-design-note-{17-15-risk-tiering-model,5-1lite-paywall-fast-lane,4-tier-a-counter-search}.md. Prior plan-time risk-check for the S3 design batch: ai-resources/audits/risk-checks/2026-06-08-s3-auto-mode-plan-time-gate-fix-spec-4-design-batch.md (PROCEED-WITH-CAUTION).

This is a PLAN-TIME gate on the IMPLEMENTATION of three design notes that were themselves design-only at S3. The design notes are the authoritative implementation briefs — read all three plus the fix spec. Key structural surfaces:
- #17+#15 keystone: NEW § Risk-Tier Model (Tier A–D) lands in BOTH the project reference/quality-standards.md AND (via Option-B path question) potentially the canonical template; tier assignment logic added to research-plan-creator; per-tier control routing added to cluster-memo-refiner + claim-permission-gate. This reshapes a control model that LIVE enforcers read. Highest blast radius.
- #5+#1-lite: paywall fast-lane + manifest source-plan table in execution-manifest-creator.
- #4: Tier-A counter-search via canonical Pass-3 Phase-B slot — DOUBLE-BLOCKED (depends on the routing decision below + on fix-spec #22 schema field being landed; #22 landed-status is UNVERIFIED).
- Item 4 (Option B): promote the project-local cross-class triangulation rule (S2 landed Option A) to the canonical research-workflow/reference template — canonical blast radius across all template-instantiating projects.

Pay special attention to: (a) whether implementing #17 project-local vs canonical creates a fork/drift hazard; (b) the double-block on #4 and whether attempting it under-verified is a risk; (c) the canonical-promotion blast radius of Option B; (d) reversibility of the keystone control-model change once live enforcers read it.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-17-15-risk-tiering-model.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-5-1lite-paywall-fast-lane.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-4-tier-a-counter-search.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-workflow-v2-fix-spec.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-plan-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/execution-manifest-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-prompt-creator/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/stage-instructions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-06-08-s3-auto-mode-plan-time-gate-fix-spec-4-design-batch.md — exists

## Verdict

RECONSIDER

**Summary:** Most of the batch is implementable with strong mitigations, but #4 is hard-blocked (its #22 dependency is unlanded — verified absent — and a double-blocked canonical-phase landing has no viable mitigation that keeps it safe this session), so #4 must be split out; the safest path is to land #17/#15/#5/#1-lite project-local + Option-B as a separately-gated promotion and defer #4 to a session where #22 is verified landed.

## Consumer Inventory

Search terms: `risk-tier` / `Risk-Tier` / `Tier A` / `Tier-A`, `counter-search` / `counter-search-runner`, `Phase B` / `Phase-B`, `paywall` / `fast-lane` / `public-gated`, `cross-class` / `same-underlying` / `triangulation-packets`, the four permission-class tokens, the § headings (`Claim-Permission Classes`, `Source-Diversity Matrix`), `independence basis`, `disconfirming-evidence` (#22). Searched `ai-resources/` and the project. Design notes under `audits/` and prior risk-checks excluded (they describe the change, they do not consume it).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/.../reference/quality-standards.md` (§ Claim-Permission Classes :116-143; § Source-Diversity Matrix :137-139) | co-edits (#17 adds § Risk-Tier Model + permission-ceiling here; #4 adds the Tier-A mandatory-counter-search note) | yes |
| `ai-resources/skills/research-plan-creator/SKILL.md:60-80` (L1/L2/L3 depth scale) | co-edits (#17 §3.1 adds `risk-tier:` per-question assignment; collides with the existing L-scale) | yes |
| `ai-resources/skills/cluster-memo-refiner/SKILL.md:216-234` (Check 9) | parses + co-edits (reads `§ Claim-Permission Classes` / `§ Source-Diversity Matrix` by heading and the four class tokens :293; #17 adds per-tier control depth + ceiling) | yes for #17 routing |
| `ai-resources/skills/claim-permission-gate/SKILL.md:14,41,110` (counter-search sentinel logic) | parses + co-edits (already wired to `.counter-search-runner.done` sentinel; #4 replaces the inline "not disconfirmation-tested" disclosure with Phase-B result; #17 adds permission-ceiling) | yes for #4/#17 |
| `ai-resources/skills/execution-manifest-creator/SKILL.md` | co-edits (#5 four-way classification + #1-lite source-plan table — output-contract change) | yes for #5/#1-lite |
| `ai-resources/skills/research-prompt-creator/SKILL.md` | co-edits (#5 fast-lane execution rule; #4 Option-A would have landed here — Option B routes away from it) | yes for #5; no for #4 (Option B) |
| `ai-resources/workflows/research-workflow/reference/stage-instructions.md:79-87,108` (Pass-3 phase set A→C→D→E→F; Phase B deferred) | co-edits (#4 Option B moves Phase B deferred→live in the canonical template) | yes for #4 (canonical) |
| `ai-resources/workflows/research-workflow/reference/quality-standards.md:137` (canonical Source-Diversity Matrix, no cross-class clause) | co-edits (Item 4 Option-B promotion adds the cross-class collapse clause already in the project copy) | yes for Option B |
| `ai-resources/skills/research-extract-creator` (`independence basis` field, landed S1) | parses (cluster-memo-refiner Check 9 :228 reads this; cross-class promotion references it) | no — already carries the field |
| `ai-resources/skills/research-extract-creator` + `research-prompt-creator` (#22 `disconfirming-evidence` schema field) | co-edits (#4 records counter-search results into this field — but the field is NOT yet landed; grep found zero `disconfirming-evidence`/`disconfirming evidence` schema field in either skill) | UNLANDED — blocks #4 |
| All future research-workflow-instantiating projects (template consumers) | imports (inherit the canonical template at scaffold time; Option B changes what they inherit) | no immediate edit, but inherit-on-next-instantiation blast radius |

Total: 11 distinct consumers, ~8 must-change for the full batch. Blast radius spans BOTH the project-local chassis and four+ canonical symlinked skills plus two canonical template files. For #4's #22 dependency: the contract field it must write into has **zero current existence** — verified absent in `research-prompt-creator/SKILL.md` and `research-extract-creator/SKILL.md` (grep returned no `disconfirming-evidence` schema field). This is the central double-block finding for Dimensions 3 and 6.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All edit targets are on-demand reads, not always-loaded. `reference/quality-standards.md:11` self-declares "Not needed for every turn"; SKILL.md files load only when their skill is invoked; the canonical template files load at stage transitions only (`stage-instructions.md:3` "Not needed for every turn").
- No always-loaded CLAUDE.md content added, no SessionStart/PreToolUse hook, no `@import` in an always-loaded file. The new § Risk-Tier Model (~30-50 lines) and #1-lite table add token cost only to the on-demand chassis/manifest, paid when those skills run.
- No frequently-spawned subagent brief is enlarged in a way that recurs per session.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` change, no `allow`/`ask`/`deny` entry, no new Bash/Write/external-API pattern. The change edits markdown chassis + skill content only.
- No scope escalation (project → user) and no new external/cross-repo capability. The counter-search Phase B (#4) is an analytical sub-agent over already-gathered evidence, not a new tool family.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded in the Step 1.5 inventory: **11 consumers, ~8 must-change** — the widest of any dimension. The change is explicitly cross-tier: project chassis + four canonical symlinked skills (`research-plan-creator`, `cluster-memo-refiner`, `claim-permission-gate`, `execution-manifest-creator`) + two canonical template files. CHANGE_DESCRIPTION itself calls #17 "Highest blast radius."
- **Contract-parse coupling (exact-string):** `cluster-memo-refiner/SKILL.md:293` and `claim-permission-gate` parse the four class tokens and `§ Claim-Permission Classes` / `§ Source-Diversity Matrix` headings as exact strings. The S3 risk-check already established these as canonical-immutable (`quality-standards.md:7`). #17 adds an adjacent § Risk-Tier Model — additive — but the permission-ceiling rule (design-note §3.2/§3.3) touches the immutable four-class set "as a cap," which is a contact point that must not re-grade.
- **#4 is double-blocked, and one block is verified open.** Design-note-4:7,39-42 names two preconditions: (a) the canonical Phase-B routing decision (resolvable this session — recommend B), and (b) the #22 `disconfirming-evidence` schema field. Grep confirms #22's field is **NOT landed** in `research-prompt-creator` or `research-extract-creator` (zero `disconfirming-evidence` schema hits). The fix-spec sequences "#22 before #4-design" (`fix-spec:47`) and "#22 ... Precedes #4" (`fix-spec:83`). Landing #4's Phase B (`stage-instructions.md:87,108` deferred→live) while its write-target field does not exist would ship a counter-search-runner with nowhere to record results — a broken canonical phase across every instantiating project.
- **Option-B canonical promotion** moves the cross-class triangulation clause from the project copy (`projects/.../reference/quality-standards.md:139`, S2 Option A) into the canonical template (`ai-resources/workflows/research-workflow/reference/quality-standards.md:137`, which currently lacks it). That is canonical blast radius — every future template-instantiating project inherits the stronger rule. It is backwards-compatible (additive, the project copy already proves the shape), but it is a separate canonical-chassis change class, not a project-local edit.
- **Inventory gap vs CHANGE_DESCRIPTION:** the description does not name `research-plan-creator`'s existing L1-L3 depth scale (`SKILL.md:60-80`) as a must-change collision surface — surfaced here (see Dimension 5).

### Dimension 4: Reversibility
**Risk:** Medium

- #17's § Risk-Tier Model + ceiling, #5/#1-lite, and the Option-B clause are all additive markdown edits — a `git revert` restores prior text cleanly within the working tree. No push this session (batched/gated per workspace CLAUDE.md), no external write, no log-state mutation that revert cannot undo.
- **The Medium driver: live-enforcer semantics, not git mechanics.** Once `cluster-memo-refiner` Check 9 and `claim-permission-gate` are rewired to apply per-tier control depth + the permission ceiling, any artifacts produced under the new control model carry tier-conditioned permission verdicts. A revert restores the skill text but does not re-grade artifacts already produced under the new rules — a one-extra-step cleanup if any run occurred between landing and revert. This project (1.1) is DELIVERED (design-note-17:61), so there are no in-flight artifacts here, which holds this at Medium not High; the canonical-template consumers face the same revert-leaves-stale-verdicts step if they adopt before a revert.
- **#4's Phase-B landing is the worst reversibility case in the batch:** landing a deferred canonical phase + rewiring `claim-permission-gate`'s sentinel-conditioned disclosure (`claim-permission-gate/SKILL.md:14,110`) is a multi-file canonical change; reverting it cleanly requires restoring the deferred-phase state in `stage-instructions.md` AND the sentinel disclosure logic in lockstep. This reinforces splitting #4 out.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Axis collision — the load-bearing hidden-coupling finding.** Design-note-17 §2 explicitly warns against "collapsing [the axes] into a competing taxonomy" and §3.1 open-question 1 asks whether a formal L-scale exists. It does: `research-plan-creator/SKILL.md:60-80` defines an L1/L2/L3 **knowledge-depth** scale ("Conversational fluency / Operational fluency / Execution competency") assigned at plan time. #17's risk-tier is a different axis (control effort), also assigned at plan time by the same skill. The design note recommends "Tier A–D IS the canonical scale and L3 shorthand is retired" — but the live L-scale is NOT a shorthand for risk tier; it answers "how deep must the AI understand this?" not "how much control does this claim deserve." Retiring or conflating it silently re-purposes a live field that downstream plan QC may read. This is two plan-time scales coexisting in one skill with overlapping "L3 ≈ Tier A" framing in the fix-spec — exactly the competing-taxonomy hazard the design note flagged, now confirmed live.
- **#22 contract dependency is undocumented-and-absent.** #4 silently relies on a `disconfirming-evidence` schema field (#22) that the executor I/O contract does not yet carry (verified absent). A counter-search-runner that writes to a non-existent field is a silent-failure coupling.
- **Sentinel coupling already half-wired.** `claim-permission-gate/SKILL.md:14,110` already reads `.counter-search-runner.done` and toggles `disconfirmation_tested`. #4 must replace the inline "not disconfirmation-tested" disclosure with the real result in lockstep — if Phase B lands but the gate's disclosure logic is not updated together, the gate emits a stale "not tested" note for sections that WERE tested. Tight two-end coupling.
- Mitigating factor keeping this from being purely catastrophic: the contract coupling on the four class tokens / § headings IS documented at the change site (`quality-standards.md:7,118`) and the S3 risk-check already froze it. But the axis collision and the #22 absence are undocumented at the change sites — driving High.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active). Checks applied: OP-9/DR-7/AP-7 (speculative abstraction), OP-12 (closure before detection), OP-5 (advisory vs enforcement), DR-1/DR-3 (placement), OP-11/OP-3 (loud revision), DR-8 (gated structural changes).

- **OP-9 / DR-7 / AP-7 (speculative abstraction) — applies to #4, mitigated by splitting it out.** #4 lands a canonical Phase B and rewires `claim-permission-gate` to consume a #22 schema field that does not exist (verified). Building a counter-search-runner ahead of its required input contract is "hooks for later before the consumer/contract exists" (AP-7, DR-7). It is NOT speculative if #22 is landed first — so the principled path is sequence #22, then #4. As described, attempting #4 this session is the DR-7 tension; deferring #4 removes it. The rest of the batch (#17/#15/#5/#1-lite/Option-B) all serve confirmed live consumers and are DR-7-aligned.
- **OP-12 (closure before detection) — #4 adds detection.** Counter-search is a new disconfirming-evidence *detection* capability. OP-12 requires detection to ship behind a working closure channel. The honest-null handling (design-note-4 §6 mitigation c — "an un-refuted claim is strengthened, not failed") and the existing Pass-3 gate ARE a closure channel, so #4 is OP-12-defensible *once landed correctly*; but landing detection (Phase B) while its recording field (#22) is absent ships detection ahead of the channel that captures it. Reinforces deferring #4 until #22 lands.
- **OP-5 (advisory vs enforcement) — watch the permission-ceiling.** #17's permission-ceiling (design-note §3.2: "hard cap for D, advisory for C" per open-question 2) moves `claim-permission-gate` from pure advisory grading toward an enforced cap. Design-note-17 itself flags this as an open question. A hard cap is an enforcement upgrade (OP-5) — permitted, but it must be an explicit per-component decision, not a silent default. Tension, not violation, because the design note surfaces it.
- **OP-11 / OP-3 (loud revision) — Option B reverses a recorded S2 deferral, loudly.** The S2 ruling landed cross-class triangulation as Option A (project-local) and explicitly *deferred* Option B (`fix-spec:70` "canonical-template promotion deferred (Option B)"). Promoting it now is the deferred decision being taken up — legitimate, but it must be recorded as the deliberate take-up of the deferred Option B, not slipped in. The plan frames it as Option B explicitly, so the loud-revision mechanism is honored.
- **DR-1 / DR-3 (placement) — aligned.** #17 chassis edit stays in the project `reference/` tier; skill edits stay in canonical `skills/`; Option-B promotion correctly targets the canonical template tier. No home/tier error.
- **DR-8 (gated structural change) — honored by this very risk-check**; each canonical edit (#17 chassis, #4 Phase B, Option-B promotion) is a gated class and is being plan-time risk-checked here as required.

## Recommended redesign

- **Split #4 out of this batch and defer it.** #4 is double-blocked: the routing decision is resolvable (recommend Option B per design-note-4 §3) but its #22 `disconfirming-evidence` schema field is verified absent. Sequence #22 (land the executor schema field in `research-prompt-creator` / `research-extract-creator`) first, then run a dedicated `/risk-check` on the Phase-B landing as its own change (design-note-4 §6 mitigation d already calls for this). Do NOT land Phase B this session — it would ship a canonical counter-search phase with no field to record results (OP-12 / AP-7).
- **Resolve the L-scale vs risk-tier axis collision BEFORE editing `research-plan-creator`.** The L1-L3 depth scale (`SKILL.md:60-80`) is live and answers a different question than risk tier. Do not retire or alias it as "L3 = Tier A." Either (a) keep both axes with an explicit "these are orthogonal" note in the skill (design-note-17 §2 axis table), or (b) make a recorded decision that one subsumes the other — but that is a loud OP-11 revision of a live field, not a silent rename. Grep any downstream consumer of the L-field before touching it (design-note-17 open-question 3).
- **Land the safe subset with the S3 mitigations carried forward.** #17 § Risk-Tier Model + ceiling, #15 field-exposure (template-by-template, not bulk), #5 fast-lane + #1-lite table, and Option-B canonical promotion are implementable IF: (1) the enforcer-parsed region (four class tokens, six § headings, verb lists) is frozen byte-identical and diffed before commit; (2) the permission-ceiling lands as an explicit per-component OP-5 decision (hard cap for D, advisory for C — recorded in `decisions.md`), not a silent enforcement upgrade; (3) Option B is logged as the deliberate take-up of the S2-deferred decision; (4) #5/#1-lite route through `/improve-skill` + their own `/risk-check` per design-note-5 §6, keeping #1-lite a manifest table (never a standalone artifact); (5) the backward-compatible un-tiered→Tier-B default (design-note-17 §3.4) is preserved so un-tiered plans run as today. If the operator wants this subset to proceed, re-run `/risk-check` on the split (subset minus #4) — it is expected to return PROCEED-WITH-CAUTION.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (skill parse points, chassis § headings, the live L1-L3 scale at `research-plan-creator/SKILL.md:60-80`, the canonical Pass-3 phase set at `stage-instructions.md:79-108`), grep counts (zero `disconfirming-evidence` schema hits in the two executor skills, confirming the #22 block; cross-class clause present in project but absent in canonical quality-standards.md), verbatim quotes from the three design notes and the fix-spec, and the principles-base index cited by frozen ID (OP-9, DR-7, AP-7, OP-12, OP-5, OP-11, OP-3, DR-1, DR-3, DR-8). No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is RECONSIDER._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-risk-check-second-opinion-s4-auto-mode-plan-time-gate.md

**Routing position.** The change is correctly classed and gated — it spans three `/risk-check` classes (canonical skill edit ×4, canonical template edit via Option B, project-local chassis edit; risk-topology.md § 3). RECONSIDER is binding and cannot be downgraded (DR-8). The real question is whether the redesign decomposition is right. It is.

**Concur with RECONSIDER and all three redesign steps:**

1. **Split #4, defer behind #22 — forced, not a judgment call.** The `disconfirming-evidence` field it writes into is verified absent. Landing Phase B now ships detection ahead of its closure channel — direct OP-12 violation, and AP-7/DR-7 (building the consumer before its contract exists).
2. **Resolve the L-scale axis collision before editing `research-plan-creator`.** Two orthogonal plan-time scales (knowledge-depth vs control-effort). Aliasing "L3 = Tier A" is silent conflict resolution between competing taxonomies (OP-3/AP-1). If one subsumes the other, that's a loud OP-11 revision of a live field, recorded — grep its consumers first.
3. **Land the safe subset under a fresh split-scoped `/risk-check`.** The five attached mitigations are well-grounded and sufficient.

**Risk the dimension review under-weighted.** Bundling Option-B canonical promotion with the keystone in one session is itself a sequencing hazard. Doing both means the first time the new risk-tier control model meets a canonical-template consumer is also the first time that consumer inherits the promoted clause — the two canonical-surface changes entangle at the point of first inheritance, so a post-landing defect isn't attributable (system-doc.md § 4.5 open loop; canonical templates inherit silently on next instantiation).

**Amendment to the redesign.** #17 should land project-local first and prove out before any canonical promotion (DR-7: the project copy is the only proven shape). Sequence: **(a)** #17/#15/#5/#1-lite project-local → **(b)** observe one live run under per-tier routing → **(c)** Option-B canonical promotion as its own gated change. Defer #4 behind #22 regardless. Cost is sequencing only, not scope.
