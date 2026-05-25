---
name: qa-readiness
description: Maintain the NaptiQcare QA readiness reporting pipeline. Use when working on the NaptiQcare QA tracker, Android UI defect log, Postman runner/API backlog, reverse-engineering evidence, HTML readiness reports, generated report package, or Netlify deployment for the NaptiQcare QA report.
---

# QA Readiness

Use this skill to update and verify the NaptiQcare QA readiness package end to end: Google Sheets tracker data, Android UI defects, Postman runner results, reverse-engineering evidence, generated HTML reports, and Netlify deployment.

## Core Rule

Treat the tracker and runner artifacts as source of truth. Do not hand-edit generated HTML unless the generator is broken and the user explicitly asks for a temporary patch.

Primary workspace:

```bash
cd /Users/olaidris/Desktop/Code/NaptiQcare
```

Primary generator:

```bash
node scripts/build_updated_execution_report.js
```

Primary deploy target:

```bash
npx netlify deploy --prod --site f59c47e2-993d-41a3-901f-6bd3909154da --dir test_cases
```

## Workflow

1. **Discover current state**
   - Use `fff` for repository search when available.
   - Check `test_cases/NAPTIQCARE_UPDATED_EXECUTION_REPORT.html`, `test_cases/NAPTIQCARE_IMPLEMENTATION_BACKLOG.html`, and `scripts/build_updated_execution_report.js`.
   - Inspect `test_cases/manifest.json` for generated readiness scores.

2. **Sync tracker evidence**
   - Android UI tracker sheet: Google Sheets document `1wogVCC9U5CuRujXkDc0VnH51S1klyr22skmzpOQP5WI`, tab `Android UI Defect Log`, gid `1694271173`.
   - If using local OAuth, refresh from `tmp/google-oauth-token-drive-upload.json`. Never print tokens or secrets.
   - Save a tracker snapshot to `tmp/android_ui_tracker_snapshot.json`.
   - Analyze it with `scripts/analyze_android_tracker.js` from this skill.
   - Read detailed tracker rules in `references/tracker-and-readiness.md`.

3. **Sync Postman runner evidence**
   - Preferred local runner artifact: `test_cases/api_run_results/postman-cli-latest.json`.
   - Use the runner artifact for the API backlog, because it contains exact failed assertions and request errors.
   - Use monitor summaries only for high-level execution summary when the user specifically wants latest monitor status.
   - Analyze runner failures with `scripts/analyze_postman_runner.js` from this skill.
   - Read exact API backlog rules in `references/postman-and-api-backlog.md`.

4. **Update report generator**
   - Make structural/content changes in `scripts/build_updated_execution_report.js`.
   - Keep generated pages consistent:
     - `NAPTIQCARE_UPDATED_EXECUTION_REPORT.html`
     - `NAPTIQCARE_IMPLEMENTATION_BACKLOG.html`
     - `NAPTIQCARE_API_FAILURE_REPRODUCTION_CATALOGUE.html`
     - `NAPTIQCARE_SECURITY_PROBE.html`
     - `NAPTIQCARE_EDGE_CASE_SCENARIOS.html`
     - `NAPTIQCARE_POSTMAN_ASSERTIONS_CODE_AUDIT.html`
   - Keep all links non-bold unless the user asks otherwise.
   - Keep cleared Android fixes hidden unless the user explicitly requests a cleared/completed section.
   - Read structure rules in `references/report-structure.md`.

5. **Regenerate and verify**
   - Run `node scripts/build_updated_execution_report.js`.
   - Confirm Android readiness equals `closed / total` from the tracker snapshot.
   - Confirm the Android backlog mirrors open tracker rows, not stale local auth-only rows.
   - Confirm the API backlog row count equals failed Postman runner executions.
   - Use `scripts/verify_report_alignment.js` from this skill for the common checks.

6. **Deploy**
   - Deploy to the existing Netlify site, not a new site.
   - Verify production URLs with `curl -Ls`.
   - Report the production URL, unique deploy URL, and important validation findings.
   - Read deployment rules in `references/deployment.md`.

## Non-Negotiables

- Do not expose API keys, OAuth tokens, refresh tokens, passwords, or Postman keys in outputs.
- Do not rely on screenshots alone when tracker/API artifacts exist.
- Do not preserve stale hard-coded readiness numbers. Recompute from current artifacts.
- Do not duplicate API backlog rows when one runner failure row already captures the exact failed execution.
- Do not show cleared Android fixes as active backlog.
- Do not deploy a new Netlify site unless the user explicitly asks for a new site.

## Helper Scripts

From this skill folder:

```bash
node scripts/analyze_android_tracker.js /Users/olaidris/Desktop/Code/NaptiQcare/tmp/android_ui_tracker_snapshot.json
node scripts/analyze_postman_runner.js /Users/olaidris/Desktop/Code/NaptiQcare/test_cases/api_run_results/postman-cli-latest.json
node scripts/verify_report_alignment.js /Users/olaidris/Desktop/Code/NaptiQcare
```

These scripts are read-only. They summarize evidence and fail loudly when report counts drift from source artifacts.
