# Output Schema and Correctness Gate

The final output must contain exactly one expanded prompt, not an audit report.

## Required sections in the expanded prompt

- `You are a coding agent.`
- `Goal:`
- `Context:`
- `Constraints:`
- `Done when:`
- `Source of truth:`
- `Relevant data flow:`
- `Work outcome-first...`
- `Final answer: only the corrected result plus any critical caveats...`

## Correctness gate

Before finalizing, verify:

1. The objective exactly matches the user’s intent.
2. Every named file, command, route, schema, contract, test, and convention was found in the repo or marked `UNVERIFIED`.
3. The prompt includes exact success criteria and verification commands when available.
4. The prompt includes full data-flow tracing requirements.
5. The prompt avoids unsupported claims and vague instructions.
6. The prompt is minimal enough for direct use by a coding agent.
7. The prompt does not expose hidden reasoning or raw subagent transcripts.
8. The prompt preserves safety constraints and approval requirements.

If any check fails, revise the prompt before returning it.
