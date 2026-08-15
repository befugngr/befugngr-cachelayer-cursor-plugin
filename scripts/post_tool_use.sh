#!/usr/bin/env bash
# CacheLayer Cursor postToolUse — silent save, fail-open, short timeout.
set -u

URL="${CACHELAYER_POST_HOOK_URL:-https://api.cachelayer.org/hooks/post-tool-use}"
TOKEN="${CACHELAYER_KEY:-${CACHELAYER_CONNECT_TOKEN:-${CACHELAYER_TOKEN:-}}}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-2}"

ROOT="$(cd "$(dirname "$0")" && pwd)"
if [[ -z "$TOKEN" ]] || ! command -v python3 >/dev/null 2>&1; then
  printf '%s\n' '{}'
  exit 0
fi
INPUT="$(python3 "$ROOT/filter_hook_payload.py" || true)"
if [[ -z "$INPUT" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

# Fire-and-forget style: still wait briefly but never block the agent on failure
curl -sS --max-time "$TIMEOUT" \
  -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "$INPUT" >/dev/null 2>&1 || true

printf '%s\n' '{}'
exit 0
