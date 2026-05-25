# Netlify Deployment Reference

## Existing Site

Use the existing Netlify site:

```text
site id: f59c47e2-993d-41a3-901f-6bd3909154da
production: https://naptiqcare-qa-report-2026-05-23.netlify.app
```

Deploy command:

```bash
npx netlify deploy --prod --site f59c47e2-993d-41a3-901f-6bd3909154da --dir test_cases --message "Update NaptiQcare QA readiness report"
```

## Validation After Deploy

Check the live main report:

```bash
curl -Ls https://naptiqcare-qa-report-2026-05-23.netlify.app/naptiqcare_updated_execution_report
```

Check the implementation backlog:

```bash
curl -Ls https://naptiqcare-qa-report-2026-05-23.netlify.app/naptiqcare_implementation_backlog
```

Verify:

- Readiness score appears.
- Android row mentions current open/closed tracker counts.
- Android backlog row count matches open tracker rows.
- API backlog row count matches failed Postman runner executions.
- Links route to extensionless Netlify paths as expected.

## Reporting Back

Return:

- Production URL.
- Unique deploy URL.
- Build logs URL when useful.
- Short validation summary.

Do not create a new Netlify site unless explicitly requested.
