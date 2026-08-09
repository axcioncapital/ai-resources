---
task: work-loop-v2-phase1a-full-descendant-termination
turn: codex
---

## Objective and scope

Close Phase 1 item 1a literally: every controlled dispatcher stop must terminate and verify the
actor's full descendant tree, including a descendant that calls `setsid`, double-forks, closes every
inherited descriptor and `exec`s another program. A stop must not signal an unrelated process and
must never claim success when termination or verification is incomplete.

The operator preserved this guarantee on 2026-08-08. The operator has now authorized **Stages B and
C only**: a temporary, non-admin actor account and the bounded feasibility checks for actor-owned
Claude/Codex authentication, UID-scoped termination and read-only Git access. Stages D and E are not
authorized: no operator-home permission or ACL change, `sudoers`, permanent launch wrapper,
dispatcher implementation or permanent production setup may occur.

The task closes only after the guarantee is implemented and supported by fail-capable simulated
regression evidence plus effective live Darwin evidence. Phase 1f and every Phase 2 action remain
outside this task; Phase 2 stays forbidden.

## Lane and unit

Standard. Discovery mode. Unit 9 — determine whether the exact persona-management entitlement has a
supported operator-accessible signing or provisioning path. This unit resolves that one read-only
unknown before any broader persona escape analysis or live probe is considered.

Named reason for the loop: literal Phase 1a still needs a Darwin supervision mechanism. Unit 8 is
accepted after its correction and final tightly-bounded fix: persona is unusable under current
authority, entitlement obtainability is unresolved, and the induced-helper escape route remains a
separate later question. Settling obtainability is the smallest justified next unit because persona
cannot become usable at all unless that gate has a supported path.

Plan justification: the governing unattended-operation plan still blocks Phase 2 on literal 1a and
1f. Persona is the strongest boundary found so far if its entitlement is obtainable, while Unit 8
proved it unusable under current authority without settling that question. This read-only discovery
unit tests the remaining gate without entering implementation, requesting new authority or weakening
the full-descendant and no-bystander requirements.

### Unit 9 brief — executed

Codex's brief for this unit, moved here verbatim from `## Next action` when the unit completed, so
that field states the single next thing. The Unit 8 brief that previously stood here is committed at
`ce6a820` and was removed from this file as prior-unit history (core § 4, current truth not a diary).
The brief itself is not altered; the result is in `## Latest result` below.

Claude: execute Unit 9 as one bounded read-only discovery unit. Determine whether
`com.apple.private.persona-mgmt` can be authorized through any **supported** signing or provisioning
path available to the operator on a normal SIP-enabled release Mac. Return evidence and a verdict
only. Do not sign, compile, install or execute a test binary, request account access or prescribe an
implementation.

Why this unit, why now, and plan alignment: Unit 8 is accepted and proved persona unusable under
current authority, but it withdrew the unsupported claim that the entitlement is unobtainable. The
governing plan still blocks Phase 2 on literal 1a; resolving this gate is the smallest next step because
persona cannot be a candidate at all without it, while induced-helper analysis matters only if the gate
can be crossed.

**Governing sources and dispositions:** `## Objective and scope`, the current unattended-operation
plan and the accepted Unit 8 result govern. Unit 8's Apple XNU test entitlements and bounded host
inventory are evidence leads, not proof that release AMFI will honor a non-Apple signature. The two
remaining uses of "the rejection" are Deferral 14 and do not govern. Unit 7's ASID root-bearing form
and Unit 8's induced-helper route stay outside this unit as adjacent work deliberately held back.

**Named unknown:** does Apple document or otherwise establish a supported operator-accessible route
by which a locally built executable can receive and effectively use
`com.apple.private.persona-mgmt` on this host class, or is the entitlement restricted to Apple-authorized
platform software?

**Claims to check:**

1. Inspect official Apple primary documentation, published entitlement metadata or schemas, current
   SDK/Xcode material and Apple-published source that bear directly on this exact key. Establish how
   Apple classifies it and whether it appears in any supported capability, provisioning-profile or
   entitlement-authorization surface available to ordinary developers. A `com.apple.private.*`
   prefix, plist declaration or code-signing build setting is not proof of effective authorization.
2. Distinguish requesting an entitlement in a signature from AMFI accepting it at launch. Establish
   what supported mechanism authorizes restricted entitlements for development, ad hoc, Developer ID,
   App Store or other relevant signing paths, and whether any such documented path covers this exact
   key. Do not generalize from a different restricted entitlement.
3. Reconcile Apple's XNU `tests/persona.entitlements` and `CODE_SIGN_ENTITLEMENTS` use with release-host
   enforcement. Determine what that test artifact proves, what build or trust context it assumes, and
   why it does or does not transfer to a normal SIP-enabled release Mac with an operator-accessible
   identity.
4. Establish whether local self-signing, an operator-held development identity, a provisioning profile
   or any other supported operator-accessible route could confer the key. Do not inspect Keychain,
   credential, certificate-private-key, account or provisioning-profile contents; use public interfaces,
   schemas, help and documentation only. State every inspection or retrieval failure rather than
   treating it as denial.
5. If primary evidence cannot settle the question read-only, identify the exact missing fact and the
   minimum separately authorized live check that would settle it, without designing or running that
   check. Do not turn an unresolved documentation question into an operator decision unless the
   evidence shows that an account-authenticated, signing or execution check is the only remaining way.
6. State the consequence for progression only: if a supported path is established, the induced-helper
   escape question remains before persona can be accepted; if supported denial is proved, persona is
   rejected; if unresolved, name the precise blocker. Do not implement, probe or reopen ASID.

**Verdict:** return exactly one: **supported operator-accessible path established**, naming the path
and its documented prerequisites; **supported path unavailable**, only if primary evidence proves
that for this exact key and host class; or **unresolved**, naming the missing primary evidence and
whether a separately authorized live check is necessary. Do not promote suggestive evidence into a
verdict.

**Evidence:** list every local primary surface and official Apple source used, with version or retrieval
date where relevant. Quote or precisely cite the language that settles authorization rather than only
signature declaration. Separate observation from inference; state all retrieval failures; reconcile
evidence that points both ways; and show what evidence would have produced each alternative verdict.
The evidence must be capable of proving the path unavailable, not just finding another entitlement
plist.

**Scope and stops:** this state file only. Read-only inspection of repository sources, local manuals,
SDK/Xcode metadata and official Apple primary sources is allowed. No Git inspection by Codex is needed;
Claude may make the single state-file commit required by the Work Loop. Do not signal any process;
do not delete, log into, authenticate, or otherwise mutate `wlactor-airesources` (uid 502); do not
inspect Keychain or credential contents; do not sign, compile, install or execute a probe; do not
launch Claude, Codex, the dispatcher, C5 or rollback; do not create/change a persona; and do not enter
Stages D/E, Phase 1f or any Phase 2 action. Stop and hand back if the premise fails, primary evidence
cannot be obtained read-only, or answering would require any forbidden host or account action.

**Unit completion:** replace `## Latest result` with the Unit 9 verdict and evidence needed for the
next progression decision, update `## Blocker` truthfully, set `turn: codex`, commit only this state
file, and stop. Preserve the accepted Unit 8 conclusions, Deferral 14, literal Phase 1a and the live
account's untouched status; do not create another artifact or push.

## Latest result

**Unit 9 (Discovery) — VERDICT: UNRESOLVED.** The authorization *mechanism* is now documented and every
supported capability surface has been read, but no primary source classifies **this exact key** as
restricted rather than unrestricted, and no host-side enumeration of restricted keys exists. The
missing fact and the minimum separately authorized live check are named below. Read-only throughout:
nothing compiled, signed, installed or executed as a probe; no persona created or changed; no signal;
no `sudo`; no account action, login or authentication; no Keychain, credential or provisioning-profile
contents read; no repository file other than this one.

**Why not "supported path unavailable".** Every documented route is closed and Apple's own support
engineering says the class cannot be granted to third parties — but the final link, that
`com.apple.private.persona-mgmt` is a *restricted* entitlement rather than an unrestricted one, rests
on the `com.apple.private.*` prefix. Resting a verdict on that prefix is the exact inference Unit 8's
correction round withdrew. The brief also set the bar explicitly: "supported path unavailable, only if
primary evidence proves that for this exact key and host class." It does not.

### Host class — measured, 2026-08-09

| Surface | Command | Observed |
|---|---|---|
| OS | `sw_vers` | `macOS 26.5.2`, build `25F84` |
| SIP | `csrutil status` | `System Integrity Protection status: enabled.` |
| Boot-args | `nvram boot-args` | `Error getting variable - 'boot-args': (iokit/common) data was not found` — no AMFI or code-signing relaxation boot-arg is set |
| Toolchain | `xcode-select -p` | `/Library/Developer/CommandLineTools` — Command Line Tools only, no full Xcode |
| SDK | `xcrun --show-sdk-version` | `26.2` |

Observation, not inference: this is a normal SIP-enabled release Mac with no AMFI bypass in place,
which is the host class the brief asked about.

### Claim 2 — the documented mechanism: declaring an entitlement is not being granted one

Apple's TN3125 *Inside Code Signing: Provisioning Profiles* is the governing documentation. Retrieved
2026-08-09 through the documentation JSON endpoint (see retrieval failures below). Quoted verbatim.

From **"Entitlements on macOS"**:

> A macOS app can claim certain entitlements without them being authorized by a provisioning profile.
> These *unrestricted entitlements* include:
> - `com.apple.security.get-task-allow`
> - `com.apple.security.application-groups`
> - Those used to enable and configure the App Sandbox
> - Those used to configure the Hardened Runtime

> In contrast, *restricted entitlements* must be authorized by a provisioning profile. This is an
> important security feature on macOS. For example, the fact that the `keychain-access-groups`
> entitlement must be authorized by a profile means that other developers can't impersonate your app
> in order to steal its keychain items.

> A Mac app that uses no restricted entitlements doesn't need a provisioning profile.

> macOS supports provisioning profiles for both App Store and Developer ID distribution. Some
> entitlements are not supported by Developer ID profiles.

From **"The how"**:

> Every profile has an `Entitlements` property which authorizes the app to use specific entitlements.

> The entitlements in the profile act as an allowlist. This isn't the same as the entitlements claimed
> by the app. To actually claim an entitlement, include the entitlement in the app's code signature.

> Every entitlement claimed by the app must be in the profile's allowlist but the reverse isn't true.

On who issues a profile:

> When the Apple Developer website creates a profile for you, it cryptographically signs it.

> You create provisioning profiles using the Apple Developer website, either directly using the
> website or indirectly using Xcode or the App Store Connect API.

**Consequence at launch**, from Apple DTS's *Resolving Trusted Execution Problems*
(developer.apple.com/forums/thread/706442, retrieved 2026-08-09):

> The app's executable might claim restricted entitlements that aren't authorised by a provisioning
> profile.

> And an app with unauthorised entitlements will be killed by the trusted execution system:
> `% OverClaim.app/Contents/MacOS/OverClaim` → `zsh: killed OverClaim.app/Contents/MacOS/OverClaim`

**Host-side corroboration that this machinery is live here** — `strings` over local binaries,
read-only:

- `/usr/libexec/amfid` exports `initWithURL:withFileOffset:withFlags:hasRestrictedEntitlements:hasOnlySoftRestrictedEntitlements:`,
  and carries `resetRestrictedRequirement`, `shouldUnrestrict`, `unsatisfiedEntitlements`,
  `areEntitlementsValidated`, `[migration] initiating provisioning profiles`.
- `/usr/libexec/taskgated-helper` carries `ProvisioningProfiles` and `unsatisfiedEntitlements`.

So the claim/grant distinction the brief asked for is established: a signature *requests* an
entitlement; a profile *authorizes* it; unauthorized restricted entitlements are stripped
(`hasOnlySoftRestrictedEntitlements`) or fatal at launch. **This is settled.**

### Claim 1 and 4 — every supported capability surface, read in full

- **Supported capabilities (macOS)**, Apple Developer Account Help, retrieved 2026-08-09. All 40
  entries read: App groups, App Sandbox, Apple Pay, Associated domains, AutoFill credential provider,
  ClassKit, Communication Notifications, Custom Network Protocol, DriverKit Family MIDI, FileProvider
  Testing Mode, FSKit Module, Game Center, Hardened runtime, Head Pose, HLS Interstitial Previews,
  HomeKit, iCloud: CloudKit, iCloud: iCloud documents, iCloud: iCloud key-value storage, In-App
  Purchase, Keychain sharing, Low Latency HLS, Managed App Installation UI, Maps, Matter Allow Setup
  Payload, MDM Managed Associated Domains, Media Extension Format Reader, Media Extension Video
  Decoder, Messages Collaboration, Network extensions, Personal VPN, Push notifications, Sensitive
  Content Analysis, Shared with You, Sign in with Apple, Spatial Audio Profile, System Extension, Time
  Sensitive Notifications, VMNet, WeatherKit. **None concerns process persona management.**
- **Provisioning with managed capabilities**, Apple Developer Account Help, retrieved 2026-08-09:
  > Managed capabilities require approval from Apple to use.

  The page enumerates no capability itself and names no persona capability.

**Apple DTS statements — Apple-published and attributed, but forum answers, not documentation.** Both
are from Quinn "The Eskimo!", Developer Technical Support, Apple:

> Regarding your question about entitlements, this is a restricted entitlement and thus must be
> authorised a profile. There's no way for a third-party developer to get a profile that authorises an
> Apple private entitlement.
> — developer.apple.com/forums/thread/756747, answering about `com.apple.private.driverkit.driver-access`

> Apple-private entitlements, which can't be granted to third-party developers.
> There's no way for a third-party developer to use Apple-private entitlements.
> — developer.apple.com/forums/thread/87740, answering about `com.apple.wifi.manager-access`

Inference, marked as such: the second pair is a **class-level** statement about Apple-private
entitlements, and `com.apple.private.persona-mgmt` is in that class by its literal prefix. That is a
strong reading. It is still an inference from the key's name, and it is the only thing standing
between this unit and a denial verdict.

### Claim 3 — what Apple's XNU persona test actually proves

Retrieved 2026-08-09 from `apple-oss-distributions/xnu`, `tests/Makefile`:

- The persona targets set the entitlement through the ordinary build setting:
  `persona: CODE_SIGN_ENTITLEMENTS = persona.entitlements` and
  `persona_adoption: CODE_SIGN_ENTITLEMENTS = persona_adoption.entitlements`.
- The signing invocation for entitlement-bearing targets is **ad hoc**:
  `$(CODESIGN) --force --sign - --entitlements $(CODE_SIGN_ENTITLEMENTS) --timestamp=none $(SYMROOT)/$@`.
  The identity is `-`.
- The makefile includes `$(DEVELOPER_DIR)/AppleInternal/Makefiles/darwintest/Makefile.common` — an
  **AppleInternal** path that is not published.

Local corroboration that Apple's own platform components are built in a different context: the AMFI
kext bundle's `Info.plist` records `DTSDKName = macosx26.5.internal`
(`/System/Library/Extensions/AppleMobileFileIntegrity.kext/Contents/Info.plist`).

**What it proves:** the key is requested through the same `CODE_SIGN_ENTITLEMENTS` mechanism any
developer uses, and Apple's test builds assume an Apple-internal environment whose makefile fragments
are not public.

**Evidence that points both ways, reconciled rather than glossed.** An ad-hoc signature carries no
Apple-issued profile. There are two readings and this unit cannot choose between them read-only:

1. The tests run on internal or development builds where AMFI enforcement is relaxed, so an ad-hoc
   signature claiming a restricted entitlement is honored there and would not be on this host. This is
   the reading consistent with the documented mechanism.
2. The key is **unrestricted**, in which case no profile is needed, ad-hoc signing is sufficient, and
   the same would hold on a release Mac — which would make persona obtainable.

Reading 2 is the one that would overturn the whole persona finding, and nothing retrieved this round
excludes it. That is the honest state of the evidence, and it is why the verdict is unresolved rather
than a denial.

### The exact missing fact

**Is `com.apple.private.persona-mgmt` a restricted entitlement or an unrestricted one, as AMFI treats
it on a release SIP-enabled macOS 26.5.2 host?**

Why it could not be settled read-only, with the surfaces named:

- TN3125's unrestricted list is introduced with "These *unrestricted entitlements* **include**:" —
  non-exhaustive wording. The documentation therefore does not place this key on either side.
- No Apple document retrieved names `com.apple.private.persona-mgmt` at all.
- **No on-disk enumeration of restricted keys was found.** Searched: `/System/Library/Security/`
  (contents: `Certificates.bundle`, `HardeningExceptions.plist`, `OSLaunchPolicyData`,
  `authorization.plist`, `ldapdl.bundle` — none is an entitlement allowlist); `strings` over
  `/usr/libexec/amfid`, `/usr/libexec/taskgated` and `/usr/libexec/taskgated-helper` for
  `restrict|entitlement|profile|allowlist|whitelist`. The only `com.apple.private.*` keys amfid names
  are its own six `com.apple.private.amfi.*` keys.
- **The AMFI kext binary is not on disk** and could not be inspected: the bundle at
  `/System/Library/Extensions/AppleMobileFileIntegrity.kext` contains only `Info.plist`,
  `version.plist` and `_CodeSignature`; the executable ships inside the boot kernel collection.
- **Bound stated rather than glossed:** the dyld shared cache, `/System/Library/PrivateFrameworks` and
  the boot kernel collection were **not** searched. This is not a whole-host absence claim.

### The minimum separately authorized live check — named, not designed, not run

Build a trivial local executable, sign it ad hoc with **only** `com.apple.private.persona-mgmt`, launch
it, and observe two things: whether it launches or is killed by the trusted execution system, and
whether `kpersona_alloc` returns success or `EPERM`. That single observation separates reading 1 from
reading 2 and settles the key's classification on this host class.

It requires compile, sign and execute authority, which this unit forbids and which the operator has not
granted. **Whether that authority is worth granting is Codex's assessment and then the operator's
decision — this unit does not ask for it and does not recommend it.** The brief's condition for
escalating is met on the surfaces searched: no Apple documentation enumerates restricted keys and no
host-side enumeration exists, so an execution check is the only remaining way found.

### What evidence would have produced each alternative verdict

This is what makes the round fail-capable — each alternative had a named surface, and each surface was
actually read rather than assumed empty.

- **"Supported operator-accessible path established"** would have required a macOS capability naming
  persona management, or a documented entitlement-request route covering it, or an Apple statement that
  the key is unrestricted. The macOS capability list was read in full (40 entries) and the managed-
  capabilities page was read; had either named persona, the verdict would be *established*.
- **"Supported path unavailable"** would have required an Apple document naming this exact key as
  platform-only, or a published exhaustive restricted/unrestricted classification placing it on the
  restricted side, or a host-side restricted-key list. All three were searched; TN3125's list is
  explicitly non-exhaustive, no document names the key, and no host list exists.
- **"Unresolved"** is what survives. It is not a default: it is the result of both other verdicts
  having identified surfaces that were checked and did not carry them.

### Claim 6 — consequence for progression only

Persona is **neither viable nor rejected**, and is unchanged as unusable under current authority. If a
supported path were later established, Unit 8's induced-helper escape question would still have to be
resolved before persona could be accepted. If denial were proved, persona is rejected and the mechanism
search continues. Literal Phase 1a is unchanged, and Phase 2 stays blocked. Whether the next unit spends
authority on the live check above, on Unit 7's unresolved ASID root-bearing form, or on neither, is
Codex's assessment and is not asserted here.

### Retrieval and inspection failures — stated, not read as denial

- `https://developer.apple.com/documentation/security/signing-a-daemon-with-a-restricted-entitlement`
  → **HTTP 404**. Not retrieved.
- TN3125's HTML page returned its title and no body. Recovered through the documentation JSON endpoint
  `https://developer.apple.com/tutorials/data/documentation/technotes/tn3125-inside-code-signing-provisioning-profiles.json`,
  which is what the quotes above come from.
- `https://github.com/apple-oss-distributions/xnu/blob/main/tests/README.md` → **HTTP 404**. The build
  and run requirements for XNU's tests were therefore not read from a README.
- The `AppleInternal` darwintest makefile fragment that XNU's `tests/Makefile` includes is not
  published, so the exact generic recipe for entitlement-bearing targets could not be read; the
  codesign line quoted above is an inline recipe from the same file and is representative, not the
  generic rule.
- Web search result *summaries* were used only to locate candidate URLs. **No summary was used as
  evidence.** Every quotation above comes from a direct retrieval of the named page.

### Carried forward — accepted Unit 8 conclusions

Full Unit 8 record is committed at `ce6a820`; condensed here as current truth (core § 4).

- Both persona doors — `kpersona_alloc_syscall()` and `spawn_validate_persona()` — are gated on
  `com.apple.private.persona-mgmt` with **no superuser alternative**. Root does not satisfy an
  entitlement check.
- Nothing the dispatcher runs carries that entitlement, so persona is unusable **under current
  authority**. Entitlement obtainability was unresolved at Unit 8 and remains unresolved after Unit 9.
- Bounded scan of 1,788 executables across `/bin`, `/sbin`, `/usr/bin`, `/usr/sbin`, `/usr/libexec`:
  five carry the entitlement, all Apple platform binaries. `/bin/ps` and `/usr/bin/umtool` only read;
  `/sbin/launchd` and `/usr/libexec/usermanagerd` can spawn into or create personas but are reached
  through service interfaces, and whether either can be **induced** to do so for a caller was not
  established. `/System/Library`, framework bundles, XPC services and `/Applications` were not scanned.
- The `ps` persona column is readable by an unprivileged caller only because `/bin/ps` is setuid root
  and is itself entitled; the syscall returns `EPERM` to a non-root caller for any pid but its own.
- **Deferral 14 stands, uncorrected:** two places in the retained Unit 8 material called the outcome
  "the rejection" although that verdict was withdrawn. Those sentences left this file with the Unit 8
  record; the deferral is preserved here so it is not lost, and it remains Codex's call.
- The dispatcher's current reach is unchanged. The inherited-descriptor handle in `dispatch.sh` still
  reaches further than any candidate examined, and `dispatch.test.sh` case 27h still pins the surviving
  hole: a descendant that closes every inherited descriptor survives it. That hole is literal 1a's
  escaped shape.

## Blocker

**Persona's gate is now narrow and named, not open-ended.** Unit 9 closed the mechanism question — a
restricted entitlement is authorized only by an Apple-signed provisioning profile, no macOS capability
covers persona management, and Apple DTS states the private class cannot be granted to third parties.
One fact remains: whether this exact key is restricted or unrestricted as AMFI treats it on this host
class. Only a compile-sign-execute check settles it, and that authority does not exist in this task.

**The candidate space is still not proved empty.** Process group, ancestry-at-stop, environment tag,
working directory, `kqueue NOTE_TRACK`, launchd job removal, Darwin `ptrace`, containers and coalitions
were excluded by the closed supervision discovery. Unit 5 excluded the pattern-free UID signal as
over-broad, Unit 6 excluded the real GID as sheddable through setuid-root `newgrp`, Unit 7 found the
audit session unusable under current authority with its root-bearing form **unassessed**, and Unit 8
found persona unusable under current authority. Two mechanism questions stay open: ASID's root-bearing
form, and persona's entitlement classification.

**The dispatcher's current reach is the honest fallback position**, unchanged, with `dispatch.test.sh`
case 27h pinning the surviving hole.

**Attended probe authority and unattended production authority remain distinct.** Operator-attended
`sudo -u` does not give the dispatcher production authority; D4 stays unauthorized. Neither authority
supplies a code-signing entitlement, which is why persona's remaining question is about signing paths
rather than privilege.

**The account stays untouched, and was not touched or re-measured this unit.** No account action, login,
authentication or signal occurred. The last measurement stands from the Unit 8 close, 2026-08-09
15:33 EEST: `id -u wlactor-airesources` → 502, not a member of `admin`, and a uid-502 census of the same
three PPID-1 services — 82525 `distnoted`, 82526 `mdbulkimport`, 82530 `lsd`. It remains a
password-bearing login account with `/bin/zsh`, and actor reach into the operator home is unresolved
before D. Rollback R1 has not been reachable at any observation, so removal needs a separately verified
procedure. Nothing may signal, delete, log into or authenticate uid 502 in the meantime. C5 as written
stays unrunnable, and C1 and every later Stage C step stay stopped.

## Next action

Codex: assess Unit 9 and decide progression. The unit returned **unresolved** with one named missing
fact — whether `com.apple.private.persona-mgmt` is restricted or unrestricted as AMFI treats it on a
release SIP-enabled macOS 26.5.2 host — and the minimum check that would settle it is a compile, sign
and execute of a trivial entitled binary, which is authority this task does not have. The decision to
be made is whether the next unit pursues that check, pursues Unit 7's unresolved ASID root-bearing
form, pursues neither, or reframes the mechanism search. Deferral 14 remains open and uncorrected.
