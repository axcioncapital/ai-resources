# Risk Check — 2026-05-22

## Change

Build a concurrent-session detection hook for projects/global-macro-analysis (friday-act 2026-05-22 check-concurrent-session plan, Autonomy Rule #8, operator-approved this session). DESIGN (revised from the plan's literal mechanism — see note below): (1) New script projects/global-macro-analysis/.claude/hooks/check-concurrent-session.sh with two modes. `--init` mode: writes current `git rev-parse HEAD` to .claude/.session-head-marker. Check mode (default): reads PreToolUse tool-input JSON from stdin, extracts file_path; if the path is under macro-kb/<theme>/ (a real theme folder, excluding _staging/_inbox/_meta/_sources/_decisions/_memos), compares the marker SHA to current HEAD — if they differ and `git log MARKER..HEAD --oneline -- macro-kb/<theme>/` is non-empty, emits {"decision":"ask","message":"..."} listing the concurrent commits; otherwise exits 0. (2) settings.json hook registration: a SessionStart entry calling the script with --init, and the script appended to the existing PreToolUse Write and Edit hook blocks (each block currently has one staging-discipline hook; the new hook becomes a second hook in each block's hooks array — hooks run in sequence). (3) .gitignore: add `.claude/.session-head-marker`. (4) CLAUDE.md § Operational Notes: add a parallel-session-discipline line. CHANGE CLASSES: new hook file (.sh), settings.json hook registration. WHY THE DESIGN DIVERGES FROM THE PLAN: the project already has concurrent-session handling — /kb-synthesize Step 0 runs `git status --short macro-kb/{theme}/` and Step 5 does a SHA-256 before/after abort; CLAUDE.md already has a Concurrent-session recovery note; two PreToolUse hooks already guard macro-kb writes for staging-discipline. The plan's proposed `git status --porcelain` check duplicates /kb-synthesize Step 0 and shares its blind spot (committed concurrent changes don't show in `git status`). The HEAD-SHA marker approach catches concurrent COMMITS — the plan's actual recorded failure mode ("stale /prime read + a wrap commit landing mid-session", leaked 3x). KNOWN WRINKLE for evaluation: the marker is overwritten on each SessionStart and not refreshed after the session's own commits, so a session that commits mid-work then writes to the same theme again can get a false-positive `ask`; mitigated by emitting `ask` (not `deny`) with the commit list in the message so the operator resolves in one click. Hooks fire only on macro-kb theme-folder Write/Edit, so blast radius is one project.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/hooks/check-concurrent-session.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.claude/settings.json — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/.gitignore — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/CLAUDE.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A scoped, single-project hook with low cost and reversible footprint, but a High-rated hidden-coupling profile — the new hook's theme-folder exclusion regex does not match the two existing staging-discipline hooks it sits beside, and the stateless git-state design has several silent failure modes that need explicit handling before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook script itself is `not yet present` — evaluation of its body is based on the described intent in CHANGE_DESCRIPTION. The cost finding holds regardless of body content because it is a shell hook, not loaded into model context.
- No always-loaded model-context cost. The script runs as a `command`-type hook in a subprocess; its output (`exit 0` or a one-line JSON `ask`) is the only thing the model sees, and only on a fired `ask`.
- The CLAUDE.md addition is one line under § Operational Notes (CHANGE_DESCRIPTION item 4). The existing § Operational Notes is 6 bullets (`projects/global-macro-analysis/CLAUDE.md` lines 64-70); one more bullet is well under the ~50-token Medium threshold.
- SessionStart `--init` runs once per session: `git rev-parse HEAD` + a single file write — negligible wall-clock and zero token cost.
- PreToolUse cost is per Write/Edit tool call, but the script short-circuits (`exit 0`) for any path not under a real theme folder, so the git-log work runs only on theme-folder writes. The existing two hooks already run a `jq`/`grep` per Write/Edit call, so adding a second sequential hook does not change the cost class.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`deny`/`ask` entry changes. The change touches only the `hooks` object of `settings.json`, not the `permissions` object (`projects/global-macro-analysis/.claude/settings.json` lines 2-35 vs 36-61).
- The project already runs `defaultMode: bypassPermissions` with `Bash(*)` allowed (`settings.json` lines 5, 34) — the hook's `git` invocations need no new grant.
- Hooks are not gated by the permission system; registering a `command` hook does not widen the tool-permission surface. The new hook is the same `type: command` shape as the two existing PreToolUse hooks (`settings.json` lines 42, 53).
- No scope escalation (stays in project-layer `settings.json`), no cross-repo capability, no external API.

### Dimension 3: Blast Radius
**Risk:** Medium

- Files touched directly: 4 — one new file (`check-concurrent-session.sh`), three edits (`settings.json`, `.gitignore`, `CLAUDE.md`), all inside `projects/global-macro-analysis/`.
- The project is its own git repo (`git rev-parse --show-toplevel` returns the project dir; the workspace `.gitignore` lists `projects/global-macro-analysis/` as a nested repo). The change does not cross the repo boundary — blast radius is genuinely one project, consistent with the stated intent.
- Enumeration of dependent components grepped:
  - `.claude/hooks/` directory does not yet exist in the project (`ls` returned no such directory) — the change creates it. Zero existing hook-file callers.
  - SessionStart hooks: `grep -rn "SessionStart" projects/global-macro-analysis/.claude/` returned nothing — this is the first SessionStart hook in the project.
  - Existing PreToolUse hooks: 2 (Write matcher, Edit matcher — `settings.json` lines 38-48, 49-59). The new hook appends to both `hooks` arrays. Hooks in an array run in sequence, so the existing staging-discipline hooks are unaffected as long as the new hook is appended (not prepended) and the existing hook's `exit 0` / `ask` behavior is not disturbed.
  - macro-kb theme folders that the PreToolUse matcher will fire on: ~50 real theme directories under `macro-kb/` (e.g., `energy-crisis`, `nato-russia`, `central-bank-credibility`), plus the 6 underscore-prefixed non-theme folders (`_staging _inbox _meta _sources _decisions _memos`).
  - `/kb-synthesize` (`projects/global-macro-analysis/.claude/commands/kb-synthesize.md`) Step 0 and Step 5a-c already perform concurrency handling. The new hook does NOT change `/kb-synthesize`'s contract — it adds an independent second layer. No caller of `/kb-synthesize` needs modification. (See Dimension 5 for the overlap concern.)
- No contract change to any subagent schema, report heading, or slash-command syntax. The `decision: ask` JSON shape the hook emits is the same shape the two existing hooks already emit (`settings.json` lines 43, 54), so Claude Code already knows how to consume it.
- Medium (not Low) because the change touches shared project infrastructure (`settings.json` hooks block read by every session, every Write/Edit) and adds a SessionStart hook class that did not exist before — a new always-fires surface even though each individual workflow remains compatible.

### Dimension 4: Reversibility
**Risk:** Low

- All four touched paths are inside one git repo; a single `git revert` of the landing commit restores `settings.json`, `.gitignore`, and `CLAUDE.md` and removes `check-concurrent-session.sh` (a new tracked file is deleted by revert).
- The `.session-head-marker` file is added to `.gitignore` (CHANGE_DESCRIPTION item 3), so it is never committed — revert leaves at most one untracked file on disk (`.claude/.session-head-marker`), which is inert once the SessionStart hook is gone. One trivial `rm` cleans it; this is well within Low (no stale committed state, no log mutation, no external propagation).
- No append-only log mutation, no `git push`, no external write. The change does not propagate beyond the local repo.
- One soft caveat keeping this from being a non-issue: the SessionStart hook fires for any session opened between landing and a potential revert, writing the marker file — but the marker is gitignored and harmless, so this does not raise the risk level.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Exclusion-regex mismatch with the sibling hooks (verified).** The two existing PreToolUse hooks exclude `(_staging|_inbox|_meta|_sources|_decisions)` — 5 folders (`settings.json` lines 43, 54, verbatim). The new hook's design (CHANGE_DESCRIPTION item 1) excludes "_staging/_inbox/_meta/_sources/_decisions/_memos" — 6 folders, adding `_memos`. Tested: `echo "macro-kb/_memos/_candidates/foo.md" | grep -qE '/macro-kb/(_staging|_inbox|_meta|_sources|_decisions)/'` returns NOT-EXCLUDED. So the three hooks in the same `settings.json` will treat `_memos/` writes differently — the new hook stays silent, the old hooks fire their `ask`. `_memos/` is a real tracked folder (`git ls-files macro-kb/_memos/` returns `_template.md`, `_candidates/_template.md`). Two hooks in the same block disagreeing on what counts as a theme folder is an undocumented, easily-missed divergence.
- **Functional overlap with `/kb-synthesize`'s own concurrency handling.** `/kb-synthesize` Step 0 runs `git status --short macro-kb/{theme}/` and Step 5b-c does a SHA-256 before/after abort (`kb-synthesize.md` lines 18, 26-27). The new hook adds a third concurrency check on the same concern. The CHANGE_DESCRIPTION argues the hook catches a *different* failure mode (concurrent commits vs. uncommitted writes), which is a fair distinction — but with three mechanisms on one concern, a future edit to one is unlikely to be reflected in the others, and an operator seeing the hook's `ask` plus `/kb-synthesize`'s Step 0 warning gets two prompts for one underlying situation. The CLAUDE.md § Operational Notes "Concurrent-session recovery" note (line 70) is written only for the `/kb-synthesize` abort path and will not describe the new hook's `ask`.
- **Stateless-hook git-state failure modes (silent):**
  - *Self-commit false positive* — acknowledged in CHANGE_DESCRIPTION as the "KNOWN WRINKLE": the marker is set once at SessionStart and never refreshed, so a session that commits mid-work then edits the same theme triggers a false `ask` listing its own commit. The stated mitigation (`ask` not `deny`, commit list shown) reduces operator friction but does not remove the false positive — the operator is trained to dismiss it, which erodes the signal over time.
  - *Detached / missing marker* — if `.session-head-marker` is absent (first run before any SessionStart, or a `/clear` that does not re-fire SessionStart, or the file deleted), the check mode has no marker to compare. The CHANGE_DESCRIPTION does not specify the no-marker branch behavior; if it errors or emits a malformed line, it can disrupt the sequential hook chain. This is an undocumented contract gap.
  - *Non-fast-forward HEAD movement* — `git log MARKER..HEAD` assumes MARKER is an ancestor of HEAD. If a concurrent session does `git pull --rebase`, `commit --amend`, or `reset` such that MARKER is no longer an ancestor, `MARKER..HEAD` silently yields a wrong (often empty) set — the hook misses the very concurrent-commit case it exists to catch. Silent false negative.
  - *Shallow / worktree / first-commit edge* — `git rev-parse HEAD` fails in a repo with no commits or in some worktree states; the `--init` write would store an error string. Not handled in the description.
- **New undocumented contract: the marker file convention.** `.claude/.session-head-marker` is a new parse-marker / filename convention. Nothing in `CLAUDE.md`, `settings.json`, or a hooks README documents that this file exists, what writes it, or that deleting it changes hook behavior. The planned CLAUDE.md line (item 4) is described as a "parallel-session-discipline line" — a behavior note, not a documentation of the marker contract.
- High because there are multiple implicit dependencies (sibling-hook regex parity, git-ancestry assumption, marker-file presence), at least one undocumented new contract (the marker file), and a functional overlap with two existing mechanisms on the same concern.

## Mitigations

- **Dimension 5 (regex parity):** Before landing, decide one canonical theme-folder exclusion set and apply it identically across all three hooks in `settings.json`. Either add `_memos` to the two existing staging-discipline hooks, or drop `_memos` from the new hook — but the three matchers must use a byte-identical exclusion alternation. Add a one-line comment in the hook script naming the canonical set so a future edit keeps them in sync.
- **Dimension 5 (git-state failure modes):** Specify and implement explicit branches in the check-mode script for: (a) marker file absent → `exit 0` silently (fail-open, no chain disruption); (b) marker not an ancestor of HEAD (`git merge-base --is-ancestor MARKER HEAD` returns non-zero) → `exit 0` or emit a distinct "marker stale, re-run SessionStart" message rather than a misleading commit list; (c) `git rev-parse HEAD` failure in `--init` → skip the marker write rather than store an error string. Every non-happy path must `exit 0` so the sequential hook chain is never broken.
- **Dimension 5 (marker contract documentation):** Document the `.claude/.session-head-marker` file in the project `CLAUDE.md` § Operational Notes line (item 4) or in a short header comment block at the top of `check-concurrent-session.sh`: what writes it, when, that it is gitignored, and that deleting it disables the check until the next SessionStart. The contract must be documented at the change site, not left implicit.
- **Dimension 5 (self-commit false positive):** Reduce the known wrinkle rather than only routing it to the operator — after the session's own commit lands, re-run `--init` (e.g., have the relevant commit-producing commands or `/wrap-session` refresh the marker), or have check mode exclude commits whose author/committer matches the current session. At minimum, the `ask` message text must explicitly say "this may be your own session's commit" so the operator is not trained to blind-dismiss.
- **Dimension 3 (shared-infra append ordering):** When editing `settings.json`, append the new hook as the second element of each existing `hooks` array — do not prepend and do not restructure the existing staging-discipline hook objects. Verify by reading the file after the edit that each PreToolUse block's first hook is byte-identical to the pre-change staging-discipline hook.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references to `settings.json`, `kb-synthesize.md`, `CLAUDE.md`; `ls`/`grep`/`git` command output including a verified regex-exclusion test for `_memos`; verbatim quotes from CHANGE_DESCRIPTION; and an explicit `not yet present` flag on the hook script). No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (`/consult`, Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION._

# Pre-Change Advisory — Concurrent-Session Detection Hook (global-macro-analysis)

## 1. Routing position

The routing baseline is sound and we concur with it. The hook is project-local to `global-macro-analysis` — macro-kb theme concurrency is a project-specific concern, not reusable. Placement Q1 ("No, tightly coupled to one project → that project's own `.claude/`") routes it correctly to the project's own `.claude/hooks/`, never `ai-resources/` (`repo-architecture.md` § Placement heuristics Q1; DR-1 three-tier model). Hooks are not auto-distributed, so the project-local placement carries no cross-project blast radius by construction (`repo-architecture.md` § Symlink topology — "Hooks are NOT auto-distributed"). This also satisfies DR-7 directly: there is exactly one confirmed consumer, and the design does not generalize speculatively (`principles.md § DR-7`).

The change is in two gated classes — hook edits and `settings.json` changes — so `/risk-check` plan-time + end-time firing is mandatory and the verdict is binding (`risk-topology.md § 3` Hook edit / Permission change rows; `principles.md § DR-8`; `repo-architecture.md` Q5). That gate fired and returned PROCEED-WITH-CAUTION. We do not downgrade it.

## 2. We concur with PROCEED-WITH-CAUTION — with one upgrade pressure noted

The verdict is correct. The blast radius is genuinely contained: `global-macro-analysis` is the most isolated project in the workspace — it shares nothing with the canonical library (`risk-topology.md § 2`, "Global-macro-analysis is the most isolated project"). A project-local hook touching only that project's sessions is the lowest-risk shape a hook change can take (`risk-topology.md § 3`, "Project-local file edit → Only that project's sessions").

But the verdict is not GO, and the reason it is not GO is the right reason. The High hidden-coupling rating is real and load-bearing: the new hook sits **inside the same PreToolUse Write/Edit block as two existing staging-discipline hooks**, and its theme-folder exclusion regex does not match theirs. That is a two-end string contract — exactly the failure class `risk-topology.md § 5` names as a structural-risk escalator ("Change modifies a string literal matched by another component"). Three hooks firing on the same event, deciding scope from three regexes that are supposed to mean the same thing, is a silent-divergence trap. When the regexes drift, one hook guards a folder the others do not, and the failure is invisible until a concurrent commit slips through the gap. The mitigations are correctly aimed at converting this from a hidden coupling into an explicit one.

## 3. The recommended mitigations are the right path — assessed against principles

| Mitigation | Verdict | Grounding |
|---|---|---|
| Align the theme-folder exclusion regex byte-identical across all 3 hooks | **Required.** This is the load-bearing mitigation. | `risk-topology.md § 5` (two-end contract). Without it the High coupling rating stands and the change should not land. |
| Add fail-open branches (missing marker / non-ancestor marker / rev-parse failure) | **Required, and correctly scoped.** A PreToolUse hook that hard-fails blocks every Write/Edit in the project. Fail-open is the only safe posture for an *advisory* hook. | `principles.md § OP-3` — but note the nuance below. The fail-open branches handle states that genuinely occur (fresh clone, detached HEAD, no git), so this is **not** AP-10 defensive-code-for-impossible-scenarios. These states are reachable. |
| Document the marker-file contract | **Required.** The `.session-head-marker` file is a two-end contract between `--init` mode and check mode. An undocumented contract is silent coupling waiting to drift. | `principles.md § OP-6` (transfer the model, not just the instruction); `QS-7` (the *why* must be legible). |
| Reduce the self-commit false positive | **Important, not blocking.** A hook that fires `ask` on the operator's own just-made commit trains the operator to dismiss it reflexively — that is AP-4 (rubber-stamp approvals) forming at the hook layer. Worth fixing before landing, but it degrades signal quality rather than breaking anything. | `principles.md § AP-4`. |
| Append the new hook as the second array element without restructuring existing hooks | **Correct.** Minimal-diff is the right call — restructuring the existing staging-discipline hooks expands the blast radius from "one new hook" to "three hooks rewritten" for no benefit. | `principles.md § DR-7` implication; `system-doc.md § 2.1` System stability ("changes don't break existing components"). |

The mitigation set is well-targeted. The two we mark **Required** (regex alignment, fail-open) are the conditions that earn the change its way from PROCEED-WITH-CAUTION toward landable. We would not let it land without both.

## 4. Risks the five-dimension review did not fully surface

Three. One is a genuine gap; two are calibration notes.

**(a) Hard Rule 6 alignment is not a conflict — but it is the load-bearing reason the design is acceptable, and it is not stated as such.** `global-macro-analysis` Hard Rule 6 forbids automation that "removes Patrik from the judgment loop." The proposed hook emits `{"decision":"ask"}` — a prompt *to* the operator — not `deny`. That is the correct side of the line: the hook surfaces a conflict for human judgment rather than resolving it silently, which is precisely `principles.md § OP-3` (loud failure over silent continuation) and `OP-5` (advisory automation surfaces findings, does not decide). **This is not a flagged conflict — we name it because it is the design's main protection and the dimension review treated it as a non-issue rather than as a deliberately-load-bearing choice.** The implication: if any future iteration changes the hook to emit `deny`, that crosses Hard Rule 6 and `OP-5`'s advisory/enforcement boundary, and must re-trigger `/risk-check` as a materially different change. Document that boundary in the marker-file contract note so the constraint travels with the hook.

**(b) Detection scope vs. the actual failure mode — the hook narrows the existing blind spot but does not close it.** The design's stated justification is that the HEAD-SHA marker catches concurrent *commits*, which `/kb-synthesize` Step 0's git-status check misses. Correct. But the new hook only fires `ask` when moved commits touch *the theme folder being written to*. The recurring 3x failure was concurrent work on macro-kb themes — but a concurrent session that commits to a *shared* file the theme depends on (a project CLAUDE.md, a shared index, an intake artifact outside the theme-folder regex) still slips through. The hook closes the narrow case and leaves a quieter adjacent one open. This is acceptable for v1 — narrowing a 3x-recurring failure is real ROI (`system-doc.md § 2.1` Proper solutions; ROI-based prioritization) — but the residual gap should be named in the marker-file contract note so it is a known boundary, not a silent one (`principles.md § OP-3`, `OP-11` — surface, do not let drift hide). The dimension review's Dimension 5 (hidden coupling) caught the *hook-to-hook* coupling; it did not catch this *hook-to-detection-scope* gap.

**(c) The marker file is session-scoped mutable state in a gitignored path — a reset surface the reversibility rating (Low) understates slightly.** `--init` overwrites `.session-head-marker` on every SessionStart. If two concurrent sessions both start, the second `--init` overwrites the first session's baseline, and the first session's check mode now diffs against the *wrong* HEAD — it can either miss a real concurrent commit or fire a false `ask`. The five-dimension review rated reversibility Low (good — deleting the hook and marker fully reverts), but reversibility of *the installation* is not the same as correctness of *the runtime state under concurrency*. The hook is a concurrency-detection tool whose own state file is not concurrency-safe. The fail-open branches partially cover this (a confused diff fails toward `ask` or toward silence, not toward a crash), so it does not block — but the marker-file contract note must state that the marker is last-writer-wins and per-`--init`, not per-session-isolated.

## 5. Clear position

The right answer is: **land the change, conditional on the two Required mitigations, with the contract note expanded.**

- Proceed with PROCEED-WITH-CAUTION as issued — do not seek to upgrade it to GO; the High coupling rating is doing its job.
- Treat regex byte-alignment across all 3 hooks and the fail-open branches as **landing preconditions**, not nice-to-haves. Without both, the change does not land.
- Treat the self-commit false-positive reduction as a should-fix-before-landing quality item (AP-4 risk), not a blocker.
- Expand the marker-file contract note to carry three things the dimension review left implicit: the `ask`-not-`deny` boundary and its Hard Rule 6 / OP-5 tie (risk 4a), the residual shared-file detection gap (risk 4b), and the last-writer-wins concurrency property of the marker file itself (risk 4c).
- The CLAUDE.md parallel-session note is a project-local CLAUDE.md edit, not a workspace/always-loaded-cross-cutting edit. Keep it to a short pointer per `principles.md § DR-5`; the mechanism detail belongs in the marker-file contract note, not in CLAUDE.md.

The design's divergence from the plan's literal git-status+mtime mechanism is the correct call and we endorse it: duplicating `/kb-synthesize` Step 0's git-status check would have inherited its blind spot, and a documented duplication that shares a known weakness is worse than a single mechanism that closes it.
