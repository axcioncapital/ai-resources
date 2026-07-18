# Risk Check — 2026-07-18

## Change

Add a caller-declared post-plan gate token `{gate:post-plan}` so `/session-plan` Step 8 stops auto-executing when invoked from `/prime` 8a (numbered-menu task selection), while continuing to auto-execute for every other caller.

The full design spec IS the change under review — read it first:
/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/gate-token-design-2026-07-18-S7-bb5.md

Four files to be edited:
1. .claude/commands/prime.md — Step 8a.b passes `{gate:post-plan}` in the args to /session-start.
2. .claude/commands/session-start.md — Step 1 generalizes the existing `{mission:<id>}` prefix parse to strip leading `{key:value}` tokens in a loop and capture POST_PLAN_GATE; Step 4 forwards the token to /session-plan; the line-380 "Chained-mode contract" sentence is rewritten because it carries a THIRD copy of the conflicting absolute (the source improvement-log entry names only two).
3. .claude/commands/session-plan.md — Step 1 strips the leading token before INTENT is set (otherwise the token pollutes the plan's Intent line); Step 8's unconditional "do NOT pause for operator confirmation" becomes conditional on POST_PLAN_GATE.
4. projects/axcion-sector-intelligence/.claude/commands/session-plan.md — a real non-symlink copy, currently byte-identical to canonical, carrying the same defect at its own line 222. Operator-authorized scope growth beyond the mandate's declared ai-resources/.claude/commands/ boundary.

Source defect: logs/improvement-log.md, 2026-07-18 entry titled "`/prime` 8a.d and `/session-plan` Step 8 give opposite instructions at the same moment, and the auto-execute reading arrives last" — severity medium-high. That entry explicitly FORBIDS one fix route: removing or weakening /prime 8a's pause. It rates caller-awareness in session-plan.md as preferred over a caller-side override in prime.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/gate-token-design-2026-07-18-S7-bb5.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/commands/session-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The defect is real and precisely as cited (all three conflicting sentences verified at their exact line numbers, no fourth found), the fix is narrowly scoped and backward-compatible for every non-`/prime`-8a caller, and the blast radius is fully accounted for (no orphaned consumer) — but the design document's own edit-table understates what "Step 1" must touch in `session-plan.md` (a genuine order-of-operations gap versus the file's actual Step 0/Step 1 split), and the feared consequence (unapproved auto-execution actually happening) has been avoided, not reproduced, in the one live encounter on record.

## Consumer Inventory

Search basis: basenames `prime.md`, `session-start.md`, `session-plan.md`; contract markers `{gate:post-plan}`, `POST_PLAN_GATE`, and the precedent token `{mission:<id>}`. Searched `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `skills/`, `workflows/`, `docs/`, and the workspace root (`find . -path "*/.claude/commands/{prime,session-start,session-plan}.md"` plus `grep -rniI`), with a `[ -L ]` symlink test per path (not `[ -f ]`, which cannot distinguish a symlink from a real file).

| Consumer path | Reference type | Must change? |
|---|---|---|
| `ai-resources/.claude/commands/prime.md` (canonical) | co-edits (token producer) | yes |
| `ai-resources/.claude/commands/session-start.md` (canonical) | co-edits (token relay: strips, captures, re-forwards) | yes |
| `ai-resources/.claude/commands/session-plan.md` (canonical) | co-edits (token consumer, gates Step 8) | yes |
| `projects/axcion-sector-intelligence/.claude/commands/session-plan.md` (real, non-symlink copy — verified byte-identical via `diff`, same defect confirmed at its own line 222) | co-edits (drift-parity copy) | yes |
| 24 symlinks to `prime.md` (workspace-root `.claude/`, `harness/`, `archive/nordic-pe-macro-landscape-H1-2026/`, `knowledge-bases/pe-kb-vault/`, and 21 `projects/*/`, e.g. `projects/strategic-os/.claude/commands/prime.md`) | invokes (transparent passthrough) | no — auto-inherit the fix via symlink resolution |
| 24 symlinks to `session-start.md` (same location set, **100% symlinked except canonical** — no other real fork exists) | invokes (transparent passthrough) | no — auto-inherit |
| 25 symlinks to `session-plan.md` (same location set plus `ai-resources/workflows/research-workflow/.claude/commands/session-plan.md`) | invokes (transparent passthrough) | no — auto-inherit |
| `ai-resources/workflows/research-workflow/.claude/commands/prime.md` (real, non-symlink — read in full) | **verified NOT a consumer** — a pre-numbered-menu legacy stub ("Do NOT execute any pipeline command. Wait for operator direction.") that never invokes `/session-start` or `/session-plan` | no |
| `projects/axcion-sector-intelligence/.claude/commands/prime.md` (real, non-symlink — read in full; byte-identical to the research-workflow stub above) | **verified NOT a consumer** — same legacy stub, no 8a/8b/8c chain logic exists here | no |
| `.claude/commands/drift-check.md`, `contract-check.md`, `wrap-session.md`, `open-items.md`, `concurrent-session-check.md` | parses (the `session-plan-*.md` output file's schema and the mandate-line bullets — unchanged by this edit; Step 8's prose is not part of any parse contract, confirmed by grep) | no |
| `docs/session-marker.md` | documents (registers `session-plan.md` Step 0 header-gate and Step 7 plan-write in the marker-contract registry; Step 8 is out of that contract) | no |

**Total: 85 consumers inventoried (4 co-edit + 73 symlink + 2 confirmed-non-consumer forks + 6 downstream readers), 4 must-change — all four are already in the change's own edit list. No orphaned consumer requiring an edit was found.**

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- All four edited files are slash commands loaded only when explicitly invoked (or chain-invoked as part of an already-existing chain) — not an always-loaded CLAUDE.md, not a PreToolUse/SessionStart hook, not a broadly-matching skill description.
- The added logic (a token-strip loop plus one conditional branch) is a few lines per file, comparable in size to the existing `{mission:<id>}` precedent already present at `session-start.md:85` — an established, already-paid cost pattern, not a new category of overhead.
- No `@import` chain is added.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched. No new Bash pattern, Write path, or external API introduced.
- All edits are `Edit`-tool prose changes to markdown command files already writable under existing permissions.

### Dimension 3: Blast Radius
**Risk:** Medium

- Per the Step 1.5 inventory: 4 files must change (all already in the design's own edit list); 73 symlinked consumers auto-inherit with zero required edits; 2 independent forks were checked and confirmed NOT to be consumers at all (read in full — both are pre-numbered-menu legacy stubs that never chain into `/session-start` or `/session-plan`). No orphaned must-change consumer was found.
- The files touched (`prime.md`, `session-start.md`, `session-plan.md`) are shared session-lifecycle infrastructure invoked at the start of nearly every session across every project workspace via symlink — this is why the rating is not Low despite zero orphaned consumers.
- The change is a contract addition, not a contract break: the caller walk-through (design §5) plus my own trace of `prime.md` 8a/8b/8c confirm the token is opt-in and every non-8a caller path (8b free-text at `prime.md:518`, 8c which never invokes the command at `prime.md:729`, direct `/session-start` or `/session-plan` invocation) receives no token and is provably unaffected — this backward-compatible framing is why the rating is Medium rather than High (per the rubric's "Medium — a contract change that is backwards-compatible").

### Dimension 4: Reversibility
**Risk:** Low

- Four existing-file prose edits; no new files, no log mutations (`session-notes.md`, `improvement-log.md` etc. untouched), no external pushes.
- `git revert` of the landing commit(s) fully restores prior state with no manual cleanup step.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Positive finding — reused, proven pattern.** The `{gate:post-plan}` token reuses the exact mechanism already shipped for `{mission:<id>}` (confirmed via grep: `session-start.md:85`, `prime.md:306/486/487/517/518` — 6 live occurrences). The "strip leading `{key:value}` tokens in a loop" generalization is licensed by this being its *second* confirmed use, not a speculative first one.
- **Positive finding — no naming collision.** Grepped the whole command/doc/skill set for `{gate:` and `POST_PLAN_GATE` — zero pre-existing hits. Clean namespace.
- **Positive finding — no downstream text-parser dependency on Step 8's wording.** Grepped for "declared autonomy posture", "pause for operator confirmation", and "further confirmation" across `.claude/commands`, `.claude/agents`, `docs`, `skills`, `workflows` — the only hits are the three sentences the design itself cites (`prime.md:489–492`, `session-plan.md:222`, `session-start.md:380`). No fourth copy exists (re-derivation confirms the design's own claim that it found a third the source log entry missed, and that a fourth is not present). Rewriting `session-start.md:380`'s prose therefore breaks nothing else.
- **The Medium-driving finding — a real order-of-operations gap in `session-plan.md` that the design's edit-table does not fully account for.** The design table (§4) attributes the token-strip edit to "Step 1" only. But tracing the actual file: **`session-plan.md` Step 0** (not Step 1) is where `$ARGUMENTS` is first consumed — it computes `UPCOMING_INTENT = $ARGUMENTS verbatim` whenever `$ARGUMENTS` is non-empty. **Step 1**'s own "cache shortcut" then runs `INTENT = UPCOMING_INTENT` (reusing Step 0's already-computed, unstripped value) *before* any new Step-1-only stripping logic would fire. Unlike `session-start.md` (which has no earlier `$ARGUMENTS` consumer before its own Step 1 — confirmed by reading Steps 0 and 0.5, neither of which touches `$ARGUMENTS`), `session-plan.md` has no prior internal precedent for token-stripping to model this edit on, since only `session-start.md` currently handles `{mission:<id>}`. If the edit is implemented literally as scoped ("Step 1 strips the leading token"), without also touching Step 0's `UPCOMING_INTENT` computation (or having Step 1 re-derive `INTENT` from a freshly-stripped copy rather than reusing the cached value), the token will leak into the written plan's `## Intent` line on the **patched** checkout too — not only on a stale one, as the design's own degradation analysis (§6) implies. This does not cause a stuck session or break the actual Step 8 gate (which can be set independently by having Step 1 examine raw `$ARGUMENTS` directly for `POST_PLAN_GATE`) — it is a cosmetic-pollution risk, but a concrete and verifiable one, and it is exactly the kind of implementation-completeness gap a risk-check should surface before the edit is written.
- No functional overlap with an existing mechanism, and no silent auto-firing in an unexpected context — the change fires only inside the already-existing, already-encountered chain.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read: `projects/strategic-os/ai-strategy/principles-base.md` (present, read in full).

- **OP-9 / DR-7 / AP-7 (speculative abstraction) — not violated.** The `{gate:post-plan}` contract has exactly one current, real consumer (`/prime` 8a), fixing an already-verified live defect — not infrastructure for an absent future consumer. The generalization of the *parsing mechanism itself* (loop-stripping leading tokens, rather than a single hardcoded prefix check) is licensed by a genuine second confirmed use case (`{mission:<id>}` is the first, `{gate:post-plan}` is the second) — this satisfies rather than violates DR-7's "generalize only on a second confirmed consumer" bar.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7)** — not triggered. No new command, agent, mandatory stage, or always-loaded doc is created; this is a targeted edit to existing infrastructure.
- **OP-10 (system boundary)** — not touched; no cross-tool coordination involved.
- **OP-12 (closure before detection)** — not touched; no new detection/audit mechanism is added.
- **OP-5 (advisory vs. enforcement)** — not touched; the Step 8 gate remains an advisory pause (operator can still say `go`), matching the existing `8a.d` pause it is designed to restore, not a new auto-correcting enforcement layer.
- **OP-2 (automate execution, gate judgment)** — the change actively serves this principle: it restores an operator-approval gate specifically at the one judgment-laden juncture (menu-pick task selection, where the operator has not yet stated the work) while leaving every execution-only path (8b free-text, direct invocation) auto-approved. This is the correct shape, not a drift toward over-gating or under-gating.
- **OP-11 / OP-3 (loud revision vs. silent drift)** — no principle is being revised; both `prime.md:489–492` and `prime.md:520` already document the pause as *intentional*, so this is a bug fix restoring already-stated intent, not a policy change.
- **DR-1 / DR-3 (placement)** — the sector-intelligence copy edit is explicit, disclosed scope growth beyond the mandate's own stated `ai-resources/.claude/commands/` boundary. The design document names this openly (§4, §8) rather than applying it silently, which is the procedural form OP-11's "loud, not silent" bar asks for. **Caveat:** I can verify the disclosure is loud *in this document*, which is what the risk-check gate exists to catch before commit; I have no independent way to confirm a prior verbal operator authorization occurred before this document was written — recommend the operator confirm this authorization is also captured in `logs/decisions.md` or the session note, not only in the working design file.

### Dimension 7: Problem Reality
**Risk:** Medium

- **Defect — observed, not merely asserted.** I independently re-read all three cited files at the cited lines and confirm the quotes verbatim:
  - `prime.md:489–492` — "**Pause.** ... Wait for the operator. Do NOT begin execution on your own." — confirmed present exactly as quoted.
  - `session-plan.md:222` — "Do NOT emit a `/qc-pass` handoff and do NOT pause for operator confirmation. The session begins under the declared autonomy posture immediately. ... Everything else flows through." — confirmed present exactly as quoted.
  - `session-start.md:380` — "**Chained-mode contract:** ... Everything else runs through to the plan write and the session begins under the declared autonomy posture without further confirmation." — confirmed present exactly as quoted.
  - I ran an independent grep sweep (`"declared autonomy posture"`, `"pause for operator confirmation"`, `"further confirmation"`, `"Everything else"`) across `.claude/commands`, `.claude/agents`, `docs`, `skills`, `workflows` looking for a fourth copy of the same conflicting absolute. **None found** — exactly three, matching the design's own claim (which itself corrected the source improvement-log entry, which had named only two).
  - `prime.md:520` independently confirms the pause is deliberate design, not oversight: "This is 8b's structural delta vs 8a, which pauses for explicit `go` after `/session-plan`."
- **Consequence — inferred, not traced.** The improvement-log entry's own **Status** line states the conflict was "encountered live by S1-1e0 (axcion-content-programme, W1.1); resolved in-session in favour of `/prime`, surfaced to the operator rather than resolved silently," and its own **Severity** rationale states plainly: **"No harm occurred this session because the conflict was noticed; the concern is that noticing it is not the default path."** In other words: the one real, observed occurrence of this conflict did **not** produce the feared consequence (unapproved auto-execution) — the session correctly caught it and paused anyway. The feared failure mode (a future session following the more-recently-loaded instruction and executing without approval) is a plausible, reasoned risk based on recency bias, but it has not been reproduced or traced to an actual incident. This is exactly the "consequence inferred, not traced" case the framework asks to be called out plainly, because it is what the source entry's "medium-high" severity rating is actually resting on.
- **Re-derivation vs. the change description:** None of the counts, paths, or quoted lines in `CHANGE_DESCRIPTION` were contradicted by my own re-derivation — the 27-path / 25-symlink / 2-real figure for `session-plan.md`, the four caller classes, the three (not four) conflicting sentences, and the byte-identical sector-intelligence copy were all independently confirmed via `find` + `[ -L ]` tests, `diff`, and direct file reads. The one discrepancy I found is not a factual contradiction but a completeness gap in the design's own implementation scoping (see Dimension 5) and the consequence-tracing gap above (defect real; feared consequence unreproduced).
- The degradation claim (§6 of the design) — "token text pollutes the Intent line, no gate applied" on a stale checkout — is verified accurate for a genuinely stale (unpatched) checkout by tracing the current, unedited `session-plan.md` Step 0/Step 1 logic. It is *not* verified accurate as a description of what distinguishes "stale" from "patched," given the Dimension 5 finding above — the same pollution risk can occur on the patched checkout too if the edit is scoped exactly as written.

## Mitigations

- **Dimension 5 (Hidden Coupling):** Before writing the `session-plan.md` edit, extend its scope explicitly to Step 0: strip the leading `{key:value}` token(s) at the point where `UPCOMING_INTENT` is computed from raw `$ARGUMENTS` (or have Step 1's cache-shortcut branch re-derive `INTENT` from a freshly-stripped copy of `UPCOMING_INTENT` rather than reusing it verbatim). After implementation, verify with a dry trace: confirm the written plan's `## Intent` line does not contain `{gate:post-plan}` when `/prime` 8a is exercised end-to-end.
- **Dimension 3 (Blast Radius):** After implementation, spot-check one representative symlinked consumer (e.g. `projects/strategic-os/.claude/commands/session-plan.md`) to confirm it still resolves to the patched canonical file, and run one live `/prime` 8a dry run plus one `/prime` 8b dry run to confirm the pause fires only for 8a and 8b remains unaffected — this directly tests the "does the default-off behavior truly reproduce today's behavior" question this review raised.
- **Dimension 7 (Problem Reality):** Proceed with the fix — the underlying contradictory-instructions defect is fully verified and real — but do not cite this as an incident-driven fix in the commit message or session log; the one live encounter on record was caught and resolved with zero harm, so the urgency is architectural (a latent gate-skip risk), not a materialized failure.
- **Dimension 6 (Principle Alignment, minor):** Confirm the sector-intelligence copy's scope growth beyond the `ai-resources/.claude/commands/` boundary is also recorded in `logs/decisions.md` or the session note, not only in the working design file, so the "loud, not silent" bar is met durably rather than only within this one document.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
