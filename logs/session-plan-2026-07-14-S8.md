# Repo-repair session — seven harness defects (V2, post-RECONSIDER)

## Status

V1 went to `/risk-check` and came back **RECONSIDER** (Permissions/Blast-radius/Reversibility/
Hidden-coupling/Problem-reality all High). Per `audit-discipline.md`, a RECONSIDER is **not**
downgraded to push a change through. This is the redesign. Every reviewer finding was re-tested by
execution; the results are below, and they changed the plan materially.

**The reviewer was right on the biggest one, and I was wrong.**

---

## Context

Seven defects were handed over as a fix list. Re-deriving each **by execution** found that three of the
seven stated premises were false — and that my own V1 plan then carried three false consequence claims
of its own. Both sets are corrected here.

### THE HEADLINE — nine repo hooks are dead right now

`ai-resources/.claude/settings.json` wires ten hook commands as `bash $CLAUDE_PROJECT_DIR/...`,
**unquoted**. The path contains two spaces. Executed:

```
sh -c 'bash $CLAUDE_PROJECT_DIR/.claude/hooks/check-heavy-tool.sh'
  → bash: /Users/patrik.lindeberg/Claude: No such file or directory   exit 127
  → quoted: exit 0
```

**All ten wirings have never fired. Not once.** That silently includes the `[HEAVY]` tool guardrail,
the auto-QC nudge, the coach reminder, the friction auto-logger, and the Friday-checkup reminder. V1
called this quoting fix "cosmetic — works today by luck." **That was false.** It is the single
highest-value line in the change set.

**Verified safe to resurrect:** each of the nine scripts was fed a benign payload directly — **all nine
exit 0** (advisory only, none blocks). So quoting them turns on nine sound hooks, not nine landmines.
*(This mattered: `check-heavy-tool.sh` is `PreToolUse` on `Read|Grep|Bash` — had it returned 2, quoting
the path would have blocked every tool call in every session.)*

### The instrument is broken — and so were five of my own fixtures

`grep` here is **a gitignore-aware shell function**, and the workspace `.gitignore` contains
`ai-resources/`. A recursive `grep -rn` from the workspace root **silently returns zero hits inside
ai-resources** — it reports a clean repo because it cannot see the repo. **Use `command grep`.**

Separately, and worth recording because it is the session's real methodological lesson: **five fixtures
in a row produced confident, plausible, wrong results** — wrong repo variable (`CLAUDE_PROJECT_DIR`),
argv instead of stdin, a `|` delimiter colliding with event names, `timeout` not existing on macOS, and
`ls` not showing dotfiles. Each returned a clean number that *looked* like a finding. **A plausible
result from a broken instrument is indistinguishable from a real one.** Only an explicit
before/after existence check ever settled anything.

### What the evidence says — the brief's claims

| # | Brief claimed | Verified |
|---|---|---|
| **1** | "The auto-cleanup has never worked once." | **FALSE.** The SessionEnd hook is wired, fired **18×** today, and — proven against a real marker — **removes the per-id marker and keeps the shared one**, logging `REMOVED`. The 17 `NOOP marker-absent` lines are sessions that never ran `/prime`, so had no marker: correct behaviour. `/wrap-session` **also** already tears down (Step 13 / Step 7). |
| **7** | "Step 12d stages the manifest; the guard blocks it." | **REFUTED.** 12d *closes*; the commit block stages; `:407` already exempts it. **But Fix 3 would re-break it** (proven below). |
| **4** | "Findings go to friction-log, which doesn't feed the menu." | **True, wrong mechanism.** `session-feedback-collector.md:98` writes `Severity:` **only for guardrail-candidates**; `/prime` Step 3 filters *on severity*. Ordinary findings land with no severity and are **structurally invisible** to the menu. A **bare** wrap produces **zero** findings (Step 6.5 is gated off), and the collector caps improvement-log at **2/session**, overflow → a chat line that evaporates. |

### What the evidence says — my own V1 claims (the reviewer's catches)

- **"Unquoted paths work by luck"** → **FALSE.** They are dead. Corrected above; Fix 2 is now the headline.
- **"The cleanup log proves the hook works"** → **Insufficient as argued.** NOOPs prove it *runs*, not
  that it *removes*. Re-tested against a real marker: **it removes.** Claim now earned, not asserted.
- **"The deny change is a narrowing"** → **FALSE. It was a widening.** My patterns
  (`git checkout -- *`, `.`, `-f *`) would have left `git checkout HEAD -- <file>`,
  `git checkout <branch> -- <file>` and `git checkout HEAD .` **allowed** — all destructive, all denied
  today. **Fix 5 is therefore CUT from this session** (below).

### Why the marker guard blocked a "finished" session — settled

The hook removes at **SessionEnd** — when the CLI process ends (`docs/session-marker.md:227`: *"normal
exit, `/clear`, `/quit`"*) — **not** when `/wrap-session` runs. A session that wraps and leaves its
window open is **still genuinely live**, so its marker is **correctly** present and the guard is
**correctly** blocking. The guard was right; the doc explaining it is wrong. The `rm` workaround trains
the operator to delete a *correct* signal.

`docs/session-marker.md:225` also says explicitly: **"Do not add a fourth model-executed teardown
site."** So the brief's Fix-1 request is both already present *and* forbidden as a new site. What is
genuinely missing is an **override** — and closing the hole below.

### NEW defect found in Phase 0 — the liveness guard is bypassable by accident

With a live marker present, `check-destructive-liveness.sh` correctly blocks `git worktree remove`
(exit 2). But:

```
git worktree remove <path>                        → exit 2  (blocked, correct)
FOO=bar git worktree remove <path>                → exit 0  (SILENTLY BYPASSED)
env FOO=bar git worktree remove <path>            → exit 0  (SILENTLY BYPASSED)
cd /tmp && git worktree remove <path>             → exit 2  (blocked, correct)
```

Any leading env-var assignment defeats the verb regex. **This is not a designed override — it is an
open hole in the guard that exists because a session came one remark from destroying 173 lines of live
work.** Critically, the operator-chosen env-var override (`AXCION_LIVENESS_OVERRIDE=1 …`) would have
"worked" *by exploiting this bug* — shipping a feature that made the hole look intentional. **The hole
must be closed first; the override is then built on top as an explicitly recognised token.**

---

## Scope

Operator decisions (locked): grammar **accepts both** `S7` and `S7-a4f`, writes only the new form ·
installer does an **idempotent merge with backup**, touching nothing else · liveness override is an
**env var, logged**.

**Changed from V1 by this redesign:**
- **Fix 5 (deny rules) is CUT** → deferred to `/friday-act`. The reviewer proved my patterns were a
  *widening*. The operator's own brief pre-authorised this route ("run it through `/risk-check` or
  handle it in `/friday-act`"), and `/risk-check` has now spoken. A correct redesign is an **allow-list
  inversion**, which is its own change with its own gate — not a footnote to a seven-item session.
- **Fix 2 is promoted to the headline** and grows (nine dead hooks).
- **New item:** close the env-var bypass (must precede the override).

**Blast radius (verified):** `prime.md` = canonical real file, **24 symlinks point at it** → edits go
live in 24 checkouts on save. `wrap-session.md` = 22 symlinks **+ 5 real copies**; workspace-root is a
**second real file** (lockstep edit); `projects/positioning-research/` runs a **divergent non-symlink
wrap** that will not receive Fix 4. **`.codex/hooks/`** holds **independent, already-drifted real-file
copies** of `check-foreign-staging.sh` and `detect-concurrent-session.sh` — every hook edit is made
**twice** or the drift widens.

**⚠ A second session is live in this checkout.** Fixes 2/3/4 edit shared files.

---

## Phase 1 — Fix 2: the guards do not exist (headline)

1. **Quote all 10 `$CLAUDE_PROJECT_DIR` occurrences** in `ai-resources/.claude/settings.json`
   (`:45,56,69,75,86,98,108,114,124,136`). **This resurrects nine dead hooks**, all verified exit-0-safe.
2. **Move `cleanup-session-marker.sh` into git** (`ai-resources/.claude/hooks/`) — today it exists only
   at `~/.claude/hooks/` and is in no repo.
3. **New `ai-resources/logs/scripts/install-hooks.sh`** — versioned installer. Backs up
   `~/.claude/settings.json`, **merges only `hooks` entries** (python3, idempotent), resolves the repo
   root **dynamically** (today's six user-level wirings hardcode `/Users/patrik.lindeberg/...` and
   resolve on no other machine). **Must not touch any other key** — in particular `"model": "opus[1m]"`
   (`:167`), which the operator declined to remove on 2026-07-13.
4. **New `ai-resources/.claude/hooks/check-hook-wiring.sh`** — SessionStart probe, wired in
   `ai-resources/.claude/settings.json` **with a quoted path** (an unquoted probe is dead on arrival —
   precisely the bug it detects). Warns loudly when the expected hook set is unwired; names the installer.
   **It gets its own known-positive** (reviewer's point 2): a probe that exits 127 reports "all clear",
   so it must be proven to *fail loudly* against a deliberately-unwired settings file before it is trusted.

---

## Phase 2 — Fix 3: suffixed session markers (after Phase 1)

Grammar `S{N}-{id3}`. Readers accept `S\d+(-[A-Za-z0-9]{3})?`; writers emit only the new form. Then
**delete the `mkdir` claim-dir mutex** from `prime.md` — unique names make it unnecessary.

**Four breaks, each proven by execution (the reviewer independently reproduced all four):**

1. **`prime.md:321–326` (×3 copies) — the fail-safe seed dies silently.** `n="${PREV##*S}"` on
   `2026-07-14 S7-a4f` → `7-a4f`; the `*[!0-9]*` guard rejects it; **HIGH stays 0** → next allocation is
   **`S1` over an existing `S7`**, the "destructive regression" its own comment warns against.
   **Fix, tested against both grammars:** `n="${n%%-*}"` → old `S7`→7, new `S7-a4f`→7. ✔
2. **`check-foreign-staging.sh:407` — the manifest loses its exemption.** Proven end-to-end in a
   fixture: `…-S1.json` → **exit 0** (exempt today); `…-S1-a4f.json` → **exit 2**. Shipping the rename
   without this **blocks every wrap commit in 24 checkouts.** *This is the "Step 12d self-conflict" the
   brief thought already existed — a bug Fix 3 would have introduced.*
3. **`check-foreign-staging.sh:187` + header regex `:249`.** `\bS\d+\b` **silently truncates** `S7-a4f`
   → `S7` (proven: `S7-a4f` and `S7-b2c` both yield `S7`), and `:249` then matches **any** same-base
   session's header → **cross-session footprint mis-attribution.** No crash, no log.
4. **`concurrent-session-check.md:72`** hardcodes a literal `logs/session-plan-${TODAY}-S{N}.md`.

**Also required:** `foreign-session-guard.sh:140,142` (unanchored greps — a bare `S7` marker
prefix-matches an `S7-a4f` header during the mixed window; `:146–156` are `$`-anchored and safe) ·
`run-manifest.sh:175` · `session-start.md`, `session-plan.md`, both real `wrap-session.md` copies ·
fixtures `prime-allocator.test.sh`, `run-manifest.test.sh` · **`.codex/hooks/check-foreign-staging.sh`**
(lockstep) · `docs/session-marker.md`.

**Verified to survive — do not touch:** `:391` (has a `.*`); every `grep -Fxq` header check; every
`.session-marker-<id>` filename consumer (keyed by session id, not `S{N}`).

**Decide:** `decisions.md` uses a separate grammar `## 2026-07-12 (S4) —`. **Leave it unsuffixed** —
nothing keys liveness or collision-safety off it.

**Registry rot:** `docs/session-marker.md:251` names `.claude/hooks/backup-session-plan.sh` as canonical
— **that file does not exist** (only a `.codex/` copy does), and an `archive/…` symlink to it is
**dangling**. Fix the registry line; report the dangling link.

---

## Phase 3 — Fix 1: close the hole, then add the override

**Order is load-bearing.**

1. **Close the env-var-prefix bypass** in `check-destructive-liveness.sh` — the verb regex must tolerate
   leading `VAR=value` assignments and `env VAR=value`. Re-assert the known-positive afterwards.
2. **Then add the logged override**: an explicitly recognised `AXCION_LIVENESS_OVERRIDE=1` token,
   checked **after** the verb matches, which allows the command and **appends an audit line**. On block,
   the guard **prints the exact override command** — that is what stops the reach for `rm`.
3. **Correct `close-worktree-session.md:127–131`** — replace *"This guard is trustworthy… the marker is
   removed by a harness-enforced SessionEnd hook"* with the true contract: **it is a liveness oracle,
   not a "has-wrapped" oracle.** A wrapped-but-open session is live, and the guard is right to say so.
4. Reconcile canonical `wrap-session.md:300–306`, whose Step 13 prose predates the hook.

---

## Phase 4 — Fix 4: make every finding become a task

1. **`session-feedback-collector.md:98`** — require `- **Severity:**` on **every** improvement-log entry,
   not just guardrail-candidates. Without it, `/prime` Step 3's grep cannot see the finding.
2. **Kill the silent drop** (`:68–69`): overflow past the 2-entry cap becomes a single **`Deferred
   findings`** entry with severities intact, not a chat line.
3. **Core-path disposition step in both wrap copies:** every finding is either **(a)** an
   `improvement-log.md` entry **with a severity**, or **(b)** one written line saying why it is not worth
   queueing. **No silent third option.** Run **inline in the main session** (no subagent), so a **bare**
   wrap still produces a disposition.
4. Fix the stale contradiction at workspace-root `:199` (says the collector scans
   `improvement-log-archive.md`; canonical `:179` and the agent `:61` say it must not).
5. Normalize the malformed `usage-log.md` entries so its readers can parse it.

**Definition used (unanswered by operator):** "a finding" = the wrap-collector's Session Assessment
bullets + any friction event.

---

## Phase 5 — `/prime` pull step

Step 0 pulls **unconditionally** and defines **no rebase-conflict case** (only an autostash *pop*
conflict). Add: skip the pull when `git rev-list --count HEAD..@{u}` is `0`; on a rebase conflict,
`git rebase --abort`, report, and **continue orientation** rather than halting the session start.

---

## CUT from this session

**Fix 5 — deny-rule narrowing → `/friday-act`.** `/risk-check` scored Permissions **High** and showed my
proposed patterns were a **widening**, not a narrowing: they would have left `git checkout HEAD -- <file>`,
`git checkout <branch> -- <file>` and `git checkout HEAD .` allowed — all destructive, all denied today.
The correct redesign is an **allow-list inversion**, which needs its own gate. This is the one change
that can lock the operator out mid-session, and it is not worth improvising at the end of a seven-item
session. *(Live evidence it is a real problem: `Bash(rm -rf *)` blocked this session's own scratchpad
cleanup — 5th occurrence of the class. It stays queued, not silently dropped.)*

---

## Verification — by execution, never by reading the diff

1. **Fix 2** — `sh -c` the exact quoted command string → **exit 0** (today: 127). Point `HOME` at a
   scratch dir → the probe **warns**; run the installer → a synthetic destructive payload is **blocked
   (exit 2)**; re-run → **idempotent**, `model` field **untouched**. Probe must **fail loudly** against a
   deliberately-unwired settings file, not silently pass.
2. **Fix 3** — re-run the four proven fixtures and assert each now passes: `S9-aaa` vs `S9-bbb` are
   **distinguished**; a manifest `…-S9-aaa.json` is **still exempt**; `HIGH` still seeds to **9** from
   `2026-07-14 S9-aaa`; `/concurrent-session-check` finds a suffixed plan file.
3. **Fix 1** — `FOO=bar git worktree remove` must go **exit 0 → exit 2** (hole closed);
   `AXCION_LIVENESS_OVERRIDE=1 …` must **proceed and write an audit line**.
4. **Fix 4** — wrap a session with ≥3 findings: **count(findings) == count(queued-with-severity +
   declined)**, then confirm `/prime` Step 3's grep **surfaces** them.
5. **Phase 5** — `/prime` in an up-to-date repo performs **no** pull; a seeded rebase conflict aborts
   cleanly and orientation continues.

## Gate

V1 → **RECONSIDER**. This V2 addresses all four redesign points (settle hook execution: **done, they are
dead**; extend Phase 0 to the probe: **done**; answer the marker-corpse question: **done, the hook
removes**; fix the deny set: **cut to `/friday-act`**). **Re-run `/risk-check` on this V2 before Phase 1.**
