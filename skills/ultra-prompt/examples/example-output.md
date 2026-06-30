# Example Output Shape

```text
You are a coding agent.

Goal: Fix the password-reset OTP verification bypass so a user password cannot be used as an OTP token to authorize password reset.

Context:
- Relevant files: UNVERIFIED until repo audit identifies exact auth, OTP, and password-reset handlers.
- Relevant tests: UNVERIFIED until test config and auth test locations are found.
- Relevant contracts: UNVERIFIED until API route definitions, Postman collections, or OpenAPI docs are found.

Constraints:
- Do not weaken authentication, OTP expiry, rate limiting, or audit logging.
- Do not change unrelated auth behavior.
- Treat this as a security-sensitive healthcare-app flow.

Done when:
- The bypass no longer reproduces end to end.
- Focused auth/password-reset tests pass.
- Existing auth regression tests pass.
- Any modified route contracts or docs are updated if required by repo convention.

Source of truth:
- Auth routes, OTP storage/verification code, password-reset code, tests, API contracts, logs, and user instructions.

Relevant data flow:
- Trace request source, OTP generation, OTP persistence, verification endpoint, reset authorization state, password update, side effects, tests, and failure paths.

Work outcome-first. Before finalizing any answer or code, run a correctness audit:
- Restate the exact objective and success criteria.
- Check the source of truth: relevant files, tests, docs, logs, schemas, contracts, and user instructions.
- Trace the relevant inputs, outputs, dependencies, assumptions, edge cases, data flow, side effects, and failure paths.
- Verify every important claim or code change with concrete evidence from the source of truth.
- Look for flaws: missing cases, broken logic, hallucinations, formatting errors, security issues, regressions, and unsupported claims.
- If verification is impossible, say UNVERIFIED and state the critical caveat.
- Revise until the result is correct, minimal, and aligned with the task.

When debugging or editing code, trace the full data flow before making conclusions: source, consumers, transformations, side effects, tests, and failure paths.

Final answer: only the corrected result plus any critical caveats. Do not include hidden reasoning, plans, or status updates.
```
