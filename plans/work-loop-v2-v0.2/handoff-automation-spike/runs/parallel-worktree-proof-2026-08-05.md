# Two-worktree parallel proof — live run record, 2026-08-05

Two file-disjoint Work Loop v2 tasks carried to a terminal `turn: operator` by two independent
`dispatch.sh` instances, in two linked worktrees of one throwaway Git sandbox, with a **measured
overlapping active interval**. Then landed serially into the sandbox's integration checkout and torn
down. No operator transported a single turn.

Everything below happened inside a disposable sandbox under `TMPDIR`, outside this repository.

---

## 1. Topology, and the boundary teardown was allowed to touch

| Thing | Value |
|---|---|
| Sandbox root | `/private/var/folders/cd/hdqdzkks7zb67xvd7pglm8ym0000gn/T/wl2-par-G8TL3Y` |
| Source repository | `…/Axcion AI Repo/ai-resources` at `24d8e66` |
| Clone | `git clone --no-hardlinks --single-branch --branch main` → `<sandbox>/integration` |
| Sandbox base commit | `7c84773` (one commit above `24d8e66` — see § 2) |
| Integration checkout | `<sandbox>/integration`, branch `main` |
| Worktree A | `<sandbox>/wt-alpha`, branch `wl2/alpha`, task `wl2-alpha` |
| Worktree B | `<sandbox>/wt-beta`, branch `wl2/beta`, task `wl2-beta` |
| Probe worktree | `<sandbox>/wt-probe`, branch `wl2/probe`, task `wl2-probe` (§ 4) |
| State files | `<worktree>/logs/work-loop/{wl2-alpha,wl2-beta}.md` |
| Allowlist (dispatcher default) | `^logs/work-loop/` and `^plans/work-loop-v2-v0\.2/handoff-automation-spike/` |
| Dispatcher log dirs | `<sandbox>/evidence/{alpha,beta}` — **outside every checkout**, so a run's own evidence is not a repository change |

**Isolation from the real repository is structural, not promised.** `--no-hardlinks` means no shared
object store: `.git/objects/info/alternates` does not exist in the clone. `git remote remove origin`
ran immediately after the clone, so the sandbox has no path back. **Teardown was permitted only
inside `<sandbox>/`** — never against a real worktree, branch or checkout.

Binaries and policy, recorded exactly (nothing installed, authenticated, upgraded or widened):

- Claude Code `2.1.220` at `/Users/patrik.lindeberg/.local/bin/claude`
- `codex-cli 0.146.0-alpha.9.2` at `/Applications/ChatGPT.app/Contents/Resources/codex`
- `git 2.50.1 (Apple Git-155)`
- Launch policy unchanged: no `--dangerously-skip-permissions`; each child inherits the sandbox
  clone's own tracked `.claude/settings.json`, which already declares `defaultMode: bypassPermissions`.

---

## 2. The file-ownership map — and the one shared writer that had to be removed first

| Path (repo-relative) | Owner |
|---|---|
| `logs/work-loop/wl2-alpha.md` | ALPHA |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures/alpha-result.md` | ALPHA |
| `logs/work-loop/wl2-beta.md` | BETA |
| `plans/work-loop-v2-v0.2/handoff-automation-spike/sandbox-fixtures/beta-result.md` | BETA |
| everything else in the checkout | neither — out of scope for both |

No path is owned by both. Each task's own state file names the sibling's two paths explicitly as
excluded, so "stay in lane" is in the brief the actor reads, not only in this table.

**Drawing the map surfaced a shared writable path that had nothing to do with either task.**
`.claude/hooks/log-write-activity.sh` is a PostToolUse hook on Write/Edit, registered in the
repository's *tracked* `.claude/settings.json`. It appends to `logs/friction-log.md` on **every file
write, in every checkout**. Two parallel Work Loops in two worktrees of this repository would both
mutate that one tracked file — and it mutates *in place* (`sed -i` insert-after-line), which the
parallel-sessions playbook § 2 classifies as the dangerous "append-shaped with in-place mutations"
row, not a safe union.

The overlap was **removed, not allowlisted**: sandbox base commit `7c84773` deletes
`logs/friction-log.md`, and the hook's own first line (`[ -f "$FRICTION_LOG" ] || exit 0`) then makes
it a no-op. Both worktrees branch from that commit, so the file never existed in either. This is
recorded rather than hidden because it is a finding about the **real** repository, and it belongs to
the operator's production-policy decision: see § 9.

Two other ambient writers were checked and cleared. `detect-innovation.sh` fires only for writes
under `.claude/commands|agents|hooks`, which neither task touches. `logs/.session-marker*` and
`logs/.prime-mtime` are gitignored, so they never appear as repository changes.

**Process honesty:** the ownership analysis — and the base commit that acts on it — preceded both
worktrees. This table was transcribed into a file *after* the worktrees existed. The decision
came first; the writing-down did not.

---

## 3. The two fixture tasks

Each opened at `turn: codex` with an unwritten brief, so the run exercises the **full** cycle
Codex → Claude → Codex → Claude → operator rather than starting mid-stream. Each brief's completion
condition is one file containing one exact marker line, chosen so the evidence can discriminate:

- ALPHA → `WL2-ALPHA-UNIQUE-MARKER-7Q4X`
- BETA → `WL2-BETA-UNIQUE-MARKER-3M8P`

---

## 4. Probe run — the source-code claim replaced by an observation

Before spending the parallel run, one bounded probe (`wl2-probe`, own worktree, one hop, 80 s)
established that a dispatcher-launched Claude child can read, write **and commit** inside a linked
worktree. `dispatch.sh` runs Claude via `( cd "$CHECKOUT" && … )`; that is source code, not an
observation. The probe's deliverable is the child reporting its own position:

```
cwd=/private/var/…/wl2-par-G8TL3Y/wt-probe
git_toplevel=/private/var/…/wl2-par-G8TL3Y/wt-probe
```

Dispatcher: `exit=0`, `HEAD` moved `f470c8a → 86cc4f2` inside the probe worktree, `turn: claude →
operator`. Siblings at that moment: `wt-alpha`, `wt-beta` and `integration` all still at their own
commits, all clean.

---

## 5. The parallel run — hops, and the overlap that makes it parallel

Both dispatchers launched at **20:36:13**, `--max-hops 5 --timeout 600`, separate log directories.

| | ALPHA (`wl2-alpha`) | BETA (`wl2-beta`) |
|---|---|---|
| Dispatcher exit | `0` | `0` |
| Wall clock | 20:36:13 → 20:40:26 (253 s) | 20:36:13 → 20:39:33 (200 s) |
| Hops launched | 4 | 4 |
| Terminal | `turn: operator`, "No further launches." | `turn: operator`, "No further launches." |

Per hop — actor, exit, duration, state `sha256` before→after, `turn` before→after, `HEAD`, verdict:

**ALPHA** (full log: `parallel-worktree-proof-2026-08-05.alpha.log`)

| Hop | Actor | Exit | Dur | `sha256` | `turn` | `HEAD` | Verdict |
|---|---|---|---|---|---|---|---|
| 1 | codex | 0 | 92 s | `54a5036…` → `115223a…` | codex → claude | `cb402f6` (unmoved) | allowed |
| 2 | claude | 0 | 60 s | `115223a…` → `d1a144d…` | claude → codex | `cb402f6` → `1234877` | allowed |
| 3 | codex | 0 | 64 s | `d1a144d…` → `00d9b86…` | codex → claude | `1234877` (unmoved) | allowed |
| 4 | claude | 0 | 37 s | `00d9b86…` → `41af69e…` | claude → operator | `1234877` → `02aca65` | allowed |

**BETA** (full log: `parallel-worktree-proof-2026-08-05.beta.log`)

| Hop | Actor | Exit | Dur | `sha256` | `turn` | `HEAD` | Verdict |
|---|---|---|---|---|---|---|---|
| 1 | codex | 0 | 61 s | `e187b2a…` → `4cf771b…` | codex → claude | `a28b4b4` (unmoved) | allowed |
| 2 | claude | 0 | 56 s | `4cf771b…` → `e278188…` | claude → codex | `a28b4b4` → `ad61f30` | allowed |
| 3 | codex | 0 | 49 s | `e278188…` → `59850a5…` | codex → claude | `ad61f30` (unmoved) | allowed |
| 4 | claude | 0 | 34 s | `59850a5…` → `4bae261…` | claude → operator | `ad61f30` → `8a5efe7` | allowed |

`HEAD` moves only on Claude hops in both tables. Codex never moved it — core § 4's "Codex does not
run git", observed rather than assumed.

### The overlap

Two dispatchers being alive together is not enough: two idle processes overlap trivially. The claim
is that **both tasks had a live actor child at the same instant**, and the sampler
(`parallel-sampler.sh`, 2 s cadence) records it:

- **91 samples** — ≈ **182 seconds** — in which ALPHA and BETA each had a live `codex` or `claude`
  child simultaneously.
- Every pairing occurred: `codex‖codex` (t=2–56, t=146–156), `codex‖claude` (t=60–86, t=112–142,
  t=158–188), `claude‖claude` (t=90–110).

Running the same proof twice in sequence produces zero such samples. Extract:
`parallel-worktree-proof-2026-08-05.sampler.txt`.

---

## 6. Isolation, judged by a separate checker

`parallel-isolation-check.sh` reads the finished run back and asserts. All nine passed:

```
PASS  A1   alpha branch changed only owned paths
PASS  A2   beta branch changed only owned paths
PASS  A3   alpha result carries WL2-ALPHA-UNIQUE-MARKER-7Q4X
PASS  A4   beta result carries WL2-BETA-UNIQUE-MARKER-3M8P
PASS  A5   no task's marker appears in the sibling worktree
PASS  A6   neither branch touched the sibling's state file
PASS  A7   both state files terminal at turn: operator (alpha=operator beta=operator)
PASS  A8   all 209 sampled actor processes ran in their routed worktree
PASS  A9   integration checkout still at base, clean index and tree (head=7c84773 dirty=0 staged=0)
```

A8 is the one that could not be answered from source code. Claude is routed by process `cwd` and
Codex by its `-C` argument, so each is judged against the mechanism that actually carries it, using
`lsof -a -d cwd` — a kernel fact about the process. 209 sampled actor observations, zero mismatches.

A9 is the "clean landing target" property, and it held *throughout* the active interval, not merely
at the end: the integration checkout stayed at the base commit with an empty index and tree while
both loops ran.

### The negative witness — three of them

A checker nobody has seen fail is an untested instrument. Each failure was manufactured by **lying
to the checker**, never by writing across a real worktree boundary:

| Witness | Injected lie | Result |
|---|---|---|
| 1 | `--expect-worktree-alpha <a path the run never used>` | **A8 FAIL**, checker `exit=1` |
| 2 | `--expect-marker-alpha NEVER-WRITTEN` | **A3 FAIL**, checker `exit=1` |
| 3 | `--marker-beta NEVER-LANDED` (landing QC) | **B2 FAIL**, QC `exit=1` |

Fixture restored, same run, true expectations → all nine assertions PASS, `exit=0`.

---

## 7. Serial landing and integration QC

Pre-merge: integration at `7c84773`, `dirty=0` — the playbook § 5.1 clean-target precondition, met
without a stash because no interactive work ever happened there.

| Step | Command | Result |
|---|---|---|
| 1 of 2 | `git merge --no-ff -m "land: wl2-alpha" wl2/alpha` | exit `0`, 2 files, **0 conflicts**, HEAD → `b7cff0f` |
| 2 of 2 | `git merge --no-ff -m "land: wl2-beta" wl2/beta` | exit `0`, 2 files, **0 conflicts**, HEAD → `b719628` |

Merged one at a time, never batched (playbook § 5.4). `parallel-landing-qc.sh` then ran
both-sides-present QC — presence first, marker sweeps second, because grepping for `<<<<<<<` proves
clean resolution and says nothing about a dropped result:

```
PASS  B1   alpha deliverable present in integration with its marker
PASS  B2   beta deliverable present in integration with its marker
PASS  B3   alpha closing record present in integration (turn: operator + the four headings)
PASS  B4   beta closing record present in integration (turn: operator + the four headings)
PASS  B5   both branch tips are ancestors of the integration HEAD — no side was dropped
PASS  B6   no conflict markers in the landed deliverables or state files
PASS  B7   no stale [IN FLIGHT] markers in the landed paths
PASS  B8   integration working tree clean after landing (dirty=0)
PASS  B9   integration HEAD advanced past the base (base=7c84773 head=b719628)
```

No push was part of the proof.

---

## 8. Teardown

Liveness first, per playbook § 5.9 — never remove a worktree a live session occupies:

- dispatcher/actor processes matching the run: **0**
- processes with `cwd` inside `wt-alpha` / `wt-beta` / `wt-probe` (`lsof -a -d cwd`): **0 / 0 / 0**

Then: all three worktrees removed; `git branch -d` deleted `wl2/alpha` and `wl2/beta` (merged).
`git branch -d wl2/probe` **refused** — "not fully merged", exit 1 — and the safety net working is
part of the evidence; it was then deleted with `-D` deliberately, because a probe branch is not a
result. Remaining branch: `main`.

Orphan sweep inside the sandbox: worktree dirs `0`, stashes `0`, prunable worktree admin entries
`0`, session markers/scratchpads `0`, dispatcher locks under `TMPDIR` `0`, integration tree clean at
`b719628`.

The sandbox root itself is kept, disposable, so the evidence stays inspectable.

---

## 9. The dispatcher defect this proof exposed, and its correction

Both tasks reached `turn: operator` **by closing**. The dispatcher printed:

```
The question below is UNANSWERED. Neither model nor this dispatcher answered it,
--- state file, as the actors left it ---

--- end ---
```

`turn: operator` has two causes and they are not the same message. A core § 7 question leaves
`## Blocker` and `## Next action` in the file; a core § 4 close **deletes them**, so the bounded
reader returns nothing — and the dispatcher asserted an unanswered question above an empty block.

Corrected minimally, inside the spike: the operator branch now branches on whether the reader
returned anything, and on a close says so, pointing at the closing record. Nothing else changed.

Red-to-green, same harness, both directions:

| Controller | Command | Exit | Result |
|---|---|---|---|
| pre-correction, extracted from `HEAD` | `DISPATCH_BIN=<pre> bash dispatch.test.sh` | 1 | **`pass=71 fail=2`** |
| corrected | `bash dispatch.test.sh` | 0 | **`pass=73 fail=0`** |

The two failures are exactly case 21's two new assertions. The previous 69 stayed green; case 0
still points the suite at an absent dispatcher and asserts it fails, so a green run still means
something.

---

## 10. Changed paths in the real repository

`plans/work-loop-v2-v0.2/handoff-automation-spike/` — `dispatch.sh` (§ 9), `dispatch.test.sh`
(case 21), `parallel-sampler.sh`, `parallel-isolation-check.sh`, `parallel-landing-qc.sh`, and this
record plus its three evidence files under `runs/`. Also `logs/work-loop/work-loop-v2-parallel-worktree-proof.md`.

Unchanged, verified by `git status --short` over the whole repository: the Work Loop core and
proposal, the live skill and command, `.claude/` and `.codex/` hooks and settings, every closed prior
task record, and all **8** real worktrees, branches and the integration checkout — `HEAD` still
`24d8e66`, branch `main`, no commit made by any sandbox child.

`logs/friction-log.md` is modified by three lines of PostToolUse write-activity telemetry from this
session's own file writes. It is not this task's work product and was deliberately not committed —
the same disposition the previous task recorded.

---

## 11. What this run does **not** establish

- **Two tasks, not N.** Nothing here describes contention at higher fan-out, or a shared resource
  that only bites at three or more.
- **One observation per property.** One parallel run, one probe. No distribution of outcomes.
- **Fixture-sized units.** Both tasks were deliberately trivial and fully partitioned. The
  playbook's § 1 granularity gate ("each unit at least a full session's worth of work") is
  knowingly *not* met — the fixtures are instruments for measuring transport, not a demonstration
  that this work was worth parallelizing.
- **Merge behaviour on genuinely co-edited files is untested.** Both tasks created only new files,
  which playbook § 2 already calls the zero-conflict shape. Nothing here tests the content-shaped
  conflict the playbook warns about, and a clean two-merge landing is therefore weak evidence about
  a real parallel run that touches a shared backlog or index.
- **The ambient shared writer was removed, not solved.** In *this* repository a real
  worktree-parallel Work Loop would have both loops mutating `logs/friction-log.md` in place. That
  is unresolved and is an input to the production-policy decision, which stays with the operator.
- **No production policy is chosen here.** No hook, daemon, service, installation or push. The
  spike remains a throwaway under `plans/`.
- **Codex-side denial behaviour remains unmeasured**, as in the prior task.
