#!/usr/bin/env bash
# CacheLayer PostCompact — reinject flushed notes. Fail-open.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
URL="${CACHELAYER_POST_COMPACT_URL:-https://api.cachelayer.org/hooks/post-compact}"
TOKEN="${CACHELAYER_KEY:-${CACHELAYER_CONNECT_TOKEN:-${CACHELAYER_TOKEN:-}}}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-3}"

FLOW_HDR=()
if [[ -n "${CACHELAYER_FLOW_ID:-}" ]]; then
  FLOW_HDR=(-H "x-amg-flow: ${CACHELAYER_FLOW_ID}")
fi

if [[ -z "$TOKEN" ]] || ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

INPUT="$(python3 -c 'import json,sys; raw=sys.stdin.buffer.read(262144); 
try: body=json.loads(raw) if raw else {}
except Exception: body={}
print(json.dumps(body if isinstance(body,dict) else {}, separators=(",",":"), default=str))' 2>/dev/null || echo '{}')"

RESP="$(curl -sS --max-time "$TIMEOUT" \
  -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  "${FLOW_HDR[@]}" \
  -d "$INPUT" 2>/dev/null || true)"

if [[ -z "$RESP" ]]; then
  exit 0
fi
printf '%s\n' "$RESP"
exit 0
