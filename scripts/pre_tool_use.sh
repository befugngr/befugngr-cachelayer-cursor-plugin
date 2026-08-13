#!/usr/bin/env bash
# CacheLayer Cursor preToolUse — silent lookup, fail-open, short timeout.
# On hit: deny tool + agent_message with cached result (skip redo).
# On miss/error: allow.
set -u

URL="${CACHELAYER_HOOK_URL:-https://api.cachelayer.org/hooks/pre-tool-use}"
TOKEN="${CACHELAYER_KEY:-${CACHELAYER_CONNECT_TOKEN:-${CACHELAYER_TOKEN:-}}}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-2}"

INPUT="$(cat || true)"
if [[ -z "$INPUT" ]]; then
  printf '%s\n' '{"permission":"allow"}'
  exit 0
fi

# Never intercept CacheLayer MCP tools (avoid loops)
if printf '%s' "$INPUT" | grep -qiE '"tool_name"[[:space:]]*:[[:space:]]*"(MCP:)?[^"]*(lookup_step|save_step|check_conflict|run_status)'; then
  printf '%s\n' '{"permission":"allow"}'
  exit 0
fi

if [[ -z "$TOKEN" ]]; then
  printf '%s\n' '{"permission":"allow"}'
  exit 0
fi

RESP="$(curl -sS --max-time "$TIMEOUT" \
  -X POST "$URL" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -d "$INPUT" 2>/dev/null || true)"

if [[ -z "$RESP" ]]; then
  printf '%s\n' '{"permission":"allow"}'
  exit 0
fi

if command -v python3 >/dev/null 2>&1; then
  OUT="$(printf '%s' "$RESP" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
except Exception:
    print(json.dumps({"permission": "allow"})); raise SystemExit(0)
if not isinstance(d, dict) or d.get("error"):
    print(json.dumps({"permission": "allow"})); raise SystemExit(0)
cl = d.get("cachelayer") if isinstance(d.get("cachelayer"), dict) else {}
hit = bool(d.get("hit") or cl.get("hit"))
result = d.get("result")
if result is None:
    result = cl.get("result")
desc = cl.get("description") or ""
if hit and result is not None:
    try:
        rendered = result if isinstance(result, str) else json.dumps(result, default=str)
    except Exception:
        rendered = str(result)
    msg = (
        "CacheLayer HIT"
        + (f" for `{desc}`" if desc else "")
        + ". Use this cached result and do NOT re-run the tool:\n"
        + rendered
    )
    # Deny skips the native tool; agent_message feeds the cached result.
    print(json.dumps({
        "permission": "deny",
        "agent_message": msg,
        "user_message": "CacheLayer reused a prior step result.",
    }))
    raise SystemExit(0)
# Miss: allow; optionally hint via empty
print(json.dumps({"permission": "allow"}))
' 2>/dev/null || true)"
  if [[ -n "$OUT" ]]; then
    printf '%s\n' "$OUT"
    exit 0
  fi
fi

printf '%s\n' '{"permission":"allow"}'
exit 0
