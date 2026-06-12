---
model: opus
---

Promote a research project's evolved pipeline up into its canonical workflow template: $ARGUMENTS

Use this command when a deployed project's `.claude/` tooling and workflow reference docs have
**evolved past** the canonical template they were deployed from, and you want those improvements
graduated *up* into the template so every future project inherits them. This is the reusable form
of the `promote-rw-canonical` mission — the multi-session, by-hand promotion it replaces.

**Direction:** project → canonical (upward). This is the inverse of `/sync-workflow` (canonical →
project) and broader than `/graduate-resource` (one resource at a time). This command promotes a
whole evolved pipeline — many files, with per-file direction classification and an anti-clobber
contract — and reconciles canonical files that drifted independently rather than overwriting them.

## Input

`$ARGUMENTS`:
- **Source project path** (optional; default = current working directory). The project whose
  evolved tooling is being promoted.
- **`--template <name>`** (optional; default = `research-workflow`). The canonical template under
  `ai-resources/workflows/<name>/` to promote into. Parameterized so the recipe can target other
  templates without modification.

If no argument is given and the cwd is not a deployed project (`CLAUDE.md` absent), stop and ask
for a source project path.

## What this command owns vs. reuses

This command owns the **recipe and its gates** — the anti-clobber inventory, the direction
classification, the phase sequence, and the residue/risk/QC discipline. It does **not** reimplement
the work that existing commands already do:

- `/innovation-sweep` — optional P0 discovery aid (finds innovations the per-write hook missed).
- `/graduate-resource` — its Step 5.5 residue-scan subagent contract is reused verbatim in P3.
- `/risk-check` and `/qc-pass` — the P5 gates.
- `/sync-workflow` — the P6 re-sync verification.

---

## Phase 0 — Discover & freeze the inventory

This is the load-bearing phase. Its output, the **frozen inventory**, is the anti-clobber contract:
every file edited in later phases must appear in it with an explicit direction, and nothing off the
list gets touched.

### 0.1 — Resolve and verify paths

- `PROJ` = source project path (arg or cwd). Verify `{PROJ}/CLAUDE.md` exists; else stop.
- `TEMPLATE` = `--template` value or `research-workflow`.
- `CANON` = `ai-resources/workflows/{TEMPLATE}/`. Verify `{CANON}/.claude/` exists; else stop
  ("canonical template not found — check the `--template` name").
- `DATE` = today (`YYYY-MM-DD`).
- `INVENTORY_PATH` = `{PROJ}/audits/working/promotion-inventory-{DATE}.md`. **Write the inventory
  here — under the resolved source project, never a hardcoded path.**

### 0.2 — Resume check

If a `{PROJ}/audits/working/promotion-inventory-*.md` already exists for this `TEMPLATE`, read the
most recent. If its phases are partially complete (a `## Progress` section tracks this — see 0.6),
offer to **resume from the first incomplete phase** instead of rebuilding. This is the cross-session
resume anchor that replaces the `/mission` scaffold. If the operator declines, proceed with a fresh
inventory (new dated file; never overwrite the prior one).

### 0.3 — Build the file inventory (the promotable surface)

Walk the **canonical template's real-file set** — the promotable surface — and pair each with its
project counterpart. Cover, for both `CANON` and `PROJ`:

```
.claude/commands/*.md
.claude/agents/*.md
.claude/hooks/*
reference/**/*.md   (and *.template.md)
docs/*.md
SETUP.md
```

For each file:
- **Skip symlinks.** Project `.claude/` commands and `reference/skills/` are typically symlinks back
  to `ai-resources/` — they are shared resources, not promotion candidates. Detect with `test -L`
  (or `git ls-files -s` mode `120000`) and exclude.
- Exclude `settings.json` / `settings.local.json` (always project-specific).
- `diff` the project copy against the canonical copy. Identical → class `identical`, no action.

### 0.4 — Direction-classify every differing file (the git-direction-check)

For each file that **differs**, a plain `diff` cannot tell you *who* changed — whether the project
advanced or canonical drifted independently. Use git history to decide. Both copies live in git
repos (project repo and ai-resources repo); compare the commit history touching each file:

- **`project-ahead`** — the project copy carries content changes (new steps, rules, fixes) the
  canonical copy lacks, and canonical's copy has **no** independent advance on the differing region.
  → Promote (a clean graduation).
- **`true-conflict (both advanced)`** — *both* copies have independent changes on overlapping
  regions since they diverged (canonical was edited after deployment AND the project evolved its
  copy). → **Merge-down in P2** (project base, canonical advance preserved verbatim).
- **`out-of-scope content`** — the difference is pure project *instantiation*, not tooling: a
  placeholder fill (`{{PROJECT_TITLE}}` → a real title), domain terms, the filled `CLAUDE.md` body,
  `source-map.md`, instantiated `known-limits.md` / paths, `reference/inputs/`, `reference/sops/`.
  → Do **not** promote.
- **`already-canonical`** — the improvement already landed in canonical in a prior promotion; the
  project copy merely matches it. → Verify-present only, never re-graduate.

When the direction is genuinely ambiguous from git history (e.g. squashed/rebased history obscures
it), mark the file `⚠ ambiguous` and surface it explicitly at the P0 gate rather than guessing —
guessing wrong on this is what silently clobbers a canonical advance.

### 0.5 — Build the placeholder DROP list

List every project-instantiation token that must **not** travel up — canonical retains the bare
`{{PLACEHOLDER}}`, carrying only the tooling delta around it. Derive from the source project's
`CLAUDE.md` Project Config and the template's known placeholders. Typical members:
`{{PROJECT_TITLE}}` title lines · `{{RESEARCH_AREA_PHRASE}}` query prefixes · `{{SECTION_SEQUENCE}}`
· `{{CLUSTER_BLOCK_THRESHOLD}}` / `{{SECTION_BLOCK_THRESHOLD}}` *values* (keep the placeholder) ·
`{{DOMAIN}}` / `{{OPERATOR_NAME}}` · `{{PART_*_DIR}}` · country-set, deal-size lens, period, and any
other field from the project's Project Config block.

### 0.6 — Write the frozen inventory

Write `INVENTORY_PATH` with:

```markdown
# Promotion Inventory (FROZEN) — {project} → canonical {template}

**Date:** {DATE} · **Source:** {PROJ} · **Template:** {CANON}
**Role:** Anti-clobber contract. Every file edited in P1–P4 must appear here with an explicit
direction. Nothing not on this list gets touched.

## Classification
| File | Class | Item / delta | Action |
|---|---|---|---|
| ... | project-ahead | {one-line description of the improvement} | Promote (Group {X}) |
| ... | true-conflict | {project delta} vs {canonical advance} | MERGE (P2) — see note |
| ... | out-of-scope content | {why} | Do not promote |
| ... | already-canonical | landed {commit/date} | Verify-present only |

### True-conflict merge notes
{Per true-conflict file: which copy is the base, exactly which canonical advance to restore verbatim.}

## OUT of scope — do not promote
{symlinks; project content; instantiations}

## Already-canonical guard — verify-present only, never re-graduate
{prior-landed items}

## Placeholder DROP list
{the 0.5 list}

## Progress
- [ ] P0 inventory frozen
- [ ] P1 judgment items QC'd
- [ ] P2 true-conflicts merged
- [ ] P3 project-ahead files graduated
- [ ] P4 deployment surface reconciled
- [ ] P5 risk-check + QC + commits
- [ ] P6 residue scan + re-sync verified
```

Group the `project-ahead` files into logical landing groups (Group A, B, …) so P3 and the P5 commits
have a natural unit structure.

## Phase 0 gate — operator review checkpoint [Operator]

Present the frozen inventory. **This is the one human checkpoint** — direction classification is the
riskiest auto-step, so the project-ahead / true-conflict / out-of-scope split must be
operator-confirmed before any edit lands. Call out:
- Every `true-conflict` file and the proposed merge direction.
- Every `⚠ ambiguous` file (these especially need a human call).
- The OUT-of-scope and already-canonical guards.

**Hard stop-condition (carried through every later phase):** if any planned edit *would drop a
canonical advance*, halt. Do not promote a project version over a canonical-ahead region without the
P2 merge-down.

Wait for confirmation. Once confirmed, mark `[x] P0` in the inventory's Progress section and proceed
autonomously through P1–P4 (the gate covers them). Re-surface only on a stop-condition, a residue
cap-hit, or a P5 risk-check non-GO.

## Phase 1 — QC the judgment items

Some promotions are **evidence-backed judgment fixes** (e.g. the mission's D-series skill edits)
rather than mechanical tooling deltas. These graduate **only if** their supporting evidence passes
an independent `/qc-pass`.

1. Identify judgment items in the inventory (skill/rule changes whose correctness depends on an
   analysis or calibration report, not just a code delta).
2. Run `/qc-pass` on each item's evidence artifact.
3. **QC PASS** → the item stays in the promotion set.
4. **QC FAIL** → **defer, do not drop.** Record the deferral in the inventory (move the row to a
   `## Deferred (QC pending)` section with the reason). A failed item is never silently removed.

Mark `[x] P1`.

## Phase 2 — Reconcile true-conflicts (merge-down)

For each `true-conflict` file, in inventory order:

1. Take the **project version as the base** (it carries the project-ahead delta).
2. **Restore canonical's independent advance verbatim** into the merged file — the exact paragraph,
   step, or block canonical added after deployment, copied byte-for-byte from the canonical copy.
3. Write the merged file to `CANON`.
4. **Verify:** `diff` the merged file's restored region against canonical's — it must be
   byte-identical. Then review the full merge to confirm **no canonical advance was dropped**
   (the hard stop-condition). If anything was dropped, halt and re-surface.

If P0 found zero true-conflicts, skip silently. Mark `[x] P2`.

## Phase 3 — Generalize & graduate the project-ahead files

Promote the `project-ahead` files group-by-group, reusing `/graduate-resource`'s methodology:

1. **Route to the correct home.** Tooling deltas land in the template (`{CANON}/...`). **Judgment
   fixes that belong in a shared skill land in `ai-resources/skills/`, never inside a template
   command.** (Routing a skill-class fix into a template command is an off-mission signal.)
2. **Auto-strip per the DROP list.** Carry only the tooling delta up; replace each project-fill with
   the bare `{{PLACEHOLDER}}`, keeping placeholders intact. Match `/graduate-resource` Step 4
   generalization (no hardcoded project paths, no operator names, no domain terms).
3. **Residue-scan each graduated file** using the `/graduate-resource` **Step 5.5** subagent
   contract verbatim (fresh-context `general-purpose` agent; `RESIDUE: clean` / `RESIDUE: {N}`
   verdict; 2-pass fail-and-revise cap; on cap-hit, emit Step 5.5's operator-pause block). Write
   working notes to `{PROJ}/audits/working/promotion-residue-{stem}-{DATE}.md`.
4. **Keep close to the original** — promote the improvement, do not "improve" it mid-graduation.

Mark `[x] P3`.

## Phase 4 — Reconcile the deployment surface

The template's deployment contract must describe the files just changed:

1. Update `{CANON}/SETUP.md` for any new stage-entry step, instantiation instruction, or file the
   promotion added.
2. Update the template's shared manifest if shipped-file membership changed. Check
   `{CANON}/.claude/shared-manifest.json` first (its usual home), but locate the actual path before
   editing — do not assume it exists at the template root.
3. Write a **consumer-confirmation note** (the mission's "DR-7" step): for each changed file, name
   who downstream reads it — including easily-missed consumers like symlink farms and vault copies.
   Record the note for the P5 commit messages.

Mark `[x] P4`.

## Phase 5 — Gates & commits

1. **`/risk-check`** — this promotion typically spans multiple structural change classes (canonical
   template + shared hook + shared skills). Run it. On **RECONSIDER / NO-GO**, halt and surface the
   verdict; the inventory and any merged files stay on disk for revision.
2. On **GO** (or PROCEED-WITH-CAUTION with mitigations applied) → **independent `/qc-pass`** on the
   landed changes. Resolve findings to GO.
3. **Commit in logical groups** (one per landing group from the inventory) with the P4 consumer note
   in each message. Per workspace rules: commit directly, no pre-commit `git status`/`diff`.
4. **Push is gated to session end** — never push here. Commits accumulate; the single y/n push
   confirmation happens at `/wrap-session`.

Mark `[x] P5`.

## Phase 6 — Verify clean

1. **Residue scan** across all graduated files: no source-project tokens
   (project name, country-set, domain, operator name, period, section IDs); every `{{PLACEHOLDER}}`
   intact and unfilled.
2. **`/sync-workflow {PROJ}`** should now report the project **in-sync** with canonical, or only
   intentional project-specific divergence. A surprise conflict here means a promotion was missed or
   mis-merged — investigate before closing.
3. **(Optional) scratch-project deploy test** — walk `SETUP.md` into a throwaway project; confirm
   `/workflow-status` passes and placeholders are unfilled.

Mark `[x] P6`. The promotion is complete; remind the operator to `/wrap-session` (push pending).

---

## Key rules

- **The frozen inventory is law.** No file is edited unless it appears in the inventory with an
  explicit direction. Nothing off-list gets touched.
- **Never drop a canonical advance.** A project version is never promoted over a canonical-ahead
  region without the P2 merge-down. This is the hard stop-condition.
- **Never hardcode a project token into the template.** Generalize per the DROP list; residue-scan
  to prove it.
- **Skill-class fixes go to skills, not template commands.**
- **QC-fail defers, never drops.**
- **No edit lands without `/risk-check` GO; no commit lands without independent QC.** If QC is
  unreachable (subagent-gate + oversized context), commit-block and `/handoff` QC-PENDING per
  `docs/qc-independence.md`.
- **Push is operator-gated at session end** — the only irreversible step, never autonomous.
- **Verify-present, never re-graduate** already-canonical work.
