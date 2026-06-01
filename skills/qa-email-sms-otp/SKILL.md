---
name: qa-email-sms-otp
description: Local QA workflow for email OTP and Android SMS OTP handling with Mailpit, SMS Gateway for Android, adb, and emulator/physical-device testing. Use this skill whenever the user needs to test signup, login, 2FA, verification codes, password reset OTPs, local SMTP capture, Android emulator SMS simulation, SMS Gateway Local Server polling, or end-to-end QA flows involving email or SMS one-time passwords.
---

# QA Email and SMS OTP

Use this skill to set up and verify local OTP flows from the command line. It bundles scripts for generating test email addresses and polling Mailpit or SMS Gateway for OTPs.

## Core Rules

- Use Mailpit API v1: list messages at `/api/v1/messages`, then fetch the full message at `/api/v1/message/<ID>`.
- Do not use MailHog-style `/api/v2/messages` for Mailpit.
- Use SMS Gateway Local Server `GET /inbox` for received SMS and `POST /inbox/refresh` before polling.
- For emulator SMS, use `adb emu sms send <sender> "<message>"`.
- Do not claim an emulator can receive real third-party carrier OTPs. Use a physical Android phone with a SIM for real SMS OTP delivery.
- Use `adb forward tcp:8080 tcp:8080` when the SMS Gateway server runs inside the emulator and the host needs to call it.
- Remember `10.0.2.2` points from emulator to host, not from host to emulator.

## Bundled Scripts

Run scripts from this skill directory:

```bash
SKILL_DIR="${CODEX_HOME:-$HOME/.codex}/skills/qa-email-sms-otp"
```

- `scripts/create-temp-email.sh`: prints a unique local email address.
- `scripts/wait-for-email-otp.sh [timeout_seconds] [recipient_email]`: polls Mailpit and prints the first 4-8 digit OTP.
- `scripts/wait-for-sms-otp.sh [timeout_seconds]`: refreshes SMS Gateway inbox, filters by time window, and prints the first 4-8 digit OTP.

## Email OTP Workflow

1. Start Mailpit:

```bash
mailpit
```

Default endpoints:

```text
SMTP:   localhost:1025
Web UI: http://localhost:8025
API:    http://localhost:8025/api/v1
```

2. Generate an email address:

```bash
EMAIL="$("$SKILL_DIR/scripts/create-temp-email.sh")"
```

3. Configure the app under test:

```text
SMTP host: localhost
SMTP port: 1025
Username/password: empty unless explicitly configured
Recipient: generated $EMAIL
```

4. Poll for the OTP:

```bash
MAILPIT_URL="${MAILPIT_URL:-http://localhost:8025}" \
"$SKILL_DIR/scripts/wait-for-email-otp.sh" 90 "$EMAIL"
```

5. To smoke-test Mailpit without an app, send a test message through the HTTP API:

```bash
curl -fsS -X POST "$MAILPIT_URL/api/v1/send" \
  -H 'Content-Type: application/json' \
  --data "{\"From\":{\"Email\":\"sender@local.qa\"},\"To\":[{\"Email\":\"$EMAIL\"}],\"Subject\":\"OTP\",\"Text\":\"Your OTP is 123456\"}"
```

## Android SMS OTP Workflow

Use an emulator for simulated incoming SMS. Use a physical Android phone for real carrier SMS.

1. Start an Android emulator and confirm adb sees it:

```bash
emulator -avd <AVD_NAME>
adb wait-for-device
adb devices
```

2. Install SMS Gateway for Android:

```bash
adb install -r -g app-release.apk
adb shell am start -n me.capcom.smsgateway/.MainActivity
```

Download the APK from `https://github.com/capcom6/android-sms-gateway/releases/latest` when it is not already available.

3. In the app, enable Local Server mode and start the server. Capture:

```text
SMS_GATEWAY_URL=http://127.0.0.1:8080
SMS_GATEWAY_USER=<username shown in app>
SMS_GATEWAY_PASS=<password shown in app>
SMS_GATEWAY_DEVICE_ID=<device ID shown in app, optional but preferred>
```

4. Forward the emulator server port to the host:

```bash
adb forward tcp:8080 tcp:8080
```

5. For emulator testing, set a fresh time boundary before triggering the SMS:

```bash
export SMS_GATEWAY_REFRESH_SINCE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
```

6. Trigger or simulate the incoming SMS:

```bash
adb emu sms send 15551234567 "Your Android OTP is 123456"
```

7. Poll for the OTP:

```bash
SMS_GATEWAY_URL="$SMS_GATEWAY_URL" \
SMS_GATEWAY_USER="$SMS_GATEWAY_USER" \
SMS_GATEWAY_PASS="$SMS_GATEWAY_PASS" \
SMS_GATEWAY_DEVICE_ID="${SMS_GATEWAY_DEVICE_ID:-}" \
SMS_GATEWAY_REFRESH_SINCE="$SMS_GATEWAY_REFRESH_SINCE" \
"$SKILL_DIR/scripts/wait-for-sms-otp.sh" 120
```

## Validation Checklist

Before reporting success, verify the actual end-to-end path:

- Email: an OTP message enters Mailpit over SMTP or API and `wait-for-email-otp.sh` prints the expected OTP.
- SMS: SMS Gateway Local Server is online in the Android emulator, an `adb emu sms send` message appears through `GET /inbox`, and `wait-for-sms-otp.sh` prints the expected OTP.
- If SMS Gateway returns a stale OTP, set `SMS_GATEWAY_REFRESH_SINCE` to a fresh timestamp before triggering the SMS and retry. The script filters `GET /inbox` by that time window.

## Troubleshooting

- Mailpit not receiving: verify the app is using SMTP `localhost:1025`, or the actual port passed to `mailpit --smtp`.
- Mailpit polling empty: query `curl -fsS "$MAILPIT_URL/api/v1/messages" | jq .`, then fetch a message by ID.
- SMS Gateway `/inbox` empty: call `POST /inbox/refresh` with `since` and `until`, then query `/inbox`.
- Host cannot reach emulator Local Server: run `adb forward tcp:8080 tcp:8080` and use `http://127.0.0.1:8080`.
- Emulator receives simulated SMS but Gateway does not show it: wait a few seconds, refresh inbox, and confirm Android has the SMS with `adb shell content query --uri content://sms/inbox`.
