# Risk Check — 2026-06-08

## Change

Edit the load-bearing harness command .claude/commands/prime.md with three behavior-preserving speed edits: (A) add an "Execution discipline" directive instructing the agent to batch independent read-only git/file calls in the orientation steps into a single message instead of running them serially; (B) add a clause in Step 3 to read each backlog file once and filter in-context rather than issuing multiple grep passes; (C) parallelize the Step 1a cross-repo git-log loop by backgrounding only the git log call (& + wait), keeping rev-parse dedup serial and the merge/keyword-match/done-vs-open logic identical. No change to scan breadth (--since window, --all, repos scanned), no change to model:sonnet frontmatter, no edit to docs/backlog-reconciliation.md (confirmed it pins logic not loop topology). Output of the scan is unchanged as a merged unordered set.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/backlog-reconciliation.md — exists (explicitly NOT edited)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Three behavior-preserving speed edits to an isolated-but-load-bearing harness command; no contract, permission, or breadth change, but Edit C restructures the Step 1a shared-primitive scan loop whose logic `docs/backlog-reconciliation.md` declares the reference implementation — the sync-contract and a bash-correctness gap on backgrounded cross-repo git calls drive a single High that is mitigable.

## Consumer Inventory

Search terms: `prime.md`, `/prime`, `backlog-reconciliation`, `reconcile-at-read`, `Step 1a`, "reference implementation". Searched `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `skills/`, `workflows/`, `docs/`, and always-loaded `CLAUDE.md` at both repo and workspace root. Audit/plan/log archives excluded (they document history, do not depend on the contract at runtime).

| Consumer path | Reference type | Must change? |
|---|---|---|
| ai-resources/docs/backlog-reconciliation.md | parses (declares `/prime` Step 1a the "reference implementation" of the merged git scan; the two "must stay in sync") | no (logic unchanged; topology not pinned — see Dim 5) |
| ai-resources/.claude/commands/fix-project-issues.md (reconcile-at-read consumer) | documents (co-invokes the same shared primitive via the doc) | no |
| ai-resources/.claude/commands/fix-repo-issues.md (reconcile-at-read consumer) | documents (co-invokes the same shared primitive via the doc) | no |
| ai-resources/.claude/commands/open-items.md (reconcile-at-read consumer) | documents (co-invokes the same shared primitive via the doc) | no |
| ai-resources/.claude/commands/session-plan.md | invokes (chained after `/prime`; depends on this session's marker-bearing header + `logs/.session-marker` written by `/prime` Step 8) | no (Step 8 write path untouched) |
| ai-resources/.claude/commands/session-start.md | invokes (chained from `/prime` Step 8b/8c; reads `logs/.prime-mtime`) | no (Step 8 write path untouched) |
| ai-resources/.claude/commands/wrap-session.md (canonical + workspace-root sibling) | parses (own-contribution attribution depends on `/prime` Step 8 marker/header/mandate/`.prime-mtime` writes) | no (Step 8 write path untouched) |
| ai-resources/.claude/commands/drift-check.md | invokes (reads marker `/prime` records; tolerant of absence) | no |
| ai-resources/.claude/agents/context-discovery.md | invokes (called by `/prime` Step 8c.4.5) | no (Step 8c.4.5 untouched) |
| ai-resources/.claude/commands/decide.md | documents (cites `/prime` tail-read idiom only) | no |
| ai-resources/.claude/commands/list-critical-resources.md | documents (enumerates `/prime` as a command; uses it as a negative-lookahead example) | no |
| ai-resources/.claude/hooks/detect-concurrent-session.sh | documents (names `/prime` in operator-facing advisory text) | no |

Total: 12 distinct consumers, 0 must-change. The three edits target the **read-only orientation steps** (the implied Step 0 batch, Step 1a scan loop, Step 3 backlog reads). Every consumer that couples to `/prime` couples to its **Step 8 write path** (marker / header / mandate / `.prime-mtime`) or to the **Step 1a scan *logic*** — neither the write path nor the scan logic/output is changed by A/B/C. The one consumer whose concern is closest to the change is `docs/backlog-reconciliation.md` (the shared-primitive sync contract); it is `must-change? = no` only because the change is asserted to touch loop *topology*, not scan logic — that assertion is the load-bearing premise verified under Dimensions 3 and 5.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `/prime` is a pay-as-used slash command, not always-loaded content and not a hook. It runs once per session orient on explicit operator invocation. Adding an "Execution discipline" directive adds a small fixed number of tokens to the command body, loaded only when `/prime` is invoked — no per-turn or per-tool-call cost. Frontmatter `model: sonnet` (prime.md:2) is explicitly unchanged.
- Net direction is *toward lower* runtime cost: Edit A batches serial calls into one message, Edit B replaces multiple grep passes with one read-and-filter, Edit C overlaps git-log latency. The change reduces, not adds, per-invocation tool churn.
- No `@import`, no SessionStart/Stop/PreToolUse/UserPromptSubmit hook, no broad-trigger skill introduced.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `settings.json` edit is in scope. CHANGE_DESCRIPTION names only an edit to `prime.md`; no `allow`/`ask`/`deny` entry is added, removed, or narrowed.
- Edit C introduces a shell idiom (`&` + `wait`) inside the command's bash blocks, but `/prime` already executes `git` and shell loops under the operator's existing bypass/allow posture (Step 1a:54–62 already runs a `for` loop with `git -C ... rev-parse` and `git ... log` per repo). Backgrounding the same already-authorized `git log` call adds no new tool family, path, or external capability.
- No cross-repo *write*, external API, or MCP capability introduced — the backgrounded calls are read-only `git log`.

### Dimension 3: Blast Radius
**Risk:** Medium

- Consumer Inventory: 12 consumers, **0 must-change** (Step 1.5). The change is single-file (`prime.md` only). This bounds the radius substantially — no caller requires modification to keep working.
- The elevated factor above "single isolated file" is the `parses` row: `docs/backlog-reconciliation.md:42` / `:65` / `:101` declares `/prime` Step 1a the **"reference implementation"** of the merged multi-repo git scan, shared by `/fix-project-issues`, `/fix-repo-issues`, `/open-items`, and states "the mechanism here and the doc must stay in sync — if you change the scan/classification logic in one, update the other." Edit C restructures that exact loop (Step 1a:54–62). This is shared infrastructure touched in a way that *could* affect four workflows if the change crossed from topology into logic.
- The CHANGE_DESCRIPTION asserts the sync contract is **not** tripped: the doc "pins logic not loop topology," and Edit C keeps "the merge/keyword-match/done-vs-open logic identical … Output of the scan is unchanged as a merged unordered set." Verified against the doc: `backlog-reconciliation.md:65` ("This is the same merged scan `/prime` Step 1a runs; that is the reference implementation") describes *which repos are scanned and the bounded-by-output property* — i.e., scan breadth and classification — not serial-vs-parallel execution order. The doc's contract is logic + breadth; topology is genuinely out of its scope. So the four reconcile-at-read consumers stay compatible — confirming `must-change? = no`.
- No consumer surfaced by the inventory was un-anticipated by CHANGE_DESCRIPTION; the description named the one consumer (`backlog-reconciliation.md`) that drives this dimension. Medium (not Low) is earned solely because the change edits shared-primitive infrastructure — the radius is contained but not trivially isolated.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to a version-controlled command. `git revert` (or discarding the working-tree edit before commit) fully restores `prime.md` to its prior state within the same working tree. No sibling files or directories are created.
- The change writes nothing to data/log files at edit time — it modifies command *instructions*, not `session-notes.md`, `.session-marker`, or any append-only log. No state propagates beyond the repo (no push in scope, no external write, no symlink, no hook registration that could fire between landing and revert).
- No operator muscle-memory shift: the command name, invocation, menu shape, and outputs are unchanged, so a revert is invisible to the operator's workflow.

### Dimension 5: Hidden Coupling
**Risk:** High

- **Bash-correctness coupling on Edit C (the load-bearing concern).** Edit C backgrounds the cross-repo `git log` call with `&` + `wait` inside the Step 1a loop (prime.md:54–62). The current loop emits each repo's `git log` to stdout and the consumer collects the merged stdout. Backgrounding parallel `git log` writes with `&` interleaves their stdout line-by-line — for `--pretty="%h %s"` output, concurrent writes can corrupt individual lines (partial-line interleaving) unless each backgrounded call writes to its **own** buffer/temp file that is concatenated after `wait`. The CHANGE_DESCRIPTION says "backgrounding only the git log call (& + wait)" but does not state per-call output isolation. If the implementation backgrounds writers sharing one stdout, the "output unchanged as a merged unordered set" guarantee silently breaks on a corrupted commit subject → a keyword-match miss → a likely-DONE item wrongly surfaced as still-open (or vice versa). This is an implicit dependency on a non-obvious shell guarantee that is not visible from the change description.
- **Workspace shell-tied-parameter coupling.** The Bash tool runs via zsh (auto-memory: zsh tied parameters). Edit C's loop reuses `repo`/`d` locals and now adds job-control (`&`/`wait`); a backgrounded subshell in zsh has its own job table — `wait` with no PID waits for *all* background jobs, which is correct here, but any later addition of an unrelated background job in the same block would be silently joined. This is a latent coupling the change introduces but does not document at the change site.
- **Shared-primitive sync coupling (documented, therefore not High on its own).** The `docs/backlog-reconciliation.md` sync contract (Dim 3) is an *explicitly documented* contract at prime.md:42 — the change site already names it. Per the dimension's own calibration, a contract that is documented at the change site is Medium-grade coupling, not High. It is the **undocumented** bash-concurrency contract above that pushes this dimension to High: a new correctness dependency (`&`/`wait` output ordering/isolation) that callers — i.e., the in-context keyword-match pass — silently rely on, with no note at the change site.
- Edits A and B are low-coupling: batching independent calls (A) and read-once-filter-in-context (B) are self-contained behavior-preserving rewrites of read-only steps with no new contract.

### Dimension 6: Principle Alignment
**Risk:** Low

- Read against `principles-base.md` (frozen-ID index, As-of 2026-06-01; readable — no fallback needed) and workspace CLAUDE.md.
- **OP-9 / DR-7 / AP-7 (speculative abstraction):** clear. The change adds **no** generalization, hook, or infrastructure for an absent consumer — it is a narrowing/speed rewrite of existing read-only steps with the Consumer Inventory showing the contract already has live consumers. No "for Phase 2" hooks.
- **OP-10 (system boundary):** clear. Edits stay inside a Claude Code command; no cross-tool (GPT/Perplexity/NotebookLM/Notion) reach added.
- **OP-12 (closure before detection):** clear. The change adds no new detection/scan/flag; it makes an existing scan faster. Step 1a's scan breadth (`--since`, `--all`, repos scanned) is explicitly unchanged.
- **OP-5 (advisory vs enforcement):** clear. `/prime` Step 1a stays advisory ("`/prime` never edits `session-notes.md`", prime.md:70) — the change does not move it toward auto-correction.
- **DR-1 / DR-3 (placement):** clear. Edit stays in the canonical `ai-resources/.claude/commands/` home; no tier or home change.
- **OP-11 / OP-3 (loud revision):** not engaged — no principle is being revised. The change is consistent with the operating principles and actively serves OP-1 (compounding efficiency of the harness) without tripping its OP-9 constraint.

## Mitigations

- **Dimension 5 (High) — output isolation for the backgrounded git-log calls.** Before landing Edit C, require the implementation to write each backgrounded `git log`'s output to its **own** per-repo temp file (or per-repo variable), `wait` for all jobs, then concatenate in any order into the merged set — never let parallel `git log` writers share one stdout/pipe. Add a one-line comment at the Step 1a change site stating this isolation requirement (turning the undocumented bash-concurrency contract into a documented one, which by Dimension 5's own calibration reduces the coupling to Medium/Low). This is the paired action that brings Dimension 5 down from High.
- **Dimension 5 (High) — verify by execution, not review (zsh).** Per the workspace zsh-tied-parameter / "validate shell code by execution" rule, run the edited Step 1a loop against the real multi-repo layout (cwd + ai-resources + ≥1 sibling `projects/*` repo with commits since a test anchor date) and diff the merged result set against the pre-edit serial loop's output. Confirm byte-identical merged sets (order-insensitive) before commit — this is the empirical check that the "output unchanged" guarantee actually holds under backgrounding.
- **Dimension 3 (Medium) — re-read the sync contract after editing.** After Edit C, re-read `docs/backlog-reconciliation.md` § "The git cross-check mechanism" and confirm the edited Step 1a still matches the doc's described breadth/classification (it should, since only topology changed). If any scan-logic line drifted, update the doc in the same commit per the prime.md:42 sync rule. This is the end-time gate's check that topology-only stayed topology-only.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (prime.md line references, backlog-reconciliation.md sync-contract quotes at :42/:65/:101, principles-base.md frozen IDs, audit-discipline.md § Risk-check change classes line 28, grep-derived consumer inventory, and workspace auto-memory zsh/shell rules). No INCOMPLETE dimensions. No training-data fallback was used on fetch/read failures.

## Architectural Commentary

_System-owner second opinion (pre-change advisory, Function B), invoked automatically because the verdict is PROCEED-WITH-CAUTION. `/consult` is operator-only (model-invocation disabled); the `system-owner` agent was invoked directly as the faithful substitute. Full advisory on disk: `projects/axcion-ai-system-owner/output/consultations/consult-2026-06-08-prime-md-speed-edits-pre-change-second-opinion.md`._

**Verdict:** Concur with PROCEED-WITH-CAUTION — **but split the change.** Edit C is the sole driver of the caution; Edits A and B, unbundled, are GO. Recommended move: land A+B now, gate C separately (or drop it).

**Q1 — concurrence.** PROCEED-WITH-CAUTION is correctly calibrated *for Edit C*. A and B carry none of C's risk and are over-gated by being bundled with it.

**Q2 — Edit C mitigation.** Isolate-output-then-concat is the correct way to background safely and is the floor if C ships — but the better answer is to **drop Edit C**: (a) per-repo `git log` is local/fast and already bounded by output not invocation count (prime.md:64), so C's wall-clock payoff is the smallest of the three; (b) the latency the operator feels is serial round-trips in steps 0–4, which Edit A already collapses; (c) C is the only edit touching the reference-implementation guarantee, forcing propagation re-check + execution-diff + same-commit doc sync. High coupling-cost, smallest payoff — poor ROI. If C ships anyway: isolate-then-concat, its own `/risk-check`, execution-diff before commit, `backlog-reconciliation.md` re-read + same-commit sync.

**Q3 — risks the dimension review missed:**
- **Edit A × marker writes — non-issue (verified).** Marker writes live in steps 8a/8b/8c (prime.md 185–220, 299–332), past Edit A's steps 0–4 scope. A cannot reorder them.
- **Steps 0–4 are NOT all independent.** Step 0 establishes `CWD_REPO`/`AI_RESOURCES` (11–14) and Step 1a consumes them (44–62), plus the Step 1 entry-date. Edit A must **name the dependency edges** (Step 0 vars → 1a; Step 1 date → 1a), not just state a bare "batch independent calls" directive — else a future reader could hoist a dependent call.
- **Edit B shifts a token cost.** "Read once, filter in-context" pulls the whole log into context every `/prime` vs grep bounded by match — a token-for-latency trade that scales with log growth. Fine now (consistent with the existing log-trio pre-fetch at 33–38); note it in the commit rationale.
- **Reversibility=Low respected most.** No QC subagent guards `/prime`'s live output; the operator reads the menu as authoritative, so a silent classification flip from C is uncaught — which is why execution-diff is load-bearing if C ships.

**Decision applied:** Land A+B this session (with Edit A naming the dependency edges and Edit B's token note in the commit rationale). Edit C **deferred** — not dropped permanently; parked for a dedicated session with its own `/risk-check` + execution-diff if its payoff is ever judged worth the coupling cost.
