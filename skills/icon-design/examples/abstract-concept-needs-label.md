# Example: Abstract Concept Needs Label

## User request

"What icon should represent AI autofix in our developer tool?"

## Good response shape

Start by naming the risk.

> "AI autofix" is not a stable icon-only concept. Users may read common AI-adjacent symbols as sparkle, magic, automation, suggestion, assistant, or premium. I would not rely on icon-only comprehension here.

### Recommendation

- **Recommended UI treatment:** icon + visible label
- **Suggested icon:** a conservative assistant/automation cue from your existing system, paired with text such as **AI Autofix** or **Suggest Fix**
- **Why this wins:** the text carries the abstract meaning; the icon acts as a recognition aid instead of doing all the semantic work

### Rejected options

- **Sparkles only:** too broad; often reads as enhancement, polish, or magic
- **Robot head:** too literal and may feel novelty-heavy or off-brand
- **Wand:** implies magic more than reliable code action

### Accessibility note

If the visible label is ever removed in a compact layout, ensure the control still has an accurate accessible name like `AI Autofix`.

## Why this is a good answer

- It refuses false precision for an abstract concept.
- It uses text as a deliberate design tool.
- It still gives the user a practical recommendation instead of only saying no.
