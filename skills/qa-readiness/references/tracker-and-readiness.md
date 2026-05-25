# Tracker And Readiness Reference

## Google Sheet

- Spreadsheet ID: `1wogVCC9U5CuRujXkDc0VnH51S1klyr22skmzpOQP5WI`
- Android UI tab: `Android UI Defect Log`
- Android UI gid: `1694271173`
- Primary columns observed:
  - `ID`
  - `Module`
  - `Submodule / Use Case`
  - `Description / Summary`
  - `Type`
  - `Severity`
  - `Priority`
  - `Platform`
  - `QA Status`
  - `Dev Comments`
  - `Dev Status`
  - `QA Comments`
  - `Image`
  - `Exact Evidence / Notes`

## Snapshot Contract

Store tracker exports as:

```text
tmp/android_ui_tracker_snapshot.json
```

Expected shape:

```json
{
  "headers": ["ID", "Module", "..."],
  "records": [
    {
      "rowNumber": 88,
      "id": "PUSH-AUTH-01",
      "module": "Notifications",
      "summary": "NaptiQCare push notification is delivered after the user has logged out.",
      "severity": "Critical",
      "priority": "P0",
      "qaStatus": "Open",
      "image": "https://drive.google.com/...",
      "notes": "..."
    }
  ]
}
```

## Android Readiness Calculation

Use the tracker rows, not local report cards:

```text
android_readiness = closed_rows / all_nonblank_android_tracker_rows * 100
```

Current known example:

```text
20 closed / 87 total = 23.0
67 open
```

If the tracker changes, update the snapshot and let the generator compute from the snapshot.

## Android Backlog Rules

- The implementation backlog must list open tracker rows, not only the old local auth rerun defects.
- Show module summary counts before the detailed open rows.
- Include severity and priority from the tracker.
- Include evidence image links and notes if present.
- Hide cleared items unless the user explicitly asks for completed work.
- Preserve critical examples such as:
  - `PROF-006`
  - `RX-004`
  - `AUTH-022`
  - `RX-005`
  - `AUTH-026`
  - `PUSH-AUTH-01`

## Updating A Tracker Row

When appending a new Android defect:

1. Upload evidence to Drive if the user supplies an image.
2. Set the Drive file permission to reader/anyone if the report should link it.
3. Append to `'Android UI Defect Log'!A:O`.
4. Avoid duplicate IDs.
5. Regenerate `tmp/android_ui_tracker_snapshot.json`.
6. Rebuild the report.

Never print OAuth tokens, API keys, or refresh tokens.
