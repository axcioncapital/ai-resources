---
task: work-loop-v2-phase1a-full-descendant-termination
turn: operator
---

## Objective and scope

Close Phase 1 item 1a as it is currently written: every controlled stop of the dispatcher must
terminate and verify the actor's full descendant tree, including a descendant that calls `setsid`,
double-forks, closes every inherited descriptor and `exec`s another program. A stop must not signal
an unrelated process, and it must never claim success when termination or verification is incomplete.

The operator decided on 2026-08-08 to **preserve the literal 1a guarantee**. Reachable-tree
termination plus containment is therefore not an acceptable substitute. This decision authorizes
the guarantee-preserving dedicated-identity route to be investigated and prepared; it does not by
itself authorize any specific macOS account, privilege, credential, privacy or filesystem mutation.

The task closes only after the guarantee is implemented and supported by fail-capable simulated
regression evidence plus effective live Darwin evidence for the process boundary the harness cannot
establish. Phase 1f and every Phase 2 action remain outside this task; Phase 2 stays forbidden.

## Lane and unit

Standard. Discovery mode. Unit 2 — establish whether a dedicated macOS actor identity can support
the real dispatcher actors without weakening the already-settled unattended authority boundary, and
return the smallest exact operator-owned setup needed for a later implementation unit.

Named reason for the loop: this is a safety-critical dispatcher task whose literal guarantee now
depends on host identity, privilege and credential boundaries. The result needs an evidence-backed
design before the operator makes hard-to-reverse system changes or Claude edits the dispatcher.

Plan justification: the governing unattended-operation plan keeps 1a open because a fully detached
daemon survives and forbids Phase 2 until 1a and 1f close. Unit 1 established that the dedicated
identity assumed by the first implementation brief does not exist. The operator has now preserved
the guarantee rather than accepting the containment scope change, so the nearest unmet condition is
to settle the dedicated identity's operational viability and exact least-authority setup.

Codex framing decision: this unit is read-only discovery because creating an account, changing
privilege policy, changing ACLs or permissions, authenticating a second identity and altering macOS
privacy state are consequential host actions. It prepares those actions for an operator decision;
it does not perform them. Product implementation, live account creation and Phase 1f are held back
until this unknown is resolved.

## Brief

The operator has kept the original safety promise: a stopped run must leave no actor-owned process
behind. Unit 1 showed that the required ownership boundary is absent, so this unit must prove whether
that boundary can be introduced without exposing the operator's home or credentials. It must return
one decision-ready setup and validation path, not create the boundary or edit the product.

### Governing sources and dispositions

- **Current operator decision:** preserve Phase 1a literally, given in the Work Loop hand-back on
  2026-08-08. It governs the guarantee and continues the dedicated-identity investigation. It does
  not silently authorize a particular system mutation.
- **Governing implementation plan:**
  `plans/work-loop-v2-v0.2/unattended-operation-plan-v0.2.md`, especially its status block, Phase 1
  § 1a, Phase 2 prohibition and Sequencing. Its statement that no operator questions remain is
  superseded for 1a by the later discovery, Unit 1 result and current operator decision.
- **Authoritative current task state:** this file's accepted Unit 1 result. It establishes that no
  suitable dedicated actor account exists on this host and that the prior implementation unit made
  no product change.
- **Accepted supervision discovery:**
  `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md`. It found no present-authority
  mechanism that closes the fully detached case and selected a dedicated actor OS identity as the
  smallest guarantee-preserving authority change. Its audit-session note is a deferral, not a second
  route to investigate unless evidence disproves the dedicated identity's viability.
- **Settled unattended authority:**
  `logs/work-loop/work-loop-v2-contained-unattended-profile.md`, together with
  `plans/work-loop-v2-v0.2/handoff-automation-spike/dispatch.sh`, `README.md` and the cited 1d live
  record. The dedicated identity must preserve the operator decision to broaden home access no
  further than the minimum Git configuration exception. Do not treat a second UID's `HOME`, config
  resolution or sandbox expansion as equivalent to the currently proved uid-501 behavior without
  evidence.
- **Later accepted containment qualification:**
  `logs/work-loop/work-loop-v2-descendant-supervision-discovery.md` records that its detached
  generated-profile probe was a direct Claude invocation, not an end-to-end dispatcher run, and did
  not establish full filesystem write confinement. Where that later record qualifies broader plan or
  README wording, carry the qualification visibly; do not reopen 1d or use its broader wording as a
  premise for credential safety.
- **Workflow contract:** `.agents/skills/work-loop-v2/SKILL.md` and
  `plans/work-loop-v2-mvp/work-loop-v2-executable-core-v0.1.md`. This is a discovery unit: inspect and
  return evidence, change nothing beyond this state file, and hand back for reframing or an operator
  decision.

### Named unknown and required outcome

Establish whether one dedicated, non-admin macOS actor identity can be an exclusive ownership
boundary for the current serial dispatcher and still run the actual Claude and Codex binaries,
authenticate each actor independently, read and modify only the bound checkout and Git common
directory, commit with a valid Git identity, and retain the effective unattended restrictions that
1d settled.

Return one evidence-backed candidate design that answers all of the following. If no design meets
all of them, return **not viable** and the exact conflict rather than weakening 1a or 1d.

1. **Identity lifecycle:** the account properties needed for a dedicated, non-admin actor; how its
   UID remains exclusive to dispatcher actors; how pre-existing processes under that UID are detected
   before launch; and how one run cannot kill another run that shares the identity. Keep the current
   project boundary — one task, one checkout, serial — explicit rather than implying support for
   concurrent unattended runs.
2. **Least launch, termination and inspection authority:** the narrow capabilities uid 501 would
   need to launch the selected actor as the dedicated identity, signal only that identity's
   processes, and verify that the boundary is empty. Select the concrete mechanism only after
   inspecting current Darwin tools and their effective semantics. Distinguish what can be limited by
   executable, target identity and arguments from any capability that would grant general root or
   arbitrary cross-user execution.
3. **Claude authentication and configuration:** how the installed Claude binary resolves its own
   authentication and configuration under the dedicated identity, and whether a separate supported
   login can be established without copying the operator's live credential files, reading the
   operator's home or granting an interactive GUI login permanently.
4. **Codex authentication and configuration:** the same answer for the Codex binary that the
   dispatcher launches from `/Applications/ChatGPT.app/Contents/Resources/codex`. Do not assume that
   the ChatGPT desktop session, Keychain state or the operator's `~/.codex` state transfers across a
   UID boundary.
5. **Checkout and Git access:** the minimum path traversal, read and write access the actor would
   need for this exact checkout, its Git common directory and the task state file; where Git identity
   would live for the actor; and whether that can be provided without opening the rest of
   `/Users/patrik.lindeberg` or copying credential-helper secrets.
6. **Contained unattended behavior under a different UID:** how `~/`, `$HOME`, user settings,
   `~/.gitconfig`, the generated profile, credential scrubbing and the effective tool/network/home
   restrictions resolve when the Claude process runs as the dedicated identity. Identify each 1d
   assertion that must be re-proved live after account setup. Do not infer it from the current
   operator-UID evidence.
7. **macOS privacy behavior:** which TCC or Keychain operations may prompt or differ for the new UID,
   whether they can be prepared while attended, and which cannot be claimed until an actual actor
   run exists.
8. **Operator setup and rollback:** the smallest ordered host procedure that would create and prepare
   the boundary, the exact decision or approval required at each consequential step, a rollback for
   each persistent change, and a later validation checklist that can fail before any dispatcher
   implementation starts.

### Check before concluding

1. Re-read the governing plan, the two closed predecessor state files, the current dispatcher launch
   paths and the unattended profile. Confirm that the literal 1a guarantee, 1d authority decision,
   exact-task locking, serial scope and Phase 2 prohibition still read as described above.
2. Confirm the current host/account premise from read-only surfaces without repeating an already
   sufficient probe merely for comfort. The prior `dscl` result may be accepted unless a direct
   repository or host fact now contradicts it. Do not create or repurpose an account.
3. Resolve the exact installed Claude and Codex versions, binary paths, supported login/status/config
   interfaces and documented configuration-location controls. Prefer local binary behavior and
   official primary documentation. Separate observed behavior from documented behavior and from an
   inference.
4. Inspect only credential metadata needed to locate the boundary: existence, owner, mode, directory
   or Keychain class, and a supported redacted status command. Never print, copy, decode, export or
   compare token, cookie, key, credential-helper response or secret value.
5. Inspect current path ownership and traversal requirements for the checkout and Git common
   directory without changing permissions, ownership, ACLs or location. Do not create a replacement
   checkout or worktree.
6. Inspect the semantics of the candidate run-as, process enumeration, signal and verification tools
   on this Darwin host. A non-interactive privilege listing may be attempted only read-only and
   non-prompting. If the tool layer refuses it, record the exact operator-run check and the result
   that would make the design viable; do not retry through a broader route.
7. Reconcile the design against all five current dispatcher launch paths: simulated `--actor-cmd`,
   Codex, attended Claude, Claude with `--claude-deny`, and contained `--unattended` Claude. Say which
   are part of the eventual ownership boundary and which test seam must remain simulated.

### Required evidence

Evidence must be capable of returning **viable**, **not viable** or **operator check required**.

- A redacted actor-readiness matrix for Claude, Codex and Git. For each, name the executable, the
  config/auth surface it actually uses, the proposed dedicated-identity source, the checkout access
  needed, the observed or documented support, and the unresolved live check. No secret values.
- A capability table for launch, enumeration, TERM, KILL and empty-boundary verification. For each,
  name the effective caller and target identity, whether privilege is required, the smallest
  constrainable surface and a negative boundary that must remain impossible. A design that can target
  uid 501, root or an arbitrary UID without an additional guard is not viable.
- A path-access table covering every parent traversal path, the checkout, Git common directory,
  actor home and Git config. It must show that the operator's home remains closed except for explicit
  task paths. If this cannot be done without broad home access, the candidate is not viable.
- A 1d revalidation list whose checks read differently under the operator UID and dedicated UID:
  effective tool roster, MCP absence, network denial, home-read denial, outside-write behavior,
  push denial, credential scrub, hook absence, Git operation and the exact `HOME`/config path the
  profile resolved. Label every item that requires the future live account.
- One exact, ordered operator procedure with persistent changes, risks and rollback paired line by
  line. Commands may be proposed only when backed by the inspected host semantics. Mark commands that
  require administrator approval and commands that merely validate. Do not execute them.
- A fail-capable pre-implementation validation plan. It must include positive controls that the real
  Claude and Codex actors can authenticate and commit under the dedicated identity, negative controls
  that operator processes and files outside the explicit paths remain unreachable, and proof that an
  empty identity boundary is required before launch.
- A clear conclusion: **viable**, **not viable**, or **operator check required**. State exactly what
  Unit 3 may implement if viable, or what operator evidence is still needed. Do not call 1a complete.

### Scope and stop conditions

Allowed repository path: this state file only.

Read-only inspection may cover the named repository sources, the installed Claude and Codex command
interfaces, account metadata, file metadata, current non-secret authentication status, local manual
pages and official primary documentation. Self-cleaning temporary probe material may be used only if
it changes no account, privilege, permission, Keychain, TCC, settings or repository state and contains
no credential data.

Excluded: product edits; account creation, deletion or repurposing; `sudoers` or other privilege-policy
changes; `launchd` or managed-settings changes; ACL, owner, mode or checkout-location changes;
authentication or logout; credential copying/export; Keychain or TCC mutation; writing a second plan,
requirements document or evidence artifact; weakening 1a; reopening the settled 1d policy; Phase 1f;
every Phase 2 action; push, merge, deployment, installation and unrelated cleanup.

Stop and hand back if inspection would reveal a secret; a check needs interactive authentication or
administrator approval; the viable design requires broad operator-home access, copied credentials,
general root authority or an interactive account that cannot be disabled after setup; the two actor
products cannot share one safe identity design; the mechanism cannot exclude operator and bystander
processes; an authority or 1d scope change is required; an applicable source conflict cannot be
reconciled; or the required evidence cannot be produced read-only.

Unit completion: Claude changes and commits only this state file, reports every check and the redacted
evidence above in `## Latest result`, identifies the conclusion and exact next owner, sets
`turn: codex` when repository-resolvable evidence is sufficient for assessment or `turn: operator`
when one specific protected host check or decision remains, and stops. Do not implement and do not
push.

## Latest result

Inspected (2026-08-08). Read-only throughout; no account, privilege, permission, Keychain, TCC,
settings or product file was changed. No secret value was printed, copied, decoded or compared.

- Check (1): HOLDS — re-read the governing plan and both closed predecessors. § 1a still states the
  objective "says the actor's *full descendant tree*"; the status block still lists exactly two Phase 2
  blockers (1a, 1f) with Phase 2 `BLOCKED`; `work-loop-v2-contained-unattended-profile.md` opens
  `turn: operator` and still records "One named read exception inside the denied home tree:
  `~/.gitconfig`, and nothing else" with the operator decision "broaden home no further";
  `dispatch.sh` still locks per exact task (`LOCK_DIR="${TMPDIR:-/tmp}/work-loop-dispatch-$LOCK_KEY.lock"`,
  `acquire_lock`, `pin_lock`, exit 17) and still carries "ONE exact Work Loop task ... in ONE checkout".
- Check (2): HOLDS — Unit 1's `dscl` result accepted, not repeated. Nothing inspected this unit
  contradicts it; no account was created or repurposed.
- Check (3): HOLDS — resolved by running each binary. `claude` 2.1.220 at
  `/Users/patrik.lindeberg/.local/bin/claude` → symlink → `~/.local/share/claude/versions/2.1.220`
  (Mach-O, mode 755). `codex-cli 0.147.0-alpha.1.2` at
  `/Applications/ChatGPT.app/Contents/Resources/codex` (mode 755). Supported interfaces observed:
  `claude auth login|logout|status`, `claude setup-token`; `codex login [status] --with-api-key
  --with-access-token`, `codex logout`, `codex doctor`. Configuration-location control observed:
  `codex doctor` reports `CODEX_HOME  ~/.codex (dir)`. `CLAUDE_CONFIG_DIR` is **unresolved** — the
  scratchpad probe that would have settled it was refused at the tool-permission layer and was not
  retried by a broader route.
- Check (4): HOLDS — metadata only. `claude auth status` (a supported redacted command) returns
  `loggedIn: true`, `authMethod: claude.ai`, `apiProvider: firstParty`, `subscriptionType: max`.
  Claude's credential is a **Keychain generic item**, service `Claude Code-credentials`, account
  `patrik.lindeberg`; attributes read, value never requested (no `-w`, no `-g`). No
  `~/.claude/.credentials*` file exists — searched `~/.claude` for `.credentials*`, no match. Codex's
  credential is a **file**: `codex doctor` reports `auth storage mode File`, `auth file ~/.codex/auth.json`,
  `stored auth mode chatgpt`; `ls -l` shows mode `600`, owner 501, never opened. `codex login status`
  returns `Logged in using ChatGPT`. `~/.gitconfig` is mode `644` and its credential-helper **key names**
  were listed with `--name-only`; no value was read.
- Check (5): HOLDS — ownership and traversal inspected, nothing changed. Full chains recorded in the
  path table below. `git rev-parse --git-common-dir` → `<checkout>/.git` (not a linked worktree).
  Git identity resolves from `file:/Users/patrik.lindeberg/.gitconfig`; `git config --local --get
  user.email` is empty, so identity is global-only — the same fact 1d relied on.
- Check (6): PARTIAL, and recorded as exactly that. Observed by effective probe: `pgrep -U 501`
  enumerates cross-process without privilege (419 pids for uid 501, exit 0), so **verification needs no
  privilege**. Observed from `man 2 kill`: EPERM unless "the super-user" or matching effective uid — so
  **uid 501 cannot signal another UID's processes**, and termination needs privilege or must run as the
  actor. Run-as tools present: `/usr/bin/sudo` (mode 4111 setuid root), `/usr/bin/su` (4755),
  `/bin/launchctl`. **Not resolvable read-only:** whether a constrained non-interactive `sudo` rule
  exists or is acceptable. The `sudo -n -l` listing was refused at the tool-permission layer in Unit 1
  and was not retried here through any broader route. The exact operator-run check and its
  design-deciding result are named in the validation plan below.
- Check (7): HOLDS — reconciled against all five launch paths in `launch_actor()` (dispatch.sh
  1554–1644). Disposition in the capability section below.

### Conclusion — OPERATOR CHECK REQUIRED

The dedicated-identity design is coherent and specifiable, and nothing found makes it *not viable*. It
cannot be called viable from uid 501 alone: three things are protected host checks that only the
operator can run, and one of them (Claude authentication in a non-GUI session) can invalidate the whole
route. Nothing here calls 1a complete.

### Actor-readiness matrix (redacted)

| Actor | Executable | Config/auth surface actually used | Dedicated-identity source | Checkout access needed | Support | Unresolved live check |
|---|---|---|---|---|---|---|
| **Claude** | `~/.local/share/claude/versions/2.1.220` — **inside the operator's home** | macOS **login Keychain**, svce `Claude Code-credentials`, acct = the login user. No credentials file on this host | actor runs its own `claude auth login` (or `claude setup-token`); item lands in the **actor's** login keychain | read + write (Claude commits, per core § 4) | login/logout/status observed; token path documented | **Decisive:** can a non-GUI `sudo -u` session read the actor's login keychain? A login keychain is unlocked by GUI login, not by `sudo`. Also unresolved: whether `CLAUDE_CONFIG_DIR` relocates state, and whether a file fallback exists when the keychain is locked |
| **Codex** | `/Applications/ChatGPT.app/Contents/Resources/codex` — **outside the home** | **file** `$CODEX_HOME/auth.json`, mode 600; `CODEX_HOME` defaults to `~/.codex` | actor runs its own `codex login` (ChatGPT OAuth, one-time attended) — **or** `codex login --with-api-key` from stdin, which is a *different* credential and a billing/authority decision | read + write (`codex exec --sandbox workspace-write`) | `login status`, `doctor`, `CODEX_HOME` all observed | whether `codex login` completes without a GUI browser session for the actor. File-based storage means **no keychain-unlock problem** once created |
| **Git** | `/usr/bin/git` — **outside the home** | actor's own `~/.gitconfig` | actor's own `user.name` / `user.email` — **not secrets** | read + write on the checkout **and** `.git` | observed | commits would carry the actor's author identity unless it is set to the operator's name/email (public data, not a credential) |

Two consequences worth stating plainly. **No credential copying is required by this design** — each
identity authenticates itself, and `~/.codex/auth.json` and the operator's keychain item are never
read. And **Git needs no credential at all here**, because commits do not authenticate; only push
does, and push stays out of scope.

One hard requirement the inspection surfaced: the checkout is owned by uid 501, so the actor's `git`
will refuse it as **dubious ownership** unless the actor's own gitconfig adds `safe.directory` for
this exact path. Documented Git behaviour, not measured under a second UID.

### Identity lifecycle

The account is **non-admin**, has no membership in `admin` or any privilege group, is hidden from the
login window once setup is done, and exists for dispatcher actors and nothing else. Its UID stays
exclusive by convention plus one enforced check rather than by any OS guarantee: **nothing else on this
host is configured to run as it**, and the dispatcher asserts `pgrep -U <actor-uid>` is empty before the
first hop, failing closed if it is not. That check is what turns "we believe it is exclusive" into
something the run can prove each time.

**One run cannot kill another run's actor because two runs cannot exist.** The current project boundary
is one task, one checkout, serial, and the dispatcher enforces it with the exact-task lock
(`LOCK_DIR` in the operator's `$TMPDIR`, `acquire_lock`, exit 17, `pin_lock`) — which stays at uid 501
and is unaffected by the actor identity. A UID-wide `pkill` is therefore safe **only while that boundary
holds**. If concurrent unattended runs are ever wanted, one shared actor UID stops being sufficient and
the design would need a UID per run; this unit does not propose that and the plan does not ask for it.

### Capability table — launch, enumerate, terminate, verify

| Capability | Effective caller → target | Privilege required | Smallest constrainable surface | Negative boundary that must stay impossible |
|---|---|---|---|---|
| **Launch** actor as the dedicated identity | uid 501 → actor uid | **yes** — `sudo -u <actor>` | a `sudoers` drop-in whose `Runas_Spec` is **the actor account only**, and whose command list is a single root-owned wrapper with a fixed argument shape | `sudo -u root …`, `sudo -u patrik.lindeberg …`, `ALL=(ALL)`, or any rule accepting an arbitrary command must be refused |
| **Enumerate** the boundary | uid 501 → actor uid | **no** — measured: `pgrep -U` works unprivileged | `pgrep -U <actor-uid>` | must never be widened to a name/pattern match that can select uid 501 processes |
| **TERM / KILL** the boundary | actor uid → actor uid | **no root needed** if the killer itself runs as the actor: `sudo -u <actor> /usr/bin/pkill -U <actor-uid>` | reuse of the same run-as rule; no root `pkill` rule is required | a root `pkill`, or any rule permitting `-U 501`/`-U 0`. `man 2 kill` guarantees the actor cannot signal uid 501 |
| **Verify empty** before release | uid 501 → actor uid | **no** | `pgrep -U <actor-uid>` returning empty | an unreadable result must pin the lock, never be read as "empty" |
| **Precondition** — empty before launch | uid 501 → actor uid | **no** | same `pgrep -U`, asserted before the first hop | a non-empty boundary must fail closed, not proceed |

Running the killer *as the actor* rather than as root is the one design choice that keeps this inside a
narrow authority: it removes root from the termination path entirely, and the kernel's own EPERM rule
then makes "signal uid 501" impossible rather than merely disallowed by policy.

**Two mechanism findings that change the existing dispatcher, recorded and not implemented.**

1. **`sudo` closes inherited descriptors** (documented `closefrom` behaviour — *not* measured here, and
   the `man sudo` read returned nothing in this environment). The private per-hop tree marker is fd 9
   (`TREE_MARKER_FD=9`, dispatch.sh 1466), inherited by the actor. Under a `sudo -u` launch that
   descriptor is expected to be closed, so **one of the three current handles stops working for live
   actors**. The UID boundary strictly dominates it, so this is requirement 9's "demonstrably
   redundant" case — but it needs its own fail-capable evidence, and `closefrom_override` must **not**
   be used to rescue the marker, because that widens sudo authority.
2. **`sudo` resets the environment** (`env_reset`), so `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` and the
   other per-hop variables set at 1561–1563 and 1623 will not survive the boundary unless the wrapper
   sets them itself. Silently losing the credential scrub would be a regression of 1d.

**Launch-path disposition (check 7).** In the ownership boundary: live `codex exec` (1573), attended
`claude` (1637), `claude` with `--claude-deny` (1633), contained `--unattended claude` (1624). Outside
it: the simulated `--actor-cmd` seam (1563), which **must remain simulated** and continue to run as
uid 501 — it is the harness's stand-in and gains nothing from a real identity, and the existing marker
and process-group handles must be kept for it.

### Path-access table

| Path | Owner / mode now | Actor needs | Reachable today? |
|---|---|---|---|
| `/Users` | root:admin `755` | search | yes |
| `/Users/patrik.lindeberg` | 501 `755+` (ACL is only `everyone deny delete`) | search **only** | yes — and this is the problem: `o+rx` currently exposes the whole world-readable home |
| `~/.local` → `share` → `claude` → `versions` | 501 `755` each | search | yes |
| `~/.local/share/claude/versions/2.1.220` | 501 `755` | read + execute | yes |
| `~/Claude Code` → `Axcion AI Repo` | 501 `755` | search | yes |
| `<checkout>` (`ai-resources`) | 501 `755` | read + **write** | **read only — no write** |
| `<checkout>/.git`, `.git/objects`, `.git/config` | 501 `755` / `644` | read + **write** | **read only — no write** |
| `<checkout>/plans/.../runs/` (`LOG_DIR`, generated profile, `.tree` marker) | inside the checkout | read (profile) | read yes, write no |
| operator `$TMPDIR` (`LOCK_DIR`) | 501 `700` | **nothing** | correctly unreachable — the lock stays with the dispatcher at uid 501 |
| actor `$HOME`, `~/.gitconfig`, `$CODEX_HOME` | would not exist yet | full | n/a |

Two gaps follow directly, and both need operator-owned mutations that this unit deliberately did not
perform:

- **Write access.** The checkout and `.git` are `755`/`644` under uid 501, so the actor can read but
  cannot commit. Write must be granted — by ACL on the checkout subtree, not by loosening modes.
- **The home is open, not closed.** The brief requires the operator's home closed except for explicit
  task paths. Today `/Users/patrik.lindeberg` is `o+rx`, so a new UID would read every world-readable
  file in it. Closing it (`chmod o-rx`) and re-granting exactly the traversal chain above by ACL is
  what makes the required statement true. This is achievable — it does **not** force broad home access,
  so the candidate does not fail here — but it is a persistent permission change, and it is listed with
  its rollback below. It is unavoidable in some form because **two things the actor must reach live
  inside the operator's home**: the checkout, and the `claude` binary itself.

### 1d revalidation list — items that read differently under a second UID

Every line requires the future live account; none can be claimed from the current uid-501 evidence.

1. **`denyRead: ["~/"]` — the one that silently inverts.** `write_unattended_profile` (dispatch.sh
   1213) writes a tilde. Under the actor UID, `~/` resolves to the *actor's* home, so the **operator's**
   home stops being denied by the profile and is protected only by POSIX mode. Left unchanged this is a
   regression of the 1d decision. The fix shape is already proven inside the same profile — an absolute
   `denyRead` on the operator's home with `allowRead` on the checkout beneath it is exactly what the
   file does today.
2. **`allowRead: ["~/.gitconfig"]`** now targets the actor's gitconfig — the right file, but it must
   exist and carry the identity and `safe.directory`.
3. **Effective tool roster and MCP absence**, re-read from the hop's `system/init` event — user-level
   MCP config now comes from the actor's home.
4. **Network denial** (`allowedDomains: []`, `strictAllowlist: true`).
5. **Home-read denial** — see item 1.
6. **Outside-write behaviour** — the accepted discovery already records that the profile confines no
   writes; under a second UID the actor additionally loses write to the operator's home, which
   *strengthens* the position but must be measured, not assumed.
7. **Push denial** — expected to fail for a second, independent reason (no credential helper for the
   actor).
8. **Credential scrub** `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB=1` — see the `env_reset` finding.
9. **Hook absence** (`disableAllHooks: true`) — user-level hooks now resolve from the actor's home.
10. **Git operation inside the sandbox** — this is what broke in 1d; re-prove it end to end.
11. **The exact `HOME` and config path the profile resolved**, captured from the run rather than
    inferred.

### macOS privacy behaviour

- The checkout is **not** under Desktop, Documents or Downloads, so no TCC folder prompt is expected
  for it. Path inspected; behaviour documented, not measured.
- **Keychain is the real exposure.** Claude's credential lives in the login keychain, which is unlocked
  by GUI login. A `sudo -u` session is not a GUI login. This is the decisive unknown in the matrix.
- A new UID carries **no** TCC grants. Any prompt that does appear cannot be answered by an unattended
  run, so the design must fail closed rather than hang.
- Preparable while attended: the one-time `codex login` and `claude auth login`, done from a temporary
  GUI session for the actor. Not claimable until a real actor run exists: everything in the 1d list.

### Operator setup and rollback — proposed, ordered, and **not executed**

Commands are shown because the host semantics behind them were inspected. `[ADMIN]` needs
administrator approval; `[ATTENDED]` needs a person present once; `[VALIDATE]` only reads.

| # | Step | Persistent change | Rollback |
|---|---|---|---|
| 1 | `[ADMIN]` Create a non-admin account for the actor, hidden from the login window | account + its home | delete the account and its home |
| 2 | `[VALIDATE]` Record its UID (`id -u <actor>`) | none | none |
| 3 | `[ADMIN]` `chmod o-rx /Users/patrik.lindeberg` | home no longer world-readable | `chmod o+rx /Users/patrik.lindeberg` |
| 4 | `[ADMIN]` ACL: `search` for the actor on the home, `~/.local`, `~/.local/share`, `~/.local/share/claude`, `~/.local/share/claude/versions`, `~/Claude Code`, `~/Claude Code/Axcion AI Repo`; `read,execute` on the version binary; `read,write,search` inherited on the checkout subtree including `.git` | ACL entries | remove each entry (`chmod -a#`) |
| 5 | `[ADMIN]` Install a **root-owned**, non-writable launch wrapper with a fixed argument shape | one file | delete it |
| 6 | `[ADMIN]` `visudo -f /etc/sudoers.d/…` — one rule: operator `ALL=(<actor>) NOPASSWD:` the wrapper and `/usr/bin/pkill`, `Runas` limited to the actor alone | privilege policy | delete the drop-in |
| 7 | `[ATTENDED]` As the actor, once: `codex login`, then `claude auth login` | actor credentials, in the actor's own store | `codex logout`, `claude auth logout` |
| 8 | `[ATTENDED]` As the actor: set `user.name`, `user.email`, and `safe.directory` for this checkout in the actor's `~/.gitconfig` | one file | delete it |
| 9 | `[ADMIN]` Disable GUI login for the actor account | login policy | re-enable |

The consequential steps are 3, 4, 5 and 6. Step 6 is the one that carries real risk: any rule that
permits an arbitrary command, or any `Runas` target other than the actor, converts this from a
containment boundary into a privilege-escalation surface.

### Fail-capable pre-implementation validation plan

It must be possible for this plan to return "no". Every check below has a stated failing outcome, and
the first three are the ones that decide the route.

**Decisive, operator-run:**

- **V1 — the privilege listing that Unit 1 could not run.** `sudo -n -l` as the operator. Viable if it
  shows exactly the drop-in rule from step 6 and no broader entry; **not viable** if the rule cannot be
  constrained to a single Runas target and a fixed command list.
- **V2 — Claude auth in a non-GUI session.** `sudo -u <actor> claude auth status`. Viable if it returns
  `loggedIn: true` with no GUI session present. **If it fails because the actor's login keychain is
  locked, the route is blocked** until one of these is shown to work without copying the operator's
  credential: a documented file fallback, `CLAUDE_CONFIG_DIR` relocation, or a long-lived token the
  actor obtains itself. An `ANTHROPIC_API_KEY` in the environment is a different auth and a different
  billing decision, and it collides with the credential scrub — treat it as an operator decision, not a
  workaround.
- **V3 — Codex auth in a non-GUI session.** `sudo -u <actor> codex login status`. Expected to pass,
  because storage is a file; fails the route if it does not.

**Positive controls:** `sudo -u <actor> git -C <checkout> status` succeeds (proves traversal, read and
`safe.directory`); the actor creates a scratch commit on a throwaway branch and it lands with the
actor's identity (proves write on `.git`); a live `--unattended` hop reaches its `system/init` event
(proves the profile is readable and the sandbox applies).

**Negative controls, each of which must FAIL to pass the test:** the actor reading `~/.claude.json`;
the actor listing `~/Documents`; uid 501 sending `kill -0` to an actor process (must be EPERM — this is
the boundary itself); `sudo -u <actor> /usr/bin/pkill -U 501` leaving a chosen operator bystander
alive; `sudo -u root …` and `sudo -u patrik.lindeberg …` being refused by the rule.

**Empty-boundary precondition:** `pgrep -U <actor-uid>` must be empty before the first hop, and a
non-empty result must fail closed with a distinct exit rather than launch.

**The 1a case itself, red then green:** the existing fully detached shape — `setsid`, double fork,
`closerange`, `exec` a SIP-protected binary — must still be ALIVE after a stop under today's dispatcher
(already recorded), and GONE after `sudo -u <actor> pkill -U <actor-uid>` under the boundary, while a
uid-501 bystander sharing the checkout survives. That pair is what would let a later unit claim the
literal guarantee; nothing short of it does.

### What Unit 3 may implement, if and only if V1–V3 return workable

Dispatcher changes only, inside the already-allowed paths: launch live actors through the wrapper;
add the empty-boundary precondition and UID-based teardown and verification; absolutise the profile's
`denyRead` to the operator's home; carry the per-hop environment across `env_reset` inside the wrapper;
keep the simulated seam at uid 501 with its existing handles; and retire the marker handle for live
actors only, with its own fail-capable evidence. Phase 1a stays open until the red/green pair above
exists. Phase 1f and every Phase 2 action remain outside.

## Blocker

**Three protected host checks stand between this design and an implementation unit, and none can be
run from uid 501 or resolved in the repository.**

1. The constrained `sudo` rule cannot be listed or verified read-only — the attempt was refused at the
   tool-permission layer in Unit 1 and was deliberately not retried by a broader route (V1).
2. Whether the actor's Claude authentication survives a non-GUI session is unknown, and it is the one
   answer that can invalidate the whole route (V2). Claude's credential is in the login keychain, and a
   `sudo -u` session does not unlock one.
3. Whether the actor can complete its own ChatGPT login without a permanent GUI account is unknown (V3).

No repository change can settle any of them, so this is not a Codex assessment question yet.

## Next action

**Operator.** Run V1, V2 and V3 — or authorize the setup steps needed to make them runnable — and
report the results. V2 is the one to watch: if the actor's Claude authentication cannot be read in a
non-GUI session without copying your credential, the dedicated-identity route is blocked and the task
returns to the choice you already declined once, rather than to another design attempt.

No account was created, no permission or privilege policy was changed, no credential was read, and no
product file was touched. Only this state file changed. Phase 1a remains open and Phase 2 remains
forbidden.

Codex assesses this unit after the operator's checks return, not before.
