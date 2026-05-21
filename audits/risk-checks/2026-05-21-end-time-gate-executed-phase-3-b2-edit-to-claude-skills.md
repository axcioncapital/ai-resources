# Risk Check — 2026-05-21

## Change

End-time gate — executed Phase 3 B2 edit to `.claude/skills/session-governor/SKILL.md`: filled the `STUB [B2]:` markers. Added a new Phase C section (strategic `/compact` at a unit boundary + governor-owned four-file rehydration from disk); filled Phase B step 5 with real context-budget monitoring (`context_usage` events, `/compact` trigger at 60–70%); filled Phase A step A2 part 5 (governor acts on the compaction policy) and added attention-budget initialization; filled Phase B steps 11–13 uncorrectable-non-blocking disposition to append to the `blocked_items` queue (B3), leaving the co-located `STUB [PHASE-5]:` re-invoke/harden mechanics intact; added a Blocked-Item Queue (B3) section and an Escalate Procedure section (B4 attention budget with `max_interruptions` + B5 decision-packet format); added an `attention_budget` object to the `current-state.json` shape documented in the skill; updated Build Status, the marker-family legend, the Stub Marker Index, Output Summary, and Edge Cases. The Phase D `STUB [B2]:` marker (session-reporter trigger / Stop hook veto) was deliberately left as Phase 4 work. Single-file structural edit to an existing skill; no new files, no new commands, no permission changes, no hook edits, no schema-file edits. One known follow-up: the skill documents an `attention_budget` field on `current-state.json` that is not yet reflected in `harness/schemas/current-state-schema.md` — the skill flags this in-file as a tracked schema-sync follow-up, not a B2 deliverable.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-bounded single-file skeleton edit whose only elevated risk is one Medium hidden-coupling item — the skill now documents an `attention_budget` field that the canonical `current-state.json` schema does not yet carry — which a single named follow-up resolves.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The edited file is a SKILL.md, not an always-loaded file — it loads only when the `session-governor` skill is invoked, which is "once per harness session, after mandate-parser has written mandate.json" (SKILL.md line 8 frontmatter description). It is pay-as-used, not per-turn.
- The file grew from ~8.6 KB to a larger body: the diff stat reports `304 ++++--` for `SKILL.md` with `313 insertions, 68 deletions` across the whole change set (`git diff --stat`). The net growth is real but lands in an on-demand skill, not workspace/project CLAUDE.md.
- No hook is registered or modified — change description states "no hook edits" and `git status --short` shows no `.claude/hooks/` or `settings.json` files touched.
- No `@import` was added to an always-loaded file. The skill's own frontmatter already instructs loading `@.claude/references/harness-rules.md` (line 9) — that pointer is unchanged by this edit.
- The skill carries `model: opus` frontmatter (line 10), unchanged — no model-tier cost shift.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings file is in the change set: `git status --short` lists only `SKILL.md` plus four `logs/` files (`harness/logs/innovation-registry.md`, `harness/logs/session-notes.md`, `harness/logs/session-plan.md`, `logs/innovation-registry.md`) — no `.claude/settings.json` or `settings.local.json`.
- No new tool family is authorized. The skill describes governor behaviors (`/compact`, git commit, `wc -w`, `grep -c`, `test -f`) that are documentation of intended runtime actions inside a skill body, not permission grants — and `/compact`, git, and read-only Bash are already established harness patterns (the B1 skeleton already documented git commit at step 18 and `test -f` verification at step 9).
- No `deny` rule is removed or narrowed; no scope escalation (project → user) occurs.

### Dimension 3: Blast Radius
**Risk:** Low

- Direct file touch for the structural change: one file — `.claude/skills/session-governor/SKILL.md` (the four `logs/` files in the working tree are session bookkeeping, not part of the evaluated structural change).
- Caller enumeration. `grep -rl "session-governor"` across `.claude/` returns three files: the skill itself, `.claude/references/harness-rules.md`, and `.claude/skills/mandate-parser/SKILL.md`. `harness-rules.md` is a reference the skill loads (a dependency of the skill, not a caller of it). `mandate-parser/SKILL.md` is the upstream skill that hands off to the governor — the SKILL.md confirms the contract direction at lines 77-80 ("inherits control from `mandate-parser` after its Step 10"). The B2 edit does not change the handoff contract: Phase A still reads `mandate.json` and the same `fields`; the only new read is the optional `max_interruptions` field, which the skill itself handles with a default if absent (line 644). So the one genuine caller needs no modification.
- `grep -rl "session-governor"` across `ai-resources/` returns only four prior risk-check report files — audit artifacts, not functional callers.
- Contract changes are additive and backwards-compatible: the new `context_usage` and `compaction_event` events use event types already defined in `harness/schemas/session-log-schema.md` (lines 28-29); `blocked_items` and its entry shape already exist in `harness/schemas/current-state-schema.md` §Blocked-Item Queue (lines 22-42). The skill conforms to existing schema rather than redefining it.
- No shared infrastructure (hooks, scripts, always-loaded CLAUDE.md) is touched.

### Dimension 4: Reversibility
**Risk:** Low

- The structural change is a single-file edit to a tracked file (`SKILL.md`). `git checkout` / `git revert` of that one path fully restores the prior B1 skeleton — there is no sibling file, no new directory, no generated artifact.
- The change creates no runtime state. It edits skill *documentation/instructions*; it does not itself run the governor, so no `current-state.json`, `session-log.json`, or `learnings.json` data is mutated by landing the edit.
- Nothing is pushed beyond the local repo and no external write occurs (change description: "no new files, no new commands, no permission changes, no hook edits"). The change is not yet committed (`git status` shows it as a working-tree modification), so even pre-commit reversal is a clean discard.
- No automation (hook, cron, symlink) is added that could fire between landing and a potential revert.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Schema-vs-skill divergence (the one Medium item).** The edit adds an `attention_budget` object — `{ "max_interruptions", "escalations_used" }` — to the `current-state.json` shape documented inside the skill (SKILL.md lines 174, 465-474). `grep -rn "attention_budget\|max_interruptions" harness/schemas` confirms the field appears in **no** schema file as a `current-state.json` field — `current-state-schema.md` does not mention it, and `max_interruptions` appears in `mandate-history-schema.md` only as an excluded mandate field. The governor is the sole writer of `current-state.json`, so a write will not break at runtime, but two artifacts now describe the same file's shape and disagree. The skill discloses this honestly in-file (lines 185-189: "syncing `current-state-schema.md` to mention `attention_budget` is a tracked follow-up") — disclosure plus a documented sole-writer invariant keeps this at Medium rather than High, but the divergence is real until the follow-up lands.
- **Rehydration four-file vs. three-file contract — documented, not hidden.** Phase C step 3 re-reads four files (`mandate.json`, `current-state.json`, `hardening-registry.json`, `workflow-config.yaml`) while `harness-rules.md` §Compaction preservation instructions names only three. `grep` of `harness-rules.md` confirms the three-file `/compact` instruction text (line 79+). The skill resolves this explicitly with an in-file "Rehydration set — note" (SKILL.md lines 535-542) explaining the three-file text is a deliberate subset. Because the discrepancy is named at the change site and reconciled against `project-plan-v3.md` §6 Phase 3 item 6, this is documented coupling, not hidden — it does not by itself raise the dimension.
- No silent auto-firing: the skill is invoked once per session by an explicit handoff, not by a hook or event trigger. The `PreCompact`/`PostCompact` hooks it references are explicitly stated to be observability-only and not control-driving (SKILL.md lines 520-522), consistent with `harness-rules.md` hard rule 6 — no functional overlap is introduced.
- The retained `STUB [B2]:` token at Phase D is a deliberate, documented naming choice (the token reads `[B2]` but the work is Phase 4) — flagged in both the marker-family legend (line 52) and the Stub Marker Index (line 609), so a future `grep "STUB \["` reader is not misled.

## Mitigations

- **Dimension 5 (Medium):** Before or immediately alongside committing, open a tracked follow-up to add the `attention_budget` object (`max_interruptions`, `escalations_used`) to `harness/schemas/current-state-schema.md` so the canonical schema and the skill agree on the `current-state.json` shape. The skill already records this as a follow-up in-file (lines 185-189); the mitigation is to make that follow-up an explicit logged work item (e.g., a `blocked_items`-style entry in the session plan or a Phase 4 schema-sync task) rather than relying on the in-file prose note alone, so it is not lost. Until it lands, the sole-writer invariant (governor is the only writer of `current-state.json`) is what prevents the divergence from causing a runtime failure — preserve that invariant.

## Recommended redesign

(Not applicable — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references in `.claude/skills/session-governor/SKILL.md`, `harness/schemas/current-state-schema.md`, `harness/schemas/session-log-schema.md`, `.claude/references/harness-rules.md`; `git diff --stat` and `git status --short` output; `grep -rl`/`grep -rn` counts for `session-governor`, `attention_budget`, and `max_interruptions`; verbatim quotes from CHANGE_DESCRIPTION and the edited file). No training-data fallback was used on fetch/read failures.
