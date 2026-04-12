---
name: before-you-memo
description: |
  React re-render optimization playbook based on "Before You memo()". Use when diagnosing slow renders or unnecessary re-renders, especially before adding memo/useMemo/useCallback.

  Triggers when user mentions:
  - "before you memo"
  - "unnecessary re-renders"
  - "slow React render"
---

# Before You memo()

Use this skill when a React or React Native screen feels slow during state updates and you are considering memoization.

This skill infers what it can do from the available project context and config. `.env.example` defines the minimum config for the skill. For this skill, no credentials or required environment variables are needed.

## Quick Usage (Already Configured)

### Show the optimization workflow
```bash
bash scripts/show-optimization-workflow.sh
```

### Ask for help directly
- “This component re-renders too much.”
- “Should I use memo here?”
- “Why is this React screen slow during state updates?”

## Goal

Fix avoidable re-renders with component structure first, then use `memo` and `useMemo` only where profiling shows they are still needed.

## Workflow

1. Validate the performance signal.
   - Measure in a production build.
   - Profile the interaction to identify which subtree is expensive.

2. Apply structural fixes before memoization.
   - Move state down to the smallest component that actually needs it.
   - Lift content up by passing stable JSX as `children` into a stateful wrapper.

3. Re-profile.
   - Confirm expensive subtrees no longer re-render unnecessarily.

4. Add memoization only if still needed.
   - Use `memo` for expensive components whose props are stable.
   - Use `useMemo` for expensive calculations, not basic derived values.

## Pattern 1: Move State Down

Use when only a small part of the tree needs the changing state.

```tsx
export const Screen = () => {
  return (
    <>
      <ColorForm />
      <ExpensiveTree />
    </>
  )
}

const ColorForm = () => {
  const [color, setColor] = useState('red')

  return (
    <View>
      <TextInput value={color} onChangeText={setColor} />
      <Text style={{ color }}>Hello</Text>
    </View>
  )
}
```

Result: `ExpensiveTree` no longer re-renders on every keystroke.

## Pattern 2: Lift Content Up With `children`

Use when a wrapper component must own state, but most content inside it is static.

```tsx
export const Screen = () => {
  return (
    <ColorPicker>
      <Text>Hello</Text>
      <ExpensiveTree />
    </ColorPicker>
  )
}

const ColorPicker = ({ children }: { children: ReactNode }) => {
  const [color, setColor] = useState('red')

  return (
    <View style={{ borderColor: color }}>
      <TextInput value={color} onChangeText={setColor} />
      {children}
    </View>
  )
}
```

Result: when `ColorPicker` state changes, React can skip traversing unchanged `children`.

## Decision Guide

- State is only used in one small region: move state down.
- Parent wrapper needs state but interior content is mostly static: lift content up with `children`.
- Expensive component still re-renders due to changing props after restructuring: then use `memo`.

## Common Mistakes

- Putting transient local UI state into high-level or global state.
- Reaching for `memo` before profiling and restructuring.
- Using `useMemo` for trivial calculations.
- Assuming memoization can fix poor component boundaries.

## Using `scripts/`

- `scripts/show-optimization-workflow.sh` prints the recommended optimization order.
- If this skill grows later, reusable profiling helpers should live in `scripts/`.

## First-Time Setup (If Not Configured)

1. Open `.env.example` and confirm the minimum config.
2. Review `references/before-you-memo.txt` for the full background material.
3. Profile before changing structure or adding memoization.
4. Use `scripts/show-optimization-workflow.sh` for a quick refresher.

## Source Material

- Full reference: `./references/before-you-memo.txt`
