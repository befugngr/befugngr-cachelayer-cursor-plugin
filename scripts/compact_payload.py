#!/usr/bin/env python3
"""Build PreCompact/PostCompact JSON for CacheLayer hooks. Reads hook stdin."""
from __future__ import annotations

import json
import sys
from typing import Any

MAX_BODY = 256 * 1024


def main() -> int:
    raw = sys.stdin.buffer.read(MAX_BODY + 1)
    if len(raw) > MAX_BODY:
        return 3
    try:
        body: Any = json.loads(raw) if raw else {}
    except Exception:
        body = {}
    if not isinstance(body, dict):
        body = {}

    path = str(body.get("transcript_path") or body.get("transcriptPath") or "")
    if path and "transcript_excerpt" not in body and "transcriptExcerpt" not in body:
        excerpt = ""
        try:
            with open(path, "r", encoding="utf-8", errors="replace") as fh:
                lines = fh.readlines()[-40:]
            excerpt = "".join(lines)[-6000:]
        except Exception:
            excerpt = ""
        if excerpt:
            body["transcript_excerpt"] = excerpt

    sys.stdout.write(json.dumps(body, separators=(",", ":"), default=str))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
