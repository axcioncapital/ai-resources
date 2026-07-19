# Risk Check — 2026-07-19

## Change

Teach the PreToolUse staging tripwire `check-foreign-staging.sh` to ALSO read the mandate's `- Required outputs:` bullet when computing this session's declared footprint, alongside the `- Files in scope:` bullet it reads today.

PROBLEM (observed live, not inferred — axcion-content-programme improvement-log.md 2026-07-19, severity medium-high):
`/session-start` Step 2.5 check 3(b) HARD-REJECTS a not-yet-existing path from `files_in_scope` and routes it to `- Required outputs:`. A session followed that rule exactly (declaring roadmap/content-pillars.md and roadmap/article-roadmap.md under Required outputs). The guard reads `- Files in scope:` ONLY (hook line 354), so it BLOCKED the commit, reported both files as "OUTSIDE this session's declared footprint", and named the concurrent-session contamination pattern. Nothing was foreign; it was a solo session. The guard's own remediation text ("your declared footprint is too narrow") then pressures the operator toward widening `Files in scope` with not-yet-created files — precisely what Step 2.5(b) hard-rejects. Two rules in the same harness contradict each other, and the guard trains operators to violate the adjacent one.

AMENDED DESIGN (revised after pre-dispatch premise verification falsified the naive version — see CORRECTED PREMISES below):
1. In the marker-scoped header block read (hook L328-356), also capture `- Required outputs:` into `outputs_raw` alongside `footprint_raw`. Drop the early `break` so both bullets are seen. `in_block` already resets on any line starting `## `, so the scan cannot leak into another session's block.
2. Parse `outputs_raw` with a PER-TOKEN SHAPE FILTER: keep a token only if it looks like a path (contains `/`, OR ends in a known extension .md/.sh/.json/.yaml/.yml/.py/.ts/.js, OR is a bare CLAUDE.md/SKILL.md). Same ./-strip, repo-name-prefix-strip, backtick-strip, "("-skip as the existing parser. Prose tokens are DISCARDED, not appended.
3. footprint = (existing files_in_scope parse, BYTE-IDENTICAL to today) + (shape-filtered outputs tokens), de-duped, order preserved.
4. `no_concrete_footprint` REMAINS DRIVEN BY `footprint_raw` (files_in_scope) ALONE — its current string test at L369-375 is UNCHANGED. Required outputs may only WIDEN an already-ON guard; it can never switch the guard ON.
5. Update the BLOCK message text (L572-586) to name both fields.

The intended invariant: the change is MONOTONIC — it can only convert a BLOCK into a pass, never a pass into a BLOCK. Please verify that invariant actually holds against the code as written, and say so explicitly. If you find any path where the change could produce a block that does not occur today, that is the single most important finding you can return.

EXPLICITLY NOT CHANGED: the mandate schema/format (no writer anywhere changes); `- Allowed inputs:` stays excluded (read-only references, not written by the session); the exempt-list; the gated-verb regexes and heredoc/quote blanking; the marker grammar regex and its `(?![-\w])` terminator; the run-manifest `(?:-[A-Za-z0-9]{3})?` exemption; the glob fnmatch arm; the live-foreign-session process-grounding oracle; the P3 escalation split; fail-open-when-python3-absent.

=== CORRECTED PREMISES (verified by execution this session — the naive design was falsified) ===
- FALSIFIED: "Required outputs is a path list." It is NOT. `/session-start` Step 2.5 validates exactly four fields — work_scope, exit_condition, files_in_scope, stop_if. `required_outputs` receives NO validation of any kind. Verified on disk in axcion-content-programme/logs/session-notes.md: line 56 is pure prose ("settled article-research policy landed in a durable home", zero paths); line 114 is mixed prose + paths + a "(path settled at plan time)" parenthetical; lines 10 and 168 are clean path lists. All four shapes are legal today.
- Consequently the naive design (`no_concrete_footprint = not footprint`) WOULD have introduced a new false-block class: `Files in scope: (inferred)` + a prose `Required outputs` carrying one incidental path would flip the guard ON with a near-empty effective footprint, so every staged file reads foreign → hard BLOCK on a solo session. Amendments 2 and 4 above exist to remove that class. Confirm they fully remove it.
- VERIFIED TRUE: registered exactly once, user-level settings.json, absolute path, to the ai-resources/.claude/hooks/ copy. The two other copies have different checksums and are registered nowhere.
- VERIFIED TRUE: no hook or script other than this one greps `Files in scope`. Other mentions across ai-resources are audits/risk-check reports (historical records) and command docs.
- VERIFIED TRUE: python3 3.14.3 present, so the degrade-open path is not the live path.

=== DIMENSIONS TO SCORE WITH PARTICULAR CARE ===
1. Does reading an UNVALIDATED free-text field into a parser-consumed footprint create hidden coupling to a field nothing constrains? Note that the shape filter is the mitigation; judge whether it is sufficient, and whether this change creates pressure to later add validation to required_outputs (a second, larger change).
2. Does widening the footprint weaken the guard's actual purpose (catching a concurrent session's staged files)? Consider that a not-yet-created output is not a lost-update surface — session-start.md L286 makes exactly this argument in the guard's favour.
3. Verify the monotonicity invariant in item 4 above against the real control flow, including the `exempt_foreign` warn branch at L547-567 and the P3 escalation at L377-401.
4. Regression risk against the four documented silent-truncation defects in this file (marker grammar S7 vs S7-a4f, run-manifest suffix, glob fnmatch, heredoc blanking). The claim is the change touches none of them — confirm or refute by reading.
5. Blast radius on the two unregistered stale forks. My intent is to LEAVE THEM ALONE and note the divergence rather than sync three copies. Judge whether leaving them divergent is safe (they are dead code) or whether it is a latent hazard (someone could register one later, or a project could copy from the wrong source).
6. Problem reality: was the defect observed or inferred? Evidence is in the improvement-log entry and the S3-4e4 session-notes "Risky actions" section.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists (the ONLY registered copy; user-level settings.json line 60, absolute path)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.codex/hooks/check-foreign-staging.sh — exists, UNREGISTERED stale fork (md5 ffec5c86…, 23563 bytes, 2026-07-14)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-sector-intelligence/.claude/hooks/check-foreign-staging.sh — exists, UNREGISTERED stale fork (md5 a7d0362b…, 27259 bytes, 2026-07-15)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/session-start.md — exists (Step 2.5 defines the field contract)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/axcion-content-programme/logs/improvement-log.md — exists (the finding, dated 2026-07-19)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A well-designed, narrowly-scoped fix to an observed, live, reproducible defect — the monotonicity invariant holds under independent re-derivation of the full control flow, and the defect/consequence are both directly traced (not inferred) — but the design reads an unvalidated free-text field into a security-relevant parser and leaves one registered "two-end contract" doc unaddressed, which push two dimensions to Medium.

## Consumer Inventory

Search terms used: `check-foreign-staging` (basename/component), `- Files in scope:` and `- Required outputs:` (the two mandate-line contract markers the change reads). Grepped across `ai-resources/.claude`, `ai-resources/docs`, `ai-resources/skills`, `ai-resources/.codex`, all `settings*.json` layers (user/workspace/ai-resources/project), and the two named project checkouts.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `~/.claude/settings.json` (line 60, user-level, absolute path) | invokes | no |
| `ai-resources/.codex/hooks/check-foreign-staging.sh` | co-edits (stale fork, unregistered — confirmed absent from `ai-resources/.codex/hooks.json`) | no |
| `projects/axcion-sector-intelligence/.claude/hooks/check-foreign-staging.sh` | co-edits (stale fork, unregistered — confirmed absent from that project's `settings.json`/`settings.local.json`) | no |
| `ai-resources/docs/commit-discipline.md` § "Foreign-staging tripwire" | documents — this is the file the hook's own header comment names as the registered "two-end contract" | **yes** |
| `ai-resources/.claude/commands/session-start.md` (Step 2.5, writer of the field being newly read) | documents / schema owner | no (schema unchanged) |
| `ai-resources/.claude/commands/prime.md` (L691-710) | documents (parser-not-reader property, `Files in scope` only) | no |
| `ai-resources/docs/session-marker.md` | documents (adjacent marker/live-session mechanics) | no |
| `ai-resources/docs/daniel-concurrent-session-hooks-setup.md` | documents (external operator setup guide, describes behavior generally) | no |
| `ai-resources/docs/parallel-sessions-playbook.md` | documents (general role description) | no |
| `ai-resources/skills/handoff/SKILL.md` (L212) | documents (marker-teardown rationale, not footprint-field specifics) | no |
| `ai-resources/.claude/commands/wrap-session.md` (canonical, Step 7a) + workspace-root variant | parses (independent sibling reader of the same `- Files in scope:` mandate bullet, for coaching-data classification — untouched schema) | no |
| `ai-resources/.claude/commands/drift-check.md` (Step 5) | parses (same sibling class) | no |
| `ai-resources/.claude/commands/contract-check.md` (Step 2.5c) | parses (same sibling class) | no |
| `ai-resources/.claude/commands/concurrent-session-check.md` (Step 3) | parses (same sibling class, read-only) | no |
| `ai-resources/.claude/commands/monday-prep.md` | documents (writes a separate week-mandate; session-start.md's own parse-contract note confirms it does NOT consume this bullet schema) | no |

Total: 15 consumers found, 1 must-change (`commit-discipline.md`, a documentation-accuracy update, not a functional dependency). The direct change target is a single file (`ai-resources/.claude/hooks/check-foreign-staging.sh`); the mandate schema/field contract itself is explicitly unchanged by this design, so the 13 sibling/doc references remain accurate without modification. The two stale forks are unregistered dead code (verified — see Dimension 3 and 5).

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- The hook is a `PreToolUse(Bash)` guard that already runs on every gated-verb Bash call (`git commit`/`git add -wide`) — this is pre-existing cost, not new cost introduced by the change.
- The change adds one more bullet capture from a file read that is already open (session-notes.md), a bounded per-token shape-filter loop over `outputs_raw`, and a few extra words in the (rare) BLOCK stderr message. No new hook is registered, no `@import`, no new subagent, no SessionStart/PreToolUse-per-tool-call addition.
- Not an always-loaded file (CLAUDE.md) and not a broadly-triggering skill. Confirmed by direct read of the full 589-line hook — no new registration surface introduced.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entries touched. Confirmed: `grep "check-foreign-staging"` across every `settings*.json` in the repo tree and `~/.claude/settings.json` returns exactly one hit (the existing registration, unaffected by this change).
- No new Bash invocation pattern, Write path, or external API introduced — the change is confined to the hook's internal Python parsing logic.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer Inventory (Step 1.5): 15 references found across the repo, but only **1** requires modification (`ai-resources/docs/commit-discipline.md`, a documentation-accuracy fix — that file explicitly states today "reads the `- Files in scope:` bullet" and will be materially incomplete once the hook also reads `- Required outputs:`). The other 14 are either (a) two unregistered dead-code forks, (b) five independent sibling readers of the *same, unchanged* `- Files in scope:` mandate field for unrelated purposes (wrap-session x2, drift-check, contract-check, concurrent-session-check), or (c) documentation that describes the hook's role generally and is not made inaccurate by this specific change.
- The raw reference count (15) exceeds the ">5 dependent callers" heuristic threshold for High, but judgment is applied per the dimension's own "calibration point, not hard rule" instruction: the schema/contract itself is explicitly unchanged (CHANGE_DESCRIPTION: "no writer anywhere changes"), so 13 of the 14 non-must-change references stay correct without action. The high count reflects that this is well-documented shared infrastructure, not that the change destabilizes many callers.
- **Monotonicity invariant — verified against the full control flow (the single most important finding requested).** Traced all three branches reachable after `no_concrete_footprint` is False:
  - P3 escalation (L377-401): depends only on `no_concrete_footprint` (driven solely by `footprint_raw` / Files-in-scope, explicitly unchanged by design item 4) and `_live_foreign_session()` (unrelated to footprint content) — this branch's behavior is completely unaffected by the change.
  - `exempt_foreign` warn branch (L547-567): reachable only when `foreign` is already empty; this branch can only end in `sys.exit(0)` — it is structurally incapable of producing a BLOCK, before or after the change. Since footprint can only grow (a superset union, per design item 3), `exempt_foreign` can only shrink or stay the same — this warn fires less often, never more.
  - Hard BLOCK (L570-588): reached only when `foreign` (candidates not exempt and not in `footprint`) is non-empty. Because the post-change `footprint` list is a strict superset of the pre-change list (files_in_scope tokens + additional shape-filtered outputs tokens, both matched via the unmodified `in_footprint()`/`fnmatch` logic), `foreign` can only shrink or stay equal — never grow. **No path was found where the change converts a pass into a block.** The invariant holds.
- The one un-mitigated gap: leaving `commit-discipline.md` unaddressed creates a doc-drift window where the repo's own registered "two-end contract" description becomes stale immediately on landing. See Mitigations.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file code edit (plus, if the Dimension-3 mitigation is applied, one companion markdown-doc edit) to a script tracked in git. A `git revert` on the commit fully restores prior parsing behavior within the same working tree — no sibling files created, no data/log mutation, no state pushed beyond the local repo (and push itself is gated/batched per workspace convention regardless).
- No automation (hook/cron/symlink) is added that could fire between landing and a potential revert — this edits the *body* of an already-existing, already-registered hook; the registration itself is untouched.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Concern 1 (per CHANGE_DESCRIPTION's own flag) — reading an unvalidated field into a parser-consumed footprint.** Confirmed by direct read of `session-start.md` Step 2.5: `required_outputs` is one of two OPTIONAL fields (`allowed_inputs`, `required_outputs`) that receive **zero validation** — no shape test, no existence test, unlike the four mandatory fields (work_scope, exit_condition, files_in_scope, stop_if). The shape filter (design item 2) is a real, reasonable mitigation — it mirrors the existing files_in_scope sanitization (./-strip, repo-prefix-strip, backtick-strip) and discards non-path-shaped tokens per-token rather than failing the whole field open or closed. It is **not** a complete guarantee: a prose Required-outputs line that coincidentally contains a path-shaped substring (e.g., session-notes.md line 114's own on-disk text mixes prose with real paths and a parenthetical) will have that substring folded into the footprint. In the narrow case where a genuinely foreign concurrent session has staged a file whose name coincidentally collides with such a substring, the widened footprint would treat it as "in scope" and the guard would fail to flag it — a **narrowing of the guard's catch rate**, not a new false block. This is a real, if low-probability, coupling to a field the schema deliberately leaves unconstrained.
- **Concern 1b — pressure toward a second, larger change.** Once `required_outputs` becomes parser-consumed by a security-relevant guard, there is a plausible future push to add validation to it (mirroring the Step 2.5(b) hard-reject already applied to `files_in_scope`). The design as specified does **not** do this, and should not — that would be a separately-scoped, separately-justified change. Flagging this now so a future session does not treat it as implied scope.
- **Concern 2 — does widening weaken the guard's purpose?** CHANGE_DESCRIPTION cites `session-start.md` L286 in the design's favor; confirmed by direct read: *"...it also gives `check-foreign-staging.sh` a truer footprint: a not-yet-created output is not a lost-update surface."* This argument is sound for the **output path itself** (nothing else can be mid-editing a file that doesn't exist yet). It does not fully cover Concern 1 above, which is about incidental non-output path fragments riding along in the same prose field — a distinct, narrower risk the L286 argument does not address.
- **Doc-contract gap.** The design's item 5 updates the BLOCK message text but does not update `commit-discipline.md`, the file the hook's own header names as the registered two-end contract (see Dimension 3). Until updated, that doc's "Footprint source and fail-open" section will state an incomplete description of what the guard reads.
- No functional overlap with another mechanism (this is the sole reader of `Files in scope`/`Required outputs` among `.sh` hooks/scripts — confirmed: the only `.sh` file matching either grep term, across `ai-resources/.claude` and `ai-resources/docs`, is `check-foreign-staging.sh` itself), and no new auto-firing context is introduced (still the same PreToolUse gated-verb trigger).

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly; readable, no fallback needed).

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not applicable as a violation.** This is a bug fix responsive to an **observed, live** defect (a real commit was actually blocked in S3-4e4; not a hypothetical future consumer). The "complexity-budget gate" in `ai-resource-creation.md` rule #7 governs *new* commands/agents/gates/always-loaded docs; this change edits the body of an existing, already-registered hook — it is not a new component, so the gate's prong (a)/(b) test does not apply as a creation gate. The consumer of the widened contract (any session that creates files and correctly routes them to Required outputs per Step 2.5(b)) already exists today, per the improvement-log's own characterization ("fires on any session whose main work is creating files — which is most substantive sessions").
- **OP-12 (closure before detection) — the change is aligned, not counter to it.** This is not new detection added ahead of a closure channel; it *reduces* a documented false-positive in an existing detector, closing an internal contradiction between two harness rules (Step 2.5(b)'s routing rule and the guard's narrower read) rather than adding new detection surface.
- **OP-5 (advisory vs. enforcement) — unaffected.** The hook's authority model (exit 2 → agent-facing stderr, not an operator permission prompt; STOP-and-surface, not silent self-correction) is untouched by this change; it only affects which files are pre-classified as in-footprint before that authority model runs.
- **OP-10 (system boundary) — not touched.** No cross-tool coordination introduced.
- **DR-1 / DR-3 (placement) — correct.** The edit stays in the canonical home (`ai-resources/.claude/hooks/`); no tier/home change.
- **OP-11 (loud revision) — not triggered.** No principle is being revised; nothing to record as a deliberate exception.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not inferred.** Independently re-derived via direct reads, not inherited from the change description:
  - `check-foreign-staging.sh` line 354 (`if in_block and ln.lstrip().startswith("- Files in scope:"):`) is the only footprint-bullet read in the file; a full read of all 589 lines confirms the string `"Required outputs"` does not appear anywhere in the hook.
  - `session-start.md` lines 280-286 confirm the routing rule exactly as described: the existence-test hard-reject routes not-yet-existing paths from `files_in_scope` to `- Required outputs:`, and explicitly reasons that this "also gives `check-foreign-staging.sh` a truer footprint."
  - `axcion-content-programme/logs/session-notes.md` (S3-4e4, "Risky actions" section, lines 184-188) is a first-person record of the block **actually firing** in a live session: *"check-foreign-staging.sh stopped the W1.2/W1.3 commit because roadmap/content-pillars.md and roadmap/article-roadmap.md sat outside the session's declared Files in scope... the mandate had routed them to Required outputs, which the guard does not read."* This is a runtime event report, not a static-code inference.
  - `improvement-log.md` (2026-07-19 entry) independently corroborates the same event and states plainly: *"Observed, not inferred: blocked live this session."*
- **Consequence — traced, not assumed.** The claimed consequence (the guard's own remediation text pressures the operator toward widening `Files in scope` with not-yet-created paths, contradicting Step 2.5(b)) is directly traced in the same session record: *"the operator chose to widen the declared footprint... which is the honest resolution but leaves the underlying mismatch in place."* The current on-disk `session-notes.md` mandate line for S3-4e4 (line 165) already shows the widened `Files in scope` including the two roadmap files — consistent with the record of the post-hoc fix. This is an actual caller behavior, reproduced in the record, not a plausible-sounding hypothesis.
- **Re-derivation vs. the change description:** None material — every count, path, and quoted line independently re-checked and confirmed:
  - `session-notes.md` lines 56, 114, 10, 168 — all four re-read directly; content and shape (pure prose / mixed / clean path list / clean path list respectively) match exactly as claimed.
  - Hook registration — re-derived via `grep -n "check-foreign-staging" ~/.claude/settings.json` (one hit, line 60, exact path match) and via checking `ai-resources/.codex/hooks.json` (no entry) and the sector-intelligence project's `settings.json`/`settings.local.json` (no entries) directly — confirms "registered exactly once."
  - Checksums of the three copies — independently computed via `md5`: canonical `174d3ab6…`, `.codex` fork `ffec5c86…` (matches the description), sector-intelligence fork `a7d0362b…` (matches the description) — all three distinct, confirmed.
  - `python3 --version` run directly: `Python 3.14.3` — exact match.
  - One minor scope clarification (not a contradiction): "no hook or script other than this one greps `Files in scope`" is true narrowly for `.sh` files (independently confirmed — the only `.sh` match across `ai-resources/.claude` and `ai-resources/docs` is the hook itself), but five `.md`-defined **commands** (wrap-session, drift-check, contract-check, concurrent-session-check, and session-start as writer) also read the same field independently for unrelated purposes — see Consumer Inventory. This does not change the risk picture since the field/schema is unmodified by this change, but the claim is precise only under the "shell script" reading, not "anything that reads this field."

## Mitigations

- **Blast Radius (Medium):** In the same commit that lands the hook change, update `ai-resources/docs/commit-discipline.md` § "Foreign-staging tripwire" → "Footprint source and fail-open" to state that the guard now unions `- Files in scope:` with shape-filtered tokens from `- Required outputs:`, so the file's own registered "two-end contract" does not go stale on landing.
- **Hidden Coupling (Medium):** (a) Implement the shape-filter block with an explicit code comment stating that `required_outputs` is unvalidated free text and the filter is a best-effort mitigation, not a guarantee — documents the new contract at the change site. (b) Do not add validation to `required_outputs` in this same change; if that is later wanted, scope and justify it separately rather than treating it as implied by this fix. (c) Before relying on this in a live session, smoke-test the shape filter against a real prose-heavy Required-outputs line already on disk (e.g., the exact text at `session-notes.md` line 114) to confirm it discards the prose and captures only the genuine path tokens as intended.
- **Advisory, not required for landing:** the two stale forks (`.codex` and `axcion-sector-intelligence`) are confirmed dead code (unregistered in every checked settings/hooks-manifest location) and already diverged from canonical before this change (missing the 2026-07-14 marker-grammar/ANY-DATE fix and/or the 2026-07-18 process-grounding fix). Leaving them un-synced is safe today. Add a one-line header comment to each fork noting it is a known-divergent, unregistered copy that must not be used as a source for a future registration or project copy without reconciling against the canonical file first — cheap insurance against the latent hazard of someone registering or copying from the wrong source later.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
