# Risk Check — 2026-06-03

## Change

Batch of 3 project-local edits to the axcion-brand-book per-module workflow (all uncommitted in the working tree now):

1. `.claude/commands/lock-module.md` Step 7 — changed from "announce ready-to-commit, do NOT git add/commit (OD-5)" to "commit the lock directly" (stage only the specific lock paths — module file, pipeline/module-status.md, edited mockups — never `git add -A`; commit; do not push). Reconciles the long-standing OD-5 vs workspace/project "Commit directly" contradiction (improvement-log 2026-06-01). Also updated the frontmatter description line. The command's model tier is sonnet.

2. `CLAUDE.md` (project) § Project structure pointers — added one bullet documenting the per-module Write-permission allow-override pattern and the settings.json session-start cache behavior (improvement-log 2026-05-29). Documentation-only; adds no rule that changes always-loaded behavior beyond informing the reader.

3. `.claude/commands/draft-module.md` Step 3 — added a Write-permission pre-flight: parse `.claude/settings.json` allow array; if `Write(./brand-book/{id}.md)` is absent, route the module-body write through a Bash heredoc (covered by `Bash(*)`) instead of the Write tool, with a one-line advisory. Same final file content; only the write mechanism changes (improvement-log 2026-05-27 / 2026-05-29).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/commands/lock-module.md — exists (edited, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/commands/draft-module.md — exists (edited, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/CLAUDE.md — exists (edited, uncommitted)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/settings.json — exists (read-only dependency of edit 3)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-brand-book/.claude/shared-manifest.json — exists (defines project-local ownership)

## Verdict

GO

**Summary:** Three low-blast project-local workflow edits that align project commands with the canonical "Commit directly" rule and remove a recurring permission-cache friction; the only elevated dimension (auto-commit of shared `module-status.md`) is already self-mitigated in the edit and carries the same exposure the prior manual posture did.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Edits 1 and 3 modify slash-command bodies (`lock-module.md`, `draft-module.md`), which are loaded only when the command is invoked — pay-as-used, not always-loaded. Both are project-local per `shared-manifest.json` lines 3-5 (`"local": ["scope-module", "draft-module", "qc-module", "lock-module"]`).
- Commands run at most ~2 more times each before project end (CHANGE_DESCRIPTION: "only 2 module runs remain"), so even the per-invocation cost is bounded and terminal.
- Edit 2 adds one bullet to project `CLAUDE.md` § Project structure pointers (now line 21, ~110 words). Project `CLAUDE.md` is always-loaded per turn, so this is a real but small ongoing cost (~150 tokens) that lands in the Low/Medium boundary; it sits in a section that already carries 8 sibling pointer bullets (lines 13-20), so the marginal cost is proportionate and the project horizon is short.
- No hook registered, no `@import` added, no subagent brief expanded, no skill added. Edit 3 adds a `settings.json` read at draft time (one extra Read per `/draft-module` run) — negligible.

### Dimension 2: Permissions Surface
**Risk:** Low

- No edit modifies the `settings.json` allow/deny arrays. Confirmed by reading `settings.json` (lines 4-63): the allow array still contains `Bash(*)` (line 6) and the per-module Write/Edit pairs; deny still locks `Write(./brand-book/0[1-8]_*.md)` (line 57).
- Edit 3 *reads* `settings.json` (parses the allow array) but does not write it — CHANGE_DESCRIPTION confirms, and `draft-module.md` line 33 reads "read `.claude/settings.json` and check whether the `allow` array contains `Write(...)`".
- Edit 3 routes a write through `Bash` heredoc when the Write allow is cache-absent. This does not widen the permission surface: `Bash(*)` is already an established allow (line 6), and the heredoc writes to the exact same module-file path the deny is meant to protect. This is a mechanism substitution within already-granted capability, not a new grant. (Note: the deny on `Write(./brand-book/0[1-8]_*.md)` is a Write-tool deny; routing through `Bash(*)` is the documented intended escape, per CLAUDE.md line 21 and the heredoc convention — the deny is a soft lock-and-protect against accidental Write, not a hard security boundary.)
- Edit 1 narrows behavior (stage only named paths, never `git add -A`, never push) — a tightening, not a widening.

### Dimension 3: Blast Radius
**Risk:** Low

- Three files touched directly; all three are project-local to `projects/axcion-brand-book`. None are ai-resources canonical and none are symlinks (confirmed: `shared-manifest.json` lists all four module commands as `local`, which the auto-sync hook skips).
- Caller enumeration (grep within the project for command references, command-invocation callers only):
  - `/lock-module` is referenced from `references/phase-workflow.md`, `references/module-sequence.md`, `.claude/commands/scope-module.md`, `.claude/commands/qc-module.md`, `CLAUDE.md`, `SESSION-GUIDE.md`, plus log/pipeline/qc-report files. The only *invocation-contract* callers are the sibling phase commands and the phase-workflow doc; all reference `/lock-module` by name + module-id argument, which the edit does not change.
  - `/draft-module` references are the analogous sibling commands + phase docs + logs. Invocation signature (`/draft-module {id}`) is unchanged by edit 3 (only Step 3 internal mechanism changed).
- No contract change: argument schema, output announcement shape, frontmatter schema, and module-id semantics are all preserved. `lock-module.md` lines 73-85 still print the same announcement block; `draft-module.md` Step 5 (lines 67-76) announcement unchanged.
- The OD-5 spec text in `pipeline/implementation-spec.md` (lines 24, 98, 729, 781, 2246) and `pipeline/architecture.md` line 421 now describes the *old* "no auto-commit" behavior — a doc-vs-command drift the edit introduces. This is a documentation-currency note, not a functional caller break: those are spec/architecture records, not executable callers, and both files are deny-locked (`settings.json` lines 37-49) so they are intentionally frozen pipeline artifacts. Flagged as a follow-up, not a blocker.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are single-file content edits to git-tracked files. `git revert` (or `git checkout --` while uncommitted) fully restores prior state within the working tree — no sibling files or directories created, no generated reports.
- Edit 1 changes *future* `/lock-module` runs to auto-commit. Any lock commit it produces is itself a normal git commit on `main`, revertable by git. No push happens (edit explicitly forbids push; `lock-module.md` line 71). So state does not propagate beyond the local repo before the operator's gated `/wrap-session` push.
- One caveat keeping this Low rather than trivially-zero: once `/lock-module` runs under the new behavior, it will have created lock commits that mix the module file + `module-status.md` + mockups. Reverting the *command edit* does not un-make those commits — but that is expected (the commits are the intended work product, not the change-under-review), and each is independently git-revertable. No append-only log mutation, no external write.

### Dimension 5: Hidden Coupling
**Risk:** Low

- Edit 3 introduces a dependency: `/draft-module` now relies on the *shape* of `settings.json` (presence of an entry matching `Write(./brand-book/{id}.md)` in the `allow` array). This is an implicit dependency on an established repo convention — but it is now documented at two sites: `draft-module.md` Step 3 (lines 33-35) and the new project `CLAUDE.md` bullet (edit 2, line 21). The contract is named where it is relied upon, which keeps this at Low/Medium rather than High.
- The settings.json session-start cache behavior the reroute depends on is a Claude Code platform behavior, not a repo artifact that could silently change — and the reroute degrades gracefully (if the allow IS active, it uses Write; if absent, heredoc). Both paths produce identical file content (line 35: "final file content is identical either way").
- Edit 1's auto-commit stages `pipeline/module-status.md` at its current working-tree state. The edit explicitly surfaces this coupling rather than hiding it (`lock-module.md` line 64 concurrency note: a concurrent session's edit to a *different* row ships in this commit — "the same exposure the prior manual-commit posture carried"). Because the exposure is unchanged from the prior posture and is documented inline with the `/wrap-session` foreign-session guard named as backstop, this is not a *new* hidden coupling.
- No silent auto-firing in an unexpected context: `/lock-module` auto-commit fires only when the operator runs `/lock-module`, an explicit per-module action. No functional overlap with an existing commit mechanism (the prior posture was manual; this replaces it 1:1, it does not run alongside it).

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to the three edited files, `settings.json` lines 4-63, `shared-manifest.json` lines 3-5, grep caller enumeration within the project, and the three corresponding `logs/improvement-log.md` entries dated 2026-05-27/29 and 2026-06-01 that establish the change intent). No training-data fallback was used on fetch/read failures.
