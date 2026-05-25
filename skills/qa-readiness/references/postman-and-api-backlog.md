# Postman And API Backlog Reference

## Source Of Truth

Use the Postman runner artifact for API backlog rows:

```text
test_cases/api_run_results/postman-cli-latest.json
```

This file is a Newman/Postman run JSON with:

- `run.stats`
- `run.executions[]`
- `execution.item.name`
- `execution.request`
- `execution.response`
- `execution.requestError`
- `execution.assertions[]`

## Backlog Rules

- One API backlog row equals one failed runner execution.
- Include the exact failed assertion name and error message from `execution.assertions[].error.message`.
- Include request errors even if there is no HTTP response.
- Do not replace exact runner rows with generalized grouped summaries.
- Do not use monitor aggregate results for the API backlog unless no runner artifact exists.

## Current Known Example

From `postman-cli-latest.json`:

```text
155 runner items
331 request executions
1604 assertions
65 failed assertions
60 failed runner executions
1 request error
```

Observed result distribution:

```text
Request Error: ETIMEDOUT = 1
404 Not Found = 2
500 Internal Server Error = 15
200 OK = 41
400 Bad Request = 1
```

## Severity Heuristic

- Critical: request error, timeout, missing response object, or 5xx.
- High: HTML fallback, unsafe `200 OK` for negative/security probes, incorrect 4xx behavior.
- Medium: regression-contract failures that are not clear release blockers.

## Engineering Action Heuristic

- HTML fallback or `text/html`: return API-shaped JSON; no browser fallback pages.
- ETIMEDOUT or no numeric status: stabilize transport and response object.
- 5xx on bad input/auth/validation/unsupported states: return controlled 4xx JSON.
- `200 OK` for negative probes: reject unsafe/unsupported scenarios with controlled JSON errors.

## Monitor Runs

Postman monitor summaries can be useful for high-level status, but they often omit detailed failed assertion text. Keep monitor stats in the executive summary only when the user asks for latest monitor evidence. Use the local runner artifact for the implementation backlog.
