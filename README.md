# CacheLayer for Cursor

Silent hooks cache agent steps (lookup before allowlisted tools, save after). Optional MCP for resume / conflict checks. No mandatory “MCP before every tool” tax.

Site: https://cachelayer.org/

## Prerequisites

- [Cursor](https://cursor.com/) with hooks support
- CacheLayer connect token (`clct_…`)

## 1. Connect token

1. Sign in at https://cachelayer.org/
2. Create a connect token
3. Export it where Cursor is launched:

```bash
export CACHELAYER_KEY='clct_<your-token>'
```

Restart Cursor after setting the env var.

## 2. Install

```bash
git clone https://github.com/befugngr/befugngr-cachelayer-cursor-plugin \
  ~/.cursor/plugins/local/cachelayer
chmod +x ~/.cursor/plugins/local/cachelayer/scripts/*.sh
```

Reload Cursor. The plugin loads `mcp.json`, `hooks/`, `skills/`, and optional rules.

### Hooks (default path — no model overhead)

| Event | Matcher | Behavior |
|-------|---------|----------|
| `preToolUse` | Shell, Read, Grep, Glob, WebSearch, WebFetch, Task | Lookup; on hit, skip tool and feed cached result |
| `postToolUse` | same | Silent save (fail-open, ~2s) |

Writes are not in the matcher (not replayed). Fail-open on timeout/network/missing token.

Optional: `CACHELAYER_HOOK_TIMEOUT_S` (default `2`), `CACHELAYER_HOOK_URL` / `CACHELAYER_POST_HOOK_URL`.

### If plugin hooks do not load

Merge into `~/.cursor/hooks.json` (absolute paths to this install):

```json
{
  "version": 1,
  "hooks": {
    "preToolUse": [{
      "command": "bash /home/YOU/.cursor/plugins/local/cachelayer/scripts/pre_tool_use.sh",
      "matcher": "Shell|Read|Grep|Glob|WebSearch|WebFetch|Task",
      "timeout": 3
    }],
    "postToolUse": [{
      "command": "bash /home/YOU/.cursor/plugins/local/cachelayer/scripts/post_tool_use.sh",
      "matcher": "Shell|Read|Grep|Glob|WebSearch|WebFetch|Task",
      "timeout": 3
    }]
  }
}
```

## 3. MCP (optional)

Bundled `mcp.json` → `https://api.cachelayer.org/mcp` with `Authorization: Bearer ${env:CACHELAYER_KEY}`.

Tools: `lookup_step`, `save_step`, `check_conflict`, `run_status` — use for resume / explicit conflict checks, **not** before every step.

## 4. Verify

- Hooks appear in Cursor **Hooks** settings / output channel
- MCP connected (optional)
- With a token: `POST https://api.cachelayer.org/hooks/pre-tool-use` returns 200
- Without token: hooks still allow tools (fail-open)

## Layout

```text
.cursor-plugin/plugin.json
mcp.json
hooks/hooks.json
scripts/pre_tool_use.sh
scripts/post_tool_use.sh
rules/cachelayer-interception.mdc   — optional (alwaysApply: false)
skills/cachelayer-tools/SKILL.md
```

## Limits

- Cheap local reads may still hit the hook (fail-open, short timeout)
- Write tools are not auto-replayed
- Do not save secrets

## Compliance

1. No impersonation of Cursor / Anysphere.
2. No malicious code.
3. A CacheLayer account is required for caching (hooks work fail-open without a token).

## Legal

Apache License 2.0. See `LICENSE`.
