---
task: work-loop-v2-contained-unattended-profile
turn: operator
---

## Outcome
Phase 1 item **1d is complete.** `dispatch.sh --unattended` applies the operator-settled contained
profile to every Claude hop, fails closed when it cannot deliver that profile, and leaves attended
and courier launches unchanged. Its effective policy — not merely the policy requested — was measured
from inside a real child the dispatcher launched.

The plan, the spike README, the Work Loop skill guidance, the simulated suite and the live record now
agree on what is built, what is proven, and what remains blocked.

**Exactly two Phase 2 blockers remain:** 1a, escaped descendants survive the stop; and 1f,
branch/worktree isolation is unproven. **Phase 2 remains forbidden.**

## Decisions that matter
- **One named read exception inside the denied home tree: `~/.gitconfig`, and nothing else.**
  `denyRead: ["~/"]` also blocked the file Git reads on every invocation, so the contained child's Git
  exited 128 *before touching the repository*. The zero-read alternative (`GIT_CONFIG_GLOBAL=/dev/null`)
  was rejected on evidence rather than preference: the Git identity lives only in the global config on
  this host, so that child could not commit, and core § 4 has Claude commit every hop. Operator
  decision, 2026-08-07 — allow the minimum Git configuration paths, broaden home no further.
- **`strictAllowlist` is delivered through CLI `--settings` on every hop, never through a repository
  settings file.** A correctness requirement, not a preference: the key has no effect from
  `.claude/settings.json`, so writing the profile there would drop network containment silently — and
  would still look contained on a machine whose user settings already carry the key.
- **The tool roster and MCP absence were moved from model claim to measurement.** Unattended hops
  capture `--output-format stream-json`, whose first event is the product's own `system/init` and
  therefore states what the runtime resolved rather than what the argv asked for. Codex's assessment
  found both being scored as passes while they were still the child's own prose.
- **The final tightly-bounded fix was taken from the § 3 menu**, rather than accepting the remaining
  findings as limitations: three stale plan statements had known, low-risk replacements, and accepting
  them would have left the phase gate internally contradictory.
- **Two observations were deferred, not pursued, because they fell outside the frozen scope.** First,
  the sandbox's *displayed* write policy does not predict its stricter enforcement — the policy shown
  to the child lists `**` among write-allowed paths while the write outside the checkout was refused,
  so the description cannot be used to reason about behaviour. Second, the probe's marker vocabulary
  does not distinguish a sandbox refusal from a permission-layer refusal.

## Evidence
- **Final-fix commit `32b3239`.**
- **Live, from inside a dispatcher-launched child:** `runs/probe-unattended-integration-2026-08-07.md`,
  raw capture `runs/probes/unattended-effective-policy-2026-08-07.raw.txt` — **21 pass, 0 fail**.
- **Shipping simulated suite: 284 pass, 0 fail.**
- **Matched red pair: 216 pass, 24 fail** — the same current test file against the preserved pre-1d
  dispatcher. The earlier **212/23** figure belongs to the pre-correction test file and is reported
  separately rather than as a run of the same one.

## Accepted limitations
- **Effective containment was measured once, on one host**, in an attended single-hop fixture run. It
  is a Phase 1 safety check — not a reliability claim, and not the Phase 2 walk-away pilot, which has
  still never happened.
- **Settings arrays can merge across scopes.** Keys such as `allowRead` merge, so another scope on the
  host can widen the profile. Closing this needs managed settings, which no dispatcher can set for
  itself.
- **The denied outside write cannot be double-checked from inside the child** — confirming no file was
  created at that path requires reading it, which is itself denied. The probe asserts it from outside
  the child and that assertion held.
- **The Claude process and its model connection sit outside the Bash sandbox.** Containment applies to
  what Claude *runs*, not to Claude.
- **`~/.gitconfig` stops being a safe exception if a real secret is ever placed in it.** It names
  credential helpers; the child obtained no token, measured rather than reasoned.
- **1a and 1f remain blocking.** They are unbuilt and unproven work, not risks accepted as safe.
