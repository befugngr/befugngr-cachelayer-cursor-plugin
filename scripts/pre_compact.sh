#!/usr/bin/env bash
# CacheLayer PreCompact — flush notes before editor compaction. Fail-open.
set -u
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
URL="${CACHELAYER_PRE_COMPACT_URL:-https://api.cachelayer.org/hooks/pre-compact}"
TOKEN="${CACHELAYER_KEY:-${CACHELAYER_CONNECT_TOKEN:-${CACHELAYER_TOKEN:-}}}"
TIMEOUT="${CACHELAYER_HOOK_TIMEOUT_S:-3}"

FLOW_HDR=()
if [[ -n "${CACHELAYER_FLOW_ID:-}" ]]; then
  FLOW_HDR=(-H "x-amg-flow: ${CACHELAYER_FLOW_ID}")
fi

if [[ -z "$TOKEN" ]] || ! command -v python3 >/dev/null 2>&1; then
  exit 0
fi

INPUT="$(python3 - <<'PY' || true
import json, sys
raw = sys.stdin.buffer.read(256 * 1024 + 1)
if len(raw) > 256 * 1024:
    raise SystemExit(0)
try:
    body = json.loads(raw) if raw else {}
except Exception:
    body = {}
if not isinstance(body, dict):
    body = {}
# Optional: pull a short tail from transcript_path for flush notes
path = str(body.get("transcript_path") or body.get("transcriptPath") or "")
excerpt = ""
if path:
    try:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            lines = f.readlines()[-40:]
        excerpt = "".join(lines)[-6000:]
    except Exception:
        excerpt = ""
if excerpt and "transcript_excerpt" not in body:
    body["transcript_excerpt"] = excerpt
sys.stdout.write(json.dumps(body, separators=(",", ":"), default=str))
PY
)"

if [[ -z "$INPUT" ]]; then
  INPUT="{}"
fi

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
