# Workspace Management Reference

Use this reference when a Maestro project grows beyond a few standalone flow files.

## Workspace Basics

A Maestro workspace usually contains:

```text
.maestro/
  config.yaml
  flows/
  subflows/
  scripts/
```

Each flow should still be able to run on a reset device. Use setup hooks, API setup scripts, or nested flows instead of depending on side effects from previous tests.

## `config.yaml`

`config.yaml` is optional for one-off local files, but useful when the suite needs:

- Nested flow discovery.
- Shared environment policy.
- Global tag filtering.
- Platform-specific behavior.
- Output directory defaults.
- Sequential execution order.

Place it at the root of the workspace directory passed to `maestro test`.

Studio does not currently support `config.yaml` locally, but Studio includes it when uploading an entire workspace to Maestro Cloud.

Run with the default config:

```bash
maestro test .maestro/
```

Run with a specific config:

```bash
maestro test --config .maestro/ci-config.yaml .maestro/
```

## Flow Discovery

By default, when the CLI points at a folder, it runs only top-level flow files. It does not recurse into subfolders unless configured.

Use `flows` glob patterns:

```yaml
# .maestro/config.yaml
flows:
  - "*"        # top-level flows
  - "auth/*"   # one subfolder
  - "tests/**" # recursive
```

Example smoke-only workspace:

```yaml
appId: com.example.app
flows:
  - "**"
includeTags:
  - smoke
```

## Tags

Add tags in the flow header:

```yaml
appId: com.example.app
tags:
  - smoke
  - registration
---
- launchApp
```

Filter with CLI flags:

```bash
maestro test .maestro/ --include-tags smoke
maestro test .maestro/ --exclude-tags wip
```

Multiple tags in one flag use OR logic:

```bash
maestro test .maestro/ --include-tags "auth,checkout"
maestro test .maestro/ --exclude-tags "experimental,stagingOnly"
```

Using include and exclude together applies include first, then removes excluded flows:

```bash
maestro test .maestro/ --include-tags dev --exclude-tags pull-request
```

There is no single-flag AND operator for "must have all these tags."

Global tag policy in `config.yaml`:

```yaml
includeTags:
  - production_ready
excludeTags:
  - experimental
  - flaky
```

CLI flags override global `config.yaml` tag settings.

## Repository Architecture

Choose the structure based on the product's user behavior.

Goal-driven apps such as ecommerce, fintech, food delivery, or booking apps should usually organize by user journeys:

```text
.maestro/
  config.yaml
  tests/
    new_users/
      register.yaml
      first_purchase.yaml
    existing_users/
      login.yaml
      checkout.yaml
  utils/
    set_discount_code.js
```

Habit-driven apps such as social, content, or entertainment apps should often organize by feature:

```text
.maestro/
  config.yaml
  auth/
    login.yaml
    login_invalid.yaml
  account/
    set_display_name.yaml
  checkout/
    complete_purchase.yaml
```

Use subflows for repeated mechanics and flows for user-visible scenarios.

## Sequential Execution

Maestro normally runs discovered flows in non-deterministic order because isolated tests are more robust. Use `executionOrder` only when a strict sequence is required.

```yaml
executionOrder:
  continueOnFailure: false
  flowsOrder:
    - signup_flow
    - verify_email_flow
    - complete_profile
```

Behavior:

- Listed flows run first, in order.
- Unlisted discovered flows run afterward in non-deterministic order.
- `continueOnFailure: true` keeps going after a failure.
- `continueOnFailure: false` stops dependent sequence execution.

If a flow needs a prior state, prefer `runFlow` or hooks to create that state inside the test rather than relying on a previous flow.

## Reports and Artifacts

Default artifact locations:

- macOS/Linux: `~/.maestro/tests`
- Windows: `%userprofile%\.maestro\tests`

Set the test output directory:

```bash
maestro test --test-output-dir=build/maestro-results .maestro/
```

or:

```yaml
testOutputDir: build/maestro-results
```

CLI `--test-output-dir` overrides `config.yaml`, which overrides the default.

Generate JUnit XML:

```bash
maestro test --format junit --output build/report.xml .maestro/
```

Generate HTML:

```bash
maestro test --format html --output build/report.html .maestro/
maestro test --format html-detailed --output build/detailed-report.html .maestro/
```

Report format is a CLI flag; it cannot be defined directly in `config.yaml`.

Add JUnit metadata in the flow header:

```yaml
appId: com.example.app
name: Login Flow
properties:
  testCaseId: "TC-101"
  priority: "High"
---
- launchApp
```

Artifact differences:

| Feature | `--test-output-dir` | `--debug-output` |
| --- | --- | --- |
| Screenshots and video | Yes | No |
| `maestro.log` | No | Yes |
| `commands-*.json` | Yes | Yes |
| AI reports | Yes | Yes |

If both flags point to the same directory, artifacts are consolidated. If they point to different directories, `--debug-output` receives only `maestro.log`; `--test-output-dir` receives screenshots, video, commands JSON, and AI reports.

## Recordings

Use local rendering for recordings:

```bash
maestro record --local .maestro/flows/checkout.yaml
```

Recordings are written under the normal Maestro test artifact location. Recordings are limited to about two minutes. The legacy remote-rendered `maestro record` path is being deprecated; prefer `--local`.

Use recordings for failure triage, stakeholder bug reports, and documenting critical paths.

## AI Analysis

For visual and internationalization checks, use Maestro's analysis option when appropriate:

```bash
maestro test --analyze .maestro/
```

Treat AI analysis as an additional signal, not a replacement for deterministic assertions.
