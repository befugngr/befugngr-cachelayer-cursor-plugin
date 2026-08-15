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

## Optional local loop-cutters

The plugin also bundles a local, Python 3 stdlib-only MCP server alongside the managed-keys cache MCP. It provides `verify_edit` (CRITIC), `run_affected_tests` (TIA), and `debug_failure` for compact one-call feedback in the current workspace. These tools are optional: missing project analyzers degrade gracefully with install guidance, while the remote `cachelayer` server and `CACHELAYER_KEY` flow remain unchanged.

For richer selection and diagnosis, projects may optionally install `pytest-testmon`/`pytest-cov`, TypeScript/ESLint/Jest, or Java tooling such as JaCoCo, Ekstazi, Joern, and Flacoco.

`run_affected_tests` picks the strongest selection the project supports, and says which one it used:

| Project state | Selection |
| --- | --- |
| `pytest-testmon` installed | testmon's own impacted set |
| `.coverage` recorded with `pytest --cov --cov-context=test` | the exact tests that executed the changed lines |
| neither | changed modules plus their importers, mapped to matching test files |
| Jest | `jest --findRelatedTests` |
| Maven with a JaCoCo report | test classes referencing changed classes the suite covers, and a list of changed classes with no coverage |
| Maven or Gradle without a report | changed classes mapped to matching test classes |

When nothing maps, it runs nothing and says so rather than falling back to the full suite.

`debug_failure` automatically builds Ochiai evidence by rerunning only parsed failing pytest files when coverage support is available. Python failures use a bounded def-use/control backward slice. Joern uses an existing `cpg.bin`; Flacoco can be on `PATH` or supplied with `FLACOCO_JAR`. Real ddmin/HDD requires `failing_input` and a bounded `repro.argv`; commands run directly without a shell.
