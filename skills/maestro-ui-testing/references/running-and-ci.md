# Running, Debugging, and CI Reference

Use this reference when installing Maestro, selecting devices, running flows, or preparing CI/cloud execution.

## Installation Checks

Before editing flows, check:

```bash
java -version
echo "$JAVA_HOME"
maestro --version
maestro --help
```

Maestro CLI requires Java 17 or higher. If Maestro is missing, current official install options include:

```bash
curl -fsSL "https://get.maestro.mobile.dev" | bash
```

or on macOS:

```bash
brew tap mobile-dev-inc/tap
brew install mobile-dev-inc/tap/maestro
```

For exact current install, update, and Windows/WSL steps, verify the official docs when network is available: https://docs.maestro.dev/maestro-cli/how-to-install-maestro-cli

## Local Device Setup

Android:

- Use Android Studio or `maestro start-device --platform android` to launch an emulator.
- Physical Android devices can be used when USB Debugging is enabled.
- Use `adb devices` to find device IDs.
- Ensure the app is installed before running a flow that launches by package name.

iOS:

- Install Xcode and Xcode Command Line Tools.
- Use an iOS Simulator.
- Use `xcrun simctl list devices booted` to find booted simulator IDs.
- Target apps by bundle ID.

Web:

- Maestro launches its managed Chromium instance.
- Use `url:` in flow config.

Start devices:

```bash
maestro start-device --platform android
maestro start-device --platform ios
maestro list-devices
maestro list-cloud-devices
```

Target a specific device:

```bash
maestro --device emulator-5554 test .maestro/
maestro --device 5B6D77EF-2AE9-47D0-9A62-70A1ABBC5FA2 test .maestro/
```

## Studio and Selector Discovery

Use Studio for fast authoring and hierarchy inspection:

```bash
maestro studio
```

Use hierarchy output when debugging from a terminal:

```bash
maestro hierarchy
```

Selector debugging process:

1. Confirm the target screen is visible.
2. Inspect available text, IDs, descriptions, and hierarchy.
3. Replace coordinates with text, ID, description, or relational selectors where possible.
4. Add app-side accessibility IDs only when the UI does not expose a reliable target.
5. Re-run the smallest failing flow.

## Running Flows

Run one flow:

```bash
maestro test .maestro/flows/login.yaml
```

Run the suite:

```bash
maestro test .maestro/
```

Continuous mode for authoring:

```bash
maestro test -c .maestro/
```

Pass variables:

```bash
maestro test \
  -e APP_ID=com.example.app \
  -e USERNAME=user@example.com \
  -e PASSWORD="$PASSWORD" \
  .maestro/
```

Use tags:

```bash
maestro test --include-tags smoke .maestro/
maestro test --exclude-tags flaky .maestro/
```

## Parallel and Sharded Runs

Run the full suite on multiple devices:

```bash
maestro test --shard-all 3 .maestro/
```

Split the suite across devices:

```bash
maestro test --shard-split 3 .maestro/
```

Specify devices:

```bash
maestro test --device "emulator-5554,emulator-5556" --shard-split 2 .maestro/
```

Avoid screenshot name collisions under sharding:

```yaml
- takeScreenshot: "LoginScreen-shard_${MAESTRO_SHARD_INDEX}-device_${MAESTRO_DEVICE_UDID}.png"
```

## Locale Runs

Set locale when starting a device or when using `maestro cloud`. Do not set locale inside `launchApp`, inside a flow, or on `maestro test`; `maestro test` uses the locale already configured on the target device.

```bash
maestro start-device --platform android --device-locale fr_FR
maestro test --include-tags french .maestro/

maestro start-device --platform ios --device-locale it_IT
maestro test --include-tags italian .maestro/
```

Use locale-specific tags in flows:

```yaml
appId: ${APP_ID}
tags:
  - french
---
- launchApp
- assertVisible: "Bienvenue"
```

`--device-locale` values are normally a language and country pair separated by `_`, such as `fr_FR` or `it_IT`. Maestro changes Android and iOS simulator/emulator system language and region, but it does not control Chrome's internal language settings for web tests. Read `locales.md` for supported examples and locale/tag patterns.

## CI and Cloud Handoff

For local CI:

1. Install Java 17+ and Maestro CLI.
2. Build and install the app under test.
3. Start or connect the target device.
4. Run tagged flows with app IDs and credentials from CI secrets.
5. Upload screenshots, logs, and Maestro artifacts if the test runner produces them.
6. Generate JUnit or HTML reports when CI needs structured output. See `workspace-management.md`.

For large suites, use Maestro Cloud to avoid local device management and run flows in parallel. Prefer cloud execution when:

- The suite is slow locally.
- iOS simulator capacity is the bottleneck.
- Multiple device models or OS versions are required.
- PR feedback needs deterministic infrastructure.

Keep flows cloud-compatible by avoiding assumptions about local paths, local server reachability, and pre-existing device state unless explicitly created in setup.
