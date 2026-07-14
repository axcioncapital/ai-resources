# Risk Check — 2026-07-14

## Change

Batched risk-check over the full 7-item repo-repair change set approved in logs/session-plan-2026-07-14-S8.md (identical to ~/.claude/plans/immutable-drifting-hearth.md). READ THAT PLAN FIRST — it is the change spec, and it contains my claimed evidence.

CHANGE CLASSES PRESENT (all in one batch, by operator decision):
1. Hook edits: check-foreign-staging.sh (regex widening at :187/:249/:407), check-destructive-liveness.sh (new logged override path), plus the .codex/hooks/ mirror copies.
2. NEW runnable infrastructure: logs/scripts/install-hooks.sh (writes to ~/.claude/settings.json), .claude/hooks/check-hook-wiring.sh (new SessionStart probe), .claude/hooks/cleanup-session-marker.sh (moved into git from ~/.claude/hooks/).
3. Permissions change: narrowing Bash(git checkout *) at ~/.claude/settings.json:47 and workspace-root .claude/settings.json:27 to only the discarding forms; narrowing Read(logs/*archive*.md) at ai-resources/.claude/settings.json:30.
4. Session-marker GRAMMAR change: S{N} -> S{N}-{id3} (3 chars of CLAUDE_CODE_SESSION_ID). Readers accept both old and new; writers emit only new. Touches prime.md, session-start.md, session-plan.md, both real wrap-session.md copies, foreign-session-guard.sh, run-manifest.sh, concurrent-session-check.md, two test fixtures, docs/session-marker.md, and the .codex mirror. REMOVES the mkdir claim-dir mutex from prime.md.
5. Doctrine: a wrap-session CORE-PATH rule that every finding must be queued-with-severity or explicitly declined; session-feedback-collector.md severity-on-every-entry change.

## Referenced files

- `ai-resources/logs/session-plan-2026-07-14-S8.md` — exists (change spec)
- `ai-resources/.claude/commands/prime.md` — exists
- `ai-resources/.claude/commands/wrap-session.md` — exists
- `.claude/commands/wrap-session.md` (workspace root) — exists
- `ai-resources/.claude/commands/session-start.md` — exists
- `ai-resources/.claude/commands/session-plan.md` — exists
- `ai-resources/.claude/commands/concurrent-session-check.md` — exists
- `ai-resources/.claude/commands/close-worktree-session.md` — exists
- `ai-resources/.claude/hooks/check-foreign-staging.sh` — exists
- `ai-resources/.claude/hooks/check-destructive-liveness.sh` — exists
- `ai-resources/.codex/hooks/check-foreign-staging.sh` — exists
- `ai-resources/.claude/agents/session-feedback-collector.md` — exists
- `ai-resources/.claude/settings.json` — exists
- `.claude/settings.json` (workspace root) — exists
- `~/.claude/settings.json` — exists
- `~/.claude/hooks/cleanup-session-marker.sh` — exists
- `~/.claude/hooks/cleanup-session-marker.log` — exists
- `ai-resources/logs/scripts/foreign-session-guard.sh` — exists
- `ai-resources/logs/scripts/run-manifest.sh` — exists
- `ai-resources/logs/scripts/prime-allocator.test.sh` — exists
- `ai-resources/logs/scripts/run-manifest.test.sh` — exists
- `ai-resources/docs/session-marker.md` — exists
- `ai-resources/logs/scripts/install-hooks.sh` — **not yet present**
- `ai-resources/.claude/hooks/check-hook-wiring.sh` — **not yet present**

The two `not yet present` files are evaluated from described intent only. This is flagged inline under Dimensions 1, 2, 4, 5 and 6.

## Verdict

**RECONSIDER**

**Summary:** The plan is unusually rigorous — its four unnamed marker-grammar breaks are all real and I reproduced every one — but it batches a verified-destructive permissions regression, a new probe that may be dead on arrival because it is wired into the very settings layer whose hook execution is unproven, and two scope-shrinking refutations that the repo's own friction log contradicts; Dimension 7 is High on its own terms and that alone forces RECONSIDER.

---

## Consumer Inventory

Built with `command grep` throughout (see Dimension 7 — the shell-function `grep` returns **0** hits inside `ai-resources/` where the real binary returns **184**; the caller's warning is confirmed and severe).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` | parses + writes (allocator ×3 sites, `PREV##*S`) | **yes** |
| `ai-resources/.claude/commands/session-start.md` | writes marker/header | **yes** |
| `ai-resources/.claude/commands/session-plan.md` | writes plan filename | **yes** |
| `ai-resources/.claude/commands/wrap-session.md` (canonical) | parses + teardown Step 13 | **yes** |
| `.claude/commands/wrap-session.md` (workspace root, **REAL file**, `[ -L ]` false) | co-edits (lockstep, Step 7) | **yes** |
| `ai-resources/.claude/commands/concurrent-session-check.md` | parses (`:72` hardcodes `session-plan-${TODAY}-S{N}.md`) | **yes** |
| `ai-resources/.claude/commands/close-worktree-session.md` | documents (`:127–131` false trustworthiness claim) | **yes** |
| `ai-resources/.claude/hooks/check-foreign-staging.sh` | parses (`:187`, `:249`, `:407`) | **yes** |
| `ai-resources/.codex/hooks/check-foreign-staging.sh` | parses (**independent real file**, 49 differing lines, 0 `logs/runs/` refs vs 6) | **yes** |
| `ai-resources/logs/scripts/foreign-session-guard.sh` | parses (`:140`, `:142` unanchored `grep -c`) | **yes** |
| `ai-resources/logs/scripts/run-manifest.sh` | writes (`:175` `${DATE}-${MARKER}.json`) | **yes** |
| `ai-resources/logs/scripts/prime-allocator.test.sh` | parses (fixture, 3 sites) | **yes** |
| `ai-resources/logs/scripts/run-manifest.test.sh` | parses (fixture) | **yes** |
| `ai-resources/docs/session-marker.md` | documents (registry; `:251` names a **missing** file) | **yes** |
| `ai-resources/.claude/agents/session-feedback-collector.md` | co-edits (severity-on-every-entry) | **yes** |
| `ai-resources/.claude/settings.json` | co-edits (9 unquoted `$CLAUDE_PROJECT_DIR` hook entries + new probe wiring) | **yes** |
| `~/.claude/settings.json` | co-edits (deny `:47`; SessionEnd wiring `:142–152`) | **yes** |
| `.claude/settings.json` (workspace root) | co-edits (deny `:27`) | **yes** |
| `ai-resources/.claude/hooks/check-destructive-liveness.sh` | co-edits (new override; keyed on session-id, not `S{N}`) | **yes** |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | imports contract (keyed on `.session-marker-<id>` filename) | no — survives |
| **24 live symlinks → `prime.md`** | imports (propagate on save) | no — auto |
| **22 live symlinks → `wrap-session.md`** | imports (propagate on save) | no — auto |
| `projects/positioning-research/.claude/commands/wrap-session.md` | **divergent REAL copy** — will NOT receive Fix 4 | no (by plan's own admission) |
| `ai-resources/workflows/research-workflow/.claude/commands/{prime,wrap-session}.md` | REAL copies, **0** allocator sites | no |
| `ai-resources/output/deploy-test-scratch-2026-06-12/.claude/commands/{prime,wrap-session}.md` | REAL copies, **0** allocator sites | no |
| `archive/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` | **DANGLING symlink** → missing `ai-resources/.claude/hooks/backup-session-plan.sh` | no (report only) |
| `.claude/skills/mandate-parser/SKILL.md` | documents (prose "Session Startup" only — **not** a grammar parser) | no |

**Total: 26 consumers, 19 must-change.** Both `not yet present` files have no consumers yet; the inventory covers the contracts they introduce (the `S{N}-{id3}` grammar, and the hook-wiring contract in `ai-resources/.claude/settings.json`).

**Consumer the change description did not anticipate:** none materially — the plan's own inventory is close to complete, which is a genuine strength. The one thing it under-states is the *category* of `ai-resources/.claude/settings.json`: the plan treats the 10 unquoted `$CLAUDE_PROJECT_DIR` occurrences as a robustness cleanup, but that file is the **execution substrate for the new probe** (see Dimensions 5 and 7).

---

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- New `check-hook-wiring.sh` is a **SessionStart** hook — runs once per session, and by design propagates via git into every checkout that uses `ai-resources/.claude/settings.json`. Per-session, not per-tool-call → Medium, not High. (Evaluated from described intent; file `not yet present`.)
- The Phase 4 wrap-session "CORE-PATH disposition step" runs **inline in the main session (no subagent)** — plan `:170`: *"Run it inline in the main session (no subagent — Subagent Proportionality), so a bare wrap still produces a disposition."* This is the cheap choice and correctly reasoned; it adds a modest per-wrap token cost, not a per-session one.
- No additions to any always-loaded `CLAUDE.md` are described. No new `@import` chain. No new frequently-spawned subagent brief.
- `install-hooks.sh` is pay-as-used (operator-invoked script), not auto-loaded → no ongoing cost.

### Dimension 2: Permissions Surface
**Risk:** **High**

- **The proposed deny replacement re-opens three destructive forms that are denied today.** The plan (`:184`) replaces `Bash(git checkout *)` with denies on `git checkout -- *`, `git checkout .`, `git checkout -f *`. Verified by `fnmatch` against the proposed set:

  | command | current | proposed | nature |
  |---|---|---|---|
  | `git checkout HEAD -- f.txt` | DENY | **allow** | **DESTRUCTIVE** — overwrites working file from HEAD, discards uncommitted changes |
  | `git checkout main -- f.txt` | DENY | **allow** | **DESTRUCTIVE** — same, from another tree-ish |
  | `git checkout HEAD .` | DENY | **allow** | **DESTRUCTIVE** — overwrites the whole tree |
  | `git checkout --ours f.txt` | DENY | allow | benign (the form the operator wants back) |
  | `git checkout -b newbranch` | DENY | allow | benign (the form the operator wants back) |

  The tree-ish-pathspec form (`git checkout <tree-ish> -- <path>`) is exactly as discarding as `git checkout -- <path>` and is **not covered** by any of the three proposed patterns. This is a net widening of destructive capability, not a narrowing. The plan does not name it.
- The deny rule is **live and enforcing** — direct evidence: my own scratch-repo test command containing `git checkout HEAD -- f.txt` was **blocked by the permission system** during this review. So this is not a theoretical surface.
- Rubric: "removes a deny rule" and "broad widening" → **High** on the letter of the rule, and High on substance given the verified hole.
- **`install-hooks.sh` introduces a new cross-layer write capability**: a repo-versioned script that writes `~/.claude/settings.json` — the **user-level** settings file, outside the repo and outside git. That is a project → user scope escalation (rubric: High). The plan constrains it well (backup, python3 idempotent merge, `hooks` key only, must not touch `"model": "opus[1m]"` at `:167` — confirmed present, operator declined removal 2026-07-13), but the capability is new. (Evaluated from described intent; file `not yet present`.)
- `Read(logs/*archive*.md)` at `ai-resources/.claude/settings.json:30` — narrowing this is the low-risk part of the class, and the plan's diagnosis is **correct**: verified by `fnmatch` that `:26`'s `Read(logs/*-archive-*.md)` does **not** match `improvement-log-archive.md` (needs a hyphen after "archive") while `:30`'s `Read(logs/*archive*.md)` **does**. The plan correctly identifies `:30` as the actual blocker and `:26` as a red herring.

### Dimension 3: Blast Radius
**Risk:** **High**

- **26 consumers, 19 must-change** (Step 1.5 inventory above). Rubric threshold for High is >5 dependent callers or any caller requiring modification — both are exceeded by a wide margin.
- **Symlink census (verified with `[ -L ]`, never `[ -f ]`, as instructed):** `prime.md` → **24 live symlinks, 3 real files, 0 dangling**. `wrap-session.md` → **22 live symlinks, 5 real files, 0 dangling**. Workspace-root `.claude/commands/wrap-session.md` is a **REAL file, not a symlink**. All three counts match the plan exactly.
- **The grammar change is a non-backwards-compatible writer contract with a hard ordering hazard.** `run-manifest.sh:175` writes `${RUNS_DIR}/${DATE}-${MARKER}.json`. Under the new grammar that is `2026-07-14-S7-a4f.json`. `check-foreign-staging.sh:407` exempts manifests via `re.match(r'\d{4}-\d{2}-\d{2}-S\d+\.json$', base)`. Executed:
  - `2026-07-14-S7.json` → **EXEMPT**
  - `2026-07-14-S7-a4f.json` → **NOT EXEMPT (blocked)**

  If any writer emits the suffixed form before `:407` is widened, **every wrap commit is blocked**. The plan identifies this and calls it "a bug Fix 3 would have introduced" — correct, and the reason the phases cannot be reordered or partially landed.
- **A second session is live in this checkout right now.** Verified: `ai-resources/logs/.session-marker-f76a2fd8-17a8-4112-9ebe-ab928f1d55cf` (mtime 15:39) is present on disk and **absent from `cleanup-session-marker.log`** (18 entries, last at 15:38:40, cap 100 so no truncation) ⇒ that session has not ended. Fixes 2/3/4 edit shared files. **DR-10** is directly on point: *"No directory wildcards for `git add` during disclosed concurrent sessions."*
- `.codex/hooks/` confirmed as **independent real files, not symlinks** (all 19 entries). `check-foreign-staging.sh` there has **49 differing lines** from `.claude/` and **0** `logs/runs/` references vs **6** in the canonical — i.e. it lacks the manifest exemption entirely. Every hook edit must be made twice or the drift widens.

### Dimension 4: Reversibility
**Risk:** **High**

- **State propagates outside git.** `install-hooks.sh` writes `~/.claude/settings.json`, which is not in any repo. A `git revert` of the installer does **not** undo what it already wrote. The plan mitigates with a backup, which is the right call, but rollback becomes a documented manual restore, not a revert. Rubric: "state has propagated beyond git" → High.
- **The deny-rule change is the one irreversible-in-session change**, as the change description itself flags. Confirmed live-and-enforcing (it blocked my own test command). A bad deny set cannot be undone by the session it locks out.
- The git-tracked half reverts cleanly: `prime.md` and `wrap-session.md` edits propagate to all 24 / 22 symlinks on save **and on revert** — symlinks cut both ways, so this part is self-healing.
- Residue a revert would leave: any `logs/runs/2026-07-14-S{N}-{id3}.json` manifests and any suffixed `session-notes.md` headers written during the mixed-grammar window. Both are append-only log artifacts a revert cannot cleanly undo — though the plan verifies backwards compatibility (`^## DATE — Session S[0-9]+` matches both forms), so they degrade harmlessly rather than breaking readers.

### Dimension 5: Hidden Coupling
**Risk:** **High**

- **The new probe's own wiring depends on the bug it exists to detect.** This is the most important finding in the review. `check-hook-wiring.sh` is to be wired into `ai-resources/.claude/settings.json` (plan `:87–89`). Every one of the 9 existing hook entries in that file uses an **unquoted** `$CLAUDE_PROJECT_DIR` (verified: 10 occurrences, all unquoted). Executed under `bash`:

  ```
  $ bash -c 'export CLAUDE_PROJECT_DIR="/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources";
             bash $CLAUDE_PROJECT_DIR/.claude/hooks/check-heavy-tool.sh </dev/null; echo "exit=$?"'
  bash: /Users/patrik.lindeberg/Claude: No such file or directory
  exit=127
  ```

  The path contains two spaces; unquoted, it word-splits into 4 arguments. If the probe is wired the same way, it **exits 127 and prints nothing** — and its silence is indistinguishable from "all hooks are correctly wired." A hook-wiring detector that cannot detect its own non-execution is a fail-open guard, which is precisely the `warn-settings-change.sh` failure the caller cites as prior art. **Phase 1 item 4 (quoting) must land before, or atomically with, item 3 (the probe).**
- **Phase 0 is NOT sufficient** (the caller asked this directly). Phase 0 requires a known-positive fixture for `check-foreign-staging.sh` and `check-destructive-liveness.sh` — the two hooks being *edited*. It requires **no** known-positive for `check-hook-wiring.sh` — the hook being *created*, and the only one in the set whose failure mode is silent. The discipline is right; its scope is one component short.
- Corroborating structural signal: the hooks that **demonstrably do fire** (`~/.claude/settings.json` — its SessionEnd hook produced 18 log lines today) **all quote their paths**: `bash \"/Users/.../check-foreign-staging.sh\"`. The 9 in `ai-resources/.claude/settings.json` are the only unquoted set in the workspace.
- **The two guards being edited do NOT carry the S7 fail-open bug** — this is a genuine positive and I confirmed it. Both read the payload correctly:
  - `check-foreign-staging.sh:66,79` — `payload=$(cat)` → `python3 - "$payload"` → `cmd = (payload.get("tool_input", {}) or {}).get("command", "")` — the **nested** form.
  - `check-destructive-liveness.sh:102,109` — identical pattern.

  Neither reads a top-level `file_path`. The S7 defect does not recur here. (Both do `command -v python3 || exit 0` — a *deliberate, documented* fail-open: "degrade OPEN — never block a commit because the guard can't run.")
- Cross-file silent contract: `run-manifest.sh:175` (writer) and `check-foreign-staging.sh:407` (reader) form a filename contract co-located in neither file. The plan found it; the coupling remains undocumented at both ends.
- `foreign-session-guard.sh:140,142` use **unanchored** `grep -c "^## ${MARKER_DATE} — Session ${MARKER}"` — a bare `S7` marker prefix-matches an `S7-a4f` header during the mixed-grammar window. `:146–156` use `awk` with a `"$"` anchor and are safe. Plan's claim confirmed exactly.
- Registry rot confirmed: `docs/session-marker.md:251` names `ai-resources/.claude/hooks/backup-session-plan.sh` as a canonical runtime consumer — **that file does not exist**. `archive/nordic-pe-macro-landscape-H1-2026/.claude/hooks/backup-session-plan.sh` is a **dangling symlink** pointing at it (verified with `[ -L ]` + `[ -e ]`). The only live copy is in `.codex/`.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles read from `projects/strategic-os/ai-strategy/principles-base.md` (present and readable) and `docs/ai-resource-creation.md` rule #7.

- **OP-12 (closure before detection) — SATISFIED, and this deserves credit.** `check-hook-wiring.sh` is new *detection*, but it ships with a working *closure channel*: the plan (`:89`) requires it to "name the installer." Detection behind closure, never ahead of it. This is the principle applied correctly.
- **Complexity budget (`ai-resource-creation.md` rule #7) — PASSES prong (b).** Two new components (installer + probe) are net-additive, so prong (a) net-simplification fails. Prong (b) requires *cited written evidence* of the failure mode. It exists and is specific: `logs/friction-log.md:523` names the owner artifact as *"`~/.claude/hooks/cleanup-session-marker.sh` + its SessionEnd wiring (**the unversioned wiring is itself the open HIGH item of 2026-07-14**)"* and asks, as prevention item (c), for exactly *"an explicit, logged operator-override input rather than one that works by erasing its own evidence"* — which is Phase 3's liveness override. The change is evidence-driven, not speculative.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — mild tension, named, not a violation.** The installer's headline justification is "on another machine none resolve" (plan `:78–79`), and a second machine is an **unconfirmed consumer**. But the *present-tense* defect is real and independent of any second machine: six guards are wired only in a non-git file by hardcoded absolute path, so if `~/.claude/settings.json` is reset the guards vanish **while the repo still looks fully guarded**. That is a live silent-failure mode with a cited log entry. Medium tension on the framing; the underlying need is confirmed.
- **OP-5 (advisory ≠ enforcement) — tension, named.** Phase 4's wrap-session CORE-PATH rule ("every finding is either queued-with-severity or explicitly declined — **no silent third option**") converts an advisory collection step into a mandatory disposition gate on the core path. It still advises-and-stops rather than auto-correcting, so it is not an enforcement upgrade — but it is a new mandatory stage, and OP-5 says enforcement authority is "an explicit per-component decision." The operator made it explicitly (plan `:41`, "Operator decisions (locked)"), so this is a recorded call, not drift.
- **OP-11 (loud revision, never silent drift) — SERVED.** The plan loudly records that it refuted three of seven operator premises rather than quietly dropping them. That is the correct posture even where I find the refutations incomplete (Dimension 7).
- **DR-10 — directly engaged and currently violated in spirit.** A concurrent session is live in this checkout (verified). DR-10 constrains staging discipline during exactly this condition. Phase 5 in particular should not run while it is live.
- **DR-8 — honoured.** The plan routes all seven items through a plan-time `/risk-check` and states (`:228`) that "a RECONSIDER is not downgraded to push the change through." Noted, and this report takes it at its word.

### Dimension 7: Problem Reality
**Risk:** **High**

This is where the review bites. The plan's central move is that it **refuted three of seven operator-stated defects and shrank the work accordingly**. I re-derived every load-bearing claim by execution. Most of the plan is right — and the places it is wrong are the places that matter.

**Defect — observed or inferred?** Overwhelmingly **observed**, and I reproduced it. Confirmed by my own execution:

- **(c) `:407` manifest exemption breaks.** `re.match(r'\d{4}-\d{2}-\d{2}-S\d+\.json$', "2026-07-14-S7-a4f.json")` → **no match**. The plan's self-caught bug is real.
- **(c2) `:187` truncation.** `re.search(r'\bS\d+\b', "2026-07-14 S7-a4f")` → `'S7'`. Both `S7-a4f` and `S7-b2c` extract to `S7`. Real.
- **(c3) `:249` cross-attribution.** The header regex built from `sess='S7'` matches `## 2026-07-14 — Session S7`, `…S7-a4f`, **and** `…S7-b2c`. Real.
- **(d) `prime.md` fail-safe seed dies.** Executed the actual shell: marker `2026-07-14 S7-a4f` → `n='7-a4f'` → the `*[!0-9]*` guard rejects → **`HIGH=0`**. The proposed fix `n="${n%%-*}"` → `HIGH=7`. Real, and the fix works.
- **(e) blast-radius counts.** `prime.md`: **24** live symlinks / 3 real. `wrap-session.md`: **22** / 5 real. Workspace-root wrap-session is a **real file** (`[ -L ]` false). All three exactly as claimed.
- **The `grep` instrument finding — confirmed, and it is the plan's best catch.** `grep` is a shell function (`/Users/patrik.lindeberg/.claude/shell-snapshots/snapshot-zsh-…`) and is gitignore-aware; `.gitignore:32` contains `ai-resources/`. Recursive `grep -rn` from the workspace root: **0** hits inside `ai-resources/`. `command grep -rn`, same pattern: **184**. Any prior audit that grepped from the workspace root was reading an empty directory.
- **(b) wrap-session already tears down its own marker — CONFIRMED.** Canonical Step 13 and workspace-root Step 7 both contain `[ -n "${CLAUDE_CODE_SESSION_ID}" ] && rm -f "logs/.session-marker-${CLAUDE_CODE_SESSION_ID}"`. And `CLAUDE_CODE_SESSION_ID` **is** set in the tool environment (verified: `acb80817-…`), so the guard passes and the `rm` runs. The brief's requested fix does exist.
- `check-destructive-liveness.sh` has **no override path** — grep for `override|OVERRIDE|AXCION_` returns **zero** hits. Confirmed.
- 10 unquoted `$CLAUDE_PROJECT_DIR` — count confirmed exactly.

**Consequence — traced or assumed?** Here three claims break down.

1. **"These work today by luck" (Phase 1 item 4) — CONTRADICTED by my execution.** There is no luck mechanism. Under `bash`, `bash $CLAUDE_PROJECT_DIR/.claude/hooks/check-heavy-tool.sh` word-splits into 4 arguments and **exits 127** (`bash: /Users/patrik.lindeberg/Claude: No such file or directory`). Either (i) Claude Code's hook runner word-splits, in which case **all 9 repo-level hooks in `ai-resources/.claude/settings.json` are dead right now** — a far larger finding than the plan's "robustness cleanup," and one that reframes item 4 as the highest-value item in the batch; or (ii) the runner does not split, in which case quoting is genuinely cosmetic. **The plan asserts (ii) without evidence and I could not confirm it from inside the sandbox.** The corroborating signal points the other way: every hook that demonstrably fires (the `~/.claude/settings.json` set) quotes its path. This must be settled empirically *before* Phase 1, because it also decides whether the new probe can run at all (Dimension 5).

2. **(a) "Its own log proves it [works]" — OVERSTATED.** The hook **is** wired (`~/.claude/settings.json:142–152`, command at `:147`) and **did** fire 18 times today. The operator's "the auto-cleanup has never worked once" is **false**, and the plan is right to refute it. But: **17 of the 18 entries are `NOOP marker-absent`, and the single `REMOVED` (log line 1) is a synthetic fixture** in a scratchpad test directory (`.../hooktest/logs/.session-marker-testsession12345`). The log proves the hook **runs** and constructs the correct path. It does **not** prove the hook has ever removed a real marker in production. Answering the caller's question directly: `NOOP marker-absent` is *consistent with* working-correctly (a session that never primed has no marker; a session that wrapped had its marker removed by Step 13 already) — but it is **not proof of it**, and the plan treats it as proof.

3. **The counter-example the plan does not reconcile — this is the load-bearing one.** `logs/friction-log.md:523` documents, in this repo, on 2026-07-13: a worktree session that ran `/wrap-session` **to completion** — committed session notes, `decisions.md`, and a run manifest at 12:11:37 (`ca68eaa`) — and **still left both markers on disk**. The entry states plainly: *"That hypothesis is now falsified: this session did not crash — it wrapped cleanly and committed — and still left its marker."* That is a dated, executed observation that **both** teardown paths failed on a real clean wrap. The plan's (a)/(b) refutations establish that the mechanism *exists*; the disputed question was never existence but **efficacy**, and the repo's own log records it failing. The plan does route this to Phase 0 (*"check whether that branch's `wrap-session.md` predates Step 13"*) — the right question — **but it shrinks the scope (drops Fix 1 items 1–2 as "already done — do not rebuild them") before Phase 0 answers it.** This is exactly the inverse Dimension-7 failure the caller asked me to hunt: a refutation that may cause the plan to under-deliver on a real defect.

4. **(d)'s consequence is CONDITIONAL, not unconditional.** The plan calls the seed break "the single most dangerous line in the change" and says it "allocates **S1** over an existing **S7**." The seed does die (`HIGH=0`, verified) — but I traced what happens next, and **the git-grep scans immediately below still recover 7**: `grep -hoE "^## 2026-07-14 — Session S[0-9]+"` matches the suffixed header, emitting `## 2026-07-14 — Session S7`, and the `[0-9]+$` tail extracts `7`. So on the **normal** path `HIGH` still ends at 7 and no collision occurs. The S1-over-S7 catastrophe fires **only when the scans also fail** — git failure, missing common dir, or `/prime` outside a git repo — i.e. precisely the degraded path the fail-safe exists to cover. The defect is real, the fix is correct and verified, and a defeated fail-safe is a genuine defect; but the claimed everyday consequence is not traced, and the urgency is lower than stated.

5. **Phase 5's consequence is worse than stated, in the other direction.** Independently derived, not in the plan: the proposed deny set leaves `git checkout HEAD -- <file>`, `git checkout <branch> -- <file>` and `git checkout HEAD .` **allowed** — all three discard uncommitted work, all three are denied today. See Dimension 2.

**Re-derivation vs. the change description:**

| Claim | Verdict |
|---|---|
| `:407` regex breaks on `-S7-a4f.json` | **Confirmed** by execution |
| `:187` `\bS\d+\b` truncates `S7-a4f` → `S7` | **Confirmed** |
| `:249` header regex cross-matches | **Confirmed** |
| `prime.md` seed → `HIGH=0` | **Confirmed**; fix `${n%%-*}` verified |
| 24 `prime.md` symlinks / 22 + 5 for `wrap-session.md` / root copy is real | **Confirmed exactly** (`[ -L ]`) |
| `.codex/` = independent drifted real files | **Confirmed** (49 differing lines; 0 vs 6 `logs/runs/` refs) |
| Deny at `~:47`, root `:27`, absent from ai-resources | **Confirmed** |
| `:26` glob does not match `improvement-log-archive.md`; `:30` does | **Confirmed** by `fnmatch` |
| `grep` is a gitignore-aware shell function | **Confirmed** (0 vs 184 hits) |
| `check-destructive-liveness.sh` has no override | **Confirmed** (0 hits) |
| Registry rot + dangling symlink | **Confirmed** |
| wrap-session already tears down its marker | **Confirmed** |
| cleanup hook is wired and fires | **Confirmed** — but "the log proves it works" is **overstated** (17/18 NOOP; only REMOVED is synthetic) |
| "these work today by luck" | **CONTRADICTED** — `exit 127` under bash |
| "`prime.md` ×3 allocator copies" | Confirmed, but the 3 sites are **all inside canonical `prime.md`**; the other 2 real `prime.md` files have **0** allocator sites. Phrasing invites a wrong search. |
| Fix 1 items 1–2 "already done — do not rebuild" | **Unsafe as a scope cut** — `friction-log.md:523` records both paths failing on a clean wrap |
| Phase 5 deny set is a narrowing | **CONTRADICTED** — it re-opens 3 destructive forms |
| `warn-settings-change.sh` "wired nowhere" | It does not exist at `ai-resources/.claude/hooks/` at all (out of scope; noted only) |

---

## Recommended redesign

- **Settle the hook-execution question first, alone, before anything else in the batch.** Whether the 9 hooks in `ai-resources/.claude/settings.json` execute at all is currently **unknown**, and it gates two separate decisions: (i) whether Phase 1 item 4 is a cosmetic quoting cleanup or a resurrection of 9 dead guards, and (ii) whether `check-hook-wiring.sh` can run at all once wired into that same file. Cheapest decisive test: wire one throwaway hook in that file that `touch`es a sentinel path, once unquoted and once quoted, and observe which sentinel appears. Until this is settled, **do not wire the new probe** — a probe that exits 127 reports "all clear" by silence, which is the exact `warn-settings-change.sh` fail-open the plan was built to avoid. Correspondingly, **extend Phase 0** to require a known-positive for `check-hook-wiring.sh` itself (deliberately unwire a hook; assert the probe *warns*), not only for the two hooks being edited.

- **Run Phase 0's marker-corpse question *before* accepting the (a)/(b) scope cut, not after.** `friction-log.md:523` is a dated, executed counter-example in which a cleanly-wrapped session left both markers on disk. The plan's refutations prove the teardown *exists*; they do not explain why it *did not work* there. If that branch's `wrap-session.md` predates Step 13, the plan's scope cut is safe and Fix 1 items 1–2 can stay dropped. If it did not, a real defect survives the plan. Answer it, then re-scope.

- **Fix the deny set before landing Phase 5, and land Phase 5 alone, in its own session, with no concurrent session live (DR-10).** The proposed three patterns leave `git checkout HEAD -- <path>`, `git checkout <branch> -- <path>` and `git checkout HEAD .` allowed — all destructive, all denied today. Either add tree-ish coverage (e.g. `Bash(git checkout * -- *)`, `Bash(git checkout HEAD *)`) or invert the approach: keep the broad `Bash(git checkout *)` deny and add narrow **allow** entries for the two forms actually wanted (`git checkout --ours *`, `git checkout --theirs *`, `git checkout -b *`). The allow-list inversion is strictly safer and matches the operator's stated need.

- **Split the batch.** The seven items have genuinely different risk profiles and different reversibility. The grammar change (Fix 3) is internally coherent and must land atomically — readers before writers — but it does not need to share a commit with a user-level permissions change that can lock the operator out mid-session, or with new infrastructure whose execution substrate is unproven. Suggested order: (0) hook-execution test → (1) quoting fix → (2) Fix 3 grammar, atomically → (3) Fix 1 override + doc corrections → (4) Fix 4 doctrine → (5) Fix 5 deny rules, own session, no concurrent session.

---

## Evidence-Grounding Note

All risk levels grounded in direct evidence: executed commands with their actual output (regex runs, shell re-implementations of `prime.md`'s seed, `bash` word-splitting tests, `fnmatch` permission-pattern matching, `[ -L ]` symlink census, `command grep` counts), file/line references independently re-read, and verbatim quotes from the referenced files and the change description. Where a claim could not be settled from inside the sandbox — specifically, the shell semantics of Claude Code's hook runner — that limitation is stated explicitly rather than resolved by assumption, and the empirical test that would settle it is named. No training-data fallback was used.
