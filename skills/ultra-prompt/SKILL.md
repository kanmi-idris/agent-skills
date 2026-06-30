---
name: ultra-prompt
description: Expands rough user coding prompts into precise, evidence-grounded coding-agent prompts after auditing the target repository. Use when the user asks to improve, rewrite, harden, expand, or generate a prompt for a coding agent, especially for debugging, editing, refactoring, QA, security review, or implementation work in a codebase.
---

# Ultra Prompt

## Purpose

Convert a rough user request into a production-ready coding-agent prompt. Before writing the expanded prompt, audit the codebase so the prompt is grounded in real files, tests, schemas, contracts, logs, and project conventions.

This Skill produces a prompt only. Do not modify source code unless the user explicitly asks for implementation.

## Mandatory workflow

1. Read the user’s original prompt and identify the intended coding task.
2. Inspect the repository source of truth before expanding the prompt.
3. If the environment supports subagents or parallel agents, spawn the audit agents in [reference/AUDIT_AGENTS.md](reference/AUDIT_AGENTS.md), wait for all results, and consolidate their findings.
4. If subagents are unavailable, run the same audit roles sequentially in the main thread and mark the audit as `single-agent fallback`.
5. Populate the prompt template in [reference/PROMPT_TEMPLATE.md](reference/PROMPT_TEMPLATE.md) using only verified audit findings.
6. Run the correctness gate in [reference/OUTPUT_SCHEMA.md](reference/OUTPUT_SCHEMA.md).
7. Return only the expanded prompt plus critical caveats. Do not include hidden reasoning, plans, status updates, or raw audit transcripts.

## Audit scope

Always map:

- Goal: the exact objective implied by the user.
- Context: files, folders, docs, examples, errors, logs, routes, schemas, contracts, tests, and conventions relevant to the task.
- Constraints: safety rules, repo conventions, non-goals, protected files, security boundaries, and approval requirements.
- Done when: concrete success criteria and verification commands.
- Data flow: sources, consumers, transformations, side effects, tests, and failure paths.

## Evidence rules

- Use concrete repository evidence: paths, command names, test names, schema names, API routes, log sources, config files, and docs.
- Do not invent files, commands, APIs, test suites, or conventions.
- If a detail is likely but not verified, write `UNVERIFIED` and state the caveat.
- If a requested task is unsafe, destructive, or outside available access, preserve that as a constraint in the expanded prompt.

## Output rule

The final response must be a single expanded coding-agent prompt. No explanation before or after it.
