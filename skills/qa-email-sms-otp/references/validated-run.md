# Validated Run Notes

This skill was validated on 2026-06-01 with:

- Mailpit v1.30.1 on macOS arm64
- Android emulator AVD `Pixel_9a`
- SMS Gateway for Android v1.64.0
- `adb forward tcp:8080 tcp:8080`

Observed successful checks:

- Email OTP `654321` was sent into Mailpit and extracted by `wait-for-email-otp.sh`.
- SMS Gateway Local Server was enabled in the emulator and reachable at `http://127.0.0.1:8080`.
- Simulated SMS `Your Android OTP is 987654` appeared through `GET /inbox`.
- A later simulated SMS `Live wait Android OTP is 445566` was injected while the SMS script was already waiting, and `wait-for-sms-otp.sh` returned `445566`.

Important implementation detail:

SMS Gateway may return a stale inbox result until `/inbox/refresh` is called with `since` and `until`. Even after refresh, filter `GET /inbox` with the same time window so older OTPs are ignored.
