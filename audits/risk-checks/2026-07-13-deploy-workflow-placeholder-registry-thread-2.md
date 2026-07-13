# Risk Check — 2026-07-13

## Change

Rewrite of /deploy-workflow Steps 5–7 and Step 11 (placeholder handling), plus completion of the research-workflow SETUP.md placeholder reference table. Mission research-workflow-deploy-fitness, thread 2.

WHAT CHANGED
1. `.claude/commands/deploy-workflow.md` Step 5 — replaced regex-discovery (`grep -roh '{{[A-Z_]*}}'`) with a DECLARED registry: Class A required (26 placeholders), Class B conditional (4, parts-based model only), Class C never-fill notation (3), Class D template-internal (94, inside six reference/*.template.md). Added Step 5a "fill scope" (excludes *.template.md, SETUP.md, and produce-architecture.md when the parts model is unused) and Step 5d drift cross-check (broad scan of fill scope; anything not in A/B/C = unregistered → STOP the deploy).
2. Step 6 — prompts only for Class A (+B if selected). Never prompts for C or D.
3. Step 7 — replaced `find … | xargs sed` with `find … \( -name … -o -name … \) ! -name "*.template.md" ! -name "SETUP.md" -print0 | xargs -0 sed`. Replaced the "no {{ anywhere" verification with a registry-scoped assertion + a `diff -r` byte-identity check on the six template files.
4. Step 11 item 1 — same fix to the always-fails leftover assertion; added a template byte-identity item.
5. `workflows/research-workflow/SETUP.md` — completed the Placeholder Reference table (it listed 8 and omitted all 13 Project Config fields + both CONFIDENTIAL_IDENTIFIER fields), split into Class A/B/C/D, and bound it in a stated lockstep contract to the Step 5b registry.

EVIDENCE (all established by EXECUTION this session, not by reading)
- OLD Step 7 is provably NON-FUNCTIONAL in this workspace: `find | xargs` word-splits on the space in "Claude Code/Axcion AI Repo". Ran it on a real-shaped path: ZERO replacements, exit 1, sed error on a truncated path.
- OLD Step 7 on a space-free path DOES work — and mutates 5 of 6 *.template.md files (hash-verified). So it is either dead or destructive.
- OLD leftover assertion (Step 7 verify + Step 11.1) fails by ~97 counts on a CORRECT deploy (94 Class-D + 3 Class-C), so it cries wolf and gets ignored.
- OLD regex finds 63 of 128 placeholders, missing all 65 digit-bearing ones incl. {{CONFIDENTIAL_IDENTIFIER_1/2}} (which live in CLAUDE.md, a deploy-time file), while also matching {{PLACEHOLDER}}, a documentation token in SETUP.md.
- NEW logic verified end-to-end on a fixture on a space-containing path: all 26 Class-A filled incl. CONFIDENTIAL_IDENTIFIER_1/2; all six *.template.md byte-identical (diff); Class B/C preserved; drift guard proven falsifiable (planted an unregistered placeholder → caught).
- Pre-fix FAILS the acceptance test, post-fix PASSES it.

BLAST RADIUS (verified by find, not asserted from memory)
- Two real copies of deploy-workflow.md: `ai-resources/.claude/commands/` (canonical, 349 L, unedited — 3 symlinks point at it: workspace root, archive/nordic-pe-macro-landscape-H1-2026, projects/axcion-website) and this worktree's copy (469 L, edited, on branch session/2026-07-13-research-workflow). Two checkouts of the same repo; consumers see the change only on merge to main.
- No live project invokes /deploy-workflow (it runs once, at deployment).
- No live project still contains SETUP.md (Step 10 removes it at deploy) — so the SETUP.md edit affects FUTURE deploys only.
- Two live projects (research-pe-regime-shift-advisory-gap, positioning-research) were deployed from this template and were verified this session to carry NO genuinely-wrong unfilled deploy-time placeholders. They are unaffected by this change.

KEY RISKS TO INTERROGATE (do not take my framing on trust — verify each against the files)
a) The registry (Step 5b) and SETUP.md's table are now a deliberate TWO-SOURCE-OF-TRUTH bound only by a stated lockstep contract plus the Step 5d drift guard. Is that guard sufficient, or does this recreate the exact class of silent drift that caused thread 1 (a declared contract that contradicted the real writer)?
b) Step 7 writes `/tmp/fill-scope.list` — a FIXED path. Two concurrent deploys would collide on it. Is that a real hazard or theoretical?
c) The registry hardcodes counts (26/4/3/94/128). Counts embedded in prose go stale silently. Is the Step 5d guard actually the thing that catches that, or do the counts drift unguarded?
d) Class C ({{Country_1/2/N}}) is my judgment call that these are format notation, not fillable values. Challenge it: could a multi-country project legitimately need them filled?
e) Does excluding SETUP.md from fill scope break anything downstream (it is removed at Step 10, but is it read by anything before that)?
f) Is there any consumer of deploy-workflow.md's Steps 5–7 contract other than the command itself — e.g. /sync-workflow, /new-project, /promote-workflow, or a hook?

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/.claude/commands/deploy-workflow.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/SETUP.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/workflows/research-workflow/reference/ — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/logs/missions/research-workflow-deploy-fitness.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/deploy-workflow.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources-research-workflow/.claude/commands/sync-workflow.md — exists

## Verdict

GO

**Summary:** The change is a well-grounded, execution-verified bug fix confined to two files in a rarely-invoked, currently-uninvoked (by any live consumer) command; the one real elevated finding — an unguarded second leg of a two-source-of-truth (SETUP.md vs. the Step 5b registry) — is bounded to documentation accuracy, not functional breakage, and does not by itself require caution-gating the whole change.

## Consumer Inventory

Search terms used: `deploy-workflow`, `SETUP.md`, `{{PLACEHOLDER}}` / `{{[A-Za-z0-9_]*}}`, `REGISTRY_RE`, `fill-scope.list`, `Class A`, `check-template-drift.sh`, `sync-workflow`. Searched `ai-resources-research-workflow/` and `ai-resources/` (canonical) and one level up (workspace root, `archive/`, `projects/`).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/deploy-workflow.md` (canonical, `main`, unedited — same git repo, linked worktree) | co-edits | no — normal git-merge propagation, not a separate manual edit |
| `ai-resources/workflows/research-workflow/SETUP.md` (canonical, `main`, unedited) | co-edits | no — same reason |
| Symlink `<workspace-root>/.claude/commands/deploy-workflow.md` → canonical | invokes | no — auto-inherits once canonical is updated |
| Symlink `archive/nordic-pe-macro-landscape-H1-2026/.claude/commands/deploy-workflow.md` → canonical | invokes | no — dormant/archived |
| Symlink `projects/axcion-website/.claude/commands/deploy-workflow.md` → canonical | invokes | no |
| `.claude/commands/sync-workflow.md` | (verified NOT a consumer) | no |
| `.claude/hooks/check-template-drift.sh` | (verified NOT a consumer) | no |
| `.claude/commands/new-project.md` | (verified NOT a consumer — has an unrelated `{{NAME}}`/`{{PROJECT_DESCRIPTION}}` mustache substitution for a different template, agent/skill scaffolding, not research-workflow) | no |
| Historical audit snapshots (`audits/repo-due-diligence-*.md`, `audits/token-audit-*.md`, `audits/repo-dd-deep-2026-{04-27,05-27}-*.md`, `audits/pipeline-review-registry.md`, `audits/backbone-manifest.md`) | documents | no — point-in-time records; will read stale after this change (e.g., one records "24 `{{...}}` mentions" in SETUP.md, now inaccurate against the corrected 33-token fill scope) but are not live-parsed by anything |

Total: 9 distinct consumers found, 0 must-change.

**Verification of the change's own risk (f):** `/sync-workflow` Step 2 explicitly excludes `settings.json`/`settings.local.json` from comparison and contains no `{{...}}` or placeholder logic anywhere — confirmed by direct read, the claim "carries no placeholder logic" is TRUE. `check-template-drift.sh` diffs only `commands/`, `agents/`, `hooks/` file contents — no placeholder or SETUP.md interaction — confirmed independent. No `/promote-workflow` command exists in this repo (grep found none). The Steps 5–7 contract has exactly one live consumer: `/deploy-workflow` itself.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/deploy-workflow` is an on-demand command (`Usage: /deploy-workflow [project-name]`), invoked once per project deployment — not auto-loaded, not a hook, not a skill with broad trigger keywords.
- File grew from 349 lines (per `audits/token-audit-2026-07-03-ai-resources.md:120`) to 469 lines (measured this session) — a real ~34% size increase, but the added tokens are only paid when the command is invoked, which is rare (historically once per new project).
- No edit to workspace CLAUDE.md or repo CLAUDE.md (both read in full; neither references this change).
- No new hook registered; no `@import` added.
- Note (non-blocking): this command was already flagged in three prior token audits (`token-audit-2026-04-24`, `-05-18`, `-07-03`) as a candidate for the protocol-file compression pattern used by `/token-audit`. This change moves further in the verbose direction. Not a risk-elevating factor on its own since it's pay-as-used, but worth a future compression pass.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings.json` or `.claude/settings.local.json` touched by this change (git status confirms only `deploy-workflow.md`, `SETUP.md`, and `logs/session-notes.md` modified).
- `ai-resources-research-workflow/.claude/settings.json` already grants `Bash(*)` (line 4) — the new `find`/`xargs`/`sed`/`diff` invocations in Step 7 use tool families already broadly permitted; no new capability class introduced.
- No Write path, external API, or MCP server touched.

### Dimension 3: Blast Radius
**Risk:** Low

- Consumer Inventory (Step 1.5): 9 consumers found, **0 must-change**. The only "co-edit" pair is the canonical `main`-branch twin of each edited file, and that propagates via ordinary git merge in the same repository (confirmed via `git worktree list`: `ai-resources` and `ai-resources-research-workflow` are linked worktrees of one repo, not separate repos) — not a distinct manual edit obligation.
- Contract change: Steps 5–7's internal mechanism changed (regex-discovery → declared registry), but the external contract — the command still resolves `{{...}}` tokens in-place and produces a working project — is unchanged, and the only consumer of that contract (`/deploy-workflow` itself) is the file being edited.
- Two commands the change description asked to be checked as possible hidden consumers (`/sync-workflow`, `check-template-drift.sh`) were verified independent by direct read (see Consumer Inventory note above) — no gap between anticipated and actual blast radius.
- No shared infrastructure (logs, cross-cutting hooks, always-loaded CLAUDE.md) touched.

### Dimension 4: Reversibility
**Risk:** Low

- Single git repo (confirmed via `git worktree list` and `.git` gitdir pointer — this worktree shares the `ai-resources` repo's object store). A `git revert` of the two commits (deploy-workflow.md, SETUP.md) on this branch, or simply not merging the branch, fully restores prior state.
- No data/log mutation from this change itself (the concurrent `logs/session-notes.md` edit is a separate, standard session-notes append, not part of this change's mechanism).
- Nothing pushed yet (workspace push-gating rule; `git push` is batched to session-end per workspace CLAUDE.md).
- No external writes (no PR, no Notion, no API call).
- The only runtime artifact this change introduces, `/tmp/fill-scope.list`, is outside version control and self-overwrites on next invocation — irrelevant to revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Finding 1 — SETUP.md/registry lockstep has only one automated leg.** Step 5d's drift scan compares the FILL SCOPE grep (real template files) against the Class A+B+C list declared in `deploy-workflow.md` Step 5b — verified by reading Step 5d's exact bash: it never reads `SETUP.md`. So the guard catches template-vs-registry drift (verified functional: 128 total distinct tokens / 33 fill-scope tokens (26+4+3) / 94 template-only tokens, computed directly via `grep -oh` across the real template tree — matches the command's own stated math exactly), but SETUP.md's mirrored table can silently drift from the registry with no automated catch — only the documented convention ("The two must be updated together"). Impact is bounded: SETUP.md is non-executed documentation, deleted at Step 10 before any pipeline stage reads it (confirmed: no command reads SETUP.md programmatically, per grep across all commands and per `audits/repo-due-diligence-2026-04-27-workflow-research-workflow.md:83`, "not loaded at runtime"). This is the same failure *class* the change description itself asks about (risk a) and directly echoes thread 1's diagnosed pattern (a declared contract with no automated cross-check) — real, but here confined to doc accuracy rather than a runtime deadlock.
- **Finding 2 — hardcoded prose counts (26/4/3/94/128) are not fully guarded.** Step 5d validates placeholder *names* against class membership, not the numeric literals in the headers/echo-blocks. A future edit that adds a Class-A placeholder would be caught by 5d (unregistered-name detection), forcing a manual registry fix — but nothing forces the "26" in the header prose or the `echo` block in Step 5d's fill-plan display to be bumped afterward. Verified: today's counts are accurate (confirmed above by direct grep), but the guard does not cover this specific staleness vector.
- **Finding 3 — `/tmp/fill-scope.list` is a fixed, non-unique path.** Two concurrent `/deploy-workflow` invocations (even across different target projects) would race on this file. Likelihood is low (single-operator workspace, rare command), but the hazard is real, not theoretical — nothing in the command scopes the path by PID, timestamp, or `PROJECT_NAME`.
- These three findings are multiple implicit dependencies on manual diligence / low-likelihood-but-real operational assumptions — the basis for Medium rather than Low. None causes silent functional corruption (each has a bounded, identified blast radius), which is the basis for Medium rather than High.
- **Verified as non-findings:** the Class-C `{{Country_1/2/N}}` judgment call (risk d) is confirmed correct — `reference/quality-standards.md:102–124` shows these are a per-claim table-header format instantiated ad hoc during Stage 2/3 cluster-memo writing (using the real `{{COUNTRY_SET}}` values, which ARE Class A), not a deploy-time value; a multi-country project does not need them filled at deployment. SETUP.md exclusion from fill scope (risk e) is confirmed safe — nothing reads SETUP.md before Step 10 deletes it.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read; frozen-ID index available and used).

- **OP-9 / DR-7 / AP-7 (speculative abstraction).** Not implicated — the registry and Step 5d fix a demonstrated, execution-verified defect in the sole existing consumer of this contract (`/deploy-workflow`); nothing is built for an absent second consumer.
- **OP-12 (closure before detection).** The change adds new detection (Step 5d's drift scan) paired with a working closure action in the same step — an unregistered placeholder **stops the deploy** until the registry is fixed, rather than shipping a dangling finding. This is the principle's intended shape (detection ships behind, and paired with, a closure channel), not a violation.
- **OP-5 (advisory vs. enforcement).** Step 5d halts and reports rather than auto-correcting — consistent with the command's pre-existing halt-on-precondition pattern (Step 1 "stop and tell the user", Step 2 same, Step 6 "halt if the user cannot supply" DOCUMENT_MODEL). Not an enforcement upgrade.
- **OP-2 (automate execution, gate judgment).** Class A values still require explicit `[Operator]` input at Step 6; no judgment call is silently automated.
- **DR-1 / DR-3 (placement).** Both edited files stay in their existing canonical homes; no placement change.
- **OP-10, OP-11/OP-3** — not implicated (no cross-tool boundary change; no principle being revised).
- Minor, non-blocking tension noted but not scored as a separate finding here (already captured under Dimension 5): keeping the registry and SETUP.md's table as two documents bound by a partial guard, rather than generating one from the other, is a "channel not subsystem" judgment call consistent with the mission's own stated "smallest general fix wins" rule — reasonable given this repo has no markdown-templating build step, but it is the source of Dimension 5's Medium and worth a follow-on hardening note (see below).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts computed live against the real template tree, verbatim quotes from CHANGE_DESCRIPTION or referenced files, `git worktree list` / `readlink` output for the blast-radius and reversibility claims, or explicit verification of the three named "verify this" consumer candidates). No training-data fallback was used on fetch/read failures. One follow-on hardening suggestion (non-blocking, does not affect the GO verdict): extend Step 5d to also diff SETUP.md's declared Class A/B/C token list against the Step 5b registry (not just the registry against the real template files), closing Finding 1's residual gap; and give `/tmp/fill-scope.list` a `PROJECT_NAME`-scoped or `mktemp`-based path to remove Finding 3's collision surface.
