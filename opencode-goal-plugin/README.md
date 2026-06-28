# OpenCode Goal Plugin

Parity-first OpenCode plugin modeled after Codex `/goal` behavior.

## Files
- `goal-plugin.ts`: plugin implementation

## What it does
- Registers `create_goal`, `get_goal`, and `update_goal`
- Preserves goal context through prompt/system hooks
- Stores goal state in `.opencode/goal.json`
- Uses session-keyed state to get closer to Codex thread semantics
- Writes debug telemetry to `.opencode/goal-plugin-debug.jsonl`

## Install
Copy `goal-plugin.ts` to:

```bash
~/.config/opencode/plugins/goal-plugin.ts
```

Or symlink it there.

## Notes
This aims for Codex parity where OpenCode exposes equivalent host hooks. Remaining divergence areas include:
- true idle auto-start of turns
- exact host-driven `usage_limited` transitions
- exact in-turn objective-updated steering injection
