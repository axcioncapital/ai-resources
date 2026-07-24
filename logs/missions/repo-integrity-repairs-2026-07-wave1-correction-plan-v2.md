# Wave 1 correction plan — v2 (incorporates two Codex rounds) — mission `repo-integrity-repairs-2026-07`

**Date:** 2026-07-24 · **Supersedes:** v1 (`audits/working/2026-07-24-wave1-correction-plan.md`, gitignored) · **Status:** revised implementation plan — **nothing implemented**
**Reviewed against:** `origin/main` at `2dbd599` (the commit Codex inspected) plus live disk. **Codex rounds folded in: R1 (nine findings) and R2 (four findings).**
**Scope:** Wave 1, threads 1–10. Wave 2 (11–16) and sibling mission `repo-health-backlog-2026-07` untouched.
**This file is git-tracked** (v1 was not — it sat in gitignored `audits/working/`, which is why Codex could not see it).

---

## 0. What changed — and why

Every Codex finding across both rounds was triaged against current repo evidence, not accepted on sight. The net effect is a **leaner and more correct** plan: wrap-time machinery removed in favour of one commit-boundary check, one prose fix parked, two obsolete rationales scheduled for repair.

### Round 2 changes (this revision)
| Thread | R1 plan said | R2 finding | Verified? | Now does |
|---|---|---|---|---|
| 3 | Change settings.json + permission-template.md | Two commands cite the deny as load-bearing: `improve.md:21` excludes the archive *because of it*; `resolve-improvement-log.md:119-126` calls it load-bearing | **Yes** — read both | Also repair both commands' rationale in the same change; **keep append-only archival** on its data-integrity merit |
| 4 | Wire tail-checks at 4 wrap sites | Wrap-time is **too late** — the recorded failure shipped in a **mid-session commit** (`c3d5fe7`); and checking only the final header misses an earlier misplaced entry | **Yes** — `c3d5fe7` prepended `decisions.md` at line 2, committed mid-session | **Move to the commit boundary** (extend the same pre-commit hook); check **every** newly-added entry, not just the last; drop the wrap-time wiring and the usage-log refactor |
| 9 | Bounded-disclosure rewrite of CLAUDE.md:52 | Disclosure prose still doesn't **enumerate** conflicting decisions — it doesn't correct the accepted problem | Accepted (judgment) | **Park without closing**; remove the prose change entirely; correct the mechanism target on the thread |
| 10 / tests | Close both; cite `:853/:867/:1159` | Those numerics are stale even vs the pinned commit (`848/862/1154`); and the `/log-sweep` write test would hit live shared logs | **Yes** — working-tree/commit drift reproduced | Cite **stable headings only**, no line numbers; every write test runs in an **isolated temp repo** |

### Round 1 changes (prior revision, retained)
| Thread | v1 said | R1 finding | Now does |
|---|---|---|---|
| 1–2 | Honour `CLAUDE_PROJECT_DIR`; NOTICE+`exit 0`; "17 copies safe" | `/log-sweep` calls the script with **no** target → silent no-op; don't claim copies safe | Require the target; **`exit 1`** on no target; fix the `/log-sweep` caller; narrow the copy claim |
| 3 | Glob cleanup only | Genuine archives stay denied → doesn't fix the accepted problem | **Remove `logs/` archive denial** entirely; assertion met |
| 5 | Close (+ optional canary add) | Closure supported | Close; **drop** the optional add |
| 6 | Command edit **+ reviewer edit** | Reviewer edit redundant with Dimension 7 | Keep command edit; **drop** reviewer edit |
| 7 | "prevents" drift | Advisory, not enforcement | Keep nudge; **label advisory**; narrow test |
| 8 | Hook guard incl. `=======` | Right boundary; settle marker policy; coverage checkout-local | `exit 1`; **exclude `=======`** (setext collision); disclose limit |

**One standing disagreement, restated (thread 6).** Codex R1 was right to cut the *reviewer* edit; I keep the one-line *command-side* scope clause, because the reviewer's Dimension 7 fires only **after** a 150k–220k-token dispatch, whereas the command check catches the error before paying for it. Different choke points, not duplication.

---

## 1. Threads 1 + 2 — wrong-repo log archival

### Accepted causal mechanism
`logs/scripts/check-archive.sh:11-14` derives its **archive target** from `$0` (its own location), so it archives whichever repo the running copy lives in — not the caller's project. The caller already passes the right answer and the script discards it: [wrap-session.md:31](ai-resources/.claude/commands/wrap-session.md#L31) runs `CLAUDE_PROJECT_DIR="$(pwd)" bash …`, and the script explicitly declines to read it. Conflating the **tool path** (`split-log.sh`, correctly `$0`-relative) with the **data/target path** (the caller's logs) is the defect. Thread 2's "13 missing dirs force a walk-up" premise is false — the committed caller has no walk-up (bare relative path, `exit 127`); the one real wrong-repo write came from a session *improvising* one.

### Exact correction — the caller names the target; the script does not guess
**a) `logs/scripts/check-archive.sh`** — replace `$0`-target resolution (lines 11–14):
```bash
# Tool path: this script's own directory (split-log.sh is a sibling — $0 is correct here).
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SPLIT="$SCRIPT_DIR/split-log.sh"

# Data/target path: the CALLER's project. NOT guessed from $0 or pwd.
if [ -n "${CLAUDE_PROJECT_DIR:-}" ] && [ -d "${CLAUDE_PROJECT_DIR}/logs" ]; then
    PROJECT_DIR="$(cd "$CLAUDE_PROJECT_DIR" && pwd)"
else
    echo "check-archive: ERROR — no archive target. CLAUDE_PROJECT_DIR unset or has no logs/." >&2
    echo "  Every caller must pass CLAUDE_PROJECT_DIR=\"\$(pwd)\". Nothing archived." >&2
    exit 1
fi
LOGS="$PROJECT_DIR/logs"
```
`exit 1` (operator decision, over v1's `exit 0`): once every caller passes the target, a missing target means a **broken caller** — surface it, don't conceal it behind silent success.

**b) Update every live caller:**
- [wrap-session.md:31](ai-resources/.claude/commands/wrap-session.md#L31) — **already correct** (`CLAUDE_PROJECT_DIR="$(pwd)" …`). Prose only: state the script now requires the target.
- [log-sweep.md:191](ai-resources/.claude/commands/log-sweep.md#L191) — **the R1 caller fix.** `cd "{AI_RESOURCES}" && bash …` → `cd "{AI_RESOURCES}" && CLAUDE_PROJECT_DIR="$(pwd)" bash logs/scripts/check-archive.sh` (it already `cd`s to ai-resources, so `pwd` is the correct target).
- Workspace-root SessionStart hook [`.claude/settings.json:41`](.claude/settings.json#L41) — `"$CLAUDE_PROJECT_DIR/…/check-archive.sh" --warn-only 2>/dev/null; exit 0`. **No change**: inherits `CLAUDE_PROJECT_DIR` from the hook env, runs the *project-local* copy, is non-writing, swallows non-zero. Covered by a regression test, not edited.

### Narrowed claim about the other copies
Only the **ai-resources canonical copy** changes. The other 16 (of 17, five line-counts) are **not** touched and **not** claimed safe. The wrong-repo defect is closed for the copy an improvised walk-up reaches; a project-local copy invoked by wrap *in its own project* archives its own logs by pre-existing `$0` coincidence — not a guarantee this plan makes. Copy consolidation is a separate gated task (§10).

### Before → after
| Situation | Before | After |
|---|---|---|
| Wrap in a project with `logs/scripts/` | correct by `$0` luck | correct by design |
| `/log-sweep` Cat A1 (ai-resources) | archives ai-resources | **unchanged** (caller now passes target) |
| Session improvises a walk-up to the canonical copy | **archives ai-resources' logs** | `exit 1`, nothing archived |
| No `CLAUDE_PROJECT_DIR` | archives its own repo silently | `exit 1` + diagnostic |
| SessionStart `--warn-only` | reports | reports — unchanged |

### Capabilities unchanged
`ENTRIES` table; today-date guard; `--warn-only` JSON shape (SessionStart consumes it); `ARCHIVE FAILED`→exit-1; `split-log.sh`; standalone project-local copy.

---

## 2. Thread 3 — archive is deny-read

### Accepted causal mechanism
`ai-resources/.claude/settings.json:25-30` denies archive reads. Deny beats allow and is **not** waived by `bypassPermissions`, so a read-only verification agent cannot check whether an item was already closed — the mechanism behind 2026-07-24's two near-permanent false closes. Two overlapping rules exist; `Read(logs/*archive*.md)` (line 30) also blocks `logs/archived-projects.md`, a **live registry, not an archive**.

### Exact correction (operator decision: satisfy the assertion in full)
**a) `ai-resources/.claude/settings.json`** — delete both `logs/`-scoped archive denies (lines 26 and 30). Resulting `deny`:
```jsonc
"deny": [
  "Bash(rm -rf *)", "Bash(sudo *)",
  "Read(archive/**)", "Read(inbox/archive/**)",
  "Read(**/deprecated/**)", "Read(**/old/**)"
]
```
**b) [permission-template.md:131-132](ai-resources/docs/permission-template.md#L131-L132)** — delete the `Read(logs/*-archive-*.md)` entry from the canonical Layer-C shape so template and live file agree (R1).

**c) Repair the two instructions that depend on the removed deny (R2) — land them in the same commit:**
- [improve.md:21](ai-resources/.claude/commands/improve.md#L21) de-dup note currently excludes the archive *"due to a `Read(logs/*archive*.md)` deny rule."* Replace with a **scoping** rationale, not a permission one:
  > **De-dup note:** the active log is the de-dup source of truth. The archive (`improvement-log-archive.md`) is out of the agent's default read scope for **relevance and token economy** — archived entries are completed fixes, so re-proposing an already-fixed root cause is low-risk and not worth the extra read. (A scoping choice, not a permission constraint — the former `Read(logs/*archive*.md)` deny that once forced it is removed by this mission's thread 3.)
- [resolve-improvement-log.md:119-126](ai-resources/.claude/commands/resolve-improvement-log.md#L119-L126) Step 7 currently justifies append-only by *"denies `Read(logs/*archive*.md)` (line 32) … blocked by that deny … it will hit the deny rule."* **Keep the append-only behaviour** (it is the right data-integrity choice) but re-base its rationale:
  > **Append-only — do NOT read-merge-sort the archive.** Append selected entries to the end and never read it back. The reason is **data integrity, not permissions**: the active log's outgoing order IS canonical chronological order (oldest→newest, top-to-bottom), so an append preserves chronology with no re-sort, while "read → merge → sort → rewrite" risks reordering or corrupting a large archive for no benefit. Do not "optimize" this into a read-merge-sort path. (The `Read(logs/*archive*.md)` deny that also blocked it is removed by thread 3; the append-only discipline stands on its own merit.)
  Step (a)'s parenthetical "*since both would trip the deny or its Read-before-Write requirement*" → replace with "*append-only via Bash keeps the archive write a pure append, no Read-before-Write round trip.*"

Rationale for full removal over v1's glob-narrowing: under `bypassPermissions` the deny was the **only** thing making these files unreadable; a hard deny expresses "forbidden," not "expensive — avoid casually." The don't-load-casually discipline lives in `CLAUDE.md`; the hard block goes.

### Before → after
`logs/improvement-log-archive.md`, `logs/session-notes-archive-2026-07.md`, `logs/decisions-archive-2026-05.md`, `logs/archived-projects.md` become readable on demand. `archive/**` and `inbox/archive/**` (bulk archived content) stay denied. Mission assertion — *"a read-only session can read `logs/improvement-log-archive.md` without a denial"* — now **met**; no contract amendment. The two commands no longer carry false permission rationale, and archival stays append-only.

### Capabilities unchanged
`archive/**`, `inbox/archive/**`, `**/deprecated/**`, `**/old/**` denials; `bypassPermissions`; `rm -rf`/`sudo` denials; append-only archive procedure. **No `"model"` key introduced.**

---

## 3. Thread 4 — append-order enforced at the COMMIT BOUNDARY (redesigned, R2)

### Accepted causal mechanism (corrected)
Three append-at-tail logs (`session-notes.md`, `decisions.md`, `usage-log.md`) share one hazard: a prepended entry lands where `check-archive.sh` treats it as *oldest* and can archive the newest. **The recorded failure shipped in a mid-session commit, not at wrap:** `c3d5fe7` prepended 16 lines to `decisions.md` at line 2 (diff hunk `@@ -2,6 +2,22 @@`), above the older retained entries, and committed — long before any `/wrap-session` ran. **A wrap-time check cannot prevent it** (Codex R2). v1/v2's wrap-site wiring was therefore the wrong boundary.

### Exact correction — one check at the boundary where the failure escapes
Extend the **same already-wired pre-commit hook** used for conflict markers (§7) with an append-order guard. New helper `logs/scripts/check-append-order.sh`, called by the hook once per staged append-only log:
```
check-append-order.sh <path> <header-regex>
  staged  = git show ":<path>"                       # the content being committed
  added   = headers matching <header-regex> among `git diff --cached -U0 <path>` '+' lines
  # Canonical order for these ai-resources logs is newest-LAST (append to end).
  # INVARIANT: every newly-added dated header must sit BELOW every retained dated header.
  # Violation iff min(position of added headers) < max(position of retained headers).
  # → exit 1, naming the misplaced entry; else exit 0.
```
The hook holds a per-log `(path, header-regex)` table for `logs/session-notes.md`, `logs/decisions.md`, `logs/usage-log.md` (exact regexes pinned at implementation by reading each log's header shape; e.g. session-notes `^## [0-9]{4}-…— Session`, usage-log `^### [0-9]{4}-…`). It runs only when that log is staged.

**Why this is complete where the wrap-time check was not:**
- Catches the recorded **mid-session** failure — it fires at commit, before the prepend can ship.
- Catches an **earlier** misplaced entry, not just the last (Codex R2): it evaluates *each* added header's position, so two-appends-with-the-first-prepended is flagged even when the last entry is correct.
- No `EXPECTED_NEWEST` needed — the staged diff itself identifies what is new.

### Dropped from v2 (unnecessary once the boundary is right)
The four wrap-site `check-append-order` calls, **and** the `check-usage-log-format.sh` refactor. The existing `check-usage-log-format.sh` wrap check **stays as-is** (it also validates the usage-log's reader anchor/header shape) — not refactored, lower risk. The existing `session-notes.md` prose warning stays as documentation.

### Files expected to change
- `logs/scripts/check-append-order.sh` (**new**)
- `.claude/hooks/pre-commit` (tracked) + `.git/hooks/pre-commit` (installed copy — re-copy by hand)
- `logs/scripts/check-append-order.test.sh` (**new**) / extend `pre-commit-hook.test.sh`

### Before → after
A prepended entry in any of the three logs — same-day, cross-day, or one of several appended in a session — is **refused at commit**, in every commit path, naming the misplaced entry. Today it ships (`c3d5fe7`).

### Capabilities unchanged · disclosed limits
`check-usage-log-format.sh` and its caller unchanged; the wrap's continue-on-advisory posture unchanged; `--no-verify` remains the escape. **Newest-last is assumed** for these three ai-resources logs; project-local newest-first logs (e.g. axcion-pitch-engine's `session-notes.md`) are **out of scope** — this is the ai-resources pre-commit hook. **Coverage is checkout-local** (unversioned hook install — sibling mission thread 3), same limit as §7.

---

## 4. Thread 5 — the `grep` antibody · **CLOSE, no fix**

The gitignore-aware `grep` wrapper is real but its blindness has a narrow, already-documented trigger, and **no committed scan site uses it**: only the dot-rooted walk goes blind (named subdirs/absolute paths immune); the shadow is a shell function that does not cross into `.sh` files; across `.claude/commands`, `.claude/agents`, `.claude/hooks`, `logs/scripts` there are **zero** real dot-rooted scan sites (4 hits, all inside `search-canary.sh` itself). [search-canary.sh](ai-resources/logs/scripts/search-canary.sh)'s 2026-07-18 header already records this. Implementing the thread would add prose antibodies against a failure mode the code shape excludes — the "inert safeguard" class this repo already fights.

**Change from v1:** the optional "add the canary call to `diagnostics-scanner.md`" follow-up is **dropped** (no observed defect; unnecessary addition). Residual exposure — ad-hoc dot-rooted greps typed inline — is unchanged by closing *and* by the thread's own fix; `search-canary.sh` surfaces it on demand.

---

## 5. Thread 6 — `/risk-check` scope check (command edit only)

`risk-check.md:87-89` (Step 2.6) checks that cited things exist and say what's claimed, never that the **instrument's scope matches the claim's scope** — how `/prime` under-counted active missions (repo-scoped instrument, workspace-scoped claim). Amend `risk-check.md:89` (one bullet, in place):
> - **Re-derive every count, record the primitive used, and assert the primitive's scope covers the claim's scope.** A correct number from a **repo-scoped** instrument misleads when the claim is **workspace-scoped**. State the scope (repo / workspace / cross-repo); a workspace-scoped claim must be derived by cross-repo enumeration, never repo-local.

**Dropped (R1): the paired `risk-check-reviewer.md` edit** — redundant; the reviewer already forces independent re-derivation and wins on contradiction ([risk-check-reviewer.md:15,383](ai-resources/.claude/agents/risk-check-reviewer.md#L15)). No new command, no extra subagent; `/risk-check` keeps its logged `sonnet` tier.

---

## 6. Thread 7 — gate→contract-drift nudge (**advisory mitigation, labelled honestly**)

[contract-check.md:11-14](ai-resources/.claude/commands/contract-check.md#L11-L14) lists four triggers, none gate-related — yet a gate verdict forcing a redesign is the event most likely to change *what is delivered*. The 2026-07-18 instance ran on `PROCEED-WITH-CAUTION` where the operator's *response* changed the deliverable, so the trigger keys on *"the gate caused the deliverable to change,"* not a verdict token. Smallest form, **not enforcement**:
1. `contract-check.md` after `:14` — a fifth trigger keyed on the deliverable changing.
2. `risk-check.md` verdict-emission step (**exact line not pinned — locate before editing**) — on any non-GO verdict, one advisory line pointing at `/contract-check` if the deliverable (not the build) changed.
3. Workspace `CLAUDE.md` § Contract-Conformance Check — mirror the fifth trigger.

**Honest limit:** a test can prove only that the nudge text is emitted, **not** that `/contract-check` runs. Advisory mitigation, not behavioural prevention. **Do not** auto-invoke `/contract-check` from `/risk-check`.

---

## 7. Thread 8 — conflict markers reaching commits

`/close-worktree-session` has zero stash handling but **does not create stashes**, so "add stash handling there" targets a mechanism it doesn't own. Markers enter the tree elsewhere (`/prime` Step 0 `--autostash`, [prime.md:58](ai-resources/.claude/commands/prime.md#L58)) and reach HEAD through *any* commit path. The **commit boundary** is the one choke point every path crosses — and now hosts two integrity checks (this + §3).

`ai-resources/.claude/hooks/pre-commit` is git-tracked, byte-identical to the installed `.git/hooks/pre-commit` (`cmp`-verified), and `exit 0`s early when no SKILL.md is staged. Insert **before** that early exit:
```bash
# Conflict-marker guard — every commit, before the SKILL.md early exit.
# Block only the UNAMBIGUOUS markers: <<<<<<<, >>>>>>>, ||||||| .
# =======  is DELIBERATELY EXCLUDED — it collides with Markdown setext headings and ==== dividers.
# Every real git conflict emits <<<<<<< and >>>>>>>, so catching those catches every conflict.
markers=$(git diff --cached -U0 | grep -E '^\+(<{7}|>{7}|\|{7})( |$)' || true)
if [ -n "$markers" ]; then
    echo "BLOCKED: staged content contains unresolved conflict markers." >&2
    git diff --cached --name-only -G'^(<{7}|>{7}|\|{7})( |$)' >&2
    echo "  Resolve, or 'git commit --no-verify' if intentional." >&2
    exit 1
fi
```
**Settled policy (R1):** anchored at line start + trailing space-or-EOL, so a marker mentioned mid-line/inside backticks (as in this document) is immune; a standalone marker line is caught. `=======` excluded to avoid setext/​divider false positives (0 tracked files carry a bare `=======` today; the exclusion is free insurance).

**Files:** `.claude/hooks/pre-commit` (tracked) + `.git/hooks/pre-commit` (re-copy by hand) + `pre-commit-hook.test.sh`. **Before/after:** today any path ships `<<<<<<<` into a tracked file (it did, into `logs/friction-log.md`); after, every path is refused with the file named. SKILL.md validation unchanged; `--no-verify` escapes. **Checkout-local limit** (unversioned install, sibling mission thread 3) inherited and disclosed — not introduced here.

---

## 8. Thread 9 — override prompts enumerate one conflict · **PARK, do not close (R2)**

### Accepted causal mechanism
Workspace `CLAUDE.md:52` frames conflict as pairwise ("two inputs") and singular ("the conflict"). When an operator gives an override, the session surfaces the *one* triggering conflict as if the search were complete; the observed failure was the **absence of a decision-surface sweep**.

### Disposition (revised twice, now settled)
- v1's singular→"every conflict" rewrite was rejected R1 (a generic always-loaded sentence, no mechanism).
- v2's **bounded-disclosure** rewrite is rejected R2: disclosing *what you searched* still does not **enumerate the conflicting decisions**, so it does not correct the accepted problem — and must not be presented as if it does.

**This plan therefore ships no thread-9 edit.** The genuine fix is a **bounded decision-surface inventory at the override path** — a real search step (enumerate standing decisions in CLAUDE.md rules / active mission contracts / `decisions.md` that the override would settle, and list them before asking). That is new machinery requiring its own design and `/risk-check`. Per the priority order (new machinery is the last resort) and the ROI gate (park, don't patch, when the structural fix needs its own session), **thread 9 is PARKED and stays OPEN**, with its mechanism target corrected on the thread from "singular wording" to "missing decision-surface inventory." No prose is presented as closing it.

---

## 9. Thread 10 — close two entries (stable headings, no line numbers)

### Verification (by heading, per R2)
- **Entry — `### 2026-07-13 — The session-marker allocator collides across checkouts …`** — its status line reads *"OPEN … no fix applied,"* yet the same entry carries a sub-section **`#### ✅ FIXED 2026-07-13 (S13) — with a mutex, not a wider read`** describing the shared-git-common-dir claim directory now live in `prime.md`. Self-contradictory. **Close.**
- **Entry — `### 2026-07-14 — \`improvement-log.md\` has TWO entry formats and \`/prime\` Step 3 can only see one of them`** — status `partially applied`; its named remainder ("the appending steps still do not emit the field") is now **false**: `wrap-session.md` appends the `- **Severity:**` line and `session-feedback-collector.md` marks it MANDATORY. **Close.**

### Exact correction — cite headings, not lines
Close both via the log's **strikethrough-plus-replacement** convention (preserve the false-open record). Cite each by the **heading text above** and by the closing evidence's own heading/anchor (`#### ✅ FIXED 2026-07-13 (S13)`; the `wrap-session.md` step that appends the Severity line + `session-feedback-collector.md`'s MANDATORY line). **No absolute line numbers** anywhere — they drift between working tree and commit (v1 cited `:853/:867/:1159`; the pinned commit had `848/862/1154`; the thread text itself cited `:848/:862/:1154`), which is the very defect this thread is about.

### Withdrawn (R1): the `check-citation-resolution.sh` recommendation
It verifies a cited line *exists (file long enough)*, explicitly **not** that the line *says* what's claimed ([check-citation-resolution.sh:9-10](ai-resources/logs/scripts/check-citation-resolution.sh#L9-L10)). Both drifted citations resolve successfully, so the scan reports them clean. Re-resolve by **stable heading + direct read**. Broader advisory (no mechanism built here): stop pinning absolute line numbers into monotonically-growing logs; cite headings.

**Files:** `logs/improvement-log.md` (two entries). Mission thread ticks via `/mission update` only — never a hand-edit (frozen-prefix hash guard).

---

## 10. Explicit non-goals
1. **Not** consolidating the 17 `check-archive.sh` copies (own gated task).
2. **Not** provisioning `logs/scripts/` into 13 projects. The residual `exit 127` in script-less projects is logged as a **separate low-priority availability item** (operator decision E), not part of the wrong-repo defect.
3. **Not** adding a walk-up to `wrap-session.md` Step 3 — deferred until §1 lands.
4. **Not** touching `.claude/commands/prime.md` (mission non-negotiable; sibling thread 15).
5. **Not** fixing unversioned hook wiring (sibling thread 3). §3/§7 inherit and disclose the limit.
6. **Not** adding a `"model"` field anywhere.
7. **Not** auto-invoking `/contract-check` from `/risk-check`.
8. **Not** editing the two immune audit agents, nor adding the canary to `diagnostics-scanner.md` (§4).
9. **Not** the reviewer-side edit for thread 6 (redundant with Dimension 7).
10. **Not** wiring append-order at wrap sites (wrong boundary — moved to the commit hook, §3).
11. **Not** shipping any thread-9 edit — parked; the decision-surface inventory is new machinery for its own session.
12. **Not** running `check-citation-resolution.sh` as evidence of citation freshness (it cannot provide it).

---

## 11. Required tests
Every test is declared before running and must be capable of failing; each reads the **shipped** file (per the `prime-allocator.test.sh` 2026-07-14 precedent). **All write tests run in an isolated temporary git repo — never against live shared logs (R2).**

**§1 — `check-archive.sh`** (the only one that writes) — *all in a temp repo mirroring the ai-resources layout (`logs/scripts/check-archive.sh` + over-threshold `logs/`):*
1. Temp project, `CLAUDE_PROJECT_DIR`=temp → temp project archived; **temp `ai-resources`-mirror's other logs byte-unchanged**. *(Falsification — fails against today's script.)*
2. `CLAUDE_PROJECT_DIR` unset → `exit 1`, nothing archived.
3. `CLAUDE_PROJECT_DIR` set to a path without `logs/` → `exit 1`, no write.
4. **`/log-sweep` regression, in an isolated temp ai-resources-mirror** (not live): fixed caller (`CLAUDE_PROJECT_DIR="$(pwd)"`) archives that mirror's over-threshold logs. *(Proves the caller fix restores the path.)*
5. SessionStart `--warn-only` with `CLAUDE_PROJECT_DIR` in env → JSON shape byte-identical; no `logs/` → non-zero swallowed, no crash.
6. Today-date guard still refuses (regression).
7. `split-log.sh` resolves from `SCRIPT_DIR` even when the caller's project has no `logs/scripts/`.

**§2 — deny removal.** Direct `Read` of `logs/improvement-log-archive.md` and `logs/archived-projects.md` succeeds; `archive/**` + `inbox/archive/**` remain denied. Also read-back `improve.md` and `resolve-improvement-log.md` after the rationale edits — no residual deny reference remains, and the append-only procedure text is intact.

**§3 — append-order at the commit boundary** — *temp repo, staged commits:*
- (a) clean append (new entry at end) → exit 0.
- (b) **cross-day prepend** → exit 1, entry named.
- (c) **same-day prepend** → exit 1.
- (d) **two entries added, the earlier prepended, the last correct** → exit 1 (the R2 case a final-header check misses).
- (e) in-place edit of an old entry, no new header → exit 0 (no false positive).
- Run against the **installed** `.git/hooks/pre-commit` after copying.

**§7 — conflict markers** — *temp repo:* (a) staged `<<<<<<<` → exit 1, file named; (b) clean → exit 0; (c) a fenced block with a **setext `=======`** line and a mid-line backticked `` `<<<<<<<` `` → **exit 0** (policy proof); (d) SKILL.md validation still passes. Installed hook.

**Threads 6, 7, 9 — prose/checklist.** §6, §7: read-back only; §7's test confirms the **nudge text exists**, not that `/contract-check` runs. §9 ships no edit — nothing to test; the thread stays open.

---

## 12. Rollback
Small in-place edits to tracked files except the new `check-append-order.sh` + tests. `git revert` restores §1, §2, §5, §6, §9. Exceptions:
- **§3 + §7 pre-commit:** `.git/hooks/pre-commit` is **not tracked** — rollback = revert the tracked file **and** re-copy it; `git commit --no-verify` is the immediate escape.
- **§9 (thread 10) log edits:** strikethrough-plus-replacement, not deletion.

Landing shape: **one commit per numbered section**; §1, §3, §7 (the runtime-behaviour changes) land alone. **Sequencing (non-negotiable):** §1 lands before any walk-up is added to `wrap-session.md` Step 3 in this repo **or** in `axcion-pitch-engine` (whose `improvement-log.md:19` proposes exactly that — it would convert §1's loud failure into a systematic silent wrong-repo write).

---

## 13. Remaining limitations (stated, not hidden)
- **§3 and §7 coverage is checkout-local** — unversioned hook install (sibling mission thread 3). A fresh clone is unprotected until the hook is installed.
- **§3 assumes newest-last** for the three ai-resources logs; project-local newest-first logs are out of scope.
- **§6, §7 carry no code enforcement** — checklist/advisory; tests confirm wording only.
- **Thread 9 is unresolved by design** — parked open; no prose is claimed to fix it.
- **The 16 divergent `check-archive.sh` copies are unchanged** and not claimed safe.
- **Not verified this session (locate before editing):** `/risk-check`'s exact verdict-emission line (§6.2); the per-log header regexes for §3 (pin by reading each log at implementation).

---

## 14. Operator decisions — resolved
| # | Decision | Resolution |
|---|---|---|
| A | Thread 3 permissions | **Full fix** — remove `logs/` archive denial; update settings.json + permission-template.md + `improve.md` + `resolve-improvement-log.md` together |
| B | §7 hook posture | **`exit 1`**, blocking; `=======` excluded; `--no-verify` escape |
| C | §1 no-target behaviour | **`exit 1`** (broken-caller signal) |
| D | Thread 5 | **Close**, no fix; optional canary add dropped |
| E | Thread 2 | **Close** as dissolved; residual `exit 127` logged as a separate availability item |
| F | Thread 9 | **Park, do not close**; ship no edit; correct the mechanism target on the thread |
| G | `/risk-check` | **One consolidated gate** over this plan (archive caller contract + permissions + the pre-commit hook's two checks) — assesses implementation risk/coupling, does **not** reopen whether the problems exist |

## 15. Recommended sequence
| Order | Section | Threads | Gate | Notes |
|---|---|---|---|---|
| 0 | Re-resolve mission citations by heading | 10 | none | Replaces the withdrawn citation scan |
| 1 | §1 | 1, 2 | consolidated | Only silent-data-integrity defect; caller fix included |
| 2 | §9 closes | 10 | none | Bookkeeping; stable headings |
| 3 | §4 (thread 5) close | 5 | none | Decline + record |
| 4 | §7 + §3 | 8, 4 | consolidated | **One pre-commit hook, two checks** (markers + append-order) — land together |
| 5 | §2 | 3 | consolidated | Permissions + the two command rationale repairs |
| 6 | §5, §6 | 6, 7 | consolidated (§6 mirror to CLAUDE.md) | Prose/checklist; last |
| — | Thread 9 | 9 | — | **Parked** — not landed this pass |

The consolidated `/risk-check` (decision G) runs **once** over the whole plan before the gated sections land, not per edit.
