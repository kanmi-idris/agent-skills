---
name: opencode-goal
description: Use when the user wants to set, get, update, or continue a persistent OpenCode goal. Force use of the OpenCode goal tools `create_goal`, `get_goal`, and `update_goal` based on the user's wording instead of handling goal state in plain text.
---

# OpenCode Goal

Use this skill whenever the user is talking about a persistent OpenCode goal.

## Core rule
Do not manage the goal in plain text when the goal tools are available.
Always force the appropriate tool call first, then explain the result to the user.

## Tool routing

### 1. Create or replace a goal
If the user asks to:
- set a goal
- create a goal
- start a persistent goal
- continue work under a new OpenCode goal

Then call `create_goal` immediately with:
- `objective`: the user's requested goal, cleaned up but not narrowed
- `token_budget`: only if the user explicitly asked for one

Do not just acknowledge the goal in text.
Do not keep the goal only in conversation memory.

### 2. Read current goal status
If the user asks to:
- check the goal
- what's my goal
- what is the current goal
- show goal status
- inspect goal progress

Then call `get_goal` immediately.
Do not answer from memory if the tool is available.

### 3. Update terminal goal status
If the user asks to:
- mark the goal complete
- mark it done
- mark the goal blocked
- close the goal

Then call `update_goal` immediately.
Allowed statuses are only:
- `complete`
- `blocked`

Do not invent pause/resume/usage-limited/budget-limited tool actions.

## Decision rule
Map the user's wording to one of these tools:
- creation intent -> `create_goal`
- inspection intent -> `get_goal`
- terminal-status intent -> `update_goal`

If a request mixes multiple intents, call the tools in the order needed to satisfy the request.
Example:
- "create a goal and show me its status" -> `create_goal`, then `get_goal`

## After the tool call
After using the tool, summarize the structured result in plain language for the user.
If the tool fails, explain the exact tool failure and the next required step.

## Important constraints
- Never pretend the goal exists without reading or creating it through the tool.
- Never simulate tool output in plain text.
- Never skip the tool call just because the correct action seems obvious.
- Preserve the full objective. Do not silently narrow or simplify it when creating the goal.

## When to prefer this skill
Use this skill ahead of generic planning or memory skills whenever the user is explicitly talking about OpenCode goal state.
