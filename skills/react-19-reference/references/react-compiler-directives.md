## React Compiler Directives

Use React Compiler directives only when project-level configuration is not enough. They are explicit escape hatches for opting a function or module into or out of compilation.

## What They Control

- `"use memo"` opts code into React Compiler optimization.
- `"use no memo"` opts code out of React Compiler optimization.

They work at:

- function scope
- module scope

Function-level directives override module-level directives.

## Default Posture

- Prefer project-level config first.
- Prefer `compilationMode: 'infer'` for normal React 19 codebases.
- Use `"use memo"` mainly for `annotation` mode or carefully staged rollouts.
- Use `"use no memo"` as a temporary escape hatch, not a permanent architecture choice.

## Directive Semantics

### `"use memo"`

Use it when you need to explicitly mark a function for compilation.

Best fit:

- `annotation` mode, where only marked functions compile
- a gradual rollout where you want deliberate opt-in
- rare cases where `infer` mode misses a valid target and renaming or structural cleanup is not the immediate path

Not the default fix for:

- poor naming conventions
- components that violate Rules of React
- components that should be cleaned up instead of forced through the compiler

Practical rule:

- In `infer` mode, fix naming and React structure first.
- In `annotation` mode, `"use memo"` is the normal opt-in tool.

### `"use no memo"`

Use it to prevent compilation for a specific function or module.

Best fit:

- debugging compiler-related behavior
- isolating a rollout issue
- temporarily shielding an incompatible integration while you fix it

Treat it like a temporary TODO-backed exception, not a steady-state pattern.

## Placement Rules

Directives must be:

- the first statement in the function body or module
- written as exact string literals
- placed before executable code

Comments are fine above them, but executable statements are not.

## Mode Interaction

- `annotation`: only `"use memo"` functions compile
- `infer`: compiler chooses by heuristics, directives override
- `all`: everything compiles unless `"use no memo"` excludes it

## Good Usage Pattern

```js
function StableLeaf({ item }) {
  "use memo";
  return <li>{item.name}</li>;
}
```

```js
function ThirdPartyWrapper(props) {
  "use no memo"; // TODO: Remove after compatibility fix lands
  return <LegacyWidget {...props} />;
}
```

## What To Tell Users

- Use directives sparingly.
- Prefer config for broad rollout strategy.
- Prefer `"use memo"` for deliberate opt-in.
- Prefer `"use no memo"` only as a short-lived escape hatch with a tracked removal reason.
