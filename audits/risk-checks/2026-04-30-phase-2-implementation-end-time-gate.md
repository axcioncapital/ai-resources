# Risk Check — 2026-04-30

## Change

Phase 2 implementation complete. Changes executed this session: (1) New PostToolUse hook friction-log-trigger.sh registered in projects/repo-documentation/.claude/settings.json — fires on Write|Edit, logs to friction log. (2) Three new project-local agents: system-developer-agent.md (Opus, propose-only), doc-scanner-agent.md (Sonnet, read-only scanner), principles-checker-agent.md (Sonnet, read-only checker). (3) Two new vault-local commands: kb-update.md and kb-integrity.md in vault/.claude/commands/. (4) /friday-checkup in ai-resources modified — monthly tier steps G/H/I/J added (gated to monthly+). (5) /friday-act in ai-resources modified — step 15g added for W2.4 auto-draft sub-disposition. (6) projects/repo-documentation/.claude/settings.json PostToolUse block added (permissions block untouched, defaultMode bypassPermissions intact). (7) projects/repo-documentation/CLAUDE.md vault reference added as canonical living doc layer post-W2.5. (8) vault/ infrastructure: CLAUDE.md, settings.json (with bypassPermissions), shared-manifest, two templates, .obsidian/core-plugins.json — all tracked. (9) vault content (gitignored): 16 Phase 1 migration files written to disk under vault/principles/, vault/architecture/, vault/blueprint/, vault/components/.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/hooks/friction-log-trigger.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/agents/system-developer-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/agents/doc-scanner-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/agents/principles-checker-agent.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/.claude/commands/kb-update.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/.claude/commands/kb-integrity.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/vault/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.claude/shared-manifest.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/repo-documentation/.gitignore — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Phase 2 implementation is large in scope (3 agents, 2 commands, 1 hook, 2 modified canonical commands, vault infrastructure, 1 cross-cutting CLAUDE.md edit) but design discipline is high — agents are propose-only or read-only, the hook is non-blocking and recursion-guarded, and the friday-checkup steps gate to monthly+ tier. Two High dimensions (Blast Radius, Reversibility) drive the verdict; both have viable mitigations.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- New PostToolUse hook fires on every Write|Edit in repo-documentation sessions, but it short-circuits within ~3 lines for non-`friction-log.md` paths — `[ -z "$FILE_PATH" ] && exit 0` and `case "$FILE_PATH" in */friction-log.md) ;; *) exit 0 ;; esac` (friction-log-trigger.sh:14, 17–20). Per-tool-call cost is negligible (jq parse + path match).
- The three new agents are NOT auto-loaded; they are spawned on demand. system-developer-agent fires only inside `/friday-act` step 15g (auto-draft sub-disposition); doc-scanner-agent fires only inside `/friday-checkup` step G (monthly+); principles-checker-agent fires only inside `/friday-checkup` step H (monthly+). All three are pay-as-used. Cumulative agent body sizes are large (~136 + ~189 + ~193 = ~518 lines combined) but they live in spawned subagent context, not main-session always-loaded context.
- The two vault-local commands (kb-update.md, kb-integrity.md) auto-load their command bodies only when invoked. They live under `vault/.claude/commands/`, which loads only in vault sessions (cwd=vault).
- The `/friday-checkup` steps G/H/I/J add ~70 lines to the command body that DO load every time `/friday-checkup` runs — but `/friday-checkup` is invoked weekly at most, so the cost is ~70 lines × 1/week, negligible at session level.
- Project CLAUDE.md (`projects/repo-documentation/CLAUDE.md`) gained one bullet ("Phase 2 cadence:..." line 15) and one phrase update at line 7 — net ~3 lines of new always-loaded content per repo-documentation session. Below the 50-token threshold for low risk by token count, but it does compound with the existing always-loaded content.
- vault/CLAUDE.md is ~125 lines of new always-loaded content for vault sessions — High at the vault-session level. Vault sessions are a separate operating context (cwd=vault); for those sessions, this is a substantial new always-loaded file. However, vault sessions are bounded and intentional, so the operator-facing cost is the price of having a canonical vault doc layer at all.

### Dimension 2: Permissions Surface
**Risk:** Low

- `projects/repo-documentation/.claude/settings.json` permissions block is unchanged from prior state. The diff is purely the addition of a `PostToolUse` hooks block (lines 50–61). The `defaultMode: bypassPermissions` is preserved at line 34 (also unchanged).
- `vault/.claude/settings.json` is a NEW settings file (lines 1–27). It declares `defaultMode: bypassPermissions` at line 24 — this matches the workspace permissive-config philosophy documented in user memory ("Repo intentionally permissive; safety via git/risk-check/audits, not prompts"). The deny list adds `Read/Write/Edit(../output/phase-1/**)` rules (lines 17–19), which is a NARROWING (additional protection on the archived baseline), not a widening.
- vault/.claude/settings.json `allow` list (`Bash(*)`, `Edit`, `Glob`, `Grep`, `Read`, `Skill`, `TodoWrite`, `Write`) is narrower than the project's parent settings.json (which also includes `Agent`, `Edit(**/.claude/**)`, `MultiEdit`, `NotebookEdit`, `WebFetch`, `WebSearch`, `Write(**/.claude/**)`, `ToolSearch`). Vault sessions get fewer capabilities than parent project sessions — net narrower posture.
- No new `Bash(<command>:*)` allow entries introduced anywhere. No deny rule was removed.
- Scope: all permission additions are project-local or vault-local. None touch workspace-root or `~/.claude/settings.json`. No cross-repo or external-API capability introduced.

### Dimension 3: Blast Radius
**Risk:** High

- Direct file touches: 1 settings.json added PostToolUse block; 1 new hook .sh; 3 new agent .md files; 2 new command .md files; 2 modified canonical commands (`/friday-checkup`, `/friday-act`); 1 modified project CLAUDE.md; 1 new vault CLAUDE.md; 1 new vault settings.json; 1 new shared-manifest entry; 2 new templates; 1 .obsidian config; 1 modified .gitignore (per the change description); 16 new gitignored vault content files. Total: ~30+ files touched in one change set.
- `/friday-checkup` is heavily referenced. Grep finds 29 files reference `friday-checkup` in `ai-resources/` alone, including `ai-resources/CLAUDE.md`, `ai-resources/docs/repo-architecture.md`, `risk-check.md`, `permission-sweep.md`, `friday-act.md`, and 7+ prior risk-check reports. Adding steps G/H/I/J changes a contract that `/friday-act` parses (Schema contract referenced in friday-act.md line 46: "the section headings parsed below are produced by `/friday-checkup` Step 7's 'Section presence by tier' data contract"). Verified: the new steps add new entries to the `RESULTS` list that `/friday-act` reads under tactical follow-ups; the friday-checkup data contract section was extended to surface them, and `/friday-act` step 15g was added to dispatch them. Both ends of the contract were updated coherently — backwards-compatible if no monthly checkup runs without the new agents deployed; the new steps include `Verify ... agent .md exists. If missing, record skipped:...` guards (friday-checkup.md:186, 194), so absence is handled gracefully.
- `/friday-act` is referenced in 17 files. Step 15g is additive (only fires when source label starts with `repo-documentation:w2-4-improvements`), so existing `/friday-act` invocations on weekly tier or non-repo-documentation projects are unaffected.
- The three new agents are referenced 97 + 81 + 72 times across the repo (mostly in pipeline-phase-2/ planning docs and the new commands themselves), but as referent (i.e., they are CALLED by `/friday-checkup` and `/friday-act`), not as callers. Internal coupling: high. External callers: 2 (the two friday commands).
- Contract changes:
  - `/friday-checkup` → `/friday-act`: section-heading contract extended with new tactical-follow-up shapes ("W2.1 doc-scan Added entry → ...", "W2.2 principle violation severity error → ...", etc., friday-checkup.md lines 255–261). Backwards-compatible — these only appear when monthly tier with repo-documentation scope runs.
  - `/friday-act` → `system-developer-agent`: NEW contract on the auto-draft sub-disposition (step 15g.3 brief format). The brief structure is new but lives inside the same command file that calls the agent.
  - friction-log-trigger.sh contract: only fires on writes to `*/friction-log.md` paths. Cross-project surface: any project's friction-log.md write triggers it if cwd is repo-documentation; but the matcher key is the file basename, not project path — defensive design (friction-log-trigger.sh:23–24).
- Shared infrastructure touched: project CLAUDE.md (always-loaded for repo-documentation), the canonical `/friday-checkup` and `/friday-act` (used across all projects).

### Dimension 4: Reversibility
**Risk:** High

- Single `git revert` cleans up most of the change set: settings.json edits, all new tracked files (agents, commands, CLAUDE.md additions, hook .sh, vault CLAUDE.md, vault settings.json, templates, shared-manifest update, .gitignore edits, friday-checkup.md and friday-act.md edits).
- BUT: the 16 vault content files written to disk under `vault/principles/`, `vault/architecture/`, `vault/blueprint/`, `vault/components/` are gitignored per `.gitignore` lines 14–22 (`vault/*` excluded except infrastructure paths). `git revert` does NOT touch these files because git never tracked them. After revert, these files remain on disk but the vault infrastructure that gives them meaning (CLAUDE.md, settings, commands, templates) would be gone — orphaned content. Operator must manually `rm -rf vault/principles vault/architecture vault/blueprint vault/components` and `rm vault/_master-index.md vault/components/_index.md` to fully roll back.
- The PostToolUse hook fires immediately on next session start (it's registered the moment settings.json is committed). Between landing this commit and any potential revert, every Write|Edit in repo-documentation sessions runs the hook. Effect is benign (only `friction-log.md` writes trigger the systemMessage), but the hook IS automation that fires automatically, which is in `/risk-check` change class "Automation with shared-state effects."
- Operator-remembered workflow: the change introduces several new operator-facing workflows (`/kb-update`, `/kb-integrity`, monthly tier surfacing W2.x items, `/friday-act` auto-draft sub-disposition). Operator muscle memory will form around these; reverting after a few weeks of use means re-learning the prior cadence.
- `improve-skill` and `migrate-skill` and other canonical pipelines are untouched — no external propagation beyond what was already present.
- Vault `_master-index.md` and `components/_index.md` are atomically maintained per the kb-update.md workflow. After several `/kb-update` invocations, these files diverge from any pre-Phase-2 state — even if the operator wants to "go back to before vault was a thing," the indexes are append-mutated, not just appended.
- No external/network writes (no git push, Notion, API). Reversibility is bounded to the local repo + filesystem.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The PostToolUse hook is registered in `projects/repo-documentation/.claude/settings.json` and uses `$CLAUDE_PROJECT_DIR/.claude/hooks/friction-log-trigger.sh` (settings.json:56). This requires the cwd-equivalent to be the project root for the hook to resolve. Standard pattern (mirrored from `detect-innovation.sh` per the hook's own docstring at line 8); coupling is to an established convention.
- The hook fires on `Write|Edit` matcher (settings.json:52), which is the SAME matcher pattern used by `ai-resources/.claude/settings.json` PostToolUse for `log-write-activity.sh` and `auto-qc-nudge.sh`. The repo-documentation hook only adds local matching when cwd is the repo-documentation project; in that context, it adds a third hook to the chain (the ai-resources hooks fire too if `CLAUDE_PROJECT_DIR` resolves there). Verified: the project-local settings.json hook block does NOT reference or duplicate the workspace/ai-resources hooks; they are independent. No double-fire concern for the same `friction-log.md` write.
- `friday-checkup.md` step I (W2.3 maintenance consolidator) reads the W2.1 drift report at a hard-coded path (`projects/repo-documentation/output/phase-2/w2-1-doc-scan-{TODAY}.md`, line 204). This is a filename contract between doc-scanner-agent (which writes to that exact path per agent .md line 108) and the consolidator step. Coupling is documented in both files, but it is implicit — there's no shared schema definition that both reference.
- `system-developer-agent.md` lists "Forbidden actions (hardcoded refusal)" at line 38–43, including "Proposing edits to `output/phase-1/**` (archived baseline; read-only)." The vault settings.json deny list separately enforces `Read/Write/Edit(../output/phase-1/**)`. The hardcoded refusal is documented at the agent prompt level, the deny is at the harness level — same intent, two enforcement layers. Functional overlap, but defense-in-depth design.
- `vault/CLAUDE.md` declares the vault as "the canonical living documentation layer" (line 5) and `projects/repo-documentation/CLAUDE.md` line 11 echoes "Vault becomes the canonical working documentation layer after Phase 1 migration." Two CLAUDE.md files now jointly define the doc-layer canon. If only one is read in a given session (vault session reads vault CLAUDE.md; project session reads project CLAUDE.md), they are consistent today, but future drift between them is a likely failure mode without an explicit single source of truth.
- The shared-manifest.json (line 7) lists `system-developer-agent`, `doc-scanner-agent`, `principles-checker-agent` under `agents.local`. This prevents the auto-sync hook from clobbering them with symlinks to ai-resources. Coupling: the auto-sync hook (referenced in settings.json:43) reads shared-manifest.json. Established convention; documented at both ends.
- W2.4 auto-draft sub-disposition (friday-act.md step 15g) detects W2.4-source items by a string match on tactical-item source labels: `if the current tactical follow-up's source label starts with repo-documentation:w2-4-improvements`. This is a fragile string-match contract — the source label format is set by `/friday-checkup` step J (line 241). If either side reformats the label, the match silently fails. Risk is bounded because both files live in `ai-resources/.claude/commands/` and would be edited together, but it is an implicit contract.

## Mitigations

- **Blast radius — verify the contract between `/friday-checkup` (steps G/H/I/J) and `/friday-act` (step 15g) before committing.** Read both commands end-to-end one more time, specifically checking that: (a) the `RESULTS` source-label format `repo-documentation:w2-4-improvements` in friday-checkup.md step J line 241 exactly matches the prefix string-match in friday-act.md step 15g line 91; (b) the new tactical-item shapes in friday-checkup.md lines 255–261 conform to the existing `[ ] {item} — risk: {low | med | high}` parser in friday-act.md step 13 line 60. Mismatch here would cause silent skip on the auto-draft path.
- **Blast radius — confirm `/friday-checkup` weekly-tier behavior is unchanged.** The new G/H/I/J steps include "Skip entirely if `TIER=weekly`" at the top of each (friday-checkup.md lines 182, 192, 200, 215). Verify by tracing the weekly path: at TIER=weekly, no new agent is spawned, no new RESULTS entry is added, no new tactical-item shapes appear. If verified, weekly invocations across all projects (the high-frequency path) carry zero new cost or risk from this change.
- **Reversibility — document a roll-back recipe in the commit message or session notes.** Specifically: "To roll back Phase 2 implementation: (a) git revert the implementation commit; (b) `rm -rf projects/repo-documentation/vault/principles projects/repo-documentation/vault/architecture projects/repo-documentation/vault/blueprint projects/repo-documentation/vault/components`; (c) `rm projects/repo-documentation/vault/_master-index.md projects/repo-documentation/vault/components/_index.md projects/repo-documentation/vault/_integrity-report-*.md`." Without this recipe captured at landing, the gitignored vault content becomes unrecoverable orphan state on revert.
- **Reversibility — verify the hook is recursion-safe before landing.** friction-log-trigger.sh emits a systemMessage but does not write to friction-log.md (verified at the file's docstring line 22 "Self-guard: skip writes from this hook (not possible since hook doesn't write, but defensive)" and at the basename guard line 23–24). Confirm no future edit to the hook adds a write back to friction-log.md, since the recursion guard is defensive-only — a future edit that writes to the log would loop. Add a code comment near the systemMessage echo line 27: `# DO NOT add Write/Edit calls below this line — hook fires PostToolUse on Write|Edit and would recurse.`
- **Hidden coupling — name the W2.4 source-label contract explicitly.** Add a one-line schema-contract comment to friday-checkup.md step J near line 241 (where `RESULTS` gets `repo-documentation:w2-4-improvements` appended) noting that `/friday-act` step 15g matches on that prefix string. This makes the implicit string-match contract visible at both ends.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
