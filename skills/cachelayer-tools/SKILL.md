---
name: cachelayer-tools
description: >-
  Correct usage of CacheLayer MCP tools. Consult any time the agent is about
  to use CacheLayer's lookup_step, save_step, check_conflict, or run_status tools.
---

# CacheLayer tools

Use these tools exactly as specified. Vague or inconsistent arguments break cache hits.

## `run_id` discipline

- One UUID per task.
- Reuse that same `run_id` across every step of that task (`lookup_step`, `save_step`, `check_conflict`, `run_status`).
- Generate a new UUID when starting a new task.

## `lookup_step(description, run_id)`

Call **before** any native step.

- `description` **MUST** be a concise, normalized statement of the step's intent — not a paragraph, not the raw user prompt.
- Use the same phrasing style every time so lookups match saves.

Good examples:

- `read file src/auth.js`
- `resolve failing test in test_login.py`
- `list files in packages/api`

Bad examples:

- `do the thing`
- the full user prompt pasted verbatim
- a multi-sentence plan

## `save_step(step_id, run_id, description, result)`

Call **after** every completed step (including after using a cache hit).

- `description` **MUST** match the phrasing style used in `lookup_step` for that step.
- `result` **MUST** contain the actual output/content produced by the step, not a summary of it.
- `step_id` identifies the step within the run (e.g. `s1`, `s2`).

## `check_conflict(intended_action, run_id)`

Call **before** any file edit or destructive terminal command.

- `intended_action` **MUST** name the target explicitly (file path, resource, order id, etc.) so conflict detection can match it.

Good: `edit file src/auth.js` / `delete file /tmp/out.txt`  
Bad: `make a change` / `clean up`

If `"safe": false`, stop. Do not proceed.

## `run_status(run_id)`

Use to recover context after interruption. Pass the task's `run_id`.

## On a hit

When `lookup_step` returns `"hit": true`:

1. Use the returned `result` directly.
2. Do **not** redo the step.
3. Do **not** re-verify unless the interception rule's conflict check demands it.
4. Still call `save_step` for the step as required by the rule (or follow the rule's after-step requirement for the overall flow).

## What NOT to do

- Do **not** save steps whose `result` contains secrets from env files or credentials.
- Do **not** call `lookup_step` with vague descriptions (`do the thing`, `fix it`, `continue`).
- Do **not** skip `save_step` because a step seems trivial.
- Do **not** call `lookup_step` before CacheLayer tools themselves (avoids infinite loops).
