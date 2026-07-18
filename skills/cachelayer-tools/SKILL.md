---
name: cachelayer-tools
description: >-
  Optional CacheLayer MCP tools. Prefer silent hooks for lookup/save. Use MCP
  for run_status, check_conflict on risky writes, or explicit expensive reuse.
---

# CacheLayer tools

Set `CACHELAYER_KEY` to your `clct_<token>`. Silent **hooks** handle most lookup/save — do not MCP-tax every step.

## Prefer hooks (default)

Cursor `preToolUse` / `postToolUse` scripts call:

- `POST /hooks/pre-tool-use` (lookup; on hit the tool is skipped)
- `POST /hooks/post-tool-use` (save)

Fail-open, ~2s timeout. No model round-trip.

## When to call MCP

| Tool | Use when |
|------|----------|
| `run_status` | Resume after interruption |
| `check_conflict` | Extra guard before risky writes/destructive commands |
| `lookup_step` / `save_step` | Explicit reuse of an expensive step hooks may miss |

## Descriptor style (if you call MCP)

Lowercase **verb + target**:

- `read file <path>`
- `run command <cmd>`
- `search <query>`

Same phrasing on lookup and save. One UUID `run_id` per task.

## Do not

- Lookup/save before every native tool (hooks already do this silently)
- Save secrets from env files
- Call CacheLayer tools before other CacheLayer tools
