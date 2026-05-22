# Graduate-Resource Candidates — 2026-05-22

Produced by workspace sweep across all project `.claude/` directories.

---

## Tier 1: Ready to graduate (clean case)

**`check-claim-ids.sh`**
- Identical copies in `projects/buy-side-service-plan/.claude/hooks/` and `projects/nordic-pe-macro-landscape-H1-2026/.claude/hooks/`
- Not in ai-resources. Not in innovation registry.
- What it does: PostToolUse hook; checks pipeline artifact files for `[CITATION NEEDED]` tags; emits targeted severity warnings (non-blocking, exit 0).
- Hardcoded paths: `analysis/chapters`, `analysis/cluster-memos`, `report/chapters`, `execution/research-extracts` — match research-workflow layout exactly.
- **Recommended target:** `ai-resources/workflows/research-workflow/.claude/hooks/check-claim-ids.sh`
- **Changes needed:** none. Register in research-workflow `settings.json`. Remove one project copy (they're identical; keep whichever is preferred).

---

## Tier 2: Loose-end (already in registry, operator decides)

**`friction-log-trigger.sh`** (`projects/repo-documentation/.claude/hooks/`)
- Registry entry: `triaged:loose-end` ("generalizable friction-log nudge pattern; not yet graduated — operator decides")
- What it does: PostToolUse Write/Edit hook; fires when `friction-log.md` is written; emits non-blocking nudge "Run /improve at session end."
- Note: different trigger from existing `friction-log-auto.sh` (which fires on skill invocations with `friction-log: true`). Complementary, not duplicate.
- **Recommended target:** `ai-resources/.claude/hooks/friction-log-trigger.sh` (shared)
- **Changes needed:** none — fully generic.

---

## Tier 3: Workflow template bundle (ai-development-lab)

Three commands form the ai-development-lab idea-screening pipeline. Not in registry. Not in any shared location.

| Command | Purpose |
|---------|---------|
| `projects/ai-development-lab/.claude/commands/analyze-transcript.md` | Full pipeline: transcript → extraction → grilling → two agent analyses (ai-engineer + system-owner) → decision memo |
| `projects/ai-development-lab/.claude/commands/review-pipeline-run.md` | QC reviewer: checks a completed run against stage contracts, produces improvement list |
| `projects/ai-development-lab/.claude/commands/produce-handoff.md` | Converts an approved Do-Now memo into a project-planning handoff seed |

- Dependencies: `pipeline/ref-*.md` reference files (project-local), `ai-engineer` agent (project-local) — bundle graduation required.
- Hardcoded references: `Patrik` in `produce-handoff.md`; `Axcíon` branding in a few places.
- **Recommended target:** `ai-resources/workflows/ai-development-lab/.claude/commands/` (new workflow template)
- **Scope:** bigger lift — also requires graduating `ai-engineer` agent and `pipeline/ref-*.md` files.

---

## Registry cleanup (no file graduation needed)

| Item | Current status | Action |
|------|---------------|--------|
| `resolve-improvement-log.md` | `triaged:graduate-candidate` in registry, but already in `ai-resources/.claude/commands/` | Update registry → `graduated` |
| 11 settings-pattern entries | `triaged:graduate` → `docs/permission-template.md` | Documentation work, not file graduation — separate task |

---

## Not candidates (confirmed)

- `buy-side-service-plan` / `nordic-pe` workflow commands — already canonical in `ai-resources/workflows/research-workflow/`
- `produce-jargon-gloss.md` (nordic-pe) — already in research-workflow template (dual-copy sync contract)
- `kb-*.md` commands (global-macro-analysis) — tightly coupled to that project's KB structure
- `backup-session-plan.sh` — already in registry as project-specific
- Brand book, interpersonal-communication, travel-os, vault commands — domain/personal specific
