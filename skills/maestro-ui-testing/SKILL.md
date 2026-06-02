---
name: maestro-ui-testing
description: Build, debug, and run Maestro UI automation for mobile and web apps. Use this skill whenever the user mentions Maestro, Maestro Studio, Maestro CLI, Maestro Cloud, YAML flows, mobile UI tests, black-box app automation, React Native/Expo E2E tests, iOS Simulator tests, Android emulator tests, Flutter/Compose/SwiftUI/UIKit automation, browser flows, locale testing, permissions, detecting Maestro in app code, JavaScript scripts in Maestro, config.yaml, test tags, reports, recordings, email OTP, SMS OTP, 2FA, verification codes, password reset codes, or wants reliable end-to-end user journey tests without app instrumentation.
---

# Maestro UI Testing

Use this skill to take a project from no Maestro coverage to a working local or CI-ready suite. Maestro tests apps at arm's length: it drives the device or browser through accessibility and input APIs rather than instrumenting app code.

## Default Workflow

1. Identify the target surface:
   - Mobile app: find Android package name or iOS bundle ID.
   - Web app: find the URL to open.
   - Expo Go: plan to use `openLink` with the `exp://` development URL instead of `launchApp` with the app's final ID.
2. Check environment readiness:
   - Verify Java 17+, `maestro --version`, and either Android tooling, Xcode Simulator tooling, or a web target.
   - If Maestro is missing, install it with the current official method. See `references/running-and-ci.md`.
3. Inspect the app's user journeys:
   - Prefer flows that represent user intent: smoke launch, signup, login, 2FA/OTP verification, onboarding, checkout, settings, notifications, permissions, and critical regressions.
   - Add or recommend stable accessibility IDs only where visible text is too brittle or not present.
   - For email/SMS OTP flows, use `references/otp-flows.md` and the `qa-email-sms-otp` skill for Mailpit, SMS Gateway, adb, and polling scripts.
4. Create a `.maestro/` suite:
   - Put complete tests in `.maestro/flows/`.
   - Put reusable pieces in `.maestro/subflows/`.
   - Use env vars for app IDs, credentials, URLs, and platform differences.
   - Add `config.yaml` once the suite needs nested discovery, global tags, output dirs, or execution order.
5. Write flows that are resilient by design:
   - Use visible text first when it expresses the UX contract.
   - Use `id` or accessibility identifiers for icons, repeated controls, localization, or unstable copy.
   - Use assertions as waits before reaching for explicit wait commands.
   - Assert the intended product outcome, not just that taps completed.
   - Use `scrollUntilVisible`, `runFlow`, `when`, and `repeat` instead of brittle coordinate-heavy scripts.
   - Use JavaScript only for dynamic data, API setup, custom state, or logic that YAML cannot express cleanly.
6. Run locally and debug:
   - Run `maestro test .maestro/` for the suite or `maestro test path/to/flow.yaml` for one flow.
   - Use `maestro test -c .maestro/` while iterating.
   - Use `maestro studio` or `maestro hierarchy` to inspect selectors when a command cannot find an element.
7. Prepare CI or cloud execution:
   - Pin credentials and app IDs via environment variables or CLI `-e` flags.
   - Use tags for smoke/regression/locale/platform subsets.
   - Use sharding or Maestro Cloud when local sequential execution becomes slow.

## Minimal Flow Skeleton

Use this as the starting point for app flows:

```yaml
appId: ${APP_ID}
name: Smoke - launch and login
tags:
  - smoke
env:
  USERNAME: ${USERNAME || "test@example.com"}
---
- launchApp:
    clearState: true
- assertVisible: "Login"
- tapOn:
    id: "username_input"
- inputText: ${USERNAME}
- tapOn:
    id: "login_button"
- assertVisible: "Welcome"
```

For web:

```yaml
url: ${BASE_URL}
name: Web smoke
tags:
  - smoke
---
- launchApp
- assertVisible: "Home"
- tapOn: "Sign in"
```

## Defect Retest Guardrails

Use these guardrails when testing known defects, flaky auth flows, OTP flows, toast-heavy apps, or user-reported regressions:

- Test one defect row per flow where practical: one setup, one action, one expected outcome, one evidence set.
- Treat a Maestro flow as incomplete until it asserts the defect-specific postcondition, such as Dashboard visible, OTP screen visible, account chooser visible, saved data persisted after leaving and returning, or a specific error/toast visible.
- Capture transient feedback immediately after submit actions. For toast-heavy apps, take evidence at roughly immediate, 1s, 3s, and 8-10s, and also collect focused logcat around the action.
- Reset logcat before each defect action, then save a short post-action logcat so parser errors, network failures, and backend messages are attributable to that test.
- Preserve authenticated state until all authenticated-only defects are tested. Run logout, account-clearing, password-change, external-browser, and destructive state tests late unless they are the target scenario.
- Use `launchApp: { clearState: true }` only for fresh onboarding/auth tests. Avoid clearing state for session restore, minimize/reopen, notification read state, referral routing, saved-data persistence, or profile update scenarios.
- Never treat placeholder text as entered user data. Focus the field, clear it explicitly when needed, type the value, and use screenshot or hierarchy evidence to verify the entered state.
- Prefer selectors over coordinates. If coordinates are necessary, capture a screenshot/hierarchy near the tap and document why a selector was not reliable.
- For flaky JSON/network/auth errors, retry the same action twice more with the same setup before classifying the issue. Keep each attempt's screenshot and logcat separate.
- For real carrier/backend OTP flows, do not claim emulator SMS simulation proves end-to-end verification. Use backend test numbers, Mailpit/SMS Gateway paths, or a physical SIM; otherwise mark the OTP validation blocked or partially verified.

Outcome-focused example:

```yaml
appId: ${APP_ID}
name: Auth - login reaches dashboard
---
- launchApp
- assertVisible: "Login"
- tapOn:
    id: "phone_input"
- inputText: ${PHONE}
- tapOn:
    id: "password_input"
- inputText: ${PASSWORD}
- tapOn: "Login"
- assertVisible: "Dashboard"
- takeScreenshot: "auth-login-dashboard"
```

Negative/toast-heavy example:

```yaml
appId: ${APP_ID}
name: Forgot password - invalid phone fails closed
---
- launchApp
- assertVisible: "Forgot Password"
- tapOn:
    id: "phone_input"
- inputText: ${PHONE}
- tapOn: "Request OTP"
- takeScreenshot: "forgot-submit-immediate"
- waitForAnimationToEnd:
    timeout: 1000
- takeScreenshot: "forgot-submit-after-1s"
- assertVisible:
    text: "Profile is not registered|Network request failed|Phone verification"
```

## Reference Map

Read only the reference file needed for the current task:

- `references/flow-building.md`: selectors, commands, waits, nested flows, conditions, loops, parameters, hooks, and locale patterns.
- `references/platforms.md`: React Native, Expo, Android native, Jetpack Compose, iOS, UIKit, SwiftUI, and Web selector guidance.
- `references/app-integration.md`: launch arguments for detecting Maestro, web `window.maestro`, permissions, and app-side test-mode behavior.
- `references/otp-flows.md`: integrating Maestro with the `qa-email-sms-otp` skill for Mailpit email OTP and Android SMS OTP flows.
- `references/javascript.md`: inline expressions, `evalScript`, `runScript`, `output`, logging, faker data, and HTTP requests.
- `references/workspace-management.md`: `config.yaml`, repository architecture, test discovery, tags, sequential execution, reports, artifacts, recordings, and analysis.
- `references/locales.md`: device locale rules, supported locale examples, and locale/tag run patterns.
- `references/running-and-ci.md`: install checks, device startup, targeting, Studio, CLI, sharding, locale startup, and cloud/CI handoff.

## Output Standard

When implementing Maestro coverage in a repo, finish with:

- Files created or changed, using absolute paths.
- The exact command used to run the flow or suite.
- Pass/fail result and the first failing selector or assertion if any.
- Any required app-side accessibility ID changes.
- Any app-side Maestro detection or permission changes.
- Any assumptions about app IDs, device state, credentials, or test data.

When only drafting flows without running them, say so explicitly and include the command the user should run.
