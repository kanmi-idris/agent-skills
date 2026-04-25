## React Calls Components And Hooks

React owns when components and Hooks are called. Your code declares structure; React orchestrates execution.

## Never Call Components Directly

Use components in JSX:

```js
return <Article />;
```

Do not do:

```js
return Article();
```

Direct calls break React’s ability to:

- preserve component identity
- reconcile correctly
- enforce Hook rules
- prioritize rendering work
- power React-aware tooling

## Never Pass Hooks Around As Ordinary Values

Hooks are not dependency-injection values or higher-order utilities to swap at runtime.

Avoid:

- higher-order Hooks that dynamically wrap other Hooks
- passing Hooks as props
- mutating which Hook implementation is used during render

Prefer:

- calling the Hook directly inside the component or custom Hook
- extracting a new custom Hook with the desired behavior

## Practical Rule

- React calls components.
- Components and custom Hooks call Hooks.
- Regular utility functions should not call Hooks.

## What To Tell Users

- If React loses control of component or Hook invocation, optimization and correctness both get worse.
- Keep component usage declarative and Hook usage static.
