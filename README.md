# CacheLayer for Cursor

https://cachelayer.org/

CacheLayer controls the agent through silent tool hooks and MCP — not by proxying the LLM. Hooks look up/save steps and put only the needed cached result back on a hit.

Personal / BYOK: https://cachelayer.org/integrations/cursor

## How CacheLayer controls the agent

The plugin does **not** attach your editor to the LLM proxy. Silent hooks sit on tool use:

1. **Before** allowlisted read/search tools → lookup a prior safe step result
2. On **hit** → skip the native tool and put only that cached result back into the agent
3. **After** the tool → save the result for the next step
4. Optional MCP tools (`lookup_step`, `save_step`, `check_conflict`, `run_status`) for explicit control

Set `CACHELAYER_KEY` (`cl_…` or legacy `clct_…`). For per-flow Agent OS metrics in the console:

```bash
export CACHELAYER_FLOW_ID="<flow_id_from_console>"
```

Hooks and MCP stay on `https://api.cachelayer.org`.


## 1. Install the plugin into Cursor

### macOS / Linux

```bash
git clone https://github.com/befugngr/befugngr-cachelayer-cursor-plugin \
  ~/.cursor/plugins/local/cachelayer
chmod +x ~/.cursor/plugins/local/cachelayer/scripts/*.sh
```

### Windows (PowerShell)

```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.cursor\plugins\local" | Out-Null
git clone https://github.com/befugngr/befugngr-cachelayer-cursor-plugin "$env:USERPROFILE\.cursor\plugins\local\cachelayer"
```

The plugin already includes MCP. Do not add CacheLayer MCP by hand.

## 2. Add your CacheLayer token to your environment

Use a connect token from https://cachelayer.org/ (`cl_…` or legacy `clct_…`).

### macOS / Linux

```bash
export CACHELAYER_KEY="<your-token>"
```

To persist, add the same line to `~/.zshrc` or `~/.bashrc`.

If you launch Cursor from Dock or Spotlight on macOS:

```bash
launchctl setenv CACHELAYER_KEY '<your-token>'
```

### Windows (PowerShell)

```powershell
[Environment]::SetEnvironmentVariable("CACHELAYER_KEY", "<your-token>", "User")
```

## 3. Restart Cursor

Fully quit and reopen Cursor.
