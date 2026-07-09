# Risk Check — 2026-07-09

## Change

Plan-time gate: editing CLAUDE.md § Section Design Sessions (cross-cutting project-level doctrine, in projects/axcion-design-studio/) and ai-resources/.claude/commands/explore-section.md (canonical command shared across other projects) to implement 5 tracked fixes from logs/next-up.md — (F1) rename the lean/full toggle to lean/explore/chain so "full" stops meaning two different things (the 4-critic Studio chain in CLAUDE.md AND explore-section.md's own "full 10-step run" label); (F2) tighten the wording of the already-existing gated-lean-loop default so operator-pick explicitly precedes any critic dispatch; (F3) split explore-section.md's § Escalation trigger so a stale approved-record (upstream copy changed) reconciles cheaply while only a genuine design departure escalates to the chain; (F4) turn the currently-advisory "Do NOT use per-section" warning (in the project's visual-design-spec/SKILL.md) into a binding pre-dispatch halt — a checklist a session must show it passed before dispatching layout-architect or any critic for section-scoped work outside an approved whole-surface run; (F5) add an explicit cost pre-declaration rule (any section-design path expected to spend ≥2 subagents or >5 minutes before the operator sees something reactable must state the estimate and get a y/n first). Once landed, the SECTION-DESIGN FREEZE block currently active in CLAUDE.md will be resolved/removed and logs/next-up.md's F1-F5 checkboxes checked off. Full plan: projects/axcion-design-studio/logs/session-plan-2026-07-09-S1.md. Background/root-cause post-mortem: projects/axcion-design-studio/logs/friction-log.md § 2026-07-08.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/explore-section.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/session-plan-2026-07-09-S1.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-design-studio/logs/next-up.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is a well-evidenced, tightly-scoped doctrine correction (root-caused in `friction-log.md § 2026-07-08`) with no permission or ongoing-cost exposure, but it coordinates five edits across four files plus two log appends, leaves a genuine open question about whether F4's "binding" halt is technically enforced or still relies on the same read-and-bypass discipline that failed before, and makes an explicit (though loudly-acknowledged) advisory→enforcement move under OP-5.

## Consumer Inventory

Search terms used: `explore-section`, `Section Design Sessions`, `SECTION-DESIGN FREEZE`, `per-section`, `Lean Exploration`, `"full"` (as tier-name), `visual-design-spec`. Searched `ai-resources/`, `projects/axcion-design-studio/`, and all other `projects/*/` repos (axcion-website, axcion-copy-factory, axcion-brand-book, axcion-ai-system-owner) plus the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `projects/axcion-design-studio/CLAUDE.md` (§ Section Design Sessions, incl. freeze block) | edit target | yes |
| `ai-resources/.claude/commands/explore-section.md` | edit target | yes |
| `projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md` (lines 38–41) | edit target (F4) | yes |
| `projects/axcion-design-studio/logs/next-up.md` (F1–F5 checkboxes) | edit target (checklist) | yes |
| `projects/axcion-design-studio/logs/decisions.md` | co-edits (plan step 9 appends a decision entry) | yes |
| `projects/axcion-design-studio/logs/session-notes.md` | co-edits (plan step 9 appends a session entry) | yes |
| `projects/axcion-design-studio/web-refinement-playbook.md` | documents (points to `CLAUDE.md § Section Design Sessions` + `/explore-section` by name, does not quote toggle words) | no |
| `projects/axcion-design-studio/20_criteria/section-design-principles.md` | documents (points to `CLAUDE.md § Section Design Sessions` Step 0 by name) | no |
| `projects/axcion-design-studio/.claude/skills/README.md` | documents (points to `CLAUDE.md § Section Design Sessions` Step 0.5 + `/explore-section` by name) | no |
| `projects/axcion-design-studio/.claude/agents/layout-architect.md` (line 65) | documents (names `CLAUDE.md § Section Design Sessions, Step 0`) | no |
| `projects/axcion-design-studio/logs/friction-log.md` § 2026-07-08 | documents (historical post-mortem; not edited by this plan) | no |
| `projects/axcion-design-studio/logs/scratchpads/2026-07-08-09-24-scratchpad.md` | documents (historical; references the freeze) | no |
| `projects/axcion-design-studio/work/homepage/sections/our-methodology/STATUS.md` | documents (suspended-work record named in `next-up.md`; its own reconciliation is explicitly a separate, already-flagged item, not part of F1–F5) | no |

Total: 13 consumers found, 6 must-change (the two edit targets plus SKILL.md/F4, next-up.md checkboxes, and two log appends).

**Notable finding:** `CHANGE_DESCRIPTION` characterizes `explore-section.md` as "canonical, shared across other projects." The inventory found **zero** consumers of `/explore-section` or the Section Design Sessions doctrine outside `projects/axcion-design-studio/` — no reference in `axcion-website`, `axcion-copy-factory`, `axcion-brand-book`, or `axcion-ai-system-owner` (the only ai-system-owner hits are historical consultation records in `output/consultations/`, not live consumers). The command's own frontmatter description reads "Axcíon Design Studio, project-local." Actual current blast radius is narrower than the change description implies — contained to one project repo plus the canonical command file itself.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `projects/axcion-design-studio/CLAUDE.md` is always-loaded in that project's sessions, but the net edit is dominated by **removing** the SECTION-DESIGN FREEZE blockquote (`CLAUDE.md:34-49`, ~16 dense lines) — a large always-loaded block — while F1 (toggle rename), F2 (wording tightening), and F5 (cost pre-declaration) add comparatively small amounts of replacement/new prose within the same already-loaded `§ Section Design Sessions`. Net token delta to the always-loaded file is very likely a decrease, not an increase.
- `ai-resources/.claude/commands/explore-section.md` and `projects/axcion-design-studio/.claude/skills/visual-design-spec/SKILL.md` are both invoked on demand (command file / skill file), not always-loaded — edits there carry no per-turn cost.
- No new SessionStart/PreToolUse/Stop hook is introduced. No new `@import`. No new skill-description broadening.
- `next-up.md`, `decisions.md`, `session-notes.md` are read on-demand (e.g. by `/prime`), not always-loaded per turn.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` / `settings.local.json` changes referenced or implied anywhere in `CHANGE_DESCRIPTION` or the session plan.
- No new Bash pattern, Write path, external API, or MCP surface introduced. The change is prose/doctrine wording plus checkbox edits.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: 13 consumers found, 6 must-change (`CLAUDE.md`, `explore-section.md`, `SKILL.md` lines 38–41, `next-up.md`, `decisions.md`, `session-notes.md`). All six must-change files are already accounted for in `session-plan-2026-07-09-S1.md`'s Execution Sequence steps 5, 7, and 9 — this is a coordinated, planned multi-file edit, not an orphaned-consumer situation.
- 7 non-must-change consumers (`web-refinement-playbook.md`, `section-design-principles.md`, `.claude/skills/README.md`, `layout-architect.md`, plus 3 historical logs) reference the doctrine **by section name/pointer**, not by quoting the "full"/"lean" toggle words — they remain compatible with the F1 rename without edits.
- No cross-project consumers found (see Consumer Inventory finding above) — contradicts the change description's "shared across other projects" framing, which narrows rather than widens the actual blast radius.
- No hook output shape, subagent I/O schema, or report-heading contract is changed — this is prose-level doctrine, not a machine-parsed interface, except for the new F4 checklist contract (addressed under Dimension 5).
- Medium rather than Low because the change genuinely touches 6 files in lockstep (2 edit targets + 1 downstream skill fix + 3 log/checklist updates) and a partial land (e.g. CLAUDE.md's freeze block removed but `next-up.md` boxes left unchecked, or `SKILL.md` F4 not landed) would leave the doctrine internally inconsistent.

### Dimension 4: Reversibility
**Risk:** Medium

- `CLAUDE.md`, `explore-section.md`, and `SKILL.md` are ordinary prose edits — a `git revert` (each is a separate git repo: `axcion-design-studio` vs `ai-resources`) fully restores prior wording within the same working tree.
- `next-up.md`'s F1–F5 checkboxes are in-place edits (`- [ ]` → `- [x]`), not append-only — a revert cleanly restores the unchecked state.
- `decisions.md` and `session-notes.md` are appended to per the plan (session-plan.md step 9: "append a decision entry to `logs/decisions.md`, add ... content under this session's `logs/session-notes.md` header"). Per this risk framework's own Medium criterion ("modifies data/log files... session-notes.md... where revert leaves stale entries that carry forward"), a later revert of the CLAUDE.md/explore-section.md/SKILL.md wording would leave the `decisions.md`/`session-notes.md` entries recording "fix landed, freeze lifted" pointing at doctrine that no longer reflects that state — a manual reconciliation step, not something `git revert` alone fixes.
- No push occurs mid-session (project + workspace commit rules gate all pushes to `/wrap-session` with explicit operator confirmation), so nothing propagates beyond the local repos before a revert could happen — this keeps the dimension at Medium rather than High.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- F4's core mechanism — "a checklist a session must show it passed before dispatching layout-architect or any critic" — is, as described in `CHANGE_DESCRIPTION`, a **textual/procedural** control (a checklist written into `SKILL.md`), not a technical (hook-level) gate on the `Agent`/`Task` tool call. `friction-log.md`'s own root-cause #3 (quoted in `CLAUDE.md:46`) is explicit: *"A warning that can be read and bypassed is not a gate."* Until F4's concrete design is drafted, there is a real risk that the new "binding" halt is structurally the same kind of control (a sentence a session must remember to consult before calling `Agent`) that already failed on 2026-07-08, just phrased more forcefully. This is an implicit dependency on the orchestrating session's own discipline at the exact moment of dispatch — the same failure surface, not yet eliminated by design.
- This coupling is at least **documented at the change site** (it will live in `SKILL.md` itself, where `layout-architect`/critic dispatch is described) — which is why this is Medium and not High.
- Mitigating factor already in the plan: `session-plan-2026-07-09-S1.md` step 3 schedules a `/blindspot-scan` on the F2+F4 design specifically because both "rewire runnable infrastructure" (`next-up.md` calls this out explicitly) — this is the correct gate for exactly this "will it actually work" question, and should be run before F4 is considered done.
- F5 (cost pre-declaration) extends the already-established `[COST]` guardrail convention (workspace `CLAUDE.md § Session Guardrails`) into a harder y/n gate for this specific domain — this reuses an existing pattern rather than inventing a new one, so it does not add new coupling risk on its own.
- F3's stale-vs-departure split is a judgment-call distinction encoded in prose (consistent with how escalation triggers already work elsewhere in this doctrine) — no new technical coupling.

### Dimension 6: Principle Alignment
**Risk:** Medium

Grounded in `projects/strategic-os/ai-strategy/principles-base.md` (read; principles-base was available).

- **OP-5** ("Advisory automation ≠ enforcement automation... enforcement ('detect and correct') authority is an explicit per-component Phase-2 decision") is directly touched: F4 explicitly moves the "Do NOT use per-section" line from advisory to "a binding pre-dispatch halt." Per the framework's own carve-out, a High here would require this to be an *unacknowledged* upgrade — it is not. The move is loudly documented in `CLAUDE.md`'s freeze block, `next-up.md` F4, `friction-log.md § 2026-07-08` root cause #3, and `session-plan-2026-07-09-S1.md` — satisfying **OP-11** ("Surfacing/revising principles is a recurring obligation... loud, deliberate revision, never silent drift") and **OP-3** ("Loud failure over silent continuation"). This keeps the finding at Medium (a real principle move, correctly acknowledged) rather than High.
- **OP-9 / AP-7 / DR-7** (speculative abstraction — "generalize only when a second confirmed consumer exists"): not violated. This change is evidence-driven correction of a documented incident (`friction-log.md § 2026-07-08`), not speculative infrastructure for an absent consumer — it clears the complexity-budget gate's prong (b) (cited written evidence of the failure mode).
- **OP-2** (automate execution, gate judgment): F2 and F5 both *add* operator gates to judgment calls that were previously auto-executed (which direction to explore; whether to spend the subagent/time budget) — this serves OP-2 positively rather than creating tension.
- **OP-10** (system boundary): not touched — the Google Stitch tool-role guidance is unchanged by F1–F5.
- **OP-12** (closure before detection): not applicable — this change is a fix/closure of an already-detected failure mode, not new detection without closure.
- Residual Medium (not Low) because the OP-5 tension is real even though acknowledged, and because Dimension 5's open question (is F4's mechanism actually enforcement-grade, or still advisory-in-substance despite being labeled "binding"?) bears directly on whether the OP-5 move will land as claimed.

## Mitigations

- **Blast Radius (Medium):** Before marking the freeze resolved, verify all 6 must-change files from the Consumer Inventory are edited together in the same landing (not just `CLAUDE.md` + `explore-section.md`) — specifically confirm `SKILL.md` lines 38–41 (F4) and all five `next-up.md` checkboxes are updated before the freeze-block removal lands, so the doctrine files and the checklist stay mutually consistent.
- **Reversibility (Medium):** When appending the `decisions.md` / `session-notes.md` entries (session-plan.md step 9), cite the specific commit(s) that landed F1–F5 so a future revert of those commits can be traced back to the paired log entries and reconciled manually rather than left stale.
- **Hidden Coupling (Medium):** Before treating F4 as done, use the already-scheduled `/blindspot-scan` (session-plan.md step 3) to explicitly test the counterfactual: "would this checklist, as drafted, have actually stopped the 2026-07-08 misfire, or only if the session had chosen to read it?" If the answer is still contingent on session discipline alone, pair the doctrine wording with a concrete mechanical trip-wire at the dispatch site (e.g., require the orchestrating session to paste the checklist's pass/fail lines inline immediately before any `Agent` call to `layout-architect` or a critic, so the halt leaves a visible artifact rather than being silently skippable) rather than relying on prose alone.
- **Principle Alignment (Medium):** When recording the freeze-lift decision in `decisions.md`, explicitly cite **OP-5** and **OP-11** by ID ("deliberate advisory→binding upgrade for section-scoped critic dispatch, recorded per OP-11") so the principle revision is traceable in the decision log itself, not only implied by the surrounding freeze-block prose.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
