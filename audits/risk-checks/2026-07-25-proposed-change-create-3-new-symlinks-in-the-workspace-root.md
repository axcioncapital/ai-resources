# Risk Check — 2026-07-25

## Change

Proposed change: create 3 new symlinks in the workspace-root `.claude/commands/` directory, pointing at canonical files in `ai-resources/.claude/commands/`, using the exact relative form the existing root commands use (`../../ai-resources/.claude/commands/<name>.md`). The three: session-start.md, session-plan.md, concurrent-session-check.md.

Verified facts, each with its instrument and a note that the instrument's search scope covers the claim's scope:
- Root command count 63, canonical count 90, `comm -23` missing-set exactly 33. Instrument: `ls` over each `.claude/commands/` directory + `comm`. Scope: both command directories in full (repo-scoped, and the claim is about exactly those two directories).
- All 3 proposed link names are currently ABSENT at root. Instrument: `test -e` on each of the 3 exact paths. Scope: exact paths, so no false negative is possible. Nothing would be shadowed or overwritten.
- All 3 canonical targets EXIST. Instrument: `test -e` on each exact path.
- The existing root commands are symlinks of identical relative form. Instrument: `ls -la` on the root command dir (pattern `../../ai-resources/.claude/commands/<name>.md`). Scope: the directory being modified.
- Root `prime.md` is itself a symlink to the canonical `prime.md`, and the canonical file references `session-start`/`session-plan` 40 times. Instrument: `ls -la` + `command grep -c`. Scope: the one file that drives the broken flow.
- The workspace root IS a live session folder: root `logs/session-notes.md` carries 19 `## ` session headers, most recent 2026-07-20. Instrument: `command grep -c "^## "` on that file. Scope: the root repo's own session log.

Problem being fixed (mission `repo-integrity-repairs-2026-07` thread 11): a workspace-root session that runs `/prime` and picks a task is instructed by the (symlinked, canonical) prime.md to invoke `/session-start` and `/session-plan`, neither of which exists at root. The documented flow fails silently.

Deliberately NOT doing: symlinking the other 30 missing commands. Several are project-scoped by design (`explore-section.md` is Axcion Design Studio-local; `pm.md`, `archive-project.md`, `scope-project.md`, `project-next-steps.md` are project-flow commands). Whether those belong at root is a separate design question, deliberately out of scope.

Reversibility: `rm` each symlink; no file content is created or modified. Blast radius: workspace-root sessions only; additive (three names that currently resolve to nothing begin resolving). No hook, no permission, no settings, no always-loaded content, no automation with shared-state effects.

This is a plan-time gate. Session S2-1d2; plan at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-07-25-S2-1d2.md`

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/session-start.md — not yet present (to be created)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/session-plan.md — not yet present (to be created)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/concurrent-session-check.md — not yet present (to be created)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists (link target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists (link target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/concurrent-session-check.md — exists (link target)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/prime.md — exists (symlink to canonical; the file whose instructions currently break)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-integrity-repairs-2026-07.md — exists (thread 11 is the source)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is a correctly-verified, low-risk, additive fix to a real and currently-active defect, but it introduces one undocumented dependency — a `context-discovery` agent gap — that must be closed or explicitly tested before the fix can be trusted to work end-to-end.

## Consumer Inventory

Search terms derived: `session-start.md`, `session-plan.md`, `concurrent-session-check.md` (basenames / component names), plus the contract markers these files carry (`subagent_type: context-discovery`, `- Files in scope:` mandate bullet, `logs/.session-marker-*`, `logs/session-plan-${TODAY}-${MARKER}.md`). Searched via `command grep -rniI --exclude-dir=.git` across `ai-resources/` and the workspace root (the ambient `grep` here is confirmed blind on dot-rooted walks — `logs/scripts/search-canary.sh` returned `blind` — so every search below used `command grep` with explicit/named paths, never a bare dot-rooted `grep -r . .`).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` (root symlink already live) | invokes (`/session-start`, `/session-plan` unconditionally at Step 8a/8b; `/concurrent-session-check` conditionally at Step 6, line 320, when `LIVE_FOREIGN_HERE>=1`) | no — already correct; the fix satisfies an existing, currently-broken expectation |
| `ai-resources/.claude/commands/wrap-session.md` (root real file, "PAIRED CONTRACT" with canonical) | parses (`- Files in scope:` bullet `/session-start` writes; matches `logs/session-plan-*{MARKER}.md` glob) | no — already written assuming these commands' output shape exists |
| `ai-resources/.claude/agents/context-discovery.md` | invokes — is the **callee** of `session-start.md` Step 2.4 (line 217, `subagent_type: context-discovery`) and `concurrent-session-check.md` Mode 1 (line 101) | **yes** — absent from root's `.claude/agents/`; see Dimension 5 |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | co-edits / companion mechanism (prunes stale `logs/.session-marker-*`; `concurrent-session-check.md` reads the same markers) | no — absence degrades to a known "stale marker" blind spot, does not break the command |
| `ai-resources/docs/session-marker.md` | documents (marker resolution, asymmetric contract, UNKNOWN-SCOPE gate) | no |
| `ai-resources/docs/parallel-sessions-playbook.md` | documents (`/concurrent-session-check` usage pattern) | no |
| `ai-resources/docs/commit-discipline.md` | documents (PreToolUse footprint-read hook, not installed at root either — pre-existing, out of scope) | no |
| `ai-resources/logs/missions/repo-integrity-repairs-2026-07.md` (thread 11) | documents (the defect this change fixes) | yes (process step — thread should be closed with citation once the fix lands, per the mission's own validation contract) |

Total: **8 consumers found, 2 must-change** (`context-discovery.md` — technical; the mission-thread closure — process housekeeping). Not an isolated change, but a narrow and well-bounded one: every consumer above was either already compatible or is a documentation/process update, except the one genuine technical gap flagged in Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file is touched — `.claude/commands/*.md` are pay-as-used slash commands, not `@import`-ed or auto-loaded.
- No hook is added or modified. Root's `SessionStart` hook is unchanged (confirmed by reading `.claude/settings.json`: only `check-archive.sh` is wired there).
- `/prime` itself is operator-invoked, not auto-fired at session start at root — the new commands only run when explicitly invoked or chained from `/prime`.

### Dimension 2: Permissions Surface
**Risk:** Low

- Root `.claude/settings.json` already carries `"Write(**/.claude/**)"` and `"Edit(**/.claude/**)"` in `allow`, plus `defaultMode: bypassPermissions` — creating 3 more symlinks under `.claude/commands/` is inside an already-established, already-exercised pattern (60 existing symlinks of the identical relative form).
- No new tool family, no new deny-rule removal, no scope change (still project-level, still `.claude/commands/`).

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct files touched: 3 new symlinks (isolated, additive, no existing file's bytes change).
- Per the Step 1.5 inventory: 8 consumers found, 2 must-change. Of those, only one (`context-discovery.md`) is a genuine **technical** gap; the other (mission-thread closure) is process housekeeping, not a functional dependency.
- The primary chain — `prime.md` → `/session-start` → `/session-plan` — is backward-compatible: `prime.md` already expects these commands to exist (that is the defect being fixed), so satisfying that expectation cannot break `prime.md` itself.
- The one place this crosses from "purely additive" into "needs attention": `session-start.md` and `concurrent-session-check.md` both call an agent (`context-discovery`) that is not part of the 3-file scope and is not currently reachable from root. This does not break any *existing* root consumer, but it means the newly-linked commands may not work exactly as they do in other projects the first time they hit a substantive task. Full detail under Dimension 5 (Hidden Coupling), which is the better-fitting dimension for this finding since it is about an *undeclared dependency of the new files*, not a caller of the old ones.

### Dimension 4: Reversibility
**Risk:** Low

- `rm .claude/commands/session-start.md .claude/commands/session-plan.md .claude/commands/concurrent-session-check.md` fully restores prior state — confirmed structurally identical to the other 60 symlinks in that directory (`ls -la` shows the same `lrwxr-xr-x` form, same relative-path pattern).
- No data/log file is created or mutated by the symlink-creation step itself. `git revert` (or a bare `rm`) leaves no stale entries anywhere.
- No state propagates beyond the local repo (no push, no external write triggered by creating a symlink).

### Dimension 5: Hidden Coupling
**Risk:** High

- `session-start.md` Step 2.4 (line 209-217) invokes the **`context-discovery`** agent (`subagent_type: context-discovery`) unless one of three skip conditions holds. Skip condition 3 is: `! [ -f "$(git rev-parse --show-toplevel)/CLAUDE.md" ]` — with the stated intent (line 215) that *"Workspace-root sessions … are not engine targets."* But the actual workspace root **does** have a `CLAUDE.md` (the one quoted in this very session's system context) — so the literal test does **not** fire for this specific repo, contrary to the author's own stated intent. For any substantive root task (≥5 tokens, not a listed meta-command literal), Step 2.4 will attempt to invoke `context-discovery`.
- `context-discovery.md` is **absent** from root's `.claude/agents/` — confirmed by direct listing (`ls -la .claude/agents/` at root does not include it; `context-discovery.md` only exists at `ai-resources/.claude/agents/context-discovery.md`).
- Cross-checked against every project currently deploying `session-start.md`: `axcion-website`, `axcion-copy-factory`, `management-os`, `strategic-os` **all** carry a paired `context-discovery.md` symlink alongside their `session-start.md` symlink (via each project's `auto-sync-shared.sh` SessionStart hook, per `new-project.md:332`, which mirrors *every* command/agent from ai-resources automatically). The workspace root has no such auto-sync hook (confirmed: root `.claude/settings.json` `SessionStart` hooks list only `check-archive.sh`) — so root's command/agent set is hand-curated, and this pairing was never established there.
- `concurrent-session-check.md` Mode 1 (line 101, "invoke the `context-discovery` agent — same call as `/build-context` Step 3") carries the identical dependency. (`/build-context` itself is also one of the 33 commands not yet at root, reinforcing that the "context engine" piece has never been deployed to the workspace root as a unit.)
- Net finding: this change is the **first** time a root-directory command would attempt to invoke `context-discovery`, and the agent is not reachable there. This is exactly the "assumes the presence of another component not explicitly named in the change" failure mode — and it was not, and could not have been, caught by `CHANGE_DESCRIPTION`'s own `comm -23` analysis, because that analysis was scoped to `.claude/commands/` only; the missing dependency lives in `.claude/agents/`, a different directory the change's own verification never inspected.
- Secondary, lower-severity note: root also has no `detect-concurrent-session.sh` hook installed (no hits under `.claude/hooks/`, no wiring in `.claude/settings.json`) — the companion mechanism that prunes stale `logs/.session-marker-*` files. `concurrent-session-check.md` will still function correctly if linked (it degrades to the documented "known blind spot": stale markers cause an occasional false "still live" read, never a missed collision) — this is not a blocker, just an existing gap the change does not need to close.

### Dimension 6: Principle Alignment
**Risk:** Low

- Principles-base was not read directly this run (path not confirmed reachable within this check's scope); evaluated against the inline checks plus the workspace/repo CLAUDE.md sections already read (Skill Library, Placement Discipline, Model Tier).
- **OP-9/AP-7/DR-7 (speculative abstraction) — not triggered, and arguably the inverse case.** This is not infrastructure built for a hypothetical future consumer — the consumer (`prime.md`, live and symlinked at root, with 19 real session headers) already exists and already instructs invoking these exact commands. The change closes a gap for an already-confirmed consumer rather than generalizing ahead of one.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7)** — does not apply in its usual force here: no new command, agent, gate, or always-loaded doc is being created. The change reuses pre-existing canonical files via the repo's own established symlink-mirroring convention (identical to the other 60 root command symlinks).
- **DR-1/DR-3 (placement)** — positively aligned. Workspace CLAUDE.md's own "Skill Library" section states shared resources are canonical in `ai-resources/` and consumed by projects "via copy or symlink." This change is exactly that pattern, applied to close a documented gap, using the exact relative form already in use.
- **OP-10/OP-12/OP-5/OP-2/OP-11/OP-3** — none touched: no cross-tool coordination, no new detection mechanism, no advisory→enforcement shift, no automated judgment call, no principle being revised.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not inferred.** Independently re-derived every load-bearing count and fact in `CHANGE_DESCRIPTION` with my own commands, not by trusting the stated numbers:
  - `comm -23 <(ls ai-resources/.claude/commands) <(ls .claude/commands)` → **exactly 33** missing names, matching the claim exactly (full 33-name list re-derived and enumerated).
  - Root count 63, canonical count 90 — re-derived via `ls | grep -c '\.md$'` on each directory, both match exactly.
  - `test -e` on all 3 proposed root paths → all **ABSENT**; `test -e` on all 3 canonical targets → all **EXIST**. Both confirmed directly, not assumed.
  - `ls -la .claude/commands/prime.md` at root → confirmed genuine symlink to `../../ai-resources/.claude/commands/prime.md`. `command grep -c -E "session-start|session-plan" ai-resources/.claude/commands/prime.md` → **40**, exact match to the claim.
  - `command grep -c "^## " logs/session-notes.md` at root → **19**, matching the claim; most recent header confirmed at `2026-07-20 — Session S1-6b8` via `tail -3` on the grep output, matching "most recent 2026-07-20."
  - Cross-referenced against `ai-resources/logs/missions/repo-integrity-repairs-2026-07.md` thread 11, which independently states the same 33/90/63 figures and the same broken-chain description — read directly, not paraphrased from `CHANGE_DESCRIPTION`.
- **Consequence — traced, not merely consistent-looking.** The causal chain is fully mechanical and each link independently confirmed: root `prime.md` **is** the canonical file (symlink, verified), so the exact same instruction text that names `/session-start`/`/session-plan` executes verbatim when the operator runs `/prime` at root. Root `logs/session-notes.md` shows 19 real session headers through 2026-07-20 — the root is an actively-used session folder today, not a dormant or theoretical one — so "the documented flow fails silently at root" is a live, currently-recurring failure, not a hypothetical one.
- **Re-derivation vs. the change description:** One characterization worth correcting, not a factual error. `CHANGE_DESCRIPTION` frames `concurrent-session-check.md` as the "weakest-justified" of the three, "referenced by the brief `/prime` emits rather than by a hard `/session-start`-style chain hop." Direct re-reading of `prime.md` shows this undersells it: line 320 emits an **explicit, executable nudge** — `run '/concurrent-session-check <task>'` — fired conditionally whenever Step 1a's `LIVE_FOREIGN_HERE >= 1`. That is a real (if conditional, rather than unconditional) invocation point in the same canonical file driving the primary defect, not merely incidental documentation. This strengthens the case for including it in the batch rather than weakening it. All other counts, paths, and quoted claims re-derived and confirmed exactly as stated.

## Mitigations

- **For Dimension 5 (High):** Before or immediately after landing the 3 symlinks, either (a) add a fourth symlink, `.claude/agents/context-discovery.md -> ../../ai-resources/.claude/agents/context-discovery.md` (the same relative-symlink convention already used by the other 25 root agent symlinks), so `session-start.md` Step 2.4 and `concurrent-session-check.md` Mode 1 can actually resolve the agent they call; or (b) if deliberately deferring that, immediately test-invoke `/session-start <a real ≥5-word task>` at root right after landing and confirm Step 2.4 degrades gracefully to its documented "engine-skipped" / "engine failed, proceeding" branches rather than hard-erroring on an unresolved `subagent_type`. Do not assume graceful degradation without one of these two checks — the failure mode (Agent tool given a `subagent_type` absent from the invoking directory's `.claude/agents/`) has not been exercised at root before.
- **For Dimension 3 (Medium, optional but recommended):** Once the fix is verified live, update `ai-resources/logs/missions/repo-integrity-repairs-2026-07.md` thread 11 to closed status with citation of the applied fix (commit + verification method), per the mission's own validation contract ("[e]ach of the sixteen threads is closed with either an execution-verified fix or a recorded decline reason").

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
