## `"use memo"` Directive

`"use memo"` explicitly marks a function for React Compiler optimization.

## When It Fits

- You are using `compilationMode: 'annotation'`
- You are doing incremental rollout and want explicit opt-in
- You need a narrow compilation boundary for a known-good function

## When It Usually Does Not Fit

- You are in `infer` mode and the real problem is bad naming
- You are trying to paper over Rules of React violations
- You are forcing compilation on code that should be refactored first

In `infer` mode, a component or hook not being compiled is often a naming or structure problem, not a directive problem.

## Mental Model

`"use memo"` tells the compiler: treat this function as a target for optimization.

That does not mean:

- all code inside is suddenly valid
- compiler errors disappear
- manual memoization strategy becomes irrelevant

It only changes selection, not correctness.

## Best Use Case

```js
function ProductCard({ product }) {
  "use memo";
  return <article>{product.name}</article>;
}
```

This is most defensible when:

- the component is already stable
- the team is rolling out compiler coverage gradually
- `annotation` mode is intentional

## Sharp Edges

- It must be the first statement in the function body.
- It must be spelled exactly.
- It is redundant in `all` mode.
- In `infer` mode, it should not replace fixing conventions.

## Practical Recommendation

- Use `"use memo"` mostly with `annotation`.
- In `infer`, prefer naming cleanup and compiler-compatible structure first.
- If you add it as a rollout tool, document why.
