## `"use no memo"` Directive

`"use no memo"` tells React Compiler to skip a function or module.

## What It Is For

This is an escape hatch.

Use it when:

- you are isolating a compiler-related bug
- a third-party integration is temporarily incompatible
- you need to keep rollout moving while one edge case is being fixed

## What It Is Not For

Do not use it as:

- a substitute for fixing invalid React code
- a blanket opt-out strategy for large areas of the app
- a permanent compatibility layer without follow-up work

## Good Usage Pattern

```js
function LegacyGrid(props) {
  "use no memo"; // TODO: Remove after dynamic row measurement issue is fixed
  return <ThirdPartyGrid {...props} />;
}
```

The important part is not just the directive. It is the explanation and removal plan.

## Practical Rules

- Put it first in the function body.
- Add a reason next to it.
- Add a tracking issue or TODO.
- Remove it once the underlying problem is fixed.

## Behavior

`"use no memo"` wins over broader config:

- it can exclude code in `all` mode
- it can override `infer` heuristics
- it can override module-level opt-in

## Recommended Posture

- Keep it narrow.
- Keep it temporary.
- Use it to unblock rollout, then pay down the compatibility debt.
