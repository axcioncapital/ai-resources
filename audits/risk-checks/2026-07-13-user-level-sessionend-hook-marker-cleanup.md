# Risk Check — 2026-07-13

## Change

Add a NEW user-level SessionEnd hook at ~/.claude/settings.json + a new script ~/.claude/hooks/cleanup-session-marker.sh. The hook parses session_id from the SessionEnd stdin JSON payload (via python3, mirroring the emit() pattern in ai-resources/.claude/hooks/detect-concurrent-session.sh — NOT via the CLAUDE_CODE_SESSION_ID env var, whose availability at SessionEnd is unconfirmed) and runs `rm -f "$cwd/logs/.session-marker-$session_id"`. Non-blocking, exit 0 on every path.

WHY: the per-session-id marker set (logs/.session-marker-<id>) is the LIVENESS ORACLE read by three consumers — detect-concurrent-session.sh (SessionStart nudge), /prime Step 1a (live-foreign check), and check-foreign-staging.sh (PreToolUse commit guard). The marker is supposed to be removed at wrap by /wrap-session Step 13, but Step 13 is the FINAL action of a 300-line command, after the commit, and is being forgotten: of today's 3 wrapped sessions (S1, S2, S3) only S2's marker was removed. Stale markers make already-wrapped sessions look live, so /prime and the SessionStart hook false-fire "a concurrent session is live" on every second-or-later session of any day. This session's own /prime false-fired exactly this way. Consequence is alarm fatigue on the one warning that guards a real data-loss failure mode (two sessions in one checkout silently overwriting each other's uncommitted edits).

WHY USER-LEVEL (not ai-resources-level): /prime is symlinked into every project from ai-resources, so it writes per-id markers and runs the live-foreign check in ALL repos — but a hook in ai-resources/.claude/settings.json only fires when ai-resources is the open folder. Verified by blindspot-scan: positioning-research runs a FORKED wrap-session with no Step 13 at all, so its markers are cleaned by nothing today. User-level is the only layer that covers ai-resources + all ~20 projects + future projects. Operator chose this option explicitly over the ai-resources-only and template+per-project alternatives.

SCOPE NOTE: /wrap-session Step 13 (both paired copies) is left in place — rm -f is idempotent, so the redundancy is harmless; removing it would mean editing both paired wrap copies for no functional gain. /prime's next-day orphan prune is retained as the required backstop, because SessionEnd does NOT fire on SIGKILL/hard crash (verified against the Claude Code hooks docs).

KEY RISKS TO SCORE:
(1) this is the FIRST SessionEnd hook anywhere in the workspace — zero precedent;
(2) it is a USER-LEVEL config change, so it fires for every Claude Code session on this machine including non-Axcion folders (intended to be a harmless no-op there: rm -f on an absent path);
(3) it DELETES A FILE — score against the possibility of an empty/malformed session_id (e.g. `rm -f "$cwd/logs/.session-marker-"` with an empty id — does that glob or delete anything unintended?), a cwd that is not a repo, or a path-traversal-shaped session_id;
(4) the workspace has a HARD RULE that no "model" field may appear in ANY settings.json (workspace CLAUDE.md § Model Tier) — confirm this change adds no such field and that editing ~/.claude/settings.json does not disturb an existing one;
(5) does ANY consumer read the per-id marker AFTER the session ends? If not, removal at SessionEnd is safe by construction.

ADDITIONAL CONTEXT THE REVIEWER MUST VERIFY INDEPENDENTLY (do not take on trust):
- Confirm the three consumers of logs/.session-marker-* by grep, and check whether there is a FOURTH I missed.
- Confirm that ~/.claude/settings.json currently exists and what it contains (hooks? permissions? a "model" field?). Do NOT edit it — read only.
- Confirm the claim that /wrap-session Step 13's rm is being skipped: today's markers in ai-resources/logs/ should show S1 and S3 present (both wrapped) and S2 absent.
- Consider whether a user-level hook that deletes files based on an externally-supplied session_id has any injection surface.

## Referenced files

- /Users/patrik.lindeberg/.claude/settings.json — exists
- /Users/patrik.lindeberg/.claude/hooks/cleanup-session-marker.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/detect-concurrent-session.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md — exists (paired root copy)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/session-marker.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is a narrowly-scoped, evidence-backed fix (an independently-verified friction-log.md entry already documents "wrapped sessions leave ghost markers" as an open, unresolved failure) that follows this machine's existing user-level hook pattern, but it carries real unversioned-config reversibility risk, a consumer inventory the description under-counted, and one unverified external-payload assumption that should be closed before landing.

## Consumer Inventory

Search terms used: `.session-marker-` (per-id marker basename pattern), `cleanup-session-marker` (target script — zero hits, confirms "not yet present" and no premature references), `SessionEnd` (event-type precedent search). Searched `ai-resources/` and the workspace root (`..`) per the mandated scope, plus `.claude/commands/`, `.claude/hooks/`, `skills/`, `docs/` specifically.

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/.claude/hooks/detect-concurrent-session.sh | parses | no |
| ai-resources/.claude/hooks/check-foreign-staging.sh | parses | no |
| ai-resources/.claude/commands/prime.md | invokes / parses (writer + live-foreign reader) | no |
| ai-resources/.claude/commands/concurrent-session-check.md | parses | no |
| ai-resources/.claude/commands/wrap-session.md (canonical, Step 13) | co-edits (parallel teardown path, left in place per scope note) | no |
| /.claude/commands/wrap-session.md (workspace-root paired copy, Step 7) | co-edits (same, left in place) | no |
| ai-resources/skills/handoff/SKILL.md (continuity Step C3) | co-edits (same, left in place) | no |
| ai-resources/docs/session-marker.md § Two-end contract registry | documents | yes |

Total: 8 consumers, 1 must-change.

**Gap found and flagged:** the change description names three consumers of the liveness oracle (detect-concurrent-session.sh, /prime Step 1a, check-foreign-staging.sh). The inventory grep found a **fourth**: `ai-resources/.claude/commands/concurrent-session-check.md` Steps 2-3, which also reads the today-dated per-id marker set to detect live sessions (documented in `docs/session-marker.md` § Two-end contract registry, "Read-only auxiliary consumers"). It shares the same read direction as the other three (absence = not-live), so the new hook does not break it — but the description's own consumer count was incomplete, which the review-time consumer inventory step exists to catch.

**Registry gap:** `docs/session-marker.md` states its own rule — "Every place the marker contract is consumed must point back to this doc. Adding or changing a consumer requires updating this list." — and its § Two-end contract registry, "Per-id marker teardown" subsection currently lists only `/wrap-session` Step 13 and `handoff/SKILL.md` Step C3 as teardown writers. The new SessionEnd hook is a third teardown writer and is not yet registered there. `friction-log.md` line 155-168 (the "S7" entry) documents a prior, directly-analogous recurrence: a structural change shipped with an incomplete consumer inventory specifically because this same registry was stale — three independent passes missed the same consumer until a manual cross-read caught it. This is the identical failure class recurring at the documentation layer, not the code layer.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content is added — the change touches `~/.claude/settings.json`'s `hooks.SessionEnd` array only, not any CLAUDE.md or auto-loaded context file.
- SessionEnd fires once per session teardown, not per tool call — same cost class as the existing `SessionStart` hooks already registered in this file (`detect-concurrent-session.sh`, `warn-fable-model.sh`, `~/.claude/settings.json` lines 68-89), not the `PreToolUse` per-call class.
- Unlike the `SessionStart` hooks (which inject a `systemMessage` back into the next session's context), a `SessionEnd` hook fires after the session has already terminated — there is no live context for it to feed tokens into. Net token cost to any future session: effectively zero.
- The script itself (per the description) is a single `python3 -c` JSON parse + one `rm -f` — minimal execution cost, no loop, no network call.

### Dimension 2: Permissions Surface
**Risk:** Medium

- `~/.claude/settings.json` (read directly, lines 1-152) already runs `defaultMode: "bypassPermissions"` with `"allow": ["Bash(*)", "Write(**)", ...]` at user level — Bash execution is already maximally permissive at this scope, for this operator's account, machine-wide. This is pre-existing state, not introduced by this change.
- The same file **already** registers three hooks that fire machine-wide at user level and reference the same `ai-resources` hook scripts and the same marker mechanism: `check-foreign-staging.sh` (PreToolUse, line 61), `detect-concurrent-session.sh` (SessionStart, line 73), `warn-fable-model.sh` (SessionStart, line 83). Adding a fourth hook to this same array, at the same file, same scope, same "call an ai-resources script via bash" pattern, is squarely "additions within an already-established pattern" (Low/Medium calibration example) — not a first-of-its-kind capability grant at this layer.
- What genuinely is new: the **event type**. `SessionEnd` has never been registered in this file or anywhere else searched in the repo (see Dimension 3 evidence — zero `SessionEnd` hits outside forward-looking planning docs). A new trigger point firing unconditionally, machine-wide, with no operator visibility (exit 0 every path, no `statusMessage`) is a step beyond "one more entry in an existing array" even though the file/scope/script-style are fully precedented.
- The actual granted capability is narrow: one `rm -f` against a single, tightly-shaped path (`$cwd/logs/.session-marker-$session_id`) — not a broad `Bash(*)`/`Write(**)`-class widening, and not a `deny`-rule removal.
- **Confirmed independently, per the change description's own ask:** the settings file contains no `deny`-rule change and no removal of any existing restriction; the four `deny` entries (`rm -rf *`, `sudo *`, `git reset --hard *`, `git checkout *`) are untouched by this change's description.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touches: 2 — `~/.claude/settings.json` (one hook-array entry added) and one new script file.
- Consumer inventory (Step 1.5, table above): **8 consumers found, 1 must-change** (the `docs/session-marker.md` registry, on its own self-declared rule — a documentation-consistency requirement, not a functional break).
- Of the 4 functional readers of the per-id marker (`detect-concurrent-session.sh`, `check-foreign-staging.sh`, `prime.md`, `concurrent-session-check.md`), **none require modification to keep working** — all four already treat "no today-dated per-id marker for a given session" as "that session is not live," which is exactly what an earlier, more-reliable removal makes MORE accurate, not less. This is a backwards-compatible reinforcement of an existing contract, not a breaking change.
- Of the 3 co-located teardown mechanisms (`wrap-session.md` Step 13 both copies, `handoff/SKILL.md` Step C3), the change's own scope note explicitly leaves all three in place — confirmed no edit is proposed to any of them.
- **Verified live evidence for the stated defect** (per the reviewer-verification instructions in the change description): today's `ai-resources/logs/` directory holds `.session-marker-c5d1f655…` (`2026-07-13 S1`) and `.session-marker-db91f37b…` (`2026-07-13 S3`) still present; no `S2`-tagged per-id file exists; `session-notes.md` shows `## 2026-07-13 — Session S1`, `S2`, `S2` (retitled), `S3` all as wrapped/closed headers. This exactly matches the claim: S1 and S3 stayed stale, S2 alone was torn down. Confirmed independently, not taken on trust.
- The gap noted above (a 4th consumer, `concurrent-session-check.md`, missed by the change description) is itself the blast-radius finding the framework asks to surface when the inventory exceeds the description's stated count — it does not change compatibility (same read direction as the other three) but it does mean the description's own risk enumeration was incomplete.

### Dimension 4: Reversibility
**Risk:** High

- `~/.claude/settings.json` is **not tracked in any git repository** — it lives in the user's home directory, outside `ai-resources/` and outside the workspace root. A `git revert` of this change is structurally impossible; there is no commit to revert. The same is true of the new script file (`~/.claude/hooks/cleanup-session-marker.sh`) — pure filesystem state, no version history.
- This matches the framework's High bar directly: "state has propagated beyond git ... multi-step manual rollback required." Undoing this change means hand-editing the JSON (removing the added hook-array entry without disturbing the rest of the file) and hand-deleting the script — with no diff, no history, and no automated check that the manual edit restored the prior state exactly.
- Partial mitigating factor: this machine already has an established backup convention for this exact file — `~/.claude/settings.json.bak-2026-04-25` exists on disk today, confirming the operator already practices manual timestamped backups before editing this file. That convention is available but not automatic — it must be invoked deliberately for this change (see Mitigations).
- The state being deleted by the hook itself (the per-id marker) is cheap and disposable (a one-line liveness flag, not durable content) — so the *ongoing* action's reversibility is fine (a wrongly-deleted marker self-heals at the next `/prime`). The High score here is about reverting the **hook registration itself**, not about the marker file the hook deletes.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Unverified payload-schema assumption.** The change description states the script will parse `session_id` from the SessionEnd stdin JSON payload and derive `$cwd`, but the script does not yet exist and this reviewer has no external documentation-fetch tool available in this dispatch to independently confirm the SessionEnd hook payload's exact field names (`session_id` vs. some other key; presence or absence of a `cwd` field). This is a genuine, load-bearing, currently-unverified assumption — flagged here explicitly rather than taken on trust, per the review's evidence-grounding rule.
- The general pattern this assumption rests on — parsing fields out of a hook's stdin JSON payload — **is already proven working** elsewhere in this repo: `check-foreign-staging.sh` (PreToolUse) successfully parses `tool_name` / `tool_input.command` from stdin JSON today (read directly, lines 63-77). So the mechanism class is not novel; only the specific SessionEnd field names are unconfirmed.
- **Functional overlap, but openly reasoned, not silent.** Three independent mechanisms will now perform the same teardown action on the same file (`/wrap-session` Step 13 both copies, `handoff/SKILL.md` Step C3, and this new SessionEnd hook). The change description explicitly names this overlap and argues it is safe because `rm -f` is idempotent and the SessionEnd trigger fires strictly after any in-session teardown already ran (SessionEnd fires when the whole CLI process exits, which is after `/wrap-session` — if it ran — already completed). Independent check: this ordering argument holds structurally; SessionEnd cannot fire concurrently with an in-session Step 13 (they are sequential, not racing). The overlap is a documented, reasoned redundancy at the change site, closer to the Medium calibration ("one new contract... documented at the change site") than the High bar of *silent* overlap.
- One additional implicit dependency worth naming: the design deliberately does **not** rely on `CLAUDE_CODE_SESSION_ID` (env var) because its availability at SessionEnd is explicitly flagged as unconfirmed in the description — this is the correct, cautious choice, and it is already loudly named rather than silently assumed. Counted as the one open item above, not a second independent unknown.

### Dimension 6: Principle Alignment
**Risk:** Low

Grounded against `projects/strategic-os/ai-strategy/principles-base.md` (read directly) plus the always-loaded CLAUDE.md sections already in context.

- **OP-9 / AP-7 / DR-7 (speculative abstraction) — does NOT apply.** This is not generalization ahead of a consumer: it serves 4 *already-existing, already-confirmed* consumers of the per-id marker mechanism (see Consumer Inventory), and closes a gap in an already-built, already-shipped contract (`docs/session-marker.md`, shipped 2026-05-29). No new consumer is being speculated into existence.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule #7)** — this is a new component (a new hook + new script), so the gate applies. It fails prong (a) (net-simplification — nothing existing is removed or consolidated; this is a pure addition). It clears **prong (b) (evidenced-failure)** on independently-found, cited written evidence the change description itself did not cite: `ai-resources/logs/friction-log.md` line 321 — "THIRD finding, at this session's own wrap: the liveness oracle is stale in the OTHER direction too — wrapped sessions leave ghost markers... Any fix must make teardown reliable (or make liveness derivable from something other than a file the dying session is trusted to delete)." That entry, from a prior session, already diagnosed exactly this defect and named exactly this class of fix as the needed remedy. **Finding:** the change description should cite this friction-log entry directly (it strengthens the case and satisfies rule #7 prong (b) on the record); its absence from the description is a documentation-completeness gap, not a principle violation — the evidence exists and was independently located.
- **OP-12 (closure before detection)** — this change is a *closer*, not a new detector: it removes stale state rather than adding a new scan/flag/finding-generator. Aligns with, does not work against, OP-12.
- **OP-5 (advisory vs. enforcement)** — the hook performs an automatic file deletion, but on the same class of ephemeral, disposable, process-owned state that `/wrap-session` Step 13 already deletes automatically today (an accepted, existing automated action, not a judgment call). This is not an advisory-to-enforcement upgrade on any judgment surface; it is mechanical housekeeping of already-automated cleanup, extended to a currently-uncovered trigger point.
- **DR-1 / DR-3 (placement)** — `DR-1`'s canonical framing names three tiers (canonical / workspace-root / project-local) and does not explicitly enumerate user-level (`~/.claude/`) as a fourth. This is a pre-existing gap in the stated framing, not one created by this change: user-level hooks are **already** an established, precedented location in this operator's actual setup (3 hooks already live there, per Dimension 2). The change's own "WHY USER-LEVEL" section gives an explicit, reasoned justification (positioning-research's forked wrap-session has no Step 13 at all — independently corroborated: the change names this as blindspot-scan-verified) and states the two rejected alternatives (ai-resources-only, template+per-project). This meets the bar of a loud, deliberate placement decision rather than silent drift.
- **OP-10 (system boundary)** — not implicated; no cross-tool coordination involved.
- **Pre-existing, out-of-scope finding (not attributable to this change):** `~/.claude/settings.json` line 150 already carries `"model": "opus[1m]"` — a standing violation of workspace CLAUDE.md § Model Tier ("Model defaults are prohibited... do not declare a `model` field in ANY `.claude/settings.json`"). This predates the proposed change and is not introduced or disturbed by it (the change only adds one entry to the `hooks.SessionEnd` array). Confirmed by direct read that the proposed change does not add or reference any `model` field. Flagged here for completeness per the review's explicit ask, not scored against this change.

## Mitigations

- **Reversibility (High):** Before editing `~/.claude/settings.json`, create a timestamped backup — `cp ~/.claude/settings.json ~/.claude/settings.json.bak-2026-07-13` — consistent with the existing `settings.json.bak-2026-04-25` convention already present on this machine. Keep the backup until the hook has been verified working across at least one full session-end cycle (confirm the marker for a throwaway/test session is actually removed after that session's CLI process exits).
- **Hidden Coupling (Medium):** Before relying on the hook in production, verify the actual SessionEnd stdin JSON payload schema with a live probe — e.g., temporarily point the hook at a script that only logs its full stdin to a scratch file, end one real session, and inspect the captured payload — to confirm the `session_id` key name and whether a `cwd` field is present. If `cwd` is absent from the payload, have the script fall back to `${CLAUDE_PROJECT_DIR}` (already used elsewhere in this repo's hooks, e.g. `check-foreign-staging.sh` line 151) rather than assuming a payload field that may not exist.
- **Blast Radius (Medium):** Before landing, add the new SessionEnd hook as a third entry under `docs/session-marker.md` § Two-end contract registry → "Per-id marker teardown" (alongside the existing `/wrap-session` Step 13 and `handoff/SKILL.md` Step C3 entries), and add `concurrent-session-check.md` to the description's consumer list for completeness (verified compatible, no change needed to that file itself — naming it closes the under-count this review found).
- **Permissions Surface (Medium):** Have the script positively validate `$cwd` (confirm it resolves to an existing directory containing a `logs/` subdirectory) before constructing the `rm -f` target path, so the "harmless no-op in non-Axcion folders" behavior the description asserts is enforced by the script's own logic, not merely by the coincidental absence of a matching filename elsewhere on the machine.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures. One item — the exact SessionEnd stdin JSON payload schema — could not be independently verified (no external-documentation-fetch tool available in this dispatch); it is flagged as an open, unverified assumption under Dimension 5 rather than asserted either way, and carries a corresponding mitigation rather than being silently assumed safe.
