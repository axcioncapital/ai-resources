# Risk Check — 2026-07-03

## Change

Three structural backlog fixes in ai-resources (item 4, a SETUP.md path typo, is non-structural and excluded from this risk-check).
(1) Add a documented subagent-spawn fallback to canonical commands /risk-check, /qc-pass, /refinement-pass. At each command's spawn step (risk-check.md Step 11 "Spawn one risk-check-reviewer subagent"; qc-pass.md Step 3 "Launch the qc-reviewer subagent"; refinement-pass.md Step 3 "Launch the refinement-reviewer subagent"), add: when the named subagent TYPE (risk-check-reviewer / qc-reviewer / refinement-reviewer) fails to resolve — the known failure mode when a canonical command runs from a *project* session, because `--add-dir` grants file access but does NOT register agent types — fall back to spawning the built-in `general-purpose` agent with the reviewer's agent definition read from disk (absolute path under ai-resources/.claude/agents/) and inlined into the prompt. The change is additive: the existing named-agent path stays the default; the fallback only fires on spawn failure. risk-check.md Step 10's file-existence check ("Verify the subagent definition exists ... Abort if missing") stays AS-IS — the fallback is added at the spawn point (Step 11), not at Step 10. These 3 commands are symlinked from workspace-root .claude/commands/ AND all ~20 project .claude/commands/ dirs to the ai-resources canonical copy (verified: readlink shows symlinks), so editing the canonical copy propagates automatically — no paired-copy sync needed.
(2) Add to docs/audit-discipline.md § Risk-check change classes a bounded carve-out OR a confirm-before-skip rule for the settings.json/settings.local.json change class. Closes a hole where a session (2026-07-03 S2) self-authorized an undocumented "materiality" exception to skip the mandatory /risk-check gate on gitignored, machine-local settings.local.json edits (defaultMode/additionalDirectories toward the documented zero-prompt floor, zero tracked/cross-repo blast radius). Constraint: must NOT contradict workspace CLAUDE.md Autonomy Rule #9, which treats the settings.json class as a pause condition — so the wording must be a BOUNDED exemption with a MANDATORY logged exemption (session must name the carve-out in its session note), or a confirm-before-skip rule; never a silent blanket exemption an executing session can self-apply.
(3) Add a /reconcile pointer line to the new-project CLAUDE.md template fragment under ai-resources/templates/project-claude-md/ (edit the fragment, NOT /new-project, per templates/README.md consumer contract). Scope the pointer to matured/output-producing projects so it does not mislead in early-stage projects where /reconcile clean-aborts (present-but-inert without per-project context/ files).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/qc-pass.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/refinement-pass.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/ — exists (fragment dir)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/README.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists (workspace root; Autonomy Rule #9)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/risk-check-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Three additive, backwards-compatible edits (three commands, one governance doc, one template fragment) with no permission or always-loaded-token cost of consequence; risk concentrates in three Mediums — a partial fix that leaves sibling spawn sites with the same latent bug, a silent `model: opus` tier-drop in the general-purpose fallback, and a bounded-gate relaxation that is loud-by-design but wording-dependent.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/agents/risk-check-reviewer.md` | imports (fallback reads def from disk at spawn-failure) | no |
| `ai-resources/.claude/agents/qc-reviewer.md` | imports (fallback def source) | no |
| `ai-resources/.claude/agents/refinement-reviewer.md` | imports (fallback def source) | no |
| 67 symlinks → canonical `risk-check.md`/`qc-pass.md`/`refinement-pass.md` (workspace-root `.claude/commands/` + ~20 project dirs + harness + KBs) | imports (auto-propagate) | no |
| `projects/positioning-research/.claude/commands/qc-pass.md` | co-edits (REAL copy, NOT a symlink — will not receive the fix) | no |
| `projects/positioning-research/.claude/commands/refinement-pass.md` | co-edits (REAL copy, NOT a symlink) | no |
| `ai-resources/workflows/research-workflow/.claude/commands/qc-pass.md` | co-edits (REAL workflow-local variant) | no |
| `ai-resources/.claude/commands/refinement-deep.md` | invokes `qc-reviewer` + `refinement-reviewer` by type (Step 3 — same latent bug, NOT covered) | no (flagged gap) |
| `ai-resources/.claude/commands/friday-journal.md` | invokes `qc-reviewer` by type (Step 5.5 — same latent bug, NOT covered) | no (flagged gap) |
| `ai-resources/.claude/commands/cleanup-worktree.md`, `pm.md`, `list-critical-resources.md` | documents/invokes `qc-reviewer` | no |
| `CLAUDE.md` (workspace, Autonomy Rule #9) | parses/documents the risk-check settings.json gate — carve-out must stay consistent (always-loaded) | no (consistency-coupled) |
| `ai-resources/.claude/commands/risk-check.md`, `qc-pass.md` Step 3a | documents `audit-discipline.md § Risk-check change classes` | no |
| `projects/strategic-os/ai-strategy/principles-base.md` (DR-8) | documents the binding risk-check gate | no |
| `ai-resources/.claude/commands/new-project.md` | imports the `project-claude-md/` fragments (hardcoded enumeration, lines 434, 462-471, 474-478) | conditional — no if pointer added to an EXISTING fragment; **yes** if a new fragment/section is created |
| `ai-resources/templates/README.md` | documents the fragment consumer contract ("update when adding a fifth consumer") | no if existing-fragment line; yes if new fragment |

Total: 15+ distinct consumers (67 symlinks consolidated as one row), 0 strictly must-change under the intended additive/backwards-compatible design. One consumer (`new-project.md`) is conditional — it must change only if change (3) is implemented as a NEW fragment/section rather than a line inside an existing fragment.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change (1) edits three command *bodies* — these load only when the command is invoked (pay-as-used), not every turn. Added fallback text is ~40-80 tokens per command body; no always-loaded impact. `risk-check.md` confirms no auto-firing hook: "There is NO SessionStart / Stop / PreToolUse hook that auto-fires `/risk-check`" (risk-check.md:30).
- Change (2) edits `audit-discipline.md`, a read-on-demand doc, not an always-loaded file — its own header gates loading: "When to read this file: Before applying a permission change ... OR before landing a structural change" (audit-discipline.md:3). No per-turn cost.
- Change (3) is the only always-loaded addition: one `/reconcile` pointer line propagates into every *new* project's `CLAUDE.md` via `/new-project` (new-project.md:408-417). A single short line (< ~30 tokens), lands only on new scaffolds (existing projects are not backfilled — templates/README.md:48 "existing projects do not receive newly-canonized sections"). Below the ~50-token Medium threshold.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` `allow`/`ask`/`deny` edits in any of the three changes. Change (2) is *about* the settings.json risk-check gate but edits a governance *doc* (`audit-discipline.md`), not any settings file.
- The change (1) fallback spawns the built-in `general-purpose` agent — an already-established pattern in the repo (grep: 24+ live files reference `general-purpose`, e.g. `wrap-session.md`, `drift-check.md`, `contract-check.md`). No new agent type, tool family, or capability introduced.
- Reading an agent definition from disk uses `Read`, already permitted for these commands. No permission surface widening.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 5 (3 command bodies + 1 doc + 1 template fragment).
- **Partial fix across the spawn-site population (unanticipated by the change description).** The change fixes the agent-type-resolution failure at only 3 of N spawn sites. Confirmed sibling spawn sites with the SAME latent bug, NOT covered: `refinement-deep.md` Step 3 spawns BOTH `qc-reviewer` AND `refinement-reviewer` directly by type ("Spawn both subagents in a single message", refinement-deep.md:21-24); `friday-journal.md` Step 5.5 spawns `qc-reviewer` directly ("Spawn the `qc-reviewer` subagent", friday-journal.md:157). If those commands are ever run from a project session, they retain the exact failure this change fixes elsewhere.
- **The "no paired-copy sync needed" claim is partly wrong.** Symlink verification (`find -type l`) confirms 67 symlinks to the canonical copies — but `projects/positioning-research/.claude/commands/qc-pass.md` and `refinement-pass.md` are REAL files (NOT symlinks), and `ai-resources/workflows/research-workflow/.claude/commands/qc-pass.md` is a separate REAL variant. These will NOT receive the propagated fallback. Not a break (they stay on pre-change behavior), but it contradicts the change description's blanket "all ~20 project dirs are symlinked" claim.
- Change (2) touches a governance contract (`audit-discipline.md § Risk-check change classes`) referenced by `risk-check.md`, `qc-pass.md` Step 3a, DR-8, and workspace `CLAUDE.md` Autonomy Rule #9. The carve-out is additive (adds an exemption path, removes no gate), so no consumer must change — but it is consistency-coupled to the always-loaded Autonomy Rule #9.
- Change (3): `/new-project` consumes the fragments via a HARDCODED enumeration, not a directory walk (existence loop new-project.md:434; fresh-creation `cat` block :462-471; idempotent-append pairs :474-478). Adding the pointer as a line inside an *existing* fragment propagates with zero `/new-project` edits (backwards-compatible). Only if a NEW fragment/section is created does `/new-project` become must-change at three sites — which would break the change's own "edit the fragment, NOT /new-project" constraint.
- Net: multiple canonical/shared files touched and one contract adjacent to an always-loaded rule, but every edit is additive and backwards-compatible with 0 strictly-required consumer edits. Medium, driven by the partial-coverage gap and the non-propagating real copies.

### Dimension 4: Reversibility
**Risk:** Low

- All three changes are plain file edits (three command bodies, one doc section, one template-fragment line). `git revert` restores prior state cleanly in the same working tree.
- No log/registry mutation (no append to `innovation-registry.md`, `improvement-log.md`, `session-notes.md`), no `settings.json` change, no external write, no push, no automation (hook/cron/symlink) created that could fire between land and revert.
- Minor caveat (does not raise the level): a project scaffolded by `/new-project` *between* landing change (3) and a later revert would carry the pointer line in its own `CLAUDE.md`; reverting the template does not retro-edit already-created project files. The residue is a benign, inert pointer line — no cleanup pressure.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Silent `model: opus` tier-drop in the fallback (confirmed).** All three agent defs declare `model: opus` (risk-check-reviewer.md:4, qc-reviewer.md:4, refinement-reviewer.md:4). The `general-purpose` fallback agent does NOT inherit a spawned def's frontmatter `model:` — it runs on the session's model. So the fallback path can silently run an Opus-tier reviewer (risk-check / QC) on a non-Opus model, degrading review quality precisely in the project-session case the fallback exists to serve. This coupling is invisible from the spawn site unless the fallback prompt explicitly re-asserts the tier.
- **Agent-def path resolution.** The change specifies "absolute path under ai-resources/.claude/agents/". In a project session the canonical location must be resolved by walk-up (the idiom `/new-project` uses at new-project.md:433 `FRAG_DIR="$AI_RES/templates/project-claude-md"` after ancestor search), not a machine-hardcoded absolute path, or the fallback breaks under a different checkout root.
- Change (2): the carve-out is implicitly coupled to workspace `CLAUDE.md` Autonomy Rule #9 (always-loaded: "Structural change classes gated by `/risk-check`"). Two canonical sources must agree; if the doc relaxes what the always-loaded rule forbids, an executing session reads a live contradiction. The change description names this constraint, which is good — but the coupling is real and the wording is load-bearing.
- Change (3): coupled to `/reconcile`'s clean-abort contract — verified: `/reconcile` "aborts with instructions" when `context/mandate-rubric.md` + `context/resource-activation-map.md` are absent (reconcile.md:9, Step 2 :33-37). The "scope to matured projects" intent is achievable only in the pointer's *prose* (conditional wording), since `/new-project`'s append loop writes fragments unconditionally to every project — there is no maturity gate in the mechanism.
- Multiple implicit dependencies, one of them a genuine silent behavior change (tier drop) → Medium.

### Dimension 6: Principle Alignment
**Risk:** Medium

- principles-base read successfully at `projects/strategic-os/ai-strategy/principles-base.md` (42 IDs, 41 active).
- Change (1) — **aligns.** It closes a confirmed, present-day defect (canonical command run from a project session cannot resolve the agent type; the 67-symlink structure confirms project sessions do invoke these commands today). This is closure of an existing failure, not building for an absent consumer — consistent with OP-9 / DR-7 / AP-7 (no speculative abstraction: the consumer and the failure exist now). Also consistent with OP-12 (closure over new detection — it adds no new detector).
- Change (2) — **Medium tension, but loud-by-design (not a violation).** Relaxing the `/risk-check` gate for the settings.local.json class edges a *binding* gate (DR-8: "Verdict is binding; downgrading to push through is prohibited") and touches OP-2 (gate judgment), OP-5 (advisory vs enforcement), AP-4 (rubber-stamp approvals). BUT the change is explicitly designed as the OP-11 / OP-3 mechanism working correctly: it converts a *silent* self-authorized skip (the 2026-07-03 S2 incident — "silent drift") into a *recorded, bounded* carve-out (mandatory logged exemption OR confirm-before-skip; never a silent blanket an executing session can self-apply). Per the agent's Dimension-6 special handling, a principle revision that *loudly acknowledges itself* is legitimate and scores Medium/Low, not High. Residual tension: the guardrail lives entirely in the wording — if the final text lands as a blanket exemption or diverges from Autonomy Rule #9, it flips to an AP-4 / OP-5 drift. Scored Medium to keep that wording check explicit.
- Change (3) — **aligns.** A pointer to an existing command, placed by editing the canonical fragment (DR-1 / DR-3 correct tier and home; templates/README consumer contract honored). Not speculative, not boundary-expanding (OP-10 untouched), not detection-without-closure (OP-12 untouched).
- Net Medium, driven entirely by change (2)'s gate-relaxation tension, which is mitigated by its explicit OP-11-compliant loud/bounded design.

## Mitigations

- **Blast radius (partial coverage):** Before landing change (1), decide explicitly for `refinement-deep.md` (Step 3, spawns `qc-reviewer` + `refinement-reviewer`) and `friday-journal.md` (Step 5.5, spawns `qc-reviewer`) whether they receive the same fallback — either extend the fallback to them or record in the commit/plan why they are excluded (e.g., they only run in the ai-resources session where the type resolves). Do not ship a fix that leaves the identical latent bug at sibling spawn sites unremarked.
- **Blast radius (non-propagating copies):** Note in the commit that `projects/positioning-research/.claude/commands/{qc-pass,refinement-pass}.md` and `ai-resources/workflows/research-workflow/.claude/commands/qc-pass.md` are REAL (non-symlink) copies that will NOT receive the fallback; decide whether to re-symlink them or accept they stay on pre-change behavior. Correct the change description's "no paired-copy sync needed" claim accordingly.
- **Hidden coupling (tier drop):** In the change (1) fallback, either have the general-purpose fallback prompt explicitly re-assert the reviewer's tier (`model: opus`) or document in the command that the fallback path runs at the session model. general-purpose does not inherit the spawned def's `model:` frontmatter — otherwise the QC/risk reviewer silently degrades to the session tier in exactly the project-session case the fallback serves.
- **Hidden coupling (path resolution):** Resolve the agent-def path via ancestor walk-up to `ai-resources/` (the `$AI_RES` idiom already used in `new-project.md:433`), not a machine-hardcoded absolute path, so the fallback works from any checkout/project root.
- **Principle alignment + change (2):** Land the carve-out as a bounded, logged exemption whose wording explicitly cross-references and does not contradict workspace `CLAUDE.md` Autonomy Rule #9; require a mandatory session-note entry naming the carve-out (never a silent self-apply). Verify the final wording against Rule #9 side-by-side before commit — the two are the coupled sources and the wording is load-bearing.
- **Change (3) scope safety:** Add the `/reconcile` pointer as a LINE inside an EXISTING fragment (name the target fragment explicitly in the plan) so `/new-project`'s hardcoded enumeration (new-project.md:434, 462-471, 474-478) needs no edit; and word the pointer conditionally ("once this project has authored `context/mandate-rubric.md` + `context/resource-activation-map.md` and produced outputs") so it does not mislead in early-stage projects where `/reconcile` clean-aborts.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `find -type l` symlink verification, verbatim quotes from the referenced files and CHANGE_DESCRIPTION, principle IDs from `principles-base.md`). No training-data fallback was used on any fetch/read failure.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-riskcheck-2nd-opinion-subagent-fallback-carveout-reconcile.md`. **The SO materially disagrees with the "apply 6 mitigations and proceed" framing on several load-bearing points — surfaced to the operator per `/risk-check` Step 17e; not auto-resolved.**_

**Concurrence — split the bundle.** Concur with PROCEED-WITH-CAUTION for changes {1, 3}, but change 2 (the gate carve-out) should be split out and re-risk-checked alone. The six dimensions scored the *bundle*, averaging change 2's principle risk (a risk-check-gate relaxation) across two near-zero items — so approving "the change" approves a gate relaxation on the coattails of a bug-fix, the exact silent-materiality pattern change 2 exists to close (`principles.md § OP-5`, `§ DR-8`).

**(a) refinement-deep + friday-journal:** neither "5th inline copy" nor "defer." They are *confirmed* consumers of the same defect, so DR-7/AP-7 do not license deferring them (`§ OP-3`). Factor one shared fallback pattern across all confirmed sites; if too large this session, park the whole item — do not ship a 3-site patch and leave 2 known-broken siblings (workspace structural-fix-default). Verify friday-journal's project-session exposure before excluding it.

**(b) silent Opus→session-model drop: blocking, not a doc choice.** "Document the tier-drop" is the OP-3/AP-2 failure for a *judgment* gate. The fallback fires exactly in the project-session case, where routine work runs on Sonnet (`repo-state.md § 1`) — silently downgrading an independent QC/risk reviewer from Opus (`§ QS-5`, `§ QS-1/QS-9`, `§ QS-8`; `risk-topology.md § 1` High). Re-assert `model:opus` on the spawn (the per-spawn override exists), or fail loud. This is the one mitigation raised to a hard sub-gate.

**(c) carve-out vs confirm-before-skip:** a discretionary logged carve-out leaves the skip decision with the session — reproducing the `OP-5` hole with a paper trail (wrong-goal-seeking). Name the class question first: if `settings.local.json` is genuinely out-of-class (per-machine, gitignored — `§ DR-3`), *clarify it out-of-class* (structural fix); if it can carry material effect, *confirm-before-skip* (`§ OP-2`, `§ AP-4`). Not the self-serve carve-out.

**Risks the dimensions missed:** (1) change 1 edits `/risk-check` itself — self-referential trust-root; require a manual `/risk-check`-from-project-session test before landing. (2) Bundle-coherence: change 1's silent tier-drop is a *new instance* of the bug-class change 2 closes. (3) **Symptom-vs-cause** — the root gap is agent-*type* resolution under `--add-dir`, while the sync hook already symlinks the def *files*; the fallback is N command-layer workarounds for one topology-layer gap (`§ AP-9`, `§ DR-7`). (4) change 2 is a two-end doc contract — edit `audit-discipline.md` + `risk-topology.md § 3`/`§ 4` together; also a dangling `risk-topology.md § 1.2` reference to repair.
