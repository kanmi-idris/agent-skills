# OTP Flow Integration

Use this reference when Maestro needs to test email OTP, SMS OTP, 2FA, verification codes, password reset codes, or signup/login flows that require a one-time password.

## Use the OTP Skill as Source of Truth

For local email and Android SMS OTP handling, read and use:

```text
${CODEX_HOME:-$HOME/.codex}/skills/qa-email-sms-otp/SKILL.md
```

Do not duplicate Mailpit or SMS Gateway polling logic in this skill. The `qa-email-sms-otp` skill owns:

- Mailpit API v1 details.
- Temporary local email generation.
- Email OTP polling.
- Android emulator SMS simulation.
- SMS Gateway Local Server polling.
- Physical-device warning for real carrier SMS OTPs.

Set the OTP skill directory in shell wrappers:

```bash
OTP_SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/qa-email-sms-otp"
```

## Orchestration Pattern

Maestro flows are best kept declarative. The OTP scripts are shell scripts, so run them outside Maestro in a wrapper script, then pass values into Maestro with `-e`.

Use a two-stage pattern:

1. Run a Maestro flow that requests the OTP and stops on the OTP entry screen.
2. Poll the OTP with `qa-email-sms-otp` scripts.
3. Run a second Maestro flow that enters `${OTP}` and asserts success.

This is usually more reliable than trying to make one Maestro flow do everything, because Maestro JavaScript cannot run local shell scripts or Node libraries.

## Email OTP with Mailpit

Example request flow:

```yaml
# .maestro/flows/request-email-otp.yaml
appId: ${APP_ID}
name: Request email OTP
---
- launchApp:
    clearState: true
- tapOn: "Sign up"
- tapOn:
    id: "email_input"
- inputText: ${EMAIL}
- tapOn:
    id: "continue_button"
- assertVisible: "Enter verification code"
```

Example submit flow:

```yaml
# .maestro/flows/submit-email-otp.yaml
appId: ${APP_ID}
name: Submit email OTP
---
- assertVisible: "Enter verification code"
- tapOn:
    id: "otp_input"
- inputText: ${OTP}
- tapOn:
    id: "verify_button"
- assertVisible: "Welcome"
```

Example wrapper:

```bash
#!/usr/bin/env bash
set -euo pipefail

OTP_SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/qa-email-sms-otp"
APP_ID="${APP_ID:?Set APP_ID}"
MAILPIT_URL="${MAILPIT_URL:-http://localhost:8025}"

EMAIL="$("$OTP_SKILL_DIR/scripts/create-temp-email.sh")"

maestro test \
  -e APP_ID="$APP_ID" \
  -e EMAIL="$EMAIL" \
  .maestro/flows/request-email-otp.yaml

OTP="$(MAILPIT_URL="$MAILPIT_URL" \
  "$OTP_SKILL_DIR/scripts/wait-for-email-otp.sh" 90 "$EMAIL")"

maestro test \
  -e APP_ID="$APP_ID" \
  -e OTP="$OTP" \
  .maestro/flows/submit-email-otp.yaml
```

Mailpit rules from `qa-email-sms-otp`:

- Use API v1: `/api/v1/messages` and `/api/v1/message/<ID>`.
- Do not use MailHog-style `/api/v2/messages`.
- Default endpoints are SMTP `localhost:1025`, Web UI `http://localhost:8025`, and API `http://localhost:8025/api/v1`.

## Android SMS OTP with SMS Gateway

Use Android emulator SMS only for simulated incoming SMS. Do not claim an emulator can receive real third-party carrier OTPs. Use a physical Android phone with a SIM for real SMS delivery.

Example request flow:

```yaml
# .maestro/flows/request-sms-otp.yaml
appId: ${APP_ID}
name: Request SMS OTP
---
- launchApp:
    clearState: true
- tapOn: "Log in"
- tapOn:
    id: "phone_input"
- inputText: ${PHONE_NUMBER}
- tapOn:
    id: "continue_button"
- assertVisible: "Enter SMS code"
```

Example submit flow:

```yaml
# .maestro/flows/submit-sms-otp.yaml
appId: ${APP_ID}
name: Submit SMS OTP
---
- assertVisible: "Enter SMS code"
- tapOn:
    id: "otp_input"
- inputText: ${OTP}
- tapOn:
    id: "verify_button"
- assertVisible: "Home"
```

Example wrapper for emulator or physical Android device with SMS Gateway Local Server:

```bash
#!/usr/bin/env bash
set -euo pipefail

OTP_SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/qa-email-sms-otp"
APP_ID="${APP_ID:?Set APP_ID}"
PHONE_NUMBER="${PHONE_NUMBER:?Set PHONE_NUMBER}"
SMS_GATEWAY_URL="${SMS_GATEWAY_URL:-http://127.0.0.1:8080}"
SMS_GATEWAY_USER="${SMS_GATEWAY_USER:?Set SMS_GATEWAY_USER}"
SMS_GATEWAY_PASS="${SMS_GATEWAY_PASS:?Set SMS_GATEWAY_PASS}"
SMS_GATEWAY_DEVICE_ID="${SMS_GATEWAY_DEVICE_ID:-}"

adb forward tcp:8080 tcp:8080
export SMS_GATEWAY_REFRESH_SINCE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

maestro test \
  -e APP_ID="$APP_ID" \
  -e PHONE_NUMBER="$PHONE_NUMBER" \
  .maestro/flows/request-sms-otp.yaml

OTP="$(SMS_GATEWAY_URL="$SMS_GATEWAY_URL" \
  SMS_GATEWAY_USER="$SMS_GATEWAY_USER" \
  SMS_GATEWAY_PASS="$SMS_GATEWAY_PASS" \
  SMS_GATEWAY_DEVICE_ID="$SMS_GATEWAY_DEVICE_ID" \
  SMS_GATEWAY_REFRESH_SINCE="$SMS_GATEWAY_REFRESH_SINCE" \
  "$OTP_SKILL_DIR/scripts/wait-for-sms-otp.sh" 120)"

maestro test \
  -e APP_ID="$APP_ID" \
  -e OTP="$OTP" \
  .maestro/flows/submit-sms-otp.yaml
```

For a Gateway smoke test without app delivery, simulate an incoming emulator SMS:

```bash
adb emu sms send 15551234567 "Your Android OTP is 123456"
```

SMS Gateway rules from `qa-email-sms-otp`:

- Use `POST /inbox/refresh` before polling `GET /inbox`.
- Use `adb forward tcp:8080 tcp:8080` when the Gateway server runs inside the emulator and the host needs to call it.
- `10.0.2.2` points from emulator to host, not from host to emulator.
- Set `SMS_GATEWAY_REFRESH_SINCE` immediately before triggering the OTP to avoid stale codes.

## Device Alignment

When testing SMS on Android, make sure Maestro and adb operate on the same device:

```bash
adb devices
maestro --device emulator-5554 test .maestro/flows/request-sms-otp.yaml
```

If multiple devices are connected, pass `--device` to Maestro and `-s <serial>` to adb commands used by wrapper scripts.

## When to Use Test-Mode Detection Instead

If the user only needs to bypass 2FA rather than verify OTP delivery, use the app-side detection pattern in `app-integration.md`:

```yaml
- launchApp:
    arguments:
      isMaestro: "true"
```

Do not replace OTP-delivery tests with bypasses when the goal is to prove email/SMS delivery and parsing work.

## Completion Checklist

Before reporting success on OTP Maestro work:

- Email: Mailpit received the message and `wait-for-email-otp.sh` printed the OTP used by Maestro.
- SMS: SMS Gateway Local Server was reachable, inbox refresh ran, and `wait-for-sms-otp.sh` printed the OTP used by Maestro.
- Maestro entered the printed OTP and reached the expected post-verification screen.
- Any limitation is explicit, especially emulator-vs-real-SMS behavior.
