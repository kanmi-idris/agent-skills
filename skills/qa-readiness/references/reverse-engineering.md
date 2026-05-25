# Reverse Engineering Reference

Reverse-engineering artifacts support API coverage and APK/API alignment. They should inform report context, not override tracker or runner evidence.

## Key Paths

```text
reverse_engineering/output/reports/
reverse_engineering/output/indexes/
reverse_engineering/output/postman/
reverse_engineering/output/bundle_strings/
scripts/reverse_engineering/
```

Important generated reports seen in this project:

```text
reverse_engineering/output/reports/11_postman_apk_verification.md
reverse_engineering/output/reports/12_apk_endpoint_delta.md
reverse_engineering/output/indexes/postman_apk_verification.csv
reverse_engineering/output/indexes/apk_endpoint_delta.csv
```

## Usage

- Use reverse-engineering output to explain whether Postman coverage aligns with APK-discovered endpoints.
- Keep reverse-engineering reports linked as supporting context.
- Do not treat APK strings as proof of runtime behavior without API runner or UI tracker evidence.
- Do not regenerate reverse-engineering artifacts unless the user supplies a new APK or asks for APK verification.

## Related Scripts

Common scripts in this repository:

```text
scripts/reverse_engineering/extract_apk_endpoints.js
scripts/reverse_engineering/verify_postman_against_apk.js
scripts/reverse_engineering/build_reports.py
```

When these scripts are run, review generated CSV/MD outputs before updating the readiness report.
