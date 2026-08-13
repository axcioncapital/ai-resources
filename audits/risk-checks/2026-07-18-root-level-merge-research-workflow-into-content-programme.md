# Risk Check — 2026-07-18

## Change

Proposed change: root-level merge of the canonical research-workflow template into projects/axcion-content-programme. Consumer-side deployment — no canonical template files in ai-resources are edited.

CONCRETE CHANGE SET (all counts re-derived by execution, not recalled):

1. Copy the template's 24 manifest-declared LOCAL commands from ai-resources/workflows/research-workflow/.claude/commands/ into projects/axcion-content-programme/.claude/commands/ (which currently holds 90 commands).
   - 19 are NEW, no collision: audit-structure, create-context-pack, inject-dependency, intake-reports, produce-architecture, produce-formatting, produce-jargon-gloss, produce-knowledge-file, produce-prose-draft, review-chapter, run-analysis, run-cluster, run-execution, run-preparation, run-report, run-synthesis, status, verify-chapter, workflow-status
   - 5 COLLIDE: audit-repo, friction-log, improve, prime, wrap-session
   - CRITICAL, verified with os.path.islink (NOT [ -f ], which follows symlinks): ALL FIVE colliding entries in the project are SYMLINKS to ai-resources canonical, e.g. prime -> ../../../../ai-resources/.claude/commands/prime.md. Copying the template-local variant over them replaces a canonical symlink with a template-local real file.

2. Copy 4 template agents into .claude/agents/: qc-gate and verification-agent are NEW; execution-agent and improvement-analyst COLLIDE and are likewise SYMLINKS to ai-resources canonical.

3. Create chassis directories at repo root: analysis/, execution/, report/, final/, preparation/, output/, reports/, usage/ — alongside the project's existing articles/, knowledge/, pipeline/, reference/, roadmap/, workflow/.

4. Merge the template's 13-field project-config block into the existing root CLAUDE.md (already ~5.7KB, always-loaded).

5. Instantiate quality-standards.md (claim-permission chassis) and known-limits.md. known-limits.md is hard-class to run-cluster, which HALTS if it is absent or unfilled.

Scoring dimensions per the reviewer's brief additionally require assessment of: (A) session-harness overwrite risk from the 5 colliding commands, specifically prime/wrap-session; (B) sizing mismatch between a multi-month research-report pipeline and ~1500-word articles; (C) whether this reverses two decisions ratified earlier the same day (the W1.5 research-procedure deferral, and the RECONSIDER that produced it) at larger scale; (D) conflict with the active `research-workflow-deploy-fitness` mission, which names Sector Intelligence as pilot 1; (E) fork/drift risk from an unsynced template-local copy; (F) project readiness (W1.4 not run, workflow/roadmap empty).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/ — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/agents/ — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/shared-manifest.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/settings.json — exists (not in the described change set — see Dimension 5)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/CLAUDE.md — exists (source of the 13-field Project Config block)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/commands/ — exists (88 .md files, 85 symlinks + 3 real)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/agents/ — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/.claude/shared-manifest.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/CLAUDE.md — exists (59 lines / 5,764 bytes)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/pipeline/architecture.md — exists (Decision Log §6, Decisions 1–10 read)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/ — exists (2 files today: editorial-standards.md, publication-gate.md)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/quality-standards.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/reference/known-limits.md — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/{analysis,execution,report,final,preparation,output,reports,usage}/ — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists (referenced, not read in full — Step 2/Step 3 mechanics taken as given per the caller's verified facts)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-destructive-liveness.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/research-workflow-deploy-fitness.md — exists (status: active)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-18-plan-time-gate-create-reference-research-procedure-md-in.md — exists (prior RECONSIDER on a narrower, related change)
- ~/.claude/settings.json — exists (user-level; registers check-destructive-liveness.sh / check-foreign-staging.sh / detect-concurrent-session.sh globally)

## Verdict

RECONSIDER

**Summary:** Five of seven dimensions score High — the merge silently replaces the project's canonical session-harness commands (`/prime`, `/wrap-session`) with narrower template-local variants that no longer write the session markers three global safety hooks depend on; it imports a multi-month research-*report* chassis wholesale for a ~1,500-word-*article* project against Decision 1's explicit rejection of that exact option; and it silently contradicts three more same-day-ratified architecture decisions (3, 4, 8) that the operator's recorded override never named. This is the same failure the morning's RECONSIDER caught, now at roughly 15x the file count and with a live-harness hazard added.

## Consumer Inventory

Search terms used: `prime`, `wrap-session`, `audit-repo`, `friction-log`, `improve` (the 5 colliding command basenames) and their symlink target contract (`.session-marker`); `execution-agent`, `improvement-analyst` (the 2 colliding agent basenames); `shared-manifest.json`, `auto-sync-shared.sh` (the manifest/sync contract the copy silently contradicts); `quality-standards.md`, `known-limits.md`, `source-class-hierarchy.md` (the reference/ contract `run-cluster` hard-requires); `research-workflow-deploy-fitness` (the active mission). Grepped across `ai-resources/.claude/`, `ai-resources/logs/`, the workspace root, and `projects/axcion-content-programme/`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/hooks/check-destructive-liveness.sh` (registered globally at `~/.claude/settings.json`, PreToolUse/Bash — fired today against this exact project) | parses (`.session-marker-*`, written only by canonical `/prime` Step 8, torn down only by canonical `/wrap-session`) | yes — its liveness signal silently degrades in this project unless the symlink is preserved or an equivalent replacement lands |
| `ai-resources/.claude/hooks/check-foreign-staging.sh` (global) | parses (same marker set) | yes — same degradation |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` (global SessionStart) | parses (same marker set) | yes — same degradation |
| `ai-resources/.claude/commands/{decide,open-items,session-plan,contract-check,drift-check,new-worktree-session,concurrent-session-check,clarify,session-start,blindspot-scan,close-worktree-session,new-project}.md` (12 files, grep-confirmed) | parses/documents (session-marker mechanics `/prime` produces) | no — these files don't need editing, but the contract they assume in this project quietly stops holding |
| `projects/axcion-content-programme/.claude/shared-manifest.json` | documents/co-edits (declares `commands.local: [build-inventory, build-roadmap, select-articles]` — explicitly excludes prime/wrap-session/audit-repo/friction-log/improve, i.e. the project's own scaffolding intends these to stay canonical-symlinked) | yes — not in the described change set; left unedited, it produces a recurring "AI-RESOURCES DRIFT" SessionStart warning (see Dimension 5) |
| `ai-resources/.claude/hooks/auto-sync-shared.sh` | invokes (drift-detection loop diffs any non-symlink target against canonical) | no (file itself unmodified) — but its output changes every session going forward |
| `projects/axcion-content-programme/pipeline/architecture.md` Decision 1 (line 165), Decision 3 (line 167), Decision 4 (line 168), Decision 8 (line 172) | documents (four ratified same-day decisions this merge contradicts) | yes — none are in the change's paired-edit list; left unedited, the canonical design record actively contradicts repo state on four points, not the one point (Decision 1) the operator's recorded override addressed |
| `ai-resources/workflows/research-workflow/.claude/commands/run-cluster.md` (newly copied) | parses (`reference/source-class-hierarchy.md`, `reference/quality-standards.md`, `reference/known-limits.md` — all three hard-class per line 11) | yes — the change set only instantiates 2 of the 3 hard-class files it needs (see Dimension 7) |
| `ai-resources/workflows/research-workflow/.claude/settings.json` (hooks: bright-line block, auto-commit, checkpoint nag, session-wrap nag, decision-log-on-GATE) | co-edits (the 24 copied commands' checkpoint/chassis-directory design assumes these hooks are live) | yes — not in the described change set at all; the copied commands land without their own guardrails |
| `ai-resources/logs/missions/research-workflow-deploy-fitness.md` (active; names Sector Intelligence pilot 1; owns the validated `/deploy-workflow` path + "At deployment" safeguards checklist) | documents (a second, unvetted deployment mechanism for the same template, outside the mission's scope) | no (the mission file itself needs no edit) — but this deployment ships with none of the mission-validated fixes or safeguards |
| `projects/axcion-content-programme/reference/editorial-standards.md` §10 (already settles article research-sizing policy, per this morning's fold) | overlapping content | no (not required, but a second unsynced description of "how research is sized/executed" now exists if `quality-standards.md`/`known-limits.md` land) |

**Total: 10 distinct consumer groups found (representing 18 individual files/hooks in the marker-dependency chain alone, plus 4 architecture.md decisions, plus 1 active mission), 7 must-change.** Two of the seven (the project's own `shared-manifest.json` and three `architecture.md` decisions) are gaps the change description's 5-item list does not anticipate — the same shape of miss the morning's `/risk-check` caught on the smaller proposal.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** High

- The template's 13-field Project Config block (`ai-resources/workflows/research-workflow/CLAUDE.md:19-39`) plus its forward-contract explanatory paragraph runs well past 150 tokens as a single markdown block (13 fields + comments + a ~180-word framing paragraph) — merged into `projects/axcion-content-programme/CLAUDE.md`, which is always-loaded every session.
- Most of the 13 fields are dead weight for this project's shape: `Report set`, `Section IDs`, `Country set`, `Country superset`, `Deal-size lens` parameterize a multi-chapter, multi-country research report — axcion-content-programme produces single-author ~1,500-word articles with no country/report/section dimension. The project pays the always-loaded token cost every session for fields most articles will never populate meaningfully.

### Dimension 2: Permissions Surface
**Risk:** Low

- Both `projects/axcion-content-programme/.claude/settings.json` and the template's `.claude/settings.json` already grant blanket `Bash(*)`, `Write`, `Edit`, `Read` with `defaultMode: bypassPermissions` — confirmed by direct read of both files. The described change set (items 1–5) does not touch either settings.json, so no new allow/deny entry is required mechanically.
- The described change is silent on merging the template's `settings.json`/hooks at all — that gap is scored under Dimension 5 (Hidden Coupling), not here, since it is an absence of guardrails rather than a widening of grants.

### Dimension 3: Blast Radius
**Risk:** High

- Grounded in the Consumer Inventory: the `/prime`/`/wrap-session` collision alone implicates 3 global hooks (`check-destructive-liveness.sh`, `check-foreign-staging.sh`, `detect-concurrent-session.sh`, all registered at the user-level `~/.claude/settings.json`, confirmed by direct grep) plus 12 more ai-resources commands whose docs reference the same `.session-marker-*` contract (`decide.md`, `open-items.md`, `session-plan.md`, `contract-check.md`, `drift-check.md`, `new-worktree-session.md`, `concurrent-session-check.md`, `clarify.md`, `session-start.md`, `blindspot-scan.md`, `close-worktree-session.md`, `new-project.md`) — 15 files whose behavior depends on a contract this single copy operation silently breaks for this one project. That is well past the ">5 dependent callers" High threshold from the marker collision alone.
- 4 `architecture.md` decisions (1, 3, 4, 8), all ratified the same day, become contradicted repo state — the canonical design record and the actual repository state disagree on four separate points, not the one the operator's recorded override addressed.
- The described change also skips shared infrastructure that the copied commands assume: the template's own `settings.json` hooks (bright-line block, auto-commit, checkpoint nag) are not part of the change set, so the 19 non-colliding commands land without the guardrails they were designed against.

### Dimension 4: Reversibility
**Risk:** High

- The file-level content (symlinks, CLAUDE.md text, new chassis directories, new reference files) is fully git-tracked and a single `git revert` restores it cleanly — that part alone would be Low.
- But the harness break is not blocking, only advisory: `auto-sync-shared.sh`'s drift check only fires the *next* SessionStart, as a soft `additionalContext` line easy to miss, not a stop. That means at least one live session is likely to run against the degraded harness before anyone notices — during that window, `check-destructive-liveness.sh`'s protection (which fired in this exact project today, per `logs/destructive-override.log`) is silently weaker, no push-gate confirmation occurs (the template's `wrap-session.md` contains no commit or push step at all, confirmed by direct read — the mandatory workspace push-gate prompt simply would not fire), and any session notes / decisions / commits produced during that window are not something reverting the original merge commit cleans up.
- This is a materially higher bar than "git revert plus one cleanup step" — it requires verifying no destructive op or ungated push happened during the exposure window and reconciling any session-notes/decisions.md entries written by the wrong command, in addition to the revert itself.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Implicit dependency on a producer contract three global hooks silently assume.** Canonical `/prime` writes `logs/.session-marker*` at Step 8; canonical `/wrap-session` tears it down. Neither behavior is named anywhere in the described change, and the template-local replacements do neither (confirmed by direct read of both template files, 33 lines each — orientation-only, no marker I/O, no commit, no push).
- **Undocumented new contract vs. an existing, explicit one.** The project's own `.claude/shared-manifest.json` (written at scaffold time, matching architecture.md Decision 4) explicitly lists only 3 commands + 1 agent as project-local and everything else as canonical-symlinked. The merge silently contradicts that manifest without updating it — `auto-sync-shared.sh`'s drift loop (verified by direct read, lines 141–159) will not re-overwrite the copied files (the `[ -e ] || [ -L ]` guard skips existing targets), but it will emit a recurring "AI-RESOURCES DRIFT" warning at every future SessionStart in this project until the manifest is updated or the symlinks restored.
- **Functional overlap with an existing, mission-validated mechanism.** `ai-resources/logs/missions/research-workflow-deploy-fitness.md` (active) owns exactly this template's deployment fitness, names Sector Intelligence as pilot 1, and carries 8 fixes plus an "At deployment" safeguards checklist validated by execution (not by reading). This proposal is a second, ad hoc `cp`-based deployment mechanism for the same template, exercised by none of the mission's acceptance tests, applying none of its safeguards checklist (scoping preamble, disconfirmation questions, manual `/verify-chapter` step, evidence-calibration note, manual research operating model).
- **Overlap with existing settled content.** `reference/editorial-standards.md` §10 (folded this morning, per `logs/decisions.md`) already states article research-sizing policy. Landing `quality-standards.md`/`known-limits.md` creates a second, differently-shaped description of overlapping ground with no cross-reference.

### Dimension 6: Principle Alignment
**Risk:** High

Principles-base not present at the expected path (`projects/strategic-os/ai-strategy/principles-base.md` was not read in this pass — grounded instead in the workspace/ai-resources CLAUDE.md inline checks, which is sufficient here since the violated principles are also independently ratified, same-day, in `architecture.md`'s own Decision Log).

- **OP-9 / AP-7 / DR-7 — speculative abstraction, at scale.** `architecture.md` Decision 1 (line 165) already considered and explicitly rejected this exact option — quoted verbatim: *"(a) Deploy it now as the project chassis... adjacency is not fit. Its unit of work is a multi-stage research report (answer specs, execution manifests, claim IDs, evidence packs, chapter modules, 31 commands, 8 stage directories). v4's unit is an article produced by a 10-step loop... Deploying it would also import active harm."* This change is that rejected alternative, now proposed again as if new.
- **DR-1 / DR-3 — placement, on three more fronts the recorded override does not name.** The operator's recorded override (`logs/session-notes.md`, session S2-44a: *"operator chose 'overrule me — deploy it into this repo anyway'"*) is a loud, recorded exception to Decision 1's *timing* premise (W1.5-vs-now) and is treated here as legitimate on that specific point. But three more same-day decisions are silently contradicted with no acknowledgment at all: Decision 8 (`reference/` capped at 2 files, rejecting *"a fuller reference/ mirroring research-workflow's 17 files"* by name — this change adds at least 2, arguably 3, more); Decision 4 (*"only 3 commands + 1 agent project-local"* — this change adds 19–24 commands + 2–4 agents, exactly the rejected alternative *"(b) build a fuller project-local command set covering every work unit"*); Decision 3 (*"flat single-level project, no subprojects"* — 8 new root chassis directories mirroring the template's own stage-directory shape is the closest thing to a subproject this repo could add without naming one).
- **OP-11 loud-revision test.** Partially met, not fully. The Decision-1 timing question is loud and recorded. Decisions 3, 4, and 8 are not — no `architecture.md` amendment, no `logs/decisions.md` entry naming them, no five-question OP-11 justification (recurring failure prevented, frequency, cost, conditional-fire alternative, why existing coverage doesn't already handle 80% of it) for any of the three. Per the framework, a High here requires either rescoping or a full loud acknowledgment; only one of four implicated decisions clears that bar.
- This is the same failure class the morning's `research-procedure.md` RECONSIDER caught (Hidden Coupling High, Principle Alignment High, same Decision 8 cap, same "pre-empting the W1.5-sized deferral" pattern) — now at roughly the same shape but ~15x the file footprint (24 commands + 4 agents + 8 directories + a 13-field config block + up to 3 reference files, vs. 1 reference file then).

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Not applicable. `CHANGE_DESCRIPTION` does not claim anything is currently broken, missing, unwired, or failing — it describes an operator-directed capability deployment, explicitly framed as an override (`logs/session-notes.md`, S2-44a: *"explicit operator override of the ratified 2026-07-18 W1.5 deferral"*), not a defect fix.
- **Consequence — traced or assumed?** N/A — no consequence is claimed to justify urgency; the mandate itself states the override was a direct operator instruction, not a reasoned defect-driven necessity.
- **Re-derivation vs. the change description:** All headline counts re-derived and confirmed exactly — 24 manifest-declared local commands (verified against `shared-manifest.json`), 19 new / 5 collide (verified with `[ -L ]` against the project's actual 88-file `.claude/commands/`, all 5 collisions confirmed as symlinks to canonical `ai-resources/.claude/commands/`), 4 template agents / 2 new / 2 collide (same method, confirmed). **One discrepancy found:** item 5 names only `quality-standards.md` and `known-limits.md` as the reference files to instantiate, but `run-cluster.md:11` states *"all three are hard-class"* — `reference/source-class-hierarchy.md` is also hard-class to `run-cluster` and is omitted from the change's own count. This is an undercount, not an overcount: the real `reference/`-file footprint is 3 new files (2→5 total), one worse than described, which strengthens (does not weaken) the Dimension 6 Decision-8 finding.
- **Not defect-justified — no premise to verify.** Risk: Low. (The substantive concern — that this imports far more chassis than the confirmed need warrants, at a scale that reverses three unacknowledged same-day decisions — is fully addressed under Dimensions 3, 5, and 6, not a defect claim under Dimension 7.)

## Recommended redesign

Dimension 6 is High with only one of four implicated decisions loudly acknowledged — per the framework this forces RECONSIDER on its own, reinforced by four more High dimensions (1, 3, 4, 5). The path is **rescope**, not a full loud-revision of all four decisions — the sizing mismatch (Dimension B) and mission-boundary conflict (Dimension D) argue against re-ratifying "deploy the whole chassis" even loudly, since the underlying need (per W1.1's own inventory, gap 1: partner-voice evidence) does not require it.

- **Never touch the 5 colliding commands or 2 colliding agents.** Copy only the 19 non-colliding local commands and the 2 genuinely new agents (`qc-gate`, `verification-agent`); leave `prime`, `wrap-session`, `audit-repo`, `friction-log`, `improve`, `execution-agent`, `improvement-analyst` as the canonical symlinks they are today. This alone removes the entire Dimension 3/4/5 harness-collision hazard (15 dependent files) in one move, and update `projects/axcion-content-programme/.claude/shared-manifest.json` in the same commit to declare the 19+2 as `commands.local`/`agents.local` so `auto-sync-shared.sh` stops reporting drift.
- **Size the import to the confirmed need, not the template.** Decision 1 already rejected "deploy the whole chassis"; importing 19 report-pipeline commands (`produce-architecture`, `review-chapter`, `verify-chapter`, `workflow-status`, etc.) for a project with no multi-chapter report and no `Section IDs`/`Country set` concept relocates the sizing mismatch rather than resolving it. Identify the specific commands the actual research gap (partner-voice evidence, W1.1 gap 1) requires — plausibly `run-execution` and `run-preparation` alone — and defer the rest until a second confirmed need exists.
- **Do not silently exceed Decision 8's reference/ cap.** Either fold only the article-independent chassis content into the existing 2 files (continuing this morning's precedent), or, if the full `quality-standards.md`/`known-limits.md`/`source-class-hierarchy.md` trio is genuinely required, amend Decision 8 explicitly in the same commit — answering the OP-11 five questions — rather than adding files with no acknowledgment.
- **Route through, or explicitly diverge from, the mission's validated path.** `research-workflow-deploy-fitness` is active, owns this template's deployment fitness, and names Sector Intelligence as pilot 1 with a validated safeguards checklist. If a bespoke non-`/deploy-workflow` merge is genuinely required here (since Step 2 hard-stops on an existing target directory), record that divergence explicitly in `logs/decisions.md` and apply the mission's "At deployment" safeguards checklist to this deployment too, rather than shipping a second, unvetted deployment mechanism silently.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, `[ -L ]`-verified symlink checks, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit re-derivation checks). No training-data fallback was used on fetch/read failures.
