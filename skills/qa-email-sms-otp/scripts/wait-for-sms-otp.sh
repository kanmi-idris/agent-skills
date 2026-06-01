#!/usr/bin/env bash
set -euo pipefail

# Usage: ./wait-for-sms-otp.sh [timeout_seconds]
# Required env:
#   SMS_GATEWAY_URL=http://<device_local_ip>:8080
#   SMS_GATEWAY_USER=<username from app>
#   SMS_GATEWAY_PASS=<password from app>
# Optional env:
#   SMS_GATEWAY_DEVICE_ID=<device ID from app>
#   SMS_GATEWAY_REFRESH_SINCE=<ISO-8601 start time>

TIMEOUT="${1:-120}"
SMS_GATEWAY_URL="${SMS_GATEWAY_URL:-http://127.0.0.1:8080}"
SMS_GATEWAY_USER="${SMS_GATEWAY_USER:?Set SMS_GATEWAY_USER}"
SMS_GATEWAY_PASS="${SMS_GATEWAY_PASS:?Set SMS_GATEWAY_PASS}"
SMS_GATEWAY_DEVICE_ID="${SMS_GATEWAY_DEVICE_ID:-}"
SMS_GATEWAY_REFRESH_SINCE="${SMS_GATEWAY_REFRESH_SINCE:-1970-01-01T00:00:00Z}"
DEADLINE=$(( $(date +%s) + TIMEOUT ))

echo "Waiting for SMS OTP..." >&2

while [ "$(date +%s)" -le "$DEADLINE" ]; do
  REFRESH_UNTIL="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  REFRESH_BODY="$(jq -nc \
    --arg deviceId "$SMS_GATEWAY_DEVICE_ID" \
    --arg since "$SMS_GATEWAY_REFRESH_SINCE" \
    --arg until "$REFRESH_UNTIL" \
    'if $deviceId == "" then {since: $since, until: $until} else {deviceId: $deviceId, since: $since, until: $until} end')"

  curl -fsS -X POST -u "$SMS_GATEWAY_USER:$SMS_GATEWAY_PASS" \
    -H 'Content-Type: application/json' \
    -d "$REFRESH_BODY" \
    "$SMS_GATEWAY_URL/inbox/refresh" >/dev/null || true

  sleep 1

  OTP=$(curl -fsS -G -u "$SMS_GATEWAY_USER:$SMS_GATEWAY_PASS" \
    --data-urlencode "type=SMS" \
    --data-urlencode "limit=20" \
    --data-urlencode "offset=0" \
    --data-urlencode "from=$SMS_GATEWAY_REFRESH_SINCE" \
    --data-urlencode "to=$REFRESH_UNTIL" \
    "$SMS_GATEWAY_URL/inbox" | jq -r '
      .[]
      | [.contentPreview, .content, .text, .message, .body, .textMessage.text]
      | map(select(type == "string" and length > 0))
      | .[]
    ' | grep -oE '\b[0-9]{4,8}\b' | head -1 || true)

  if [ -n "$OTP" ]; then
    echo "$OTP"
    exit 0
  fi

  sleep 3
done

echo "TIMEOUT" >&2
exit 1
