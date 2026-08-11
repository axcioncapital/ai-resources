---
task: axcion-harness-v0-2-phase0-p0-d-monday-prep
turn: codex
---

## Objective and scope

Settle the smallest implementation-ready `ai-resources` change that removes the retired May
Harness as a live reader/writer dependency of `/monday-prep`, while preserving the weekly mandate's
useful operating role and keeping the command and its governing cadence documentation consistent.
This task is bound only to the nested checkout
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`; the workspace-root repository is
read-only context, and root P0-D implementation remains paused until this dependency is accepted.

Scope is the active `.claude/commands/monday-prep.md` behavior and only the directly governing or
consuming `ai-resources` command/document surfaces needed to determine the canonical week-mandate
home and remove active reliance on `harness/session/` and `harness/CHANGELOG.md`. Excluded:
workspace-root edits; movement or deletion of any `harness/session/*` file; the approved G1/G2 root
actions; Work Loop v1 retirement; P0-F actor policy; unattended containment; general cadence
redesign; and Phase 1+ harness work.

## Lane and unit

Standard. Discovery mode. Unit 1 — establish the canonical live week-mandate destination, the exact
command/document consistency boundary, and fail-capable implementation checks; do not implement the
eventual change.

Named reason for the loop: the accepted root P0-D sequence depends on a separately assessed
cross-repository change, and current repository evidence shows that both executable command text and
operator-facing cadence documents name the retired destination. Guessing the replacement would
either leave conflicting authority or silently create a new operating surface.

## Brief

P0-A and P0-C are accepted, and root P0-D's corrected discovery is accepted with G1–G3 approved.
This unit is ready now because G3 expressly authorizes a separately bound `ai-resources` flow, while
the root implementation must not retire `harness/session/` until the live reader/writer dependency
has been severed. It advances Phase 0's exit condition that stale May state cannot govern a v0.2
actor, without starting the premature root deletion/move work.

**Required outcome.** Return one repository-grounded discovery design in `## Latest result` that:
(1) identifies where the live weekly mandate should reside after the May Harness retirement;
(2) inventories every active command, cadence instruction, and real consumer whose behavior or
guidance must change with that destination; (3) defines the smallest future implementation boundary
inside `ai-resources`; (4) specifies fail-capable red/green checks and rollback/stop conditions; and
(5) ends with **PROCEED**, **REFRAME**, **DE-ESCALATE**, or **STOP**. Do not implement it.

**Authority and source dispositions — verify before relying on them.**

- Current operator decision: the G3 approval recorded in the root state file
  `../logs/work-loop/axcion-harness-v0-2-phase0-p0-d.md` authorizes exactly this separately bound
  nested flow. It does not authorize workspace-root edits or the later G1/G2 implementation.
- Authoritative current project position: the same root state file records accepted P0-D discovery,
  pauses root Unit 2 on this dependency, and records the closure-check deferral that exposed the
  cadence-document inconsistency. Read it without modifying it.
- Product boundary: `plans/axcion-harness-v0.2/mvp-plan.md` is still marked proposed/no general
  implementation authorization. Use its Phase 0 outcome and non-goals to bound the discovery; the
  later operator approval governs only this specific flow and must not be broadened.
- Governing workflow: Work Loop v2's executable core and actor resources as resolved from this exact
  nested checkout. Claude inspects repository reality and commits the discovery handback; Codex
  assesses it.
- Active object: `.claude/commands/monday-prep.md`. Verify the `HARNESS` constant, B11 read, C14
  write, the later session-plan reference to the week mandate, and all other occurrences rather than
  assuming the line numbers remain current.
- Candidate cadence sources: `docs/weekly-cadence.md`, `docs/session-rituals.md`,
  `docs/operator-maintenance-cadence.md`, `docs/weekly-session-guide.md`, and
  `docs/friday-cadence-runbook.md`. Their presence in this brief makes them verify-first candidates,
  not automatically equal authorities. Determine which govern, summarize, or consume the behavior.
- Non-governing background: the root May Harness files and preserved week mandates are historical
  evidence. They may establish current behavior and migration constraints, but they do not decide
  the new live destination.

**Check against the repository.** Treat every item as a claim to establish, and bound every absence
claim to the searched surface and pattern.

1. Verify the exact nested checkout binding, state-file identity, and current dirty/staged state
   read-only before work. Preserve all unrelated root and nested changes.
2. Inspect `.claude/commands/monday-prep.md` end to end. Classify every use of `HARNESS`,
   `harness/session`, `harness/CHANGELOG.md`, `week-mandate`, and any downstream variable or summary
   derived from B11/C14 as reader, writer, consumer, or inert prose.
3. Search active `ai-resources` commands, skills, hooks, scripts, and current operator/cadence docs
   for `week-mandate`, `harness/session`, `harness/CHANGELOG.md`, `Harness state`, and the current
   mandate filename pattern. Follow symlinks where the searched surface can contain them. Classify
   every relevant hit and explicitly exclude trials, fixtures, plans, audits, logs, and historical
   evidence unless a live source points to them.
4. Determine whether a canonical non-Harness home already exists. Inspect the live directory and
   ownership conventions for plausible candidates, every current reader of week mandates, ignore
   rules that would affect them, and the Friday/Monday lifecycle. Do not promote the root P0-D
   proposal `logs/week-mandates/` into a requirement without repository evidence.
5. Reconcile the command with the applicable cadence documentation. Identify the smallest set of
   files that must change together so an operator and an invoked command cannot be directed to
   different mandate locations or different sources of weekly truth.
6. Verify that the design can sever B11's retired Harness-state summary and C14's retired-directory
   write without changing the weekly mandate's week-scope, operator confirmation, overwrite guard,
   or separation from per-session planning.
7. Separate adjacent work: inert `session-start.md` prose, root G1/G2 moves/deletes, root
   `HARNESS_*` local cleanup, broader cadence simplification, P0-F, Work Loop v1, and Phase 1+ remain
   outside unless a cited live dependency makes one load-bearing to this exact change.

**Design requirements.** The handback must include an authority/consumer map; the selected mandate
destination with alternatives rejected and value/risk grounds; an exact future file boundary;
anchored behavioral intent for B11 and C14 without prescribing unnecessary implementation
mechanics; explicit exclusions and deferrals; a red/green matrix capable of detecting the old
reader, old writer, stale instructions, broken mandate consumption, and out-of-bound staging; and a
sequence that leaves the root task safely paused until the nested implementation is accepted.

**Codex framing decisions.** Discovery mode is required because the corrected root result proposed
`logs/week-mandates/` but did not establish it as canonical, and direct inspection found multiple
live cadence documents that still specify the retired location. The search is bounded to active
instructions and consumers that can determine this one destination and its consistency boundary;
general weekly-operations redesign and the later root archival work are held outside because they
have different exit conditions and owners.

**Required evidence.** Record decisive file anchors and command outputs for each verify-first
claim; the complete bounded hit classification; before-state controls for every proposed green
check; proof that the proposed destination is or is not already owned/ignored/consumed; the exact
future nested path boundary; and confirmation that no target command, cadence document,
workspace-root file, other task state, or unrelated nested path changed. A check that only finds
words supplied by this brief is not evidence.

**Completion condition.** `## Latest result` contains the complete discovery design, explicit
recommendation, fail-capable evidence, exact future nested boundary, and any operator gate. No
implementation occurred; only this state file is staged and committed in `ai-resources`; set
`turn: codex`; then stop for assessment.

**Stop conditions.** Hand back if the G3 approval or root dependency premise is false, the selected
destination requires a new operator policy decision, the relevant consumer boundary cannot be
established, or fail-capable evidence cannot be produced. Stop for the operator before any edit to
the root repository, deletion/move/overwrite of mandate evidence, scope expansion, guard weakening,
or other hard-to-reverse choice. Challenge false premises or stale direction instead of
improvising.

## Latest result

Inspected (2026-08-11):

- Claim (1) nested checkout binding, state-file identity, dirty/staged state: **HOLDS** —
  `git rev-parse --show-toplevel` from this file's directory returns
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`, branch `main`, HEAD `3ef4313`.
  `git diff --cached --name-only` empty (index clean). `git status --porcelain` = 5 entries:
  `logs/friction-log.md` and `logs/work-loop/work-loop-v2-bounded-execution-fix-plan.md` modified,
  `scripts/recall-search.py` untracked, plus two untracked work-loop files (this one and the sibling
  named in the finding below). Frontmatter `task:` equals the resolved `{task-id}`. All unrelated
  paths were left untouched; the workspace-root repository was read-only throughout.
- Claim (2) `.claude/commands/monday-prep.md` classified end to end: **HOLDS, 6 sites** — read all
  341 lines; `grep -n 'HARNESS\|harness\|week-mandate\|Harness'` returns exactly lines 49, 200, 203,
  204, 233, 234, 312. Classification: line 49 `HARNESS=` — **constant definition**, its only
  consumers are B11 and C14; lines 203–204 (B11) — **active reader**, `tail -20 "$HARNESS/CHANGELOG.md"`
  and `ls -1 "$HARNESS/session/"`, summarised at line 207 as "active phase … in-progress work";
  line 234 (C14) — **active writer**, `$HARNESS/session/week-mandate-{WEEK}.md`; line 200 heading and
  line 312 `### Harness state` in D16 — **consumer** of B11's summary inside the `session-notes.md`
  entry; line 233 — the filename pattern, destination-free. Line 293 (`/session-plan` separation) and
  line 339 (`Week mandate is at {path}`) reference the mandate but derive the path, so neither
  hard-codes a destination.
- Claim (2a) B11 contributes nothing to the mandate's content: **HOLDS** — C14's "Gather context
  from" list (lines 238–243) names Phase A flags, Phase B flags, C12, C13, and operator goals. B11's
  block carries no `add to FLAGS` instruction, unlike A1–A5 and B6–B10 which each state one
  explicitly. B11's only downstream consumer is D16's `### Harness state` section.
- Claim (3) bounded search over active `ai-resources` surfaces: **HOLDS** — symlink-following
  `grep -RIn -E 'week-mandate|harness/session|harness/CHANGELOG|Harness state|week mandate'` over
  `.claude/ skills/ scripts/ templates/ docs/ workflows/` returns hits in exactly two commands and
  six docs. Classified: **`.claude/commands/monday-prep.md`** — the reader/writer above;
  **`.claude/commands/session-start.md:10,12,376`** — inert prose about the retired
  `session-start.sh`/`mandate-parser`, no execution path (already root P0-D deferral 1);
  **`docs/weekly-cadence.md`** — the command's own reference doc (named at `monday-prep.md:9`), so
  the **governing** document: line 57 (step 11 = B11), line 67 (step 14 destination), line 78
  (§ Scope separation destination), line 117 (Friday F0 read destination), line 179 (function-map row
  "Harness state read"); **`docs/session-rituals.md:24`** — operator summary, states both the
  harness-state read and the destination; **`docs/weekly-session-guide.md:29,30`** — operator
  summary, Phase B "harness state" and Phase C destination;
  **`docs/operator-maintenance-cadence.md:15`** — operator summary, "harness state read", no
  destination; **`docs/session-marker.md:289`** — inert pass-through note, names no path, explicitly
  records that `monday-prep` is unaffected by the bullet schema. Scripts: a single hit,
  `logs/scripts/prime-allocator.test.sh:14`, is the unrelated English word "harness" in a comment —
  searched `ai-resources/logs/scripts/`, `ai-resources/scripts/` and root `logs/scripts/` for
  `week-mandate|HARNESS|harness/session`; no other match. Hooks: none — searched `.claude/` (which
  contains `hooks/`) with the pattern above; only the two commands hit. Excluded as historical
  evidence, none pointed to by a live source: `audits/` (25 files), `logs/` archives and session
  plans, `plans/`, and both work-loop state files.
- Claim (3a) the root repository adds no separate consumer: **HOLDS** —
  `ls -la` shows root `.claude/commands/monday-prep.md` is a symlink to
  `../../ai-resources/.claude/commands/monday-prep.md` (same for `session-start.md`), so the nested
  edit changes the root-invoked command with no root write. Symlink-following grep over root
  `.claude/`, root `CLAUDE.md` finds no additional surface. The three sibling directories
  `ai-resources-{eval,diagnostics-workflow,work-loop-ceremony}/` that appear in a naive root-wide
  grep are linked git worktrees of this same repository (`git worktree list`), not independent
  consumers.
- Claim (4) whether a canonical non-Harness home already exists: **FALSE — no such home exists, and
  the root proposal is not yet a repository fact.** `find . -type d -name 'week-mandates'` over the
  whole workspace returns nothing; `find . -name 'week-mandate*'` returns exactly the five files in
  `harness/session/` (W20–W24). The current destination is disqualified by evidence, not by
  preference: root `.gitignore:2` `harness/session/*` (negated only for `.gitkeep` at line 3) makes
  every mandate **untracked** — `git ls-files harness/session/` returns the 4 May JSONs and
  `.gitkeep` and no mandate — so the five existing mandates are sole copies that `git clean -x` would
  destroy. Root P0-D already established this and G1 approved converting them to tracked history.
  Ownership convention: `/monday-prep` prefixes **every** log read and write with `$AI_RESOURCES`
  (A4, A5, B8 ×2, C13, D16) and every audit read with `$AI_RESOURCES/audits/`; only the git and
  project-scan steps use `$WORKSPACE`. `ai-resources/logs/` already hosts dated series as
  subdirectories (`runs/`, `missions/`, `work-loop/`, `loop/`). `git -C ai-resources check-ignore -v
  logs/week-mandates/x.md` exits non-zero — not ignored, so the path would be tracked. Lifecycle:
  Monday writes, Friday F0 reads; `harness/session/` holds no `*-session-report.md` file at all
  (`find harness -name '*session-report*'` returns only a template and two retired components), so
  the docs' Friday session-report references never had an object.
- Claim (5) the command/document consistency boundary: **HOLDS, 5 files** — the smallest set that
  cannot leave an operator and the command pointing at different mandate locations is
  `.claude/commands/monday-prep.md` plus `docs/weekly-cadence.md`, `docs/session-rituals.md`,
  `docs/weekly-session-guide.md`, `docs/operator-maintenance-cadence.md`. The last is included for
  its "harness state read" claim only (line 15); it names no destination. Every other hit is either
  a different artifact (harness session reports) or path-free prose.
- Claim (6) the design can sever B11 and C14 without touching the cadence's guarantees: **HOLDS** —
  the week-scope `{WEEK}` token (line 233), the overwrite guard (line 236), the `y / edit / skip`
  operator confirmation (lines 272–278) and the `/session-plan` separation (line 293) all sit outside
  lines 49/200–207/234/312. C14's only harness-bound token is the directory in line 234. Removing
  B11 cannot change mandate content per claim (2a), and removing D16's `### Harness state` section
  breaks no reader: a symlink-following grep for `Harness state` across both repositories'
  `.claude/`, `skills/` and `logs/scripts/` returns 4 hits, all of them lines 200 and 312 of this one
  command seen through both paths.
- Claim (7) adjacent work stays separated: **HOLDS** — no live dependency makes any of it
  load-bearing to the destination change. Listed under Exclusions and deferrals below.

**Finding A — the accepted root P0-D verification matrix is not fail-capable, and this unit is the
reason it matters.** Root P0-D's V-D6 is `grep -c 'harness/session'` on
`ai-resources/.claude/commands/monday-prep.md` → 0, with the red control stated as "red today: 3".
Run today against the unmodified file it returns **0**. The command never writes the literal string:
it uses `$HARNESS/session/`, and `HARNESS` is upper-case, so a case-sensitive grep matches nothing.
V-D6 therefore passes whether or not the fix lands — the exact defect core § 6 rule 5 forbids. The
joint acceptance check V-D1 has the mirror defect: the same pattern over root's claim-3 surfaces
returns **2** hits today, both at `.claude/commands/session-start.md:10,12` — inert prose the root
design deliberately does **not** change — and **zero** from `monday-prep.md`. V-D1 as written can
therefore never go green from this fix, and its stated red control ("3 hits via monday-prep.md") is
wrong in both count and source. The corrected checks are in the matrix below; the root task needs
V-D1/V-D6 restated before root Unit 2 can use them as its acceptance signal.

**Finding B — a second, unauthorised state file exists for this same work.**
`logs/work-loop/axcion-harness-v0-2-p0-d-monday-prep.md` (untracked, `turn: claude`, task id without
`phase0`) is an **Implementation-mode** brief that pre-commits to writing mandates to
`logs/week-mandates/week-mandate-{WEEK}.md` and excludes cadence documentation from its scope. It is
not the authorised task: the root state file's Next action names
`axcion-harness-v0-2-phase0-p0-d-monday-prep` — this file. Executing the sibling would implement the
destination this discovery was opened to establish and would leave all four cadence documents stale.
Nothing was changed about it; the disposition is Codex's or the operator's.

Result: discovery complete. **Recommendation: PROCEED** to one Implementation-mode unit in this
checkout, with no operator gate required beyond what is already approved, and one Codex confirmation
noted below.

**Authority and consumer map.**

| Surface | Role | Mandate destination stated? | In boundary |
|---|---|---|---|
| `.claude/commands/monday-prep.md` | executable object — sole reader (B11) and sole writer (C14) | yes, line 234 | **yes** |
| `docs/weekly-cadence.md` | **governing** reference doc, cited at `monday-prep.md:9` | yes — lines 67, 78, 117 (+ 57, 179 describe B11) | **yes** |
| `docs/session-rituals.md` | operator summary, defers to weekly-cadence | yes, line 24 | **yes** |
| `docs/weekly-session-guide.md` | operator summary, defers to weekly-cadence | yes, line 30 (+ 29 describes B11) | **yes** |
| `docs/operator-maintenance-cadence.md` | operator summary, defers to weekly-cadence | no — describes B11 only, line 15 | **yes** (B11 clause only) |
| `docs/friday-cadence-runbook.md:47` | Friday F0 read instruction | no — "you read the week mandate" | no |
| `docs/session-marker.md:289` | inert pass-through note | no | no |
| `.claude/commands/session-start.md:10,12,376` | inert prose about retired components | no | no |
| root `.claude/commands/monday-prep.md` | symlink to the nested file | inherited | no separate edit |

**Selected destination: `ai-resources/logs/week-mandates/week-mandate-{WEEK}.md`.**

Grounds, from claim (4): it is tracked (verified not ignored), which repairs the defect that made
`harness/session/` wrong — the artifact the whole cadence is told to start from currently survives
only as an untracked file in a gitignored directory that root Unit 2 will delete. It sits with every
other artifact this command reads and writes, all of which are `$AI_RESOURCES`-prefixed, including
the `session-notes.md` entry that names the mandate path. It follows the existing
`logs/<series>/` convention. And it keeps Monday's output in one repository, which is the split that
root P0-D spent a correction round separating.

*Alternative rejected — root `logs/week-mandates/` (the root P0-D proposal, marked "proposal" there
and explicitly not to be promoted without evidence by this brief).* Value: the mandate's subject
matter is workspace-wide, and root `logs/` is tracked and would work. Risk: it splits one Monday run
across two repositories — the flag list lands in `ai-resources/logs/session-notes.md` while the
mandate it points at lands in root — so D16's entry becomes a cross-repo pointer, the Friday F0 read
crosses a repository boundary, and the command's single `$AI_RESOURCES` log convention gains one
exception with no reader that needs it. On the evidence this is the weaker option, but **the choice
of repository is Codex's to confirm**, because the accepted root design named root. If Codex prefers
root, only the constant differs; the boundary, edits, and matrix below are otherwise unchanged.

*No new operator policy decision is required.* Making week mandates tracked is the same policy
change the operator already approved as **G1** choice (a) for the five historical mandates. This
design applies the settled policy forward; it does not reopen it.

*Alternative rejected — keep writing to `harness/session/` and let root Unit 2 handle it.* Root
Unit 2 deletes that directory; C14 would recreate it on the next run, restoring the stale surface
Phase 0 exists to remove.

**Exact future implementation boundary (this checkout only).** Five files, all under
`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`:

- `.claude/commands/monday-prep.md`
- `docs/weekly-cadence.md`
- `docs/session-rituals.md`
- `docs/weekly-session-guide.md`
- `docs/operator-maintenance-cadence.md`

Administrative path: `logs/work-loop/axcion-harness-v0-2-phase0-p0-d-monday-prep.md`. Nothing else is
staged. No file is created by the implementation unit: the destination directory comes into existence
on the next real `/monday-prep` run, so no placeholder is added and no mandate is written.

**Anchored behavioural intent** (intent, not mechanics; anchors are unique strings, not line numbers):

- Constant block (anchor: the `HARNESS=` bullet) — remove it. After the two edits below it has no
  consumer, and leaving a defined variable pointing at a directory scheduled for deletion is the
  route by which the retired path returns.
- **B11** (anchor: the `**B11 — Harness state**` heading through its fenced block and the
  `Summarize:` line) — remove the step. It is the route by which retired state is presented as
  current, its output feeds nothing but D16, and Phase B's remaining ten steps are unaffected. If a
  pointer is wanted, one line naming `harness/README.md`'s retirement record is sufficient; it must
  not read or list anything.
- **D16** (anchor: the `### Harness state` heading and its `{summary from B11}` placeholder) — remove
  the section, so the `session-notes.md` entry does not carry an empty heading. No external reader.
- **C14** (anchor: the `Full path:` line) — change only the directory to
  `$AI_RESOURCES/logs/week-mandates/`. The `{WEEK}` token, filename pattern, overwrite guard,
  confirmation prompt and `/session-plan` separation are not touched.
- Governing doc `docs/weekly-cadence.md` — step 11 and the function-map row removed to match B11;
  step 14, § Scope separation, and the Friday F0 read line repointed to the new destination.
- The three operator summaries — destination repointed (`session-rituals.md`,
  `weekly-session-guide.md`) and the harness-state-read clause dropped from all three
  (`session-rituals.md`, `weekly-session-guide.md`, `operator-maintenance-cadence.md`).

**Red/green matrix.** Red control = value measured today, 2026-08-11, on the unmodified tree.

| # | Check | Red (today, measured) | Green | Detects |
|---|---|---|---|---|
| N1 | `grep -c 'HARNESS' .claude/commands/monday-prep.md` | **4** (lines 49, 203, 204, 234) | 0 | old reader, old writer, and the dangling constant — the correct form of root V-D6 |
| N2 | `grep -c 'Harness state' .claude/commands/monday-prep.md` | **2** (lines 200, 312) | 0 | B11 step and its D16 consumer both gone |
| N3 | `grep -c 'harness/session/week-mandate' docs/weekly-cadence.md docs/session-rituals.md docs/weekly-session-guide.md` | **3 / 1 / 1** | 0 / 0 / 0 | stale destination in each governing or summarising document |
| N4 | unique destination directories across the command and the three docs: `grep -rhoE '(harness/session\|logs/week-mandates)/week-mandate' <5 files> \| sed 's\|/week-mandate\|\|' \| sort -u` | **`harness/session`**, count 1 | **`logs/week-mandates`**, count 1 | a **half-done edit** — count ≠ 1 means the command and the docs disagree. Green today on the old value, so it is a regression guard, not a progress signal; it is the only check that fails on the partial-edit failure mode |
| N5 | `grep -ic 'harness state' docs/session-rituals.md docs/weekly-session-guide.md docs/operator-maintenance-cadence.md docs/weekly-cadence.md` | **1 / 1 / 1 / 2** | 0 / 0 / 0 / 0 | operator instructions still describing the removed B11 step |
| N6 | `git -C ai-resources check-ignore -v logs/week-mandates/probe.md` | exit 1 today | exit 1 | destination is tracked, not silently ignored — must stay true |
| N7 | `git -C ai-resources diff --cached --name-only` at commit | — | exactly the 5 boundary files + this state file | out-of-bound staging |
| N8 | `git -C "<workspace root>" status --porcelain` before vs after | 35-entry baseline | byte-identical | no root file changed |
| N9 | joint signal, run from root **after** this unit: symlink-following `grep -c '\$HARNESS' .claude/commands/monday-prep.md` | **3** | 0 | the corrected replacement for root V-D1's monday-prep component. Root's own `session-start.md` hits are a separate deferral and must not be folded into this signal |

No behavioural check on a real mandate file is proposed, and inventing one would be ceremony: the
next mandate is produced by an operator-confirmed `/monday-prep` run, which belongs to normal
operation. Worth recording as context — the latest mandate on disk is `week-mandate-2026-W24.md`
and the current week is `2026-W33`, so the cadence has produced none for about nine weeks. The
redirect cannot interrupt a running weekly rhythm, and the first real proof lands whenever
`/monday-prep` is next run.

**Sequence, rollback, stop conditions.**

1. Codex confirms the repository choice (this checkout's `logs/` vs root `logs/`) and dispositions
   the duplicate state file in Finding B, then opens one Implementation-mode unit on the five-file
   boundary.
2. That unit edits the five files, runs N1–N8, and commits by explicit pathspec.
3. Once accepted, the root task resumes: Codex opens root Unit 2 with V-D1 and V-D6 restated per
   Finding A, and N9 becomes the cross-repository acceptance signal.
4. Rollback: every change is a tracked text edit in one repository, revertible by git. No file is
   deleted, moved, or overwritten; no mandate evidence is touched; the five existing mandates stay
   exactly where root G1 will handle them.
5. Stop for the operator before: any root edit, any move or deletion of the existing mandates, any
   weakening of C14's overwrite guard or confirmation prompt, or any widening past the five files.

**Exclusions and deferrals** — noticed, recorded, not done, none load-bearing to the destination:

1. **Harness session-report references** — `docs/weekly-cadence.md:114,158`,
   `docs/weekly-session-guide.md:126,148`, `docs/friday-cadence-runbook.md:81` point Friday F0/F6 at
   `harness/session/{date}-session-report.md`. A different artifact from the week mandate, and inert:
   `find harness -name '*session-report*'` proves no such file was ever written there. They are the
   excluded "general cadence redesign"/Phase 1+ work. **But they become dangling the moment root
   Unit 2 deletes `harness/session/`** — Codex should carry this to the root task as a coordination
   note, not fold it in here.
2. `session-start.md:10,12,376` inert prose — already root P0-D deferral 1; unchanged.
3. `docs/session-marker.md:289` — accurate as written; needs nothing.
4. **Latent, pre-existing:** C15 writes `logs/session-plan-next.md` with no `$AI_RESOURCES` or
   `$WORKSPACE` prefix (line 284), unlike every other log path in the command. Which repository it
   lands in depends on the invoking directory. Outside this unit's completion condition; worth its
   own small item.
5. Root G1/G2 moves and deletes, root `HARNESS_*` local cleanup, P0-F, Work Loop v1, Phase 1+ —
   untouched.

Evidence: every claim line above names the command run and what it returned. The decisive
fail-capable results are N1 = 4, N2 = 2, N3 = 3/1/1, N5 = 1/1/1/2 and N4 = `harness/session` measured
on the unmodified tree — each goes to its green value only if the corresponding edit lands, and N4
goes red if only part of the boundary is edited. Finding A is proved by running root V-D6 verbatim
today and getting 0 (its stated red control is 3) and root V-D1 verbatim and getting 2 hits, both in
`session-start.md` and none in `monday-prep.md`. No implementation occurred: no target command, no
cadence document, no workspace-root file, no other task state, and no unrelated nested path was
modified — the only file this unit changed is this state file, and the staged path list for this
handback is exactly `logs/work-loop/axcion-harness-v0-2-phase0-p0-d-monday-prep.md`.

## Blocker

None. No operator gate is required: the destination is tracked under the policy already approved as
root G1 choice (a), and G3 already authorises this flow.

## Next action

Codex: assess this discovery. Two decisions belong to you before an Implementation-mode unit opens —
(a) confirm the mandate repository, `ai-resources/logs/week-mandates/` as recommended or root
`logs/week-mandates/` as the accepted root design named; (b) disposition the duplicate state file
`logs/work-loop/axcion-harness-v0-2-p0-d-monday-prep.md` in Finding B, which would implement a
destination this unit was opened to establish. Also carry Finding A to the root task: V-D1 and V-D6
must be restated before root Unit 2 can use them, and deferral 1 makes the docs' harness
session-report pointers dangle once root Unit 2 deletes `harness/session/`.
