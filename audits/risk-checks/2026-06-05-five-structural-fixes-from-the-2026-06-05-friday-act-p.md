# Risk Check — 2026-06-05

## Change

Five structural fixes from the 2026-06-05 friday-act plans (batch):

1. Add `"defaultMode": "bypassPermissions"` to `ai-resources/.claude/settings.local.json` — the file currently has a permissions block with 5 narrow Bash allows but NO defaultMode, so it shadows the parent's bypassPermissions and causes permission prompts in every ai-resources session. Fix: add the missing defaultMode field. CRITICAL restoration of existing intended behavior.

2. Add Read() deny rules to workspace-root `.claude/settings.json` — currently has zero Read() deny rules (only Bash denies). Propose adding: `Read(audits/**)`, `Read(logs/scratchpads/**)`, `Read(projects/*/output/**)` or similar stale-content dirs. ai-resources settings.json already has partial coverage. Separately extend research-pe deny coverage (additive change).

3. Correct stale push-rule text in `marketing-positioning/CLAUDE.md` and `research-pe/CLAUDE.md` — both still say "Do not push. Pushing is a manual operator step." (pre-2026-05-29 inverted rule). Replace with the current gated-batch push language matching workspace CLAUDE.md § Push behavior.

4. Fix `/new-project` CLAUDE.md template (templates/project-claude-md/commit-rules.md + templates/project-claude-md/input-file-handling.md): (a) in commit-rules.md: replace "Do not push. Pushing is a manual operator step." with the current gated-batch push language; (b) in input-file-handling.md: convert the verbatim 9-line Input File Handling block to a one-line pointer: "Full rule: `ai-resources/docs/file-write-discipline.md`." (c) optionally: fix the workspace-section anchor in the trailing sentence. This template shapes every future project CLAUDE.md scaffolded by /new-project.

5. Add pre-push `git fetch` + divergence check to `/wrap-session` push gate — currently wrap-session push gate has no pre-push pull/fetch step, so concurrent-machine push rejection (non-fast-forward) is structurally guaranteed. Fix: before `git push`, run `git fetch origin` and check `git rev-list @{u}..HEAD` vs `git rev-list HEAD..@{u}` — if remote has new commits, surface a rebase prompt before proceeding with push. Separately decide whether to set `pull.rebase=true` policy (deferred to a dedicated decision step, not part of this batch).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.local.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/marketing-positioning/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/research-pe-regime-shift-advisory-gap/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/commit-rules.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/project-claude-md/input-file-handling.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Four of the five fixes are low-risk corrective changes that restore intended behavior, but change #2 (workspace-root Read() deny rules) is underspecified and, as proposed, would re-introduce a deny pattern the repo deliberately retired and would break `/prime` scratchpad resume — and change #5 must be applied to a second non-symlink `wrap-session.md` copy or it lands half-done.

## Consumer Inventory

Search terms: `defaultMode`, `settings.local.json`, `Read(audits`, `Read(logs/scratchpads`, `permission-template`, `wrap-session`, `commit-rules.md`, `input-file-handling.md`, `project-claude-md`, "manual operator step".

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/hooks/check-permission-sanity.sh` | parses (reads `.permissions.defaultMode` of settings.local.json; nudges when present-but-not-bypass) | no |
| `ai-resources/.claude/commands/permission-sweep.md` | parses/co-edits (the canonical fixer for the defaultMode shadow; change #1 is exactly its rule-1 remediation) | no |
| `ai-resources/docs/permission-template.md` | documents (canonical Read()-deny shape; line 141 explicitly RETIRED `Read(audits/working/**)`, "Do not restore it") | yes (if change #2's deny shape lands, the canonical doc must record the deviation) |
| `ai-resources/.claude/commands/new-project.md` | invokes (lines 431–474 `cat` the template fragments `commit-rules.md` + `input-file-handling.md` into every new project CLAUDE.md at scaffold time) | no (consumes #4's output automatically) |
| `ai-resources/templates/README.md` | documents (declares the fragment files as single source of truth, lines 9–12) | no |
| `.claude/commands/wrap-session.md` (workspace-root, REAL copy) | co-edits (independent non-symlink copy with its own push gate at line 351, no fetch step — paired contract with the canonical) | yes (change #5 must touch this copy too) |
| `ai-resources/workflows/research-workflow/.claude/commands/wrap-session.md` (REAL copy) | co-edits (third real copy; no push gate found — divergent, lighter) | no (no push gate to fix) |
| ~16 project `.claude/commands/wrap-session.md` symlinks | imports (symlink → canonical ai-resources copy) | no (inherit #5 automatically) |
| `ai-resources/.claude/commands/prime.md` (Step 1b) | parses (reads `logs/scratchpads/*-scratchpad.md` for resume detection) | no — but a `Read(logs/scratchpads/**)` deny at #2 would BREAK this |
| `ai-resources/.claude/agents/*` (qc-reviewer, log-sweep-auditor, diagnostics-scanner, fix-repo-issues-scanner, friday-journal) | parses (write to + main session reads from `audits/working/`) | no — but a broad `Read(audits/**)` deny would block these summary reads |
| `projects/research-pe-regime-shift-advisory-gap/.claude/settings.json` (line 22 `deny`) | co-edits (change #2's "extend research-pe deny coverage" target) | yes (additive deny extension) |
| `projects/marketing-positioning/CLAUDE.md` (line 144) | co-edits (stale push text, change #3) | yes |
| `projects/research-pe-regime-shift-advisory-gap/CLAUDE.md` (line 132) | co-edits (stale push text, change #3) | yes |

Total: 13 distinct consumer rows; 5 must-change (`permission-template.md`, workspace-root `wrap-session.md`, research-pe `settings.json`, the two project CLAUDE.md files). Two consumers (`prime.md` scratchpad read, the `audits/working/` reader agents) are NOT in the change's anticipated set and are at risk of being broken by change #2 — that gap is itself a blast-radius finding.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to an always-loaded CLAUDE.md; change #4(b) REMOVES ~9 lines from the project-CLAUDE.md template (verbatim Input File Handling block → one-line pointer), reducing per-turn load for every future scaffolded project. Net token cost is negative.
- Change #1 edits `settings.local.json` (not loaded as context); changes #2/#5 edit settings and a command body (pay-as-used, not always-loaded).
- No new hook, no `@import`, no new frequently-spawned subagent brief.

### Dimension 2: Permissions Surface
**Risk:** Medium

- Change #1 ADDS `defaultMode: bypassPermissions` to `ai-resources/.claude/settings.local.json` (currently absent — confirmed at lines 2–11 of the file). This *widens* effective permission (removes prompts) but only restores the parent `.claude/settings.json` line 26 posture the local file was shadowing — it does not grant anything the workspace layer did not already grant. The `check-permission-sanity.sh` hook exists specifically to nudge this exact drift (lines 49, 12–13). Consistent with established pattern → not High.
- Change #2 ADDS `Read()` deny rules to workspace-root `.claude/settings.json` (narrowing, not widening — moves toward least-privilege). Narrowing reads is the safe direction, but see Blast Radius / Hidden Coupling: the *specific* globs proposed are hazardous.
- Change #2 also extends `research-pe/.claude/settings.json` deny (line 22) — additive narrowing, low surface risk.
- Net: one permission-restoring widen (#1, bounded) + several narrowing denies (#2). Medium because #1 is a genuine bypass-mode change to a settings layer, even though it restores intended state.

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Consumer Inventory: 13 consumer rows, 5 must-change. Most are isolated corrective edits.
- **Change #5 is wider than the description implies.** The description names "`/wrap-session` push gate" as if singular. The inventory found TWO real (non-symlink) copies with push gates/behaviour: the canonical `ai-resources/.claude/commands/wrap-session.md` (push gate line 401) AND the workspace-root `.claude/commands/wrap-session.md` (independent copy, push gate line 351, no fetch). The canonical file's own Step 3.5 PAIRED-CONTRACT comment (lines 42–48) confirms the workspace-root copy is a deliberate non-symlink sibling kept in sync by hand. If #5 edits only the canonical copy, the workspace-root push path keeps its non-fast-forward exposure — the fix lands half-done. ~16 project symlinks inherit the canonical fix automatically (no action needed there).
- **Change #2 touches shared infra in a way that affects multiple workflows.** `audits/working/` is written by 5+ auditor agents and read back by their invoking commands (qc-reviewer line 136, log-sweep-auditor, diagnostics-scanner, fix-repo-issues-scanner, friday-journal). `logs/scratchpads/` is read by `/prime` Step 1b. A blanket `Read(audits/**)` or `Read(logs/scratchpads/**)` deny would reach these consumers. (Mitigated partly by the fact that the deny is at workspace-root and these paths are under `ai-resources/` — see Hidden Coupling for the path-scope ambiguity that makes the blast radius uncertain rather than certain.)
- Change #4 propagates to every FUTURE project via `/new-project` (new-project.md lines 462/464 `cat` the fragments) — forward blast radius, but only on next scaffold, and the change is a correction, so the propagation is desirable.

### Dimension 4: Reversibility
**Risk:** Low

- All five changes are single-file or small-multi-file edits that `git revert` restores cleanly. No data/log-file mutation, no append-only log entry, no external write, no symlink/hook creation.
- Change #1 edits `settings.local.json` — note this file may be gitignored in some layers; if so, revert is a manual one-line removal rather than a git op. Even so it is a single trivial edit. (The referenced file is tracked here per the Read, so git revert applies.)
- No state propagates beyond the local working tree at change-apply time (the push itself remains operator-gated).

### Dimension 5: Hidden Coupling
**Risk:** High

- **Change #2 would re-introduce a deliberately-retired deny pattern.** `permission-template.md` line 141 states the canonical shape DELIBERATELY OMITS `Read(audits/working/**)` because the directory is gitignored and main-session reads of auditor `*.summary.md` files are required by `/permission-sweep` Step 4 — closing with "the deny was retired 2026-04-28. Do not restore it." A proposed `Read(audits/**)` is BROADER than the retired rule and silently re-blocks exactly those reads. This is an undocumented conflict with an explicit, dated prior decision — the change site does not name it.
- **Change #2 `Read(logs/scratchpads/**)` collides with `/prime` Step 1b**, which reads `logs/scratchpads/*-scratchpad.md` to offer session resume (prime.md lines 81–84). Denying reads there would silently disable the resume-detection feature.
- **Path-scope ambiguity (compounds the above).** The proposed denies are on WORKSPACE-ROOT `.claude/settings.json`, but workspace root has no `audits/` directory (`ls -d audits` → absent); the stale audit content lives under `ai-resources/audits/`. So the proposed `Read(audits/**)` either (a) targets a non-existent path and does nothing, or (b) is intended for `ai-resources/audits/` and is in the wrong settings layer. Either way the rule as written does not do what the description intends, and the "or similar stale-content dirs" hedge confirms the glob set is not yet pinned. This is an unresolved contract.
- Change #5 silently depends on the workspace-root `wrap-session.md` being kept in sync (the PAIRED-CONTRACT convention, canonical lines 42–48) — an implicit dependency the description does not name.
- Changes #1/#3/#4 are self-contained with no hidden coupling.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base was readable (`projects/strategic-os/ai-strategy/principles-base.md`, 42-principle frozen-ID index). Checks applied: OP-12, OP-11/OP-3, DR-1/DR-3, OP-9/AP-7/DR-7, OP-5.
- **OP-11 / OP-3 (loud revision, never silent drift) — served, not violated.** Changes #3/#4 correct CLAUDE.md/template text still carrying the pre-2026-05-29 inverted push rule; bringing them in line with the current gated-batch rule is exactly the "correct the practice" arm of OP-11. The 2026-05-29 push-rule inversion is already a recorded decision (workspace CLAUDE.md § Push behavior; MEMORY note "Push is gated and batched").
- **DR-3 (component home) — served.** Change #4(b) moves a 9-line methodology block out of the project-CLAUDE.md template into a pointer to `file-write-discipline.md`, aligning with DR-5 (CLAUDE.md holds cross-session rules, not methodology).
- **No speculative abstraction (OP-9/AP-7/DR-7).** None of the five changes builds infrastructure for an absent consumer; all five have a current, confirmed consumer.
- **OP-5 caveat (not a violation).** Change #2 moves toward enforcement-by-denylist (mechanically blocking reads) rather than advisory. But deny rules are an established repo mechanism (`permission-template.md` documents the canonical deny set), so this is within an existing pattern, not a silent advisory→enforcement upgrade. The Hidden-Coupling hazards are the real problem with #2, not a principle conflict — scored there, not here.

## Mitigations

- **Change #2 (Hidden Coupling High → Low):** Do NOT use blanket `Read(audits/**)` or `Read(logs/scratchpads/**)`. Before adding any Read() deny, (a) honor `permission-template.md` line 141 — never deny `audits/working/**` or any superset of it; (b) exclude `logs/scratchpads/**` from any deny so `/prime` Step 1b resume-detection keeps working; (c) resolve the path-scope: confirm whether the intent is workspace-root `audits/` (absent — rule is a no-op) or `ai-resources/audits/` (wrong layer for a workspace-root settings file), and place the rule where the stale content actually lives. Pin the exact glob set against `permission-template.md`'s canonical Read-deny shape and record any deviation in that doc. If the glob set cannot be pinned this session, defer change #2 rather than land an unpinned denylist.
- **Change #5 (Blast Radius Medium → Low):** Apply the `git fetch` + divergence-check edit to BOTH real copies — `ai-resources/.claude/commands/wrap-session.md` (push gate ~line 401) AND workspace-root `.claude/commands/wrap-session.md` (push gate ~line 351) — per the PAIRED-CONTRACT convention (canonical lines 42–48). Verify the ~16 project symlinks point at the canonical copy (they do) so they inherit automatically; the research-workflow copy has no push gate and needs no edit.
- **Change #1 (Permissions Medium, confirm-before-apply):** This is the exact remediation `/permission-sweep` rule-1 performs (permission-sweep.md lines 198–200: `jq '.permissions.defaultMode = "bypassPermissions"'`). Prefer applying it via `/permission-sweep` (or mirror its jq idiom) so the canonical fixer stays the single source of truth, rather than hand-editing — and confirm the bypass-mode restoration matches the operator's "bypassPermissions is the floor" standing decision (MEMORY: feedback_zero_permission_prompts). It does.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION and referenced/repo files). Principle citations drawn from `projects/strategic-os/ai-strategy/principles-base.md` (readable). No training-data fallback was used on any read.
