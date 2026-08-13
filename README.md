# CacheLayer Managed Keys for Cursor

https://cachelayer.org/

Install the Cursor plugin, add your CacheLayer connect token, and restart.

This repo is for managed keys only (`clct_…` as `CACHELAYER_KEY`).  
Personal API keys: https://cachelayer.org/integrations/cursor

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

Use a connect token from https://cachelayer.org/ (starts with `clct_`).

### macOS / Linux

```bash
export CACHELAYER_KEY="clct_<your-token>"
```

To persist, add the same line to `~/.zshrc` or `~/.bashrc`.

If you launch Cursor from Dock or Spotlight on macOS:

```bash
launchctl setenv CACHELAYER_KEY 'clct_<your-token>'
```

### Windows (PowerShell)

```powershell
[Environment]::SetEnvironmentVariable("CACHELAYER_KEY", "clct_<your-token>", "User")
```

## 3. Restart Cursor

Fully quit and reopen Cursor.
