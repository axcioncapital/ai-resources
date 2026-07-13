# Risk Check — 2026-07-13 (END-TIME, executed change set)

## Change

END-TIME gate on the shipped (uncommitted) session-marker allocator fix — the "split half" of a bundle whose plan-time gate (`audits/risk-checks/2026-07-13-marker-lifecycle-bundle-common-dir-allocator-plus-mtime-liveness.md`) returned RECONSIDER and recommended "split the bundle." Only the allocator half shipped; the mtime-liveness heartbeat (R-1, R-2, R-5) was deliberately NOT built.

**What is on disk, uncommitted:**
1. `.claude/commands/prime.md` — a fourth allocation source (d), a claim directory at `$(git rev-parse --path-format=absolute --git-common-dir)/axcion-session-markers/{date}-S{N}/`, added to the existing three-source MAX (marker file, working-tree `session-notes.md`, all-refs `git grep`). Allocation now CLAIMS the number atomically via `mkdir` (POSIX-atomic; loser gets `EEXIST` and retries, capped at 999). Stale (non-today) claims are pruned with `rm -rf`. Replicated identically across Steps 8a.3.a / 8b.3.a / 8c.3.
2. `docs/session-marker.md` — § Marker allocation rewritten for the four-source rule, the R-3/R-4 closures, the accepted gap, and a "verification standard" paragraph.
3. `logs/improvement-log.md` — the allocator entry marked FIXED with a verification record (7/7 falsification harness) and the accepted-gap note.

R-3 (relative-vs-absolute `--git-common-dir` path shape) is closed via `--path-format=absolute`, present in all three blocks — confirmed by direct grep. R-4 (cross-repo namespace fragmentation) was closed **in the design's favour**, on the claim that "the scope of the common dir and the scope of the namespace are the same scope" because each repo owns its own `logs/session-notes.md`.

## Referenced files

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — exists (MODIFIED, uncommitted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md` — exists (MODIFIED, uncommitted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md` — exists (MODIFIED, uncommitted)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-13-marker-lifecycle-bundle-common-dir-allocator-plus-mtime-liveness.md` — exists (plan-time RECONSIDER, read in full)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-13-prime-marker-allocation-union-across-refs.md` — exists (S6 fix's gate; fail-safe invariant established here, read in full)

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The design closes a real, reproduced incident (S11 in-flight cross-checkout collision) with a genuinely correct mutex mechanism and a clean, narrow consumer footprint — but the code as it sits on disk right now **will crash on the very next `/prime` invocation in this exact repo**, because the shipped "7/7 falsification harness" verified the extracted block by running it under `bash`, while the actual execution shell (confirmed live, this session) is `zsh`, and one of the two new claim-directory loops uses a raw shell glob that zsh's default `NOMATCH` option turns into a hard, script-aborting error the moment the claims directory is empty of today-dated entries — which is true on every single day's first invocation, in every one of the ~24 consuming repos, without exception.

## Consumer Inventory

Search terms: `axcion-session-markers`, `git-common-dir` / `--git-common-dir`, `path-format=absolute`, plus the file-basenames of the three modified files. Searched `ai-resources/` and the workspace root (`--exclude-dir=.git`), and independently walked the live filesystem topology of every checkout that resolves `prime.md` (symlink vs. real file; own `.git` vs. shared common dir).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` (3 blocks: Steps 8a.3.a / 8b.3.a / 8c.3) | co-edits (the change) | yes — done, byte-identical (independently re-verified, md5 `2ae430298dffcfab218e9aa35bc7d5e9` across all three after indent-normalisation) |
| `ai-resources/docs/session-marker.md` § Marker allocation | documents (the change) | yes — done |
| `ai-resources/logs/improvement-log.md` (allocator entry) | documents (the change) | yes — done |
| 24 × `prime.md` symlinks → canonical, each its **own separate git repo** (verified: `projects/strategic-os`, `projects/positioning-research`, `knowledge-bases/pe-kb-vault`, etc. — each resolves to its own `.git`) | imports | no — auto-propagate, correctly isolated (own common dir ⇒ own claim namespace, matching R-4's per-repo intent) |
| `ai-resources-research-workflow/.claude/commands/prime.md` (REAL file, not symlink, branch `session/2026-07-13-research-workflow`, 10 commits behind main) | co-edits / must-rebase (accepted gap) | no — confirmed still running the OLD 3-source block (`grep` shows "THREE sources", not "FOUR") — matches the documented accepted gap exactly |
| `projects/axcion-website/.claude/commands/prime.md` (symlink) **and** `harness/.claude/commands/prime.md` (symlink) | imports — **but shares the workspace-root repo's `.git` common dir, and therefore the SAME `axcion-session-markers/` claim namespace as the workspace root itself and each other** | **yes — NOT identified in the shipped docs; new finding, see Dimension 5** |
| `ai-resources/workflows/research-workflow/.claude/commands/prime.md`, `ai-resources/output/deploy-test-scratch-2026-06-12/.claude/commands/prime.md` (33-line stubs, 0 marker-block lines) | — | no |
| Every other documented marker consumer (`session-start.md`, `session-plan.md`, `wrap-session.md`, `contract-check.md`, `drift-check.md`, `concurrent-session-check.md`, `detect-concurrent-session.sh`, `check-foreign-staging.sh`, `cleanup-session-marker.sh`) | reads/parses the **resolved** marker only (§ Marker resolution), never the allocation internals | no — confirmed zero hits for `axcion-session-markers` / the claim-dir contract outside `prime.md` itself and the three doc/log files above |

**Total: 3 files directly co-edited (all done); the allocation logic itself has exactly ONE runtime consumer (`/prime`), matching the pattern already established for this subsystem** — narrow by the same reasoning the prior two gates in this chain both reached. **One new, previously-unidentified consumer-topology fact surfaced in this review:** `projects/axcion-website` and `harness` are not separate git repos — `git rev-parse --path-format=absolute --git-common-dir` from both resolves to the **same** `.git` as the workspace root itself (verified directly), while each maintains its **own independent** `logs/session-notes.md` and therefore its own independent `S{N}` sequence. This means 3 of the ~24 consumers (root, `axcion-website`, `harness`) share one claim namespace despite having three unrelated `S{N}` counters — see Dimension 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded file (CLAUDE.md) touched; `git diff --stat` confirms exactly 3 files (`prime.md`, `docs/session-marker.md`, `logs/improvement-log.md`).
- Runs once per `/prime` invocation, same frequency as before. No new hook registered.
- Marginal added cost when the code actually completes: one `git rev-parse`, one `mkdir -p`, up to two bounded loops (same-day claim count, typically small), one atomic-claim retry loop (bounded by same-second collision count, typically 1 iteration). Negligible.
- (As shipped, per Dimension 5, the block does not currently reach the point where this cost would even be paid — it aborts earlier. This does not change the Usage Cost score for the intended design; it is captured under Hidden Coupling.)

### Dimension 2: Permissions Surface
**Risk:** Low

- `git diff` touches zero `settings.json` / `settings.local.json` files (confirmed — only the 3 files above changed).
- No new capability class: `mkdir`, `rm -rf` (scoped to a path under `.git/` the code itself constructs), and read-only `git` plumbing were all already exercised by the pre-existing 3-source block.
- No settings-layer scope change.

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: 3 files directly co-edited, all done; the allocation logic's only runtime reader is `/prime` itself. Zero other files reference `axcion-session-markers` or the claim-directory contract (grep across `ai-resources/` and the workspace root, excluding `.git`, confirmed).
- Lockstep triplet independently re-verified byte-identical (md5 match across all 3 blocks after indent normalisation) — the earlier gate's `fba7ccf215b0` claim is corroborated, not merely trusted.
- R-3 closure (`--path-format=absolute`) independently confirmed present in all three blocks.
- The accepted gap (`ai-resources-research-workflow` on the old 3-source block) is independently confirmed real: direct `grep` on that checkout's `prime.md` shows "THREE sources," not "FOUR" — the worktree genuinely has not received this fix, exactly as documented.
- **Held at Low, not escalated, despite Dimension 5's finding being severe** — because Blast Radius here measures consumer/file *reach* of the change, which stays narrow (one runtime consumer), not the *severity* of a defect within that narrow footprint. The severity is scored where it belongs: Dimension 5.

### Dimension 4: Reversibility
**Risk:** Low

- Clean 3-file `git revert` / `git checkout --` — all three touched files are tracked, no sibling files or directories are created by the diff itself (the claim directories are runtime-created under `.git/`, not part of the commit).
- Given the severity of the Dimension 5 finding, reversion is in fact the fastest available fix: reverting `prime.md` to its pre-S13 state restores the working 3-source allocator immediately, with zero manual cleanup (the empty/partial `axcion-session-markers/` directory left behind by a crashed run is inert and git-untracked; it does not need to be removed for the revert to be clean).

### Dimension 5: Hidden Coupling
**Risk:** High

**Finding A — dominant, verified by direct execution, not by reading the code.** The shipped "verification standard" claims 7/7 passes from "a falsification harness on a real git repo with a real worktree… run against the block extracted from `prime.md` itself." The harness file (`scratchpad/harness.sh`, read in full) is a `#!/bin/bash` script that invokes the extracted block via `bash "$T/new.sh"` on **every** one of its 6 test scenarios (lines 54, 55, 61, 68, 74–75, 85, 93 all say `bash "$T/new.sh"`). **This never exercises the actual execution shell.** Directly confirmed in this review's own tool session: `$0` = `/bin/zsh`, `ZSH_VERSION=5.9`, `BASH_VERSION` unset — the Bash tool that will run `/prime`'s fenced code **is zsh**, not bash, exactly as the operator's own standing note states ("Bash-tool runs via zsh… validate shell code by execution, not just review").

zsh's default `NOMATCH` option turns an unmatched glob in a `for x in pattern*; do` clause into a **hard, script-aborting error** — unlike bash, which (without `nullglob`) passes the literal unmatched string through, letting the `[ -d "$d" ] || continue` guard inside the loop body handle it gracefully. The shipped code's own comment at line 358 (`# no matches → glob stays literal`) states the **bash** behaviour as if it were universal; it is not, under the actual runtime shell.

Both of the two **new** for-loops added by this change run the glob **before** any claim can exist:
```
for d in "$CLAIMS"/${TODAY}-S*; do   # SCAN — runs before the mkdir claim step
for d in "$CLAIMS"/*; do             # PRUNE — same issue
```
`$CLAIMS` is freshly `mkdir -p`'d immediately beforehand, so on the **very first invocation ever** (and, since the prune step is unreachable once the scan crashes, on **every subsequent invocation whose most-recent claim is not dated today** — i.e., the first `/prime` of every calendar day, forever, in every consuming repo) the directory is either empty or contains only non-today entries. Reproduced directly, three independent ways, in this session's own tool environment, against a genuinely fresh git repo:
- Isolated minimal repro (`for d in "$EMPTY_DIR"/pattern*; do … done`) → `zsh: no matches found: …`, exit 1, and the line immediately after the loop is never reached.
- The exact block extracted from the shipped `prime.md` (lines 332–382, byte-for-byte), run via `bash <script>` → **succeeds** (confirms the harness's own result is genuine, but only under bash).
- The **same** exact block, run via the live Bash tool directly (the actual `/prime` execution path) against a fresh repo → **`(eval):28: no matches found: …/axcion-session-markers/2026-07-13-S*`, exit 1, `logs/.session-marker` never written.** Re-run a second time with only a stale (non-today) claim present → **same crash.**
- **Live-repo check, this exact `ai-resources` checkout:** `ls "$(git rev-parse --path-format=absolute --git-common-dir)/axcion-session-markers/"` → **`No such file or directory`.** The claims directory does not exist yet in the repo under review — meaning the fix has not yet survived a single `/prime` re-invocation since landing, and the **next** `/prime` call in this exact repo will hit this crash, guaranteed, not hypothetically.

**Consequence if committed as-is:** `/prime` — the single most frequently invoked command in the entire system, run at the start of every session in every one of the ~24 consuming repos — fails to complete its marker-allocation step on its very next invocation, every day, everywhere, until fixed. `MARKER` is never set; `logs/.session-marker` is never written; the downstream header-existence check and mtime write (which depend on `${MARKER}`) are left in an undefined state.

**Viable, specific, verified mitigation:** replace both raw shell globs with a `find`-based enumeration, which has no glob-expansion-time failure mode under either shell:
```bash
for d in $(find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d -name "${TODAY}-S*" 2>/dev/null); do
for d in $(find "$CLAIMS" -mindepth 1 -maxdepth 1 -type d 2>/dev/null); do
```
Verified directly in this review: on a genuinely empty `$CLAIMS`, both loops complete with no error (script reaches its final line); with real today-dated and stale entries present, `HIGH` is computed correctly (3) and the stale entry is correctly identified for pruning. This is a two-line, drop-in fix to the already-shipped block — it does not change the allocation semantics, the fail-safe invariant, or the lockstep-triplet requirement.

**Finding B — secondary, real but lower severity: the R-4 "closed in the design's favour" reasoning is factually wrong for at least 2 of the ~24 consumers.** The claim in both `docs/session-marker.md` and `logs/improvement-log.md` is: "S{N} is per-repo by design… the scope of the common dir and the scope of the namespace are the same scope." Directly verified against the live topology: `projects/axcion-website` and `harness` are **not** separate git repos — `git rev-parse --path-format=absolute --git-common-dir` from both resolves to the **same** `.git` as the workspace-root repo itself — while each maintains its **own independent** `logs/session-notes.md` (confirmed: different content, different `S{N}` history). Sources (a)/(b)/(c) are correctly cwd-scoped (relative paths, and `git grep`'s pathspec resolves relative to cwd) and so remain correctly isolated per sub-project even inside a shared repo — but the **new** source (d)'s claim directory is keyed **only** by common-dir, with no cwd/sub-tree disambiguation. Consequence: a busy day of root-level `/prime` activity will cause `axcion-website`'s or `harness`'s next `/prime` to see the root's claims and skip its own `S{N}` ahead unnecessarily — not destructive (per the established "markers are identifiers, gaps are inert" finding from the S6 gate), but it directly falsifies a claim the shipped docs record as "closed… by design," which is worse than an undocumented gap because it invites false confidence. **Viable mitigation:** scope the claim path by the cwd's repo-relative prefix, e.g. `CLAIMS="$GIT_COMMON/axcion-session-markers/$(git rev-parse --show-prefix 2>/dev/null | tr '/' '_')"` — verified directly: `git rev-parse --show-prefix` returns `projects/axcion-website/` and `harness/` respectively from those two checkouts, and empty from the repo root, giving each of the 3 co-located consumers its own sub-namespace while preserving the intended cross-worktree sharing (a worktree of the *same* project, opened at its root, has the same empty/prefix value as its main checkout).

**Finding C — accepted, correctly characterised, no new issue.** `ai-resources-research-workflow`'s stale real-file `prime.md` (10 commits behind, old 3-source block) is exactly as documented — confirmed directly, not on trust.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md` (present).

- **OP-9 / DR-7 / AP-7 (speculative abstraction) — not violated.** The fix closes a confirmed, reproduced incident (S11 in-flight collision), not a hypothetical. No new command, agent, or gate is introduced.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7) — not applicable.** No new command/agent/mandatory stage/always-loaded doc; the change modifies an existing block.
- **OP-12 (closure before detection) — served.** The change closes a defect rather than adding new detection.
- **OP-5 (advisory vs. enforcement) — untouched.** No advisory mechanism gains new blocking authority.
- **OP-3 (loud failure over silent continuation) — worth a note, not a violation.** The shipped "verification standard" paragraph in `session-marker.md` and the improvement-log's "7/7" claim assert a rigor that this review found incomplete (Dimension 5, Finding A) — the claim itself is not a principle violation (it was a genuine, good-faith test that used the wrong shell, not a fabricated result), but it is a reminder that "verified by falsification" language should name the interpreter it ran under, so a future reader does not mistake bash-verified for zsh-verified. Worth adding to the verification-standard note once the Dimension 5 mitigation lands.
- **Structural-fix-as-default-style — honoured in intent.** The mutex mechanism is a genuine structural fix, not a patch; the defect found here is an implementation bug in that structural fix, not a reversion to patch-style thinking.
- **DR-1 / DR-3 (placement) — correct.** Allocator logic stays in `/prime`; the contract doc stays in the existing canonical `session-marker.md`.

## Mitigations

- **[REQUIRED — Dimension 5, Finding A, must-fix before commit] Replace both new `for d in "$CLAIMS"/...*; do` glob loops with the `find`-based enumeration shown above**, then re-run the falsification harness with every `bash "$T/new.sh"` invocation changed to `zsh "$T/new.sh"` (or equivalently, drop the `#!/bin/bash` shebang assumption and invoke via the actual Bash tool) before re-shipping. Until this lands, do not commit — the next `/prime` invocation in this exact repo will reproduce the crash verified above.
- **[REQUIRED — Dimension 5, Finding B] Scope the claim directory by `git rev-parse --show-prefix`** (verified above) so `projects/axcion-website`, `harness`, and the workspace root — which share one `.git` common dir but maintain three independent `S{N}` sequences — do not share one claim namespace. Update the R-4 closure note in both `docs/session-marker.md` and `logs/improvement-log.md` to describe the corrected scoping rather than re-asserting "the scope of the common dir and the scope of the namespace are the same scope," which is false for these two consumers.
- **[OPTIONAL — Dimension 6, OP-3 hardening] Amend the "Verification standard" paragraph** in `docs/session-marker.md` to name the interpreter the falsification harness ran under, so "verified by execution" cannot be read as covering shells it did not test.

## Evidence-Grounding Note

All risk levels grounded in direct evidence, gathered by execution, not by re-reading the shipped claims. Specifically: the 3-block lockstep triplet was independently re-hashed (md5, not trusted from the log); `--path-format=absolute` presence was grep-confirmed in all 3 blocks; the accepted-gap worktree was independently re-verified (`grep` for "THREE sources" vs "FOUR", sha/line-count comparison); the workspace topology was walked directly (`git rev-parse --path-format=absolute --git-common-dir` run from `projects/axcion-website`, `harness`, `projects/strategic-os`, `projects/positioning-research`, `knowledge-bases/pe-kb-vault`, and the workspace root, plus a check of each project's own `logs/session-notes.md` existence/content); the dominant Dimension 5 finding was reproduced three independent ways in this session's own live tool environment (isolated minimal repro, the exact extracted block under `bash`, the exact extracted block under the live Bash tool against a fresh repo), and the live `ai-resources` claims directory was confirmed absent (`ls` → `No such file or directory`), meaning the defect has not yet fired only because `/prime` has not been re-invoked since the fix landed — not because the defect is latent or conditional. The proposed `find`-based mitigation was itself executed and confirmed to complete without error on both an empty and a populated claims directory, and to compute `HIGH` correctly in the populated case. No training-data fallback was used on any read or execution failure; where sandbox restrictions blocked a specific probe (a `rm -rf` targeting a path under `.git/` in the scratch test repo), the test was restructured around the restriction rather than asserted.
