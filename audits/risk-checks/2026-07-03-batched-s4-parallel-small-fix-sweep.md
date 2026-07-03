# Risk Check — 2026-07-03

## Change

Batched plan-time check, 2026-07-03 session S4-parallel small-fix sweep (8 edits): (E1) agent-definition edit — system-owner.md Phase 1/1.5/3: add robust grounding-path resolution (cwd → workspace-parent → Glob fallback) for both the references/ root (projects/axcion-ai-system-owner/references/) and the repo-documentation vault root (projects/repo-documentation/vault/), halting Shape-1 GROUNDING-UNAVAILABLE only after all fallbacks fail — fixes the 2026-06-12 defect where the agent spawned from an ai-resources cwd globbed only ai-resources/, declared the corpus verified-absent, and fired a false degraded-mode halt; (E2) canonical command edit — consult.md: new input-corpus disambiguation step (when the operator's question/plan names an input corpus whose name resolves to more than one directory on disk, e.g. projects/strategic-os/ vs knowledge-bases/strategic-os/, surface the ambiguity and pass the confirmed absolute path in the agent brief), paired-applied to the real-file copy in projects/axcion-ai-system-owner/.claude/commands/consult.md so the two variants do not fork; (E3) canonical doc edit — docs/commit-discipline.md: one-line hygiene rule discouraging catch-all "commit leftover artifacts" sweep commits in favor of scoped commits; (E4) .gitignore edit — anchor line 42 `archive/` to `/archive/` so nested logs/missions/archive/ (mission-close records, currently force-add-only) and audits/working/archive/ stop being silently ignored; git-add the newly visible files in the same commit; (E5) canonical doc edit — docs/backlog-reconciliation.md: add an advisory target-file touch-scan to the reconcile-at-read primitive (for still-open candidates that name target files, check git log --since=<anchor> -- <target-file>; a touch annotates the candidate "target file touched by <hash> since anchor — verify before executing" but NEVER demotes it; closes the 2026-06-12 keyword-blindness entry conservatively; propagates by reference to the 4 consumer commands which all defer to this doc for the full mechanism); (E6) cross-project hook down-port — copy canonical .claude/hooks/friction-log-auto.sh (4 "Friction Events" refs, C6 repair) over the stale 1-ref copy in projects/positioning-research/.claude/hooks/, verify byte-identity with cmp, and align positioning-research/.claude/settings.json hook registrations to canonical parity (canonical registers the hook on two events; positioning currently has PreToolUse(Skill) + PostToolUse(Write)); (E7) canonical command edit — friday-act.md: add an output-contract note near the intro ("this command triages and produces plan files; it never applies fixes inline — session mandates should read 'triaged into executable plans', not 'applied and committed'") and pin the Step-1.5 soft-cap active-entry count method to one canonical definition (count `- **Status:**` lines containing `logged` or `pending`; do not count `^### ` headers); (E8) shared-log header normalization — improvement-log.md line 243 `## id-39 — Read() deny rules...` → `### 2026-06-05 — id-39 — Read() deny rules...` (schema-conformant dated h3 header; fixes the non-deterministic active-entry count feeding the soft-cap gate, friction 2026-07-03 S1). Context: a concurrent session is live in the same checkout executing a disjoint fix list (its files: wrap-session.md, graduate-resource.md, resolve-improvement-log.md, risk-check.md, qc-pass.md, refinement-pass.md, audit-discipline.md, friday-checkup.md, templates/project-claude-md/header.md, workflows/research-workflow/SETUP.md, source-class-hierarchy.template.md) — this sweep's file set is disjoint except the shared logs (improvement-log.md, friction-log.md), which this session edits last and never stages in its own commits.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/system-owner.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/consult.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/.claude/commands/consult.md — exists (real file, not symlink)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/backlog-reconciliation.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/.claude/hooks/friction-log-auto.sh — exists (stale copy)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/positioning-research/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Eight individually-sound, backward-compatible maintenance fixes with no High dimension, but the batch touches broad shared infrastructure (a 6-caller agent, a 5-consumer reconcile primitive, a ~10-parser shared log, a cross-project hook, and git-tracking semantics) during a disclosed concurrent session, so four dimensions sit at Medium and each benefits from a targeted mitigation before landing.

## Consumer Inventory

Total: 40+ distinct references across the eight targets; **3 must-change, all of which are co-edits internal to the change itself** (the paired consult copy, the positioning settings.json, and the git-add of newly-visible files). **Zero external consumers require modification to keep working** — every contract change is additive/backward-compatible. Table groups by change target; representative rows shown.

| Consumer path | Reference type | Must change? |
|---|---|---|
| **E1 — system-owner.md agent** | | |
| .claude/commands/consult.md | invokes | no |
| .claude/commands/architecture-review.md | invokes | no |
| .claude/commands/implementation-triage.md | invokes | no |
| .claude/commands/systems-review.md | invokes | no |
| .claude/commands/friday-so.md | invokes | no |
| .claude/commands/so-monthly.md | invokes | no |
| .claude/commands/fix-project-issues.md | invokes (Function-A caller) | no |
| .claude/agents/project-manager.md | invokes (Task escalation) | no |
| .claude/commands/{pipeline-review,new-project,scope-project}.md | documents/pointer | no |
| docs/agent-tier-table.md | documents | no |
| **E2 — consult.md (canonical)** | | |
| .claude/commands/risk-check.md (Step 17b) | invokes (auto) | no |
| .claude/commands/resolve-incident.md | invokes (auto, Function B) | no |
| .claude/commands/pm.md / .claude/agents/project-manager.md (Fallback 5d) | documents/redirects | no |
| docs/change-shape-classifier.md | parses (Step-2 contract) | no |
| .claude/commands/{clarify,scope-project,systems-review}.md, docs/protected-zones.md, docs/onboarding-daniel*.md | documents | no |
| **E2 — consult.md (project real-file copy)** | co-edits (paired) | **yes** |
| **E3 — commit-discipline.md** | | |
| ../CLAUDE.md (workspace) | documents/pointer | no |
| .claude/commands/{concurrent-session-check,improve,tweak}.md | documents | no |
| docs/{parallel-sessions-playbook,friday-cadence-runbook}.md, docs/onboarding-daniel*.md | documents | no |
| **E4 — .gitignore** | | |
| logs/missions/archive/*.md (mission-close records) | co-edits (git-add / tracking-scope) | **yes** |
| .claude/settings.json `Read(archive/**)` deny (line 25) | co-located contract (verify no shadow) | no |
| **E5 — backlog-reconciliation.md** | | |
| .claude/commands/prime.md (Step 1a, reference impl) | invokes primitive | no |
| .claude/commands/fix-project-issues.md | invokes primitive | no |
| .claude/commands/fix-repo-issues.md | invokes primitive | no |
| .claude/commands/open-items.md | invokes primitive | no |
| .claude/commands/reconcile-backlog.md | invokes primitive | no |
| docs/audit-discipline.md | documents | no |
| **E6 — friction-log-auto.sh (positioning) + settings.json** | | |
| projects/positioning-research/.claude/settings.json | co-edits (hook registration) | **yes** |
| .claude/hooks/friction-log-auto.sh (canonical) | imports (byte-identity source) | no |
| **E7 — friday-act.md** | | |
| .claude/commands/friday-checkup.md | invokes (Session 1→2 cadence) | no |
| .claude/agents/friday-act-16a-summarizer.md | invoked-by | no |
| docs/{friday-cadence-runbook,weekly-cadence,operator-maintenance-cadence}.md | documents | no |
| **E8 — improvement-log.md (`^### ` / `### YYYY-MM-DD` marker parsers)** | | |
| .claude/agents/session-feedback-collector.md (`grep -c '^### '`) | parses (count-proxy) | no |
| docs/commit-discipline.md (`grep -c '^### '`) | parses (count-proxy) | no |
| .claude/commands/improve.md (`grep -c '^### '`) | parses (count-proxy) | no |
| .claude/commands/resolve-improvement-log.md (`### `-boundary removal) | parses (entry boundary) | no |
| .claude/agents/fix-repo-issues-scanner.md (`### YYYY-MM-DD —`) | parses | no |
| .claude/commands/friday-checkup.md (stale/session-issue/park-drain: `### YYYY-MM-DD` + Status) | parses | no |
| .claude/commands/open-items.md (`### YYYY-MM-DD`) | parses | no |
| .claude/commands/{reconcile-backlog}.md + docs/backlog-reconciliation.md (`### YYYY-MM-DD —`) | parses | no |
| .claude/commands/friday-act.md Step 1.7 (`**Status:**` count) | parses | no |

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched. None of the 11 referenced files is a workspace or project `CLAUDE.md`; the two docs edited (`commit-discipline.md`, `backlog-reconciliation.md`) are on-demand reads gated by an explicit "When to read this file" header (`backlog-reconciliation.md:3`; `commit-discipline.md:3`), not `@import`ed into any always-loaded context.
- E1 expands the `system-owner` agent body (Phases 1/1.5/3) with path-resolution fallback logic, but the agent is spawned on-demand by advisory commands (`system-owner.md:14` lists the 6 callers), not per-session or per-tool. Added Glob-fallback calls are a marginal per-invocation cost against an agent that already reads references every invocation (`system-owner.md:27-37`). Pay-as-used.
- No new hook that runs per session or per tool-call is registered in an always-loaded scope. E6 wires an existing canonical hook into one project's `PostToolUse`, but that is project-scoped runtime, not main-session token cost (see Dimension 3).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow` / `ask` / `deny` entry is added, removed, or widened in any settings layer. E6 edits `projects/positioning-research/.claude/settings.json`, but only the `hooks` block (hook registration parity), not the `permissions` block. That project already runs `defaultMode: bypassPermissions` with broad allows including `Bash(*)` and `Write(**/.claude/**)` (`positioning-research/.claude/settings.json:31, 6, 20`), so the hook down-port grants no new capability.
- E4 changes `.gitignore` tracking semantics, not permissions. It does interact with an existing deny rule (`.claude/settings.json:25 Read(archive/**)`) — see Dimension 5 for the tracked-but-readable verification, but no permission is changed.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory: **40+ distinct references, 3 must-change, all internal co-edits; 0 external consumers require modification.** Every contract change is additive/backward-compatible.
- The aggregate shared-infra surface is what lifts this above Low: one batch simultaneously touches (a) an agent invoked by 6 commands (`system-owner.md:14`), (b) a reconcile primitive that 5 commands defer to (`backlog-reconciliation.md:90-101` Consumers table + grep confirmed prime/fix-project-issues/fix-repo-issues/open-items/reconcile-backlog), (c) a shared log parsed by ~10 markers-consumers (E8 inventory rows), (d) a cross-project hook + settings, and (e) git-tracking semantics.
- E1 changes *when* Shape-1 GROUNDING-UNAVAILABLE fires (only after all fallbacks fail) — this makes the agent halt **less** often and preserves the output contract (`system-owner.md:156-169` Shape-1 shape unchanged; `:87-93` path-back line unchanged). Backward-compatible for all 6 callers.
- E5 adds a new `git log --since -- <target-file>` touch-scan to the reconcile primitive that 5 consumers invoke by reference. Because the doc is the single definition (`backlog-reconciliation.md:3`) and the annotation "never demotes" (per change desc), consumers inherit the new behavior without edits — but it is a genuine cross-consumer behavior change, not an isolated doc tweak.
- **E4 blast-radius accuracy gap (grep/git-verified):** the change description asserts E4 makes *both* `logs/missions/archive/` and `audits/working/archive/` visible. `git check-ignore -v audits/working/archive` returns `.gitignore:25:audits/working/` — i.e. `audits/working/archive/` is shadowed by the parent `audits/working/` rule and is **unaffected** by anchoring `archive/`. Only `logs/missions/archive/` is genuinely un-ignored (`git check-ignore -v logs/missions/archive/x.md` → `.gitignore:42:archive/`). Further, `git ls-files logs/missions/` shows two records under `logs/missions/archive/` are **already tracked** (force-added), so the "git-add the newly visible files" set is smaller than the description implies (possibly near-empty right now). Enumerate the exact set with `git status` before the git-add rather than assuming.
- E8 edits a shared log (`improvement-log.md`) concurrently accessible to the disclosed second session. The header change is beneficial (fixes a real mis-parse — see Dimension 5) but touches the single most contention-sensitive file class in the repo.

### Dimension 4: Reversibility
**Risk:** Medium

- E1, E2 (both copies), E3, E5, E7 are clean single-purpose edits that `git revert` restores fully within the working tree.
- **E4 is the sharpest reversibility item.** A `git revert` of the E4 commit reverses the diff: it restores unanchored `archive/` in `.gitignore` **and** `git rm`s any files git-added in the same commit — deleting those mission-close records from the working tree. Because two records are already tracked (force-added), a revert would *untrack and delete* them, a net state loss beyond the .gitignore line. Split the .gitignore change from any git-add of records into separate commits so each reverts independently.
- **E8 reversibility is entangled by the staging arrangement.** The change states the shared logs are "edited last and never staged in its own commits" — so E8 lands via wrap or the concurrent session's commit, potentially **bundled** with a concurrent append to the same file. Reverting E8's one-line header fix in isolation from a bundled commit requires a manual line-level revert, not a clean `git revert`.
- E6, once the hook is live in positioning, may fire between landing and any revert, writing `[auto]` friction entries to that project's `friction-log.md`. That is an append-only, low-stakes side effect (`friction-log-auto.sh:55-56`), so revert of the hook/settings is otherwise clean.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **E8 relies on and mutates the `^### ` count-proxy contract.** Line 243 is currently `## id-39 …` (H2), read from disk. A `### `-boundary parser (`resolve-improvement-log.md:117`, `session-feedback-collector.md:79`, `commit-discipline.md:43`, `improve.md:60`) does not see id-39 as its own entry — its body (lines 243–253) is silently swallowed into the preceding `### 2026-06-04 …` entry (`improvement-log.md:233`), and the next `### ` boundary is at line 254. E8's promotion to `### 2026-06-05 — id-39 —` is therefore a genuine schema-conformance repair that *fixes* a live mis-parse, and it only ever **raises** the `^### ` count (never lowers it), so it cannot trip the append-integrity abort guard (`commit-discipline.md:40-47`, which aborts only on a count *drop*). Well-understood, conservative, and documented at the parsers — but it is an **in-place mutation of a shared status log**, which `commit-discipline.md:51-64` § Maintenance-owned in-place mutations reserves for *dedicated single-purpose sessions*, not an ordinary work sweep run alongside a concurrent session. The enumerated cases there are status-flips and archiving (not header fixes), so E8 edges the *spirit* of that invariant rather than clearly breaching it.
- **E2 pairs two already-forked copies.** The canonical `consult.md` and the project copy have already diverged structurally: canonical carries Step 0 read-first gate, Step 5a existence check, and reads `docs/change-shape-classifier.md` as a one-end contract (`consult.md:52-58`); the project copy inlines the change-shape rule at its Step 2 and has neither gate (`projects/axcion-ai-system-owner/.claude/commands/consult.md:29-45, 87-92`). Applying the same disambiguation step to both keeps *that step* in sync but does not un-fork the files; "so the two variants do not fork" is already only partially true.
- **E6 shifts the friction-log write format in positioning and newly enables PostToolUse auto-firing there.** The stale copy writes old markers (`### Session:` / `#### Friction Events`, `friction-log-auto.sh:43-45` positioning) that canonical parsers (`## Session —` / `### Friction Events`, `open-items.md:35`) do not match; the down-port aligns future writes to canonical (a fix), but leaves a mixed-format residual in positioning's existing log. Adding the hook to `PostToolUse` also silently enables error-capture friction logging in that project — a new auto-firing context; the canonical hook's recursion guard skips `friction-log.md`/`improvement-log.md` targets (`friction-log-auto.sh:37-42`), so it is safe, but it is new behavior the project did not have.
- **E4 gitignore/deny co-location.** After anchoring, `logs/missions/archive/` becomes tracked; verify the `.claude/settings.json:25 Read(archive/**)` deny does not shadow that path (glob probe indicates `archive/**` is root-anchored and `logs/*archive*.md` does not cross `/`, so mission records should stay readable — confirm before landing so you do not commit tracked-but-Read-denied records).

### Dimension 6: Principle Alignment
**Risk:** Medium

- Principles-base was readable at `projects/strategic-os/ai-strategy/principles-base.md` (frozen-ID index, 41 active).
- **OP-12 (closure before detection) — tension, named.** E5 adds a *new advisory detection* to the reconcile primitive: a "target file touched by `<hash>` since anchor — verify before executing" annotation that, by the change's own wording, "NEVER demotes" and does not close anything — a human must act on it. Per OP-12 (`principles-base.md:50`), "new detection that does not close findings counts *against* a candidate." This is a mild tension, not a violation: E5 tightens the accuracy of an *existing* advisory reconciler (reducing the keyword-blindness false-negative logged 2026-06-12) rather than standing up a new detection engine, and it preserves the primitive's advisory-only posture (`backlog-reconciliation.md:83`). It adds a verify-flag with no auto-closure — the honest OP-12 read is Medium.
- **OP-5 (advisory vs enforcement) — aligned.** E5 stays advisory ("never demotes"); E6's hook is advisory friction logging (`commit-discipline.md:25` notes the paired tripwire is "advisory … not enforcement (principle OP-5)"); no advisory→enforcement upgrade anywhere in the batch.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — aligned.** Every edit serves an existing consumer or fixes a dated defect (E1 → 2026-06-12 false-halt; E8 → 2026-07-03 S1 count friction; E5 → 2026-06-12 keyword-blindness). No "hooks for later," no generalization ahead of a second consumer (`principles-base.md:47, 60, 85`).
- **OP-10 (system boundary) — aligned.** E6 down-ports a hook to `positioning-research`, a project *inside* Claude Code, not a cross-tool (GPT/Perplexity/NotebookLM) integration (`principles-base.md:48`). No boundary expansion.
- **DR-1 / DR-3 (placement) — aligned.** All canonical edits stay in canonical homes; the positioning down-port is a project-local sync of a canonical hook.
- **OP-11 (loud revision) — not implicated.** No principle is being revised, so no loud-revision obligation is triggered.

## Mitigations

- **Dimension 3/4 (E4):** Before landing, run `git status` (and `git check-ignore -v` on candidate paths) to enumerate the *exact* set of files the anchored `/archive/` newly exposes — do not assume it is `logs/missions/archive/ + audits/working/archive/` (git confirms `audits/working/archive/` stays ignored via the `audits/working/` rule, and two `logs/missions/archive/` records are already tracked). Correct the E4 commit message / session mandate to drop the `audits/working/archive/` claim.
- **Dimension 4 (E4):** Land the `.gitignore` anchor edit and any `git add` of newly-visible records as **two separate commits** so a revert of the ignore-rule change does not `git rm` (delete) mission-close records.
- **Dimension 3/4/5 (E8):** Apply E8 as the final edit of the session; immediately before the Edit, re-Read `improvement-log.md` and confirm no concurrent append landed since your last read (guard against read-during-rewrite per `commit-discipline.md:33-49`); leave it unstaged for `/wrap-session` and do **not** let it be swept into a bundled commit with the concurrent session's append (`commit-discipline.md:17-19` wrap-owned posture) so the one-line header fix stays independently revertible.
- **Dimension 5 (E4):** Confirm the `.claude/settings.json:25 Read(archive/**)` deny does not match `logs/missions/archive/**` (probe with a representative path) so the newly-tracked mission records are not committed as tracked-but-Read-denied.
- **Dimension 5 (E2):** In the E2 edit, note in the disambiguation step (or the session record) that the two `consult.md` copies are *already* structurally forked (canonical has the Step 0 gate + Step 5a check the project copy lacks); scope the "keep in sync" claim to the disambiguation step only, so a future reader does not assume full parity.
- **Dimension 6 (E5):** Since the OP-12 tension is mild and the touch-scan improves an existing advisory reconciler rather than adding a standalone detector, keep it strictly annotation-only (never demote, never auto-action, as specified) and record in the change that the added signal is advisory-with-no-auto-closure — so the OP-12 posture is an explicit, on-the-record choice rather than silent scope growth.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION, not RECONSIDER.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references to the 11 referenced files, `grep -rniI` consumer counts across `ai-resources` and the workspace root, and `git check-ignore -v` / `git ls-files` probes for the E4 gitignore semantics. Principle citations are frozen IDs from `projects/strategic-os/ai-strategy/principles-base.md` (OP-5, OP-9, OP-10, OP-11, OP-12, AP-7, DR-1, DR-3, DR-7). No training-data fallback was used on any read; all referenced files tagged `exists` were read directly, and no `not yet present` files were referenced.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

**Verdict: CONCUR with PROCEED-WITH-CAUTION.** Four `/risk-check`-gated classes bundled — E1 canonical agent, E6 hook+settings, E8 parser-target log, E4 gitignore semantics — none High, but their aggregation across shared infra during a disclosed concurrent session correctly lands below GO (risk-topology.md § 3; DR-8). Verdict is binding; no downgrade.

**The four proposed mitigations:**
- **E8** (apply-last/re-read/leave-unstaged) — right as written; respects DR-10, closes the parser-target two-end contract.
- **E5** (annotate-only) — right; keeps the reconcile primitive advisory, not enforcement (OP-5).
- **E4** (exact-set + two-commit split + Read-deny probe) — right but extend: enumerate the newly-exposed set *repo-wide* (un-anchoring exposes every nested `archive/`, not just logs/missions), before any staging.
- **E2** (scope the sync-claim) — right but insufficient; does not address standing fork divergence between canonical and the project fork.

**Risks the six-dimension frame missed:**
1. **QC reachability is not a dimension.** E1/E6/E8 are QC-gated architectural changes; if independent QC is unreachable this session (1M-gate + >200k tokens), workspace rule *commit-blocks* the batch → `/handoff` (QS-1/QS-2). All-Medium can still be commit-blocked. Confirm reachability before staging.
2. **E4 × concurrent session.** DR-10 binds this session's staging, not the concurrent one — a `git add -A` there can sweep newly-exposed content before the split runs. Land E4 last, gated on that session not wildcard-adding, or defer past its wrap.
3. **Batching is the reversibility cost (D4).** Six rollback boundaries in one sweep — commit per boundary; generalize E4's split to E1/E6/E8 (QS-7).

**E1-specific:** its QC must assert the Glob fallback prefers the vault root and fails loud on ambiguous multi-match — first-match-wins could silently ground the agent against the archived `output/phase-1/` baseline grounding.md § 1 forbids.

**Position:** land it, but not as one batch and not before two gates — confirm QC reachability, then commit per rollback boundary with E4 last. E2/E6 add unmanaged forks; log as maintenance debt. Flag: the QC gate may force a `/handoff` the plan did not budget for — that is a hard rule, not a preference.

**Full advisory on disk:** projects/axcion-ai-system-owner/output/consultations/consult-2026-07-03-batched-s4-parallel-sweep-second-opinion.md
