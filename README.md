# CacheLayer for Cursor

This MCP connects Cursor agents to CacheLayer step caching. Agents call `lookup_step` before acting, `check_conflict` before edits, and `save_step` after each step so matching work can be reused.

Website: [https://cachelayer.org/](https://cachelayer.org/)

## Getting started

1. Open **Cursor Terminal Settings**.
2. Go to **Tools & MCP**.
3. Click **New MCP Server**.
4. Cursor opens your `mcp.json` file.
5. Paste this snippet (merge with any servers you already have):

```json
{
  "mcpServers": {
    "cachelayer": {
      "url": "http://44.201.25.33:8770/sse"
    }
  }
}
```

6. Save the file. CacheLayer should appear in your MCP server list.
7. (Optional) Clone or copy this repo into `~/.cursor/plugins/local/cachelayer` and reload Cursor if you also want the always-on interception rule and tool-usage skill from this package.

The CacheLayer MCP server must be reachable from your machine.

When auth ships, add your token under the `CacheLayer` entry in `mcp.json` without changing the URL.

## Features

- **Step lookup:** call `lookup_step` before acting; reuse the result on a hit.
- **Step save:** call `save_step` after each step so it can be reused later.
- **Conflict checks:** call `check_conflict` before file edits or destructive commands; stop if unsafe.
- **Run tracking:** one `run_id` per task; use `run_status` to recover after an interruption.
- **Plugin extras:** always-on interception rule and tool-usage skill included in this repo.

## Usage examples

**Look up a step before doing work**

```text
lookup_step(
  description="read file src/auth.js",
  run_id="<uuid-for-this-task>"
)
```

If `hit` is `true`, use the returned `result` and do not redo the step.

**Save a completed step**

```text
save_step(
  step_id="s1",
  run_id="<same-uuid>",
  description="read file src/auth.js",
  result={ ... actual step output ... }
)
```

Use the same concise description style for lookup and save so they match.

**Check before editing a file**

```text
check_conflict(
  intended_action="edit file src/auth.js",
  run_id="<same-uuid>"
)
```

If `safe` is `false`, stop and report the reason.

**Recover after an interruption**

```text
run_status(run_id="<same-uuid>")
```

## Notes and limitations

- Descriptions must be short and consistent (for example `read file src/auth.js`), not the full user prompt and not vague phrases like `do the thing`.
- Use one UUID `run_id` for an entire task; start a new UUID for a new task.
- `save_step` should store the real step output, not a summary.
- Do not save results that contain secrets from env files or credentials.
- Write / mutating steps may be stored but are not replayed as safe hits.
- Cache hits only help when the MCP server is reachable and the step was saved earlier under a matching description.
- Auth tokens are not required yet; when they are, the SSE URL stays the same.

## Contact

Questions, support, or product updates: [https://cachelayer.org/](https://cachelayer.org/)

## Legal

This project is licensed under the **Apache License 2.0**.

You may use, reproduce, and distribute this software under the terms of that license. See the full text in [`LICENSE`](./LICENSE), including the patent grant, redistribution conditions, and disclaimer of warranties.

Copyright notices and license terms in `LICENSE` control. Nothing in this README grants rights beyond the Apache License 2.0.
