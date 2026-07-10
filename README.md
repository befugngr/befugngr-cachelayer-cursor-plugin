# CacheLayer Cursor plugin

Packages CacheLayer step caching for Cursor agents: an MCP server connection, an always-on interception rule, and a skill that teaches correct tool usage. Agents look up prior step results before acting, conflict-check before edits, and save results after each step so repeated work can be skipped.

## What's included

| Path | Role |
| --- | --- |
| `.cursor-plugin/plugin.json` | Plugin manifest |
| `mcp.json` | CacheLayer MCP SSE endpoint |
| `rules/cachelayer-interception.mdc` | Always-on lookup / conflict / save enforcement |
| `skills/cachelayer-tools/SKILL.md` | Correct argument patterns for CacheLayer tools |

## Local install (testing)

1. Copy this folder to `~/.cursor/plugins/local/cachelayer` with `.cursor-plugin/plugin.json` at the plugin root.
2. Restart Cursor (or run **Developer: Reload Window**).
3. Confirm the plugin loads, **CacheLayer** appears in Cursor's MCP list, the interception rule is active, and the `cachelayer-tools` skill is discovered.

The MCP server at the URL in `mcp.json` must be reachable from your machine.

## Auth token (when auth ships)

Add the token under the `CacheLayer` entry in `mcp.json` (for example as a header or `auth` field — exact shape TBD) without changing the SSE URL:

```json
{
  "mcpServers": {
    "cachelayer": {
      "url": "http://44.201.25.33:8770/sse"
    }
  }
}
```

## Extract into another repo

This repository is self-contained. Copy the `cachelayer-cursor-plugin/` tree (or clone this repo) into another project, or install from `~/.cursor/plugins/local/cachelayer` as above.
