# Risk Check — 2026-07-19

## Change

Bundle of three repo-health fixes gated in one pass, per `logs/session-plan-2026-07-19-S4-2b2.md` (mission `repo-health-backlog-2026-07`):

- **Item 0 (context only, not a proposed change):** confirm mission thread 5 (`/permission-sweep` merged-layer fix) is already shipped in commit `b7b6911`.
- **Item 1:** fix `check-foreign-staging.sh` (`:223-229`) resolving the gated `git add`/`git commit` staging check against `CLAUDE_PROJECT_DIR`/`os.getcwd()` instead of the Bash call's actual target repo — producing a false BLOCK when the command runs inside a nested project repo. Proposed fix: resolve the toplevel from the PreToolUse payload's `cwd` field, run the git probes with `-C <that toplevel>`, relativize footprint paths against the same root; degrade to soft-warn when the resolved toplevel is not confidently trustworthy (e.g., an unresolvable leading `cd` in a compound command).
- **Item 4 (mission thread 14):** three hooks that ship looking installed and fire nowhere. (a) `warn-settings-change.sh` (workspace-root, unwired, fails open on the real payload shape) — recommendation: delete. (b) `check-claim-ids.sh` (7 copies on disk; research-workflow template ships it unregistered) — decide wire-or-remove in the template. (c) `friction-log-auto.sh` PostToolUse branch registered in `ai-resources` but not in the research-workflow template — bring the template into line.
- **Item 6:** delete the falsified sentence at `prime.md:224` ("As of 2026-07-18, 30 of 87 entries carry no `Severity` field at all") — the 2026-07-18 backfill took the count to 0; only the stale figure is removed, the surrounding rationale stays.

## Referenced files

- ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- ai-resources/.claude/commands/prime.md — exists
- ai-resources/docs/commit-discipline.md — exists
- ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists
- ai-resources/logs/improvement-log.md — exists
- .claude/hooks/warn-settings-change.sh (workspace root) — exists
- ai-resources/workflows/research-workflow/.claude/hooks/check-claim-ids.sh — exists
- ai-resources/workflows/research-workflow/.claude/settings.json — exists
- ai-resources/logs/session-plan-2026-07-19-S4-2b2.md — exists

## Verdict

**BUNDLE: RECONSIDER** — dragged down by **Item 1 alone**. Items 4 and 6 clear independently and may proceed on their own merits, matching the session plan's own item-scoped gating design ("On RECONSIDER … for an item, that item stops … the other items proceed only if the verdict is item-scoped").

**Per-item verdicts:**

| Item | Verdict | Driving dimension(s) |
|---|---|---|
| 0 — thread 5 shipped? | **CONFIRMED SHIPPED** (not gated — context only) | n/a |
| 1 — staging hook repo resolution | **RECONSIDER** | Blast Radius (High), Hidden Coupling (High) |
| 4(a) — `warn-settings-change.sh` delete | **PROCEED-WITH-CAUTION** | Blast Radius, Hidden Coupling, Reversibility, Principle Alignment, Problem Reality — all Medium |
| 4(b) — `check-claim-ids.sh` wire/remove | **GO** | none elevated |
| 4(c) — friction-log template parity | **GO** | none elevated (one Medium: Problem Reality, non-driving) |
| 6 — delete stale `prime.md:224` sentence | **PROCEED-WITH-CAUTION** | Blast Radius (High), mitigated |

**Summary:** the real defect behind Item 1 is genuine and directly confirmed, but the fix *as scoped* still carries an unresolved design gap (compound `cd`) on the single highest-leverage, globally-wired hook in the workspace — that combination is what RECONSIDERs. Item 4(a)'s "delete the orphan" call is sound but was made without seeing a live planned dependency (System Owner v2 stage S2/B3) and overstated its urgency ("actively replicating" is false); both are fixable by pairing the delete with a loud, recorded note rather than by not deleting. Item 4(b)/(c) and Item 6 are clean, low-risk, well-evidenced fixes.

## Consumer Inventory

Search terms derived from each hook/file's basename (`check-foreign-staging`, `warn-settings-change`, `check-claim-ids`, `friction-log-auto`) plus the item-6 contract marker (`30 of 87`). Grepped with `command grep` (not the ambient shell alias) across `ai-resources/` and the workspace root, per Step 1.5. Raw hit counts are large (mostly historical audit/scratchpad prose); the table below lists the structurally load-bearing consumers — registrations, live/maintained docs, co-edit siblings, and any consumer *not* named in the change description — with the prose long-tail summarized by count.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `~/.claude/settings.json:60` | invokes (global PreToolUse[Bash] registration for `check-foreign-staging.sh`, fires in every checkout) | no — wiring unaffected, only internal logic changes |
| `ai-resources/docs/commit-discipline.md` § Foreign-staging tripwire | documents (describes the current footprint/repo-resolution contract in detail) | yes — must be updated to describe the fixed resolution logic |
| `ai-resources/.claude/commands/risk-check.md`, `session-start.md`, `prime.md` | documents (brief mentions) | no |
| `ai-resources/logs/missions/repo-health-backlog-2026-07.md` (thread, "Routed OUT" note) | documents | yes — close/update the routed-out note when the fix lands |
| `ai-resources/logs/improvement-log.md:1488-1516` | documents (source defect entry) | yes — flip status per mission non-negotiable ("close the log entry when the fix lands") |
| `ai-resources/.codex/hooks/check-foreign-staging.sh` | co-edit (divergent sibling fork, **not named in the change description**) | no today (confirmed unregistered in `.codex/hooks.json` — inert), but a silent-drift risk if left unaddressed |
| `~/.claude/settings.json`, `ai-resources/.claude/settings.json` (warn-settings-change) | absence confirmed — zero registrations either layer | n/a |
| `projects/repo-documentation/vault/blueprint/blueprint.md:105` | documents (status: active, last_updated 2026-07-03) | yes |
| `projects/repo-documentation/vault/components/hooks.md:153-168` | documents (component registry, Status: active) | yes |
| `projects/repo-documentation/vault/architecture/system-doc.md:200` | documents | yes |
| `projects/project-planning/Project Plans/system-owner-v2/control-pack/technical-design.md:32-34` (B3) | depends-on (plans to **wire** this exact file as a working gate) | **yes — not named in the change description; found by this gate** |
| `projects/project-planning/Project Plans/system-owner-v2/control-pack/execution-roadmap.md:30` (Session S2) | depends-on (sequences B3 into the SO v2 build order) | **yes — not named in the change description; found by this gate** |
| `projects/axcion-ai-system-owner/output/consultations/consult-2026-07-14-repo-repair-pilot-v1.md:103-127` | documents (the corrective consult that already recommends deletion and already disproves the "actively replicating" framing) | no |
| ~54 other prose mentions (audits, session-notes, scratchpads — point-in-time records) | documents | no |
| `ai-resources/workflows/research-workflow/.claude/hooks/check-claim-ids.sh` + `.claude/settings.json` | co-edit sibling / absent registration | depends on wire-vs-remove decision |
| `archive/nordic-pe-macro-landscape-H1-2026/.claude/settings.json`, `projects/buy-side-service-plan/.claude/settings.json`, `projects/buy-side-service-plan/.codex/hooks.json` | invokes (3 live registrations, pre-existing, independent of this change) | no |
| 4 other `check-claim-ids.sh` copies (axcion-sector-intelligence, positioning-research, research-pe-regime-shift-advisory-gap, archive) | unregistered siblings | no — out of mission scope, routed |
| `ai-resources/.claude/settings.json` (friction-log-auto canonical) | invokes (PreToolUse\|Skill + PostToolUse\|Bash\|Write\|Edit\|Agent\|Skill) | no — source of truth, unaffected |
| `ai-resources/workflows/research-workflow/.claude/settings.json` (friction-log-auto template) | invokes (PreToolUse\|Skill only — the actual edit target) | yes |
| `projects/positioning-research/.claude/settings.json` | invokes — **already has both branches wired**, contradicting the "every deployment" claim | no |
| 4 other friction-log-auto deployments (archive, buy-side-service-plan, research-pe-regime-shift-advisory-gap, axcion-sector-intelligence) | invokes (PreToolUse\|Skill only) | no — out of mission scope, routed |
| 26 symlinked `prime.md` consumers (workspace-root, `ai-resources` itself, `harness/`, `archive/`, ~22 project checkouts) | imports (byte-identical via symlink) | no — auto-propagates atomically |
| `ai-resources/workflows/research-workflow/.claude/commands/prime.md`, `projects/axcion-sector-intelligence/.claude/commands/prime.md` | **not** consumers of this edit — independent 1537-byte files, do not contain the stale line (verified) | no |

**Total: ~30 structurally distinct consumers identified, 7 must-change** (2 for Item 1's doc/log updates; 4 newly-found for Item 4(a) — 3 vault docs + the SO v2 control-pack that were **not named in the change description**; 1 for Item 4(c)'s template edit). The long prose tail (~54+ files for `warn-settings-change`, 100+ for `check-foreign-staging`/`friction-log-auto`) is historical/point-in-time and not enumerated row-by-row.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low (all items)

- **Item 1** — internal logic edit to an already-registered PreToolUse(Bash) hook; no new registration, no new context injection. `payload.get("cwd")` is free (the payload is already parsed at `:83`).
- **Item 4(a)** — pure deletion, reduces surface.
- **Item 4(b)** — `check-claim-ids.sh` is a non-blocking PostToolUse(Edit) warn-only script scoped to four narrow pipeline-artifact path patterns; wiring it matches an established, already-running pattern in 3 other projects (confirmed by direct read of the script and by the 3 live JSON registrations).
- **Item 4(c)** — read `friction-log-auto.sh` directly: the PostToolUse branch exits at line 34 unless `tool_response.is_error == "true"`, injects nothing into Claude's context (writes to a log file only), and is shell-only (no LLM tokens). Cheap even at broad-matcher scope.
- **Item 6** — net-negative cost (one sentence removed from a command file read at every `/prime` invocation).

### Dimension 2: Permissions Surface
**Risk:** Low (all items)

- No item adds an allow/deny entry, widens a glob, or changes tool-invocation patterns. Item 4(a) removes a (never-firing) PreToolUse Edit/Write block — if anything, a narrowing, not a widening. Item 4(b)/(c) extend an already-authorized hook pattern already present via `~/.claude/settings.json`'s `Bash(*)`/`bypassPermissions` posture.

### Dimension 3: Blast Radius
**Risk:** Item 1 — **High**. Item 4(a) — **Medium**. Item 4(b) — Low. Item 4(c) — Low. Item 6 — **High**.

- **Item 1.** `check-foreign-staging.sh` is registered exactly once, at user level (`~/.claude/settings.json:60`), and fires on every gated git verb in **every checkout in the workspace** — the single highest-leverage hook in the repo by the consumer inventory's own measure. This is squarely "shared infra touched in a way that affects multiple workflows." Two doc/log consumers must change to stay accurate (`commit-discipline.md`, `improvement-log.md`). **High.**
- **Item 4(a).** Consumer inventory: ~58 prose mentions (all `documents`-type, no `invokes`/`parses` — nothing calls or parses this file, confirmed by zero JSON hits), plus 3 actively-maintained vault docs and 2 System Owner v2 control-pack docs that plan to depend on it (see Dimension 5 — this is the material finding). No functional/runtime breakage results from deletion (nothing invokes it); the risk is **documentation and forward-plan drift**, not broken execution. **Medium**, not High — all must-change consumers are `documents`/`depends-on` planning artifacts, none `invokes`/`parses`.
- **Item 4(b).** Bounded to the template file itself; the 5 other `check-claim-ids.sh` copies are pre-existing, independent, and explicitly out of mission scope (routed, not touched). Low.
- **Item 4(c).** Bounded to the template file; the 4 other deployments missing the PostToolUse branch are likewise out of scope and untouched by this change. Low.
- **Item 6.** 26 confirmed symlinked consumers (re-derived via `readlink`/`os.path.realpath`, not accepted from the plan — matches the plan's own "26" figure exactly). All propagate atomically and identically (zero divergence risk, zero must-change beyond the one canonical edit) — but the raw count and the fact that `prime.md` is the most-loaded command in the system is exactly why the mission's own thread 15 flags `prime.md` edits as inherently risk-check class ("`prime.md` is distributed to every project by symlink"). **High** by count and by role, even though the specific edit is a one-sentence, no-behavioral-surface deletion.

### Dimension 4: Reversibility
**Risk:** Item 1 — Medium. Item 4(a) — Medium. Item 4(b) — Low. Item 4(c) — Low. Item 6 — Low.

- **Item 1.** `git revert` cleanly restores the prior script version in the same repo. Medium, not Low, because the hook runs live and continuously (every commit, every checkout) — a bad version deployed mid-window is not merely "reverted," it has already fired incorrectly for every commit attempted in that window, and understanding whether to revert requires recognizing the failure mode first (one extra diagnostic step).
- **Item 4(a).** File deletion via git reverts cleanly. Medium because any companion doc updates (vault docs, mission note) landed in the same or adjacent commits would need their own revert/re-review if the delete is reversed — a multi-file unwind, not a single clean revert.
- **Item 4(b)/(c).** Single settings.json edits, clean `git revert`. Low.
- **Item 6.** Symlink fan-out means a single canonical-file revert atomically restores all 26 consumers simultaneously — cleaner than a typical multi-file change. Low.

### Dimension 5: Hidden Coupling
**Risk:** Item 1 — **High**. Item 4(a) — **Medium**. Item 4(b) — Low. Item 4(c) — Low. Item 6 — Low.

- **Item 1.** Two genuine implicit dependencies, both confirmed by direct evidence:
  1. **The fix's correctness now depends on the installed Claude Code version's PreToolUse payload shape.** Verified live (`curl` to `code.claude.com/docs/en/hooks.md`, fetched this session): the `cwd` field **is** documented as a top-level PreToolUse input ("Current working directory when the hook is invoked" — doc line 614; live JSON example at line 635/943/1055 etc.), and `${CLAUDE_PROJECT_DIR}` is documented as usable "regardless of the working directory when the hook runs" (doc line 487) — this substantively confirms the change description's premise, though the exact quoted phrase "doesn't change" was not found verbatim on that page (a minor overstatement, not a contradiction).
  2. **The residual gap the plan itself flags is real and unresolved.** `cwd` is a snapshot "when the hook is invoked" — i.e., *before* the gated command executes — so a compound `cd nested && git add .` in one Bash call will not have `cwd` reflect `nested`. The plan's own candidate handling ("hard block only when confidently resolved, else degrade to warn") is not yet a decided, tested design — it is exactly the open question the change description asks this gate to score. Getting this wrong reopens the fail-open that commit `979ed01` (2026-07-18) closed on the same hook.
  3. A previously undisclosed sibling fork (`ai-resources/.codex/hooks/check-foreign-staging.sh`) exists, is older (lacks the 2026-07-19 Required-outputs union), and is currently unregistered/inert — a silent-drift risk if the canonical fix lands without a decision on the fork.
  Multiple implicit dependencies, one of them load-bearing and unresolved by design → **High**.
- **Item 4(a).** One material, previously undisclosed dependency, found by this gate and not named in the change description: **System Owner v2 stage S2 / build item B3** (`projects/project-planning/Project Plans/system-owner-v2/control-pack/technical-design.md:32-34`, `execution-roadmap.md:30`) explicitly plans to "wire the already-built-but-unwired `warn-settings-change.sh`" as its mechanical protected-zone detector. That plan is dated 2026-07-03, carries no superseded/deprecated marker, and is cross-referenced from the vault's `system-doc.md:200` ("SO v2 stage S2/B3 wires it") — it reads as live, not abandoned. Note: the SO v2 B3 plan is *itself* built on the same false premise the 2026-07-14 consult already debunked (that the script works once wired) — so deleting the file doesn't by itself break a working thing, but it does invalidate an active plan's stated assumption without that plan currently knowing it. One clear implicit dependency → **Medium**.
- **Item 4(b)/(c).** No hidden dependency — 4(b) is a documented open decision; 4(c) copies an already-proven, already-running pattern verbatim from `ai-resources` (2 confirmed live consumers: `ai-resources` itself and `positioning-research`). Low.
- **Item 6.** None — pure prose deletion, nothing parses the sentence mechanically, surrounding rationale is explicitly preserved. Low.

### Dimension 6: Principle Alignment
**Risk:** Item 1 — Low. Item 4(a) — **Medium**. Item 4(b) — Low. Item 4(c) — Low. Item 6 — Low.

Ground: workspace `CLAUDE.md` § Design Judgment Principles / Autonomy Rules (read this session). `principles-base.md` was not read (not listed in inputs and not required — the inline checks below fully cover what these five items touch); noted as not consulted rather than silently skipped.

- **Item 1** — a bug fix restoring correct behavior; stays advisory (still `exit 2` to the agent, never an operator permission prompt — OP-5 posture unchanged). No new detection shipped without closure (this *closes* an existing false-block). Low.
- **Item 4(a)** — deletion of dead weight is net-simplification, not speculative abstraction (the opposite direction from OP-9/AP-7/DR-7 concerns). But **OP-11 (loud revision, never silent drift)** is in tension: an active project plan (SO v2 B3, per Dimension 5) currently assumes this file will be wired and functional. Deleting it without a recorded note that SO v2's B3 premise needs revision is silent drift into another project's forward plan — not a violation, but a real tension that the mitigation below closes. **Medium.**
- **Item 4(b)** — wiring an already-vetted, non-blocking pattern (3 live precedents) is not speculative; it is applying an existing, working convention. Low.
- **Item 4(c)** — closes a parity gap in an existing, already-proven detection channel (2 live consumers) rather than adding new unclosed detection (OP-12 not implicated — this *is* the closure, not new detection). Low.
- **Item 6** — deleting a false factual claim serves the honesty/no-silent-drift principle directly. Low.

**Scope-boundary check (Item 4, raised explicitly by the caller):** the mission's non-negotiable forbids "widening scope into the projects… a thread that turns out to live in another repo is surfaced and routed, never reached into." Touching the workspace-root `.claude/hooks/warn-settings-change.sh` is **in scope** — mission thread 14 (via the "FOLDED INTO THREAD 14" note, `repo-health-backlog-2026-07.md:157`) names this exact file specifically, and the In/Out-scope clause carves out "except where a thread names a specific file there." The research-workflow template is directly under `ai-resources/`, in scope without exception. **The boundary is drawn correctly as stated in the plan.**

### Dimension 7: Problem Reality
**Risk:** Item 1 — Low. Item 4(a) — Medium. Item 4(b) — Low. Item 4(c) — Medium. Item 6 — Low.

- **Item 1.**
  - **Defect — observed or inferred?** Observed. `improvement-log.md:1488-1516` records a real live incident (workspace-root session S2-e73) with the actual stderr block reproduced verbatim (6 foreign paths, 2 confirmed absent from the target repo). Independently re-read `check-foreign-staging.sh:223-229` myself: the code computes `project_dir` from `CLAUDE_PROJECT_DIR`/`os.getcwd()`, never from the Bash call's own cwd — a direct code-level confirmation of the mechanism, not an inherited claim.
  - **Consequence — traced or assumed?** Traced. The mechanism (wrong-root resolution) directly explains the observed symptom (workspace-root paths reported foreign, 2 nonexistent in the target repo). The "prescribed remedy is unreachable" claim is also directly evidenced in the same log entry (widening `Required outputs` was tried and re-failed identically).
  - **Re-derivation vs. the change description:** the one open item — "can a PreToolUse hook see the Bash cwd?" — was independently re-verified via a live docs fetch (not taken on the change description's or the referenced subagent's word): `cwd` **is** a documented top-level PreToolUse field. **Confirms the change description's premise; the fix is implementable as claimed.**
- **Item 4(a).**
  - **Defect — observed or inferred?** Observed. Read `warn-settings-change.sh:6` directly: `d.get('file_path','')` against a payload where the real field lives at `tool_input.file_path` — on any real payload this returns `''`, the grep never matches, and the script always `exit 0`s. Registration: `command grep -rl "warn-settings-change" --include="*.json"` across the workspace root and `~/.claude` → **zero hits**, confirming "registered nowhere."
  - **Consequence — traced or assumed?** Core consequence (inert guard, has never blocked) is traced by direct code read. **A secondary claimed consequence is contradicted:** the change description asserts the defect is "actively replicating" because the file is "cited… as proof the exit 2 pattern works… queued to be copied." Direct read of `consult-2026-07-14-repo-repair-pilot-v1.md:103-127` shows the **opposite** — that document is the one that *caught and rejected* exactly this citation ("It proves the opposite… It has never run… had it been wired, it would have silently passed every settings.json write"), and the operator's own recorded decision (`ai-resources/logs/decisions.md:73`, direct read) explicitly did **not** land the hook that would have copied the pattern (`require-gate.sh`, confirmed absent from disk via `find`). No live replication is underway; it was identified and stopped on 2026-07-14, five days before this gate.
  - **Re-derivation vs. the change description:** the "actively replicating" framing does not hold. It is not, however, the reason given for the delete recommendation (registered-nowhere + fails-open + repair cost) — that reasoning is independently sound and unaffected. **Medium**, not High: the core defect and its driving consequence are traced; a non-driving aggravating claim was found false.
- **Item 4(b).** Defect observed directly (JSON enumeration of `research-workflow/.claude/settings.json` shows zero `check-claim-ids` registration); consequence ("inherits a dead script") is a direct, mechanical implication of "never registered = never fires," not an inference. Low.
- **Item 4(c).**
  - **Defect — observed or inferred?** Observed. Direct JSON enumeration of both `ai-resources/.claude/settings.json` (both `PreToolUse|Skill` and `PostToolUse|Bash|Write|Edit|Agent|Skill` present) and the template's `settings.json` (only `PreToolUse|Skill`) confirms the gap exactly as described.
  - **Consequence — traced or assumed?** Partially contradicted. The change description states the PostToolUse branch is "dead… in every deployment." Direct enumeration of all 6 project-level `settings.json` copies shows **`positioning-research` already has both branches wired** — matching the mission's own more careful phrasing ("5 of 6 deployments"), not the change description's "every deployment." The fix (bring the *template* into line) is unaffected by this — it does not depend on the overstated count — but the urgency framing is inflated.
  - **Re-derivation vs. the change description:** "every deployment" → corrected to 5 of 6; `positioning-research` is the exception. **Medium.**
- **Item 6.** Directly re-ran the exact scan `prime.md` Step 3 itself executes: `UNCLASSIFIED: 0 of 117 entries carry no Severity field` (live execution this session, not inherited). This independently confirms the "30 of 87" sentence is stale and the true current count is 0. Line number re-confirmed at `:224` via `command grep -n "30 of 87"`. **Low** — as strong a Dimension 7 result as this gate can produce: the defect claim was directly re-executed, not merely re-read.

## Recommended redesign (Item 1 — drives the bundle RECONSIDER)

- **Rescope: split Item 1 into its own dedicated session**, per the session plan's own "Scope Alternatives" ("Item 1 is the largest and most uncertain; it can stand alone"). Do not bundle it with Items 4/6 for landing.
- **Decide and test the compound-`cd` handling before writing the fix**, not as a "candidate." Build the Stage-1.2 two-way fixture *first* (false-block reproduction, fix verification, genuine-foreign-stage-still-blocks verification) and add a third, explicit fixture case for `cd nested && git add .` / `cd nested && git commit` to prove the degrade-to-warn path does not silently reopen the fail-open that `979ed01` (2026-07-18) closed on this same hook.
- **Name an explicit rollback plan in the landing commit message**, given this hook is registered exactly once, globally, and gates every commit in every checkout — a single point of failure for the whole workspace.
- **Decide explicitly on the `.codex/hooks/check-foreign-staging.sh` sibling fork** (fix in parallel, delete, or park with a dated note) rather than leaving it to silently diverge further.

## Mitigations (Items 4 and 6 — proceed independently, gated on these)

- **Item 4(a) (Medium × 5 — no High, so PROCEED-WITH-CAUTION, not RECONSIDER):**
  - Before deleting, add a loud, recorded note (in `logs/decisions.md` or `logs/improvement-log.md`, cross-referenced from the mission's "Routed OUT" section) stating that System Owner v2 stage S2/B3 (`projects/project-planning/Project Plans/system-owner-v2/control-pack/technical-design.md:32-34`, `execution-roadmap.md:30`) assumed `warn-settings-change.sh` would be wired and working, and that assumption is now doubly false (file deleted; was fails-open anyway per the 2026-07-14 consult) — so that project's own next planning pass catches it rather than discovering a dangling reference mid-build.
  - Update the 3 repo-documentation vault entries (`blueprint.md:105`, `components/hooks.md:153-168`, `system-doc.md:200`) in the same or an immediately-following commit — they carry `status: active` and are meant to be a living reference, not a point-in-time snapshot.
  - Do not cite "actively replicating" as a reason in the commit message or the mission-thread closure note — cite the reasons that are independently sound (registered nowhere; fails open; repair cost is a permissions-surface expansion the standing architecture points away from).
- **Item 6 (High on Blast Radius only, mitigated):**
  - Immediately before the `Edit` call, re-run `command grep -n "30 of 87" ai-resources/.claude/commands/prime.md` to confirm the line number has not drifted again (it already moved `:220 → :224` within the same day, per the change description's own note).
  - After editing, read back the canonical file to confirm exactly the one sentence was removed and the surrounding "count, not a content read" rationale paragraph is intact — a wrong edit here propagates to all 26 symlinked consumers simultaneously with no independent review point.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line re-reads (`check-foreign-staging.sh`, `warn-settings-change.sh`, `friction-log-auto.sh`, `check-claim-ids.sh`, `prime.md`, `commit-discipline.md`), live command execution (the exact `prime.md` Step 3 Severity-count scan, re-run this session: 0 of 117), grep counts with `command grep` (not the ambient shell alias) across the workspace root and `ai-resources`, a live docs fetch (`code.claude.com/docs/en/hooks.md`) to verify the PreToolUse `cwd` field claim, and git-object verification (`git cat-file -t b7b6911`, `git show --stat b7b6911` inside the `ai-resources` nested repo — the workspace-root repo and `ai-resources` are separate git checkouts, confirmed live and directly relevant to Item 1's own defect mechanism). No training-data fallback was used on any read or command.
