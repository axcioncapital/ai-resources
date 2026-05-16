# Risk Check — 2026-05-16

## Change

Edit ai-resources/.claude/commands/new-project.md (project pipeline orchestrator) to add two enrichments to the Post-Pipeline Enrichment section:

(1) New step 4a (after CLAUDE.md scaffold, before initial sync): Create `projects/{name}/logs/` directory and a `logs/decisions.md` scaffold file with a minimal template (heading + a `## YYYY-MM-DD — {decision title}` template comment). Idempotent — skip if file already exists.

(2) New step 5a (after initial sync): Canonical command verification step. Enumerates a hard-coded list of minimum-required canonical commands (prime, wrap-session, session-start, session-plan, open-items, qc-pass, resolve, clarify, scope, recommend) and verifies each is present as a symlink (or file) in projects/{name}/.claude/commands/. If any are missing, surface a clear error and instruct re-running the auto-sync hook. The auto-sync hook is the bulk install mechanism (unchanged); this step is a safety-net verification to catch hook-exclusion regressions.

Affects every newly created project. Plan-item flagged this as "shared-state automation" class per the source plan, even though the changes are mechanical (read-only verification + idempotent file scaffold — no cross-session writes, no auto-commit, no hook wiring changes). Source: friday-act 2026-05-16 journal-improvements plan #2.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md — exists

## Verdict

GO

**Summary:** Mechanical enrichment of an existing orchestrator with one idempotent file scaffold and one read-only verification; no permission, hook, or contract changes; revert is a single-file edit.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change targets `new-project.md` (model: sonnet, header line 2 of the file). Loaded only when `/new-project` is invoked — not an always-on file. No SessionStart/PreToolUse/Stop hook is registered.
- Both steps are inline bash blocks in the same command file; they add ~30–60 lines to a 530-line file. Tokens are paid only when the orchestrator is invoked, which is once per new project (rare).
- The verification step performs read-only `test -L`/`test -f` checks against ~10 paths; trivial per-invocation cost.
- No `@import` chains, no skill description expansion, no subagent brief growth.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edits to any `settings.json`/`settings.local.json` allow/deny/defaultMode block. The change description does not introduce any new tool family or glob.
- `mkdir -p projects/{name}/logs` and `Write` of a scaffold `logs/decisions.md` are already covered by the canonical Layer-D allow block this same command installs (lines 242–273: `Write`, `Edit`, `Bash(*)`).
- The verification step uses standard shell tests already authorized.

### Dimension 3: Blast Radius
**Risk:** Low

- Single file touched: `ai-resources/.claude/commands/new-project.md`.
- Grep enumeration of `logs/decisions.md` references (already established convention in the repo): 14 matches across `friday-journal.md`, `open-items.md`, `log-sweep.md`, `wrap-session.md`, `prime.md`, `repo-dd.md`, `save-session.md`, `collaboration-coach.md`, `dd-log-sweep-agent.md`, `log-sweep-auditor.md`. The scaffolded file matches the path these commands already expect. This is a contract *alignment*, not a contract change.
- All 10 named canonical commands exist in `ai-resources/.claude/commands/`: `prime.md`, `wrap-session.md`, `session-start.md`, `session-plan.md`, `open-items.md`, `qc-pass.md`, `resolve.md`, `clarify.md`, `scope.md`, `recommend.md` (verified by `ls`). None are in the auto-sync EXCLUDE list (`auto-sync-shared.sh` line 35: `EXCLUDE_COMMANDS="new-project deploy-workflow"`), so the hook already symlinks all 10 into every project — the verification step will pass under normal operation.
- No callers depend on the absence of `logs/decisions.md` or the absence of a verification step. `wrap-session.md:24` already states "If the file doesn't exist, create it" — pre-scaffolding is strictly compatible.
- Pipeline-internal `pipeline/decisions.md` (line 116) is a separate file from `logs/decisions.md` — no namespace collision.

### Dimension 4: Reversibility
**Risk:** Low

- Step 4a writes one file into a *new* project directory. The change to `new-project.md` itself is one Edit; `git revert` of that commit fully restores the orchestrator. Already-created projects with the scaffold file retain it harmlessly (it matches existing repo convention), and operators can delete it manually if undesired — no propagating side effects.
- Step 5a is pure read-only verification; reverting removes it with no cleanup cost.
- No external writes (no push, no API), no append-only log mutations in shared logs, no hook auto-fires.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The `logs/decisions.md` filename and heading shape are already established convention. `wrap-session.md` (lines 24, 33, 40, 57, 69), `prime.md` line 40, `open-items.md` line 39, and `log-sweep-auditor.md` line 69 all reference this exact path with the same semantics. The scaffold aligns to that contract — it does not invent a new one.
- The "minimum-required canonical commands" list is hard-coded in the change. It overlaps in purpose with the auto-sync hook's bulk install but does not duplicate the install action — it only *verifies*. The change description explicitly names this overlap and frames step 5a as a safety net, not a parallel mechanism. Risk of drift: if a command is renamed or retired in ai-resources, the hard-coded list will fail without an update to `new-project.md`. This is a small maintenance dependency, not a hidden one — the failure mode is a clear error, not silent breakage.
- No auto-firing in unexpected contexts: step 4a runs once during `/new-project` enrichment; step 5a runs once immediately after. Both are scoped to the pipeline run.
- No silent reliance on sort order, path separators, or downstream subagent markers.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `new-project.md` read in full (530 lines); `auto-sync-shared.sh` EXCLUDE list verified (line 35); 10 canonical command files verified present via `ls`; 14 cross-file references to `logs/decisions.md` enumerated via grep across `ai-resources/.claude/`. No training-data fallback used.
