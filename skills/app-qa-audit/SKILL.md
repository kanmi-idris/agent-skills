---
name: app-qa-audit
description: End-to-end QA skill for Android APKs, mobile builds, and live webapps, with optional Maestro E2E automation for mobile. Use this whenever the user wants deep QA on a mobile app or webapp, wants test plans or manual test cases, wants Android UI execution or URL-based browser testing, regression suites, issue logs with repro steps, dark mode or visual validation, hidden-module discovery, APK reverse engineering, network or API extraction, Postman collections, CORS or app-trust checks, pre-release performance and reliability validation, or wants stable Maestro flows for repeatable mobile E2E testing.
---

# App QA Audit

An app QA operator skill for real shipped builds and live web URLs, not just requirement documents.

This skill should behave like a QA operator who can:

- understand scope from docs and live product surfaces
- test a mobile build or a live webapp
- create deep edge-case packs and smaller regression suites
- log issues with exact reproduction paths and evidence
- retest visual themes and loading states
- discover hidden modules and gated flows
- reverse engineer APKs when the UI is not enough
- extract APIs and turn them into Postman assets
- challenge false backend trust assumptions
- define non-functional readiness work
- optionally package stable mobile flows into Maestro E2E automation

## Input Modes

Support both:

- `APK/build mode`
  - Android APK, mobile build, device or emulator access
- `URL/webapp mode`
  - live webapp URL, browser access, optional credentials

Always identify the mode first and make it explicit in the output.

## Use This Skill When

Trigger on requests like:

- deeply analyze this app
- create QA strategy or test plan
- generate auth, dashboard, tracking, AI, notification, profile, legal, or module test cases
- build smoke or regression suites
- rerun a flow and log passes and failures
- log bugs with reproduction steps
- retest dark mode or UI rendering issues
- map hidden screens, routes, or modules
- reverse engineer an APK
- extract APIs or create a Postman collection
- test whether the backend is really restricted to the official app
- validate performance, speed, or reliability
- convert stable mobile flows into Maestro automation
- open this URL and test the webapp

Do not use this skill for:

- pure unit-test or source-only implementation tasks
- abstract QA theory discussions where no artifact is wanted
- forcing automation on unstable flows unless the user explicitly wants that risk

## What The Skill Should Produce

Pick the smallest set of outputs that satisfies the request, but prefer real artifacts over advice.

Possible outputs:

- product-understanding summary
- QA strategy
- execution checklist
- daily QA report template
- module or route map
- UI edge-case pack
- regression suite
- issue log
- execution report
- hidden-module analysis
- reverse-engineering workspace
- API inventory
- Postman collection and environment
- security assessment
- performance or reliability to-do or test pack
- Maestro automation plan or `.maestro/` package

## Core Workflow

### 1. Build context first

- Read all available docs, CSVs, and client materials.
- Explain the product in QA terms.
- Extract scope, deliverables, constraints, and open questions.
- Use the docs to anchor the work instead of guessing.

### 2. Establish the live surface

- In `APK/build mode`, launch the Android build and identify reachable pre-auth and post-auth surfaces.
- In `URL/webapp mode`, open the live URL and identify reachable pre-auth and post-auth routes.
- Determine blockers such as auth, OTP, permissions, cookies, hidden routing, or environment failures.
- Prefer live-product truth over documentation alone.

### 3. Generate two layers of tests

For each area under test, create:

- a deep edge-case pack
- a smaller prioritized regression suite

At minimum, think in these categories:

- positive flow
- validation failures
- empty states
- repeated actions
- network failure
- slow response
- `500` resilience
- session behavior
- platform or browser state
- privacy and abuse behavior
- visual consistency

### 4. Log issues like a QA operator

For every failed case, capture:

- title
- severity
- area or module
- exact reproduction path
- expected behavior
- actual behavior
- evidence file names

For execution reports, explicitly mark passes and failures.

### 5. Treat visual QA as a real pass

Run a dedicated visual retest when the user flags:

- dark mode
- border rendering
- theme mismatch
- spinner or loader states
- spacing
- OTP cell rendering
- responsiveness

Retake screenshots if the first capture is weak.

### 6. Probe for hidden modules

Look beyond obvious navigation:

- dashboard carousels
- cards and tiles
- profile lower-menu items
- drawers and tabs
- secondary menus
- rewards, store, facilities, feedback, and account surfaces

Separate:

- confirmed reachable hidden modules or routes
- strong evidence of shipped but not yet opened surfaces

### 7. Deep inspection when the UI is not enough

For `APK/build mode`:

- create a separate reverse-engineering workspace
- decode the manifest
- expose strings
- inspect the Hermes bundle
- build a screen and route map
- extract security review targets

For `URL/webapp mode`:

- map routes from the running app
- inspect navigation, DOM states, storage, and network behavior
- capture hidden navigation paths and backend calls
- summarize security-relevant surfaces such as auth, uploads, payments, embedded content, and browser storage

Optimize for readable outputs, not rebuildability.

### 8. Extract APIs and turn them into QA assets

Recover:

- base URLs
- route names
- payload shapes
- request patterns
- trust patterns and auth assumptions

Then generate:

- human-readable endpoint inventory
- machine-readable inventory
- Postman collection
- Postman environment

For mobile APKs, extract these from the bundle when possible.  
For webapps, derive them from observed network behavior.

If the API spec is missing, say so clearly and mark placeholders where needed.

### 9. Validate security claims, not just functionality

If the user wants to know whether the backend is app-only or trusted:

- test preflight and `Origin` behavior
- test direct non-browser requests
- test spoofed client metadata
- explain why CORS alone is not an app-trust control
- distinguish browser-origin exposure from real server-side trust

### 10. Add non-functional QA

When readiness matters, include:

- performance
- speed
- reliability
- retries
- timeouts
- long-session stability
- degraded backend behavior
- OCR and AI latency
- crash-free behavior

Keep this as a distinct workstream, not a footnote.

## Optional Webapp Mode

When the user provides a URL instead of an APK:

- use browser automation and live inspection
- map routes, auth states, logged-in surfaces, and hidden paths
- create the same quality of edge-case packs and regression suites
- log browser-visible issues with screenshots and reproduction steps
- use network inspection when API inventory or Postman follow-up is requested

Expected webapp outputs:

- route or module map
- browser execution report
- UI edge-case pack
- regression suite
- issue log
- hidden-route analysis
- API or network inventory if requested

## Optional Maestro E2E Layer

Use Maestro only when the user wants automation, repeatable E2E flows, CI-ready mobile tests, or flaky mobile test stabilization.

Treat Maestro as an automation extension of the manual QA work, not a replacement for discovery.

### When Maestro fits

- stable user journeys already exist in the manual or regression packs
- the team wants smoke or regression automation
- source access exists and `testID` values can be added
- the UI is stable enough to use text or relative selectors safely

### Maestro rules to preserve

- prefer `testID` selectors when source access exists
- use text or relative selectors deliberately when `testID` is unavailable
- derive flows from stable manual regression paths
- build adaptive auth-aware flows where practical
- add an auth-resolution marker like `auth-loaded` when source access exists and auth races are likely
- verify optimistic updates with short state-driven waits
- dismiss native dialogs explicitly
- use sub-flows for shared sequences
- for OTP, prefer one input per digit if the UI auto-advances
- use controlled staging or mock API dependencies for flaky backend flows
- if Maestro MCP is available, use it to run and refine flows after authoring them

### Platform caveats

- iOS `clearState` does not clear Keychain-backed auth
- iOS cold boot may need a tiny post-launch interaction
- Android permission dialogs must be handled explicitly
- use platform-gated sub-flows when UI differences are real

### Expected Maestro outputs

- `.maestro/` folder plan or real files
- main flow YAML files
- reusable sub-flows
- selector strategy notes
- helper scripts if needed
- CI or Maestro Cloud notes when requested

## Deliverable Templates

### Test plan

Always include:

- objective
- product understanding
- scope
- phases
- risk-based order
- defect reporting standard
- deliverables
- entry criteria
- exit criteria
- open questions

### Manual test pack

Use:

```markdown
## [Area]

- [ ] `ID` Title
  - Preconditions:
  - Steps:
  - Expected:
  - Notes:
```

### Regression suite

Use:

```markdown
### `ID`

- Priority: `P0 | P1 | P2`
- Title:
- Steps:
  1. ...
- Expected:
  - ...
```

Also include usage guidance such as smoke, post-fix, and signoff packs.

### Issue log

Use:

```markdown
### [Number]. [Severity] - [Title]

- Area:
- Steps:
  1. ...
- Expected:
- Actual:
- Evidence:
```

### Execution report

Use:

```markdown
## Passed
- [x] `ID` ...

## Failed / Issues Found
- [ ] `ID` ...
  - Actual:
  - Reproduction path:
  - Expected:
  - Evidence:
```

### Security assessment

Use:

- key conclusion
- confirmed live results
- what this means for testing
- recommended security position
- source references

### Maestro package

Use:

```text
.maestro/
├── README.md
├── flows/
├── scripts/
└── [feature-flow].yaml
```

Each flow should include:

- purpose
- prerequisites
- selector strategy
- launch and auth pre-flight
- main user actions
- assertions
- screenshots at key checkpoints
- environment or mock-server dependency notes

## Anti-patterns

Avoid:

- writing only happy-path cases
- generating generic test cases with no product context
- claiming hidden surfaces without separating confirmed versus inferred evidence
- treating CORS as proof that only the app can access the API
- logging bugs without exact reproduction paths
- mixing functional pass status with visual-quality pass status
- assuming the first screenshots are good enough
- creating API cases without stating whether routes are confirmed or placeholders
- stopping at planning when the user clearly wants execution
- treating a live webapp URL like static documentation
- skipping route or network inspection when the user asked for deep web analysis
- forcing Maestro automation on unstable flows
- relying on brittle index-based selectors when better selectors exist
- using long blind waits instead of state-driven waits in Maestro
- assuming mobile E2E auth resets the same way on Android and iOS
- writing Maestro helper scripts with unsupported async browser APIs

## Verification Checklist

Before finishing:

### Planning outputs

- [ ] Product is explained in QA terms
- [ ] Deliverables are explicit
- [ ] Scope and risks are documented
- [ ] Open questions are listed
- [ ] Input mode is clear: APK/build or URL/webapp

### Test packs

- [ ] Edge cases go beyond happy path
- [ ] Regression pack is smaller and prioritized
- [ ] Negative paths include network and `500` resilience where relevant
- [ ] Cases are grouped logically by module or flow

### Issue logs

- [ ] Repro steps are exact
- [ ] Expected vs actual is clear
- [ ] Evidence is named
- [ ] Severity is usable by a team

### Inspection outputs

- [ ] Screen, route, or module map exists
- [ ] Hidden or gated surfaces are called out
- [ ] API inventory exists if requested
- [ ] Trust or security patterns are called out

### Webapp outputs

- [ ] Route coverage is explicit
- [ ] Browser-visible issues include screenshots and repro steps
- [ ] Network-derived API observations are labeled clearly

### Postman outputs

- [ ] Collection imports cleanly
- [ ] Environment variables are present
- [ ] Security probes are included when relevant

### Maestro outputs

- [ ] Flows are derived from stable manual paths
- [ ] Selector strategy is explicit
- [ ] Auth-state handling is deliberate
- [ ] Shared sequences are extracted into sub-flows where useful
- [ ] Environment prerequisites are documented

## Project References

If the target project already contains QA strategy docs, checklists, execution reports, route maps, reverse-engineering notes, or Postman exports, treat them as the strongest local examples and align output structure to them instead of inventing a new format.

External references when relevant:

- Maestro docs: `https://docs.maestro.dev/`
- Maestro selectors: `https://docs.maestro.dev/api-reference/selectors`
- Maestro MCP: `https://docs.maestro.dev/getting-started/maestro-mcp`
- Maestro Cloud: `https://docs.maestro.dev/cloud`

## Keep Outside The Core QA Skill

These are adjacent but commercial, not executional:

- pricing docs
- proposal docs
- quote docs
- client-questionnaire docs
