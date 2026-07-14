# Risk Check — 2026-07-14

## Change

RE-GATE of the batched repo-repair change set, V2, after V1 received RECONSIDER.

Revised spec: `logs/session-plan-2026-07-14-S8.md`. V2 = V1 minus Fix 5 (deny rules, cut to
`/friday-act`), plus a promoted headline (Fix 2: "nine repo hooks are dead right now"), plus a new
item (close the env-var-prefix bypass in `check-destructive-liveness.sh` before adding the override).

The four prior redesign points and what the main session claims it did:

- **P1** — settle the hook-execution question first → claims CONFIRMED the reviewer was right:
  `sh -c 'bash $CLAUDE_PROJECT_DIR/...'` → exit 127; all ten repo-level wirings are dead and have
  never run; quoting is now the headline. Also claims all 9 scripts exit 0, so resurrection is safe.
- **P2** — extend Phase 0 to give `check-hook-wiring.sh` its own known-positive → claims done.
- **P3** — answer the marker-corpse question before the (a)/(b) scope cut → claims done: the hook
  removes a real marker; the corpse is wrapped-but-window-still-open.
- **P4** — fix the deny set → ACCEPTED IN FULL; Fix 5 cut; no permissions change.

## Referenced files

- `ai-resources/logs/session-plan-2026-07-14-S8.md` — exists (change spec)
- `ai-resources/audits/risk-checks/2026-07-14-batched-repo-repair-marker-grammar-hook-wiring-deny-rules.md` — exists (V1 report)
- `ai-resources/.claude/settings.json` — exists
- `~/.claude/settings.json` — exists
- `.claude/settings.json` (workspace root) — exists
- `ai-resources/.claude/hooks/check-heavy-tool.sh` — exists
- `ai-resources/.claude/hooks/log-write-activity.sh` — exists
- `ai-resources/.claude/hooks/coach-reminder.sh` — exists
- `ai-resources/.claude/hooks/improve-reminder.sh` — exists
- `ai-resources/.claude/hooks/auto-qc-nudge.sh` — exists
- `ai-resources/.claude/hooks/friction-log-auto.sh` — exists
- `ai-resources/.claude/hooks/check-destructive-liveness.sh` — exists
- `ai-resources/.claude/hooks/check-foreign-staging.sh` — exists
- `ai-resources/.codex/hooks/check-foreign-staging.sh` — exists
- `~/.claude/hooks/cleanup-session-marker.sh` — exists
- `~/.claude/hooks/cleanup-session-marker.log` — exists
- `ai-resources/docs/session-marker.md` — exists
- `ai-resources/logs/friction-log.md` — exists
- `ai-resources/.claude/commands/{prime,wrap-session,session-start,session-plan,concurrent-session-check,close-worktree-session}.md` — exist
- `ai-resources/logs/scripts/{foreign-session-guard,run-manifest}.sh` — exist
- `ai-resources/logs/scripts/install-hooks.sh` — **not yet present**
- `ai-resources/.claude/hooks/check-hook-wiring.sh` — **not yet present**

The two `not yet present` files are evaluated from described intent only, flagged inline under
Dimensions 1, 4, 5, 6 and 7.

## Verdict

**RECONSIDER**

**Summary:** V2 is a materially better plan than V1 — P4 is fully honoured (I verified: zero
permissions edits), the new env-var-bypass defect is real and *larger* than the plan states, and the
plan's headline symptom ("the repo hooks do not fire") is **correct — I confirmed it independently
by a different route**. But P1 was answered with a *shell* fixture, not a *harness* observation, and
that gap is load-bearing: the plan's causal diagnosis (word-splitting) is one of **three** live
explanations for the dead hooks, and under the other two the proposed quoting fix **changes nothing**
— while the plan's own verification step cannot tell the difference. The new probe is wired through
that same unproven mechanism, so it fails open exactly as the V1 reviewer warned. Dimension 7 is High
on the *fix*, not the symptom, and that alone forces RECONSIDER.

---

## Consumer Inventory

Built with `command grep` throughout (the shell-function `grep` is gitignore-aware and returns 0 hits
inside `ai-resources/`; the caller's warning is confirmed). Symlinks tested with `[ -L ]`, never `[ -f ]`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` | parses + writes (allocator ×3; Step 0 pull) | **yes** |
| **24 live symlinks → `prime.md`** | imports (propagate on save) | no — auto |
| `ai-resources/.claude/commands/session-start.md` | writes marker/header | **yes** |
| `ai-resources/.claude/commands/session-plan.md` | writes plan filename | **yes** |
| `ai-resources/.claude/commands/wrap-session.md` (canonical) | parses + Step 13 teardown + Phase 4 | **yes** |
| `.claude/commands/wrap-session.md` (workspace root, **REAL file**, `[ -L ]` false) | co-edits (lockstep) | **yes** |
| **22 live symlinks → `wrap-session.md`** | imports (propagate on save) | no — auto |
| `projects/positioning-research/.claude/commands/wrap-session.md` | **divergent REAL copy** — will not receive Fix 4 | no (plan's own admission) |
| `ai-resources/.claude/commands/concurrent-session-check.md` (`:72`) | parses | **yes** |
| `ai-resources/.claude/commands/close-worktree-session.md` (`:127–131`) | documents (false trustworthiness claim) | **yes** |
| `ai-resources/.claude/hooks/check-foreign-staging.sh` (`:187`, `:249`, `:407`) | parses | **yes** |
| `ai-resources/.codex/hooks/check-foreign-staging.sh` | parses (**independent REAL file**, drifted) | **yes** |
| `ai-resources/logs/scripts/foreign-session-guard.sh` (`:140`, `:142`) | parses (unanchored grep) | **yes** |
| `ai-resources/logs/scripts/run-manifest.sh` (`:175`) | writes (`${DATE}-${MARKER}.json`) | **yes** |
| `ai-resources/logs/scripts/prime-allocator.test.sh` | parses (fixture) | **yes** |
| `ai-resources/logs/scripts/run-manifest.test.sh` | parses (fixture) | **yes** |
| `ai-resources/docs/session-marker.md` | documents (registry; `:251` names a missing file) | **yes** |
| `ai-resources/.claude/agents/session-feedback-collector.md` | co-edits (severity-on-every-entry) | **yes** |
| `ai-resources/.claude/settings.json` | co-edits (**10** unquoted `$CLAUDE_PROJECT_DIR` + new probe wiring) | **yes** |
| `~/.claude/settings.json` | co-edits (`:147` SessionEnd wiring; installer target; `:167` `"model"` must survive) | **yes** |
| `~/.claude/hooks/cleanup-session-marker.sh` | co-edits (moved into git — **see D5 hazard**) | **yes** |
| `ai-resources/.claude/hooks/check-destructive-liveness.sh` | co-edits (bypass close + override) | **yes** |
| `ai-resources/logs/usage-log.md` | co-edits (normalize malformed entries) | **yes** |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | imports contract (`.session-marker-<id>` filename) | no — survives |
| `ai-resources/.codex/hooks/detect-concurrent-session.sh` | REAL copy, documented **dead duplicate** | no |

**Total: 25 consumers, 18 must-change.**

**Contracts introduced by the two `not yet present` files — all have ZERO current consumers**
(`command grep -rlI`): `check-hook-wiring` → **3** files (V1 report, session-notes, the plan itself);
`install-hooks` → **4** files (all planning/consult docs); `AXCION_LIVENESS_OVERRIDE` → **1** file
(the plan). No runtime consumer exists for any of the three. This is expected for new detection +
its installer, and is scored under D6, not held against the change.

**Consumer the change description did not anticipate:** `~/.claude/settings.json:147` — the live
SessionEnd wiring that points at `$HOME/.claude/hooks/cleanup-session-marker.sh`, the file Phase 1
item 2 proposes to **move**. See Dimension 5.

**Also newly derived:** `.codex/hooks/` contains **no** `check-destructive-liveness.sh` copy — so
Phase 3's hook edit has no mirror to keep in lockstep. The plan is correct to name only
`check-foreign-staging.sh` and `detect-concurrent-session.sh` as the two `.codex` mirrors.

---

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- **The change turns on per-tool-call hook execution that does not happen today, and the plan never
  costs it.** Quoting resurrects 2 PreToolUse matchers (`Read|Grep|Bash` → `check-heavy-tool.sh`;
  `Skill` → `friction-log-auto.sh`) and 2 PostToolUse matchers (`Write|Edit` → `log-write-activity.sh`
  + `auto-qc-nudge.sh`; `Bash|Write|Edit|Agent|Skill` → `friction-log-auto.sh`). By the letter of the
  rubric ("adds a hook that runs per tool call (PreToolUse)") that is High.
- **Measured, it is modest — which is why I score Medium, not High.** `check-heavy-tool.sh` walks the
  entire transcript JSONL on *every* Read/Grep/Bash call (`last_real_user_prompt`: `for line in f:
  json.loads(line)`). Executed against the largest transcript in this project
  (`a4d7fb1e-….jsonl`, 3.0M, 902 records): **0.01 s** per full scan. Well inside the hook's `"timeout": 5`.
  The residual cost is a `python3` spawn per matching tool call plus `[HEAVY]` `additionalContext`
  token injections on matching calls, and four Stop hooks emitting `systemMessage` chatter per turn.
- **Real, unnamed side effect:** `log-write-activity.sh` appends `- HH:MM — <path>` to
  `logs/friction-log.md` on **every** Write/Edit (no `is_error` filter, no path filter beyond the
  friction/improvement-log recursion guard). Once quoted, the friction log resumes accumulating
  write-activity noise, as it demonstrably did in May 2026. The plan verified exit codes; it did not
  evaluate what nine hooks *do* once running.
- New `check-hook-wiring.sh` is SessionStart — once per session, not per tool call. Correct tier.
  (Evaluated from described intent; file `not yet present`.)
- `install-hooks.sh` is operator-invoked, pay-as-used → no ongoing cost.
- No always-loaded `CLAUDE.md` additions, no new `@import` chain, no new frequently-spawned subagent.

### Dimension 2: Permissions Surface
**Risk:** Medium

- **P4 is fully honoured — verified. The V2 plan makes ZERO permissions edits.** I grepped the plan
  for every permission token (`deny|permission|allow\(|Read\(logs|git checkout|settings.json`): every
  hit is either in the retrospective ("my V1 claims were wrong") or in the **CUT** section. The
  `permissions` blocks are untouched.
- The deny rules Fix 5 would have widened are confirmed **still in place and unchanged**:
  `~/.claude/settings.json:47` → `"Bash(git checkout *)"`; workspace-root `.claude/settings.json:27`
  → `"Bash(git checkout *)"`. Nothing in V2 touches either.
- Live corroboration that the deny set enforces: my own `rm -rf` in a scratch fixture was **blocked
  by the permission system** during this review (`Bash(rm -rf *)`, `ai-resources/.claude/settings.json:23`).
- **Residual, and the reason this is not Low:** `install-hooks.sh` is a repo-versioned script that
  writes `~/.claude/settings.json` — the **user-level** file, outside the repo and outside git. That
  is a new project → user cross-layer write capability. The plan constrains it well (backup, python3
  idempotent merge, `hooks` key only). `"model": "opus[1m]"` confirmed present at
  `~/.claude/settings.json:167` — operator declined its removal on 2026-07-13, and the installer must
  not touch it. (Evaluated from described intent; file `not yet present`.)
- V1's `Read(logs/*archive*.md)` narrowing (`ai-resources/.claude/settings.json:30`) is **silently
  absent** from V2 — dropped along with Fix 5. Benign (it was a correct diagnosis of a real read
  blocker), but it is now unqueued rather than deferred. Worth one line in the wrap note.

### Dimension 3: Blast Radius
**Risk:** High

- **25 consumers, 18 must-change** (Step 1.5 inventory). Rubric threshold for High (>5 callers, or
  *any* caller requiring modification) is exceeded by a wide margin.
- **Symlink census re-derived independently with `[ -L ]`** — matches the plan and the V1 report
  exactly: `prime.md` → **24 live symlinks / 3 real files / 0 dangling**; `wrap-session.md` → **22
  live symlinks / 5 real files / 0 dangling**; workspace-root `.claude/commands/wrap-session.md` is a
  **REAL file, not a symlink** (lockstep co-edit). `prime.md` edits go live in 24 checkouts on save.
- **The marker-grammar change is a non-backwards-compatible *writer* contract with a hard ordering
  hazard**, and the plan found it: `run-manifest.sh:175` writes `${DATE}-${MARKER}.json`;
  `check-foreign-staging.sh:407` exempts manifests via `\d{4}-\d{2}-\d{2}-S\d+\.json$`, which does not
  match `2026-07-14-S7-a4f.json`. If any writer emits the suffixed form before `:407` is widened,
  every wrap commit is blocked in 24 checkouts. Readers must land before writers; the phases cannot be
  partially landed.
- **A second session is live in this checkout right now**, and Phases 1/2/3/4 all edit shared files.
  DR-10 is directly on point. The plan flags this (`:125`) but does not sequence around it.
- `.codex/hooks/check-foreign-staging.sh` re-confirmed as an **independent REAL file** (not a
  symlink) — every hook edit is made twice or the drift widens.
- **Blast-radius finding the plan does not name:** `~/.claude/settings.json:147` wires the SessionEnd
  teardown as `bash "$HOME/.claude/hooks/cleanup-session-marker.sh"`. Phase 1 item 2 proposes to
  **move** that file into git. See Dimension 5 — this is the sharpest unnamed edge in the set.

### Dimension 4: Reversibility
**Risk:** Medium

- **Cutting Fix 5 removed the one genuinely irreversible item.** V1 was High here largely because a
  bad deny set can lock the operator out of the session that wrote it. That risk is gone. This is the
  single biggest improvement in V2 and it is real.
- **State still propagates beyond git, in two places**, so a `git revert` does not fully restore:
  1. `install-hooks.sh` writes `~/.claude/settings.json` (unversioned). Rollback = restore from the
     script's own backup. One documented manual step.
  2. Phase 1 item 2 removes `~/.claude/hooks/cleanup-session-marker.sh` from an unversioned location.
     A repo revert does not put it back. Second manual step.
- Residue a revert would leave: `logs/runs/2026-07-14-S{N}-{id3}.json` manifests and suffixed
  `session-notes.md` headers written during the mixed-grammar window. Readers accept both forms
  (`^## DATE — Session S[0-9]+` matches both), so these degrade harmlessly rather than breaking.
- The git-tracked half reverts cleanly — the 24 `prime.md` / 22 `wrap-session.md` symlinks propagate
  a revert exactly as they propagate the edit.

### Dimension 5: Hidden Coupling
**Risk:** High

- **(1) The probe's own execution depends on the very mechanism whose behavior is unproven — P2 is
  NOT genuinely closed.** The plan's known-positive for `check-hook-wiring.sh` is: *"Point `HOME` at a
  scratch dir → the probe **warns**… Probe must **fail loudly** against a deliberately-unwired settings
  file"* (`:245–246`). That tests the probe's **script logic**, by invoking the script directly. It does
  **not** test the probe's **liveness** — whether the harness invokes it at all. The probe is wired into
  `ai-resources/.claude/settings.json`, the same file whose ten hook wirings currently do not execute
  (D7). If the cause is anything other than quoting, the quoted probe is *also* dead, prints nothing,
  and its silence is indistinguishable from "all hooks correctly wired." That is a fail-open guard —
  precisely the failure the V1 reviewer named, and the plan's answer does not reach it.
- **(2) Phase 1 item 2 can silently kill the only reliable marker teardown.** Verified:
  `~/.claude/settings.json:147` = `"command": "bash \"$HOME/.claude/hooks/cleanup-session-marker.sh\""`.
  The file exists **only** at `~/.claude/hooks/` (confirmed: absent from `ai-resources/.claude/hooks/`).
  The plan says *"**Move** `cleanup-session-marker.sh` into git"* (`:133`) and sequences that as item 2,
  **before** the installer (item 3) that would rewire the path. If the move happens without the
  lockstep rewiring, the SessionEnd command 127s — and SessionEnd **cannot block**, so it fails
  silently. `docs/session-marker.md` calls this hook *"the RELIABLE path"* and says the two
  model-executed teardowns are *"redundant fast paths"* that are *"demonstrably skipped"*. Killing it
  reinstates marker corpses on every session → `check-destructive-liveness.sh` false-fires → the
  operator reaches for the `rm` workaround the change exists to eliminate. The plan does not name
  this coupling, does not state copy-vs-move, and does not order the rewiring.
- **(3) The nine resurrected hooks have side effects nobody has observed in months.** The plan
  verified only exit codes ("all nine exit 0"). It did not verify what they *write*:
  `log-write-activity.sh` mutates `logs/friction-log.md` on every Write/Edit;
  `auto-qc-nudge.sh` / `coach-reminder.sh` / `improve-reminder.sh` / `auto-resolve-nudge.sh` touch
  `/tmp` sentinels and emit `systemMessage` chatter; `friction-log-auto.sh` `sed -i`'s the friction log.
- **(4) The writer/reader filename contract** `run-manifest.sh:175` ↔ `check-foreign-staging.sh:407`
  is co-located in neither file and documented at neither end. The plan found it; the coupling remains
  undocumented.
- **(5) `foreign-session-guard.sh:140,142`** use unanchored `grep -c "^## ${MARKER_DATE} — Session ${MARKER}"`
  — a bare `S7` prefix-matches an `S7-a4f` header during the mixed-grammar window. Plan's claim confirmed.
- **Genuine positive:** the plan's Phase 3 ordering — *close the env-var hole first, then add the
  override on top as an explicitly recognised token* — is **correct and important**, and I endorse it.
  Shipping the override first would have made the bug look like a feature. See D7.

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles read from `projects/strategic-os/ai-strategy/principles-base.md` (present) and
`docs/ai-resource-creation.md` rule #7.

- **OP-12 (closure before detection) — SATISFIED.** `check-hook-wiring.sh` is new *detection*, but it
  ships in the same phase as its *closure channel*: the plan (`:142`) requires it to "name the
  installer," and `install-hooks.sh` is that installer. Detection behind closure, not ahead of it.
- **Complexity budget (`ai-resource-creation.md` rule #7) — PASSES prong (b).** Two net-additive
  components, so prong (a) net-simplification fails. Prong (b) requires *cited written evidence* of the
  failure mode: it exists and is specific — `logs/friction-log.md` (S5 block) names the owner artifact
  as *"`~/.claude/hooks/cleanup-session-marker.sh` + its SessionEnd wiring (the unversioned wiring is
  itself the open HIGH item of 2026-07-14)"* and asks as prevention (c) for *"an explicit, logged
  operator-override input rather than one that works by erasing its own evidence"* — which is exactly
  Phase 3. Evidence-driven, not speculative.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — mild tension, named, not a violation.** The
  contracts the two new files introduce have **zero current consumers** (inventory: 3/4/1 files, all
  planning docs). Normally a speculative-abstraction signal. Here the present-tense defect is real and
  independent of any second machine: six guards are wired only in an unversioned file by hardcoded
  absolute path, so a `~/.claude/` reset silently disarms them while the repo still looks guarded.
- **OP-5 (advisory ≠ enforcement) — tension, recorded.** Phase 4's wrap-session CORE-PATH rule
  ("every finding is either queued-with-severity or explicitly declined — no silent third option") adds
  a mandatory disposition stage. It still advises-and-stops rather than auto-correcting, and the
  operator made the call explicitly (plan `:106`, "Operator decisions (locked)") — a recorded decision,
  not drift.
- **OP-11 (loud revision, never silent drift) — SERVED, and this deserves credit.** The plan opens
  with *"The reviewer was right on the biggest one, and I was wrong"* (`:10`) and enumerates its own
  three false consequence-claims. That is the correct posture, and it is why this re-gate could be
  scoped to what actually changed.
- **DR-10 — engaged.** A second session is live in this checkout; Phases 1–4 edit shared files.

### Dimension 7: Problem Reality
**Risk:** **High**

**Defect — observed or inferred?** The *symptom* is **observed, and I confirmed it independently by a
route the plan did not use.** Full credit to the plan here — but I had to work to get there, because the
plan's own evidence is confounded.

- Re-derived the count: `command grep -c 'CLAUDE_PROJECT_DIR' .claude/settings.json` → **10**. Matches.
- **The apparent evidence that the hooks DO fire is a mirage — and it is the main session's own
  fixtures.** `logs/friction-log.md:356` carries `- 19:59 — README.md`, which is exactly
  `log-write-activity.sh`'s output format (`- ${NOW} — ${REL_PATH}`), and `git blame` shows it as
  **"Not Committed Yet", dated 2026-07-14**. Two `/tmp/claude-coach-reminded-*` sentinels exist,
  mtimes **19:58:46** and **19:59:02**. `coach-reminder.sh` and `log-write-activity.sh` are wired in
  **exactly one** settings layer — the unquoted `ai-resources/.claude/settings.json` (verified across
  managed / user / workspace / ai-resources / `.local` layers). Taken at face value, that says the
  hooks run. **It is not what it looks like.** `ai-resources/README.md` **does not exist** — a classic
  benign test payload — and the timestamps sit inside the window in which the plan says *"I ALSO tested
  all 9 hook scripts directly with benign payloads."* These artifacts are the *tests*, not the harness.
- **What actually settles it:** the script is functional, and no real tool call produces its output.
  I ran `log-write-activity.sh` in a clean scratch fixture with a correct payload → **exit 0, and it
  appended `- 20:10 — probe.md`**. So the script works. Yet: the main session **edited
  `logs/session-notes.md` (mtime 19:42:37)** and **wrote `logs/session-plan-2026-07-14-S8.md`
  (mtime 20:01:28)**, and **neither produced a friction-log entry**. `auto-qc-nudge.sh` fires on the
  same `Write|Edit` matcher for files ≥50 lines; the ~260-line plan file would have touched
  `/tmp/claude-auto-qc-*` — **no such sentinel exists**. My own Write during this review produced
  nothing either. **Conclusion: the PostToolUse wirings in `ai-resources/.claude/settings.json` do not
  execute. The plan's headline symptom is REAL.**

**Consequence — traced or assumed?** **Assumed — and this is where the change breaks.** The plan does
not merely claim "the hooks are dead"; it claims **"quoting resurrects nine dead hooks… the single
highest-value line in the change set"** (`:34–35`). That is a claim about a **cause**, and it is not
traced. There are **three** live explanations for the dead hooks, and the plan's fix only addresses one:

| # | Cause | Does quoting fix it? |
|---|---|---|
| **C1** | Unquoted `$CLAUDE_PROJECT_DIR` word-splits on the 2-space path → 127 (**the plan's diagnosis**) | **Yes** |
| **C2** | `CLAUDE_PROJECT_DIR` is unset/empty in the hook env → `bash /.claude/hooks/x.sh` → 127 | **No** — `bash "/.claude/hooks/x.sh"` is still 127 |
| **C3** | The `ai-resources` settings hooks block is not loaded for these sessions at all | **No** |

- **C2 is not excluded, and there is affirmative evidence for it.** `env | grep '^CLAUDE'` in this
  environment returns `CLAUDECODE`, `CLAUDE_CODE_SESSION_ID`, `CLAUDE_CODE_ENTRYPOINT`, … and
  **`CLAUDE_PROJECT_DIR` is UNSET**. Further: **every hook in this system that demonstrably fires is
  wired with an absolute path or `$HOME` — never `$CLAUDE_PROJECT_DIR`** (`~/.claude/settings.json`
  :61/:67/:79/:89/:102/:113 hardcode absolute paths; :147 uses `"$HOME/…"`). And **every hook script
  that reads the variable does so defensively** — `os.environ.get("CLAUDE_PROJECT_DIR","") or
  os.getcwd()` (`check-foreign-staging.sh:153`, `check-destructive-liveness.sh:195`) and
  `${CLAUDE_PROJECT_DIR:-$(pwd)}` (`coach-reminder.sh:9`, `improve-reminder.sh:9`). There is **zero
  positive evidence anywhere in this repo that `$CLAUDE_PROJECT_DIR` ever resolves inside a hook
  command string** — the fallbacks mean the firing hooks would work identically if it were empty.
- **The plan's test does not discriminate.** `sh -c 'bash $CLAUDE_PROJECT_DIR/…'` → 127 proves that
  **`sh` word-splits**. It does not prove that Claude Code's hook runner is `sh`. Executed here:
  `zsh -c 'bash $CLAUDE_PROJECT_DIR/.claude/hooks/check-heavy-tool.sh'` → **exit 0**, because **zsh
  does not word-split unquoted parameter expansions** — and zsh is this operator's shell (the repo's
  own memory rule states "Bash-tool runs via zsh"). Under zsh, C1 cannot be the cause at all. The
  plan's fixture was run with the variable **manually exported by the tester**, which begs the exact
  question at issue.
- **And the plan's verification cannot catch the failure.** § Verification item 1 is: *"`sh -c` the
  exact quoted command string → **exit 0** (today: 127)."* That re-runs the same shell-level fixture
  with the variable exported. It will return exit 0 under C1, C2 **and** C3 — i.e. it reports success
  even when the change has done nothing. Combined with D5(1) — the probe wired through the same
  mechanism, whose silence reads as "all clear" — the change would land, self-report green, and leave
  nine hooks dead.

**Re-derivation vs. the change description:**

| Claim | Verdict |
|---|---|
| 10 unquoted `$CLAUDE_PROJECT_DIR` occurrences | **Confirmed** (`command grep -c` → 10) |
| The repo-level hooks do not fire | **CONFIRMED — independently, and the plan is right.** Script functional in fixture; zero artifacts from real writes; no `auto-qc` sentinels |
| "`sh -c …` → exit 127; quoted → exit 0" | **Reproduced** — but under `zsh -c` the *unquoted* form is **exit 0**. The test identifies `sh`'s behavior, not the harness's |
| **"Quoting resurrects nine dead hooks"** | **NOT ESTABLISHED.** Two of three live causes (C2, C3) are unexcluded and defeat the fix. `CLAUDE_PROJECT_DIR` is unset in the tool env; no firing hook anywhere uses it in its wiring |
| "All nine exit 0 → safe to resurrect" | **Confirmed as to exit codes** — but the plan checked only exit codes, not side effects (friction-log mutation, `[HEAVY]` injection, `/tmp` sentinels, Stop-hook chatter). See D1/D5(3) |
| **Env-var bypass of `check-destructive-liveness.sh`** | **CONFIRMED — and WORSE than stated.** `_VB = r'(?:^|[\n;&\|(])\s*'` requires `git` at a command boundary. Executed against the real regexes: `FOO=bar git worktree remove` → **BYPASS**; `env FOO=bar …` → **BYPASS**; `AXCION_LIVENESS_OVERRIDE=1 git worktree remove` → **BYPASS**; `cd /tmp && git worktree remove` → BLOCK. The plan names only `worktree remove`; **all four gated verbs are bypassable**: `FOO=1 git reset --hard HEAD` → BYPASS, `FOO=1 git clean -fd` → BYPASS, `FOO=1 git branch -D x` → BYPASS. The plan's ordering (close the hole, *then* add the override) is **correct** |
| P3 "the hook DOES tear down; the 17 NOOPs are sessions that never primed" | **PARTIAL.** The removal *logic* works — but the two new `REMOVED` lines (`cleanup-session-marker.log:19–20`, 19:59:20 / 19:59:37) are **synthetic scratchpad fixtures** (`scratchpad/se-xO70La/…/.session-marker-eeeeeeee-1111-2222-3333-444444444444`) — the **same evidence class the V1 reviewer already rejected**. In the hook's entire 20-line log (cap 100, no truncation) there is still **not one production `REMOVED`** |
| P3 "the S3 corpse = wrapped-but-window-still-open" | **Plausible, not traced.** The log contains **zero** entries for the corpse session `f928a89d` and **zero** for *any* session in the research-workflow worktree, while carrying 17 production entries for ai-resources and buy-side-service-plan the same day. Consistent with "window still open"; equally consistent with "SessionEnd never fired there." Does not gate the change — the plan's compensating corrections (`close-worktree-session.md:127–131`, the logged override) address the operator-facing harm either way |
| P4 "no permissions change" | **Confirmed in full.** Zero permissions edits; `Bash(git checkout *)` intact at `~:47` and root `:27` |
| Symlink census 24 / 22+5 / root copy is REAL | **Confirmed exactly** (`[ -L ]`) |
| `.codex/` = independent drifted real files | **Confirmed**; also: `.codex/` has **no** `check-destructive-liveness.sh`, so Phase 3 has no mirror |

**Bottom line for D7.** The plan diagnosed the *symptom* correctly and I verified it. But the V1
reviewer's P1 asked it to *settle the hook-execution question*, and named the test: **"wire one
throwaway hook … that `touch`es a sentinel path, once unquoted and once quoted, and observe which
sentinel appears."** That test was **not run.** A shell fixture was run instead — and a shell fixture
cannot see the harness. This is the sixth instance of the exact error the plan itself diagnoses on
`:52`: *"A plausible result from a broken instrument is indistinguishable from a real one."* The
instrument here is `sh -c` standing in for a hook runner it is not.

---

## Recommended redesign

- **Run the harness-level sentinel test FIRST, before any of Phase 1 — it is one session restart and
  it decides whether Phase 1 has any value at all.** Add two throwaway hooks to
  `ai-resources/.claude/settings.json`: (a) `touch "/tmp/hooksentinel-abs"` with a **hardcoded, quoted,
  absolute** path, and (b) `touch "$CLAUDE_PROJECT_DIR/../hooksentinel-var"` with a **quoted
  `$CLAUDE_PROJECT_DIR`** path. Restart the session and look:
  **neither sentinel** → the settings layer's hooks are not loaded (C3): quoting fixes nothing and the
  probe would be dead too — the whole of Fix 2 must be redesigned;
  **only `-abs`** → `CLAUDE_PROJECT_DIR` is unset/empty in the hook env (C2): the fix is an absolute
  path or a `${CLAUDE_PROJECT_DIR:-<resolved-root>}` guard, **not** quotes;
  **both** → C1 confirmed, the plan's diagnosis is right, and Phase 1 proceeds exactly as written.
  Only after this is the claim "quoting resurrects nine dead hooks" an observation rather than an
  inference — and only then can `check-hook-wiring.sh` be trusted not to fail open.

- **Re-base the probe's known-positive on liveness, not on script logic.** The plan's known-positive
  (point `HOME` at a scratch dir, assert the probe warns) proves the script works — which was never in
  doubt. Replace/augment it with an **end-to-end** assertion: after the fix, perform one real `Write`
  in a real session and assert a hook-produced side effect appears (a new `- HH:MM — <file>` line in
  `logs/friction-log.md`, or a `/tmp/claude-auto-qc-*` sentinel). **Silence must be graded as failure,
  never as "all clear."** Note in the plan that the artifacts currently in `friction-log.md:356` and
  `/tmp/claude-coach-reminded-*` are the session's **own fixtures**, not harness output — they must not
  be counted as evidence of firing.

- **COPY `cleanup-session-marker.sh` into git; do not MOVE it — and rewire `~/.claude/settings.json:147`
  in the same operation, verified by a real SessionEnd before the original is deleted.** As sequenced
  (item 2 moves the file, item 3 later rewires), there is a window in which the only *reliable* marker
  teardown 127s silently — and SessionEnd cannot block, so nothing reports it. That reinstates the
  marker corpses and the `rm` guard-defeat path this whole change set exists to close.

- **Optional, cheap, and it strengthens the plan:** widen the Phase 3 bypass fix to cover all four
  gated verbs, not just `git worktree remove` — I reproduced `FOO=1 git reset --hard`,
  `FOO=1 git clean -fd` and `FOO=1 git branch -D` as bypasses too. The plan's fix (tolerate leading
  `VAR=value` / `env VAR=value` in `_VB`) closes all four at once if it is applied to the shared prefix
  rather than to `RE_WORKTREE` alone.

---

## Evidence-Grounding Note

All risk levels grounded in direct evidence: executed commands with their actual output (`command grep`
counts across every settings layer; `git blame` / `git log -S` / `git show` on the wiring's history;
`[ -L ]` symlink census; a clean-room scratch-fixture run of `log-write-activity.sh`; a live `Write`
probe; `stat` mtimes on `/tmp` sentinels and repo files; the four gated-verb regexes reproduced against
nine command forms in python3; a timed full-transcript scan), plus file/line references independently
re-read and verbatim quotes from the plan and the referenced files. Where a claim could not be settled
from inside the sandbox — specifically, whether `$CLAUDE_PROJECT_DIR` is populated in Claude Code's
**hook** environment — that limitation is stated explicitly rather than resolved by assumption, and the
one test that would settle it is named. Two artifacts I created are disclosed: a scratchpad probe file,
and a scratch fixture under the session scratchpad. Neither touched a referenced file. No training-data
fallback was used.
