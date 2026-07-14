# Risk Check — 2026-07-14

## Change

Two coupled structural changes to the ai-resources harness, planned in logs/session-plan-2026-07-14-S3.md (READ IT FIRST — it carries the findings and the counter-arguments).

CHANGE 1 — Destructive-op liveness pre-flight.
- Add a new section to `docs/commit-discipline.md`: before any `git worktree remove` / `branch -D` / `branch -d` / `reset --hard` / `clean -f`, the EXECUTOR (not a gate, not /risk-check) must probe the TARGET checkout: (a) `git -C <target> status --short`, (b) `ls <target>/logs/.session-marker-*` (any date), (c) mtimes of dirty files. Any hit -> STOP and ask the operator.
- Edit `.claude/commands/close-worktree-session.md` Step 3: remove the TODAY-only date filter on the marker scan (an overnight session's marker currently does not match, so the guard silently passes), and add the mtime probe. NOTE: this session VERIFIED by direct read that close-worktree-session's Steps 2-3 already probe the TARGET checkout correctly ($WT_PATH), contrary to the backlog entry's suspicion. The guard is sound; these are two residual gaps in it.
- Edit `.claude/commands/new-worktree-session.md` Step 5 (lines ~118-124): its "Equivalent by hand, if you prefer — but you lose the guards" block prints `git worktree remove` + `git branch -d` verbatim, guarded only by prose ("Never remove a worktree a live session still occupies"). This is the documented on-ramp to the exact failure. NOTE: this file is a SCOPE EXPANSION — not in the session's declared Files in scope.
- Provenance: on 2026-07-14, session S2 planned `git worktree remove` on a worktree holding a LIVE Claude session with 173+ lines of uncommitted work across 5 files. /risk-check ITSELF reviewed that action and scored it "Reversibility: Medium", reasoning the worktree was "reconstructible" from the merge commit — true of COMMITTED content, silent about UNCOMMITTED content. Only the operator noticing an open VS Code window prevented the loss.

CHANGE 2 — Prevention (b): mechanical `Files in scope` check.
- Edit `.claude/commands/session-start.md` Step 2.5 check 3. Today it reads: "files_in_scope either lists >=1 concrete path OR is explicitly (inferred). Empty / bare placeholder fails." It tests NON-EMPTINESS ONLY — so S2's prose footprint ("the 18 files carried by the branch") PASSES it today. Tighten the predicate to: every entry must be a literal path AND exist on disk. Preserve `(inferred)` as the one legal non-listed shape.
- Add a companion rule at Step 3: the field carries pasted literal paths; a reference to a command is not a footprint (its consumer is a parser, not a reader).
- Mirror the same check into `.claude/commands/prime.md` Step 8c.7 (auto mode has NO Step-2.5-equivalent self-check at all today — it derives files_in_scope at 8c.4 and writes it at 8c.7 with nothing in between).
- Downstream relevance: `.claude/hooks/check-foreign-staging.sh` reads the `- Files in scope:` bullet and FAILS OPEN when it is prose / (inferred) / has no concrete path — so a prose footprint means NO tripwire protection at all.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-plan-2026-07-14-S3.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/close-worktree-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-worktree-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists (2026-07-14 S2 entry, incident provenance)

## Verdict

RECONSIDER

**Summary:** Both dimensions the change itself flags as risky (blast radius, and the doctrine's actual enforceability) turn out to be worse than stated — every symlink/real-file count in the change description undercounts, a live un-synced worktree fork was omitted from the census entirely, and the core mechanism (a prose doctrine in a doc the executor must remember to consult) is, on a step-by-step trace, unlikely to have reliably prevented the exact incident it is named for.

## Consumer Inventory

Search terms derived: basenames of all 5 referenced command/doc files (`prime.md`, `session-start.md`, `close-worktree-session.md`, `new-worktree-session.md`, `commit-discipline.md`); the parse-contract marker `- Files in scope:`; the schema token `(inferred)`. Grepped via `find`/`grep` across `ai-resources/` and the workspace root (`..`), including sibling repos under `projects/*/` and the sibling repo `ai-resources-research-workflow/`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources-research-workflow/.claude/commands/prime.md` (real file, linked-worktree copy of `ai-resources`, branch `session/2026-07-13-research-workflow`, NOT a symlink) | co-edits | yes |
| `ai-resources-research-workflow/.claude/commands/session-start.md` (same worktree, real file) | co-edits | yes |
| `ai-resources-research-workflow/.claude/commands/close-worktree-session.md` (same worktree, real file) | co-edits | yes |
| `ai-resources-research-workflow/.claude/commands/new-worktree-session.md` (same worktree, real file) | co-edits | yes |
| `ai-resources-research-workflow/docs/commit-discipline.md` (same worktree, real file) | co-edits | yes |
| 24 symlinks of `prime.md` (workspace-root `.claude/commands/`, `harness/`, `archive/nordic-pe-macro-landscape-H1-2026/`, and 21 `projects/*` / `knowledge-bases/*` dirs) | invokes | no (auto-inherit canonical body) |
| 22 symlinks of `session-start.md` (workspace-root absent here; `harness/`, `archive/…`, and 20 `projects/*`/`knowledge-bases/*` dirs) | invokes | no |
| 1 symlink of `close-worktree-session.md` (`projects/buy-side-service-plan/`) | invokes | no |
| 15 symlinks of `new-worktree-session.md` (`projects/*` and `knowledge-bases/pe-kb-vault/`) | invokes | no |
| `.claude/commands/wrap-session.md` Step 7a (canonical) — coaching-data classification | parses | no (compatible: stricter predicate still emits literal paths) |
| workspace-root `wrap-session.md` Step 2b — Phase 3 session report | parses | no |
| `.claude/commands/drift-check.md` Step 5 — mandate auto-detection | parses | no |
| `.claude/commands/contract-check.md` Step 2.5c — mandate-block contract-source detection | parses | no |
| `.claude/commands/concurrent-session-check.md` Step 3 — reads `- Files in scope:` for the pre-flight collision check | parses | no |
| `.claude/hooks/check-foreign-staging.sh` (wired at USER level, `~/.claude/settings.json`, NOT in `ai-resources/.claude/settings.json` as `commit-discipline.md` and the change description both assert — see Dimension 5) — parses the same `- Files in scope:` bullet with its OWN independent path-shape regex (`[\w./-]+\.\w+|[\w-]+/`) to decide fail-open vs. armed | parses | no (compatibility with Change 2's new predicate not verified in-plan — flagged, not required) |
| `new-worktree-session.md:118-124` "Equivalent by hand" block — prints the unguarded `git worktree remove` + `git branch -d` verbatim | documents (the on-ramp to the failure) | yes (per the plan's own F2.3/Scope Alternatives) |

**Total: ~16 distinct consumer entries, covering ~74 individual file-level references (5 fork files + 62 symlinks + 6 parse-contract readers + 1 by-hand block); 6 must-change.** This is not an isolated change — see Dimension 3 for the count discrepancy against the change description's own stated census.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change 1 adds a new section to `docs/commit-discipline.md`, a pointer-loaded doc (its own header: "When to read this file:" — not always-loaded; workspace CLAUDE.md § Git edge-case rules only points at it). No per-turn cost.
- Change 1's command edits (`close-worktree-session.md`, `new-worktree-session.md`) are operator-invoked, pay-as-used commands (`disable-model-invocation: true` on both, confirmed by reading their frontmatter) — not auto-loaded.
- Change 2 tightens an existing self-check step inside `session-start.md` (Step 2.5, invoked once per mandate write) and adds a mirrored step inside `prime.md` Step 8c.7 (invoked only in auto mode, once per session). Neither is a `SessionStart`/`PreToolUse` hook and neither is always-loaded content — a few added lines to an existing inline check, well under the ~50-150 token Medium threshold.
- No new hook, no new `@import`, no new broadly-matching skill description in either change as specified.

### Dimension 2: Permissions Surface
**Risk:** Low

- Neither change touches `settings.json`, `allow`/`deny` lists, or tool-invocation patterns. Verified by reading `ai-resources/.claude/settings.json` and `ai-resources/.claude/settings.local.json` in full — no proposed edits target either file.
- Incidental finding, not a risk driver: `~/.claude/settings.json` (user level) already denies `Bash(git reset --hard *)` and `Bash(git checkout *)` — one of Change 1's five named destructive verbs (`reset --hard`) is already blocked at the permission layer, independent of this change. `worktree remove`, `branch -D`/`-d`, and `clean -f` are not denied.

### Dimension 3: Blast Radius
**Risk:** High

**Q1 (pressed) — Blast radius by symlink: is the predicate safe to propagate that widely, and are the session's counts trustworthy?** Independently re-derived via `find` (not taken on trust, per the instruction). **Every one of the four stated counts is wrong, and in the same direction — all four undercount real (non-symlink) files by omitting a live, un-synced worktree fork:**

| File | Change description claimed | Verified actual |
|---|---|---|
| `prime.md` | "1 canonical + 24 symlinks (+ 2 unrelated 33-line stubs)" = 27 total | **29 total: 2 mandate-bearing real files (canonical, 899 L, + `ai-resources-research-workflow/.claude/commands/prime.md`, 665 L, which independently contains 41 matches for `8c`/`Files in scope`/`Mandate` — NOT a stub) + 3 template stubs (33 L, 0 matches each) + 24 symlinks.** (This 29 = 24 + 5 figure is *already published* in `logs/improvement-log.md` line 850, same day, same session family — the change description did not cross-check its own repo's already-corrected count.) |
| `session-start.md` | "1 canonical + 21 symlinks" = 22 | **24 total: 2 real files (canonical + the same `ai-resources-research-workflow` fork) + 22 symlinks.** |
| `close-worktree-session.md` | "1 canonical + 1 symlink" = 2 | **3 total: 2 real files (canonical + fork) + 1 symlink (`projects/buy-side-service-plan/`).** |
| `commit-discipline.md` | "canonical real file only" = 1 | **2 total: canonical + the same fork (`ai-resources-research-workflow/docs/commit-discipline.md`).** |
| `new-worktree-session.md` | not counted at all | **17 total: 2 real files (canonical + fork) + 15 symlinks.** This file is explicitly in scope via F2.3's scope expansion, yet received zero symlink verification. |

The missed consumer in all five cases is the **same file**: `ai-resources-research-workflow`, confirmed by `cat .git` to be a genuine **linked git worktree of this repo** (`gitdir: .../ai-resources/.git/worktrees/ai-resources-research-workflow`), on branch `session/2026-07-13-research-workflow`, with commits as recent as today (`b59e038`, 2026-07-14). This is not a stale export — `git worktree list` confirms it is a currently-registered worktree, currently clean and marker-free (its earlier live session appears to have wrapped since the S2/S3 narrative), but on a branch that has **not** been rebased/merged onto `main` (per `improvement-log.md` line 843-850, that rebase is explicitly blocked pending operator confirmation). Editing the canonical files on `main` will **not** appear in this worktree until that merge happens — it is a real, currently-diverging consumer, not an auto-syncing symlink. **This is the exact worktree at the center of the S2 incident this whole change exists to prevent**, and it was omitted from the blast-radius census used to justify the change.

Symlink propagation itself (24/22/1/15 symlinks) is by design a single-source-of-truth pattern and is not inherently risky — but it does mechanically satisfy the rubric's ">5 dependent callers" High trigger for three of the four files, and the change also touches **shared infra**: `session-start.md`'s `- Files in scope:` bullet is a documented parse contract read by **six** listed readers (`wrap-session.md` canonical + workspace-root, `drift-check.md`, `contract-check.md`, `concurrent-session-check.md`, plus `check-foreign-staging.sh` — the sixth is undocumented in `session-start.md`'s own "six readers" list, see Dimension 5). That crosses the "shared infra touched in a way that affects multiple workflows" High trigger independently of the symlink count.

### Dimension 4: Reversibility
**Risk:** Low

- All edits (doc section, two command bodies, two command self-check steps) are plain-text edits to git-tracked files; `git revert` fully restores prior text in one step.
- The plan's Stage 4 flips two `improvement-log.md` entries from OPEN to applied (an in-place status mutation). Per `docs/commit-discipline.md` § Maintenance-owned in-place mutations, this is reserved for dedicated single-purpose sessions — the plan's own Risk section confirms this session qualifies (single-purpose, no concurrent session in this checkout) and states the conflict check explicitly. A `git revert` of that commit restores the OPEN status cleanly; no external push, no cross-repo write, no non-git state to clean up.
- No `git push` is in scope (plan Step 12 states "No push — batched to wrap"), so nothing propagates beyond the local repo before an operator gate.

### Dimension 5: Hidden Coupling
**Risk:** High

**Q2 (pressed) — is the hard-path / warn-on-existence split the right cut?** The cut is right, with one refinement worth naming. Verified against `session-start.md` Step 2 (read in full): `files_in_scope` ("which files may be edited") and `required_outputs` ("files/artifacts the session must produce") are already two separate, distinct fields — a to-be-created output arguably belongs in `required_outputs`, not `files_in_scope`, but the command's own Step 2.5 self-check text and real-world usage mix them freely, and Step 2.5 today performs **no existence check of any kind** (only non-emptiness). Making the lexical "is this path-shaped" test HARD (reject prose, e.g. `"the 18 files carried by the branch"`) and the "does this exist on disk" test WARN-only is the correct asymmetry: the lexical test has near-zero false-positive risk against legitimate mandates (a real path, glob, or directory always parses as path-shaped), while the existence test would false-reject every legitimate to-be-created output if made a hard gate. Recommendation to fold in: the companion rule at Step 3 should explicitly note that a to-be-created path is better placed in `required_outputs`, with `files_in_scope`'s existence check remaining warn-only as the safety net for the common case where operators mix the two fields anyway.

**Q4 (pressed) — is a third option (a PreToolUse(Bash) hook) available, and is it the right answer?** `check-foreign-staging.sh` was read in full. It confirms the pattern exists in this repo: a `PreToolUse(Bash)` hook that regex-matches gated git verbs at a command-segment boundary, reads session state from disk, and either allows, warns (`additionalContext`, non-blocking), or blocks (`exit 2`, stderr fed back to the **agent**, not an operator permission prompt) — explicitly built to respect OP-5 (advisory, not enforcement) and the zero-permission-prompt / `bypassPermissions` floor (verified: `defaultMode: bypassPermissions` is set at both the `ai-resources` and user-level `settings.json`). **Correction to the change description's own premise:** the hook is wired at the **user level** (`~/.claude/settings.json` line 61), not in `ai-resources/.claude/settings.json` as both the change description and `commit-discipline.md` line 29 assert ("wired in `.claude/settings.json`") — grep confirms zero mention of `check-foreign-staging` in any `ai-resources/.claude/settings*.json`. The mechanism and its advisory posture are real and correctly characterized; only the settings-file location is misstated. A hook implementing Change 1's three probes, matching `git worktree remove` / `branch -D` / `branch -d` / `reset --hard` / `clean -f` at the same command-segment boundary, would fire **regardless of whether the executor remembers to consult `commit-discipline.md`** — this is the load-bearing property the doc-only route lacks (see Q5). It is the right answer to "how do you make this mechanical rather than memory-dependent," but it is explicitly **not** part of the change as specified, and hook edits are their own `/risk-check`-required structural class per workspace CLAUDE.md Autonomy Rule #9 / `DR-8` — landing it inside this change would be an undisclosed scope expansion on top of the one already disclosed (`new-worktree-session.md`).

Coupling findings, both meeting the High bar independently:
- **Undocumented/unverified implicit dependency:** Change 2's new predicate for `- Files in scope:` and `check-foreign-staging.sh`'s existing independent path-shape regex (`re.search(r'[\w./-]+\.\w+|[\w-]+/', footprint_raw)`, `check-foreign-staging.sh` line 267) are two separately-coded "is this a path" tests that must stay compatible but are not unified or cross-referenced in the plan. The plan's F3.3 cites the hook only as a *beneficiary* of the change, never as a compatibility surface to verify against the new predicate's output shape.
- **Functional overlap with an already-failed mechanism (explicit High trigger):** Change 1's doctrine is a *third* prose-based liveness warning layered on top of two that already exist and already failed to fire in the S2 incident — `new-worktree-session.md`'s "Never remove a worktree a live session still occupies" (line 126) and `close-worktree-session.md`'s Step 2-3 guards (which are sound, per F2.1, but were never invoked because S2 ran the destructive command outside that command entirely). Adding a fourth prose location (`commit-discipline.md`) without a mechanical trigger is overlap, not consolidation, of the same failed control class — see Q5.

### Dimension 6: Principle Alignment
**Risk:** Medium

Ground: `projects/strategic-os/ai-strategy/principles-base.md` was read in full (42-principle frozen-ID index); workspace CLAUDE.md § Design Judgment Principles and Autonomy Rules were read per the standard context load.

**Q5 (pressed) — would the proposed text have prevented the S2 incident, or does it only document it? Brutal answer: it only documents it, unless paired with an execution-time enforcement mechanism.** Tracing S2 step by step against Change 1 as specified: S2's mandate, session plan (Stage 1 step 6), and `/risk-check` prompt all specified `git worktree remove` + `git branch -D` directly — **the destructive command was never routed through `/close-worktree-session`**, so that command's guards (sound, per F2.1) were structurally never in the path. The one thing that WOULD have caught it mechanically if reached — probe (b), `ls <target>/logs/.session-marker-*` (any date) — is well-designed: the worktree had a primed, un-wrapped session, so a per-id marker file would have been present, and probe (b) does not depend on the exact moment of dirtiness the way probe (a) does. **But this only matters if the executor actually stops and reads `docs/commit-discipline.md`'s new section at the exact moment of invoking the destructive verb from a freeform session plan** — and the S2 incident is direct, same-day proof that a functionally identical prose warning (`new-worktree-session.md:126`, already on the books before this change) did **not** fire under exactly these conditions, for exactly this reason: the destructive command was assembled directly in a session plan, never touching the document or command that carried the warning. Nothing about placing a *second* prose warning in a *different* document changes that causal path. The honest answer is that Change 1, as specified, converts an undocumented gap into a documented one — a real and worthwhile improvement — but it does not convert a memory-dependent failure into a mechanically-enforced one, which is the improvement-log entry's own stated goal ("no gate can catch this").

This is a live tension with **OP-2** ("Automate execution; gate judgment... full autonomy for execution") — the liveness probe is a deterministic, mechanical check (file exists? tree dirty? marker present?), not a judgment call, and OP-2's framing favors automating exactly this class of check rather than leaving it to be manually recalled from a doc at the correct moment. It does not rise to a clear, unacknowledged violation: the session plan is explicit and self-aware about the tradeoff (Stage 1 step 3 explicitly forbids the `/risk-check` route and names the anti-pattern; the Risk section flags the predicate-strictness risk and asks this very review to weigh in), so this is disclosed tension, not silent drift (**OP-11**/**OP-3** — a revision would need to be loud, and the plan is at least transparent about the mechanism's limits even if it does not draw the OP-2 conclusion itself).

Other principle checks, all clear:
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** not applicable — both changes fix a demonstrated, dated defect (the S2 near-miss; the 4-for-4 assert-from-recall pattern) with confirmed existing consumers (`/close-worktree-session`, `/prime` auto mode), not a hypothetical future one.
- **OP-12 (closure before detection):** not applicable — neither change adds a new detection/finding-generator with no closure channel; both are inline "reject or re-derive now" checks, closed at the point of detection.
- **DR-8:** correctly followed — the plan already routes through `/risk-check` at plan-time per Autonomy Rule #9, and this review is that gate.

**Q3 (pressed) — does the "not a new gate, just a tightened predicate" defence hold? Judged separately for the two halves, as instructed.** For `session-start.md` Step 2.5 check 3: **the defence holds.** The check already exists (verified by reading Step 2.5 in full — "files_in_scope either lists ≥1 concrete path OR is explicitly (inferred)"); tightening its predicate from non-empty to path-shaped-and-verified is definitionally a strengthening of an existing gate, not a new one, and the `/lean-repo` RR-05 over-gating objection does not land here. For `prime.md` Step 8c.7: **the defence does not extend, and the plan's own F3.2 says so** ("Auto mode has NO self-check at all"). This half is structurally a new check at that entry point. It is not, however, an instance of the over-gating anti-pattern RR-05 warns against: it is a single inline mechanical check (no subagent, no dispatch, no extra approval step) that brings the less-supervised auto-mode path to parity with the already-existing manual path, justified by a demonstrated, repeated defect (four same-day recall failures) rather than speculative hardening. Net: clears on its own distinct grounds, not by borrowing F3.1's argument.

## Recommended redesign

- **Close the fork gap before landing, and treat `new-worktree-session.md` as unverified until it is.** Before shipping the canonical edits, explicitly resolve `ai-resources-research-workflow` (the live linked worktree on `session/2026-07-13-research-workflow`) — either sync it now (rebase/merge, unblocking the already-open marker-mutex fix in `improvement-log.md` line 843), or log a stated, deliberate decision to leave it stale with the drift risk named. Do not ship while the change description's own blast-radius claim is factually wrong on all four counted files and silent on the fifth (`new-worktree-session.md`, 17 total consumers, never verified this session).
- **Split Change 1 into an honest two-part shape.** Land the doc/command edits as a *necessary-but-not-sufficient* documentation improvement (reframe the improvement-log entry's verification line accordingly — it should not claim the gate is closed). Scope a **separate**, separately-`/risk-check`'d follow-up: a `PreToolUse(Bash)` hook, patterned directly on `check-foreign-staging.sh`'s advisory posture (OP-5-compliant, `exit 2` to the agent, respects the `bypassPermissions` floor), that matches the five destructive verbs at a command-segment boundary and runs the three liveness probes against the resolved target checkout at the moment the command is about to execute — independent of whether the executor has read any doc. This is the only mechanism in this change set that would have fired regardless of memory, per the Q5 trace.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. All symlink/real-file counts were independently re-derived via `find` against the live filesystem, not taken from the change description.
