# Risk Check — 2026-06-09

## Change

Harden /prime (.claude/commands/prime.md) Step 0 pull-result classification to detect an autostash pop-conflict that returns exit code 0. Current behavior: Step 0 classifies `git pull --rebase --autostash` purely by exit code (Exit 0 + "Already up to date" → `up to date`; Exit 0 otherwise → `updated`; non-zero → `failed`/`skip`). An autostash POP conflict prints "Applying autostash resulted in conflicts. Your changes are safe in the stash." but returns exit 0, so it is misclassified `updated`; Step 4 only carries the pull result to the brief on "failure or unpushed commits", so the conflict is invisible — /prime shows a clean brief while the working tree has conflict markers in a tracked file and a stranded stash@{0}. Proposed fix (3 edit points, all in prime.md): (1) Step 0 — after each pull, in addition to exit-code classification, detect the conflict-pop path by checking captured output for "Applying autostash resulted in conflicts" OR a residual autostash entry in `git stash list` OR a conflicted (`UU`) `git status` state; when detected, set a new result state `autostash-conflict`. (2) Step 4 "Pull result" exception-carry — change "carry forward the step 0 result only on failure or when there are unpushed commits" to ALSO carry on `autostash-conflict`. (3) Step 6 brief template — add an exception line `⚠ Pull: autostash pop conflicted — working tree has conflict markers; stash@{0} preserved`. No behavior change to the success/failure paths; purely additive detection of a currently-silent state. Reversible single-file edit. Source: improvement-log.md entry "2026-06-09 — /prime Step 0 silently swallows an autostash pop conflict", verified by S2 sandbox test at audits/working/2026-06-09-S2-prime-autostash-path-test.md.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/improvement-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/working/2026-06-09-S2-prime-autostash-path-test.md — not yet present

## Verdict

GO

**Summary:** A single-file, additive edit to canonical `prime.md` that surfaces a currently-silent error state; no contract is parsed by any external consumer, the 18 symlinked copies inherit the edit automatically, and the change actively serves the loud-failure principle (OP-3).

## Consumer Inventory

The change targets three internal regions of `prime.md`: Step 0 pull-result classification, Step 4 "Pull result" exception-carry, and the Step 6 brief template. Search terms used: `prime.md`, `/prime`, `autostash`, `autostash-conflict`, `Pull result`, `.prime-mtime`, `Applying autostash resulted`. Grep run across `{AI_RESOURCES}` and the workspace root one level up.

Key inventory facts:
- The new state token `autostash-conflict` and the marker string `Applying autostash resulted in conflicts` have **zero existing references** anywhere in the repo or workspace (grep returned empty) — this is a brand-new internal token, parsed by nobody.
- The `⚠ Pull:` brief line is a render-only output of Step 6; no command reads `/prime`'s rendered brief as a parse contract.
- 18 of the 20 `prime.md` files in the workspace are **symlinks to the canonical file** — they receive the edit automatically (reference type `imports`), no co-edit needed.
- 2 `prime.md` files are independent (non-symlink) regular files: the canonical one (the edit target) and `workflows/research-workflow/.claude/commands/prime.md`. The research-workflow copy is an older, simpler `/prime` with **no Step 0 pull logic at all** — it does not depend on the changed contract and is a divergent fork, not a consumer.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `.claude/commands/prime.md` (canonical) | co-edits (the edit target itself) | yes |
| Workspace-root `.claude/commands/prime.md` (symlink → canonical) | imports | no |
| `harness/.claude/commands/prime.md` (symlink → canonical) | imports | no |
| 15 `projects/*/.claude/commands/prime.md` + `knowledge-bases/pe-kb-vault/...` + `archive/...` (all symlinks → canonical) | imports | no |
| `workflows/research-workflow/.claude/commands/prime.md` (independent fork, no Step 0 pull logic) | documents (name only; no contract dep) | no |
| `logs/improvement-log.md` (source entry) | documents | no |

Total: 21 distinct consumers (1 canonical edit target + 18 symlink inheritors + 1 divergent fork + 1 source-log entry); **1 must-change** (the canonical file itself). No consumer parses the pull-result state token, the `⚠ Pull:` brief line, or the new `autostash-conflict` value. The marker string and new state token have zero existing references — confirming this introduces a fresh internal contract with no current consumer to break.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/prime` is universally invoked at session start, so it is a frequently-run command — but the change adds no per-turn or per-tool-call cost. The detection runs once per repo per `/prime` invocation, inside Step 0's already-batched pull block (prime.md:13-33).
- Marginal runtime cost is at most one extra `git stash list` and/or `git status` read per pulled repo, plus a substring check of already-captured `git pull` output — all read-only and pay-as-used, not always-loaded.
- Token cost to the always-loaded layer is zero: `prime.md` is a command body loaded only when `/prime` runs, not an always-loaded CLAUDE.md or `@import`. The 3 edit points add a modest amount of command-body prose (one classification branch, one carry-condition clause, one brief-template line) — well under the always-loaded thresholds, and not on the always-loaded path at all.

### Dimension 2: Permissions Surface
**Risk:** Low

- No settings.json change. No new `allow`/`ask` entry, no `deny` removal.
- The detection uses `git stash list` and `git status` — both read-only git commands already used throughout `prime.md` (e.g., `git status --short` at prime.md:103, :151; `git stash` family is within the established read-only git pattern the command already exercises). No new tool family, no Write path, no external API.

### Dimension 3: Blast Radius
**Risk:** Low

- Consumed directly from the Step 1.5 inventory: 21 consumers, **1 must-change** (the canonical `prime.md` itself). All 18 symlink copies inherit the edit with no separate action.
- No `parses` consumer exists: grep for `autostash-conflict` and `Applying autostash resulted` returned zero hits, confirming the pull-result state is internal to `/prime` and read by no other command. The `⚠ Pull:` brief line is render-only output, not a downstream parse contract (contrast the `**Mandate:**` line at prime.md:518, which IS a documented four-reader parse contract — this change does not touch it).
- The new `autostash-conflict` state is a backwards-compatible addition: the success/`up to date`/`updated`/`failed`/`skip` paths are unchanged (CHANGE_DESCRIPTION: "No behavior change to the success/failure paths; purely additive detection of a currently-silent state"). The Step 4 carry condition is widened (carry ALSO on `autostash-conflict`), which only adds a brief line that was previously suppressed — no existing carry behavior is removed.
- No unanticipated consumer surfaced: the one independent fork (`workflows/research-workflow/.claude/commands/prime.md`) has no Step 0 pull logic, so it neither inherits nor needs the change. Worth a one-line note to the operator that this fork already diverges from canonical `/prime` on Step 0 generally — but it is pre-existing drift, not introduced by this change.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to one regular file (`prime.md`); the 18 symlinks revert automatically with it. `git revert` fully restores prior state within the working tree.
- No data/log mutation, no settings.json cached state, no external push, no automation (hook/cron/symlink) added that could fire between landing and revert. CHANGE_DESCRIPTION states "Reversible single-file edit" and the file-system evidence confirms it.
- The new `autostash-conflict` state leaves no persistent artifact on disk — it is a transient classification computed at `/prime` time, not written anywhere a revert would have to clean up.

### Dimension 5: Hidden Coupling
**Risk:** Low

- The change creates a new internal contract (the `autostash-conflict` state token + the marker-string match) but that contract is **fully self-contained within `prime.md`**: Step 0 sets it, Step 4 reads it, Step 6 renders it — all three sites are in the same file and the same change. No external caller must honor it.
- One implicit dependency on git's own output string: the detection keys partly off the literal phrase `"Applying autostash resulted in conflicts"`. This is a git-version-dependent message that could change across git releases. However, the design is robustly degraded: CHANGE_DESCRIPTION specifies the detection is an OR of three independent signals — the output string OR a residual `git stash list` entry OR a `UU` `git status` state. The two state-based signals (stash-list residue, conflicted index) do not depend on the exact wording, so a message-string change in a future git would not blind the detector. Note this as the one coupling to track, mitigated by the multi-signal design.
- No silent auto-firing in an unexpected context: the detection runs only inside `/prime` Step 0, the same place the pull already runs. No functional overlap with another mechanism — nothing else currently detects this state (that is precisely the gap being closed).

### Dimension 6: Principle Alignment
**Risk:** Low

- The change directly serves **OP-3 (Loud failure over silent continuation)** and the `/prime` command's own stated principle ("Prime never asserts state from a single source", prime.md:7): it converts a currently-silent failure (a conflicted working tree shown under a clean brief) into a surfaced exception line. This is the principle working *for* the change.
- **OP-9 / AP-7 / DR-7 (speculative abstraction):** not triggered. Although the new `autostash-conflict` token has zero current consumers, it is not a speculative hook for an absent future consumer — it is the minimum state needed to surface a *real, observed* failure (improvement-log entry 2026-06-09, verified by the S2 sandbox test). The token is consumed within the same change (Step 4 + Step 6), so there is no dangling generalization.
- **OP-5 (advisory vs enforcement):** the change stays advisory — it adds a brief line that *names* the conflict; it does not auto-resolve the conflict, drop the stash, or run `git checkout`. No enforcement upgrade.
- **OP-12 (closure before detection):** satisfied. The new detection ships with its closure channel in the same change — the Step 6 brief line tells the operator exactly what to fix (conflict markers present; stash@{0} preserved), so the finding is surfaced to a human who closes it. It is not a detector that generates findings into a void.
- **DR-1 / DR-3 (placement):** correct — the edit lives in the canonical command at `ai-resources/.claude/commands/`, the fixed home for slash commands.
- Note on the referenced `not yet present` file: `audits/working/2026-06-09-S2-prime-autostash-path-test.md` is the sandbox-test evidence cited as verifying the failure path. It was not read (tagged not-yet-present). The principle-alignment judgment above does not depend on it — the failure is independently legible from the git-mechanics description in CHANGE_DESCRIPTION (autostash pop conflict returns exit 0). The principles-base index was readable and IDs are cited from it.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `prime.md` line citations (Step 0 at :13-33, Step 4 Pull-result at :153, Step 6 brief template at :185, Mandate parse contract at :518, git-status uses at :103/:151, command principle at :7); symlink-vs-regular determination via `find -print0 | readlink` over all 20 `prime.md` files in the workspace; grep counts for `autostash-conflict` and `Applying autostash resulted` (zero hits) and for `prime.md` / `/prime` references across `{AI_RESOURCES}` and the workspace root; principle IDs (OP-3, OP-5, OP-9, OP-12, AP-7, DR-1, DR-3, DR-7) cited from the readable `principles-base.md` index. No training-data fallback was used on any read.
