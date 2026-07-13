# Risk Check — 2026-07-13

## Change

END-TIME gate on the executed 3-item fix plan (`audits/fix-plans/fix-repo-issues-2026-07-13-2134.md`), already applied to the working tree, not yet committed.

CHANGE 1 (id-55) — `/lean-repo` Q3 orphan lens, command + agent. APPLIED:
- Part A: Q3 now scans `projects/*/logs/` and `projects/*/CLAUDE.md` in addition to `ai-resources/` (where the wiring lives but the usage does not).
- Part B: the verdict `zero live callers = orphan → Remove` is GONE. Q3 now emits `no evidence of use in scanned scope → CONFIRM BEFORE DELETE`; a Q3 finding is structurally barred from the `Remove` disposition and must be routed to `Investigate`; the report must state its scanned scope; and the agent must run a planted known-positive check (`/explore-section`) and declare `Q3 VOID` (withholding ALL orphan findings) if the instrument fails it.
- Validation performed: old lens returned 0 hits for `/explore-section`; corrected lens returns 109 hits across 17 files.

CHANGE 2 (id-53) — `check-foreign-staging.sh` allowlist. APPLIED, but NOT as the fix plan/plan-time mitigation specified. Instead of adding `"logs/runs/"` to the blanket-prefix `EXEMPT_DIR_PREFIXES` list, a narrower clause was added inside the existing `logs/` branch of `is_exempt()`, matching the file's `session-plan-*.md` precedent: `if path.startswith("logs/runs/") and re.match(r'\d{4}-\d{2}-\d{2}-S\d+\.json$', base): return True`.

CHANGE 3 (hygiene, no runtime surface). Four stale records flipped to live state in `logs/friction-log.md` and `logs/improvement-log.md`, plus an INVESTIGATE-section update-note in `audits/lean-repo-2026-07-13.md`, plus `/route-change` → `/placement` in `projects/axcion-ai-system-owner/references/toolkit-relationship.md` (a separate git repo).

CHANGE 4 (`.gitignore`). Added `.codex/`, `.agents/`, `AGENTS.md` — a ~60-file Codex CLI harness mirror that appeared untracked and was not gitignored. Operator decision: treat as an unadopted experiment; do not fix its copy of the Q3 lens.

CHANGE 5 (new log entries, no runtime surface). Two new `improvement-log.md` OPEN entries: a session-marker allocator collision across git worktrees (uncommitted in-flight allocations invisible to the existing union-scan fix), and a false-premise correction on parked item id-46 (design-studio's commands directory is a symlink, not 89 copies).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/lean-repo-auditor.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/lean-repo.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/lean-repo-2026-07-13.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-ai-system-owner/references/toolkit-relationship.md — exists
- (also read for grounding) /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-13-lean-repo-orphan-lens-and-foreign-staging-allowlist.md — the prior plan-time gate — exists
- (also read) /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/run-manifest.sh — exists
- (also read) /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.codex/agents/lean-repo-auditor.toml — exists (not a target of this change; read to assess the deferred mitigation)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Both structural edits are correctly, and in the hook's case more safely, applied than either the fix plan or the plan-time mitigation specified, and all four hygiene claims verify against live filesystem/git state; the residual risk is a deliberately un-fixed, but loudly-documented and now-gitignored, stale copy of the dangerous pre-fix Q3 lens sitting in an unadopted Codex mirror.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/lean-repo.md` | edit target (Part A + B) | yes — done |
| `.claude/agents/lean-repo-auditor.md` | edit target (Part A + B) | yes — done |
| `.claude/hooks/check-foreign-staging.sh` | edit target (Change 2) | yes — done (narrower than specified) |
| `.codex/agents/lean-repo-auditor.toml` | co-edits (byte-identical-at-defect-time Q3 text mirror; carries the pre-fix `zero live callers = orphan` verdict verbatim, confirmed by direct read) | yes — **not done, deliberate operator scope decision, now gitignored** |
| `.codex/hooks/check-foreign-staging.sh` | co-edits (mirror; confirmed inert — not registered in `.codex/hooks.json`) | recommended, not done — low urgency, inert today |
| `projects/axcion-design-studio/.claude/commands/lean-repo*.md` | invokes (directory symlink, inode-identical to canonical, confirmed via `stat`) | no — auto-inherits the fix, zero additional edits needed |
| `ai-resources-research-workflow` worktree (`.claude/{commands,agents,hooks}/…`) | co-edits (live concurrent worktree, branch `session/2026-07-13-research-workflow`, unwrapped, confirmed via `git worktree list`) | no — different checkout; shares the same physical `~/.claude/settings.json`-registered hook file only at commit time |
| `~/.claude/settings.json` (user level) | invokes — sole live PreToolUse(Bash) registration for the hook | no — registration unchanged; runtime reach is global (every repo on this machine) |
| `logs/scripts/run-manifest.sh` | implicit dependency (the new clause's safety rests on this script always writing flat `{date}-S{N}.json` into `logs/runs/`, confirmed by direct read — no subdirectories) | no |
| `projects/axcion-ai-system-owner` (separate git repo) | co-edits (`toolkit-relationship.md` rename fix; confirmed `/route-change` does not exist, `/placement` does) | no — isolated, correct |
| `logs/improvement-log.md`, `logs/friction-log.md`, `audits/lean-repo-2026-07-13.md` | documents (hygiene flips, each independently verified against live filesystem/git, not trusted from the log's own prior claims) | no — companion actions |
| downstream project copies of `/lean-repo` | none | n/a — `lean-repo` remains in `auto-sync-shared.sh`'s `EXCLUDE_COMMANDS`; no symlinked project copies exist outside the design-studio directory-symlink case above |

**Total: 11 distinct consumer rows, 4 must-change; 3 of 4 done.** The one open must-change consumer (`.codex/agents/lean-repo-auditor.toml`) is a deliberate, named, gitignored exception, not a silent gap — carried into Dimensions 3 and 5 below.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change 1 edits existing on-demand command/agent prompt text; no new always-loaded CLAUDE.md content, no new hook registration, no new subagent, no new skill-trigger pattern.
- Change 2 adds ~13 lines to an existing per-commit-gated code path inside `is_exempt()` (`check-foreign-staging.sh:384-396`); the gated-verb early exit (`:140-141`) means this only runs on `git commit`/`git add -A` style invocations, not per tool call — confirmed unchanged by diff.
- The `.gitignore` and log-hygiene edits carry zero runtime cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` touched, no `allow`/`ask`/`deny` change, no new tool capability granted.
- Change 2 is narrower than the plan-time-recommended fix: it does **not** touch the blanket-prefix `EXEMPT_DIR_PREFIXES` list (confirmed by diff — that list is byte-identical, still exactly `("audits/risk-checks/", "audits/working/")`). It adds a filename-shape-gated clause inside the `logs/` branch instead, which is a strictly narrower widening of the tripwire's exempt surface than either the fix plan's literal `logs/runs/*.json` (which would have silently done nothing) or the plan-time-recommended `"logs/runs/"` prefix (which would have exempted any file under `logs/runs/`).

### Dimension 3: Blast Radius
**Risk:** Medium

- Grounded in the Step 1.5 inventory: 11 consumer rows, 4 must-change, 3 done. The one open item, `.codex/agents/lean-repo-auditor.toml`, was confirmed by direct read to still carry the exact pre-fix verdict text: *"Grep for the invocation path… zero live callers = orphan. This is the '/tech-consult orphan' failure mode"* — the precise defect this session exists to close, unmodified.
- Contained by: `.codex/`, `.agents/`, `AGENTS.md` are now gitignored (confirmed via `git status --porcelain --ignored`), so this stale copy cannot be accidentally committed or propagated to another checkout via git. `.codex/hooks.json` does not register `check-foreign-staging.sh` (confirmed by direct read of the hooks-directory file list) — that particular mirror is inert. The agent `.toml` mirror is not confirmed inert in the same way — Codex CLI's own command surface (a full `config.toml` + `agents/*.toml` + `hooks.json` set, ~28+ agent files) appears structured to be directly runnable if the operator launches Codex CLI, which is how this mirror came to exist on disk in the first place.
- Not expanded: design-studio's 89-command surface auto-inherits the canonical fix via directory symlink (verified: `stat` shows identical inode for `ai-resources/.claude/commands/lean-repo.md` and the design-studio path) — zero additional edits were needed there, and none were made.
- The hook's runtime reach remains global (registered once, user-level, per the plan-time gate's finding, unchanged this session) — the content delta itself stays small and additive.

### Dimension 4: Reversibility
**Risk:** Low

- All structural edits (command, agent, hook, `.gitignore`) are plain-text edits to git-tracked files; `git revert` on any of them fully restores prior behavior.
- The log-hygiene edits (`improvement-log.md`, `friction-log.md`, `lean-repo-2026-07-13.md`) are corrective annotations (strikethrough + superseding note), not silent overwrites — a revert restores the prior (now-known-wrong) text, which is a clean, low-cost degrade, not a lost-update.
- No `git push`, no cross-repo write beyond the separate, already-isolated `axcion-ai-system-owner` repo edit (itself a 2-line, trivially revertible rename fix).
- Non-blocking note carried from plan-time and still open: the plan-time gate recommended landing the log-hygiene follow-ups as a separate commit from the structural command/agent/hook edit, so a revert of one does not also revert the other. Not yet confirmed whether this session will honor that at commit time — flag it as a live-at-commit-time consideration, not a blocking finding.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Resolved from plan-time:** the undocumented dependency on `run-manifest.sh`'s naming convention is now documented at the change site — the new clause in `check-foreign-staging.sh:384-393` carries an explicit code comment naming the dependency and the incident it fixes. Confirmed by diff.
- **Avoided from plan-time:** the "two matching engines in one file" risk (literal `startswith` vs. `fnmatch` glob) does not materialize, because the shipped fix never touches `EXEMPT_DIR_PREFIXES` (the literal-match list) at all — it adds a regex-gated clause in a different code path. This sidesteps the exact confusion the plan-time gate flagged.
- **Verified safe, narrow match:** empirically re-derived the new predicate — `path.startswith("logs/runs/") and re.match(r'\d{4}-\d{2}-\d{2}-S\d+\.json$', os.path.basename(path))`. `re.match` anchors at position 0 and the pattern's trailing `$` anchors at end-of-string, so the basename must be *exactly* `YYYY-MM-DD-S{N}.json` — no prefix/suffix slack. Confirmed the file still parses (`bash -n` + isolated `compile()` of the embedded Python both pass on the post-edit file).
- **One residual, narrow edge case, not currently exploitable:** the clause checks `path.startswith("logs/runs/")` and the *basename*, not that the file is a direct, one-level child of `logs/runs/`. A path like `logs/runs/sub/2026-07-13-S12.json` would also satisfy the exemption, since `os.path.basename()` strips all leading directories. `run-manifest.sh` (confirmed by direct read) only ever writes flat files directly into `logs/runs/`, so no legitimate producer creates this shape — but a foreign session (or hand-crafted path) that happened to land a file at a nested nonstandard location with a date-shaped basename would slip through. Low-severity because it requires a specifically-shaped foreign path, not a generic one; worth a one-line tightening (`path.count("/") == 2`) but not blocking.
- **Persists, now acknowledged rather than silent:** the Codex-mirror drift (`.codex/agents/lean-repo-auditor.toml` carrying the disproven Q3 lens) is a real instance of "two files carry the same contract with no shared source of truth" — the operator's choice to leave it, gitignore it, and record the rationale inline in `.gitignore` converts this from silent drift into a named, bounded exception (see Dimension 6).
- **Live concurrent-worktree exposure (transient, now closed):** `git worktree list` confirms the `ai-resources-research-workflow` worktree (branch `session/2026-07-13-research-workflow`) is still live and shares the single user-level-registered hook file. The edit window risk the plan-time gate flagged (a malformed intermediate state failing the tripwire open for both sessions) is closed — the file parses cleanly post-edit, verified directly, not inferred.

### Dimension 6: Principle Alignment
**Risk:** Low

- **OP-5 (advisory vs. enforcement).** Part B of Change 1 keeps moving verdict language toward advisory framing (`no evidence of use in scanned scope → CONFIRM BEFORE DELETE`), consistent with the plan-time finding. Direct answer to the operator's question on enforceability: the Q3 contract (scanned-scope statement, known-positive check, `Q3 VOID` fallback, ban on `Remove` disposition) is **prompt-level discipline, not a code-level gate** — `lean-repo.md` Step 3 only checks for the presence of a `NOTES:` last line before re-invoking once; nothing in the command mechanically greps the agent's output for a stray `Remove` disposition sourced from a Q3 finding, or for the two required opening lines. This matches the existing architecture (every other rule in this file is instruction-following, not code-enforced) and is consistent with OP-5's advisory-not-enforcement posture — but it means the safety of the fix rests on the subagent honoring its own contract each run, same as before the fix, just with a much more explicit and repeatedly-restated contract (including the named 2026-07-13 incident and the line "This rule has a body count").
- **OP-12 (closure before detection).** No new detection is added; both changes repair existing detection/gating machinery (a false-positive-prone orphan scan; a contract mismatch between an instruction and a guard). Consistent.
- **OP-9 / AP-7 / DR-7 (speculative abstraction).** The narrower, idiom-matched hook clause is a smaller, more targeted addition than either the fix plan's literal string or the plan-time-recommended prefix — it is not new infrastructure, and it's grounded in a named, dated incident. No new component created.
- **OP-11 (loud revision, never silent drift) — applied to the deviation from a required plan-time mitigation.** Two required plan-time mitigations were not executed as specified: (1) the hook fix used a narrower, safer mechanism than the literal `"logs/runs/"` prefix recommended, and (2) `.codex/agents/lean-repo-auditor.toml` was not patched. Both deviations are **loudly recorded** — (1) in a code comment at the change site plus an `improvement-log.md` entry explaining exactly why the narrower form was chosen over the recommended one; (2) in the `.gitignore` comment block itself, in `CHANGE_DESCRIPTION`, and now in this report. Per the Dimension-6 special-handling rule, a loudly-acknowledged deviation from a plan-time recommendation is not scored as a violation — it is exactly the OP-11 pattern this rule exists to permit. Scored Low, not Medium/High, on that basis.
- **DR-1 / DR-3 (placement).** No placement issues — all edits land in their existing, correct homes.

## Answers to the operator's specific checks

1. **The hook — cannot over-match, cannot fail the guard open.** Confirmed: `EXEMPT_DIR_PREFIXES` is untouched (still 2 entries, still a `startswith` literal match); the new clause is a separate, narrower, regex-anchored check gated by both a directory prefix AND an exact-basename-shape match. Both bash and the embedded Python parse cleanly post-edit. The one residual gap is the nested-subdirectory edge case noted in Dimension 5 — narrow, requires a specifically-shaped foreign path, not a hole your blanket-prefix recommendation would have avoided (the blanket prefix would have been strictly *more* permissive, not less).
2. **The Q3 lens — deletion authority is genuinely gone from the prose contract, not from a code gate.** No path in the command or agent text now permits a Q3 finding to reach `Remove` — confirmed by reading both files' Step 3/guardrails sections (`lean-repo-auditor.md`: *"A Q3 finding may never be dispositioned Remove"*; `lean-repo.md`: *"Q3 never carries deletion authority"*). The known-positive check is enforceable only in the sense that a competent, contract-following agent will run it — there is no mechanical validator in `lean-repo.md` that checks the agent's returned Q3 section for the two required opening lines or scans for a stray `Remove` before writing the final report. This is consistent with, not a regression from, the existing all-prompt-based architecture of this subagent.
3. **Command/agent coherence — confirmed matching, no contradiction.** Both files carry the same scan-scope grep commands, the same verdict string verbatim, the same known-positive command (`/explore-section`), and the same `Q3 VOID` fallback language. `lean-repo.md`'s Step 4 output template's Q3 section header/lines are copied near-verbatim from the agent's required output shape.
4. **Plan-time mitigations — 2 of 4 honored as specified, 2 honored in substance via a different, safer mechanism, 1 explicitly declined by operator call.** The "add code comment naming the run-manifest.sh dependency" mitigation is done verbatim. The "use the literal `logs/runs/`" mitigation was not followed literally — a narrower, better mechanism was substituted, and the substitution is itself an improvement on the recommendation (see Dimension 2/5). The "add `.codex/agents/lean-repo-auditor.toml` to id-55's targets" mitigation was explicitly declined — see Dimension 3/6 for the resulting residual risk and why it is scored Medium, not High. Judgment on leaving the defective lens in an ignored, unmaintained mirror: **acceptable, conditionally** — it is gitignored (no propagation risk via git) and the deviation is loudly recorded, satisfying OP-11, but it is not risk-free (a still-directly-invocable Codex CLI surface exists on this machine today) — see Mitigations below for the low-cost close.

## Mitigations

- **(Dimension 3/5 — Codex-mirror gap, required)** Since the operator has ruled out patching the mirror's Q3 logic, add a one-line, loud, top-of-file warning inside `.codex/agents/lean-repo-auditor.toml` itself (not just the `.gitignore` comment, which the operator will not see when directly working inside Codex CLI): e.g. `# STALE — Q3 orphan lens NOT patched for the 2026-07-13 false-deletion-authority fix (see ai-resources/logs/improvement-log.md). Do NOT trust "orphan → Remove" verdicts from this file.` This is a single-line, near-zero-cost edit that closes the actual exposure path (a direct Codex CLI invocation) without adopting or maintaining the mirror.
- **(Dimension 5 — nested-path edge case, recommended, non-blocking)** Tighten the new `check-foreign-staging.sh` clause to require the file be a direct child of `logs/runs/` (e.g. `"/" not in path[len("logs/runs/"):]` or equivalent), closing the narrow nested-subdirectory gap noted above.
- **(Dimension 4 — commit sequencing, recommended, non-blocking, carried from plan-time)** Land the structural edits (command/agent/hook/`.gitignore`) and the log-hygiene corrections as separate commits, so a revert of one does not also revert the other.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file reads, `git diff`/`git status --ignored`/`git worktree list` output, `stat` inode comparisons, `find` existence checks, a live `bash -n` + Python `compile()` parse test of the edited hook, and direct reads of `.codex/agents/lean-repo-auditor.toml` and `logs/scripts/run-manifest.sh`. No claim in `CHANGE_DESCRIPTION` was accepted on trust — every factual assertion (hygiene flips, symlink/inode identity, gitignore effectiveness, hook parse-validity, Codex-mirror staleness) was independently re-verified against live filesystem/git state. No training-data fallback was used on fetch/read failures.
