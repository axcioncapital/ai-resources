# Risk Check — 2026-07-17

## Change

Proposed structural change: add a NEW `.gitattributes` at the ai-resources repo root (none currently exists) containing exactly two lines:

  logs/session-notes.md merge=union
  logs/decisions.md merge=union

WHY: cross-worktree session collisions. Two worktree sessions each append their own session block to the END of these shared, git-tracked, append-only logs on separate branches; when the branches merge back, git raises an add/add conflict at EOF. There is no merge rule today. `merge=union` is a git built-in that keeps BOTH sides' lines instead of conflicting.

PROVEN BY EXECUTION (git merge-file on representative content): default merge → EXIT=1 with conflict markers between the two session blocks (reproduces the collision); `--union` → EXIT=0, both session blocks kept, headers intact, no markers. Red-before/green-after.

SCOPE DECISION (grounded, not guessed): only the two logs that are provably PURE append-at-EOF (first dated header oldest at top, newest at bottom; 0 `**Status:**`/`Resolved:` in-place stamps; no prepend marker). DELIBERATELY EXCLUDED: improvement-log.md (107 in-place `**Status:**` flips — union would duplicate flipped lines), friction-log.md (10 in-place `Resolved:` stamps + prepend marker), usage-log.md (prepend writer + already-fragile format). Those keep default/manual conflict resolution.

REVERSIBILITY: fully reversible — delete the file or the lines; no history rewrite, no state written outside git.

BLAST RADIUS: ai-resources repo and its worktrees only (`.gitattributes` is a per-repo tracked file; other project repos are separate and unaffected). It governs merges performed INTO whichever branch carries it (i.e. main), which is where worktree branches land.

KNOWN COSMETIC: union concatenation drops the inter-block blank line; harmless because every session block begins with its own `## ` header and all readers (`/prime`, wrap) grep on `^##`.

This maps to the #1 open HIGH backlog item ("the session-marker lock is unenforceable by construction") but is the narrow, safe first slice — NOT the deeper marker-allocator relocation, which stays out of scope.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.gitattributes — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/decisions.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The defect is real (independently reproduced, and directly documented as having actually occurred, multiple times, in the very files under discussion) and the two-file scope is correctly grounded, but the change is widely referenced infrastructure (85 distinct consumer files) and silently removes the one existing forcing function — a git conflict — that has twice already caught a same-header session-marker collision; both risks have concrete, cheap mitigations.

## Consumer Inventory

Search terms: `session-notes.md`, `decisions.md` (the two target basenames), plus the contract marker the change depends on for safety: the literal `## {date} — Session {marker}` header line consumed by `grep -Fxq` in `prime.md`, `session-start.md`, `session-plan.md`. Grepped across `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `docs/`, `logs/scripts/`, `skills/` in `{AI_RESOURCES}`.

**Total distinct consumer files: 85** (60 reference `session-notes.md`, 59 reference `decisions.md`, with overlap). `.gitattributes` itself is `not yet present`, so it has no consumers of its own yet — the inventory below covers consumers of the two target files whose *merge outcome* the new file will govern. `Must-change? = no` for every row: verified by direct test (see Dimension 3/5) that literal `## ` header lines and `^## `-anchored block-boundary parsing survive a union merge byte-for-byte; the one cosmetic effect (a dropped inter-block blank line) does not affect any consumer below.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/prime.md` | parses (`grep -Fxq "## ${TODAY} — Session ${MARKER}"` header-existence check; allocates the marker; pre-fetches both logs) | no |
| `.claude/commands/wrap-session.md` | invokes (sole writer — appends session note + decision entries at EOF; owns the foreign-write pre-write guard) | no |
| `.claude/commands/session-start.md` | parses (mandate-line write; foreign-write mtime check) | no |
| `.claude/commands/session-plan.md` | parses (locates marker-bearing header; hard-fails if absent) | no |
| `.claude/commands/drift-check.md` | parses (reads bottom-most `## {date}` block as mandate source) | no |
| `.claude/commands/contract-check.md` | parses (reads bottom-most mandate block as contract source) | no |
| `.claude/commands/concurrent-session-check.md` | documents+parses (explicitly classifies both files as "Expected-shared — not a conflict... both sessions' entries survive") | no |
| `.claude/commands/mission.md` | parses (`grep -c "Mission: <id>"` session count; scans blocks for mandate) | no |
| `.claude/commands/open-items.md` / `reconcile-backlog.md` | parses (Open Questions / Defer-trigger field scan) | no |
| `.claude/commands/blindspot-scan.md` | parses (reads bottom-most `## {date}` block) | no |
| `.claude/hooks/check-foreign-staging.sh` | parses (marker regex `\bS\d+\b`, header/mandate footprint counting) — flagged in `improvement-log.md:895` as the one site whose regex is "ambiguous once suffixes exist" | no (script logic unaffected by merge driver; regex ambiguity is a pre-existing, separate open item) |
| `logs/scripts/foreign-session-guard.sh` | parses (header/mandate counting across working tree and HEAD) | no |
| `logs/scripts/check-archive.sh` + `split-log.sh` | parses (fence-aware `^## ` header extraction; archives oldest entries at threshold) | no |
| `docs/session-marker.md` | documents (defines the `grep -Fxq` header-check contract these files must satisfy) | no |
| `docs/commit-discipline.md` | documents (explicitly lists both files as "append-only... two sessions only ever union them"; also lists `usage-log.md` and `coaching-data.md` in the same class) | no |
| `docs/parallel-sessions-playbook.md` | documents (explicitly classifies both files as "Append-only / log-shaped... Genuine 'keep both' unions" — already prescribes the exact behavior this change automates) | no |
| ~68 further files (commands: `friday-checkup.md`, `coach.md`, `post-project-review.md`, `note.md`, `decide.md`, `clarify.md`, `friday-act.md`, `resolve-repo-problem.md`, `reconcile.md`, `reconcile-activate.md`, `log-sweep.md`, `leverage-idea.md`, `project-next-steps.md`, `friday-journal.md`, `resolve-incident.md`, `new-project.md`, `improve-skill.md`/`create-skill.md`/`migrate-skill.md`, `lean-repo.md`; agents: `reconcile-reviewer.md`, `context-discovery.md`, `collaboration-coach.md`, `fix-repo-issues-scanner.md`, `project-state-snapshot-agent.md`, `session-feedback-collector.md`, `log-sweep-auditor.md`, `dd-log-sweep-agent.md`, `project-manager.md`, `risk-check-reviewer.md` itself; hooks: `coach-reminder.sh`, `detect-concurrent-session.sh`; docs: `repo-architecture.md`, `session-rituals.md`, `weekly-cadence.md`, `heavy-read-discipline.md`, `session-guardrails.md`, `friday-cadence-runbook.md`, `reconcile-failure-taxonomy.md`, `compaction-protocol.md`, `backlog-reconciliation.md`, `agent-tier-table.md`, `control-pack-schema.md`, `operator-maintenance-cadence.md`, `weekly-session-guide.md`; skills: `handoff/SKILL.md`, `workflow-system-critic/SKILL.md`, `session-guide-generator/SKILL.md`) | documents (read the files as an orientation/audit source; none parse merge-sensitive structure beyond `## `/`### ` headers, already covered above) | no |

**Gap the inventory surfaced, not named in `CHANGE_DESCRIPTION`:** `docs/commit-discipline.md` and `docs/parallel-sessions-playbook.md` both classify **`coaching-data.md`** and **`usage-log.md`** alongside `session-notes.md`/`decisions.md` as "append-only in both senses... two sessions only ever union them" — i.e. the repo's own docs already describe a 4-file class, not the 2-file class this change ships. The change's exclusion of `usage-log.md` is independently justified (a real historical prepend-bug is documented in `wrap-session.md:223`, confirming the caller's "already-fragile format" claim). `coaching-data.md` is not addressed at all — neither included nor explicitly excluded. It is out of the archive rotation (`check-archive.sh:17` — "uses `###` headers only, `split-log.sh` requires `##` headers") and structurally simpler, so this is a scope-completeness gap, not a risk of the two lines actually proposed.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `.gitattributes` is read only by git's own merge/diff/checkout machinery, never loaded into an agent's context window. Confirmed no existing `.gitattributes` anywhere in the repo tree or the workspace root (`find … -name .gitattributes` — zero hits), and no `core.attributesFile` override in local or global git config, so this is a genuinely new, isolated addition with no interaction with an existing attributes file.
- No always-loaded CLAUDE.md touched, no hook registered, no skill trigger, no subagent brief expanded.

### Dimension 2: Permissions Surface
**Risk:** Low

- Creating a new repo-root file uses the already-blanket `"Write"` entry in `.claude/settings.json`'s `allow` list (`defaultMode: bypassPermissions`). No new tool-invocation pattern, no widened glob, no new capability class (no shell exec, no external API, no cross-repo write — `.gitattributes` only configures git's own merge driver selection for two named local paths).

### Dimension 3: Blast Radius
**Risk:** High

- Consumer inventory (Step 1.5): **85 distinct files** in `{AI_RESOURCES}` reference `session-notes.md` and/or `decisions.md` (60 and 59 respectively, with overlap) — commands, agents, hooks, docs and scripts. This exceeds the ">5 dependent callers" High threshold on raw count, and both files are unambiguously shared infra consumed by most of the harness's cadence commands (`/prime`, `/wrap-session`, `/session-start`, `/session-plan`, `/drift-check`, `/contract-check`, `/mission`, `/friday-checkup`, `/friday-act`, `/blindspot-scan`, `concurrent-session-check.md`, `check-foreign-staging.sh`, `foreign-session-guard.sh`, `check-archive.sh`).
- **Must-change count: 0**, verified by direct test, not assumed. `git merge-file --union` on representative content preserves the literal `## {date} — Session {marker}` header line verbatim (Test 1, reproduced below) — the exact string `prime.md`, `session-start.md`, `session-plan.md` test with `grep -Fxq`. The one structural side-effect (an inter-block blank line dropped) does not disturb any `^## `-anchored parser (`check-archive.sh`, `split-log.sh`, `foreign-session-guard.sh` all match on line-start `##`, not on blank-line separation).
- The score is driven by breadth/shared-infra-touch (the letter of the High trigger), not by any caller requiring modification — every consumer keeps working unchanged. See Dimension 5 for the one scenario (same-header collision) where the *content* a consumer reads could become wrong, which is the sharper risk this High should be read alongside.

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert`/deleting the two lines cleanly restores default (conflict-marker) merge behavior for all **future** merges — this part of the CHANGE_DESCRIPTION's "fully reversible" claim holds.
- It does **not** retroactively undo the **outcome** of any merge already performed while the union driver was active. If a union merge silently drops a blank line, or (the rarer case — Dimension 5) silently blends two sessions under one shared header, that content is already committed; reverting `.gitattributes` does not repair it. The CHANGE_DESCRIPTION's blanket "no state written outside git" is true but understates this: state *is* written differently, inside git, in a way a later revert of the driver config cannot fix. This is the ordinary "one extra cleanup step" Medium case (manual inspection of any merge commit produced under the union driver), not a High — no external state, no history rewrite required to fix it if caught.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **One clear, tested, undocumented implicit dependency.** Union-merge correctness on these two files silently relies on the marker-suffix uniqueness convention (`SFX="-${ID3}"`, derived from the first 3 alphanumeric characters of `$CLAUDE_CODE_SESSION_ID`, in `prime.md` L425/597/785) continuing to guarantee that no two concurrent sessions ever write the byte-identical header `## {date} — Session S{N}{SFX}`. This dependency is not named anywhere in `CHANGE_DESCRIPTION`'s "KNOWN COSMETIC" section (which only names the blank-line drop).
- **This is not a hypothetical.** `improvement-log.md:889` ("The session-marker lock is unenforceable by construction") documents that headers **have already collided twice** pre-suffix-fix — `S8` and `S13` "each landing twice as different sessions" at the 2026-07-14 merge — and that this was caught precisely *because* the collision produced a git merge conflict that someone had to look at and resolve by hand (`decisions.md` 2026-07-14 S3, Decision 5: "resolved all six merge conflicts as a union, not a pick"). The same backlog entry flags that the suffix rollout was, as of 2026-07-14, not fully hardened: "one is genuinely load-bearing (`\bS\d+\b` in `check-foreign-staging.sh` L185 is ambiguous once suffixes exist)."
- **Reproduced directly.** Two branches independently writing *different* content under the *same* header text (simulating a residual suffix collision):
  - Default `git merge-file`: EXIT=1, conflict markers isolate the differing bodies under the shared header — the forcing function that caught `S8`/`S13` in the first place.
  - `git merge-file --union`: EXIT=0, **both bodies silently concatenated under one shared header**, no signal, no markers. This is worse than the status quo specifically in the one case (a genuine collision) where "always keep both, unreviewed" is the wrong answer — see the paired mitigation below.
- The residual probability is low (the suffix fix substantially reduced same-header collisions vs. the pre-2026-07-14 state), so this is Medium, not High: one implicit dependency on an established-but-imperfect repo convention, not multiple, and not silent auto-firing in an *unexpected* context (it only manifests during an actual collision, which is the rare case by design).

### Dimension 6: Principle Alignment
**Risk:** Low

- Read `{AI_RESOURCES}/../CLAUDE.md` and `{AI_RESOURCES}/CLAUDE.md` (Step 1). `{AI_RESOURCES}/../projects/strategic-os/ai-strategy/principles-base.md` was not read for this pass — the checks below are the inline Step 6.5 checks, applied directly, not a substitute for it; flagging per instructions rather than marking the dimension `INCOMPLETE`, since `CHANGE_DESCRIPTION` is specific enough to judge fit.
- **OP-9/AP-7/DR-7 (speculative abstraction):** does not apply — the two files are real, named, currently-in-use consumers with a documented collision history (`improvement-log.md:889`), not a hypothetical future one. The deeper marker-allocator relocation is explicitly and deliberately left out of scope, which is the correct-sized slice rather than "hooks for Phase 2."
- **OP-2 (automate execution, gate judgment):** every documented historical resolution of this exact conflict shape chose "union, not a pick" (`decisions.md` 2026-07-14 S3, Decision 5) — i.e. humans/agents facing this conflict have always produced the same answer, which is exactly the kind of routine, always-the-same-outcome decision OP-2 licenses automating. The one place this tension sharpens — the rare same-header case where "always union" silently produces the *wrong* answer — is a real judgment-automation concern, but it is the same underlying fact already scored under Dimension 5 (Medium) rather than a second, independent principle violation; it does not clear the bar for a Dimension 6 High (no unacknowledged violation — the change's own "KNOWN COSMETIC" section shows awareness that union merge trades away something, just not this specific something).
- **OP-12 (closure before detection):** not applicable — this is a pure closure/automation mechanism, not a new detection/scan/audit component.
- **OP-10, OP-5, DR-1/DR-3:** no cross-tool boundary expansion, no advisory-to-enforcement upgrade, and `.gitattributes` at repo root is the canonical, correct location for this mechanism (no placement issue).

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not merely asserted.** Independently re-executed (not taken on the caller's word): `git merge-file` on representative content with two branches each appending a distinct block after a shared tail produced `EXIT=1` with `<<<<<<<`/`=======`/`>>>>>>>` conflict markers under the default driver, and `EXIT=0` with both blocks concatenated cleanly under `--union` — reproducing the CHANGE_DESCRIPTION's claim exactly. Beyond the synthetic test, the defect is also **directly documented as having actually occurred** in the two files under discussion: `logs/session-notes.md` L58 ("the merge appended the branch's own entries after it, so the body lives here at the tail") and `logs/decisions.md` 2026-07-14 (S3) Decision 5 ("resolved all six merge conflicts as a union, not a pick... Both `main` (S4) and this branch (S1/S3) had appended distinct session entries to the same append-only logs since the fork").
- **Consequence — traced, not assumed.** The claimed consequence (an add/add conflict at EOF when two worktree branches both append) is not an inference from a quoted line — it is reproduced by direct execution above, and it matches the repo's own historical record of resolving this exact conflict shape by hand, repeatedly, on these exact two files.
- **Re-derivation vs. the change description.** Every checkable count/claim was re-derived independently and confirmed, none contradicted:
  - `.gitattributes` "none currently exists" — confirmed (`find` returned zero hits, workspace root included).
  - `improvement-log.md` "107 in-place `**Status:**` flips" — confirmed exactly (`grep -c` = 107).
  - `friction-log.md` "10 in-place `Resolved:` stamps" — confirmed exactly (`grep -c` = 10).
  - `session-notes.md`/`decisions.md` "0 `**Status:**`/`Resolved:` in-place stamps" — confirmed (0 and 0 for both files, both patterns).
  - `usage-log.md` "prepend writer + already-fragile format" — confirmed independently: `wrap-session.md:223` documents a real historical failure ("the 2026-07-14 (S2) entry... was prepended directly under the `<!-- entries below -->` marker, ~900 lines above the reader's window, invisible to its own consumer"), now guarded by a dedicated format-check script.
  - "#1 open HIGH backlog item ('the session-marker lock is unenforceable by construction')" — confirmed at `improvement-log.md:889`, `Status: OPEN — the highest-value structural item in this log`, `Severity: high`.
  - No count, path, or quoted claim in `CHANGE_DESCRIPTION` was contradicted by re-derivation. Two refinements were found that the caller did not name (the reversibility nuance under Dimension 4, and the same-header collision risk under Dimension 5) — these are new findings, not contradictions of what was claimed.

## Mitigations

- **Dimension 3 (High) + Dimension 5 (Medium) — paired mitigation.** Add a cheap post-merge sanity check: immediately after any merge/rebase into `main` that touches `logs/session-notes.md` or `logs/decisions.md`, run `grep '^## ' <file> | sort | uniq -d` and treat any duplicate literal header line as a STOP-and-review signal before the merge commit lands. This directly restores, in mechanical form, the exact forcing function `merge=union` removes (a human/agent noticing a same-header collision via conflict markers) — at near-zero cost, and without requiring any of the 85 inventoried consumers to change. Land it alongside the `.gitattributes` file, not as a follow-up.
- **Dimension 5 (Medium) — verify before landing.** Confirm whether `check-foreign-staging.sh` L185's `\bS\d+\b` regex ambiguity (flagged as open in `improvement-log.md:889`) has been closed since 2026-07-14; if not, note the residual exposure explicitly in the commit or in `decisions.md` rather than landing the `.gitattributes` change on the unstated assumption that marker-suffix uniqueness is already fully hardened.
- **Dimension 4 (Medium) — no action required, note only.** State in the commit message or `decisions.md` that reversibility applies to future merges only; a merge already resolved under `merge=union` requires manual inspection (the same post-merge grep above) to undo if it turns out wrong, not a plain `git revert`.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
