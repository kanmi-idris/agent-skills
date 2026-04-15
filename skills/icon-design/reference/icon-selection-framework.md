# Icon Selection Framework

Use this when choosing between existing icon metaphors or critiquing one.

## Principle

The "best" icon is not the prettiest one. It is the one users are most likely to understand quickly, in context, at the intended size, without colliding with nearby meanings.

## Selection sequence

1. **Name the real meaning**
   - What is the user trying to do or understand?

2. **Classify the type**
   - object, action, state, navigation, or abstract concept

3. **Build candidate metaphors**
   - start with conventional choices
   - add contextual alternatives only if needed

4. **Filter high-risk candidates**
   - remove icons that are cute, niche, or easily overloaded

5. **Score the remaining options**
   - use the rubric below

6. **Recommend the winner**
   - lead with one choice
   - explain if a visible label is still required

## Scoring rubric

Score each candidate from 1 to 5.

| Criterion | What to ask | Fail signal |
| --- | --- | --- |
| Meaning fit | Does the icon represent the intended concept? | It could mean several unrelated things |
| Convention strength | Will many users already know this metaphor? | It needs explanation to work |
| Context fit | Does it make sense in this exact UI? | It works only in the abstract |
| Distinctness | Is it visually distinct from nearby icons? | It collides with adjacent actions |
| Small-size survival | Does it still read at 16–20 px? | Internal detail collapses |
| System fit | Does it match the existing family? | Stroke/fill/shape language feels foreign |
| Cultural stability | Is it broadly safe across users? | Region, domain, or age group changes the meaning |
| Label dependence risk | Can it stand alone if needed? | Tooltip is doing all the work |

If a candidate is weak on **meaning fit**, **convention strength**, or **distinctness**, do not recommend it as icon-only.

## Tie-breakers

When two candidates score similarly:

1. Prefer the more conventional metaphor.
2. Prefer the clearer silhouette at small sizes.
3. Prefer the one that matches the surrounding family better.
4. Prefer the one that needs less explanation.

## Common confusion pairs

Watch these closely:

- download vs export
- upload vs import
- save vs archive
- close vs remove vs delete
- settings vs filter vs tune
- history vs activity vs audit log
- share vs send vs publish

Do not assume these can be solved by icon shape alone.

## Good recommendation language

Use language like:

- "I recommend X because it matches the user's mental model for this action."
- "I would not use Y here because users often read it as Z."
- "This can work only with a visible label."
- "If the action actually means A instead of B, switch to this alternative."

## Fail-safe rule

If no candidate is clearly strong, recommend one of these instead:

- icon + visible label
- clearer copy with a secondary icon
- a UI treatment that does not rely on icon-only recognition
