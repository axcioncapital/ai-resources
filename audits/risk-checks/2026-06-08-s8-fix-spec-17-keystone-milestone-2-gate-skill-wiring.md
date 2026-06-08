# Risk Check — 2026-06-08

## Change

Milestone 2 of the fix-spec #17 risk-tier keystone: wire the Tier A–D control-effort model into three canonical research-workflow skills (each via /improve-skill). (1) research-plan-creator — finalize the already-drafted (uncommitted) plan-time tier-assignment framework + L-scale orthogonality guard. (2) cluster-memo-refiner — read the per-question Risk-tier field and apply the design-note §3.2 control matrix; presence-gate absent field OR absent '§ Risk-Tier Model' → Tier B. (3) claim-permission-gate — read tier and apply the permission ceiling per decisions.md OP-5: Tier D = hard cap (auto-ILLUSTRATIVE-ONLY, no override), Tier C = advisory (flag a C-tier claim graded above PROXY-SUPPORTED; operator may override), Tiers A/B = SUPPORTED ceiling. The ceiling is a cap, not a re-grade — the four permission-class names/verbs/gate semantics stay byte-identical. Backward-compat default: un-tiered question OR a consumer project lacking the § Risk-Tier Model chassis → Tier B → current uniform behavior. Blast radius: these skills are symlinked into multiple consumer projects including buy-side-service-plan (which has a tier-less quality-standards.md — the double-absent path). Mitigation already planned: dry-run the two gate skills against buy-side's tier-less chassis to confirm uniform Tier-B output BEFORE committing; independent /qc-pass per edit; commit ai-resources batch before any project tree. Milestone 1 (the quality-standards.md § Risk-Tier Model chassis) already landed and was risk-checked (PROCEED-WITH-CAUTION) + QC'd APPROVE in S6. This bundle has been risk-checked 4× across S3–S6, all PROCEED-WITH-CAUTION.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/research-plan-creator/SKILL.md — exists (has an uncommitted working-tree draft of the tier framework)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/cluster-memo-refiner/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/claim-permission-gate/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/reference/quality-standards.md — exists (canonical chassis; § Risk-Tier Model landed in S6)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/audits/2026-06-08-design-note-17-15-risk-tiering-model.md — exists (design spec: §3.1 assignment, §3.2 control matrix, §6.2 ceiling)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/logs/decisions.md — exists (OP-5 permission-ceiling decision)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/reference/quality-standards.md — exists (tier-less chassis; the dry-run target / double-absent consumer)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A high-blast-radius edit to three canonical skills consumed live (via symlink) by two projects, made safe by a verified backward-compat presence-gate (no existing consumer parses a tier field, so the default-to-Tier-B path cannot break a reader) and a byte-identity freeze on the immutable four permission classes — but the immediate symlink propagation and the OP-5 advisory→enforcement upgrade in claim-permission-gate require the planned dry-run and freeze mitigations to hold before commit.

## Consumer Inventory

The three target skills are symlinked from each consuming project's `reference/skills/` directory directly to the canonical `ai-resources/skills/` copies (verified via `readlink`: e.g. `claim-permission-gate -> ../../../../ai-resources/skills/claim-permission-gate`). An edit to the canonical SKILL.md therefore propagates **immediately** to every symlinking consumer — there is no per-project copy buffering the change. Only runtime consumers (symlinks + invoking commands + reference docs that parse outputs) are inventoried below; logs, audits, scratchpads, session-plans, and context-packs that merely *name* the skills are documentation noise and excluded.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/research-pe-regime-shift-advisory-gap/reference/skills/research-plan-creator (symlink → canonical) | imports | no |
| projects/research-pe-regime-shift-advisory-gap/reference/skills/cluster-memo-refiner (symlink → canonical) | imports | no |
| projects/research-pe-regime-shift-advisory-gap/reference/skills/claim-permission-gate (symlink → canonical) | imports | no |
| projects/buy-side-service-plan/reference/skills/research-plan-creator (symlink → canonical) | imports | no |
| projects/buy-side-service-plan/reference/skills/cluster-memo-refiner (symlink → canonical) | imports | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-preparation.md | invokes (research-plan-creator) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-cluster.md | invokes (cluster-memo-refiner) | no |
| projects/research-pe-regime-shift-advisory-gap/.claude/commands/run-sufficiency.md | invokes (claim-permission-gate) | no |
| projects/buy-side-service-plan/.claude/commands/run-preparation.md | invokes (research-plan-creator) | no |
| projects/buy-side-service-plan/.claude/commands/run-cluster.md | invokes (cluster-memo-refiner) | no |
| ai-resources/workflows/research-workflow/.claude/commands/run-sufficiency.md | invokes (canonical template) | no |
| projects/research-pe-regime-shift-advisory-gap/reference/quality-standards.md | parses (§ Risk-Tier Model chassis present — tiered consumer) | no |
| projects/buy-side-service-plan/reference/quality-standards.md | parses (§ Risk-Tier Model ABSENT — double-absent / tier-less consumer) | no |

Total: 13 consumers, 0 must-change. No `not yet present` referenced files — all targets exist.

**Inventory findings that drive later dimensions:**

- **buy-side does NOT symlink `claim-permission-gate`** (verified: `ls` returns "No such file or directory"; buy-side's `stage-instructions.md` contains no `claim-permission-gate` / Pass-3 / `run-sufficiency` reference). So the most behaviour-changing of the three edits (the OP-5 ceiling) reaches only the PE-regime project at runtime; buy-side consumes only the two read-side skills (`research-plan-creator`, `cluster-memo-refiner`).
- **No existing consumer parses a `tier`/`Risk-tier` field from any skill output.** Grep for `Risk-tier:` / `risk-tier:` / `read.*tier` / `parse.*tier` across all invoking commands and skills (PE-regime, buy-side, canonical workflow template) returned zero hits. This is the load-bearing backward-compat fact: the presence-gate that defaults an absent tier to Tier B cannot break an existing reader, because there is no existing reader. The field is brand-new and the gate is its first and only consumer.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. The change edits three SKILL.md files; SKILL.md bodies load only when the skill is invoked (pay-as-used), not per session or per turn. Evidence: workspace `CLAUDE.md` § Skill Library — "Read the relevant SKILL.md before performing any task that has a corresponding skill" (on-demand load).
- No hook is registered (SessionStart / Stop / PreToolUse / UserPromptSubmit). The change adds no entry to any hook directory; `CHANGE_DESCRIPTION` describes only skill-body edits via `/improve-skill`.
- No `@import` into an always-loaded CLAUDE.md. The Risk-Tier Model definition lives in `reference/quality-standards.md` (a deployment-dependency reference read on demand by the skills), not in any CLAUDE.md.
- The three skills are already `model: opus, effort: high` (verified in all three frontmatters); the edits add tier-handling prose inside an existing invoked brief, a marginal token addition to skills that already run on demand only. No new spawn frequency is introduced.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json change. `CHANGE_DESCRIPTION` describes skill-body edits only; no `allow`/`ask`/`deny` entry is added, removed, or narrowed.
- No new tool family. All three skills declare "Read + Write only. No shell, no network" (claim-permission-gate SKILL.md line 185); the tier-handling edits stay within that footprint.
- No scope escalation (project → user) and no cross-repo / external write introduced.

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Step 1.5 inventory: **13 consumers, 0 must-change**, but the High rating is driven by the *contract surface* and the *immediate symlink propagation*, not by a count of broken callers.

- **Three canonical skills edited, all consumed live via symlink-to-canonical.** `readlink` confirms each project `reference/skills/<skill>` points at `ai-resources/skills/<skill>` — so the edit propagates to both consuming projects the instant it lands, with no per-project copy to stage or test independently. Touching three skills at once that sit on the Pass-1→Pass-3 pipeline is shared-infrastructure scope.
- **A new cross-skill contract is introduced:** the `Risk-tier:` field emitted by `research-plan-creator` (SKILL.md lines 84–104, 383: `Risk-tier: [A / B / C / D]`) is read downstream by `cluster-memo-refiner` and `claim-permission-gate`. This is a producer→consumer contract spanning three files that must agree on field name, tier values, and the presence-gate default.
- **Contract change is backward-compatible (the mitigating fact).** No existing consumer parses a tier field (grep: zero `Risk-tier:`/`tier` parsers in any invoking command or skill). The presence-gate (absent field OR absent `§ Risk-Tier Model` → Tier B → current uniform behaviour) is additive: un-tiered plans and tier-less projects run exactly as today. Evidence: design-note §3.4 (line 62) and research-plan-creator SKILL.md line 99 ("a plan that omits tiers entirely runs exactly as before").
- **Blast-radius gap vs. stated intent — surfaced, not anticipated as a problem:** `CHANGE_DESCRIPTION` says the skills "are symlinked into multiple consumer projects including buy-side." The inventory refines this: buy-side symlinks only **two** of the three skills — it does NOT symlink `claim-permission-gate` (the OP-5 ceiling skill). So the highest-risk edit reaches only the PE-regime project at runtime; buy-side's exposure is limited to the two read-side skills, and its tier-less `quality-standards.md` is exactly the double-absent path the presence-gate must handle. This narrows the real ceiling-skill blast radius to one project but confirms the dry-run target (buy-side) genuinely exercises the absent-chassis path for the two skills it does consume.
- **Four prior risk-checks (S3–S6) all returned PROCEED-WITH-CAUTION** for this bundle (`CHANGE_DESCRIPTION`; design-note line 7), and Milestone 1 (the chassis) already landed + QC-APPROVE in S6 — consistent with a known, repeatedly-vetted high-blast-radius change rather than a novel one.

### Dimension 4: Reversibility
**Risk:** Medium

- The edits themselves are `git revert`-clean: three SKILL.md files in `ai-resources`, no sibling files or directories created, no data/log mutation by the edit. A single revert of the ai-resources batch restores all three skills.
- One extra cleanup consideration raises this above Low: **the symlink propagation means a revert must also account for any project-tree artifacts produced under the tiered behaviour between landing and revert.** Because symlinks resolve to canonical, a revert of the canonical skills instantly restores prior behaviour for both projects — but any tiered research plan or ceiling-capped permission table already written by the PE-regime project would remain on disk as a stale artifact a git-revert of `ai-resources` does not touch.
- The planned commit ordering mitigates this directly: "commit ai-resources batch before any project tree" (`CHANGE_DESCRIPTION`) keeps the skill change and any project output in separate commits, so the skill change can be reverted without entangling project-tree state. With that ordering, rollback is a clean two-step (revert ai-resources batch; optionally discard any tiered project artifact), which is the Medium profile (revert + one cleanup step), not High.
- No state propagates beyond git: no push (batched/gated per `CLAUDE.md`), no external write, no hook/cron/symlink-creation that could fire between landing and revert (the symlinks already exist; the change does not add automation).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One new cross-skill contract, but it is documented at the change site** (the mitigating factor that holds this at Medium rather than High): the `Risk-tier:` field is defined in `research-plan-creator` SKILL.md § Risk-Tier Calibration Framework (lines 84–104) and Question Format (line 383), and the consumers' contract (presence-gate default, control matrix, ceiling) is specified in the canonical `reference/quality-standards.md § Risk-Tier Model` and design-note §3.2/§6.2. The contract is not silent.
- **Implicit dependency on the `§ Risk-Tier Model` heading string in `quality-standards.md`.** Both gate skills presence-gate on the literal section heading: "absent '§ Risk-Tier Model' → Tier B." If a future project renames or omits that heading, the skills silently fall back to Tier B. This is an established convention in this workflow (the same skills already presence-gate on `## Claim-Permission Classes` / `## Source-Diversity Matrix` headings — claim-permission-gate SKILL.md lines 49–50, 146), so the coupling pattern is consistent with prior art rather than novel, but it is a heading-string dependency that lives outside the skill.
- **The L-scale orthogonality risk is explicitly guarded, not silent.** decisions.md S5 (line 297) records that `research-plan-creator` carries a live L1–L3 Depth Calibration Framework (SKILL.md lines 52–81), and the design's original §3.1 recommendation to retire "L3" was overturned in favour of COEXISTENCE with an explicit orthogonality guard written at the change site (SKILL.md § Axis Orthogonality, lines 88–90: "Risk tier does not replace, alias, or map onto L1–L3"). Without that guard this would be a high-coupling collision between two axes; with it, the coupling is surfaced and bounded.
- **No functional overlap / double-handling.** The permission ceiling is explicitly "a cap, not a re-grade" (design-note line 53; decisions.md line 342): tier sets the ceiling, the existing permission gate still decides the class under it. Two mechanisms do not both try to grade the claim — the design rule (design-note §2, line 30) keeps risk-tier as an *input* and permission-class as the *output*, never merged.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index available).

- **OP-5 (advisory vs. enforcement) — the principle this change touches most.** claim-permission-gate is today a pure advisory grader ("assigns each claim a permission class based on evidence" — SKILL.md description). This change adds an **enforcement** element: Tier D = a **hard cap** (auto-ILLUSTRATIVE-ONLY, no override). That is an advisory→enforcement move on one tier. Under OP-5, enforcement authority is "an explicit per-component decision," and under OP-11 a principle move must be **loud and recorded**. Here it *is* recorded: decisions.md 2026-06-08 (S6), § "Risk-Tier Model permission-ceiling enforcement (fix-spec #17, OP-5 decision)" (lines 340–344) explicitly states the asymmetry (D hard cap / C advisory / A-B unconstrained) and its rationale ("a D-tier question is illustrative by construction … so the cap is hard"). Because the enforcement upgrade is an explicit, recorded OP-5 decision rather than a silent upgrade, this is principle **tension handled correctly**, not a violation — Medium, not High. (Per the Step-6.5 rule: a loud, recorded enforcement decision is scored Medium/Low with a note, not High.)
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — checked and cleared.** The change wires a contract (`Risk-tier:`) that currently has zero parsers (grep-confirmed). On its face that is the speculative-abstraction signal (a contract for an absent consumer). But the consumers are landed *in the same bundle*: cluster-memo-refiner and claim-permission-gate are the confirmed first consumers wired in this very change, and the PE-regime project is the live first adopter. decisions.md (line 303) shows the alternative — "Land only the project-local definition … rejected by the system owner as a definition-before-consumer inversion (DR-7/AP-7/OP-12)" — i.e. the team explicitly sequenced consumer-with-definition to *avoid* the speculative-abstraction trap. This is consumer-confirmed building, not "hooks for later." Cleared.
- **OP-12 (closure before detection) — not triggered.** The change adds no new detection/scan/finding-generator; it routes *existing* controls (source ladder, counter-search, permission gate) by tier and applies a ceiling. No new finding stream is opened ahead of a closure channel.
- **OP-10 (system boundary) — not triggered.** The change stays entirely within Claude Code skills; no GPT/Perplexity/NotebookLM/Notion behaviour is governed.
- **DR-1 / DR-3 (placement) — aligned.** The edits land in canonical `ai-resources/skills/` (the correct tier for shared skills, DR-1) and the definition lives in the workflow reference doc (`quality-standards.md`), not in a CLAUDE.md — correct home per DR-3.

### Mitigations

- **Dimension 3 (Blast Radius, High) — dry-run the two gate skills against buy-side's tier-less `quality-standards.md` BEFORE committing**, confirming uniform Tier-B output on the double-absent path (absent field + absent `§ Risk-Tier Model`). This is already in the plan (`CHANGE_DESCRIPTION`); it must run and pass before the ai-resources batch is committed, because the symlinks propagate the edit live to both projects the moment it lands. Pair with: independent `/qc-pass` per skill edit (catches a presence-gate or contract-name mismatch across the three files), and the planned commit ordering (ai-resources batch committed as a separate, independently-revertible unit before any project-tree commit). Note that buy-side does NOT consume `claim-permission-gate`, so the dry-run for the OP-5 ceiling skill must be exercised against the PE-regime project (or a synthetic tier-less fixture) — buy-side alone does not cover that skill's absent-chassis path.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, `readlink` symlink-target verification, and `ls` existence checks). No training-data fallback was used on any read. The principles-base index was readable and Dimension 6 cites frozen IDs (OP-5, OP-9/AP-7/DR-7, OP-12, OP-10, DR-1/DR-3, OP-11) directly.

## Architectural Commentary

_System-owner second opinion, invoked automatically because the verdict is PROCEED-WITH-CAUTION. Note: `/risk-check` Step 17b directs invoking `/consult` via the Skill tool, but `consult` is not in this session's invocable-skill list, so the `system-owner` agent (which `/consult` delegates to for its Function-B pre-change advisory) was invoked directly instead. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-risk-check-second-opinion-fix-spec-17-milestone-2.md`._

**Q1 — CONCUR?** Yes. The verdict is correctly tiered. The load-bearing fact holds: grep confirms zero existing `Risk-tier:` parsers, so the presence-gate default-to-Tier-B cannot break a live reader — there is no live reader. Blast radius is genuinely High (three canonical skills, live symlink propagation), so GO would be wrong; the additive contract + byte-identity freeze on the four permission classes make RECONSIDER wrong. The Tier-D hard cap is an advisory→enforcement move on `claim-permission-gate`, permissible only because it is recorded in decisions.md (OP-5, OP-11) — tension handled correctly, not a violation.

**Q2 — Right mitigation path?** Yes, with one tightening. All four parts are correct, including the synthetic-fixture addition for `claim-permission-gate` (buy-side symlinks only two of three skills — it does NOT cover the OP-5 ceiling skill). **Tighten:** run them as an ordered precondition chain, not an unordered set: per-edit `/qc-pass` → both dry-runs pass (incl. the `claim-permission-gate` fixture) → ai-resources commit → project commit. Committing before the ceiling-skill fixture passes pushes the enforcement-bearing edit live on an unexercised path. The dry-run is a precondition of commit, not a parallel nicety (DR-8).

**Q3 — Risks the six dimensions missed** (priority order):
1. **[Most material] Uncommitted working-tree draft in `research-plan-creator`.** All six dimensions reason about the edit; none reason about the half-finished baseline it lands on. If that draft's `Risk-tier:` format diverges from what the consumers presence-gate on, the contract breaks at the producer end. Reconcile or commit the draft to a clean baseline *before* editing (OP-3 — the draft's state is load-bearing and currently unverified).
2. **`§ Risk-Tier Model` heading-string dependency is durable silent-degradation.** A project that *meant* to be tiered but typo'd the heading drops to Tier-B silently. Accept for v1; park a follow-up advisory-on-fallback (DR-7 — no second consumer yet).
3. **No written rollback recipe for the tiered-artifact cleanup.** A revert of the canonical skills does not remove tiered artifacts PE-regime already wrote. Same un-written rollback debt already open as repo-state.md § 2 steps #8 and #11. Write the two-step recipe into the plan file before committing.

**Position:** Proceed under PROCEED-WITH-CAUTION, sequence the mitigations as a hard precondition chain, and reconcile the uncommitted draft baseline first.

---

## S9 delta-assessment (2026-06-08) — propagation rule is within this envelope; no re-fire

The S9 session resolved the Milestone-2 blocker (tier→finding propagation) — design-note `audits/2026-06-08-design-note-17-15-risk-tiering-model.md` §7 + `logs/decisions.md` S9. Assessed against this report's envelope:

- **Carrier = `cluster-memo-refiner` reads tier from the research plan** (added as an optional-recommended input), following the contributing-question provenance Check 1/Check 2 already produce. This is the *same class of input dependency* the refiner already has (cluster memos; optionally compressed briefs) — not a new skill, tool, hook, setting, or consumer. **`research-extract-creator` is explicitly NOT edited**, consistent with this report's 3-skill scope (tier is a per-question property; an extract is per-source — category mismatch).
- **Derivation = most-restrictive tier binds** is an application detail *inside* the already-scoped Check 9 ceiling edit. It does not touch the immutable four permission classes (still a cap, not a re-grade) and does not alter the presence-gate→Tier-B backward-compat default. The D-hard-cap/C-advisory enforcement character (Dimension 6, OP-5) is unchanged — applying the recorded cap at finding level (weakest-link, capping *more* not less) stays "tension handled correctly, recorded," not a new High.
- **Baseline correction:** Q3 #1 (the most-material gap — "reconcile/commit the uncommitted `research-plan-creator` draft before editing") is now **SATISFIED**: Edit 1 was committed at 21:20 (`cabcd51 update: research-plan-creator — risk-tier model (fix-spec #17, skill 1/3)`) on a clean working tree, after a cold-eval that fixed the field-casing Major. The scratchpad's "held uncommitted" was stale; git is authoritative.

**Conclusion:** within-envelope refinement, not a scope expansion → the 5th PROCEED-WITH-CAUTION verdict and the precondition chain (per-edit `/qc-pass` → both dry-runs incl. the synthetic `claim-permission-gate` tier-less fixture → ai-resources batch commit → project commit) carry forward unchanged to Edits 2–3.
