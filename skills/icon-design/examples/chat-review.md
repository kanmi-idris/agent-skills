# Example: Chat Review

## User request

"Which icon should I use for exporting CSV from a data table?"

## Good response shape

Start by clarifying the action:

- If this creates a file that lands on the user's device, treat it as a file output action.
- If this sends data to another service, treat it as transfer/share, not download.

Then give the recommendation:

> I would not treat "export" as icon-only unless your context is very narrow. If the action downloads a CSV file, use your standard **download** icon with a visible label such as **Export CSV**. If the action sends data out to another tool, switch to a transfer/share metaphor instead. Avoid an upload arrow here because many users read that as import.

Finish with risk and accessibility notes:

- **Risk:** export is overloaded; the same word can mean download, share, or push-to-integration.
- **Label:** recommended.
- **Accessibility:** if this is an icon-only button, the control needs an accessible name like `Export CSV`.

## Why this is a good answer

- It resolves context before choosing a shape.
- It recommends one clear default.
- It warns about a likely confusion pair.
- It does not pretend the icon is universally self-explanatory.
