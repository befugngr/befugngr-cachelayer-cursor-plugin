# CacheLayer for Cursor

MCP for Cursor agents: look up, save, and conflict-check cached steps so repeated work can be skipped.

Site: https://cachelayer.org/

## Install (plugin — recommended)

1. Clone into Cursor’s local plugin dir:

```bash
git clone https://github.com/befugngr/cachelayer-cursor-plugin \
  ~/.cursor/plugins/local/cachelayer
```

(If the GitHub repo still redirects from the old `befugngr-cachelayer-cursor-plugin` slug, either URL works until renamed.)

2. Reload Cursor. The plugin loads `mcp.json`, `rules/`, and `skills/` from the package root (Cursor plugin discovery — not a project `.cursor/` folder).

3. Set `CACHELAYER_KEY` in your environment to your `clct_<your-token>` connect token, then restart Cursor so `${env:CACHELAYER_KEY}` resolves.

## Install (project MCP only)

1. Open Cursor MCP settings (Settings → **Tools & MCP**) or edit `~/.cursor/mcp.json` / `.cursor/mcp.json`.
2. Merge this server entry (keep your other servers):

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

Cursor expands `${env:NAME}` only — bare `${NAME}` is sent literally and yields **401**.

## Auth

Auth is required. Get a connect token (`clct_<your-token>`) from your CacheLayer account. Unauthenticated requests return **401**.

MCP URL: `https://api.cachelayer.org/mcp` (streamable HTTP; nginx also serves legacy `/mcp/sse`).

## Tools

- `lookup_step(description, run_id)` before a step; on hit, use `result`
- `save_step(step_id, run_id, description, result)` after a step
- `check_conflict(intended_action, run_id)` before edits; stop if `safe` is false
- `run_status(run_id)` to recover after interruption

One UUID `run_id` per task. Keep descriptions short and consistent (e.g. `read file src/auth.js`).

## Layout

```text
.cursor-plugin/plugin.json
mcp.json                          — MCP server (plugin-root; required by Cursor plugins)
rules/cachelayer-interception.mdc — always-on interception rule
skills/cachelayer-tools/SKILL.md
LICENSE
README.md
```

## Limits

- Do not save secrets from env files
- Write steps may be stored but are not replayed
- Cursor has no native hooks; enforcement is the always-apply rule in this plugin

## Compliance

1. No impersonation. CacheLayer only; not Cursor or Anysphere.
2. No malicious code.
3. A CacheLayer account/subscription is required.

## Contact

https://cachelayer.org/

## Legal

Apache License 2.0. See `LICENSE`.
