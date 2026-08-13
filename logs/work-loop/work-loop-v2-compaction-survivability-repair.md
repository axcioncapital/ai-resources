---
task: work-loop-v2-compaction-survivability-repair
turn: codex
---

## Objective and scope

Make Work Loop v2 reliably recover its authoritative task after Codex compaction in every intended Work-Loop-enabled project, without adding parallel state, weakening actor boundaries, or duplicating recovery authority. The task exits only when the instruction layer is review-clean, the approved deployment scope is installed, and one representative project-repository compaction proves recovery or a safe stop.

In scope across the task: the instruction-layer correction following commit `df35ddd`; deployment only to verified Work-Loop-enabled projects and future eligible scaffolds; the operator-approved user-level compact-hook carrier; proportionate operational proof. Excluded: distributing these skills to every project, a five-compaction endurance exercise, broad Work Loop redesign, a second recovery artifact, and approving or rewriting the executable core without a later explicit operator decision.

## Lane and unit

Standard. Discovery mode. Unit 6 — verify the exact deployment surfaces, shared-resource provenance, and safe installation boundary before any cross-project or user-level change.

Named reason for the loop: the repair crosses sessions and repositories, needs bounding before deployment, and requires independent assessment of Claude's evidence before changes propagate to project environments.

Why this unit, why now: Unit 5 is accepted, so the instruction layer is review-clean enough to proceed. Deployment is the next unmet exit condition, but the exact enabled-project surfaces, the provenance of two project skill links, the user-level hook carrier, and the future-scaffold consumer must be verified before a machine-wide or cross-repository installation is framed.

Governing authority: the operator has approved a user-level hook carrier, deployment to the intended Work-Loop-enabled projects and future eligible `/new-project` scaffolds, and only individually approved executable-core clauses. The approved proposal preserves one repository interface and the operator–Codex–Claude role split. The 12 August required-fixes report is operator-supplied source material, but its five-compaction test and whole-core approval recommendation are superseded for this task by the current objective: one representative recovery-or-safe-stop proof and approved clauses only.

Codex framing decision: this is one read-only discovery deliverable: a verified deployment map sufficient to frame the next implementation unit. It changes no deployment surface. The later installation and the representative compaction proof remain separate because combining discovery, machine-wide writes, cross-project writes, and operational proof would be oversized and would conceal consequential scope mistakes.

Pre-deployment structural risk review, completed by Codex before opening the unit:

1. **Machine scope:** `~/.codex/hooks.json` affects current and future checkouts on this machine. The operator approved that carrier, but discovery must establish its current shape, merge behavior, and exact hook target before any write.
2. **Single ownership:** the compact hook remains only a trigger; Reorient remains the sole recovery owner. No project copy may introduce task selection, mutation, or a second recovery record.
3. **Shared-resource provenance:** projects should consume canonical shared skills through the existing synchronization/link mechanism. Unknown or branch-bound links must be explained before deployment; manual skill copies are not an acceptable default.
4. **Project boundary:** deployment is limited to verified Work-Loop-enabled projects and future eligible scaffolds, not every repository. Candidate names are claims until Claude verifies their manifests and instructions.
5. **Authority:** no deployment edit may approve or rewrite the draft executable core. Only the operator-approved clauses and decisions govern.
6. **Proof sequencing:** installation must precede the representative compaction proof, and discovery must identify one suitable project without running the proof now.

## Brief

Required outcome: return a bounded, evidence-backed map of the exact files and mechanisms that a later deployment unit should change, including permissions or unresolved risks. Do not install, copy, relink, or edit any deployment surface in this unit.

Check against the repository:

1. Verify whether these three candidates are the complete intended enabled set, using each candidate's live `.claude/shared-manifest.json`, project `AGENTS.md`, and any explicit Work Loop enablement marker rather than names alone: `axcion-systems-builder`, `axcion-systems-builder-dashboard`, and `axcion-systems-builder-methodology-r-d`. Report each absolute checkout path and the evidence that includes or excludes it; do not scan unrelated repositories after the set is settled.
2. For each included project, establish the current shared-skill declarations for `work-loop-v2`, `reorient`, and `handoff-thread`; inspect the existing shared-resource synchronization mechanism; and resolve the actual destination and provenance of any existing project skill link. Specifically explain the two previously unexplained links and whether they remain valid when this branch is not the active canonical checkout.
3. Inspect each included project `AGENTS.md` for the minimal compaction-preservation contract: exact task-state path, bound checkout, governing plan path, workflow and phase, and current `## Next action`. Identify the canonical template fragment that should supply it to future eligible projects; distinguish the template from its consuming command.
4. Inspect the current user-level Codex hook configuration and the existing compact-hook carrier read-only. Establish whether `~/.codex/hooks.json` exists, the schema or merge behavior a safe edit must preserve, the exact carrier script path that can remain stable outside this branch, and whether the carrier merely emits the executable Reorient instruction without selecting or mutating task state. Do not write outside the checkout.
5. Inspect `/new-project`'s canonical templates and consumer contract only far enough to identify how future projects become Work-Loop-eligible and which fragments must change. Do not broaden the default to projects that are not eligible.
6. Return the minimum later implementation boundary: exact files inside each repository, the user-level file, any stable carrier location, required synchronization action, and any permission or ordering constraint. Name one representative project suitable for the later compaction proof and why it exercises project-repository discovery.

Required evidence capable of failure:

- A compact table for the three candidate projects showing enablement evidence, manifest state, AGENTS preservation state, skill-link destination or provenance, and required later change.
- Exact paths and short quoted excerpts for the user hook config, carrier, synchronization mechanism, canonical template fragments, and `/new-project` consumer that settle the map. For an absent file or declaration, name the bounded path or surface checked.
- A risk list limited to facts that would change the deployment boundary or ordering; distinguish verified facts from unresolved unknowns.
- A proposed minimum changed-path set for the later deployment unit and one recommended representative proof project. This is a non-governing technical recommendation for Codex assessment, not implementation permission.
- Confirm that this discovery changed nothing except this state file and automatic `logs/friction-log.md` telemetry, set `turn: codex`, commit the handback, and do not push.

Completion condition: Codex can frame one bounded deployment implementation unit without guessing which projects are enabled, where shared skills resolve, how the user hook is safely carried, which template is canonical, or what exact files and permissions are involved. No deployment change has been made.

Stop and hand back if a candidate's enablement or a skill link cannot be established from bounded repository evidence, if the user-level hook schema or stable carrier cannot be determined safely, or if the later deployment would require a surface outside the approved scope. Stop for the operator if the evidence reveals a new machine-wide policy choice. A false premise is a valid result; report it instead of implementing or widening scope.

## Latest result

Discovery unit. The map below is the inspection record. Nothing was installed, copied, relinked or
edited. Two findings change the deployment framing and one is a hard blocker.

### Finding 0 — the three "projects" are one repository with three worktrees

This reframes items 1, 2 and 6 of the brief, so it comes first. `git rev-parse --git-common-dir` in
each candidate returns the same store, and `git worktree list` from the first confirms it:

| Checkout (absolute) | Branch | HEAD |
|---|---|---|
| `…/Axcion AI Repo/projects/axcion-systems-builder` | `main` | `57e583f` |
| `…/Axcion AI Repo/projects/axcion-systems-builder-dashboard` | `session/2026-08-10-dashboard` | `d94c44e` |
| `…/Axcion AI Repo/projects/axcion-systems-builder-methodology-r-d` | `session/2026-08-10-methodology-r-d` | `ab20907` |

So "deploy to three projects" is really "deploy to **one** project repository". Tracked files reach
all three checkouts by branch merge; untracked per-checkout artifacts (symlinks, `.codex/`) do not, and
that split explains every anomaly below.

### Finding 1 — HARD BLOCKER: the Work Loop cannot complete in any project checkout today

`logs/scripts/work-loop-owner.sh` is **absent from all three checkouts** (checked
`projects/<name>/logs/scripts/work-loop-owner.sh` in each). The Claude command's Step 1.5 requires that
helper and says so in terms that admit no workaround: *"If the check cannot run, stop. A missing,
unreadable or failing helper is not permission to continue."* Every `/work-loop-v2` invocation in these
checkouts would therefore stop before Step 2.

This is not hypothetical exposure: each checkout already holds live task-state files —
18 under `main`, 10 under each session branch — and `.claude/commands/work-loop-v2.md` resolves in all
three (symlink to `../../../../ai-resources/.claude/commands/work-loop-v2.md`). The Claude half is
installed and its precondition is not. Reorient degrades gracefully here and Claude does not: Reorient's
fallback check 2 carries an explicit by-hand alternative ("where the checkout does not carry that
script, make the same reads by hand — they are plain file reads and need no git"); Step 1.5 has no such
clause. **A deployment unit that does not ship this helper installs a Work Loop that cannot run.**

### Finding 2 — enablement, per candidate

Evidence is each checkout's live `.claude/shared-manifest.json`, its `AGENTS.md`, and the actual link.

| Checkout | Manifest `skills.shared` | AGENTS preservation | Skill link | Provenance | Later change |
|---|---|---|---|---|---|
| `axcion-systems-builder` (main) | `["work-loop-v2"]` — commit `e67c1ab`, 2026-08-10 20:56:36 | **absent** (Work Loop fields not in § Compaction) | `.agents/skills/work-loop-v2 → ../../../../ai-resources/.agents/skills/work-loop-v2`, resolves, untracked | declared; sync-reproducible | add `reorient` to manifest; add preservation fields; install owner helper |
| `axcion-systems-builder-dashboard` | **no `skills` block at all** | absent (same file) | same link, resolves, untracked | **undeclared — hand-made** | same, plus the manifest declaration itself |
| `axcion-systems-builder-methodology-r-d` | **no `skills` block at all** | absent (same file) | same link, resolves, untracked | **undeclared — hand-made** | same |

`AGENTS.md` is byte-identical across all three (SHA-256 `d846f4d828e16927…`), as expected from one repo.

**Is this the complete intended enabled set?** Yes, on the declarative evidence. Searched all 27
project `shared-manifest.json` files for `work-loop-v2|reorient|handoff-thread`: exactly one hit,
`axcion-systems-builder`. No other project declares any of the three, so no scan beyond the settled set
was needed.

**But `reorient` and `handoff-thread` are deployed nowhere.** No project declares either, and no project
carries a link for either. `reorient` is the sole recovery owner the compact hook points at, so the
carrier currently names a skill that does not exist in any project checkout.

### Finding 3 — the two unexplained links, resolved

Both undeclared links are hand-made, and the mechanism explains why they survive.

- **Origin.** The dashboard and methodology-r-d manifests have exactly one commit each — `e37b5c4`, the
  original scaffold — and `git log -S'skills' -- .claude/shared-manifest.json` returns nothing for
  either. They never carried a `skills` block. The links were created 2026-08-10 20:55 and 20:56, the
  same minutes as the opt-in commit on `main` (20:56:36), and `auto-sync-shared.sh`'s own header records
  the incident they answered: *"Added 2026-08-10 after the axcion-systems-builder-methodology-r-d
  worktree had /work-loop-v2 (Claude) but no work-loop-v2 SKILL.md (Codex), and Codex correctly reported
  the Work Loop unavailable."* So the hand links were the immediate fix and the manifest opt-in was the
  durable one — but the opt-in landed on `main` only, and the two session branches were already cut.
- **Why they persist.** `auto-sync-shared.sh` never overwrites — L172, `[ -e "$target" ] || [ -L
  "$target" ] && continue` — and has no prune pass, stated at L207–209: *"No drift pass for skills… a
  real (non-symlink) `.agents/skills/<name>/` is a legitimate project-local skill rather than drift."*
  An undeclared link therefore survives indefinitely **and masks the missing declaration**: the skill
  works today, and would silently vanish if the worktree were recreated.
- **Validity when this branch is not canonical.** The links resolve by relative path into
  `…/ai-resources/…`, the `main` checkout — never into this worktree. They resolve today. They do **not**
  carry this task's work: `ai-resources/.agents/skills/work-loop-v2/references/` holds only
  `repository-problem-resolution-sop.md`, so Unit 4's `routing-index.md` and Unit 5's wording are absent
  from what every project actually reads. Confirmed by `git merge-base --is-ancestor`: this branch's
  commits are not on `main`.

### Finding 4 — AGENTS.md preservation contract and its template

The five-field contract exists, in exactly one place, and it is **not** in the projects.

`ai-resources/AGENTS.md` § Compaction — present on `main`, verified by `git show main:AGENTS.md` — lists
the exact active `logs/work-loop/{task-id}.md` path, the bound checkout, the governing plan path with
its workflow and phase, and the current `## Next action`. The project `AGENTS.md` § Compaction (L113–120,
all three checkouts) preserves only the current case/phase/review point, unread output paths, and any
pending operator gate. None of the five fields appears.

**There is no canonical template fragment to supply it.** `templates/` holds six files — `README.md`,
`capability-record.md`, `incident-log-template.md`, `mission-contract.md`, `project-claude-md.md`,
`project-settings.json.template` — and none is an `AGENTS.md` or a compaction fragment.
`templates/README.md` names four live consumers plus one retired; none writes `AGENTS.md`. The
template-versus-consumer distinction the brief asks for is therefore: **the template does not exist
yet**, and `templates/README.md` L40 states the contract for creating one — *"When adding a sixth
consumer, update this contract list and the `## What's here` description for the affected template
file."*

### Finding 5 — the hook surfaces

- **User level is empty.** `~/.codex/hooks.json` is **absent**; `~/.codex/hooks/` is **absent**;
  `~/.codex/config.toml` registers no hooks (its only relevant key is `notify`, for computer-use). So a
  safe first write **creates** the file and merges with nothing. That removes the merge risk the brief
  anticipated, and replaces it with a precedence question (see risks).
- **Schema**, taken from the repo's own working file rather than from documentation:
  `{"hooks": {"<Event>": [ {"matcher": "<regex>", "hooks": [ {"type": "command", "command": "bash
  '<absolute path>'", "timeout": <n>, "statusMessage": "<text>"} ]} ]}}`. For `SessionStart` the matcher
  filters the *source*, and the value needed is `compact`.
- **The registration already exists at repo level.** `ai-resources/.codex/hooks.json` carries
  `SessionStart` with `"matcher": "compact"` → `work-loop-reorient.sh`, and this branch's copy is
  byte-identical (both 3100 bytes). Nothing needs adding there.
- **Stable carrier path:**
  `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.codex/hooks/work-loop-reorient.sh`.
  It is tracked on `main`, and every command in `hooks.json` already uses that absolute `ai-resources/…`
  form, so it is not branch-bound and survives this worktree's deletion.
- **The carrier only emits.** Read in full (53 lines): it takes `cwd` from stdin JSON, adds the git
  common dir, and emits one `additionalContext` string. It never reads `logs/work-loop`, never searches
  `turn:`, never writes, never sets `turn:`. It fails open at six points (no stdin, empty input, no
  `jq`, no `cwd`, missing dir, `jq` failure). Its header states the same prohibitions explicitly.
- **Divergence that matters.** `main`'s carrier and this branch's differ on one line. `main` tells the
  model to re-read the pointers itself; this branch's (commit `c7eb221`, **not** an ancestor of `main`)
  delegates to `$reorient` and names it the recovery owner. Because `hooks.json` hardcodes the
  `ai-resources` path, **the version that fires today is `main`'s older one**, and this branch's
  correction is inert until merged.
- **Project level does not register it.** `projects/axcion-systems-builder/.codex/hooks.json` registers
  only two `SessionStart` hooks (auto-sync, permission-sanity) — no `compact` matcher, no reorient. The
  two session worktrees have **no `.codex/` at all**, because `.codex` is untracked in the project repo
  (`git ls-files .codex` is empty). That is precisely why the user-level carrier is the right
  instrument: it reaches current and future checkouts without a per-checkout file.

### Finding 6 — `/new-project` eligibility

Read only far enough to locate the fragments. Two routes, neither Work-Loop-eligible today:

- **Direct route** — L345: *"Do NOT install `shared-manifest.json` or wire the auto-sync SessionStart
  hook"*; L389 installs a *"fixed core symlink set (no auto-sync)"*. A direct project gets no manifest,
  so no `skills.shared`, so no Codex-side skill.
- **Full route** — L473 writes `projects/{name}/.claude/shared-manifest.json` declaring project-owned
  files. This is the fragment that would need `skills.shared: ["work-loop-v2", "reorient"]`.
- **No step scaffolds `AGENTS.md` or `.codex/`** — searched `new-project.md` for both. So the
  preservation contract has no producer for new projects, which is the gap Finding 4 names.

### Risks that would change the deployment boundary or ordering

**Verified facts.** The owner helper is absent from every project checkout (Finding 1). `reorient` is
deployed nowhere. `~/.codex/hooks.json` does not exist. The repo-level compact registration already
exists and needs no edit. The carrier path is stable and its content is read-only and non-selecting.
Two links are undeclared and the sync never prunes. The projects' `AGENTS.md` lacks all five fields and
no template supplies them. This branch's skill and carrier corrections are not on `main`, so nothing the
projects read reflects Units 4 and 5.

**Unresolved unknowns, stated as unknown.**

1. **Precedence between user-level and repo-level hooks is not established.** The plan document says
   hooks are discovered from `<repo>/.codex/hooks.json` *"and the `~/.codex/` equivalents"*, but I found
   no statement in the repository of whether both fire or one shadows the other. If both fire, adding a
   user-level `compact` entry would run the carrier **twice** inside `ai-resources` checkouts — the exact
   double-reorientation the v0.1 draft was corrected to avoid. Bounded surfaces searched:
   `~/.codex/config.toml`, `ai-resources/.codex/hooks.json`, and the two plan documents that reference
   `hooks.json`. This needs settling before the user-level write, and it is a behaviour question the
   repository cannot answer.
2. **Ordering constraint implied by Finding 5.** Merging this branch to `main` changes which carrier
   fires. Installing the user-level hook before that merge would pin the machine to the older wording.
3. **Whether the two session branches are live work.** Their manifests can be fixed by merge from
   `main`, or the branches may be finished and due for deletion. That is an operator call, not a
   repository fact.

### Proposed minimum changed-path set for the later deployment unit

Non-governing technical recommendation for Codex assessment, not implementation permission.

1. **Merge this branch to `ai-resources` `main` first** — it is what the projects read, and it is the
   ordering constraint in risk 2. No project change is meaningful before it.
2. **In the project repository, on `main`, then merged to the two session branches:**
   `.claude/shared-manifest.json` — add `reorient` (and add the whole `skills` block on the two session
   branches); `AGENTS.md` § Compaction — add the five Work Loop fields; `logs/scripts/work-loop-owner.sh`
   — install, which Finding 1 makes a precondition rather than an option.
3. **User level:** create `~/.codex/hooks.json` with one `SessionStart`/`compact` entry pointing at the
   stable `ai-resources/.codex/hooks/work-loop-reorient.sh` path — **only after risk 1 is settled**.
4. **In `ai-resources`, for future eligibility:** a new canonical compaction fragment under `templates/`,
   its registration as a fifth consumer in `templates/README.md`, and the `/new-project` step that
   consumes it.

**Representative proof project: `axcion-systems-builder` (main worktree).** It is the only checkout with
a manifest declaration, its own `.codex/`, a resolving skill link and 18 live task-state files, and it is
a project repository distinct from `ai-resources`. A compaction there exercises project-repository
discovery in the way the objective means: the hook hands a `cwd` under `projects/`, the state file is in
the project's own `logs/work-loop/`, and the core resolver must reach `ai-resources` through the
`WORKSPACE/projects/<one-child>` branch of its boundary test rather than the canonical-repository branch
every unit of this task has used so far.

Evidence that this discovery could have read otherwise: three of the brief's premises did not survive
inspection as stated — the three candidates are not three projects, the "two unexplained links" are
explained by an absent prune pass rather than by anything exotic, and the deployment set is blocked by a
missing helper the brief never named. `git status --porcelain` shows only this state file and automatic
`logs/friction-log.md` telemetry; no deployment surface was touched.

Deferrals noticed and not done: the project `.codex/hooks.json` points its two hook commands at
`projects/axcion-systems-builder/.codex/hooks/`, a directory that does not exist — both are guarded by
`[ -x … ]` so they fail silently, meaning auto-sync and permission-sanity have not run in that project
since the file was written. Outside this unit and not investigated further. Unit 5's deferrals remain
open.

## Blocker

None for the discovery, which completed. But Finding 1 is a blocker on the *deployment* unit that
follows: `logs/scripts/work-loop-owner.sh` must ship to the project checkouts or the Work Loop stops at
Step 1.5 in all of them.

## Next action

Codex: assess the deployment map. Decide whether the reframing in Finding 0 changes the approved
deployment scope (one project repository, three branches — not three projects), whether Finding 1's
helper install belongs inside the deployment unit or ahead of it, and whether the user-level hook write
must wait until the user-versus-repo precedence question in risk 1 is settled. Then frame the deployment
unit, or stop for the operator if the precedence question turns out to be a machine-wide policy choice.
