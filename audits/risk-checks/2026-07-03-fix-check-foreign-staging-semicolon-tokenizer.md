# Risk Check — 2026-07-03

## Change

Fix a whitespace-tokenizer bug in .claude/hooks/check-foreign-staging.sh — change the footprint-parsing regex at line 301 from `re.split(r'[,\s]+', footprint_raw)` to `re.split(r'[,;\s]+', footprint_raw)` so the canonical semicolon-separated "- Files in scope:" mandate format (e.g. "path1; path2; path3", the format /session-start Step 3 and /prime Step 8c.7 both write) splits into clean tokens instead of tokens carrying a trailing semicolon that never string-matches a staged file path. Real-world incident (friction-log.md 2026-07-02 S3): 11 of 12 staged files were false-flagged as foreign in a legitimate commit; only the list's final entry (no trailing semicolon) matched. This is a single-line, additive-delimiter change — semicolon added alongside the existing comma/whitespace delimiters; no other logic in the file changes, no other regex touched, no new files created. A concurrent session (S2) is live in this same ai-resources checkout doing unrelated /friday-act work (git config, project settings.json, .claude/commands/prime.md, project/workspace CLAUDE.md) with zero file overlap with this change. This hook IS the concurrent-session staging-safety mechanism, so S2's own future git commits will run through the new version once this lands — the fix is strictly more permissive for well-formed semicolon-delimited input and identical for comma/whitespace-only input, so it should not introduce new false blocks.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists

## Verdict

GO

**Summary:** A one-line, additive-delimiter fix to a single, single-copy advisory hook — strictly more permissive for the documented semicolon format, safe-directional (removes false blocks, introduces no silent misses), fully git-revertible, and aligned with an existing documented convention; all six dimensions Low.

## Consumer Inventory

Search terms derived: `check-foreign-staging` / `check-foreign-staging.sh` (basename + component), `foreign-staging` / `staging-tripwire` (contract markers), `- Files in scope:` (the mandate bullet the tokenizer parses), `[,\s]` / `[,;\s]` (the tokenizer regex, checked for replication). Grepped across `ai-resources/` and the workspace root one level up.

Copies of the hook file itself: **exactly one** — `find` across the whole workspace returned only `ai-resources/.claude/hooks/check-foreign-staging.sh`. No project-local or workspace-root copies exist, so there is **no lockstep-sync burden** (unlike `detect-concurrent-session.sh` / `backup-session-plan.sh`, which have byte-identical project copies). Independently confirms the "prior search found only one copy" note in the task.

Wiring: the hook is registered at the **user level** — `~/.claude/settings.json` PreToolUse, `bash "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh"` — by **absolute path** to the single copy. It is NOT in `ai-resources/.claude/settings.json` (whose PreToolUse array holds only `check-heavy-tool.sh` and `friction-log-auto.sh`). Consequence: editing the one file changes behavior for every Claude Code session on this machine at once (this is why the incident fired in `projects/axcion-design-studio`, which has no hook copy of its own).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `~/.claude/settings.json` (user-level PreToolUse) | invokes (absolute-path wiring, machine-wide) | no |
| `ai-resources/docs/commit-discipline.md` (§ Foreign-staging tripwire, L21–23) | documents | no |
| `.claude/commands/wrap-session.md` (workspace-root, Step 7 per-id marker teardown, L413) | documents | no |
| `projects/axcion-website/pipeline/repo-snapshot.md` (L265 hook table) | documents | no |
| `ai-resources/.claude/commands/session-start.md` (Step 3 — writes the `- Files in scope:` semicolon format the hook parses) | co-edits (upstream format producer — already correct, no change) | no |
| `ai-resources/.claude/commands/prime.md` (Step 8c.7 — same format producer) | co-edits (upstream format producer — already correct, no change) | no |

Total: 6 consumers, 0 must-change. The two format-producer rows (session-start, prime) are the *upstream* of the contract the fix conforms to — the change moves the hook toward their already-correct output, so they do not change. The change target itself introduces no new contract, so it adds no new consumers.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded file — the change is entirely inside a shell/python hook body, not a CLAUDE.md, `@import`, skill description, or subagent brief. Verified: the only edited line is L301 of `check-foreign-staging.sh`.
- No new hook registered and no change to firing frequency. The hook already exists and already runs on `PreToolUse(Bash)`; the edit does not touch the gated-verb early-exit (L140–141) that keeps the expensive path off ordinary Bash calls. Runtime cost is one `re.split` call before and after — unchanged.
- The hook emits `additionalContext` only on the warn-open path and stderr only on block; the tokenizer change does not alter output shape, so no added token cost to any session's context.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is touched. Grep for `foreign-staging` across all `settings*.json` (repo, workspace, user) shows the hook's only registration is the pre-existing user-level wiring; this change does not edit it.
- No `allow`/`ask`/`deny` entry added, removed, or widened; no new Bash/Write/API pattern introduced; no scope escalation. The change is pure hook logic.

### Dimension 3: Blast Radius
**Risk:** Low

- Files changed directly: **1** (`check-foreign-staging.sh`, one line). Hook copies in the workspace: **1** (`find` confirmed) — zero lockstep copies to sync.
- Consumer inventory (above): **6 consumers, 0 must-change.** The three `documents` rows describe the hook's *purpose and contract* ("compares staged files against the footprint, blocks foreign whole files") — none of which the tokenizer change alters, so none must change. The `invokes` row is absolute-path wiring, unaffected by a file-internal edit.
- No contract change: exit codes (0 / 2), the block/warn stderr shape, the gated-verb set, the fail-open/P3 escalation, the exempt-list, and the `- Files in scope:` dependency are all untouched. Cross-checking the `parses` relationship — the hook is the parser; its consumers do not parse *it*.
- Machine-wide propagation is real (user-level absolute-path wiring → all sessions/projects pick up the new tokenizer on their next gated commit, including the live S2 session named in the change) but is the *intended* effect and is safe-directional (see Dimension 5 safety analysis: can only reduce false blocks). It does not force any consumer to change, so it does not elevate the level.
- No unanticipated consumer surfaced that the change description missed; the description's "single-line, additive, no new files, only one copy" framing matches the evidence.

### Dimension 4: Reversibility
**Risk:** Low

- Single-line edit to a git-tracked file — `git revert` (or a one-line re-edit) fully restores prior behavior with no residue.
- Hooks are read fresh from disk on every fire (no compilation/caching), so a revert takes effect on the very next hook invocation; no restart, no cached permission state, no operator muscle-memory to unwind.
- The change writes nothing to logs, data files, or external systems, and propagates no state beyond the local repo. Nothing to clean up beyond the one file.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change *removes* a hidden mismatch rather than adding coupling: the hook's tokenizer disagreed with the canonical `- Files in scope:` semicolon convention that `session-start.md` Step 3 (L280) and `prime.md` Step 8c.7 (L557) write, and that `session-marker.md` § Mandate-line bullet contract (L179–189) documents. Adding `;` aligns the parser to that documented format. No new contract is created.
- Safety analysis of the additive delimiter (grounded in the hook body): for semicolon input `"a.md; b.md; c.md"`, the old `[,\s]+` splits only on the space, yielding `a.md;`, `b.md;`, `c.md` — trailing semicolons that never match a staged path (exactly the incident: friction-log 2026-07-02 S3, "11 of 12 flagged; only the final no-semicolon entry matched"). The new `[,;\s]+` splits cleanly. For comma-only or whitespace-only input the two regexes are identical. The cleaned tokens are a strict subset-cleanup of the declared paths — they cannot spuriously match a *genuinely foreign* file, so no new false-negative (silent miss) is introduced; the guard's safety property (a file outside the declared footprint is still flagged) is preserved.
- No functional-overlap concern: `check-foreign-staging.sh` is the only hook handling foreign-staging on `PreToolUse(Bash)`; `detect-concurrent-session.sh` fires on the different `SessionStart` event. The two are documented as paired-not-duplicated (session-marker.md L213).
- Two residual notes, neither introduced or worsened by this change: (a) **pre-existing registration gap** — the hook is a de-facto consumer of the mandate `- Files in scope:` parse contract but is not listed among the 6 registered readers in `session-start.md` Step 3 (L288–294) nor in the `session-marker.md` two-end registry; a future delimiter change to the format could silently desync it. Worth registering, but out of scope for this one-line fix. (b) **theoretical edge** — a footprint token containing a literal `;` would now over-split into a non-matching token, a *new false-positive* (fail-safe: over-blocks, never under-detects); filenames with semicolons are effectively nonexistent, so negligible.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present).

- **OP-5 (advisory vs enforcement):** the hook is an advisory tripwire (exit 2 feeds the foreign list back to the agent, per the hook header L14–18, explicitly citing OP-5). The change keeps it advisory and makes it *less* aggressive (fewer false blocks) — no drift toward enforcement. Aligned.
- **OP-12 (closure before detection):** the change adds no new detection; it repairs an existing detector's false-positive. Closure/repair counts *for* the change, not against. Aligned.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction):** driven by a *confirmed* incident (friction-log 2026-07-02 S3, evidence-backed) and matching a *documented, in-use* format (semicolon separators the writers actually emit) — a confirmed consumer/format, not a hypothetical. No speculation. Aligned.
- **OP-10 (system boundary):** no cross-tool reach. N/A.
- **OP-11 (loud revision):** no principle is being revised; nothing to make loud. N/A.
- **DR-1 / DR-3 (placement):** edits an existing file in its canonical home (`ai-resources/.claude/hooks/`). Aligned.
- **DR-8 (risk-check gate on hook changes):** this change is being risk-checked, satisfying the gate. Aligned.

The change actively serves the operating principles (repairs an advisory guard's false-positive on confirmed evidence); no principle is touched adversely.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the hook body (`check-foreign-staging.sh` L301 tokenizer, L140–141 early exit, L14–18 advisory contract, L246 footprint read); the confirmed incident (`friction-log.md` 2026-07-02 S3); the format-producer sites (`session-start.md` L280/L288–294, `prime.md` L557/L565); the wiring (`~/.claude/settings.json` user-level absolute-path registration; `ai-resources/.claude/settings.json` PreToolUse array); `find`/grep counts establishing a single hook copy and zero replicated tokenizers; and principle IDs from `principles-base.md`. No training-data fallback was used on any read.
