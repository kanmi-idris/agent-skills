# Flow Building Reference

Use this reference when writing or repairing Maestro YAML flows.

## Flow Anatomy

A flow has an optional configuration section, a `---` separator, and a commands section.

```yaml
appId: com.example.app
name: Checkout happy path
tags:
  - regression
env:
  PRODUCT_NAME: "Headphones"
---
- launchApp
- tapOn: "Search"
- inputText: ${PRODUCT_NAME}
- pressKey: Enter
- assertVisible: ${PRODUCT_NAME}
```

Use `url:` instead of `appId:` for web tests.

## Selector Strategy

Use the lightest selector that is stable enough:

1. `text`: Best when visible copy is the user contract.
2. `id`: Best for icons, localized text, repeated controls, or product copy that changes often.
3. `description`: Useful for Android accessibility labels/content descriptions.
4. `index`: Useful only when duplicate text is unavoidable and order is stable.
5. `point`: Last resort for controls not represented in the accessibility tree.
6. Relational selectors such as `below`, `above`, or `childOf`: Best when a target is only unique near a stable anchor.

Simple text selector:

```yaml
- tapOn: "Login"
```

Precise selector:

```yaml
- tapOn:
    id: "submit_button"
    enabled: true
    below: "Password"
```

Regex is supported for text and IDs. Use it for dynamic values:

```yaml
- assertVisible:
    text: "Order #[0-9]+"
```

## Core Commands

Use these commands for most flows:

```yaml
- launchApp:
    clearState: true
- openLink: "myapp://checkout"
- tapOn: "Continue"
- inputText: "maestro_user"
- eraseText
- pressKey: Enter
- assertVisible: "Success"
- assertNotVisible: "Loading"
- scrollUntilVisible:
    element:
      text: "Item #50"
    direction: DOWN
- setPermissions:
    permissions:
      notifications: allow
- takeScreenshot: "checkout-success"
```

For launch arguments, test-mode detection, and detailed permission handling, read `app-integration.md`.

## Waits and Timing

Prefer assertions as waits. Maestro polls until the assertion is satisfied or times out.

```yaml
- tapOn: "Submit"
- assertVisible: "Success"
```

Use `extendedWaitUntil` for known long operations:

```yaml
- extendedWaitUntil:
    visible: "Payment Confirmed"
    timeout: 30000
```

Use `waitForAnimationToEnd` when elements are visible but still moving:

```yaml
- waitForAnimationToEnd:
    timeout: 5000
```

If a tap sometimes lands before the UI responds, combine a stable selector with retry behavior:

```yaml
- tapOn:
    text: "Continue"
    retryTapIfNoChange: true
```

## Nested Flows

Extract repeated journeys into `.maestro/subflows/`.

```yaml
# .maestro/flows/profile.yaml
appId: ${APP_ID}
---
- launchApp
- runFlow:
    file: ../subflows/login.yaml
    env:
      USERNAME: ${USERNAME}
      PASSWORD: ${PASSWORD}
- assertVisible: "Profile"
```

```yaml
# .maestro/subflows/login.yaml
- tapOn:
    id: "username_input"
- inputText: ${USERNAME}
- tapOn:
    id: "password_input"
- inputText: ${PASSWORD}
- tapOn:
    id: "login_button"
```

Keep subflows atomic: `login.yaml`, `logout.yaml`, `dismiss-onboarding.yaml`, `grant-permissions.yaml`, and `create-test-data.yaml` are easier to reuse than broad scenario files.

## Conditions

Use `when` for platform branches or dynamic UI.

```yaml
- runFlow:
    when:
      platform: Android
    file: ../subflows/android-permissions.yaml

- runFlow:
    when:
      visible: "Skip"
    commands:
      - tapOn: "Skip"
```

Use `optional: true` for one-off cleanup taps where absence should not fail the test:

```yaml
- tapOn:
    text: "Dismiss"
    optional: true
    label: "Dismiss transient popup"
```

Use JavaScript conditions for feature flags or computed state:

```yaml
- runFlow:
    when:
      true: ${IS_FEATURE_ENABLED == true}
    file: ../subflows/new-feature.yaml
```

For JavaScript scripts, `output`, faker data, HTTP setup, and logging, read `javascript.md`.

## Loops

Use fixed loops for known repetition:

```yaml
- repeat:
    times: 5
    commands:
      - tapOn: "Add Item"
      - tapOn: "Save"
```

Use conditional loops for dynamic state:

```yaml
- repeat:
    while:
      notVisible: "Your inbox is empty"
    commands:
      - tapOn: "Delete Message"
      - tapOn: "Confirm"
```

Add a safety cap when the stop condition might never happen:

```yaml
- repeat:
    times: 10
    while:
      visible: "Update available"
    commands:
      - tapOn: "Dismiss"
      - assertNotVisible: "Dismiss"
```

## Parameters and Constants

Pass runtime values from the CLI:

```bash
maestro test -e APP_ID=com.example.app -e USERNAME=user@example.com .maestro/
```

Use shell env vars with `MAESTRO_` prefix when running through the CLI:

```bash
export MAESTRO_API_KEY="secret"
maestro test .maestro/
```

Define defaults in flow config:

```yaml
appId: ${APP_ID}
env:
  USERNAME: ${USERNAME || "guest@example.com"}
---
- launchApp
```

Common built-ins include `MAESTRO_FILENAME`, `MAESTRO_DEVICE_UDID`, `MAESTRO_SHARD_ID`, and `MAESTRO_SHARD_INDEX`.

## Hooks

Use hooks for consistent setup and cleanup around every flow.

```yaml
appId: ${APP_ID}
onFlowStart:
  - runFlow: subflows/login.yaml
onFlowComplete:
  - runFlow: subflows/logout.yaml
---
- launchApp
- assertVisible: "Home"
```

Keep hooks fast. A slow hook runs for every flow and can dominate suite time.

## Locale Testing

Locales are set outside flows. Start a device with a locale, then run tagged flows.

```bash
maestro start-device --platform android --device-locale fr_FR
maestro test --include-tags french .maestro/
```

Do not put locale selection in `launchApp` or flow config. For web, Maestro does not control Chrome's internal language settings.

For supported locale examples and the full rules for `--device-locale`, read `locales.md`.
