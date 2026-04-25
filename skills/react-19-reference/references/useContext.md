# `useContext`

## Core purpose

Use `useContext` to read and subscribe to a context value from the nearest matching provider above the current component.

```js
const value = useContext(SomeContext)
```

## Mental model

Context is a dependency injection channel for React trees.

- `createContext` defines the channel
- a provider supplies the current value
- `useContext` reads the closest value above the current component

The context object itself does not store data. It identifies which provider/consumer pair React should connect.

## Use it when

- data needs to be available deeply in the tree without prop drilling
- multiple distant components need the same ambient state
- you want to expose shared state plus actions through a provider
- a feature area benefits from colocated provider + consumer hooks

Common fits:

- theme
- current user / auth state
- router state
- feature-scoped reducer state + dispatch

## Do not use it when

- the data is only needed by a few nearby components
- plain props would be clearer
- you are trying to avoid thinking about state ownership
- the context value changes too frequently and would fan out avoidable re-renders across large parts of the tree

Rule:

- use context for shared ambient dependencies
- do not use it as the default container for every piece of app state

## Smallest good example

```tsx
import { createContext, useContext } from 'react'

const ThemeContext = createContext('light')

function Button({ children }) {
  const theme = useContext(ThemeContext)
  return <button className={`button-${theme}`}>{children}</button>
}

export default function App() {
  return (
    <ThemeContext value="dark">
      <Button>Sign up</Button>
    </ThemeContext>
  )
}
```

## Most important rule

`useContext` only sees providers **above** the component that calls it.

It does not see:

- providers returned later in the same component
- providers below it in the tree

Wrong mental model:

```tsx
function Example() {
  const theme = useContext(ThemeContext)

  return <ThemeContext value="dark">...</ThemeContext>
}
```

The `useContext` call above will **not** read `"dark"` from that provider, because the provider is created in the same render output and is not above the caller.

## How updates work

When the provider `value` changes:

- React compares old vs new with `Object.is`
- all consumers for that context under that provider are re-rendered
- `memo` does not block consumers from receiving the fresh context value

This is one of the most important performance properties of context.

## Default value behavior

If there is **no matching provider above at all**, `useContext` returns the default value passed to `createContext(defaultValue)`.

```js
const ThemeContext = createContext('light')
```

Important:

- the default value is a fallback, not a dynamic initial state
- if a provider exists and passes `undefined`, consumers get `undefined`, not the default

## Good design patterns

### 1. Provider + state

The provider usually gets its value from state owned above it.

```tsx
function App() {
  const [theme, setTheme] = useState('dark')

  return (
    <ThemeContext value={theme}>
      <Page />
    </ThemeContext>
  )
}
```

### 2. Split state and dispatch contexts

For reducer-style state, use separate contexts for state and dispatch.

```tsx
const TasksContext = createContext(null)
const TasksDispatchContext = createContext(null)
```

Why this is often better:

- clearer consumer APIs
- fewer unnecessary re-renders for dispatch-only consumers
- easier separation of read vs write concerns

### 3. Custom consumer hooks

Hide raw `useContext` behind custom hooks when the context is app-specific.

```tsx
export function useTasks() {
  return useContext(TasksContext)
}

export function useTasksDispatch() {
  return useContext(TasksDispatchContext)
}
```

This improves call sites and gives you one place to add validation later.

### 4. Extract provider plumbing

If you have many nested providers near the root, it is fine to group them in a dedicated provider component.

This improves readability without changing the underlying model.

## Multiple contexts

Use multiple focused contexts instead of one giant “app context” when the values have different concerns or update rhythms.

Good:

- `ThemeContext`
- `CurrentUserContext`
- `TasksContext`
- `TasksDispatchContext`

Avoid:

- one massive object holding unrelated state

Why:

- easier reasoning
- better composability
- fewer broad re-render cascades

## Overriding context

Providers can be nested to override values for a subtree.

```tsx
<ThemeContext value="dark">
  <Page />
  <ThemeContext value="light">
    <Footer />
  </ThemeContext>
</ThemeContext>
```

The nearest matching provider wins.

## Performance guidance

Context is simple, but value identity matters.

Bad pattern:

```tsx
<AuthContext value={{ currentUser, login }}>
  <Page />
</AuthContext>
```

If the parent re-renders, that object is new every time, and all consumers will re-render.

When this matters, stabilize the function with `useCallback` and the object with `useMemo`:

```tsx
const login = useCallback((response) => {
  storeCredentials(response.credentials)
  setCurrentUser(response.user)
}, [])

const contextValue = useMemo(() => {
  return { currentUser, login }
}, [currentUser, login])

return <AuthContext value={contextValue}><Page /></AuthContext>
```

Important:

- this is a performance optimization, not a correctness requirement
- do it when fan-out re-renders matter
- do not cargo-cult it into every provider

## Common mistakes

### Reading from the wrong place in the tree

If a component does not see the expected value:

- the provider may be missing
- the provider may be in a sibling branch
- the provider may be inside the same component rather than above it

### Expecting `memo` to block context updates

`memo` does not stop context consumers from re-rendering when the consumed value changes.

### Treating default value as a fallback for `undefined`

If a provider exists with `value={undefined}`, consumers receive `undefined`.

### Putting too much into one context

Large object-shaped contexts make broad re-renders more likely and often blur ownership boundaries.

### Passing unstable objects/functions in hot paths

If the provider value changes identity every render, every consumer updates too.

## Troubleshooting

### “My component does not see the provider value”

Check:

- is the provider actually above the consumer?
- is it the same context object?
- is the component rendered in the branch you think it is?

### “I always get `undefined` even though the default is different”

You probably have a provider above with:

- no `value` prop
- `value={undefined}`
- the wrong prop name

The default only applies when there is no matching provider at all.

### “Context seems broken with symlinks or monorepo tooling”

Provider and consumer must use the **exact same context object** by `===`.

If duplicate module instances are produced, context can break because the provider and consumer are using different copies of what looks like the same module.

## Practical decision line

Use `useContext` for shared ambient data with clear ownership and provider boundaries. Keep contexts focused, split high-churn concerns when needed, and stabilize provider values only when re-render fan-out is actually a problem.
