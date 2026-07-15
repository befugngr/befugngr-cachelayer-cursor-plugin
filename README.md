# CacheLayer for Cursor

MCP for Cursor agents: look up, save, and conflict-check cached steps so repeated work can be skipped. An always-on rule teaches the agent when to call CacheLayer.

Site: https://cachelayer.org/

## Prerequisites

- [Cursor](https://cursor.com/)
- A **CacheLayer account** and connect token (`clct_…`) — required; MCP returns **401** without it

## 1. Get a connect token

1. Sign up or sign in at https://cachelayer.org/
2. Create a connect token from your account (API: `POST /user/connect-token` while logged in)
3. Copy the full value once — it looks like `clct_<your-token>`

You will set this as `CACHELAYER_KEY` below.

## 2. Install (plugin — recommended)

```bash
git clone https://github.com/befugngr/befugngr-cachelayer-cursor-plugin \
  ~/.cursor/plugins/local/cachelayer
```

Reload Cursor. The plugin loads `mcp.json`, `rules/`, and `skills/` from the **package root** (Cursor plugin discovery — not a project `.cursor/` folder).

### Alternative: project / user MCP only

Open Settings → **Tools & MCP**, or edit `~/.cursor/mcp.json` / `.cursor/mcp.json`, and merge:

```json
{
  "mcpServers": {
    "cachelayer": {
      "url": "https://api.cachelayer.org/mcp",
      "headers": {
        "Authorization": "Bearer ${env:CACHELAYER_KEY}"
      }
    }
  }
}
```

## 3. Auth (required)

Export your connect token in the environment that launches Cursor, then **restart Cursor** so the env is picked up:

```bash
export CACHELAYER_KEY='clct_<your-token>'
```

Cursor only expands `${env:NAME}` in MCP config — bare `${NAME}` is sent literally and yields **401**.

- Bundled plugin `mcp.json` uses: `Authorization: Bearer ${env:CACHELAYER_KEY}`
- MCP URL: `https://api.cachelayer.org/mcp` (streamable HTTP; legacy `/mcp/sse` still exists on the API)

Missing or invalid token → MCP **401**.

## 4. Verify

- CacheLayer appears in Cursor’s MCP list and shows as connected
- Tools available: `lookup_step`, `save_step`, `check_conflict`, `run_status`
- Skill / rule from this plugin load after reload
- A test `lookup_step` does not return unauthorized / 401

## Tools

- `lookup_step(description, run_id)` before a step; on hit, use `result`
- `save_step(step_id, run_id, description, result)` after a step
- `check_conflict(intended_action, run_id)` before edits; stop if `safe` is false
- `run_status(run_id)` after interruption

One UUID `run_id` per task. Keep descriptors short and consistent (e.g. `read file src/auth.js`).

## Layout

```text
.cursor-plugin/plugin.json
mcp.json                           — MCP server (plugin-root)
rules/cachelayer-interception.mdc  — always-on interception rule
skills/cachelayer-tools/SKILL.md
LICENSE
README.md
```

## Limits

- Cursor has no native PreToolUse hooks; enforcement is the always-apply rule + skill
- Write steps may be stored but are not replayed
- Do not save secrets from env files

## Compliance

1. No impersonation. CacheLayer only; not Cursor or Anysphere.
2. No malicious code.
3. A CacheLayer account/subscription is required.

## Contact

https://cachelayer.org/

## Legal

Apache License 2.0. See `LICENSE`.
