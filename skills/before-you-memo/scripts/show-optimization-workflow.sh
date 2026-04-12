#!/usr/bin/env bash
set -euo pipefail

cat <<'EOF'
Before You memo() — workflow

1) Validate the signal
- Test production build
- Profile the slow interaction

2) Fix structure first
- Move state down
- Lift static content up with children

3) Re-profile
- Confirm expensive subtrees stopped re-rendering

4) Memoize only if needed
- memo for expensive stable-prop components
- useMemo for expensive calculations

Common mistakes
- Globalizing transient UI state
- Adding memo before profiling
- useMemo for trivial work
- Using memoization to hide poor boundaries
EOF
