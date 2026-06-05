# Risk Check — 2026-06-05

## Change

Add a clobber-safe own-marker recovery block to the NO_OWN_MARKER branch of wrap-session.md Step 3.5 (both paired copies: ai-resources/.claude/commands/wrap-session.md + workspace-root /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md). Logic: when MARKER is still empty AND NO_OWN_MARKER=1, read the shared logs/.session-marker; if it is dated today/yesterday and points to SX, scan all logs/.session-marker-* per-id files — if NONE claims that "{DATE} SX" AND a matching "## DATE — Session SX" header exists in logs/session-notes.md, recover MARKER/MARKER_DATE (routing into the existing marker-aware counting path that already exists at the `if [ -n "${MARKER}" ]` branch); otherwise fall through to the existing conservative zero-own-contribution claim (NO_OWN_MARKER=1 → OWN_*_SUBTRACT=0). Purpose: stop a partial-marker-setup session (one that wrote the shared logs/.session-marker but not its per-id logs/.session-marker-${CLAUDE_CODE_SESSION_ID} file) from being false-flagged FOREIGN at wrap, WITHOUT weakening the clobber-false-negative protection NO_OWN_MARKER provides. Secondary edits: one-line reader-side note in docs/session-marker.md (next to the existing both-or-neither writer invariant), and flip logs/improvement-log.md L300 entry from PARTIAL to applied. Plan: logs/session-plan-2026-06-05-S9.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-06-05-S9.md — exists

## Verdict

GO

**Summary:** A narrow, internally-contained safety-guard correction that fixes a known false-positive (own header mis-flagged FOREIGN) using a disambiguator that is provably safe under an already-BLOCKING writer invariant; all six dimensions are Low, with the sole non-trivial signal (paired-copy drift) covered by the plan's own byte-identity check.

## Consumer Inventory

The change targets the Step 3.5 attribution logic (`NO_OWN_MARKER`, the `MARKER`/`MARKER_DATE` resolution, the `.session-marker` / per-id marker files) and the `FOREIGN` / `FOREIGN_CLASS` pre-write guard it feeds. Search terms: `NO_OWN_MARKER`, `session-marker`, `FOREIGN_CLASS`/`FOREIGN=`, plus the two `wrap-session.md` basenames. Greps run across `ai-resources/` and the workspace root.

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md | co-edits | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md | co-edits | yes |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md | documents | yes (one-line reader-side note, in scope) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md | documents | yes (status flip, in scope) |
| 16 project/checkout symlinks → canonical `ai-resources/.claude/commands/wrap-session.md` (e.g. `projects/strategic-os/...`, `harness/...`, `knowledge-bases/pe-kb-vault/...`) | imports | no (inherit edit via symlink — no separate write) |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow/.claude/commands/wrap-session.md | (variant) | no (real file, but `grep -c NO_OWN_MARKER` = 0 — guard absent, untouched) |
| ai-resources/.claude/commands/{prime,session-start,session-plan}.md | parses (write `.session-marker` shared + per-id under the both-or-neither invariant) | no (writers; change reads their output, contract unchanged) |
| ai-resources/.claude/commands/{contract-check,drift-check,open-items,decide}.md; .claude/agents/fix-repo-issues-scanner.md | parses (read-only marker consumers, glob-based) | no (do not touch NO_OWN_MARKER or the FOREIGN gate) |
| ai-resources/.claude/hooks/{backup-session-plan.sh,detect-concurrent-session.sh} (+ project-local copies) | parses (read `.session-marker` for naming / enrichment) | no (read shared marker only; do not consume the recovered MARKER or FOREIGN) |

**Total: 4 must-change consumers (all in scope), ~26 non-must-change marker-ecosystem consumers, 16 symlinks inheriting the edit.** The downstream consumer of the guard's output — the `FOREIGN ≥ 1` STOP gate that decides whether `/wrap-session` stages `logs/session-notes.md` — is **internal to `wrap-session.md` itself** (canonical L234, paired-copy L183+), not an external caller. No consumer outside the two edited copies reads `NO_OWN_MARKER`, `OWN_*_SUBTRACT`, or `FOREIGN` as a contract. The inventory surfaced no consumer the CHANGE_DESCRIPTION did not already anticipate (the blast-radius note named all of them).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edit adds shell logic to a slash-command body (`wrap-session.md`), not to an always-loaded CLAUDE.md or an `@import` chain — pay-as-used, runs only when `/wrap-session` is invoked. Evidence: target is `.claude/commands/wrap-session.md` Step 3.5, a per-invocation command path, not a SessionStart/PreToolUse hook.
- No new hook registered: the change is confined to existing command files and two doc/log edits (`docs/session-marker.md` one-line note, `improvement-log.md` status flip). Grep for new hook wiring: none introduced; `detect-concurrent-session.sh` / `backup-session-plan.sh` are untouched.
- Runtime cost of the recovery block is a one-shot `cat` of the shared marker + a glob scan of `logs/.session-marker-*` + one `grep` of `session-notes.md`, executed only on the `NO_OWN_MARKER=1` path of a single wrap — negligible.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` / `settings.local.json` edit in scope; no `allow`/`ask`/`deny` entry added or removed. The change touches command bodies, one doc, one log. Referenced-file list contains no settings file.
- The new shell uses already-authorized read primitives (`cat`, `grep`, `awk`, glob over `logs/`) identical in family to the existing Step 3.5 code (L91–L145). No new tool family, no shell capability widening, no cross-repo or external write.

### Dimension 3: Blast Radius
**Risk:** Low

- Grounded in the Consumer Inventory: **2 real files must change** (the paired `wrap-session.md` copies), plus 2 in-scope documentation edits (`session-marker.md`, `improvement-log.md`). All 4 are already named in the change.
- 16 `wrap-session.md` entries are **symlinks** to the canonical copy (verified: `find … -L` test returned SYMLINK for all 16 project/checkout copies) — they inherit the edit with no separate write, so they are not additional must-change surfaces.
- The 1 divergent real file (`ai-resources/workflows/research-workflow/.claude/commands/wrap-session.md`) **does not contain the guard** (`grep -c NO_OWN_MARKER` = 0) and is correctly untouched — confirmed, not assumed.
- **Contract impact:** the change does NOT alter any externally-observed contract. It only *adds a new pre-condition under which `MARKER` becomes non-empty*, routing into the **pre-existing** marker-aware counting path (canonical L122 / paired L93). The output schema (`OWN_*_SUBTRACT`, `FOREIGN`, `FOREIGN_CLASS`, the `GUARD:` trace line) is unchanged. The only consumer of `FOREIGN` is the same file's own STOP gate (canonical L234) — no cross-file parser depends on the changed branch.
- No shared infrastructure (logs schema, hook output shape, marker file format) is modified — the change *reads* `.session-marker` and per-id files but writes none of them.

### Dimension 4: Reversibility
**Risk:** Low

- The functional change is two command-file edits plus one one-line doc note — a single `git revert` of the landing commit fully restores prior Step 3.5 behavior. No sibling files or directories are created.
- The `improvement-log.md` status flip (PARTIAL → applied at L300) is an in-place edit, not an append; `git revert` restores it cleanly with no stale orphan entry (unlike append-only log mutations). The entry already exists; only its Status word changes.
- No state propagates beyond git: the change writes no marker files, fires no automation between landing and a potential revert, and pushes nothing external. Per CLAUDE.md push discipline, the commit is batched and unpushed until wrap, so even pre-push the rollback is purely local.
- The plan carries an explicit **Stop-if** (S9 plan § Risk: "dry-run shows any false-negative → revert to conservative claim-zero"), so the revert path is pre-specified.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change's correctness **depends on** the both-or-neither writer invariant — but that dependency is explicit and documented, not hidden: `docs/session-marker.md` § "Both-or-neither writer invariant (BLOCKING)" (L39–47) states any marker-setup path writes shared + per-id together, and the change adds a reader-side note next to it (in scope). The invariant is the named premise that makes the per-id-claim cross-scan safe (foreign clobber leaves a per-id file claiming SX → recovery suppressed; own partial-setup leaves none → recovery proceeds).
- One residual coupling is acknowledged in the design, not silent: two *non-compliant* partial-setup sessions both claiming the same SX (a double invariant-violation) would defeat the cross-scan. The CHANGE_DESCRIPTION and S9 plan § Findings both state this explicitly and argue it is strictly narrower than the status-quo false-positive surface — a documented, bounded residual, which keeps this Low rather than Medium.
- No silent auto-firing: the recovery runs only inside `/wrap-session` Step 3.5 on the `NO_OWN_MARKER=1 && MARKER empty` path, gated by an existing-header existence grep — it cannot fire in an unexpected context.
- No functional overlap with another mechanism: this is the only own-contribution attribution path; `detect-concurrent-session.sh` (proactive) and `session-start.md` Step 0.5 (`.prime-mtime`) operate on different signals/timings (per `session-marker.md` L180–192) and are not touched.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`, As-of 2026-06-01); IDs cited from it directly.
- **OP-12 (closure before detection):** the change *closes* a known finding rather than adding new detection — it corrects the existing FOREIGN guard's false-positive on partial-marker-setup sessions (improvement-log L292–299, Status PARTIAL → applied). It ships a fix to an already-working closure channel, not a new flag with no closure. Aligns with OP-12.
- **OP-9 / DR-7 / AP-7 (no speculative abstraction):** the change is licensed by *confirmed* consumers — the S6 and S8 near-misses (real observed events, `session-marker.md` L45, S9 plan § Findings), not a hypothetical future. It adds no hook, no generalization, no Phase-2 scaffolding. No speculative-abstraction signal.
- **OP-5 (advisory vs enforcement):** the guard remains advisory-and-stop — on `FOREIGN ≥ 1` it STOPs and surfaces to the operator (canonical L234, L245). The change does not move it toward auto-correction; it makes the *advisory* attribution more accurate. No silent enforcement upgrade.
- **DR-8:** this very risk-check satisfies the gated-class requirement (paired safety-guard edit), and the S9 plan invokes it at plan-time (§ Execution Sequence step 7). Compliant.
- **DR-1 / DR-3 (placement):** edits stay in the canonical `ai-resources/` command + its workspace-root paired copy and canonical docs/logs — correct tier and home. No misplacement.
- No principle is revised or relaxed; nothing requires an OP-11 loud-revision call. The change actively serves OP-12 and stays inside OP-5/OP-9. Low.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to both `wrap-session.md` copies, `session-marker.md`, `improvement-log.md` L292–300, and the S9 plan; grep counts for the consumer inventory and the symlink-vs-real classification; principle IDs cited from the readable principles-base.md). No training-data fallback was used; no fetch/read failures occurred.
