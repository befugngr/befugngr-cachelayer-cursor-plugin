# CacheLayer for Cursor

MCP for Cursor agents: look up, save, and conflict-check cached steps so repeated work can be skipped.

Site: https://cachelayer.org/

## Install

1. Open Cursor MCP settings (Settings → **Tools & MCP**, or the **Customize** / MCP page depending on Cursor version) → New MCP Server, or edit `~/.cursor/mcp.json`.
2. Merge this server entry (keep your other servers):

```json
{
  "mcpServers": {
    "CacheLayer": {
      "url": "https://api.cachelayer.org/mcp/sse",
      "headers": {
        "Authorization": "Bearer YOUR_clct_TOKEN"
      }
    }
  }
}
```

3. Save. CacheLayer should appear in the MCP list.
4. Optional: copy this repo to `~/.cursor/plugins/local/cachelayer` and reload Cursor for the always-on rule and skill.

Auth is required. Get a connect token (`clct_...`) from your CacheLayer account and put it in `headers.Authorization`. Unauthenticated requests return **401**. If your Cursor build expands env vars in MCP config, you can use `Bearer ${env:CACHELAYER_CONNECT_TOKEN}` instead of pasting the token.

## Tools

- `lookup_step(description, run_id)` before a step; on hit, use `result`
- `save_step(step_id, run_id, description, result)` after a step
- `check_conflict(intended_action, run_id)` before edits; stop if `safe` is false
- `run_status(run_id)` to recover after interruption

One UUID `run_id` per task. Keep descriptions short and consistent (e.g. `read file src/auth.js`).

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
