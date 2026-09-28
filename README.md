# CacheLayer for Cursor

https://cachelayer.org/

CacheLayer Agent OS sits in front of the LLM: it clears the agent’s memory and only gives it what the current step needs. This plugin connects your editor (managed keys, hooks, and MCP).

Personal / BYOK: https://cachelayer.org/integrations/cursor

## Agent OS (LLM traffic)

Point the model at CacheLayer Agent OS so it clears memory and only gives the agent what the current step needs:

```bash
export OPENAI_BASE_URL="https://api.cachelayer.org/cl-gate/v1"
export OPENAI_API_KEY="sk-<your-provider-key>"
# CacheLayer org key (Portfolio cl_… / legacy clct_…):
export CACHELAYER_KEY="cl_<your-org-key>"
# Clients that support custom headers must send:
#   x-api-key: $CACHELAYER_KEY
# Authorization stays the provider sk- key.
# Optional Anthropic-shaped clients:
# export ANTHROPIC_BASE_URL="https://api.cachelayer.org/cl-gate"
# export ANTHROPIC_API_KEY="sk-ant-<your-provider-key>"
```

Hooks and MCP stay on `https://api.cachelayer.org` (unchanged) with `Authorization: Bearer $CACHELAYER_KEY`.

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
