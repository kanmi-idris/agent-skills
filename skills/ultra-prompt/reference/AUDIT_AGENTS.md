# Audit Agents

Use these audit agents before expanding the user prompt. Spawn them in parallel when supported. Each agent must return concise findings with evidence, not recommendations detached from the repo.

## Agent 1: Intent and scope auditor

Task:
- Restate the user’s exact objective.
- Identify what must be changed, debugged, tested, or explained.
- Identify non-goals and ambiguous areas.
- Identify whether the task is implementation, debugging, QA, refactor, security, documentation, or prompt-only.

Return:
- `objective`
- `success_criteria`
- `non_goals`
- `ambiguities_or_unverified_items`

## Agent 2: Repository source-of-truth auditor

Task:
- Inspect repo layout and locate files/folders most relevant to the task.
- Locate docs, AGENTS.md, README, package manifests, test configs, lint configs, schemas, API contracts, env examples, CI workflows, and project conventions.
- Identify exact commands for build, lint, test, typecheck, app start, and relevant focused tests.

Return:
- `relevant_files`
- `relevant_docs`
- `repo_conventions`
- `verification_commands`
- `missing_or_unverified_sources`

## Agent 3: Data-flow and dependency auditor

Task:
- Trace full data flow around the requested area: source, consumers, transformations, storage, network/API boundaries, side effects, async jobs, caches, queues, UI consumers, and external dependencies.
- Identify assumptions and edge cases.
- Identify failure paths and observable symptoms.

Return:
- `inputs`
- `outputs`
- `dependencies`
- `data_flow`
- `side_effects`
- `edge_cases`
- `failure_paths`

## Agent 4: Risk and regression auditor

Task:
- Identify security, privacy, correctness, performance, concurrency, auth, validation, migration, and backward-compatibility risks relevant to the task.
- Identify likely regressions and tests that should catch them.
- Flag unsafe/destructive actions requiring approval.

Return:
- `risks`
- `regression_surfaces`
- `security_considerations`
- `approval_required`
- `critical_caveats`

## Agent 5: Prompt assembly auditor

Task:
- Review all audit findings.
- Remove unsupported claims.
- Convert findings into a concise coding-agent prompt using the required template.
- Ensure the prompt is actionable, scoped, minimal, and verification-driven.

Return:
- `expanded_prompt_draft`
- `evidence_gaps`
- `final_caveats`
