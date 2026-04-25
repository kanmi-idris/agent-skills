#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
React 19 Reference — workflow

1) Identify the job
- UI state
- Action state
- Optimistic state
- Render-time derivation

2) Pick the smallest primitive
- useState / useReducer for pure UI state
- use for render-time Promise or branchy context reads
- useActionState for action result state
- useCallback only when stable function identity matters
- useContext for shared ambient data across a subtree
- useDebugValue for custom Hook DevTools labeling
- useDeferredValue when urgent UI must stay responsive while a slow subtree catches up
- useEffect only for external-system synchronization
- useEffectEvent for latest values inside Effect-owned callbacks
- useId for accessibility-safe DOM relationships
- useImperativeHandle for narrow imperative ref APIs
- useRef for persistent non-render values and DOM access
- useSyncExternalStore for subscribing to real external stores outside React
- useTransition for non-urgent background rendering and pending UI
- Fragment for grouping siblings without wrapper DOM nodes
- Profiler for measuring subtree render cost programmatically
- Suspense for loading boundaries and reveal sequencing
- Activity for hiding UI while preserving state and pre-rendered work
- cache for shared request-scoped server fetches and computations
- cacheSignal for canceling render-scoped server work
- lazy for deferring component code until first render
- memo for skipping re-renders when props truly stay stable
- startTransition for non-urgent work when you do not need pending state
- React Performance tracks for browser-timeline diagnosis of React work
- Purity and Hook rules for render safety, static structure, and React-owned invocation
- Server Components for server-only async render and client bundle reduction
- Server Functions and RSC directives for client-triggered server mutations
- React Compiler config for rollout, compatibility, and diagnostics
- React Compiler directives for explicit opt-in or temporary opt-out
- useInsertionEffect only for CSS-in-JS runtime style injection
- useLayoutEffect only for pre-paint layout measurement or visual correction
- useMemo only when a calculation or value identity actually needs caching
- useOptimistic for immediate feedback layered on canonical state
- useReducer when local state transitions benefit from named actions and centralized logic

3) Explain the boundaries
- When to use
- When not to use
- Transition / server / serialization caveats

4) Give the smallest working example
- Prefer event or form flow examples
- Show the real trigger pattern

5) End with the failure mode
- Common mistake
- Why it breaks
- Correct fix

Current coverage
- useActionState
- useCallback
- useContext
- useDebugValue
- useDeferredValue
- useEffect
- useEffectEvent
- useId
- useImperativeHandle
- useRef
- useSyncExternalStore
- useTransition
- Fragment
- Profiler
- Suspense
- Activity
- cache
- cacheSignal
- lazy
- memo
- use
- startTransition
- React Performance tracks
- React purity and Hook rules
- Server Components
- Server Functions
- use client directive
- use server directive
- React Compiler configuration
- compilationMode
- gating
- logger
- panicThreshold
- target
- React Compiler directives
- use memo directive
- use no memo directive
- useInsertionEffect
- useLayoutEffect
- useMemo
- useOptimistic
- useReducer
EOF
