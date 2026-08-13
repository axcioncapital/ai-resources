# Risk Check — 2026-07-29

## Change

End-time gate on the uncommitted /work-loop commit-3 + commit-5 change set in ai-resources, before it is committed locally. Two prior sessions on this same build WAIVED their end-time gate; the operator has explicitly directed that this one must run and must not be waived.

CHANGE SET (uncommitted, ai-resources), re-derived this session via `git diff --stat`:
- docs/work-loop.md (C1, the contract) — +59 lines
- .claude/commands/work-loop.md (C3, the executor slash command) — +115 lines
- plans/2026-07-28-work-loop-consolidated-build-plan.md — +15 lines
Total: 163 insertions, 26 deletions across 3 files.
NOT part of this set: logs/friction-log.md carries uncommitted lines but is PRE-EXISTING dirt from a session on 2026-07-25 and must not be staged.

WHAT COMMIT 3 + 5 DO. C3 gains live Step 5a (challenged route: Frame/Shape/Build/Prove/Land per-phase blocks, gates G1/G2/G3, "exactly three stops") and live Step 5b (capability-unit orchestration: opens projects/{p}/development/{slug}.md from templates/capability-record.md at Frame, writes stream:/active_unit: correlation, append-only ## Units table, cardinality, Land sets status:). Step 8 now writes into capability records — marks evidence Status: complete on every outcome, appends the ## Units row, clears active_unit: none, and sets status: paused with a reopen_trigger: if a stream stops before Land. C1 gains challenged-route gate definitions, a cross-session correlation requirement, resume tiers widened from `in-development` alone to the whole ACTIVE set (`in-development` · `continue-trial` · `revise` · `paused`), and a repository-boundary/WORKDIR confidentiality rule.

WHAT THIS SESSION ADDED ON TOP — the three remaining /qc-pass round-1 findings:
- F1a: resolved a direct contradiction between C1 and C3 over whether a /develop-ai-resource hand-off is terminal. DECIDED RESUMABLE (component hand-off): the operating outcome and adoption decision stay in the loop, the stream stays open, the unit closes on its ordinary outcome, and the artifact disposition returns through the capability record rather than through the unit. `routed-out` is now reserved for a whole need leaving (the /scope-project case). Grounded in: C1 and C4's shared boundary sentence ("/develop-ai-resource owns the artifact... one implementation component"), C4:439, C4:47, and the ALREADY-LANDED .claude/commands/develop-ai-resource.md:24 and :34 which both state /work-loop "holds the adoption decision". The build plan at line 409 explicitly assigns this decision to commit 5.
- F1b: added the brief-format spec (`**Capability:**` / `**Settled upstream:**`) to C1 § Block formats, discharging the plan's producer-side obligation #2.
- F7: C1 and C3 both cited "the Independent Review SOP's five triggers" as the SOLE authorization for a review-2. That document exists nowhere in the repo or workspace (verified with a positive control on the search). Replaced with an operative bar stated in the contract's own terms, plus C4's operator-supplied-document caveat.
- F9: C1's WORKDIR rule said delete-always while C4 carried an "if it must survive the unit, say so explicitly and say why" exception, and C1 falsely asserted the two agreed. C1 now carries the exception and names the three points on which the two files are kept textually equivalent.

ALSO KNOWN, reported not fixed (outside this change set, gated change class): acceptance test A-CAP-0 fails one clause — ~/.claude/settings.json:166 declares "model": "opus[1m]", which workspace CLAUDE.md prohibits at EVERY layer because a declared default contests /model in the live session. Pre-existing, user-level, out of the declared file scope for this change.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/work-loop.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/work-loop.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/plans/2026-07-28-work-loop-consolidated-build-plan.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/capability-development/SKILL.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/templates/capability-record.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/develop-ai-resource.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The three closed findings (F1a, F1b, F7, F9) are genuinely observed defects with genuinely traced fixes — re-derivation confirms the change description's claims — but the change leaves one already-landed downstream consumer (`develop-ai-resource.md`) carrying stale line citations that now describe a contradiction that no longer exists, and introduces two minor, real design gaps (no reopen_trigger date-gating at resume, C1 at zero line-budget headroom) that are each Medium and each independently mitigable.

## Consumer Inventory

Verified independently via `find -L` (to catch directory-level symlinks that plain `find` misses — confirmed the caller's own recorded method note: `find . -type d -name commands` without `-L` indeed omits `axcion-design-studio`, whose `.claude/commands` is itself a symlink to `ai-resources/.claude/commands`) and `command grep -rniI --exclude-dir=.git` (bypasses the dot-rooted `grep` shadow per `docs/audit-discipline.md`; all instances below used `command grep`, so the shadow does not apply regardless of search-root form). `search-canary.sh` returned `inconclusive` (no gitignored probe directory existed) but is not load-bearing here since `command grep` was used throughout, not the shadowed form.

MD5 confirmed identical (`3df2c7cd0a5ce259fc793a2c9d73a52c`) across all 5 locations of `.claude/commands/work-loop.md` — 4 are symlinks (one file-level, three via file-level relative symlinks, one via a symlinked parent directory) resolving to the single real file in `ai-resources`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/work-loop.md` (workspace root, symlink) | invokes | no — auto-propagates |
| `projects/global-macro-analysis/.claude/commands/work-loop.md` (relative symlink) | invokes | no — auto-propagates |
| `projects/axcion-systems-builder/.claude/commands/work-loop.md` (relative symlink) | invokes | no — auto-propagates |
| `projects/axcion-design-studio/.claude/commands/work-loop.md` (reached via a symlinked `commands/` directory) | invokes | no — auto-propagates |
| `ai-resources/.claude/commands/work-loop.md` (C3 itself) | parses `docs/work-loop.md` (C1) on every invocation | no — cross-references verified intact |
| `ai-resources/skills/capability-development/SKILL.md` (C4) | parses — cites C1 §§ by name (Route triggers, Artifacts, Block formats) | no — section headings unchanged, all cited names still resolve |
| `ai-resources/templates/capability-record.md` (C5) | parses — C1's artifact/status rules assume this schema | no — schema unchanged; `ACTIVE-STATUS-SET` already matches C1's widened resume tiers |
| `ai-resources/plans/2026-07-28-work-loop-consolidated-build-plan.md` | documents — is itself part of the change set (+15 lines) | partially — `plans/…:164` still cites "the Independent Review SOP's five triggers" as the sole `review-2` authorization, the exact framing F7 replaced in C1/C3; not corrected in this pass |
| `ai-resources/.claude/commands/develop-ai-resource.md` (already-landed, commit 6) | documents / parses — cites specific line numbers describing the F1a contradiction | **yes** — `develop-ai-resource.md:163` cites `docs/work-loop.md:157` / `:171` and `.claude/commands/work-loop.md:124` as contradicting each other; those exact line numbers now land on unrelated text (the WORKDIR rule and the Shape-unit review-placement text respectively — verified by direct read), and the underlying contradiction is resolved. Behavior is unaffected (the record-keyed disposition path this file already implements matches the resolved C1/C3 semantics) — this is stale documentation, not a functional break. |

**Total: 9 consumers found, 1 clearly must-change (`develop-ai-resource.md`), 1 partially stale but self-owned (the plan document).**

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `docs/work-loop.md` (C1) is read only on `/work-loop` invocation ("Read `ai-resources/docs/work-loop.md` before anything else, every invocation" — `.claude/commands/work-loop.md:11`), not always-loaded — no workspace/project CLAUDE.md touched in this diff (confirmed: `git diff --stat` names only the 3 files above).
- `.claude/commands/work-loop.md` frontmatter (`model: opus`, `effort: high`) is unchanged by this diff — no new default declared.
- No hook added or edited (`.claude/hooks/*.sh` untouched by this diff).
- No skill description changed (`skills/capability-development/SKILL.md` is unmodified — `git status` shows it clean; only cited, not edited).

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` (any layer) touched by this diff — `git diff --stat` confirms only `docs/work-loop.md`, `.claude/commands/work-loop.md`, and the plan.
- The pre-existing `~/.claude/settings.json:166` `"model": "opus[1m]"` violation is real (independently confirmed: `command grep -n '"model"' ~/.claude/settings.json` → `166:  "model": "opus[1m]"`) but is explicitly out of this change's declared file scope and unaffected by it — noted, not scored against this change.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory (above): 9 consumers, 4 of which are pure symlink propagations of C3 (zero action required — the distribution mechanism is pre-existing and unaffected by this diff), 3 of which are doc/parse consumers verified compatible (C3 itself, C4, C5), and 1 (the plan) partially stale.
- **1 must-change consumer not updated:** `develop-ai-resource.md:163` still narrates the F1a contradiction as live and cites line numbers that no longer support that claim (`docs/work-loop.md:157`/`:171` now read as the WORKDIR-survival clause, not the `routed-out` terminality clause — re-verified by direct read against the current file, not recalled). The change description's own framing ("resolved a direct contradiction between C1 and C3") is accurate as stated — it never claimed the third file was updated — but the consumer inventory surfaces a gap the change's scope did not cover.
- Shared infrastructure: `docs/work-loop.md` and `.claude/commands/work-loop.md` are both symlinked into 4 additional locations, so any edit is live everywhere on next invocation with no sync step — consistent with what the change description names as a structural class trigger ("cross-cutting command edits — C3 is a slash command with 5 consumers and no sync step"). Re-derivation confirms 5 total locations of C3 (1 real + 4 symlinks), matching the caller's count exactly.

### Dimension 4: Reversibility
**Risk:** Low

- The 3-file diff (docs/work-loop.md, .claude/commands/work-loop.md, the plan) is a clean, self-contained markdown edit — `git revert` on the resulting commit(s) fully restores prior state.
- No log/data-file mutation in this specific 3-file diff (`logs/decisions.md`, `logs/friction-log.md` are excluded from this change set, confirmed by `git diff --stat`).
- No external write (no push, no API call, no Notion write) in this change.
- Once landed, commit 3 and commit 5 must be reverted in that reverse order (5 then 3) per the build plan's own rollback-boundary table (`plans/…:316-329`) — this is a documented, git-native ordering constraint, not a manual multi-system cleanup, so it stays Low rather than Medium.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Stale downstream citation (same finding as Dimension 3, different angle):** `develop-ai-resource.md:163` is an implicit dependency on C1/C3's exact line numbers that this change did not re-check. The behavior it describes still works (verified: the record-keyed return address in `develop-ai-resource.md` Step 4 already matches the resolved C1/C3 semantics), but a future reader trusting the citation would be misled.
- **No trigger-date gating on `paused` resume (adversarial check 3):** confirmed by `command grep -n "reopen_trigger"` across C1, C3, C4, C5 — the field is written and validated for presence, but nothing compares it against today's date before Tier 3 offers a `paused` record as a resume candidate. Per § Resume order, "exactly one candidate in the highest non-empty tier → resume it, announcing in one line" — a sole `paused` capability with a future `reopen_trigger` would be silently offered (and, if sole, auto-resumed) before its stated trigger. This is a real gap, not fabricated: the field exists and is validated for presence/malformedness, but its date is never read back. It does not, however, produce a loop jam — Step 8's `active_unit: none` clearing and the TERMINAL-status exit are independently correct and were specifically checked against adversarial concern 3 (no jam path found).
- **Zero line-budget headroom:** `wc -l ai-resources/docs/work-loop.md` → exactly 260 lines against A-CORE-3's 260-line ceiling — re-derived, matches the change description exactly. This is the third ceiling figure recorded in the file's own history (180 → 220 → 260, per `plans/…:341-351`) — a legitimate correction pattern, but zero headroom means the next addition to C1 forces either trimming existing material or a fourth amendment, both of which this change does not decide in advance.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.

- **OP-12 (closure before detection).** This change is closure work — it resolves three previously-flagged QC findings (F1a, F1b, F7, F9) rather than adding new detection. Positively aligned.
- **OP-9 / AP-7 / DR-7 (speculative abstraction).** The new brief-format contract (`**Capability:**` / `**Settled upstream:**` in C1 § Block formats) is not speculative: its consumer, `develop-ai-resource.md` Step 1.0, is already landed (commit 6, confirmed via `git log`) and already checks these exact fields — the contract was previously incomplete on the producer side only (confirmed via the plan's own note that "no executable component emits these fields yet"). This closes an existing, already-confirmed consumer's dependency rather than building ahead of one.
- **OP-2 (automate execution; gate judgment).** The F1a resolution (resumable vs. terminal) is a judgment call the session plan itself names as such, decided under full autonomy per workspace CLAUDE.md's Decision-Point Posture (pick the recommended option, state it, proceed) rather than an ungated blocking question — and it is grounded in cited evidence (the shared boundary sentence, C4:439/:47, the already-landed `develop-ai-resource.md:24`/`:34`). This very `/risk-check` gate is the operator-directed check on that judgment call, consistent with OP-2's intent.
- **OP-5 (advisory vs. enforcement).** No change to enforcement posture — `/work-loop` remains operator-gated at G1/G2/G3 with explicit stops; nothing in this diff auto-corrects or auto-acts.
- **OP-10 (system boundary).** The Codex control-room declaration (`docs/work-loop.md:1-7`) is unchanged by this diff (outside the git-diff hunk ranges) — no deepening of cross-tool coordination.
- **DR-1 / DR-3 (placement).** No new files, no new resource category — edits to existing files in their established homes.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed or inferred?** Observed, not merely recalled. For each of the four claimed findings, this review independently re-read the pre-fix state (via `logs/session-plan-2026-07-29-S1-208.md`, which records the original citations with line anchors: C1:190/202-204 vs. C3:199 for F1a; the absent `grep` result for F1b; the "Independent Review SOP" phrase with a stated positive control for F7; C1:156 vs. C4:354 for F9) and the current post-fix state (via direct `Read` of the live files and targeted `command grep`), confirming each fix lands as described: F1a's "not terminal when the artifact is a component of a live stream" text is present at `docs/work-loop.md:48` and the mirrored text at `.claude/commands/work-loop.md:199`; F1b's brief-format block is present at `docs/work-loop.md:188-194`; F7's SOP-caveat replacement is present at `docs/work-loop.md:94` and `.claude/commands/work-loop.md:224`; F9's WORKDIR exception clause is present at `docs/work-loop.md:156-158`.
- **Consequence — traced or assumed?** Traced. Adversarial check 1 (does F1a break stream closure or leak artifacts) was independently worked through against the live text: the "stream stays open" design is paired with Step 8's pre-existing `paused` + `reopen_trigger` safeguard for any unit that closes without reaching Land, which prevents the hypothesized "record left in limbo forever" failure — no path was found where a stream that should close terminally instead stays open, or where artifacts are retained beyond the documented per-stream retention rule.
- **Re-derivation vs. the change description:** Two minor discrepancies found, both immaterial to the verdict: (1) the change description states `logs/friction-log.md` "carries 47 uncommitted lines"; `git diff --stat` shows 49 insertions — the direction of the claim (pre-existing, 2026-07-25, must not be staged) is confirmed correct, only the count is off by 2. (2) The change description's own three-finding summary (F1a, F1b, F7, F9 fixed) is accurate as stated, but the consumer inventory (Step 1.5, run independently) surfaced a gap the description did not mention: `develop-ai-resource.md`'s stale citation of the now-resolved F1a contradiction — not a contradiction of any claim made, but an incompleteness the description did not flag. No claim in the change description was found to be false.
- The pre-existing, out-of-scope `~/.claude/settings.json:166` model-default claim was independently verified true (see Dimension 2) — this strengthens confidence in the change description's overall accuracy but is not part of this change's own defect premise.

## Mitigations

- **Blast Radius / Hidden Coupling (stale consumer citation):** Before or immediately after landing commits 3 and 5, update `develop-ai-resource.md:163` to drop or correct the now-inaccurate line citations and the "these two shipped files contradict each other" framing — the contradiction is resolved and the record-keyed return-address design already matches. A small, additive, single-file follow-up edit; log it in the same session or as a one-line `logs/friction-log.md` entry if deferred.
- **Hidden Coupling (reopen_trigger date-gating gap):** Record the "Tier 3 does not check whether a `paused` record's `reopen_trigger` date has arrived" gap as a **Named residual** in `docs/work-loop.md` § Resume order, following the section's own existing pattern (it already carries one named residual for unbound reviewed capabilities) — this converts a silent gap into a documented, accepted behavior with a stated revisit trigger, consistent with how the contract handles its other known limitations.
- **Hidden Coupling (zero line-budget headroom):** No blocking action required before landing, but the next session that needs to add to C1 should treat the 260/260 state as a decision point requiring an explicit choice (trim vs. a recorded fourth ceiling amendment) rather than a default assumption that headroom exists.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `git diff --stat`/`git diff` output, `wc -l`, `md5`, `find -L`, `command grep -rniI --exclude-dir=.git` with confirmed non-shadowed behavior, direct `Read` of all referenced files (current state) and of `logs/session-plan-2026-07-29-S1-208.md` (pre-fix state), and `git log` confirming which commits in this build have already landed. No training-data fallback was used on fetch/read failures.
