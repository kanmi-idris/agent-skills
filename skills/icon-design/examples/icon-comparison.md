# Example: Icon Comparison

## User request

"Which is better for notifications in our app: a bell or a megaphone?"

## Good response shape

Start by naming the semantic difference before picking a winner.

> I recommend the **bell** for notifications. In most product interfaces, users already associate a bell with alerts, inbox-like notification centers, and unread updates. A **megaphone** usually reads more like announcement, broadcast, promotion, or marketing message than personal notifications.

### Comparison

- **Bell**
  - **Best for:** alerts, unread updates, notification centers
  - **Strength:** strong convention in app UI
  - **Risk:** can feel generic, so use labels when needed

- **Megaphone**
  - **Best for:** announcements, broadcasts, campaigns, admin messages
  - **Strength:** strong one-to-many communication cue
  - **Risk:** users may not read it as routine notifications

### Recommendation

- **Winner:** bell
- **Why it wins:** it better matches the everyday mental model for app notifications
- **When I would switch:** if this surface is specifically for company-wide announcements, broadcasts, or promotional messages, use the megaphone instead
- **Label:** optional in a well-established notifications pattern; recommended if this appears beside other communication tools

### Accessibility note

If the control opens a notification center, an accessible name like `Notifications` is better than a vague label like `Alerts icon`.

## Why this is a good answer

- It compares meaning, not just visual taste.
- It explains when the losing option becomes the right one.
- It keeps the recommendation conditional on the actual product semantics.
