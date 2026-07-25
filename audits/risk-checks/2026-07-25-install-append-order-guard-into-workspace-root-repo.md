# Risk Check — 2026-07-25

## Change

Install the commit-boundary append-order guard into the WORKSPACE-ROOT repo (/Users/patrik.lindeberg/Claude Code/Axcion AI Repo), which currently has no pre-commit hook at all. Two artifacts: (1) copy ai-resources/logs/scripts/check-append-order.sh into the root repo's logs/scripts/ (that directory already exists and holds check-archive.sh + split-log.sh); (2) install ai-resources/.claude/hooks/pre-commit (the tracked canonical copy, 151 lines) as the root repo's .git/hooks/pre-commit, where only .sample files exist today.

VERIFIED PREMISES (each re-derived this session by execution or explicit-path read; instrument named, scope stated):
- Root repo has NO .git/hooks/pre-commit — `ls -1 .git/hooks/ | grep -v '\.sample$'` returns empty. Repo-scoped, correct scope for the claim.
- Root repo has NO logs/scripts/check-append-order.sh, but DOES have logs/scripts/ (a real directory, not a symlink: `ls -ld` shows drwxr-xr-x) containing check-archive.sh and split-log.sh.
- Root repo keeps its own append-to-end logs/session-notes.md and logs/decisions.md, and archiving demonstrably runs there — logs/session-notes-archive-2026-04.md and -05.md exist.
- Root repo had zero prose append-direction warnings until this session's commit 359e8f0, which added them at both write sites. So before today the root repo had NEITHER prose nor mechanical protection.
- The hook is portable by construction: it resolves ao_root via `git rev-parse --show-toplevel`, builds ao_script as ${ao_root}/logs/scripts/check-append-order.sh, and the whole append-order block is wrapped in `if [ -n "$ao_root" ] && [ -x "$ao_script" ]` — so it fails OPEN (silently skips) when the script is absent. Its three guarded log paths are repo-relative: logs/session-notes.md, logs/decisions.md, logs/usage-log.md.
- The same hook also runs a conflict-marker check on every commit (exit 1 on staged conflict markers) and a SKILL.md validation block that early-exits `exit 0` when no SKILL.md is staged.

CORRECTION applied at Step 2.6 (pre-dispatch premise verification), which you should score against rather than the original wording:
- (a) The root repo DOES have logs/usage-log.md (5895 bytes, verified by `ls -l`). So ALL THREE of the hook's guarded paths exist in the root repo, not two. The install protects three files.
- (b) Ordering verified: the conflict-marker and append-order guards sit at hook lines 10-46, BEFORE the SKILL.md `exit 0` at line 57. The hook's own line-10 comment states this is deliberate ("run on EVERY commit, before the SKILL.md early exit"). So in a repo with no skills the guards still run; only the skill-validation tail is skipped.
- (c) The tracked copy at ai-resources/.claude/hooks/pre-commit and the installed ai-resources/.git/hooks/pre-commit are byte-identical (`diff -q` → no differences), both 151 lines. So there is a clean canonical source to install FROM.
- (d) check-append-order.sh is mode -rwxr-xr-x, i.e. executable, so the hook's `[ -x ]` guard would pass once copied.

KNOWN COUPLING TO WEIGH: .git/hooks/ is per-clone and unversioned, so this install is invisible to git and lost on a fresh clone — the same unversioned-wiring defect already tracked as mission repo-health-backlog-2026-07 thread 3 (an installer design scored High/High on /risk-check twice). This change would ADD a second instance of that known-unversioned-wiring problem rather than fix it.

COUNTER-CONSIDERATION: a blocking pre-commit hook in the repo the operator commits workspace-level work from can stall sessions. This workspace has a logged precedent — a deny rule retired 2026-07-18 after it "denied by verb, not effect, and stalled work in 5 sessions".

PURPOSE AND NECESSITY NOTE: this closes a newly-verified exposure behind mission repo-integrity-repairs-2026-07 thread 4. Note carefully for Dimension 7 (Problem Reality): the mission's frozen acceptance assertion 3 requires only PROSE append-direction warnings, and that requirement is ALREADY SATISFIED 4-of-4 as of commits 34d6eeb and 359e8f0. This hook install is therefore belt-and-braces defence-in-depth, NOT required by the mission contract. Score honestly whether the residual risk after the prose fix justifies a second, unversioned, commit-blocking mechanism.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/pre-commit — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.git/hooks/pre-commit — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/scripts/check-append-order.sh — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/scripts/ — exists (dir; holds check-archive.sh, split-log.sh)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.git/hooks/pre-commit — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/scripts/check-append-order.sh — not yet present
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/session-notes.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/decisions.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/logs/usage-log.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists (thread 3, the unversioned-wiring item)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** The change is technically sound, honestly self-disclosed, and consistent with an already-risk-checked precedent (the identical hook is already live in ai-resources), but it carries four ordinary Mediums — a wider footprint than its own description names (the SKILL.md validator goes live for six actively-edited root-repo skill files), an unversioned install that `git revert` cannot undo, a current-state dependency that is nowhere written down, and a claimed consequence that is real in principle but not yet observed in this specific repo.

## Consumer Inventory

| Consumer path | Reference type | Must change? |
|---|---|---|
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.git (root repo's own commit mechanism — every `git commit` in this repo runs the installed hook) | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/commands/wrap-session.md | co-edits | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/mandate-parser/SKILL.md | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-reporter/SKILL.md | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/prompt-hardener/SKILL.md | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/session-governor/SKILL.md | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/failure-mode-detector/SKILL.md | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/skills/verification-playbook/SKILL.md | invokes | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-integrity-repairs-2026-07.md (thread 4) | documents | no |
| /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md (thread 3) | documents | no |

**Total: 10 consumers, 0 must-change.**

Method: grepped `pre-commit` and `check-append-order` as absolute paths across `ai-resources` and the workspace root (not dot-rooted, so the shadowed-`grep` blind spot confirmed by `search-canary.sh` — `SEARCH_CANARY=blind` for dot-rooted walks — does not apply here). The six SKILL.md rows were surfaced independently: `find . -iname SKILL.md -not -path "*/ai-resources/*"` returned 6 hits under `.claude/skills/`, none named in `CHANGE_DESCRIPTION`, each format-checked by direct read (frontmatter, `name:`, `description:`, no prohibited sibling files — all currently compliant) and confirmed under active development (`git log --oneline -5 -- .claude/skills/` shows 5 harness commits). The two mission-log rows are the documents that describe and will need routine updating to reflect this install (no code dependency). Everything else the grep returned (roughly 40 additional hits) was historical audit/risk-check archive prose referencing "pre-commit" in an unrelated context (commit-behavior rules, past due-diligence snapshots) — not live consumers, excluded from the table.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Not a Claude Code hook — confirmed by direct read of `ai-resources/.claude/hooks/pre-commit`: it is a git-native `.git/hooks/pre-commit` script, invoked only by `git commit`, never registered in any `settings.json` `hooks` block. No SessionStart/PreToolUse/Stop registration is added.
- No always-loaded file (workspace or project CLAUDE.md) is touched by this change — neither referenced file is a CLAUDE.md.
- Fires only on `git commit` in the root repo, not per-turn or per-tool-call. Measured actual frequency: `git log --oneline --since="30 days ago" -- logs/session-notes.md logs/decisions.md` → 6 commits touching guarded paths in 30 days — real but low-frequency, and cheap (bash + grep, sub-second) even when it fires.

### Dimension 2: Permissions Surface
**Risk:** Low

- Root repo `.claude/settings.json` already carries `"allow": ["Read","Edit","Write","MultiEdit", ..., "Bash(*)", ...]` with `"defaultMode": "bypassPermissions"` (read directly). Copying a file into `logs/scripts/` and writing `.git/hooks/pre-commit` both fall entirely within the existing, already-broad Write/Bash allow set.
- No `settings.json` edit is part of this change — the change installs two files, it does not touch permission configuration.
- No new tool-invocation class (no external API, no cross-repo write beyond the two named local paths, no MCP surface) is introduced.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer inventory: 10 consumers, 0 must-change (see table above) — no caller is broken.
- The Step 1.5 inventory surfaced a consumer `CHANGE_DESCRIPTION` does not name: the same 151-line hook that is being installed "for the append-order guard" also activates the dormant SKILL.md validator (`pre-commit:50-119`) for six root-repo skill files (`.claude/skills/{mandate-parser,session-reporter,prompt-hardener,session-governor,failure-mode-detector,verification-playbook}/SKILL.md`) that are under active development (`git log --oneline -5 -- .claude/skills/` shows 5 recent harness commits). `CHANGE_DESCRIPTION` does disclose that the hook "also runs ... a SKILL.md validation block," but does not note that root already has 6 live, actively-edited files that block is about to start gating. This is a wider real footprint than "install the append-order guard" implies — per the task instructions, this gap is itself a blast-radius finding.
- All 6 files currently pass every check the validator runs (verified by direct read: `---` opening, `name:`, `description:` present and non-empty, lowercase-hyphenated folder names, no prohibited siblings `README.md`/`CHANGELOG.md`/etc.) — so immediate risk of an unwanted block is low, but the exposure is real for any future edit.
- Shared infra touched: `logs/scripts/` (already holds `check-archive.sh`, `split-log.sh`) and `.git/hooks/` — both are commit-boundary infrastructure the root repo's own `wrap-session.md` writes through every session, but the guard only fires on the 3 named log paths and is additive, not a contract change to any existing caller.

### Dimension 4: Reversibility
**Risk:** Medium

- `logs/scripts/check-append-order.sh` becomes a normal tracked file in the root repo once committed — a clean `git revert` fully removes it.
- `.git/hooks/pre-commit` is **not tracked by git** (universal git behavior — `.git/` is never versioned) — confirmed by the fact that ai-resources' own already-installed copy at `ai-resources/.git/hooks/pre-commit` shows up nowhere in `git log`/`git show` for that repo, and the copy sits outside any commit. `git revert` of the landing commit removes the tracked script but leaves the installed hook file in place, requiring a manual `rm "{root}/.git/hooks/pre-commit"` cleanup step.
- This matches the exact, already-precedented limitation from the prior ai-resources install: `ai-resources/logs/missions/repo-integrity-repairs-2026-07-wave1-correction-plan-v2.md:281` states verbatim: *"`.git/hooks/pre-commit` is not tracked — rollback = revert the tracked file and re-copy it; `git commit --no-verify` is the immediate escape."* Same class of gap, same documented escape hatch (`--no-verify`).
- No state is pushed beyond the local repo and no external write occurs — the extra step is local and single-command, keeping this at Medium rather than High.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The mechanism itself is disclosed, not hidden — `CHANGE_DESCRIPTION` explicitly names the conflict-marker check and the SKILL.md validation block bundled into the same hook.
- One implicit dependency the description does not surface: the append-order guard's safe landing depends on the 6 root-repo SKILL.md files currently complying with the validator's frontmatter rules (verified true today by direct read) — a precondition that exists nowhere in writing as a stated dependency of this install. A future edit that breaks one file's frontmatter would trip a commit block whose origin (an append-order-guard install) is not obvious from the block message alone (the SKILL.md validator's own error text names the failing check, but nothing links it back to "the append-order guard install" for whoever hits it cold).
- No functional overlap with an existing mechanism: root repo has no other append-order or conflict-marker check today (confirmed: no `.git/hooks/pre-commit`, `logs/scripts/` has only `check-archive.sh` + `split-log.sh`, neither of which check ordering at commit time).
- No unexpected auto-firing context: the hook only fires on `git commit`, a context where a commit-time check firing is by definition expected.

### Dimension 6: Principle Alignment
**Risk:** Low

Principles-base read at `projects/strategic-os/ai-strategy/principles-base.md`.

- **DR-7 / OP-9 / AP-7 (speculative abstraction) — actively served, not violated.** This is the textbook non-speculative case DR-7 licenses: the hook + script are already-built, already-verified infrastructure (live in ai-resources since `3878b4d`/`78ecf21`), being extended to a **second confirmed consumer** — the workspace-root repo, independently verified to share the identical append-only/newest-last/`check-archive.sh` architecture, with its own live archive files (`logs/session-notes-archive-2026-04.md`, `-05.md`) and real commit cadence (6 commits/30 days touching the guarded paths). This is not "hooks for Phase 2."
- **OP-5 (advisory vs. enforcement) — a loud, per-component decision, not a silent upgrade.** The install is enforcement (commit-blocking), but it is going through `/risk-check` exactly as `DR-8` requires, and the mission thread that authorizes it explicitly named this as the anticipated closure step: `repo-integrity-repairs-2026-07.md:90` — *"(b) is a structural class (hook install) and needs /risk-check at plan time."* This gate run is that loud decision, not drift.
- **OP-12 (closure before detection) — served.** This ships a closure mechanism (blocks the defect at commit time), not bare new detection with no closure channel.
- **DR-1 / DR-3 (placement) — correct.** `logs/scripts/` and `.git/hooks/` are the established, already-precedented homes, mirroring the identical ai-resources layout exactly.
- **Complexity-budget gate (`docs/ai-resource-creation.md` rule 7)** — this does add a new mandatory gate to a repo that had none, so it must clear prong (a) or (b). It does not net-simplify (fails a). Prong (b)'s cited evidence (`c3d5fe7`, a real shipped mis-ordering defect) is from the sibling ai-resources repo, not a literal workspace-root incident — a thin point, noted honestly — but the failure *mode* is evidenced with a real, shipped incident, and the workspace-root repo is independently confirmed to run the identical architecture that made that incident possible. This is materially different from "we might need it" speculation. Scored Low rather than Medium because the mission's own prior, already-risk-checked plan (`...wave1-correction-plan-v2.md`) pre-negotiated this exact deployment as the correct next step, and the necessity question itself is the subject of the honest Medium finding under Dimension 7, avoiding double-counting the same concern here.

### Dimension 7: Problem Reality
**Risk:** Medium

- **Defect — observed or inferred?** Observed, by direct execution, not asserted. `ls -1 .git/hooks/ | grep -v '\.sample$'` on the root repo returned empty (no pre-commit hook installed). `ls logs/scripts/check-append-order.sh` on the root repo returned "No such file or directory." Both the absence of the mechanical guard and the (now-closed) absence of prose warnings were independently re-derived, not taken on the caller's word.
- **Consequence — traced or assumed?** Assumed for this specific repo, though the underlying failure mode is real and traced elsewhere. The claimed consequence — "a prepended entry is read as oldest and archived" — is a demonstrated, shipped failure in the **sibling** ai-resources repo (`c3d5fe7`), and the workspace-root repo is confirmed to share the identical bottom-ordering, `check-archive.sh`-driven architecture (own archive files exist as proof archiving runs there). But no prepend-then-mis-archive incident has actually occurred **in the workspace-root repo** — that specific consequence has not been traced to a caller or reproduced here; it is extrapolated from the sibling repo's precedent. This matches the note in `CHANGE_DESCRIPTION` itself, which correctly frames the install as "belt-and-braces defence-in-depth, NOT required by the mission contract" — the mission's frozen acceptance assertion 3 (prose-only) is independently confirmed satisfied 4-of-4 by direct read of both `wrap-session.md` copies (root repo lines 87, 148; ai-resources canonical lines 123, 132) and by opening commits `359e8f0` and `34d6eeb` directly (both exist, both do exactly what their subject lines claim).
- **Re-derivation vs. the change description:** None — all claims re-derived and confirmed. Every count, byte size, line number, and commit hash in `CHANGE_DESCRIPTION` and its Step-2.6 correction checked out exactly: `.git/hooks/` empty of non-sample files; `logs/usage-log.md` = 5895 bytes; both hook copies = 151 lines via `wc -l` and byte-identical via `diff -q`; hook lines 10-46 (guards) precede line 57 (`exit 0`); `check-append-order.sh` is `-rwxr-xr-x`; commits `359e8f0` and `34d6eeb` exist and match their stated content.
- This is not a fabricated or exaggerated premise — it is a real, correctly-scoped, honestly-labeled residual-risk closure whose urgency (not its existence) is the only unproven element. Per the dimension's own calibration, a real-but-untraced-consequence defect is Medium, not High.

## Mitigations

- **Blast Radius (Medium):** Before landing, state explicitly in the install commit message that the hook also activates SKILL.md validation for `.claude/skills/*/SKILL.md` (6 files, currently compliant) — not only the append-order guard — so a future blocked commit on an Agent Harness skill file is traceable back to this install rather than rediscovered cold.
- **Reversibility (Medium):** Record the exact rollback command in the same commit message: `rm "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.git/hooks/pre-commit"` (no pre-existing file is being overwritten, so rollback is a bare delete, not a restore-from-backup) — and note `git commit --no-verify` as the immediate per-commit escape, matching the ai-resources precedent's documented pattern.
- **Hidden Coupling (Medium):** Add a one-line comment or a `logs/decisions.md` note naming the implicit dependency — "this install assumes the 6 current `.claude/skills/*/SKILL.md` files stay format-compliant; a validator failure on one of them will read as an unrelated block unless traced back here."
- **Problem Reality (Medium):** No technical mitigation needed — the finding is that urgency is unproven, not that the defect is fabricated. Land as the disclosed defense-in-depth measure it is (normal sequencing, not an emergency fix). Optionally, run the equivalent of `pre-commit-hook.test.sh` ARM E (temp repo, staged prepend) against the **root repo's real paths** once installed, to convert "the mechanism should work here" into a demonstrated, repo-specific pass — closing the traced-vs-assumed gap for the mechanical function even though real-world urgency stays unproven by design.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files, or explicit INCOMPLETE flags). No training-data fallback was used on fetch/read failures.
