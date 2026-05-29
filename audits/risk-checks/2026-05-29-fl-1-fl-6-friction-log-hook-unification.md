# Risk Check — 2026-05-29

## Change

Item 1 from logs/session-plan-S5.md: FL-1+FL-6 friction-log hook unification. Edits planned:
(a) rewrite `.claude/hooks/friction-log-auto.sh` lines 41-46 to emit the canonical `## Session — {YYYY-MM-DD HH:MM}` + `### Friction Events` + `#### Write Activity` block (drop the current `### Session: $NOW — Trigger: /$SKILL_NAME` three-hash colon shape).
(b) correct the false byte-identical claim in `.claude/commands/note.md:16`.
(c) verify `.claude/commands/friction-log.md` Step 2 and `note.md` Step A.2 align with the canonical block.
(d) FL-6: document the `friction-log: true` frontmatter convention in `docs/session-guardrails.md` (or new short doc) so future command authors know it exists.

Source memo: `audits/pipeline-reviews/friction-log-2026-05-29.md`. The memo classifies this as a structural change class per `risk-topology.md § 3` (hook edit + cross-cutting two-end contract repair). End-time `/risk-check` is also required post-edit; THIS invocation is the plan-time gate only.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/friction-log-auto.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/note.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friction-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-guardrails.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/pipeline-reviews/friction-log-2026-05-29.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A small, well-scoped contract-repair change with one High dimension (blast radius — five+ writer/consumer surfaces must stay in lockstep) that has a viable paired mitigation (sequence the hook edit last and self-verify via the dedup grep). All other dimensions are Low or Medium.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Hook is `PreToolUse` matcher=Skill — fires per Skill tool invocation, but fast-exits at line 17 (`grep -q 'friction-log: true' "$CMD_FILE" || exit 0`) for any command without the frontmatter flag. The body-rewrite (lines 41–46) only runs on the slow path; per-invocation cost is dominated by the 3 grep/test/exit lines that already run pre-change. No new per-turn cost.
- The rewrite swaps one `echo "### Session: $NOW — Trigger: /$SKILL_NAME"` line for `echo "## Session — $NOW"` — a net wash in bytes emitted at runtime.
- FL-6 docs edit lands in `docs/session-guardrails.md` (per CHANGE_DESCRIPTION sub-item d). That doc is **not** auto-loaded — workspace CLAUDE.md line "Full trigger enumeration … `ai-resources/docs/session-guardrails.md`" treats it as a deep-reference, loaded on demand. Per-turn token cost: none. Per-load cost on the (rare) read: ~50–150 tokens for a short convention block.
- The `note.md:16` claim correction is a wording fix inside a slash-command body (pay-as-used, not auto-loaded). Frontmatter `disable-model-invocation: true` on `friction-log.md` (line 4) further restricts its load context.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `.claude/settings*.json` edits in scope per CHANGE_DESCRIPTION. The hook is already registered (multiple audits confirm: `repo-due-diligence-2026-05-08-ai-resources.md:84`, `token-audit-2026-05-25-ai-resources.md:149`).
- No new Bash patterns, no new Write paths, no new tool family. Hook continues to read `tool_input.skill`, the command file, and write to `logs/friction-log.md` — same surfaces as today.
- No deny rules removed or weakened.

### Dimension 3: Blast Radius
**Risk:** High

Enumerated writers and consumers touching the canonical session-header pattern:

- **Writers (3):**
  - `.claude/hooks/friction-log-auto.sh:43` — emits old shape `### Session: $NOW — Trigger: /$SKILL_NAME` (file under edit).
  - `.claude/commands/friction-log.md:25` — emits `## Session — {YYYY-MM-DD HH:MM}` (canonical).
  - `.claude/commands/note.md:18` — emits `## Session — {YYYY-MM-DD HH:MM}` (canonical).

- **Consumers / parsers (≥5):**
  - `.claude/agents/fix-repo-issues-scanner.md:64` — parses "the nearest `## Session — YYYY-MM-DD` header above the entry" to compute `age_days`. **Fourth consumer not named in the CHANGE_DESCRIPTION's "two consumers" framing.** Today it would silently fail on any hook-written block (zero such blocks exist in live log — see below — but the dependency is there).
  - `.claude/commands/open-items.md:35` — condition (d) of the cross-match parser names `## Session — YYYY-MM-DD` literally as the date-bound outer guard.
  - `.claude/commands/friday-checkup.md` Step 313 (per source memo) — friction-log-dormancy scan keys on `### YYYY-MM-DD` / `## YYYY-MM-DD` date prefix; passes loosely today but the source memo flags it advisory.
  - **Internal dedup grep inside the hook itself**, line 21: `grep -n "^### Session:" "$FRICTION_LOG"`. **This grep is co-tied to the old shape and MUST be updated in the same commit** — otherwise post-change the dedup window detects zero prior sessions and the hook re-appends on every invocation within 30 min. The CHANGE_DESCRIPTION names lines 41–46 only; line 21 is the silent partner. Evidence: `friction-log-auto.sh:21` `LAST_SESSION=$(grep -n "^### Session:" "$FRICTION_LOG" | tail -1 | cut -d: -f1)`.
  - `note.md:16` contract assertion — the false byte-identical claim is itself a downstream documentation consumer of the writer contract.

- **Live data state:** `grep "### Session:" logs/friction-log.md` returns zero matches; every session block in the live log uses `## Session —` (lines 3, 12, 21, 35, 43, 53, 65, 73, 82). This means **no data migration is required** in the canonical repo's live log — the hook has never successfully landed an entry under the old shape (likely because it was gated by frontmatter that only `cleanup-worktree.md` carried until recently). Risk is forward-looking, not backward.

- **Workflow sibling (out of scope but worth noting):** `workflows/research-workflow/.claude/hooks/friction-log-auto.sh:43` and `workflows/research-workflow/.claude/commands/note.md:16` carry the same shapes. The CHANGE_DESCRIPTION does not include them, so they will drift out of sync with the canonical hook after this edit. Not a blocker (sibling repos manage their own copies via graduate/deploy), but flag for awareness.

Verdict basis: 3 writers + 5 named consumer surfaces = 8 surfaces, with **one hidden in-file partner (line 21 grep)** that the CHANGE_DESCRIPTION does not name. Contract change is backwards-incompatible at the literal-string level. Pushes blast radius to High.

### Dimension 4: Reversibility
**Risk:** Low

- All four edit sites (`friction-log-auto.sh`, `note.md`, `friction-log.md`, `session-guardrails.md`) are single-file edits in a small bash script and three markdown files, all tracked in git. `git revert` of the landing commit fully restores prior state.
- No log mutation is on the path: the live `logs/friction-log.md` already contains only canonical `## Session —` entries (verified by grep — zero `### Session:` matches), so the change does not migrate or rewrite log data. Revert does not leave orphan log entries.
- No external state propagation in scope: no `git push` until session end (per workspace push-gating rule); no Notion write; no API call.
- No new automation registered (the hook is already in `settings.json`; this is a body edit).
- One mild caveat: operator muscle memory after FL-6 documents the `friction-log: true` flag — but the flag pre-exists the change and the docs edit only describes it. No new behavior to unlearn.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Co-tied dedup grep (line 21).** Most consequential implicit dependency: the hook's own dedup logic at line 21 (`grep -n "^### Session:"`) is bound to the *old* header literal. Changing lines 41–46 without updating line 21 leaves the dedup window broken — the hook would re-append every 30 min instead of deduplicating against its own prior writes. The CHANGE_DESCRIPTION specifies "lines 41-46" only; line 21 must be lifted into scope as part of (a). Documented at the change site only if the implementer reads the full script. This is the single highest-risk implicit coupling in this change.
- **Fourth consumer not named in the brief.** `.claude/agents/fix-repo-issues-scanner.md:64` parses `## Session — YYYY-MM-DD` to compute friction-log entry age. After the change, hook-written entries will (newly) be visible to this parser — which is the intended outcome. But the parser was not named in the CHANGE_DESCRIPTION's "four downstream consumers" list (which named `/friday-checkup`, `/open-items`, `/friction-log`, `/note`). Mild but worth surfacing.
- **`note.md:16` claim correction has no cascading documentation impact.** Grep across the repo finds no other file that quotes or references the "byte-identical" assertion — it is a single-site claim. Logs document the history (e.g., `session-notes-archive-2026-05.md:2623`: "claimed byte-identity with the `friction-log-auto.sh` hook, but the hook adds a `**Trigger:**` line; reworded to 'detection-compatible'"), but those are historical records, not live contracts. Correcting line 16 is a self-contained edit with no transitive doc obligations.
- **Workflow-sibling drift.** As noted above, the workflows/research-workflow copy of the hook + note.md retains the old shape. This is sibling, not transitive — but if a future graduate pass uses the workflow copy as a source-of-truth diff target, the canonical change would surface as drift. Mark for awareness, not blocking.
- **`friction-log: true` frontmatter convention.** FL-6 promotes an existing convention from de facto to documented. The flag is already wired (line 17 of the hook reads it); the docs edit clarifies intent. No new contract is invented — this is a documentation-of-existing-state change.

## Mitigations

- **Dimension 3 (High) + Dimension 5 (line 21 co-tie):** Expand sub-edit (a) to cover **both** lines 21 and 41–46 in one commit. After the rewrite, line 21's grep pattern MUST be `grep -n "^## Session —"` (matching the new emitted shape). Self-verification: after the edit, run a single Skill-tool invocation against a command carrying `friction-log: true` (e.g., one of the research-workflow pipeline commands), then re-run within 30 min and confirm the dedup-skip branch fires (exits without appending a second block). Without this verification, the hook can silently regress to per-invocation appending.

- **Dimension 3 (High) — multi-surface consistency check:** Before declaring the change shipped, run a single grep across `.claude/commands/`, `.claude/agents/`, and `.claude/hooks/` for both the old literal `### Session:` and the new literal `## Session —`, and confirm: zero old-shape references remain in canonical paths (workflows/ is out of scope); every consumer parsing the session header parses the new shape only. The fix-repo-issues-scanner agent (line 64) and open-items.md (line 35) already use the new shape, so no further edits are required there — the grep is verification, not refactor scope.

- **Dimension 5 (Medium) — note.md:16 wording fix:** Drop the verbatim word "byte-identical" and replace with a factual description of the post-change state. After unification, the three writers genuinely write the same canonical block, so wording can return to a true byte-identity claim — but only after lines 41–46 land. If the hook edit and the note.md edit are staged in separate commits, land the hook edit first; otherwise the note.md correction will briefly contradict itself.

## Recommended redesign

(Omitted — verdict is PROCEED-WITH-CAUTION.)

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references for all five referenced files, grep counts for `### Session:` (0 matches in live log) and `## Session —` (9 matches across writer commands + agent + log), and verbatim quotes from CHANGE_DESCRIPTION, `friction-log-auto.sh:21,43`, `note.md:16,18`, `friction-log.md:25`, `fix-repo-issues-scanner.md:64`, `open-items.md:35`, and the source pipeline-review memo. No training-data fallback was used.

## Architectural Commentary

_System-owner second opinion (Function B — pre-change advisory), invoked automatically because the verdict is PROCEED-WITH-CAUTION. The canonical `/consult` slash command is not surfaced as a Skill in this session's harness skill list; the system-owner agent was invoked directly via the Agent tool, equivalent to /consult's Function B path._

**Routing position.** Change lands in the canonical paths the architecture map specifies: hook → `ai-resources/.claude/hooks/`, command bodies → `ai-resources/.claude/commands/`, convention doc → `ai-resources/docs/session-guardrails.md` (deep-reference, load-on-demand). No routing correction required.

**Architectural commentary.** The change is a two-end contract repair, which is exactly the failure mode `risk-topology.md § 5` names as a structural-risk elevator. The reviewer's PROCEED-WITH-CAUTION is the correct verdict shape (hook edit class per `risk-topology.md § 3` requires plan-time + end-time `/risk-check`). The line-21 finding is the right thing to elevate: a co-tied dedup grep is the canonical "hidden in-file partner" pattern. **Concur with verdict; concur with all three mitigations.**

**Five named questions:**

1. **Cross-resource coupling beyond the four named consumers.** One additional consumer the original CHANGE_DESCRIPTION did not name: `.claude/agents/fix-repo-issues-scanner.md:64` parses `## Session — YYYY-MM-DD` to compute `age_days`. The risk-check report already names this in Dimension 3. **Latent fix observation:** the agent today silently fails on any hook-written block (zero such blocks exist in the live log, but the dependency is there). The unification fix closes this latent bug as a side benefit — worth naming in the commit message. No additional fix scope. `/improve` (`improve.md:9`) keys on `### Friction Events`, not on the session-header shape — invariant under the change.
2. **Documentation cascade from `note.md:16`.** No cascade. Direct grep across the repo for the "byte-identical" assertion returns no other live consumers — only historical session-notes archive entries. Correcting `note.md:16` is self-contained.
3. **The 30-minute dedup window — load-bearing?** No. `DEDUP_MINUTES=30` is a private heuristic inside the hook; grep across the workspace finds no consumer depending on the value. **Leave the 30-minute window alone in this change.** Re-tuning is a separate question waiting for a friction signal that the window is wrong.
4. **FL-6 docs scope.** `session-guardrails.md` is the correct home for v1. The `friction-log: true` flag is a session-side behavioral signal, structurally adjacent to the four advisory flags the file already documents (`[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]`). Workspace CLAUDE.md already names this file as the canonical reference for related rules. Promote to a dedicated `docs/friction-log-discipline.md` only when a second drift signal appears.
5. **Sequencing risk landing FL-1+FL-6 before C-1+C-2.** No sequencing risk. The two items are independent at the contract level. The S5 session plan sequences them correctly (Stage 1–2 = FL-1+FL-6, Stage 3–4 = C-1+C-2), each gated by its own plan-time `/risk-check`. No structural reason to re-order or split sessions.

**One risk the dimension review did not explicitly surface (additive observation, not a verdict change).** `fix-repo-issues-scanner.md:64` keys on the NEW shape and is therefore presently silently broken for hook-written entries — today invisible because no hook-written entries land in the live log, but the moment another command earns the `friction-log: true` flag mid-cycle, `fix-repo-issues-scanner` would age such entries as unknown and `/fix-repo-issues` plans would rank incorrectly. The unification fix closes this latent bug. Worth naming in the commit message so future-Claude reads the intent correctly.

**Position.** Ship FL-1+FL-6 in one commit with all three reviewer mitigations applied, expanded sub-edit (a) covering both line 21 and lines 41–46, with the two-invocation dedup self-verification test mandatory before end-time `/risk-check`. Concur with PROCEED-WITH-CAUTION. The verdict is sized correctly to the contract change; the High blast-radius dimension is real and the mitigation set neutralizes it. No verdict change recommended.
