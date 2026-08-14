---
name: cachelayer-tools
description: >-
  Optional CacheLayer cache and local CRITIC/TIA/Debug tools. Prefer silent
  cache hooks; use each local loop-cutter once at the appropriate point.
---

# CacheLayer tools

Set `CACHELAYER_KEY` to your `clct_<token>`. Silent hooks handle normal remote cache lookup/save; do not MCP-tax every step.

## Local loop-cutters

- Call `verify_edit` **once after a coherent code edit** with the edited paths. It gates typecheck, lint, then affected tests. Skip docs-only changes.
- Call `run_affected_tests` **once after edits** when targeted test evidence is needed and `verify_edit` did not already run them.
- Call `debug_failure` **once only after a real failure**, passing the traceback or failing test output. Do not call it on passing runs or start a second debug loop.
- Missing mypy, ruff, pytest-testmon, Jest, JaCoCo, Ekstazi, Scalpel, Joern, Flacoco, or GZoltar is an expected degrade path; use the returned install hint or bounded fallback.

## Remote cache MCP

Use `run_status` after interruption, `check_conflict` before risky writes, and `lookup_step` / `save_step` only for explicit expensive reuse. Descriptors are lowercase verb + target, such as `read file <path>` or `run command <cmd>`; keep one `run_id` per task.

## Do not

- Call MCP before every Read/Grep/native tool
- Save secrets from environment files
- Call CacheLayer tools before other CacheLayer tools
