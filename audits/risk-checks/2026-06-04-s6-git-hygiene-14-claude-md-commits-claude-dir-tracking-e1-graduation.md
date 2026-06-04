# Risk Check — 2026-06-04

## Change

Two structural changes proposed in session S6 auto-mode:
(1) GIT-HYGIENE — commit the remaining 14 project-repo Session-Boundaries CLAUDE.md conversions (explicit-path commits per repo across 14 foreign repos, foreign drift untouched), AND decide the per-project .claude/ command/agent-dir tracking model (commit-as-is vs gitignore+symlink-from-canonical). The .claude/ tracking-model decision is an unresolved architecture question flagged in S5 as needing a deliberate reviewed pass.
(2) E1 GRADUATION — run /graduate-resource on doc-scanner-agent from projects/repo-documentation/.claude/agents/doc-scanner-agent.md to canonical ai-resources, creating a new canonical agent + symlink distribution across projects.

Evaluate BOTH changes. Treat the .claude/ tracking-model decision as a distinct sub-change with its own risk profile (it is an unresolved architecture question, not yet a concrete edit) — score it on reversibility and blast radius accordingly.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/agents/doc-scanner-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/ — exists (canonical agent dir; graduation target)
- 14 project-repo CLAUDE.md files under /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/*/CLAUDE.md — exist (Session-Boundaries conversions, uncommitted)

## Verdict

RECONSIDER

**Summary:** The 14-repo CLAUDE.md commit is low-risk and ships cleanly, but it is bundled with two changes that fail on their own dimensions — the E1 graduation is a speculative abstraction (OP-9/AP-7/DR-7: a deeply project-specific agent with one hardcoded caller and zero second consumer) that the `auto-sync-shared.sh` hook will silently fan out as symlinks into ~10 projects, and the `.claude/` tracking-model decision is an unresolved architecture question that cannot be scored as a concrete edit and must not be settled inside an auto-mode session.

## Consumer Inventory

Search terms: `doc-scanner-agent`, `doc-scanner`, `doc scan` (E1 target); `Session Boundaries` / `session-boundaries` marker, `projects/*/CLAUDE.md` basenames (git-hygiene target); `.claude/agents`, `shared-manifest.json`, `auto-sync-shared.sh` (tracking-model sub-change).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/friday-checkup.md` (Step H, lines 196–204) | invokes (spawns `doc-scanner-agent` by name; hardcodes `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` path + project-specific brief) | yes — if graduation is meant to retarget the canonical copy; no — if the project-local file is left in place (then graduation is redundant) |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | imports (auto-symlinks every canonical `.claude/agents/*.md` into manifest-bearing projects on SessionStart) | no (fires automatically) — but this is the fan-out vector, see Dimension 3 |
| ~10 `projects/*/.claude/shared-manifest.json` (obsidian-pe-kb, repo-documentation, interpersonal-communication, ai-development-lab, project-planning, strategic-os, research-pe-regime-shift-advisory-gap, axcion-ai-system-owner, corporate-identity, …) | imports (opt-in targets the auto-sync hook distributes canonical agents into) | no (silent recipients of a new `doc-scanner-agent.md` symlink post-graduation) |
| `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` (real file) | co-edits (the graduation source; basename-collides with the canonical name graduation creates) | no — but creates a dual-registration / basename collision the source agent's own Phase 3 rule (lines 76) flags as operator-surfacing |
| `projects/repo-documentation/references/documentation-structure.md` §4.1 | parses (agent's Phase 5 entry schema is governed by this spec) | no (project-local; unaffected by graduation but proves the agent is project-coupled) |
| `ai-resources/docs/agent-tier-table.md` | documents (agent-tier registry; doc-scanner-agent currently ABSENT — F-13 in 2026-05-08 repo-dd) | yes if graduated (canonical agents must have a tier-table entry per QS-6) |
| 13 `projects/*/CLAUDE.md` (git-hygiene target) | co-edits (each is a modified file in its own nested git repo, staged per-repo) | yes (these ARE the commit) |

Total: 7 distinct consumer classes; 3 must-change (friday-checkup caller, agent-tier-table, the 13 CLAUDE.md files themselves). Note: workspace-root `git status` shows `projects/` is `??` (untracked) and each project is a **separate nested git repo** ignored at root (`.gitignore` lines 13–27) — so the 14 commits land in 13 independent foreign repos, not the workspace repo. The change-description says "14" but the filesystem shows 13 modified CLAUDE.md files (one project — `personal` — has no Session-Boundaries conversion or is absent from the modified set); this count discrepancy is itself a finding.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The 13 CLAUDE.md conversions are already written; committing them adds no new always-loaded token cost — each project's CLAUDE.md already loads every turn in that project's sessions, and the Session-Boundaries section is a short pointer (the canonical rule lives in `ai-resources/docs/session-boundaries.md`, referenced not inlined — verified pattern in workspace CLAUDE.md "Session boundaries" line).
- E1 graduation adds one canonical agent file (`doc-scanner-agent.md`, ~12 KB) — pay-as-used (Agent-tool spawn, not always-loaded). No `@import`, no hook registration, no broadly-matching skill. The agent is spawned only by `/friday-checkup` Step H, gated on `project repo-documentation selected` (friday-checkup.md:196). No per-turn cost.
- The tracking-model sub-change has no usage-cost implication either way (gitignore vs commit-as-is does not change what loads per turn).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries added or narrowed by any of the three changes.
- The graduated agent's `tools` frontmatter is `Read, Glob, Grep, Write` (doc-scanner-agent.md lines 5–9) — unchanged from the project-local original; no new tool family. Write is scoped to `output/phase-2/` by the agent body (line 12).
- Per-repo explicit-path commits use already-authorized git operations; no new Bash pattern.

### Dimension 3: Blast Radius
**Risk:** High

Grounded in the Consumer Inventory above.

- **E1 graduation — silent symlink fan-out (the dominant finding).** `auto-sync-shared.sh` walks `ai-resources/.claude/{commands,agents}/` and symlinks every file into any project carrying a `shared-manifest.json` (hook header lines 4–11). ~10 manifest-bearing projects exist (filesystem-confirmed). The moment a canonical `doc-scanner-agent.md` exists, the next SessionStart in each of those projects auto-creates a `doc-scanner-agent.md` symlink — distributing a **deeply project-specific** agent (vault baseline, `output/phase-2/`, D-37 decision IDs, repo-documentation `references/documentation-structure.md` schema) into 9 unrelated projects that have no vault and no use for it. This is a >5-consumer fan-out with silent automatic distribution — High by the heuristic.
- **Single hardcoded caller not updated by graduation.** The only active caller, `friday-checkup.md:202`, hardcodes `projects/repo-documentation/.claude/agents/doc-scanner-agent.md` (the project-local path) and passes a project-specific brief (line 203). `/graduate-resource` never modifies the source caller (command Step 7: "Never modify the source project's copy"). So post-graduation the caller still points at the project-local file — graduation produces a canonical copy nothing invokes. Either the caller must change (must-change=yes) or the canonical copy is dead-on-arrival. This is the contradiction-with-intent meta-check.
- **Basename collision in repo-documentation.** The graduation source (real file) and the auto-sync symlink share basename `doc-scanner-agent.md`. The hook's idempotency guard (`[ -e "$target" ] || [ -L "$target" ] && continue`, hook lines 88/105) means the real file is NOT overwritten in repo-documentation — but the agent's own Phase 3 rule (doc-scanner-agent.md:76) treats project-local-vs-canonical basename collisions as a must-surface drift signal. Graduation manufactures exactly that collision.
- **Git-hygiene commit — bounded.** The 13 CLAUDE.md commits are explicit-path, one per nested foreign repo, foreign drift untouched. Each is isolated to its own repo; no contract is parsed across repos. Blast radius for the commit alone is Low. It is High only because it is bundled with E1 and the tracking-model decision in one auto-mode pass.

### Dimension 4: Reversibility
**Risk:** High

- **Tracking-model decision is the irreversible one.** Choosing `gitignore + symlink-from-canonical` for per-project `.claude/` is a structural model change applied across 13 nested repos. Today the model is **commit-as-is** (verified: `git ls-files .claude/` in repo-documentation lists real agent files AND symlinks tracked). Switching to gitignore means each repo's `.gitignore` changes, previously-tracked files get `git rm --cached`, and the canonical-symlink topology becomes load-bearing. Reverting that across 13 repos is multi-step manual per-repo work, not one `git revert` — and a mistaken gitignore can silently drop a real project-local agent (e.g., repo-documentation's `principles-checker-agent.md`, `system-developer-agent.md` — real files, not symlinks) from version control. High.
- **E1 graduation across nested repos + push.** `/graduate-resource` Step 7 commits the new canonical resource AND (per the command text line 154) "Push automatically after the commit" — this conflicts with the workspace push-gating rule (commits batch until `/wrap-session`); if followed literally it pushes ai-resources mid-session, which `git revert` alone cannot recall once remote. Combined with the auto-sync hook firing on the next SessionStart (creating symlinks in ~10 repos before any revert), rollback is multi-step and crosses repo boundaries.
- **Git-hygiene commit alone — Medium.** 13 commits in 13 foreign repos are individually `git revert`-able, but a revert is per-repo (13 operations) and the commits are not pushed yet (push-gating), so pre-push they are local-only and cleanly droppable. Medium for the commit in isolation; the dimension is High because the bundle includes the gitignore-model and the auto-push.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Auto-sync hook is an invisible distribution channel.** Nothing in the change-description mentions `auto-sync-shared.sh`. The coupling — "create a canonical agent → it auto-symlinks into every manifest project on next SessionStart" — is invisible from the graduation site. This is silent auto-firing in an unexpected context (Dimension-5 High trigger).
- **`/graduate-resource` Step 6 vs agents.** The command's Step 6 (hook registration) is skipped for agents ("discovered automatically via `--add-dir`", command line 145) — but the auto-sync hook means agents are ALSO distributed by symlink, a second discovery path the command does not account for. Two mechanisms (`--add-dir` discovery + auto-sync symlink) both handle distribution; functional overlap.
- **Project-specific contract embedded in a "shared" agent.** The agent hard-depends on `projects/repo-documentation/vault/components/` (Phase 2 precondition, lines 30–35), `references/documentation-structure.md` §4.1 (Phase 1, line 26), and `output/phase-2/` write target (line 12). None of these exist in the other 9 projects the symlink reaches. A graduated copy carries an undocumented contract that only one project can satisfy.
- **Git-hygiene commit alone — Low coupling** (each CLAUDE.md is self-contained; the Session-Boundaries pointer references the canonical doc explicitly). The High is driven by E1 + the hook.

### Dimension 6: Principle Alignment
**Risk:** High

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).

- **E1 graduation violates OP-9 / AP-7 / DR-7 (speculative abstraction; generalize only on a second confirmed consumer).** DR-7: "Generalize only when a second confirmed consumer exists." The Consumer Inventory finds **one** caller (`friday-checkup.md`, repo-documentation-gated) and **zero** second consumer. The 2026-05-16 innovation sweep already triaged this exact agent: `repo-documentation/.claude/agents/doc-scanner-agent.md | triaged:project-specific | hardcoded output/ paths + decision IDs` (innovation-sweep-2026-05-16.md:205) and "Keep local — hardcoded output/ paths, decision IDs, pipeline phase writes" (line 172). Graduating it now contradicts a recorded triage and generalizes for an absent consumer — the textbook AP-7 failure. The change-description does not loudly acknowledge a principle revision, so per the Dimension-6 special-handling rule this is High, not Medium.
- **Tracking-model decision touches DR-1/DR-3 (placement/tiering) and OP-2 (gate judgment, not execution).** Deciding the per-project `.claude/` tracking model is a load-bearing, hard-to-reverse, future-shaping architecture call across 13 repos — precisely the "judgment" OP-2 says stays operator-gated, not auto-executed. The change-description itself flags it as "an unresolved architecture question … needing a deliberate reviewed pass." Settling it inside an S6 auto-mode session is an OP-2 violation.
- **Git-hygiene commit aligns** with OP-12 (closure/consolidation over new building) and DR-8 (it is the kind of bounded, contract-preserving cleanup the system favors). No principle tension for the commit alone.

## Recommended redesign

- **Split the bundle. Ship only the git-hygiene commit now.** Commit the 13 modified `projects/*/CLAUDE.md` Session-Boundaries conversions via explicit-path per-repo commits (foreign drift untouched), leave them unpushed per push-gating, and reconcile the "14 vs 13" count before committing (confirm whether a 14th project — `personal` — is in or out of scope). This change is Low on every dimension and needs no mitigation.
- **Drop E1 graduation (rescope to avoid the OP-9/AP-7/DR-7 violation).** doc-scanner-agent is project-specific by recorded triage; keep it local. If a genuine second consumer appears later, graduate then — and at that point first generalize away the vault / `output/phase-2/` / decision-ID coupling, update the single hardcoded `friday-checkup.md:202` caller in the same change set, and account for the `auto-sync-shared.sh` fan-out (manifest opt-out or a guard) before the symlinks distribute. None of that is in scope for an auto-mode session.
- **Defer the `.claude/` tracking-model decision to a dedicated operator-reviewed pass (OP-2 gate).** It is an architecture question across 13 nested repos with High reversibility cost; do not settle it in auto-mode. When taken up, run its own plan-time `/risk-check` on the chosen model (commit-as-is vs gitignore+symlink) with the canonical-symlink topology and the auto-sync hook explicitly in scope.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: doc-scanner-agent.md (lines 5–9, 12, 26, 30–35, 76); friday-checkup.md (lines 196–204); auto-sync-shared.sh (lines 4–11, 88, 105); graduate-resource.md (lines 145, 154); innovation-sweep-2026-05-16.md (lines 172, 205); workspace-root `.gitignore` (lines 13–27); filesystem-verified nested-git-repo structure and 13 modified `projects/*/CLAUDE.md`; ~10 `shared-manifest.json` files (filesystem find); principle IDs OP-2, OP-9, OP-12, DR-1, DR-3, DR-7, DR-8, AP-7 cited from `projects/strategic-os/ai-strategy/principles-base.md`. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is RECONSIDER. `/consult` dispatch is disable-model-invocation; the system-owner agent (which `/consult` wraps) was invoked directly for the equivalent advisory._

**Grounding note:** The system-owner ran in an isolated checkout where `projects/` was absent; it could not read `slot-1-decisions.md` or `doc-scanner-agent.md` directly. It grounded the E1 verdict on mechanism it read directly — `auto-sync-shared.sh` and `friday-checkup.md:202`. Principle citations it could not verify carry `[CITATION NEEDED]` in its output.

**Q1 — Concur with RECONSIDER + the split.** Ship the CLAUDE.md commit (after pinning the count), drop E1, defer the tracking-model decision. The three High marks (blast radius, hidden coupling, principle alignment) concentrate in E1 and the tracking decision; strip those two and what remains is a clean low-risk mechanical commit. Auto-mode is the wrong vehicle for a batch carrying a structurally-consequential decision S5 already reserved for its own reviewed pass.

**Q2 — Trust the risk-check. Keep doc-scanner-agent local. The slot-1 GRADUATE verdict is stale/wrong.** Mechanism:
- One caller, `friday-checkup.md:202`, points project-local and is scope-gated to repo-documentation by design (lines 196–204).
- `auto-sync-shared.sh` (99–113) symlinks every canonical agent into every project with a manifest; `doc-scanner-agent` is not in the exclude globs — graduation actively fans a project-specific scanner into ~10 unrelated projects. Speculative abstraction, N=1 real consumer.
- `graduate-resource.md` Step 4/5.5 would strip or fail on exactly the project-specific lens that is this agent's whole job — the pipeline resists it.
- It is stale, not "too conservative": a GRADUATE verdict reached at S5-wrap contradicts the project's own recorded triage and the live caller topology — the wrap-time decision skipped the second-consumer test. **Action:** don't execute E1; correct the slot-1 entry to KEEP-LOCAL with a one-line reason. Leaving a contradicted GRADUATE in the log is a latent re-trigger.

**Q3 — Missed risks:**
1. The 14-vs-13 discrepancy is an unexplained-state signal, not a counting nit — resolve it to a *named* repo before committing, or risk committing a wrong-state CLAUDE.md.
2. Dropping E1 without correcting the log is only half-reversible — the decision record still says "do it."
3. The deferred tracking-model pass must treat `auto-sync-shared.sh`'s symlink-emission + drift-detection as a hard constraint, not design `.claude/` tracking in isolation. Name it in that pass's brief.

**Position:** ship CLAUDE.md commit (count pinned to a named repo) → drop E1 and correct slot-1 to KEEP-LOCAL → defer tracking-model to its own risk-check with `auto-sync-shared.sh` named as a binding constraint.

_The second opinion concurs with the verdict; no operator-facing disagreement to resolve._
