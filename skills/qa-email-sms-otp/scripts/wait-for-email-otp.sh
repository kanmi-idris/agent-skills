#!/usr/bin/env bash
set -euo pipefail

# Usage: ./wait-for-email-otp.sh [timeout_seconds] [recipient_email]

TIMEOUT="${1:-90}"
RECIPIENT="${2:-}"
MAILPIT_URL="${MAILPIT_URL:-http://localhost:8025}"
DEADLINE=$(( $(date +%s) + TIMEOUT ))

echo "Waiting for OTP email..." >&2

while [ "$(date +%s)" -le "$DEADLINE" ]; do
  IDS=$(curl -fsS "$MAILPIT_URL/api/v1/messages?limit=20" | jq -r --arg recipient "$RECIPIENT" '
    .messages[]
    | select($recipient == "" or any(.To[]?; .Address == $recipient))
    | .ID
  ')

  for ID in $IDS; do
    OTP=$(curl -fsS "$MAILPIT_URL/api/v1/message/$ID" | jq -r '
      [.Text, .HTML, .Subject]
      | map(select(type == "string" and length > 0))
      | join("\n")
    ' | grep -oE '\b[0-9]{4,8}\b' | head -1 || true)

    if [ -n "$OTP" ]; then
      echo "$OTP"
      exit 0
    fi
  done

  sleep 2
done

echo "TIMEOUT" >&2
exit 1
