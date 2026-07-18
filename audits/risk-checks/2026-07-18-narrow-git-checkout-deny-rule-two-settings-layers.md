# Risk Check — 2026-07-18

## Change

PROPOSED CHANGE — narrow the over-broad `Bash(git checkout *)` deny rule in two settings layers.

TARGET FILES (2 edits + 1 doc):
- `/Users/patrik.lindeberg/.claude/settings.json` line 47 — user-level, OUTSIDE any git repo (not revertible by git revert; rollback is manual restore)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` line 27 — workspace root, git-tracked
- `ai-resources/docs/permission-template.md` — canonical deny-list shape, update to match

CURRENT STATE (verified this session by execution, not recalled):
Both files carry `"Bash(git checkout *)"` in their deny array. Confirmed live and enforcing: `git checkout --help` — a command that cannot modify a byte — was DENIED this session. `defaultMode: bypassPermissions` is set in both and does not waive it.

PROPOSED REPLACEMENT (candidate deny set, replacing the single blanket entry):
  "Bash(git checkout .)"
  "Bash(git checkout -- *)"
  "Bash(git checkout * -- *)"
  "Bash(git checkout * .)"
  "Bash(git checkout -f*)"
  "Bash(git checkout --force*)"
  "Bash(git checkout -p*)"
  "Bash(git checkout --patch*)"

GIVEN STATE — the caller has already derived the following. SPOT-CHECK and EXTEND rather than rebuilding from scratch (per the 2026-07-18 usage-log recommendation on not re-deriving caller-held inventories). Challenge any of it you find wrong — do NOT take it on trust, but do not spend 20 tool calls reproducing what is already stated unless a spot-check fails.

(a) fnmatch scoring of 21 commands against three sets — today's blanket rule, the REFUTED 2026-07-14 set, and the candidate. Results: today's blanket = 9 safe forms wrongly blocked. 2026-07-14 set = 8 destructive forms wrongly ALLOWED. Candidate = 0 mismatches. The 2026-07-14 set was included as a control and the test reproduced its known failure, so the test is falsifiable rather than confirmatory.

(b) Destructive forms the candidate must block (and does): `git checkout .`, `git checkout -- <path>`, `git checkout -- .`, `git checkout HEAD -- <path>`, `git checkout main -- <path>`, `git checkout HEAD .`, `git checkout HEAD~1 -- <path>`, `git checkout -f`, `git checkout -f main`, `git checkout --force main`, `git checkout -p`, `git checkout --patch <path>`.

(c) Safe forms the candidate must allow (and does): `git checkout <branch>`, `-b`, `-B`, `-`, `--ours <path>`, `--theirs <path>`, `--help`, `--detach`, `--track origin/<b>`.

(d) Matcher semantics CONFIRMED against official Claude Code docs this session (not assumed): mid-pattern `*` is supported and spans spaces; compound commands split on `&&`/`||`/`;`/`|`/`&`/newlines with each subcommand matched independently; deny is evaluated before allow and cannot be overridden by an allow rule or by bypassPermissions.

(e) KNOWN LIMITATION, stated up front rather than discovered by you: Anthropic's docs explicitly warn that Bash patterns constraining ARGUMENTS are fragile — evadable by variable expansion (`P=. && git checkout $P`), option reordering, and similar shell features. The caller is therefore claiming this is a GUARDRAIL AGAINST ACCIDENT, not a security boundary. Judge whether that claim is honest and whether the threat model justifies the change.

PRIOR VERDICT THAT MUST BE RECKONED WITH — do not let the caller bypass it:
This exact change class returned RECONSIDER on 2026-07-14 with Permissions scored High (`audits/risk-checks/2026-07-14-batched-repo-repair-marker-grammar-hook-wiring-deny-rules.md`, verdict token at :45, Dimension 2 High at :101-102). Two things differ now and the caller wants them tested, not accepted:
  1. That RECONSIDER was on a SEVEN-ITEM BUNDLE (install-hooks.sh writing ~/.claude/settings.json, a marker-grammar change across 24 symlinked commands, hook edits, doctrine changes). Its High scores on Blast Radius (26 consumers / 19 must-change) and Reversibility were driven largely by those other items. This change is UNBUNDLED. Does unbundling actually lower those dimensions, or is the caller rationalising?
  2. Dimension 2's High was earned by the deny set ITSELF — the prior reviewer proved the proposed set re-opened three destructive forms (`git checkout HEAD -- f.txt`, `git checkout main -- f.txt`, `git checkout HEAD .`). That finding is specific and survives unbundling. The candidate set is designed to close exactly that hole (and five more the prior review did not name). Verify independently that it does.

PROBLEM REALITY: OBSERVED, not inferred. The block was reproduced by execution this session (`git checkout --help` denied — the permission system returned a denial). Mission thread 4 (line 81 of the mission file) records 5 logged work stalls, once freezing both open sessions mid-merge.

OUT OF SCOPE (do not recommend touching): the `"model": "opus[1m]"` field in ~/.claude/settings.json — operator-DECLINED 2026-07-13, must not be modified while editing that file. Also out of scope: the archive `Read()` deny patterns (verified a separate, wrongly-routed item).

CONTEXT: mission thread 4 of `logs/missions/repo-health-backlog-2026-07.md`. Mission non-negotiable: verify by execution, not by reading.

---

SPECIFIC QUESTIONS I WANT ANSWERED IN YOUR DIMENSIONS (in addition to your standard rubric):

1. Is there any destructive `git checkout` form the candidate set still leaves allowed? Enumerate what you test. Pay particular attention to forms the caller may not have considered: `git checkout <branch> <pathspec>` without `--`, pathspecs with globs, `git checkout @{-1} -- path`, `git checkout :/pattern`, `--pathspec-from-file`, `--overwrite-ignore`, `--merge`/`-m`, and any form where the pathspec precedes the tree-ish.
2. Does any pattern in the candidate set over-block a safe form the caller did not test? Consider branch names containing spaces or dots, `git checkout "branch with space"`, and `git checkout release/1.0 .` style edge cases.
3. Given that deny-pattern argument matching is documented-fragile, is a settings-layer fix the right instrument at all — or should this move to the already-wired `check-destructive-liveness.sh` PreToolUse hook, which can parse the command properly? Note that mission thread 3 has established hook WIRING is unversioned (a fresh clone loses it), so a hook-based fix inherits that weakness. Weigh both.
4. Does unbundling genuinely reduce Blast Radius and Reversibility versus the 2026-07-14 bundle, or is that reasoning motivated?

## Referenced files

- /Users/patrik.lindeberg/.claude/settings.json — exists (deny entry at :47)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json — exists (deny entry at :27)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/permission-template.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/risk-checks/2026-07-14-batched-repo-repair-marker-grammar-hook-wiring-deny-rules.md — exists (the prior RECONSIDER)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/missions/repo-health-backlog-2026-07.md — exists (thread 4, line 81)

## Verdict

**PROCEED-WITH-CAUTION**

**Summary:** The defect is real and independently reproduced (I denied `git checkout --help` myself), the candidate is a genuine, carefully-tested improvement over both today's blanket rule and the 2026-07-14 refuted set (closes all 12 previously-known destructive holes, restores all 9 safe forms with zero over-blocking) — but my own execution found the candidate still leaves open the single most common real-world accidental-discard form (`git checkout <file>`, no `--`), an architecture the repo's own improvement-log explicitly told future sessions not to repeat, and that specific prior lesson is not acknowledged anywhere in this change.

## Consumer Inventory

Search terms used: `Bash(git checkout`, `git checkout *` (literal deny-pattern text), `permission-template`, plus direct checks of `check-permission-sanity.sh`, `permission-sweep.md`, and `templates/project-settings.json.template` for hardcoded references to this specific pattern. Run from the workspace root and `ai-resources/`, excluding `.git`.

| Consumer path | Reference type | Must change? |
|---|---|---|
| `/Users/patrik.lindeberg/.claude/settings.json:47` | is the target (edit itself) | yes |
| `.claude/settings.json:27` (workspace root) | is the target (edit itself) | yes |
| `ai-resources/docs/permission-template.md` — Layer B canonical shape (`:72`, shows the exact pattern) | documents | yes |
| `ai-resources/docs/permission-template.md` — Layer A canonical shape (`:38-40`, deny floor listed as `rm -rf`/`sudo` **only** — does NOT show `git checkout`/`git reset --hard` even though the actual `~/.claude/settings.json` carries both) | documents (pre-existing doc/actual drift, not caused by this change but not closed by it either) | yes — **not named by the caller's "1 doc" framing** |
| `ai-resources/logs/improvement-log.md:949-956` (2026-07-14 entry, Status: OPEN) | tracks/documents; mission non-negotiable requires flipping status when the fix lands | yes |
| `ai-resources/logs/missions/repo-health-backlog-2026-07.md` (thread 4, `:81`) | tracks; mission contract requires closing via `/mission close`, not hand-edit | yes |
| `ai-resources/.claude/hooks/check-permission-sanity.sh` — safety-floor check hardcodes only `Bash(rm -rf *)`/`Bash(sudo *)` (`:53-63`) | parses (confirmed does NOT reference this pattern) | no |
| `.claude/commands/permission-sweep.md` | documents `permission-template.md` generically; no hardcoded deny-array literals found | no |
| `ai-resources/templates/project-settings.json.template` | checked — Layer D never carried this rule; zero hits | no (not a consumer) |
| `projects/project-planning/Project Plans/agent-harness/tech-spec-v1.md`, `v2.md` | documents (illustrative example config for an unrelated project, out of mission scope) | no |

**Total: 6 must-change consumers** (2 named target files + 4 discovered: one doc-shape gap the caller's "1 doc" framing under-scoped, plus two log/mission closure obligations required by this mission's own non-negotiable "close the entry when the fix lands, not as follow-up"). **Consumer the change description did not fully anticipate:** `permission-template.md`'s Layer A canonical shape (the section describing `~/.claude/settings.json`) does not list `git checkout`/`git reset --hard` at all — a pre-existing drift from the live file. The caller's "update the canonical deny-list shape" (singular) risks updating only the Layer B block (which does show the pattern) and leaving Layer A's shown shape stale a second time. No runtime/code coupling was found — this is a narrow, well-contained change by the letter of the inventory.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- No content added to any always-loaded `CLAUDE.md`. `permission-template.md` is referenced by pointer only, never `@`-imported (confirmed: repo-snapshot audit in `artifacts/merged-os-context/management-os/pipeline/repo-snapshot.md:13` states `ai-resources/CLAUDE.md` "contains no `@import` references").
- No new hook registered; no change to hook trigger frequency. `check-permission-sanity.sh`'s SessionStart wiring is untouched (confirmed: it hardcodes only `rm -rf`/`sudo`, not this pattern).
- Pay-as-used: a settings.json deny-array edit has zero per-turn or per-session token cost.

### Dimension 2: Permissions Surface
**Risk:** Medium

- **Re-derivation of the caller's fnmatch matrix (executed, not trusted): confirmed exactly.** Blanket rule wrongly blocks 9/9 tested safe forms; the REFUTED 2026-07-14 set wrongly allows 8/12 tested destructive forms; the candidate mismatches 0/21. My own Python `fnmatch.fnmatchcase` re-implementation, run independently, reproduced all three counts precisely.
- **Q1 answer — a genuine destructive hole remains, and it is the most common one.** I tested 13 additional forms directly responsive to the caller's own Question 1 hint list. `git checkout somefile.txt` (bare pathspec, no `--`, no tree-ish) — the single most common real-world "discard my uncommitted edits" git accident — is **ALLOWED** by the candidate set (executed: `fnmatch.fnmatchcase` against all 8 patterns, no match). Same result for `git checkout *.txt` (bare glob pathspec), `git checkout main somefile.txt` / `git checkout HEAD somefile.txt` (tree-ish + pathspec, no `--`), `git checkout --pathspec-from-file=paths.txt HEAD` (a real, documented git-checkout flag that discards working-tree changes to every listed path), `git checkout -m mybranch` / `--merge`, and `git checkout --overwrite-ignore mybranch`. `git checkout @{-1} -- path` and `git checkout :/fix -- path` ARE correctly denied (both contain the literal ` -- ` substring pattern 3 requires) — the caller's set handles those two correctly.
- **Q2 answer — no over-blocking found on the edge cases tested.** `git checkout "branch with space"`, `git checkout release/1.0`, `git checkout v1.2.3` (dotted tag) all correctly stay allowed. `git checkout release/1.0 .` is correctly **denied** — this is not an over-block: a bare `.` pathspec after any tree-ish discards the entire working directory from that tree, exactly as destructive as `git checkout HEAD .`. The candidate's safe-side precision holds up under my extended test set.
- **Tested whether the bare-pathspec gap can be closed by a 9th pattern (executed).** `git checkout --pathspec-from-file*` closes that specific flag cleanly with zero over-blocking (verified against `--pathspec-from-file=...`, `--patch`, `--help`, `mybranch`). But a pattern attempting to catch the `<tree-ish> <pathspec>`-no-`--` form (`git checkout [!-]* [!-]*`) **reintroduces exactly the over-blocking problem this redesign exists to fix**: executed test shows it correctly denies `git checkout main somefile.txt` but also **wrongly denies `git checkout "branch with space"`** — a safe form the candidate currently allows. This is not a "try harder" gap; it is structurally irreducible via glob patterns, because a single bare token cannot be classified safe-vs-destructive without asking git whether it resolves to a ref (branch-switch, safe) or not (pathspec-discard, destructive) — information no static pattern can have.
- **Mitigating context, independently found, not raised by the caller:** `git restore <file>` — the modern, git-recommended equivalent of `git checkout -- <file>` — achieves identical destructive discard and is **completely unguarded by any deny pattern in either settings.json file, today and after this change** (confirmed: grepped both files for `git restore`, zero hits). This means the "new" residual risk this change leaves open was never actually closed by the blanket rule either — equivalent capability was always one verb away. This substantially tempers the severity of the Q1 finding without eliminating it.
- Net: this is a real, tested, well-evidenced improvement over both the current state and the refuted 2026-07-14 set on every dimension the caller tested — but it is not the complete closure the caller's synthesis language ("designed to close exactly that hole... and five more the prior review did not name") implies. Widening from "100% blocked" to "~95% allowed" on a data-loss-capable verb, with a residual gap in the most common accident shape, is Medium rather than Low; it is not High because the residual gap is structurally irreducible at this layer, already exploitable via an unrelated unguarded verb, and the caller's own item (e) already frames this honestly as an accident-guardrail, not a security boundary.

### Dimension 3: Blast Radius
**Risk:** Low

- Per the Step 1.5 inventory: 6 must-change consumers, 0 requiring code/runtime modification (the two settings.json edits are the fix itself; the remaining 4 are doc/log-closure obligations, not functional dependents).
- No command, agent, hook, or skill parses this specific deny-pattern text (`check-permission-sanity.sh` and `permission-sweep.md` both confirmed clean by direct grep).
- The one gap the inventory surfaced that the change description did not name: `permission-template.md`'s Layer A shape doesn't list this rule at all, so "update the doc to match" is under-scoped by one location — small, but real, and easy to miss precisely because the caller's own framing ("1 doc") implies a single edit site.
- **Q4 answer:** unbundling genuinely lowers this dimension, not just rhetorically. The 2026-07-14 bundle's Blast Radius High was driven by 26 consumers / 19 must-change across a marker-grammar rewrite touching 24 symlinked commands, two independent hook-script copies, and a new SessionStart probe — none of which are present here. This change touches exactly the deny array in two files plus their doc/log closure. The caller's unbundling claim is not motivated reasoning; it is a materially different (and much smaller) change shape.

### Dimension 4: Reversibility
**Risk:** Medium

- The workspace-root `.claude/settings.json` edit is git-tracked; `git revert` fully restores it.
- The user-level `~/.claude/settings.json` edit is outside any repo, exactly as the caller flags. This is a single-array, single-file edit (8 lines back to 1), not a multi-step migration and not an external/third-party write — a plain "restore from backup" closes it in one step, which is why this scores Medium rather than High (the 2026-07-14 bundle's Reversibility High was earned by `install-hooks.sh` writing external state via a script with no simple undo path — a materially different, more complex shape than a direct one-line array edit here).
- **Q4 answer (continued):** yes, unbundling lowers this dimension too — there is no installer script, no multi-file migration, and no append-only log mutation in the two target-file edits themselves. What remains Medium is intrinsic to the user-level file being outside git at all, not to bundling.
- No mitigation is needed to avoid Reversibility risk entirely — a pre-edit backup of `~/.claude/settings.json` reduces this to Low (see Mitigations).

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The candidate's correctness depends entirely on Claude Code's Bash-permission matcher having exactly the semantics claimed in item (d) — mid-pattern `*` spanning spaces, deny-before-allow, unoverridable by `bypassPermissions`. I do not have a WebFetch/WebSearch tool in this reviewer context and could not independently re-fetch Anthropic's docs to confirm the claim at its source. I can only say it is **consistent with directly observed behavior**: my own `git checkout --help` denial and my `git checkout -- <non-archive-path>` denial (both reproduced this session) match what the claimed semantics predict, and my independent fnmatch re-implementation matched the caller's 21-command matrix exactly. This is corroboration, not independent verification of the primary source — note it as a limitation rather than resolve it by assumption.
- No regression fixture exists for permission deny patterns anywhere in the repo (unlike `run-manifest.test.sh` or `prime-allocator.test.sh` for other config-shaped artifacts) — a future edit to this array has no mechanical safety net; correctness rests entirely on this one-time review.
- The edit target (`~/.claude/settings.json`) also holds the operator-declined `"model": "opus[1m]"` field in the same top-level object, a few lines away from the deny array. This is a real adjacency risk for any tool-assisted (non-manual) edit of the file — worth a specific caution, not a blocker.
- No functional overlap with another existing mechanism was found — this deny array is the sole guard on `git checkout`, and `check-destructive-liveness.sh` (the other destructive-op guard in this repo) explicitly does not cover this verb (confirmed by reading its gated-verb list: `worktree remove`, `branch -d/-D`, `reset --hard`, `clean -f` — `checkout` and `restore` are absent).

### Dimension 6: Principle Alignment
**Risk:** Medium

Principles read from `projects/strategic-os/ai-strategy/principles-base.md` (present and readable).

- **OP-11 (loud revision, never silent drift) — tension, not clearly resolved.** `ai-resources/logs/improvement-log.md:953` records, from the 2026-07-14 attempt on this exact deny rule: *"A deny-list of destructive forms is the wrong shape, because the destructive set is open-ended. **The correct redesign is an allow-list inversion. Do not attempt the enumerate-the-bad-forms approach again.**"* The current candidate is a more careful, better-tested enumerate-the-bad-forms deny list — the exact architecture that entry told future sessions not to repeat — and my own Dimension 2 testing reproduced the predicted failure mode (an open-ended residual gap: bare pathspec discard). Nothing in `CHANGE_DESCRIPTION` cites or reconciles this specific prior verdict; item (e) acknowledges general argument-matching fragility from Anthropic's docs, but not this repo's own more specific "do not repeat this shape" lesson. This is closer to silent repetition than a loud, deliberate revision — OP-11's bar. It is Medium rather than High because the change is a materially more careful attempt than the one the log warned about (closes 12 previously-open forms cleanly, zero new over-blocking found), and because a concrete, low-cost path to making the revision loud exists (see Mitigations) rather than requiring a rescope.
- **DR-8 — honoured.** This is exactly the gated change class routed through plan-time `/risk-check`, as required.
- **OP-9 / AP-7 / DR-7 (speculative abstraction) — not engaged.** This fixes a confirmed, currently-live defect with a present consumer (every session needing `git checkout`), not a speculative build for an absent one.
- **OP-2 (automate execution, gate judgment) — correctly handled.** A permissions-surface change is exactly the class `/risk-check` exists to gate; using it here is the system working as designed, not a bypass.
- **OP-12 (closure before detection) — not engaged; if anything, positively aligned.** This is a closure of an existing defect, not new detection.

### Dimension 7: Problem Reality
**Risk:** Low

- **Defect — observed, not inferred, and independently reproduced by me.** I ran `git checkout --help` in this reviewer's own sandbox and received: `Permission to use Bash with command ... git checkout --help has been denied.` This is a first-person reproduction, not an inherited claim. I additionally isolated the root cause: `git add logs/decisions-archive-2026-06.md` (an archive-pattern path) succeeded, while `git checkout -- docs/permission-template.md` (a **non**-archive path) was denied — proving the block is the blanket `Bash(git checkout *)` rule, independent of the archive `Read()` patterns, exactly as the change description's "out of scope" note and mission thread 4 both claim.
- **Consequence — traced, with dates and specifics, not merely inferred.** `ai-resources/logs/friction-log.md:619-625` and `ai-resources/logs/improvement-log.md:949-956` (Status: OPEN) both document a 2026-07-14 incident where a whitespace-only merge conflict could not be resolved because `git checkout --ours … <path>` was denied, and the operator's own second live session was independently blocked for an unrelated reason — both sessions stalled on the same merge. `improvement-log.md:952` states explicitly: *"it has stalled work four sessions running, once freezing both open sessions mid-merge... 5th occurrence of the class"* — this matches the change description's "5 logged work stalls, once freezing both open sessions mid-merge" exactly; I did not need to correct this count.
- **Re-derivation vs. the change description:** the fnmatch scoring (a), the 12 destructive forms (b), and the 9 safe forms (c) all re-derived exactly as claimed — no discrepancy. The one place my re-derivation diverges from the change description's framing (not its facts): the synthesis "Candidate = 0 mismatches... designed to close exactly that hole (and five more the prior review did not name)" reads as a completeness claim. My independent extension of the same test methodology found the candidate is **not** complete — a materially real destructive form (bare pathspec discard) remains open, and it is structurally unfixable at this layer (see Dimension 2). This does not make the defect fictional or the fix worthless; it means the fix's advertised thoroughness is somewhat overstated. Recorded here per the mandate that a re-derivation discrepancy is itself a Dimension 7 finding — captured substantively under Dimension 2, since it is a completeness-of-fix question rather than a reality-of-defect question.
- **Q3 answer.** A pure settings-layer fix cannot fully close the destructive-discard problem — the branch-name-vs-pathspec ambiguity for a single bare argument is undecidable by any static glob pattern (confirmed by my Dimension 2 test: attempting to close it via an additional pattern reintroduces over-blocking on a safe form). `check-destructive-liveness.sh` is architecturally the right template for a complete fix — it already parses raw commands with `shlex` and blanks heredocs/quotes for precision — but it does not currently cover `checkout`/`restore` at all, and it answers a different question (**is the target occupied**) than the one this defect needs answered (**does this specific invocation discard working-tree changes**, answerable via `git status --porcelain` + `git rev-parse --verify`, no liveness check required). Critically, moving to that hook does **not** sidestep the propagation concern the caller raises: `check-destructive-liveness.sh`'s own wiring lives *only* in the non-git-tracked `~/.claude/settings.json` (confirmed: the workspace-root `.claude/settings.json` has no `PreToolUse[Bash]` block at all), which is precisely mission thread 3's finding — a fresh clone gets the hook script but not its wiring. A settings-deny fix is, asymmetrically, *better* on this one axis: the workspace-root half of this change is git-tracked and propagates to a fresh clone automatically; only the user-level half shares the hook's unversioned-wiring weakness. Net: land the settings fix now for its git-tracked, real, working-today improvement; treat full precision (closing the bare-pathspec class) as a separate, later hook-layer thread, not a precondition — consistent with the mission's own "structural fix as default; ROI decides scope" posture, since attempting full precision here now would require solving thread 3 first.

## Mitigations

- **Permissions Surface (Medium):** add a 9th deny pattern, `"Bash(git checkout --pathspec-from-file*)"`, to both settings files — verified by execution to close that specific real gap with zero over-blocking risk. Separately, add one explicit line to `docs/permission-template.md` (or a settings.json-adjacent comment/PERMISSIONS-NOTES.md per the existing documented convention) naming the two residual, structurally-irreducible gaps (bare pathspec discard; tree-ish+pathspec without `--`) as an accepted, documented residual risk — not a silently-shipped one — citing that equivalent capability is already open via the unguarded `git restore` verb.
- **Reversibility (Medium):** before editing `~/.claude/settings.json`, write a timestamped backup (e.g. `cp ~/.claude/settings.json ~/.claude/settings.json.bak-2026-07-18`). This closes the one extra manual-cleanup step and would drop this dimension to Low on the next review.
- **Hidden Coupling (Medium):** when editing `~/.claude/settings.json`, use a targeted JSON-array edit (not a full-file rewrite) to keep the operator-declined `"model": "opus[1m]"` field untouched and easy to diff-verify. Treat the matcher-semantics claim (item d) as corroborated-by-observation rather than independently source-verified, and flag that explicitly in the landing session's own notes rather than restating it as confirmed fact.
- **Principle Alignment (Medium):** when flipping `improvement-log.md:949-956` to closed (required regardless, per the mission's own non-negotiable), explicitly name and reconcile the entry's own prior verdict — state plainly why a refined enumerate-the-bad-forms deny list is being adopted despite the recorded "do not attempt this approach again" warning, rather than landing it silently. This is the loud-revision move OP-11 requires and is a one-paragraph addition to a log entry that must be edited anyway.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: the core defect was reproduced by this reviewer's own execution (`git checkout --help` denied; `git add` on an archive path succeeded while `git checkout -- <non-archive path>` was denied, isolating the true root cause); the caller's 21-command fnmatch matrix was independently re-implemented in Python and matched exactly (9/8/0); 13 additional edge-case commands were tested by execution against the candidate set, surfacing a real residual gap (bare pathspec discard) and confirming no new over-blocking on the safe-form edge cases asked about; a hypothetical 9th deny pattern was tested by execution and shown to both close one gap safely and, in a different form, reopen an over-blocking regression — both by running code, not by reasoning alone; file:line citations (`improvement-log.md:949-956`, `friction-log.md:619-625`, `permission-template.md:38-40,72`, `check-destructive-liveness.sh` gated-verb list) were independently re-read, not inherited from the change description. The one limitation stated rather than resolved by assumption: this reviewer has no WebFetch/WebSearch tool and could not independently re-fetch Anthropic's permissions documentation to verify the matcher-semantics claim (item d) at its primary source — it is corroborated by directly observed behavior instead, and that distinction is preserved in Dimension 5 rather than collapsed into a confirmed fact. No training-data fallback was used on any claim in this report.
