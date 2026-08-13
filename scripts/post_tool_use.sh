#!/usr/bin/env bash
# CacheLayer Cursor postToolUse — silent save, fail-open, short timeout.
set -u

URL="${CACHELAYER_POST_HOOK_URL:-https://api.cachelayer.org/hooks/post-tool-use}"
TOKEN="${CACHELAYER_KEY:-${CACHELAYER_CONNECT_TOKEN:-${CACHELAYER_TOKEN:-}}}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-2}"

INPUT="$(cat || true)"
if [[ -z "$INPUT" || -z "$TOKEN" ]]; then
  printf '%s\n' '{}'
  exit 0
fi

if printf '%s' "$INPUT" | grep -qiE '"tool_name"[[:space:]]*:[[:space:]]*"(MCP:)?[^"]*(lookup_step|save_step|check_conflict|run_status)'; then
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
