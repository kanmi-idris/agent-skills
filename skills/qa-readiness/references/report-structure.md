# Report Structure Reference

## Generated Files

The generator writes these files:

```text
test_cases/NAPTIQCARE_UPDATED_EXECUTION_REPORT.html
test_cases/NAPTIQCARE_IMPLEMENTATION_BACKLOG.html
test_cases/NAPTIQCARE_API_FAILURE_REPRODUCTION_CATALOGUE.html
test_cases/NAPTIQCARE_SECURITY_PROBE.html
test_cases/NAPTIQCARE_EDGE_CASE_SCENARIOS.html
test_cases/NAPTIQCARE_POSTMAN_ASSERTIONS_CODE_AUDIT.html
test_cases/manifest.json
```

The generator also updates package copies under:

```text
test_cases/NaptiQCare_QA_Executive_Report_Package_2026-05-23/
```

## Main Report

Main title:

```text
NaptiQcare Android and Backend API Completion Readiness Report
```

Summary copy:

```text
This report details the completion readiness across API execution, Android UI and edge-case tests.
```

Evidence base should point to the QA tracker, not a long local evidence directory.

## Current Page Model

- Main readiness report: executive summary, go-live readiness, tracker table, API summary, linked report pages.
- Implementation backlog: active priority fix list, API backlog from Postman runner, Android UI backlog from tracker.
- API failure catalogue: detailed API reproduction items.
- Security probe: focused upload/security explanation.
- Edge-case scenarios: scenario-to-test mapping.
- Postman assertion audit: explains why each API test case exists for the health app.

## Display Rules Learned From Review

- Do not bold every link.
- Keep cleared Android fixes hidden by default.
- Keep API backlog based on exact runner failures.
- Keep Android backlog based on open tracker rows.
- Keep duplicated API groups out of executive backlog unless the rows reflect different runner executions and failed checks.
- Use the report generator for all persistent changes.

## Layout Origin

The report layout was adapted from the prior Netlify report:

```text
https://naptiqcare-qa-report-2026-05-23.netlify.app/naptiqcare_qa_executive_test_summary_report
```

Preserve the calmer executive report feel: large readiness score, table-of-contents links, separate detail pages, and evidence-backed sections.
