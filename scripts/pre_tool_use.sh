#!/usr/bin/env bash
# Do not wait on the network before a tool runs.
# Replay is the proxy at /v1. This hook stays allow-only so an old
# PreToolUse matcher cannot stall the editor.
printf '%s\n' '{"permission":"allow","continue":true}'
exit 0
