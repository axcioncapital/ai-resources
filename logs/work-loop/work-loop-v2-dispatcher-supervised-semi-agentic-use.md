---
task: work-loop-v2-dispatcher-supervised-semi-agentic-use
status: active
turn: codex
---

## Objective and scope

Implement the approved revised plan at `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` through its complete revised Gate SA acceptance contract and independent adoption review, so the dispatcher may truthfully carry the label **Ready for supervised semi-agentic use — durable terminal results are guaranteed after run admission.**

Scope: the existing Work Loop v2 supervised dispatcher, its accepted helpers and runtime surfaces, focused proof, the required live trials, and the synchronous regression gate named by the plan. Excluded throughout: durable results for invalid pre-admission invocations; the unqualified **Reliable supervised semi-autonomous dispatcher** label; Gate ST; Gate U; unattended or walk-away release claims; a dispatcher rewrite or language migration; merge, push, deployment, destructive cleanup; and every other exclusion in plan §§ 4 and 7.

Task exit condition: one integrated candidate has passed the revised Gate SA and the independent review has returned `ADOPT`, or Patrik has explicitly chosen `SHRINK` or `STOP`.

## Lane and unit

Standard. Discovery mode. Unit 18 — adjudicate actor-handback parsing

Named reason for the loop: the approved objective spans multiple bounded implementation, proof and operating-trial units, must survive session boundaries, needs its scope held against overengineering, and requires independent Codex assessment before it counts as complete.

## Brief

Unit 17 is accepted at `c234dd14b225210a0eacf30f357bad0ade8f9b54` with its correction at `67d363a3994de3310a56b22fe6049b46ea0a6074`. The dispatcher now refuses every currently value-taking option with an absent following argv element, permanently proves the unknown-option default, and retains the existing meanings of empty and option-looking values; the correction removed 37 lines of repeated narrative with an empty whole-file code-only diff and unchanged `48/0` focused proof. The next Change set A clause is to parse actor handbacks as bounded data through one parser without `eval` or `source`, so this unit determines whether current mechanisms already satisfy that requirement before any new parser is proposed.

Dominant deliverable: a producer-to-consumer adjudication of the current actor-handback parsing boundary.
Evidence required in this hop: one compact map of every actor-controlled byte channel read after a hop, its parser and bounds, the trusted decision or terminal field it can influence, permanent proof, and an exact verdict; then one earliest genuine target only if a gap exists.
Evidence explicitly deferred: implementation or test changes; argument-array and option-termination policy; checkout/state/evidence/capture/changed-path canonicalization; the remaining hostile path and fake-control-line families; `too-many-lines` defence-in-depth proof; Change set B execution budgets; the full dispatcher suite; Change sets B–D; live trials; final regression; adoption review; historical cleanup; merge, push, deployment and destructive cleanup.

Required outcome:

- Enumerate only production channels containing actor-controlled bytes that the dispatcher reads after an actor launch. At minimum adjudicate the task state file, raw hop capture, permission-denial extraction, and any actor-authored Git/path facts that are parsed rather than independently observed. Do not treat a dispatcher-created path that merely points to raw capture as actor content.
- Trace each channel from producer through parser to every routing, authority, continuation, terminal-result or diagnostic consumer. State its size/line/field/character bounds, failure behavior, and whether raw bytes can enter trusted terminal-result framing.
- Interpret the approved phrase “through one parser” by its safety purpose: one authoritative parser per trusted protocol boundary, with no fallback reader that can disagree. Do not demand one universal function for semantically different channels unless the approved plan or current contract actually requires it.
- Search every executable `eval`, `source`, and dot-source site in `dispatch.sh` and its invoked validation helpers. Distinguish internal trusted code/library use and file-descriptor mechanics from any evaluation of actor-controlled bytes; do not report a text match as a behavior gap.
- Classify each channel `COVERED`, `BEHAVIOR GAP`, `PROOF GAP`, `NOT APPLICABLE`, or `UNKNOWN`. For a non-covered verdict, name the exact missing boundary or fail-capable proof and the smallest hostile example that would distinguish it, without executing the example.
- If all actor-handback channels are covered by the current authoritative readers, say so and identify the next unmet Change set A clause in approved-plan order. Do not add or recommend a second parser merely to mirror the plan's noun.

Check against the repository:

1. Verify the Unit 17 and correction commits, accepted `48/0` and empty code-only correction diff without rerunning either check.
2. Verify the content-bound approved plan still places “Parse actor handbacks as bounded data through one parser; never `eval` or `source` actor content” immediately after the token-grammar clause in Change set A.
3. Inspect the complete post-actor read path in `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, the canonical state validator and any helper it invokes, plus the focused committed tests for those exact consumers. Search assignments, file reads and parser calls rather than relying on one vocabulary grep.
4. Treat current comments and previous-unit prose as claims to verify. Current executable code and fail-capable committed tests decide the verdict.

Required fail-capable evidence:

- Return one compact table: channel/value, actor control level, parser/authoritative reader, explicit bound or closed grammar, trusted consumers, exact permanent proof, and verdict.
- For every `COVERED`, explain which refusal or mismatch would occur if malformed, oversized, duplicate, injected or fake-control content reached that boundary, and cite a permanent test that would read differently. A comment, grep hit or aggregate pass count is not proof.
- For every gap, name the complete searched surfaces/patterns and the smallest hostile example; do not run it or implement a repair.
- Confirm no production, test, plan or documentation file changed and no test suite ran; only this state file may be committed. Leave `logs/friction-log.md` unstaged.

Capability subset: baseline only — read the approved plan, accepted Unit 17 evidence, current dispatcher, canonical state validator/helpers and focused tests; inspect necessary accepted history; and commit only this task state. The five baseline deny rules and four mandatory nested-actor rules are required in full. Nothing is selected from the pre-authorizable set, which is empty today. No test execution, source mutation, model launch, authentication attempt, network, external service or operator-reserved capability is permitted.

Completion condition: one committed discovery handback establishes whether every current actor-handback channel is bounded by one authoritative reader at its trusted boundary, identifies one justified next target or the next Change set A clause without implementing anything, changes only this state file, and returns with `turn: codex`.

Stop and hand back if “actor handback” cannot be bounded from current production read paths without inventing a new protocol category, if adjudication would require a full hostile-input audit, or if the current implementation materially conflicts with the approved clause beyond one bounded next target.

## Latest result

Inspected (2026-08-19):

- Claim (1): HOLDS — `git log -1` resolves `c234dd14b225210a0eacf30f357bad0ade8f9b54` (Unit 17 handback, 2026-08-18) and `67d363a3994de3310a56b22fe6049b46ea0a6074` (its correction). The correction's `--stat` touches only the two spike shell files and this state file; comparing both shell files between the two commits with comments and blank lines stripped produces an empty diff, confirming the code-only diff without rerunning the suite. The accepted `48/0` is taken from the accepted record, not re-executed.
- Claim (2): HOLDS — in `plans/work-loop-v2-v0.2/work-loop-v2-dispatcher-reliable-supervised-use-implementation-plan-v0.1.md` § "Hostile-input boundary", line 209 is the token-grammar clause and line 210 is "Parse actor handbacks as bounded data through one parser; never `eval` or `source` actor content" — immediately after, in Change set A.
- Claim (3): HOLDS — the post-actor read path was traced from `dispatch.sh:4380` (launch) to `:4593`, by function-definition enumeration plus assignment/read/call-site greps (`LAST_CAPTURE`, `STATE_FILE`, `fm_value`, `closing_record_ok`, `operator_question`, the `git` readers), not by one vocabulary grep. `logs/scripts/work-loop-state.sh` (342 lines) was read whole; `work-loop-owner.sh`, `work-loop-lease.sh` and `work-loop-capability.sh` are the only other helpers dispatch.sh invokes.
- Claim (4): HOLDS as method — every verdict below rests on executable code or a committed fail-capable assertion. Where only a comment claims a property, it is recorded as unproven rather than as covered.

Result: adjudicated. Eight production channels carry actor-controlled bytes past a hop; seven are covered or not applicable, and one carries a proof gap. No new parser is warranted, and no second parser is recommended.

| Channel | Actor control | Authoritative reader | Bound / closed grammar | Trusted consumers | Permanent proof | Verdict |
|---|---|---|---|---|---|---|
| State file — lifecycle | full | `work-loop-state.sh` via `validate_state()` (`dispatch.sh:3516`) | exactly 3 keys, each once; `status`/`turn` closed sets; 4 legal pairs enumerated; exact heading list and order, fence-aware; symlink and traversal refused; task id `^[A-Za-z0-9][A-Za-z0-9._-]*$` | `ST_TURN`/`ST_CLASS` → transition table (`:4523`), die 13/14/15/26, `turn_at_terminal`, `state_class`, `closing_record_ok` | `work-loop-state.test.sh` L/I/F/B, plus R1–R5 | COVERED |
| State file — byte identity | full | `file_hash()` (shasum) | not a parse; 64-hex output | 22/36/25, the crash-retry guard, `state_sha256_before/after` | `dispatch.test.sh` case 43 (`SB43` read before the hop) | NOT APPLICABLE — a hash has no grammar to bound |
| State file — operator prose | full | `operator_question()` (awk, `:3793`) | `## Blocker` and `## Next action` only, ≤24 lines each | none — output reaches only `say` at `:4254`; never the terminal result | — | COVERED — bounded, and no trusted consumer to disagree with |
| Hop capture — permission denials | full | `permission_denials_in()` → `denials_via_jq` / `denials_via_python` | real JSON parse in both tiers; no truncation; `unique` + sort; unparseable input yields empty and cannot invent a stop | exit 37 and its stop prose | cases 43, 43b (clean-capture control), 43c (>200-char target via jq), 43d (same target via python3, with a shim control) | **PROOF GAP** |
| Hop capture — everything else | full | none — no reader exists | n/a | none; only the dispatcher-created path is recorded as `capture` | case 43 line 5854 | NOT APPLICABLE |
| Actor-authored Git facts | full | `git` plumbing only: `status --porcelain`, `diff --name-only`, `rev-parse`, `rev-list --count`, `hash-object` | observed, never parsed from actor prose; each path matched against the `--allow-path` regex set | 24, 30, 20/25/36, and the `worktree_*` / `changed_paths_since_launch` counts | case 43 (`SH43`) and the allowlist cases | COVERED for this clause; path canonicalization is deferred by this brief |
| Actor commit messages | full | none — never read | n/a | none | — | NOT APPLICABLE |
| `logs/work-loop/.owner` | reachable — an actor can write the checkout | `owner_declaration()` (`:709`), first non-blank line | `tr_val`: newlines/CR/tabs to spaces, cut at 512 chars | `owner_declared`, a diagnostic field only; nothing branches on it | — | NOT APPLICABLE — not a handback, and it reaches no decision |

Three findings support the covered verdicts.

**No `eval` or `source` touches actor content.** Six matches in `dispatch.sh`: `:1040`, `:1569` and `:1767` are comment prose; `:1794` dot-sources `$LEASE_LIB`, fixed at `$CHECKOUT/logs/scripts/work-loop-lease.sh` (`:1785`) and gated on existence and readability — a trusted internal library, not handback content; `:3835` and `:3850` are `eval "exec ${TREE_MARKER_FD}>\"\$marker\""`, where `TREE_MARKER_FD` is the literal `9` (`:2311`) and `$marker` is escaped so `eval` expands only the descriptor number while the redirect target is expanded by `exec` as an ordinary quoted word. Helper matches are one comment each (`work-loop-lease.sh:36`, `work-loop-capability.sh:142`). None is an evaluation of actor bytes.

**Raw bytes cannot enter trusted terminal-result framing.** Every field written by `finalize_terminal_result()` (`:828`–`:878`) is a dispatcher constant, a dispatcher-observed fact, a count, or a closed-set token, and each passes through `tr_val` — so no value can inject a second `key=value` line. `recorded_usage` is stated `unavailable` rather than extracted (`:859`–`:861`), and only the capture *path* is recorded. `LAST_CAPTURE` has exactly one reader (`:4480`).

**"One parser" is satisfied in its safety sense.** `work-loop-state.test.sh` R3 asserts every plan-named consumer delegates to the validator, R4 asserts none retains a private lifecycle parser, and R5 is R4's fail-capable control. The one remaining second reader of `turn:`/`task:` is `fm_value()` under `--status` (`:2900`), which prints no classification word, reaches `exit 0` two lines later at `:2927`, and influences no dispatcher decision — a display reader outside any trusted protocol boundary, not a fallback that can disagree at one.

The gap, stated exactly. No permanent case exercises denial extraction against a line-delimited `stream-json` capture, which is the shape `--unattended` produces — cases 32/32n prove `--output-format stream-json --verbose` is the unattended argv. All four denial fixtures (`dispatch.test.sh:264`, `:5787`, `:5891`, `:5951`) are single JSON objects, and every denial case runs `--carry-one`. The gate at `dispatch.sh:4479` is not mode-scoped, so it fires under `--unattended` too. Both readers claim to handle the line-delimited shape — `jq -s` slurping (`:3585`–`:3588`) and python's per-line fallback (`:3650`–`:3657`) — but nothing reads differently if either stopped: `permission_denials_in` fails safe to silence, so a real unattended denial would resurface as a bare 25 or 22 naming no cause, which is the defect exit 37 exists to remove, in the mode where nobody is watching.

Searched surfaces and patterns: `grep -n 'permission_denials' dispatch.test.sh` (4 fixture sites, every one a single object); `grep -n 'stream-json' dispatch.test.sh` (12 hits, all argv-shape assertions in cases 32/32j/32n, none a capture body); `grep -n 'unattended' dispatch.test.sh | grep -iE 'denial|37'` (no hit); `grep -n 'LAST_CAPTURE' dispatch.sh` (one reader, not mode-scoped).

Smallest hostile example, not executed: a three-line capture — `{"type":"system","subtype":"init"}`, `{"type":"assistant",…}`, `{"type":"result","permission_denials":[{"tool_name":"Bash","tool_input":{"command":"git commit -m wip"}}]}` — driven through a hop that moves `turn:` and exits 0. A working extractor gives exit 37 naming `Bash :: git commit -m wip`; a broken one gives 22 or 25 and names nothing.

Earliest genuine target: one fail-capable case beside 43–43d that drives the fixture above and asserts exit 37 with the exact tool and target, plus a 43b-style clean line-delimited control so it cannot pass vacuously. Test-only, inside the already-open hostile-input boundary, and it proposes no second parser. The next Change set A clause in approved-plan order after this one is line 211, "Use argument arrays and explicit option termination where supported" — which this brief explicitly defers.

Evidence: the verdicts rest on executable code and committed fail-capable assertions, each cited above by file and line; the single gap is proven by four negative searches whose exact patterns are named, so a later reader can rerun them and get a different answer once the case exists. Nothing was executed this hop. No production, test, plan or documentation file changed — `git status --porcelain` shows only this state file and the pre-existing, unstaged `logs/friction-log.md`. No test suite ran.

## Blocker

None.

## Next action

Codex: assess the Unit 18 discovery handback. Decide whether the adjudication settles the "one parser, never `eval` or `source`" clause on current mechanisms, and whether the named `stream-json` denial-capture proof gap is the right next unit or should be deferred so the next unmet Change set A clause opens instead.
