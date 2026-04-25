---
name: react-19-reference
description: |
  Consolidated React 19 reference guidance with practical decision rules, caveats, and examples. Use when choosing or applying hooks and adjacent React primitives like use, useActionState, useCallback, useContext, useDebugValue, useDeferredValue, useEffect, useEffectEvent, useId, useImperativeHandle, useInsertionEffect, useLayoutEffect, useMemo, useOptimistic, useReducer, useRef, useSyncExternalStore, useTransition, startTransition, Fragment, Profiler, Suspense, Activity, cache, cacheSignal, lazy, memo, React Performance tracks, React purity and Hook rules, Server Components, Server Functions, and React Compiler configuration like compilationMode, gating, logger, panicThreshold, target, and directives such as "use memo", "use no memo", "use client", and "use server".

  Triggers when user mentions:
  - "react 19 hooks"
  - "useActionState"
  - "useCallback"
  - "useContext"
  - "useDebugValue"
  - "useDeferredValue"
  - "useEffect"
  - "useEffectEvent"
  - "useId"
  - "useImperativeHandle"
  - "useInsertionEffect"
  - "useLayoutEffect"
  - "useMemo"
  - "useRef"
  - "useReducer"
  - "new React hooks"
  - "useSyncExternalStore"
  - "useTransition"
  - "Fragment"
  - "Profiler"
  - "Suspense"
  - "Activity"
  - "cache"
  - "startTransition"
  - "cacheSignal"
  - "lazy"
  - "memo"
  - "use"
  - "React Compiler configuration"
  - "compilationMode"
  - "gating"
  - "logger"
  - "panicThreshold"
  - "target"
  - "Directives"
  - "\"use memo\""
  - "\"use no memo\""
  - "React Performance tracks"
  - "Components and Hooks must be pure"
  - "React calls Components and Hooks"
  - "Rules of Hooks"
  - "Server Components"
  - "Server Functions"
  - "'use client'"
  - "'use server'"
---

# React 19 Reference

Use this skill when a user is asking about React 19-era hooks, RSC boundaries, compiler/runtime behavior, or related React rules and wants practical guidance on when to use something, when not to use it, and what caveats matter in real code.

This skill is designed as a consolidated reference. Keep the top-level guidance here brief, and add topic-specific material under `references/` as the collection grows.

This skill infers what it can do from the available project context and config. `.env.example` defines the minimum config for the skill. For this skill, no credentials or required environment variables are needed.

## Quick Usage (Already Configured)

### Show the consolidation workflow
```bash
bash scripts/show-hooks-workflow.sh
```

### Ask for help directly
- “Should I use `useActionState` here?”
- “What’s the difference between `useActionState` and `useReducer`?”
- “Which React 19 hook fits this form flow?”

## Working Rules

When this skill is used, follow this workflow:

1. Identify whether the question is about **UI state**, **Action state**, **optimistic state**, or **render-time computation**.
2. Prefer the **smallest hook that matches the job**.
3. Explain **when not to use** the hook, not just when to use it.
4. Call out **transition**, **serialization**, or **server/client** caveats inline when they matter.
5. Prefer **copy-pasteable examples** that show the real trigger pattern.
6. If a hook has a sharp edge, include the **failure mode** and the fix.

## Decision Guide

- Pure UI state with no side effects: prefer `useState` or `useReducer`.
- Read a Promise or branchy context during render: consider `use`.
- Action result state with pending behavior and side effects: prefer `useActionState`.
- Stable function identity for a real optimization or Hook API boundary: consider `useCallback`.
- Shared ambient data across a subtree: consider `useContext`, but keep the context focused.
- Custom Hook DevTools labeling: consider `useDebugValue` when the debugging value is real.
- Keep urgent UI responsive while a slow subtree lags behind: consider `useDeferredValue`.
- Synchronize with an external system: consider `useEffect`, but default to avoiding it when no external system exists.
- Read latest values inside Effect-owned callbacks without re-synchronizing the Effect: consider `useEffectEvent`.
- Generate accessibility-safe DOM relationship IDs: consider `useId`.
- Expose a narrow imperative ref API to parents: consider `useImperativeHandle`, but prefer props for declarative control.
- Persist mutable values without rendering or access DOM nodes: consider `useRef`.
- Subscribe to a real external source of truth outside React: consider `useSyncExternalStore`.
- Mark non-urgent rendering work as interruptible background work: consider `useTransition`.
- Group sibling elements without adding DOM wrappers: consider `Fragment`.
- Measure subtree render performance programmatically: consider `Profiler`.
- Define loading and reveal boundaries for Suspense-enabled code or data: consider `Suspense`.
- Hide UI while preserving state, DOM, and pre-rendered work: consider `Activity`.
- Share request-scoped server fetches or computations across Server Components: consider `cache`.
- Cancel render-scoped server work when React no longer needs it: consider `cacheSignal`.
- Defer component code loading until first render: consider `lazy`.
- Skip re-rendering an actually expensive component when props stay stable: consider `memo`.
- Mark non-urgent work as a Transition outside hooks or without pending state: consider `startTransition`.
- Diagnose React work inside the browser timeline: consider React Performance tracks alongside `<Profiler>` and browser Performance tooling.
- Fix render bugs by preserving purity, static Hook structure, and React-owned call sites.
- Split server-only rendering work from interactive client work deliberately: consider Server Components.
- Use network-backed server mutations from client code deliberately: consider Server Functions, `'use server'`, `'use client'`, and `useActionState`.
- Configure React Compiler rollout and compatibility deliberately: consider `compilationMode`, `target`, `panicThreshold`, `gating`, and `logger`.
- Control per-function compiler selection only when config is not enough: consider directives like `"use memo"` and `"use no memo"`.
- Inject runtime CSS before layout Effects: consider `useInsertionEffect`, but only for CSS-in-JS library infrastructure.
- Measure layout or make a visual correction before paint: consider `useLayoutEffect`, but prefer `useEffect` by default.
- Cache an expensive calculation or preserve value identity for a real optimization boundary: consider `useMemo`.
- Show temporary optimistic UI while an Action is pending: consider `useOptimistic`.
- Immediate feedback before async confirmation: layer `useOptimistic` on top of the canonical state source.
- Complex local state transitions with named actions: consider `useReducer`.
- Render-time derivation or memoization questions: do not force these through Action hooks.

## Current Hook Coverage

- `useActionState`: action result state, pending state, sequential dispatching, forms, optimistic UI pairing, and error handling.
- `useCallback`: stable function identity, memo boundaries, custom Hook outputs, and dependency reduction tradeoffs.
- `useContext`: provider lookup rules, re-render behavior, split contexts, and stabilizing provider values when needed.
- `useDebugValue`: custom Hook labels in React DevTools, when to add them, and when to defer formatting.
- `useDeferredValue`: stale-while-refreshing UI, render-priority control, Suspense behavior, and how it differs from debouncing.
- `useEffect`: external-system synchronization, dependency discipline, cleanup symmetry, and why many Effects should not exist.
- `useEffectEvent`: separating reactive synchronization from non-reactive Effect-owned callbacks that need latest values.
- `useId`: accessibility IDs, shared prefixes, SSR-safe generation, and why it should not be used for keys.
- `useImperativeHandle`: narrow imperative ref APIs, internal DOM encapsulation, and when declarative props are better.
- `useInsertionEffect`: CSS-in-JS runtime style injection timing, and why ordinary app code should almost never use it.
- `useLayoutEffect`: pre-paint layout measurement, flicker avoidance, and why it should be rarer than `useEffect`.
- `useMemo`: caching expensive calculations, preserving value identity, and why React 19 lowers the need for manual memoization.
- `useOptimistic`: temporary optimistic overlays during Actions, reducer vs updater tradeoffs, and rollback behavior.
- `useReducer`: centralized state transitions, action design, initializer functions, and immutable updates.
- `useRef`: persistent non-render values, DOM access, lazy initialization, and why refs are not state.
- `useSyncExternalStore`: external subscriptions, snapshot stability, SSR snapshots, and why it is an integration hook rather than normal state.
- `useTransition`: non-urgent background rendering, pending UI, Suspense-friendly navigation, and async caveats.
- `Fragment`: grouping without wrapper DOM nodes, keyed fragment lists, and canary fragment refs.
- `Profiler`: subtree render measurement, timing callback semantics, and when programmatic profiling is worth the overhead.
- `Suspense`: loading boundaries, reveal sequencing, transition-aware fallback behavior, and Suspense-enabled data constraints.
- `Activity`: hide-vs-unmount behavior, state and DOM restoration, pre-rendering, and effect cleanup boundaries.
- `cache`: request-scoped server memoization, shared fetch snapshots, preload patterns, and `cache` vs `useMemo` vs `memo`.
- `cacheSignal`: render-lifetime cancellation for server work, abort-aware fetches, and ignoring cancellation-driven errors.
- `lazy`: code-splitting boundaries, top-level declaration rules, and why it pairs with `Suspense`.
- `memo`: prop-stability render skipping, compiler-first guidance, and why structural fixes often beat blanket memoization.
- `use`: render-time Promise/context reading, Server-vs-Client tradeoffs, and why `await` is usually better in Server Components.
- `startTransition`: standalone non-urgent scheduling, no pending signal, async caveats, and when it is better than `useTransition`.
- `React Performance tracks`: browser Performance-panel correlation for Scheduler, Components, Suspense, and server-side render/request timing.
- `React purity and Hook rules`: render idempotence, no side effects in render, immutable snapshots, top-level Hook structure, and React-owned invocation.
- `Server Components`: server/client rendering boundaries, async server render, serialization, and when server-side data work should stay off the client.
- `Server Functions and RSC directives`: mutation-oriented server calls, form actions, serialization boundaries, and when to mark modules with `'use client'` or functions with `'use server'`.
- `React Compiler configuration`: compile selection, version targeting, error policy, rollout gating, and compiler diagnostics.
- `React Compiler directives`: function-level and module-level opt-in/opt-out control, rollout escape hatches, and when directives are justified.

## References

- `references/useActionState.md` — full decision rules, caveats, examples, and troubleshooting for `useActionState`.
- `references/useCallback.md` — when stable function identity helps, when it does not, and how React Compiler changes the default posture.
- `references/useContext.md` — provider lookup, default values, overrides, splitting contexts, and context re-render tradeoffs.
- `references/useDebugValue.md` — custom Hook DevTools labels, selective usage, and lazy formatting.
- `references/useDeferredValue.md` — render-priority control, stale content patterns, memo requirements, and debounce/throttle distinctions.
- `references/useEffect.md` — external-system synchronization, dependency rules, cleanup patterns, and alternatives when no Effect is needed.
- `references/useEffectEvent.md` — latest values inside Effects, call-site restrictions, and why it is not a dependency escape hatch.
- `references/useId.md` — accessibility IDs, shared prefixes, hydration constraints, and multi-root identifier prefixes.
- `references/useImperativeHandle.md` — narrow imperative APIs over refs, dependency guidance, and declarative-vs-imperative tradeoffs.
- `references/useInsertionEffect.md` — runtime CSS injection timing, server constraints, and why it is not a general “faster Effect.”
- `references/useLayoutEffect.md` — pre-paint measurement, performance costs, SSR constraints, and when to prefer `useEffect`.
- `references/useMemo.md` — expensive calculation caching, value identity, compiler-era guidance, and common memoization traps.
- `references/useOptimistic.md` — optimistic overlays during Actions, reducer/updater patterns, pending-state strategies, and failure rollback behavior.
- `references/useReducer.md` — centralized state transitions, action vocabulary, immutable updates, initializer usage, and reducer-vs-state tradeoffs.
- `references/useRef.md` — persistent non-render values, DOM refs, lazy initialization, and the boundary between refs and state.
- `references/useSyncExternalStore.md` — external subscriptions, stable snapshot rules, SSR hydration snapshots, and store-vs-React-state guidance.
- `references/useTransition.md` — non-urgent background rendering, pending UI, Suspense-friendly updates, action props, and async ordering caveats.
- `references/Fragment.md` — grouping without wrapper nodes, keyed fragment lists, canary fragment refs, and when a real wrapper is still needed.
- `references/Profiler.md` — programmatic render measurement, timing callback interpretation, profiling-build caveats, and subtree-level profiling guidance.
- `references/Suspense.md` — loading boundaries, reveal-together vs reveal-progressively patterns, transition-aware fallback control, and Suspense-enabled source constraints.
- `references/Activity.md` — hide-vs-unmount behavior, state and DOM restoration, pre-rendering, media cleanup caveats, and when Activity is the right boundary.
- `references/cache.md` — request-scoped server memoization, shared async work, preload patterns, argument identity pitfalls, and how `cache` differs from `useMemo` and `memo`.
- `references/cacheSignal.md` — render-lifetime cancellation, abort-aware server fetches, null-outside-render semantics, and cancellation-aware error handling.
- `references/lazy.md` — code-splitting boundaries, top-level declaration rules, Suspense pairing, and when lazy loading is worth the boundary cost.
- `references/memo.md` — prop-stability render skipping, compiler-era guidance, prop-shape strategy, and the real tradeoffs of manual component memoization.
- `references/use.md` — render-time Promise/context reading, Suspense and Error Boundary integration, branch flexibility, and `use` vs `await`.
- `references/startTransition.md` — standalone transition scheduling, no pending signal, outside-component usage, and async-boundary limitations.
- `references/react-performance-tracks.md` — browser timeline diagnostics, Scheduler and Components interpretation, profiling-build constraints, and server track guidance.
- `references/react-purity.md` — render idempotence, side-effect boundaries, immutable snapshots, local mutation, and JSX immutability timing.
- `references/react-calls-components-and-hooks.md` — JSX-only component invocation, static Hook usage, and why React must own call orchestration.
- `references/rules-of-hooks.md` — top-level Hook constraints, valid call sites, structural fixes, and the special-case relationship to `use`.
- `references/server-components.md` — server/client boundaries, async Server Components, composition with Client Components, and practical adoption guidance.
- `references/server-functions.md` — mutation-oriented server calls, form integration, transition-wrapped calls, and `useActionState` pairing.
- `references/use-client-directive.md` — client boundary semantics, transitive client subtrees, bundling implications, and when interactivity justifies client code.
- `references/use-server-directive.md` — Server Function marking, module-vs-function placement, serialization limits, and security posture.
- `references/react-compiler-configuration.md` — React Compiler config overview, default posture, rollout strategy, and how the options fit together.
- `references/compilationMode.md` — compile selection strategies, inference vs annotation tradeoffs, and safe incremental adoption.
- `references/gating.md` — runtime feature-flag rollout, bundle-size tradeoffs, and gating import requirements.
- `references/logger.md` — compiler event diagnostics, temporary debug logging, and practical error/timing inspection patterns.
- `references/panicThreshold.md` — production-safe error policy, stricter development thresholds, and why `'none'` is the steady-state default.
- `references/target.md` — React version compatibility, runtime package requirements for 17/18, and output verification.
- `references/react-compiler-directives.md` — directive overview, mode interaction, placement rules, and the default posture for `"use memo"` vs `"use no memo"`.
- `references/use-memo-directive.md` — when explicit opt-in makes sense, especially in `annotation` mode, and when naming fixes are better.
- `references/use-no-memo-directive.md` — temporary opt-out strategy, rollout debugging, and how to keep escape hatches narrow and removable.

## Using `scripts/`

- `scripts/show-hooks-workflow.sh` prints the recommended consolidation workflow and current covered hooks.
- If this skill grows later, additional long-form hook notes should live in `references/` rather than bloating this file.

## First-Time Setup (If Not Configured)

1. Open `.env.example` and confirm the minimum config.
2. Read the relevant hook reference under `references/`.
3. Give the user the smallest working example for their actual interaction model.
4. Use `scripts/show-hooks-workflow.sh` for a quick refresher.
