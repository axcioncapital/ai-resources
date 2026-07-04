# Risk Check — 2026-07-04

## Change

Build the "Both" plan from the approved leverage-idea analysis. Structural change spanning several risk-check classes:
(1) NEW COMMAND ai-resources/.claude/commands/lean-repo.md — a diagnose-and-plan-only advisory command that reads the latest on-disk audit outputs (token-audit, audit-repo, architecture-review, pipeline-review, friday-checkup) plus evidence logs through a leanness/control-drift lens and emits a simplification plan. It NEVER mutates the repo — structural fixes route to a separate execution session (like /friday-checkup → /friday-act). Reads on-disk outputs, does NOT self-invoke other audit commands. Distinctive lens = 3 questions the other audits don't ask: (a) control-proportionality/drift (controls that should be conditional but became always-on, audited against the existing tier doctrine in docs/audit-discipline.md § Risk-check change classes), (b) retroactive complexity-budget scoring, (c) orphan/adoption (built-but-unwired components). Output: disposition-grouped plan (Remove/Merge/Make-conditional/Simplify/Defer-loading/Retain/Investigate) + top-5 bottlenecks, written to audits/lean-repo-{DATE}.md. Delegates heavy read to the new lean-repo-auditor subagent. Frontmatter model: opus.
(2) NEW AGENT ai-resources/.claude/agents/lean-repo-auditor.md — audit subagent following the ai-resources § Subagent Contracts disk-notes pattern (matches token-audit-auditor / repo-dd-auditor): writes full notes to audits/working/, returns ≤30-line summary with a NOTES: last line. Frontmatter model: opus.
(3) DOC EDIT ai-resources/docs/ai-resource-creation.md — add rule #7 "Complexity budget" (creation-time gate: no new command/agent/mandatory stage/permanent doc unless it (a) replaces more complexity than it adds OR (b) addresses a clearly evidenced failure mode; includes a 5-question check). Explicitly distinguished from docs/materiality-bar.md, which governs review findings not resource creation; cross-references the AP-7/DR-7 speculative-abstraction ban as the existing principle it operationalizes at creation time.
(4) COMMAND EDIT ai-resources/.claude/commands/leverage-idea.md — Step 6 verdict: add one line that options introducing a new component must clear the complexity-budget gate, else the verdict caps at MARGINAL.
(5) COMMAND EDIT ai-resources/.claude/commands/risk-check.md — add the complexity budget as an explicit sub-check under the existing principle-alignment dimension for new-component change classes.
Motivation is evidenced (capability sprawl; orphan commands e.g. /tech-consult; a rubber-stamp gate not earning its review cost; workspace CLAUDE.md over its line target). Self-referential tension to weigh: this build adds a NEW command + NEW agent to fight overengineering, so the new command must itself pass the complexity-budget gate it helps enforce — the claimed justification is that it addresses an evidenced failure mode AND consolidates a leanness lens currently scattered across 5 audit commands into one plan-producing pass. Assess whether that justification actually holds under the gate's own test.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/lean-repo.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/lean-repo-auditor.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/ai-resource-creation.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/materiality-bar.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/leverage-idea.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/architecture-review.md — exists (nearest-neighbour for overlap check)

## Verdict

RECONSIDER

**Summary:** The complexity-budget doctrine (items 3–5) is sound and consumer-backed, but the new command + agent (items 1–2) do not clearly pass their own gate — they duplicate architecture-review's shape, ship detection without a closure channel (OP-12), and one edit targets the wrong file (risk-check-reviewer, not risk-check.md).

## Consumer Inventory

Live/functional consumers of the edited files plus the new-contract markers. Historical artifacts (files under `audits/`, `logs/`, `plans/`, `logs/scratchpads/`, `session-notes*`, project `pipeline/repo-snapshot.md` and `context-pack*`) are records that *name* these components, not live consumers that invoke or parse them — excluded from the table (they neither break nor need editing). Grep run from `{AI_RESOURCES}` and the workspace root one level up.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/agents/risk-check-reviewer.md | co-edits — this agent (24KB) holds the six-dimension procedure incl. the principle-alignment dimension; item 5's sub-check must land here to actually fire | **yes — OMITTED from the change set** |
| ai-resources/.claude/agents/system-owner.md | co-edits — also carries a principle-alignment dimension (`architecture-review` path); a "complexity budget under principle alignment" edit may need mirroring here | investigate |
| ai-resources/.claude/commands/friday-act.md | invokes — writes `risk_check_required` annotations and runs `/risk-check` at execution time (lines 7, 175, 279) | no (invocation syntax unchanged; new sub-check is backwards-compatible) |
| ai-resources/docs/audit-discipline.md | documents — canonical definition of the `/risk-check` change classes + verdict semantics | no (rule #7 doctrine does not alter change-class list) |
| ai-resources/.claude/commands/placement.md | documents — routes to `ai-resource-creation.md` for creation rules | no (rule #7 is append-only) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md § AI Resource Creation | imports (pointer) — "Full rules: ai-resources/docs/ai-resource-creation.md" | no (rule #7 append-only; read on-demand, not always-loaded verbatim) |
| ai-resources/.claude/commands/architecture-review.md | co-edits / functional-overlap — near-identical shape to the proposed lean-repo (reads latest on-disk audits, opus subagent, advisory prioritized report, non-mutating); lean-repo *also reads its output* | no to change, but this is the central overlap finding (D5/D6) |
| ai-resources/.claude/commands/leverage-idea.md | co-edits (self, item 4) — no live command invokes `/leverage-idea` (only a doc, `toolkit-relationship.md`, names it) | yes (in change set); blast radius of the Step 6 edit is otherwise near-zero |
| Contract marker `complexity budget` / `complexity-budget` | new contract — 0 existing references; change defines it in ai-resource-creation.md rule #7 and wires 2 consumers (leverage-idea Step 6, risk-check/reviewer) | n/a (new) |
| Command token `/lean-repo` | new — 0 existing references (no orphan, no collision) | n/a (new) |
| Agent `lean-repo-auditor` | new — consumed only by lean-repo.md; no consumers yet | n/a (new) |
| On-disk audit outputs (`token-audit-*`, `repo-health-*`, `architecture-review-*`, `pipeline-review-*`, `friday-checkup-*`) | imports (glob-reads) — lean-repo depends on 5 audits' filename conventions and prior execution | no (they don't change), but implicit dependency (D5) |

Total: 12 rows — 1 must-change (`risk-check-reviewer.md`, **omitted from the plan**), 1 investigate (`system-owner.md`), plus 3 new-contract rows with no consumers yet. The two `not yet present` files (`lean-repo.md`, `lean-repo-auditor.md`) have no consumers of their own; the inventory covers the contracts they introduce (`/lean-repo` token, the `complexity budget` marker, and the 5 audit-output dependencies they read).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded cost. `lean-repo` is a pay-as-used command invoked on demand — same posture as `architecture-review` — not a hook, not `@import`ed, not added to any CLAUDE.md. The `lean-repo-auditor` subagent spawns only when `/lean-repo` runs. Evidence: change description "diagnose-and-plan-only advisory command … Delegates heavy read to the new lean-repo-auditor subagent."
- Rule #7 lands in `docs/ai-resource-creation.md`, which is read on-demand (workspace CLAUDE.md § AI Resource Creation carries only a pointer: "Full rules: ai-resources/docs/ai-resource-creation.md"), not loaded verbatim every turn. Adds ~1 rule (~5-question check) to a doc already holding 6 rules — no per-session token cost.
- Items 4 and 5 add one line each to two on-demand command bodies. No always-loaded impact.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` edits described. The command uses capabilities already established for the audit family: `Read` (on-disk outputs), `Task` (subagent spawn), `Write` to `audits/` (the same target `architecture-review`, `token-audit`, `friday-checkup` already write to). Evidence: output "written to audits/lean-repo-{DATE}.md"; subagent "writes full notes to audits/working/" — both within the existing audit write surface.
- No cross-repo write, external API, or MCP capability introduced. No settings-file scope change.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 5 (2 new — `lean-repo.md`, `lean-repo-auditor.md`; 3 edited — `ai-resource-creation.md`, `leverage-idea.md`, `risk-check.md`).
- Consumer inventory: 12 rows, **1 must-change** (`risk-check-reviewer.md`) which is **not in the change set**. Item 5 says "edit risk-check.md … add the complexity budget as an explicit sub-check under the existing principle-alignment dimension." But `risk-check.md` (the command) contains no dimension procedure — it only names "Principle alignment" in the Step 5 summary-display list (line 153). The six-dimension procedure lives in `.claude/agents/risk-check-reviewer.md` (grep confirmed: the dimension bodies are in the agent, not the command). A sub-check added to the command will not fire unless the reviewer agent honors it. **The effective target file is omitted from the plan** — this is a blast-radius gap the change description did not anticipate. (`system-owner.md` also carries a principle-alignment dimension for the architecture-review path — possible second mirror site; flagged `investigate`.)
- Contract changes are otherwise backwards-compatible: the `/leverage-idea` verdict cap ("caps at MARGINAL") has no automated downstream parser (grep found no live consumer of leverage-idea's verdict token); the risk-check sub-check does not alter the `### Dimension N` / `**Risk:** High` parse markers that `risk-check.md` Step 4 structural-validation depends on (lines 86–108).
- New contract `complexity budget` is wired to 2 consumers simultaneously (leverage-idea + risk-check) — no dangling contract on that axis.
- Not a High: no >5 breaking callers; edits are additive. But the omitted must-change target plus the functional-overlap component (architecture-review) keep it above Low.

### Dimension 4: Reversibility
**Risk:** Low

- All 5 files land in the working tree; a single `git revert` of the landing commit removes the 2 new files and reverts the 3 edits cleanly, within the same tree. No `settings.json` change, no cached permission state.
- No state propagates beyond git at *landing time*: the command mutates `audits/lean-repo-{DATE}.md` and `logs` only when *run*, not when the files are added. No hook/cron/symlink is registered that could auto-fire between landing and revert.
- Mild, non-blocking note: once `/lean-repo` and the "complexity budget" term enter operator muscle memory and rule #7 is cross-referenced by two commands, a revert must remove all three doctrine touchpoints together — a single-commit revert still handles this cleanly if items 3–5 land as one commit.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Functional overlap with `architecture-review` (existing mechanism).** `architecture-review.md` already "synthesize[s] a prioritized architecture-health report from the most recent on-disk audit outputs" (line 6), delegates to an opus subagent (`system-owner`), reads MISSING/STALE-guarded globs of the same audit family, and is advisory/non-mutating (writes report + chat echo). The proposed `lean-repo` has a near-identical shape — reads the latest on-disk audits (including `architecture-review`'s own output), opus subagent (`lean-repo-auditor`), advisory disposition plan. Two mechanisms would then both consume the audit corpus to produce an advisory repo-health/simplification report. This is the "functional overlap with existing mechanisms" High trigger. The distinguishing element is a 3-question *lens*, not a distinct mechanism.
- **Command-vs-agent placement coupling (silent).** Item 5's sub-check depends on the unstated fact that Dimension 6 is implemented in `risk-check-reviewer.md`, not `risk-check.md`. Editing the command alone silently fails to change reviewer behavior. Undocumented dependency across the command→agent boundary.
- **Implicit dependency on 5 audit-output conventions.** `lean-repo` glob-reads `token-audit-*`, `repo-health-*`, `architecture-review-*`, `pipeline-review-*`, `friday-checkup-*` by filename convention (mirroring architecture-review's Step 2 table). It silently depends on each audit having been run and keeping its filename shape; a convention drift in any source breaks it quietly. Change description does not name a staleness/degraded-mode contract the way `architecture-review.md` Steps 2–3 do.
- The `complexity budget` contract itself is *documented at its definition site* (rule #7 in `ai-resource-creation.md`) — that axis is fine; the coupling risk is concentrated in the two points above plus the audit-glob dependency.

### Dimension 6: Principle Alignment
**Risk:** High

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read successfully; frozen-ID index of the 41 active principles).

- **OP-12 (closure before detection).** `lean-repo` is a new *detection/diagnosis* capability. OP-12: "new detection that does not close findings counts *against* a candidate … a detection engine ships behind a working closure channel, never ahead." The change cites the `/friday-checkup → /friday-act` pattern as its analogue — but `/friday-act` **exists** as friday-checkup's closer, whereas **no `lean-act` / lean-repo closer exists** (grep confirmed: `commands/` holds `friday-act.md` only; no lean closer). The change ships the detector ahead of its closer. This counts against the candidate under OP-12.
- **Complexity-budget gate — the self-referential test the change asks me to run.** Under rule #7's own two prongs: **(a) "replaces more complexity than it adds"** — NOT satisfied: the build *adds* a command + an agent + 3 edits and *removes nothing*; the 5 audit commands all remain, and no orphan (e.g. `/tech-consult`) is retired as part of this change. It consolidates a *lens*, not components. **(b) "addresses a clearly evidenced failure mode"** — the justification rests entirely here, but the evidence (capability sprawl, orphan commands, rubber-stamp gate, CLAUDE.md over line target) is *asserted in the change description*, not cited to this reviewer with on-disk log entries. So the gate passes, if at all, only on the weaker prong and only on unverified evidence. A tool built to fight overengineering that itself clears its own gate only on prong (b) is the exact pattern the gate exists to scrutinize.
- **DR-7 / AP-7 (speculative abstraction) — partial defence.** The *doctrine* (items 3–5) is NOT speculative: rule #7 is wired to two confirmed consumers (leverage-idea Step 6 + risk-check) at creation, satisfying DR-7. This is the strong part of the change and should be preserved. The weakness is isolated to items 1–2.
- **OP-5 (advisory vs enforcement) — satisfied.** `lean-repo` advises and stops (non-mutating, routes fixes to a separate session). No enforcement upgrade. Not a violation.
- **DR-1/DR-3 (placement) — satisfied for the new files; violated for item 5.** New command/agent placement is canonical (`ai-resources/.claude/commands` and `/agents`). But item 5 places the sub-check in the wrong home (command vs the reviewer agent that owns the dimension) — see D3/D5.
- **Loud-revision note (OP-11/OP-3).** The change *loudly surfaces* its self-referential tension and asks for the assessment — good, and it pulls this away from silent drift. But surfacing a *tension* is not the same as making an explicit, recorded decision to *revise* OP-12/OP-9. The change asserts it passes the gate rather than recording a deliberate principle exception. So the loud-acknowledgment escape hatch (which would downgrade this to Medium/Low) does not fully apply: the OP-12 detection-ahead-of-closure issue and the prong-(a) failure remain unresolved.

Net: High — a clean OP-12 hit (detector shipped without its closer) plus a complexity-budget prong-(a) failure with a leaner alternative available, and the acknowledgment stops at "tension noted," not "principle revision recorded." Per the Dimension-6 special handling, the path is **rescope** (or make the revision explicit and recorded), not a technical patch.

## Recommended redesign

- **Split the change: ship the doctrine, rescope the tooling.** Items 3–5 (the complexity-budget gate + its two wirings) are DR-7-clean and low-risk — land them, but retarget item 5 to `.claude/agents/risk-check-reviewer.md` (the file that actually implements the principle-alignment dimension), and check whether `system-owner.md`'s parallel dimension needs the same sub-check. This delivers the operating value (a creation-time complexity gate that two commands enforce) without the overengineering the tooling introduces.
- **Fold the leanness lens into `architecture-review` instead of a new command + agent.** The 3 distinctive questions (control-proportionality/drift, retroactive complexity-budget scoring, orphan/adoption) are a *lens*, and `architecture-review` already has the exact mechanism (reads the on-disk audit corpus, opus subagent, advisory prioritized report). Adding a "leanness / simplification" mode or section to `architecture-review` — reusing the `system-owner` agent — simultaneously clears the complexity-budget prong (a) (adds a lens, not a component), resolves the D5 functional overlap, and cuts the D3 file/consumer count. If a standalone `/lean-repo` is nonetheless judged worth its cost, then to clear OP-12 it must (i) ship its closure channel (a `lean-act`, or an explicit, documented reuse of `/friday-act`) in the same change, and (ii) record the complexity-budget self-assessment as an explicit OP-11 decision rather than an in-line assertion — so the exception is a logged call, not drift.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references (risk-check.md:153, architecture-review.md:6, friday-act.md:7/175/279, ai-resource-creation.md rule structure), grep counts (`lean-repo` = 0 refs, `complexity budget` = 0 refs, no `lean-act` command, no live invoker of `/leverage-idea`, dimension procedure located in `risk-check-reviewer.md` not `risk-check.md`), verbatim quotes from CHANGE_DESCRIPTION and principles-base.md (OP-12, OP-9, DR-7, AP-7, OP-5, OP-11). Principles-base was readable; no inline fallback needed. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is RECONSIDER. Full advisory: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-04-lean-repo-both-reconsider.md`._

**Verdict: CONCUR with RECONSIDER** — but sharpen it. Clean split holds: doctrine ships, command+agent do not ship standalone.

Command+agent half (concur): fails its own flagship rule. Prong (a) fails by construction (two net-new components, none removed); OP-12 breached (`/lean-repo` is detection with no closer); duplicates `/architecture-review`'s shape.

Item 5 — reviewer under-cited its own evidence: verified `risk-check-reviewer.md` Step 6.5 (Dimension 6) *already* runs AP-7/DR-7 ("zero current consumers → speculative-abstraction signal") and OP-12 ("detection without closure counts against the change") — the machinery that produced this RECONSIDER. So item 5 is not just mis-filed (scoring lives in the agent, not the command), it is largely **redundant**. Retarget it to the agent as a *thin cross-reference* supplying the budget threshold to the existing check — not a new parallel check.

(i) Fold the three **questions** into `/architecture-review` (lenses, near-zero cost, no dilution); do **not** fold the seven-disposition **output** — severity-taxonomy vs. disposition-taxonomy are different artifacts, and grafting the plan dilutes synthesis.

(ii) Prong (b) does not rescue the standalone: the analytical gap is real, but the cheaper subset (fold the questions) captures it with zero new components. Bolting on an OP-12 closer makes it worse — command+agent+closer = three components to enforce an anti-component rule.

(iii) Auto-distribution: new canonical command symlinks to all 21 projects (risk-topology § 3); the anti-bloat command adds to the 255-command surface it measures. Real, mitigable (opt-out manifest), reinforcing not decisive.

Missed risks (outside the six dimensions):
1. Self-referential credibility — the doctrine's first act violates itself; discredits the rule (OP-11/OP-3). Biggest miss.
2. Enforcement-authority inconsistency — item 4 caps a verdict (enforcement), item 5 is advisory; same rule, two unlabeled authority levels (OP-5).
3. Undefined budget threshold — no unit/bound, so items 4/5 can't apply consistently.

Conflict named (persona § 5.7): grounding reopens the "Both" decision the operator already made. The choice turns on what the command buys — the three **questions** (→ fold in, grounded default) or the disposition-**plan artifact** (→ standalone, but only *whole*: OP-12 closer + recorded OP-11 waiver + opt-out entry). Current "Both" as specced is the one illegitimate path.

Position: ship item 3 (define the threshold first), ship item 4 (label the authority), thin+retarget item 5, hold items 1+2.
