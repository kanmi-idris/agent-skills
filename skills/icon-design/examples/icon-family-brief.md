# Example: Icon Family Brief

## User request

"Help me define an icon family for a finance dashboard."

## Good response shape

Lead with system rules before drawing individual icons.

### System brief

- **Canvas:** 24×24
- **Live area:** 20×20
- **Stroke:** 2px centered, round caps/joins
- **Style:** outline only for v1
- **Color:** inherit via `currentColor`; semantic color belongs to the UI wrapper, not the asset

### Icon grammar

- Use stable artifacts for domain objects: card, document, chart, wallet, bell.
- Use arrows only for directional actions like transfer, send, or receive.
- Use one modifier max for states such as locked, warning, or synced.
- Keep corners and empty space consistent across the set.

### Priority v1 set

1. overview
2. accounts
3. cards
4. transfers
5. reports
6. alerts
7. support

### Hard icons first

Design these first because they define the family grammar:

- transfers
- reports
- recurring payments
- fraud / alert states

### QA plan

- compare the whole set at 24, 20, and 16
- review dark and light themes
- test confusion pairs like transfers vs send vs withdraw
- check whether text labels are still needed for admin-only features

## Why this is a good answer

- It treats consistency as a system problem, not a one-icon problem.
- It defines reusable rules before polishing individual drawings.
- It starts with the hardest concepts instead of the easiest ones.
