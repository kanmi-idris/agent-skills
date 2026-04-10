---
name: react-navigation-v8-cheat-sheet
description: |
  Helps apply React Navigation v8 patterns for static config, native tabs, deep linking, auth flows, TypeScript, theming, and migration from v7.

  Triggers when user mentions:
  - "react navigation v8"
  - "static vs dynamic navigation"
  - "react navigation v8 cheat sheet"
---

# React Navigation v8 Cheat Sheet

Use this skill when a user wants practical React Navigation v8 guidance with copy-pasteable patterns, migration notes, and TypeScript-aware examples.

This skill infers what it can do from the available project context and config. `.env.example` defines the minimum config for the skill. For this skill, no credentials or required environment variables are needed.

## Quick Usage (Already Configured)

### Show the support matrix
```bash
bash scripts/show-navigation-summary.sh
```

### Ask for help directly
- “Should this app use static or dynamic navigation in v8?”
- “Show me React Navigation v8 auth flow with `if`.”
- “How do I type React Navigation v8 screens?”

## What This Skill Covers

1. **Static vs dynamic navigation**
   - Recommend static config by default in v8.
   - Explain benefits: less boilerplate, automatic deep linking, better TypeScript inference.
   - Prefer dynamic config only when runtime conditional screens are truly needed.

2. **Native bottom tabs**
   - Use native tabs by default.
   - Mention that Android is limited to 5 tabs.
   - Mention that header is hidden by default and can be re-enabled with `headerShown: true`.
   - Show `implementation: 'custom'` when opting out of native tabs.

3. **Tab bar icons**
   - Prefer built-in native symbols over extra icon libraries where appropriate.
   - Use SF Symbols on iOS and Material Symbols on Android.
   - Support dynamic icons based on focus state.

4. **Deep linking**
   - In static config, treat deep linking as enabled by default.
   - Show screen-level `linking.path` configuration.
   - Include Zod-based parsing when params need validation.
   - Include catch-all `'*'` routes for 404 handling.

5. **Modals and groups**
   - Use groups in static config for modal presentation.
   - Support `card`, `modal`, and `transparentModal` presentation options.

6. **Nesting navigators**
   - Prefer shallow nesting.
   - Show the common pattern of tabs inside a stack.
   - Explain how to navigate to nested screens.

7. **Auth flow**
   - Prefer the static `if` pattern in v8 when possible.
   - Explain that auth state changes handle transitions automatically.
   - Use dynamic conditional rendering only when the app is already built that way.

8. **TypeScript**
   - Prefer module augmentation over the old `RootParamList` pattern.
   - Prefer static config examples first.
   - Use typed hooks like `useNavigation("Profile")` and `useRoute("Profile")` for static setups.
   - Mention casting patterns only for dynamic setups when unavoidable.

9. **Theming**
   - Show dark mode theming with `DefaultTheme` and `DarkTheme`.
   - Mention material themes on Android 14+.
   - Use `PlatformColor` when aiming for true native colors.
   - Use `useTheme()` inside components.

10. **Migration and requirements**
   - Include key v7 → v8 API changes.
   - Call out minimum versions and the New Architecture requirement.

## Working Rules

When this skill is used, follow this workflow:

1. Determine whether the app should use **static** or **dynamic** navigation.
2. Prefer **static config** unless runtime conditions make dynamic config necessary.
3. Provide the **smallest copy-pasteable snippet** for the user’s case.
4. Mention important **platform limits** and **version requirements** inline.
5. Prefer **v8-native TypeScript patterns** over legacy examples.
6. If the user is migrating, call out the exact **v7 → v8 replacement** that matters.

## Recommended Response Pattern

When helping with code, structure the answer like this:

1. **Recommended pattern**
   - State whether static or dynamic is best here.
2. **Why**
   - Mention boilerplate, deep linking, typing, or runtime needs.
3. **Example**
   - Provide a minimal v8 snippet.
4. **Migration note**
   - If relevant, show what changed from v7.

## Example Guidance Snippets

### Static navigation (recommended)
```tsx
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { createStaticNavigation } from '@react-navigation/native'

const RootStack = createNativeStackNavigator({
  screens: {
    Home: HomeScreen,
    Profile: ProfileScreen,
  },
})

const Navigation = createStaticNavigation(RootStack)

export default function App() {
  return <Navigation />
}
```

### Dynamic navigation
```tsx
import { NavigationContainer } from '@react-navigation/native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'

const Stack = createNativeStackNavigator()

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="Profile" component={ProfileScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}
```

### Native bottom tabs
```tsx
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs'

const Tabs = createBottomTabNavigator({
  screens: {
    Home: HomeScreen,
    Profile: ProfileScreen,
  },
})
```

### Opt out of native tabs
```tsx
const Tabs = createBottomTabNavigator({
  implementation: 'custom',
  screens: {
    Home: HomeScreen,
    Profile: ProfileScreen,
  },
})
```

### Deep linking with Zod
```tsx
import { z } from 'zod'

const RootStack = createNativeStackNavigator({
  screens: {
    Profile: {
      screen: ProfileScreen,
      linking: {
        path: 'user/:id',
        parse: {
          id: z.coerce.number(),
        },
      },
    },
  },
})
```

### Auth flow with `if`
```tsx
function useIsSignedIn() {
  return React.useContext(AuthContext).isSignedIn
}

function useIsSignedOut() {
  return !useIsSignedIn()
}

const RootStack = createNativeStackNavigator({
  screens: {
    Home: {
      if: useIsSignedIn,
      screen: HomeScreen,
    },
    SignIn: {
      if: useIsSignedOut,
      screen: SignInScreen,
    },
  },
})
```

### Typed hooks in static config
```tsx
const navigation = useNavigation('Profile')
const route = useRoute('Profile')
```

### Module augmentation
```tsx
const RootStack = createNativeStackNavigator({
  screens: {
    Home: HomeScreen,
    Profile: ProfileScreen,
  },
})

type RootStackType = typeof RootStack

declare module '@react-navigation/core' {
  interface RootNavigator extends RootStackType {}
}
```

## Quick Migration Tips (v7 → v8)

- `navigation.getParent('some-id')` → `navigation.getParent('ScreenName')`
- `tabBarShowLabel` → `tabBarLabelVisibilityMode`
- `detachInactiveScreens` → `inactiveBehavior: 'unmount'`
- `freezeOnBlur` → `inactiveBehavior: 'pause'`
- `headerBackImageSource` → `headerBackIcon: { type: 'image', source: ... }`
- `overlayColor` (drawer) → `overlayStyle: { backgroundColor: ... }`
- `gestureResponseDistance: { horizontal: 50 }` → `gestureResponseDistance: 50`
- `InteractionManager.runAfterInteractions(...)` → `navigation.addListener('transitionEnd', ...)`
- `setParams` history behavior split into `pushParams` and `setParams`
- `useNavigation<Type>()` → `useNavigation('ScreenName')` or cast in dynamic setups

## Minimum Requirements

- React Native >= 0.83
- Expo >= 55 (dev build only, no Expo Go)
- TypeScript >= 5.9.2
- `react-native-screens` >= 4.20.0
- New Architecture required

## Common Gotchas

- Static config is the v8 default recommendation; don’t start dynamic unless you need runtime screen decisions.
- Native bottom tabs are limited to 5 tabs on Android.
- The tab header is hidden by default.
- Deep nesting hurts performance, especially on low-end Android devices.
- Expo Go is not sufficient for this setup according to the article’s minimum requirements.
- Don’t teach old `RootParamList` patterns first when the user is clearly on v8.

## Using `scripts/`

- `scripts/show-navigation-summary.sh` prints a compact summary of v8 guidance and requirements.
- If this skill grows later, keep reusable helpers in `scripts/` instead of bloating `SKILL.md` further.

## First-Time Setup (If Not Configured)

1. Open `.env.example` and confirm the minimum config.
2. Verify the app meets the minimum version requirements.
3. Confirm the app is on the New Architecture.
4. Decide whether the navigation tree should be static or dynamic before refactoring.
5. Use `scripts/show-navigation-summary.sh` before making larger navigation changes.

## References

- Inspiration: Code with Beto — “React Navigation v8 Cheat Sheet”
- Example app: https://github.com/betomoedano/react-navigation-v8-example
- React Navigation docs: https://reactnavigation.org/
