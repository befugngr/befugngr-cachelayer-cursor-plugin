---
name: cachelayer-tools
description: >-
  Correct usage of CacheLayer MCP tools. Consult any time the agent is about
  to use CacheLayer's lookup_step, save_step, check_conflict, or run_status tools.
---

# CacheLayer tools

Vague or inconsistent arguments break cache hits. Set `CACHELAYER_KEY` to your `clct_<your-token>` connect token.

## `run_id`

- One UUID per task
- Reuse it for every `lookup_step`, `save_step`, `check_conflict`, `run_status` in that task
- New UUID for a new task

## `lookup_step(description, run_id)`

Call before any native step.

- `description` MUST be a concise, normalized intent statement, not a paragraph, not the raw user prompt
- Same phrasing style every time so lookups match saves

Good: `read file src/auth.js`, `resolve failing test in test_login.py`  
Bad: `do the thing`, full user prompt, multi-sentence plan

## `save_step(step_id, run_id, description, result)`

Call after every completed step (including after a cache hit).

- `description` MUST match lookup phrasing
- `result` MUST be the actual output, not a summary

## `check_conflict(intended_action, run_id)`

Call before file edits or destructive commands.

- Name the target explicitly (path, resource, id)
- If `safe` is false, stop

## `run_status(run_id)`

Recover context after interruption.

## On a hit

Use the returned `result`. Do not redo. Do not re-verify unless conflict check demands it.

## Do not

- Save secrets from env files
- Use vague descriptions
- Skip `save_step` for "trivial" steps
- Call `lookup_step` before CacheLayer tools themselves
