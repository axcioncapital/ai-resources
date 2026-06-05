# Session Plan — S2 (2026-06-05)

## Intent

Safe low-risk backlog sweep, run **concurrently** with the S1 `/friday-act` session. Clear two named monthly-checkup config-hygiene findings that touch repos and files the S1 session does **not** own — zero collision risk. (A third candidate, the vault index-count fix, was found already resolved during planning — see Findings.)

## Model

**Recommended: Sonnet 1M (`claude-sonnet-4-6[1m]`).** This is "doing" work — small, well-scoped edits to two project CLAUDE.md Model-Selection sections and two skill frontmatter blocks, with only light judgment (de-version wording; pick the right `model:`/`effort:` tier from an existing convention). Current session model is Opus 4.8 (1M).

→ `/model sonnet` (mismatch — optional; the work is small enough that staying on Opus is also fine).

## Source Material

- `audits/friday-checkup-2026-06-05.md` — findings #11 (research-pe skill frontmatter, item 117) and #12 (stale model pins, item 118). Finding #5 (item 110, vault index counts) — verified already resolved.
- `projects/nordic-pe-screening-project/CLAUDE.md` (line 75 — `Opus 4.7 (claude-opus-4-7)` pin).
- `projects/project-planning/CLAUDE.md` (line 64 — `Opus 4.7` pin).
- `projects/research-pe-regime-shift-advisory-gap/reference/skills/knowledge-file-producer/SKILL.md` — no `model:`/`effort:` frontmatter.
- `projects/research-pe-regime-shift-advisory-gap/reference/skills/report-compliance-qc/SKILL.md` — no `model:`/`effort:` frontmatter.
- Frontmatter convention reference: sibling research-pe `reference/skills/*` (e.g. `knowledge-file-completeness-qc`, `prose-compliance-qc`, `document-integration-qc` → `model: opus, effort: high`; mechanical skills → `model: sonnet, effort: medium`).

## Findings / Items to Address

### Item 1 — De-version stale model pins (finding #12 / item 118)
- **nordic-pe** `CLAUDE.md:75` reads: *"Recommended posture: Opus 4.7 (`claude-opus-4-7`) for nearly all program work."* The point-version is now stale (current is Opus 4.8). Line 77 also pins `claude-sonnet-4-6[1m]` (sonnet pin is fine — keep the `[1m]` suffix; only the Opus point-version is stale).
- **project-planning** `CLAUDE.md:64` reads: *"Recommended posture: use Opus 4.7 for plan/spec drafting…"*
- **Fix:** de-version the **Opus** reference to tier-only ("Opus"), removing the `claude-opus-4-7` point-version, so the recommendation is self-maintaining as models advance. Keep the surrounding recommendation prose and rationale intact. This is a *recommended-posture* edit (permitted per Model Tier rule) — not a default-model declaration.
- **Consequence if unfixed:** the recommendation silently rots each model release; audit re-flags it every cycle.

### Item 2 — Add missing skill frontmatter (finding #11 / item 117)
- Both research-pe project-local skills lack `model:`/`effort:` frontmatter → audit-repo YELLOW. Adding the fields clears it to GREEN.
- **`report-compliance-qc`** → `model: opus`, `effort: high` (matches the QC-skill convention: `prose-compliance-qc`, `document-integration-qc`, `knowledge-file-completeness-qc` are all opus/high; the skill makes BLOCKING/NON-BLOCKING severity judgments).
- **`knowledge-file-producer`** → `model: opus`, `effort: high` (the skill description states it "handles the judgment about what to preserve and what to condense"; comparable producers `evidence-to-report-writer` / `decision-to-prose-writer` are opus/high). **Confirm at execution** — if the condensation is judged mechanical, `sonnet`/`medium` is the fallback.
- **Placement:** insert the two fields into the existing YAML frontmatter block (after `name:`/`description:`), preserving the block structure.
- **Consequence if unfixed:** audit-repo stays YELLOW; the skills run on the inherited session model with no declared tier.

### Item 3 — Vault index counts (finding #5 / item 110) — VERIFIED ALREADY RESOLVED, NO ACTION
- Planning check found the live `vault/components/_index.md` already reads **49 / 45 / 11** for Commands / Agents / Projects, matching the actual `####`-entry counts in `commands.md` (49), `agents.md` (45), `projects.md` (11). The fix was applied during the checkup's 03:24 vault refresh.
- The friday-checkup report's 03:45 snapshot lists it as pending (stale). The integrity report's target values (49/45/11) are present.
- `vault/` is gitignored (`vault/*`) — there is nothing to commit even if it were freshly edited. **No action; record as already-resolved in the wrap note.**

## Execution Sequence

### Stage 1 — Item 1: de-version model pins (~2 edits)
1. Edit `nordic-pe/CLAUDE.md:75` — replace `Opus 4.7 (\`claude-opus-4-7\`)` with tier-only "Opus"; keep the rest of the sentence + rationale. Leave line 77's sonnet `[1m]` pin untouched.
2. Edit `project-planning/CLAUDE.md:64` — replace `Opus 4.7` with "Opus"; keep surrounding prose.
3. Re-read both edited regions from the filesystem to confirm the point-version is gone and prose still reads cleanly.

### Stage 2 — Item 2: add skill frontmatter (~2 edits)
4. Edit `knowledge-file-producer/SKILL.md` — add `model: opus` + `effort: high` to frontmatter (confirm tier first against the skill body's cognitive load).
5. Edit `report-compliance-qc/SKILL.md` — add `model: opus` + `effort: high`.
6. Re-read both frontmatter blocks to confirm valid YAML.

### Stage 3 — verify + close
7. Confirm Item 3 (vault counts) needs no action — already verified during planning.
8. `/qc-pass` on the four edits (de-version wording preserved meaning; frontmatter tiers match convention; no scope bleed into friday-act files).
9. Commit per workspace Commit Rules — **note: nordic-pe, project-planning, and research-pe are each their own git repo** (nested under `projects/`); commit in each touched repo separately. `_index.md` is gitignored → not committed.
10. Update the S2 session-notes entry; leave push to `/wrap-session` (gated, batched — and **do not push while the S1 friday-act session is mid-flight**).

## Scope Alternatives

- **Minimal:** Item 1 only (de-version pins) — 2 edits, ~1 repo-pair, fastest, clears the recurring HIGH finding.
- **Recommended (this plan):** Items 1 + 2 — 4 edits across 3 project repos, clears two named findings (one HIGH, one YELLOW→GREEN). Item 3 is a no-op verify.
- **Maximal:** add the session-plan filename date-qualify (#113) — declined for this session (broader harness change, likely needs `/risk-check`; keep the concurrent session low-risk).

## Autonomy Posture

**Full autonomy.** No structural change class triggered: these are project-local CLAUDE.md *recommended-posture* edits and project-local skill frontmatter additions — not canonical/workspace CLAUDE.md edits, not hook/permission/command/skill-creation changes, no symlinks, no shared-state automation. `STRUCTURAL_RISK = false` → no `/risk-check` gate. Run to completion; `/qc-pass` before commit.

## Risk

- **Concurrency (primary):** S1 `/friday-act` is live. This plan touches **zero** S1-scope files (S1 owns `settings.local.json`, `marketing-positioning/CLAUDE.md`, `research-pe/CLAUDE.md` push-rule, `/new-project` template, Read() deny rules). Note Item 2 edits research-pe *skill* files under `reference/skills/`, **not** `research-pe/CLAUDE.md` — different files, no overlap. **Stop-if:** any in-scope file shows a concurrent foreign edit when opened.
- **session-notes.md shared write:** S2 already appended its own marker-bearing header (per `docs/session-marker.md`); concurrent same-day headers are the expected shape. Wrap will append under the S2 header only.
- **Push:** gated to `/wrap-session`; explicitly hold until the S1 session has wrapped to avoid a concurrent-push race.
- **Low blast radius:** all four edits are reversible single-line/single-block changes; no downstream consumer depends on the exact point-version string.
