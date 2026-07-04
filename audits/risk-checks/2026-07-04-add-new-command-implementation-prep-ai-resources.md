# Risk Check — 2026-07-04

## Change

Add a new command `/implementation-prep` to ai-resources by creating ai-resources/.claude/commands/implementation-prep.md (declaring `model: opus`). The command is the "Finding-to-Implementation Translator" — it reads project-local files (output/implementation-prep/remediation-register.md, the packet template, window-outputs/W3.2-* roadmap + target-architecture, docs/protected-zones.md), drafts an implementation packet, updates the register row, and STOPS before execution. It writes packets + register rows only; it never edits ai-resources or executes a fix. Draft: projects/axcion-ai-system-redesign/output/steering/implementation-prep-command-DRAFT.md. This install also exits the project's design-only rail (first session in the window to make real ai-resources changes). Known concern to weigh: the command hardcodes project-local input paths, so as a canonical ai-resources command it is offered workspace-wide but only functions when invoked from the axcion-ai-system-redesign cwd (file-not-found elsewhere).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/implementation-prep.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/steering/implementation-prep-command-DRAFT.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/output/steering/remediation-register.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/window-outputs/W3.2-migration-roadmap.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/window-outputs/W3.2-target-architecture.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-redesign/docs/protected-zones.md — not yet present (the project has no `docs/` directory at all)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/protected-zones.md — exists

## Verdict

RECONSIDER

**Summary:** A prepare-and-stop command that is safe on cost/permissions and breaks nothing (0 live consumers), but is being installed into the canonical, autosynced commands directory despite serving exactly one project and one cwd — a DR-1/DR-7 placement + speculative-generalization misalignment (Dimension 6 High) compounded by multiple silent path-coupling defects (Dimension 5 High), including an input that does not resolve even at its home cwd.

## Consumer Inventory

The new command file has **no live consumers** — nothing in `ai-resources/` (commands, agents, hooks, always-loaded `CLAUDE.md`) invokes `/implementation-prep`, references its register, or parses any contract it introduces. Every hit for the command token and its substrate is a **project-local planning/log record** in `axcion-ai-system-redesign/logs/` (session-plan, decisions, session-notes, scratchpad) that *documents the intent to install* — historical records, none of which must change for the command to work. The command's substrate (`remediation-register.md`, `implementation-packet-template.md`) is referenced only by its own project-local `output/steering/README.md`.

Note the inventory also surfaces the **inverse** dependencies the command *relies on* (carried into Dimension 5, not consumers of the change): `/implementation-triage` (exists — heavily referenced across `ai-resources`) and `/risk-check` (exists) as gate commands, plus the W3.2 file schemas.

| Consumer path | Reference type | Must change? |
|---|---|---|
| projects/axcion-ai-system-redesign/logs/session-plan-2026-07-04-S1.md | documents | no |
| projects/axcion-ai-system-redesign/logs/decisions.md | documents | no |
| projects/axcion-ai-system-redesign/logs/session-notes.md | documents | no |
| projects/axcion-ai-system-redesign/logs/scratchpads/2026-07-04-11-42-scratchpad.md | documents | no |
| projects/axcion-ai-system-redesign/output/steering/README.md | documents (substrate) | no |

Total: 5 consumers, 0 must-change. All are project-local documentation/logs of the plan — **no command, agent, hook, or always-loaded file consumes `/implementation-prep`.** The new command file itself has no consumers yet (it is `not yet present`); this inventory covers the contract/token it introduces (`/implementation-prep`, `packet-drafted` register status) — grep found no live parser of either outside the project substrate. An effectively **empty live-consumer set is itself the finding**: this is an isolated addition whose only "reach" is that it lands in the shared, autosynced commands directory (see Dimensions 3, 5, 6).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No ongoing token cost — a slash command loads only on invocation, not per session. DRAFT frontmatter is a standard command block (`description`/`argument-hint`/`model: opus`, DRAFT lines 14–18); it is not a hook, `@import`, or always-loaded file.
- Adds nothing to any always-loaded file — neither workspace `CLAUDE.md`, project `CLAUDE.md`, nor `ai-resources/CLAUDE.md` references the command; grep for `implementation-prep` returned zero hits in any `CLAUDE.md`.
- No auto-load hook and no broad-trigger skill introduced — the change is a single command file under `.claude/commands/`.
- Minor caveat (not scored up): install checklist step 5 ("register the command wherever the command catalogue lives", DRAFT line 94) adds one catalogue row; catalogues are not always-loaded, so no per-turn cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No permission change — no `settings.json` (any layer) `allow`/`ask`/`deny` edit is part of this change. The change touches only `.claude/commands/`.
- No new tool family or capability — the command is explicitly bounded: "it writes packets + register rows only; it never edits ai-resources or executes a fix" (CHANGE_DESCRIPTION), and DRAFT Rule 2 (line 76): "writes a packet + register row, never edits `ai-resources` or executes a fix." No shell escalation, no external API, no cross-repo write.
- Writes stay within the project `output/` scope (packets under `output/.../packets/`, register-row edits) — an already-established Write/Edit pattern, not a new authorization.

### Dimension 3: Blast Radius
**Risk:** Low

- **From the Step 1.5 inventory: 5 consumers, 0 must-change** — all are project-local planning logs/README that document the plan; no command, agent, hook, or always-loaded file invokes or parses `/implementation-prep`. Nothing breaks when the file is added.
- Files touched directly by the install itself: **1 new file** (`ai-resources/.claude/commands/implementation-prep.md`; confirmed absent today). Adding a file to `.claude/commands/` does not modify any existing command's behavior.
- No outward contract change — the command introduces the `/implementation-prep` token and `packet-drafted` status, but grep found no existing caller that parses either outside the project's own substrate. It is contract-*consuming*, not contract-*imposing* (dependencies handled under Dimension 5).
- Adjacent bundled change (noted, not scored here): the same session plan renames `output/steering → output/implementation-prep` touching register/template/2 packets/README; per the session-plan "Check A" those are relative sibling links that survive the rename, and the scope is project-local and backwards-compatible.
- **Caveat carried forward:** the file lands in the *shared, autosynced* commands directory — `ai-resources/docs/protected-zones.md` line 16: `.claude/commands/*.md` (shared) are "Autosynced to all projects." Today that directory holds 87 commands; this becomes the 88th, *offered* workspace-wide. Availability radiates workspace-wide even though functionality does not — but this surfaces a *broken-elsewhere* command rather than breaking any existing workflow, so it scores Low here and drives Dimensions 5 and 6.

### Dimension 4: Reversibility
**Risk:** Medium

- The command file alone reverts cleanly — a new tracked file in `ai-resources`; `git revert`/delete fully restores prior state (Low in isolation).
- But the landing is bundled and requires extra cleanup beyond a single-file revert: (a) install checklist step 5 registers the command in the command catalogue (DRAFT line 94) — a second edit a command-file revert would leave stale; (b) the same-session `git mv output/steering → output/implementation-prep` plus cross-link edits across register/template/2 packets/README (session-plan step 5) must be reverted in lockstep; (c) shared commands are autosynced/symlinked to projects (protected-zones.md line 16) — reverting the canonical file can leave dangling project symlinks.
- No state propagates beyond git in this action — push is gated to wrap (workspace `CLAUDE.md` Push behavior), the command adds no hook/cron, and it performs no external write. So rollback stays within git but is multi-step → Medium.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Silent cwd assumption.** The command's five inputs are project-relative paths (DRAFT lines 28–32: `output/steering/…`, `window-outputs/W3.2-*`, `docs/protected-zones.md`). Installed into the canonical shared dir but invoked from any other project cwd → raw file-not-found, not a clear "wrong project" message (CHANGE_DESCRIPTION's own flagged concern). Multiple implicit dependencies on the invoking cwd.
- **An input that does not resolve even at the home cwd.** DRAFT line 32 lists `docs/protected-zones.md` (the SO-review trigger, used at Steps 3/§Rule 3). Verified: `projects/axcion-ai-system-redesign/docs/` **does not exist** — the project has no `docs/` directory, so this input silently reads nothing even when run from the correct project root. Only `ai-resources/docs/protected-zones.md` exists. This is a latent defect in the command as drafted, not merely a portability edge case.
- **Dependence on gate commands the register itself plans to merge/retire.** The packet gate table hardcodes `/implementation-triage` and `/risk-check` (DRAFT lines 58–61). Both exist today (grep confirms `/implementation-triage` is defined and widely referenced). But the very register this command reads schedules command merges/retirements in Phase 2 (`remediation-register.md` rows M-B2 "`/prime` absorbs mandate+plan", M-B3 "retire `/resolve`", etc.) — a self-referential coupling where the command's own workstream can rename the gates it depends on.
- **Substrate contract separated from the command.** The command parses the register schema, the packet-template schema, and W3.2 §-anchors (e.g., target-arch §10 SO-v2 table, DRAFT lines 44–56), but those contracts are documented only in the project-local `output/steering/README.md`/template — a reader of the installed `ai-resources` command cannot see them. New parse contract not documented at the change site.
- **Functional overlap with an existing mechanism — acknowledged, which mitigates.** `decisions.md` line 72 records the command "overlaps SO v2's B1 Implementation Contract + the Nav charter's Brief step." The command body names this and states convergence ("If SO v2 ships its B1 Implementation Contract, `/implementation-prep`'s packets converge into it", DRAFT line 83) — so the overlap is loud, not silent. This is the one coupling that is documented; the cwd/path couplings above are not.

### Dimension 6: Principle Alignment
**Risk:** High

- **DR-1 / DR-3 (placement) — clear misalignment.** DR-1's explicit test is "could this serve more than one project?" As drafted, the command hardcodes axcion-local relative paths and one of its inputs does not even exist in-project — it can serve *exactly one* project from *one* cwd. Placing it in the canonical `ai-resources/.claude/commands/` (the shared, autosynced tier) fails DR-1's test; the correct home for a single-project operating function is project-local or workspace-root (DR-3).
- **DR-7 / OP-9 / AP-7 (speculative generalization) — clear signal.** The Step 1.5 inventory found **zero live consumers**; the command's own install checklist says "keep project-local unless a second consumer appears" (DRAFT line 92, Reuse-first). Installing to the canonical/shared tier now generalizes ahead of a second confirmed consumer — the exact "hooks/reach for later" pattern DR-7 forbids and AP-7 names. The chosen action contradicts the checklist's own guidance, so this generalization is **not loudly acknowledged as a deliberate DR-7 revision**.
- **OP-11 / OP-3 (loud revision, not silent drift) — residual divergence.** The install "exits the project's design-only rail." Project `CLAUDE.md` still asserts the opposite in two places: the Design-only rail ("No session implements, deletes, converts, or migrates anything") and decision D1 ("The window builds zero new skills, agents, commands, or hooks by design"). The rail-exit *is* operator-authorized and recorded in the session logs (decisions.md, session-notes mandate) — loud at the session level — but the standing `CLAUDE.md` rule is not yet revised, so practice diverges from the written rule. OP-11 requires that divergence be closed loudly (revise the rule or correct the practice), not left implicit.
- **Aligned dimensions (the change serves these principles).** OP-2 / OP-5: the command "prepares/translates; it never implements" and delegates judgment to gates ("do not self-assess the risk class — it comes from the gate", DRAFT line 59) — advisory-and-stop, not a silent enforcement upgrade. OP-12: it is a *closure-side* mechanism (turns already-accepted W3.2 findings into gated packets), not new detection ahead of a closure channel. OP-10: it operates wholly within Claude Code; the SO reference is governance, not cross-tool control. These keep the *design* sound — the misalignment is placement/generalization and an unclosed rule-vs-practice gap, not the command's behavior.
- Principles-base index was readable at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID set OP/DR/QS/AP); IDs above are cited from it.

## Recommended redesign

- **Rescope placement to resolve DR-1/DR-3/DR-7/AP-7 and the whole portability/coupling class (primary path — rescope, not a technical patch).** Install `/implementation-prep` as a **project-local** command (in `projects/axcion-ai-system-redesign/.claude/commands/`, or the workspace-root tier) rather than canonical `ai-resources` — it serves one project and functions only from that cwd, so DR-1's "serves >1 project?" test says project-local. This also shrinks the design-only-rail exit to its minimum and stops offering a broken-elsewhere command across the 87-command autosynced surface. *Only if* canonical reach is genuinely wanted: first relocate the substrate (register + packet template + packets) to a canonical home and parameterize the input paths so a **second** project can actually invoke it — satisfying DR-7's second-consumer requirement *before* generalizing, not after.
- **Make the design-only-rail revision loud and recorded (OP-11 / OP-3).** Before any install, update project `CLAUDE.md` Window Operating Rules / decision D1 to state explicitly that this session exits the design-only rail and why, so the standing rule matches practice instead of contradicting it.
- **Fix the two coupling defects before install regardless of placement (reduces Dimension 5).** (a) Correct the `docs/protected-zones.md` input — it resolves to nothing even at the home cwd (no project `docs/` dir); point it at `ai-resources/docs/protected-zones.md` or add a project copy. (b) Add a one-line cwd scope guard at command start that checks for the register file and emits a clear "run from the axcion-ai-system-redesign project root" message instead of a raw file-not-found.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: DRAFT command body line references (lines 14–94), `remediation-register.md` rows (M-B2/M-B3), `ai-resources/docs/protected-zones.md` line 16 (autosync), repo-wide greps for `implementation-prep`/`remediation-register`/`implementation-triage` (consumer inventory), filesystem checks confirming the new file is absent, the project `docs/` directory is absent, and the 87-command shared dir, plus principle IDs cited from the readable `principles-base.md`. No training-data fallback was used on any read.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is RECONSIDER._

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-07-04-implementation-prep-placement.md

**Concur with RECONSIDER? Yes.** The routing baseline routes this *away* from canonical before any principle is invoked. `repo-architecture.md` Q1: all inputs (`output/steering/…`, `window-outputs/W3.2-*`, `docs/protected-zones.md`) are single-project/single-cwd → "tightly coupled to one project → its own `.claude/`." It is the same shape as `kb-audit` — a named project-local exception. DR-1/DR-3/DR-7 all agree (`principles.md § DR-1/§ DR-3/§ DR-7`, `§ AP-7`). The draft even contradicts itself: install-checklist item 3 keeps the *data* project-local "reuse-first" while sending the *command* canonical — a command can't be more reusable than its inputs.

**Is "install project-local" the right path? Partially.** Project-local is the correct home, but it is a placement fix only. It does not close the design-only-rail exit, the dangling input, or the path fragility.

**Three risks the dimension review missed:**
- **(A) Blast radius is mis-scored Low** — inconsistent with the High coupling score. Auto-sync (`risk-topology.md § 1/§ 3`) pushes a single-cwd command into 21 project menus; bare relative paths then silently resolve against the wrong project's cwd. Catalog pollution + wrong-cwd reads is not Low.
- **(B) No *first* consumer, not just no second** — inputs are W3.2 (the window's terminal unit) and `protected-zones.md`, which is **verified absent** (Glob returned nothing). The command can't run in any cwd today. Building the consumer ahead of the substrate trips `§ DR-7` and `§ OP-12`.
- **(C) The rail exit has no dimension slot, and project-local install does not close it** — installing in *either* location breaches project CLAUDE.md's design-only rail and decision D1 ("builds zero new commands"). Framing it as "make the exit loud" under-reads it; treating relocation as the fix is silent conflict resolution (`§ OP-3/§ AP-1`).

**Position:** Keep it out of `ai-resources`. Do not install this session — the rail exit is an explicit operator decision, named not smoothed. If built: project-local home, fix `protected-zones.md` and confirm W3.2 inputs exist, replace bare relative paths with an absolute anchor / cwd guard. And answer first via `/implementation-triage` whether a zero-judgment orchestrator needs to be a persisted command at all vs. a project-local skill (`§ DR-7/§ AP-7`).
