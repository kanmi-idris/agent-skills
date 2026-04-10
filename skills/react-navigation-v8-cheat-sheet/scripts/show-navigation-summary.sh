#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
React Navigation v8 — quick summary

1) Static vs dynamic
- Prefer static config in v8
- Use dynamic only for real runtime conditional screen trees

2) Native bottom tabs
- Native by default
- Android limited to 5 tabs
- Header hidden by default
- Opt out with implementation: 'custom'

3) Deep linking
- Static config enables deep linking ergonomics by default
- Add linking.path per screen
- Zod parsing works well for route param coercion

4) Auth flow
- Prefer static `if` screen conditions in v8
- Auth transitions happen automatically on state change

5) TypeScript
- Prefer module augmentation over legacy RootParamList-first patterns
- Static hooks: useNavigation('ScreenName'), useRoute('ScreenName')

6) Minimum requirements
- React Native >= 0.83
- Expo >= 55 (dev build only, no Expo Go)
- TypeScript >= 5.9.2
- react-native-screens >= 4.20.0
- New Architecture required
EOF
