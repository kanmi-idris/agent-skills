# ultra-prompt

A filesystem-based AI agent skill that expands rough coding prompts into evidence-grounded coding-agent prompts after auditing the target repository.

## Install

Use as a custom skill by placing this folder wherever your agent loads custom skills from, or zip the folder and upload it to a skill-compatible agent environment.

## What it does

- Reads the user’s rough coding request.
- Audits the codebase first.
- Uses subagents when the environment supports them.
- Falls back to sequential audit roles when subagents are unavailable.
- Produces one final expanded prompt using the required correctness-audit template.

## Non-goal

This skill does not implement code changes. It produces better prompts for coding agents.
