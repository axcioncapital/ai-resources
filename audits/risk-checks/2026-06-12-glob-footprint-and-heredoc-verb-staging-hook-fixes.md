# Risk Check — 2026-06-12

## Change

Two fixes to `.claude/hooks/check-foreign-staging.sh` (a PreToolUse Bash "staging-tripwire" hook that, when a gated git verb runs, compares the files it would stage against this session's declared `- Files in scope:` footprint and BLOCKS — exit 2 — on foreign files):

(A) **Glob-aware `in_footprint()`** — previously matched a candidate path against each footprint token by literal `path == fp or path.startswith(fp + "/")`. A footprint token containing `*`/`**` (e.g. `wiki/**/*.md`, which `/session-start`, `/prime` Step 8c, and hand-written mandates legitimately emit) was treated as literal characters, so no real path ever matched → the whole session false-blocked at commit. Fix: when a token contains `*`, match with `fnmatch.fnmatch(path, token.replace("**","*"))` (collapse `**`→`*` first since fnmatch's `*` already crosses `/`); keep the literal `==`/`startswith` arm for non-glob tokens. Added `import fnmatch` to the stdlib import line.

(B) **Invocation-anchored gated-verb detection** — previously `is_commit = re.search(r'\bgit\s+commit\b', cmd)` and the `git add`-wide detection scanned the ENTIRE command string, so `git commit`/`git add` appearing inside a `<<'EOF' … EOF` heredoc body or a quoted string (e.g. a `cat >> log <<'EOF' … git commit … EOF` append, or a quoted commit message) false-triggered the guard on commands that are not git invocations. Fix: a new `_command_text_only(command)` helper blanks heredoc bodies (line-scanner tracking the heredoc delimiter) and quoted spans (single + double), producing `scan`; then `is_commit`, `is_add_wide`, `_add_is_wide`, and the candidate-form regexes (`add_u_only`, `subdir`, `commit -a`) all operate over `scan` and anchor the git verb to a command-segment boundary `(?:^|[\n;&|(])\s*` (start-of-string, newline, or after `;`/`&&`/`||`/`|`/`(`) rather than matching anywhere. Both defenses combine: blanking removes literal mentions; boundary-anchoring keeps newline-separated real invocations gating while rejecting mid-line mentions like `echo git commit`.

Both fixes are confined to the single file `.claude/hooks/check-foreign-staging.sh`. No other file changed. The hook has one wiring site today: `ai-resources/.claude/settings.json` (PreToolUse Bash matcher), slated for user-level registration per improvement-log entry 521 P1. Edits are applied and unit-tested: 19/19 cases pass (heredoc/quoted/mid-line false-triggers now exit 0; real commit/add-wide forms including newline-separated and subshell still gate; glob footprints now match nested paths; non-glob tokens and dir-prefixes unchanged). The change is a defect fix on a guard whose two prior defects (date-anchor, /handoff teardown) were fixed in the 2026-06-12 S1 session; these two (glob-footprint, heredoc-verb) were the deliberately-deferred remainder. Source spec: improvement-log.md 2026-06-11 entry (Symptoms A/B, Fix A/B prescriptions).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-foreign-staging.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json — exists (wiring site)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/commit-discipline.md — exists (two-end contract)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists (spec source)

## Verdict

GO

**Summary:** A spec-driven, unit-tested defect fix confined to one self-contained hook script; it loosens two false-block paths (the guard becomes *less* eager to block), touches no contract that callers depend on, and aligns with OP-5/OP-12 — but note the actual wiring site is user-level `~/.claude/settings.json`, not `ai-resources/.claude/settings.json` as the description states.

## Consumer Inventory

The change target is a Bash hook *script*. Its "consumers" are (1) whatever wires it into the PreToolUse(Bash) event, and (2) any reader of the contracts it depends on or emits. The hook itself depends on the `- Files in scope:` footprint contract (Fix A) and reads git porcelain/diff (unchanged). It introduces no new contract.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `/Users/patrik.lindeberg/.claude/settings.json` (line 61) | invokes (PreToolUse Bash matcher → `bash ".../ai-resources/.claude/hooks/check-foreign-staging.sh"`) | no |
| `ai-resources/.claude/commands/session-start.md` (L280/L288 parse contract; emits `- Files in scope:` glob tokens) | co-edits / contract-producer (Fix A consumes the footprint it writes) | no |
| `ai-resources/.claude/commands/prime.md` (L472/L512/L520; emits footprint incl. globs) | contract-producer | no |
| `ai-resources/docs/commit-discipline.md` (§ Foreign-staging tripwire, L17–27) | documents (two-end contract: gated verbs, exempt-list, fail-open) | no |
| `ai-resources/docs/session-marker.md` | documents (marker/teardown contract the hook reads) | no |
| `ai-resources/.claude/hooks/detect-concurrent-session.sh` | parses-shared-signal (reads the IDENTICAL per-id-marker liveness oracle; paired contract per session-marker.md) | no |
| `projects/positioning-research/.claude/hooks/detect-concurrent-session.sh` (+ research-pe-regime-shift copy) | documents (prose references the hook by name; no shared code) | no |
| `.claude/commands/wrap-session.md` (workspace-root) | documents (names the hook) | no |
| `ai-resources/docs/daniel-concurrent-session-hooks-setup.md` | documents (Daniel R1 self-registration of the same script at his own user-level) | no |

Total: 9 distinct consumers, 0 must-change. The two contract-producers (`session-start.md`, `prime.md`) are listed because Fix A is precisely a fix to make the hook honor the glob footprints they already legitimately emit — they need no change; the hook now matches what they write. `detect-concurrent-session.sh` shares the liveness-oracle signal but neither of these two fixes touches that signal, so the paired contract stays coherent.

**Wiring-site correction (blast-radius finding):** the CHANGE_DESCRIPTION states "one wiring site today: `ai-resources/.claude/settings.json` (PreToolUse Bash matcher), slated for user-level registration per … 521 P1." Grep shows the opposite is now true: `ai-resources/.claude/settings.json` contains **no** `check-foreign-staging` matcher (its PreToolUse hooks are `check-heavy-tool.sh` and `friction-log-auto.sh` only — lines 41–63). The sole live wiring is `~/.claude/settings.json:61`, by machine-absolute path. Entry 521 (improvement-log.md:522) confirms P1 *already landed* 2026-06-11 ("user-level registration in `~/.claude/settings.json` by machine-absolute path; the three repo/project-level registrations deleted in the same change set"). Consequence: this single physical script fires on **every checkout/repo on this machine** (and Daniel's machine via R1 self-registration), not just ai-resources. This widens the *operational* blast radius vs. the description's framing — addressed under Dimension 3.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No always-loaded content added. The change edits a hook *body*; it adds no `@import`, no CLAUDE.md line, no skill, no new always-loaded file. (No CLAUDE.md or settings line references the script body content.)
- The hook is PreToolUse(Bash), so it does run per Bash tool call — but that cost is pre-existing, not introduced by this change. The early-exit ordering is unchanged: the cheap regex gated-verb check still runs first and exits 0 before any git/file read for non-commit/non-add Bash calls (hook L140–141, `if not is_commit and not is_add_wide: sys.exit(0)`).
- Fix B adds one extra pre-pass over the command string (`_command_text_only`, L92–119: a line split + two regex subs) on every Bash call before the early exit. This is a few microseconds on a short command string and runs inside the existing `timeout: 5` budget — negligible, no per-session token cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `allow`/`ask`/`deny` entry added, removed, or narrowed. `ai-resources/.claude/settings.json` permissions block (lines 2–35) is untouched by this change (only the hook body changed; `git status` shows one modified file, the script).
- No new tool-invocation pattern introduced. The hook still shells only `git -C … rev-parse / status / diff` and `python3` (hook L61, L144–149, L311, L351, L354) — same external surface as before.
- `import fnmatch` is a Python stdlib import inside the existing `python3` heredoc — not a tool-permission change.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 1 (`ai-resources/.claude/hooks/check-foreign-staging.sh`; `git diff --stat HEAD` = 66 insertions, 10 deletions, 1 file).
- Consumer inventory: 9 consumers, **0 must-change**. No caller requires modification to keep working. The change is backward-compatible in both directions: Fix B only *removes* false triggers (commands that previously false-blocked now exit 0; all 19 real-invocation test cases still gate), and Fix A only *adds* matches for glob tokens that previously matched nothing (non-glob `==`/`startswith` arm preserved verbatim, hook L408).
- Contract check (the `parses` rows): the only contract the change *consumes* is the `- Files in scope:` footprint emitted by `session-start.md`/`prime.md` (documented parse contract, session-start.md L288). Fix A makes the hook honor the glob form of that contract — it does not change the contract. The shared liveness-oracle signal that `detect-concurrent-session.sh` co-reads is **not touched** by either fix (the `_live_foreign_session` body, hook L197–225, is unchanged), so the paired-hook coherence noted in session-marker.md holds.
- **Operational-scope finding (not anticipated by the description):** the live wiring is user-level (`~/.claude/settings.json:61`), so the edited script fires across all repos on this machine, plus Daniel's machine. This is wider than the "one wiring site, ai-resources" framing — but it does not raise the risk *level*, because (a) the script is a single shared physical file (one edit propagates everywhere automatically — no per-repo copies to sync; `find` confirms only one `check-foreign-staging.sh` exists), and (b) the change is strictly false-block-reducing, so broader reach means the *fix* reaches more checkouts, not that a regression reaches more checkouts. The only residual is that a latent defect in the new code would also fire everywhere — covered under Reversibility/Coupling.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to a tracked file. `git revert` (or `git checkout HEAD -- .claude/hooks/check-foreign-staging.sh`) fully restores the prior body within the working tree — no sibling files created, no data/log mutation, no settings.json change.
- The hook writes nothing (reads only; CONTRACT note hook L54: "Reads only; writes nothing"), so a revert leaves no stale state behind — no log entries, no markers, no cached permission state to clean up.
- No state propagates beyond git by the change itself (no push, no external write). Standard wrap-time gated push applies to the commit, but the change is recoverable by a normal revert commit.
- One nuance, still Low: because the live wiring is by absolute path to the working file, a revert takes effect immediately for every session on the machine the moment the file is restored — reversal is in fact *easier* (no settings edit needed), not harder.

### Dimension 5: Hidden Coupling
**Risk:** Low

- No new contract introduced for callers to honor. Fix B's `_command_text_only`/`_VERB_BOUNDARY` are internal helpers; Fix A's fnmatch arm is internal to `in_footprint`. Nothing downstream parses these.
- One implicit dependency, on an *established and documented* convention: Fix A assumes footprint tokens may legitimately contain `*`/`**` globs. This is grounded — `session-start.md`/`prime.md` emit them and the `- Files in scope:` parse contract is documented (session-start.md L288). The `**`→`*` collapse is a deliberate, code-commented choice (hook L406) keyed to fnmatch's `*`-crosses-`/` semantics; documented at the change site.
- Fix B's heredoc scanner is best-effort and self-documents its failure mode as fail-open (hook L96–98: a pathological input "degrades toward not-seeing text, i.e. a fail-open miss, never a false block") — consistent with the hook's stated FAIL-OPEN contract (L30–43, L51–55). No silent auto-firing in an unexpected context: the firing context (PreToolUse Bash on a gated verb) is unchanged; the fix narrows *when* it fires.
- No functional overlap created. The hook still pairs with — does not duplicate — the `git diff --cached` shared-hunk review (commit-discipline.md L21) and the parked QC-PENDING block hook (L27); neither fix changes that division.
- Residual coupling note (Low, not Medium): the new heredoc/quote-blanking is a hand-rolled mini-parser of shell syntax. Its correctness rests on the 19-case unit battery rather than a formal shell grammar; an exotic construct (nested heredocs, `<<<` here-strings, escaped quotes across lines) could mis-blank. Because every failure mode is fail-open (miss a real verb → allow), the worst case is a missed block, not a false block — so this is a coverage gap in an advisory guard, not a hidden-coupling hazard that breaks a caller.

### Dimension 6: Principle Alignment
**Risk:** Low

- principles-base.md was readable (`projects/strategic-os/ai-strategy/principles-base.md`); IDs cited below are from it.
- **OP-5 (advisory ≠ enforcement) — aligned.** The change keeps the hook advisory: exit 2 still feeds the foreign-file list back to the agent with a stop-and-surface message, not a silent auto-correct (hook L14–21, L417–435; commit-discipline.md L21). No advisory→enforcement upgrade.
- **OP-12 (closure before detection) — aligned / actively served.** This adds *no new detection*. It removes two false-positive detection paths (glob-footprint false-block, heredoc false-trigger), making the existing guard correct. Reducing spurious findings is closure-friendly, the opposite of the anti-pattern OP-12 guards against.
- **OP-9 / AP-7 / DR-7 (no speculative abstraction) — aligned.** No generalization for an absent consumer. Both fixes are repairs to a live, firing guard against *recorded, observed* false-fires (improvement-log.md:544–545, observed live 2026-06-11). The inventory shows real current consumers (the footprint-emitting commands, the user-level wiring). No "hooks for later."
- **OP-2 (automate execution, gate judgment) — aligned.** No judgment call is automated or re-gated; the change refines a mechanical guard.
- **OP-11 / OP-3 (loud revision, not silent drift) — not engaged.** No principle is being revised; nothing to surface.
- **DR-1/DR-3 (placement) — aligned.** The fix stays in the canonical hook file in `ai-resources/.claude/hooks/`; correct tier and home. (The wiring lives at user-level by prior recorded decision, entry 521 — not changed here.)

## Mitigations

(Verdict is GO — no mitigations required. Two advisory notes the operator may carry into QC/commit, neither blocking:)

- The CHANGE_DESCRIPTION's wiring-site claim is stale: the hook is wired user-level (`~/.claude/settings.json:61`), not in `ai-resources/.claude/settings.json`. Worth correcting in the improvement-log close note so the next maintainer knows the edit propagates machine-wide (and to Daniel's separate registration) immediately on commit.
- Fix B's heredoc/quote scanner is fail-open by design; if a future exotic shell construct slips a real `git commit` past the guard, that is a missed block (degraded protection), not a false block. Acceptable for an advisory tripwire, but worth a one-line note in the test battery's coverage scope.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: hook body line references (check-foreign-staging.sh L14–55, L92–141, L197–225, L395–435), `~/.claude/settings.json:61` grep, `ai-resources/.claude/settings.json` lines 41–63, `git diff --stat HEAD` (66/10, 1 file), improvement-log.md:521–562 spec/provenance, commit-discipline.md L17–27, session-start.md L280–294, principles-base.md (OP-2/5/9/11/12, DR-7, AP-7). No training-data fallback was used.
